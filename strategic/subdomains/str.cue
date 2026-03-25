package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

str: artifact_schemas.#Subdomain & {
	code: "str"
	name: "Storage & Document Management"
	type: "generic-subdomain"

	definition: """
		Armazenamento e gestão de documentos e arquivos —
		upload, download, versionamento, retenção e acesso
		controlado a artefatos digitais (contratos, laudos,
		fotos, certificados). Fornece infraestrutura de
		persistência de documentos que subdomínios consomem.
		Não verifica integridade criptográfica (DGV), não
		interpreta conteúdo de documentos, não governa
		compliance documental (NPM).
		"""

	purpose: """
		Separar armazenamento de documentos da lógica de
		domínio que os consome. Tecnologias de storage (object
		storage, CDN, replicação) evoluem por drivers
		tecnológicos, não por regras de negócio. Sem STR como
		unidade separada, cada subdomínio que lida com
		documentos implementaria persistência internamente —
		duplicação com risco de inconsistência de políticas
		de retenção e acesso.
		"""

	negativeBoundaries: [{
		responsibility: "Integridade criptográfica — CAS, DSSE, Merkle proofs."
		delegatedTo: {
			type: "subdomain"
			ref:  "dgv"
		}
		rationale: "STR persiste bytes; DGV verifica integridade. Separação permite trocar tecnologia de storage sem alterar primitivas criptográficas — storage é commodity, verificação é constraint de domínio."
	}, {
		responsibility: "Compliance documental — verificação, qualificação, IQF."
		delegatedTo: {
			type: "subdomain"
			ref:  "npm"
		}
		rationale: "STR armazena documentos; NPM interpreta e valida para fins de compliance. Fusão misturaria infraestrutura de persistência com lógica de qualificação — dois domínios com especialização distinta."
	}, {
		responsibility: "Evidência operacional — cadeia de custódia, rastreamento."
		delegatedTo: {
			type: "subdomain"
			ref:  "log"
		}
		rationale: "STR persiste artefatos digitais; LOG governa a cadeia de custódia de evidência operacional. Separação mantém storage genérico desacoplado de domínio de evidência por vertical."
	}]

	rationale: """
		STR é generic porque armazenamento de documentos é
		infraestrutura comoditizada — object storage (S3, GCS,
		Azure Blob) é intercambiável. Nenhuma diferenciação
		competitiva da Mesh reside em como documentos são
		armazenados. STR é substituível por qualquer provedor
		de storage que satisfaça requisitos de retenção e acesso.
		"""
}
