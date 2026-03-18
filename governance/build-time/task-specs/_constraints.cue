package task_specs

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// Mapa de TaskSpecs indexado por ID.
// Constraint [ID=string]: ... & {id: ID} garante chave = campo id.
//
// Invariante de validação: governance/build-time/task-specs/ é um
// package CUE único. Validação deve rodar no diretório inteiro
// (cue vet ./governance/build-time/task-specs/), nunca por arquivo
// isolado. Arquivos wi-*.cue contribuem entradas ao mapa; este
// arquivo impõe o constraint de tipo sobre todas as entradas.
// Mover arquivos para outro package quebra a unificação.
taskSpecs: [ID=string]: build_time.#TaskSpec & {id: ID}
