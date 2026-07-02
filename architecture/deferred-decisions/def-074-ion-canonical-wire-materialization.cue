package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def074: artifact_schemas.#DeferredDecision & {
	id:     "def-074"
	title:  "Materialização do Ion como wire canônico da persistência do EventLog"
	date:   "2026-07-02"
	status: "open"

	description: """
		adr-140 item 3 adota Amazon Ion como serialização canônica de payload
		(regras Ion-1..4) e WI-128 (W001, aberto, não-executado) planeja
		architecture/shared-schemas/ion-rules.cue — que ainda não existe. Enquanto
		isso, o runtime persiste eventos do EventLog com um wire PROVISÓRIO de Java
		serialization (mesh-runtime rtd-024/rtd-026), escorado por markers
		java.io.Serializable emitidos pelo gerador em todos os domain-types
		(rtd-029 — andaime transiente declarado). Fica deferida a MATERIALIZAÇÃO do
		Ion como wire da persistência do EventLog, substituindo o wire provisório.
		Escopo nomeado ao acordar (não executado aqui): (a) ion-rules.cue (o output
		do WI-128); (b) codegen emitindo serialização Ion POR TIPO — código gerado
		explícito, SEM reflection (lint-gate do runtime); (c) os adapters
		persistentes do runtime trocando o wire Java→Ion; (d) a REMOÇÃO dos markers
		Serializable do gerador — o andaime rtd-029 reverte junto.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: adr-140 explicitamente NÃO vincula o bootstrap
		slice — materializar ion-rules + codegen de serialização + troca de adapter
		agora seria construir a língua canônica antes de existir dado que a exija,
		no exato ponto em que o organismo é sintético/descartável. O wire Java
		provisório está DECLARADO e contido (rtd-026), e o custo de trocá-lo
		enquanto o dado é sintético é ~zero: troca de língua = descartar e regerar.
		Custo de continuar deferindo ALÉM da retenção real: alto — migração de wire
		sobre dado retido (reler o log inteiro em Java e regravar em Ion) e retenção
		prolongada num formato acoplado a classes JVM (fragilidade de evolução de
		schema). Este def é o mecanismo de vigilância que faltava: os rtds do
		runtime (rtd-024/026/029) registraram o sinal "Ion canônico pendente,
		NÃO-rastreado como def" — sinal solto sem mecanismo é esquecimento
		silencioso (adr-162). Este def RESOLVE esse sinal.
		"""

	triggerCalibrationRationale: """
		Mesma família de gatilho do def-073 (ancorada na entrada de dado real
		retido): o Ion tem que chegar ANTES do primeiro fato que não se descarta,
		porque dado retido torna a troca de wire cara e o formato provisório vira
		passivo permanente. O evento real vive no runtime (a transição para
		retenção real), sem sensor honesto no runner repo-local do mesh-spec — por
		isso manual-review + temporal 180d de backstop anti-limbo (mesmo desenho de
		def-072/def-073). Um adjacent-need file-exists em ion-rules.cue foi
		considerado e REJEITADO: dispararia na EXECUÇÃO do WI-128 (o trabalho já
		começado), não na condição de negócio que torna o trabalho devido —
		proxy-falso, mesma razão que def-072 recusou sensor artificial.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-140-codegen-contracts.cue",
		"session:fatia-2-ion-wire-vigilancia",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			medium porque enquanto o dado é sintético a troca de wire é ~grátis
			(descarta e regera — rtd-026); vira cara na entrada de dado retido
			(migração do log + fragilidade do formato Java para retenção).
			cross-artifact porque o wire cruza o codegen (emissão por tipo), os
			adapters persistentes do runtime, os markers rtd-029 e o contrato de
			payload de adr-140 (Ion-1..4).
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Entrada de dado REAL/RETIDO no organismo (mesma família do def-073): dado sintético é descartável (troca de língua = descartar e regerar); dado retido torna a troca de wire cara — o Ion deve materializar ANTES do primeiro fato que não se descarta. Evento vive no runtime; founder revisita na transição para retenção real."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
