#!/usr/bin/env python3
# SIMULACAO DESCARTAVEL (branch sim/firstclass-fce). NAO e gate de producao.
# Prova de desenho: firstClass + rastreabilidade glossario<->modelo contra o FCE em disco.
# Le: sim/glossary.json, sim/domainmodel.json, sim/annotations.json (todos exportados/derivados do real).
# Determinístico: igualdade de string normalizada + pertinência de conjunto. Zero LLM, zero heurística.
#
# Gates:
#   G1 COBERTURA-DEDICADA   : todo conceito OWNED firstClass:true precisa de termo cujo termEn==coreNoun E que o referencie.
#   G2 CLASSIFICACAO-FORCADA: todo conceito do modelo (agg/evt/cmd/vo) precisa de anotação com firstClass+reason.
#   G3 REF-EXISTE+CORRESPOND: (3a) todo domainModelRef resolve; (3b) termo que NOMEIA um coreNoun precisa referenciá-lo.
#   G4 CONSISTENCIA BIDIR.  : nenhum termo pode referenciar conceito anotado firstClass:false.
#   G5 RAZAO-TIPADA         : firstClass:true=>reason in positiveReasons; false=>reason in negativeReasons.
#   FILA DE REVISAO         : conceitos firstClass:false E crossesContract:true (suspeita p/ olho humano).

import json
import sys
import copy

def norm(s):
    # normalizacao canonica: minuscula, sem espaço/hífen. EXATA (nao substring) — e isso que derrota o grazing.
    return "".join(c for c in s.lower() if c.isalnum())

def load():
    gl = json.load(open("sim/glossary.json"))
    dm = json.load(open("sim/domainmodel.json"))
    an = json.load(open("sim/annotations.json"))
    return gl, dm, an

def concept_index(dm):
    # codigo -> (kind, owner). owner = sourceContext do conceito (ausente => owned por este BC = fce).
    idx = {}
    for a in dm.get("aggregates", []):  idx[a["code"]] = ("aggregate",    a.get("sourceContext"))
    for e in dm.get("events", []):      idx[e["code"]] = ("event",        e.get("sourceContext"))
    for c in dm.get("commands", []):    idx[c["code"]] = ("command",      c.get("sourceContext"))
    for v in dm.get("valueObjects", []):idx[v["code"]] = ("value-object", v.get("sourceContext"))
    for i in dm.get("invariants", []):  idx[i["code"]] = ("invariant",    i.get("sourceContext"))
    return idx

def run_gates(gl, dm, an, home_bc="fce"):
    idx   = concept_index(dm)
    valid = set(idx)                                  # todos os codigos que existem no modelo (inclui invariantes)
    ann   = {c["code"]: c for c in an["concepts"]}    # codigo -> anotacao
    pos   = set(an["positiveReasons"])
    neg   = set(an["negativeReasons"])
    terms = gl["terms"]

    # conjunto de conceitos do modelo que SAO candidatos a firstClass (regras/invariantes ficam de fora — sao alvos, nao sujeitos)
    model_concepts = [code for code, (kind, _) in idx.items() if kind != "invariant"]

    R = {"G1": {"gaps": [], "foreign_exempt": [], "covered": []},
         "G2": {"unclassified": []},
         "G3": {"dangling_ref": [], "correspondence_fail": []},
         "G4": {"contradiction": []},
         "G5": {"mistyped": []},
         "QUEUE": []}

    # --- G1: cobertura dedicada (concept -> term) ---
    for code in model_concepts:
        a = ann.get(code)
        if not a or not a.get("firstClass"):
            continue                                   # so firstClass:true entra em G1
        _, owner = idx[code]
        if owner and owner != home_bc:
            R["G1"]["foreign_exempt"].append((code, a["coreNoun"], owner))
            continue                                   # estrangeiro: termo canonico vive no BC dono
        cn = norm(a["coreNoun"])
        dedicated = any(norm(t["termEn"]) == cn and code in t.get("domainModelRefs", []) for t in terms)
        (R["G1"]["covered"] if dedicated else R["G1"]["gaps"]).append((code, a["coreNoun"]))

    # --- G2: classificacao forcada (modelo -> anotacao) ---
    for code in model_concepts:
        a = ann.get(code)
        if not a or "firstClass" not in a or not a.get("firstClassReason"):
            R["G2"]["unclassified"].append(code)

    # --- G3: ref-existe + correspondencia ---
    for t in terms:
        for ref in t.get("domainModelRefs", []):
            if ref not in valid:
                R["G3"]["dangling_ref"].append((t["code"], ref))
    # correspondencia: termo cujo termEn nomeia o coreNoun de um conceito DEVE referenciar esse conceito
    for t in terms:
        tn = norm(t["termEn"])
        for code in model_concepts:
            a = ann.get(code)
            if not a:
                continue
            if norm(a["coreNoun"]) == tn and code not in t.get("domainModelRefs", []):
                R["G3"]["correspondence_fail"].append((t["code"], t["termEn"], code))

    # --- G4: consistencia bidirecional (termo nunca aponta p/ firstClass:false) ---
    for t in terms:
        for ref in t.get("domainModelRefs", []):
            a = ann.get(ref)
            if a and a.get("firstClass") is False:
                R["G4"]["contradiction"].append((t["code"], ref, a.get("firstClassReason")))

    # --- G5: razao tipada ---
    for code, a in ann.items():
        r = a.get("firstClassReason")
        if a.get("firstClass") and r not in pos:
            R["G5"]["mistyped"].append((code, "true", r))
        if a.get("firstClass") is False and r not in neg:
            R["G5"]["mistyped"].append((code, "false", r))

    # --- FILA DE REVISAO ---
    for code, a in ann.items():
        if a.get("firstClass") is False and a.get("crossesContract"):
            R["QUEUE"].append((code, a["coreNoun"], a.get("firstClassReason")))

    return R

