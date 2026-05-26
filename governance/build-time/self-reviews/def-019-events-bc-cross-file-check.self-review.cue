package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def019EventsBcCrossFileCheck: build_time.#SelfReviewReport & {
	reportId: "srr-def-019-events-bc-cross-file-check"

	artifactPath:       "architecture/deferred-decisions/def-019-events-bc-cross-file-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			def-019 defere o check cross-file events↔BC. Diagnóstico AFIADO após
			investigação posterior a adr-103. Aprovado pelo founder.

			Conformancia #DeferredDecision:
			- description: PASS (autorar cross-file-id-exists para events do context-map
			  contra domain-model.events[].name).
			- deferralRationale: PASS — CORRIGIDO: events ESTÃO materializados
			  (domain-model.events[]); o bloqueio real é VOCABULÁRIO inconsistente entre
			  artefatos (context-map PascalCase vs domain-models misturando PascalCase e
			  prosa-com-espaços; nomes divergem: IdentityVerificationCompleted vs
			  IdentityVerified). Mesmo built↔built, 7/16 não casam por nome. Gatear agora
			  = ruído, não sinal.
			- triggerCalibrationRationale: PASS (manual-review porque o pré-requisito é
			  canonização de vocabulário — decisão de domínio, não machine-evaluable).
			- originatingArtifacts: PASS (adr-103 + adr-102).
			- costOfDeferral: severity low + blastRadius cross-artifact, não-cumulativo.
			- triggers: 1 manual-review com reason. status open.

			Anti-catch-all (adr-062): deferimento genuíno com trade-off articulado e
			condição de revisita (canonização do vocabulário de events). O achado em si
			(vocabulário inconsistente) é drift real do audit, endereçável por domínio.

			Verificacao: cue vet ./... EXIT 0; protótipo (refs context-map vs
			domain-model.events[].name) → 34/44 não casam por nome; built↔built 7/16,
			todos por divergência de nome (não ausência) — confirma o diagnóstico.
			"""
	}]

	findings: {}

	summary: """
		def-019: deferimento consciente do check events↔BC. Diagnóstico corrigido —
		events ESTÃO materializados (domain-model.events[]); o bloqueio é vocabulário
		de events inconsistente entre context-map e domain-models (convenções e nomes
		divergem). Pré-requisito = canonização de vocabulário (domínio), não kind nem
		materialização. Trigger manual-review. Conforma #DeferredDecision; sem findings.
		"""

	singleRoundRationale: """
		Uma rodada basta: deferred-decision de registro de trade-off + trigger, cujo
		diagnóstico (vocabulário de events inconsistente) foi verificado empiricamente
		por protótipo e cuja estrutura conforma #DeferredDecision (cue vet 0). Sem
		espaco de decisao aberto a red-team.
		"""
}
