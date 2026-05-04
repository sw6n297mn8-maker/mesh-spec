package ssc

// glossary.cue — Ubiquitous Language: Strategic Sourcing & Category.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC SSC. Define o vocabulário que agentes,
// código, contratos e interfaces usam ao operar neste contexto.
//
// Lenses aplicadas:
// - lens-domain-language-and-terminology-design (primária):
//   bilingual mapping, term selection, cross-layer consistency
// - lens-incentive-alignment (secundária):
//   precisão de termos adversariais (Fracionamento, FitnessRules
//   como config governada) que sustentam defesa estrutural do gate
//
// Production-guide aplicado: architecture/production-guides/glossary.cue
//
// Authoring path: subagent dispatch (disp-008) — segundo non-PG
// dispatch em WI-060 SSC bootstrap (Phase 2). Founder review pre-write
// aplicou 9 ajustes para separar UL de protocolo/integration policy.
//
// Materializado em 2 commits incrementais:
//   parte 1 — anchor + process + roles (8 terms; este commit)
//   parte 2 — machinery + events + adversarial (11 terms)
//
// domainModelRefs ficam vazios pois domain-model.cue de SSC ainda
// não existe — a serem preenchidos incrementalmente quando WI futura
// materializar o domain model (per gapPolicy do PG glossary).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code:              "ssc"
	name:              "Glossário SSC — Strategic Sourcing & Category"
	boundedContextRef: "ssc"

	terms: [{
		code:       "term-sourcing-decision"
		name:       "Decisão de Sourcing"
		termEn:     "Sourcing Decision"
		definition: "Resultado canônico produzido por SSC que declara qual fornecedor qualificado atende qual escopo de demanda em uma categoria, com decisionRationale estruturado (criteria + weights + evaluatedSuppliers + tradeoffs). É a unidade que P2P consulta para validar autoridade de procurement e que CTR consome para formalização contratual quando aplicável."
		category:   "entity"
		rationale:  "Conceito-âncora do BC. Decisão de Sourcing é mais preciso que 'escolha de fornecedor' (informal, sem rationale estruturado) ou 'compra' (que vive em P2P). É a entidade que captura o COMO e o POR QUÊ um fornecedor foi escolhido — moat de inteligência declarado pelo subdomain SSC. Tipo da decisão (one-shot, preferred, strategic) é declarado upfront pelo category manager (bd-decision-type-is-declared-upfront)."
		antiTerms: [{
			term:          "Pedido de Compra"
			clarification: "Pedido de Compra (Purchase Order) é instrumento operacional emitido por P2P para executar a compra. Decisão de Sourcing é a autoridade estratégica que precede o pedido. Frase canônica: SSC decide sourcing; P2P executa compra."
		}, {
			term:          "Contrato"
			clarification: "Contrato é instrumento jurídico formalizado por CTR. Decisão de Sourcing é input estratégico que pode (no caso de strategic-award) disparar formalização contratual; não é o contrato em si."
		}, {
			term:          "Compromisso"
			clarification: "Compromisso (Commitment) é a entidade bilateral formalizada em CMT após aceite mútuo. Decisão de Sourcing é anterior — designa fornecedor para uma demanda; o compromisso bilateral é construto downstream do macrofluxo."
		}]
		rejectedAlternatives: [{
			term:   "Award"
			reason: "Anglicismo que cobre apenas o subtipo strategic-award; não representa as outras duas variantes (one-shot, preferred-designation). 'Decisão de Sourcing' é o termo guarda-chuva canônico."
		}, {
			term:   "Seleção de Fornecedor"
			reason: "Captura a ação mas perde a propriedade de fato auditável com decisionRationale estruturado. Decisão é o output canônico estruturado, não apenas o ato de selecionar."
		}]
		examples: [{
			context:   "Vertical construção civil"
			instance:  "Decisão de Sourcing one-shot para fornecimento de 500m³ de concreto CP-II para obra XYZ — fornecedor ABC selecionado entre 4 cotantes, decisionRationale registrando criteria (preço 40%, prazo 30%, capacidade 30%), weights vigentes da categoria, evaluatedSuppliers e tradeoffs articulados."
			rationale: "Caso típico do vertical inicial — demanda pontual com decisão atômica vinculante para P2P emitir pedido."
		}]
		relatedTerms: ["term-one-shot-sourcing-decision", "term-preferred-supplier-designation", "term-strategic-award", "term-categoria-de-compra"]
	}, {
		code:       "term-one-shot-sourcing-decision"
		name:       "Decisão de Sourcing One-Shot"
		termEn:     "One Shot Sourcing Decision"
		definition: "Subtipo de Decisão de Sourcing para necessidade pontual sem contrato-quadro nem designação preferred vigente. Atômica e vinculante para P2P emitir pedido específico para o escopo declarado. Override em P2P exige supervisedDecision (hard binding)."
		category:   "entity"
		rationale:  "Subtipo declarado upfront via command MakeOneShotSourcingDecision e emitido como evento SourcingDecisionMade (canonizado em parte 2 do glossary). Termo canônico separado porque P2P trata one-shot diferente de preferred (override regime distinto: hard vs autonomous-with-audit) e CTR não é consumer (vs strategic-award que é)."
		antiTerms: [{
			term:          "Designação Preferred"
			clarification: "Preferred designation é recurring com validUntil cobrindo múltiplos pedidos; one-shot vincula um único pedido específico. Override em P2P difere: one-shot exige supervised; preferred é autonomous-with-audit."
		}]
		relatedTerms: ["term-sourcing-decision", "term-categoria-de-compra"]
	}, {
		code:       "term-preferred-supplier-designation"
		name:       "Designação de Fornecedor Preferido"
		termEn:     "Preferred Supplier Designation"
		definition: "Subtipo de Decisão de Sourcing recurring que designa fornecedor preferido para uma categoria sem contrato-quadro formal, com prazo de validade (validUntil). P2P consome como cache de policy aplicável a múltiplos pedidos da categoria; expiração de validUntil afeta apenas decisões P2P futuras — não desfaz pedidos já criados."
		category:   "entity"
		rationale:  "Declarado upfront via command DesignatePreferredSupplier e emitido como PreferredSupplierDesignated (canonizado em parte 2 do glossary). Soft binding (autonomous-with-audit em P2P) distingue de one-shot (hard binding). Útil para categorias recurring onde formalização contratual completa não justifica mas designação estável agrega valor operacional."
		antiTerms: [{
			term:          "Strategic Award"
			clarification: "Strategic Award é gatilho para formalização contratual em CTR (volume comprometido + RFQ formal). Preferred Designation não dispara CTR — é designação operacional sem contrato-quadro."
		}, {
			term:          "Contrato-Quadro"
			clarification: "Contrato-quadro (framework agreement) é instrumento formalizado em CTR com cláusulas e SLAs. Preferred Designation é leve — designação SSC sem instrumento contratual associado."
		}]
		relatedTerms: ["term-sourcing-decision", "term-strategic-award", "term-categoria-de-compra"]
	}, {
		code:       "term-strategic-award"
		name:       "Strategic Award"
		termEn:     "Strategic Award"
		definition: "Subtipo de Decisão de Sourcing que conclui RFQ formal com volume comprometido e serve como input governado para formalização contratual em CTR."
		category:   "entity"
		rationale:  "Declarado upfront via command CompleteStrategicAward e emitido como StrategicAwardCompleted (canonizado em parte 2 do glossary). CTR é consumer obrigatório (não opcional como nos outros subtipos); P2P é consumer secundário advisory enquanto CTR materializa. Comportamento de integração detalhado (janela [StrategicAward, ContractActivation], expectedContractScope no payload, transição de SoT advisory→contrato CTR) vive em domain-model + integration policy — glossário nomeia o conceito; protocolo é definido fora. Loanword preservado (precedente cmt 'CommitmentId', bdg 'Alçada' como casos de termos consagrados profissionais) — 'Concessão Estratégica' perde precisão de mercado."
		antiTerms: [{
			term:          "Contrato"
			clarification: "Strategic Award é input indicativo para formalização — CTR cria o contrato como artefato jurídico. Award não é contrato; é decisão de sourcing que dispara CTR."
		}, {
			term:          "RFQ"
			clarification: "RFQ é o processo competitivo (request for quotation) que produz cotações; Strategic Award é o resultado da RFQ formal — decisão sobre fornecedor selecionado com volume comprometido."
		}]
		rejectedAlternatives: [{
			term:   "Adjudicação Estratégica"
			reason: "Vocabulário de licitação pública (Lei 8.666). Mesh opera no setor privado — usar termo público introduz acoplamento semântico inadequado, paralelo ao precedente bdg que rejeitou 'Dotação'."
		}]
		relatedTerms: ["term-sourcing-decision", "term-rfq", "term-preferred-supplier-designation"]
	}, {
		code:       "term-rfq"
		name:       "RFQ"
		termEn:     "RFQ"
		definition: "Request for Quotation — processo competitivo estruturado que SSC opera para coletar cotações de fornecedores qualificados sobre escopo definido. Tem lifecycle público mínimo Phase 0 com 3 events (RFQOpened, RFQConcluded, RFQCancelled) que sustentam notificação operacional aos fornecedores convidados. Avaliação interna de cotações permanece intra-SSC. Phase 0 modela apenas single-round."
		category:   "process"
		rationale:  "Loanword consagrado em strategic sourcing internacionalmente — 'Solicitação de Cotação' é tradução literal sem precisão operacional do mecanismo competitivo formal. Manter sigla preserva alinhamento com profissionais (sourcing managers) e instrumentos de mercado (e-procurement platforms). Precedente: idc preservou 'Merkle Proof', 'DSSE'; bdg preservou 'Alçada'. Suporte a multi-round BAFO é openQuestion (oq-ssc-9) — fora do escopo Phase 0. Events de lifecycle canonizados em parte 2 do glossary."
		antiTerms: [{
			term:          "Cotação Informal"
			clarification: "Cotação informal (email, telefone) não tem lifecycle estruturado, sem audit trail nem notificação formal a participantes. RFQ tem lifecycle público mínimo (Opened/Concluded/Cancelled) e produz fact auditável."
		}, {
			term:          "Leilão"
			clarification: "Leilão (auction) é mecanismo dinâmico com lances iterativos públicos. RFQ é coleta de cotações fechadas — fornecedores não veem propostas dos demais até decisão. Phase 0 é single-round."
		}]
		examples: [{
			context:   "Vertical construção civil"
			instance:  "RFQ aberta para fornecimento de cimento CP-II em obra XYZ, 4 fornecedores qualificados convidados via NTF, janela de 5 dias úteis para submissão de cotações; conclusão dispara RFQConcluded e SourcingDecisionMade."
			rationale: "Caso típico de RFQ one-shot no vertical inicial — escopo definido, pool qualificado pré-validado por NPM, decisão emitida ao final."
		}]
		relatedTerms: ["term-fornecedor-qualificado", "term-sourcing-decision", "term-categoria-de-compra"]
	}, {
		code:       "term-categoria-de-compra"
		name:       "Categoria de Compra"
		termEn:     "Purchase Category"
		definition: "Taxonomia canônica de classes de bens ou serviços sobre a qual SSC opera fitness rules e Decisões de Sourcing. Cada categoria tem fitness rules vigentes próprias (pesos, critérios, thresholds) configuradas externamente por category manager. É o eixo principal de segmentação operacional do BC — fornecedores são qualificados por categoria, RFQs são abertas em uma categoria, decisões designam fornecedor para uma categoria."
		category:   "classification"
		rationale:  "Termo canônico do vocabulário de category management (junto com Strategic Sourcing e RFQ — disciplinas estabelecidas no domínio). Sem categoria como conceito explícito, fitness rules ficam globais ou ad-hoc; com categoria, segmentação é eixo de governança (rules por categoria, KPIs por categoria, drift detection por categoria)."
		antiTerms: [{
			term:          "Conta Contábil"
			clarification: "Conta contábil é estrutura do plano de contas (DRE/Balanço) para reconhecimento contábil. Categoria de Compra é segmentação operacional para sourcing — múltiplas categorias podem mapear à mesma conta e vice-versa."
		}, {
			term:          "Centro de Custo"
			clarification: "Centro de Custo (BDG) é unidade de comprometimento orçamentário. Categoria é eixo de classificação do que está sendo comprado — categoria 'concreto' pode ser comprada contra múltiplos centros de custo (uma obra por centro, mesma categoria)."
		}]
		rejectedAlternatives: [{
			term:   "Família de Insumos"
			reason: "Vocabulário de manufatura/MRP; perde generalidade para serviços e bens não-manufatura. 'Categoria de Compra' é termo padrão em strategic sourcing para qualquer tipo de objeto adquirido."
		}]
		relatedTerms: ["term-rfq", "term-sourcing-decision", "term-category-manager"]
	}, {
		code:       "term-category-manager"
		name:       "Category Manager"
		termEn:     "Category Manager"
		definition: "Função responsável pela governança da categoria no escopo da originadora ou de sua operação assistida pela Mesh — declara tipo de Decisão de Sourcing pré-RFQ, configura fitness rules vigentes por categoria, aprova supervisedDecisions de SSC (override de regra, cancelamento de RFQ, configuração de rules) e opera o BC por exceção."
		category:   "role"
		rationale:  "Papel funcional articulado em bd-category-manager-as-sh-01-internal-function. Definição genérica preserva resiliência a evoluções operacionais (originadora interna; operação assistida pela Mesh; delegação parcial a agente; modos híbridos). Phase 0 operacional: recipient pré-PMF é founder per ADR-037; pós-PMF evolui para category manager designado conforme modelo operacional escolhido. Loanword preservado (precedente: terminology profissional internacional) — 'Gestor de Categoria' é tradução aceitável mas perde alinhamento com vocabulário consagrado da disciplina category management. Distinto de stakeholder próprio porque é função, não ator separado."
		antiTerms: [{
			term:          "Comprador"
			clarification: "Comprador (buyer) é função operacional em P2P que executa pedidos. Category manager é função estratégica em SSC que decide sourcing — qual fornecedor atende qual categoria. Comprador opera dentro da decisão; category manager faz a decisão."
		}, {
			term:          "Procurement Officer"
			clarification: "Procurement officer é função genérica que pode cobrir todo o ciclo (sourcing + execução). Category manager é especificamente o papel estratégico em SSC, focado em decisão por categoria — não executa pedido."
		}]
		relatedTerms: ["term-sourcing-decision", "term-categoria-de-compra"]
	}, {
		code:       "term-fornecedor-qualificado"
		name:       "Fornecedor Qualificado"
		termEn:     "Qualified Supplier"
		definition: "Participante NPM com status eligible-for-sourcing consultado via QueryParticipantStatus. Precondição absoluta para entrada em RFQ (bd-qualification-as-absolute-precondition). SSC valida em 2 momentos críticos: RFQ open (qualificação inicial do pool) e decision time (re-validation antes de emitir decisão). Fornecedor rebaixado entre os dois pontos é excluído automaticamente. SSC NÃO revalida compliance — KYC/AML é responsabilidade NPM."
		category:   "classification"
		rationale:  "Fronteira boundary com NPM. 'Fornecedor' é role (papel ativo na rede); 'qualificado' é classification — gate hard binário de elegibilidade aplicado ao role. Schema #TermCategory tem ambos enums; classification é mais preciso para o termo composto que nomeia o gate (não o papel em si). Termo canônico explícito porque é o gate que abre acesso ao mercado SSC. Re-validation no decision time é design response a janela de risco entre RFQ open e decision (NPM pode rebaixar durante RFQ ativa)."
		antiTerms: [{
			term:          "Fornecedor Cadastrado"
			clarification: "Cadastro é registro inicial em NPM (status pending). Qualificado é status pós-aprovação KYC/AML (eligible-for-sourcing). SSC opera apenas com qualificados — cadastrados não-qualificados não entram em RFQ."
		}, {
			term:          "Fornecedor Preferido"
			clarification: "Fornecedor Preferido é resultado de Designação de Fornecedor Preferido (Decisão de Sourcing recurring) — pressupõe qualificação como precondição. Qualificado é o universo elegível; preferido é o subconjunto designado para uma categoria."
		}]
		relatedTerms: ["term-rfq", "term-sourcing-decision"]
	}, {
		code:       "term-fitness-signals"
		name:       "FitnessSignals"
		termEn:     "Fitness Signals"
		definition: "Estrutura de inputs estruturados que SSC consome para aplicar fitness rules e produzir Decisão de Sourcing. Composição Phase 0: requiredPhase0 (NPM eligibility + RFQ context + RFQ responses) + optionalPhase0 (NIM performance/reputation + CTR existingCommitments — pendentes oq-ssc-1, oq-ssc-2, oq-ssc-7). SSC NÃO interpreta signals — aplica regras determinísticas; ausência ou ambiguidade de signal required dispara escalation."
		category:   "value"
		rationale:  "Conceito-âncora da capacidade de decisão de SSC. Termo canônico distingue de 'dados de fornecedor' (genérico) ou 'inputs' (não-estruturado). Anti-mini-NIM: SSC consome FitnessSignals como struct externa; não computa nem infere — apenas estrutura o que vem da RFQ e consome o que outros BCs (NPM, NIM, CTR) produzem. Refs a openQuestions na definition são essenciais para entender camada optionalPhase0 (signals que entram pós-formalização cross-BC)."
		antiTerms: [{
			term:          "Reputation Score"
			clarification: "Reputation Score é construto computado por NIM. SSC consome reputation signals via FitnessSignals.performanceScore (pós-bootstrap NIM) — não computa o score em si. Anti-mini-NIM: SSC aplica, não interpreta."
		}, {
			term:          "Risk Rating"
			clarification: "Risk rating de fornecedor é responsabilidade de REW (não modelado Phase 0 em SSC). SSC consome eligibility binária de NPM como gate absoluto, não scoring de risco gradiente."
		}]
		relatedTerms: ["term-fitness-rules", "term-sourcing-decision", "term-fornecedor-qualificado", "term-decision-rationale"]
	}, {
		code:       "term-fitness-rules"
		name:       "Fitness Rules"
		termEn:     "Fitness Rules"
		definition: "Regras determinísticas versionadas que SSC aplica sobre FitnessSignals para produzir Decisão de Sourcing — pesos por critério, thresholds, lógica de equalização TCO. Vivem em configuração externa governada (não no agent code) com versionamento e audit trail de mudanças. Configuração e atualização são supervisedDecision (configure-fitness-rules) — não pertencem ao escopo aplicador do agente."
		category:   "rule"
		rationale:  "Materialização operacional de bd-deterministic-decision-from-structured-signals. Termo canônico explícito porque é o conceito que sustenta integridade do gate: regras versionadas + audit trail + governance de mudanças = credibilidade. Sem termo, agente confunde 'aplicar regras' com 'inferir critérios' — viola anti-mini-NIM. Loanword preservado por alinhamento com vocabulário técnico de scoring/decision systems. Shape e infraestrutura de configuração de fitness rules é openQuestion oq-ssc-8 — definição da forma canônica fica para evolução futura."
		antiTerms: [{
			term:          "Scoring Algorithm"
			clarification: "Scoring algorithm sugere modelo treinável que infere padrões. Fitness Rules são regras determinísticas declarativas (pesos, thresholds, equalizações) — sem inferência, sem treinamento, sem aprendizado. Reaplicação produz mesmo resultado dado mesmos signals."
		}, {
			term:          "Heurística"
			clarification: "Heurística implica regra aproximativa de julgamento. Fitness Rules são regras formais versionadas com governance — não heurísticas ad-hoc. Heurísticas violariam determinismo do gate."
		}]
		relatedTerms: ["term-fitness-signals", "term-sourcing-decision", "term-equalizacao-tco", "term-categoria-de-compra"]
	}, {
		code:       "term-decision-rationale"
		name:       "DecisionRationale"
		termEn:     "Decision Rationale"
		definition: "Estrutura de captura canônica que cada Decisão de Sourcing carrega, registrando criteria aplicados, weights vigentes da categoria, evaluatedSuppliers e tradeoffs articulados. Sustenta auditoria de processo competitivo (compliance anti-corrupção, Lei 12.846), reconciliação spend por controllers e consumo NIM futuro (intelligence learning loop pós-bootstrap NIM)."
		category:   "value"
		rationale:  "Captura estruturada é o moat de inteligência da Mesh per subdomain SSC: 'dado mais valioso para NIM é como e por que fornecedor foi escolhido'. Termo canônico distingue de 'justificativa' (texto livre) ou 'comentário' (não-estruturado). Sem decisionRationale como termo, agentes tratam como string opcional — perdem moat analítico. Formalização cross-BC com NIM (consumo via decision events com decisionRationale rico) é coberta pelos openQuestions oq-ssc-1 (nim-to-ssc) e oq-ssc-2 (ssc-to-nim)."
		antiTerms: [{
			term:          "Justificativa"
			clarification: "Justificativa em sentido coloquial é texto livre. DecisionRationale é estrutura tipada (criteria + weights + evaluatedSuppliers + tradeoffs) que sustenta consumo programático downstream — NIM aprende padrões, controllers reconciliam spend."
		}]
		relatedTerms: ["term-sourcing-decision", "term-fitness-rules", "term-fitness-signals"]
	}, {
		code:       "term-equalizacao-tco"
		name:       "Equalização TCO"
		termEn:     "TCO Equalization"
		definition: "Padrão analítico de strategic sourcing pelo qual cotações são normalizadas considerando Total Cost of Ownership — preço unitário + custos indiretos relevantes para a categoria (logística, retrabalho esperado, garantia, downtime). Implementada em SSC como componente das Fitness Rules quando categoria exige (categorias commodity podem usar apenas preço; categorias técnicas exigem TCO completo)."
		category:   "process"
		rationale:  "Termo canônico do vocabulário de category management — sem equalização TCO, comparação de cotações é parcial e favorece fornecedores que sub-precificam unit price compensando em custos indiretos. TCO loanword preservado (precedente: vocabulário consagrado em strategic sourcing). Implementação concreta vive em Fitness Rules da categoria — termo aparece no glossário como conceito porque é referenciado em decisionRationale e em discussão de configuração."
		antiTerms: [{
			term:          "Comparação por Preço"
			clarification: "Comparação por preço unit considera apenas valor cotado; TCO inclui custos relevantes ao longo do ciclo de uso. Para categorias commodity (cimento padrão), preço pode ser proxy razoável; para categorias técnicas, equalização TCO é necessária para decisão informada."
		}]
		relatedTerms: ["term-fitness-rules", "term-categoria-de-compra", "term-sourcing-decision"]
	}, {
		code:       "term-sourcing-decision-made"
		name:       "SourcingDecisionMade"
		termEn:     "Sourcing Decision Made"
		definition: "Evento de domínio publicado quando Decisão de Sourcing one-shot é emitida. Hard binding para P2P emitir pedido específico (override exige supervisedDecision). Carrega decisionRationale rico (criteria + weights + evaluatedSuppliers + tradeoffs)."
		category:   "event"
		rationale:  "Mapeamento canônico (per bd-decision-type-is-declared-upfront): one-shot → SourcingDecisionMade. Termo canônico no glossário porque o nome em inglês aparece em código, contratos e logs cross-context. Distinto de PreferredSupplierDesignated (recurring soft binding) e StrategicAwardCompleted (gatilho CTR). NIM consumer é openQuestion (oq-ssc-2) — quando bootstrap, mesmo evento alimenta intelligence learning loop sem evento dedicated."
		relatedTerms: ["term-one-shot-sourcing-decision", "term-decision-rationale", "term-sourcing-decision"]
		layerMapping: {
			codeTerm: "SourcingDecisionMade"
		}
	}, {
		code:       "term-preferred-supplier-designated"
		name:       "PreferredSupplierDesignated"
		termEn:     "Preferred Supplier Designated"
		definition: "Evento de domínio publicado quando Designação de Fornecedor Preferido é ativada. Soft binding em P2P (autonomous-with-audit) — override sustentado é sinal de drift de designação (mecanismo de feedback loop P2P→SSC documentado em canvas openQuestions). Carrega validUntil; expiração afeta apenas decisões P2P futuras — não desfaz pedidos já criados sob designação vigente."
		category:   "event"
		rationale:  "Mapeamento canônico: preferred-designation → PreferredSupplierDesignated. Soft binding é design deliberado: P2P pode override em casos genuínos de exceção sem fricção operacional, mas sustentado vira sinal de drift que retroalimenta SSC para redesignação. Mecanismo concreto de feedback loop é openQuestion oq-ssc-3."
		relatedTerms: ["term-preferred-supplier-designation", "term-decision-rationale", "term-sourcing-decision"]
		layerMapping: {
			codeTerm: "PreferredSupplierDesignated"
		}
	}, {
		code:       "term-strategic-award-completed"
		name:       "StrategicAwardCompleted"
		termEn:     "Strategic Award Completed"
		definition: "Evento de domínio publicado quando Strategic Award é concluído pós-RFQ formal — gatilho para formalização contratual em CTR. CTR consumer primário e obrigatório (formaliza contrato sob input indicativo); P2P consumer secundário advisory enquanto CTR materializa contrato — pós-materialização, contrato CTR é SoT vinculante."
		category:   "event"
		rationale:  "Mapeamento canônico: strategic-award → StrategicAwardCompleted. Único dos 3 events com CTR como consumer obrigatório — reflete papel do strategic-award como ponte entre decisão de sourcing e formalização contratual. Cache stale em P2P pós-cancelamento CTR é tratado como deferimento operacional documentado em domain-model + canvas openQuestions."
		relatedTerms: ["term-strategic-award", "term-decision-rationale", "term-sourcing-decision"]
		layerMapping: {
			codeTerm: "StrategicAwardCompleted"
		}
	}, {
		code:       "term-rfq-opened"
		name:       "RFQOpened"
		termEn:     "RFQ Opened"
		definition: "Evento de lifecycle público mínimo publicado quando RFQ é aberta — fornecedores qualificados convidados são notificados via NTF transversal. Carrega categoria, escopo, janela de cotação e pool de fornecedores convidados. OBS consome para observabilidade. Decisão autônoma do agente (open-rfq) — abertura é função sobre input estruturado (demanda + pool qualificado pré-validado por NPM)."
		category:   "event"
		rationale:  "Parte do trio canônico de RFQ lifecycle (RFQOpened, RFQConcluded, RFQCancelled) per bd-rfq-lifecycle-public-minimal. Visibilidade pública mínima sustenta operacional dos fornecedores convidados; avaliação interna de cotações permanece intra-SSC (preserva confidencialidade competitiva)."
		relatedTerms: ["term-rfq", "term-fornecedor-qualificado"]
		layerMapping: {
			codeTerm: "RFQOpened"
		}
	}, {
		code:       "term-rfq-concluded"
		name:       "RFQConcluded"
		termEn:     "RFQ Concluded"
		definition: "Evento de lifecycle público mínimo publicado quando RFQ é concluída — decisão de sourcing emitida. Notifica fornecedores convidados (vencedores e não-vencedores) via NTF transversal. OBS consome para observabilidade. Decisão autônoma do agente (conclude-rfq-on-decision) — conclusão é evento causal de decisão emitida, sem julgamento envolvido."
		category:   "event"
		rationale:  "Conclusão pareada com abertura — notificação a não-vencedores é elemento de processo competitivo formal (sustenta legitimidade do mecanismo, evita fornecedores em limbo). Conclusão é determinística: decisão emitida ⇒ RFQ concluída."
		relatedTerms: ["term-rfq", "term-sourcing-decision"]
		layerMapping: {
			codeTerm: "RFQConcluded"
		}
	}, {
		code:       "term-rfq-cancelled"
		name:       "RFQCancelled"
		termEn:     "RFQ Cancelled"
		definition: "Evento de lifecycle público mínimo publicado quando RFQ é cancelada antes de decisão. Operação anula compromisso com fornecedores convidados — supervisedDecision (cancel-rfq) por custo reputacional. Notifica via NTF transversal com justificativa documentada."
		category:   "event"
		rationale:  "Cancelamento é supervisedDecision (não autônoma) per bd-rfq-lifecycle-public-minimal — distingue de abertura/conclusão (autonomous). Custo reputacional para fornecedores que investiram tempo em cotação justifica gate humano com justificativa explícita."
		relatedTerms: ["term-rfq"]
		layerMapping: {
			codeTerm: "RFQCancelled"
		}
	}, {
		code:       "term-fracionamento"
		name:       "Fracionamento"
		termEn:     "Fragmentation"
		definition: "Padrão adversarial em que um proponente subdivide deliberadamente uma demanda de valor superior a threshold em múltiplas RFQs sub-threshold com mesmo escopo, mesmo fornecedor potencial e janela temporal curta, para evitar processo competitivo formal OR concentração detectável. Detection é responsabilidade de act-detect-fragmentation-pattern (agent SSC pós-bootstrap); ocorrência detectada dispara escalation criterion fragmentation-pattern-detected — pausa autonomia para proponente OR fornecedor afetado até decisão humana."
		category:   "classification"
		rationale:  "Vetor adversarial canônico no incentiveAnalysis sh-02 (collusion sub-threshold) e mecanismo de detection backup explícito em escalationCriteria. Modelar como termo canônico torna o conceito visível na UL — agentes referenciam o padrão pelo nome em código de detection e em escalações. Termo familiar em controladoria brasileira (paralelo ao precedente bdg que canonizou Fracionamento como threshold gaming em compras públicas — Lei 8.666 — embora Mesh seja setor privado, o conceito é o mesmo). Schema #TermCategory não inclui 'anti-pattern' — classification é a melhor aproximação dentro do enum atual (Fracionamento como classificação de padrão observável). Dívida explícita registrada para evolução futura do schema."
		antiTerms: [{
			term:          "Compra Pulverizada"
			clarification: "Compra pulverizada é prática legítima de diversificação de fornecedores ao longo do tempo para reduzir dependência. Fracionamento é divisão deliberada para contornar threshold competitivo — diferença está na intenção e no padrão temporal/relacional concentrado."
		}]
		rejectedAlternatives: [{
			term:   "Threshold Gaming"
			reason: "Idiomático em segurança/incentive design mas opaco em conversa de domínio com category managers brasileiros. 'Fracionamento' é termo familiar em controladoria — precedente bdg adotou mesmo termo para vetor análogo em BDG (Alçada gaming)."
		}]
		relatedTerms: ["term-rfq", "term-categoria-de-compra"]
	}]

	rationale: "UL completa do BC SSC organiza-se em torno do conceito-âncora Decisão de Sourcing e seus 3 subtipos declarados upfront (One-Shot, Preferred Supplier Designation, Strategic Award) — cada um com binding regime distinto em P2P (hard / soft / advisory-pré-CTR) e mapeamento canônico para evento próprio (SourcingDecisionMade, PreferredSupplierDesignated, StrategicAwardCompleted). Mecanismo competitivo (RFQ — loanword preservado) com seu trio de events de lifecycle público mínimo (RFQOpened, RFQConcluded, RFQCancelled). Inputs estruturados do gate determinístico (FitnessSignals consumido como struct externa, FitnessRules vivendo em config externa governada) com captura canônica do output (DecisionRationale como moat de inteligência). Eixo de segmentação operacional (Categoria de Compra) e função humana de governance (Category Manager — definição genérica preservando resiliência a evoluções operacionais). Padrão analítico de equalização (Equalização TCO — TCO loanword preservado). Boundary com NPM (Fornecedor Qualificado — gate hard binário, classification aplicada ao role). Vetor adversarial canônico (Fracionamento — paralelo deliberado com bdg para vocabulário cross-BC consistente; classification como workaround para schema #TermCategory que não inclui anti-pattern). Anti-mini-NIM como invariant transversal: termos como ReputationScore e RiskRating NÃO entram (anti-fragmentação cross-BC) — SSC consume signals de NIM/REW via FitnessSignals; não computa nem infere. Pedido de Compra, Contrato e Compromisso são antiTerms recorrentes — fortalecem fronteiras com P2P, CTR e CMT respectivamente (frase canônica: SSC decide sourcing; CTR formaliza contrato; P2P executa compra). Vocabulary respeita convenções de strategic sourcing internacional onde inglês perde precisão (RFQ, Strategic Award, Category Manager, FitnessSignals, FitnessRules, TCO) e usa português onde vocabulário brasileiro é mais preciso (Decisão de Sourcing, Categoria de Compra, Fornecedor Qualificado, Fracionamento, Equalização TCO). Founder review pre-write aplicou 9 ajustes para separar UL de protocol/integration policy: definitions limpas (sem refs a oq não-essenciais nem detalhes de runtime); refs a oq mantidas em rationale onde essenciais para context Phase 0; categories ajustadas (role→classification para Fornecedor Qualificado e Fracionamento). domainModelRefs ficam vazios pendente de materialização do domain-model.cue de SSC."
}
