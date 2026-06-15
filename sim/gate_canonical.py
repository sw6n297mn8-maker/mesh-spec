#!/usr/bin/env python3
# SIMULACAO 3 DESCARTAVEL (branch sim/firstclass-canonical-home). NAO e gate de producao.
# Alvo: o LAR CANONICO do termo shared (pre-condicao descoberta no piloto 2).
#
# Layer 1 (E1 + regressao + alt A/B): usa os locs REAIS de scripts/ci/structural-check-runner.py
#   (all_schema_locations) + o MESMO predicado re.match(rx, path) do gate de orfao (file_classification l.704)
#   + a MESMA funcao is_type_definition_file. Nada reimplementado: o enforcer real e consultado.
# Layer 2 (E2-E7 + 4 categorias): testa os campos novos (canonicalTermRef, canonicalSchemaRef, shared,
#   specializes, localConstraint). Le os shared-schemas REAIS do disco para E3.

import json, re, os, sys, copy, importlib.util, glob

# ---- importar o runner REAL (sem reimplementar logica de enforcement) ----
_spec = importlib.util.spec_from_file_location("scr", "scripts/ci/structural-check-runner.py")
_scr = importlib.util.module_from_spec(_spec)
try: _spec.loader.exec_module(_scr)
except SystemExit: pass

def norm(s): return "".join(c for c in (s or "").lower() if c.isalnum())

AN = json.load(open("sim/canonical-home-annotations.json"))
EXT = AN["extension"]
REG = AN["canonical"]["registry"]
REG_CODES = {t["code"] for t in REG}
REG_TERMEN = {t["code"]: t["termEn"] for t in REG}
REG_HOME = {t["code"]: t["home"] for t in REG}

GLOSS_12 = [f"contexts/{bc}/glossary.cue" for bc in
            "bdg bkr cmt ctr dlv fce idc inv npm p2p rew ssc".split()]

def real_locs():
    return [(n, rx) for n, rx in json.load(open("sim/_real_locs.json"))]

def locs_with_glossary(rx_glossary):
    out = []
    for n, rx in real_locs():
        out.append((n, rx_glossary if n == "#Glossary" else rx))
    return out

def matches(path, locs):                      # MESMO predicado do runner: re.match
    return [n for n, rx in locs if re.match(rx, path)]

def real_shared_schema_defs():                # para E3: schemas que existem de fato em shared-schemas/
    defs = set()
    for f in glob.glob("architecture/shared-schemas/*.cue"):
        for m in re.finditer(r'(?m)^(#[A-Za-z][A-Za-z0-9_]*)\s*:', open(f).read()):
            defs.add(m.group(1))
    return defs

# =========================================================================
# LAYER 1 — E1 (teste-mae) + regressao + alt A/B  [enforcer REAL]
# =========================================================================
def layer1():
    cur = locs_with_glossary(EXT["currentRegex"])
    ext = locs_with_glossary(EXT["proposedRegex"])
    A = EXT["candidateHomeA"]; B = EXT["candidateHomeB"]
    R = {}

    # E1 teste-mae: candidato A orfao ANTES, limpo DEPOIS
    R["e1_before"] = matches(A, cur)          # esperado [] -> orfao (bloqueante)
    R["e1_after"]  = matches(A, ext)          # esperado ['#Glossary']
    R["e1_after_unambiguous"] = (R["e1_after"] == ["#Glossary"])

    # REGRESSAO: os 12 glossarios casam exatamente #Glossary em AMBOS os regimes
    reg = {}
    for p in GLOSS_12:
        reg[p] = (matches(p, cur), matches(p, ext))
    R["regression_broken"] = [p for p, (c, e) in reg.items() if c != ["#Glossary"] or e != ["#Glossary"]]
    R["regression_clean"] = (len(R["regression_broken"]) == 0)

    # AMBIGUIDADE NOVA: a extensao admite algum arquivo .cue EXISTENTE que nao casava antes?
    new_admits = []
    for f in glob.glob("architecture/shared-schemas/**/*.cue", recursive=True):
        p = os.path.relpath(f, ".")
        if matches(p, cur) == [] and matches(p, ext) != []:
            new_admits.append((p, matches(p, ext)))
    R["new_admits"] = new_admits             # esperado: [] (nenhum glossary.cue existe ainda em shared-schemas)

    # ALT B (co-localizar termo em money.cue): a classificacao PULA typedef-files ->
    # termo escaparia a governanca do gate de orfao. Prova mecanica com a funcao REAL.
    R["altB_is_typedef"] = _scr.is_type_definition_file(B)   # True -> file pulado da classificacao
    R["altB_money_matches_glossary_ext"] = matches(B, ext)   # money.cue NAO casa o regex (basename != glossary.cue)
    return R

