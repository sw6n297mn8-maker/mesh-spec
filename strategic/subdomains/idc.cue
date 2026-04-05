package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

idc: artifact_schemas.#Subdomain & {
	code: "idc"
	name: "Identity & Data Governance"
	type: "supporting-subdomain"

	definition: """
		Gestão de identidade, autenticação, autorização,
		governança de dados e integridade criptográfica.
		Fornece identidade de participantes e agentes,
		permissões, cadeia verificável de responsabilidade,
		primitivas de verificação (CAS, DSSE, Merkle proofs),
		políticas de retenção, LGPD e data lineage — incluindo
		as primitivas de integridade que mech-evidence consome.
		A existência de identidade e permissão não garante
		autorização efetiva — gates de domínio podem negar
		operações que IDC autorizou em nível de acesso. A
		integridade criptográfica garante não adulteração,
		não veracidade do conteúdo registrado. Não qualifica
		participantes para a rede (NPM), não governa
		autonomia de agentes (governance envelope per-agent),
		não captura evidência operacional (LOG), não processa
		transações (CMT, FCE), não produz registros de
		auditoria regulatória (ATO), não modela risco (REW).
		"""

	purpose: """
		Unificar gestão de identidade e governança de dados
		sob um owner canônico. Identidade e integridade
		criptográfica compartilham a mesma preocupação
		transversal: quem fez o quê, com qual permissão, e
		a evidência é íntegra? Sem IDC como unidade unificada,
		autenticação e verificação criptográfica evoluiriam
		separadamente — com risco de inconsistência na cadeia
		de responsabilidade exigida por dp-10 e na cadeia de
		evidência tamper-evident de mech-evidence.
		"""

	negativeBoundaries: [{
		responsibility: "Qualificação de participantes — verificação documental, compliance regulatório, IQF."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "IDC autentica e autoriza; NPM qualifica para a rede. Identidade é 'quem é você'; qualificação é 'você pode operar aqui'. Fusão misturaria infraestrutura de segurança com processo de compliance documental."
	}, {
		responsibility: "Captura de evidência operacional — rastreamento, inspeção, medição."
		delegatedTo: {
			type: "subdomain"
			ref:  "log"
		}
		rationale: "IDC verifica integridade; LOG captura evidência no ponto de origem. Métodos de captura evoluem por vertical sem alterar primitivas criptográficas."
	}, {
		responsibility: "Lógica de domínio — compromissos, pagamentos, risco, transações."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "IDC fornece identidade e integridade verificável; BCs de domínio implementam a lógica. Cadeia de responsabilidade não pode depender de lógica de negócio."
	}, {
		responsibility: "Auditoria regulatória — reporting, compliance fiscal."
		delegatedTo: {
			type: "subdomain"
			ref:  "ato"
		}
		rationale: "IDC fornece trilha de integridade verificável; ATO produz registros de auditoria regulatória. Integridade criptográfica e compliance fiscal são domínios com regulação distinta."
	}, {
		responsibility: "Infraestrutura de plataforma — deploy, networking, runtime."
		delegatedTo: {
			type: "subdomain"
			ref:  "plt"
		}
		rationale: "IDC governa identidade, acesso e integridade de dados; PLT governa infraestrutura de execução. Fusão acoplaria decisões de segurança a decisões de infraestrutura."
	}]

	rationale: """
		IDC é supporting porque gestão de identidade (OAuth,
		OIDC, RBAC, ABAC) e primitivas criptográficas (CAS,
		DSSE, Merkle) são domínios com padrões estabelecidos
		— não proprietários. O valor proprietário da Mesh está
		na lógica financeira, não na autenticação nem na
		criptografia. IDC é pré-condição para dp-10
		(responsabilidade jurídica explícita), dp-05
		(auditabilidade total) e para a cadeia de evidência
		tamper-evident de mech-evidence.
		"""
}
