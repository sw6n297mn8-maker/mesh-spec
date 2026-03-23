package artifact_schemas

// subdomain.cue — Artifact schema para declaração de subdomínios.
//
// Cada subdomínio da Mesh é declarado como instância de #Subdomain.
// Instâncias vivem em strategic/subdomains/<id>.cue.
// Classificação estratégica é definida aqui (#BCClassification) e
// consumida por #Canvas — a classificação é conceito de camada
// estratégica que o canvas herda.

// Classificação estratégica de subdomínio.
// Definido aqui porque classificação é conceito da camada estratégica.
// Consumido por #Canvas (mesmo package, sem import).
#BCClassification: "core-subdomain" | "supporting-subdomain" | "generic-subdomain"

#Subdomain: {
	// Identificador único do subdomínio.
	id: string & =~"^[a-z][a-z0-9-]*$"

	// Nome descritivo do subdomínio.
	name: string & !=""

	// Classificação estratégica.
	classification: #BCClassification

	// Responsabilidade central deste subdomínio — por que existe
	// como unidade separada de análise estratégica.
	responsibility: string & !=""

	// Bounded Contexts que pertencem a este subdomínio.
	// CI valida que cada bcRef corresponde a um diretório em contexts/<id>/.
	// Lista vazia é válida na fase de bootstrap (BCs ainda não existem).
	// Invariante cross-file: cada BC aparece em no máximo 1 subdomínio
	// (enforcement CI, não expressável em schema de arquivo individual).
	boundedContexts: [...string & =~"^[a-z][a-z0-9-]*$"]

	// Mecanismos do domínio que este subdomínio implementa.
	// Referência a mech-* de domain-definition.cue.
	// Para core-subdomain e supporting-subdomain, pelo menos 1 é esperado
	// (tq-sd-03). Para generic-subdomain, lista vazia é aceitável.
	mechanismRefs: [...string & =~"^mech-[a-z][a-z0-9-]*$"]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^strategic/subdomains/[a-z][a-z0-9-]*\\.cue$"
			fileNameRegex:      "^[a-z][a-z0-9-]*\\.cue$"
			description:        "Declaração de subdomínio estratégico da Mesh."
			rationale:          "Subdomínios são a unidade de classificação estratégica. Vivem em strategic/subdomains/ porque são artefatos de camada estratégica, não de BC individual."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-sd-01"
			description: "Responsibility justifica separação estratégica"
			test:        "O campo responsibility explica por que este subdomínio é uma unidade de análise separada e qual responsabilidade é exclusivamente dele. Responsibility que descreve funcionalidade genérica, que poderia ser nome de módulo, ou que se aplicaria igualmente a outro subdomínio falha."
			severity:    "fail"
			rationale:   "Subdomínio sem justificativa de separação é agrupamento arbitrário — não informa decisões de investimento nem alocação de recursos."
		}, {
			id:          "tq-sd-02"
			description: "Classification é consistente com os BCs declarados"
			test:        "Se boundedContexts não está vazio e os BCs referenciados possuem canvas.cue, cada BC deve existir em contexts/<id>/ e seu canvas.classification deve ser idêntica à classification do subdomínio. BC com classification diferente do subdomínio é finding fail. Se boundedContexts está vazio ou BCs não possuem canvas, critério não é aplicável."
			severity:    "fail"
			rationale:   "Inconsistência entre classification do subdomínio e do BC derrota o propósito da classificação estratégica — decisões de investimento baseadas em classificação errada são decisões erradas."
		}, {
			id:          "tq-sd-03"
			description: "Mechanism refs rastreáveis ao domínio"
			test:        "Cada mechanismRef referencia um mech-* existente em domain/domain-definition.cue. Referência inexistente é finding fail. Para subdomínios com classification core-subdomain ou supporting-subdomain, pelo menos um mechanismRef é obrigatório — subdomínio core ou supporting sem mecanismo perde rastreabilidade à tese. Para generic-subdomain, lista vazia é aceitável."
			severity:    "fail"
			rationale:   "Subdomínio core/supporting desconectado dos mecanismos do domínio perde rastreabilidade tese→mecanismo→subdomínio. Subdomínios genéricos podem servir funções de suporte sem implementar mecanismos diretamente."
		}]
		rationale: "Critérios cobrem as dimensões que tornam subdomínios úteis para decisão estratégica: separação justificada, consistência classificatória com BCs e rastreabilidade aos mecanismos do domínio."
	}
}
