package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensOrganizationalEconomics: build_time.#SelfReviewReport & {
	reportId: "srr-lens-organizational-economics"

	artifactPath:       "architecture/lenses/lens-organizational-economics.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Round 1 avaliou artefato parcial (trigger + concepts apenas). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes. Demais critérios universais pass sobre conteúdo presente. tq-ln-01 pass (12 condições testáveis). tq-ln-02 a tq-ln-04 não avaliáveis por campos ausentes."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 avalia artefato completo com todos os campos obrigatórios adicionados pelo founder: reasoningProtocol (11 steps), meshExamples (3 exemplos), principleIds (6 refs: ax-01, ax-02, ax-03, dp-04, dp-05, dp-07), relatedLenses (9 relações), limitations (8 limitações), rationale. uq-01 pass: todos os rationale explicam por que, não o que (e.g., 'Classificação vem antes de execução' em vez de descrever o step). uq-02 pass: conteúdo fortemente ancorado na Mesh — scoring, antecipações, CLAUDE.md, solo founder IA-first, agentes com context window finito. Teste de substituição falha se trocar Mesh por fintech genérica. uq-03 pass: crossDependsOn referencia pd-critical-mass em lens-platform-dynamics (existente); principleIds usam padrão ax-XX e dp-XX conforme PrincipleRef regex. uq-04 pass: consistente com P10 (agentes recomendam, gates validam) e P12 (governança é código). uq-05 pass: 8 limitações com alternativas concretas. uq-06 pass: terminologia consistente (scoring, antecipação, anchor, founder). uq-07 pass: zero placeholders. uq-08 pendente cue vet. tq-ln-01 pass: 12 condições + 5 excludeWhen permitem ativação/desativação determinística. tq-ln-02 pass: 11 reasoning steps com perguntas específicas de economia organizacional — classificação de autoridade, failure modes, complementaridades, dívida organizacional, cultura via defaults — distintas dos princípios gerais. tq-ln-03 pass: 3 exemplos concretos (mudança de scoring com complementaridades, escala de antecipações de 30 para 100/dia, drift de dilution detectado reativamente). tq-ln-04 pass: 8 limitações reais com alternativas (campo pouco estabilizado, premissa de solo founder, medição indireta de consistência, falsa cobertura por artefato incompleto, vieses resistentes a auto-observação, context window mutável, artefact-centrism contingente, degradação cognitiva multidimensional)."
	}]

	findings: {}

	summary: """
		Lente de economia organizacional completa com 10 conceitos, 11 reasoning
		steps, 3 exemplos Mesh, 6 principleIds, 9 relatedLenses e 8 limitações.
		Round 1 identificou fail por campos ausentes (artefato parcial por decisão
		do founder). Round 2 avalia artefato completo — todos os critérios
		universais e type-specific passam. uq-08 pendente validação cue vet.
		"""
}
