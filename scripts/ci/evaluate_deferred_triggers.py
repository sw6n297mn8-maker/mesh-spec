#!/usr/bin/env python3
"""evaluate_deferred_triggers.py — core do runner determinístico de triggers
de deferred-decisions (per adr-062, adr-071, adr-162, adr-166).

Invocado pelo wrapper scripts/ci/evaluate-deferred-triggers.sh (que roda o
Step 0 `cue vet` antes). Roda a partir da raiz do repo.

Contratos-chave (adr-166):
- Exclusões de engine POR CONSTRUÇÃO em toda contagem recurrence: um def
  nunca conta para o próprio sensor (deferred-decisions/ + self-reviews/ +
  basenames '_*' ficam fora de qualquer contagem).
- pathScope (regex ancorado) restringe ONDE recurrence file-content conta.
- Kind structural-predicate: sinal lido da ESTRUTURA de artefatos tipados
  via `cue export <package> -e <expr> --out json`, resolvendo predicado
  nomeado no registry governance/build-time/dd-predicates.cue.
- Malformação (predicate id não resolvido; package/expr que não avalia)
  falha ALTO: ::error + exit 1. NUNCA degrada para count 0 silencioso.
- Gate de carência (adr-162) avaliado sobre TODOS os triggers disparados de
  um def — não apenas o primeiro (fix do contorno por ordem, adr-166 item 4).

Limitação preservada de adr-062: avaliação é sobre filesystem state atual +
git; não há state persistido entre runs — trigger fired permanece "open" até
o founder editar status manualmente.
"""

import json
import os
import re
import subprocess
import sys
from datetime import date, datetime, timedelta

DEFERRED_DIR = "architecture/deferred-decisions"
PREDICATES_PACKAGE = "./governance/build-time/"
PREDICATES_EXPR = "ddPredicates"
GRACE_DAYS = 7

# ── Exclusões de engine (adr-166 item 1) — POR CONSTRUÇÃO, não configuráveis ──
ENGINE_EXCLUDED_PREFIXES = (
    "architecture/deferred-decisions/",
    "governance/build-time/self-reviews/",
)


class MalformedTriggerError(Exception):
    """Trigger malformado que escapou do cue vet — falha ALTO (adr-166 item 2)."""


def engine_excluded(path):
    """True quando o path está fora de qualquer contagem recurrence."""
    if path.startswith(ENGINE_EXCLUDED_PREFIXES):
        return True
    return os.path.basename(path).startswith("_")


# ── Dual-source discovery ──
#
# Author styles observados:
#   (a) `deferredDecisions: "def-NNN": {...}`              (def-001..def-014, def-016)
#   (b) `deferredDecisions: "def-NNN-slug": {...}`         (def-015, def-017)
#   (c) `defXXX: {...}` top-level                          (def-018+)
# Todos válidos no schema. Discovery olha ambos os lugares e rekeya pela id
# canônica do value, NÃO pela chave do author (que varia).
def _is_def_value(v):
    if not isinstance(v, dict):
        return False
    vid = v.get("id", "")
    return (isinstance(vid, str)
            and re.match(r"^def-\d{3}$", vid)
            and isinstance(v.get("triggers"), list))


def discover_defs(data):
    defs = {}
    for _key, value in data.get("deferredDecisions", {}).items():
        if _is_def_value(value):
            defs[value["id"]] = value
    for _key, value in data.items():
        if _key == "deferredDecisions" or _key == "meta":
            continue
        if _is_def_value(value):
            defs[value["id"]] = value
    return defs


def fs_sanity_check(defs, deferred_dir=DEFERRED_DIR):
    """def-NNN-*.cue no diretório que NÃO foi discovered = bug de discovery.
    Print ERROR loud — não bloqueia (advisory), mas torna o gap visível."""
    import glob as _glob
    fs_def_ids = set()
    for path in _glob.glob(f"{deferred_dir}/def-*.cue"):
        m = re.match(r".*/(def-\d{3})-", path)
        if m:
            fs_def_ids.add(m.group(1))
    missing = fs_def_ids - set(defs.keys())
    if missing:
        print(f"  ERROR: filesystem has {len(missing)} def-NNN file(s) NOT discovered")
        print(f"  by runner: {sorted(missing)}.")
        print(f"  Indicates discovery bug (novo authoring style não suportado, ou")
        print(f"  schema drift). Runner continua (advisory), mas defs invisíveis")
        print(f"  significam dívida não rastreada.")
    return missing


# ── Avaliadores por kind ──

