package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// work-governance.cue — Structural checks determinísticos para
// integridade referencial do work governance system.
//
// Per adr-040: gate determinístico complementar a manual review;
// motivado por bug WI-033 (commit c9b584c, 2026-04-02) onde
// work-event foi criado sem task-spec correspondente — inconsistência
// silenciosa por ~5 semanas detectada apenas em retrospective manual.
//
// Per adr-064: kind directory-pair-coverage cobre integridade entre
// work-events/ e task-specs/. Reusável para outros directory pairs
// futuros (não escopo deste arquivo).

structuralChecks: "sc-wg-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-wg-01"
	title:        "work-event exige task-spec correspondente"

	// Promovido a gate bloqueante per adr-097: verde pós-backfill D7
	// (wi-072..085), determinístico, baixo risco, e guarda exatamente a classe
	// de drift do bug WI-033/D7. Primeiro check da "catraca" warn→reject.
	enforcement: "reject"

	artifactType: "work-governance"
	description:  "Para cada arquivo wi-NNN em governance/build-time/work-events/, arquivo wi-NNN correspondente DEVE existir em governance/build-time/task-specs/. Direção source-to-target only: work-event sem task-spec = inconsistência referencial (admission state inválido per work-governance state machine — work-event implica task-spec proposed/approved). Reverse direction (task-spec sem work-event) é estado válido admission=defined; bidirectional=false respeita essa assimetria."
	kind:         "directory-pair-coverage"
	rule: {
		sourceGlob:    "governance/build-time/work-events/wi-*.cue"
		targetGlob:    "governance/build-time/task-specs/wi-*.cue"
		bidirectional: false
	}
	errorMessage: "work-event {file} existe em governance/build-time/work-events/ mas task-spec correspondente NÃO existe em governance/build-time/task-specs/. Inconsistência referencial: work governance state machine assume task-spec defined ANTES de events; work-event sem task-spec é estado admission inválido. Crie o task-spec correspondente OU remova o work-event."
	rationale:    "derivedFromInvariant: bug WI-033 (commit c9b584c, 2026-04-02) criou wi-033.cue em work-events/ + entry em wave-plan SEM criar task-spec; inconsistência silenciosa por ~5 semanas. Detectada em retrospective de session claude/resume-mesh-work-jv2MC e backfilled mecanicamente via commit fbfe535. Real fix preventivo: structural gate. enforcementLevel: runner (latente até runner ativar per adr-040 + adr-041 forward-looking). Rule nasce verde após backfill — primeiro uso é proteção contra recorrência."
}
