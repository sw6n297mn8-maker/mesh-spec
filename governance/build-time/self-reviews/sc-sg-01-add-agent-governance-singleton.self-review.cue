package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scSg01AddAgentGovernanceSingleton: build_time.#SelfReviewReport & {
	reportId: "srr-sc-sg-01-add-agent-governance-singleton"

	artifactPath:       "architecture/structural-checks/singleton-coverage.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Edição change-on-touch em sc-sg-01 (singleton-coverage): adiciona
			"agent-governance" a rule.requiredSingletons no MESMO commit que cria o
			singleton global architecture/agent-governance.cue (adr-037, governança
			em dois níveis). O comentário do check já antecipava esta extensão
			("agent-governance global entra na whitelist quando criado").

			Conformidade ao schema (#StructuralCheck):
			- id "sc-sg-01", kind "singleton-coverage", artifactType "artifact-schema"
			  inalterados; apenas requiredSingletons cresce de 4 → 5 nomes.
			- tq-srr-01 (identidade): PASS — artifactPath (singleton-coverage.cue) +
			  artifactSchemaPath (structural-check.cue) + artifactType structural-check
			  identificam o artefato sem ambiguidade.
			- tq-srr-02 (rounds↔status): PASS — roundsExecuted 1 == len(roundDetails);
			  stable com failCount 0 no único round; sem fail findings.
			- tq-srr-04/05 (severity/especificidade): PASS — sem findings; summary
			  ancora no elemento concreto (requiredSingletons, nome agent-governance).

			Verificação semântica do check após a edição: o schema homônimo
			#AgentGovernanceGlobal (architecture/artifact-schemas/agent-governance.cue)
			declara _schema.location.cardinality "singleton" com canonicalPathRegex
			literal-âncora ^architecture/agent-governance\\.cue$, e o arquivo nesse
			path passa a existir no mesmo commit — então sc-sg-01 permanece VERDE
			(não introduz violação de regressão). Sem este pareamento no mesmo commit,
			a entrada nova falharia a própria trava (errorMessage do check).

			Verificação local (cue v0.16.0): cue vet ./architecture/... exit 0 com a
			lista de 5 singletons; export de rule.requiredSingletons concretiza
			["agent-governance","context-map","domain-definition","repo-structure",
			"stakeholder-map"].
			"""
	}]

	findings: {}

	summary: """
		Self-review da extensão change-on-touch de sc-sg-01 (singleton-coverage):
		acrescenta "agent-governance" a requiredSingletons no commit que materializa
		o singleton global architecture/agent-governance.cue (adr-037). Mudança de
		uma linha na lista; check permanece verde porque o schema #AgentGovernanceGlobal
		é singleton e o arquivo passa a existir no mesmo commit. 4 critérios tq-srr
		aplicáveis PASS; sem findings. cue vet local OK.
		"""

	singleRoundRationale: "Edição de escopo mínimo (uma entrada adicionada a uma lista) cujo pareamento com a criação do arquivo singleton é verificável no mesmo commit; conformidade ao #StructuralCheck e neutralidade da trava (check segue verde) confirmadas por cue vet local. Rounds adicionais não revelariam novos findings."
}
