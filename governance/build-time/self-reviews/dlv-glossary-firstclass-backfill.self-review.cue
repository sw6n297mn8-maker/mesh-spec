package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

dlvGlossaryFirstClassBackfill: build_time.#SelfReviewReport & {
	reportId: "srr-dlv-glossary-firstclass-backfill"

	artifactPath:       "contexts/dlv/glossary.cue"
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
			glossario dlv na onda 2 do backfill Forma A (adr-151 passo vi). SRR distinto do de
			authoring (srr-dlv-glossary, maio/WI-042): append-only, dois eventos distintos.
			Edicao: +10 termos (3 command: registrar-evidencia, avaliar-verificacao,
			transicionar-estado-de-excecao; 7 event: entrega-verificada, entrega-rejeitada,
			evidencia-registrada, supersessao-aplicada, excecao-iniciada, excecao-estendida,
			excecao-resolvida) + add-ref ["agg-verification"] ao term-verificacao existente (termEn
			"Verification" == coreNoun da raiz). Onda 2 e 100% owned (0 foreign, distinto do cmt que
			tinha 8 G1-isentos) -> os 11 exigem coreNoun + termo. PASS: cada termo novo tem termEn ==
			coreNoun do conceito (norm-exato) e domainModelRefs apontando o code (G1 exige a
			referencia); definition substantiva ancorada no dominio real (timers 14d/30d-BD6,
			reasonCode+retryPath-BD13, linhagem de supersessao-BD5); rationale registra POR QUE
			(uq-01) -- ex. os 3 termos proximos registro-de-evidencia (coisa) / registrar-evidencia
			(ato) / evidencia-registrada (fato) sao conceitos distintos que o gate separa por
			norm-exato; category command/event coerente; relatedTerms resolvem (existentes +
			irmaos in-file). add-ref ao term-verificacao e puro +1 linha apos category (sem
			drive-by; o termo nao tinha domainModelRefs). cue vet EXIT=0 + evaluator
			first-class-traceability contra o disco: report VAZIO (os 11 owned do dlv passam G1 com
			10 termos novos + 1 add-ref; 0 foreign). 0 fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Edicao do glossario dlv na onda 2 do backfill Forma A (adr-151 passo vi): 10 termos novos
		(3 command + 7 event) + add-ref ["agg-verification"] ao term-verificacao, dando cobertura
		dedicada (G1) aos 11 conceitos cross-contract owned do dlv (6 delivery + 1 qualification +
		4 governance). SRR distinto do de authoring (srr-dlv-glossary, maio) por append-only --
		documentam dois eventos. Self-review self-reported em 1 round: uq-01..09 + criterios de
		glossary contra o disco, 0 fail / 0 warn. Fidelidade provada pelo evaluator (report VAZIO
		pos-onda; worklist 28->17). cue vet EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: edicao aditiva de 10 termos declarativos + 1 add-ref conformando ao #Glossary (cue
		vet EXIT=0), cada termo com termEn==coreNoun + ref (G1) e rationale substantivo; comportamento
		do gate validado empiricamente (evaluator report vazio pos-onda). Nenhum finding tocou a
		substancia; round unico porque os termos sao declarativos e o gate foi validado a parte.
		"""
}