def evaluate_recurrence(trigger):
    pattern = trigger["pattern"]
    scope = trigger["scope"]
    threshold = trigger["threshold"]
    path_scope = trigger.get("pathScope")
    try:
        if scope == "filename":
            files = subprocess.check_output(["git", "ls-files"], text=True).splitlines()
            matched = [f for f in files
                       if not engine_excluded(f) and re.search(pattern, f)]
            count = len(matched)
        elif scope == "file-content":
            try:
                files = subprocess.check_output(
                    ["git", "grep", "-l", "-E", pattern], text=True,
                ).splitlines()
            except subprocess.CalledProcessError:
                files = []  # grep returns 1 when no match
            matched = [f for f in files if not engine_excluded(f)]
            if path_scope:
                matched = [f for f in matched if re.search(path_scope, f)]
            count = len(matched)
        elif scope == "commit-message":
            commits = subprocess.check_output(
                ["git", "log", "--format=%H", f"--grep={pattern}", "-E"], text=True,
            ).splitlines()
            count = len(commits)
        else:
            return False, f"unknown recurrence scope: {scope}"
        scoped = f", pathScope={path_scope!r}" if path_scope else ""
        if count >= threshold:
            return True, f"recurrence(scope={scope}, pattern={pattern!r}{scoped}) found {count} >= threshold {threshold}"
        return False, f"recurrence count {count} < threshold {threshold}"
    except Exception as e:
        return False, f"recurrence eval error: {e}"


def evaluate_adjacent_need(trigger):
    cond = trigger["condition"]
    kind = cond["kind"]
    path = cond["path"]
    if kind == "file-exists":
        if os.path.exists(path):
            return True, f"adjacent-need.file-exists: {path} exists"
        return False, f"adjacent-need.file-exists: {path} does not exist"
    if kind == "file-contains":
        pattern = cond["pattern"]
        if not os.path.exists(path):
            return False, f"adjacent-need.file-contains: {path} does not exist"
        try:
            with open(path) as f:
                content = f.read()
            if re.search(pattern, content):
                return True, f"adjacent-need.file-contains: {path} matches pattern {pattern!r}"
            return False, f"adjacent-need.file-contains: {path} no match for {pattern!r}"
        except Exception as e:
            return False, f"adjacent-need eval error: {e}"
    return False, f"unknown adjacent-need kind: {kind}"


def evaluate_volume_threshold(trigger):
    artifact_type = trigger["artifactType"]
    threshold = trigger["threshold"]
    # Best-effort: count files matching common patterns for known types.
    # Future: could derive from artifact schema's canonicalPathRegex.
    patterns = {
        "adr": "architecture/adrs/adr-*.cue",
        "lens": "architecture/lenses/*.cue",
        "tension-entry": "architecture/tension-log/ten-*.cue",
        "deferred-decision": "architecture/deferred-decisions/def-*.cue",
        "task-template": "ai-orchestration/agent-instructions/task-templates.cue",
        "structural-check": "architecture/structural-checks/*.cue",
        "validation-prompt": "architecture/validation-prompts/*.cue",
        "production-guide": "architecture/production-guides/*.cue",
        "self-review-report": "governance/build-time/self-reviews/*.cue",
        "subdomain": "strategic/subdomains/*.cue",
    }
    pat = patterns.get(artifact_type)
    if not pat:
        return False, f"volume-threshold: unknown artifactType {artifact_type}"
    try:
        cmd = ["bash", "-c", f"ls {pat} 2>/dev/null | wc -l"]
        count = int(subprocess.check_output(cmd, text=True).strip())
        if count >= threshold:
            return True, f"volume-threshold({artifact_type}): {count} >= threshold {threshold}"
        return False, f"volume-threshold({artifact_type}): {count} < threshold {threshold}"
    except Exception as e:
        return False, f"volume-threshold eval error: {e}"


def evaluate_temporal(trigger, def_date, today):
    max_age = trigger["maxAgeDays"]
    try:
        d = datetime.strptime(def_date, "%Y-%m-%d").date()
        age_days = (today - d).days
        if age_days >= max_age:
            return True, f"temporal: age {age_days} days >= maxAgeDays {max_age}"
        return False, f"temporal: age {age_days} days < maxAgeDays {max_age}"
    except Exception as e:
        return False, f"temporal eval error: {e}"


def evaluate_manual_review(trigger):
    return False, f"manual-review: skip (reason: {trigger.get('reason', 'n/a')[:60]}...)"


def evaluate_file_content_occurrence_count(trigger):
    # Conta occurrences do regex DENTRO de UM arquivo singleton (adr-071).
    # Distinto de recurrence scope=file-content (conta arquivos com matches).
    path = trigger["path"]
    pattern = trigger["pattern"]
    threshold = trigger["threshold"]
    if not os.path.exists(path):
        return False, f"file-content-occurrence-count: {path} does not exist"
    try:
        with open(path) as f:
            text = f.read()
        count = len(re.findall(pattern, text))
        if count >= threshold:
            return True, f"file-content-occurrence-count(path={path}, pattern={pattern!r}) found {count} >= threshold {threshold}"
        return False, f"file-content-occurrence-count: {count} < threshold {threshold}"
    except Exception as e:
        return False, f"file-content-occurrence-count eval error: {e}"


