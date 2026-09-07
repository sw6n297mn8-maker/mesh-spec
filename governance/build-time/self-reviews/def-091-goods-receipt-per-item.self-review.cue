package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def091GoodsReceiptPerItem: build_time.#SelfReviewReport & {
	reportId: "srr-def-091-goods-receipt-per-item"

	artifactPath:       "architecture/deferred-decisions/def-091-goods-receipt-per-item.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-07"

	roundsExecuted: 3
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
	}, {
		round:     3
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Passe de 2026-09-07 — SEGUNDA FRENTE (a forma do aceite),
			por comando do founder. 1 fail corrigido na redação: o rascunho
			tratava a ausência de cerimônia bilateral no dlv como PROVA de
			que a EntregaScreen errou. O founder corrigiu a premissa: nenhum
			dos dois artefatos foi testado contra a realidade, e o aceite
			bilateral é da tese — o modelo pode estar atrás dela. Reescrito
			como divergência em ABERTO com as duas leituras nomeadas e
			nenhuma decidida. A medição que sustenta a correção: 'aceite
			bilateral' EXISTE no repo (subdomains/p2p.cue 'compromisso é
			acordo bilateral com aceite mútuo'; subdomains/cmt.cue
			'confirmação bilateral', 'invariantes de aceite mútuo',
			'aceite bilateral registrado com integridade criptográfica via
			CAS/DSSE') — mora no cmt, sobre o COMPROMISSO, e o cmt declara
			'não verifica execução operacional (DLV)'. A questão deixa de
			ser 'o modelo tem ou não tem' e passa a ser 'em que nível o
			aceite incide' — moldura mais precisa que a do rascunho.
			severity intocada (high): a frente nova não acrescenta custo
			cumulativo próprio. #TriggerStrict ✓; cue vet ✓.
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

		2026-09-07: o def ganha SEGUNDA FRENTE — a forma do aceite —, por
		comando do founder ao derivar a story do fornecedor. A EntregaScreen
		afirma um evt-delivery-accepted inexistente em contexts/; o dlv
		verifica por evidência sem cerimônia bilateral. As duas leituras
		ficam nomeadas e NENHUMA decidida, porque nenhum dos dois artefatos
		foi testado contra a realidade. O def passa a cobrir granularidade
		E cerimônia, e a fatia futura decide as duas juntas — o saldo por
		item não se modela sob forma de aceite não escolhida. A story do
		fornecedor declara isto como limite em vez de escolher, no molde do
		passo 7 da ds-buyer-procurement-journey.
		"""
}
