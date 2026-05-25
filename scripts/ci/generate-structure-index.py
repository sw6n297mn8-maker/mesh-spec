#!/usr/bin/env python3
"""
generate-structure-index — gerador determinístico do índice estrutural derivado (adr-090).

DERIVAÇÃO (adr-090 componentes 1/2/3/4/6): a estrutura schema-governada do repo
é DERIVADA de cada _schema.location + scan do filesystem — não autorada. Este
gerador emite governance/readme/structure-index.cue em stdout. Determinístico
(P10): saída ordenada, reproduzível; pode ser gate (derived-artifact-sync).

  - Diff assimétrico por cardinalidade (componente 2):
      singleton  -> path literal -> checa presença (revela ausentes)
      collection -> classificação + órfãos
  - Exclusive-match (componente 3): arquivo casando >=2 schemas -> ambíguo.
  - Ausentes sem veredito (componente 4): missingSingletons anota status do
    wave-plan (agendado WI-xxx / nao-contabilizado / status-desconhecido),
    leitura DEGRADÁVEL — wave-plan inválido/ausente nunca falha o gerador.
  - Sem lógica nova (componente 6): reusa o algoritmo fileClassification já
    implementado em structural-check-runner.py (helpers importados).

Uso:
  generate-structure-index.py <repo-root>   # emite o índice em stdout
  generate-structure-index.py --self-test    # golden test sintético
"""
import json, os, re, sys, glob, importlib.util, tempfile

_HERE = os.path.dirname(os.path.abspath(__file__))


