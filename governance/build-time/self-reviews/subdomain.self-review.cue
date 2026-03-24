package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

subdomainSchema: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-schema"

	artifactPath:       "architecture/artifact-schemas/subdomain.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-03-24T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Subdomain schema revisado por sub-agente isolado (sem acesso ao
		histórico da conversa) contra 8 critérios universais (uq-01 a
		uq-08) e 3 critérios type-specific de artifact-schema (tq-as-01
		a tq-as-03). Sub-agente verificou: rationales explicam WHY não
		WHAT em todos os campos (code, negativeBoundaries, strategicProfile,
		lifecycle, _schema.location, cada tq-sd-NN); termos ancorados em
		mecanismos Mesh (reutilização de #BCClassification, canvas cross-ref,
		decomposição estratégica DDD); referências cruzadas #BCClassification
		(canvas.cue:91) e #QualityCriteria (quality-criteria.cue:46)
		validadas; consistência com P0/P12 de design-principles.cue
		confirmada; limitação de tq-sd-05 (correspondência subdomain ↔
		canvas depende de runner) declarada explicitamente com severity
		warn; _schema.location completo com canonicalPathRegex, fileNameRegex,
		cardinality, allowNested; 5 critérios tq-sd-NN acionáveis com tests
		concretos; rationale do conjunto explica cobertura das 4 dimensões
		(identidade, contorno, classificação, coerência cross-artifact).
		Zero findings em todas as verificações.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Sub-agente isolado avaliou subdomain.cue contra critérios universais (uq-01 a uq-08) e type-specific (tq-as-01 a tq-as-03). Schema define #Subdomain com união discriminada active/deprecated (padrão de #ADR), #NegativeBoundary com responsibility + delegatedTo + rationale para delegação rastreável, #StrategicProfile opcional (exigido para core via tq-sd-03), e reutilização de #BCClassification de canvas.cue. _schema.location declara domain/subdomains/ com cardinality collection. 5 critérios tq-sd-NN cobrem identidade, contorno, classificação e coerência cross-artifact. Zero findings."
	}]

	findings: {}

	summary: "Subdomain artifact schema estável no round 1 via sub-agente isolado. Schema define estrutura com união discriminada para lifecycle, #NegativeBoundary com delegação explícita (responsibility + delegatedTo + rationale), #StrategicProfile condicional, e reutilização de #BCClassification. Zero findings em 11 critérios avaliados."
}