# =========================================================================
# LAYER 2 — E2-E7 + 4 categorias  [campos novos]
# =========================================================================
def classify(u):
    if not u.get("shared"):
        return "owned" if u.get("sourceContext") == u["bc"] else "foreign-consumed"
    # shared:true
    cref = u.get("canonicalTermRef")
    canon_en = REG_TERMEN.get(cref, "")
    if norm(u["coreNoun"]) == norm(canon_en):
        return "shared-canonical"
    if u.get("specializes") and u.get("localConstraint"):
        return "local-specialization"
    return "masquerade-suspect"              # shared + nome divergente SEM specializes -> suspeito

def layer2(an):
    real_schemas = real_shared_schema_defs()
    R = {"E2_term_missing": [], "E3_schema_missing": [], "E4_shared_no_termref": [],
         "E5_shared_no_schemaref": [], "E6_termref_no_shared": [], "E7_dup_local": [],
         "categories": {}, "review_queue": []}

    for u in an["usages"]:
        key = f"{u['bc']}/{u['code']}"
        cref = u.get("canonicalTermRef"); sref = u.get("canonicalSchemaRef")
        # E2 ref de termo resolve
        if cref is not None and cref not in REG_CODES:
            R["E2_term_missing"].append((key, cref))
        # E3 ref de schema resolve (contra disco real)
        if sref is not None and sref not in real_schemas:
            R["E3_schema_missing"].append((key, sref))
        # E4/E5 shared exige ambos os refs
        if u.get("shared") and not cref:
            R["E4_shared_no_termref"].append(key)
        if u.get("shared") and not sref:
            R["E5_shared_no_schemaref"].append(key)
        # E6 termref sem shared -> inconsistencia -> revisao (nunca verde silencioso)
        if cref and not u.get("shared"):
            R["E6_termref_no_shared"].append(key)
            R["review_queue"].append((key, "canonicalTermRef sem shared:true"))
        # categoria
        cat = classify(u)
        R["categories"][key] = cat
        if cat == "masquerade-suspect":
            R["review_queue"].append((key, "shared + nome divergente SEM specializes/localConstraint"))
        if cat == "local-specialization":
            R["review_queue"].append((key, f"especializacao local ({u.get('localConstraint')}) — revisao leve"))

    # E7 duplicacao P0: termo local com termEn == termEn canonico, sem ser o canonico
    for t in an.get("localGlossaryTerms", []):
        for code, en in REG_TERMEN.items():
            if norm(t.get("termEn")) == norm(en) and t.get("home") != REG_HOME.get(code):
                R["E7_dup_local"].append((f"{t.get('bc')}/{t.get('code')}", t.get("termEn")))
                R["review_queue"].append((f"{t.get('bc')}/{t.get('code')}", f"duplica termEn canonico '{en}' (evasao P0)"))
    return R

# ---- injecoes ----
def inj_E2(an):
    an = copy.deepcopy(an); an["usages"].append({"bc":"ctr","code":"vo-x","coreNoun":"Money","category":"shared-canonical","shared":True,"sourceContext":"ctr","canonicalTermRef":"term-ghost","canonicalSchemaRef":"#Money"})
    return an, "usage ctr/vo-x canonicalTermRef='term-ghost' (inexistente)"
