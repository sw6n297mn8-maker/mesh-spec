package build_time

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// verifier-registry.cue — Singleton do Verifier Registry Mesh (adr-187).
//
// Trust root event-sourced de identidade de verifier para a completion do
// work-governance. Morada canônica per adr-187 (camada build-time, adr-098
// schemaExemptZone). Schema #VerifierRegistry adotado de tekton-spec via
// adopted-artifacts (adr-186), v0.4.0 @ 0de85b3.
//
// FASE INAUGURAL NÃO-OPERACIONAL (adr-187 decisão item 4): os dentes temporais
// (append-only + causal) e o caminho governado de mutação NÃO existem ainda —
// pertencem ao Slice C. events deve permanecer [] nesta fase inaugural.
// Qualquer mutação antes da ativação dos dentes append-only/causal e do caminho
// governado de mutação é inválida por adr-187. A semântica event-sourced/
// forward-only é normativa desde a criação. Nenhuma tarefa Mesh depende do
// Registry para admission/completion nesta fase.
//
// Autoridade decisória: verifier-governance founder-held (adr-187 item 2). A
// autorização executável de mutação nasce com os dentes (Slice C).
verifierRegistry: artifact_schemas.#VerifierRegistry & {
	events: []
}
