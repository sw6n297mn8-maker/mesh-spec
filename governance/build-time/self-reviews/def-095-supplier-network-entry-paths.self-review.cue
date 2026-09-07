package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def095SupplierNetworkEntryPaths: build_time.#SelfReviewReport & {
	reportId: "srr-def-095-supplier-network-entry-paths"

	artifactPath:       "architecture/deferred-decisions/def-095-supplier-network-entry-paths.cue"
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
			1 fail corrigido: a primeira redação tratava o passo 4 da story
			como ERRADO ('a story diz o contrário do sistema'). O founder
			corrigiu a moldura: a entrada tem VÁRIOS caminhos legítimos e a
			story descreve um deles como se fosse o único — o defeito não é
			de fidelidade, é de completude. Reescrito como território
			nomeado, com cada caminho medido contra o modelo em vez de um
			veredito sobre a story.
			"""
	}, {
		round:     2
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido: o rascunho tratava o caminho (3) — o convite
			arrastando o não-qualificado — como LACUNA, igual aos caminhos
			(4) e (5). A medição mostrou que não é: inv-qualification-as-
			absolute-precondition o PROÍBE ('nenhum fornecedor entra em RFQ
			sem status eligible-for-sourcing'), e o glossário do ssc
			reforça. Reclassificado como CONTRA-INVARIANTE — abri-lo muda
			contrato, não preenche vazio. A distinção importa: ausência e
			proibição não custam a mesma coisa para reverter.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Zero fails, zero warns. tq-def-03 NÃO dispara: além do
			manual-review há um adjacent-need machine-evaluable
			(file-contains categoryRef em contexts/npm/domain-model.cue).
			Verificado no runner: o trigger avalia e NÃO dispara — confirma
			por execução a medição de que a qualificação por categoria não
			existe. Calibração high ratificada pelo founder com o
			argumento que fecha o contra-argumento: 'nada quebra porque
			nada está entrando' — ausência de fornecedores não é dívida
			acumulando, é o produto não funcionando. Correção mecânica de
			sintaxe no caminho: #AdjacentCondition é objeto aninhado, não
			campos planos (cue vet pegou; não exigiu novo ciclo).
			#TriggerStrict ✓; cue vet ✓.
			"""
	}]

	findings: {}

	summary: """
		def-095 nomeia os cinco caminhos de entrada do fornecedor na rede e
		mede cada um contra o modelo: (1) auto-registro SUSTENTADO — e é o
		único que o sistema executa, e o que a story não descreve; (2)
		compradora puxa NÃO SUSTENTADO — e é o que a story descreve; (3)
		convite arrasta CONTRA-INVARIANTE; (4) rede propõe e (5) indicação
		AUSENTES. A pergunta dos dois estados tem resposta em dois eixos
		com maturidades diferentes: cadastro↔qualificação JÁ distinguidos
		(lifecycle de 4 estados, glossário do ssc nomeia); qualificação↔
		categoria NÃO EXISTE (categoryRef ausente do npm, oq-ssc-6 aberta,
		e o dev serve anuncia o pool como category-agnostic). O def defere
		a ESCOLHA das portas, não a modelagem — e registra o custo que a
		motiva: cada caminho é uma tela diferente, e o primeiro construído
		fecha a porta dos outros. Precedente de forma citado (passo 7 da
		ds-buyer-procurement-journey) com o instrumento trocado: a
		divergência não é entre dois protótipos, é entre a story e o
		sistema em execução, exposta pela travessia da borda do dev serve.
		"""
}
