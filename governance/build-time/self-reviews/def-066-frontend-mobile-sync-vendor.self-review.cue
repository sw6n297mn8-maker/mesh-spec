package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def066FrontendMobileSyncVendor: build_time.#SelfReviewReport & {
	reportId: "srr-def-066-frontend-mobile-sync-vendor"

	artifactPath:       "architecture/deferred-decisions/def-066-frontend-mobile-sync-vendor.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-23"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do def-066 NOVO (open, low/cross-artifact), sucessor de adr-159: defere o vendor de
			sync mobile offline (o motor que implementa FF-FE-07).

			[tq-def-01 trade-off próprio]: PASS. deferralRationale específico — nenhuma tela de captura existe, logo
			não há padrão de dado de campo contra o qual escolher/validar o motor; cravar agora pinaria um modelo de
			conflito sem caso. Substituir a peça (ex.: design system) quebra o rationale — não copiado de def-060.

			[tq-def-02/03 trigger]: PASS. manual-review com reason ≥40; triggerCalibrationRationale justifica
			manual-only (vendor vive no frontend-runtime, invisível ao runner — precedente def-060/def-043). Runner
			skipa manual-review → sem disparo espúrio (confirmado: evaluate-deferred-triggers não disparou def-066).

			[tq-def-04 custo-escopo]: PASS. low (FF-FE-07 é lei; nenhuma tela offline antes do runtime) + cross-artifact
			(camada mobile + contrato de sync), não o low+repo-wide que o schema flaga.

			[uq-02/03/08]: PASS. uq-02 quebra na substituição (FF-FE-07, P2, frontend-runtime). originatingArtifacts
			[adr-159, def-060] existem. cue vet limpo; shape open (sem triggeredAt/resolvedBy/withdrawalRationale).
			"""
	}]

	findings: {}

	summary: """
		def-066 NOVO (open, low/cross-artifact), sucessor per-peça de adr-159, defere o vendor de sync mobile offline
		(motor de FF-FE-07). deferralRationale próprio: sem tela de captura, não há padrão de dado de campo contra o
		qual escolher o motor — cravar agora é retrabalho. Trigger manual-review justificado (vendor no runtime,
		invisível ao runner — precedente def-060/def-043). Self-review, 1 round.

		VEREDITO: 0 fail / 0 warn / 0 info. tq-def-01..04 satisfeitos (trade-off próprio não copiado de def-060;
		trigger codificado e manual-only legítimo; low+cross-artifact coerente); uq-02 quebra na substituição;
		originatingArtifacts resolvem; cue vet limpo (shape open). Estável em 1 round.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque os eixos do def-066 foram exercitados inteiros contra o disco: o trade-off é
		específico da peça-sync (padrão de dado de campo inexistente, não o motivo de outra peça — passa o teste de
		substituição de tq-def-01); o trigger manual-only é a consequência lógica de o vendor viver no frontend-runtime
		(invisível ao runner, precedente def-060/def-043 verificado), e o runner de fato não o disparou; low+cross-artifact
		é coerente (FF-FE-07 é lei → low; impacto na sub-camada mobile → cross-artifact); originatingArtifacts [adr-159,
		def-060] existem; cue vet confirma o shape open. Sem gap fail/warn-ancorável — nada a corrigir-e-rerodar.
		"""
}
