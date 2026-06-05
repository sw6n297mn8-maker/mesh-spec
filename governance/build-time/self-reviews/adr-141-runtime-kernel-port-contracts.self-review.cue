package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr141: build_time.#SelfReviewReport & {
	reportId: "srr-adr-141-runtime-kernel-port-contracts"

	artifactPath:       "architecture/adrs/adr-141-runtime-kernel-port-contracts.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-04"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 3
		warnCount: 0
		infoCount: 3
		summary: """
			Round 1 do self-review por SUB-AGENTE ISOLADO (per quality-gate executionPolicy rollout: adr
			→ isolated-subagent), sem acesso ao histórico de autoria, sobre adr-141 (runtime kernel: 5
			Ports canônicos retornando PortResult<T>, value classes na fronteira, L3 PortManifest-como-SoT
			com interface Kotlin = projeção verificada, contract-tests dois tiers + reference adapter). 3
			fails:
			(a) uq-03 (referência cruzada): "WI-140" citado 3x (comentário de header + decision items 5 e
			8) como work item concreto que não existe em governance/wave-plan.cue nem em work-graph.cue —
			ilusão de rastreabilidade.
			(b) falsificationCondition (âncora): observableSignal ancorava em WI-136 (schema #GoldenExample,
			zero codegen) quando o sinal de falha do codegen vive no harness de WI-137 — âncora errada.
			(c) tq-adr-03 (triage): def-041..045 ausentes no filesystem — triado como falta-de-contexto
			same-arc (criados no mesmo commit do pacote), NÃO defeito de conteúdo; affectedArtifacts=[]
			torna tq-adr-03 N/A de qualquer modo.
			3 advisories (info, não-bloqueantes): A1 — o estreitamento de P1 (interface Kotlin
			hand-authored vs "código é gerado, nunca escrito manualmente") deve virar tension-entry
			explícita; A2 — reversibility=medium merece justificativa agregada (vendor-swap ALTA vs
			forma-do-kernel BAIXA); A3 — decisionClass structural vs foundational (avaliado).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 (re-review isolado pós-correção), 0 fail / 0 warn: (a) "WI-140" zerado repo-wide
			(grep = 0) — header e decision items 5/8 repassados para "adr-144 (e o work item futuro de seu
			arco)"; uq-03 limpa. (b) falsificationCondition re-ancorada em WI-137 (harness de
			codegen-validation), confirmada contra wave-plan (WI-136 = schema-only; WI-137 = harness). (c)
			tensão P0/P1 registrada nas 3 camadas exigidas pelo protocolo: tag [TENSÃO: ten-015 vs P1] no
			rationale + ten-015 conformante (tensionTarget=P1, manifestsIn→adr-141, resolution com
			alternativa escolhida e rejeitada, status=accepted, structuralResolutionPath populado). A2
			absorvida (sentença de reversibility agregada — "média honesta"); A3 mantida (structural,
			decisão do founder). Clean pass nos uq-01..09 + tq-adr-01..04. def-041..045 confirmados como
			same-arc (não-defeito).
			"""
	}]

	findings: {}

	summary: """
		adr-141 (runtime kernel spec-side: 5 Ports canônicos retornando PortResult<T>, value classes na
		fronteira, L3 PortManifest-como-SoT com interface Kotlin = projeção verificada, contract-tests
		dois tiers + reference adapter, vendor-of-record deferido a def-041..045). Passou por 3 gates
		founder-facing (PG-ADR: scaffold+classificação; context+decision+alternativas;
		consequences+rationale+traceability) + 2 rounds de self-review por SUB-AGENTE ISOLADO. O gate
		isolado pegou 2 defeitos reais (uq-03 — ref WI-140 inexistente; falsification ancorada em WI-136
		em vez do harness WI-137) e forçou o registro da tensão P1↔interface-hand-authored em ten-015 (3
		camadas). Fechado clean em round 2 (0 fail / 0 warn). def-041..045 ausentes no round 1 =
		same-arc (criados no mesmo commit), não defeito.
		"""
}
