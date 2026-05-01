package idc

// canvas.cue — Bounded Context Canvas: Identity & Data Governance.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// IDC é a raiz de confiança da Mesh: verifica identidade de
// organizações, assina evidência com integridade criptográfica
// (DSSE, CAS, Merkle proofs) e fornece primitivas de
// autorização. Substitui antigos IDN (Identity) e DGV (Data
// Governance) — fusão justificada porque identidade e
// integridade compartilham a mesma raiz: autoria verificável
// + prova criptográfica (bd-idc-fusion).
//
// IDC fornece primitivas, não políticas (bd-primitives-not-policy).
// NPM consome verificação de identidade como pré-condição para
// KYC/AML. LOG consome assinatura criptográfica como primitiva
// de registro. DLV consome proofs de integridade como primitiva
// de verificação de entrega. Cada BC consumer é owner da
// política de uso — IDC não tem visibilidade sobre por que a
// primitiva é consumida.
//
// Comunicação: 3 commands inbound (VerifyOrganizationIdentity
// async para NPM, SignEvidence sync para LOG,
// GenerateIntegrityProof sync para DLV) + 3 query surfaces
// (status de verificação para NPM, integridade de
// armazenamento para LOG, integridade criptográfica end-to-end
// para DLV). 1 event publisher outbound
// (IdentityVerificationCompleted para NPM). Integração com NPM
// é dual: evento push notifica conclusão, query pull confirma
// estado no momento da decisão — em divergência, query
// prevalece.
//
// Tensão arquitetural registrada: IDC é conceptualmente
// "authority/trust-root" mas o schema #Canvas não oferece este
// archetype/businessRole. Canvas usa gateway + operational-enabler
// como aproximação. Tensão completa em
// architecture/tension-log/ten-002-idc-authority-archetype-missing.cue.
//
// Lenses aplicadas:
// - lens-security-trust-infrastructure (primária):
//   criptografia, trust chain, integridade como infraestrutura
// - lens-multi-tenancy-and-identity-architecture (primária):
//   identity model, verificação organizacional
// - lens-regulatory-compliance-as-architecture (secundária):
//   identificação verificável como constraint regulatório

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

