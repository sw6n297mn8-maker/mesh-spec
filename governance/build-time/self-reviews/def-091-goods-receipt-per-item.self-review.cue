package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def091GoodsReceiptPerItem: build_time.#SelfReviewReport & {
	reportId: "srr-def-091-goods-receipt-per-item"

	artifactPath:       "architecture/deferred-decisions/def-091-goods-receipt-per-item.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-06"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			1 fail corrigido: o caso do caminhão e as fontes viviam em
			comando pré-compactação irrecuperável do transcript — a lacuna
			foi DECLARADA na proposta em vez de fabricada (fabricar falharia
			uq-02/tq-def-01), e o founder recolou o caso verbatim na
			aprovação; o def o carrega integral. Fontes incorporadas com o
			marcador exigido pelo founder: PESQUISA EXTERNA NÃO VERIFICADA
			CONTRA NORMA PRIMÁRIA (secundárias).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Warn tq-def-03 (manual-only) mantido. Calibração
			CORRIGIDA pelo founder na aprovação: severity high (não medium) —
			único def do passe em que o custo do adiamento é pagamento
			indevido, não retrabalho; high+cross-cutting é combo coerente
			para tq-def-04. #TriggerStrict ✓; cue vet ✓.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Trigger manual-review-only: a revisita depende de def-087 entregar a forma do item e do founder abrir o arco pós-PO — sequenciamento, não fato de disco."
			rationale:   "Warn aceito com precedente (def-079/087/088, mesma classe); articulado em triggerCalibrationRationale."
		}]
	}

	summary: """
		def-091 registra o recebimento por item — o elo onde a cadeia de
		evidência muda de granularidade exatamente onde o dinheiro se move.
		Caso do caminhão (Vedacit, 300 de 400 m²) verbatim do founder;
		fontes secundárias marcadas como não verificadas contra norma
		primária; severity high por calibração explícita do founder
		(pagamento contra fato não provado fere a tese da empresa). Depende
		de def-087.
		"""
}
