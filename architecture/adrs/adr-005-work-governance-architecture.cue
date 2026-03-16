package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr005: artifact_schemas.#ADR & {
	id:    "adr-005"
	title: "Arquitetura de governança de trabalho para coordenação de agentes"
	date:  "2026-03-16"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	context: """
		O repositório mesh-spec será operado por múltiplos agentes de IA
		coordenando trabalho de especificação. Sem governança formal, não
		há visibilidade do que precisa ser feito, ordem de execução
		verificável, recuperação de tarefas abandonadas, nem prova de
		conclusão. O modelo atual (founder aprova via chat) funciona para
		1 agente, mas não escala sem perder auditabilidade.
		"""

	decision: """
		Criar sistema de governança de trabalho em governance/build-time/
		com 4 camadas separadas: (a) TaskSpec para definição normativa;
		(b) backlog admission via eventos; (c) execution com state machine
		dual (admission × execution); (d) projeções como materialização
		descartável. O sistema usa event sourcing leve sobre git — o
		agente materializa um command como proposta de append de evento ao
		stream; o evento só se torna fato canônico após validação no
		merge + CI. Implementação incremental em 3 fases: mínimo
		funcional (agora), governança formal (2+ agentes), robustez
		(evidência de falha).
		"""

	consequences: """
		Positivas: coordenação determinística entre agentes, auditabilidade
		completa via event streams, recuperação automática de claims
		abandonados via leases peer-based, prova de conclusão com
		validation gates, orquestração descentralizada sem scheduler
		central. Negativas: overhead de governança para tarefas triviais
		(mitigado por implementação incremental), complexidade de state
		machine dual (mitigada por CI enforcement).
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"governance/build-time/work-governance.cue",
	]

	principlesApplied: [
		"P0",
		"P3",
		"P6",
		"P8",
		"P10",
		"P11",
		"P12",
	]

	rationale: "Governança de trabalho é pré-requisito para operação multi-agente segura. Decisão foundational porque define o modelo de coordenação de todo o build-time."
}
