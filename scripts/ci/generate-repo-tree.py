#!/usr/bin/env python3
"""
generate-repo-tree — gerador determinístico da árvore do repositório (adr-115).

Filesystem é source of truth da estrutura. Cada diretório governado carrega um
meta.cue (#DirectoryMeta: canonicalPath + purpose). Este gerador caminha o
filesystem por meta.cue, lê canonicalPath/purpose/rationale, valida:
  - tq-dm-01 (FAIL): canonicalPath == path real do diretório onde o meta.cue
    reside. Divergência bloqueia a regeneração.
  - tq-dm-04 (WARN): purpose não contém substring '.cue' (não enumera arquivos).
E emite governance/readme/tree-generated.cue com:
  - treeAscii: bloco ASCII anotado (├──/└──) com purpose por diretório.
  - treeEntries: lista de #DirectoryNote-compatível (path/purpose/conventions/
    rationale), consumida por governance/readme/config.cue.

Determinístico (P10): saída ordenada, reproduzível; pode ser gate
(derived-artifact-sync). Reusa os helpers de structural-check-runner.py
(load_scope, cue_json) — sem duplicar lógica (mesmo padrão do
generate-structure-index.py, adr-090).

Uso:
  generate-repo-tree.py <repo-root>   # emite a árvore em stdout
  generate-repo-tree.py --self-test   # golden test sintético
"""
import json, os, re, sys, tempfile, importlib.util

_HERE = os.path.dirname(os.path.abspath(__file__))

ROOT_NAME = "mesh-spec"
DEFAULT_RATIONALE = "Diretório governado declarado em meta.cue local (adr-115)."
# Artefato DERIVADO gerado por este pipeline: não tem meta.cue próprio e não
# entra na árvore (análogo ao self-exclude de generate-structure-index.py).
DERIVED_ARTIFACTS = {"governance/readme/tree-generated.cue"}


