package task_specs

// Task-spec materializado retroativamente (2026-06-16) para parear com o stream
// de work-events homonimo (sc-wg-01 exige o par). TRANSCRICAO do wave-plan WI-141
// (title/semanticPrerequisites/outputs/affects/rationale verbatim), nao autoria
// nova; fluxo founder<->agente sem task-spec a epoca. templateRef tmpl-create-
// instance@v1 (default, como WIs de ADR/instance ex. wi-103; WI-141 nao e schema/
// validacao/script/convencao puros). DIVERGENCIA outputs->realidade: os 2
// materialize-*.yml (type "update") foram REMOVIDOS na execucao (substituidos pelo
// gate de drift per adr-152); a verdade do resultado vive no work-event wi-141.cue
// (decisao founder seguindo precedente wi-103). Esta transcricao reflete o PLANO.
taskSpecs: "WI-141": {
	version:     1
	title:       "Restaurar materialização dos derivados auto-commitados (structure-index + repo-tree/README) e tornar a falha audível"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"adr-090 (structure-index derivado) e adr-115 (repo-tree/README derivado) vigentes — artefatos e workflows já existem; o WI restaura sincronia, não os cria.",
	]
	outputs: [{
		artifact: "governance/readme/structure-index.cue"
		type:     "update"
	}, {
		artifact: "governance/readme/tree-generated.cue"
		type:     "update"
	}, {
		artifact: "README.md"
		type:     "update"
	}, {
		artifact: ".github/workflows/materialize-structure-index.yml"
		type:     "update"
	}, {
		artifact: ".github/workflows/materialize-repo-tree.yml"
		type:     "update"
	}]
	affects: [
		"scripts/ci/generate-structure-index.py",
		"scripts/ci/generate-repo-tree.py",
	]
	rationale: "Bug/gap -> WI (não DD: sem trade-off; não tension: sem forças concorrentes), per anti-catch-all. SINTOMA: dois derivados auto-commitados stale, parados em ~adr-133 (faltam adr-134..151, def-035..062, 4 schemas novos, #AgentProbeProtocol, artefatos FCE). DOENÇA (class-level, não index-specific): os DOIS workflows materialize-* (push->main, contents:write, auto-commit do bot) não estão landando há vários merges (#142/#146/#147/#148) — provável branch-protection/permissão bloqueando o push do bot ao main protegido. AÇÃO: (a) re-materializar ambos os derivados num commit dedicado; (b) achar a causa-raiz do auto-commit que não landa; (c) tornar a falha do auto-commit um SINAL VISÍVEL — quando a re-materialização não conseguir landar no main, o pipeline DEVE produzir sinal explícito (check vermelho, issue/annotation automática, ou equivalente bloqueante/visível), nunca um log silencioso; a forma exata é trabalho do WI, mas o WI EXIGE que a falha vire sinal. Hoje não-bloqueante (phantom-gate regenera fresco; validate é report-only), mas o drift cresce a cada merge — e um derivado que auto-sincroniza e falha em silêncio é a própria classe de drift que o adr-151 combate, num derivado de discovery."
}
