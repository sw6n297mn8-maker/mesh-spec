#!/usr/bin/env python3
# SIMULACAO 2 DESCARTAVEL (branch sim/firstclass-shared). NAO e gate de producao.
# Estende o gate do piloto 1 (sim/firstclass-fce) para o CASO COMPARTILHADO (Caso 3): Money cruzando inv/p2p/bdg/bkr.
# Reusa norm() + padrao de runner; adiciona as DUAS leituras de cobertura e o teste shared-vs-foreign.
#
# Le: sim/shared-annotations.json (usages + registro canonico) e sim/gl-<bc>.json (glossarios reais).
# Determinístico. O gate le SO: coreNoun, canonicalTermRef, shared, sourceContext, bc. Nunca le _trueSemantic (oraculo).
#
# LEITURA A (cobertura local): cada uso de Money precisa de termo LOCAL no glossario do proprio BC (termEn==coreNoun).
# LEITURA B (canonico+ref): um termo canonico unico; cada uso shared:true DECLARA canonicalTermRef -> canonico.
#   B1 canonico existe | B2 todo uso shared declara ref | B3 ref resolve | B4 coreNoun corresponde ao termo canonico.
# FILA DE REVISAO: shared:true SEM canonicalTermRef, OU coreNoun != nome do termo canonico (suspeita de guarda-chuva).

import json, sys, copy

def norm(s):
    return "".join(c for c in (s or "").lower() if c.isalnum())

def load():
    an = json.load(open("sim/shared-annotations.json"))
    gloss = {}
    for bc in ["inv", "p2p", "bdg", "bkr", "ctr"]:
        try:
            gloss[bc] = json.load(open(f"sim/gl-{bc}.json")).get("terms", [])
        except FileNotFoundError:
            gloss[bc] = []   # ctr nao exportado: glossario local vazio para fins do sim (4e injeta nele)
    return an, gloss

# ---------------- LEITURA A : cobertura local ----------------
def reading_A(usages, gloss):
    screams = []
    for u in usages:
        terms = gloss.get(u["bc"], [])
        has_local = any(norm(t.get("termEn")) == norm(u["coreNoun"]) for t in terms)
        if not has_local:
            screams.append((u["bc"], u["code"], u["coreNoun"]))
    distinct_bcs = sorted({u["bc"] for u in usages})
    return {"screams": screams, "copies_required": len(distinct_bcs), "bcs": distinct_bcs}

# ---------------- LEITURA B : canonico + ref ----------------
def reading_B(usages, canonical_terms, mode="shared-aware"):
    can_by_code = {t["code"]: t for t in canonical_terms}
    R = {"orphans": [], "dangling": [], "mismatch": [], "ok": [], "exempted_as_foreign": []}
    # B1: canonico existe?
    R["B1_canonical_exists"] = len(canonical_terms) >= 1
    for u in usages:
        if not u.get("shared"):
            continue
        # filtro de propriedade — AQUI mora a diferenca shared-vs-foreign:
        foreign_looking = u.get("sourceContext") and u["sourceContext"] != u["bc"]
        if mode == "naive" and foreign_looking:
            # piloto-1: trata sourceContext!=home como ESTRANGEIRO -> isento (NAO checa ref)
            R["exempted_as_foreign"].append((u["bc"], u["code"], u["sourceContext"]))
            continue
        # shared-aware: shared:true SOBREPÕE a isencao de estrangeiro — sempre checa ref.
        ref = u.get("canonicalTermRef")
        if not ref:                                   # B2: uso shared sem ancora canonica
            R["orphans"].append((u["bc"], u["code"], u["coreNoun"]))
            continue
        if ref not in can_by_code:                    # B3: ref nao resolve
            R["dangling"].append((u["bc"], u["code"], ref))
            continue
        can = can_by_code[ref]                         # B4: coreNoun corresponde ao termo canonico?
        if norm(u["coreNoun"]) != norm(can["termEn"]):
            R["mismatch"].append((u["bc"], u["code"], u["coreNoun"], can["termEn"]))
        else:
            R["ok"].append((u["bc"], u["code"]))
    return R

def review_queue(usages, canonical_terms):
    can_by_code = {t["code"]: t for t in canonical_terms}
    q = []
    for u in usages:
        if not u.get("shared"):
            continue
        ref = u.get("canonicalTermRef")
        if not ref:
            q.append((u["bc"], u["code"], "sem-canonicalTermRef"))
        elif ref in can_by_code and norm(u["coreNoun"]) != norm(can_by_code[ref]["termEn"]):
            q.append((u["bc"], u["code"], f"coreNoun '{u['coreNoun']}' != canonico '{can_by_code[ref]['termEn']}'"))
    return q

