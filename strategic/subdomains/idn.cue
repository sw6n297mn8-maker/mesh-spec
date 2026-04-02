package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

idn: artifact_schemas.#Subdomain & {
	code: "idn"
	name: "Identity & Access Management"
	type: "supporting-subdomain"

	definition: """
		Gestão de identidade, autenticação e autorização —
		identidade de participantes, identidade de agentes,
		tokens, permissões, políticas de acesso e cadeia de
		responsabilidade. Garante que toda operação tem autor
		identificável e permissão verificável. Não qualifica
		participantes para a rede (NPM), não governa autonomia
		de agentes (domínio dos bounded contexts via
		governance envelope per-agent), não processa transações.
		"""

	purpose: """
		Separar gestão de identidade e acesso da qualificação
		de participantes e da lógica de domínio. Identidade é
		pré-condição transversal — todo subdomínio precisa saber
		quem está agindo e com qual permissão. Sem IDN como
		unidade separada, autenticação e autorização ficariam
		distribuídas entre bounded contexts — duplicação com
		risco de inconsistência na cadeia de responsabilidade
		exigida por dp-10.
		"""

	negativeBoundaries: [{
		responsibility: "Qualificação de participantes — verificação documental, compliance, IQF."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "IDN autentica e autoriza; NPM qualifica para a rede. Identidade é 'quem é você'; qualificação é 'você pode operar aqui'. Fusão misturaria infraestrutura de segurança com processo de compliance documental."
	}, {
		responsibility: "Lógica de domínio — compromissos, pagamentos, risco."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "IDN garante que operações têm autor identificável; CMT (e demais) implementam a lógica. Separação é pré-condição para dp-10 (responsabilidade jurídica explícita) — cadeia de responsabilidade não pode depender de lógica de negócio."
	}, {
		responsibility: "Infraestrutura de plataforma — deploy, networking, runtime."
		delegatedTo: {
			type: "subdomain"
			ref:  "plt"
		}
		rationale: "IDN governa identidade e acesso; PLT governa infraestrutura de execução. Fusão acoplaria decisões de segurança a decisões de infraestrutura — blast radius e stakeholders distintos."
	}]

	rationale: """
		IDN é supporting porque gestão de identidade e acesso é
		domínio com padrões bem estabelecidos (OAuth, OIDC, RBAC,
		ABAC) — não proprietário. O valor proprietário da Mesh
		está na lógica financeira, não na autenticação. IDN é
		pré-condição para dp-10 (responsabilidade jurídica
		explícita) e dp-05 (auditabilidade total) — toda operação
		rastreável até pessoa responsável exige identidade
		canônica.
		"""
}
