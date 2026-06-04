package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr143: build_time.#SelfReviewReport & {
	reportId: "srr-adr-143-cmt-dispute-orchestration"

	artifactPath:       "architecture/adrs/adr-143-cmt-dispute-orchestration.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-03"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-143 (orquestração de disputa no CMT: enum local + revalidação CTR +
			supervisão) por SUB-AGENTE ISOLADO (per quality-gate executionPolicy rollout: adr →
			isolated-subagent), sem acesso ao histórico da sessão de autoria. Avaliado contra 9
			universalCriteria + tq-adr-01..04. 1 finding fail: uq-03 — defersTo:["def-047","def-048"]
			referencia #DeferredDecision ainda inexistentes no disco (schema diz "deve resolver para
			def-XXX existente"). Todos os demais passaram, e o subagente CORROBOROU independentemente os
			pontos calibrados no gate: P7 invocado corretamente (value class / zero raw String no enum
			#DisputeResolution), P13 invocado corretamente (classificação ACL consumer downstream
			DRC→CMT), tq-adr-02 (low/cross-artifact coerentes — 4 artefatos CMT, carve-out de invariante,
			sem cross-BC), 7 alternativas (a)–(g) substantivas, uq-02 Mesh-specific. uq-09 N/A.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			findingEvaluation do uq-03 pelo main agent (verificação, não aplicação cega): finding
			factualmente correto sobre o snapshot de meio-de-autoria, mas NÃO é defeito do adr-143 — o
			padrão defersTo↔plannedOutputs para defs criados ATOMICAMENTE no mesmo commit é o idioma
			correto do adr-062, com precedente em adr-139 (def-037/038/039) e adr-142 (def-046). RESOLVIDO
			por completude de pacote: def-047-drc-dispute-resolution-canonicalization.cue e
			def-048-cmt-modify-terms-downstream-notification.cue autorados no mesmo pacote; cue vet ./...
			EXIT=0 com defersTo resolvido. 0 fail residual.
			"""
	}]

	findings: {}

	summary: """
		adr-143 fecha o contrato de orquestração de disputa do CMT (Fatia B): enum local fechado
		#DisputeResolution (ACL consumer, canonicalização DRC deferida a def-047), modify_terms revalida
		CTR fail-closed (nova invariante inv-dispute-modify-terms-revalidates-ctr + sc-cmt-09), maintain
		sobre suspended exige reativação supervisionada, e carve-out autoritativo de
		inv-mutual-bilateral-acceptance (SD1) documentado em ten-014. Self-review por SUB-AGENTE ISOLADO
		(rollout adr): 1 fail (uq-03, defersTo→def-047/048) resolvido por completude de pacote, 0
		residual. Estável em 2 rounds.
		"""
}
