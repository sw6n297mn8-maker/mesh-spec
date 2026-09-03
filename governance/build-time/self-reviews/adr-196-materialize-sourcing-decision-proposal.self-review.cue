package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr196MaterializeSourcingDecisionProposal: build_time.#SelfReviewReport & {
	reportId: "srr-adr-196-materialize-sourcing-decision-proposal"

	artifactPath:       "architecture/adrs/adr-196-materialize-sourcing-decision-proposal.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-03"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 3
		warnCount: 2
		infoCount: 0
		summary:   "Três fails corrigidos na passada: (a) título descritivo reescrito como afirmativo per PG scaffold-and-classification; (b) rejeição da alternativa C rasa (só custo) rearticulada com o trade-off real — teto permanente de produto na plataforma cuja tese é evidência verificável (tq-adr-01); (c) affectedArtifacts continha paths de superfícies geradas fora deste repo — removidos, mantidos só paths inspecionáveis no filesystem (tq-adr-03)."
	}, {
		round:     2
		failCount: 0
		warnCount: 2
		infoCount: 0
		summary:   "Zero fails. Dois warns declarados e mantidos como transparência à proposta: (uq-05) nomes evt-/prj- indicativos, naming final na fatia (declarado no decision item 3); (tq-adr-02) calibrações de risco propostas (structural/medium/cross-artifact) aguardando confirmação do founder, listadas explicitamente na submissão."
	}]

	findings: {}

	summary: "adr-196 proposto após 2 rounds: fails de título, alternativa e rastreabilidade corrigidos no round 1; round 2 limpo com 2 warns declarados (naming indicativo; calibração founder pendente). Verificação de refs por leitura direta: act-evaluate-and-conclude-rfq, svc-fitness-rule-evaluator, inv-decision-rationale-required, prj-active-sourcing-decisions no ssc; gap registrado no rationale do passo 7 da story na main."
}
