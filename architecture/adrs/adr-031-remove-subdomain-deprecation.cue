package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr031: artifact_schemas.#ADR & {
	id:    "adr-031"
	title: "Remove subdomain deprecation — subdomínio que deixa de existir é deletado"
	date:  "2026-03-24"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		O schema de subdomain (ADR-030) incluía união discriminada
		active/deprecated com #SubdomainDeprecation (absorbedBy, reason,
		rationale) e critério tq-sd-08 para validar completude de
		deprecação. Na prática, subdomínio deprecated é artefato morto
		que ocupa espaço no repositório e cria ambiguidade: existe como
		arquivo mas não representa responsabilidade ativa. O caso
		concreto (PSO absorvido por ECL+FCE) demonstrou que o artefato
		deprecated não agrega informação — a rastreabilidade da absorção
		já está nos rationales dos absorvedores. A alternativa — manter
		a união discriminada no schema mas nunca instanciar subdomínios
		deprecated — foi rejeitada porque preserva complexidade morta
		(branch nunca exercitada, tipo nunca instanciado, critério
		tq-sd-08 sem cobertura real) e sugere a futuros agentes que
		deprecação é caminho válido.
		"""

	decision: """
		(1) Remover união discriminada active/deprecated de #Subdomain —
		schema passa a ser struct direta, sem branch por status.
		(2) Remover campo status de #Subdomain e de todas as instâncias.
		(3) Remover #SubdomainDeprecation. (4) Remover critério tq-sd-08.
		(5) Subdomínio que deixa de existir é deletado do repositório —
		o commit de deleção e os rationales dos absorvedores são a
		rastreabilidade suficiente. (6) Atualizar ECL para remover
		limitação conhecida sobre subdomain refs inexistentes (agora
		resolvida com criação dos subdomínios restantes).
		"""

	consequences: """
		Positivas: schema mais simples, sem branch morta; elimina
		categoria de artefato ambíguo (existe mas não opera); PSO
		simplesmente não terá arquivo. Negativas: perda de
		rastreabilidade estruturada de absorção dentro do artefato
		deprecado — mitigada pelo fato de que rationales dos absorvedores
		já documentam a origem das responsabilidades, e o histórico git
		preserva o registro completo.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/subdomain.cue",
		"strategic/subdomains/ecl.cue",
		"strategic/subdomains/fce.cue",
		"strategic/subdomains/nim.cue",
		"strategic/subdomains/rew.cue",
		"strategic/subdomains/ngr.cue",
	]

	principlesApplied: [
		"P0",
	]

	rationale: """
		Artefato deprecated viola o espírito de P0: é informação que
		existe em dois lugares (no artefato morto e nos rationales dos
		absorvedores). Deletar o arquivo e confiar no histórico git +
		rationales dos absorvedores é mais limpo e elimina a
		possibilidade de drift entre o artefato deprecated e o estado
		real do sistema. Schema sem branch deprecated é mais simples
		de validar e de instanciar.
		"""
}
