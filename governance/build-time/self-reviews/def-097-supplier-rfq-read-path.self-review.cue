package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def097SupplierRfqReadPath: build_time.#SelfReviewReport & {
	reportId: "srr-def-097-supplier-rfq-read-path"

	artifactPath:       "architecture/deferred-decisions/def-097-supplier-rfq-read-path.cue"
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
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido: o rascunho tratava isto como o mesmo achado que
			a story do fornecedor JÁ declarava no passo 4 — 'o veículo da
			notificação não está modelado'. Não é. Veículo é como o aviso
			CHEGA; o que falta aqui é a SUPERFÍCIE que o fornecedor consulta.
			Um push por e-mail resolveria o primeiro e deixaria o segundo
			intacto. A distinção entrou na description, senão o def leria
			como duplicata de algo já registrado e seria descartado por isso.
			"""
	}, {
		round:     2
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido na FORÇA DA EVIDÊNCIA: a primeira redação
			afirmava a lacuna pela ausência das projections, o que é
			argumento negativo — sempre se pode alegar que a leitura vive
			noutro lugar não procurado. Acrescentada a consequência MECÂNICA
			medida no contrato: cmd-submit-quotation exige o campo rfqId
			(fields verificados por cue export), e nenhum caminho de leitura
			do ssc o entrega ao fornecedor. Isso é afirmação positiva e
			falsificável — basta um endpoint que devolva rfqId ao fornecedor
			para derrubá-la. O api.yaml foi conferido: 8 endpoints, 2 de
			leitura, nenhum do lado vendedor.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Zero fails. Trigger adjacent-need verificado POR EXECUÇÃO no
			runner: 'no match for supplierRef.*projection|projections.*
			supplierRef' — não dispara, o que confirma pela própria execução
			a medição de que nenhuma projection do ssc é escopada por
			fornecedor. O trigger não é o gatilho da decisão: é o gatilho de
			DETECTAR que ela foi tomada por fora, sem passar por este def.
			Calibração high proposta e MARCADA como minha, para revisão do
			founder — o contraste com o def-096 (medium, mesmo commit) está
			escrito na própria costOfDeferral, e a régua usada é a que o
			founder aplicou ao def-095. cue vet ✓; 1 de 97 defs dispara no
			runner (def-075, pré-existente, warn-only).
			"""
	}]

	findings: {}

	summary: """
		def-097 nomeia o território de que o fornecedor convidado não tem por
		onde ler a RFQ. A medição é exaustiva e por execução: as quatro
		projections do ssc, uma a uma, com quem cada uma serve — duas para
		P2P/CTR/auditoria, uma 'read model INTERNO' explicitamente 'não input
		do fornecedor', e o mapa 'NUNCA exposto a fornecedores'. E o api.yaml
		confirmando pela borda: 8 endpoints, 2 de leitura, nenhum do lado
		vendedor.

		O achado que transforma isto de lacuna narrativa em dependência
		impossível: cmd-submit-quotation EXIGE rfqId. O passo 5 da story do
		fornecedor depende de um identificador que o passo 4 não tem como
		obter.

		O agravante é de GOVERNANÇA, e é o que mais pesa na calibração: a
		lacuna já está preenchida por decisão runtime-local — o dev serve do
		mesh-runtime materializou um stand-in de pull, e a tela do modo
		supplier já o consome. O contrato não tem a leitura, o runtime
		inventou uma, e a tela está de pé sobre ela. É a inversão que a
		fronteira entre os repos existe para impedir, e cada dia de
		adiamento acrescenta superfície sobre ela.

		Quatro formas nomeadas, nenhuma escolhida, e o def declara
		explicitamente que NÃO julga o stand-in do runtime — foi decisão
		local legítima na ausência de contrato.
		"""
}
