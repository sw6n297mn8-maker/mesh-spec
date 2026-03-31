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

	// Relationships, hooks, limitations e rationale serão adicionados no próximo commit.
	relationships: []

	rationale: """
		Context map derivado da análise de 19 lenses sobre 21 subdomínios
		com 4 rounds de red team na topologia e 4 rounds de red team na
		instância. Mapeamento 1:1 BC↔subdomínio por análise que confirmou
		que cada subdomínio tem linguagem, invariantes e razão de existir
		distintas. Arquivo parcial — relationships serão adicionados no
		próximo commit.
		"""
}
