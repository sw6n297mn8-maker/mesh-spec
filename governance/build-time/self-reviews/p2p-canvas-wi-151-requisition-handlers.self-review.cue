package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pCanvasWi151RequisitionHandlers: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-canvas-wi-151-requisition-handlers"

	artifactPath:       "contexts/p2p/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da COEVOLUÇÃO do canvas p2p (WI-151):
			+4 command-handlers inbound (SubmitPurchaseRequisition async — a
			PORTA; TriageRequisition sync — ato formal com outcome;
			ApprovePurchase sync — o PORTÃO com Gate de Cobertura pré-pedido
			per adr-174; CancelPurchaseRequisition sync); handler
			EmitPurchaseOrder coevoluído (trigger agora descreve conversão de
			requisição APROVADA em pedido + description cita o gate de 2
			braços) — o trigger antigo descrevia o mundo pré-portão
			('originadora submete demanda estruturada') e ficaria FALSO sob a
			ordem canônica nova; rationale da communication atualizado
			(2 → 6 command-handlers, com papéis nomeados).

			[uq-08 CONFORMÂNCIA]: cue vet EXIT=0; shape command-handler
			idêntico aos existentes (type/interactionMode/trigger/command/
			resultingEvents/description); interactionMode async válido no
			enum #InteractionMode. [uq-03 REFS]: cada command PascalCase dos
			handlers tem par kebab-case no domain-model (tq-dm-12);
			cmd-convert-requisition deliberadamente FORA do canvas (command
			interno de policy — o carve-out que o próprio tq-dm-12 declara).
			[uq-06 UL]: triggers usam a língua da jornada (requisitante,
			comprador, gestor, Centro de Custo, etapa do orçamento, Alçada).
			[uq-05]: janela WI-153 declarada no handler de cancelamento
			(liberação da reserva). [ESCOPO]: query-surfaces INTOCADAS (a fila
			de requisições é read model interno consumido via projection;
			exposição como query-surface do canvas só se demanda cross-context
			emergir — sem invenção de contrato).
			"""
	}]

	findings: {}

	summary: """
		Canvas p2p coevoluído com a fatia da requisição: 4 handlers novos
		(porta → triagem → portão → cancelamento), Emit re-descrito sob a
		ordem canônica do adr-174, contagens do rationale atualizadas.
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: coevolução declarativa espelhando o
		domain-model editado na mesma fatia; a consistência canvas↔domain-model
		é verificada pelo review isolado do adr-174 e pelos criteria tq-dm-11/
		tq-dm-12 do schema na validação integral.
		"""
}
