package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do def-074 — deferimento dormente (Ion como wire canônico da persistência
// do EventLog) que converte o sinal "não-rastreado" dos rtds do runtime em
// mecanismo de vigilância. Self-reported: deferred-decision não está no rollout
// do executionPolicy (defaultMode). 1 round, stable, 0 fail.

def074: build_time.#SelfReviewReport & {
	reportId: "srr-def-074-ion-canonical-wire-materialization"

	artifactPath:       "architecture/deferred-decisions/def-074-ion-canonical-wire-materialization.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-02"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			cue vet EXIT=0 (gate determinístico; discriminated union status=open respeitada — auxiliary
			fields ausentes; #Trigger union conforme; #OriginRef union conforme: path .cue + session:).
			MinRunes folgados (description 949; deferralRationale 949; triggerCalibrationRationale 729;
			manual-review.reason 321). uq-01..08 PASS (WHY articulado; specificity test falha substituição
			de tópico — texto nomeia adr-140/Ion-1..4, WI-128/ion-rules.cue, rtd-024/026/029, def-073;
			refs cruzadas verificadas no disco: adr-140 existe, WI-128 no wave-plan com output ion-rules.cue,
			ion-rules.cue corretamente descrito como AUSENTE; zero placeholder). uq-09: sections autoradas
			serialmente per PG workOrder; gates apresentados em batch com auto-checks separados no checkpoint
			(cláusula batch do serializationRule — arco de checkpoint único definido pelo founder).
			tq-def-01 PASS (trade-off concreto: construir a língua antes do dado vs migração de log retido +
			fragilidade JVM); tq-def-02 PASS (triggers codificados); tq-def-03 PASS (temporal 180d
			non-manual-review ao lado do manual-review); tq-def-04 PASS (medium/cross-artifact coerente com
			"~grátis enquanto sintético, caro na retenção" — espelha a calibração founder da família def-073;
			sujeito à confirmação do founder no checkpoint). tq-defg-01/02 PASS (trade-off e gatilho vêm da
			diretiva explícita do founder no arco, não inferidos por similaridade pelo agente); tq-defg-03
			PASS (calibration rationale não-tautológico: por que manual-review, por que NÃO file-exists em
			ion-rules — proxy da execução, não da condição —, por que temporal backstop); tq-defg-04 PASS
			(manual-review justificado: evento vive no runtime sem sensor honesto repo-local). Reconciliação
			PG 3/3: origins rastreáveis à description; severity coerente com rationale; triggers detectam
			exatamente a expiração do motivo de deferir (início da retenção real).
			"""
	}]

	findings: {}

	summary: """
		def-074 — deferimento dormente: materializar o Ion (adr-140 item 3) como wire canônico da
		persistência do EventLog, substituindo o wire provisório Java do runtime (rtd-024/026) e
		removendo os markers Serializable (rtd-029) ao acordar. Gatilho manual-review na entrada de
		dado real/retido (mesma família do def-073) + temporal 180d backstop. Resolve o sinal
		"Ion canônico pendente, não-rastreado como def" dos rtds do runtime (anti-esquecimento
		silencioso, adr-162). Self-reported: 0 fail / 0 warn, stable em 1 round; cue vet EXIT=0.
		"""

	singleRoundRationale: """
		1 round: def dormente de calibração estreita no molde direto dos irmãos def-072/def-073
		(mesma família de gatilho, mesmo desenho manual-review + temporal backstop), com PASS direto
		em todos os critérios. Os eixos de risco — gatilho desonesto (file-exists em ion-rules.cue
		seria proxy da execução do WI-128, não da condição de revisita; rejeitado com rationale
		registrado) e overlap com def-073 (grafo causal, envelope-locus — pergunta distinta de wire
		de serialização) — foram verificados ausentes contra o disco. Sem delta a re-rodar.
		"""
}
