package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dsBuyerProcurementJourneyStep9BilateralSplit: build_time.#SelfReviewReport & {
	reportId: "srr-ds-buyer-procurement-journey-step9-bilateral-split"

	artifactPath:       "strategic/domain-stories/buyer-procurement-journey.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-story.cue"
	artifactType:       "domain-story"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-07"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido na FORMA da correção. O rascunho desdobrava o
			passo 9 em dois (9a comprador / 9b fornecedor), o que criaria um
			passo com actorRef sh-02 DENTRO da story do comprador —
			exatamente o que a decisão de story própria evita — e
			renumeraria os passos 10-12, multiplicando a dívida de citação
			que a fatia anterior acabara de sanear. Trocado pela Forma B:
			os dois comandos do fornecedor SAEM, e a bilateralidade é
			declarada como aresta entre as duas stories.
			MEDIÇÃO QUE ELIMINOU UMA TERCEIRA FORMA: o #StoryStep tem UM
			actorRef e nenhum campo de contraparte — 'ator secundário' não
			cabe sem emenda de schema, que seria ADR próprio. Reportado como
			lacuna de schema em vez de improvisado.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Zero fails. Os eventRefs PERMANECEM os três, por decisão do
			founder e com a razão registrada no rationale: aqui são fatos
			que o passo CONSOME, não produz — a fila do comprador 'distingue
			manteve de aguardando' (rationale do cmd-decline-counter-terms),
			e tirar os eventos tiraria o que ele lê. A distinção
			produz/consome não tem campo no schema; vive na prosa, e está
			dita. cue vet ✓; structural-check-runner no baseline de 31
			warns / 0 bloqueantes.
			"""
	}]

	findings: {}

	summary: """
		Correção do passo 9: commandRefs passa de três para um. O achado é
		que o passo atribuía a sh-08 dois comandos que o modelo IMPEDE
		sh-08 de invocar — cmd-revise-quotation e cmd-decline-counter-terms
		são declarados atos do FORNECEDOR no domain-model ('supplierRef
		deve match'), e a inv-negotiated-terms-materialize-on-quotation faz
		disso lei estrutural: 'nenhum caminho de escrita do comprador
		alcança a ent-quotation'. Não era imprecisão de prosa; era o passo
		afirmando o que o modelo proíbe.

		O rationale anterior antecipava a objeção e resolvia só um dos três
		comandos ('quem invoca cmd-propose-counter-terms segue sendo sh-08,
		por isso as refs não mudam') — a frase foi substituída, não
		apagada: a revisão de 2026-09-07 fica ao lado da de 2026-09-03,
		preservando a proveniência de ambas.

		Escrito no MESMO commit que criou a ds-supplier-network-journey,
		sob o princípio que o founder registrou ao aprovar: refs não se
		movem em dois tempos. Separar os commits deixaria dois atos do
		domínio sem pertencer a story nenhuma — estado que nenhum gate pega
		e qualquer leitor pega.
		"""
}
