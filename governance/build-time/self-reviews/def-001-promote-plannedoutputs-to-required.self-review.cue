package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def001: build_time.#SelfReviewReport & {
	reportId: "srr-def-001"

	artifactPath:       "architecture/deferred-decisions/def-001-promote-plannedoutputs-to-required.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Primeira instância real do sistema deferred-decision (per adr-062). Formaliza pause de C3 Part 4 desta sessão (claude/resume-mesh-work-jv2MC). Triggers calibrados nas 2 condições explícitas articuladas pelo founder: (a) at-least-one constraint no schema #ADR (file-contains pattern conservador), (b) structural-check ADR traceability (file-exists). Ambos adjacent-need (machine-evaluable; nenhum manual-review). status=open inicial; originatingArtifacts inclui adr-059 (.cue) + session:resume-mesh-work-jv2mc (chat). costOfDeferral severity=low + blastRadius=local (escopo single-artifact + drift baixo). triggerCalibrationRationale articula POR QUE pattern conservador (false-positive risk baixo verificado: nenhum dos tokens at-least-one/MinItems/disjunction aparece em adr.cue atualmente). Runner test pass: ambos triggers correctly evaluate a 'not fired' (estado esperado pós-este-commit). Calibration case do sistema."
	}]

	findings: {}

	summary: "def-001: primeira instância real do sistema deferred-decision; serve como calibration case + formaliza pause de C3 Part 4. 2 triggers adjacent-need machine-evaluable; status=open."

	singleRoundRationale: "Instância derivada diretamente de discussão founder-aprovada na sessão (3 rounds de red-team aplicados antes ao schema/PG; instância em si é aplicação direta do sistema). Round único suficiente — substantive review do design já incorporado em adr-062 + schema."
}
