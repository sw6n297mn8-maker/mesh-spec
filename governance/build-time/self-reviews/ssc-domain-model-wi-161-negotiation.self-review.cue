package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscDomainModelWi161Negotiation: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-domain-model-wi-161-negotiation"

	artifactPath:       "contexts/ssc/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-28"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Round único (precedente das fatias de domínio WI-151/152/adr-177,
		modo self-reported): os critérios verificáveis mecanicamente foram
		provados por gate real na própria fatia (cue vet; runner estrutural
		com sc-ds/sc-ag/sc-fct em reject; verbatim-diff programático do am;
		fidelidade command→event extraída por export e reportada verbatim no
		checkpoint per instrução do founder) e as decisões interpretativas
		foram aprovadas explicitamente pelo founder na proposta consolidada
		com 3 calibrações — a dimensão restante é o founder review final da
		fatia, gate humano que rounds adicionais de self-review não
		substituem.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da NEGOCIAÇÃO (WI-161, passo 8 da
			ds-buyer-procurement-journey; o único pedaço de modelagem-do-zero
			do arco): +3 commands intra-open (cmd-propose-counter-terms do
			comprador; cmd-revise-quotation e cmd-decline-counter-terms do
			fornecedor — molde exato de submit/withdraw), +3 events INTERNAL
			(mesmo veto de confidencialidade dos fatos de cotação: um
			fornecedor jamais vê a negociação do outro), +3 VOs
			(vo-payment-terms com termScheduleDays lista NÃO-VAZIA e
			ESTRITAMENTE CRESCENTE per calibração 2 do founder;
			vo-delivery-schedule com entries derivando volume total por soma;
			vo-counter-terms com ≥1 eixo por invariante de handler), +1
			invariant (inv-negotiated-terms-materialize-on-quotation — a
			regra de ouro: contraproposta NUNCA muta a cotação; só a revisão
			do fornecedor materializa condições na ent-quotation, preservando
			quotationId e o gate de procedência do adr-177 por construção).
			ent-quotation ganha paymentTerms/deliverySchedule (opcionais) +
			revisionNumber/lastRevisedAt; cmd-submit-quotation ganha os 2
			opcionais (calibração 3 — fidelidade aos passos 6/7 da story:
			'preço, prazo e condições de pagamento' antes só prosa em
			termsNotes). Lifecycle do aggregate INALTERADO (negotiating é
			micro-state intra-open, mesmo design de receiving/evaluating);
			status da ent-quotation INALTERADO (revisão não é lifecycle).
			Wiring completo: handlesCommands 8→11, emitsEvents 9→12,
			protectsInvariants 7→8, usesValueObjects 15→18;
			prj-quotation-map consome os 3 fatos novos (rodadas + preço
			inicial vs vigente); rationale raiz e header coevoluídos SEM
			prosa stale de contagem (lição WI-151) — incluindo o caveat
			multi-round reescrito com precisão: BAFO formal segue oq-ssc-9
			(a negociação bilateral reduz a pressão sem resolvê-lo).
			Fidelidade command→event verificada campo a campo (reporte
			verbatim no checkpoint per instrução do founder — sem gate
			mecânico para esta dimensão). cue vet ./... PASS.
			"""
	}]

	findings: {}

	summary: """
		Modelagem da negociação autorada manualmente na fatia (precedente
		WI-151/152/adr-177 para updates de instância; dispatch é para
		criação — escolha declarada na proposta), sob aprovação explícita
		do founder com 3 calibrações confirmadas (decline mantido;
		payment-terms com invariante de lista crescente; submit estendido).
		A decisão estrutural central — condições negociadas materializam
		SOMENTE via revisão do fornecedor na casa canônica do preço (P0) —
		preserva o elo requisição↔cotação do adr-177 sem tocar o adr:
		classificação instanciação, sem ADR novo (precedente WI-152).
		"""
}
