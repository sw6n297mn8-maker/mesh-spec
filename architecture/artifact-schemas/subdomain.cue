package artifact_schemas

// subdomain.cue — Artifact schema para Subdomínio.
//
// Define a estrutura válida para declaração de subdomínios no
// mapa estratégico do domínio Mesh. classification reutiliza
// #BCClassification (canvas.cue) para vocabulário unificado.
// lifecycle usa união discriminada active/deprecated.

#Subdomain: #SubdomainBase & ({
	lifecycle: {
		status: "active"
	}
} | {
	lifecycle: {
		status:       "deprecated"
		supersededBy: string & =~"^[a-z][a-z0-9-]*$"
		rationale:    string & !=""
	}
})

#SubdomainBase: {
	// Código lowercase do subdomínio — CI valida que coincide
	// com o nome do arquivo em domain/subdomains/<code>.cue.
	code: string & =~"^[a-z][a-z0-9-]*$"

	// Nome legível do subdomínio.
	name: string & !=""

	// Classificação estratégica — reutiliza #BCClassification (canvas.cue)
	// para garantir vocabulário unificado entre subdomain e canvas.
	type: #BCClassification

	// Propósito do subdomínio — por que existe como unidade separada.
	purpose: string & !=""

	// Responsabilidades explicitamente fora deste subdomínio,
	// com delegação rastreável.
	negativeBoundaries: [#NegativeBoundary, ...#NegativeBoundary]

	// Estado do subdomínio — união discriminada em #Subdomain.
	lifecycle: _

	// Perfil estratégico — opcional por default.
	// tq-sd-03 exige preenchimento para core-subdomain.
	strategicProfile?: #StrategicProfile

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^domain/subdomains/[a-z][a-z0-9-]*\\.cue$"
			fileNameRegex:      "^[a-z][a-z0-9-]*\\.cue$"
			description:        "Declaração de subdomínio no mapa estratégico do domínio Mesh."
			rationale:          "Subdomínios vivem em domain/subdomains/ porque são artefatos de modelagem estratégica do domínio, não de arquitetura ou governança."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-sd-01"
			description: "code coincide com nome do arquivo"
			test:        "O campo code deve ser idêntico ao nome do arquivo sem extensão .cue. Arquivo commitment-management.cue exige code: \"commitment-management\". Divergência é finding fail."
			severity:    "fail"
			rationale:   "Convenção code ↔ filename permite CI e agentes localizarem o subdomínio por code sem índice externo."
		}, {
			id:          "tq-sd-02"
			description: "negativeBoundaries identificam delegatário concreto"
			test:        "Cada entrada em negativeBoundaries tem responsibility descrevendo o que está fora, delegatedTo identificando quem assume (código de subdomínio interno ou nome de sistema externo), e rationale explicando por que a delegação existe. delegatedTo vazio ou genérico ('outro sistema') falha."
			severity:    "fail"
			rationale:   "Boundary negativa sem delegatário é declaração de intenção, não constraint verificável. CI pode validar que delegatedTo referencia subdomínio existente ou sistema externo nomeado."
		}, {
			id:          "tq-sd-03"
			description: "core-subdomain exige strategicProfile"
			test:        "Se type == \"core-subdomain\" e strategicProfile está ausente, é finding fail. Para supporting-subdomain e generic-subdomain, ausência de strategicProfile é aceitável."
			severity:    "fail"
			rationale:   "Core subdomains são o diferencial competitivo — sem perfil estratégico explícito, a classificação 'core' é rótulo sem substância."
		}, {
			id:          "tq-sd-04"
			description: "purpose justifica separação como subdomínio"
			test:        "O campo purpose explica por que esta responsabilidade é um subdomínio separado — não apenas o que faz. Purpose que descreve funcionalidade genérica, que poderia ser nome de módulo, ou que se aplicaria igualmente a outro subdomínio, falha."
			severity:    "fail"
			rationale:   "Purpose é o critério de contorno. Sem justificativa de separação, o subdomínio não tem base para aceitar ou rejeitar responsabilidades."
		}, {
			id:          "tq-sd-05"
			description: "Consistência com canvas quando existir"
			test:        "Se existe canvas em contexts/ cujo BC corresponde a este subdomínio (correspondência por code do subdomínio aparecer no id ou path do canvas), classification do canvas deve ser compatível com type do subdomínio. Divergência é finding warn. Nota: a lógica de correspondência subdomain ↔ canvas depende de implementação no runner — este critério orienta, mas pode não ser verificável automaticamente até o runner formalizar o matching."
			severity:    "warn"
			rationale:   "Subdomain e canvas expressam a mesma classificação estratégica em níveis diferentes. Divergência silenciosa é drift — warn porque a correspondência ainda não está formalizada no schema."
		}]
		rationale: "Critérios do subdomínio cobrem identidade (code ↔ filename), contorno (purpose, negativeBoundaries com delegação), classificação (strategicProfile para core) e coerência cross-artifact (canvas). Esses são os aspectos que governam decisões de escopo e investimento."
	}
}

// Responsabilidade explicitamente delegada a outro subdomínio ou sistema externo.
#NegativeBoundary: {
	// O que este subdomínio NÃO faz.
	responsibility: string & !=""

	// Quem assume esta responsabilidade.
	// Código de subdomínio interno (lowercase, kebab-case) ou
	// nome de sistema externo. CI pode validar referência a
	// subdomínio existente; sistema externo é aceito como string.
	delegatedTo: string & !=""

	rationale: string & !=""
}

// Perfil estratégico — justifica investimento diferenciado.
#StrategicProfile: {
	// O que torna este subdomínio diferenciador competitivo.
	differentiator: string & !=""

	// Vantagem competitiva que a Mesh obtém por investir neste subdomínio.
	competitiveAdvantage: string & !=""

	rationale: string & !=""
}