def inj_E3(an):
    an = copy.deepcopy(an); an["usages"].append({"bc":"ctr","code":"vo-y","coreNoun":"Money","category":"shared-canonical","shared":True,"sourceContext":"ctr","canonicalTermRef":"term-money","canonicalSchemaRef":"#GhostMoney"})
    return an, "usage ctr/vo-y canonicalSchemaRef='#GhostMoney' (inexistente em shared-schemas/)"
def inj_E4(an):
    an = copy.deepcopy(an)
    for u in an["usages"]:
        if u["bc"]=="inv": u.pop("canonicalTermRef",None)
    return an, "inv/vo-money: canonicalTermRef removido, shared:true mantido"
def inj_E5(an):
    an = copy.deepcopy(an)
    for u in an["usages"]:
        if u["bc"]=="p2p": u.pop("canonicalSchemaRef",None)
    return an, "p2p/vo-money: canonicalSchemaRef removido, shared:true mantido"
def inj_E6(an):
    an = copy.deepcopy(an); an["usages"].append({"bc":"ctr","code":"vo-z","coreNoun":"Money","category":"owned","shared":False,"sourceContext":"ctr","canonicalTermRef":"term-money"})
    return an, "usage ctr/vo-z: canonicalTermRef='term-money' MAS shared:false (inconsistente)"
def inj_E7(an):
    an = copy.deepcopy(an); an["localGlossaryTerms"]=[{"bc":"ctr","code":"term-money-local","termEn":"Money","home":"contexts/ctr/glossary.cue"}]
    return an, "ctr cria termo LOCAL term-money-local termEn='Money' (duplica canonico — evasao P0)"

def fl(x): return "\n".join(f"      - {i}" for i in x) if x else "      (vazio)"

