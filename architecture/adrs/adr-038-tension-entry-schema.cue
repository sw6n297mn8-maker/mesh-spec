package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr038: artifact_schemas.#ADR & {
	id:    "adr-038"
	title: "Create #TensionEntry artifact schema for tension log"
	date:  "2026-04-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		CLAUDE.md seção 2 define que decisões concretas que tensionam
		axiomas devem ser registradas em architecture/tension-log/
		conforme schema architecture/artifact-schemas/tension-entry.cue.
		Porém o schema não existia — o tension-log só tinha .gitkeep.
		Tensões eram registradas apenas em campos rationale de artefatos
		individuais, invisíveis para agentes operando em outros BCs e
		irrecuperáveis após a sessão que as identificou. Caso concreto:
		vo-lineage no CTR domain model tem tensão de schema-limitation
		(#DomainField não suporta optionalidade intra-VO) que só existe
		no rationale do VO — agente do CMT não encontra essa informação.
		Alternativa considerada: manter tensões exclusivamente em campos
		rationale — rejeitada porque dispersão torna tensões inacessíveis
		para agentes cross-context e impossibilita reavaliação sistemática
		quando o contexto muda.
		"""

	decision: """
		Criar #TensionEntry em architecture/artifact-schemas/tension-entry.cue
		com: (1) 3 tipos de tensão (#TensionKind: axiom-tension,
		schema-limitation, cross-artifact-friction) cobrindo os padrões
		observados; (2) tensionTarget com regex que aceita ids de axioma
		(ax-XX), princípio (dp-XX, PX) ou paths de schema; (3) manifestsIn
		com regex de path (.cue|.md); (4) ciclo de vida simples
		(#TensionStatus: open, accepted, resolved); (5) relatedADR
		opcional para rastreabilidade bidirecional com ciclo de decisão;
		(6) structuralResolutionPath opcional para indicar caminho de
		resolução definitiva; (7) 4 quality criteria (tq-te-01 a tq-te-04)
		cobrindo target identificável, resolution concreta, manifestação
		rastreável e resolved exige evidência.
		Adicionar "tension-entry" a #ArtifactType em quality-criteria.cue.
		Lense aplicada: lens-knowledge-management (tensão como unidade de
		conhecimento organizacional externalizável).
		"""

	consequences: """
		Positivas: (1) Tensões têm contrato de conformidade validável
		por cue vet. (2) Agentes stateless recuperam trade-offs aceitos
		em sessões anteriores via tension-log. (3) tq-te-04 impede
		'resolved por decreto' — exige evidência rastreável. (4) Regex
		em tensionTarget e manifestsIn reduzem lixo estrutural no shape.
		(5) relatedADR conecta tension-log ao ciclo de decisão formal.
		Negativas: (1) tensionTarget é singular — tensão multi-target
		requer uma entry por target ou descrição composta (limitação
		declarada no header). (2) date valida formato mas não validade
		real (2026-99-99 passa). Aceitável para v1. (3) Optionalidade
		de previousVersion em vo-lineage não é enforçável pelo shape
		de #TensionEntry — enforcement fica no quality criterion tq-te-04.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/tension-entry.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
	]

	rationale: """
		Tension-log schema é estruturante para o mecanismo de
		tensionabilidade de axiomas definido em CLAUDE.md seção 2.
		Sem schema, CLAUDE.md referencia artefato inexistente e
		agentes não têm contrato para validar instâncias. SoT de
		tensões ancora em P1 (CUE como SoT). Registro explícito de
		trade-offs ancora em P0 (cada decisão de design é registrada).
		Lens knowledge-management informou externalização de tensões
		como unidade de conhecimento organizacional. Reversibility
		high porque não há instâncias commitadas. blastRadius
		cross-artifact porque expande #ArtifactType em
		quality-criteria.cue e tensões referenciam artefatos de
		múltiplos BCs.
		"""
}
