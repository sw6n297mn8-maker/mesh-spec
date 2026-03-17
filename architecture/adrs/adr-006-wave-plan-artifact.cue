package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr006: artifact_schemas.#ADR & {
	id:    "adr-006"
	title: "Introdução do artefato wave-plan com schema tipado"
	date:  "2026-03-17"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O repositório precisa de um plano formal de execução que
		defina quais artefatos são criados em cada wave, suas
		dependências e outputs esperados. Sem isso, a ordem de
		trabalho é implícita e não verificável. O wave-plan.cue
		estava previsto no README mas sem schema de validação.
		"""

	decision: """
		Criar schema #WavePlan em architecture/artifact-schemas/
		e instância em governance/wave-plan.cue. O schema inclui:
		(a) #WaveTask com separação explícita entre outputs
		(artefatos produzidos diretamente) e affects (superfície
		semântica impactada); (b) constraint de unicidade global
		de task IDs via list.UniqueItems; (c) validação de
		dependências via list.Contains contra IDs existentes no
		plano. Também corrige #TaskGovernanceRule em
		work-governance.cue (fechar união discriminada) e alinha
		#TaskSpec.outputs com tipagem estruturada (#TaskOutput).
		"""

	consequences: """
		Positivas: ordem de execução verificável, dependências
		validadas por CUE e CI, blast radius explícito por tarefa,
		separação clara entre produção direta e impacto indireto,
		#TaskGovernanceRule não aceita mais campos do scope oposto.
		Negativas: overhead de manutenção do wave-plan (mitigado
		por ser singleton atualizado por wave, não por task).
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/wave-plan.cue",
		"governance/wave-plan.cue",
		"governance/build-time/work-governance.cue",
	]

	principlesApplied: [
		"P0",
		"P3",
		"P10",
	]

	rationale: "Wave-plan tipado transforma ordem de execução de conhecimento implícito em artefato verificável. Constraints testados empiricamente com cue vet antes de commit."
}
