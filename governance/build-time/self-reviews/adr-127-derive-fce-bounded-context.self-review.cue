package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr127: build_time.#SelfReviewReport & {
	reportId: "srr-adr-127"

	artifactPath:       "architecture/adrs/adr-127-derive-fce-bounded-context.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-127 documenta a derivação do BC FCE — primeira aplicação real
			de P13/adr-125. Registra os 3 testes de separação (linguagem
			ubíqua distinta: settlement/financialization/PrePaymentGuard/
			retention; invariante própria: P11 money-on-proof; ownership
			canônico: Payment state + authorization proof + PaymentSettled
			SoT) todos PASSED, o teste de remoção (projeção sobrevive/execução
			morre → perda de função, não acoplamento), e a classificação das 6
			relações cross-BC na ordem de preferência de P13 (fce↔rew ciclo
			tipado policy-execution-feedback; fce↔tcm par gate-acíclico via
			events-required filter adr-120; inv→fce/bkr→fce/fce→scf/fce→ato
			unidirecionais acíclicas com patterns confirmados). Decisões de
			escopo: Opção B budget (sem aggregate; Payment.commitmentRef→
			BudgetApproved); distinção BDG-compromete/FCE-realiza; imprecisão
			"budget allocation" em fce.cue:11 registrada em ten-013.
			tq-adr-01 PASSED: alternativas explicitadas e rejeitadas (merge
			FCE em CMT/INV — rejeitado por 3/3 testes + linguagem disjunta;
			aggregate BudgetAllocation no FCE — rejeitado por Opção B anti-
			anêmico + drift de linguagem com BDG). tq-adr-02 PASSED:
			reversibility=medium (fronteira de BC é redesign se desfeita, mas
			spec-level reversível), blastRadius=cross-cutting (FCE toca 6 BCs +
			context-map + é core). tq-adr-03/04 PASSED: plannedOutputs=[canvas,
			ten-013] criados como output direto. principlesApplied=[P13,P11,
			P10,P0]. cue vet ./contexts/fce/ EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		ADR-127 deriva o BC FCE via P13 (primeira aplicação real): 3 testes
		de separação 3/3 + teste de remoção PASSED + classificação das 6
		relações cross-BC. Opção B budget; ten-013 para imprecisão do
		subdomain. plannedOutputs canvas + tension. cue vet EXIT=0.
		"""

	singleRoundRationale: """
		O conteúdo da derivação (S1 boundary-derivation) passou por founder
		gate dedicado durante authoring do canvas; este ADR é o registro
		canônico (Opção i — derivação não vira campo do canvas). Alternativas
		de fronteira (merge/aggregate) explicitadas e rejeitadas com os testes
		de P13. Round único suficiente.
		"""
}
