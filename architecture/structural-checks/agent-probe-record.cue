package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// agent-probe-record.cue — Structural-checks do agent-probe-record (Ciclo 4, adr-134).
//
// Dois checks ortogonais (eixos distintos, ambos reusam kind + handler existentes
// — sem kind novo, sem handler novo):
//   sc-apr-01 (referencial): todo probe-record aponta a um canvas existente.
//     Reusa filesystem-path-exists (gêmeo do sc-srr-01 sobre artifactPath).
//     Born-green: o único record hoje (fce) aponta a contexts/fce/canvas.cue real.
//   sc-apr-02 (cobertura): todo canvas tem >=1 probe-record. Reusa
//     directory-pair-coverage (gêmeo do sc-dp-01 work-events<->task-specs).
//     Born-warn (catraca adr-097): 14 canvases - 1 record (fce) = 13 warns.
//     Promove a reject quando os 14 forem probados (residual em def-035).

structuralChecks: {
	"sc-apr-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-apr-01"
		title:        "probe-record.targetCanvas aponta a canvas existente"
		artifactType: "agent-probe-record"
		description:  "O campo targetCanvas de cada agent-probe-record deve corresponder a um arquivo de canvas real no filesystem. Probe-record cujo targetCanvas não existe é probe órfão — registro de um probe sobre um canvas que não existe."
		kind:         "filesystem-path-exists"
		rule: {
			sourcePath: "targetCanvas"
		}
		errorMessage: "agent-probe-record: targetCanvas '{ref}' não existe no filesystem. Corrija o path ou remova o record órfão."
		rationale:    "adr-134: integridade referencial determinística (existência verificável por inspeção do filesystem, não interpretativa — adr-040 split). Gêmeo do sc-srr-01 (artifactPath). Born-green: o record fce aponta a canvas real."
		enforcement: "warn"
	}
	"sc-apr-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-apr-02"
		title:        "todo canvas tem >=1 probe-record (cobertura)"
		artifactType: "agent-probe-record"
		description:  "Para cada contexts/<bc>/canvas.cue deve existir architecture/agent-probes/records/<bc>.cue. Pega o canvas ainda não submetido ao agent-probe (Ciclo 4). Cobertura canvas->record por pareamento de filename (wildcard <bc>)."
		kind:         "directory-pair-coverage"
		rule: {
			sourceGlob:    "contexts/*/canvas.cue"
			targetGlob:    "architecture/agent-probes/records/*.cue"
			bidirectional: false
		}
		errorMessage: "agent-probe-record: canvas '{source}' não tem probe-record correspondente em architecture/agent-probes/records/. Submeta o canvas ao agent-probe (protocolo) e registre o record."
		rationale:    "adr-134 cobertura A: torna canvas não-probado visível (vs nada-garante). Born-warn (catraca adr-097): nasce com 13 warns (14 canvases - fce). Goodhart neutralizado pelo DoD-completeness do #AgentProbeRecord (record vazio falha cue vet). Promove a reject quando os 14 forem probados (def-035)."
		enforcement: "warn"
	}
}
