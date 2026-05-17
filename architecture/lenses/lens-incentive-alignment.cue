package lenses

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// lens-incentive-alignment.cue — Lens analítica para análise de
// comportamento adversarial dentro de mecanismos fixos.
//
// Bootstrapped por Q10 do canvas SSC (WI-060) após founder identificar
// que lens-game-theory-applied era imprecisa no nível de abstração:
// SSC modela comportamento adversarial dentro de mecanismo fixo, não
// equilíbrio teórico. Lens cria fronteira clara entre teoria de
// equilíbrio (lens-game-theory-applied), design de regras (lens-
// mechanism-design) e proteção operacional de mecanismos existentes
// (esta lens).
//
// Aplicado PG lens (architecture/production-guides/lens.cue) section-
// by-section per manualAuthoringProtocol (adr-057). Founder review
// por section + 5 ciclos de red team por section.
//
// 6 critérios tq-lng-XX satisfeitos por construção:
// - tq-lng-01 (trigger determinístico): conditions SIM/NÃO testáveis,
//   sem quantificadores vagos
// - tq-lng-02 (capacidade analítica própria): reasoningProtocol é
//   sequência defensiva específica (mapping → vectors → response →
//   signal audit → detection), não duplica P10 ou dp-08
// - tq-lng-03 (mesh examples concretos): SSC RFQ low-balling +
//   BDG cost-center masking, ambos com recommendation acionável
// - tq-lng-04 (limitations com alternative): 3 limitations cada com
//   alternative concreta (lens-game-theory-applied, lens-mechanism-
//   design, lens-data-quality-as-competitive-moat)
// - tq-lng-05 (relatedLenses semantic): 4 lenses com relations
//   articuladas — tensionWith (game-theory, mechanism-design) +
//   complementsWith (information-economics) + feedsInto
//   (organizational-resource-allocation)
// - tq-lng-06 (lens descritiva): concepts orientam análise; reasoning
//   é sequência de perguntas adversariais; sem imperativo de
//   enforcement em concept ou step. Canonical removal test (tq-mg-10):
//   se removermos esta lens, invariants Mesh permanecem protegidos
//   por outros enforcers? Resposta SIM — lens é OPERADORA analítica
//   (orienta análise), não SEGURADORA de invariant. P10 permanece via
//   gates determinísticos; dp-08 permanece via canvas incentiveAnalysis
//   structural pattern; structural-checks por artifact-type específico
//   permanecem ativos.

