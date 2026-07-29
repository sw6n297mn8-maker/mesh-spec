package work_events

// wi-157.cue — Lifecycle event-sourced de WI-157 (re-autoria do
// stakeholder-map, resolve def-076). Proposto pelo spec-writer na sessão
// 2026-07-28 do arco jornada→produção; aprovado pelo founder na mesma
// sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
//
// Claimado e completado na execução da própria fatia (2026-07-29,
// molde WI-156/159/160/161). Direção do founder (D1-D4) + 3 section
// gates do adr-181 + consolidada aprovada com sanção explícita da
// entrada invertida do sh-06 (pp-cumulative-detection-cost como custo
// imposto ao ataque — repurpose deliberado e declarado, coerente com a
// N3). Verificação pedida na direção, executada por leitura: os 6
// canvases que citam sh-06 (bkr/drc/fce/idc/rew/scf) referenciam por
// id estável (stakeholderRef + prosa); grep actor-class em contexts/ =
// 0 — a mudança de categoria não quebra ref algum. Verificação pedida
// no OK da escrita: mv-* SÃO entries identificadas no shape
// (#ManipulationVector.code, regex ^mv-[a-z][a-z0-9-]*$, scoped ao
// stakeholder); a unicidade deles é tq-sm-06 — SEM kind no runner
// (lacuna nomeada no header do sc-sm), coberta por SCRIPT nesta fatia
// (unicidade de int-*/pp-*/mv-*/platformRelationships verificada por
// stakeholder; zero duplicatas). Exit do def-076 completo num
// movimento só: instância re-unificada + sc-sm-01..03 + isenção stale
// do meta-coverage removida. Runner: 32 warns / 0 bloqueantes
// (29 pré-existentes + 3 esperados do sc-sm-02: sh-07/08/09 sem ref
// de canvas até a operacionalização das personas no WI-158+).
// adr-181: G2 --assert adr=181 na escrita; pipeline isolated 2 rounds
// estável (F1 taxonomia v0 +"system"; F2 def-076 na rastreabilidade —
// ambos verificados na fonte). SRRs: 2 exigidos pelo gate (adr-181;
// sc-sm) + 2 por transparência do pipeline (schema-delta isolated; o
// mapa — núcleo da fatia); demais artefatos casaram reports existentes
// por path (gate PASSED). artifactSnapshotHash = git blob hash de
// domain/stakeholder-map.cue materializado.
streams: "WI-157": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-157"
	taskVersion: 1
	commandId:   "WI-157-propose-stakeholder-map-reauthoring"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-157"
	taskVersion: 1
	commandId:   "WI-157-approve-stakeholder-map-reauthoring"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-157"
	taskVersion:    1
	commandId:      "WI-157-claim-stakeholder-map-reauthoring"
	timestamp:      "2026-07-29T02:05:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-29T10:05:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-157"
	taskVersion: 1
	commandId:   "WI-157-complete-stakeholder-map-reauthoring"
	timestamp:   "2026-07-29T02:35:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-157-completion-20260729"
		artifactSnapshotHash: "7fe90cdb668b2fedc6395516efc14f15c97587a3"
		gatesPassed: ["cue-vet", "canvas-refs-verification", "mv-uniqueness-script", "structural-runner", "freshness-gate", "check-self-review"]
	}
}]
