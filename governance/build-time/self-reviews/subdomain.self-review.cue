package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

subdomainSchema: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-schema"

	artifactPath:       "architecture/artifact-schemas/subdomain.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-03-23T00:00:00Z"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Sub-agente isolado avaliou subdomain.cue contra 8 critérios
		universais (uq-01 a uq-08) e 3 critérios type-specific de
		artifact-schema (tq-as-01 a tq-as-03). Dois findings reportados
		pelo sub-agente foram avaliados pelo agente principal como
		falso-positivos: (1) uq-08 sobre duplicação de #BCClassification
		— o sub-agente não tinha visibilidade de que canvas.cue seria
		editado no mesmo pacote para remover a definição local, eliminando
		a duplicação; (2) tq-as-01/uq-08 sobre abreviação sd não
		registrada em quality-criteria.cue — o comentário canônico em
		quality-criteria.cue declara explicitamente que #ArtifactType é
		expandido quando tipos entram no regime de self-review, e o
		prefixo tq-sd-NN nos critérios é convenção documental consistente
		com o padrão existente (tq-cv, tq-as, tq-dd), não constraint do
		type system. Ambos rejeitados com justificativa factual. Zero
		findings válidos após avaliação.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado avaliou subdomain.cue contra critérios
			universais (uq-01 a uq-08) e type-specific (tq-as-01 a
			tq-as-03). Schema declara #BCClassification como enum fechada
			(core/supporting/generic) e #Subdomain com campos id, name,
			classification, responsibility, boundedContexts, mechanismRefs.
			_schema.location com canonicalPathRegex para
			strategic/subdomains/<id>.cue. Três critérios tq-sd-NN
			acionáveis cobrindo separação estratégica, consistência
			classificatória BC↔subdomínio, e rastreabilidade
			mecanismo→subdomínio. Rationales explicam WHY (separação
			arbitrária, decisões de investimento erradas, perda de
			rastreabilidade). Referências cruzadas a mech-* e
			domain-definition.cue validadas. Dois findings do sub-agente
			rejeitados como falso-positivos (duplicação #BCClassification
			resolvida pelo pacote; abreviação sd conforme padrão de
			expansão incremental de #ArtifactType).
			"""
	}]

	findings: {}

	summary: """
		Subdomain artifact schema estável no round 1 via sub-agente
		isolado. Schema define #BCClassification (relocada de canvas.cue)
		e #Subdomain com campos de classificação estratégica,
		boundedContexts e mechanismRefs. Três critérios type-specific
		(tq-sd-01/02/03) cobrem separação, consistência e
		rastreabilidade. Dois findings do sub-agente rejeitados como
		falso-positivos com justificativa factual. Zero findings válidos.
		"""
}
