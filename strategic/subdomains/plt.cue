package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

plt: artifact_schemas.#Subdomain & {
	code: "plt"
	name: "Platform & Infrastructure Services"
	type: "supporting-subdomain"

	definition: """
		Serviços de plataforma que suportam todos os subdomínios
		— deploy, scaling, service mesh, configuração, secrets
		management, CI/CD e infraestrutura de runtime. Fornece
		as primitivas de execução sobre as quais bounded contexts
		operam. Não implementa lógica de negócio de nenhum
		subdomínio.
		"""

	purpose: """
		Separar infraestrutura de runtime da lógica de domínio.
		Decisões de deploy, scaling e networking evoluem por
		drivers tecnológicos (cloud providers, containers,
		service mesh), não por regras de negócio. Sem PLT como
		unidade separada, decisões de infraestrutura ficariam
		acopladas a bounded contexts de domínio — cada mudança
		de cloud provider ou estratégia de deploy exigiria
		revisão de lógica de negócio.
		"""

	negativeBoundaries: [{
		responsibility: "Lógica de domínio — compromissos, pagamentos, risco, contratos."
		delegatedTo: {
			type: "subdomain"
			ref:  "ecl"
		}
		rationale: "PLT fornece infraestrutura de execução; ECL (e demais) implementam lógica de domínio. Separação é a fronteira fundamental entre plataforma e produto — fusão é anti-pattern universalmente reconhecido."
	}, {
		responsibility: "Observabilidade e inteligência operacional — métricas, alertas, dashboards."
		delegatedTo: {
			type: "subdomain"
			ref:  "obs"
		}
		rationale: "PLT fornece infraestrutura de coleta (agents, exporters); OBS governa o que observar e como interpretar. Separação permite trocar stack de observabilidade sem alterar plataforma."
	}, {
		responsibility: "Gestão de identidade e autenticação — login, tokens, permissões."
		delegatedTo: {
			type: "subdomain"
			ref:  "idn"
		}
		rationale: "PLT fornece infraestrutura de rede e deploy; IDN governa identidade e acesso. Fusão acoplaria decisões de segurança a decisões de infraestrutura — blast radius e stakeholders distintos."
	}]

	rationale: """
		PLT é supporting porque infraestrutura de plataforma é
		domínio com soluções bem estabelecidas (Kubernetes, Terraform,
		service mesh) — não proprietário. O valor da Mesh está na
		lógica de domínio financeiro, não na infraestrutura que a
		executa. PLT é pré-condição para dp-06 (escalabilidade
		estrutural) e dp-03 (controle de blast radius via isolamento).
		"""
}
