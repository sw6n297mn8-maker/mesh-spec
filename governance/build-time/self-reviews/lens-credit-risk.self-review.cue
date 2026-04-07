package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensCreditRisk: build_time.#SelfReviewReport & {
	reportId: "srr-lens-credit-risk"

	artifactPath:       "architecture/lenses/lens-credit-risk.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 1 avaliou lente completa (trigger + 19 concepts + 17 reasoning steps + 3 examples + 5 principleIds + 6 relatedLenses + 4 limitations). uq-01 pass: rationales explicam WHY. uq-02 pass: meshManifestation ancorado em construção civil, FIDC, registradora, Resolução 2.682, cessão, coobrigação, duplicata, recuperação judicial, HHI, RAROC, PSI, roll rates. uq-03 warn: principleIds todos existem; sc-multi-tier-propagation, sc-operational-financial-transmission e cas-nonlinearity-tipping existem; rs-brazil-financial-regime NÃO existe em lens-regulatory-strategy (conceitos existentes: rs-legal-capital, rs-regulatory-map, etc.); 1 de 6 relatedLenses (lens-financial-intermediation) é forward reference. uq-04 pass. uq-05 pass: 4 limitações declaradas. uq-06 pass: PD, LGD, EAD, EL, UL, RAROC, HHI usados consistentemente. uq-07 pass. uq-08 pass. tq-ln-01 pass: 9 condições testáveis, 4 excludeWhen. tq-ln-02 pass: 17 reasoning steps específicos cobrindo toda a cadeia de análise. tq-ln-03 pass: 3 exemplos concretos. tq-ln-04 pass: 4 limitações reais com alternativas."
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary:   "Round 2 (adr-043 Fase 1 backfill batch 2): adicionado campo verticalApplicability ao lens. Classificação: vertical-adaptable, primaryVertical=construction. Análise estrutural confirmou que construção está embebida nos próprios conceitos (cr-operational-transmission via 'queda de pedidos, atraso em confirmação de entrega, parada de canteiro'; vintage analysis via ciclo de projeto; dilution risk via padrões de glosa). A própria seção limitations da lens autodeclara que reuso em outras verticais 'exige reconstruir a camada causal em vez de reaproveitar a da construção' — confirmação textual de adaptable, não agnostic. tq-ln-05 (novo critério warn em lens.cue) pass: campo presente, mode coerente com evidência estrutural, rationale explícito. Hipótese a priori (adaptable) confirmada com precisão acima do esperado. Warn pré-existente uq-03 mantido (não relacionado a este round)."
	}]

	findings: {
		warn: [{
			criterionId: "uq-03"
			severity:  "warn"
			message:   "crossDependsOn em cr-regulatory-provisioning referencia rs-brazil-financial-regime em lens-regulatory-strategy, mas esse conceptId não existe na lente. Conceitos existentes incluem rs-legal-capital, rs-regulatory-map, rs-licensing-strategy. Também: lens-financial-intermediation em relatedLenses é forward reference (arquivo não existe)."
		}]
	}

	summary: """
		Lente credit-risk completa com 19 conceitos (18 theoretical + 1
		operational monthly), trigger (9 condições, 32 keywords, 4 excludeWhen),
		17 reasoning steps, 3 meshExamples (buyer concentration, dilution dispute,
		operational leading indicator), 5 principleIds verificados, 6 relatedLenses
		e 4 limitations. Stable em 1 round. Warn (uq-03) por rs-brazil-financial-regime
		inexistente em lens-regulatory-strategy e 1 forward reference em relatedLenses.
		"""
}
