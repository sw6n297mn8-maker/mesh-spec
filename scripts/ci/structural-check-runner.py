#!/usr/bin/env python3
"""
structural-check-runner — avaliador determinístico dos structural-checks (adr-090 / adr-040).

Executa as regras declaradas em architecture/structural-checks/*.cue contra o
estado do repositório. Determinístico (P10): nenhum julgamento interpretativo.

Enforcement por check (adr-096 + adr-097): cada #StructuralCheck declara
enforcement ("warn" default | "reject"). Exit 1 sse houver violação em check
com enforcement efetivo "reject" (blocking_total > 0); senão exit 0.
--mode é override global: default (sem flag) respeita check.enforcement;
--mode warn força tudo report-only; --mode reject força tudo blocking

Meta-cobertura (adr-099/101): além dos checks declarados, dois built-ins
de fileClassification + os meta-checks sc-meta-01 (evaluator-coverage) e
sc-meta-02 (structural-check-coverage) garantem COBERTURA da camada de
fiscalização — todo kind tem evaluator, todo tipo governado tem check ou
isenção registrada. Ambos promovidos a reject (adr-101).
(discovery runs e testes locais).

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

def _cue_unescape(s):
    # String CUE double-quoted -> valor literal. Cobre os escapes usados em
    # canonicalPathRegex (\\ -> \, \" -> ", ...). Necessario quando a location
    # vem da extracao TEXTUAL (forma source) e nao do cue eval (forma avaliada).
    out=[]; i=0; mp={"\\":"\\",'"':'"',"/":"/","n":"\n","t":"\t","r":"\r"}
    while i<len(s):
        if s[i]=="\\" and i+1<len(s): out.append(mp.get(s[i+1],s[i+1])); i+=2
        else: out.append(s[i]); i+=1
    return "".join(out)

def _def_body(txt,dn):
    # Fatia ESTRITA do corpo do #Def alvo: do seu inicio (col 0) ate o proximo
    # def top-level (col 0) ou EOF. Impede capturar _schema.location de OUTRO
    # def no mesmo arquivo (ex.: agent-governance.cue = Global + Envelope).
    m=re.search(r'(?m)^'+re.escape(dn)+r'\s*:', txt)
    if not m: return None
    nxt=re.search(r'(?m)^(?:_#|#|_)[A-Za-z0-9_]+\s*:', txt[m.end():])
    return txt[m.start():m.end()+nxt.start()] if nxt else txt[m.start():]

def _textual_location(txt,dn):
    # Fallback p/ defs NAO-concretos (ex.: #Subdomain tem disjuncao aberta) onde
    # cue eval/export/def estouram. Le canonicalPathRegex + cardinality do corpo
    # do def, com unescape CUE. Determinista; escopo limitado ao bloco do def.
    body=_def_body(txt,dn)
    if not body: return None
    mr=re.search(r'canonicalPathRegex:\s*"((?:[^"\\]|\\.)*)"', body)
    if not mr: return None
    loc={"canonicalPathRegex":_cue_unescape(mr.group(1))}
    mc=re.search(r'cardinality:\s*"([a-z-]+)"', body)
    if mc: loc["cardinality"]=mc.group(1)
    mf=re.search(r'fileNameRegex:\s*"((?:[^"\\]|\\.)*)"', body)
    if mf: loc["fileNameRegex"]=_cue_unescape(mf.group(1))
    return loc

def extract_location(d,dn,txt):
    # Fonte UNICA da extracao de location (runner + gerador). Fast path: cue eval
    # (forma avaliada). Fallback: extracao textual quando o def e nao-concreto e
    # o eval estoura — robustez a defs com disjuncao aberta (nao alterar o schema).
    loc,e=cue_json(["eval",d,"-e","%s._schema.location"%dn,"--out","json"])
    if not e and isinstance(loc,dict) and loc.get("canonicalPathRegex"): return loc
    return _textual_location(txt,dn)

_loc_cache={}
def schema_location(name):
    if name in _loc_cache: return _loc_cache[name]
    res=None
    for d in SCHEMA_DIRS:
        f=d+"/"+name+".cue"
        if not os.path.isfile(f): continue
        txt=open(f).read()
        for dn in re.findall(r'^((?:_#|#|_)[A-Za-z0-9_]+):', txt, re.M):
            loc=extract_location(d,dn,txt)
            if loc and loc.get("canonicalPathRegex"): res=loc; break
        if res: break
    _loc_cache[name]=res
    return res

def all_locations_full():
    # (defName, canonicalPathRegex, cardinality). Base compartilhada com o gerador.
    out=[]
    for d in SCHEMA_DIRS:
        if not os.path.isdir(d): continue
        for f in sorted(glob.glob(d+"/*.cue")):
            txt=open(f).read()
            if "_schema" not in txt: continue
            for dn in re.findall(r'^((?:_#|#|_)[A-Za-z0-9_]+):', txt, re.M):
                loc=extract_location(d,dn,txt)
                if loc and loc.get("canonicalPathRegex"): out.append((dn,loc["canonicalPathRegex"],loc.get("cardinality","")))
    return sorted(out)

def all_schema_locations():
    return [(n,rx) for n,rx,c in all_locations_full()]

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
    ff=rule.get("filterField"); fv=rule.get("filterValue"); must=rule.get("mustExist",True)
    v=[]
    for f in fs:
        a=load_artifact(f)
        if a is None: continue
        if ff is not None and dotget(a,ff)!=fv: continue
        val=dotget(a,rule["sourcePath"])
        if val is None: continue
        for p in (val if (rule.get("isList") and isinstance(val,list)) else [val]):
            if not isinstance(p,str): continue
            ex=os.path.exists(p)
            if must and not ex: v.append(f"{f}: {rule['sourcePath']} -> '{p}' inexistente")
            elif (not must) and ex: v.append(f"{f}: {rule['sourcePath']} -> '{p}' existe (recordType=delecao exige ausencia)")
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

def _resolve_multi(obj,path):
    # adr-100: resolve um path multi-valor. Segmento "x[]" itera os elementos
    # de uma lista OU os valores de um dict; segmento "x" acessa o campo. Retorna
    # a lista achatada de folhas (None descartado). Travessia intra-arquivo.
    cur=[obj]
    for seg in path.split("."):
        it=seg.endswith("[]"); key=seg[:-2] if it else seg
        nxt=[]
        for o in cur:
            if not isinstance(o,dict) or key not in o: continue
            val=o[key]
            if it:
                if isinstance(val,list): nxt.extend(val)
                elif isinstance(val,dict): nxt.extend(val.values())
            else:
                nxt.append(val)
        cur=nxt
    return [x for x in cur if x is not None]

def ev_local_field_reference_integrity(rule,c):
    # adr-100: todo valor em referencePath existe no conjunto namespacePath, no
    # MESMO arquivo. Intra-arquivo (distinto do cross-file-id-exists, def-002).
    fs=files_for_at(c["artifactType"])
    if fs is None: return [f"(artifactType '{c['artifactType']}' nao resolve)"]
    v=[]
    for f in fs:
        a=load_artifact(f)
        if a is None: continue
        ns={x for x in _resolve_multi(a,rule["namespacePath"]) if isinstance(x,(str,int))}
        for r in _resolve_multi(a,rule["referencePath"]):
            if isinstance(r,(str,int)) and r not in ns:
                v.append("%s: ref '%s' (%s) ausente em %s" % (f,r,rule["referencePath"],rule["namespacePath"]))
    return v

def ev_evaluator_coverage(rule,c):
    # M1 (adr-099): todo kind DECLARADO no enum #StructuralCheckKind + todo kind
    # USADO por algum check tem evaluator em EVAL. Cartaz sem fiscal => finding.
    declared=set()
    p=rule.get("checkSchemaPath","architecture/artifact-schemas/structural-check.cue")
    try:
        m=re.search(r'#StructuralCheckKind:\s*(.+)',open(p).read())
        if m: declared={x for x in re.findall(r'"([a-z-]+)"',m.group(1))}
    except OSError: pass
    used={cc.get("kind") for cc in load_checks().values() if isinstance(cc,dict)}
    miss=sorted(k for k in (declared|used) if k and k not in EVAL)
    return ["kind '%s' declarado/usado sem evaluator em EVAL (cartaz sem fiscal)" % k for k in miss]

def ev_sc_coverage(rule,c):
    # M2 (adr-099): tipos governados DERIVADOS dos _schema.location (basenames dos
    # schemas que governam instancias), nao autorados. Coberto = existe check com
    # artifactType == basename. Isencoes registradas (com rationale) saem.
    governed=set()
    for d in SCHEMA_DIRS:
        for f in glob.glob(d+"/*.cue"):
            try: t=open(f).read()
            except OSError: continue
            if "_schema" in t: governed.add(os.path.basename(f)[:-4])
    covered={cc.get("artifactType") for cc in load_checks().values() if isinstance(cc,dict)}
    exempt={e.get("type") for e in rule.get("exemptTypes",[]) if isinstance(e,dict)}
    miss=sorted(governed-covered-exempt)
    return ["tipo '%s' governado sem structural-check (so cue vet + gate de orfao)" % t for t in miss]

EVAL={"directory-pair-coverage":ev_directory_pair,"singleton-coverage":ev_singleton,
 "production-guide-coverage":ev_pg_coverage,"required-block":ev_required_block,
 "at-least-one-block-present":ev_at_least_one,"filesystem-path-exists":ev_fs_path_exists,
 "reference-exists":ev_reference_exists,"same-artifact-consistency":ev_same_artifact,
 "conditional-file-presence":ev_conditional,"domain-invariant":ev_domain_invariant,
 "evaluator-coverage":ev_evaluator_coverage,"structural-check-coverage":ev_sc_coverage,
 "local-field-reference-integrity":ev_local_field_reference_integrity}

# adr-098: exclusoes da classificacao por artifact-schema-instance lidas de
# fontes DECLARADAS (nao hardcoded) — repoStructure.scope.schemaExemptZones +
# derivedArtifacts (targets .cue + deriver-templates). Substitui o antigo
# GOVERNED_ELSEWHERE hardcoded (subsumido por governance/build-time/).
_exempt_cache={}
def exempt_zones():
    if "v" in _exempt_cache: return _exempt_cache["v"]
    d,e=cue_json(["export","./governance/repo-structure.cue","-e","repoStructure.scope.schemaExemptZones","--out","json"])
    _exempt_cache["v"]=d if (not e and isinstance(d,list)) else []
    return _exempt_cache["v"]

# Fallback se o export do registry falhar: evita que o proprio indice derivado
# reapareca como orfao (auto-referencia).
_DERIVED_FALLBACK={"governance/readme/structure-index.cue"}
_derived_cache={}
def derived_template_paths():
    if "v" in _derived_cache: return _derived_cache["v"]
    out=set(_DERIVED_FALLBACK)
    d,e=cue_json(["export","./governance/repo-structure.cue","-e","repoStructure.derivedArtifacts.artifacts","--out","json"])
    if not e and isinstance(d,list):
        for a in d:
            if not isinstance(a,dict): continue
            p=a.get("path","")
            if isinstance(p,str) and p.endswith(".cue"): out.add(p)
            # deriver-template: o .cue que define o campo exportado pelo generator
            # (ex.: `cue export ./governance/readme -e output` -> readme/output.cue).
            g=a.get("generator","")
            m=re.search(r'cue export \./(\S+) -e (\w+)',g) if isinstance(g,str) else None
            if m:
                dirp,field=m.group(1),m.group(2)
                for f in glob.glob(dirp+"/*.cue"):
                    try: t=open(f).read()
                    except OSError: continue
                    if re.search(r'(?m)^'+re.escape(field)+r'\s*:',t): out.add(os.path.relpath(f,"."))
    _derived_cache["v"]=out
    return out

_TYPEDEF_RE=re.compile(r'(?m)^(?:#|_#)[A-Za-z0-9_]+\s*:')
def is_type_definition_file(path):
    # adr-098: .cue com def top-level (# ou _#) e arquivo de definicao de
    # tipo/schema, nao instancia — fora da classificacao de instancia.
    try: t=open(path).read()
    except OSError: return False
    return bool(_TYPEDEF_RE.search(t))

def classification_skip(p,excluded,exempt,derived):
    # adr-098: predicado UNICO compartilhado entre runner e gerador (mapas
    # alinhados). Pula excluded (P2/plataforma/tooling), zonas engine/config,
    # derivados+templates registrados e type-definition files.
    if any(p.startswith(x.rstrip("/")) for x in excluded): return True
    if any(p.startswith(z.rstrip("/")) for z in exempt): return True
    if p in derived: return True
    if is_type_definition_file(p): return True
    return False

def file_classification(scope,excluded):
    locs=all_schema_locations(); exempt=exempt_zones(); derived=derived_template_paths()
    orphan=[]; ambig=[]
    for d in scope:
        d=d.rstrip("/")
        if not os.path.isdir(d): continue
        for dp,_,fs in os.walk(d):
            for f in fs:
                if not f.endswith(".cue"): continue
                p=os.path.relpath(os.path.join(dp,f),".")
                if classification_skip(p,excluded,exempt,derived): continue
                ms=[n for n,rx in locs if re.match(rx,p)]
                if len(ms)==0: orphan.append(p)
                elif len(ms)>=2: ambig.append((p,ms))
    return orphan,ambig

def effective_enforcement(check, mode):
    # mode override global (adr-097): warn força tudo report-only; reject força
    # tudo blocking; default (None) respeita o enforcement declarado no check.
    if mode == "warn":   return "warn"
    if mode == "reject": return "reject"
    return check.get("enforcement", "warn")

def run(root,mode):
    os.chdir(root)
    checks=load_checks(); total=0; blocking=0; uncovered=[]
    for cid,c in sorted(checks.items()):
        fn=EVAL.get(c["kind"])
        if not fn: uncovered.append((cid,c["kind"])); continue
        enf=effective_enforcement(c,mode)
        try:
            vs=fn(c["rule"],c)
        except Exception as ex:
            # crash de avaliador é bug do runner, não violação de artefato:
            # conta em total (visibilidade), bloqueia só sob --mode reject global.
            total+=1
            if mode=="reject": blocking+=1
            print(f"[ERROR] {cid} ({c['kind']}): avaliador falhou: {type(ex).__name__}: {ex}")
            continue
        if vs:
            total+=len(vs)
            if enf=="reject": blocking+=len(vs)
            print(f"[{'FAIL' if enf=='reject' else 'WARN'}] {cid} ({c['kind']}, enforcement={enf}): {c.get('title','')}")
            for x in vs: print(f"    - {x}")
    scope,excluded=load_scope()
    orphan,ambig=file_classification(scope,excluded)
    if ambig:
        # adr-090 declara ambíguo→reject; promoção a blocking-por-default é
        # follow-up (built-in, não check com enforcement). Bloqueia só sob
        # --mode reject global por ora; conta sempre em total.
        print(f"\n[fileClassification] AMBIGUO (viola exclusive-match) — conta:")
        for p,ms in ambig: print(f"    AMBIG  {p} -> {ms}")
        total+=len(ambig)
        if mode=="reject": blocking+=len(ambig)
    if orphan:
        # adr-098: orfao promovido de INFO/non-counting para enforcement "reject"
        # (def-018 resolvido). Built-in do fileClassification, simetrico ao
        # enforcement por-check do adr-097: default/reject bloqueiam; --mode warn forca warn.
        oenf=effective_enforcement({"enforcement":"reject"},mode)
        print(f"\n[{'FAIL' if oenf=='reject' else 'WARN'}] fileClassification: {len(orphan)} orfao(s) sem artifact-schema (enforcement={oenf}):")
        for o in orphan: print(f"    orphan  {o}")
        total+=len(orphan)
        if oenf=="reject": blocking+=len(orphan)
    if uncovered:
        print("\n[runner] kinds sem evaluator (ignorados):")
        for cid,k in uncovered: print(f"    {cid}: {k}")
    print(f"\nTOTAL: {total} violacao(oes); {blocking} bloqueante(s) [modo={mode}]")
    return total,blocking

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
    # filesystem-path-exists com filterField/mustExist (recordType: review exige existir; delecao exige ausencia)
    w("architecture/artifact-schemas/rec.cue",'package artifact_schemas\n#Rec:{recordType:string,target:string,_schema:location:{canonicalPathRegex:"^recs/[a-z0-9-]+\\\\.cue$",fileNameRegex:"^[a-z0-9-]+\\\\.cue$",cardinality:"collection",allowNested:false}}\n')
    w("architecture/structural-checks/rec.cue",'package structural_checks\nstructuralChecks:{"sc-rec-01":{id:"sc-rec-01",title:"t",artifactType:"rec",description:"d",kind:"filesystem-path-exists",rule:{sourcePath:"target",isList:false,filterField:"recordType",filterValue:"artifact-review"},errorMessage:"e",rationale:"r"},"sc-rec-03":{id:"sc-rec-03",title:"t",artifactType:"rec",description:"d",kind:"filesystem-path-exists",rule:{sourcePath:"target",filterField:"recordType",filterValue:"artifact-deletion",mustExist:false},errorMessage:"e",rationale:"r"}}\n')
    w("recs/a.cue",'package recs\nra:{recordType:"artifact-review",target:"recs/a.cue"}\n')
    w("recs/b.cue",'package recs\nrb:{recordType:"artifact-deletion",target:"recs/zzz.cue"}\n')
    w("recs/c.cue",'package recs\nrc:{recordType:"artifact-deletion",target:"recs/a.cue"}\n')
    # regressao non-concreto: def com disjuncao ABERTA (sem default) e _schema
    # DENTRO dele (padrao #Subdomain). cue eval estoura; a location so resolve
    # via fallback textual. Segundo def no MESMO arquivo p/ checar escopo do slice.
    w("architecture/artifact-schemas/sub.cue",'package artifact_schemas\n#Sub:{kind:"a"|"b"|"c"\n_schema:location:{canonicalPathRegex:"^strat/subs/[a-z]+\\\\.cue$",fileNameRegex:"^[a-z]+\\\\.cue$",cardinality:"collection"}}\n#SubRef:string&=~"^x-[a-z]+$"\n')
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
    # filterField/mustExist: review com path existente nao dispara; delecao com path existente dispara
    fre=ev_fs_path_exists(checks["sc-rec-01"]["rule"],checks["sc-rec-01"])
    fde=ev_fs_path_exists(checks["sc-rec-03"]["rule"],checks["sc-rec-03"])
    fil = (fre==[]) and (fde==["recs/c.cue: target -> 'recs/a.cue' existe (recordType=delecao exige ausencia)"])
    # non-concreto: location de #Sub deve resolver via fallback textual (cue eval
    # estoura), com regex na forma AVALIADA (\. e nao \\.) e cardinality correta.
    ncloc=schema_location("sub")
    nc = isinstance(ncloc,dict) and ncloc.get("canonicalPathRegex")==r"^strat/subs/[a-z]+\.cue$" and ncloc.get("cardinality")=="collection"
    ok = (dp==["we/wi-9.cue -> falta ts/wi-9.cue"]) and (sg==[]) and (th==["things/good.cue: falta bloco 'val'"]) and idr and hid and fil and nc
    print("SELF-TEST:", "PASS" if ok else f"FAIL dp={dp} sg={sg} th={th} idr={idr} hid={hid} fre={fre} fde={fde} nc={nc} ncloc={ncloc}")
    return 0 if ok else 1

if __name__=="__main__":
    if "--self-test" in sys.argv: sys.exit(self_test())
    root=sys.argv[1]
    mode="default"
    if "--mode" in sys.argv:
        v=sys.argv[sys.argv.index("--mode")+1]
        if v in ("warn","reject"): mode=v
    total,blocking=run(root,mode)
    sys.exit(1 if blocking else 0)