incentiveAlignmentLens: artifact_schemas.#AnalyticalLens & {
	id:   "lens-incentive-alignment"
	name: "Incentive Alignment & Adversarial Behavior"

	purpose: "Análise de comportamento adversarial dentro de mecanismos fixos: prevenir manipulação, detectar exploração, estruturar incentivos sem redesenhar mecanismo nem modelar equilíbrio teórico."

	status: "draft"

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Comportamento adversarial dentro de mecanismos fixos é universal:
			toda cadeia produtiva B2B com decisões automatizadas tem
			participantes com incentivo para manipular. Mecanismos específicos
			variam por vertical (RFQ em construção civil, leilão de
			fornecedores em manufatura, sourcing strategy em retail), mas a
			estrutura adversarial — atores com incentivo divergente operando
			dentro de regras fixas — é transversal a B2B.
			"""
	}

	// =============================================
	// TRIGGER
	// =============================================

	trigger: {
		conditions: [
			"Decisão é tomada por agente AI ou processo automatizado dentro de mecanismo fixo (regras já definidas em config externa)",
			"Múltiplos atores (humanos ou agentes) podem influenciar a decisão diretamente ou indiretamente via inputs",
			"≥1 stakeholder tem benefício potencial mensurável em deviar do comportamento alinhado com o purpose do mecanismo",
		]
		keywords: [
			"manipulation",
			"adversarial",
			"low-ball",
			"gaming",
			"exploit",
			"algorithmic bias",
			"collusion",
		]
		excludeWhen: [
			"Decisão é puramente técnica sem stakeholders com interesse divergente",
			"Análise busca redesenhar mecanismo de zero (use lens-mechanism-design)",
			"Análise busca equilíbrio teórico cooperativo de longo prazo (use lens-game-theory-applied)",
		]
		rationale: """
			Lens ativa para PROTEGER mecanismos contra exploração — distinto
			de DESENHAR mecanismos (lens-mechanism-design) ou de MODELAR
			equilíbrios teóricos (lens-game-theory-applied). Boundary
			canônica: 'mecanismo já existe, precisa ser robusto contra
			manipulação' é o domínio desta lens. Conditions e keywords são
			testáveis SIM/NÃO; excludeWhen articula fronteira com lenses
			adjacentes evitando over-application.
			"""
	}

	// =============================================
	// CONCEPTS
	// =============================================

	concepts: [{
		id:     "incentive-structure"
		name:   "Incentive Structure"
		nature: "theoretical"
		role:   "framework"
		definition: "Estrutura que mapeia ações de cada ator a payoffs (ganho ou perda) considerando ações dos outros atores e regras do mecanismo. Captura quem ganha o quê com cada combinação de ações."
		meshManifestation: "Em SSC, structure mapeia ações de fornecedor (cotar verdadeiro vs low-ball) a payoffs (ganhar contrato + entregar conforme vs ganhar e renegociar pós-decision); em BDG, mapeia ações de category manager (declarar centro de custo correto vs mascarar) a payoffs (aprovação rápida vs investigação)."
		meshImplication: "Antes de calibrar gates ou desenhar design response, mapear structure explicitamente — quem ganha o quê com cada ação possível, incluindo ações manipulativas. Mapping ausente vira design response cego."
		rationale: "Framework analítico fundamental — manipulation vector e design response derivam do mapping. Sem incentive structure, análise adversarial é narrativa sem grounding."
	}, {
		id:     "manipulation-vector"
		name:   "Manipulation Vector"
		nature: "operational"
		role:   "method"
		definition: "Caminho específico via o qual ator pode obter payoff superior ao alinhado com purpose do mecanismo, explorando assimetria informacional, opacidade de regras ou folga regulatória."
		meshManifestation: "SSC — fornecedor low-balling cotação RFQ; originadora manipulando pesos de fitness rules para favorecer fornecedor preferido; agente operador com viés algorítmico. BDG — originadora mascarando centro de custo; category manager corrupto aprovando override de Alçada."
		meshImplication: "Cada vector identificado precisa designResponse declarado. Vector sem response declarado é gap de proteção que tende a ser explorado em escala. Vectors documentados em canvas.incentiveAnalysis devem ter response em domain-model.invariants ou agent-spec.constraints."
		rationale: "Operational concept — vector é unidade de análise concreta para hardening. Distinto de incentive-structure (framework abstrato) por ser atomically actionable."
		dependsOn: ["incentive-structure"]
	}, {
		id:     "manipulation-cost"
		name:   "Manipulation Cost"
		nature: "operational"
		role:   "property"
		definition: "Custo (tangível ou reputacional) que ator paga ao tentar manipulation vector, calculado como detection probability × penalty + custo de operação manipulativa em si."
		meshManifestation: "SSC — detection via Event Log + reconciliação cross-BC com NIM (pós-bootstrap); penalty inclui revogação de aprovações + escalada de severidade futura + responsabilidade jurídica (dp-10 quando configurar fraude). BDG — detection via inv-cost-center-required + cross-BC reconciliação CMT/DLV."
		meshImplication: "Para cada vector, calcular cost vs benefit assimétrica. Se benefit > cost detectável, mecanismo é frágil — design response prioritário. Cost ínfimo + benefit alto é vetor escalonável (gaming sistemático)."
		rationale: "Property analítica que torna vectors comparáveis — permite priorização. Sem cost calculation, todos vectors parecem igualmente urgentes."
		dependsOn: ["manipulation-vector"]
	}, {
		id:     "design-response"
		name:   "Design Response"
		nature: "operational"
		role:   "method"
		definition: "Mecanismo estrutural (gate determinístico, validação cross-BC, supervisedDecision, audit trail rico) que aumenta manipulation cost ou reduz manipulation benefit, mantendo mecanismo operacional para uso correto."
		meshManifestation: "SSC — fitness rules como config externa governada com versionamento (bd-fitness-rules-as-config); revalidação NPM no decision time; audit trail com decisionRationale rico. BDG — inv-cost-center-required como invariant; supervisedDecisions para override de Alçada; OBS metric supervisor-override-rate."
		meshImplication: "Response NÃO é 'remover funcionalidade' — é 'tornar exploração mais cara que operação correta', preservando utilidade do mecanismo para casos legítimos. Asymmetric cost design: ato correto é trivial, ato manipulativo requer esforço/custo desproporcional."
		rationale: "Operational concept central — é onde análise vira ação. Sem design response materializado em invariants/constraints/gates, análise adversarial é descritiva, não defensiva."
		dependsOn: ["manipulation-vector", "manipulation-cost"]
	}, {
		id:     "signal-robustness"
		name:   "Signal Robustness"
		nature: "operational"
		role:   "property"
		definition: "Resistência de signal a manipulação direta ou influência via inputs upstream — signal robusto sustenta decisão mesmo quando atores tentam alterar input. Signal frágil é manipulável; signal robusto sai do controle do manipulador."
		meshManifestation: "SSC — fitness rules em config externa governada (não mutável por ator); NPM eligibility (fonte autoritativa NPM, não declaração do fornecedor); RFQ context estruturado pelo SSC. Signal frágil: cotação do fornecedor (input do manipulador). Signal robusto: NPM status (fonte externa)."
		meshImplication: "Quanto mais signals fora do controle do ator manipulador, mais robusta a decisão. Signal audit é checagem sistemática — para cada input, perguntar 'pode o ator manipulável alterar este signal?'. Se sim, mover signal para fora do controle do ator OU adicionar cross-validation."
		rationale: "Property analítica que orienta arquitetura de inputs — preventiva, não detectiva. Signals robustos eliminam classe inteira de manipulation vectors antes de virarem problema."
	}, {
		id:     "incentive-divergence-detection"
		name:   "Incentive Divergence Detection"
		nature: "operational"
		role:   "heuristic"
		definition: "Padrão estatístico ou comportamental observável que sinaliza ator operando fora do alinhado — drift de método, anomalia em distribuição, override-rate sustentado, padrão coordenado entre múltiplos atos."
		meshManifestation: "SSC — Fracionamento detection (multiple sub-threshold submissions de mesmo proponente em janela curta). BDG — supervisor-override-rate sustentado acima de threshold canvas. FCE — payment pattern anomaly (cadência ou montante atípicos). Comum: detection é mecanismo SECUNDÁRIO; defesa primária é structural."
		meshImplication: "Detection é segunda linha de defesa — cobre vectors que structural defense não capta totalmente. Trigger de detection deve gerar escalation, não block automático (P10: detection sinaliza, humano decide consequência). Métricas de detection vivem em OBS + drift detection do agent-governance envelope."
		rationale: "Heuristic operational — detection é último recurso quando design response não pode ser tornado totalmente structural. Modelagem honesta: nem todo vector tem structural fix viable em Phase 0."
		dependsOn: ["manipulation-vector"]
	}]

	// =============================================
	// REASONING PROTOCOL
	// =============================================

	reasoningProtocol: [{
		question: "Qual é a estrutura de incentivos REAL deste mecanismo? Quem ganha o quê com cada ação possível, incluindo ações manipulativas?"
		reveals:  "Incentive-structure mapping completo para todos atores envolvidos — base para todas as análises subsequentes. Atores típicos: originador da demanda, executor de operação, agente operador, supervisor humano, observador externo."
		rationale: "Sem mapping explícito, análise adversarial opera em narrativa sem grounding. Mapping força articulação de payoffs concretos — quem ganha em cenário alinhado vs cenário manipulativo."
	}, {
		question: "Quais manipulation vectors específicos existem? Para cada ator, qual ação manipulativa tem benefit > cost detectável atual?"
		reveals:  "Vectors prioritários para design response, ordenados por assimetria benefit/cost. Vectors low-cost-high-benefit são tier 1; vectors high-cost-low-benefit auto-defendidos."
		rationale: "Priorização é necessária — recursos defensivos são finitos. Atacar vectors com maior assimetria primeiro maximiza ROI defensivo. Vectors enumerados sem priorização vira to-do list infinita."
	}, {
		question: "Para cada vector tier 1, qual é a design response que torna manipulation cost > benefit, preservando mecanismo operacional para uso correto?"
		reveals:  "Gaps de proteção atuais e quais responses materiais (gate determinístico, audit trail, supervisedDecision, signal robustness shift, cross-BC validation). Asymmetric cost design — operação correta trivial, manipulativa cara."
		rationale: "Response sem articulação é prevenção implícita — falha silenciosa quando vector é explorado. Response materializado em invariant/constraint/gate é testável e auditable."
	}, {
		question: "Quais signals do mecanismo são robustos vs manipuláveis? Quais signals deveriam ser movidos para fora do controle do ator manipulador?"
		reveals:  "Signal robustness audit — para cada input do mecanismo, classificação 'robusto' (fora do controle do manipulador) ou 'frágil' (sob controle). Recomendação de architectural shift: mover signals frágeis para fontes autoritativas externas ao manipulador."
		rationale: "Signals robustos eliminam classes inteiras de manipulation vectors preventivamente. Mais barato shift de signal source que blindar todos vectors derivados de signal frágil. Análise upstream do design response."
	}, {
		question: "Quais padrões observáveis indicariam manipulation em runtime? Como incentive-divergence-detection cobriria o que structural defense não capta?"
		reveals:  "Detection metrics + thresholds + coverage gaps. Vectors com structural fix completo não precisam detection; vectors com fix parcial precisam detection como segunda linha. Coverage assessment — quais vectors ficam sem nenhuma defesa."
		rationale: "Honesto reconhecimento de limites: structural defense é primary mas nem todo vector tem fix viable Phase 0. Detection cobre o gap, mas é segundo melhor — gera metric drift, não bloqueio direto."
	}]

	// =============================================
	// MESH EXAMPLES
	// =============================================

	meshExamples: [{
		id: "ex-ssc-rfq-low-balling"
		scenario: """
			SSC abre RFQ para fornecimento de cimento CP-II em obra
			específica. Fornecedor X submete preço 30% abaixo da média
			histórica da categoria + capacidade declarada 2x acima do
			realista para sua escala operacional. Outros fornecedores
			cotam dentro de range esperado. Phase 0 (sem NIM signals
			históricos): SSC tem que decidir entre escolher X (baseado
			em fitness rules sobre signals disponíveis) ou escalar.
			"""
		analysis: """
			Incentive-structure mapping: fornecedor X benefit potencial =
			ganhar contrato + renegociar pós-decision OR entregar
			qualidade inferior. Manipulation cost atual = baixo (sem NIM
			reputation decay automático Phase 0; sem RFQ history
			comparison); detection probability baixa em fase pré-pipeline
			completo. Vector = low-ball + capacity overstate combinados.
			Signal-robustness audit: cotação (preço, capacidade) é INPUT
			do fornecedor — frágil. Signals robustos disponíveis: NPM
			eligibility (qualificado), RFQ context (volume, location),
			RFQ history (mediana de preço por categoria — se SSC
			estruturar como signal próprio).
			"""
		recommendation: """
			Design response Phase 0: fitness rules incluem comparação
			contra RFQ history (mediana de preço por categoria + variância
			máxima); cotação fora de threshold dispara escalation
			'suspicious-input' em vez de aprovação automática (move
			decisão para human gate quando structural defense é incompleta).
			Signal robustness shift: estruturar RFQ history como signal
			SSC-mantido (não input de fornecedor). Detection backup: act-
			detect-fragmentation-pattern do agent-spec captura padrão
			coordenado de submissions sub-threshold cross-RFQ. Quando NIM
			bootstrap (oq-ssc-1a), incorporar performanceScore +
			reliabilityScore como signals adicionais — manipulation cost
			aumenta com reputation decay.
			"""
		principlesApplied: ["P10", "dp-08"]
		assumptions: [
			"RFQ history é signal disponível ou estruturável como signal SSC-mantido",
			"Cotação RFQ é input estruturado (preço + capacidade declarada), não livre",
			"NPM eligibility é signal robusto (fonte autoritativa externa ao fornecedor)",
		]
		rationale: "Example âncora para vector tier 1 em SSC: input do ator manipulável é fonte primária de signals frágeis. Pattern recomendado generaliza para outros mecanismos com input direto de stakeholder."
	}, {
		id: "ex-bdg-cost-center-masking"
		scenario: """
			Originadora submete compromisso atribuído a Centro de Custo X
			com saldo abundante. Análise do escopo do compromisso (descrição,
			fornecedor, item) sugere que Centro Y restrito seria o atribuível
			correto, mas X foi declarado. Category manager designado tem
			KPI de velocity de aprovação (incentivo para aprovar rápido sem
			questionar atribuição). BDG agente recebe via ACL CMT
			CommitmentAccepted com costCenterId pré-definido.
			"""
		analysis: """
			Incentive-structure mapping: originadora benefit = aprovação
			rápida via Centro X (saldo abundante) em vez de Centro Y
			(potencialmente restrito ou exigindo escalation de Alçada);
			category manager benefit = velocity KPI cumprido sem fricção.
			Manipulation vector = mascarar centro de custo via declaração
			incorreta. Signal-robustness audit: declaração de centro de
			custo é input do submitter — frágil. Signal robusto disponível:
			cross-BC reconciliação CMT escopo + DLV evidência de execução
			(pós-DLV bootstrap). Cost atual: detection latente (apenas
			pós-execução); penalty fraca Phase 0.
			"""
		recommendation: """
			Design response Phase 0 BDG: inv-cost-center-required + bd-cost-
			center-as-sot (já materializados em BDG canvas/domain-model)
			estabelecem invariant. supervisedDecision approve-budget-with-
			cost-center-ambiguity força escalation quando atribuição é
			ambígua (escopo cobre múltiplos centros). Detection backup:
			drift detection metric supervisor-override-rate sustained acima
			de threshold sinaliza padrão sistemático de override de
			validação automática — gera regression trigger via bdg-primary-
			agent.governance.cue. Signal robustness shift pós-DLV bootstrap:
			cross-BC reconciliação CMT escopo + DLV evidência fortalece
			detection. Limitação Phase 0: detection é tardia (pós-aprovação);
			structural fix completo aguarda DLV bootstrap.
			"""
		principlesApplied: ["P10", "dp-08"]
		assumptions: [
			"BDG agent tem operationalScope incluindo prj-cost-center-availability",
			"Cross-BC reconciliação CMT/DLV operacional ou planejada (oq-bdg em domain-model BDG)",
			"OBS metric supervisor-override-rate é coletada e exposta para drift detection",
		]
		rationale: "Example complementar: vector com structural fix parcial Phase 0 — invariant declarado mas detection tardia. Honesto sobre Phase 0 limitations + path de hardening pós-cross-BC bootstrap. Padrão aplicável a qualquer BC com declaração de classification por submitter."
	}]

	// =============================================
	// PRINCIPLE IDS
	// =============================================

	principleIds: ["P10", "dp-08"]

	// =============================================
	// RELATED LENSES
	// =============================================

	relatedLenses: [{
		lensId:   "lens-game-theory-applied"
		relation: "tensionWith"
		context: """
			Game theory aplicada modela equilíbrio estratégico cooperativo
			entre múltiplos agentes; incentive-alignment foca em proteção
			de mecanismo fixo contra manipulation. Tensão: ambas tratam
			comportamento estratégico mas com escopos opostos — equilíbrio
			teórico vs defesa operacional. Agente arbitra: usar game-theory
			para entender dinâmica multi-agente; usar incentive-alignment
			para endurecer mecanismo específico. Tipicamente sequenciais
			(análise teórica primeiro → defesa operacional depois), mas
			não complementares somáveis.
			"""
	}, {
		lensId:   "lens-mechanism-design"
		relation: "tensionWith"
		context: """
			Mechanism design desenha regras do mecanismo para alinhar
			incentivos by construction; incentive-alignment opera DENTRO
			de mecanismo já desenhado. Tensão: redesenhar (mechanism-design)
			vs proteger o existente (incentive-alignment). Boundary
			canônica: mecanismo novo OR redesign substantivo → mechanism-
			design; mecanismo existente com manipulation observada →
			incentive-alignment. Mistura gera redesign desnecessário OR
			defesa em mecanismo mal-desenhado.
			"""
	}, {
		lensId:   "lens-information-economics"
		relation: "complementsWith"
		context: """
			Information economics modela asymmetry e signaling como source
			de manipulation oportunity; incentive-alignment usa essa análise
			para identificar vectors específicos e estruturar design
			response. Capacidades somam: information-economics revela ONDE
			há manipulation oportunity (asymmetry sustentada, signaling
			barato); incentive-alignment estrutura COMO defender. Sequência
			analítica natural: information-economics → incentive-alignment.
			"""
	}, {
		lensId:   "lens-organizational-resource-allocation"
		relation: "feedsInto"
		context: """
			Resource allocation define o que está sendo alocado e por que;
			incentive-alignment protege esse processo de alocação contra
			manipulation. Direcional: allocation produz contexto (oportunidade
			econômica de fornecimento, alocação de orçamento, allocation de
			tempo regulatório) e identifica stakeholders com claim sobre
			recurso; incentive-alignment consome esse contexto para
			identificar vectors específicos e response. Lens primária BC
			(SSC, BDG) tipicamente tem allocation lens primária + incentive-
			alignment como secundária.
			"""
	}]

	// =============================================
	// LIMITATIONS
	// =============================================

	limitations: [{
		description: "Lens não modela equilíbrios cooperativos de longo prazo entre múltiplos agentes — repeated games, coalições, evolução de estratégia em horizonte multi-período."
		alternative: "lens-game-theory-applied"
		rationale:   "Equilíbrio cooperativo requer ferramenta teórica distinta — folk theorems, repeated game equilibria, evolutionary stability. Incentive-alignment é defensiva no curto prazo (proteger mecanismo existente), não estratégica de longo prazo (modelar como agentes co-evoluem)."
	}, {
		description: "Lens não desenha mecanismo de zero — opera dentro de mecanismo já existente. Não cobre revenue equivalence, IC constraints, IR constraints, ou outros theorems de mechanism design."
		alternative: "lens-mechanism-design"
		rationale:   "Quando mecanismo precisa ser redesenhado (regras de auction de zero, incentive structure inicial, escolha de tipo de leilão), mechanism-design tem ferramentas próprias. Incentive-alignment hardens mecanismo existente sem redesenhar regras — assume regras dadas e protege execução."
	}, {
		description: "Lens não cobre manipulation que requer dados históricos para detection — incentive-divergence-detection só funciona com baseline acumulado. Phase 0 limitação reconhecida: detection estatística degrada na ausência de signals históricos."
		alternative: "lens-data-quality-as-competitive-moat (para acumulação de signal data) + Phase 0 mitigation via heurística manual + structural defense priorizada sobre detection"
		rationale:   "Detection estatística depende de baseline. Phase 0 sem dados históricos limita detection a heurísticas manuais ou structural defense. Lens reconhece limitação honestamente — não pretende cobrir o gap, indica caminho (data accumulation + structural priority até detection ser viável)."
	}]

	// =============================================
	// RATIONALE OUTER
	// =============================================

	rationale: """
		lens-incentive-alignment opera entre lens-game-theory-applied
		(equilíbrio estratégico teórico) e lens-mechanism-design (desenho
		de regras): protege mecanismos fixos contra manipulação, detecta
		exploração e estrutura design response sem redesenhar nem teorizar.
		Aplicabilidade Phase 0: vetores adversariais identificados em
		canvases de BCs com decisão automatizada — especialmente SSC, BDG
		e BCs adjacentes de commitment, risk e compliance — análise de
		incentive-structure + manipulation-vector + manipulation-cost
		articulando design-response viável dado mecanismo existente.

		Concepts core (incentive-structure, manipulation-vector,
		manipulation-cost, design-response, signal-robustness, incentive-
		divergence-detection) mapeiam o ciclo defensivo: mapear estrutura
		→ identificar vectors → calcular cost vs benefit → estruturar
		response material → auditar signal robustness → backup detection.
		ReasoningProtocol é sequência adversarial concreta: 'qual a
		structure REAL?' → 'que vectors operam?' → 'que response material?'
		→ 'que signals robustos?' → 'que detection backup?'.

		MeshExamples ancoram dois cenários paradigmáticos: SSC RFQ low-
		balling (input fornecedor manipulável → response via fitness rules
		governadas + RFQ history como signal robusto + detection backup
		via Fracionamento) e BDG cost-center masking (declaração originadora
		manipulável → response via inv-cost-center-required + cross-BC
		reconciliação + drift detection via supervisor-override-rate).
		Ambos honestos sobre Phase 0 limitations e path de hardening pós-
		cross-BC bootstrap.

		Limitations explícitas: (1) lens não modela equilíbrios cooperativos
		de longo prazo (alternative lens-game-theory-applied); (2) lens não
		desenha mecanismo de zero (alternative lens-mechanism-design); (3)
		detection estatística depende de data accumulation (alternative
		lens-data-quality-as-competitive-moat + structural priority Phase 0).
		Lens é OPERADORA analítica para hardening defensivo de mecanismos
		Mesh — não substitui governance, structural-checks ou policies que
		enforçam regras (canonical removal test tq-mg-10: se removermos
		esta lens, invariants permanecem protegidos por outros enforcers?
		Resposta SIM — lens orienta análise, não enforça regra).
		"""
}
