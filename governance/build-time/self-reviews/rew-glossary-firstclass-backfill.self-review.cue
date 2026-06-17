package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

rewGlossaryFirstClassBackfill: build_time.#SelfReviewReport & {
	reportId: "srr-rew-glossary-firstclass-backfill"

	artifactPath:       "contexts/rew/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-17"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- self-review self-reported (rollout default p/ glossary) da edicao do
			glossario rew na onda 4 (ULTIMA) do backfill Forma A (adr-151 passo vi). SRR sob nome
			QUALIFICADO (rew-glossary-firstclass-backfill) -- o rew-glossary.self-review.cue de
			authoring ja existe; colisao evitada por construcao. Edicao: +9 termos novos (1 entity:
			avaliacao-de-risco; 3 command: solicitar/superseder-avaliacao-de-risco,
			marcar-avaliacao-stale; 5 event: sinal-recebido, avaliacao-de-risco-computada/emitida/
			superseded/marcada-stale), 0 add-ref. Onda 4 e 100% owned (0 foreign; o REW e o DONO dos
			counterparty-risk que o cmt consumia como foreign). reason 9x risk (o REW e
			monoliticamente avaliacao-de-risco -- cada conceito cruza contrato por avaliar/sinalizar
			risco; emit=risk nao eligibility [eligibility e um campo vo-eligibility-decision, nao a
			natureza]; cluster supersede/stale=risk nao governance [ciclo de vida natural da
			avaliacao, nao supervisao humana como o cluster de excecao do dlv]).
			SOURCE-ANCHORED (licao da fce aplicada de saida): cada definition citou a linha-fonte
			(domain-model L / invariante) ANTES da aprovacao do founder -- verificacao definicao-vs-
			fonte aconteceu antes, nao depois. Distincoes do REW capturadas fielmente: Computed !=
			Emitted (L140), Received != observed (L105-106), Stale != Superseded (L201 vs L184),
			'evento pode duplicar; decisao nao' (L164/L185); o evt-risk-evaluation-emitted reflete o
			CONSOLIDADO do adr-149 (UM fato atomico score+eligibility+confidence, ex-RiskScoreEmitted
			+ EligibilityEmitted, L164), nao os 4 eventos antigos. Loanwords stale/supersede mantidos
			(o dominio os usa como termos canonicos distintos de obsoleto/substituido genericos --
			aportuguesar criaria a divergencia glossario-vs-uso que o adr-151 previne). PASS: cada
			termo novo tem termEn == coreNoun do conceito (norm-exato, coreNoun limpo sem descritor) e
			domainModelRefs apontando o code (G1); category entity/command/event coerente;
			relatedTerms resolvem (componentes existentes Risk Score/Eligibility Decision/Confidence
			Interval/Signal/Applicable Context + irmaos). Verificado: os 9 termEns/codes nao colidem
			com os 12 existentes -> sem G3, sem code-clash. cue vet EXIT=0 + evaluator
			first-class-traceability contra o disco: report VAZIO. MARCO: esta onda ZERA a worklist
			(48 conceitos cobertos: 20 cmt + 11 dlv + 8 fce + 9 rew); report vazio COM worklist vazia
			= zero cross-contract sem Forma A, casa 100% coberta -- pre-requisito do flip
			warn->reject (ato final do adr-151, peca separada). 0 fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Edicao do glossario rew na onda 4 (ULTIMA) do backfill Forma A (adr-151 passo vi): 9 termos
		novos (1 entity + 3 command + 5 event) dando cobertura dedicada (G1) aos 9 conceitos
		cross-contract owned do rew, todos reason risk. Definitions source-anchored (cada uma citou
		domain-model L / invariante antes da aprovacao -- licao da fce); o emit reflete o consolidado
		do adr-149 (um fato atomico, nao 4 eventos). SRR sob nome qualificado. Self-review
		self-reported em 1 round: uq-01..09 + criterios de glossary contra o disco, 0 fail / 0 warn.
		Fidelidade provada pelo evaluator (report VAZIO). MARCO: a worklist ZERA (48 conceitos
		cobertos nas 4 ondas) -- pre-requisito do flip warn->reject. cue vet EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: edicao aditiva de 9 termos declarativos conformando ao #Glossary (cue vet EXIT=0),
		cada termo com termEn==coreNoun + ref (G1) e rationale substantivo source-anchored;
		comportamento do gate validado empiricamente (evaluator report vazio pos-onda, worklist
		vazia). Nenhum finding tocou a substancia; round unico porque os termos sao declarativos, as
		definicoes foram verificadas contra a fonte ANTES da aprovacao (licao da fce), e o gate foi
		validado a parte.
		"""
}