def gate_failures(R):
    # quais gates DETERMINISTICOS dispararam (G1 owned-gap conta como achado de cobertura; demais como erro estrutural)
    fired = []
    if R["G1"]["gaps"]:                fired.append("G1")
    if R["G2"]["unclassified"]:        fired.append("G2")
    if R["G3"]["dangling_ref"] or R["G3"]["correspondence_fail"]: fired.append("G3")
    if R["G4"]["contradiction"]:       fired.append("G4")
    if R["G5"]["mistyped"]:            fired.append("G5")
    return fired

# ---------- injecoes de erro de teste (mutacao in-memory; impressas como delta) ----------

def inject_4a(gl, dm, an):
    # WRONG-NEIGHBOR: termo "Payment" apontando para o vizinho errado (vo-eligibility-decision) em vez de agg-payment.
    gl = copy.deepcopy(gl)
    gl["terms"].append({
        "code": "term-pagamento", "name": "Pagamento", "termEn": "Payment",
        "category": "value", "definition": "(injetado 4a)",
        "domainModelRefs": ["vo-eligibility-decision"],
    })
    return gl, dm, an, "glossary += termo termEn='Payment' refs=[vo-eligibility-decision] (vizinho errado)"

def inject_4b(gl, dm, an):
    # FIRSTCLASS:FALSE LIE: agg-payment rebaixado a nao-first-class com razao bem-tipada (derived-mechanical).
    an = copy.deepcopy(an)
    for c in an["concepts"]:
        if c["code"] == "agg-payment":
            c["firstClass"] = False
            c["firstClassReason"] = "derived-mechanical"
    return gl, dm, an, "annotations: agg-payment.firstClass true->false reason='derived-mechanical' (mentira bem-tipada)"

def inject_4c(gl, dm, an):
    # GRAZING TERM: termo que pasta em agg-payment (referencia) mas cujo termEn != 'Payment' (nao cobre dedicadamente).
    gl = copy.deepcopy(gl)
    gl["terms"].append({
        "code": "term-ciclo-pagamento", "name": "Ciclo de Pagamento", "termEn": "PaymentCycle",
        "category": "process", "definition": "(injetado 4c)",
        "domainModelRefs": ["agg-payment"],
    })
    return gl, dm, an, "glossary += termo termEn='PaymentCycle' refs=[agg-payment] (pasta, nao cobre)"

# ---------- relatorio ----------

def fmt_list(items):
    return "\n".join(f"      - {x}" for x in items) if items else "      (vazio)"