def _load_runner():
    # Reuso real (componente 6): importa o avaliador como módulo apesar do
    # nome com hífen (não-importável por `import` direto).
    path = os.path.join(_HERE, "structural-check-runner.py")
    spec = importlib.util.spec_from_file_location("scr", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


R = _load_runner()


# Artefatos DERIVADOS gerados por este pipeline: nao se auto-classificam. Sem
# isto, commitar o proprio structure-index.cue o tornaria um orfao #21 na
# regeneracao seguinte (auto-referencia), quebrando o derived-artifact-sync.
# Analogo a README.md/CLAUDE.md ja estarem em scope.excluded.
DERIVED_ARTIFACTS = {"governance/readme/structure-index.cue"}


def all_locations_full():
    # Fonte UNICA: reusa o extrator do runner (fast path cue eval + fallback
    # textual p/ defs nao-concretos como #Subdomain). Sem duplicar a logica.
    return R.all_locations_full()


def classify(locs, scope, excluded):
    """Anda a árvore validada e classifica cada .cue (exclusive-match). Mesma
    lógica de R.file_classification, mas também emite o bucket `matched`
    (schema -> [paths])."""
    matched = {}      # defName -> [paths]
    ambiguous = []    # (path, [defNames])
    unmatched = []    # paths sem schema
    for d in scope:
        d = d.rstrip("/")
        if not os.path.isdir(d):
            continue
        for dp, _, fs in os.walk(d):
            for f in fs:
                if not f.endswith(".cue"):
                    continue
                p = os.path.relpath(os.path.join(dp, f), ".")
                if p in DERIVED_ARTIFACTS:
                    continue
                if any(p.startswith(e.rstrip("/")) for e in excluded):
                    continue
                if any(p.startswith(g) for g in R.GOVERNED_ELSEWHERE):
                    continue
                ms = [dn for dn, rx, _ in locs if re.match(rx, p)]
                if len(ms) == 0:
                    unmatched.append(p)
                elif len(ms) == 1:
                    matched.setdefault(ms[0], []).append(p)
                else:
                    ambiguous.append((p, sorted(ms)))
    return matched, sorted(ambiguous), sorted(unmatched)


_wp_cache = {}


def wave_plan_create_paths():
    """Mapa path-criado -> WI id, lido do wave-plan. DEGRADÁVEL: qualquer falha
    retorna {} (annotation vira 'status-desconhecido'). Nunca levanta."""
    if "v" in _wp_cache:
        return _wp_cache["v"]
    res = {}
    try:
        cands = sorted(glob.glob("governance/**/wave-plan.cue", recursive=True))
        for c in cands:
            d, e = R.cue_json(["export", c, "--out", "json"])
            if e or not isinstance(d, dict):
                continue
            stack = list(d.values())
            while stack:
                cur = stack.pop()
                if isinstance(cur, dict):
                    out = cur.get("outputs")
                    wid = cur.get("id") or cur.get("workItemId")
                    if isinstance(out, list) and isinstance(wid, str):
                        for o in out:
                            if isinstance(o, dict) and o.get("type") == "create" and isinstance(o.get("path"), str):
                                res.setdefault(o["path"], wid)
                    stack.extend(cur.values())
                elif isinstance(cur, list):
                    stack.extend(cur)
    except Exception:
        res = {}
    _wp_cache["v"] = res
    return res


def annotate(path, loaded_ok, create_map):
    if not loaded_ok:
        return "status-desconhecido"
    if path in create_map:
        return "agendado " + create_map[path]
    return "nao-contabilizado"


# Anti-phantom (adr-090 componente 7): paths .cue CONCRETOS referenciados no
# config autoral que NÃO resolvem (nem existem no disco, nem plannedIn no
# wave-plan). Warn-first: surface como backlog no índice, não bloqueia.
_PHANTOM_SCAN_FILES = ["governance/readme/config.cue"]
_CONCRETE_PATH_RE = re.compile(
    r'(?:domain|strategic|contexts|architecture|governance|ai-orchestration)/[A-Za-z0-9._/-]+\.cue')


def phantom_candidates(create_map):
    # Extração determinística: só paths concretos sob raiz real, sem {}/*/[]
    # (o char-class já exclui placeholders/regex) e sem bare-name (exige raiz/).
    # Resolve = existe no disco OU plannedIn (create_map). Demais = candidato.
    refs = set()
    for f in _PHANTOM_SCAN_FILES:
        try:
            refs.update(_CONCRETE_PATH_RE.findall(open(f).read()))
        except OSError:
            continue
    return sorted(p for p in refs if not os.path.isfile(p) and p not in create_map)


def build_index():
    locs = all_locations_full()
    scope, excluded = R.load_scope()
    matched, ambiguous, unmatched = classify(locs, scope, excluded)

    singletons = []
    missing = []
    create_map = wave_plan_create_paths()
    loaded_ok = bool(create_map) or bool(sorted(glob.glob("governance/**/wave-plan.cue", recursive=True)))
    for dn, rx, card in locs:
        if card != "singleton":
            continue
        lp = R.literal_path(rx)
        present = bool(lp) and os.path.isfile(lp)
        singletons.append({"schema": dn, "canonicalPath": lp if lp else rx, "present": present})
        if not present:
            missing.append({"schema": dn, "canonicalPath": lp if lp else rx,
                            "wavePlanStatus": annotate(lp if lp else rx, loaded_ok, create_map)})

    collections = []
    for dn, rx, card in locs:
        if card != "collection":
            continue
        collections.append({"schema": dn, "canonicalPathRegex": rx,
                            "files": sorted(matched.get(dn, []))})

    return {
        "generator": "scripts/ci/generate-structure-index.py",
        "source": "_schema.location (artifact-schemas + build-time) + filesystem scan (scope.validated)",
        "singletons": sorted(singletons, key=lambda s: s["canonicalPath"]),
        "collections": sorted(collections, key=lambda c: c["schema"]),
        "ambiguous": [{"path": p, "schemas": ms} for p, ms in ambiguous],
        "unmatched": unmatched,
        "missingSingletons": sorted(missing, key=lambda m: m["canonicalPath"]),
        "phantomCandidates": phantom_candidates(create_map),
    }


def emit(index):
    # JSON é CUE válido para valores; escapes de backslash (\\.) sobrevivem.
    # Saída crua, comparada byte-a-byte por derived-artifact-sync (NÃO cue-fmt).
    body = json.dumps(index, indent="\t", ensure_ascii=False, sort_keys=True)
    return ("package readme\n\n"
            "// structure-index.cue — DERIVADO. Gerado por "
            "scripts/ci/generate-structure-index.py a partir de _schema.location\n"
            "// (artifact-schemas + build-time) + scan do filesystem. NÃO editar à "
            "mão; regenerar. (adr-090)\n\n"
            "structureIndex: " + body + "\n")


def generate(root):
    os.chdir(root)
    R._loc_cache.clear()
    return emit(build_index())


def self_test():
    d = tempfile.mkdtemp()

    def w(p, s):
        fp = os.path.join(d, p)
        os.makedirs(os.path.dirname(fp), exist_ok=True)
        open(fp, "w").write(s)

    # Dois singletons (um presente, um AUSENTE) + uma collection + um ambíguo.
    w("architecture/artifact-schemas/alpha.cue",
      'package artifact_schemas\n#Alpha:{_schema:location:{canonicalPathRegex:"^architecture/alpha\\\\.cue$",fileNameRegex:"^alpha\\\\.cue$",cardinality:"singleton"}}\n')
    w("architecture/artifact-schemas/beta.cue",
      'package artifact_schemas\n#Beta:{_schema:location:{canonicalPathRegex:"^architecture/beta\\\\.cue$",fileNameRegex:"^beta\\\\.cue$",cardinality:"singleton"}}\n')
    w("architecture/artifact-schemas/note.cue",
      'package artifact_schemas\n#Note:{_schema:location:{canonicalPathRegex:"^architecture/notes/[a-z]+\\\\.cue$",fileNameRegex:"^[a-z]+\\\\.cue$",cardinality:"collection"}}\n')
    # alpha presente; beta AUSENTE (e agendado no wave-plan sintético).
    w("architecture/alpha.cue", "package x\n")
    w("architecture/notes/foo.cue", "package x\n")
    w("architecture/notes/bar.cue", "package x\n")
    # scope mínimo
    w("governance/repo-structure.cue",
      'package x\nrepoStructure:scope:{validated:["architecture/","governance/"],excluded:["cue.mod/",".git/",".github/","scripts/"]}\n')
    # wave-plan sintético: cria architecture/beta.cue no WI-007
    w("governance/wave-plan.cue",
      'package x\nwavePlan:workItems:[{id:"WI-007",outputs:[{type:"create",path:"architecture/beta.cue"}]}]\n')
    # self-exclusion: o proprio indice derivado existe na arvore e NAO pode
    # aparecer como orfao (senao auto-referencia quebra o sync byte-a-byte).
    w("governance/readme/structure-index.cue", "package readme\nstructureIndex: {}\n")
    # anti-phantom: config com 1 ref que resolve (alpha existe), 1 plannedIn
    # (beta no WI-007), 1 phantom (ghost), 1 template e 1 bare (ignorados).
    w("governance/readme/config.cue",
      'package readme\nconfig: x: "ver architecture/alpha.cue, architecture/beta.cue, architecture/ghost.cue; template contexts/{bc}/x.cue; bare foo.cue"\n')

    out = generate(d)
    idx = json.loads(out[out.index("{"):])

    # Round-trip forte: o CUE emitido deve ser válido e re-exportar idêntico
    # (prova que o escaping do regex sobrevive a `cue`, não só ao json.loads).
    sf = os.path.join(d, "structure-index.cue")
    open(sf, "w").write(out)
    rt, e = R.cue_json(["export", sf, "-e", "structureIndex", "--out", "json"])
    round_trip = (e is None) and (rt == idx)

    paths = [s["canonicalPath"] for s in idx["singletons"]]
    beta = next((s for s in idx["singletons"] if s["canonicalPath"] == "architecture/beta.cue"), None)
    alpha = next((s for s in idx["singletons"] if s["canonicalPath"] == "architecture/alpha.cue"), None)
    note = next((c for c in idx["collections"] if c["schema"] == "#Note"), None)
    miss = idx["missingSingletons"]

    ok = (
        paths == ["architecture/alpha.cue", "architecture/beta.cue"]
        and alpha and alpha["present"] is True
        and beta and beta["present"] is False
        and note and note["files"] == ["architecture/notes/bar.cue", "architecture/notes/foo.cue"]
        and note["canonicalPathRegex"] == r"^architecture/notes/[a-z]+\.cue$"
        and idx["ambiguous"] == []
        and len(miss) == 1 and miss[0]["canonicalPath"] == "architecture/beta.cue"
        and miss[0]["wavePlanStatus"] == "agendado WI-007"
        and "governance/readme/structure-index.cue" not in idx["unmatched"]
        and idx["phantomCandidates"] == ["architecture/ghost.cue"]
        and out.startswith("package readme\n")
        and round_trip
    )
    print("SELF-TEST:", "PASS" if ok else "FAIL  (round_trip=%s err=%s)" % (round_trip, e))
    if not ok:
        print(json.dumps(idx, indent=2, ensure_ascii=False))
    return 0 if ok else 1


if __name__ == "__main__":
    if "--self-test" in sys.argv:
        sys.exit(self_test())
    if len(sys.argv) < 2:
        sys.exit("uso: generate-structure-index.py <repo-root> | --self-test")
    sys.stdout.write(generate(sys.argv[1]))
