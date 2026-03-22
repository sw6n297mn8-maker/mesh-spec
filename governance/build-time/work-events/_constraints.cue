package work_events

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Mapa de streams indexado por taskId.
// Constraint [ID=string]: ... & {taskId: ID} garante chave = campo taskId.
//
// Backfill retroativo: eventos reconstruídos a partir do git log
// para work-items completados antes da ativação da governança formal
// (ADR-024). Consequências:
// - Timestamps de proposed/approved/claimed/completed são idênticos
//   para WIs completados (derivados do commit que produziu o output).
//   Dados granulares não existem.
// - Timestamps de WIs incompletos (proposed+approved): 2026-03-21T00:00:00Z
//   representa a formalização retroativa da admissão no regime de
//   governança. Não representa a data histórica real de proposta/aprovação
//   original — essa informação não foi capturada antes da ativação.
// - commandIds carregam sufixo "-backfill" para rastreabilidade.
// - Ordering de fases (work-graph.cue) pode não ter sido respeitado
//   na execução original (ex: WI-014 phase 3 completado antes de
//   WI-007/WI-008 phase 2). Backfill reflete realidade, não impõe
//   conformidade retroativa.
// - gatesPassed em completionValidation reflete o mínimo verificável
//   retroativamente (cue-vet).
// - artifactSnapshotHash é git blob hash (hash do conteúdo do artefato),
//   obtido via git ls-tree no commit de conclusão.
streams: [ID=string]: build_time.#WorkItemStream & {taskId: ID}
