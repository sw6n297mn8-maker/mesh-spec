package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr032: artifact_schemas.#ADR & {
	id:    "adr-032"
	title: "Introduce #CrossContextFlow artifact schema"
	date:  "2026-03-30"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Durante a avaliação DDD dos 18 subdomínios (Option C), identificou-se
		que ECL (Economic Commitment Lifecycle) é um processo/coreografia
		disfarçado de subdomínio — falha no teste 'se o fluxo mudar, a área
		de conhecimento continua existindo?'. A reestruturação exige decompor
		ECL em subdomínios reais (CMT, BDG, DLV, INV) e modelar a progressão
		cross-BC como artefato descritivo. O repositório não possuía artifact
		schema para fluxos cross-context. O diretório
		architecture/cross-context-workflows/ existia vazio, indicando intenção
		prévia não concretizada. Alternativa considerada: usar markdown ou
		diagrama ad hoc para documentar o fluxo — rejeitada porque viola o
		princípio de formato (todo artefato autoral é CUE) e não permite
		validação por CI.
		"""

	decision: """
		Criar artifact schema #CrossContextFlow em
		architecture/artifact-schemas/cross-context-flow.cue. O schema modela
		composição linear de bounded contexts com ownership por fase,
		invariantes emergentes com contribuições rastreáveis, conceitos
		cross-cutting com origem e consumidores, conectividade verificável
		entre fases via #PhaseConsumer, e failure modes opcionais. Instâncias
		vivem em architecture/cross-context-workflows/. O schema é agnóstico
		a runtime — choreography, orchestration e saga são decisões posteriores.
		Dois tipos novos: #BoundedContextRef (string typed) e #PolicyRef
		(string com prefixo pol-). Tipos existentes (#MechanismRef, #CostRef,
		#CapabilityRef, #SubdomainRef) reusados sem modificação.
		"""

	consequences: """
		Positivas: (1) fluxos cross-BC são artefatos governados com schema,
		quality criteria e self-review — não diagramas informais. (2) A
		decomposição de ECL em subdomínios reais tem onde documentar a
		coreografia resultante. (3) Conectividade entre fases é verificável
		por CI via #PhaseConsumer.consumes. (4) #BoundedContextRef fica
		disponível para reuso em outros schemas.
		Negativas: (1) v1 suporta apenas fluxo linear — branches e
		paralelismo ficam fora do escopo, exigindo evolução futura se
		necessário. (2) #ArtifactType em quality-criteria.cue precisará
		incluir 'cross-context-flow' quando o tipo entrar no regime de
		self-review isolado. (3) Referências entre fases são por nome
		(string), sem validação CUE nativa — enforcement depende de CI.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/cross-context-flow.cue",
	]

	derivedArtifacts: [
		"governance/build-time/self-reviews/cross-context-flow.self-review.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"dp-01",
		"dp-03",
		"dp-05",
	]

	rationale: """
		Schema nasce da necessidade concreta de modelar o commitment lifecycle
		como composição de BCs independentes após identificar que ECL é
		processo, não subdomínio. Design informado por 7 lenses analíticas
		(theory-of-firm, domain-language, supply-chain-theory,
		information-economics, complex-adaptive-systems, mechanism-design,
		event-driven-architecture) e 3 rounds de red team. Decisão de
		ownership por BC (não subdomínio) segue dp-03 — blast radius é
		contido por context, não por abstração estratégica. Decisão de
		conectividade verificável (#PhaseConsumer) segue dp-05 —
		auditabilidade por construção.
		"""
}
