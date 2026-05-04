package strategic

// context-map.cue — Context Map da Mesh (v2).
// Instância de #ContextMap (architecture/artifact-schemas/context-map.cue).
//
// Singleton que documenta a topologia de integração entre os 25
// bounded contexts da Mesh e seus relacionamentos.
//
// v2: reconstruído sobre ontologia expandida (WI-037). Mudanças
// estruturais: IDN+DGV fundidos em IDC; 6 novos BCs (P2P, SSC,
// ITC, TCM, INS, IDC); macrofluxo expandido para incluir
// P2P, SSC e CTR upstream de CMT; spine financeiro ampliado com TCM
// e capacidades adjacentes de transferência de risco via INS.
//
// Convenção de nomenclatura dos data flows:
// - Eventos: {QualifiedEntity}{PastParticiple}
// - Commands: {Verb}{QualifiedEntity}
// - Queries: Query{Entity}{Aspect}
// Nomes são canônicos nesta versão; revisões futuras nos canvas
// de cada BC podem refiná-los.
//
// Convenção de referência de agent specs:
// - domainAgentSpec referencia o path canônico do agent spec do BC.
// - Formato: contexts/{bc}/agents/{bc}-primary-agent.cue
// - Substitui o antigo ID lógico agt-{bc}-primary (ADR-039).
// - Permite validação estrutural do formato diretamente pelo runner.
// - A coerência entre o BC do contexto e o BC embutido no path,
//   bem como a existência física do arquivo, é validada pelo runner
//   como regra semântica.
// - Estado transitório: paths declarados para todos os 25 BCs;
//   existência física dos arquivos é progressiva conforme agent
//   specs são criados por WI dedicados.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

