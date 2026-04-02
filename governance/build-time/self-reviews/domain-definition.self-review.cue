package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainDefinitionSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-domain-definition-regex-tighten"

	artifactPath:       "architecture/artifact-schemas/domain-definition.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-02"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Mudança é estritamente mecânica: apertar regex de 3 campos
		ID (Mechanism.id, CostEliminated.id, CapabilityCreated.id) e
		1 campo ref (CostEliminated.mechanismRef) de string & !="" para
		regexes que correspondem exatamente aos padrões já usados pela
		instância (mech-*, ce-NN, cc-NN) e já enforçados por consumidores
		downstream (subdomain.cue, canvas.cue, stakeholder-map.cue,
		cross-context-flow.cue). Nenhum campo novo, nenhum tipo novo,
		nenhuma semântica alterada. Instância existente já conforma —
		mudança apenas fecha gap entre contrato implícito e explícito.
		Round único justificado porque não há decisão de design, apenas
		alinhamento de fonte com consumidores.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Verificação das 4 regexes propostas contra instância
			domain/domain-definition.cue: mech-evidence, mech-agent-gate,
			mech-three-sots, mech-network, mech-scd todos match
			^mech-[a-z][a-z0-9-]*$. ce-01..ce-07 match ^ce-[0-9]{2}$.
			cc-01..cc-05 match ^cc-[0-9]{2}$. mechanismRef values
			(mech-evidence, mech-agent-gate, mech-three-sots, mech-network,
			mech-scd) match ^mech-[a-z][a-z0-9-]*$. Zero findings.
			Nenhum campo novo adicionado, nenhum critério de qualidade
			alterado, nenhuma mudança estrutural.
			"""
	}]

	findings: {}

	summary: """
		Aperto de regex em #Mechanism.id, #CostEliminated.id,
		#CapabilityCreated.id e #CostEliminated.mechanismRef no schema
		#DomainDefinition. Alinha fonte (domain-definition) com padrões
		já enforçados por consumidores downstream (subdomain, canvas,
		stakeholder-map, cross-context-flow). Instância existente já
		conforma. Estável em 1 round — mudança mecânica sem decisão
		de design.
		"""
}
