package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentSpecDomainmodelrefsCommentFix: build_time.#SelfReviewReport & {
	reportId: "srr-agent-spec-domainmodelrefs-comment-fix"

	artifactPath:       "architecture/artifact-schemas/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/quality-criteria.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-01"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Fix editorial em comment de #AgentAction.domainModelRefs (linha 306-308 → 306-314): o comment original 'Devem estar dentro do operationalScope (tq-ag-02)' era over-strict relativo ao regex de #DomainModelRef (linha 457: ^(evt|cmd|inv|vo|agg|ent|mod|svc|pol|prj|qry)-...). #OperationalScope declara apenas 5 categorias (aggregates/commands/events/invariants/projections); os 6 prefixos restantes (vo-/ent-/qry-/mod-/svc-/pol-) são permitidos pelo regex mas não exigem entrada literal em operationalScope. Comment atualizado para alinhar com regex reality: refs com prefixos de operationalScope seguem least privilege; refs com outros prefixos são associadas via parent (vo-/ent- via aggregate; qry- via projection) ou por scope próprio (mod-/svc-/pol- como building blocks top-level). Aponta para PG-A heuristic correspondente (commit 35dd8ab F4) para discipline detalhada. Sem mudança de policy nem de regex; pure comment alignment com reality. Discovery via review retroativo de idc-primary-agent.cue (chat sessão 2026-05-01) que tem vo-cnpj-identifier e qry-* em domainModelRefs. cue vet ./... EXIT=0."
	}]

	findings: {}

	summary: """
		Fix editorial em comment de #AgentAction.domainModelRefs em
		architecture/artifact-schemas/agent-spec.cue. Comment atualizado
		para alinhar com regex de #DomainModelRef (permite 11 prefixos
		incluindo vo-/qry- além das 5 categorias de operationalScope).
		Coerente com F4 PG-A refinement (commit 35dd8ab). Sem mudança
		de policy, regex ou behavior. Editorial per CLAUDE.md L131.
		"""

	singleRoundRationale: """
		Mudança é estritamente editorial (comment-only) para alinhar
		schema documentation com regex reality. Não introduz constraints,
		não altera policy, não muda comportamento de validação. Round 1
		do self-review verifica: (a) cue vet ./... passa EXIT=0 (regex
		e shape inalterados), (b) comment alinhado com PG-A heuristic
		atualizada (commit 35dd8ab), (c) nenhum critério tq-ag-XX
		afetado (todos preservados). Multiple rounds seriam fabricação
		— comment fix de 3 linhas para 8 linhas não justifica iteração
		de critérios; review founder do path (C1 isolado antes de
		C2/C3) ocorreu pre-write na escolha de Opção C.
		"""
}