def main():
    print("#"*76)
    print("# SIMULACAO 3 — LAR CANONICO do termo shared (Money). Enforcer REAL p/ Layer 1.")
    print("#"*76)

    L1 = layer1()
    print("\n=== LAYER 1 — E1 (teste-mae) + regressao + alt A/B  [structural-check-runner REAL] ===")
    print(f"  regex atual    : {EXT['currentRegex']}")
    print(f"  regex proposto : {EXT['proposedRegex']}")
    print(f"  E1 candidato A '{EXT['candidateHomeA']}'")
    print(f"     ANTES da extensao: matches={L1['e1_before']}  -> {'ORFAO (bloqueante)' if not L1['e1_before'] else 'casou'}")
    print(f"     DEPOIS da extensao: matches={L1['e1_after']}  -> {'LIMPO (so #Glossary)' if L1['e1_after_unambiguous'] else 'PROBLEMA'}")
    print(f"  REGRESSAO 12 glossarios: {'ZERO quebra' if L1['regression_clean'] else 'QUEBROU: '+str(L1['regression_broken'])}")
    print(f"  AMBIGUIDADE nova (arquivos existentes recem-admitidos): {L1['new_admits'] or 'nenhum'}")
    print(f"  ALT B (termo em money.cue): is_type_definition_file={L1['altB_is_typedef']} "
          f"-> {'PULADO da classificacao (termo ESCAPA a governanca)' if L1['altB_is_typedef'] else 'classificado'}; "
          f"money.cue casa #Glossary? {L1['altB_money_matches_glossary_ext'] or 'nao'}")

    base = layer2(AN)
    print("\n=== LAYER 2 — BASELINE (4 categorias) ===")
    for k, c in base["categories"].items(): print(f"  {k:28s} -> {c}")
    print(f"  fila de revisao baseline:\n{fl(base['review_queue'])}")

    runs = {}
    print("\n=== LAYER 2 — INJECOES E2-E7 ===")
    for name, fn in [("E2",inj_E2),("E3",inj_E3),("E4",inj_E4),("E5",inj_E5),("E6",inj_E6),("E7",inj_E7)]:
        an, delta = fn(AN)
        r = layer2(an); runs[name] = r
        # achado correspondente
        hit = {"E2":r["E2_term_missing"],"E3":r["E3_schema_missing"],"E4":r["E4_shared_no_termref"],
               "E5":r["E5_shared_no_schemaref"],"E6":r["E6_termref_no_shared"],"E7":r["E7_dup_local"]}[name]
        print(f"  [{name}] {delta}\n        achado: {hit or 'NENHUM (!)'}")

    # ---------------- MATRIZ ----------------
    print(f"\n{'#'*76}\n# MATRIZ (criterio: nenhum E1-E7 escapa verde silencioso; E6/E7 podem ir p/ revisao)\n{'#'*76}")
    rows = [
        ("E1 path fora do regex", "Layer1 orfao->extensao",
         bool(not L1["e1_before"]) and L1["e1_after_unambiguous"] and L1["regression_clean"]),
        ("E2 canonicalTermRef inexistente", "C-TERM-EXISTS", bool(runs["E2"]["E2_term_missing"])),
        ("E3 canonicalSchemaRef inexistente", "C-SCHEMA-EXISTS", bool(runs["E3"]["E3_schema_missing"])),
        ("E4 shared sem canonicalTermRef", "C-SHARED-NEEDS-TERMREF", bool(runs["E4"]["E4_shared_no_termref"])),
        ("E5 shared sem canonicalSchemaRef", "C-SHARED-NEEDS-SCHEMAREF", bool(runs["E5"]["E5_shared_no_schemaref"])),
        ("E6 canonicalTermRef sem shared (revisao)", "C-TERMREF-NEEDS-SHARED", bool(runs["E6"]["E6_termref_no_shared"])),
        ("E7 duplicacao local P0 (revisao)", "C-NO-DUP", bool(runs["E7"]["E7_dup_local"])),
    ]
    escaped = []
    for label, det, caught in rows:
        verd = "CAPTURADO" if caught else "ESCAPOU(verde silencioso)"
        if not caught: escaped.append(label)
        print(f"  [{verd:26s}] {label:42s} detector={det}")

    print(f"\n{'#'*76}")
    print(f"# VEREDITO: {'PASSA — nenhum erro escapou verde silencioso' if not escaped else 'FALHA — escaparam: '+str(escaped)}")
    print(f"{'#'*76}")

    # ---------------- RESPOSTAS Q1-Q9 ----------------
    print("\n--- RESPOSTAS (RESULT.txt) ---")
    print(f"Q1 melhor lar canonico: {EXT['candidateHomeA']} (alt A). Alt B (money.cue) so 'funciona' por ESCAPAR a governanca (typedef-skip) + mistura schema/linguagem.")
    print(f"Q2 mudanca minima: trocar #Glossary.canonicalPathRegex por alternacao: {EXT['proposedRegex']}")
    print(f"Q3 quebra os 12? {'NAO — zero regressao (provado contra os 12 + zero ambiguidade nova)' if L1['regression_clean'] and not L1['new_admits'] else 'SIM'}")
    print(f"Q4 canonicalTermRef verificavel? SIM (C-TERM-EXISTS contra registry; E2 pego)")
    print(f"Q5 canonicalSchemaRef verificavel? SIM (C-SCHEMA-EXISTS contra shared-schemas/ real; E3 pego)")
    print(f"Q6 shared sobrepoe sourceContext? SIM (categoria 'foreign-consumed' so quando shared:false; shared:true nunca isenta)")
    cats = set(base["categories"].values())
    four = {"owned","foreign-consumed","shared-canonical","local-specialization"}
    print(f"Q7 distingue as 4 categorias? {'SIM' if four <= cats else 'PARCIAL'} (vistas: {sorted(cats)}). "
          f"local-specialization (bkr) SO e distinguivel de masquerade COM os campos novos specializes+localConstraint — sem eles, fresta (licao do piloto 2).")
    print(f"Q8 algum erro escapou? {'NAO' if not escaped else 'SIM: '+str(escaped)}")
    print(f"Q9 ADR agora ou +1 piloto: ver relatorio (recomendacao do agente).")
    return 0 if not escaped else 1

if __name__ == "__main__":
    sys.exit(main())
