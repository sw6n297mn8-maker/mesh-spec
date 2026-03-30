package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

crossContextFlowSchema: build_time.#SelfReviewReport & {
	reportId: "srr-cross-context-flow-schema"

	artifactPath:       "architecture/artifact-schemas/cross-context-flow.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-30T00:00:00Z"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 avaliou versão inicial (#Choreography) contra critérios
			universais (uq-01 a uq-08) e type-specific (tq-as-01 a tq-as-03).
			Findings: (1) fail uq-03 — #SubdomainRef redefinido como struct,
			colide com definição existente (string) em subdomain.cue no mesmo
			package; CUE unificação falha. (2) fail uq-03 — #ArtifactRef
			genérico substitui #MechanismRef, #CostRef, #CapabilityRef,
			perdendo validação de prefixo. (3) warn uq-06 — nome
			'Choreography' prescreve implementação; lens EDA define
			choreography como 'reação descentralizada', mas artefato modela
			fases sequenciais com pré-condições. Aplicadas 7 lenses
			analíticas (theory-of-firm, domain-language, supply-chain-theory,
			information-economics, complex-adaptive-systems, mechanism-design,
			event-driven-architecture) e 3 rounds de red team (naming, estrutura,
			fitness). Todos os findings corrigidos na versão revisada.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 avaliou versão final (#CrossContextFlow) após correções.
			Verificações: (uq-01) rationales explicam WHY em todos os campos
			e critérios. (uq-02) schema vinculado a BCs, subdomínios,
			mecanismos do domain-definition — Mesh-specific. (uq-03)
			reusa #MechanismRef, #CostRef, #CapabilityRef, #SubdomainRef
			existentes; novos #BoundedContextRef e #PolicyRef seguem padrão
			de typed strings. (uq-04) alinhado com dp-01 (tq-xf-05), dp-05
			(verificationStrategy), dp-03 (ownership por context). (uq-05)
			limitações declaradas: v1 linear only, referências por name sem
			validação CUE nativa. (uq-06) termos consistentes com glossário;
			CrossContextFlow alinha com diretório existente
			cross-context-workflows/. (uq-07) zero placeholders. (uq-08)
			_schema.location e _qualityCriteria presentes e completos.
			(tq-as-01) location com todos os campos. (tq-as-02) 7 critérios
			tq-xf-01 a tq-xf-07 com testes acionáveis; tq-xf-02 verifica
			conectividade via #PhaseConsumer.consumes. (tq-as-03) rationale
			do conjunto explica cobertura coletiva incluindo análise de
			risco em fluxos financeiros. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Schema #CrossContextFlow estável no round 2. Round 1 identificou
		3 findings (2 fail, 1 warn): colisão de #SubdomainRef, perda de
		tipagem forte em refs, e nome prescritivo. Todos corrigidos na
		versão revisada via reuso de tipos existentes, renomeação para
		CrossContextFlow, e adição de #PhaseConsumer para conectividade
		verificável. Processo incluiu 7 lenses analíticas e 3 rounds de
		red team com 8 ataques. Schema define 7 tipos (#CrossContextFlow,
		#FlowPhase, #PhaseConsumer, #EmergentInvariant, #InvariantContribution,
		#CrossCuttingConcept, #ConceptConsumer, #FlowFailureMode) e 2 refs
		novos (#BoundedContextRef, #PolicyRef). 7 critérios de qualidade
		(4 fail, 3 warn) cobrem ownership, conectividade, invariantes
		emergentes, agnosticismo de runtime e análise de risco financeiro.
		"""
}
