package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

apiSpecSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-api-spec-schema"

	artifactPath:       "architecture/artifact-schemas/api-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-08"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Artefato estritamente declarativo: dois tipos skeletal
		(#OpenAPISpec, #AsyncAPISpec) contendo apenas _schema.location
		cada, sem _qualityCriteria por decisão explícita ancorada em
		adr-040 (schema declara ontologia; enforcement vive em
		structural-check). Não há lógica, constraints de campo nem
		critérios para falhar em múltiplas dimensões. O literal foi
		previamente submetido a crítica do founder antes desta passada
		— a remoção de _qualityCriteria (presente na versão anterior
		com severity fail delegando test a structural-check) foi
		identificada como correção necessária durante diálogo prévio
		e aplicada ao literal antes do self-review. Um round adicional
		não revelaria findings que este round não revelou: a superfície
		semântica do artefato cabe integralmente em uma passada.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round único sobre api-spec.cue. Aplicados uq-01 a uq-08 +
			tq-as-01/02/03. PASS em uq-01 (rationales WHY em
			_schema.location e prose header), uq-02 (ancoragem em
			canvas hasSyncSurface/hasAsyncSurface, adr-040,
			repo-structure), uq-03 (refs informativas a adr-040 e
			canvas.cue existem), uq-04 (alinhado com adr-040, P0, P1),
			uq-06, uq-07, uq-08 (conforma ao meta-schema via padrão
			nested-in-definition per adr.cue). tq-as-01 PASS para
			ambos os tipos. tq-as-02 e tq-as-03 vacuously PASS —
			sem _qualityCriteria por decisão deliberada sancionada
			por criteriaResolution.fallback em quality-gate.cue.
			WARN em uq-05: o comment header referencia
			api-spec-convention.cue e structural-check dedicado como
			origem das normas e mecanismo de enforcement, sem declarar
			explicitamente que nenhum dos dois existe no repo no
			momento da criação deste schema. São dependências
			prospectivas a serem materializadas nas etapas seguintes
			de B.1/B.2. Warn registrado sem correção: direção
			explícita do founder foi escrever o literal exatamente
			como proposto; decisão sobre correção ou aceite pertence
			ao founder.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Comment header de api-spec.cue referencia
				api-spec-convention.cue e structural-check dedicado
				como mecanismos de enforcement das normas de
				presença/coerência, sem declarar explicitamente que
				nenhum dos dois existe no repo no momento da criação
				deste schema. Ambos são dependências prospectivas
				cuja materialização está planejada para etapas
				seguintes (B.1 para a convenção, B.2 para o
				structural-check). O texto atual pode ser lido como
				se esses mecanismos já existissem.
				"""
			rationale: """
				Não é violação de adr-040 — a arquitetura está
				correta. É omissão textual que afeta leitura do
				schema antes da convenção existir. Aceito como
				limitação conhecida desta etapa; correção pode
				acontecer na materialização final de B.1 junto com
				a criação da convenção.
				"""
		}]
	}

	summary: """
		Self-review stable em 1 round para api-spec.cue — artifact
		schema esqueletal declarando #OpenAPISpec e #AsyncAPISpec com
		apenas _schema.location, sem _qualityCriteria por alinhamento
		explícito com adr-040 (schema = ontologia; structural-check =
		enforcement). Zero fail findings. 1 warn em uq-05 sobre
		status prospectivo não declarado de api-spec-convention.cue
		e structural-check dedicado; warn registrado para
		visibilidade, sem correção nesta passada por direção explícita
		do founder (escrever literal como proposto).
		"""
}
