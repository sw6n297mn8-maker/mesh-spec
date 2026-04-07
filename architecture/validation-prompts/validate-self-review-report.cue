package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-self-review-report": artifact_schemas.#ValidationPrompt & {
	id:    "vp-self-review-report"
	title: "Validação semântica de Self-Review Reports"

	matchPatterns: ["^governance/build-time/self-reviews/[a-z0-9-]+\\.self-review\\.cue$"]

	appliesTo: ["self-review-report"]

	reviewContract: "advisory-only"

	references: [
		"governance/build-time/self-review-report.cue",
		"governance/build-time/quality-gate.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	checks: [{
		id:         "vc-srr-01"
		question:   "Os findings evidenciam avaliação genuína ou são rubber-stamping (aprovação automática sem análise real)?"
		lookFor:    "Findings com mensagens genéricas que poderiam aplicar-se a qualquer artefato ('está adequado', 'conforma com o esperado'). Ausência de referência a conteúdo específico do artefato avaliado. Reports com zero findings em artefatos complexos — pode indicar avaliação superficial."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "Self-review que não evidencia análise real é formalidade vazia — consome esforço sem capturar valor. O mecanismo existe para capturar problemas antes do founder review."
	}, {
		id:         "vc-srr-02"
		question:   "As correções entre rounds são substantivas ou cosméticas?"
		lookFor:    "roundDetails onde o summary indica apenas ajustes de redação ou formatação para findings com severity fail. failCount que cai entre rounds sem que o summary explique qual correção material foi feita. Padrão: round N tem 2 fails, round N+1 tem 0 fails, mas summary é vago."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "Correções cosméticas para findings fail indicam que o critério não é acionável ou que o agente não está engajando com o finding substantivamente. warn porque correções legítimas podem ser simples."
	}, {
		id:         "vc-srr-03"
		question:   "O self-review cobriu todos os critérios aplicáveis (universalCriteria + type-specific), ou há gaps de cobertura?"
		lookFor:    "Critérios do quality-gate.cue (uq-01..uq-08) ou do artifact schema correspondente (_qualityCriteria) que não aparecem referenciados em nenhum finding. Ausência de cobertura pode indicar que o agente pulou critérios difíceis. Nota: critérios que passam não geram findings obrigatórios, mas a cobertura pode ser inferida dos roundDetails summaries."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "Gaps de cobertura são invisíveis para o mesmo agente — ele não sabe o que não avaliou. Perspectiva externa pode comparar o conjunto de critérios aplicáveis contra os efetivamente exercitados."
	}, {
		id:         "vc-srr-04"
		question:   "Lendo o artefato referenciado em artifactPath, existem problemas óbvios que o self-review não detectou?"
		lookFor:    "Inconsistências internas no artefato que nenhum finding menciona. Violações de design principles ou ubiquitous language não reportadas. Placeholders ou texto genérico não capturado por uq-07. Este check exige que o validador leia o artefato original além do report."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "Este é o check de máximo valor da validação separada: perspectiva fresca sobre o artefato, não apenas sobre o report. Se o self-review falhou em detectar um problema óbvio, o mecanismo inteiro precisa de ajuste."
	}]

	rationale: "Self-review reports são evidência de autovalidação. Validação semântica por agente separado verifica se a evidência é genuína: findings substantivos, correções materiais entre rounds, cobertura completa de critérios, e detecção de problemas que o self-review perdeu."
}