def report_run(label, delta, R):
    print(f"\n{'='*72}\n RUN: {label}")
    if delta: print(f" INJECAO: {delta}")
    print(f"{'='*72}")
    print(f"  G1 COBERTURA-DEDICADA  gaps(owned)={len(R['G1']['gaps'])} foreign-exempt={len(R['G1']['foreign_exempt'])} covered={len(R['G1']['covered'])}")
    print(f"     gaps(owned):\n{fmt_list(R['G1']['gaps'])}")
    print(f"     foreign-exempt:\n{fmt_list(R['G1']['foreign_exempt'])}")
    print(f"  G2 CLASSIFICACAO-FORCADA unclassified={len(R['G2']['unclassified'])}\n{fmt_list(R['G2']['unclassified'])}")
    print(f"  G3 REF+CORRESPOND  dangling={len(R['G3']['dangling_ref'])} correspondence_fail={len(R['G3']['correspondence_fail'])}")
    print(f"     dangling:\n{fmt_list(R['G3']['dangling_ref'])}")
    print(f"     correspondence_fail:\n{fmt_list(R['G3']['correspondence_fail'])}")
    print(f"  G4 CONSISTENCIA-BIDIR  contradiction={len(R['G4']['contradiction'])}\n{fmt_list(R['G4']['contradiction'])}")
    print(f"  G5 RAZAO-TIPADA  mistyped={len(R['G5']['mistyped'])}\n{fmt_list(R['G5']['mistyped'])}")
    print(f"  FILA DE REVISAO  ({len(R['QUEUE'])}):\n{fmt_list(R['QUEUE'])}")
    print(f"  -> gates disparados: {gate_failures(R) or '(nenhum)'}")
    return R

def main():
    gl0, dm0, an0 = load()

    print("#"*72)
    print("# SIMULACAO firstClass + rastreabilidade glossario<->modelo  (FCE, descartavel)")
    print("#"*72)

    base = report_run("BASELINE (FCE real, 7 termos vs 15 conceitos)", None, run_gates(gl0, dm0, an0))

    runs = {}
    for name, fn in [("4a", inject_4a), ("4b", inject_4b), ("4c", inject_4c)]:
        gl, dm, an, delta = fn(gl0, dm0, an0)
        runs[name] = report_run(f"INJECAO {name}", delta, run_gates(gl, dm, an))

    # ---------- MATRIZ ----------
    print(f"\n{'#'*72}\n# MATRIZ DE DETECCAO  (criterio: nenhum erro escapa como verde falso)\n{'#'*72}")
    base_agg_gap = ("agg-payment", "Payment") in base["G1"]["gaps"]

    def caught_4a(R):
        return [("G3-correspondence", R["G3"]["correspondence_fail"]),
                ("G1-gap-persiste", ("agg-payment","Payment") in R["G1"]["gaps"])]
    def caught_4b(R):
        on_queue = any(c[0]=="agg-payment" for c in R["QUEUE"])
        return [("FILA-DE-REVISAO", on_queue),
                ("G4-contradiction", R["G4"]["contradiction"]),
                ("G5(nao pega: mentira bem-tipada)", bool(R["G5"]["mistyped"]))]
    def caught_4c(R):
        return [("G1-gap-persiste", ("agg-payment","Payment") in R["G1"]["gaps"]),
                ("nao-confundido-por-grazing", ("agg-payment","Payment") in R["G1"]["gaps"])]

    rows = [
        ("4a wrong-neighbor (G3 esperado)",  "G3-correspondence", caught_4a(runs["4a"])),
        ("4b firstClass:false-lie (fila esperada)", "FILA-DE-REVISAO", caught_4b(runs["4b"])),
        ("4c grazing-term (G1 esperado)",    "G1-gap-persiste",  caught_4c(runs["4c"])),
    ]
    all_caught = True
    print(f"  baseline: agg-payment(Payment) e gap em G1 = {base_agg_gap}  (gap headline: Payment sem termo dedicado)\n")
    for label, expect, signals in rows:
        hit = any(bool(v) for _, v in signals if not _.startswith("G5(") and not _.startswith("nao-confundido"))
        verd = "CAPTURADO" if hit else "ESCAPOU(verde falso)"
        if not hit: all_caught = False
        print(f"  [{verd:20s}] {label}")
        print(f"       detector esperado: {expect}")
        for sname, sval in signals:
            mark = "x" if sval else "."
            print(f"         ({mark}) {sname}: {sval}")
    print(f"\n{'#'*72}")
    print(f"# VEREDITO DO PILOTO: {'PASSA — nenhum dos 3 erros escapou como verde falso' if all_caught else 'FALHA — houve verde falso'}")
    print(f"{'#'*72}")
    return 0 if all_caught else 1

if __name__ == "__main__":
    sys.exit(main())
