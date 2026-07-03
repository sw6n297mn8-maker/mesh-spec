package task_specs

taskSpecs: "WI-147": {
	version:     1
	title:       "Correção do runner de deferred-triggers per adr-166 — contagem escopada, self-match morto por construção, kind structural-predicate + registry, gate multi-trigger, migração dos 21 triggers"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-166-deferred-trigger-scoped-counting-and-structural-predicates.cue (accepted) — a decisão: 3 defeitos mecânicos comprovados (repo-wide sem escopo; self-match; gate first-trigger) + classe de erro semântica (contagem sintática não distingue definição de transgressão, caso #196).",
		"architecture/artifact-schemas/deferred-decision.cue #Trigger — o contrato de declaração que ganha pathScope (required no tightening) + kind structural-predicate.",
		"governance/build-time/dd-predicates.cue — registry singleton dos predicados nomeados ddp-001..004 (nasce neste WI).",
		"PR #196 (merged @ 67562de) — a correção de REGISTRO que precedeu esta correção de MOTOR: def-014/def-010/def-012 com contagens-artefato documentadas; fundamento 'sinal de prosa não se conta, se revisa'.",
		"Tabela de migração aprovada pelo founder (2026-07-03): 4 triggers → structural-predicate; 6 ganham pathScope/âncora corrigida; 3 anexam âncora; def-016[0] removido (prosa); def-001[0][1] removidos (exauridos); 7 já conformes.",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-166-deferred-trigger-scoped-counting-and-structural-predicates.cue"
		type:     "create"
	}, {
		artifact: "scripts/ci/evaluate_deferred_triggers.py"
		type:     "create"
	}, {
		artifact: "governance/build-time/dd-predicates.cue"
		type:     "create"
	}, {
		artifact: "scripts/ci/tests/test_evaluate_deferred_triggers.py"
		type:     "create"
	}, {
		artifact: "architecture/artifact-schemas/deferred-decision.cue"
		type:     "update"
	}, {
		artifact: "scripts/ci/evaluate-deferred-triggers.sh"
		type:     "update"
	}]
	affects: [
		".github/workflows/validate.yml",
		".github/workflows/deferred-trigger-check.yml",
		"governance/claude/config.cue",
	]
	rationale: """
		O sensor determinístico do sistema de deferimentos produzia sinal
		falso (pior que ausência de sensor — induz decisão com aparência de
		evidência; caso #196: janela de spec-hygiene ordenada sobre contagem
		defeituosa). Este WI corrige o MOTOR em 2 commits: c1 aditivo (adr +
		schema aditivo + registry + runner extraído/testável + suite + step
		CI + correção factual do config.cue Camada 1 — gate ligado desde
		#184, não 'ligação futura') e c2 atômico (migração dos 21 triggers
		per tabela + tightening do schema: pathScope/âncora viram required —
		atômico porque o tightening invalidaria instâncias não-migradas).

		Sequenciamento obrigatório (adr-166 decisão item 6): o fix do gate
		multi-trigger e a migração do def-001 viajam no MESMO PR — o fix
		sozinho deixaria main vermelho via def-001[1] (file-exists disparado
		além da carência, hoje escondido pelo warn-only anterior).

		Aceitação (FASE C, pós-merge): rodar o runner corrigido sobre os
		defs vivos; o GABARITO do pre-flight (def-012=24≥20; def-013=3;
		def-035=5; def-010=1<2; def-004 cai com escopo) é o critério —
		bater = runner calibrado; divergir = primeiro bug report. Re-triagem
		dos sobreviventes é decisão do founder sobre os números.

		CLASSIFICAÇÃO: semântica/estrutural (muda contrato de declaração de
		triggers + mecânica de avaliação) → adr-166 no mesmo PR. Reversível
		com custo (revert de schema/runner + segunda migração) — metadata no
		ADR.
		"""
}
