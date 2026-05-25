#!/usr/bin/env python3
"""
structural-check-runner — avaliador determinístico dos structural-checks (adr-090 / adr-040).

Executa as regras declaradas em architecture/structural-checks/*.cue contra o
estado do repositório. Determinístico (P10): nenhum julgamento interpretativo.
Modo warn (default): reporta, exit 0. Modo reject: exit 1 se houver violação.

Aquisição de dados via `cue`:
  - structuralChecks: cue export ./architecture/structural-checks/ -e structuralChecks
  - location de schema (campo OCULTO _schema.location): cue eval <dir-do-package> -e '<Def>._schema.location'
    (avalia o DIRETORIO do package; tenta TODOS os defs incl. _#Base oculto E
     campos ocultos minusculos como _xxxMeta, pois o location concreto pode
     viver num campo oculto enquanto #Def principal so tem o constraint abstrato
     ou e disjuncao; varre architecture/artifact-schemas/ E governance/build-time/)
  - scope/excluded: cue export ./governance/repo-structure.cue -e repoStructure.scope

Cobre os 10 kinds do #StructuralCheck. fileClassification: AMBIGUO (>=2 schemas)
conta como violacao; unmatched (sem schema localizado) e INFO. Zonas governadas
por work-governance (task-specs/work-events/projections) sao excluidas.

Resiliencia: cada evaluator roda isolado (try/except) — um check que estoura
vira uma linha [ERROR] e NAO aborta o inventario (apropriado para warn-first).

Uso:
  structural-check-runner.py <repo-root> [--mode warn|reject]
  structural-check-runner.py --self-test
"""
import json, subprocess, sys, os, re, glob, tempfile

def cue_json(args):
    r = subprocess.run(["cue"]+args, capture_output=True, text=True)
    if r.returncode != 0: return None, r.stderr.strip()
    try: return json.loads(r.stdout), None
    except Exception as e: return None, f"json: {e}"

def load_checks():
    d,e = cue_json(["export","./architecture/structural-checks/","-e","structuralChecks","--out","json"])
    if e: sys.exit("FATAL load checks: "+e)
    return d

def load_scope():
    d,e = cue_json(["export","./governance/repo-structure.cue","-e","repoStructure.scope","--out","json"])
    if e or not d: return (["domain/","strategic/","contexts/","architecture/","governance/","ai-orchestration/"], ["cue.mod/",".git/",".github/","scripts/"])
    return (d.get("validated",[]), d.get("excluded",[]))

SCHEMA_DIRS=["./architecture/artifact-schemas","./governance/build-time"]
_loc_cache={}
def schema_location(name):
    if name in _loc_cache: return _loc_cache[name]
    res=None
    for d in SCHEMA_DIRS:
        f=d+"/"+name+".cue"
        if not os.path.isfile(f): continue
        for dn in re.findall(r'^((?:_#|#|_)[A-Za-z0-9_]+):', open(f).read(), re.M):
            loc,e=cue_json(["eval",d,"-e","%s._schema.location"%dn,"--out","json"])
            if not e and isinstance(loc,dict) and loc.get("canonicalPathRegex"): res=loc; break
        if res: break
    _loc_cache[name]=res
    return res

def all_schema_locations():
    out=[]
    for d in SCHEMA_DIRS:
        if not os.path.isdir(d): continue
        for f in sorted(glob.glob(d+"/*.cue")):
            txt=open(f).read()
            if "_schema" not in txt: continue
            for dn in re.findall(r'^((?:_#|#|_)[A-Za-z0-9_]+):', txt, re.M):
                loc,e=cue_json(["eval",d,"-e","%s._schema.location"%dn,"--out","json"])
                if not e and isinstance(loc,dict) and loc.get("canonicalPathRegex"): out.append((dn,loc["canonicalPathRegex"]))
    return out

def literal_path(rx):
    if not (rx.startswith("^") and rx.endswith("$")): return None
    body=rx[1:-1].replace("\\.",".")
    return None if re.search(r'[\[\]\(\)\*\+\?\|\\]',body) else body

def glob_capture(g,p):
    pre,_,suf=g.partition("*")
    if not p.startswith(pre) or not p.endswith(suf): return None
    return p[len(pre):len(p)-len(suf)] if suf else p[len(pre):]

def files_matching(rx):
    c=re.compile(rx); out=[]
    for dp,_,fs in os.walk("."):
        for f in fs:
            p=os.path.relpath(os.path.join(dp,f),".")
            if c.match(p): out.append(p)
    return sorted(out)