meshContextMap: artifact_schemas.#ContextMap & {
	code: "mesh-context-map"
	name: "Mesh Context Map"

	purpose: """
		Documentar a topologia de integração entre os bounded contexts
		da Mesh: quais BCs existem, como se relacionam, quem é upstream
		e downstream, qual padrão de integração governa cada fronteira,
		e qual BC é owner de cada subdomínio. Este artefato é o SoT
		de fronteiras e relacionamentos entre contexts.
		"""

	topology: "global"

	// ==============================
	// CONTEXTS (25 BCs — 1:1 com subdomínios)
	// ==============================

	contexts: [
		// --- Core (6) ---
		{
			context: "cmt", name: "Commitment Management", subdomains: ["cmt"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "contexts/cmt/agents/cmt-primary-agent.cue"
			rationale: "Formaliza compromissos econômicos entre organizações com aceite bilateral, a partir de sinais upstream de procurement (P2P), eventualmente informados por sourcing estratégico (SSC), e sob termos contratuais de CTR. Consome sinais de risco (REW); publica compromissos para BDG, TCM e DRC. BC separado: linguagem de compromisso, gates de confirmação e invariantes de aceite mútuo são distintos de termos (CTR), risco (REW) e procurement (P2P)."
		},
		{
			context: "dlv", name: "Delivery & Verification", subdomains: ["dlv"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "contexts/dlv/agents/dlv-primary-agent.cue"
			rationale: "Verifica execução de compromissos contra critérios acordados. Consome evidência de LOG com integridade de IDC; publica verificação para INV, REW, NIM e DRC. BC separado: linguagem de verificação e suficiência de evidência é distinta de logística (LOG) e faturamento (INV)."
		},
		{
			context: "fce", name: "Financial Commitment Execution", subdomains: ["fce"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "contexts/fce/agents/fce-primary-agent.cue"
			rationale: "Executa liquidação financeira condicionada a gates de risco e fatura válida, com disponibilidade informada por TCM e settlement via BKR. Consome elegibilidade de REW e faturas de INV; publica sinais de pagamento para REW, ATO e TCM. BC separado: linguagem de liquidação e regras de settlement são distintas de faturamento (INV), risco (REW), tesouraria (TCM) e rails bancários (BKR)."
		},
		{
			context: "ngr", name: "Network Growth & Reach", subdomains: ["ngr"]
			subdomainType: "core", wardleyEvolution: "genesis"
			domainAgentSpec: "contexts/ngr/agents/ngr-primary-agent.cue"
			rationale: "Direciona crescimento da rede usando insights de NIM. Opera em parceria com NPM para onboarding de participantes. BC separado: linguagem de growth, estratégias de aquisição e métricas de rede são distintas de gestão de participantes (NPM) e inteligência (NIM)."
		},
		{
			context: "nim", name: "Network Intelligence & Mechanism Design", subdomains: ["nim"]
			subdomainType: "core", wardleyEvolution: "genesis"
			domainAgentSpec: "contexts/nim/agents/nim-primary-agent.cue"
			rationale: "Modela topologia e comportamento de rede para calibrar mecanismos de incentivo. Consome dados de NPM e DLV; publica ontologia de mecanismos para REW e insights para NGR. BC separado: linguagem de mecanismos, modelagem de rede e calibração de incentivos são distintas de risco (REW) e growth (NGR)."
		},
		{
			context: "rew", name: "Risk Engine & Risk Observability", subdomains: ["rew"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "contexts/rew/agents/rew-primary-agent.cue"
			rationale: "Avalia risco contínuo de participantes e operações. Consome sinais de múltiplos BCs; publica scores e elegibilidade como published language. BC separado: linguagem de risco, modelos de scoring e decisões de elegibilidade são distintas de compromissos (CMT) e financiamento (SCF)."
		},

		// --- Supporting (16) ---
		{
			context: "ato", name: "Accounting & Tax Operations", subdomains: ["ato"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/ato/agents/ato-primary-agent.cue"
			rationale: "Registra lançamentos fiscais e contábeis derivados de operações de faturamento, liquidação financeira, supply chain finance e comércio exterior. Consome eventos de INV, FCE, SCF e ITC em modo conformist. BC separado: linguagem fiscal/contábil e regulação tributária brasileira e aduaneira são distintas de faturamento (INV), liquidação (FCE), financiamento (SCF) e comércio exterior (ITC)."
		},
		{
			context: "bdg", name: "Budget & Approval", subdomains: ["bdg"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/bdg/agents/bdg-primary-agent.cue"
			rationale: "Aprova ou rejeita cobertura orçamentária para compromissos. Consome CommitmentAccepted de CMT; publica BudgetApproved para DLV. BC separado: linguagem orçamentária, regras de aprovação e limites de cobertura são distintos de compromisso (CMT) e verificação (DLV)."
		},
		{
			context: "ctr", name: "Contract & Terms Registry", subdomains: ["ctr"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/ctr/agents/ctr-primary-agent.cue"
			rationale: "Formalização e gestão de lifecycle de instrumentos contratuais — contratos-quadro, contratos de fornecimento e termos contratuais aplicáveis a pedidos de compra, ordens de serviço, SLAs, cláusulas de retenção e exigências de garantia. Registry canônico de termos contratuais consumido primariamente por CMT e por BCs downstream como SCF, DRC e ITC. Publica eventos de lifecycle para CMT, SCF, DRC e ITC; consome qualificação de NPM e decisões de SSC. BC separado: linguagem contratual, versionamento imutável e lifecycle de termos são distintos de compromisso (CMT), disputa (DRC) e sourcing (SSC)."
		},
		{
			context: "idc", name: "Identity & Data Governance", subdomains: ["idc"]
			subdomainType: "supporting", wardleyEvolution: "custom"
			domainAgentSpec: "contexts/idc/agents/idc-primary-agent.cue"
			rationale: "Gestão de identidade, autenticação, autorização, governança de dados e integridade criptográfica. Unifica identidade e primitivas de verificação criptográfica (CAS, DSSE, Merkle proofs) sob único owner — quem fez o quê, com qual permissão, e a evidência está íntegra. Substitui antigos IDN e DGV. Relações individuais modeladas apenas quando semanticamente diferenciadas (LOG, DLV, NPM); demais BCs consomem IDC como transversal."
		},
		{
			context: "drc", name: "Disputes, Reversals & Corrections", subdomains: ["drc"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/drc/agents/drc-primary-agent.cue"
			rationale: "Avalia e resolve disputas referenciando compromissos, evidência e termos. Consome de CMT, DLV e CTR; publica decisões para FCE e CMT. BC separado: linguagem de disputa, processo de resolução e reversão são distintos de compromisso (CMT) e execução financeira (FCE)."
		},
		{
			context: "ins", name: "Insurance & Risk Transfer", subdomains: ["ins"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/ins/agents/ins-primary-agent.cue"
			rationale: "Governa instrumentos de proteção e transferência de risco: seguro garantia, seguro de carga, performance bonds e outros instrumentos emitidos por seguradoras e garantidores. BC separado: linguagem securitária (apólice, sinistro, prêmio, franquia, endosso, cobertura), profissionais (corretores, underwriters) e regime regulatório (SUSEP, IRB) são distintos de precificação de risco (REW) e originação financeira (SCF). INS intermedia — não subscreve."
		},
		{
			context: "itc", name: "International Trade & Customs", subdomains: ["itc"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/itc/agents/itc-primary-agent.cue"
			rationale: "Governa operações de comércio exterior: freight forwarding, desembaraço aduaneiro, documentação comex e compliance aduaneiro. BC separado: linguagem de comex (BL, AWB, DI, Incoterms, NCM), profissionais (despachantes, freight forwarders) e regime regulatório (legislação aduaneira, Siscomex, câmbio) são distintos de logística doméstica (LOG) e execução financeira (FCE)."
		},
		{
			context: "inv", name: "Invoicing", subdomains: ["inv"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/inv/agents/inv-primary-agent.cue"
			rationale: "Emite faturas vinculadas a entrega verificada. Consome DeliveryVerified de DLV; publica InvoiceIssued para FCE, SCF e ATO. BC separado: linguagem fiscal de faturamento, regras de NF-e e regulação tributária são distintas de verificação (DLV) e liquidação (FCE)."
		},
		{
			context: "log", name: "Logistics & Operational Evidence", subdomains: ["log"]
			subdomainType: "supporting", wardleyEvolution: "custom"
			domainAgentSpec: "contexts/log/agents/log-primary-agent.cue"
			rationale: "Captura, registro e gestão de evidência operacional: rastreamento de carga, inspeção de qualidade, medição de obra, atividades de prestação de serviço e eventos de campo. Produz cadeia de custódia registrada que DLV consome. Consome integridade de IDC; publica eventos operacionais e cadeia de custódia para DLV. BC separado: linguagem de evidência operacional e rastreabilidade são distintas de verificação de compromisso (DLV) e governança de dados (IDC)."
		},
		{
			context: "npm", name: "Network Participant Management", subdomains: ["npm"]
			subdomainType: "supporting", wardleyEvolution: "custom"
			domainAgentSpec: "contexts/npm/agents/npm-primary-agent.cue"
			rationale: "Gerencia ciclo de vida de participantes da rede. Publica eventos de lifecycle para REW, NIM e SSC; expõe status via query para CTR e SSC; opera em parceria com NGR. BC separado: linguagem de participante, onboarding e qualificação são distintos de risco (REW) e growth (NGR)."
		},
		{
			context: "p2p", name: "Procure-to-Pay", subdomains: ["p2p"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/p2p/agents/p2p-primary-agent.cue"
			rationale: "Governa ciclo interno de demanda-compra: requisição, aprovação, emissão de pedido de compra para fornecedores participantes. BC separado: linguagem de procurement (requisição, autorização, pedido de compra), profissionais (compradores, requisitantes técnicos) e cadência de evolução (políticas corporativas) são distintos de compromisso econômico (CMT) e sourcing estratégico (SSC)."
		},
		{
			context: "obs", name: "Observability & Operational Intelligence", subdomains: ["obs"]
			subdomainType: "supporting", wardleyEvolution: "commodity"
			domainAgentSpec: "contexts/obs/agents/obs-primary-agent.cue"
			rationale: "Fornece observabilidade e inteligência operacional. Capability transversal consumida por todos os BCs de domínio. BC separado: linguagem de observabilidade e métricas operacionais é domínio especializado. Relações individuais omitidas — ver knownLimitations, regra de omissão de transversais."
		},
		{
			context: "plt", name: "Platform & Infrastructure Services", subdomains: ["plt"]
			subdomainType: "supporting", wardleyEvolution: "commodity"
			domainAgentSpec: "contexts/plt/agents/plt-primary-agent.cue"
			rationale: "Fornece serviços de plataforma e infraestrutura. Capability transversal consumida por todos os BCs de domínio. BC separado: linguagem de infraestrutura e serviços de plataforma é domínio especializado. Relações individuais omitidas — ver knownLimitations, regra de omissão de transversais."
		},
		{
			context: "ssc", name: "Strategic Sourcing & Category", subdomains: ["ssc"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/ssc/agents/ssc-primary-agent.cue"
			rationale: "Governa seleção estratégica de fornecedores e gestão de categorias de compra: cotação estruturada, equalização TCO, spend analysis e decisão de sourcing. BC separado: linguagem de sourcing (categoria, TCO, RFQ, spend), profissionais (category managers) e cadência (contratos-quadro anuais/plurianuais) são distintos de execução de compra (P2P) e qualificação de participantes (NPM)."
		},
		{
			context: "tcm", name: "Treasury & Cash Management", subdomains: ["tcm"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/tcm/agents/tcm-primary-agent.cue"
			rationale: "Governa visão de tesouraria corporativa: posição de caixa, projeção de fluxo de caixa, estratégia de liquidez e exposição cambial. BC separado: linguagem de tesouraria (cash position, cash forecast, liquidez, hedge), profissionais (tesoureiros, controllers) e cadência (projeções diárias/semanais) são distintos de execução financeira transacional (FCE) e originação de produto financeiro (SCF)."
		},
		{
			context: "scf", name: "Supply Chain Finance", subdomains: ["scf"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "contexts/scf/agents/scf-primary-agent.cue"
			rationale: "Estruturação e oferta de produtos financeiros sobre recebíveis operacionais e preparação de portfólios para distribuição: antecipação de recebíveis, reverse factoring, dynamic discounting, working capital e preparação de portfólios de securitização. Consome recebíveis materializados por INV, derivados de compromissos governados por CMT, elegibilidade de REW, termos de CTR e estado de cobertura securitária de INS; opera como SCD. BC separado: linguagem de financiamento de cadeia produtiva, regras de cessão e operação de FIDC são distintas de faturamento (INV) e risco (REW). SCF estrutura; FCE executa."
		},

		// --- Generic (3) ---
		{
			context: "bkr", name: "Banking Rails & Settlement", subdomains: ["bkr"]
			subdomainType: "generic", wardleyEvolution: "commodity"
			domainAgentSpec: "contexts/bkr/agents/bkr-primary-agent.cue"
			rationale: "Integra com rails bancários para liquidação física. Consumido por FCE para settlement. BC separado: linguagem de integração bancária e protocolos de settlement são domínio especializado distinto de execução financeira (FCE)."
		},
		{
			context: "ntf", name: "Notifications & Communications", subdomains: ["ntf"]
			subdomainType: "generic", wardleyEvolution: "commodity"
			domainAgentSpec: "contexts/ntf/agents/ntf-primary-agent.cue"
			rationale: "Fornece notificações e comunicações. Capability transversal consumida por todos os BCs de domínio. BC separado: linguagem de notificação e canais de comunicação é domínio especializado. Relações individuais omitidas — ver knownLimitations, regra de omissão de transversais."
		},
		{
			context: "str", name: "Storage & Document Management", subdomains: ["str"]
			subdomainType: "generic", wardleyEvolution: "commodity"
			domainAgentSpec: "contexts/str/agents/str-primary-agent.cue"
			rationale: "Fornece armazenamento e gestão documental. Capability transversal consumida por todos os BCs de domínio. BC separado: linguagem de storage e gestão documental é domínio especializado. Relações individuais omitidas — ver knownLimitations, regra de omissão de transversais."
		},
	]

	// ==============================
	// SUBDOMAIN OWNERSHIP (SoT — mapa 1:1)
	// ==============================

	subdomainOwnership: {
		cmt: {ownerContext: "cmt", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		dlv: {ownerContext: "dlv", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		fce: {ownerContext: "fce", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		ngr: {ownerContext: "ngr", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		nim: {ownerContext: "nim", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		rew: {ownerContext: "rew", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por separação deliberada de linguagem, invariantes e governança."}

		ato: {ownerContext: "ato", rationale: "Subdomínio supporting com linguagem fiscal/contábil própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		bdg: {ownerContext: "bdg", rationale: "Subdomínio supporting com linguagem orçamentária própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		ctr: {ownerContext: "ctr", rationale: "Subdomínio supporting com linguagem contratual própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		drc: {ownerContext: "drc", rationale: "Subdomínio supporting com linguagem de disputas e reversões própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		idc: {ownerContext: "idc", rationale: "Subdomínio supporting com linguagem de identidade e integridade de dados própria — BC dedicado por separação deliberada de linguagem, invariantes e governança. Fusão de antigos IDN e DGV."}
		ins: {ownerContext: "ins", rationale: "Subdomínio supporting com linguagem securitária própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		inv: {ownerContext: "inv", rationale: "Subdomínio supporting com linguagem fiscal/faturamento própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		itc: {ownerContext: "itc", rationale: "Subdomínio supporting com linguagem de comércio exterior própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		log: {ownerContext: "log", rationale: "Subdomínio supporting com linguagem logística e de evidência operacional própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		npm: {ownerContext: "npm", rationale: "Subdomínio supporting com linguagem de gestão de participantes própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		obs: {ownerContext: "obs", rationale: "Subdomínio supporting com linguagem de observabilidade própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		p2p: {ownerContext: "p2p", rationale: "Subdomínio supporting com linguagem de procurement própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		plt: {ownerContext: "plt", rationale: "Subdomínio supporting com linguagem de plataforma e infraestrutura própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		scf: {ownerContext: "scf", rationale: "Subdomínio supporting com linguagem de financiamento de cadeia produtiva própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		ssc: {ownerContext: "ssc", rationale: "Subdomínio supporting com linguagem de sourcing estratégico própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		tcm: {ownerContext: "tcm", rationale: "Subdomínio supporting com linguagem de tesouraria corporativa própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}

		bkr: {ownerContext: "bkr", rationale: "Subdomínio generic com linguagem de integração bancária própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		ntf: {ownerContext: "ntf", rationale: "Subdomínio generic com linguagem de notificações própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
		str: {ownerContext: "str", rationale: "Subdomínio generic com linguagem de armazenamento própria — BC dedicado por separação deliberada de linguagem, invariantes e governança."}
	}

	// ==============================
	// RELATIONSHIPS (46 total)
	// ==============================

	relationships: [

		// --- A. Commitment Lifecycle (5) ---
		{
			code:              "cmt-to-bdg"
			source:            {kind: "bounded-context", context: "cmt"}
			target:            {kind: "bounded-context", context: "bdg"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "CMT publica CommitmentAccepted; BDG consome para iniciar aprovação orçamentária."
			rationale:         "Spine do commitment lifecycle — compromisso formalizado precede verificação de cobertura."
			communication: {type: "async"}
			events: ["CommitmentAccepted"]
			flowRefs: ["commitment-lifecycle"]
		},
		{
			code:              "bdg-to-dlv"
			source:            {kind: "bounded-context", context: "bdg"}
			target:            {kind: "bounded-context", context: "dlv"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "BDG publica BudgetApproved; DLV consome para habilitar verificação de execução."
			rationale:         "Spine do commitment lifecycle — orçamento aprovado precede verificação de entrega."
			communication: {type: "async"}
			events: ["BudgetApproved"]
			flowRefs: ["commitment-lifecycle"]
		},
		{
			code:              "dlv-to-inv"
			source:            {kind: "bounded-context", context: "dlv"}
			target:            {kind: "bounded-context", context: "inv"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "DLV publica DeliveryVerified; INV consome para emitir NF-e vinculada."
			rationale:         "Spine do commitment lifecycle — entrega verificada precede faturamento. Invariante central: sem evidência, sem fatura."
			communication: {type: "async"}
			events: ["DeliveryVerified"]
			flowRefs: ["commitment-lifecycle"]
		},
		{
			code:              "inv-to-fce"
			source:            {kind: "bounded-context", context: "inv"}
			target:            {kind: "bounded-context", context: "fce"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "INV publica InvoiceIssued; FCE consome para executar pagamento."
			rationale:         "Spine do commitment lifecycle — fatura emitida precede liquidação financeira."
			communication: {type: "async"}
			events: ["InvoiceIssued"]
			flowRefs: ["commitment-lifecycle"]
		},
		{
			code:              "ctr-to-cmt"
			source:            {kind: "bounded-context", context: "ctr"}
			target:            {kind: "bounded-context", context: "cmt"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Contract & Terms canonical model"
			description:       "CTR expõe termos contratuais via published language e publica eventos de lifecycle; CMT consome para formalizar compromissos sob termos registrados e reagir a mudanças de termos."
			rationale:         "Compromisso referencia termos contratuais como pré-condição. CTR é SoT de termos; CMT traduz para linguagem de compromisso. Hybrid porque CMT consulta termos sincronamente na formalização e reage assincronamente a ativação, supersessão e cancelamento de termos."
			communication: {type: "hybrid"}
			events: ["ContractTermsActivated", "ContractTermsSuperseded", "ContractTermsCancelled"]
			queries: ["QueryContractTerms"]
		},

		// --- B. Evidence Chain (3) ---
		{
			code:              "log-to-dlv"
			source:            {kind: "bounded-context", context: "log"}
			target:            {kind: "bounded-context", context: "dlv"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "LOG publica evidência operacional; DLV consome para verificar execução contra critérios do compromisso."
			rationale:         "Evidência nasce em LOG (SoT de rastreabilidade operacional) e é consumida por DLV para decisão de suficiência."
			communication: {type: "async"}
			events: ["OperationalEvidenceRecorded"]
		},
		{
			code:              "idc-to-log"
			source:            {kind: "bounded-context", context: "idc"}
			target:            {kind: "bounded-context", context: "log"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "IDC fornece primitivas de verificação de integridade e governança de dados; LOG conforma com o protocolo."
			rationale:         "LOG não traduz — adota diretamente os padrões de integridade criptográfica de IDC. Conformist por design: custo de ACL sem benefício. Captura e integridade são preocupações distintas — LOG não garante não adulteração nem autoria verificável."
			communication: {type: "sync"}
			queries: ["QueryEvidenceIntegrity"]
		},
		{
			code:              "idc-to-dlv"
			source:            {kind: "bounded-context", context: "idc"}
			target:            {kind: "bounded-context", context: "dlv"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "IDC fornece verificação criptográfica de integridade; DLV conforma para garantir que evidência não foi adulterada."
			rationale:         "DLV depende de IDC para integridade criptográfica sem tradução — conformist é o padrão correto para primitiva de verificação."
			communication: {type: "sync"}
			queries: ["QueryCryptographicIntegrity"]
		},

		// --- C. Risk & Intelligence (8) ---
		{
			code:              "npm-to-rew"
			source:            {kind: "bounded-context", context: "npm"}
			target:            {kind: "bounded-context", context: "rew"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "NPM publica eventos de ciclo de vida de participantes; REW consome para alimentar modelos de risco."
			rationale:         "Comportamento de participantes é input para avaliação de risco. REW traduz para linguagem de risco via ACL."
			communication: {type: "async"}
			events: ["NetworkParticipantOnboarded", "NetworkParticipantStatusChanged"]
		},
		{
			code:              "dlv-to-rew"
			source:            {kind: "bounded-context", context: "dlv"}
			target:            {kind: "bounded-context", context: "rew"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "DLV publica EvidenceRecorded; REW consome para correlacionar padrões de execução com risco."
			rationale:         "Qualidade e frequência de entregas são sinais de risco. REW traduz resultado de verificação operacional para score. Evento alinhado com commitment-lifecycle.cue (EvidenceRecorded consumido por REW)."
			communication: {type: "async"}
			events: ["EvidenceRecorded"]
			flowRefs: ["commitment-lifecycle"]
		},
		{
			code:              "dlv-to-nim"
			source:            {kind: "bounded-context", context: "dlv"}
			target:            {kind: "bounded-context", context: "nim"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "DLV publica EvidenceRecorded; NIM consome para atualizar métricas de rede e calibrar mecanismos."
			rationale:         "Dados operacionais alimentam inteligência de rede. NIM traduz resultado de verificação para linguagem de mecanismos. Evento alinhado com commitment-lifecycle.cue (EvidenceRecorded consumido por NIM)."
			communication: {type: "async"}
			events: ["EvidenceRecorded"]
			flowRefs: ["commitment-lifecycle"]
		},
		{
			code:              "nim-to-rew"
			source:            {kind: "bounded-context", context: "nim"}
			target:            {kind: "bounded-context", context: "rew"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Network mechanisms ontology"
			description:       "NIM publica sinais de rede e mecanismos via published language; REW consome como input de risco."
			rationale:         "Inteligência de rede é dimensão de risco. Published language porque NIM expõe ontologia formal de mecanismos."
			communication: {type: "async"}
			events: ["NetworkBehaviorSignalEmitted", "IncentiveMechanismCalibrated"]
		},
		{
			code:              "nim-to-ngr"
			source:            {kind: "bounded-context", context: "nim"}
			target:            {kind: "bounded-context", context: "ngr"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "NIM publica insights de rede; NGR consome para direcionar estratégias de crescimento."
			rationale:         "Inteligência de rede informa onde crescer. NGR traduz insights para ações de growth."
			communication: {type: "async"}
			events: ["NetworkGrowthInsightPublished"]
		},
		{
			code:              "npm-to-nim"
			source:            {kind: "bounded-context", context: "npm"}
			target:            {kind: "bounded-context", context: "nim"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "NPM publica dados de participantes; NIM consome para modelar topologia e comportamento de rede."
			rationale:         "Dados de participantes são input fundamental para inteligência de rede."
			communication: {type: "async"}
			events: ["NetworkParticipantOnboarded", "NetworkParticipantStatusChanged"]
		},
		{
			code:              "fce-to-rew"
			source:            {kind: "bounded-context", context: "fce"}
			target:            {kind: "bounded-context", context: "rew"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "FCE publica PaymentSettled e sinais de comportamento de pagamento; REW consome para alimentar modelos de risco financeiro."
			rationale:         "Padrões de pagamento, atrasos e defaults são sinais de risco de alta relevância. Sem este fluxo, REW opera sem visibilidade sobre comportamento financeiro realizado."
			communication: {type: "async"}
			events: ["PaymentSettled", "PaymentObligationDefaulted"]
			feedbackLoop: {
				exists:                true
				reverseRelationshipId: "rew-to-fce"
				loopSemantics:         "Comportamento de pagamento alimenta risco; risco condiciona elegibilidade de pagamento — loop de aprendizado contínuo entre execução financeira e avaliação de risco."
			}
		},
		{
			code:              "rew-to-cmt"
			source:            {kind: "bounded-context", context: "rew"}
			target:            {kind: "bounded-context", context: "cmt"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Risk score and eligibility model"
			description:       "REW publica alertas de risco e resolução de alertas via published language; CMT consome para sinalizar e limpar sinalização de compromissos existentes com contraparte sob risco."
			rationale:         "REW retroalimenta CMT com sinalização de deterioração e resolução de risco em compromissos ativos. Par simétrico: CounterpartyRiskAlertRaised → flag at-risk, CounterpartyRiskAlertCleared → clear risk flag."
			communication: {type: "async"}
			events: ["CounterpartyRiskAlertRaised", "CounterpartyRiskAlertCleared"]
		},

		// --- D. Financial Products & Execution (5) ---
		{
			code:              "rew-to-scf"
			source:            {kind: "bounded-context", context: "rew"}
			target:            {kind: "bounded-context", context: "scf"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Risk score and eligibility model"
			description:       "REW publica score e elegibilidade via published language; SCF consome para decisão de antecipação."
			rationale:         "Decisão de crédito depende de risco. Published language porque score é ontologia formal consumida por múltiplos contexts."
			communication: {type: "async"}
			events: ["CounterpartyRiskScoreUpdated", "CreditEligibilityDecided"]
		},
		{
			code:              "rew-to-fce"
			source:            {kind: "bounded-context", context: "rew"}
			target:            {kind: "bounded-context", context: "fce"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Risk score and eligibility model"
			description:       "REW publica decisões de risco e elegibilidade; FCE consome como PrePaymentGuard."
			rationale:         "Pagamento condicional depende de decisão de risco. Invariante: dinheiro não move sem avaliação de risco."
			communication: {type: "async"}
			events: ["CreditEligibilityDecided"]
			feedbackLoop: {
				exists:                true
				reverseRelationshipId: "fce-to-rew"
				loopSemantics:         "Risco informa elegibilidade de pagamento; pagamento realizado retroalimenta risco — loop de aprendizado contínuo."
			}
		},
		{
			code:              "inv-to-scf"
			source:            {kind: "bounded-context", context: "inv"}
			target:            {kind: "bounded-context", context: "scf"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "INV publica ReceivableMaterialized; SCF consome como lastro para operação de antecipação."
			rationale:         "Recebível materializado é o ativo que SCF utiliza como lastro. Sem fatura válida, não há recebível."
			communication: {type: "async"}
			events: ["ReceivableMaterialized"]
			flowRefs: ["commitment-lifecycle"]
		},
		{
			code:              "fce-to-scf"
			source:            {kind: "bounded-context", context: "fce"}
			target:            {kind: "bounded-context", context: "scf"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "FCE expõe estado de pagamento e liquidação; SCF consome para reconciliar operações de antecipação."
			rationale:         "SCF precisa saber quando pagamento original foi liquidado para fechar operação de antecipação. Hybrid porque inclui consultas síncronas de estado e eventos assíncronos de liquidação."
			communication: {type: "hybrid"}
			events: ["PaymentSettled"]
			queries: ["QueryPaymentSettlementStatus"]
		},
		{
			code:              "bkr-to-fce"
			source:            {kind: "bounded-context", context: "bkr"}
			target:            {kind: "bounded-context", context: "fce"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "BKR expõe rails bancários e status de liquidação física; FCE consome para executar e confirmar settlement."
			rationale:         "FCE depende de BKR para liquidação física. Hybrid porque inclui iniciação síncrona de transferência e confirmação assíncrona de settlement."
			communication: {type: "hybrid"}
			events: ["BankSettlementConfirmed"]
			commands: ["InitiateBankTransfer"]
		},

		// --- E. Fiscal & Accounting (3) ---
		{
			code:              "inv-to-ato"
			source:            {kind: "bounded-context", context: "inv"}
			target:            {kind: "bounded-context", context: "ato"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "INV publica InvoiceIssued; ATO conforma para registrar lançamentos fiscais."
			rationale:         "ATO conforma com eventos de INV sem tradução — linguagem fiscal é extensão direta da linguagem de faturamento."
			communication: {type: "async"}
			events: ["InvoiceIssued"]
		},
		{
			code:              "fce-to-ato"
			source:            {kind: "bounded-context", context: "fce"}
			target:            {kind: "bounded-context", context: "ato"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "FCE publica PaymentSettled; ATO conforma para registrar lançamentos contábeis de liquidação."
			rationale:         "ATO conforma com eventos de FCE sem tradução — lançamentos contábeis derivam diretamente de eventos financeiros."
			communication: {type: "async"}
			events: ["PaymentSettled"]
		},
		{
			code:              "scf-to-ato"
			source:            {kind: "bounded-context", context: "scf"}
			target:            {kind: "bounded-context", context: "ato"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "SCF publica eventos de originação e liquidação de antecipação; ATO conforma para registrar consequências fiscais."
			rationale:         "Operações de SCF têm consequências fiscais e contábeis. ATO conforma porque linguagem fiscal é extensão direta dos eventos financeiros de SCF."
			communication: {type: "async"}
			events: ["ReceivableAdvanceOriginated", "ReceivableAdvanceSettled"]
		},

		// --- F. Participant & Growth (1) ---
		{
			code:              "ngr-npm"
			source:            {kind: "bounded-context", context: "ngr"}
			target:            {kind: "bounded-context", context: "npm"}
			direction:         "mutual-dependency"
			upstreamPattern:   "partnership"
			downstreamPattern: "partnership"
			description:       "NGR e NPM operam em parceria: NGR direciona crescimento, NPM gerencia ciclo de vida de participantes adquiridos."
			rationale:         "Relação simétrica — ambos influenciam mutuamente. NGR não é upstream de NPM nem vice-versa; co-evoluem. Partnership não implica shared model nem shared ownership — cada BC mantém linguagem e invariantes próprias."
			communication: {type: "async"}
			events: ["NetworkGrowthTargetDefined", "NetworkParticipantOnboarded"]
		},

		// --- G. Contract Management (3) ---
		{
			code:              "ctr-to-scf"
			source:            {kind: "bounded-context", context: "ctr"}
			target:            {kind: "bounded-context", context: "scf"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Contract & Terms canonical model"
			description:       "CTR expõe termos contratuais via published language e publica eventos de lifecycle; SCF consome para validar elegibilidade e reagir a mudanças de termos que afetam operações de antecipação."
			rationale:         "Operação de SCF depende de termos contratuais. SCF traduz termos para linguagem de financiamento via ACL. Hybrid porque SCF consulta termos sincronamente na originação e reage assincronamente a ativação e supersessão que afetam operações em curso."
			communication: {type: "hybrid"}
			events: ["ContractTermsActivated", "ContractTermsSuperseded"]
			queries: ["QueryContractTerms"]
		},
		{
			code:              "ctr-to-drc"
			source:            {kind: "bounded-context", context: "ctr"}
			target:            {kind: "bounded-context", context: "drc"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Contract & Terms canonical model"
			description:       "CTR expõe termos e cláusulas via published language e publica eventos de lifecycle; DRC consome para avaliar disputas contra termos formalizados e reagir a supersessão e cancelamento."
			rationale:         "Resolução de disputa referencia termos contratuais como base. DRC traduz para linguagem de disputa via ACL. Hybrid porque DRC consulta termos sincronamente na avaliação de disputas e reage assincronamente a supersessão e cancelamento que podem afetar disputas em curso."
			communication: {type: "hybrid"}
			events: ["ContractTermsSuperseded", "ContractTermsCancelled"]
			queries: ["QueryContractTerms", "QueryContractClauses"]
		},
		{
			code:              "npm-to-ctr"
			source:            {kind: "bounded-context", context: "npm"}
			target:            {kind: "bounded-context", context: "ctr"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "NPM expõe status de qualificação de participantes; CTR consome para validar partes antes de registrar termos."
			rationale:         "Registro de termos contratuais exige partes qualificadas (inv-valid-participant-qualification). CTR consulta NPM sincronamente como precondição de registro. ACL porque CTR traduz status de participante para linguagem contratual de qualificação."
			communication: {type: "sync"}
			queries: ["QueryParticipantStatus"]
		},

		// --- H. Disputes (4) ---
		{
			code:              "cmt-to-drc"
			source:            {kind: "bounded-context", context: "cmt"}
			target:            {kind: "bounded-context", context: "drc"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "CMT publica eventos de compromisso; DRC consome para contextualizar disputas com estado do compromisso."
			rationale:         "Disputa referencia compromisso original. DRC traduz estado do compromisso para linguagem de disputa."
			communication: {type: "async"}
			events: ["CommitmentAccepted", "CommitmentStateChanged"]
			feedbackLoop: {
				exists:                true
				reverseRelationshipId: "drc-to-cmt"
				loopSemantics:         "Compromisso contextualiza disputa; resolução de disputa altera estado do compromisso — loop bidirecional disputa↔compromisso."
			}
		},
		{
			code:              "dlv-to-drc"
			source:            {kind: "bounded-context", context: "dlv"}
			target:            {kind: "bounded-context", context: "drc"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "DLV publica eventos de verificação; DRC consome para avaliar disputas sobre execução."
			rationale:         "Disputas sobre entrega referenciam evidência de verificação. DRC traduz resultado de DLV para linguagem de disputa."
			communication: {type: "async"}
			events: ["DeliveryVerified", "DeliveryRejected"]
		},
		{
			code:              "drc-to-fce"
			source:            {kind: "bounded-context", context: "drc"}
			target:            {kind: "bounded-context", context: "fce"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "DRC publica decisões de disputa (reversão, compensação); FCE consome para executar consequências financeiras."
			rationale:         "Decisão de disputa tem consequência financeira direta. FCE traduz decisão para operação de pagamento."
			communication: {type: "async"}
			events: ["DisputeResolved", "FinancialCompensationOrdered"]
		},
		{
			code:              "drc-to-cmt"
			source:            {kind: "bounded-context", context: "drc"}
			target:            {kind: "bounded-context", context: "cmt"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "DRC publica decisões de disputa que afetam estado do compromisso; CMT consome para atualizar ciclo de vida."
			rationale:         "Decisão de disputa pode cancelar, suspender ou modificar compromisso. Sem este fluxo, CMT não tem visibilidade sobre decisões que alteram estado de compromissos existentes."
			communication: {type: "async"}
			events: ["DisputeResolved", "CommitmentSuspensionOrdered"]
			feedbackLoop: {
				exists:                true
				reverseRelationshipId: "cmt-to-drc"
				loopSemantics:         "Resolução de disputa altera estado do compromisso; compromisso contextualiza disputa — loop bidirecional disputa↔compromisso."
			}
		},
		// --- I. Procurement & Sourcing (4) ---
		{
			code:              "p2p-to-cmt"
			source:            {kind: "bounded-context", context: "p2p"}
			target:            {kind: "bounded-context", context: "cmt"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "P2P publica PurchaseOrderEmitted; CMT consome para formalizar compromisso econômico bilateral a partir do pedido de compra."
			rationale:         "Pedido de compra é sinal de demanda unilateral do comprador; compromisso exige aceite mútuo. P2P é upstream porque o pedido precede o compromisso no macrofluxo. CMT traduz pedido para linguagem de compromisso via ACL."
			communication: {type: "async"}
			events: ["PurchaseOrderEmitted"]
		},
		{
			code:              "ssc-to-p2p"
			source:            {kind: "bounded-context", context: "ssc"}
			target:            {kind: "bounded-context", context: "p2p"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "SSC publica decisão de sourcing e fornecedores selecionados; P2P consome para direcionar emissão de pedidos aos fornecedores aprovados."
			rationale:         "Decisão estratégica de sourcing precede execução de compra. SSC seleciona fornecedor e condições; P2P executa o pedido sob essas condições. P2P traduz decisão de sourcing para linguagem de procurement via ACL."
			communication: {type: "async"}
			events: ["SourcingDecisionMade", "PreferredSupplierDesignated", "StrategicAwardCompleted"]
		},
		{
			code:              "ssc-to-ctr"
			source:            {kind: "bounded-context", context: "ssc"}
			target:            {kind: "bounded-context", context: "ctr"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "SSC publica decisão de sourcing que fundamenta formalização de contrato-quadro; CTR consome para iniciar registro de termos."
			rationale:         "Decisão de sourcing é gatilho para formalização contratual — contrato-quadro nasce de negociação estratégica (SSC), não de execução de compra (P2P). CTR traduz decisão de sourcing para linguagem contratual via ACL."
			communication: {type: "async"}
			events: ["SourcingDecisionMade"]
		},
		{
			code:              "npm-to-ssc"
			source:            {kind: "bounded-context", context: "npm"}
			target:            {kind: "bounded-context", context: "ssc"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "NPM publica eventos de qualificação de participantes e expõe status; SSC consome como input para decisão de sourcing."
			rationale:         "Sourcing estratégico depende de qualificação de participantes — fornecedor não qualificado não entra no pool de sourcing. Hybrid porque SSC consulta status sincronamente durante processo de cotação e reage assincronamente a mudanças de status."
			communication: {type: "hybrid"}
			events: ["NetworkParticipantStatusChanged"]
			queries: ["QueryParticipantStatus"]
		},

		// --- J. International Trade (3) ---
		{
			code:              "ctr-to-itc"
			source:            {kind: "bounded-context", context: "ctr"}
			target:            {kind: "bounded-context", context: "itc"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Contract & Terms canonical model"
			description:       "CTR expõe termos contratuais com cláusulas de comex (Incoterms, condições de embarque) via published language; ITC consome para governar operação de comércio exterior sob termos formalizados."
			rationale:         "Operação de comex é regida por termos contratuais — Incoterms definem responsabilidades logísticas e aduaneiras. CTR é SoT de termos; ITC traduz para linguagem de comex via ACL. Hybrid porque ITC consulta termos sincronamente na abertura de operação e reage assincronamente a mudanças."
			communication: {type: "hybrid"}
			events: ["ContractTermsActivated"]
			queries: ["QueryContractTerms"]
		},
		{
			code:              "itc-to-log"
			source:            {kind: "bounded-context", context: "itc"}
			target:            {kind: "bounded-context", context: "log"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "ITC publica eventos de fluxo aduaneiro (liberação, desembaraço, status documental); LOG consome como evidência operacional de operações internacionais."
			rationale:         "O fluxo aduaneiro e documental de ITC condiciona a logística internacional — liberação aduaneira é pré-condição para movimentação de carga. LOG registra esses fatos como evidência operacional. ITC é upstream porque o desembaraço precede a movimentação no fluxo internacional."
			communication: {type: "async"}
			events: ["CustomsClearanceCompleted", "TradeDocumentStatusChanged"]
		},
		{
			code:              "itc-to-ato"
			source:            {kind: "bounded-context", context: "itc"}
			target:            {kind: "bounded-context", context: "ato"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "ITC publica eventos de comércio exterior; ATO conforma para registrar consequências fiscais e obrigações aduaneiras."
			rationale:         "Operações de comex têm consequências fiscais específicas (impostos de importação, ICMS-ST, PIS/Cofins-importação). ATO conforma porque linguagem fiscal aduaneira é extensão direta dos eventos de comex."
			communication: {type: "async"}
			events: ["CustomsClearanceCompleted", "ImportTaxAssessed"]
		},

		// --- K. Treasury & Cash (3) ---
		{
			code:              "cmt-to-tcm"
			source:            {kind: "bounded-context", context: "cmt"}
			target:            {kind: "bounded-context", context: "tcm"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "CMT publica compromissos aceitos e mudanças de estado; TCM consome para projetar obrigações e direitos futuros na posição de caixa."
			rationale:         "Compromisso aceito gera obrigação/direito financeiro futuro que TCM precisa projetar para gestão de liquidez. TCM traduz estado de compromisso para linguagem de tesouraria (cash forecast) via ACL."
			communication: {type: "async"}
			events: ["CommitmentAccepted", "CommitmentStateChanged"]
		},
		{
			code:              "fce-to-tcm"
			source:            {kind: "bounded-context", context: "fce"}
			target:            {kind: "bounded-context", context: "tcm"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "FCE publica eventos de liquidação financeira; TCM consome para atualizar posição de caixa realizada."
			rationale:         "Pagamento liquidado altera posição de caixa — projeção vira realizado. TCM traduz evento de settlement para linguagem de tesouraria (cash position) via ACL."
			communication: {type: "async"}
			events: ["PaymentSettled"]
		},
		{
			code:              "tcm-to-fce"
			source:            {kind: "bounded-context", context: "tcm"}
			target:            {kind: "bounded-context", context: "fce"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "TCM expõe disponibilidade financeira e posição de caixa; FCE consome para otimizar sequenciamento e timing de execução de pagamentos."
			rationale:         "FCE utiliza informações de disponibilidade fornecidas por TCM para otimizar execução, sem assumir gestão de posição de caixa. Empresa pode ter orçamento sem caixa (BDG aprovou mas TCM não tem liquidez) ou caixa sem orçamento — são domínios distintos."
			communication: {type: "sync"}
			queries: ["QueryCashAvailability", "QueryCashForecast"]
		},

		// --- L. Insurance & Risk Transfer (3) ---
		{
			code:              "rew-to-ins"
			source:            {kind: "bounded-context", context: "rew"}
			target:            {kind: "bounded-context", context: "ins"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Risk score and eligibility model"
			description:       "REW publica score de risco e sinais de exposição via published language; INS consome como input para solicitar cotação e cobertura à seguradora externa."
			rationale:         "Score de risco da Mesh informa INS sobre exposição — INS usa como input para intermediar cotação com seguradoras externas. REW fornece sinal; INS gerencia vínculo de cobertura; seguradora externa é quem subscreve e decide aceitação do risco. INS nunca decide cobertura sozinho — intermedia."
			communication: {type: "async"}
			events: ["CounterpartyRiskScoreUpdated"]
		},
		{
			code:              "ins-to-scf"
			source:            {kind: "bounded-context", context: "ins"}
			target:            {kind: "bounded-context", context: "scf"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "INS publica estado de cobertura e eventos de apólice; SCF consome como input para elegibilidade e condições de produto financeiro."
			rationale:         "Existência de cobertura securitária pode melhorar condições de antecipação ou habilitar produtos que exigem garantia. SCF traduz estado de cobertura para linguagem de produto financeiro via ACL."
			communication: {type: "async"}
			events: ["CoverageActivated", "CoverageLapsed", "ClaimFiled"]
		},
		{
			code:              "ins-to-ext-insurers"
			source:            {kind: "bounded-context", context: "ins"}
			target:            {kind: "external-system", code: "ext-insurers", name: "Insurance Companies & Guarantors", type: "financial-institution", regulatoryVolatility: "medium"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "external-interface"
			description:       "INS solicita cotação e emissão de apólice a seguradoras externas; recebe confirmação de cobertura e notificação de sinistro."
			rationale:         "A Mesh não é seguradora nem garantidora — INS intermedia entre necessidade de cobertura da rede e capacidade de subscrição de seguradoras externas. Hybrid porque inclui solicitação síncrona de cotação e confirmação assíncrona de emissão e sinistro."
			communication: {type: "hybrid"}
			events: ["PolicyIssuedConfirmed", "ClaimProcessed"]
			commands: ["RequestQuotation", "RequestPolicyIssuance"]
		},

		// --- M. Identity & Data Governance (1) ---
		{
			code:              "idc-to-npm"
			source:            {kind: "bounded-context", context: "idc"}
			target:            {kind: "bounded-context", context: "npm"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "anti-corruption-layer"
			description:       "IDC fornece identidade verificável e evidências base de verificação de identidade; NPM consome como pré-condição para onboarding e qualificação de participantes."
			rationale:         "Identidade verificável é pré-condição de onboarding — NPM não qualifica sem identidade. Relação semanticamente diferenciada: NPM depende de verificação de identidade de forma distinta dos demais BCs que consomem autenticação genérica. ACL porque NPM traduz resultado de verificação para linguagem de qualificação de participante. Compliance material (KYC/AML) é responsabilidade de NPM — IDC fornece apenas a verificação de identidade base."
			communication: {type: "hybrid"}
			events: ["IdentityVerificationCompleted"]
			queries: ["QueryIdentityVerificationStatus"]
		},
	]

	// ==============================
	// HOOKS DE UNIFICAÇÃO
	// ==============================

	expectedContexts: [
		"ato", "bdg", "bkr", "cmt", "ctr",
		"dlv", "drc", "fce", "idc", "ins",
		"inv", "itc", "log", "ngr", "nim",
		"npm", "ntf", "obs", "p2p", "plt",
		"rew", "scf", "ssc", "str", "tcm",
	]

	declaredFlows: [
		"commitment-lifecycle",
	]

	// ==============================
	// LIMITAÇÕES E PREMISSAS
	// ==============================

	knownLimitations: [
		"v2 modela relações 1:1 entre BC e subdomínio — eventual reagrupamento exigirá revisão completa do mapa.",
		"BCs transversais (ntf, str, plt, obs) não têm relações individuais modeladas. IDC (ex-IDN+DGV) tem relações individuais com LOG, DLV e NPM por semântica diferenciada — demais BCs consomem IDC como transversal genérica. Regra de omissão: capability transversal consumida uniformemente por todos os BCs de domínio é registrada no rationale do contexto, não como N relações individuais. Relações individuais só são modeladas quando a integração é semanticamente diferenciada (padrão, SLA, ou data flow específico).",
		"Relações modelam integrações de domínio entre BCs — integrações técnicas (health checks, service discovery, logging) estão fora do escopo.",
		"Partnership NGR↔NPM é a única relação simétrica. Eventual necessidade de shared kernel entre outros BCs exigirá revisão.",
		"Nomes de eventos, commands e queries seguem convenção {QualifiedEntity}{PastParticiple}/{Verb}{QualifiedEntity}/Query{Entity}{Aspect} — nomes canônicos podem ser refinados nos canvas de cada BC.",
		"Os nomes de eventos, commands e queries neste mapa são candidatos canônicos estratégicos. Validação definitiva depende dos canvas e domain models de cada BC, onde cada data flow é definido com schema, payload e invariantes.",
		"domainLevelTransversals não modelados nesta versão — definição de shared kernels de domínio requer análise dos canvas de cada BC, que ainda não existem.",
		"INS→CMT não modelada nesta versão — não há evento de INS que mude estado de compromisso de forma semanticamente forte. Se canvas do CMT revelar CoverageRequirementBreached ou CoverageAttachedToCommitment, a relação entra.",
		"IDC→CMT e IDC→FCE não modeladas — assinatura/autorização verificável é consumida como transversal genérica por ambos. Se canvas revelar requisito criptográfico específico diferenciado do consumo genérico, relação entra.",
		"ATO acumula 4 upstreams conformist (INV, FCE, SCF, ITC). Decisão consciente — linguagem fiscal é extensão direta de cada upstream. Risco: mudança de schema em qualquer upstream impacta ATO sem tradução. Se a concentração gerar instabilidade, migrar para ACL seletivo nas relações mais voláteis.",
	]

	assumptions: [
		"Mapeamento 1:1 entre subdomínios e BCs é decisão arquitetural deliberada, não artefato acidental. Cada subdomínio foi analisado com precisão de BC (linguagem, invariantes, razão de existir próprias) e a conclusão foi que nenhum par de subdomínios compartilha linguagem o suficiente para justificar agrupamento. Esta decisão será reavaliada quando canvas de BCs revelarem sobreposição semântica não detectada na análise estratégica.",
		"BCs transversais (ntf, str, plt, obs) são consumidos como primitivas técnicas por todos os BCs de domínio. IDC tem relações explícitas com LOG, DLV e NPM por semântica diferenciada. A ausência de relações explícitas para demais BCs não significa ausência de dependência — significa que a dependência é uniforme e cross-cutting. Ver regra de omissão em knownLimitations.",
		"As relações modeladas refletem o Wave 0 da Mesh com ontologia expandida (WI-037). Evolução da rede pode introduzir novas relações ou alterar padrões existentes.",
		"Padrões conformist (ATO←INV, ATO←FCE, ATO←SCF, ATO←ITC, LOG←IDC, DLV←IDC) refletem decisão consciente: o custo de ACL não se justifica quando a linguagem downstream é extensão direta da upstream.",
		"Macrofluxo canônico estendido: SSC→{P2P, CTR}→CMT→BDG→DLV→INV→FCE. O spine antigo (CMT→BDG→DLV→INV→FCE) inicia no meio — o fluxo real começa na decisão de sourcing (SSC), que informa tanto a execução de compra (P2P) quanto a formalização contratual (CTR), ambas convergindo em CMT. O macrofluxo não é linear rígido: P2P→CMT direto existe para compras spot sem contrato-quadro prévio; SSC→CTR→CMT é o caminho quando há sourcing estratégico e formalização contratual. A coexistência das duas relações reflete bifurcação real por tipo de instrumento, não redundância.",
		"INS intermedia entre rede Mesh e seguradoras externas — nunca subscreve risco. A existência de instrumento de proteção não elimina o risco subjacente nem garante indenização automática.",
	]

	rationale: """
		Context map v2 com 25 BCs e 46 relações. Reconstruído sobre
		ontologia expandida (WI-037): IDN+DGV fundidos em IDC; 6 novos
		BCs (P2P, SSC, ITC, TCM, INS, IDC). Mapeamento 1:1
		BC↔subdomínio mantido. 46 relações cobrem: spine do commitment
		lifecycle (5), cadeia de evidência (3), risco e inteligência (8),
		produtos financeiros e execução (5), fiscal e contábil (3),
		crescimento de rede (1), gestão contratual (3), disputas (4),
		procurement e sourcing (4, inclui fluxos upstream P2P, SSC e CTR antes de CMT),
		comércio exterior (3, ITC como hub entre CTR, LOG e ATO),
		tesouraria e caixa (3, TCM como visão consolidada de
		liquidez com feedback loop implícito fce→tcm→fce),
		seguro e transferência de risco (3, INS como intermediário
		entre rede e seguradoras externas), e identidade e governança
		de dados (1, idc-to-npm por identidade verificável + 2
		existentes idc-to-log e idc-to-dlv por integridade
		criptográfica). 4 BCs transversais (ntf, str, plt, obs)
		consumidos cross-cutting sem relações individuais. IDC tem 3
		relações diferenciadas. 2 pares de feedback loops diretos:
		fce↔rew (pagamento↔risco) e cmt↔drc (compromisso↔disputa).
		1 sistema externo novo: ext-insurers (seguradoras e
		garantidores). Macrofluxo canônico estendido:
		SSC→{P2P, CTR}→CMT→BDG→DLV→INV→FCE. Padrões: OHS/ACL como
		default, OHS-PL/ACL para ontologias formais (CTR, NIM, REW),
		conformist para extensão direta (ATO, LOG←IDC, DLV←IDC,
		ATO←ITC), partnership para simetria (NGR↔NPM).
		"""
}
