package rew

// am-risk-evaluation.cue -- AggregateManifest do agg-risk-evaluation
// (fatia REW, caminho da elegibilidade, PR #139 Etapa 2).
//
// Instancia de #AggregateManifest (architecture/artifact-schemas/aggregate-manifest.cue,
// adr-144). Per adr-141 item 5: declara a SUPERFICIE do aggregate; "o aggregate
// base gerado deriva do AggregateManifest". Quarta instancia do tipo no disco
// (precedentes de forma: am-commitment, am-verification, am-payment).
//
// Listas commandsAccepted/invariants copiadas VERBATIM de
// contexts/rew/domain-model.cue agg-risk-evaluation (handlesCommands/
// protectsInvariants — 3 commands, 39 invariants INTEGRAIS); eventsEmitted e
// SUBCONJUNTO declarado (5 dos 9 de emitsEvents) -- existencia por construcao;
// diff programatico verificado no checkpoint (zero-drift listas<->domain-model).
//
// NOTA DE RECORTE (precedente am-payment/Defaulted): eventsEmitted tem 5 (NAO
// inclui evt-signal-rejected, evt-signal-corruption-detected,
// evt-risk-evaluation-emit-failed, evt-risk-evaluation-emit-superseded-by-newer:
// fluxos de excecao sem emissor materializado na fatia -- schemas do recorte
// cobrem o caminho da elegibilidade; os 4 entram com a fatia de excecao/alerts).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifest: artifact_schemas.#AggregateManifest & {
	id:           "am-risk-evaluation"
	name:         "RiskEvaluation"
	aggregateRef: "agg-risk-evaluation"

	// 3 commands verbatim de agg-risk-evaluation.handlesCommands.
	commandsAccepted: [
		"cmd-request-risk-evaluation",
		"cmd-supersede-risk-evaluation",
		"cmd-mark-evaluation-stale",
	]

	// 5 events do recorte (subconjunto declarado de emitsEvents — ver header).
	eventsEmitted: [
		"evt-signal-received",
		"evt-risk-evaluation-computed",
		"evt-risk-evaluation-emitted",
		"evt-risk-evaluation-superseded",
		"evt-risk-evaluation-marked-stale",
	]

	// 39 invariants verbatim de agg-risk-evaluation.protectsInvariants
	// (lista INTEGRAL do aggregate — zero-drift puro).
	invariants: [
		"inv-rew-signal-traceability",
		"inv-rew-contextual-completeness",
		"inv-rew-bounded-score",
		"inv-rew-deterministic-replay",
		"inv-rew-model-policy-separation",
		"inv-rew-model-version-binding",
		"inv-rew-asset-aware-discipline",
		"inv-rew-reasoning-completeness",
		"inv-rew-temporal-consistency",
		"inv-rew-payload-opacity",
		"inv-rew-explicit-supersede-only",
		"inv-rew-active-evaluation-rule",
		"inv-rew-compute-emit-ordering",
		"inv-rew-snapshot-temporal-consistency",
		"inv-rew-evaluation-completeness",
		"inv-rew-staleness-tracking",
		"inv-rew-no-staleness-feedback-loop",
		"inv-rew-event-emission-boundedness",
		"inv-rew-command-idempotency",
		"inv-rew-signal-corruption-handling",
		"inv-rew-version-frozen-at-request",
		"inv-rew-policy-version-immutability-per-evaluation",
		"inv-rew-evaluation-lineage-acyclic",
		"inv-rew-supersede-after-emit-only",
		"inv-rew-compute-implies-emit",
		"inv-rew-computed-idempotent-retry",
		"inv-rew-single-successor-per-evaluation",
		"inv-rew-computed-must-eventually-emit-or-fail",
		"inv-rew-supersede-requires-current-active",
		"inv-rew-signal-validation-before-ingestion",
		"inv-rew-supersede-emit-failed-precedence",
		"inv-rew-evaluation-temporal-validity",
		"inv-rew-replay-scope-completeness",
		"inv-rew-acl-validation-cost-bounded",
		"inv-rew-obsolete-evaluation-must-link-successor",
		"inv-rew-successor-chain-bounded",
		"inv-rew-replay-confidence-propagation",
		"inv-rew-decision-binding-to-evaluation-version",
		"inv-rew-undetectable-pattern-risk-declared",
	]

	// Coerente com pm-rew: EventLogPort uso-forte (persistencia OCC + replay +
	// read-rule da evaluation ativa). EvidencePort NAO consumido nesta fatia
	// (criterio no header do pm-rew; expansao def-058).
	portsRequired: ["EventLogPort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton do RiskEvaluation derivado deste manifest (adr-141 item 5): estados do lifecycle (emitted, stale, superseded — #RiskEvaluationState reusado dos schemas, disjuncao fechada), handlers dos 3 commands, emissao dos 5 events declarados, guards das invariants."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract (transform: from AggregateManifest). Com esta fatia o discovery do gerador passa a pegar o REW (schemas + manifests presentes, rtd-013); o baseline rew-generated no mesh-runtime e downstream do proximo pacote-runtime (build.gradle.kts hand + FF-CG-03, precedente FCE)."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-risk-evaluation (per-aggregate, adr-141 item 5): 3 commands e 39 invariants verbatim do domain-model do REW (extracao com diff verificado); eventsEmitted e o recorte de 5 do caminho da elegibilidade (exclusao dos 4 fluxos de excecao declarada no header, precedente am-payment/Defaulted). portsRequired coerente com pm-rew (EventLogPort uso-forte; EvidencePort nao consumido — def-058). Quarta instancia do tipo; ativa sc-mri-02 para o REW (aggregateRef verificado em aggregates[].code). Manifests dos demais aggregates do REW (alert/model/policy) pendentes — fatia NAO cobre o BC inteiro."
}
