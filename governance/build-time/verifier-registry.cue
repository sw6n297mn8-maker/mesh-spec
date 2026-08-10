package build_time

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// verifier-registry.cue — Singleton do Verifier Registry Mesh (adr-187).
//
// Trust root event-sourced de identidade de verifier para a completion do
// work-governance. Morada canônica per adr-187 (camada build-time, adr-098
// schemaExemptZone). Schema #VerifierRegistry adotado de tekton-spec via
// adopted-artifacts (adr-186), v0.4.0 @ 0de85b3.
//
// REGIME CAUSAL ATIVO (adr-189, Slice C1): as invariantes de mutação causal do
// trust root estão IMPLEMENTADAS e verificadas por gates determinísticos
// dedicados (falham o CI em violação) — append-only Git-prefix (base×candidato)
// e quiescência terminal (nenhum evento dirigido a uma versão após "revoked"),
// em scripts/ci/check-verifier-registry-{append-only,terminal-quiescence}.sh via
// .github/workflows/verifier-registry-check.yml — somadas às invariantes
// estruturais do cue vet (#VerifierRegistry: register-once, referências causais
// válidas, grants resolvíveis e projeção derivada do stream).
//
// AINDA NÃO — A AUTORIDADE EXECUTÁVEL DE MUTAÇÃO: a superfície governada que
// decide QUEM pode mutar (distinta dos eventos persistidos) pertence ao Slice C2.
// Enquanto ela não existir, NÃO se afirma "governed mutation operational": há
// integridade causal, não ainda a superfície de autoridade.
//
// events permanece [] (machine-first, adr-189 decisão 6): C1 entrega a máquina;
// nenhum verifier produtivo é semeado até existir um verifier real (downstream).
// Nenhuma tarefa Mesh depende do Registry para admission/completion nesta fase.
//
// Autoridade decisória: verifier-governance founder-held (adr-187 item 2;
// superfície executável = Slice C2).
verifierRegistry: artifact_schemas.#VerifierRegistry & {
	events: []
}