def files_for_at(at):
    loc=schema_location(at)
    if not loc or not loc.get("canonicalPathRegex"): return None
    return files_matching(loc["canonicalPathRegex"])

_art_cache={}
def load_artifact(path):
    if path in _art_cache: return _art_cache[path]
    d,e=cue_json(["export",path,"--out","json"])
    res=None if e else (list(d.values())[0] if isinstance(d,dict) and len(d)==1 else d)
    _art_cache[path]=res
    return res

def dotget(o,path):
    cur=o
    for k in path.split("."):
        if isinstance(cur,dict) and k in cur: cur=cur[k]
        else: return None
    return cur

def ev_directory_pair(rule,c):
    v=[]
    for p in sorted(glob.glob(rule["sourceGlob"])):
        cap=glob_capture(rule["sourceGlob"],p)
        if cap is None: continue
        t=rule["targetGlob"].replace("*",cap,1)
        if not os.path.isfile(t): v.append(f"{p} -> falta {t}")
    if rule.get("bidirectional"):
        for p in sorted(glob.glob(rule["targetGlob"])):
            cap=glob_capture(rule["targetGlob"],p)
            if cap is None: continue
            s=rule["sourceGlob"].replace("*",cap,1)
            if not os.path.isfile(s): v.append(f"{p} -> falta {s}")
    return v

def ev_singleton(rule,c):
    v=[]
    for n in rule["requiredSingletons"]:
        loc=schema_location(n)
        if loc is None: v.append(f"{n}: schema/location nao encontrado"); continue
        if loc.get("cardinality")!="singleton": v.append(f"{n}: cardinality != singleton"); continue
        lp=literal_path(loc.get("canonicalPathRegex",""))
        if lp is None: v.append(f"{n}: canonicalPathRegex nao-literal (fora do V1)"); continue
        if not os.path.isfile(lp): v.append(f"{n}: ausente em {lp}")
    return v

def ev_pg_coverage(rule,c):
    return [f"{n}: production-guides/{n}.cue ausente" for n in rule["coveredSchemas"]
            if not os.path.isfile("./architecture/production-guides/"+n+".cue")]

def ev_required_block(rule,c):
    fs=files_for_at(c["artifactType"])
    if fs is None: return [f"(artifactType '{c['artifactType']}' nao resolve para schema)"]
    v=[]
    for f in fs:
        a=load_artifact(f)
        if a is not None and dotget(a,rule["blockName"]) is None: v.append(f"{f}: falta bloco '{rule['blockName']}'")
    return v

def ev_at_least_one(rule,c):
    fs=files_for_at(c["artifactType"])
    if fs is None: return [f"(artifactType '{c['artifactType']}' nao resolve)"]
    v=[]
    for f in fs:
        a=load_artifact(f)
        if a is None: continue
        if not any(dotget(a,b) not in (None,[],{},"") for b in rule["blockNames"]):
            v.append(f"{f}: nenhum de {rule['blockNames']}")
    return v

def ev_fs_path_exists(rule,c):
    fs=files_for_at(c["artifactType"])
    if fs is None: return [f"(artifactType '{c['artifactType']}' nao resolve)"]
    v=[]
    for f in fs:
        a=load_artifact(f)
        if a is None: continue
        val=dotget(a,rule["sourcePath"])
        if val is None: continue
        for p in (val if (rule.get("isList") and isinstance(val,list)) else [val]):
            if isinstance(p,str) and not os.path.exists(p): v.append(f"{f}: {rule['sourcePath']} -> '{p}' inexistente")
    return v

def ev_reference_exists(rule,c):
    fs=files_for_at(c["artifactType"])
    if fs is None: return [f"(artifactType '{c['artifactType']}' nao resolve)"]
    v=[]
    for f in fs:
        a=load_artifact(f)
        if a is None: continue
        refs=dotget(a,rule["sourcePath"])
        if refs is None: continue
        refs=refs if isinstance(refs,list) else [refs]
        ns=dotget(a,rule["refNamespace"]); keys=set(ns.keys()) if isinstance(ns,dict) else set()
        for r in refs:
            if isinstance(r,(dict,list)): continue
            if r not in keys: v.append(f"{f}: ref '{r}' ({rule['sourcePath']}) ausente em {rule['refNamespace']}")
    return v

def _idset(val):
    # Normaliza um bloco (dict de defs, lista de strings, ou lista de dicts)
    # para um set de identificadores hashaveis. Lista de dicts: usa
    # id/code/name/key. Evita TypeError unhashable em set().
    out=set()
    if isinstance(val,dict): return set(val.keys())
    if isinstance(val,str): return {val}
    if isinstance(val,list):
        for it in val:
            if isinstance(it,str): out.add(it)
            elif isinstance(it,dict):
                for fld in ("id","code","name","key"):
                    if isinstance(it.get(fld),str): out.add(it[fld]); break
    return out

