package scf

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Supply Chain Finance.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// SCF é o BC supporting que estrutura e oferta produtos financeiros sobre
// recebíveis verificados (antecipação, reverse factoring, dynamic discounting,
// capital de giro) e prepara portfólios para securitização. É o REVENUE
// SURFACE da tese: captura o spread da ativação (dp-02), enquanto o moat vive
// upstream (lastro mech-evidence via DLV/INV + pricing mech-network via REW).
//
// Terceira aplicação de P13/adr-125 (N=3), segunda em section-by-section. A
// derivação de fronteira (3 testes + remoção + classificação das 6 arestas)
// NÃO materializa campo no canvas (schema #Canvas é struct fechada — Opção i);
// vive canonicamente em adr-131. Naming/shape de rew-to-scf reconciliado em
// adr-130 (espelho adr-126). 6 arestas, todas Tier 1 unidirecionais acíclicas
// (0 ciclos) — SCF é folha downstream do grafo financeiro.

canvas: artifact_schemas.#Canvas & {
	code: "scf"
	name: "Supply Chain Finance"

	purpose: """
		Estruturar e ofertar produtos financeiros sobre recebíveis operacionais
		verificados — antecipação de recebíveis, reverse factoring, dynamic
		discounting, capital de giro — e preparar portfólios para distribuição a
		investidores (elegibilidade para veículos de securitização). SCF é owner
		da lógica de produto financeiro e dos critérios de elegibilidade de
		carteira: compõe o lastro verificado (ReceivableMaterialized de INV,
		ancorado em evidência via DLV), a decisão de risco (REW) e os termos
		contratuais (CTR) numa decisão de originação de produto que nenhum outro
		BC detém.

		Existe como unidade SEPARADA porque a linguagem de produto financeiro e
		de elegibilidade para securitização é distinta de: materialização do
		recebível (INV), modelagem de risco (REW), execução de pagamento (FCE),
		lifecycle do compromisso (CMT), formalização contratual (CTR) e
		instrumentos de proteção (INS). SCF ESTRUTURA e OFERTA; não materializa o
		ativo (INV), não modela risco (REW), não executa pagamento (FCE) e não
		administra veículo de securitização (delegado a administrador fiduciário
		externo regulado pela CVM — a Mesh não é administradora de FIDC).
		Crucialmente: a estruturação de produto NÃO garante disponibilidade de
		funding nem elegibilidade da carteira para securitização — SCF prepara e
		define critérios, não promete capital nem aprovação regulatória.

		Sem SCF como unidade canônica, a lógica de produto financeiro e de
		elegibilidade ficaria distribuída entre CMT+DLV+INV (originação do
		lastro), REW (pricing) e FCE (execução) sem owner — e o lastro
		verificado (mech-evidence) não se converteria em produto ativável,
		quebrando a ativação de volume sob governança (dp-02) que a tese
		persegue.
		"""

	ubiquitousLanguageRef: "contexts/scf/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "revenue-generator"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque produtos de supply chain finance (antecipação,
			reverse factoring, dynamic discounting) e securitização de recebíveis
			são padrões EXÓGENOS do mercado financeiro — não proprietários à Mesh
			(scf.cue:123-133). O diferencial proprietário (lastro em mech-evidence
			via DLV/INV + pricing mech-network via REW) vive UPSTREAM; SCF combina
			diferenciais alheios em produtos que o mercado já conhece. Supporting,
			não core: a inovação está no lastro (INV/DLV) e no pricing (REW), não
			no produto que o SCF estrutura.

			revenue-generator (decisão consciente — ver alternativa rejeitada):
			SCF é o BC onde o volume sob governança se ATIVA em receita. dp-02
			define o critério econômico da Mesh como "taxa de ativação do volume
			em serviços concretos (antecipação, netting, futuros)" com "spread que
			comprime vs mercado" — e a antecipação/factoring que o SCF estrutura é
			exatamente o serviço que monetiza o spread (domain-definition:299-300,
			475). SCF é o ponto de conversão lastro-verificado → produto-com-spread;
			é onde a Mesh GERA receita, não apenas viabiliza a de outro BC. O
			boundary "estruturação ≠ garantia de funding" (scf.cue:22-23) não nega
			a geração de receita: SCF gera a receita do PRODUTO (spread de
			antecipação) sem PROMETER a disponibilidade de capital de terceiros —
			dimensões distintas (produto monetizado vs funding de balanço). A
			ortogonalidade supporting↔revenue-generator é a estrutura econômica da
			tese: produto commodity + moat upstream + SCF como revenue surface; o
			spread comprime vs mercado porque o lastro é VERIFICÁVEL, não porque o
			produto é único.

			product na evolução Wardley (cross-checked com registry): antecipação/
			factoring/desconto dinâmico são produtos financeiros amplamente
			estabelecidos no mercado (décadas de prática); a Mesh adapta o padrão
			ao lastro verificável, mas o produto em si é product-stage, não custom
			— diferente do FCE (custom: orquestração evidência→guard→settlement
			sob medida).
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Produtos de SCF (antecipação, reverse factoring, dynamic discounting,
			capital de giro, securitização) são padrões EXÓGENOS do mercado global
			de Supply Chain Finance, aplicáveis a qualquer cadeia produtiva B2B com
			recebíveis rastreáveis — nenhum carrega vocabulário, mecanismo ou
			premissa construção-específica (scf.cue:93-120). O binding
			construção-específico da Mesh, se existir no plano financeiro, vive
			upstream em DLV (evidência), INV (recebível) e REW (pricing), não em
			SCF. As âncoras regulatórias (FIDC, CVM, performance bonds) são
			jurisdicionais (Brasil), não setoriais — FIDC securitiza recebíveis de
			qualquer vertical. SCF é orquestrador de produtos financeiros
			padronizados.
			"""
	}

	domainRoles: {
		primary: "specification"
		secondary: ["analysis"]
		rationale: """
			Primary specification: SCF DEFINE produtos financeiros e critérios de
			elegibilidade — parâmetros de antecipação/factoring/desconto dinâmico,
			regras de composição de carteira, critérios de elegibilidade para
			securitização. O enum #Archetype não tem "orchestrator"/"product"; o
			papel central do SCF é SPECIFICATION (especifica o produto e seus
			critérios), não execution: o SCF não move dinheiro (FCE) nem
			materializa ativo (INV) — ele ESPECIFICA o produto que se aplica sobre
			o ativo. Inversão deliberada vs FCE (execution): FCE executa um produto
			já especificado; SCF especifica o produto antes. Secondary analysis:
			SCF GENUINAMENTE avalia elegibilidade — pondera lastro
			(ReceivableMaterialized/INV) contra risco (REW), termos (CTR) e
			cobertura (INS) para decidir se um recebível é antecipável e se uma
			carteira é elegível para distribuição. A dimensão analítica
			(elegibilidade contextual) é o complemento ortogonal da especificação
			de produto.
			"""
	}

	capabilities: {
		operational: [{
			description: """
				Estruturação de produto financeiro sobre recebível verificado:
				especifica antecipação, reverse factoring, dynamic discounting e
				capital de giro com parâmetros (taxa, prazo, condições) aplicados
				sobre ReceivableMaterialized (INV) sob decisão de risco (REW) e
				termos (CTR). Originação produz ReceivableAdvanceOriginated;
				fechamento produz ReceivableAdvanceSettled.
				"""
			rationale: """
				Capability core local (sem cc-XX) — o subdomain scf.cue não declara
				capabilityRefs; é a função que define o SCF. NÃO move dinheiro (FCE
				executa via PaymentSettled), NÃO materializa o recebível (INV), NÃO
				modela o risco (REW): especifica o produto sobre inputs alheios.
				"""
		}, {
			description: """
				Composição de elegibilidade: combina lastro verificado
				(ReceivableMaterialized de INV, ancorado em evidência via DLV),
				decisão de risco (RiskScoreEmitted/EligibilityEmitted de REW),
				termos contratuais (QueryContractTerms de CTR) e estado de cobertura
				(INS) numa decisão de originação de produto que nenhum BC isolado
				detém. Elegibilidade é função contextual: recebível X é antecipável
				sob produto Y, política V, no tempo T.
				"""
			rationale: """
				Capability local ancorada na invariante própria do SCF
				(boundary-derivation, teste b): a composição multi-fonte de
				elegibilidade é o que distingue o SCF de um catálogo de produtos
				genérico. Consome decisões de REW (não as produz) e termos de CTR
				(não os formaliza).
				"""
		}, {
			capabilityRef: "cc-05"
			description: """
				Preparação de portfólio para distribuição: agrupa recebíveis
				antecipados em carteiras e define critérios de elegibilidade para
				veículos de securitização, expondo acesso programático ao portfólio
				com evidência verificável e auditabilidade contínua. A estruturação
				jurídica do veículo (FIDC, CVM) é delegada a administrador
				fiduciário externo — SCF prepara e define critérios, não constitui
				nem administra o fundo.
				"""
			rationale: """
				cc-05 (acesso programático a portfólios de recebíveis com evidência
				verificável, domain-definition:518) — aplicado como ref canônico: é
				a capability desenhada exatamente para o SCF, com bearer sh-03
				(funding partner) e enabledBy mech-evidence. O lastro verificável
				(vs due diligence manual, ce-07) é o diferencial que torna a
				carteira atrativa. NÃO administra o veículo de securitização
				(ext-securitization-admin, openQuestion oq-scf-1).
				"""
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:          "event-consumer"
			sourceContext: "inv"
			event:         "ReceivableMaterialized"
			reaction: """
				Materializa o lastro: ReceivableMaterialized é o ativo verificado
				(ancorado em evidência via DLV) sobre o qual o SCF estrutura
				produtos de antecipação. Sem recebível materializado, não há
				operação de SCF.
				"""
			description: "Lastro primário. Nome coincide context-map↔INV (inv:311-312)."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "RiskScoreEmitted"
			reaction: """
				Atualiza cache de score do participante para precificação e
				elegibilidade de produto. SCF consome via ACL (rew-to-scf, published
				language 'Risk score and eligibility model').
				"""
			description: "Reconciliado: context-map dizia CounterpartyRiskScoreUpdated; REW publica RiskScoreEmitted (rew:332). adr-130."
		}, {
			type:          "event-consumer"
			sourceContext: "rew"
			event:         "EligibilityEmitted"
			reaction: """
				Atualiza decisão de elegibilidade (eligible/conditionally-eligible/
				ineligible) que gateia a originação de antecipação. Validação
				crítica no momento da originação usa sync query (QueryEligibility).
				"""
			description: "Reconciliado: context-map dizia CreditEligibilityDecided; REW publica EligibilityEmitted (rew:338-340 'SCF antecipa?'). adr-130."
		}, {
			type:          "event-consumer"
			sourceContext: "fce"
			event:         "PaymentSettled"
			reaction: """
				Sinal de liquidação do pagamento original: SCF reconcilia e fecha a
				operação de antecipação (ReceivableAdvanceSettled) quando o pagamento
				que lastreia a antecipação é liquidado.
				"""
			description: "Per fce-to-scf. Coincide context-map↔FCE (fce:290-291)."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractTermsActivated"
			reaction: """
				Habilita referência a termos ativos na originação de produto
				financeiro — SCF valida elegibilidade contra termos vigentes.
				"""
			description: "Per ctr-to-scf. Coincide context-map↔CTR (ctr:172-173)."
		}, {
			type:          "event-consumer"
			sourceContext: "ctr"
			event:         "ContractTermsSuperseded"
			reaction: """
				Reavalia operações de antecipação em curso cujo embasamento
				referencia termos superseded — mudança de termos pode afetar
				condições de produto já originado.
				"""
			description: "Per ctr-to-scf. Coincide context-map↔CTR (ctr:178-179)."
		}, {
			type:          "event-consumer"
			sourceContext: "ins"
			event:         "CoverageActivated"
			reaction: """
				Estado de cobertura securitária ativa melhora o perfil do ativo para
				securitização e pode habilitar produtos que exigem garantia.
				Cobertura é input de elegibilidade, não produto do SCF.
				"""
			description: "Per ins-to-scf. NOTA: canvas INS ainda não scaffolded — forward-ref (oq-scf-2); context-map é autoridade."
		}, {
			type:          "event-consumer"
			sourceContext: "ins"
			event:         "CoverageLapsed"
			reaction: """
				Cobertura expirada degrada o perfil do ativo — SCF reavalia
				elegibilidade de carteira que dependia da garantia.
				"""
			description: "Per ins-to-scf. Forward-ref (INS não scaffolded, oq-scf-2)."
		}, {
			type:          "event-consumer"
			sourceContext: "ins"
			event:         "ClaimFiled"
			reaction: """
				Sinistro acionado sobre instrumento de proteção — SCF marca o ativo
				afetado e reavalia a carteira que o inclui.
				"""
			description: "Per ins-to-scf. Forward-ref (INS não scaffolded, oq-scf-2)."
		}, {
			type:       "query-surface"
			query:      "QueryPortfolioEligibility"
			returnType: "PortfolioEligibilityView (portfolioId + receivableRefs[] + eligibilityCriteria + eligibilityStatus + evidenceAnchors[] + assessedAt)"
			description: """
				Superfície síncrona exposta pelo SCF para acesso programático ao
				portfólio com evidência verificável (cc-05). Consumer é sh-03
				(funding partner), stakeholder EXTERNO — não um BC interno
				(precedente: DLV QueryEvidenceLedger). sh-03 avalia a carteira sem
				due diligence manual (ce-07). Read model; expõe critérios de
				elegibilidade e âncoras de evidência, não o motor de decisão.
				"""
		}]

		outbound: [{
			type: "event-publisher"
			trigger: """
				Originação de operação de antecipação aprovada (lastro verificado +
				elegibilidade satisfeita + termos válidos) — produto financeiro
				estruturado e ofertado.
				"""
			event:     "ReceivableAdvanceOriginated"
			consumers: ["ato", "fce"]
			description: """
				Fato canônico de originação de produto. FCE consome para EXECUTAR o
				disbursement ao fornecedor (aresta scf-to-fce, ciclo
				bidirectional-orchestration, adr-137) — o canal de execução é sempre o
				FCE. ATO conforma para registrar consequência fiscal/contábil
				(scf-to-ato, conformist). NOTA: canvas ATO ainda não scaffolded —
				forward-ref (oq-scf-3); context-map é autoridade.
				"""
		}, {
			type: "event-publisher"
			trigger: """
				Fechamento da operação de antecipação: o pagamento original que
				lastreia a antecipação foi liquidado (PaymentSettled de FCE
				consumido), encerrando o ciclo do produto.
				"""
			event:     "ReceivableAdvanceSettled"
			consumers: ["ato"]
			description: "Fechamento canônico. ATO conforma (conformist). Forward-ref (ATO não scaffolded, oq-scf-3)."
		}, {
			type:          "query-dependency"
			targetContext: "rew"
			query:         "QueryRiskScore"
			purpose: """
				Validação crítica de score no momento da originação, complementar ao
				cache event-driven (RiskScoreEmitted).
				"""
			description: "Reconciliado: queries adicionadas a rew-to-scf (async→hybrid, adr-130). REW expõe QueryRiskScore nomeando SCF (rew:316)."
		}, {
			type:          "query-dependency"
			targetContext: "rew"
			query:         "QueryEligibility"
			purpose: """
				Validação de elegibilidade contextual (recebível X antecipável sob
				produto Y, política V, tempo T) no gate de originação.
				"""
			description: "Reconciliado (shape change rew-to-scf, adr-130). REW expõe QueryEligibility nomeando SCF (rew:321 'Consumed primarily by SCF')."
		}, {
			type:          "query-dependency"
			targetContext: "ctr"
			query:         "QueryContractTerms"
			purpose: """
				Consultar termos contratuais vigentes (version-pinned) na originação
				— validar elegibilidade do produto contra termos.
				"""
			description: "Per ctr-to-scf (queries). Coincide context-map↔CTR (ctr:160,172-173 SCF consumer)."
		}, {
			type:          "query-dependency"
			targetContext: "fce"
			query:         "QueryPaymentSettlementStatus"
			purpose: """
				Consultar estado de liquidação do pagamento original para reconciliar
				e fechar operações de antecipação.
				"""
			description: "Per fce-to-scf (queries). Coincide context-map↔FCE (fce:275 QueryPaymentSettlementStatus exposta a scf)."
		}]

		rationale: """
			Inbound event-driven (sem command-handler): SCF é acionado por fatos
			upstream (recebível, risco, liquidação, termos, cobertura), não
			comandado. Inbound: 9 event-consumers (inv ×1 lastro; rew ×2
			score+elegibilidade; fce ×1 liquidação; ctr ×2 termos; ins ×3 cobertura)
			+ 1 query-surface exposta (QueryPortfolioEligibility, cc-05, consumer
			sh-03 externo). Outbound: 2 event-publishers (ReceivableAdvanceOriginated/
			Settled → ato, conformist) + 4 query-dependencies (rew ×2 validação
			real-time; ctr ×1 termos; fce ×1 liquidação). SCF é folha downstream do
			grafo financeiro: consome 5 upstreams, publica para 1 (ato). 0 ciclos —
			nenhuma aresta reversa. TODAS as relations cross-checked com context-map
			APÓS reconciliação do rew-to-scf (naming+shape, adr-130). Forward-refs
			declarados: ins-to-scf (3 events) e scf-to-ato (2 events) referenciam
			BCs ainda não scaffolded (oq-scf-2/3); ext-securitization-admin
			(securitização) NÃO tem aresta no context-map — openQuestion oq-scf-1,
			não modelada aqui.
			"""
	}

	businessDecisions: [{
		id: "bd-advance-requires-verified-receivable"
		decision: """
			Toda operação de antecipação exige um ReceivableMaterialized (INV)
			ancorado em evidência verificável (mech-evidence via DLV) como lastro.
			Sem recebível verificado, não há produto financeiro originado — SCF não
			antecipa contra promessa, só contra ativo comprovado.
			"""
		rationale: """
			Instância de P11 (dinheiro só se move quando a operação comprova) na
			camada de produto financeiro: o lastro verificável é o diferencial
			proprietário da Mesh (scf.cue:123-133 'inovação é no lastro, não no
			produto'). Sem essa âncora, SCF seria factoring genérico sobre recebível
			auto-reportado — vetor de fraude e o que a tese existe para eliminar.
			"""
		consequences: """
			Originação é gateada por ReceivableMaterialized consumido de INV; a
			antecipação carrega evidenceAnchors rastreáveis até DLV. Funding partner
			(sh-03) verifica o lastro programaticamente (cc-05, ce-07) em vez de due
			diligence manual. Recebível sem materialização verificada não entra em
			portfólio.
			"""
	}, {
		id: "bd-eligibility-multi-source-composition"
		decision: """
			A decisão de originação compõe quatro fontes que nenhum BC isolado
			detém: lastro verificado (ReceivableMaterialized/INV), decisão de risco
			(RiskScoreEmitted/EligibilityEmitted/REW), termos contratuais
			(QueryContractTerms/CTR) e estado de cobertura (INS). Elegibilidade é
			função contextual: recebível X é antecipável sob produto Y, política V,
			no tempo T.
			"""
		rationale: """
			A invariante PRÓPRIA do SCF (boundary-derivation, teste b): a composição
			multi-fonte é o que distingue o SCF de um catálogo de produtos genérico
			e o torna owner canônico da decisão de produto. Cada fonte é consumida
			(não produzida): risco é de REW, termos de CTR, lastro de INV, cobertura
			de INS.
			"""
		consequences: """
			Originação requer as quatro fontes consistentes; ausência ou staleness
			de qualquer uma bloqueia ou condiciona o produto. Elegibilidade carrega
			o snapshot das fontes (policyVersion de REW, termsVersion de CTR) para
			reprodutibilidade. Mudança em qualquer fonte upstream reavalia operações
			em curso.
			"""
	}, {
		id: "bd-structures-not-executes"
		decision: """
			Duas dimensões ORTOGONAIS, não confundir:
			(a) CANAL de execução — é SEMPRE o FCE. O SCF ESPECIFICA e OFERTA o produto
			(parâmetros de antecipação, taxa, prazo, condições) e emite
			ReceivableAdvanceOriginated; o SCF nunca move dinheiro nem toca rails.
			Quando há disbursement, o FCE o executa (aresta scf→fce, ciclo
			bidirectional-orchestration; adr-137); a liquidação do recebível subjacente
			também é do FCE (PaymentSettled fecha a antecipação).
			(b) FONTE do capital — é VARIÁVEL: próprio (quando houver receita +
			autorização BC) ou parceiro (para diluir risco) = dois modos de funding. A
			escolha da fonte, o regime de risco por modo e o impacto no PrePaymentGuard
			do FCE são decisão DEFERIDA (def-036). O canal não muda com a fonte.
			"""
		rationale: """
			Anti-FCE boundary (scf.cue:49-55): separar ESPECIFICAÇÃO de produto (SCF) da
			EXECUÇÃO de pagamento (FCE) permite novos produtos financeiros sem alterar a
			orquestração de pagamentos. Espelho de fce bd-economic-authority-not-rails
			(FCE decide/executa pagamento; não especifica produto). A separação canal
			(estável, FCE) × fonte (variável, próprio/parceiro) preserva essa fronteira:
			a fonte é dimensão do produto, não um segundo caminho de execução (P0 — um
			executor canônico de movimento de dinheiro). adr-137 modela a aresta scf→fce
			que antes faltava (contradição pf-scf-1); o regime de fonte fica em def-036.
			"""
		consequences: """
			SCF não tem aggregate de pagamento; depende do FCE para a execução efetiva
			(disbursement do advance + liquidação do recebível via PaymentSettled). A
			aresta scf→fce dá canal ao que antes era só prosa ("o que o FCE executará
			downstream"). Adicionar produto financeiro é mudança no SCF, não no FCE.
			Mudar a FONTE de capital (próprio↔parceiro) NÃO muda o canal nem cria
			aggregate de pagamento no SCF — só o regime de risco/guard (def-036).
			"""
	}, {
		id: "bd-consumes-risk-not-models"
		decision: """
			SCF CONSOME decisões de risco de REW (RiskScoreEmitted, EligibilityEmitted,
			QueryRiskScore/QueryEligibility) para precificar e elegibilizar produto;
			NÃO modela risco nem produz score. O pricing do produto deriva da decisão
			de risco alheia, não de modelo próprio.
			"""
		rationale: """
			Anti-REW boundary (scf.cue:57-62): acoplar originação de produto à
			modelagem de risco fundiria dois corpos de conhecimento com stakeholders
			distintos. O diferencial de pricing (mech-network via REW) vive upstream;
			SCF aplica, não cria. dp-04: a precificação é determinística sobre a
			decisão de risco consumida, não estocástica interna.
			"""
		consequences: """
			SCF não tem modelo de risco; mudança de política de risco é mudança no
			REW (consumida via RiskScoreEmitted/EligibilityEmitted). O pricing do
			produto referencia a policyVersion de REW que o embasou (rastreabilidade).
			Decisão de elegibilidade contraditória com REW é drift detectável.
			"""
	}, {
		id: "bd-structuring-not-funding-guarantee"
		decision: """
			A estruturação de produto pelo SCF NÃO garante disponibilidade de funding
			nem elegibilidade da carteira para securitização. SCF prepara o produto e
			define critérios; não promete o capital de terceiros nem a aprovação do
			veículo de securitização.
			"""
		rationale: """
			Invariante de honestidade do subdomain (scf.cue:22-23): estruturar é
			distinto de fondar. SCF gera a receita do produto (spread, businessRole
			revenue-generator) sem assumir o risco de balanço de prover capital — são
			dimensões econômicas distintas. Confundi-las daria ao SCF uma promessa que
			ele não pode honrar (funding de terceiros) e exposição regulatória indevida.
			Cristaliza a ortogonalidade revenue-generator (receita do produto vs
			funding de balanço).
			"""
		consequences: """
			Produto estruturado pode não encontrar funding; carteira preparada pode
			não ser aceita pelo veículo. SCF declara critérios e disponibilidade, não
			garantia. O matching com capital (funding partner sh-03) e a aprovação do
			veículo (administrador externo) são eventos separados, não consequências
			automáticas da estruturação.
			"""
	}, {
		id: "bd-prepares-portfolio-not-administers-fund"
		decision: """
			SCF prepara carteiras e define critérios de elegibilidade para
			securitização (cc-05); a constituição e administração do veículo (FIDC,
			regulação CVM, administração fiduciária, gestão de portfólio de
			investimentos) é delegada a administrador fiduciário externo. A Mesh não é
			administradora de FIDC nem gestora regulada pela CVM.
			"""
		rationale: """
			Anti-ext boundary (scf.cue:85-90): a fronteira com ext-securitization-admin
			é constraint regulatório (nível 1 — integridade legal). SCF não pode
			assumir função de administrador fiduciário sem registro CVM. Preparar ≠
			administrar: SCF produz a carteira elegível e o acesso programático com
			evidência (cc-05); o veículo é externo.
			"""
		consequences: """
			SCF expõe portfólio + critérios (QueryPortfolioEligibility) ao
			administrador/funding partner externo; não constitui nem gere o fundo. A
			relação scf→ext-securitization-admin não é modelada no context-map
			(openQuestion oq-scf-1 — fronteira externa merece pattern uniforme, não
			one-off; precedente ins-to-ext-insurers). Constraint regulatório
			inviolável.
			"""
	}]

	stakeholders: [{
		stakeholderRef: "sh-03"
		roleInContext:  "Funding partner — consome a carteira preparada e fonde o capital das operações de antecipação."
		impactDescription: """
			sh-03 é o stakeholder central do SCF como revenue surface: consome
			QueryPortfolioEligibility (cc-05) para avaliar a carteira com evidência
			verificável e fondar antecipações. O lastro programático (evidenceAnchors
			até DLV) substitui due diligence manual (ce-07) — reduz o prêmio de risco
			exigido e viabiliza funding em escala. Sem SCF estruturando produto com
			lastro verificável, sh-03 não tem carteira auditável programaticamente
			para fondar.
			"""
		rationale: "sh-03 fornece o capital — o input mais crítico (ce-07 rationale); SCF é o BC que produz a carteira elegível com lastro verificável que torna o funding atrativo."
	}, {
		stakeholderRef: "sh-02"
		roleInContext:  "Fornecedor — antecipa recebível verificado, obtém capital de giro antes do ciclo normal."
		impactDescription: """
			Fornecedor é o beneficiário primário da antecipação: o
			ReceivableMaterialized (lastro de sua entrega verificada) vira capital de
			giro imediato via produto SCF, eliminando o ciclo de 60-120 dias (ce-06).
			Sem SCF, o recebível verificado permanece preso ao ciclo tradicional — o
			fornecedor financia a cadeia involuntariamente.
			"""
		rationale: "sh-02 carrega a dor mais aguda (ce-06 — alongamento do ciclo); SCF é onde o recebível verificado se converte em capital de giro antecipado."
	}, {
		stakeholderRef: "sh-01"
		roleInContext:  "Construtora — contraparte em reverse factoring e dynamic discounting; pagadora do recebível antecipado."
		impactDescription: """
			Construtora participa via reverse factoring (estende prazo de pagamento
			usando o crédito da Mesh sobre seus fornecedores) e dynamic discounting
			(desconto por pagamento antecipado). SCF estrutura o produto que alinha o
			interesse de prazo da construtora com a necessidade de liquidez do
			fornecedor, ambos lastreados em recebível verificado.
			"""
		rationale: "sh-01 é o nó central da cadeia; os produtos de SCF (reverse factoring, dynamic discounting) operam sobre seus compromissos — afetam diretamente seu fluxo de caixa e relação com fornecedores."
	}, {
		stakeholderRef: "sh-04"
		roleInContext:  "Regulador — securitização e operação de crédito têm dimensão prudencial (Bacen/SCD) e de mercado de capitais (CVM)."
		impactDescription: """
			Bacen regula a operação de crédito da SCD; a preparação de carteira para
			securitização toca a fronteira CVM (FIDC). SCF mantém a disciplina de que
			prepara critérios mas NÃO administra veículo
			(bd-prepares-portfolio-not-administers-fund) — a constituição do FIDC é de
			administrador fiduciário externo regulado. Originação de produto carrega
			trail auditável (evidenceAnchors) para reporting prudencial.
			"""
		rationale: "Operar produto financeiro sob SCD exige conformidade prudencial; a fronteira com securitização (CVM) é constraint inviolável (nível 1) — SCF é o BC onde essa fronteira regulatória é enforçada por design."
	}]

	costsEliminated: [{
		costRef: "ce-07"
		contribution: """
			SCF prepara carteira com acesso programático e evidência verificável
			(cc-05, QueryPortfolioEligibility): o funding partner (sh-03) verifica a
			qualidade do lastro programaticamente — evidenceAnchors rastreáveis até
			DLV substituem auditoria manual de cada recebível. Encaixe DIRETO (não
			espelho genérico): ce-07 bearer é literalmente sh-03, mechanismRef
			mech-evidence, e a thesisConnection descreve exatamente a capability cc-05
			do SCF.
			"""
		rationale: "ce-07 (due diligence manual, mech-evidence) é eliminável quando a carteira é verificável programaticamente — SCF é o BC que produz a carteira com lastro auditável que torna isso possível."
	}, {
		costRef: "ce-06"
		contribution: """
			SCF estrutura a antecipação que converte ReceivableMaterialized (recebível
			verificado) em capital de giro imediato para o fornecedor (sh-02),
			eliminando o ciclo de 60-120 dias que o obriga a financiar a cadeia
			involuntariamente. A antecipação só é possível porque o lastro é verificado
			(bd-advance-requires-verified-receivable).
			"""
		rationale: "ce-06 (alongamento do ciclo do fornecedor, mech-scd) é o driver primário de adoção; SCF é a etapa de estruturação de produto que realiza o ciclo curto sobre recebível verificado."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-06"
			participantType:           "Classe de actor adversarial canonical (R4+++) com intenção primária de extrair capital via fraude de lastro."
			desiredBehavior:           "Antecipar apenas recebíveis genuinamente verificados; submeter carteiras cujo lastro corresponde a entregas reais."
			correctOperationIncentive: "Antecipação de recebível verificado é rápida e barata (lastro programático reduz prêmio de risco); fraude de lastro leva a detecção via cadeia de evidência + degradação de reputação cross-network."
			manipulationVector: """
				Forjar lastro para antecipar sem ativo real (recebível fictício), OU
				gaming de elegibilidade (manipular inputs de risco/termos para originar
				produto que não qualificaria), OU inflar carteira com recebíveis de
				baixa qualidade para securitização (externalizar risco para funding
				partner/investidor).
				"""
			manipulationCost: """
				bd-advance-requires-verified-receivable: sem ReceivableMaterialized
				ancorado em evidência (mech-evidence via DLV), não há antecipação —
				recebível fictício não tem lastro verificável. bd-eligibility-multi-
				source-composition: a composição de 4 fontes (INV+REW+CTR+INS) torna
				inconsistência detectável (lastro sem risco aprovado, ou termos que não
				batem). evidenceAnchors rastreáveis até DLV + cc-05 audit tornam carteira
				inflada detectável por sh-03 programaticamente.
				"""
			vsBenefit: """
				Ganho de antecipar um recebível fictício é único e detectável; custo é
				forjar evidência criptográfica (inviável, mesma barreira do FCE
				as-fce-1) + detecção cross-BC + degradação de reputação +
				responsabilidade jurídica por fraude (dp-10). Inflar carteira para
				securitização tem custo agravado: o funding partner verifica
				programaticamente (ce-07) e o trail é regulatório (CVM).
				"""
			designResponse: """
				bd-advance-requires-verified-receivable (âncora P11/mech-evidence) +
				bd-eligibility-multi-source-composition (detecção por inconsistência
				cross-source) + cc-05 audit trail (verificação programática por sh-03) +
				evidenceAnchors até DLV. Fraude de lastro é não-progressiva por
				construção: sem recebível verificado, sem produto.
				"""
			rationale: "Mesh é AI-operated e SCF é revenue surface — o vetor de maior valor é fraude de lastro (extrair capital sem ativo). sh-06 canonical (REW WI-046); a defesa é a mesma âncora de evidência que torna o lastro o diferencial proprietário."
		}, {
			stakeholderRef:            "sh-03"
			participantType:           "Funding partner (instituição financeira) que consome carteira e fonde capital."
			desiredBehavior:           "Fondar representativamente a rede; financiar carteiras pela qualidade verificável do lastro, sem cherry-picking que degrade a função sistêmica de funding."
			correctOperationIncentive: "Verificação programática (ce-07) reduz custo de due diligence e prêmio de risco; participação balanceada preserva deal flow futuro e a qualidade da rede que torna o funding atrativo."
			manipulationVector: """
				Seleção adversa (cherry-picking): fondar apenas os recebíveis mais
				seguros (entregas de baixa contestabilidade, contrapartes premium) e
				rejeitar sistematicamente o resto, degradando a função de funding da rede
				e externalizando risco para outros financiadores ou para a Mesh.
				"""
			manipulationCost: """
				Padrão de cherry-picking é observável (ratio fondado/disponível por
				risk-tier via cc-05); SCF/REW podem ajustar condições de acesso ao funding
				partner com seleção adversa comprovada. Mesh como rede antifrágil: seleção
				adversa prolongada degrada acesso a deal flow futuro (elegibilidade
				revogável).
				"""
			vsBenefit: "Ganho de cherry-picking é portfólio de menor risco aparente; custo é degradação de acesso a deal flow (a rede observa o padrão) + perda da vantagem de custo (ce-07) que depende de participação representativa. Inviável a longo prazo."
			designResponse: "cc-05 expõe ratio de consumo por risk-tier (observável); QueryPortfolioEligibility carrega critérios transparentes; seleção adversa comprovada ajusta condições de acesso. Detecção via comportamento observável, não intenção."
			rationale: "sh-03 fornece capital e tem incentivo a externalizar risco via seleção adversa; a defesa é a observabilidade do padrão de consumo (cc-05) + elegibilidade revogável — paralelo ao vetor sh-03 do canvas INV."
		}]
		rationale: """
			Dois vetores: (a) adversário canonical (sh-06) que forja lastro ou infla
			carteira para extrair capital sem ativo real — contido pela âncora
			P11/mech-evidence (sem recebível verificado, sem antecipação) + composição
			multi-fonte (detecção por inconsistência) + verificação programática de
			sh-03; (b) funding partner (sh-03) que faz seleção adversa para
			externalizar risco — contido pela observabilidade do padrão de consumo
			(cc-05) + elegibilidade revogável. Em ambos, o custo de manipular excede o
			benefício por design (dp-08), e a defesa comum é o lastro verificável que é
			o próprio diferencial do SCF.
			"""
	}

	ownership: {
		domainAgentSpec: "contexts/scf/agents/scf-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "originate-advance-on-eligibility"
				description: "Originar operação de antecipação quando as 4 fontes estão consistentes e satisfeitas: ReceivableMaterialized verificado (INV) + elegibilidade aprovada (REW) + termos válidos (CTR) + cobertura coerente (INS), com produto/taxa/prazo dentro da policy declarada. Composição determinística da elegibilidade."
				rationale:   "P10/P11: originação dentro do envelope é composição determinística das 4 fontes (elegibilidade como função, não julgamento); o lastro verificado (P11) gateia. dp-02: ativação de volume autônoma é a operação central do revenue surface."
			}, {
				id:          "settle-advance-on-payment"
				description: "Fechar operação de antecipação (emitir ReceivableAdvanceSettled) quando PaymentSettled do FCE confirma a liquidação do pagamento original que lastreia a antecipação. Reconciliação determinística."
				rationale:   "Fechamento é função do fato upstream (PaymentSettled), não decisão econômica nova — determinístico (within-reconciliation). bd-structures-not-executes: SCF reconcilia sobre a execução do FCE."
			}, {
				id:          "reassess-portfolio-on-upstream-change"
				description: "Reavaliar elegibilidade de operações/carteiras em curso quando uma fonte upstream muda (ContractTermsSuperseded de CTR, CoverageLapsed de INS, EligibilityEmitted revisado de REW) — recomputar consistência das 4 fontes."
				rationale:   "Reavaliação é recomputação determinística da composição multi-fonte (bd-eligibility-multi-source-composition); não cria condição de produto nova. Inconsistência resultante escala (escalationCriteria)."
			}]
			supervisedDecisions: [{
				id:          "originate-with-nonstandard-terms"
				description: "Originar produto com condições não-padrão (taxa/prazo/estrutura fora da policy declarada) — exige confirmação humana sobre a condição econômica."
				rationale:   "Condição de produto fora da policy é decisão econômica com julgamento (precificação não-padrão); não é composição determinística. O agente recomenda, o humano decide a condição."
			}, {
				id:          "override-eligibility-on-stale-source"
				description: "Originar apesar de uma fonte stale/ambígua (e.g., elegibilidade REW desatualizada, termos CTR em transição) — NUNCA autônomo. Análogo ao override do PrePaymentGuard do FCE."
				rationale:   "Linha vermelha P10/P11: originar sem as 4 fontes consistentes é override de gate — julgamento humano, jamais autônomo. bd-eligibility-multi-source-composition exige consistência; o override é exceção supervisionada nominalmente atribuída ao supervisor."
			}, {
				id:          "prepare-portfolio-for-securitization"
				description: "Preparar carteira para distribuição a veículo de securitização e definir seus critérios de elegibilidade — exige confirmação humana por impacto regulatório (fronteira CVM/FIDC)."
				rationale:   "bd-prepares-portfolio-not-administers-fund: a preparação toca a fronteira regulatória de securitização (CVM) — constraint nível 1. Mesmo preparando (não administrando), a decisão de compor carteira para distribuição exige supervisão regulatória."
			}, {
				id:          "adjust-funding-partner-access"
				description: "Ajustar condições de acesso de um funding partner (sh-03) ao deal flow após seleção adversa comprovada — decisão sobre relacionamento com contraparte de capital."
				rationale:   "Vetor sh-03 da incentiveAnalysis (seleção adversa): ajustar acesso é decisão com impacto sobre a contraparte de funding e a função sistêmica da rede; exige julgamento humano, não auto-ajuste."
			}]
			escalationCriteria: [{
				id:        "lastro-fraud-suspected"
				condition: "Indício de fraude de lastro: tentativa de originar sem ReceivableMaterialized verificado, OU inconsistência entre o lastro reivindicado e a cadeia de evidência (evidenceAnchors não resolvem até DLV) — vetor sh-06."
				action:    "Bloquear originação (fail-safe: sem lastro verificado, sem produto); escalar founder/compliance + security review; congelar operações do proponente afetado até decisão."
				rationale: "Fraude de lastro é o vetor adversarial de maior valor no revenue surface (sh-06); o bloqueio é fail-safe determinístico (P11), mas o padrão exige análise humana de origem (bug vs ataque)."
			}, {
				id:        "funding-adverse-selection-detected"
				condition: "Padrão de seleção adversa de funding partner comprovado: ratio fondado/disponível por risk-tier (via cc-05) revela cherry-picking sistemático que degrada a função de funding da rede — vetor sh-03."
				action:    "Escalar founder para decisão sobre ajuste de condições de acesso do partner; pausar expansão de deal flow ao partner afetado até revisão."
				rationale: "Seleção adversa (sh-03) externaliza risco e degrada a rede; detecção é observável (cc-05), mas a consequência (ajustar acesso a contraparte de capital) exige decisão humana."
			}, {
				id:        "cross-source-inconsistency-persistent"
				condition: "Inconsistência persistente entre as 4 fontes de elegibilidade (lastro INV sem risco REW aprovado, termos CTR que não batem, cobertura INS divergente) que não resolve por reavaliação automática."
				action:    "Escalar supervisor; não originar autonomamente sob inconsistência. Pode solicitar atualização de fonte ou aguardar consistência."
				rationale: "bd-eligibility-multi-source-composition: originar sob inconsistência violaria a invariante própria do SCF; inconsistência persistente é o caminho clássico de erro/gaming de elegibilidade."
			}, {
				id:        "securitization-regulatory-ambiguity"
				condition: "Ambiguidade regulatória na preparação de carteira para securitização: estrutura de FIDC em zona cinza CVM, critério de elegibilidade que pode requerer enquadramento específico, ou fronteira preparar-vs-administrar incerta."
				action:    "Escalar compliance officer designado para parecer antes de preparar/distribuir; não avançar até enquadramento."
				rationale: "Fronteira CVM (bd-prepares-portfolio-not-administers-fund) é constraint inviolável (nível 1); zona cinza de securitização exige julgamento jurídico especializado, jamais resolução autônoma."
			}]
		}
		rationale: """
			scf-primary-agent como operador (forward reference). Padrão de autonomia
			INTERMEDIÁRIO entre FCE (default autônomo) e DRC (default supervisionado):
			3 autonomousDecisions cobrem composição determinística da elegibilidade
			(originação dentro do envelope das 4 fontes, fechamento on-payment,
			reavaliação on-upstream-change); 4 supervisedDecisions cobrem o que sai do
			envelope (produto não-padrão, override de fonte stale — linha vermelha
			P10/P11, preparação para securitização — fronteira CVM, ajuste de acesso de
			funding partner); 4 escalationCriteria cobrem os 2 vetores adversariais da
			incentiveAnalysis (fraude de lastro sh-06 + seleção adversa sh-03) +
			inconsistência cross-source + ambiguidade regulatória CVM. Default:
			originação autônoma quando as 4 fontes são consistentes (revenue surface
			opera em escala, dp-02); supervisão é exceção para condição econômica
			não-padrão, override de gate e fronteira regulatória. Nenhuma originação
			autônoma sem lastro verificado (P11) nem sob inconsistência cross-source.
			"""
	}

	assumptions: [{
		id:                 "as-scf-1"
		assumption:         "O mecanismo criptográfico da cadeia de evidência (mesma base de as-fce-1: assinatura + hash chain + notarização) torna a falsificação de lastro de recebível computacionalmente inviável — recebível fictício não tem ReceivableMaterialized ancorado em evidência verificável."
		invalidationSignal: "Antecipação originada sobre lastro forjado aceita pelo SCF, OU comprometimento do esquema criptográfico que sustenta ReceivableMaterialized/DLV."
		rationale:          "manipulationCost de sh-06 (fraude de lastro) depende disso; sem inviabilidade criptográfica, o lastro deixa de ser o diferencial proprietário e SCF vira factoring sobre recebível auto-reportado."
	}, {
		id:                 "as-scf-2"
		assumption:         "A consistência das 4 fontes (INV+REW+CTR+INS) é condição suficiente de elegibilidade — quando as quatro batem, a originação é determinística e não requer julgamento adicional."
		invalidationSignal: "Taxa elevada de originações que escalam por inconsistência cross-source apesar de fontes individualmente válidas, OU casos recorrentes onde 4 fontes consistentes produzem produto inadequado (exigindo julgamento não-capturado)."
		rationale:          "bd-eligibility-multi-source-composition + originate-advance-on-eligibility (autônomo) pressupõem que a composição é determinística; se a maioria exige julgamento, a autonomia do revenue surface regride e dp-02 (ativação em escala) fica comprometida."
	}, {
		id:                 "as-scf-3"
		assumption:         "EligibilityEmitted/RiskScoreEmitted de REW é decisão de risco suficiente para originação — SCF consome a decisão, não re-modela risco nem produz score próprio."
		invalidationSignal: "Necessidade recorrente de o SCF ajustar/recalcular a decisão de risco do REW antes de originar, indicando que a decisão consumida não é suficiente para o produto."
		rationale:          "bd-consumes-risk-not-models é o boundary anti-REW; violá-lo daria ao SCF um modelo de risco próprio, fundindo originação de produto com modelagem de risco (dois corpos de conhecimento, scf.cue:57-62)."
	}, {
		id:                 "as-scf-4"
		assumption:         "Os critérios de elegibilidade para securitização são input regulatório externo (CVM/administrador fiduciário), não derivados pelo SCF — SCF aplica critérios declarados, não os define juridicamente."
		invalidationSignal: "Demanda recorrente de interpretação jurídica caso-a-caso de enquadramento CVM dentro do SCF, em vez de aplicação de critério declarado externamente."
		rationale:          "bd-prepares-portfolio-not-administers-fund: derivar critério de securitização internamente aproximaria o SCF de função de administrador fiduciário (constraint CVM nível 1); SCF prepara sob critério externo, não enquadra."
	}, {
		id:                 "as-scf-5"
		assumption:         "Estruturação de produto e disponibilidade de funding são desacopladas — SCF pode estruturar produto elegível sem que o funding esteja garantido (o matching com capital de sh-03 é evento separado)."
		invalidationSignal: "Produtos estruturados acumulam sem funding correspondente em volume que indica que estruturação sem funding garantido é disfuncional (carteira preparada sem comprador)."
		rationale:          "bd-structuring-not-funding-guarantee (invariante de honestidade, scf.cue:22-23): SCF gera receita do produto sem prometer capital de terceiros; a premissa é que estruturação precede e é independente do funding."
	}]

	openQuestions: [{
		id:       "oq-scf-1"
		question: "Quando e como modelar a relação scf→ext-securitization-admin no context-map (fronteira externa declarada no subdomain scf.cue:85-90 mas ausente do mapa)?"
		impact:   "A delegação de administração de securitização a administrador fiduciário externo é constraint regulatório (bd-prepares-portfolio-not-administers-fund), mas não há aresta scf→ext no context-map. A formalização deve seguir um pattern uniforme de external-system: ins-to-ext-insurers já existe no context-map como precedente — verificar se é o pattern canônico e replicá-lo, em vez de decidir pattern do zero."
		deadline: "2026-08-31"
		rationale: "Fronteira externa merece pattern uniforme decidido em WI dedicado (precedente ins-to-ext-insurers reduz escopo); modelar ad-hoc aqui criaria inconsistência. Q3 founder decision: não modelar neste scaffold."
	}, {
		id:       "oq-scf-2"
		question: "Quando o canvas INS é scaffolded para validar bidirecional o consumo ins-to-scf (CoverageActivated/Lapsed/ClaimFiled)?"
		impact:   "Forward-ref cross-BC: ins-to-scf é formalizada no context-map, mas o canvas INS não existe — o consumo não é bidirecional-validado até INS materializar como source."
		deadline: "2026-09-30"
		rationale: "INS é BC adjacente não-scaffolded; SCF consome 3 eventos de cobertura per context-map (autoridade). Validação bidirecional aguarda scaffold do INS."
	}, {
		id:       "oq-scf-3"
		question: "Quando o canvas ATO é scaffolded para validar bidirecional o consumo scf-to-ato (ReceivableAdvanceOriginated/Settled, conformist)?"
		impact:   "Forward-ref cross-BC: scf-to-ato é formalizada no context-map, mas o canvas ATO não existe. ATO acumula 4 upstreams conformist (INV/FCE/SCF/ITC) per context-map knownLimitations."
		deadline: "2026-09-30"
		rationale: "ATO é BC adjacente não-scaffolded; SCF publica 2 eventos de originação per context-map. Validação aguarda scaffold do ATO."
	}, {
		id:       "oq-scf-4"
		question: "Quando autorar contexts/scf/glossary.cue (ubiquitousLanguageRef forward-ref)?"
		impact:   "ubiquitousLanguageRef aponta para arquivo inexistente; consolida a ubiquitous language (antecipação, reverse factoring, dynamic discounting, elegibilidade de carteira, securitização)."
		deadline: "2026-07-31"
		rationale: "Glossary é precondição para domain-model do SCF; forward-ref consciente (pattern fce/drc)."
	}, {
		id:       "oq-scf-5"
		question: "Quando autorar contexts/scf/agents/scf-primary-agent.cue (domainAgentSpec) e contexts/scf/api.yaml + async-api.yaml (sc-cv-02/03)?"
		impact:   "domainAgentSpec + api-specs referenciados mas não materializados; o agente operacional + as superfícies declaradas (hasSyncSurface/hasAsyncSurface=true) dependem deles. Flags true/true espelham bdg/fce/drc (gap conhecido)."
		deadline: "2026-08-31"
		rationale: "Agent spec materializa o operador do governanceScope; api-specs são trabalho rotineiro pendente sem trade-off (WI). Forward-refs conscientes."
	}, {
		id:       "oq-scf-6"
		question: "Como a fonte de funding (próprio vs parceiro) é escolhida, qual o regime de risco por modo, e como afeta o PrePaymentGuard do FCE?"
		impact:   "adr-137 fixou o canal de execução (sempre FCE, aresta scf→fce) mas deferiu o regime da FONTE de capital. Sem o regime, o disbursement real não pode ocorrer: quem fonda (próprio sob licença SCD / parceiro), como o risco é absorvido por modo, e se/como o PrePaymentGuard difere por fonte ficam em aberto."
		deadline: "2026-09-30"
		rationale: "Escopo amplo de pf-scf-1 deferido conscientemente (def-036) — depende de condições inexistentes (receita Mesh + autorização BC; parceiros concretos). O canal mínimo já existe (adr-137); o regime de fonte espera as condições."
	}]

	verificationMetrics: [{
		id:     "lastro-fraud-rate"
		metric: "Número de tentativas de originação sobre lastro não-verificado ou com evidenceAnchors que não resolvem até DLV."
		target: "0 — toda antecipação exige ReceivableMaterialized verificado (bd-advance-requires-verified-receivable)."
		onBreach: {
			escalationRef: "lastro-fraud-suspected"
			rationale:     "Tentativa de originação sem lastro verificado é o vetor adversarial sh-06; mapeia 1:1 para o escalationCriterion de bloqueio fail-safe + security review."
		}
		rationale: "Control metric — viola P11/bd-advance-requires-verified-receivable diretamente; causalidade determinística (sem lastro → bloqueio + escalation)."
	}, {
		id:     "cross-source-inconsistency-rate"
		metric: "Número de originações que prosseguem (ou tentam) sob inconsistência não-resolvida entre as 4 fontes de elegibilidade."
		target: "0 — originação exige as 4 fontes consistentes (bd-eligibility-multi-source-composition)."
		onBreach: {
			escalationRef: "cross-source-inconsistency-persistent"
			rationale:     "Originação sob inconsistência viola a invariante própria do SCF; mapeia para o escalationCriterion de inconsistência cross-source."
		}
		rationale: "Control metric — viola bd-eligibility-multi-source-composition; detecta gaming de elegibilidade por inconsistência."
	}, {
		id:     "funding-adverse-selection-ratio"
		metric: "Ratio fondado/disponível por risk-tier por funding partner — desvio que indica cherry-picking sistemático."
		target: "Distribuição representativa por risk-tier; desvio > threshold (provisório — calibração Phase 1) sinaliza seleção adversa."
		onBreach: {
			escalationRef: "funding-adverse-selection-detected"
			rationale:     "Ratio que revela cherry-picking é o vetor sh-03 (seleção adversa); mapeia para o escalationCriterion de ajuste de acesso do partner."
		}
		rationale: "Control metric — detecta o vetor sh-03; a observabilidade do padrão (cc-05) torna a causalidade ratio→escalation determinística o suficiente para link. Threshold calibra Phase 1."
	}, {
		id:     "origination-latency-p99"
		metric: "Latência p99 entre fontes consistentes (4 disponíveis) e ReceivableAdvanceOriginated emitido."
		target: "p99 < 5 min no caminho normal (provisório — calibração Phase 1)."
		rationale: "Observability-only — latência sem SLA hard de violação; interpretação depende de volume e disponibilidade de fontes. Sem onBreach (ADR-077/078)."
	}, {
		id:     "advance-volume-activated"
		metric: "Volume de recebível antecipado (ativação) por janela — proxy operacional de dp-02 (ativação de volume sob governança)."
		target: "Crescente (sem threshold crítico de breach; é métrica de tese, não de invariante)."
		rationale: "Observability-only — volume de ativação é sinal de saúde da tese (dp-02), não violação de invariante; interpretação contextual (sazonalidade, pipeline). Sem ação automática."
	}, {
		id:     "settlement-reconciliation-time"
		metric: "Tempo entre PaymentSettled (FCE) e ReceivableAdvanceSettled (fechamento da operação)."
		target: "< 24h para 95% das operações (provisório — calibração Phase 1)."
		rationale: "Observability-only — latência de reconciliação depende de timing do FCE; sem threshold crítico determinístico de breach (atraso é diagnóstico, não violação)."
	}]

	rationale: """
		SCF é o BC supporting que estrutura e oferta produtos financeiros sobre
		recebíveis verificados — antecipação, reverse factoring, dynamic discounting,
		capital de giro — e prepara portfólios para securitização. A estrutura
		econômica é a chave da sua classificação: produto COMMODITY (supporting —
		antecipação/factoring são padrões exógenos do mercado, não proprietários à
		Mesh) + MOAT UPSTREAM (o diferencial vive em DLV/INV via mech-evidence no
		lastro, e em REW via mech-network no pricing) + SCF como REVENUE SURFACE
		(revenue-generator — captura o spread da ativação, dp-02). A coerência: o
		spread comprime vs mercado NÃO porque o produto é único (não é), mas porque o
		lastro é VERIFICÁVEL — due diligence manual (ce-07) é eliminada e o prêmio de
		risco cai. bd-structuring-not-funding-guarantee cristaliza a ortogonalidade:
		SCF gera receita do produto (spread) sem prometer funding de terceiros
		(capital de balanço). archetype specification (define produto/critérios) +
		analysis (avalia elegibilidade), inversão deliberada vs FCE (execution): SCF
		especifica, FCE executa. As 6 invariantes ancoram-se em P11/mech-evidence
		(advance-requires-verified-receivable), na composição multi-fonte própria
		(eligibility-multi-source-composition — o que torna SCF owner canônico da
		decisão de produto), e nos boundaries anti-FCE/anti-REW/anti-ext. Governança
		intermediária (P10): originação dentro do envelope das 4 fontes é autônoma
		(determinística); condição não-padrão, override de fonte stale, securitização
		e ajuste de funding partner são supervised — os 2 vetores adversariais (fraude
		de lastro sh-06, seleção adversa sh-03) têm escalationCriteria correspondentes.
		Topologia: 6 arestas cross-BC, TODAS Tier 1 unidirecionais acíclicas — SCF é
		folha downstream do grafo financeiro (consome 5: inv/rew/fce/ctr/ins; publica
		para 1: ato). 0 ciclos; sc-cm-07 inalterado. rew-to-scf reconciliada
		(naming+shape, espelho adr-126, adr-130). Teste de remoção (P13): remover SCF
		para a oferta de produto por perda de função — INV/REW/FCE continuam
		(materializam, precificam, executam), só perdem o consumidor que converte
		recebível verificado em produto ativável. A fronteira scf→ext-securitization-
		admin (administração de FIDC, externa/CVM) é declarada no subdomain mas não
		modelada no context-map — openQuestion (oq-scf-1), aguardando pattern uniforme
		de external-system (precedente ins-to-ext-insurers). Terceira aplicação de P13
		(N=3), segunda em section-by-section.
		"""
}
