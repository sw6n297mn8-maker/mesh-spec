package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

cmtGlossary: build_time.#SelfReviewReport & {
	reportId: "srr-cmt-glossary"

	artifactPath:       "contexts/cmt/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-16"

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
			glossario cmt na onda 1 do backfill Forma A (adr-151 passo vi): +6 termos-comando
			(cancelar/suspender/reativar-compromisso, sinalizar-risco, limpar-flag-risco,
			tratar-resolucao-disputa), cada um dando cobertura dedicada (G1) ao command owned
			homonimo do cmt sem termo previo. Universais uq-01..09 + type-specific de glossary.
			PASS: cada termo tem termEn == coreNoun do command (norm-exato) e domainModelRefs
			apontando o code (G1 exige a referencia); definition substantiva (acao canonica +
			efeito no lifecycle); rationale registra POR QUE (uq-01) -- ex. cancelar e terminal
			vs suspender reversivel; category "command" coerente; relatedTerms resolvem (term-
			compromisso + pares irmaos in-file). #5 confirmado: term-suspender-compromisso
			(verbo "Suspend Commitment") coexiste com term-suspensao-compromisso (substantivo
			"Commitment Suspension") sem colisao -- norm() exato distingue. uq-06 (ubiquitous
			language): vocabulario de commitment lifecycle consistente. cue vet EXIT=0 + o
			evaluator first-class-traceability validado contra o disco: report VAZIO (os 12
			owned do cmt passam G1 com os 6 ja-ref + 6 novos termos; 8 foreign G1-isentos). 0
			fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Edicao do glossario cmt na onda 1 do backfill Forma A (adr-151 passo vi): 6 termos-
		comando novos dando cobertura dedicada (G1) aos commands owned do cmt antes sem termo.
		Self-review self-reported em 1 round: uq-01..09 + criterios de glossary contra o disco,
		0 fail / 0 warn. Fidelidade provada pelo evaluator (report VAZIO apos a onda; dívida
		migra worklist->coberto). cue vet EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: edicao aditiva de 6 termos declarativos conformando ao #Glossary (cue vet
		EXIT=0), cada um com termEn==coreNoun + ref (G1) e rationale substantivo; comportamento
		do gate validado empiricamente (evaluator report vazio pos-onda). Nenhum finding tocou a
		substancia; round unico porque os termos sao declarativos e o gate foi validado a parte.
		"""
}
