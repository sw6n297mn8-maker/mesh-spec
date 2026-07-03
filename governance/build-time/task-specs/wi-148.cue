package task_specs

taskSpecs: "WI-148": {
	version:     1
	title:       "Regras A+B no check-self-review per adr-167 — invariante global de staleness das bootstrap exceptions + fim do SKIP (isenção perdoa o passado, não o presente); resolução do def-012 e aposentadoria do ddp-001"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-167-bootstrap-exception-staleness-invariant-and-no-skip.cue (accepted) — a decisão: Regra A (invariante transient-only em todo run, falha nomeando 'exceção stale: quitar') + Regra B (sem SKIP para TODAS as entries; policy vira proveniência histórica + fila de quitação enforçada).",
		"PR #198 (merged @ 6047008) — quitação das 3 stales ANTES deste WI: pré-requisito de sequenciamento (a Regra A nasceria vermelha sobre o estado anterior).",
		"Fatia def-012 pre-flight (2026-07-03, verificado em disco): 3 stales empíricas (1ª invisível ~7 semanas); SKIP infiel ao exitCondition declarado (caso idc/glossary em a7126df); 6/6 permanent com SRR matching (custo zero do escopo B=todas); associação por existência → custo one-time por artefato.",
		"architecture/deferred-decisions/def-012-bootstrap-exception-stale-detection-sc.cue — o def que este WI resolve: as opções (a)/(b)/(c) especuladas são substituídas por enforcement no ponto de uso (declarado no adr-167 decision item 4).",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-167-bootstrap-exception-staleness-invariant-and-no-skip.cue"
		type:     "create"
	}, {
		artifact: "scripts/ci/check-self-review.sh"
		type:     "update"
	}, {
		artifact: "scripts/ci/tests/test_check_self_review.py"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-012-bootstrap-exception-stale-detection-sc.cue"
		type:     "update"
	}, {
		artifact: "governance/build-time/dd-predicates.cue"
		type:     "update"
	}]
	affects: [
		"governance/build-time/self-review-bootstrap-policy.cue",
		"scripts/ci/tests/test_evaluate_deferred_triggers.py",
	]
	rationale: """
		Fecha a fatia def-012 em 2 commits: c1 (adr-167 + Regras A+B no
		check + testes de fixture — A dispara nomeando entry; A limpa; B
		exige SRR em isento modificado; B satisfeita por existência com
		permanent; ciclo completo num único PR — + este WI + SRR do
		adr-167 via isolated-subagent) e c2 (def-012 status resolved com
		resolvedBy adr-167 + amendment curto; ddp-001 removido do registry
		— predicado sem consumidor é declared-but-unused, gate substitui
		sinal; asserts recalibrados registry==3; rationale da policy
		atualizado: cleanup agora ENFORÇADO pela Regra A).

		Prova viva ORGÂNICA registrada (decisão do founder, sem fabricar):
		a primeira modificação real de artefato transient-isento pós-merge
		deve produzir o ciclo completo num único PR (SRR exigido pela B +
		quitação cobrada pela A) — reportar como confirmação da
		falsificationCondition do adr-167 quando acontecer naturalmente.

		CLASSIFICAÇÃO: semântica (muda enforcement de governança — o
		check-self-review deixa de isentar) → adr-167 no mesmo PR.
		Reversível no script com custo de decisão (reabrir o regime dual
		re-esconde stales) — metadata no ADR.
		"""
}