# ── structural-predicate (adr-166 item 3) ──

def cue_export_expr(package, expr):
    """Avalia expr no package via cue export. Erro de avaliação → malformação."""
    try:
        out = subprocess.check_output(
            ["cue", "export", package, "-e", expr, "--out", "json"],
            text=True, stderr=subprocess.PIPE,
        )
    except subprocess.CalledProcessError as e:
        raise MalformedTriggerError(
            f"cue export {package} -e {expr!r} failed: {e.stderr.strip()[:200]}"
        )
    return json.loads(out)


def load_predicates(exporter=cue_export_expr):
    """Carrega o registry ddPredicates. Ausência/erro do registry só é fatal
    quando algum trigger structural-predicate existe (avaliação lazy no caller)."""
    return exporter(PREDICATES_PACKAGE, PREDICATES_EXPR)


def evaluate_structural_predicate(trigger, predicates, exporter=cue_export_expr):
    pid = trigger["predicate"]
    pred = (predicates or {}).get(pid)
    if pred is None:
        raise MalformedTriggerError(
            f"structural-predicate {pid} não resolvido no registry "
            f"governance/build-time/dd-predicates.cue"
        )
    value = exporter(pred["package"], pred["expr"])
    comparator = pred["comparator"]
    if comparator == ">=":
        threshold = pred["threshold"]
        if not isinstance(value, (int, float)) or isinstance(value, bool):
            raise MalformedTriggerError(
                f"structural-predicate {pid}: expr produziu {type(value).__name__}, "
                f"esperado número para comparator '>='"
            )
        if value >= threshold:
            return True, f"structural-predicate({pid}): value {value} >= threshold {threshold}"
        return False, f"structural-predicate({pid}): value {value} < threshold {threshold}"
    if comparator == "==true":
        if not isinstance(value, bool):
            raise MalformedTriggerError(
                f"structural-predicate {pid}: expr produziu {type(value).__name__}, "
                f"esperado booleano para comparator '==true'"
            )
        if value:
            return True, f"structural-predicate({pid}): value is true"
        return False, f"structural-predicate({pid}): value is false"
    raise MalformedTriggerError(f"structural-predicate {pid}: comparator desconhecido {comparator!r}")


# ── Gate de carência (adr-162; multi-trigger per adr-166 item 4) ──

def fire_age_days(trigger, d, today):
    """(gateable, age_days|None) do trigger que disparou. age_days = idade do
    disparo em dias, git-derivada. Só file-exists e temporal são gateáveis no V1."""
    kind = trigger.get("kind")
    if kind == "adjacent-need" and trigger.get("condition", {}).get("kind") == "file-exists":
        path = trigger["condition"]["path"]
        try:
            out = subprocess.run(
                ["git", "log", "--diff-filter=A", "--format=%cs", "-1", "--", path],
                capture_output=True, text=True,
            )
            s = out.stdout.strip()
            if not s:
                return True, 0  # gateável, sem data git (path novo não-commitado) → idade 0
            fd = datetime.strptime(s, "%Y-%m-%d").date()
            return True, (today - fd).days
        except Exception:
            return True, None
    if kind == "temporal":
        try:
            dd = datetime.strptime(d.get("date", ""), "%Y-%m-%d").date()
            fire = dd + timedelta(days=int(trigger["maxAgeDays"]))
            return True, (today - fire).days
        except Exception:
            return True, None
    return False, None  # warn-only no V1


# ── Loop de avaliação ──

