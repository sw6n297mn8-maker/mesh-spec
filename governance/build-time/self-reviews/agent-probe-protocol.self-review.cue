package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentProbeProtocol: build_time.#SelfReviewReport & {
	reportId: "srr-agent-probe-protocol"

	artifactPath:       "architecture/artifact-schemas/agent-probe-protocol.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-31"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do schema #AgentProbeProtocol (Ciclo 4, adr-134). Avaliado
			contra 8 universalCriteria + 3 type-specific de #ArtifactSchema (tq-as).

			uq-01 (rationale=WHY): rationales em isolation, _qualityCriteria e
			_schema.location explicam POR QUE — ex.: isolation.rationale ancora o
			contrato no probe-por-reconstrução (canvas como único input neutraliza
			confirmação do design existente). Pass.
			uq-02 (Mesh-specific): substitution falha — o protocolo é o Ciclo 4 de
			feedback de build-time específico da Mesh (P10 advisory, adr-040), não
			validação genérica. Pass.
			uq-03 (refs existem): #ProbeFindingCategory definido em agent-probe-record.cue
			(mesmo package); adr-040/P10 existem. Pass.
			uq-04 (princípios): coerente com P10 (probe é advisory — recomenda buracos,
			não gateia) e P0 (_schema.location singleton declara lar único). Pass.
			uq-05 (limitações): closingDoD declara o limite (probe não corrige a spec —
			só registra buracos; correção é trabalho separado do BC alvo). Pass.
			uq-06 (ubiquitous language): termos estáveis — probe, isolation, finding,
			taxonomy, cleanSession. Pass.
			uq-07 (zero placeholder): nenhum TODO/TBD. Pass.
			uq-08 (conforma schema): _schema.location com 6 campos (canonicalPathRegex
			singleton architecture/agent-probes/protocol.cue, fileNameRegex, description,
			rationale, cardinality singleton, allowNested false); _qualityCriteria
			aninhado em #AgentProbeProtocol. cue vet EXIT=0. Pass.
			tq-as-01 (localização canônica): _schema.location presente e preenchido. Pass.
			tq-as-02 (critérios acionáveis): tq-app-01/02 têm test concreto (isolation
			exclui domain-model/ADRs; findingTaxonomy = as 7 categorias: gaps reais
			(3 defeito + cross-bc-gap), não-defeitos (deferred-by-design/already-specified)
			e probe-noise). Pass.
			tq-as-03 (rationale do conjunto): _qualityCriteria.rationale explica a
			cobertura (isolamento + taxonomia como as duas dimensões que definem o
			protocolo). Pass.
			"""
	}]

	findings: {}

	summary: """
		#AgentProbeProtocol materializa o protocolo agent-probe do Ciclo 4 como
		schema self-contained (estilo validation-prompt, camada P10 advisory):
		isolation contract (cleanSession, allowedInputs:[canvas],
		excludedInputs:[domain-model,ADRs,glossary], promptNonRevealing), probeTask,
		promptTemplate{version,template}, findingTaxonomy (#ProbeFindingCategory) e
		closingDoD em prosa. Singleton em architecture/agent-probes/protocol.cue.
		Estável em 1 round, zero findings; todos os 11 critérios passam.
		"""

	singleRoundRationale: """
		Schema desenhado a partir de spec detalhada do founder (campos de isolation,
		taxonomy, promptTemplate explicitamente enumerados na autorização do Ciclo 4),
		mirror estrutural de validation-prompt.cue (artifact-schema self-contained
		recente e validado). Critérios são verificáveis por inspeção direta:
		conformance ao meta-schema é estrutural (uq-08/tq-as-01), acionabilidade dos
		critérios é verificável pelos testes concretos. Sem ambiguidade pendente.
		"""
}
