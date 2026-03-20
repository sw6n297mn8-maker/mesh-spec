package build_time

import (
	"list"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
)

// self-review-report.cue — Contrato canônico de evidência do self-review.
//
// Instâncias vivem em:
//   governance/build-time/self-reviews/<artifact-name>.self-review.cue
//   package self_reviews (import de build_time para resolver #SelfReviewReport)
//
// Invariantes estruturais:
//   1. stable → sem fail findings (garantido pela união discriminada)
//   2. len(roundDetails) == roundsExecuted (validado pelo CI)
//   3. stable → último round failCount == 0 (validado pelo CI)
//   4. stable + roundsExecuted == 1 → singleRoundRationale obrigatório
//
// Padrão da união discriminada: mesmo de #ADR (status↔supersededBy).
// Extensão: stable subdivide-se em >=2 rounds (sem exigência extra)
// e == 1 round (singleRoundRationale obrigatório).

#SelfReviewStatus: "stable" | "max-rounds-reached"

#RoundSummary: {
	round:     int & >=1
	failCount: int & >=0
	warnCount: int & >=0
	infoCount: int & >=0
	summary:   string & !=""
}

#SelfReviewFindings: {
	fail?: [artifact_schemas.#QualityCriterionFinding, ...artifact_schemas.#QualityCriterionFinding]
	warn?: [artifact_schemas.#QualityCriterionFinding, ...artifact_schemas.#QualityCriterionFinding]
	info?: [artifact_schemas.#QualityCriterionFinding, ...artifact_schemas.#QualityCriterionFinding]
}

// União discriminada por status + roundsExecuted:
//   stable + >=2 rounds → singleRoundRationale opcional (evidência nos rounds)
//   stable + 1 round    → singleRoundRationale obrigatório (evidência de revisão real)
//   max-rounds-reached  → singleRoundRationale opcional
#SelfReviewReport: _#SelfReviewReportBase & ({
	status: "stable"
	findings: {fail?: _|_}
	roundsExecuted: >=2
} | {
	status:              "stable"
	findings:            {fail?: _|_}
	roundsExecuted:      1
	singleRoundRationale: string & !=""
} | {
	status: "max-rounds-reached"
})

_#SelfReviewReportBase: {
	reportId: string & =~"^srr-[a-z0-9-]+$"

	artifactPath:       string & !=""
	artifactSchemaPath: string & !=""
	artifactType:       artifact_schemas.#ArtifactType

	// Proveniência: identifica o protocolo de self-review seguido.
	canonicalSource: "governance/build-time/quality-gate.cue"

	generatedAt: string & !=""

	roundsExecuted: int & >=1
	maxRounds:      int & >=1

	status: #SelfReviewStatus

	roundDetails: [#RoundSummary, ...#RoundSummary] & list.MinItems(1)

	findings: #SelfReviewFindings
	summary:  string & !=""

	// Obrigatório quando roundsExecuted == 1 e status == "stable".
	// Explica por que o artefato estabilizou em um único round —
	// evidência de que houve revisão real, não bypass.
	// Enforcement: união discriminada em #SelfReviewReport.
	singleRoundRationale?: string & !=""

	// Anti-placeholder no ID.
	reportId: !~"^srr-(tbd|todo|placeholder|temp)$"

	_schema: {
		location: {
			canonicalPathRegex: "^governance/build-time/self-reviews/[a-z0-9-]+\\.self-review\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.self-review\\.cue$"
			description:        "Relatório estruturado de self-review pré-proposta."
			rationale:          "Cada proposta gera evidência auditável de autovalidação antes de chegar ao founder."
			cardinality:        "many"
			allowNested:        false
		}
	}

	_qualityCriteria: artifact_schemas.#QualityCriteria & {
		criteria: [{
			id:          "tq-srr-01"
			description: "Report identifica unicamente o artefato revisado"
			test:        "artifactPath, artifactSchemaPath e artifactType juntos permitem identificar sem ambiguidade qual artefato foi revisado e contra qual schema."
			severity:    "fail"
			rationale:   "Sem identidade inequívoca, o report não serve como evidência auditável."
		}, {
			id:          "tq-srr-02"
			description: "Rounds e status são consistentes"
			test:        "roundsExecuted bate com len(roundDetails); status stable implica zero fail no último round e zero fail findings; status max-rounds-reached implica que o protocolo foi interrompido pelo limite, não por esquecimento."
			severity:    "fail"
			rationale:   "Inconsistência interna torna o report não confiável como evidência."
		}, {
			id:          "tq-srr-03"
			description: "Summary final é informativo"
			test:        "summary explica o resultado do self-review de forma substantiva, incluindo natureza do artefato e motivo do status final. Resumos vazios ou genéricos falham."
			severity:    "warn"
			rationale:   "O founder deve conseguir entender rapidamente o estado do review sem ler todos os findings."
		}, {
			id:          "tq-srr-04"
			description: "Severity de finding respeita severity do critério"
			test:        "Para cada finding, o severity declarado é idêntico ao severity do critério referenciado por criterionId. Downgrade (e.g., critério fail reportado como warn) ou upgrade são violação. Fonte de verdade: _severityInvariant em #QualityCriterionFinding."
			severity:    "fail"
			rationale:   "Sem este critério, o agente pode declarar 'stable' rebaixando silenciosamente um fail para warn — o mecanismo exato de autoengano que o self-review deve prevenir."
		}, {
			id:          "tq-srr-05"
			description: "Round summaries e finding rationales são específicos ao artefato"
			test:        "Cada roundDetails[].summary e cada finding.rationale (quando presente) contém informação específica sobre o artefato revisado — não frases genéricas como 'tudo conforme', 'sem issues', 'artefato válido'. Teste de substituição: se o texto funciona igualmente para qualquer artefato de qualquer tipo, está genérico demais e falha. Ancoragem mínima: referencia pelo menos um elemento concreto do artefato (ex: tipo, mudança realizada, critério aplicado, estrutura específica avaliada)."
			severity:    "fail"
			rationale:   "Rationale genérica em self-review é o mecanismo exato de autoengano com aparência de conformidade — o agente produz texto que satisfaz formato sem evidenciar revisão real."
		}]
		rationale: "Critérios específicos garantem que o self-review report seja evidência real, não formalidade vazia."
	}
}
