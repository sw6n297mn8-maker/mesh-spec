package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def086FrontendDesignSystemVendorAndTooling: build_time.#SelfReviewReport & {
	reportId: "srr-def-086-frontend-design-system-vendor-and-tooling"

	artifactPath:       "architecture/deferred-decisions/def-086-frontend-design-system-vendor-and-tooling.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-14"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Estabilização em round único porque o artefato é sucessor por forma
		PRECEDENTADA (adr-159: parent withdrawn + sucessor estreitado) com
		molde direto no próprio parent def-068 — o review consistiu em
		conferir, campo a campo, (a) o estreitamento de escopo contra o
		adr-194 dec 6 (SÓ vendor/component library/styling tooling/mecânica
		de promulgação; identidade explicitamente DECIDIDA e excluída);
		(b) tq-def-01: deferralRationale articula trade-off concreto e a
		MUDANÇA vs o parent (custo menor: a premissa 'antes de a marca estar
		definida' venceu; telas vivas rendem sem design system formal);
		(c) tq-def-02: trigger conforma #TriggerStrict no branch open
		(manual-review com reason ≥40 runes); (d) tq-def-04: low +
		cross-artifact coerentes com o escopo de camada de apresentação;
		(e) uq-03: originatingArtifacts (adr-194 + def-068) existem no
		working tree; input Mesh-Old §2.9 preservado como leitura sem
		decisão; (f) numeração def-086 confirmada pelo freshness gate
		(--assert def=086, G2 ok contra origin/main).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			1 warn consciente (tq-def-03): trigger manual-review-only. A
			articulação do porquê manual-only vive em
			triggerCalibrationRationale ('repo externo, invisível ao grep' —
			a condição de revisita acontece no mesh-frontend-runtime), mesmo
			shape aceito nos irmãos def-066/067/068; o warn permanece
			registrado, não silenciado. cue vet ✓ (união discriminada open +
			#TriggerStrict); runner de triggers avalia e SKIPa manual-review
			como esperado.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a condição real de revisita (fatia de tela do frontend-runtime adotando component library/styling tooling sob o token-contract) é fato de repo externo, não-machine-evaluable pelo runner do mesh-spec."
			rationale:   "Warn aceito com precedente direto (def-060/066/067/068, mesma classe de condição cross-repo); justificativa articulada em triggerCalibrationRationale."
		}]
	}

	summary: """
		def-086, sucessor estreitado do def-068 pela forma adr-159 executada
		no adr-194 dec 6: fica deferido apenas o lado TECNOLOGIA (vendor,
		component library, styling tooling, mecânica de promulgação); a
		identidade (tokens/tipografia/marca) está decidida na Constituição e
		saiu do deferimento. Round único com conferência campo a campo contra
		o molde def-068 e o adr-194; warn tq-def-03 (manual-only) registrado
		com precedente. Par do commit: def-068 → withdrawn com
		withdrawalRationale apontando adr-194 + def-086 (SRR do def-068 já
		existente cobre o artifactPath; a edição de status é a executada pela
		decisão do adr-194).
		"""
}