# ---------------- injecoes ----------------
def inject_4d(an):  # orfao-de-definicao: bdg usa Money sem ref nem termo local
    an = copy.deepcopy(an)
    for u in an["usages"]:
        if u["bc"] == "bdg" and u["code"] == "vo-money":
            u["canonicalTermRef"] = None
    return an, "bdg/vo-money: canonicalTermRef removido (orfao — usa Money, nao aponta canonico, sem termo local)"

def inject_4e_honest(an):  # nome divergente honesto: Fee apontando o canonico Money
    an = copy.deepcopy(an)
    an["usages"].append({"bc": "ctr", "code": "vo-retention-fee", "coreNoun": "RetentionFee",
                         "firstClass": True, "shared": True, "sourceContext": "ctr",
                         "canonicalTermRef": "term-money", "canonicalSchemaRef": "#Money", "_trueSemantic": "fee"})
    return an, "ctr/vo-retention-fee: coreNoun='RetentionFee' aponta term-money (Fee != Money, NOME divergente)"

def inject_4e_dishonest(an):  # mascara identica: Receivable (claim) se diz 'Money'
    an = copy.deepcopy(an)
    an["usages"].append({"bc": "ctr", "code": "vo-receivable-amount", "coreNoun": "Money",
                         "firstClass": True, "shared": True, "sourceContext": "ctr",
                         "canonicalTermRef": "term-money", "canonicalSchemaRef": "#Money", "_trueSemantic": "receivable-claim"})
    return an, "ctr/vo-receivable-amount: coreNoun='Money' aponta term-money MAS _trueSemantic=receivable-claim (mentira de nome identico)"

def inject_4f(an):  # shared mascarado de estrangeiro: p2p Money com sourceContext=inv e orfao
    an = copy.deepcopy(an)
    for u in an["usages"]:
        if u["bc"] == "p2p" and u["code"] == "vo-money":
            u["sourceContext"] = "inv"          # parece estrangeiro (dono=inv)
            u["canonicalTermRef"] = None         # e e orfao
    return an, "p2p/vo-money: sourceContext inv (parece estrangeiro) + canonicalTermRef removido (orfao)"

# ---------------- relatorio ----------------
def fl(items):
    return "\n".join(f"      - {x}" for x in items) if items else "      (vazio)"

def report(label, delta, an, gloss, modes=("shared-aware",)):
    print(f"\n{'='*74}\n RUN: {label}")
    if delta: print(f" INJECAO: {delta}")
    print('='*74)
    can = an["canonical"]["terms"]
    A = reading_A(an["usages"], gloss)
    print(f"  LEITURA A (cobertura local): {len(A['screams'])} gritos | exigiria {A['copies_required']} copias de term-money ({A['bcs']})")
    print(fl(A["screams"]))
    out = {}
    for mode in modes:
        B = reading_B(an["usages"], can, mode=mode)
        out[mode] = B
        tag = f"LEITURA B [{mode}]"
        print(f"  {tag}: B1canon={B['B1_canonical_exists']} orphans={len(B['orphans'])} dangling={len(B['dangling'])} mismatch={len(B['mismatch'])} ok={len(B['ok'])} foreign-exempt={len(B['exempted_as_foreign'])}")
        if B["orphans"]:   print("     orphans (B2):\n"+fl(B["orphans"]))
        if B["dangling"]:  print("     dangling (B3):\n"+fl(B["dangling"]))
        if B["mismatch"]:  print("     mismatch (B4):\n"+fl(B["mismatch"]))
        if B["exempted_as_foreign"]: print("     ISENTOS COMO ESTRANGEIRO (nao checados!):\n"+fl(B["exempted_as_foreign"]))
    Q = review_queue(an["usages"], can)
    print(f"  FILA DE REVISAO ({len(Q)}):\n{fl(Q)}")
    return {"A": A, "B": out, "Q": Q}

