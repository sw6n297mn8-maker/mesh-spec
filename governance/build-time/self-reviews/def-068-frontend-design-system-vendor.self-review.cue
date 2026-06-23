package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def068FrontendDesignSystemVendor: build_time.#SelfReviewReport & {
	reportId: "srr-def-068-frontend-design-system-vendor"

	artifactPath:       "architecture/deferred-decisions/def-068-frontend-design-system-vendor.cue"
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
			Round 1 — self-review do def-068 NOVO (open, low/cross-artifact), sucessor de adr-159: defere o vendor de
			design system visual (tokens, tipografia, marca) + specs de tela.

			[tq-def-01 trade-off próprio]: PASS. deferralRationale específico — a tela de override precisa de
			COMPONENTES (botão, form), NÃO da MARCA; identidade visual é porta-de-mão-dupla escolhida JIT na fatia da
			tela; cravar agora, antes de existir tela e antes de a marca estar definida, é retrabalho. Distinto das
			peças sync/orquestração — não copiado de def-060.

			[tq-def-02/03 trigger]: PASS. manual-review com reason ≥40; triggerCalibrationRationale justifica
			manual-only (escolha JIT no frontend-runtime, invisível ao runner — precedente def-060). Runner skipa →
			sem disparo espúrio (confirmado: evaluate-deferred-triggers não disparou def-068).

			[tq-def-04 custo-escopo]: PASS. low (a capacidade de confirmação estruturada, Approval-as-Confirmation, é
			lei; nenhuma tela antes do runtime) + cross-artifact (camada de apresentação — todas as telas a vestir),
			não local nem low+repo-wide.

			[uq-02/03/08]: PASS. uq-02 quebra na substituição (Approval-as-Confirmation/P10, P2, frontend-runtime).
			originatingArtifacts [adr-159, def-060] existem. cue vet limpo; shape open.
			"""
	}]

	findings: {}

	summary: """
		def-068 NOVO (open, low/cross-artifact), sucessor per-peça de adr-159, defere o vendor de design system visual
		(tokens, tipografia, marca) + specs de tela. deferralRationale próprio: a tela precisa de COMPONENTES, não da
		MARCA — o design system de partida é porta-de-mão-dupla escolhida JIT. Trigger manual-review justificado
		(escolha JIT no runtime). Self-review, 1 round.

		VEREDITO: 0 fail / 0 warn / 0 info. tq-def-01..04 satisfeitos (trade-off próprio componentes≠marca;
		manual-only legítimo; low+cross-artifact — apresentação multi-tela, não local); uq-02 quebra na substituição
		(Approval-as-Confirmation/P10); refs resolvem; cue vet limpo. Estável em 1 round.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque os eixos do def-068 foram exercitados contra o disco: o trade-off é específico
		da peça-design (componentes≠marca; o design de partida é mão-dupla — distinto do motivo de sync/orquestração,
		passa tq-def-01); o trigger manual-only segue de a escolha ser JIT no frontend-runtime (invisível ao runner,
		precedente def-060), e o runner não o disparou; low+cross-artifact é coerente (a capacidade de confirmação
		estruturada é lei → low; impacto na camada de apresentação que veste todas as telas → cross-artifact, não
		local); originatingArtifacts [adr-159, def-060] existem; cue vet confirma o shape open. Sem gap
		fail/warn-ancorável — nada a corrigir-e-rerodar.
		"""
}
