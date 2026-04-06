package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr039: artifact_schemas.#ADR & {
	id:    "adr-039"
	title: "domainAgentSpec references canonical artifact paths instead of logical IDs"
	date:  "2026-04-06"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O context-map referencia agent specs de cada BC via campo
		domainAgentSpec. Na versão original, o valor era um ID lógico
		curto (e.g., "agt-cmt-primary") sem correspondência direta com
		o filesystem. O canvas CMT (WI-039) estabeleceu a convenção de
		usar path canônico do artefato (e.g.,
		"contexts/cmt/agents/cmt-primary-agent.cue") — verificável
		diretamente por runner sem tabela de tradução. O canvas CTR
		adotou a mesma convenção. O context-map permaneceu com IDs
		lógicos, criando inconsistência entre o SoT de fronteiras
		(context-map) e o SoT local do BC (canvas). Alternativa
		considerada: manter ID lógico com tabela de tradução no runner
		— rejeitada porque adiciona indireção sem valor e diverge da
		convenção já adotada nos canvas.
		"""

	decision: """
		(1) domainAgentSpec no context-map passa a conter o path
		canônico do agent spec: contexts/{bc}/agents/{bc}-primary-agent.cue.
		(2) Comentário do campo no schema context-map.cue atualizado
		para documentar formato e convenção. (3) Header do context-map
		atualizado com bloco de convenção de referência de agent specs.
		(4) Estado transitório documentado: o context-map declara paths
		canônicos para todos os 25 BCs; a existência física dos arquivos
		é progressiva — runner deve distinguir entre formato correto da
		referência (validável agora) e existência material do artefato
		(validável quando agent spec for criado). (5) Schema mantém
		campo como string simples — validação de coerência entre BC do
		contexto e BC embutido no path é responsabilidade do runner,
		não do type system.
		"""

	consequences: """
		Positivas: (1) Referências são resolvíveis diretamente pelo
		runner sem tabela de tradução. (2) Alinhamento
		filesystem↔context-map↔canvas elimina ambiguidade. (3) Runner
		pode validar formato imediatamente e existência progressivamente.
		Negativas: (1) 23 dos 25 paths apontam para arquivos que ainda
		não existem — runner deve tratar como warn, não fail, até que
		o agent spec do BC seja criado. (2) Se a convenção de naming
		de agent specs mudar, 25 valores no context-map precisam ser
		atualizados — custo mecânico aceitável dado que a convenção é
		estável e derivável do BC code.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"strategic/context-map.cue",
		"architecture/artifact-schemas/context-map.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
	]

	rationale: """
		Convenção de path canônico já estava em uso nos canvas (CMT,
		CTR). Context-map como SoT de fronteiras deve alinhar com a
		convenção dos canvas para evitar drift. Reversibility high
		porque é mudança de formato de string sem dependentes que
		consumam o valor antigo. blastRadius cross-artifact porque
		afeta context-map (strategic) e schema (architecture).
		"""
}
