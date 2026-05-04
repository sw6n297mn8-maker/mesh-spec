package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bdgDomainModel: build_time.#SelfReviewReport & {
	reportId: "srr-bdg-domain-model"

	artifactPath:       "contexts/bdg/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

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
		summary:   "Domain Model BDG materializado via subagent-drafted dispatch (disp-006) — segundo non-PG type successful pós-WI-069 PG-tension-entry e disp-005 glossary BDG. PG domain-model aplicado section-by-section pelo subagent. Estrutura: 1 aggregate central (agg-cost-center) com 1 entity nested (ent-budget-commitment), 7 invariants protegidos, 7 value objects, 4 events (3 published spine/parallel + 1 internal ACL CommitmentAcceptedReceived), 3 commands (ApproveBudget canvas inbound + RejectBudget canvas inbound + ReleaseBudgetCommitment anchor pré-oq-bdg-2), 1 policy (CommitmentAccepted→ApproveBudget choreography), 2 projections (BudgetApprovalStatus + CostCenterAvailability matching canvas query-surfaces). Aggregate sem lifecycle por design (per tq-dmg-07 stateless aggregate test): persiste registry de Comprometimentos ativos como uniqueness registry + ledger de reservas; lifecycle do próprio Centro de Custo é governance externa per bd-allocation-not-treasury. Glossary alignment: 14/15 terms mapeados explicitamente; term-fracionamento NÃO modelado como invariant local (aguarda oq-bdg-1 — agregação cross-BC com REW). Lenses aplicadas: lens-organizational-resource-allocation (primária — Centro de Custo como unidade canônica de allocation; ora-delegation-fitness para Alçada; ora-strategic-neglect para bd-allocation-not-treasury) + lens-event-driven-architecture-patterns (secundária — eda-domain-vs-integration-events para published events, eda-cqrs para projections, eda-event-sourcing implícito sustenta cap-04 audit, eda-choreography-vs-orchestration para policy). 7 invariants cobrem 4 businessDecisions (bd-coverage-as-invariant, bd-commitment-not-payment, bd-cost-center-as-sot, bd-allocation-not-treasury) + 1 autonomousDecision (evaluate-alcada-deterministic) + 2 estruturais (released-amount-matches-commitment, commitment-id-uniqueness-per-cost-center). Founder review pre-commit aplicou 3 ciclos de red team com 1 correção substantiva: nota explícita em inv-alcada-respected.rationale sobre tabela de Alçadas viver como configuração externa fora do BDG BC (não modelada como state interno do agg-cost-center). Adequação BR validated: vocabulary brasileiro respeitado (Centro de Custo, Saldo Disponível, Limite, Alçada, Comprometimento, Aprovação, Liberação); terminologia financeira/contábil BR consistent com glossary. Phase 0 caveats articulados em rationale: evt-budget-rejected/released propagação cross-BC pendente oq-bdg-2; cmd-release-budget-commitment trigger ACL pendente; Fracionamento detection deferred oq-bdg-1; as-bdg-1 premissa de cmd-approve-budget. cue vet ./contexts/bdg/ EXIT=1 (esperado — pre-existing schema collision artifact_schemas.#Policy entre policy.cue PLR registry e domain-model.cue policy; identical baseline em CMT/IDC/NPM golden examples confirmado); CI self-review-check local PASSED. Note: subagent dispatch successfully produziu draft conformant; founder optou por review direto + 3-cycle red team próprio (paralelo a glossary BDG approach) em vez de dispatch de review subagent."
	}]

	findings: {}

	summary: "Domain Model BDG via subagent dispatch (disp-006). 1 aggregate + 7 invariants + 7 VOs + 4 events + 3 commands + 1 policy + 2 projections. Lenses primary+secondary aplicadas. Glossary 14/15 alignment. 3-cycle red team founder + 1 correction substantiva. Pre-existing schema collision baseline aceito."

	singleRoundRationale: "Subagent dispatch successful + founder substantial review in 3 layers (red team cycles + adequação BR + design decisions on priority items). Auto-checks passed within accepted baseline. Round único suficiente."
}
