package self_reviews

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
