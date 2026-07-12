package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

p2pGlossaryWi151TermRequisicao: build_time.#SelfReviewReport & {
	reportId: "srr-p2p-glossary-wi-151-term-requisicao"

	artifactPath:       "contexts/p2p/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

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
			Round 1 — self-review do term-requisicao (WI-151): 16º term do
			glossário p2p, category entity (identidade + lifecycle → mapeia
			agg-purchase-requisition), posicionado junto às entities
			(após term-purchase-order). Definition cobre a PORTA inteira
			(canteiro → triagem formal → portão do adr-174 → conversão) com o
			lifecycle canônico; antiTerms fecham as duas boundaries que mais
			confundem (Pedido de Compra — a requisição nunca chega ao
			fornecedor; Cotação — SSC, depois da triagem); relatedTerms ligam
			os roles que a vivem (term-requisitante, term-comprador) e o
			destino (term-purchase-order, term-po-lifecycle).

			[uq-08 CONFORMÂNCIA]: cue vet EXIT=0; code term-requisicao passa o
			regex (sem acento — precedente term-comprador/term-requisitante);
			termEn 'Purchase Requisition' sem hífen (lição da fatia adr-173).
			[uq-03]: relatedTerms existem todos no próprio glossário. [uq-06]:
			'Requisição de Compra' é o vocabulário canônico procurement BR que
			o subdomínio p2p já declarava — o glossário nomeia o que ganhou lar
			de escrita, coerência UL↔domain-model em par no mesmo commit.
			[COEVOLUÇÃO DE CONTAGEM]: rationale do glossário atualizado (15 →
			16 terms; distribuição 2 → 3 entities; escopo Phase 0 anotado com a
			ampliação WI-151); glossary alignment do domain-model atualizado em
			par (16 terms + mapeamento term-requisicao → agg/vo/lifecycle).
			[uq-07]: zero placeholder; rationale registra o porquê (o vazio que
			a story revelou — 'requisi' tinha zero ocorrências).
			"""
	}]

	findings: {}

	summary: """
		term-requisicao criado como entity no glossário p2p com boundaries
		explícitas (PO, Cotação) e contagens coevoluídas (16 terms, 3 entities)
		em par com o domain-model. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: 1 term novo nomeando conceito materializado
		na mesma fatia, com molde estrutural dos 15 terms existentes; a
		consistência UL↔domain-model é verificada no review isolado do adr-174.
		"""
}
