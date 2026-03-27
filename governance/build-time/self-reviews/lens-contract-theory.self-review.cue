package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensContractTheory: build_time.#SelfReviewReport & {
	reportId: "srr-lens-contract-theory"

	artifactPath:       "architecture/lenses/lens-contract-theory.cue"
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
		summary:   "Round 1 avaliou artefato parcial (trigger + concepts). uq-08 fail: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale ausentes. Demais critérios pass sobre conteúdo presente. tq-ln-01 pass (15 condições testáveis, 5 excludeWhen)."
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Round 2 avalia artefato completo: reasoningProtocol (16 steps cobrindo contraparte, regime de enforcement, sustentabilidade relacional, verificabilidade, direitos residuais, penalty defaults, subjacente, perfection, custo de enforcement, remédios, moral hazard, covenants, renegociação, menu contratual, alinhamento multi-party e viabilidade econômica), meshExamples (3 cenários: recebível informal de areia, covenant sazonal em FIDC, renegociação de anchor), principleIds (6 refs: ax-03, ax-05, ax-06, ax-07, dp-02, dp-05), relatedLenses (9 relações), limitations (8 limitações), rationale. uq-01 pass: rationale explicam por que (e.g., 'Não existe contrato genérico; Mesh↔fornecedor, Mesh↔comprador, Mesh↔investidor e subjacente têm lógicas diferentes'). uq-02 pass: fortemente ancorado na Mesh — cessão, duplicata, registradora, LGPD, protesto, FIDC, WhatsApp, areia, construtora, informalidade brasileira. uq-03 pass: dependsOn internos consistentes, principleIds conformam com PrincipleRef regex. uq-04 pass. uq-05 pass: 8 limitações com alternativas. uq-06 pass: terminologia consistente (verificabilidade, enforcement, covenant, cessão, perfection, reps, menu, camada). uq-07 pass. uq-08 pendente cue vet. tq-ln-01 pass. tq-ln-02 pass: 16 reasoning steps específicos de teoria de contratos — regime de enforcement, sustentabilidade relacional, verificabilidade por nível, direitos residuais, penalty defaults, subjacente, perfection, custo de enforcement, moral hazard de servicer, covenants compostos, renegociação, menu contratual, alinhamento multi-party e viabilidade econômica all-in. tq-ln-03 pass: 3 exemplos concretos com cenários reais da Mesh. tq-ln-04 pass: 8 limitações reais com alternativas operacionais."
	}]

	findings: {}

	summary: """
		Lente de contract theory completa com 15 conceitos, 16 reasoning steps,
		3 exemplos Mesh, 6 principleIds, 9 relatedLenses e 8 limitações. Round 1
		identificou fail por campos ausentes (artefato parcial). Round 2 avalia
		artefato completo — todos os critérios universais e type-specific passam.
		uq-08 pendente validação cue vet.
		"""
}
