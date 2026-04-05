package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

tensionEntrySelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-tension-entry-schema"

	artifactPath:       "architecture/artifact-schemas/tension-entry.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-03"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Avaliação de #TensionEntry contra 8 critérios universais +
			3 critérios de artifact-schema (tq-as-01/02/03). Findings:
			(1) uq-01 (fail) — rationale top-level descrevia WHAT ('critérios
			garantem rastreabilidade') em vez de WHY. (2) uq-02 (fail) —
			teste de substituição: schema inteiro funcionava para qualquer
			fintech, sem ancoragem em mecanismos Mesh (axiomas tensionáveis,
			agentes stateless, CLAUDE.md seção 2). (3) uq-05 (warn) —
			limitação de tensionTarget singular não declarada.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correções aplicadas: (1) rationale top-level reescrito para WHY —
			'sem tipo formal, tensões vivem apenas em rationales individuais,
			invisíveis para agentes cross-context'. (2) Header reescrito com
			ancoragem Mesh: axiomas tensionáveis (domain-definition.cue),
			CLAUDE.md seção 2, agentes stateless. (3) Limitação de
			tensionTarget singular declarada no header. Finding uq-08
			investigado (tipos #TensionKind/#TensionStatus no top-level do
			package) — rejeitado como falso-positivo: padrão do package já
			usa tipos auxiliares top-level sem namespace (#DecisionClass,
			#Reversibility em adr.cue). Zero findings reais no round 2.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round de confirmação de estabilidade. Todos os 11 critérios
			(8 universais + 3 tq-as) reavaliados. Zero findings. Correções
			do round 1 confirmadas sem regressão. Schema estável.
			"""
	}]

	findings: {}

	summary: """
		Schema #TensionEntry para tension log — formaliza mecanismo de
		tensão referenciado em CLAUDE.md seção 2. 3 tipos (axiom-tension,
		schema-limitation, cross-artifact-friction), 3 estados (open,
		accepted, resolved). 4 quality criteria (tq-te-01 a tq-te-04):
		target identificável, resolution concreta, manifestação rastreável,
		resolved exige evidência. Estabilizou em 3 rounds: round 1
		encontrou 2 fail (rationale WHAT→WHY, falta ancoragem Mesh) e
		1 warn (limitação não declarada); round 2 corrigiu e rejeitou
		1 falso-positivo (tipos top-level); round 3 confirmou estabilidade.
		Lense aplicada: lens-knowledge-management. Founder revisou e
		endureceu 3 pontos (tensionTarget regex, manifestsIn path regex,
		tq-te-04 resolved exige evidência) após self-review.
		"""
}
