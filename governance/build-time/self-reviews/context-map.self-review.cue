package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

contextMapSchema: build_time.#SelfReviewReport & {
	reportId: "srr-context-map-schema"

	artifactPath:       "architecture/artifact-schemas/context-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-04-01"

	roundsExecuted: 4
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
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 3 avaliou evolução substancial do schema fornecida pelo
			founder. Mudanças estruturais: (1) endpoints tipados com
			#RelationshipEndpoint (union #ContextEndpoint | #ExternalEndpoint)
			substituindo upstream/downstream como refs simples; (2) direction
			explícita (upstream-downstream | mutual-dependency); (3)
			#CommunicationPattern mudou de {mode} para {type: sync|async|hybrid};
			(4) #FlowPayload com events/commands/queries tipados, simetria
			communication↔data enforced por tipo (tq-cm-14); (5) publishedLanguage
			obrigatório em variantes PL, proibido em não-PL via _|_; (6)
			conformistCascadeRisk permitido apenas em conformist; (7)
			#ExternalRelationship com inbound (6 variantes) e outbound (6
			variantes); (8) customer-supplier como novo downstream pattern;
			(9) #DomainLevelTransversal como artefato de primeira classe;
			(10) #ContextEntry expandido com name, subdomainType?,
			wardleyEvolution?, domainAgentSpec?, domainTransversals?; (11)
			#FeedbackLoop como union discriminado; (12) hotspots?,
			contextBudget? em #_RelationshipCore; (13) 3 novos quality
			criteria (tq-cm-12 classificação estratégica, tq-cm-13
			transversais, tq-cm-14 simetria). Avaliação: (uq-01) rationales
			WHY em todos os 14 critérios e tipos. (uq-02) Mesh-specific via
			commitment lifecycle, SCF, domainLevelTransversals, ownership.
			(uq-03) #QualityCriteria em quality-criteria.cue, #BoundedContextRef
			e #SubdomainRef compatíveis com cross-context-flow.cue e
			subdomain.cue. (uq-04) ownership obrigatório e union de tipos
			reforçam P0. (uq-05) header lista 11 decisões de design. (uq-06)
			terminologia consistente sem sinônimos. (uq-07) zero placeholders.
			(uq-08) _schema.location e _qualityCriteria completos com 14
			critérios. (tq-as-01) location com 6 campos. (tq-as-02) 14
			critérios com tests concretos e verificáveis. (tq-as-03)
			rationale cobre integridade estrutural, ownership, patterns,
			contratos por tipo, completude estratégica, unificação. Zero
			findings.
			"""
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 4 avaliou mudança pontual: #ExternalEndpoint ganhou campo
			code: #ExternalSystemRef para identidade canônica de sistemas
			externos. #ExternalSystemRef adicionado como string com regex
			^ext-[a-z][a-z0-9-]*$ — prefixo ext- distingue de BCs internos.
			Alinhado com #ContextOrSystemRef no canvas.cue que aceita ambos
			os padrões. Consistente com a convenção de refs tipados existente
			(#BoundedContextRef, #SubdomainRef, #DomainLevelTransversalRef).
			Verificação: (uq-03) #ExternalSystemRef usado apenas em
			#ExternalEndpoint.code, referência válida. (uq-06) nomenclatura
			consistente com *Ref pattern. (uq-08) cue vet passa. Zero findings.
			"""
	}]

	findings: {}

	summary: """
		Schema #ContextMap estável no round 4. Rounds 1-2 avaliaram versões
		anteriores (ownership opcional→obrigatório, knownFlows→declaredFlows).
		Round 3 avaliou evolução substancial: endpoints tipados com union
		(internal/external), direction explícita, communication com type
		(sync/async/hybrid), FlowPayload com events/commands/queries tipados
		e simetria enforced por tipo, publishedLanguage enforced por variante
		(obrigatório em PL, proibido em não-PL), conformistCascadeRisk
		localizado, external relationships (12 variantes), customer-supplier,
		domainLevelTransversals, ContextEntry expandido, FeedbackLoop como
		union discriminado. Round 4: #ExternalEndpoint.code com
		#ExternalSystemRef (regex ext-*) para identidade canônica de
		sistemas externos, alinhado com #ContextOrSystemRef do canvas.
		14 quality criteria (12 fail, 2 warn). Zero findings em 4 rounds.
		"""
}
