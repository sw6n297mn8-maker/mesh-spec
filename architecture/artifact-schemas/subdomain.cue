package artifact_schemas

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"

// subdomain.cue — Artifact schema para classificação estratégica de subdomínios.
//
// Cada subdomínio representa uma partição do espaço de problema,
// classificada estrategicamente e rastreável ao domain-definition.cue
// por mecanismo, custo eliminado e capability criada.
//
// União discriminada por status:
//   - status == "active"     → deprecation proibido
//   - status == "deprecated" → deprecation obrigatório

#Subdomain: #SubdomainCommon & ({
	status:       "active"
	deprecation?: _|_
} | {
	status:      "deprecated"
	deprecation: #SubdomainDeprecation
})

#SubdomainCommon: {
	// Código canônico do subdomínio.
	// Deve coincidir com o nome do arquivo em strategic/subdomains/<code>.cue.
	code: string & =~"^[a-z][a-z0-9-]*$"

	// Nome legível do subdomínio.
	name: string & !=""

	// O que este subdomínio é — qual espaço de problema cobre.
	definition: string & !=""

	// Por que este subdomínio existe como unidade separada.
	purpose: string & !=""

	// Classificação estratégica canônica compartilhada.
	type: shared_types.#SubdomainClassification

	// Status do lifecycle — discriminante da união em #Subdomain.
	// Constraint de presença/ausência de deprecation é imposto pela
	// união discriminada em #Subdomain.
	status: "active" | "deprecated"

	// Dados de deprecação (preenchido apenas quando status == "deprecated").
	deprecation?: #SubdomainDeprecation

	// Referências a mecanismos canônicos do domain-definition.
	mechanismRefs?: [...#MechanismRef]

	// Referências a custos eliminados (ce-NN) do domain-definition.
	costRefs?: [...#CostRef]

	// Referências a capabilities criadas (cc-NN) do domain-definition.
	capabilityRefs?: [...#CapabilityRef]

	// Declaração explícita do que este subdomínio NÃO faz.
	negativeBoundaries: [#NegativeBoundary, ...#NegativeBoundary]

	// Perfil estratégico — opcional por default; obrigatório para core-subdomain.
	strategicProfile?: #StrategicProfile

	// Justificativa das escolhas de modelagem.
	rationale: string & !=""

	// Invariantes estruturais mínimas para core-subdomain.
	if type == "core-subdomain" {
		mechanismRefs:  [#MechanismRef, ...#MechanismRef]
		costRefs:       [#CostRef, ...#CostRef]
		capabilityRefs: [#CapabilityRef, ...#CapabilityRef]
		strategicProfile: #StrategicProfile
	}

	_schema: {
		location: {
			canonicalPathRegex: "^strategic/subdomains/[a-z][a-z0-9-]*\\.cue$"
			fileNameRegex:      "^[a-z][a-z0-9-]*\\.cue$"
			description:        "Classificação estratégica de subdomínio com rastreabilidade ao domain-definition."
			rationale:          "Subdomínios vivem em strategic/subdomains/ como artefatos de classificação estratégica independentes da existência prévia de bounded contexts concretos."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-sd-01"
			description: "Purpose justifica separação como subdomínio"
			test:        "Purpose explica por que esta área de domínio é tratada como subdomínio separado e qual responsabilidade é exclusivamente dela. Purpose genérico, intercambiável ou que apenas repete a definition com outras palavras falha."
			severity:    "fail"
			rationale:   "Sem justificativa de separação, não há critério para governar contorno entre subdomínios."
		}, {
			id:          "tq-sd-02"
			description: "Rastreabilidade a domain-definition válida"
			test:        "Cada mechanismRef (mech-*), costRef (ce-NN) e capabilityRef (cc-NN) aponta para IDs existentes em domain/domain-definition.cue. Referência inexistente é finding fail."
			severity:    "fail"
			rationale:   "Subdomínio sem ligação verificável à tese é classificação decorativa."
		}, {
			id:          "tq-sd-03"
			description: "Negative boundaries são explícitas, concretas e atribuídas"
			test:        "Cada negativeBoundary declara responsabilidade concreta, target explícito e rationale verificável. Fronteiras vagas, sem owner ou com target implícito falham."
			severity:    "fail"
			rationale:   "Fronteiras negativas só protegem contra scope creep quando deixam claro o que fica fora e quem assume."
		}, {
			id:          "tq-sd-04"
			description: "Core exige densidade estratégica mínima"
			test:        "Se type == 'core-subdomain', strategicProfile deve estar preenchido com complexity e volatility, e o subdomínio deve ter ao menos um mechanismRef, um costRef e um capabilityRef."
			severity:    "fail"
			rationale:   "Core subdomains concentram diferenciação competitiva. Sem profile e rastreabilidade mínima, a classificação de core não é defensável."
		}, {
			id:          "tq-sd-05"
			description: "Type consistente com classification dos canvases associados"
			test:        "Se existir canvas de bounded context que declare pertencer a este subdomínio, subdomain.type deve ser idêntico a canvas.classification. Divergência é drift entre artefatos estratégicos e operacionais."
			severity:    "fail"
			rationale:   "A taxonomia é única e compartilhada. Divergência entre subdomain e canvas indica quebra de single source of truth."
		}, {
			id:          "tq-sd-06"
			description: "Definition delimita espaço de problema"
			test:        "Definition descreve responsabilidades e questões de negócio cobertas pelo subdomínio, não solução, implementação, tecnologia ou arquitetura."
			severity:    "fail"
			rationale:   "Subdomínio é partição do espaço de problema, não da solução."
		}, {
			id:          "tq-sd-07"
			description: "Código do artefato coincide com o filename"
			test:        "O campo code é idêntico ao nome base do arquivo em strategic/subdomains/<code>.cue. Divergência entre identidade declarada e localização canônica falha."
			severity:    "fail"
			rationale:   "Identidade canônica não pode depender de transformação implícita nem de convenção informal."
		}, {
			id:          "tq-sd-08"
			description: "Deprecation é completa quando status é deprecated"
			test:        "Se status == 'deprecated', deprecation.absorbedBy, deprecation.reason e deprecation.rationale devem estar preenchidos. Se status == 'active', deprecation não pode existir."
			severity:    "fail"
			rationale:   "Lifecycle incompleto cria artefatos ambíguos: nem ativos, nem corretamente absorvidos."
		}]
		rationale: "Critérios cobrem identidade canônica, contorno (definition, purpose, negative boundaries), rastreabilidade à tese (mechanismRefs, costRefs, capabilityRefs), governança estratégica de core e lifecycle."
	}
}

#MechanismRef: string & =~"^mech-[a-z][a-z0-9-]*$"
#CostRef: string & =~"^ce-[0-9]{2}$"
#CapabilityRef: string & =~"^cc-[0-9]{2}$"

#SubdomainRef: string & =~"^[a-z][a-z0-9-]*$"

// Sistema externo canônico. Prefixo ext- elimina ambiguidade com subdomínios.
#ExternalSystemRef: string & =~"^ext-[a-z][a-z0-9-]*$"

#DelegationTarget: {
	type: "subdomain"
	ref:  #SubdomainRef
} | {
	type: "external-system"
	ref:  #ExternalSystemRef
}

#NegativeBoundary: {
	// Responsabilidade que este subdomínio explicitamente não possui.
	responsibility: string & !=""

	// Owner explícito da responsabilidade excluída.
	delegatedTo: #DelegationTarget

	rationale: string & !=""
}

#StrategicProfile: {
	// Complexidade do domínio — governa investimento em modelagem.
	complexity: "low" | "moderate" | "high"

	// Volatilidade — frequência esperada de mudança nas regras de negócio.
	volatility: "low" | "moderate" | "high"

	rationale: string & !=""
}

#SubdomainDeprecation: {
	// Subdomínio que absorve as responsabilidades.
	absorbedBy: #SubdomainRef

	// Motivo da deprecação.
	reason: string & !=""

	// Justificativa da deprecação.
	rationale: string & !=""
}
