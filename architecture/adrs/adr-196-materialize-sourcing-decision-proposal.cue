package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr196: artifact_schemas.#ADR & {
	id:    "adr-196"
	title: "Materializar a proposta de decisão de sourcing como fato de domínio do ssc"
	date:  "2026-09-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		O agente do ssc prepara a decisão de sourcing sob propose-and-wait
		(act-evaluate-and-conclude-rfq): aplica as fitness rules versionadas
		sobre os signals e produz ranking + allocationPolicy recomendada +
		decisionRationale — e ESPERA o gate humano antes do emit. O output
		dessa preparação, porém, não tem elemento de domínio no ssc: nenhum
		comando o cria, nenhum evento o registra, nenhuma projection o expõe
		(prj-active-sourcing-decisions é PÓS-decisão). O agente prepara para
		o nada observável: a proposta que aguarda ratificação não pode ser
		exibida com procedência, auditada, nem distinguida de rascunho.

		O gap foi verificado e registrado no rationale do passo 7 da
		ds-buyer-procurement-journey (revisão de 2026-09-03, na main): o
		passo do agente entrou na story com commandRefs/eventRefs VAZIOS por
		lacuna honesta (adr-170). O trigger concreto: dois artefatos de
		protótipo divergiram exatamente sobre essa ausência — um encarnou o
		agent-spec (proposta do agente ao comprador), o outro encarnou o
		passo do mapa (comprador comparando sozinho) — porque cada superfície
		foi obrigada a INVENTAR o lado que o modelo não declara. Enquanto a
		proposta não tiver morada canônica, cada tela re-decide a fronteira
		(violação de P0 por construção).

		Alternativas avaliadas: (B) PROJECTION SEM EVENTO — a proposta como
		read model derivado do estado do agente, sem tocar o event stream.
		Rejeitada: projection sem fato de domínio autoritativo inverte a
		doutrina de derivação (projections derivam de eventos); a proposta
		vira exibível mas não auditável — a história do agregado fica muda
		sobre o que o agente propôs, e a auditoria pós-fato depende de log
		operacional fora do modelo. (C) FORA DO MODELO POR DESENHO — declarar
		que proposta pendente é estado do agent-spec, não do domínio, e a UI
		exibe sob marca de não-verificado (declarar limite em vez de fingir
		garantia). Rejeitada como default: é postura honesta e barata, mas
		converte a lacuna num teto permanente de produto — a plataforma cuja
		tese é evidência verificável exibiria sua peça central de preparação
		como não-verificável para sempre; a divergência entre superfícies
		reapareceria a cada tela nova; e def-080 segue sem o contexto
		compensatório. C permanece a POSTURA TRANSITÓRIA legítima até a
		fatia de materialização executar.
		"""

	decision: """
		(1) MATERIALIZAR a proposta de decisão de sourcing como fato de
		domínio do ssc: evento interno (nome indicativo
		evt-sourcing-decision-proposed) emitido pelo agente ao concluir a
		avaliação — ANTES do gate humano — carregando ranking,
		allocationPolicy recomendada, decisionRationale e
		fitnessRuleSnapshot (a mesma carga que a decisão consumada anexa,
		per act-evaluate-and-conclude-rfq).

		(2) PROJECTION da proposta viva com query capability, consultável
		pela superfície de ratificação; carimbada pela decisão quando
		cmd-make-one-shot-sourcing-decision consumar — o molde do
		prj-quotation-map (vivo durante a janela, carimbado pela decisão).

		(3) A MATERIALIZAÇÃO é fatia própria (WI), não este ADR: toca
		contexts/ssc/domain-model.cue (evento + projection), o agent-spec
		(refs do act passam a cobrir o evento novo — o gate sc-ag-02 do
		adr-175 exige a cobertura na mesma fatia) e fecha as refs vazias do
		passo 7 da story. Naming final decide-se na fatia sob o glossário
		do ssc; os nomes deste ADR são indicativos.

		(4) ATÉ a fatia executar, vigora a postura da alternativa C como
		transição declarada: superfícies exibem a proposta sob marca de
		não-verificado, nunca como fato do domínio.
		"""

	consequences: """
		Positivas — P1: a proposta entra na história imutável do agregado;
		a ratificação ganha contexto POR POSIÇÃO no stream (proposta precede
		decisão), o que dá controle compensatório imediato à lacuna do
		decidedBy nominal registrada em def-080 — sem esperar a mecanização
		do campo. P2: a lacuna honesta do passo 7 da story fecha com refs
		reais — o instrumento do adr-170 completa o ciclo (vazio achado →
		decisão → refs preenchidas). P3: a superfície de ratificação exibe a
		proposta COM procedência (fitnessRuleSnapshot + rationale no fato),
		eliminando a marca de não-verificado para esta peça. P4: a fronteira
		agente↔humano ganha morada canônica única — a divergência entre
		protótipos que revelou o gap deixa de ser reinventável por tela (P0).

		Negativas — N1: custo real da fatia: evento + projection no
		domain-model, cobertura no agent-spec (adr-175), propagação às
		superfícies geradas dos runtimes. N2: proposta em história imutável
		exige desenho de cadência na fatia (re-avaliação a cada cotação nova
		emitiria ruído; emitir no fecho da janela ou como re-proposta
		explícita é decisão da fatia). N3: NÃO resolve def-080 — o campo
		decidedBy continua string nominal; este ADR só compensa o caso da
		decisão de sourcing, por posição. N4: o evento é interno
		(confidencialidade competitiva, molde dos fatos de cotação) — a
		auditoria cross-BC continua dependendo do fato consumado, não da
		proposta.
		"""

	falsificationCondition: {
		condition:        "A proposta materializada ficar sem consumidor real (superfície de ratificação ou trilha de auditoria) após a fatia de materialização — evento emitido que nenhuma leitura consome é cerimônia, não evidência."
		observableSignal: "Projection da proposta sem queryCapability consumida por contrato de codegen/superfície na fatia seguinte à materialização."
	}

	affectedArtifacts: [
		"contexts/ssc/domain-model.cue",
		"contexts/ssc/agents/ssc-primary-agent.cue",
		"strategic/domain-stories/buyer-procurement-journey.cue",
	]

	principlesApplied: [
		"P0 — a proposta ganha localização canônica única; sem ela, cada superfície re-decide a fronteira agente↔humano (a divergência entre os dois protótipos foi exatamente esse drift por construção).",
		"P10 — o gate humano (propose-and-wait) passa a operar sobre fato observável do domínio, não sobre estado interno do agente: o que o humano ratifica é inspecionável e determinístico.",
	]

	rationale: """
		Entre as três alternativas, A é a única que honra a tese da cunha —
		'dinheiro só se move quando a operação comprova' (amarração de
		adr-174) — no ponto exato onde o agente prepara o movimento: a
		preparação vira evidência verificável, não efêmero de agente. B
		compraria exibição sem auditoria; C compraria honestidade sem
		evidência. O custo (N1/N2) é o custo normal de uma fatia de
		domain-model e é pago onde a Mesh já paga: no modelo, uma vez, em
		vez de em cada superfície, para sempre. Reversibility medium:
		reverter antes de dados de produção é retrofit de modelo e
		superfícies geradas, sem migração; blastRadius cross-artifact:
		domain-model + agent-spec + story no ssc, sem tocar outros domínios.
		Relação com def-080: dependência nos dois sentidos — este ADR dá o
		controle compensatório por posição no stream; a mecanização do campo
		de ator (def-080) segue necessária para os demais commands e ganha,
		quando vier, o vocabulário do fato proposto.
		"""
}