def ev_same_artifact(rule,c):
    fs=files_for_at(c["artifactType"])
    if fs is None: return [f"(artifactType '{c['artifactType']}' nao resolve)"]
    v=[]
    for f in fs:
        a=load_artifact(f)
        if a is None: continue
        refk=_idset(dotget(a,rule["referencingBlock"])); defk=_idset(dotget(a,rule["definingBlock"]))
        for k in sorted(refk):
            if k not in defk: v.append(f"{f}: '{k}' ({rule['referencingBlock']}) ausente em {rule['definingBlock']}")
    return v

def ev_conditional(rule,c):
    v=[]
    for f in sorted(glob.glob(rule["sourcePattern"])):
        a=load_artifact(f)
        if a is None: continue
        cond=dotget(a,rule["conditionField"]) is True
        cap=glob_capture(rule["sourcePattern"],f)
        if cap is None: continue
        t=rule["targetPattern"].replace("*",cap,1); ex=os.path.exists(t)
        if cond and not ex: v.append(f"{f}: {rule['conditionField']}=true mas {t} ausente")
        elif rule.get("biconditional") and (not cond) and ex: v.append(f"{f}: {rule['conditionField']}=false mas {t} existe")
    return v

def ev_domain_invariant(rule,c):
    inv=rule["invariantId"]
    for f in glob.glob("contexts/*/domain-model.cue"):
        a=load_artifact(f); invs=dotget(a,"invariants") if a else None
        if isinstance(invs,list) and any(isinstance(i,dict) and (i.get("code")==inv or i.get("id")==inv) for i in invs): return []
        if isinstance(invs,dict) and inv in invs: return []
    return [f"invariantId '{inv}' nao encontrado em contexts/*/domain-model.cue"]

EVAL={"directory-pair-coverage":ev_directory_pair,"singleton-coverage":ev_singleton,
 "production-guide-coverage":ev_pg_coverage,"required-block":ev_required_block,
 "at-least-one-block-present":ev_at_least_one,"filesystem-path-exists":ev_fs_path_exists,
 "reference-exists":ev_reference_exists,"same-artifact-consistency":ev_same_artifact,
 "conditional-file-presence":ev_conditional,"domain-invariant":ev_domain_invariant}

GOVERNED_ELSEWHERE=("governance/build-time/task-specs/","governance/build-time/work-events/","governance/build-time/projections/")
def file_classification(scope,excluded):
    locs=all_schema_locations(); orphan=[]; ambig=[]
    for d in scope:
        d=d.rstrip("/")
        if not os.path.isdir(d): continue
        for dp,_,fs in os.walk(d):
            for f in fs:
                if not f.endswith(".cue"): continue
                p=os.path.relpath(os.path.join(dp,f),".")
                if any(p.startswith(e.rstrip("/")) for e in excluded): continue
                if any(p.startswith(g) for g in GOVERNED_ELSEWHERE): continue
                ms=[n for n,rx in locs if re.match(rx,p)]
                if len(ms)==0: orphan.append(p)
                elif len(ms)>=2: ambig.append((p,ms))
    return orphan,ambig

def run(root,mode):
    os.chdir(root)
    checks=load_checks(); total=0; uncovered=[]
    for cid,c in sorted(checks.items()):
        fn=EVAL.get(c["kind"])
        if not fn: uncovered.append((cid,c["kind"])); continue
        try:
            vs=fn(c["rule"],c)
        except Exception as ex:
            total+=1
            print(f"[ERROR] {cid} ({c['kind']}): avaliador falhou: {type(ex).__name__}: {ex}")
            continue
        if vs:
            total+=len(vs); print(f"[{'WARN' if mode=='warn' else 'FAIL'}] {cid} ({c['kind']}): {c.get('title','')}")
            for x in vs: print(f"    - {x}")
    scope,excluded=load_scope()
    orphan,ambig=file_classification(scope,excluded)
    if ambig:
        print(f"\n[fileClassification] AMBIGUO (viola exclusive-match) — conta:")
        for p,ms in ambig: print(f"    AMBIG  {p} -> {ms}")
        total+=len(ambig)
    if orphan:
        print(f"\n[fileClassification] unmatched — sem artifact-schema localizado (INFO, nao conta): {len(orphan)}")
        for o in orphan: print(f"    unmatched  {o}")
    if uncovered:
        print("\n[runner] kinds sem evaluator (ignorados):")
        for cid,k in uncovered: print(f"    {cid}: {k}")
    print(f"\nTOTAL: {total} violacao(oes) [modo={mode}]")
    return total

