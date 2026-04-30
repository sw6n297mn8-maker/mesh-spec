package idc

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Ubiquitous Language do BC Identity & Data Governance.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// PARTIAL — commit 3 de 4 (foundation + crypto mechanisms + composite/audit/boundary).
// Materializa 10 dos 13 terms aprovados. Demais 3 terms em commit 4.
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
	}, {
		code:       "term-assinatura-dsse"
		name:       "Assinatura DSSE"
		termEn:     "DSSE Signature"
		definition: "Envelope criptográfico no padrão Dead Simple Signing Envelope que vincula payload (evidência operacional) a Identidade Organizacional verificada. Inclui assinatura, payload type e metadata de verificação."
		category:   "document"
		rationale:  "Output de SignEvidence (canvas command), consumido primariamente por LOG. Distinto de assinatura digital ICP-Brasil (que vincula a pessoa física via certificado A1/A3) — DSSE vincula a Identidade Organizacional verificada por IDC."
		relatedTerms: ["term-identidade-organizacional", "term-prova-de-integridade", "term-trilha-de-auditoria-criptografica"]
		examples: [{
			context:   "LOG registra evidência de entrega"
			instance:  "Envelope DSSE contendo {payloadType: 'application/vnd.mesh.evidence-delivery+json', payload: <NF-e + GR>, signatures: [{keyid: <idc-key-id>, sig: <base64>}]}"
			rationale: "Caso típico onde LOG consome SignEvidence para vincular evidência à organização emissora verificada."
		}]
		rejectedAlternatives: [{
			term:   "Assinatura Digital"
			reason: "Termo legal genérico associado a ICP-Brasil; ambíguo em escopo cripto da Mesh. DSSE é específico ao protocolo escolhido (bd-crypto-single-owner)."
		}]
	}, {
		code:       "term-enderecamento-cas"
		name:       "Endereçamento CAS"
		termEn:     "Content Addressable Storage"
		definition: "Esquema de armazenamento onde o endereço do conteúdo é seu próprio hash criptográfico — qualquer modificação do conteúdo muda o endereço, garantindo integridade por construção."
		category:   "classification"
		rationale:  "Mecanismo que sustenta provas de integridade (capability cc-01) sob ownership exclusivo de IDC (bd-crypto-single-owner). Distinto de armazenamento por path/UUID que LOG usa para metadata."
		relatedTerms: ["term-merkle-proof", "term-prova-de-integridade"]
		antiTerms: [{
			term:          "Armazenamento por Path"
			clarification: "Path-based addressing (filesystem, S3 keys) não garante integridade — modificação do conteúdo preserva o path. CAS por construção detecta qualquer modificação."
		}]
	}, {
		code:       "term-merkle-proof"
		name:       "Merkle Proof"
		termEn:     "Merkle Proof"
		definition: "Sequência de hashes criptográficos que prova inclusão de uma evidência em um conjunto sem expor o conjunto inteiro. Permite verificação independente de integridade por terceiros (IF parceira, regulador)."
		category:   "document"
		rationale:  "Componente da Prova de Integridade (capability cc-01); habilita verificação criptográfica por sh-03 e sh-04 sem confiança em Mesh como intermediária. Termo técnico universalmente reconhecido em criptografia — preservado em inglês por idiomática (per heuristic termEn)."
		relatedTerms: ["term-enderecamento-cas", "term-prova-de-integridade"]
		examples: [{
			context:   "Verificação independente por instituição financeira parceira"
			instance:  "Merkle proof com 12 hashes (path da folha até a raiz da árvore) verifica que NF-e #X faz parte do conjunto de evidências do contrato Y, sem expor outras NFs do mesmo contrato."
			rationale: "Caso típico onde sh-03 valida lastro sem precisar acessar evidências de outras operações — privacy-preserving verification."
		}]
	}, {
		code:       "term-prova-de-integridade"
		name:       "Prova de Integridade"
		termEn:     "Integrity Proof"
		definition: "Artefato composto retornado por GenerateIntegrityProof que combina Merkle Proof + Assinatura DSSE para verificação criptográfica end-to-end de evidência: assinada por identidade verificada e não-adulterada desde a origem."
		category:   "document"
		rationale:  "Output primário consumido por DLV; torna verificação de lastro independente de confiança institucional em Mesh — qualquer parte com o proof pode verificar criptograficamente. Distinto de Merkle Proof simples (que apenas prova inclusão sem ligação a identidade)."
		relatedTerms: ["term-merkle-proof", "term-assinatura-dsse", "term-identidade-organizacional", "term-enderecamento-cas"]
		antiTerms: [{
			term:          "Atestado"
			clarification: "Atestado é declaração emitida por autoridade reconhecida (cartório, Junta); Prova de Integridade é verificável criptograficamente por qualquer parte sem confiança em emissor."
		}]
	}, {
		code:       "term-trilha-de-auditoria-criptografica"
		name:       "Trilha de Auditoria Criptográfica"
		termEn:     "Cryptographic Audit Trail"
		definition: "Registro auditável de toda operação de verificação, assinatura e geração de prova executada por IDC, com hash criptográfico verificável independentemente. Reconstituível em qualquer data por regulador ou parceiro autorizado."
		category:   "document"
		rationale:  "Materializa capability cc-04 (auditoria contínua) e atende sh-04 (regulador). Distinto de log operacional convencional por ser criptograficamente verificável — operadores não podem alterar trilha sem deixar evidência de adulteração."
		relatedTerms: ["term-verificacao-de-identidade-organizacional", "term-assinatura-dsse", "term-prova-de-integridade", "term-raiz-de-confianca"]
		rejectedAlternatives: [{
			term:   "Audit Log"
			reason: "Anglicismo que sugere log convencional; perde a propriedade cripto-verificável que diferencia esta trilha."
		}, {
			term:   "Registro de Auditoria"
			reason: "Genérico demais; não distingue de logs de aplicação. 'Trilha Criptográfica' enfatiza propriedade central (verificabilidade independente)."
		}]
	}, {
		code:       "term-fonte-oficial-de-verificacao"
		name:       "Fonte Oficial de Verificação"
		termEn:     "Verification Source"
		definition: "Sistema externo autoritativo (Receita Federal, Junta Comercial, bureaus de crédito) consultado por IDC como ground truth de identidade organizacional. Disponibilidade e qualidade são premissas registradas em as-idc-1."
		category:   "role"
		rationale:  "Boundary externa de IDC: input crítico do qual depende toda Verificação de Identidade Organizacional. Tratada como classe (não fonte específica) porque: composição pode evoluir, fontes alternativas podem ser adicionadas, fontes podem falhar individualmente."
		relatedTerms: ["term-verificacao-de-identidade-organizacional", "term-identidade-organizacional"]
		examples: [{
			context:   "Consulta padrão de verificação"
			instance:  "Receita Federal (consulta de CNPJ, situação cadastral); Junta Comercial (quadro societário, atos constitutivos); bureaus de crédito (Serasa, Boa Vista) para histórico complementar."
			rationale: "Composição típica para verificação de organização brasileira — múltiplas fontes cruzadas reduzem custo de manipulação (vsBenefit em incentiveAnalysis sh-01)."
		}]
		antiTerms: [{
			term:          "Self-Attestation"
			clarification: "Fonte Oficial é externa e autoritativa; self-attestation (declaração da própria organização) não substitui — IDC nunca opera apenas com self-attestation por restrição regulatória (sh-04)."
		}]
	}]

	rationale: "UL de IDC organiza-se em torno dos 3 pilares declarados no canvas: (1) verificação de identidade organizacional contra fontes oficiais; (2) integridade criptográfica via DSSE/CAS/Merkle; (3) autorização como primitiva. Termos arquiteturais (Primitiva e Raiz de Confiança) caracterizam o papel de IDC como provedor único de primitivas no portfolio Mesh; termos de boundary (Fonte Oficial, Janela de Inconsistência) explicitam dependências externas e operacionais. Estados (Verificada, Suspensa, Revogada) NÃO são terms separados per anti-fragmentação. Comandos e eventos são building blocks de domain-model.cue (a ser materializado), não terms de glossary. domainModelRefs ficam vazios pendente de materialização do domain-model — preenchimento incremental quando WI futura criar."
}