def main():
    an0, gloss = load()
    print("#"*74)
    print("# SIMULACAO 2 — caso COMPARTILHADO (Money cruzando inv/p2p/bdg/bkr)")
    print("#"*74)

    # baseline-disco: estado real (nenhum uso declara canonicalTermRef, nenhum termo de Money existe)
    disk = copy.deepcopy(an0)
    for u in disk["usages"]:
        u["canonicalTermRef"] = None
    report("BASELINE-DISCO (realidade: 0 refs declaradas, 0 termo de Money, #Money schema existe)", None, disk, gloss)

    # baseline-ideal: como Reading B correto pareceria (todos declaram ref; bkr tem nome divergente real)
    base = report("BASELINE-IDEAL (Reading B preenchido; bkr=SettlementValue e divergencia real de disco)", None, an0, gloss)

    runs = {}
    for name, fn in [("4d", inject_4d), ("4e_honest", inject_4e_honest), ("4e_dishonest", inject_4e_dishonest)]:
        an, delta = fn(an0)
        runs[name] = report(f"INJECAO {name}", delta, an, gloss)

    # 4f roda nos DOIS modos para mostrar shared-vs-foreign
    an4f, d4f = inject_4f(an0)
    runs["4f"] = report("INJECAO 4f (shared mascarado de estrangeiro)", d4f, an4f, gloss, modes=("naive", "shared-aware"))

    # ---------------- MATRIZ ----------------
    print(f"\n{'#'*74}\n# MATRIZ DE DETECCAO (TP=pego / FN=escapou verde / FP=grito indevido)\n{'#'*74}")

    def has(b, key): return bool(b.get(key))
    rows = []

    # 4d
    b = runs["4d"]["B"]["shared-aware"]
    caught_4d = any(c[1] == "vo-money" and c[0] == "bdg" for c in b["orphans"])
    rows.append(("4d orfao-de-definicao (criterio: NAO pode escapar)", "B2-orphan",
                 "TP" if caught_4d else "FN",
                 [f"B2 isolou bdg/vo-money: {caught_4d}",
                  f"Reading A tambem grita, mas para TODOS ({len(runs['4d']['A']['screams'])}) — nao isola"]))
    # 4e honest
    b = runs["4e_honest"]["B"]["shared-aware"]
    caught_4eh = any(c[1] == "vo-retention-fee" for c in b["mismatch"])
    rows.append(("4e nome-divergente (Fee->Money)", "B4-mismatch",
                 "TP" if caught_4eh else "FN",
                 [f"B4 flagou ctr/vo-retention-fee: {caught_4eh}", "nome divergente vira finding -> fila de revisao"]))
    # 4e dishonest
    b = runs["4e_dishonest"]["B"]["shared-aware"]
    escaped_4ed = not any(c[1] == "vo-receivable-amount" for c in b["mismatch"]) and \
                  not any(c[1] == "vo-receivable-amount" for c in b["orphans"]) and \
                  ("ctr", "vo-receivable-amount") in b["ok"]
    rows.append(("4e mascara-identica (Receivable-claim diz 'Money')", "(limite honesto)",
                 "FN-declarado" if escaped_4ed else "TP",
                 [f"gate marcou OK (passou): {escaped_4ed}",
                  "oraculo _trueSemantic=receivable-claim e INVISIVEL a estrutura",
                  "mitigacao = camada advisory/humano (le a definicao), nao mais estrutura"]))
    # 4f naive vs shared-aware
    bn = runs["4f"]["B"]["naive"]; bs = runs["4f"]["B"]["shared-aware"]
    escaped_naive = any(c[1] == "vo-money" and c[0] == "p2p" for c in bn["exempted_as_foreign"])
    caught_shared = any(c[1] == "vo-money" and c[0] == "p2p" for c in bs["orphans"])
    rows.append(("4f shared-mascarado-de-estrangeiro", "shared sobrepoe foreign",
                 "TP(shared-aware) / FN(naive)" if (caught_shared and escaped_naive) else "??",
                 [f"naive (filtro piloto-1): isentou como estrangeiro -> ESCAPOU: {escaped_naive}",
                  f"shared-aware: shared sobrepoe -> orphan pego: {caught_shared}"]))

    fail = False
    for label, detector, verd, signals in rows:
        # criterio de falha: APENAS 4d escapando conta como reprovacao do piloto
        if label.startswith("4d") and verd == "FN":
            fail = True
        print(f"\n  [{verd:28s}] {label}")
        print(f"       detector: {detector}")
        for s in signals:
            print(f"         . {s}")

    print(f"\n{'#'*74}")
    print(f"# VEREDITO: {'FALHA — 4d (orfao) escapou' if fail else 'PASSA — 4d nao escapou; 4e-mascara e limite declarado; 4f exige shared!=foreign'}")
    print('#'*74)
    return 1 if fail else 0

if __name__ == "__main__":
    sys.exit(main())
