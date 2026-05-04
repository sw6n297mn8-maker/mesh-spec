package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bdgGlossary: build_time.#SelfReviewReport & {
	reportId: "srr-bdg-glossary"

	artifactPath:       "contexts/bdg/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-04"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Glossário BDG materializado via subagent-drafted dispatch (disp-005) — primeiro sucesso pós-WI-069 PG-tension-entry validando rollout extension de adr-074 para non-PG type. PG glossary aplicado section-by-section pelo subagent. Glossary tem 15 terms organizados em torno do conceito-âncora Cobertura Orçamentária e seu mecanismo Gate de Cobertura: 1 entity (Centro de Custo), 3 values (Saldo Disponível, Limite de Centro de Custo, Comprometimento Orçamentário), 4 rules (Cobertura Orçamentária, Alçada, Gate de Cobertura, Fracionamento), 2 processes (Aprovação Orçamentária, Liberação de Comprometimento), 2 commands (Aprovar/Rejeitar Cobertura Orçamentária), 3 events (BudgetApproved, BudgetRejected, BudgetCommitmentReleased). Auto-checks tq-gl-XX todos PASSED (unicidade code/name/termEn em 15/15/15; 47 relatedTerms refs resolvidas; antiTerms tq-gl-06 clean; tq-gl-09 anchor coverage ≥1 anchor por term; tq-gl-11 termEn semanticamente adequado). Hardening per PG glossary: tq-gg-01 unicidade enforced, tq-gg-02 anchor ≥1 enforced (warn→fail), tq-gg-03 definition non-redundant enforced (warn→fail), tq-gg-04 rejectedAlternatives substantive em 6 terms onde seleção foi não-trivial. Founder review pre-commit aplicou: (1) decisões substantivas nos 7 priority items do subagent reasoning report (Fracionamento keep como rule; Centro de Custo keep como entity; Alçada termEn loanword; Liberação termEn verboso 'Budget Commitment Release'; +1 term BudgetCommitmentReleased event; queries não modeladas; identificação de centro de custo embutida na definition); (2) 3 ciclos de red team com correções (Centro de Custo scope clarification, Alçada definition 'agente'→'ator', Encargo antiTerm clarification, Teto Orçamentário rejection tightening, Reserva Orçamentária rejection enrichment, examples adicionados a term-cobertura + term-budget-rejected, definition de cobertura refatorada para (a)/(b) explicit structure); (3) adequação BR validated (vocabulário canônico brasileiro de controladoria respeitado, anti-terms cobrem confusões típicas BR, loanwords mantidos com critério); (4) fix mecânico cue vet pre-commit: termEn 'Alçada'→'Alcada' (ASCII variant per schema #Glossary regex; pattern paralelo a 'açaí'→'acai' em APIs internacionais; spirit do loanword preservado, com nota explícita no rationale). domainModelRefs ficam vazios pendente de materialização do domain-model.cue de BDG. cue vet ./contexts/bdg/ EXIT=0; CI self-review-check local PASSED."
	}]

	findings: {}

	summary: "Glossário BDG: 15 terms via subagent dispatch (disp-005, primeiro sucesso non-PG pós-WI-069). PG glossary aplicado; tq-gl-* + tq-gg-* todos PASSED. Founder review pre-commit aplicou 3 layers de ajuste: priority items, 3 red-team cycles, fix mecânico ASCII em termEn 'Alcada'."

	singleRoundRationale: "Subagent dispatch successful + founder substantial review in 3 layers (priority items + red team cycles + ASCII fix) + auto-checks passed. Round único suficiente."
}
