package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr037: artifact_schemas.#ADR & {
	id:    "adr-037"
	title: "Two-level agent governance: global defaults + per-agent envelope"
	date:  "2026-04-02"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		WI-022 introduz #AgentSpec como schema para definição operacional
		de agentes por BC. A questão central é onde e como governar esses
		agentes: autonomia, escalation, observability, limites operacionais.
		Três lenses foram aplicadas: lens-ai-agent-governance (autonomia,
		escalation), lens-security-trust-infrastructure (inputTrustLevel,
		operationalScope) e lens-regulatory-compliance-as-architecture
		(audit trail, constraints). O diagnóstico convergiu para separar
		comportamento operacional (o que o agente faz) de governança
		operacional (como o agente é supervisionado).
		Alternativa considerada e rejeitada: agent-spec monolítico com
		governança inline — todos os campos de governança (lifecycle stage,
		blast radius caps, drift detection, HITL calibration, promotion/
		regression) embutidos no próprio #AgentSpec. Rejeitada porque:
		(a) mistura concerns com ritmos de mudança diferentes — calibração
		de autonomia muda por track record, spec operacional muda por
		redesign; (b) agent-spec ficaria excessivamente grande e complexo;
		(c) governança global (defaults transversais) não tem ponto de
		ancoragem natural dentro de um spec por-agente.
		"""

	decision: """
		Governança de agentes opera em dois níveis:
		1. Global (architecture/agent-governance.cue): defaults de autonomia,
		   taxonomias transversais, políticas que se aplicam a todos os agentes.
		   Schema: #AgentGovernanceGlobal (a ser definido por WI-028).
		2. Per-agent envelope (contexts/{bc}/agents/{name}.governance.cue):
		   limites específicos, thresholds, overrides, lifecycle stage,
		   calibração dinâmica. Schema: #AgentGovernanceEnvelope (a ser
		   definido por WI-028).
		O #AgentSpec não replica governança; declara comportamento operacional
		e referencia seu envelope via campo governanceRef. Fronteira:
		- agent-spec declara QUANDO escalar (escalationConditions)
		- governance envelope declara COMO escalar (canal, SLA, destinatário)
		- agent-spec declara nível de autonomia por ação (autonomyLevel)
		- governance envelope declara calibração dinâmica (promoção/regressão)
		Quatro campos em #AgentSpec são informados por esta decisão:
		governanceRef, autonomyLevel (por ação), inputTrustLevel (por ação,
		opcional), escalationConditions (6 categorias de incerteza).
		"""

	consequences: """
		Positivas: (1) Separação clara de concerns — spec operacional e
		governança evoluem independentemente. (2) Governança global evita
		repetição de defaults em cada envelope. (3) governanceRef cria
		ponte validável por runner entre spec e envelope. (4) escalationConditions
		com categorias tipadas (#EscalationCategory) tornam incerteza
		operacional explícita e auditável. (5) autonomyLevel por ação
		(Sheridan 4 níveis) permite granularidade sem complexidade de
		tabela NxM.
		Negativas: (1) Dois artefatos por agente (spec + envelope) em vez
		de um — overhead de manutenção proporcional ao número de agentes
		(~30 estimados). (2) Dependência sequencial: #AgentGovernanceEnvelope
		e #AgentGovernanceGlobal (WI-028) ainda não existem — governanceRef
		é validável por regex mas não por existência até WI-028 ser
		completado. Runner deve tratar ausência de envelope como erro
		gracioso até schemas de governança existirem. (3) inputTrustLevel
		opcional — enforcement de presença em ações com input externo
		depende de runner (tq-ag-11), não do type system CUE.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/agent-spec.cue",
	]

	derivedArtifacts: [
		"architecture/agent-governance.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
	]

	rationale: """
		Agentes AI em intermediário financeiro regulado operam com autonomia
		variável e requerem supervisão proporcional. Monolito spec+governança
		mistura ritmos de mudança e impede defaults transversais. Dois níveis
		(global + per-agent envelope) com spec operacional separado é a
		decomposição mínima que preserva separação de concerns, permite
		governança proporcional, e mantém rastreabilidade via governanceRef.
		Lenses ai-agent-governance, security-trust-infrastructure e
		regulatory-compliance-as-architecture informaram os 4 campos novos.
		Reversibility high porque não há instâncias commitadas nem dados
		persistidos. blastRadius cross-artifact porque afeta agent-spec
		schema e quality-criteria.cue, e cria dependência futura com
		WI-028 (governance envelope schemas).
		"""
}
