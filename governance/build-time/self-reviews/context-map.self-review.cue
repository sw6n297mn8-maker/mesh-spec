package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapSchema: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-schema"

	artifactPath:       "architecture/artifact-schemas/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-31T00:00:00Z"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 avaliou versão inicial do schema #ContextMap contra
			critérios universais (uq-01 a uq-08) e type-specific (tq-as-01
			a tq-as-03). Schema fornecido pelo founder após 3 lenses e 4
			rounds de red team. subdomainOwnership opcional (com ?), hook
			knownFlows. Todos os critérios passaram. Zero findings.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 avaliou versão refinada pelo founder com 3 mudanças
			estruturais: (1) subdomainOwnership obrigatório (sem ?) —
			ownership vira dado estrutural, não opcional de bootstrap;
			(2) contexts[].subdomains explicitamente marcado como visão
			derivada do ownership global; (3) knownFlows renomeado para
			declaredFlows — nome mais preciso que denota ato explícito.
			Header comment atualizado com estratégia clara: tipo para
			estados inválidos, unificação para cross-artifact, runner
			para o restante. Quality criteria mais concisos. Seções com
			separadores visuais. Verificação: (uq-01) rationales WHY
			em todos os campos. (uq-02) Mesh-specific via wave plan,
			ownership por BC, cross-context flows. (uq-03) refs
			#BoundedContextRef e #SubdomainRef idênticos aos existentes
			no package. (uq-04) subdomainOwnership obrigatório reforça
			P0. (uq-05) header documenta fronteira tipo/unificação/runner.
			(uq-06) terminologia consistente. (uq-07) zero placeholders.
			(uq-08) _schema.location e _qualityCriteria completos.
			(tq-as-01) location com todos os campos. (tq-as-02) 11
			critérios acionáveis. (tq-as-03) rationale cobre separação
			tipo/unificação/runner. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Schema #ContextMap estável no round 2. Round 1 avaliou versão
		inicial (subdomainOwnership opcional, knownFlows). Round 2
		avaliou versão refinada pelo founder: ownership obrigatório,
		subdomains como visão derivada, declaredFlows. Union de 8
		variantes tipadas garante compatibilidade de patterns (tq-cm-04)
		e simetria (tq-cm-07) a nível de tipo. subdomainOwnership
		obrigatório é SoT explícito de ownership. declaredFlows e
		expectedContexts são hooks de unificação cross-artifact.
		11 critérios (9 fail, 2 warn) com separação clara entre
		validação estrutural (tipo), contratos de unificação e
		validação operacional (runner).
		"""
}
