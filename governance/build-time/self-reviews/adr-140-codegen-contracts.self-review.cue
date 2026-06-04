package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr140: build_time.#SelfReviewReport & {
	reportId: "srr-adr-140-codegen-contracts"

	artifactPath:       "architecture/adrs/adr-140-codegen-contracts.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-04"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-140 (contrato de codegen: CUE SoT, derivados duráveis, ContractGate)
			executado por SUB-AGENTE ISOLADO (per quality-gate executionPolicy rollout: adr →
			isolated-subagent), sem acesso ao histórico da sessão de autoria. Avaliado contra 9
			universalCriteria (uq-01..09) + tq-adr-01..04. Resultado: ZERO findings fail/warn.

			uq-01 (WHY): rationale explica por que CUE é a única opção que honra P1+P2 simultaneamente,
			e por que P0 não é tensionado (substituição condicional, não coexistência). Pass.
			uq-02 (Mesh): substituição "qualquer fintech" quebra — 3 SoTs (P0), 5 Ports/P7, Ion-4
			decimal↔determinismo financeiro (dp-04), agente-recomenda/gate-valida (P10), CMT
			inv-mutual-bilateral-acceptance, real-options/keystone-first (adr-138/139). Pass.
			uq-03 (refs): subagente verificou no filesystem — governance/wave-plan.cue existe e WI-102
			lista adr-140 + def-040 + def-049; def-040/def-049 existem (coerência bidirecional via
			originatingArtifacts); principlesApplied P0/P1/P2/P10/P12 em design-principles.cue +
			dp-04/dp-07 em domain-definition.cue, todos existentes. adr-141 e codegen-contract.cue são
			forward-refs (planned), não tratados como existentes. Pass.
			uq-04 (princípios): materialização direta de P1; reconcilia P0/P2/P10 sem contradição
			não-documentada. Pass.
			uq-05 (limitações): N1..N4 + falsificationCondition declaram shadow-SoT, curva CUE, gaps
			CUE→Proto, assertion-to-test deferido. Pass (warn).
			uq-06 (ubiquitous language): SoT/codegen/derived artifact/ContractGate/Ion-1..4 consistentes. Pass.
			uq-07 (zero placeholder): nenhum TODO/TBD; deferrals têm alvos reais (def-040/def-049). Pass.
			uq-08 (conforma #ADR): status=proposed → supersededBy ausente (união discriminada); regex de
			id/date; enums decisionClass/reversibility/blastRadius; principlesApplied; falsificationCondition
			completa. cue vet ./... EXIT=0 confirmado pelo agente principal (subagente avaliou por inspeção;
			main rodou cue vet). Pass.
			uq-09 (section gates): N/A — subagente isolado não recebe transcript de autoria.
			tq-adr-01 (alternativas): 8 alternativas (a)-(h) com motivo de rejeição concreto (acoplamento
			transport, vendor no domínio, ausência de canonical form, quebra de keystone-first). Pass.
			tq-adr-02 (risk metadata): medium + cross-cutting coerentes — toca contratos de todos os BCs
			(≠ local); reversível via promoção .proto documentada (≠ low/irreversível). Pass.
			tq-adr-03 (paths reais): affectedArtifacts governance/wave-plan.cue existe. Pass.
			tq-adr-04 (rastreabilidade ≥1): affectedArtifacts (1) + plannedOutputs (2) non-empty. Pass.

			1 observação advisory (info, NÃO finding — nenhum critério é info-severity): FF-04/FF-CG-03
			aparecem só em prosa (sem fitness-function registry no repo ainda); não são refs quebradas
			(não em campo estruturado; adr-140 estabelece o contrato que esses gates implementarão
			downstream em WI-134). Quando WI-134 materializar, ancorar os nomes num registry.
			"""
	}]

	findings: {}

	summary: """
		adr-140 cristaliza o contrato de codegen (CUE como SoT único → tipos/validadores/stubs;
		pipeline multi-target via .proto durável; Ion + 4 Regras; compat 3-camadas; ContractGate
		determinístico; #Assertion como artifact-class; exit strategy preservando P0; slice HTTP
		durável). Self-review por SUB-AGENTE ISOLADO (rollout adr→isolated-subagent): zero findings
		nos 13 critérios, cross-file verificado (WI-102 outputs, def-040/def-049, principleIds),
		uq-02 strong pass. cue vet ./... EXIT=0 (agente principal). 1 observação advisory (FF-04/
		FF-CG-03 sem registry — downstream WI-134). Estável em 1 round.
		"""

	singleRoundRationale: """
		A decisão passou por 3 gates founder-facing (scaffold+classificação; context+decision+
		alternativas; consequences+rationale+traceability); este é o self-review de CONFORMIDADE,
		executado por subagente isolado para remover viés de auto-ratificação. Critérios verificáveis
		por inspeção direta (cue vet EXIT=0, paths no filesystem, IDs reais de princípios, coerência
		com WI-102) — zero findings, sem ambiguidade que rounds adicionais resolveriam.
		"""
}
