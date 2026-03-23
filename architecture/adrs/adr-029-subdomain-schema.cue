package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr029: artifact_schemas.#ADR & {
	id:    "adr-029"
	title: "Subdomain artifact schema + BCClassification relocation"
	date:  "2026-03-23"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		WI-012 requer schema #Subdomain para que instâncias de subdomínios
		em strategic/subdomains/ sejam validáveis por CI. Adicionalmente,
		#BCClassification (core/supporting/generic) foi definido em
		canvas.cue, mas classificação é conceito de camada estratégica
		que o subdomínio origina e o canvas herda. A colocação atual
		inverte a direção semântica. A alternativa — manter
		#BCClassification no canvas — foi rejeitada porque obscurece
		a origem do conceito e cria dependência semântica invertida
		(estratégico depende de tático para sua tipagem).
		"""

	decision: """
		Criar architecture/artifact-schemas/subdomain.cue com #Subdomain
		definindo: id, name, classification (#BCClassification),
		responsibility, boundedContexts (lista de bcRef validável por CI),
		mechanismRefs (referências a mech-* de domain-definition.cue).
		Mover #BCClassification de canvas.cue para subdomain.cue — ambos
		no mesmo CUE package, acesso inalterado. Quality criteria com
		prefixo tq-sd-NN diferenciando obrigatoriedade de mechanismRefs
		por classification (core/supporting vs generic). Invariante
		cross-file de unicidade BC-subdomínio registrada como enforcement
		CI futuro, não como constraint de schema individual.
		"""

	consequences: """
		Positivas: instâncias de subdomínio validáveis por CI;
		#BCClassification vive em sua origem semântica; mechanismRefs
		garante rastreabilidade tese→mecanismo→subdomínio para
		core/supporting; critérios condicionais por classification
		evitam false positives em generic-subdomain.
		Negativas: canvas.cue depende implicitamente de subdomain.cue
		para #BCClassification (via package). Unicidade de BC entre
		subdomínios não é enforçável por schema individual — requer
		CI cross-file (enforcement diferido).
		"""

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/subdomain.cue",
		"architecture/artifact-schemas/canvas.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P12",
	]

	rationale: """
		Subdomínio é a unidade de classificação estratégica da Mesh —
		decisões de investimento (core vs generic), alocação de agentes
		e priorização de features derivam da classificação do subdomínio.
		Schema formal é extensão de P0 (estrutura canônica), P1 (schemas
		CUE como source of truth) e P12 (validação por CI). Relocação de
		#BCClassification corrige inversão semântica: classificação nasce
		na camada estratégica (subdomínio) e é herdada pela camada tática
		(canvas). mechanismRefs ancoram cada subdomínio nos mecanismos
		específicos da Mesh, mantendo rastreabilidade tese→mecanismo→
		subdomínio→BC.
		"""
}