def self_test():
    d=tempfile.mkdtemp()
    def w(p,s):
        fp=os.path.join(d,p); os.makedirs(os.path.dirname(fp),exist_ok=True); open(fp,"w").write(s)
    w("architecture/artifact-schemas/singleton.cue",'package artifact_schemas\n#S:{x:string,_schema:location:{canonicalPathRegex:"^global/thing\\\\.cue$",fileNameRegex:"^thing\\\\.cue$",cardinality:"singleton"}}\n')
    w("architecture/artifact-schemas/thing.cue",'package artifact_schemas\n#Thing:_#TB&({k:"x"}|{k:"y"})\n_#TB:{k:string,_schema:location:{canonicalPathRegex:"^things/[a-z]+\\\\.cue$",fileNameRegex:"^[a-z]+\\\\.cue$",cardinality:"collection"}}\n')
    w("architecture/structural-checks/c.cue",'package structural_checks\nstructuralChecks:{"sc-dp-01":{id:"sc-dp-01",title:"t",artifactType:"work-governance",description:"d",kind:"directory-pair-coverage",rule:{sourceGlob:"we/wi-*.cue",targetGlob:"ts/wi-*.cue",bidirectional:false},errorMessage:"e",rationale:"r"},"sc-sg-01":{id:"sc-sg-01",title:"t",artifactType:"artifact-schema",description:"d",kind:"singleton-coverage",rule:{requiredSingletons:["singleton"]},errorMessage:"e",rationale:"r"},"sc-th-01":{id:"sc-th-01",title:"t",artifactType:"thing",description:"d",kind:"required-block",rule:{blockName:"val"},errorMessage:"e",rationale:"r"}}\n')
    # location concreto em campo oculto minusculo (_pgMeta), nao em _#Base —
    # replica production-guide.cue (regressao sc-pg "nao resolve").
    w("architecture/artifact-schemas/pg.cue",'package artifact_schemas\n#PG:{_schema:location:{canonicalPathRegex:string&!="",fileNameRegex:string&!="",cardinality:"singleton"|"collection",allowNested:bool|*false}}\n_pgMeta:{_schema:location:{canonicalPathRegex:"^pg/[a-z]+\\\\.cue$",fileNameRegex:"^[a-z]+\\\\.cue$",cardinality:"collection",allowNested:false}}\n')
    w("we/wi-1.cue","package we\n"); w("we/wi-9.cue","package we\n"); w("ts/wi-1.cue","package ts\n")
    w("global/thing.cue","package x\n"); w("things/good.cue",'package things\nt:{k:"x"}\n')
    os.chdir(d); _loc_cache.clear(); _art_cache.clear()
    checks=load_checks()
    dp=ev_directory_pair(checks["sc-dp-01"]["rule"],checks["sc-dp-01"])
    sg=ev_singleton(checks["sc-sg-01"]["rule"],checks["sc-sg-01"])
    th=ev_required_block(checks["sc-th-01"]["rule"],checks["sc-th-01"])  # disjuncao+base-oculta deve RESOLVER
    # regressao unhashable: blocos como lista-de-dicts nao podem crashar _idset
    idr = (_idset([{"id":"a"},{"code":"b"},"c"])=={"a","b","c"}) and (_idset({"x":1})=={"x"}) and (_idset(None)==set())
    # regressao campo-oculto-minusculo: location concreto em _pgMeta deve RESOLVER
    pgloc=schema_location("pg")
    hid = isinstance(pgloc,dict) and pgloc.get("canonicalPathRegex")=="^pg/[a-z]+\\.cue$"
    ok = (dp==["we/wi-9.cue -> falta ts/wi-9.cue"]) and (sg==[]) and (th==["things/good.cue: falta bloco 'val'"]) and idr and hid
    print("SELF-TEST:", "PASS" if ok else f"FAIL dp={dp} sg={sg} th={th} idr={idr} hid={hid}")
    return 0 if ok else 1

if __name__=="__main__":
    if "--self-test" in sys.argv: sys.exit(self_test())
    root=sys.argv[1]; mode="reject" if "--mode" in sys.argv and sys.argv[sys.argv.index("--mode")+1]=="reject" else "warn"
    total=run(root,mode)
    sys.exit(1 if (mode=="reject" and total) else 0)
