package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dsSupplierNetworkJourney: build_time.#SelfReviewReport & {
	reportId: "srr-ds-supplier-network-journey"

	artifactPath:       "strategic/domain-stories/supplier-network-journey.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-story.cue"
	artifactType:       "domain-story"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-07"

	roundsExecuted: 4
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido: o rascunho dava commandRefs ao passo 3 (a
			espera pela qualificação), referenciando cmd-record-identity-
			verification e cmd-approve-qualification. São atos de ops/
			comprador — pô-los sob actorRef sh-02 repetiria EXATAMENTE o
			defeito que a correção do passo 9 da story do comprador desfez
			no mesmo commit: comando sob ator que o modelo impede de
			invocá-lo. Esvaziado, com a natureza da lacuna declarada no
			rationale.
			"""
	}, {
		round:     2
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido: os refs vazios estavam todos rotulados
			'lacuna honesta' sem distinguir NATUREZAS diferentes. Nos
			passos 4, 6 e 9 o vazio significa 'receber não é ato' — não
			falta nada ao modelo; no passo 3 significa 'o comando existe e
			é de outro ator'. Tratá-los igual esconderia que um é forma da
			narrativa e o outro é fronteira de autoria. A distinção entrou
			nos rationales dos passos e no rationale da story.
			"""
	}, {
		round:     3
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido: a ausência de passo entre a adjudicação (A5) e
			o pedido (A6) estava implícita — um leitor a tomaria por
			esquecimento e a preencheria. Explicitada no rationale do passo
			9: não há 'o fornecedor soube que venceu' porque
			evt-sourcing-decision-made é internal por confidencialidade
			competitiva, e o PEDIDO é o canal. A ausência é forma imposta
			pela confidencialidade, não lacuna de cobertura — e está
			registrada como tal para que ninguém a preencha por engano.
			"""
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Zero fails, zero warns. REFS VERIFICADOS POR EXECUÇÃO, não por
			leitura: o structural-check-runner foi rodado com um ref
			deliberadamente falso injetado no passo 5
			(cmd-inexistente-de-proposito), e mordeu — '1 bloqueante',
			nomeando item, campo e BC do escopo. Restaurado, voltou ao
			baseline de 31 warns / 0 bloqueantes, provando que os 10 passos
			resolvem contra os domain-models de npm/ssc/p2p/dlv. cue vet ✓.
			"""
	}]

	findings: {}

	summary: """
		ds-supplier-network-journey é a segunda domain story do repo e a
		primeira do lado-vendedor. Story PRÓPRIA por decisão do founder: o
		ator, o ciclo e os comandos são outros, e as duas se cruzam nas
		ARESTAS BILATERAIS — que são o produto principal da derivação,
		porque são elas que o protótipo pode testar. Sete arestas nomeadas,
		duas assimétricas POR DESIGN (A2 proposta e A5 adjudicação
		atravessam eventos internal por confidencialidade competitiva) e
		uma órfã (A7 entrega: o fornecedor tem passo, o comprador não tem
		correspondente em story alguma).

		Escrita no MESMO commit que corrigiu o passo 9 da story do
		comprador, por decisão do founder e sob o princípio que ele
		registrou: refs não se movem em dois tempos — tirar de um lado e
		pôr no outro é uma operação só, mesmo quando o trabalho que a
		produziu teve etapas. cmd-revise-quotation e cmd-decline-counter-
		terms nunca ficaram sem passo.

		Achado que contrariou a expectativa: o fornecedor TEM ato próprio
		na entrega (cmd-record-evidence declara 'direct submission por
		sh-02/sh-01' como caminho alternativo). Eu previa que não tinha.

		subdomainRef=ssc por centro de gravidade dos atos (3 ssc, 2 npm, 1
		dlv) e porque o ssc possui o processo competitivo que o fornecedor
		atravessa repetidamente, enquanto o npm é portão cruzado uma vez.
		JULGAMENTO, não derivação mecânica — o schema não dá critério, e
		vale como ponto de revisão do founder.

		Dois limites declarados em vez de escolhidos: o caminho de entrada
		(def-095 nomeia cinco; o passo 1 narra o único sustentado) e a
		forma do aceite na entrega (def-091 segunda frente; o passo 10
		declara a divergência em aberto). Ambos no molde do passo 7 da
		ds-buyer-procurement-journey, cuja falha registrada — 'a story era
		a fonte de ambos e não decidia entre eles' — foi evitada de
		propósito.
		"""
}
