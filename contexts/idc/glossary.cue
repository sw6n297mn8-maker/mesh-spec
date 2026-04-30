package idc

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Ubiquitous Language do BC Identity & Data Governance.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// PARTIAL — commit 1 de 4 (identity foundation cluster).
// Materializa 4 dos 13 terms aprovados: Identidade Organizacional,
// Verificação de Identidade Organizacional, Primitiva de Confiança,
// Raiz de Confiança. Demais 9 terms em commits 2-4.
//
// Materializa a UL emergente do canvas IDC: 3 pilares (verificação,
// integridade criptográfica, autorização) + boundary com fontes oficiais
// + revogação e cache invalidation. domainModelRefs ficam vazios pois
// domain-model.cue de IDC ainda não existe — a serem preenchidos
// incrementalmente quando WI futura materializar o domain model.
//
// Lens aplicada: lens-domain-language-and-terminology-design.
// Production-guide aplicado: architecture/production-guides/glossary.cue.

glossary: artifact_schemas.#Glossary & {
	code:              "idc"
	name:              "Identity & Data Governance"
	boundedContextRef: "idc"

	terms: [{
		code:       "term-identidade-organizacional"
		name:       "Identidade Organizacional"
		termEn:     "Organizational Identity"
		definition: "Entidade jurídica (CNPJ ou equivalente) cuja existência, atributos e elegibilidade foram confirmados contra fontes oficiais e mantidos como SoT por IDC. Inclui razão social, quadro societário e estado de elegibilidade vigente."
		category:   "entity"
		rationale:  "Conceito central de IDC: a entidade que IDC verifica e cuja identidade é base de toda operação na rede. Distinta de identidade individual (pessoa física, fora do escopo) e autenticação de sessão (responsabilidade de PLT per bd-identity-not-authentication)."
		relatedTerms: ["term-verificacao-de-identidade-organizacional", "term-revogacao-de-identidade", "term-fonte-oficial-de-verificacao"]
		antiTerms: [{
			term:          "Pessoa Física"
			clarification: "IDC verifica organizações jurídicas, não pessoas físicas individuais. Verificação de pessoa física não pertence ao escopo de IDC."
		}, {
			term:          "Sessão de Usuário Autenticado"
			clarification: "Identidade Organizacional é resultado persistente de verificação contra fontes oficiais; sessão autenticada é handshake transitório de PLT (bd-identity-not-authentication)."
		}]
		rejectedAlternatives: [{
			term:   "Identidade Corporativa"
			reason: "Restritivo demais — IDC verifica organizações em sentido amplo (empresas, cooperativas, associações), não apenas corporações."
		}, {
			term:   "Identidade da Empresa"
			reason: "Linguagem coloquial; perde precisão jurídica. 'Organizacional' é neutro em relação à forma jurídica."
		}]
	}, {
		code:       "term-verificacao-de-identidade-organizacional"
		name:       "Verificação de Identidade Organizacional"
		termEn:     "Organizational Identity Verification"
		definition: "Processo assíncrono de confirmar que uma organização é quem alega ser via cruzamento com fontes oficiais autoritativas. Produz resultado persistente e consultável, não handshake de autenticação."
		category:   "process"
		rationale:  "Capability primária de IDC (capability cap-3 do canvas) e pré-condição de onboarding via NPM. Distinta de outras verificações em IDC (integridade, autorização) e de autenticação de sessão (PLT)."
		relatedTerms: ["term-identidade-organizacional", "term-fonte-oficial-de-verificacao", "term-revogacao-de-identidade"]
		antiTerms: [{
			term:          "Autenticação"
			clarification: "Verificação confirma identidade contra fontes externas (resultado persistente); autenticação valida sessão de usuário (handshake transitório, escopo PLT)."
		}, {
			term:          "Qualificação"
			clarification: "Verificação confirma quem a organização É; qualificação (NPM) decide se PODE operar. Verificação é pré-condição de qualificação, não substituto."
		}]
	}, {
		code:       "term-primitiva-de-confianca"
		name:       "Primitiva de Confiança"
		termEn:     "Trust Primitive"
		definition: "Operação atômica de verificação que IDC fornece a consumers (verificar identidade, assinar evidência, gerar prova de integridade, autorizar). Estável e reusável; não implementa política de negócio que consome a primitiva."
		category:   "classification"
		rationale:  "Caracteriza o que IDC entrega per bd-primitives-not-policy: estabilidade vs volatilidade. Primitivas mudam pouco (cripto, identidade); políticas que as consomem (KYC/AML em NPM, regras de assinatura em LOG) são voláteis e ficam fora de IDC."
		relatedTerms: ["term-raiz-de-confianca", "term-verificacao-de-identidade-organizacional", "term-assinatura-dsse", "term-prova-de-integridade", "term-autorizacao"]
		antiTerms: [{
			term:          "Serviço de Compliance"
			clarification: "Primitiva responde 'identidade verificada?', 'assinatura válida?'. Serviço de compliance (KYC/AML) responde 'pode operar?' usando primitivas + política externa — escopo NPM, não IDC."
		}]
		rejectedAlternatives: [{
			term:   "Serviço de Confiança"
			reason: "Termo bancário associado a certificação ICP/ITI; cria coupling com regulação externa que IDC não pretende implementar."
		}]
	}, {
		code:       "term-raiz-de-confianca"
		name:       "Raiz de Confiança"
		termEn:     "Trust Root"
		definition: "Papel arquitetural exclusivo de IDC na rede Mesh — única fonte de verificação de identidade organizacional e integridade criptográfica. Toda evidência confiável da rede tem cadeia de custódia que termina em IDC."
		category:   "role"
		rationale:  "Caracteriza posição de IDC no grafo de dependências (per bd-crypto-single-owner): consumer único de fontes oficiais, owner único de DSSE/CAS/Merkle, gate único de integridade. Tensão registrada em ten-002 (Canvas archetype não captura authority/trust-root)."
		relatedTerms: ["term-primitiva-de-confianca", "term-fonte-oficial-de-verificacao", "term-trilha-de-auditoria-criptografica"]
		rejectedAlternatives: [{
			term:   "Trust Anchor"
			reason: "Anglicismo PKI específico; o conceito Mesh é mais amplo (inclui identidade organizacional, não só chaves)."
		}, {
			term:   "Authority"
			reason: "Sugere autoridade regulatória, não papel arquitetural. ten-002 registra falta de archetype 'authority' no schema #Canvas como tensão."
		}]
	}]

	rationale: "UL de IDC organiza-se em torno dos 3 pilares declarados no canvas: (1) verificação de identidade organizacional contra fontes oficiais; (2) integridade criptográfica via DSSE/CAS/Merkle; (3) autorização como primitiva. Termos arquiteturais (Primitiva e Raiz de Confiança) caracterizam o papel de IDC como provedor único de primitivas no portfolio Mesh; termos de boundary (Fonte Oficial, Janela de Inconsistência) explicitam dependências externas e operacionais. Estados (Verificada, Suspensa, Revogada) NÃO são terms separados per anti-fragmentação. Comandos e eventos são building blocks de domain-model.cue (a ser materializado), não terms de glossary. domainModelRefs ficam vazios pendente de materialização do domain-model — preenchimento incremental quando WI futura criar."
}
