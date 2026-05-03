package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr030: artifact_schemas.#ADR & {
	id:    "adr-030"
	title: "Shared strategic classification type and subdomain schema evolution"
	date:  "2026-03-24"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		ADR-029 criou subdomain.cue com classificação reutilizando
		#BCClassification definida localmente em canvas.cue. Essa
		abordagem funciona, mas cria dependência de import entre
		artifact schemas e fragilidade semântica: canvas.cue é owner
		de um tipo que na verdade é vocabulário estratégico do domínio,
		não do canvas. Além disso, o subdomain schema precisa evoluir
		para incluir: rastreabilidade ao domain-definition via
		mechanismRefs, costRefs e capabilityRefs; definition separado
		de purpose; #DelegationTarget tipado para negativeBoundaries;
		e constraints condicionais de densidade para core-subdomain.
		A alternativa — manter #BCClassification no canvas e evoluir
		apenas o subdomain — foi rejeitada porque perpetua ownership
		incorreto do tipo e impede que futuros consumidores importem
		a classificação sem depender de canvas.
		"""

	decision: """
		(1) Criar architecture/shared-types/strategic-classification.cue
		com package shared_types, definindo #SubdomainClassification
		como tipo canônico ("core-subdomain" | "supporting-subdomain" |
		"generic-subdomain"). (2) Em canvas.cue, importar shared_types
		e redefinir #BCClassification como alias permanente de
		shared_types.#SubdomainClassification — estado final aceitável,
		não ponte temporária; consumidores de canvas continuam usando
		#BCClassification como vocabulário contextualizado ao BC, enquanto
		a source of truth semântica vive em shared_types. (3) Substituir
		subdomain.cue com schema evoluído: import de shared_types;
		definition (espaço de problema) separado de purpose (justificativa
		de separação); mechanismRefs, costRefs e capabilityRefs com tipos
		dedicados (#MechanismRef, #CostRef, #CapabilityRef);
		#DelegationTarget como união discriminada subdomain/external-system
		para negativeBoundaries; invariantes estruturais para core-subdomain
		via constraints condicionais CUE (exige mechanismRefs, costRefs,
		capabilityRefs e strategicProfile preenchidos); quality criteria
		expandidos (tq-sd-01 a tq-sd-08) cobrindo identidade, contorno,
		rastreabilidade, governança de core, consistência cross-artifact,
		definition e lifecycle.
		"""

	consequences: """
		Positivas: tipo de classificação estratégica tem ownership
		correto em shared-types, eliminando dependência canvas→subdomain;
		subdomain ganha rastreabilidade formal ao domain-definition via
		3 tipos de ref; negativeBoundaries com #DelegationTarget
		discriminam subdomínio interno de sistema externo; invariantes
		estruturais para core-subdomain garantem densidade mínima por
		construção CUE. Negativas: novo diretório architecture/shared-types/
		a ser governado — shared-types é reservado a vocabulário canônico
		transversal, semanticamente neutro em relação a artifact families
		específicas; não deve se tornar repositório genérico de tipos
		utilitários. ADR-029 superseded — schema original nunca foi
		instanciado, custo de migração é zero.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/canvas.cue",
		"architecture/artifact-schemas/subdomain.cue",
	]

	plannedOutputs: [
		"architecture/shared-types/strategic-classification.cue",
	]

	supersedes: ["adr-029"]

	principlesApplied: [
		"P0",
		"P1",
		"P12",
	]

	rationale: """
		Vocabulário estratégico compartilhado pertence a um package
		dedicado, não a um artifact schema específico. Extrair
		#SubdomainClassification para shared-types aplica P0 (single
		source of truth para classificação — o tipo existe em um único
		lugar, consumidores são ponteiros). P1 justifica a extração
		como tipo importável: schemas CUE são source of truth de
		contratos, e um tipo definido dentro de um artifact schema
		específico não é importável de forma limpa por outros schemas
		sem criar acoplamento indevido; shared-types resolve isso
		tornando o tipo um contrato canônico com package próprio.
		Evolução do subdomain schema com mechanismRefs, costRefs e
		capabilityRefs fecha o gap de rastreabilidade
		subdomínio→domain-definition. #DelegationTarget tipado elimina
		ambiguidade entre subdomínio interno e sistema externo em
		negativeBoundaries. Invariantes estruturais para core-subdomain
		impõem densidade mínima por construção CUE, não por protocolo
		— alinhado com P12 (governança como código, imposta
		automaticamente).
		"""
}
