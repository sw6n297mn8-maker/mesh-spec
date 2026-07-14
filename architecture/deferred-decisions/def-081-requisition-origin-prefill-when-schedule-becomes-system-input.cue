package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def081: artifact_schemas.#DeferredDecision & {
	id:     "def-081"
	title:  "Origem da requisição migra de digitação net-new para Generative Form padrão quando o cronograma físico virar input de sistema"
	date:   "2026-07-14"
	status: "open"

	description: """
		A tela de submissão de requisição (adr-178) nasce com a origem em
		DIGITAÇÃO HUMANA — legítima HOJE porque a fonte da informação (o
		cronograma físico do canteiro, observado na visita técnica do
		engenheiro) não existe no sistema até o ato: é o não-padrão de origem
		net-new que o adr-178 instituiu sobre o qualificador 'por padrao' da
		Generative Form da adr-150. Fica deferida a MIGRAÇÃO DE REGIME:
		quando o cronograma físico virar input de sistema (BIM/planejamento
		da obra lido por agente), a origem da requisição SAI do não-padrão
		net-new e ENTRA na Generative Form padrão da adr-150 — form
		pré-preenchido pelo agente a partir do cronograma-no-sistema, com o
		engenheiro confirmando/editando. Sem mudança de shape na superfície
		(o form já nasce pré-preenchível por construção, adr-178 item 4).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o pré-preenchimento por agente exige o
		cronograma DENTRO do sistema — integração de planejamento/BIM que não
		existe e cuja construção antes da 1ª tela inverteria a ordem do arco
		(a informação entra no sistema PELA tela; adr-178 alternativa (c)
		rejeitada). Custo evitado: desenhar integração de planejamento agora,
		sem produto nem fonte definida. Custo de continuar deferindo: janela
		em que a 1ª tela de origem digita do zero — legítima per adr-178
		enquanto o pressuposto (fonte fora do sistema) valer, com o custo de
		UX da digitação e o risco-precedente vigiado pela falsificação (a) do
		adr-178 (net-new virando brecha se a fonte entrar no sistema e a
		origem NÃO migrar).

		NÃO é um deferimento de 'falta o agente': o que muda o regime não é a
		existência de um agente-preenchedor, é o PRESSUPOSTO do critério
		net-new mudar (cronograma passar a existir no sistema). Enquanto a
		fonte é física, nenhum agente teria de onde pré-preencher.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito e declarado): o gatilho real —
		'o cronograma físico virou input de sistema' — é fato de
		produto/integração que só o founder observa; não há predicado de
		disco livre de falso-positivo (trigger de conteúdo sobre
		'cronograma'/'BIM' dispararia em prosa que já menciona os conceitos,
		inclusive este def e o adr-178; trigger de existência cravaria path
		de integração não-desenhada). A âncora de revisita vive no ponto de
		uso: o action-surface-p2p do frontend-codegen-contract v2 e a
		description do POST em contexts/p2p/api.yaml citam def-081 pelo
		número — quem tocar a superfície de origem reencontra a migração.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-178-journey-start-surface-kit-and-net-new-origin.cue",
		"architecture/adrs/adr-150-frontend-ai-first-invariants.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque nada quebra nem bloqueia: a tela funciona, o dado entra,
			o critério net-new do adr-178 mantém a digitação legítima enquanto o
			pressuposto valer — o custo corrente é UX (digitação manual) e a
			vigilância do precedente (review de telas de origem futuras);
			cross-artifact porque a migração, quando disparar, toca spec (o
			regime declarado no adr-178/contrato v2) + frontend-runtime (o
			preenchedor entra no form já pré-preenchível) + a integração de
			planejamento que a habilitar — sem mudança de shape de superfície
			por construção. Exit: quando o cronograma virar input de sistema,
			ADR de resolução move a origem para a Generative Form padrão da
			adr-150 e este def resolve (resolvedBy).
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é fato de produto/integração fora do disco (o cronograma físico passar a existir como input de sistema — BIM/planejamento lido por agente); sem predicado machine-evaluable livre de falso-positivo — conteúdo sobre 'cronograma/BIM' dispararia em prosa que já menciona os conceitos, e existência cravaria path de integração não-desenhada. A revisita está ancorada no ponto de uso: o contrato de codegen v2 (action-surface-p2p) e o POST do api.yaml citam def-081."
	}]
}
