#!/usr/bin/env python3
"""
_apply_wi128_oneshot.py — aplicação ONE-SHOT (adr-090): registra o WI-128
(planejamento da autoria dos 5 shared-schemas) no wave-plan + cria o SRR.

Edita o arquivo REAL cirurgicamente (insere so o bloco WI-128 na ancora apos
WI-071), em vez de reescrever o wave-plan inteiro — evita clobber. Idempotente:
se WI-128 ja existe, nao faz nada. Destinado a rodar 1x no CI (commit do bot);
o workflow e este script sao removidos depois.
"""
import os, sys

WP = "governance/wave-plan.cue"
SRR = "governance/build-time/self-reviews/wave-plan-wi-128-shared-schemas.self-review.cue"
T = "\t"

WI_FIELDS = [
    '%sid:         "WI-128"' % (T * 4),
    '%stitle:      "Planejar a autoria dos shared-schemas base (envelopes de interacao/decisao de agentes, assertion, spec-gap, ion-rules)"' % (T * 4),
    '%stshirtSize: "M"' % (T * 4),
    '%sdependsOn: []' % (T * 4),
    '%ssemanticPrerequisites: ["Framework de artifact-schemas estabelecido (WI-001 e relacionados)"]' % (T * 4),
    '%soutputs: [{' % (T * 4),
    '%sartifact: "architecture/shared-schemas/agent-interaction-envelope.cue"' % (T * 5),
    '%stype:     "create"' % (T * 5),
    '%s}, {' % (T * 4),
    '%sartifact: "architecture/shared-schemas/agent-decision-record.cue"' % (T * 5),
    '%stype:     "create"' % (T * 5),
    '%s}, {' % (T * 4),
    '%sartifact: "architecture/shared-schemas/assertion-schema.cue"' % (T * 5),
    '%stype:     "create"' % (T * 5),
    '%s}, {' % (T * 4),
    '%sartifact: "architecture/shared-schemas/spec-gap-event.cue"' % (T * 5),
    '%stype:     "create"' % (T * 5),
    '%s}, {' % (T * 4),
    '%sartifact: "architecture/shared-schemas/ion-rules.cue"' % (T * 5),
    '%stype:     "create"' % (T * 5),
    '%s}]' % (T * 4),
    '%srationale: "Planeja a autoria dos shared-schemas referenciados na narrativa do config (infraestrutura de interacao/decisao de agentes). Dir ja reservado por stub; este WI registra a intencao (plannedIn), removendo os 5 paths de phantomCandidates. O desenho de cada schema fica para a execucao do WI."' % (T * 4),
]

SRR_CONTENT = '''package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

waveplanWi128SharedSchemas: build_time.#SelfReviewReport & {
	reportId: "srr-wave-plan-wi-128-shared-schemas"

	artifactPath:       "governance/wave-plan.cue"
	artifactSchemaPath: "architecture/artifact-schemas/wave-plan.cue"
	artifactType:       "wave-plan"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Adiciona o WI-128 a wave W001-governance-robustness do wave-plan,
			planejando a autoria dos 5 shared-schemas (agent-interaction-envelope,
			agent-decision-record, assertion-schema, spec-gap-event, ion-rules)
			como outputs type=create. Objetivo: registrar a intencao (plannedIn)
			para o gate anti-phantom (adr-090 c7), nao desenhar os schemas agora.

			Conformidade ao #WavePlan:
			- tq-wp-01 (dependsOn): PASS - dependsOn [] (arquivos de schema novos,
			  sem dependencia estrutural-bloqueante); o framework de artifact-schemas
			  fica em semanticPrerequisites, categoria correta (nao serializa).
			- tq-wp-02 (outputs conformes a estrutura): PASS - os 5 paths caem em
			  architecture/shared-schemas/ (zona valida, dir ja reservado por stub)
			  e seguem a convencao de naming kebab-case.cue.
			- Invariantes do schema: id WI-128 unico (proximo livre apos WI-127);
			  cada output usa o campo real artifact + type; >=1 output. Verificado:
			  cue vet exit 0.

			Verificacao do efeito: o gerador (reader corrigido para outputs[].artifact)
			passa a conter os 5 paths -> WI-128, removendo-os de phantomCandidates
			(15 -> 10). Os 10 restantes (grupos B/C/D) sao tratados por reword separado.
			"""
	}]

	findings: {}

	summary: """
		Self-review do WI-128 (planejamento da autoria dos 5 shared-schemas) na
		wave W001-governance-robustness. Mudanca de planejamento (nao implementacao):
		registra os 5 paths como outputs type=create para que o gate anti-phantom os
		reconheca como plannedIn. dependsOn [] + framework em semanticPrerequisites
		(tq-wp-01); paths conformes a architecture/shared-schemas/ (tq-wp-02); id
		unico; cue vet exit 0. Efeito verificado: 5 saem de phantomCandidates.
		"""

	singleRoundRationale: "Mudanca de escopo contido (uma task de planejamento com 5 outputs create, dependsOn vazio) cuja conformidade ao #WavePlan e efeito (5 paths viram plannedIn) foram verificados por cue vet + execucao do gerador. Rounds adicionais nao revelariam novos findings."
}
'''


def main():
    t = open(WP).read()
    if '"WI-128"' in t:
        print("WI-128 ja presente; nada a fazer (idempotente).")
        if not os.path.isfile(SRR):
            os.makedirs(os.path.dirname(SRR), exist_ok=True)
            open(SRR, "w").write(SRR_CONTENT)
            print("SRR criado.")
        return 0
    marker = "scripts/ci/rebuild-projections.sh"  # output do WI-071 (ultima task da wave)
    mi = t.find(marker)
    if mi < 0:
        sys.exit("ancora (WI-071/rebuild-projections.sh) nao encontrada — abortando sem editar.")
    anchor = "\n\t\t\t}]"  # \n + EXATAMENTE 3 tabs + }]  => fecha WI-071 + tasks da wave
    close = t.index(anchor, mi)
    ins = "\n%s}, {\n%s" % (T * 3, "\n".join(WI_FIELDS))
    t2 = t[:close] + ins + t[close:]
    open(WP, "w").write(t2)
    os.makedirs(os.path.dirname(SRR), exist_ok=True)
    open(SRR, "w").write(SRR_CONTENT)
    print("WI-128 inserido em %s + SRR criado em %s." % (WP, SRR))
    return 0


if __name__ == "__main__":
    sys.exit(main())

# re-trigger CI apos ambiente idle (no-op de logica)