def evaluate_all(defs, *, today=None, gate_enabled=False, grace_days=GRACE_DAYS,
                 predicates_loader=load_predicates, exporter=cue_export_expr):
    """Avalia todos os defs open. Retorna (triggered_count, output_lines,
    gate_blocking, exit_code). Malformação → MalformedTriggerError sobe."""
    if today is None:
        today = date.today()

    # Registry carregado lazy: só quando algum structural-predicate existe.
    predicates = None
    needs_predicates = any(
        t.get("kind") == "structural-predicate"
        for d in defs.values() if d.get("status") == "open"
        for t in d.get("triggers", [])
    )
    if needs_predicates:
        try:
            predicates = predicates_loader()
        except MalformedTriggerError:
            raise
        except Exception as e:
            raise MalformedTriggerError(f"registry dd-predicates não carregável: {e}")

    triggered_count = 0
    output_lines = []
    gate_blocking = []

    for def_id, d in defs.items():
        status = d.get("status", "")
        if status != "open":
            print(f"  SKIP {def_id} (status={status})")
            continue

        print(f"  EVAL {def_id}: {d.get('title', '')[:80]}")
        triggers = d.get("triggers", [])
        fired = False
        fired_condition = None

        for i, trigger in enumerate(triggers):
            kind = trigger["kind"]
            if kind == "recurrence":
                ok, msg = evaluate_recurrence(trigger)
            elif kind == "adjacent-need":
                ok, msg = evaluate_adjacent_need(trigger)
            elif kind == "volume-threshold":
                ok, msg = evaluate_volume_threshold(trigger)
            elif kind == "temporal":
                ok, msg = evaluate_temporal(trigger, d.get("date", ""), today)
            elif kind == "manual-review":
                ok, msg = evaluate_manual_review(trigger)
            elif kind == "file-content-occurrence-count":
                ok, msg = evaluate_file_content_occurrence_count(trigger)
            elif kind == "structural-predicate":
                ok, msg = evaluate_structural_predicate(trigger, predicates, exporter)
            else:
                ok, msg = False, f"unknown kind: {kind}"

            marker = "FIRED" if ok else "..."
            print(f"    trigger[{i}] {kind}: {marker} {msg}")

            if ok:
                if not fired:
                    fired = True
                    fired_condition = msg
                # Gate avaliado para TODO trigger disparado (adr-166 item 4),
                # não apenas o primeiro — warn-only anterior não esconde
                # trigger gateável.
                gateable, age = fire_age_days(trigger, d, today)
                if gateable and age is not None and age > grace_days:
                    gate_blocking.append((def_id, d.get("title", ""), age, msg))
                    print(f"    -> BEYOND GRACE: fired {age}d ago > {grace_days}d (gateable)")
                elif gateable and age is not None:
                    print(f"    -> within grace: fired {age}d ago <= {grace_days}d")
                elif not gateable:
                    print(f"    -> warn-only (kind not gateable in V1)")

        if fired:
            triggered_count += 1
            title = d.get("title", "")
            line = f"::warning title=Deferred Trigger Fired::{def_id}: {title} | condition: {fired_condition}"
            output_lines.append(line)
            print(line)  # GitHub Actions annotation

    # dedupe gate_blocking por def (múltiplos triggers gateáveis do mesmo def)
    seen = set()
    deduped = []
    for entry in gate_blocking:
        if entry[0] not in seen:
            seen.add(entry[0])
            deduped.append(entry)
    gate_blocking = deduped

    exit_code = 0
    if gate_blocking and gate_enabled:
        exit_code = 1
    return triggered_count, output_lines, gate_blocking, exit_code


def main():
    json_data = subprocess.check_output(
        ["cue", "export", f"./{DEFERRED_DIR}/", "--out", "json"], text=True,
    )
    data = json.loads(json_data)
    defs = discover_defs(data)
    fs_sanity_check(defs)

    gate_enabled = os.environ.get("DD_GATE_ENABLED", "") not in ("", "0", "false", "False", "no")

    try:
        triggered_count, output_lines, gate_blocking, exit_code = evaluate_all(
            defs, gate_enabled=gate_enabled,
        )
    except MalformedTriggerError as e:
        print(f"::error title=Malformed Deferred Trigger::{e}")
        print("Trigger/predicado malformado NUNCA degrada para count 0 (adr-166).")
        return 1

    # ── Summary ──
    print(f"\nDeferred-trigger evaluation complete. {triggered_count} of {len(defs)} fired.")
    if triggered_count > 0:
        print("Founder should review fired def-XXX and update status (open → triggered)")
        print("by editing the corresponding architecture/deferred-decisions/def-*.cue file.")

    gh_summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if gh_summary and triggered_count > 0:
        with open(gh_summary, "a") as f:
            f.write(f"## Deferred-trigger evaluation\n\n")
            f.write(f"{triggered_count} of {len(defs)} deferrals had a trigger fire:\n\n")
            for line in output_lines:
                f.write(f"- {line}\n")

    # ── Gate (adr-162) ── advisory por default; bloqueante só com DD_GATE_ENABLED.
    if gate_blocking:
        print(f"\n{len(gate_blocking)} def(s) open com trigger gateável disparado ALÉM da carência de {GRACE_DAYS}d:")
        for def_id, title, age, cond in gate_blocking:
            print(f"::error title=Deferred Decision Beyond Grace::{def_id}: {title} | fired {age}d ago > {GRACE_DAYS}d grace | {cond}")
        if gate_enabled:
            print(f"\nGATE ENABLED (DD_GATE_ENABLED): blocking CI. Aja sobre os {len(gate_blocking)} def(s) acima")
            print("(resolver / triggered / withdrawn / re-adiar) para destravar.")
            return 1
        print("\nGATE INSTALLED BUT OFF (DD_GATE_ENABLED unset): advisory apenas.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