canvas: artifact_schemas.#Canvas & {
	code: "idc"
	name: "Identity & Data Governance"

	purpose: """
		Fornecer primitivas de confiança para a rede Mesh:
		verificação de identidade organizacional, assinatura
		criptográfica de evidência (DSSE) e provas de integridade
		(CAS + Merkle proofs). IDC é a raiz de confiança —
		responde quem fez, com qual permissão, e a evidência está
		íntegra. Responsabilidade exclusiva: nenhum outro BC
		verifica identidade, assina evidência ou gera proofs de
		integridade. IDC fornece primitivas de verificação, não
		políticas de uso — NPM decide quem pode operar (KYC/AML),
		LOG decide o que registrar, DLV decide o que verificar.
		IDC não interpreta, classifica ou atribui risco a
		entidades (bd-verify-not-interpret).
		"""

	ubiquitousLanguageRef: "contexts/idc/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "custom"
		rationale: """
			Supporting porque IDC não é a proposta de valor final
			da Mesh, mas é pré-condição de operação — sem raiz de
			confiança, nenhum BC opera com integridade verificável.
			Operational-enabler porque IDC habilita operações de
			todos os BCs que dependem de identidade verificada e
			integridade criptográfica. Custom porque integridade
			criptográfica para SCD em cadeia produtiva B2B
			(DSSE + CAS + Merkle proofs) exige construção
			específica — não há solução de mercado que integre
			verificação de identidade organizacional com
			integridade criptográfica de evidência operacional.
			Tensão sobre businessRole registrada em ten-002.
			"""
	}

	domainRoles: {
		primary:   "gateway"
		secondary: ["specification"]
		rationale: """
			Gateway como primário: IDC é o ponto de acesso a
			primitivas de confiança — os BCs que dependem de
			confiança verificável consomem IDC como primitiva
			transversal. Specification como secundário: IDC define
			os protocolos criptográficos (DSSE envelope, CAS
			addressing, Merkle proof structure) que consumers
			adotam como conformist (relações idc-to-log e idc-to-dlv
			no context-map). Tensão sobre archetype registrada em
			ten-002 — gateway é o mais próximo semanticamente do
			papel conceitual de authority.
			"""
	}

	capabilities: {
		operational: [{
			capabilityRef: "cc-01"
			description: """
				Integridade criptográfica de evidência operacional:
				assinatura DSSE vincula autoria verificável,
				CAS garante integridade de armazenamento, Merkle
				proofs garantem consistência da cadeia. Primitiva
				consumida por LOG (assinatura), DLV (proofs) e
				qualquer BC que precise verificar integridade.
				"""
			rationale: "cc-01 (liberação financeira vinculada a evidência) depende diretamente de integridade criptográfica verificável — sem IDC, evidência não tem prova de autoria nem de não-adulteração."
		}, {
			capabilityRef: "cc-04"
			description: """
				Auditoria de identidade e integridade: cada
				verificação de identidade, assinatura e geração
				de proof é registrada com trail criptográfico.
				Regulador pode reconstituir cadeia de verificação
				de qualquer organização em qualquer data.
				"""
			rationale: "cc-04 (auditoria contínua e automatizada) depende de trail de verificação de identidade e integridade — IDC fornece a camada criptográfica que torna audit trail verificável independentemente."
		}, {
			description: """
				Verificação de identidade organizacional: confirma
				que organização é quem alega ser via fontes
				externas autoritativas (Receita Federal, Junta
				Comercial, bureaus). Resultado persistente e
				consultável — não handshake de autenticação.
				"""
			rationale: "Verificação de identidade é pré-condição de onboarding via NPM. Sem IDC, NPM não tem base para qualificação e nenhum BC tem garantia de que contraparte é quem alega ser."
		}, {
			description: """
				Autorização como primitiva de verificação:
				responde 'esta identidade tem esta permissão?'
				sem implementar engine de políticas complexa.
				Modelo detalhado de autorização (binária, RBAC
				ou ABAC) ainda em definição (oq-idc-2) — capability
				declarada porque é o terceiro pilar de IDC, mas
				escopo final depende de evolução dos requisitos.
				"""
			rationale: "Autorização é o terceiro pilar de IDC mas o modelo ainda não é fixo (oq-idc-2). Declarar como capability mantém visibilidade do escopo, evita assimetria entre purpose e capabilities, e sinaliza que o modelo será refinado."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "NPM solicita verificação de identidade de organização recém-registrada na rede."
			command:         "VerifyOrganizationIdentity"
			resultingEvents: ["IdentityVerificationCompleted"]
			description:     "Inicia processo de verificação de identidade: coleta dados, consulta fontes externas (Receita Federal, Junta Comercial, bureaus), emite resultado. Async porque verificação contra fontes externas tem latência variável. Resultado publicado como evento para NPM e exposto via query para confirmação no momento da decisão."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "LOG solicita assinatura criptográfica de evidência operacional durante registro."
			command:         "SignEvidence"
			resultingEvents: ["EvidenceSigned"]
			description:     "Assina evidência com DSSE (Dead Simple Signing Envelope). Sync porque LOG precisa da assinatura para completar registro de evidência. Resultado inclui envelope assinado e metadata de verificação. EvidenceSigned é evento de domínio interno para audit trail — não publicado externamente. Outros BCs que registram evidência podem consumir esta primitiva, mas LOG é o consumer primário."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "DLV solicita geração de proof de integridade para verificação de entrega."
			command:         "GenerateIntegrityProof"
			resultingEvents: ["IntegrityProofGenerated"]
			description:     "Gera Merkle proof para conjunto de evidências armazenadas via CAS. Sync porque DLV precisa do proof para prosseguir com verificação. Proof permite verificação independente de integridade sem acesso ao conteúdo original. IntegrityProofGenerated é evento de domínio interno para audit trail — não publicado externamente. Outros fluxos de verificação podem consumir esta primitiva, mas DLV é o consumer primário."
		}, {
			type:        "query-surface"
			query:       "QueryIdentityVerificationStatus"
			returnType:  "IdentityVerificationResult"
			description: "Retorna status atual de verificação de identidade de uma organização. Consumido por NPM como SoT no momento da decisão de qualificação — query prevalece sobre evento previamente recebido em caso de divergência. Sync por natureza: NPM precisa de resposta determinística antes de aprovar."
		}, {
			type:        "query-surface"
			query:       "QueryEvidenceIntegrity"
			returnType:  "EvidenceIntegrityResult"
			description: "Verificação de armazenamento: confirma que conteúdo armazenado via CAS está íntegro — hash do conteúdo coincide com o endereço CAS e metadata de armazenamento é consistente. Responde: o conteúdo está como foi armazenado? Consumido por LOG quando precisa confirmar integridade antes de fornecer evidência a downstream. Conformist — LOG adota protocolo de IDC sem tradução."
		}, {
			type:        "query-surface"
			query:       "QueryCryptographicIntegrity"
			returnType:  "CryptographicIntegrityResult"
			description: "Verificação end-to-end: confirma que assinatura DSSE é válida contra identidade reconhecida por IDC, Merkle proof é consistente com a árvore, e conteúdo não foi adulterado em nenhum ponto da cadeia — da assinatura original até o momento da consulta. Responde: este conteúdo foi assinado por identidade verificada por IDC e permaneceu íntegro desde a origem? Consumido por DLV como primitiva de verificação de entrega. Conformist — DLV adota protocolo sem tradução."
		}]

		outbound: [{
			type:        "event-publisher"
			trigger:     "Verificação de identidade de organização concluída."
			event:       "IdentityVerificationCompleted"
			consumers:   ["npm"]
			description: "Notifica NPM que verificação de identidade concluiu com resultado (verificado ou não). NPM registra resultado e avança no processo de qualificação. Evento é trigger de fluxo — QueryIdentityVerificationStatus é SoT. Context-map referencia este evento na relação idc-to-npm."
		}]
		rationale: """
			Inbound: 3 commands (verificação de identidade async
			para NPM, assinatura criptográfica sync para LOG,
			geração de proof sync para DLV) + 3 query surfaces
			(status de verificação para NPM, integridade de
			armazenamento para LOG, integridade criptográfica
			end-to-end para DLV). Outbound: 1 event publisher
			(IdentityVerificationCompleted para NPM). SignEvidence
			e GenerateIntegrityProof são operações sync cujo
			resultado retorna na resposta — não publicam eventos
			externos porque não há processamento async downstream
			que justifique contrato de evento. Eventos internos
			(EvidenceSigned, IntegrityProofGenerated) existem para
			audit trail. IDC é provider transversal de primitivas
			de confiança (identidade, integridade, autorização),
			não helper genérico — cada primitiva tem consumer
			primário identificado e fronteira semântica clara.
			"""
	}

	businessDecisions: [{
		id:           "bd-idc-fusion"
		decision:     "Identidade, integridade criptográfica e autorização unificadas em único BC (IDC), substituindo antigos IDN e DGV separados."
		rationale:    "Verificação de identidade e integridade criptográfica compartilham o mesmo fundamento: quem fez, com qual permissão, e a evidência está íntegra. Separar em dois BCs criaria coupling bidirecional — DGV precisaria de IDN para saber quem assinou, IDN precisaria de DGV para verificar integridade da identidade. Fusão elimina fronteira artificial e simplifica cadeia de confiança."
		consequences: "IDC concentra 3 pilares (identidade, integridade, autorização) — risco de crescer para 'BC Deus'. Mitigação: capabilities estritamente definidas como primitivas — IDC verifica identidade, não executa KYC/AML (NPM). IDC assina e verifica integridade, não captura evidência (LOG). IDC autoriza, não decide política de negócio."
	}, {
		id:           "bd-primitives-not-policy"
		decision:     "IDC fornece primitivas de confiança (verificar, assinar, provar), não implementa políticas de negócio que consomem essas primitivas."
		rationale:    "Se IDC implementasse KYC/AML, compliance documental ou regras de autorização por domínio, cada mudança regulatória ou de negócio propagaria para IDC. Primitivas são estáveis — verificar identidade, assinar evidência, gerar proof. Políticas são voláteis — quem pode operar, quais documentos são exigidos, quais limites aplicam. Separar estabilidade de volatilidade preserva autonomia dos BCs consumers."
		consequences: "NPM executa KYC/AML usando verificação de identidade de IDC como pré-condição. LOG registra evidência usando assinatura de IDC como primitiva. Cada BC é owner da política de uso — IDC não tem visibilidade sobre por que a primitiva é consumida."
	}, {
		id:           "bd-crypto-single-owner"
		decision:     "CAS (Content-Addressable Storage), DSSE (Dead Simple Signing Envelope) e Merkle proofs sob ownership exclusivo de IDC."
		rationale:    "Integridade criptográfica exige cadeia de custódia inequívoca. Se múltiplos BCs pudessem assinar ou armazenar via CAS independentemente, não haveria garantia de unicidade de endereçamento nem consistência de chaves. Owner único garante que toda assinatura usa identidade verificada por IDC e todo conteúdo endereçável é armazenado sob mesmo esquema."
		consequences: "Todo BC que precisa de assinatura ou proof depende de IDC — IDC é gate de novas operações criptográficas. Mitigação: operações de assinatura e proof são stateless e idempotentes — falha temporária de IDC não corrompe dados, apenas bloqueia novas operações de verificação. BCs consumers podem cachear proofs já gerados."
	}, {
		id:           "bd-identity-not-authentication"
		decision:     "IDC verifica identidade de organizações (quem é esta entidade), não autentica sessões de usuários (quem está logado agora)."
		rationale:    "Mesh opera entre organizações, não entre usuários individuais. Autenticação de sessão é infraestrutura transversal (PLT), não domínio de confiança. IDC verifica que a organização X é quem alega ser — Receita Federal, Junta Comercial, bureaus. PLT autentica que o usuário Y tem sessão válida para operar em nome de X."
		consequences: "IDC não tem conceito de sessão, token ou login. Verificação de identidade é processo assíncrono com resultado persistente — não handshake de autenticação. PLT e IDC operam em camadas diferentes sem dependência direta."
	}, {
		id:           "bd-verify-not-interpret"
		decision:     "IDC verifica identidade e integridade, mas não interpreta, classifica ou atribui risco a entidades — essas decisões pertencem a BCs consumers."
		rationale:    "Se IDC interpretasse dados de identidade (e.g., inferir risco a partir de perfil, classificar entidade por porte ou segmento), acumularia responsabilidade analítica que pertence a REW (risco), NPM (qualificação) ou outros BCs de domínio. Drift de 'verificar' para 'interpretar' é gradual e difícil de reverter — fronteira explícita previne. Alternativa rejeitada concreta: IDC retornar score de confiança ou classificação derivada (e.g., 'identidade verificada com risco baixo'). Score derivado é interpretação — pertence a REW/NPM/outros consumers, não a IDC. O eixo desta decisão é distinto de bd-primitives-not-policy: aquela rejeita IDC implementar política externa (KYC/AML); esta rejeita IDC atribuir significado interpretativo ao próprio output."
		consequences: "IDC retorna resultado binário ou estruturado de verificação (verificado/não verificado, íntegro/não íntegro). Qualquer decisão derivada — pode operar? qual risco? qual classificação? — é responsabilidade do BC que consome a primitiva. IDC não tem visibilidade sobre o uso downstream do resultado."
	}]

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Organização verificada — construtora submetida a verificação de identidade como pré-condição de onboarding na rede."
		impactDescription: "Verificação de identidade com integridade criptográfica cria base de confiança para todas as operações subsequentes. Resultado é persistente e verificável por qualquer BC — construtora não precisa reprovar identidade a cada operação."
		rationale:         "Construtora é participante âncora. Verificação de identidade é o primeiro passo do lifecycle na Mesh — se IDC não verificar, NPM não qualifica, e nenhuma operação acontece."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Organização verificada — fornecedor submetido a verificação de identidade para operar como contraparte na rede."
		impactDescription: "Mesma base de confiança que construtora. Verificação única e persistente reduz fricção de entrada — fornecedor não repete processo a cada novo contrato."
		rationale:         "Fornecedor é o lado com menor poder de barganha. Processo de verificação de identidade eficiente reduz barreira de entrada e protege efeito de rede."
	}, {
		stakeholderRef:    "sh-03"
		roleInContext:     "Consumidor de integridade criptográfica — instituição financeira parceira que depende de cadeia de confiança verificável para due diligence sobre lastro."
		impactDescription: "Proofs de integridade gerados por IDC permitem verificação independente de evidência operacional sem depender de confiança na Mesh como intermediária — verificação criptográfica é auditável por qualquer parte com acesso ao proof, independentemente da instituição que o produziu."
		rationale:         "Instituição financeira parceira precisa de garantia verificável de que evidência de lastro não foi adulterada — IDC fornece a primitiva, DLV e LOG fornecem o contexto operacional."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulador — exige identificação verificável de todas as partes em operações intermediadas por SCD, com trail auditável."
		impactDescription: "IDC mantém cadeia de verificação de identidade com integridade criptográfica. Regulador pode solicitar reconstituição de quem foi verificado, quando, com quais fontes, e confirmar que evidência não foi adulterada."
		rationale:         "Identificação verificável é constraint inviolável (nível 1). Bacen exige que SCD identifique partes com diligência — IDC fornece a base criptográfica que sustenta essa diligência."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Executor do protocolo de confiança — executa verificações de identidade, assinaturas criptográficas e geração de proofs dentro dos limites do autonomy envelope."
		impactDescription: "Operações criptográficas (assinatura, proof) são determinísticas e idempotentes — autonomia alta. Verificação de identidade envolve fontes externas e ambiguidade — autonomia calibrada. Agente executa processos de verificação e não decide significado de negócio do resultado — pode avaliar consistência técnica, normalizar dados e detectar ambiguidade, mas decisões de uso downstream pertencem aos BCs consumers."
		rationale:         "Agente opera primitivas de confiança com governance proporcional ao determinismo de cada operação. Fronteira explícita: agente executa protocolo de verificação e reporta resultado, sem decidir política de uso downstream."
	}]

	costsEliminated: [{
		costRef: "ce-01"
		contribution: """
			IDC fornece a base criptográfica que torna evidência
			operacional verificável independentemente: assinatura
			DSSE vincula autoria à identidade verificada, CAS
			garante que conteúdo armazenado é o mesmo que foi
			assinado, Merkle proofs permitem verificação de
			conjuntos sem expor o conteúdo. Sem essa camada, a
			verificação de lastro por DLV dependeria de confiança
			institucional em vez de verificação criptográfica.
			"""
		rationale: "ce-01 (verificação independente de evidência) só é viável se a evidência tem autoria verificável e integridade preservada — IDC fornece exatamente essas duas garantias como primitivas reusáveis."
	}, {
		costRef: "ce-07"
		contribution: """
			Verificação de identidade organizacional única e
			persistente reduz custo de due diligence repetida:
			cada nova contraparte na rede consome o resultado
			já verificado por IDC em vez de reexecutar processo
			com fontes externas. Resultado é auditável e
			reconstituível — instituições financeiras parceiras
			podem confirmar a verificação sem refazer o trabalho.
			"""
		rationale: "ce-07 (custos de due diligence repetida) é endereçado quando verificação de identidade tem cadeia de custódia verificável — IDC mantém o resultado como SoT e fornece via query, evitando reexecução."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Comprador (construtora) — organização verificada que opera como contraparte principal em contratos."
			desiredBehavior:           "Submeter dados de identidade verídicos durante onboarding e operar consistentemente com a identidade verificada."
			correctOperationIncentive: "Verificação única e persistente reduz fricção em todas as operações subsequentes na rede. Identidade verificada é pré-condição para qualquer operação — não há atalho."
			manipulationVector:        "Tentar registrar identidade falsa ou usar credenciais de outra organização para operar na rede sem ser quem alega ser."
			manipulationCost:          "Verificação cruza dados com fontes externas autoritativas (Receita Federal, Junta Comercial, bureaus). Falsificação exigiria comprometer fontes externas, o que está fora do alcance prático e expõe a riscos legais (falsidade ideológica, fraude documental)."
			vsBenefit: """
				O benefício realista do vetor não é operar sob
				identidade falsa em uma única operação — é escapar
				de histórico negativo de crédito vinculado à
				identidade verdadeira (reset de reputação). Mesmo
				nesse cenário ampliado o custo permanece
				estruturalmente maior: fontes externas autoritativas
				vinculam CNPJ a quadro societário, patrimônio e
				histórico fiscal. Abrir CNPJ novo para esconder
				histórico cruza com sócios reais e endereço
				declarado, deixando trail rastreável por bureaus
				de crédito e pelo próprio Bacen. Reset de reputação
				via identidade falsa é detectável estruturalmente
				por cruzamento de fontes, não apenas por boa-fé do
				verificador.
				"""
			designResponse:            "IDC depende de múltiplas fontes externas autoritativas e mantém trail criptográfico de cada verificação. Tentativas de fraude geram evidência reutilizável por reguladores."
			rationale:                 "Construtora é participante âncora — incentivo para verificação honesta deve ser estrutural, não confiar em boa fé."
		}, {
			stakeholderRef:            "sh-02"
			participantType:           "Fornecedor — organização verificada que opera como contraparte de menor poder de barganha."
			desiredBehavior:           "Submeter dados de identidade verídicos e manter consistência ao longo do ciclo de vida na rede."
			correctOperationIncentive: "Verificação única elimina fricção de entrada repetida — fornecedor não reverifica a cada contrato. Resultado verificado abre acesso a múltiplos compradores."
			manipulationVector:        "Mesmo vetor que sh-01: identidade falsa ou usurpação de credenciais."
			manipulationCost:          "Mesmas fontes externas autoritativas, mesmo trail criptográfico. Adicionalmente, fornecedor que tenta operar sob identidade falsa perde acesso a todos os contratos da rede assim que a fraude é detectada."
			vsBenefit:                 "Custo de perder acesso à rede + risco legal supera qualquer benefício de operar fraudulentamente em contratos individuais."
			designResponse:            "Verificação é simétrica — mesmo rigor para construtora e fornecedor. Não há fast-path por porte ou volume."
			rationale:                 "Fornecedor com menor poder de barganha precisa de processo simétrico para confiar na rede como mecanismo de proteção, não apenas como gate."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Executor do protocolo de confiança — agente que executa operações de verificação, assinatura e proof dentro de autonomy envelope."
			desiredBehavior:           "Executar protocolo de verificação fielmente, reportar resultados sem viés, escalar ambiguidade técnica para humano supervisor quando autonomy envelope exigir."
			correctOperationIncentive: "Operações criptográficas são determinísticas e auditáveis — execução correta gera trail verificável. Self-monitoring detecta drift e reporta ao founder antes que padrão se consolide."
			manipulationVector:        "Favorecimento seletivo — agente poderia, em tese, aplicar critério de verificação mais leve para entidades específicas, ou cachear resultados sem reverificar quando necessário, criando viés sistemático invisível em casos individuais."
			manipulationCost: """
				Mitigação operacional atual: trail de cada
				operação é registrado em log configurado pelo
				founder fora do processo do agente; amostragem
				estatística por reverificação é executada
				manualmente ou por pipeline auxiliar configurado
				pelo founder; threshold de aceitação é
				supervisedDecision e qualquer alteração exige
				aprovação humana. Resolução estrutural futura:
				registro e amostragem como responsabilidade
				transversal de PLT (infraestrutura ainda não
				formalizada), garantindo separação arquitetural
				— não apenas operacional — entre execução e
				auditoria. Mecanismo secundário: self-monitoring
				pelo agente da própria distribuição de resultados
				como input adicional para diagnóstico, nunca
				como defesa primária.
				"""
			vsBenefit:                 "Agente não tem benefício direto em favorecer — não há contraparte oferecendo vantagem. Pressão potencial viria de otimização de custo (cachear em vez de reverificar) ou de vies de treinamento — ambos detectáveis pela amostragem por reverificação executada externamente, não pelo próprio agente."
			designResponse: """
				Atual: log externo configurado + amostragem por
				pipeline auxiliar + threshold supervisado + acesso
				direto do founder e do regulador ao trail.
				Futuro: substrato comum em PLT que torne a
				separação arquitetural por construção, não por
				configuração.
				"""
			rationale:                 "Agente é o executor real do protocolo na operação cotidiana — incentivo precisa cobrir tanto manipulação externa quanto drift interno do próprio agente. Drift detection é o mecanismo específico para vetor 'favorecimento seletivo'."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Executor do protocolo de confiança — vetor de conluio com contraparte verificada."
			desiredBehavior:           "Aplicar critério de verificação uniforme independentemente de qual organização está sendo verificada, mesmo na presença de pressão externa."
			correctOperationIncentive: "Agente não tem conta financeira, não recebe pagamento direto e não tem canal de comunicação privado com sh-01/sh-02 — qualquer interação acontece via interface auditada."
			manipulationVector:        "Construtora ou fornecedor oferece vantagem (financeira, operacional, ou de influência sobre regras futuras) ao operador humano do agente em troca de verificação leniente para sua própria identidade ou para identidade afiliada."
			manipulationCost: """
				Mitigação operacional atual: ausência de canal
				monetário entre agente e contraparte (agente não
				recebe pagamento direto), threshold de verificação
				como supervisedDecision (alterar critério exige
				aprovação humana fora do controle do agente),
				amostragem por reverificação executada por processo
				externo configurado pelo founder, e acesso autônomo
				do regulador (sh-04) ao trail criptográfico.
				Resolução estrutural futura: amostragem e gravação
				de trail como responsabilidade arquitetural de PLT,
				garantindo que conluio não possa ser ocultado por
				configuração operacional comprometida. Mecanismo
				secundário: comparação estatística contínua e
				self-review pelo agente como input adicional, não
				como gate.
				"""
			vsBenefit:                 "Benefício potencial de favorecer uma entidade é limitado pelo valor das operações daquela entidade na rede. Custo é detecção por amostragem externa + perda de credibilidade regulatória de toda a operação Mesh + responsabilização jurídica do operador humano. Custo é estruturalmente desproporcional ao benefício."
			designResponse: """
				Atual: remoção estrutural do canal monetário +
				supervisão humana sobre threshold + amostragem
				externa + observabilidade independente do regulador.
				Futuro: substrato comum em PLT para gravação de
				trail e amostragem por construção. Self-review do
				agente é complemento.
				"""
			rationale:                 "Vetor de conluio é o vetor adversarial mais provável quando agente é o ponto único de execução — incentivo precisa ser estrutural, não baseado em integridade do operador humano."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Executor do protocolo de confiança — vetor de omissão ativa."
			desiredBehavior:           "Executar toda requisição de verificação recebida ou registrar falha explícita com causa; nunca silenciar requisição."
			correctOperationIncentive: "Cada requisição gera registro de entrada antes de qualquer execução. Ausência de resultado dentro de SLA gera escalation automático. Consumer BC (NPM) detecta requisições sem resposta e reporta como incidente."
			manipulationVector:        "Agente simula timeout, ficar offline ou descartar requisição sem registro para evitar verificar uma identidade específica — produzindo o mesmo efeito de rejeição sem deixar trail explícito de decisão."
			manipulationCost: """
				Mitigação operacional atual: registro de entrada
				de cada requisição é gravado em fila configurada
				pelo founder fora do processo do agente, separado
				do registro de execução — agente não pode descartar
				requisição sem deixar trail de entrada. Consumer
				BC (NPM, LOG, DLV) detecta ausência de resposta
				independentemente porque depende do resultado para
				prosseguir. Resolução estrutural futura: fila e
				SLA monitoring como responsabilidade transversal
				de PLT (ainda não formalizada), garantindo que
				registro de entrada seja por construção
				inacessível ao agente. Mecanismo secundário:
				reconciliação periódica entre requisições recebidas
				e respostas emitidas, executada externamente.
				"""
			vsBenefit:                 "Omissão tem o mesmo custo de detecção que rejeição explícita, sem benefício adicional — o consumer ainda fica sem resposta e ainda escala. Único benefício marginal é negação plausível, anulada pelo registro de entrada externo ao agente."
			designResponse: """
				Atual: registro de entrada externo + dependência
				observável dos consumers + reconciliação por
				processo externo. Futuro: fila e SLA monitoring
				como substrato de PLT, separação por construção
				em vez de configuração.
				"""
			rationale:                 "Omissão é vetor sutil porque produz aparência de falha técnica em vez de decisão. Endereçada por separar registro de entrada de registro de resultado."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "Executor do protocolo de confiança — vetor de timing/front-running."
			desiredBehavior:           "Processar requisições de verificação em ordem determinística (FIFO ou outro critério público), sem reordenação que beneficie requisição específica."
			correctOperationIncentive: "Ordem de processamento é registrada por timestamp na entrada. Reordenação é detectável por comparação entre timestamp de entrada e timestamp de execução."
			manipulationVector:        "Agente atrasa verificação de organização A (concorrente) para dar vantagem temporal a organização B na qualificação para crédito ou participação em operação com janela limitada."
			manipulationCost: """
				Mitigação operacional atual: timestamps de entrada
				e execução são gravados em fila configurada pelo
				founder fora do processo do agente; ordem é
				verificável por terceiro (founder, auditor,
				regulador) por comparação direta entre os dois
				timestamps, sem cooperação do agente. Critério de
				ordenação é declarado e auditável. Resolução
				estrutural futura: fila com timestamps imutáveis
				como responsabilidade arquitetural de PLT,
				eliminando dependência de configuração operacional.
				Mecanismo secundário: amostragem estatística do
				tempo de processamento por organização revela
				tratamento assimétrico no agregado.
				"""
			vsBenefit:                 "Benefício temporal é apenas relevante quando há janela competitiva — caso raro. Custo de detecção (queixa do prejudicado + audit trail externo) é alto e a operação Mesh perde credibilidade ao ser identificada como manipulável por timing."
			designResponse: """
				Atual: timestamps em fila externa + critério de
				ordem declarado e público + verificabilidade por
				terceiro sem cooperação do agente + amostragem
				estatística complementar. Futuro: fila com
				timestamps imutáveis como substrato de PLT,
				ordem auditável por construção.
				"""
			rationale:                 "Vetor de front-running existe sempre que verificação é gate de operação com janela competitiva. Endereçado por tornar ordem auditável, não por confiar em FIFO implícito."
		}, {
			stakeholderRef: "sh-05"
			participantType: """
				Executor do protocolo de confiança — vetor de
				stale read entre estado vigente em IDC e cópia
				cacheada em consumer BC após revogação ou
				suspensão de identidade.
				"""
			desiredBehavior: """
				Garantir convergência entre estado vigente em
				IDC e estado em uso por cada consumer (NPM,
				LOG, DLV) com latência limitada e auditável;
				quando IDC marca identidade como revogada ou
				suspensa, propagar a invalidação ativamente em
				vez de depender exclusivamente do TTL passivo
				de cada consumer.
				"""
			correctOperationIncentive: """
				Operação produzida por consumer sobre cache
				stale gera registro auditável e é passível de
				rollback downstream em DLV/INV. Custo
				regulatório de operar com identidade não-vigente
				cresce linearmente com a janela de
				inconsistência — incentivo estrutural para
				minimizar essa janela.
				"""
			manipulationVector: """
				Os três pontos de exposição:
				(1) Estado vigente: IDC marca organização X
				como revogada (em t0) por decisão de verificação
				ou por sinal externo de comprometimento.
				(2) Cópia cacheada: cada consumer (NPM, LOG,
				DLV) mantém resultado de uma query anterior a
				t0 onde X figurava como verificada. O cache
				pode ser explícito (resultado armazenado) ou
				implícito (decisão tomada com base no resultado
				e nunca reavaliada).
				(3) Janela de inconsistência: intervalo entre
				t0 (revogação em IDC) e tN (atualização efetiva
				no consumer), determinado pelo TTL do consumer
				e pela frequência de reconciliação ou propagação
				ativa.
				Adversário (X, sabendo que foi revogada)
				acelera operações dentro de [t0, tN] explorando
				a janela. Consequência operacional por consumer
				dentro da janela: NPM continua qualificando X
				para novas operações e habilitando contratos
				baseados em identidade verificada inexistente,
				expondo a rede a contraparte inelegível; LOG
				continua aceitando e fornecendo evidência cuja
				identidade signatária está revogada, propagando
				evidência cripto-válida mas semanticamente
				inválida para downstream; DLV continua
				aceitando proofs de integridade atrelados a
				identidade revogada como suficientes para
				liberar entrega, validando fluxos cuja base de
				confiança foi removida.
				"""
			manipulationCost: """
				Mitigação operacional atual: TTL passivo
				configurado em cada consumer + reconciliação
				periódica entre IDC e consumers (executada por
				processo externo configurado pelo founder) +
				bloqueio downstream em DLV/INV quando
				inconsistência é detectada. Toda operação
				dentro da janela [t0, tN] gera registro
				auditável passível de rollback. Resolução
				estrutural futura: invalidação ativa via evento
				IdentityRevoked publicado por IDC e consumido
				por NPM, LOG, DLV (decisão pendente em oq-idc-1,
				registrada como ten-003). Enquanto a resolução
				estrutural não existir, o vetor permanece com
				cobertura parcial e janela de inconsistência
				diretamente proporcional ao TTL configurado nos
				consumers.
				"""
			vsBenefit: """
				O benefício para o adversário é proporcional à
				janela de inconsistência e ao número de
				operações que ele consegue executar antes da
				reconciliação. Para janelas curtas (TTL na
				ordem de minutos a dezenas de minutos) e
				operações detectáveis por bloqueio downstream
				em DLV/INV, o benefício realizável é baixo.
				Para janelas longas (TTL de horas ou ausência
				de reconciliação ativa) e operações que escapem
				do bloqueio downstream (e.g., decisões de
				qualificação em NPM cujo efeito já se propagou
				para fora do escopo de DLV/INV), o benefício
				pode ser substancial. Por isso a janela deve
				ser estruturalmente limitada, não apenas
				operacionalmente — ten-003 é o caminho de
				redução estrutural.
				"""
			designResponse: """
				Atual: TTL configurado em cada consumer +
				reconciliação periódica externa + bloqueio
				downstream em DLV/INV + responsabilização
				posterior por operações sobre cache stale.
				Futuro: protocolo de invalidação ativa via
				evento IdentityRevoked, dependente da resolução
				de oq-idc-1 / ten-003.
				"""
			rationale: """
				Vetor de cache stale é diretamente dependente
				da resolução estrutural de ten-003. Endereçamento
				atual é parcial e honestamente declarado: três
				pontos de exposição (estado vigente, cópia
				cacheada, janela de inconsistência) estão
				amarrados explicitamente, e a consequência
				operacional em cada consumer é nomeada — vetor
				não vira abstração genérica de cache.
				"""
		}, {
			stakeholderRef: "sh-05"
			participantType: """
				Executor do protocolo de confiança — vetor de
				side-channel via observação de padrão de queries
				de verificação.
				"""
			desiredBehavior: """
				Atender queries de verificação sem expor
				metadata observacional que permita inferir
				estado de identidades em verificação ou
				correlacionar atividade entre BCs.
				"""
			correctOperationIncentive: """
				Padrão de queries é observável por qualquer
				ator com acesso a logs de IDC ou de consumers.
				Sem mitigação estrutural, observador pode
				inferir que entidade X está sendo verificada
				antes do resultado público — vazamento de
				informação de domínio sensível.
				"""
			manipulationVector: """
				Observador com acesso a logs de query (operador
				da plataforma, BC consumer comprometido, ou
				auditoria com escopo amplo) infere state machine
				de verificação observando frequência, ordem e
				correlação de queries entre BCs. Permite
				inteligência adversarial sobre quem está em
				onboarding, quem foi suspenso, quem está em
				re-verificação.
				"""
			manipulationCost: """
				Mitigação operacional atual: gates de acesso a
				logs de query são supervisedDecision em
				governance — quem pode ler audit trail é
				decisão humana fora do controle do agente.
				Resolução estrutural futura: normalização de
				resposta (constant-time response, dummy traffic,
				agregação temporal) ainda não decidida —
				exigiria decisão arquitetural sobre o protocolo
				de query de IDC. Mecanismo secundário não se
				aplica: não há self-monitoring que detecte
				exfiltração silenciosa de padrão observacional.
				"""
			vsBenefit: """
				Vetor é assimétrico: custo de explorar é baixo
				(apenas acesso a logs) e benefício é alto
				(inteligência sobre identidades sensíveis em
				estados intermediários). Endereçamento atual é
				parcial — gates de acesso limitam quem observa,
				mas não normalizam o que é observável.
				Cobertura completa depende de decisão
				arquitetural não tomada.
				"""
			designResponse: """
				Atual: gate de acesso a logs (quem lê).
				Futuro: normalização de resposta
				(constant-time, dummy traffic) como direção de
				evolução, ainda não decidida. Vetor reconhecido
				com cobertura parcial em vez de coberto por
				mecanismo inexistente.
				"""
			rationale: """
				Side-channel é vetor adversarial assimétrico
				que não pode ser fechado por self-monitoring
				nem por boa-fé. Endereçamento estrutural exige
				decisão arquitetural sobre normalização de
				resposta — declarado como gap honesto, não
				como mitigação inventada. Cruza com ten-005
				(operador da plataforma) porque o observador
				mais provável é o operador.
				"""
		}]
		rationale: """
			Análise cobre seis vetores adversariais distintos
			contra sh-05 (drift interno, conluio com
			contraparte, omissão ativa, front-running, cache
			stale read, side-channel via padrão de queries)
			além dos vetores estruturais contra sh-01 e sh-02
			(identidade falsa incluindo reset de reputação).
			Cada vetor explicita seu mecanismo primário de
			mitigação como estrutural e externo ao agente
			(registro em fila separada, supervisão humana
			sobre threshold, amostragem por processo
			independente, bloqueio downstream, gates de acesso
			a logs); self-monitoring pelo agente é declarado
			como mecanismo secundário onde presente, nunca
			como defesa primária. Cobertura parcial é declarada
			honestamente quando o mecanismo estrutural depende
			de artefato ainda não materializado: ten-003
			(protocolo de revogação) afeta o vetor de cache
			stale, ten-004 (taxonomia de evidência) afeta a
			invariante pré-assinatura, ten-005 (operador da
			plataforma) afeta o vetor de side-channel e o
			conjunto de vetores não cobertos pela ausência de
			sh-NN para operador. Reguladores (sh-04) e
			parceiros financeiros (sh-03) não são participantes
			ativos — são consumers de evidência produzida por
			outros — por isso não geram vetor endereçável
			neste BC.
			"""
	}

	ownership: {
		domainAgentSpec: "contexts/idc/agents/idc-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "execute-identity-verification"
				description: "Executar processo de verificação de identidade contra fontes externas conforme protocolo definido, sem intervenção humana por execução individual."
				rationale:   "Operação determinística com protocolo bem-definido — humano supervisor não agrega valor por execução individual; auditoria é por amostragem."
			}, {
				id: "sign-evidence"
				description: """
					Assinar evidência via DSSE quando solicitado por BC
					autorizado. Decisão é autônoma porque está protegida
					por gate determinístico pré-assinatura sobre quatro
					invariantes: (1) BC solicitante está declarado como
					consumer autorizado da capacidade de assinatura no
					context-map; (2) identidade do solicitante está
					verificada por IDC com resultado vigente (não
					revogado nem suspenso) — protocolo de revogação
					ainda em formalização (ten-003); (3) evidência
					conforma com schema da classe declarada conforme
					taxonomia canônica de evidência — taxonomia ainda
					em formalização (ten-004); (4) requisição não é
					duplicata de assinatura já emitida — escopo de
					unicidade definido pela tupla (hash do conteúdo
					da evidência, classe de evidência, BC solicitante);
					reexecução com mesma tupla retorna a assinatura
					previamente emitida em vez de gerar nova; tentativa
					com classe ou BC distintos é tratada como
					requisição independente. Falha em qualquer
					invariante bloqueia a assinatura e gera registro
					de tentativa rejeitada. Não há julgamento semântico
					sobre valor da evidência — gate é determinístico
					sobre as invariantes acima.
					"""
				rationale: """
					P10 exige que operações com impacto financeiro
					passem por gate determinístico que imponha
					invariantes. Assinatura DSSE é gate de fluxos
					downstream (LOG → DLV → INV → FCE), portanto a
					autonomia só é admissível se o próprio gate
					determinístico está declarado e auditável. As
					quatro invariantes acima são a forma concreta
					desse gate em IDC.

					Ressalva de completude: invariantes (2) e (3)
					dependem de artefatos ainda não materializados
					— protocolo de revogação de identidade (ten-003)
					e taxonomia canônica de evidência (ten-004).
					Conformidade plena com P10 está condicionada à
					resolução estrutural dessas tensões. Até lá, as
					duas invariantes são sustentadas por configuração
					operacional verificável pelo founder, não por
					gate arquitetural.
					"""
			}, {
				id:          "generate-integrity-proof"
				description: "Gerar Merkle proof para conjunto de evidências armazenadas via CAS quando solicitado."
				rationale:   "Operação criptográfica determinística — proof é função pura do conteúdo armazenado."
			}, {
				id:          "normalize-identity-data"
				description: "Normalizar dados de identidade recebidos (formatação de CNPJ, padronização de razão social, deduplicação técnica) antes de submeter a fontes externas."
				rationale:   "Normalização técnica não decide significado de negócio — apenas reduz ruído sintático antes de verificação."
			}],
			supervisedDecisions: [{
				id:          "reject-identity-on-data-mismatch"
				description: "Rejeitar verificação por divergência entre dados submetidos e fontes externas — rejeição requer aprovação humana antes de tornar definitiva."
				rationale:   "Rejeição de identidade tem impacto direto sobre acesso à rede — falso negativo bloqueia organização legítima. Humano supervisor avalia ambiguidade antes da decisão se consolidar."
			}, {
				id:          "reject-identity-on-source-unavailable"
				description: "Rejeitar verificação quando fonte externa autoritativa está indisponível ou retorna resultado ambíguo."
				rationale:   "Indisponibilidade de fonte externa pode ser temporária — humano avalia se reverificar ou rejeitar definitivamente, evitando bloqueio injusto."
			}, {
				id:          "calibrate-verification-threshold"
				description: "Ajustar threshold de aceitação de verificação (e.g., quantas fontes devem confirmar) requer aprovação humana."
				rationale:   "Threshold define a política de verificação — mudança altera o critério de quem entra na rede, decisão estratégica que excede autonomia operacional."
			}],
			escalationCriteria: [{
				id:        "identity-compromise-suspected"
				condition: "Suspeita de comprometimento de identidade verificada (assinaturas anômalas, divergência entre uso e padrão histórico, alerta de fonte externa de fraude)."
				action:    "Suspender capacidade de assinatura para a identidade afetada, notificar founder imediatamente, preservar trail criptográfico para análise. Reativação só após decisão humana explícita."
				rationale: "Comprometimento de identidade compromete toda evidência assinada por aquela identidade — contenção imediata é prioridade sobre disponibilidade da operação."
			}, {
				id:        "verification-source-systematic-failure"
				condition: "Fonte externa autoritativa apresenta falha sistemática (não ambígua) — retorna dados incorretos comprovados ou está offline por período extenso."
				action:    "Notificar founder, suspender uso da fonte afetada, escalar para decisão sobre fontes alternativas ou pausa de verificações dependentes da fonte."
				rationale: "Fonte sistematicamente comprometida invalida verificações que dependem dela — decisão de continuar ou pausar tem impacto regulatório e exige humano."
			}, {
				id:        "drift-detected-in-verification-pattern"
				condition: "Self-monitoring detecta desvio estatístico no padrão de verificações (e.g., taxa de aceitação muda significativamente sem mudança de input)."
				action:    "Notificar founder, gerar relatório de amostragem comparativa, pausar autonomia sobre verificações até revisão."
				rationale: "Drift no padrão pode indicar viés emergente do agente ou mudança nas fontes externas — ambos exigem investigação humana antes que padrão se consolide."
			}, {
				id: "signature-pattern-anomaly"
				condition: """
					Self-monitoring detecta padrão anômalo em
					requisições de assinatura: volume fora da
					distribuição histórica, classe de evidência fora
					da taxonomia registrada, requisição repetida de
					BC não declarado como consumer autorizado, ou
					concentração temporal incompatível com fluxo
					operacional normal do BC solicitante.
					"""
				action: """
					Pausar assinatura para a classe ou origem afetada,
					notificar founder, preservar trail criptográfico
					das requisições anômalas. Reativação requer decisão
					humana após análise.
					"""
				rationale: """
					Gate determinístico cobre invariantes por requisição
					individual, mas padrão anômalo agregado pode indicar
					comprometimento, abuso de capacidade autorizada, ou
					drift no consumer. Detecção por padrão é complemento
					ao gate por requisição — sem ele, ataque distribuído
					passa pelas invariantes individuais e só é detectado
					em auditoria.
					"""
			}, {
				id: "sign-evidence-gap"
				condition: """
					Requisição de sign-evidence cujo BC consumer não
					está na whitelist estática autorizada (NPM, LOG,
					DLV) OU cuja classe de evidência não está
					declarada na taxonomia interna do IDC, enquanto
					ten-003 (protocolo de revogação ativa) e ten-004
					(taxonomia formal de evidência) não estiverem
					resolvidos.
					"""
				action: """
					Escalar ao founder antes de assinar. Não cachear
					decisão entre requisições — cada requisição fora
					do escopo conhecido é reavaliada individualmente.
					Preservar trail da requisição com motivo do
					escalation.
					"""
				rationale: """
					sign-evidence está em autonomousDecisions porque
					a operação criptográfica em si é determinística,
					mas as invariantes (2) identidade vigente e (3)
					conformidade de classe dependem de ten-003 e
					ten-004, ainda não materializados. Enquanto a
					resolução estrutural não existir, P10 exige gate
					humano sobre requisições fora do caminho
					conhecido-seguro — escalation cobre exatamente o
					delta entre o gate arquitetural pleno e o que é
					sustentado operacionalmente hoje. Vem reportado
					como finding vc-cv-05 da execução end-to-end de
					vp-canvas em 2026-04-07.
					"""
			}]
		}
		rationale: """
			Autonomia alta sobre operações criptográficas
			determinísticas (assinatura, proof, normalização);
			supervisão sobre decisões de rejeição (impacto direto
			no acesso à rede) e calibração de threshold (mudança
			de política); escalação imediata para suspeita de
			comprometimento, falha sistemática de fonte externa
			e drift detectado por self-monitoring. Boundaries são
			proporcionais ao determinismo de cada operação e ao
			impacto reversível ou irreversível da decisão.
			"""
	}

	assumptions: [{
		id:                 "as-idc-1"
		assumption:         "Fontes externas autoritativas (Receita Federal, Junta Comercial, bureaus) permanecem disponíveis via interfaces estáveis e mantêm qualidade de dados aceitável para verificação organizacional."
		invalidationSignal: "Aumento significativo de falhas de verificação atribuíveis a indisponibilidade ou divergência sistemática nas fontes; mudança estrutural em interface ou modelo de acesso de qualquer fonte autoritativa primária."
		rationale:          "IDC depende dessas fontes como ground truth — sem elas, verificação de identidade reduz a self-attestation, que não satisfaz constraint regulatório (sh-04)."
	}, {
		id:                 "as-idc-2"
		assumption:         "DSSE, CAS e Merkle proofs como primitivas criptográficas permanecem suficientes para os requisitos de integridade da Mesh no horizonte de planejamento atual."
		invalidationSignal: "Necessidade de verificação que excede o que essas primitivas suportam (e.g., zero-knowledge proofs para privacidade, threshold signatures para multi-party); descoberta de vulnerabilidade em qualquer das primitivas."
		rationale:          "Escolha das primitivas define a fronteira do que IDC pode oferecer — invalidação exige reavaliação arquitetural, não apenas implementação."
	}, {
		id:                 "as-idc-3"
		assumption:         "Modelo de identidade organizacional (não de usuário individual) é suficiente para todos os fluxos da Mesh no horizonte atual."
		invalidationSignal: "Surgimento de fluxo que exige verificação de identidade individual (e.g., responsabilidade pessoal por decisão específica) que não pode ser satisfeito por identidade organizacional + autenticação de sessão por PLT."
		rationale:          "bd-identity-not-authentication assume essa fronteira — invalidação exige redesenho de responsabilidades entre IDC e PLT."
	}]

	openQuestions: [{
		id:       "oq-idc-1"
		question: "Qual o protocolo exato de revogação de identidade verificada quando organização perde elegibilidade (e.g., baixa de CNPJ, decisão regulatória)?"
		impact:   "Sem protocolo definido, identidade revogada poderia continuar sendo aceita por consumers que cachearam o resultado anterior — risco de operação com contraparte inelegível."
		rationale: "Revogação cruza fronteiras de cache e propagação — exige decisão sobre TTL de query, invalidação ativa via evento, ou ambos."
	}, {
		id:       "oq-idc-2"
		question: "O modelo de autorização de IDC será binário (verificado/não verificado), RBAC (roles atribuídos por contexto) ou ABAC (atributos compostos por consumer)?"
		impact:   "Modelo de autorização define a granularidade de decisão que IDC pode delegar a consumers. Modelo errado força consumers a reimplementar lógica de autorização ou força IDC a conhecer política de domínio (violando bd-primitives-not-policy)."
		rationale: "Capability de autorização declarada (purpose menciona autorização como terceiro pilar) mas modelo ainda não fixo — decisão exige análise de casos reais de NPM, LOG e DLV antes de fixar contrato."
	}, {
		id:       "oq-idc-3"
		question: "Qual a estratégia de rotação de chaves criptográficas usadas para assinatura DSSE — automatizada por IDC ou supervisionada por humano?"
		impact:   "Rotação afeta toda evidência assinada — rotação errada invalida proofs históricos. Rotação ausente cria risco crescente de comprometimento."
		rationale: "Rotação de chaves é decisão criptográfica com impacto sobre todo o histórico — exige avaliação de trade-off entre automação operacional e supervisão humana antes de fixar política."
	}, {
		id: "oq-idc-4"
		question: """
			O "operador da plataforma" deve ser modelado como
			stakeholder distinto do founder no stakeholder map, e
			em caso afirmativo, IDC precisa documentar vetor de
			manipulação do operador sobre verificação de
			identidade e geração de proofs?
			"""
		impact: """
			IDC é raiz de confiança da Mesh — operador com acesso
			privilegiado pode em tese favorecer próprios clientes,
			extrair inteligência sobre identidades verificadas, ou
			introduzir viés sistemático. Sem stakeholder explícito,
			a análise de incentivos não pode endereçar este vetor
			nem propor mitigação arquitetural. Decisão tem impacto
			cross-BC, não apenas IDC.
			"""
		rationale: """
			Lacuna identificada na validação semântica do canvas
			IDC (vc-cv-02). Resolução exige decisão sobre o modelo
			de stakeholders ao nível domain, não ao nível BC.
			Cross-referência: ten-005 registra esta lacuna no
			log sistêmico de tensões e descreve o caminho de
			resolução estrutural (adição de sh-06 ao stakeholder
			map).
			"""
	}]

	verificationMetrics: [{
		id:        "vm-identity-verification-success-rate"
		metric:    "Taxa de sucesso de verificação de identidade contra fontes externas autoritativas, segmentada por fonte."
		target:    "Falhas atribuíveis a IDC (não à indisponibilidade de fonte) ≤ 0.5% das tentativas; taxa estável ao longo do tempo (sem drift)."
		rationale: "Taxa de sucesso confirma que protocolo está funcionando; estabilidade detecta drift que mereça investigação."
	}, {
		id:        "vm-cryptographic-integrity-verification-rate"
		metric:    "Taxa de proofs de integridade verificados com sucesso por consumers (DLV, parceiros financeiros)."
		target:    "100% dos proofs gerados por IDC verificáveis pelos consumers — qualquer falha de verificação é incidente de severidade alta."
		rationale: "Proof que falha verificação invalida toda a cadeia de confiança — métrica binária por design."
	}, {
		id:        "vm-audit-trail-completeness"
		metric:    "Completude do trail criptográfico — toda operação de verificação, assinatura ou proof tem entrada correspondente no audit log com hash verificável."
		target:    "100% — qualquer gap é violação de cc-04 e tratada como incidente."
		rationale: "Trail incompleto invalida cc-04 e expõe IDC a risco regulatório (sh-04)."
	}]

	rationale: """
		IDC é a raiz de confiança da Mesh — verifica identidade
		organizacional, assina evidência e gera proofs de
		integridade como primitivas reusáveis. Fusão de IDN e
		DGV (bd-idc-fusion) elimina coupling artificial entre
		dois BCs que compartilham o mesmo fundamento. Separação
		estrita entre primitiva e política (bd-primitives-not-policy)
		preserva autonomia dos consumers e protege IDC contra
		drift para 'BC Deus'. Single owner sobre criptografia
		(bd-crypto-single-owner) garante cadeia de custódia
		inequívoca. Identidade ≠ autenticação (bd-identity-not-authentication)
		preserva fronteira com PLT. Verificação ≠ interpretação
		(bd-verify-not-interpret) protege contra acumulação de
		responsabilidade analítica que pertence a outros BCs.
		Tensão arquitetural sobre archetype/businessRole
		registrada em ten-002 — gateway/operational-enabler é
		aproximação semântica para o papel conceitual de
		authority/trust-root, ainda não capturado pelo schema
		#Canvas. Lenses primárias aplicadas: lens-security-trust-infrastructure
		(criptografia e trust chain como infraestrutura),
		lens-multi-tenancy-and-identity-architecture (identity
		model). Lens secundária: lens-regulatory-compliance-as-architecture
		(identificação verificável como constraint regulatório).
		"""
}
