package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-010": artifact_schemas.#DeferredDecision & {
	id:    "def-010"
	title: "#Convention central schema centralization — formalizar schema central quando n=2+ convenções concretas materializem"
	date:  "2026-05-03"

	description: """
		adr-046 estabeleceu categoria architecture/conventions/ +
		template tmpl-create-convention. adr-048 criou 1ª convention
		concreta (api-spec-convention.cue). Ambas ADRs deferiram
		explicitamente formalização de #Convention schema central
		'até n=2 convenções concretas' (pattern ten-009 expand-when-
		needed). Quando 2ª convention materializar, decidir:
		(a) extrair invariantes comuns para #Convention schema central
		+ migrar conventions existentes; (b) manter conventions como
		artefatos independentes (no shared schema); (c) hybrid — alguns
		shared types em architecture/shared-types/ + per-convention
		specifics permanecem locais.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-046-conventions-category-and-tmpl-create-convention.cue",
		"architecture/adrs/adr-048-api-spec-convention-conditional-presence.cue",
	]

	deferralRationale: """
		Backfill from prose 'Known gaps declarados' em adr-046 + adr-048
		(pre-adr-062 ADRs grandfathered; backfill nesta sessão converte
		gap shared para def-XXX queryable per adr-062 forward direction).
		Centralization prematuro com 1 convention é solution-in-search-
		of-problem (pattern ten-009 expand-when-needed): sem dados sobre
		invariants comuns vs specifics, qualquer schema central é
		especulação. 2 convenções concretas provêm evidência empírica de
		quais campos repetem-se vs quais são specifics. Trade-off:
		aguardar 2nd case (custo: zero — 1 convention coexiste sem
		schema) vs commitment prematuro a estrutura sem evidence (custo:
		schema errado bloqueia 2ª convention OR migration custosa
		retroativa).
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence scope=filename) usa pattern
		'^architecture/conventions/' threshold=2. Atualmente conta=1
		(api-spec-convention.cue). Ao adicionar 2ª convention, count=2,
		trigger fires → founder revisita decisão de centralization.
		Pattern verificado clean: scope=filename matches paths;
		schema declarations vivem em artifact-schemas/, não em
		conventions/, portanto schema files não causam false positive.
		Threshold=2 é o limiar exato articulado em adr-046/048
		('até n=2 convenções concretas'). Trigger 2 (manual-review)
		escape para founder priorizar antes — e.g., regulatory
		requirement antecipa pattern compartilhado entre conventions
		que justifica centralization sem aguardar 2nd concrete case.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "local"
		description: """
			Com 1 convention, deferral é zero-cost — sem dados, schema
			central seria especulação. Severity low porque conventions
			são meta-estrutura (não BCs operacionais); blastRadius local
			porque escopo é arquitetura/conventions/ apenas. Cresce
			marginalmente com 2ª convention (decisão fica overdue), mas
			ainda local.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "^architecture/conventions/"
		scope:     "filename"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar centralization antes de 2ª convention concreta — e.g., regulatory requirement antecipa pattern compartilhado entre conventions OR review de adr-046/048 retroativo identifica invariants centralizáveis sem aguardar 2nd case."
	}]

	status: "open"
}
