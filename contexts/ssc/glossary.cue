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
	}]

	rationale: "Parte 1 do glossário SSC: estabelece vocabulário fundacional do BC — conceito-âncora Decisão de Sourcing + 3 subtipos (One-Shot, Preferred Designation, Strategic Award) + processo competitivo (RFQ) + segmentação operacional (Categoria de Compra) + função humana (Category Manager) + boundary com NPM (Fornecedor Qualificado). Define o que SSC produz, sobre que opera, quem opera, com qual gate de entrada — sem ainda materializar machinery operacional (FitnessSignals/FitnessRules/DecisionRationale/Equalização TCO), events outbound (6 events) nem vetor adversarial (Fracionamento) — esses entram em parte 2. Frase canônica preservada: SSC decide sourcing; CTR formaliza contrato; P2P executa compra (antiTerms recorrentes em term-sourcing-decision sustentam esta separação). Anti-mini-NIM aparece em rationale dos antiTerms de term-fornecedor-qualificado (boundary NPM mantida). Vocabulary híbrido PT-BR (Decisão de Sourcing, Categoria de Compra, Fornecedor Qualificado) + EN loanword (RFQ, Strategic Award, Category Manager) seguindo precedente bdg/idc para termos onde inglês perde precisão operacional. domainModelRefs ficam vazios pendente de materialização do domain-model.cue de SSC."
}
