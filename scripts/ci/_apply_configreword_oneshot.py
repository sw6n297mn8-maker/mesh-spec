#!/usr/bin/env python3
"""
_apply_configreword_oneshot.py — Commit B (adr-090 c7): reword dos 10 paths
.cue concretos AUSENTES (grupos B/C/D) no governance/readme/config.cue, virando
narrativa "(planejado)" — deixam de ser claims de arquivo existente.

Cada substituicao exige match EXATO e UNICO (count==1); se qualquer find nao
casar exatamente 1x, aborta SEM escrever (evita clobber). Edita so dentro de
sections[].content (markdown). Preserva templates ({...}/*) e o
shared-schemas/spec-gap-event.cue (plannedIn via WI-128). Idempotente: se
nenhum dos 10 paths existe mais, no-op.
"""
import os, sys

CFG = "governance/readme/config.cue"
BT = chr(96)  # backtick

# (find, replace) — finds verbatim do config (subagente). Tabela + prosa.
EDITS = [
    # tabela "Mapeamento: Niveis de Abstracao -> Arquivos no Repo"
    ("| — | Threat modeling | contexts/{bc-code}/threat-model.cue + governance/red-team-protocol.cue |",
     "| — | Threat modeling | contexts/{bc-code}/threat-model.cue + protocolo de red-team (planejado) |"),
    ("| — | Acumulação informacional | strategic/informational-flywheel.cue |",
     "| — | Acumulação informacional | flywheel informacional (planejado) |"),
    ("| — | Ciclo de aprendizado | governance/spec-gap-protocol.cue + architecture/shared-schemas/spec-gap-event.cue |",
     "| — | Ciclo de aprendizado | protocolo de spec-gap (planejado) + architecture/shared-schemas/spec-gap-event.cue |"),
    ("| 12 | Infra | architecture/infrastructure.cue, database-strategy.cue, security.cue |",
     "| 12 | Infra | infraestrutura (planejado), database-strategy.cue, security.cue |"),
    ("| — | Testabilidade | contexts/{bc-code}/test-specs.cue + architecture/testing-strategy.cue + governance/validation-protocol.cue |",
     "| — | Testabilidade | contexts/{bc-code}/test-specs.cue + estratégia de testes global (planejada) + protocolo de validação (planejado) |"),
    ("| — | Observabilidade | contexts/{bc-code}/observability.cue + architecture/observability-strategy.cue |",
     "| — | Observabilidade | contexts/{bc-code}/observability.cue + estratégia de observabilidade global (planejada) |"),
    ("| — | Evolução de eventos | contexts/{bc-code}/schemas/_migrations/ + architecture/event-evolution.cue |",
     "| — | Evolução de eventos | contexts/{bc-code}/schemas/_migrations/ + regras de evolução de eventos (planejado) |"),
    ("| — | Recovery / Compensation | contexts/{bc-code}/failure-modes.cue + workflows/*.cue + architecture/compensation-patterns.cue |",
     "| — | Recovery / Compensation | contexts/{bc-code}/failure-modes.cue + workflows/*.cue + patterns de compensação globais (planejado) |"),
    # prosa (paths em backticks)
    ("mecanismo de priorização — vive em %sgovernance/spec-gap-protocol.cue%s." % (BT, BT),
     "mecanismo de priorização — será definido no protocolo de spec-gap (planejado)."),
    ("vive em %sarchitecture/testing-strategy.cue%s. O protocolo de execução" % (BT, BT),
     "será definida na estratégia de testes global (planejada). O protocolo de execução"),
    ("como validar antes de merge — vive em %sgovernance/validation-protocol.cue%s." % (BT, BT),
     "como validar antes de merge — será definido no protocolo de validação (planejado)."),
    ("SLOs por tier de BC — vive em %sarchitecture/observability-strategy.cue%s." % (BT, BT),
     "SLOs por tier de BC — será definida na estratégia de observabilidade global (planejada)."),
    ("notificados de deprecastão — vivem em %sarchitecture/event-evolution.cue%s." % (BT, BT),
     "notificados de deprecastão — serão definidas nas regras globais de evolução de eventos (planejado)."),
    ("como toda saga se comporta sob falha vivem em %sarchitecture/compensation-patterns.cue%s." % (BT, BT),
     "como toda saga se comporta sob falha serão definidos nos patterns de compensação globais (planejado)."),
    ("O ciclo completo vive em %sai-orchestration/agent-lifecycle.cue%s e cobre:" % (BT, BT),
     "O ciclo completo (planejado) cobre:"),
]

PHANTOMS = [
    "governance/red-team-protocol.cue", "governance/spec-gap-protocol.cue",
    "governance/validation-protocol.cue", "architecture/infrastructure.cue",
    "architecture/testing-strategy.cue", "architecture/observability-strategy.cue",
    "architecture/event-evolution.cue", "architecture/compensation-patterns.cue",
    "ai-orchestration/agent-lifecycle.cue", "strategic/informational-flywheel.cue",
]


def main():
    t = open(CFG).read()
    if not any(p in t for p in PHANTOMS):
        print("nenhum dos 10 paths presente; nada a fazer (idempotente).")
        return 0
    errs = []
    for find, repl in EDITS:
        n = t.count(find)
        if n != 1:
            errs.append("find casa %dx (esperado 1): %r" % (n, find[:70]))
    if errs:
        sys.exit("ABORTANDO sem escrever — finds nao-unicos:\n  " + "\n  ".join(errs))
    for find, repl in EDITS:
        t = t.replace(find, repl, 1)
    left = [p for p in PHANTOMS if p in t]
    if left:
        sys.exit("ABORTANDO — paths ainda presentes apos reword: %s" % left)
    open(CFG, "w").write(t)
    print("config.cue: 14 rewords aplicados; 10 paths concretos removidos.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
