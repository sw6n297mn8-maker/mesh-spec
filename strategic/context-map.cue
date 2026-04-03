package strategic

// context-map.cue — Context Map da Mesh.
// Instância de #ContextMap (architecture/artifact-schemas/context-map.cue).
//
// Singleton que documenta a topologia de integração entre os 21
// bounded contexts da Mesh e seus 31 relacionamentos. Derivado
// da análise de 19 lenses sobre os 21 subdomínios definidos em
// strategic/subdomains/, com 4 rounds de red team na topologia
// e 4 rounds de red team na instância.
//
// Convenção de nomenclatura dos data flows:
// - Eventos: {QualifiedEntity}{PastParticiple}
// - Commands: {Verb}{QualifiedEntity}
// - Queries: Query{Entity}{Aspect}
// Nomes são canônicos nesta versão; revisões futuras nos canvas
// de cada BC podem refiná-los.

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
	// CONTEXTS (21 BCs — 1:1 com subdomínios)
	// ==============================

	contexts: [
		// --- Core (6) ---
		{
			context: "cmt", name: "Commitment Management", subdomains: ["cmt"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "cmt-primary-agent"
			rationale: "Formaliza compromissos econômicos entre organizações com aceite mútuo bilateral, respeitando termos contratuais (CTR) e sinais de risco de contraparte (REW). Opera gates de confirmação."
		},
		{
			context: "dlv", name: "Delivery & Verification", subdomains: ["dlv"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "dlv-primary-agent"
			rationale: "Verifica execução de compromissos contra critérios acordados usando evidência operacional de LOG com integridade criptográfica de DGV. Publica resultado verificado ou rejeitado."
		},
		{
			context: "fce", name: "Financial Commitment Execution", subdomains: ["fce"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "fce-primary-agent"
			rationale: "Executa liquidação financeira condicionada a gates de risco (REW) e fatura válida (INV). Interage com BKR para settlement físico. Publica sinais de comportamento de pagamento."
		},
		{
			context: "ngr", name: "Network Growth & Reach", subdomains: ["ngr"]
			subdomainType: "core", wardleyEvolution: "genesis"
			domainAgentSpec: "ngr-primary-agent"
			rationale: "Direciona crescimento da rede usando insights de topologia e mecanismos de NIM. Opera em parceria com NPM para onboarding. Maximiza efeito de rede informacional."
		},
		{
			context: "nim", name: "Network Intelligence & Mechanism Design", subdomains: ["nim"]
			subdomainType: "core", wardleyEvolution: "genesis"
			domainAgentSpec: "nim-primary-agent"
			rationale: "Modela topologia e comportamento de rede a partir de dados operacionais (DLV) e de participantes (NPM). Calibra mecanismos de incentivo. Publica ontologia formal de mecanismos."
		},
		{
			context: "rew", name: "Risk Engine & Risk Observability", subdomains: ["rew"]
			subdomainType: "core", wardleyEvolution: "custom"
			domainAgentSpec: "rew-primary-agent"
			rationale: "Avalia risco contínuo de participantes e operações consumindo sinais de NPM, DLV, FCE e NIM. Publica scores, elegibilidade e alertas como published language consumida por CMT, SCF e FCE."
		},

		// --- Supporting (12) ---
		{
			context: "ato", name: "Accounting & Tax Operations", subdomains: ["ato"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "ato-primary-agent"
			rationale: "Registra lançamentos fiscais e contábeis consumindo eventos de INV, FCE e SCF em modo conformist. Opera sob regulação fiscal brasileira."
		},
		{
			context: "bdg", name: "Budget & Approval", subdomains: ["bdg"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "bdg-primary-agent"
			rationale: "Aprova ou rejeita cobertura orçamentária para compromissos aceitos. Consome CommitmentAccepted de CMT e publica BudgetApproved para DLV."
		},
		{
			context: "ctr", name: "Contract & Terms Registry", subdomains: ["ctr"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "ctr-primary-agent"
			rationale: "Registra e expõe termos contratuais como published language. SoT de condições que governam compromissos (CMT), financiamento (SCF) e disputas (DRC)."
		},
		{
			context: "dgv", name: "Data Governance & Verification", subdomains: ["dgv"]
			subdomainType: "supporting", wardleyEvolution: "custom"
			domainAgentSpec: "dgv-primary-agent"
			rationale: "Fornece primitivas de verificação criptográfica e governança de dados consumidas por LOG e DLV em modo conformist."
		},
		{
			context: "drc", name: "Disputes, Reversals & Corrections", subdomains: ["drc"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "drc-primary-agent"
			rationale: "Avalia e resolve disputas referenciando compromissos (CMT), evidência (DLV) e termos (CTR). Publica decisões que afetam estado de compromissos e execução financeira."
		},
		{
			context: "idn", name: "Identity & Access Management", subdomains: ["idn"]
			subdomainType: "supporting", wardleyEvolution: "commodity"
			domainAgentSpec: "idn-primary-agent"
			rationale: "Gerencia identidade, autenticação e autorização como primitiva transversal consumida por todos os BCs de domínio. Relações individuais omitidas para evitar ruído semântico."
		},
		{
			context: "inv", name: "Invoicing", subdomains: ["inv"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "inv-primary-agent"
			rationale: "Emite faturas (NF-e) vinculadas a entrega verificada (DLV). Materializa recebíveis consumidos por SCF. Opera sob regulação fiscal brasileira."
		},
		{
			context: "log", name: "Logistics & Operational Evidence", subdomains: ["log"]
			subdomainType: "supporting", wardleyEvolution: "custom"
			domainAgentSpec: "log-primary-agent"
			rationale: "Registra evidência operacional com rastreabilidade de cadeia produtiva. SoT de eventos operacionais consumidos por DLV para verificação."
		},
		{
			context: "npm", name: "Network Participant Management", subdomains: ["npm"]
			subdomainType: "supporting", wardleyEvolution: "custom"
			domainAgentSpec: "npm-primary-agent"
			rationale: "Gerencia ciclo de vida de participantes da rede. Publica eventos consumidos por REW e NIM. Opera em parceria com NGR."
		},
		{
			context: "obs", name: "Observability & Operational Intelligence", subdomains: ["obs"]
			subdomainType: "supporting", wardleyEvolution: "commodity"
			domainAgentSpec: "obs-primary-agent"
			rationale: "Fornece observabilidade e inteligência operacional como primitiva transversal consumida por todos os BCs de domínio. Relações individuais omitidas para evitar ruído semântico."
		},
		{
			context: "plt", name: "Platform & Infrastructure Services", subdomains: ["plt"]
			subdomainType: "supporting", wardleyEvolution: "commodity"
			domainAgentSpec: "plt-primary-agent"
			rationale: "Fornece serviços de plataforma e infraestrutura como primitiva transversal consumida por todos os BCs de domínio. Relações individuais omitidas para evitar ruído semântico."
		},
		{
			context: "scf", name: "Supply Chain Finance", subdomains: ["scf"]
			subdomainType: "supporting", wardleyEvolution: "product"
			domainAgentSpec: "scf-primary-agent"
			rationale: "Origina e liquida operações de antecipação de recebíveis usando lastro de INV, elegibilidade de REW e termos de CTR. Opera como SCD."
		},

		// --- Generic (3) ---
		{
			context: "bkr", name: "Banking Rails & Settlement", subdomains: ["bkr"]
			subdomainType: "generic", wardleyEvolution: "commodity"
			domainAgentSpec: "bkr-primary-agent"
			rationale: "Integra com rails bancários para liquidação física. Expõe transferência e confirmação de settlement consumidos por FCE."
		},
		{
			context: "ntf", name: "Notifications & Communications", subdomains: ["ntf"]
			subdomainType: "generic", wardleyEvolution: "commodity"
			domainAgentSpec: "ntf-primary-agent"
			rationale: "Fornece notificações e comunicações como primitiva transversal consumida por todos os BCs de domínio. Relações individuais omitidas para evitar ruído semântico."
		},
		{
			context: "str", name: "Storage & Document Management", subdomains: ["str"]
			subdomainType: "generic", wardleyEvolution: "commodity"
			domainAgentSpec: "str-primary-agent"
			rationale: "Fornece armazenamento e gestão documental como primitiva transversal consumida por todos os BCs de domínio. Relações individuais omitidas para evitar ruído semântico."
		},
	]

	// ==============================
	// SUBDOMAIN OWNERSHIP (SoT — mapa 1:1)
	// ==============================

	subdomainOwnership: {
		cmt: {ownerContext: "cmt", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por análise de 19 lenses."}
		dlv: {ownerContext: "dlv", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por análise de 19 lenses."}
		fce: {ownerContext: "fce", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por análise de 19 lenses."}
		ngr: {ownerContext: "ngr", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por análise de 19 lenses."}
		nim: {ownerContext: "nim", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por análise de 19 lenses."}
		rew: {ownerContext: "rew", rationale: "Subdomínio core com linguagem, regras e invariantes próprias — BC dedicado por análise de 19 lenses."}

		ato: {ownerContext: "ato", rationale: "Subdomínio supporting com linguagem fiscal/contábil própria — BC dedicado por análise de 19 lenses."}
		bdg: {ownerContext: "bdg", rationale: "Subdomínio supporting com linguagem orçamentária própria — BC dedicado por análise de 19 lenses."}
		ctr: {ownerContext: "ctr", rationale: "Subdomínio supporting com linguagem contratual própria — BC dedicado por análise de 19 lenses."}
		dgv: {ownerContext: "dgv", rationale: "Subdomínio supporting com linguagem de governança de dados própria — BC dedicado por análise de 19 lenses."}
		drc: {ownerContext: "drc", rationale: "Subdomínio supporting com linguagem de disputas e reversões própria — BC dedicado por análise de 19 lenses."}
		idn: {ownerContext: "idn", rationale: "Subdomínio supporting com linguagem de identidade e acesso própria — BC dedicado por análise de 19 lenses."}
		inv: {ownerContext: "inv", rationale: "Subdomínio supporting com linguagem fiscal/faturamento própria — BC dedicado por análise de 19 lenses."}
		log: {ownerContext: "log", rationale: "Subdomínio supporting com linguagem logística e de evidência operacional própria — BC dedicado por análise de 19 lenses."}
		npm: {ownerContext: "npm", rationale: "Subdomínio supporting com linguagem de gestão de participantes própria — BC dedicado por análise de 19 lenses."}
		obs: {ownerContext: "obs", rationale: "Subdomínio supporting com linguagem de observabilidade própria — BC dedicado por análise de 19 lenses."}
		plt: {ownerContext: "plt", rationale: "Subdomínio supporting com linguagem de plataforma e infraestrutura própria — BC dedicado por análise de 19 lenses."}
		scf: {ownerContext: "scf", rationale: "Subdomínio supporting com linguagem de financiamento de cadeia produtiva própria — BC dedicado por análise de 19 lenses."}

		bkr: {ownerContext: "bkr", rationale: "Subdomínio generic com linguagem de integração bancária própria — BC dedicado por análise de 19 lenses."}
		ntf: {ownerContext: "ntf", rationale: "Subdomínio generic com linguagem de notificações própria — BC dedicado por análise de 19 lenses."}
		str: {ownerContext: "str", rationale: "Subdomínio generic com linguagem de armazenamento própria — BC dedicado por análise de 19 lenses."}
	}

	// ==============================
	// RELATIONSHIPS (31 total)
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
			description:       "CTR expõe termos contratuais via published language; CMT consome para formalizar compromissos sob termos registrados."
			rationale:         "Compromisso referencia termos contratuais como pré-condição. CTR é SoT de termos; CMT traduz para linguagem de compromisso."
			communication: {type: "sync"}
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
			code:              "dgv-to-log"
			source:            {kind: "bounded-context", context: "dgv"}
			target:            {kind: "bounded-context", context: "log"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "DGV fornece serviços de verificação de integridade e governança de dados; LOG conforma com o protocolo."
			rationale:         "LOG não traduz — adota diretamente os padrões de integridade e verificação de DGV. Conformist por design: custo de ACL sem benefício."
			communication: {type: "sync"}
			queries: ["QueryEvidenceIntegrity"]
		},
		{
			code:              "dgv-to-dlv"
			source:            {kind: "bounded-context", context: "dgv"}
			target:            {kind: "bounded-context", context: "dlv"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service"
			downstreamPattern: "conformist"
			description:       "DGV fornece verificação criptográfica de integridade; DLV conforma para garantir que evidência não foi adulterada."
			rationale:         "DLV depende de DGV para integridade criptográfica sem tradução — conformist é o padrão correto para primitiva de verificação."
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
			rationale:         "Relação simétrica — ambos influenciam mutuamente. NGR não é upstream de NPM nem vice-versa; co-evoluem."
			communication: {type: "async"}
			events: ["NetworkGrowthTargetDefined", "NetworkParticipantOnboarded"]
		},

		// --- G. Contract Management (2) ---
		{
			code:              "ctr-to-scf"
			source:            {kind: "bounded-context", context: "ctr"}
			target:            {kind: "bounded-context", context: "scf"}
			direction:         "upstream-downstream"
			upstreamPattern:   "open-host-service-published-language"
			downstreamPattern: "anti-corruption-layer"
			publishedLanguage: "Contract & Terms canonical model"
			description:       "CTR expõe termos contratuais via published language; SCF consome para validar elegibilidade e condições de antecipação."
			rationale:         "Operação de SCF depende de termos contratuais. SCF traduz termos para linguagem de financiamento via ACL."
			communication: {type: "sync"}
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
			description:       "CTR expõe termos e cláusulas via published language; DRC consome para avaliar disputas contra termos formalizados."
			rationale:         "Resolução de disputa referencia termos contratuais como base. DRC traduz para linguagem de disputa via ACL."
			communication: {type: "sync"}
			queries: ["QueryContractTerms", "QueryContractClauses"]
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
	]

	// ==============================
	// HOOKS DE UNIFICAÇÃO
	// ==============================

	expectedContexts: [
		"ato", "bdg", "bkr", "cmt", "ctr",
		"dgv", "dlv", "drc", "fce", "idn",
		"inv", "log", "ngr", "nim", "npm",
		"ntf", "obs", "plt", "rew", "scf", "str",
	]

	declaredFlows: [
		"commitment-lifecycle",
	]

	// ==============================
	// LIMITAÇÕES E PREMISSAS
	// ==============================

	knownLimitations: [
		"v1 modela relações 1:1 entre BC e subdomínio — eventual reagrupamento exigirá revisão completa do mapa.",
		"BCs de infraestrutura (idn, ntf, str, plt, obs) não têm relações individuais modeladas — são consumidos cross-cutting por todos os BCs de domínio como primitivas de infraestrutura.",
		"Relações modelam integrações de domínio entre BCs — integrações técnicas (health checks, service discovery, logging) estão fora do escopo.",
		"Partnership NGR↔NPM é a única relação simétrica. Eventual necessidade de shared kernel entre outros BCs exigirá revisão.",
		"Nomes de eventos, commands e queries seguem convenção {QualifiedEntity}{PastParticiple}/{Verb}{QualifiedEntity}/Query{Entity}{Aspect} — nomes canônicos podem ser refinados nos canvas de cada BC.",
		"domainLevelTransversals não modelados nesta versão — definição de shared kernels de domínio requer análise dos canvas de cada BC, que ainda não existem.",
	]

	assumptions: [
		"Mapeamento 1:1 entre subdomínios e BCs é válido para o estágio atual da Mesh. Cada subdomínio foi definido com precisão de BC (linguagem, invariantes, razão de existir próprias) pela análise de 19 lenses.",
		"BCs de infraestrutura (idn, ntf, str, plt, obs) são consumidos como primitivas técnicas por todos os BCs de domínio. Modelar cada relação individual adicionaria ruído sem valor semântico. A ausência de relações explícitas não significa ausência de dependência — significa que a dependência é uniforme e cross-cutting.",
		"As relações modeladas refletem o Wave 0 da Mesh. Evolução da rede pode introduzir novas relações ou alterar padrões existentes.",
		"Padrões conformist (ATO←INV, ATO←FCE, ATO←SCF, LOG←DGV, DLV←DGV) refletem decisão consciente: o custo de ACL não se justifica quando a linguagem downstream é extensão direta da upstream.",
	]

	rationale: """
		Context map derivado da análise de 19 lenses sobre 21 subdomínios
		com 4 rounds de red team na topologia e 4 rounds de red team na
		instância. Mapeamento 1:1 BC↔subdomínio por análise que confirmou
		que cada subdomínio tem linguagem, invariantes e razão de existir
		distintas. 31 relações cobrem: spine do commitment lifecycle (5),
		cadeia de evidência (3), risco e inteligência (8), produtos
		financeiros e execução (5), fiscal e contábil (3), crescimento
		de rede (1), gestão contratual (2) e disputas (4). 5 BCs de
		infraestrutura são consumidos cross-cutting sem relações
		individuais. 2 pares de feedback loops diretos capturados (4
		relações com feedbackLoop): fce↔rew (pagamento↔risco) e cmt↔drc
		(compromisso↔disputa). Loop indireto cmt→bdg→dlv→rew→cmt
		documentado em rationale de rew-to-cmt. Classificação estratégica
		completa: subdomainType, wardleyEvolution e domainAgentSpec
		preenchidos para todos os 21 BCs. Padrões de integração seguem
		DDD: OHS/ACL como default, OHS-PL/ACL para contexts com ontologia
		formal publicada (CTR, NIM, REW), conformist onde linguagem
		downstream é extensão direta da upstream (ATO, LOG, DLV←DGV),
		partnership para relação simétrica (NGR↔NPM).
		"""
}