def _load_runner():
    # Reuso real: importa o avaliador como módulo apesar do nome com hífen.
    path = os.path.join(_HERE, "structural-check-runner.py")
    spec = importlib.util.spec_from_file_location("scr", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


R = _load_runner()


def collect_metas():
    """Caminha scope.validated por meta.cue; lê e valida cada um.

    Retorna (metas, warnings). Levanta SystemExit em FAIL (tq-dm-01 ou meta.cue
    ilegível) — o gerador é gate: estrutura inconsistente não deve gerar árvore."""
    scope, _excluded = R.load_scope()
    metas, warnings, seen = [], [], set()
    for d in scope:
        d = d.rstrip("/")
        if not os.path.isdir(d):
            continue
        for dp, _, fs in os.walk(d):
            if "meta.cue" not in fs:
                continue
            p = os.path.relpath(os.path.join(dp, "meta.cue"), ".")
            obj, e = R.cue_json(["export", p, "-e", "meta", "--out", "json"])
            if e or not isinstance(obj, dict):
                raise SystemExit("erro ao ler %s: %s" % (p, e))
            cp = obj.get("canonicalPath", "")
            purpose = obj.get("purpose", "")
            rationale = obj.get("rationale", "") or DEFAULT_RATIONALE
            real = os.path.relpath(dp, ".")
            # tq-dm-01 (FAIL): path declarado == path real.
            if cp != real:
                raise SystemExit(
                    "tq-dm-01 FAIL: %s canonicalPath=%r != path real %r" % (p, cp, real))
            if cp in seen:
                raise SystemExit("canonicalPath duplicado: %r" % cp)
            seen.add(cp)
            # tq-dm-04 (WARN): purpose não enumera arquivos .cue.
            if ".cue" in purpose:
                warnings.append("tq-dm-04 WARN: %s purpose contém '.cue'" % p)
            metas.append({
                "path":        cp,
                "purpose":     purpose,
                "conventions": [],
                "rationale":   rationale,
            })
    metas.sort(key=lambda m: m["path"])
    return metas, warnings


def render_ascii(metas):
    """Renderiza a árvore ASCII a partir dos paths governados. Diretórios
    intermediários sem meta.cue aparecem como nó estrutural sem comentário."""
    purpose_by_path = {m["path"]: m["purpose"] for m in metas}
    tree = {}
    for m in metas:
        node = tree
        for part in m["path"].split("/"):
            node = node.setdefault(part, {})

    rows = []  # (text_sem_comentario, purpose)

    def walk(node, prefix, parent):
        items = sorted(node.keys())
        for i, name in enumerate(items):
            last = i == len(items) - 1
            connector = "└── " if last else "├── "
            full = (parent + "/" + name) if parent else name
            rows.append((prefix + connector + name + "/", purpose_by_path.get(full, "")))
            walk(node[name], prefix + ("    " if last else "│   "), full)

    walk(tree, "", "")

    root_line = ROOT_NAME + "/"
    width = max([len(root_line)] + [len(t) for t, _ in rows]) if rows else len(root_line)
    out = [root_line]
    for text, purpose in rows:
        out.append(text.ljust(width + 1) + "# " + purpose if purpose else text)
    return "\n".join(out)


def emit(metas, ascii_tree):
    # treeAscii como string multiline CUE: cada linha prefixada por \t (a
    # indentação de fechamento define o strip); o conteúdo usa só espaços.
    ascii_block = "\n".join("\t" + l for l in ascii_tree.split("\n"))
    entries = json.dumps(metas, indent="\t", ensure_ascii=False, sort_keys=True)
    return (
        "package readme\n\n"
        "// tree-generated.cue — DERIVADO. Gerado por scripts/ci/generate-repo-tree.py\n"
        "// a partir dos meta.cue (#DirectoryMeta) por diretório + scan do filesystem.\n"
        "// NÃO editar à mão; regenerar via 'make sync-readme' (ou o gerador direto). (adr-115)\n"
        "//\n"
        "// treeAscii vive fora de config.tree porque #ReadmeConfig não declara campo\n"
        "// 'ascii'; treeEntries alimenta config.tree.entries (#DirectoryNote).\n\n"
        'treeAscii: """\n' + ascii_block + '\n\t"""\n\n'
        "treeEntries: " + entries + "\n")


def generate(root):
    os.chdir(root)
    if hasattr(R, "_loc_cache"):
        R._loc_cache.clear()
    metas, warnings = collect_metas()
    for w in warnings:
        sys.stderr.write(w + "\n")
    return emit(metas, render_ascii(metas))


def self_test():
    d = tempfile.mkdtemp()

    def w(p, s):
        fp = os.path.join(d, p)
        os.makedirs(os.path.dirname(fp), exist_ok=True)
        open(fp, "w").write(s)

    # Scope mínimo.
    w("governance/repo-structure.cue",
      'package x\nrepoStructure:scope:{validated:["architecture/","governance/"],'
      'excluded:["cue.mod/",".git/",".github/","scripts/"]}\n')
    # meta.cue sintéticos (schema-less: o gerador só lê o valor concreto `meta`).
    # Dois níveis em architecture/ + um em governance/. purposes >= 20 runes.
    w("architecture/meta.cue",
      'package x\nmeta:{canonicalPath:"architecture",purpose:"Camada transversal de'
      ' governanca tecnica do repositorio (sintetico de teste)."}\n')
    w("architecture/adrs/meta.cue",
      'package x\nmeta:{canonicalPath:"architecture/adrs",purpose:"Architecture'
      ' Decision Records numerados do sistema (sintetico de teste).",'
      'rationale:"Diretorio proprio para decisoes cross-cutting (teste)."}\n')
    w("governance/meta.cue",
      'package x\nmeta:{canonicalPath:"governance",purpose:"Camada operacional de'
      ' governanca do repositorio (sintetico de teste)."}\n')
    # Artefato derivado já presente: NÃO deve quebrar (não tem meta.cue).
    w("governance/readme/tree-generated.cue", "package readme\ntreeEntries: []\n")

    out = generate(d)

    # Round-trip: o CUE emitido re-exporta treeEntries idêntico e treeAscii é string.
    sf = os.path.join(d, "tree-generated.cue")
    open(sf, "w").write(out)
    entries, e1 = R.cue_json(["export", sf, "-e", "treeEntries", "--out", "json"])
    ascii_rt, e2 = R.cue_json(["export", sf, "-e", "treeAscii", "--out", "json"])

    paths = [m["path"] for m in entries] if isinstance(entries, list) else None
    adrs = next((m for m in (entries or []) if m["path"] == "architecture/adrs"), None)
    arch = next((m for m in (entries or []) if m["path"] == "architecture"), None)

    ok = (
        e1 is None and e2 is None
        and paths == ["architecture", "architecture/adrs", "governance"]
        # rationale default preenchido quando ausente; explícito preservado.
        and arch and arch["rationale"] == DEFAULT_RATIONALE and arch["conventions"] == []
        and adrs and adrs["rationale"] == "Diretorio proprio para decisoes cross-cutting (teste)."
        # ASCII: raiz + indentação de filho.
        and isinstance(ascii_rt, str)
        and ascii_rt.startswith("mesh-spec/\n")
        and "├── architecture/" in ascii_rt
        and "│   └── adrs/" in ascii_rt
        and "└── governance/" in ascii_rt
        and out.startswith("package readme\n")
    )
    print("SELF-TEST:", "PASS" if ok else "FAIL (e1=%s e2=%s)" % (e1, e2))
    if not ok:
        sys.stderr.write(out + "\n")
        sys.stderr.write(json.dumps(entries, indent=2, ensure_ascii=False) + "\n")
    return 0 if ok else 1


if __name__ == "__main__":
    if "--self-test" in sys.argv:
        sys.exit(self_test())
    if len(sys.argv) < 2:
        sys.exit("uso: generate-repo-tree.py <repo-root> | --self-test")
    sys.stdout.write(generate(sys.argv[1]))
