package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

dgv: artifact_schemas.#Subdomain & {
	code: "dgv"
	name: "Data Governance & Verification"
	type: "supporting-subdomain"

	definition: """
		Governança de dados, integridade criptográfica e
		verificação — CAS (Content-Addressable Storage), DSSE
		(Dead Simple Signing Envelope), Merkle proofs, políticas
		de retenção, LGPD e data lineage. Fornece as primitivas
		de integridade que mech-evidence consome. Não processa
		transações (ECL, FCE), não modela risco (REW), não
		captura evidência operacional (LOG).
		"""

	purpose: """
		Separar primitivas de integridade criptográfica e
		governança de dados da lógica de domínio que as consome.
		CAS, DSSE e Merkle proofs são infraestrutura de
		verificação — evoluem por avanços criptográficos e
		regulação de dados (LGPD), não por regras de negócio.
		Sem DGV como unidade separada, cada subdomínio que
		produz ou consome evidência implementaria verificação
		internamente — duplicação com risco de inconsistência
		criptográfica.
		"""

	negativeBoundaries: [{
		responsibility: "Captura de evidência operacional — rastreamento, inspeção, medição."
		delegatedTo: {
			type: "subdomain"
			ref:  "log"
		}
		rationale: "DGV verifica integridade; LOG captura evidência no ponto de origem. Separação permite que métodos de captura evoluam por vertical sem alterar primitivas criptográficas."
	}, {
		responsibility: "Lifecycle do compromisso econômico — state machine, transições."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "DGV garante integridade de dados que CMT consome; não governa progressão do compromisso. Fusão acoplaria decisões criptográficas a decisões de domínio financeiro."
	}, {
		responsibility: "Auditoria regulatória — reporting, compliance fiscal."
		delegatedTo: {
			type: "subdomain"
			ref:  "ato"
		}
		rationale: "DGV fornece trilha de integridade verificável; ATO produz registros de auditoria regulatória. Integridade criptográfica e compliance fiscal são domínios com especialização e regulação distintas."
	}]

	rationale: """
		DGV é supporting porque primitivas criptográficas (CAS,
		DSSE, Merkle) são tecnologias de verificação estabelecidas
		— não proprietárias. O valor proprietário da Mesh está em
		como essas primitivas são aplicadas ao domínio financeiro
		(mech-evidence), não nas primitivas em si. DGV é
		pré-condição para a cadeia de evidência tamper-evident
		de 6 camadas descrita em mech-evidence.
		"""
}
