package shared_types

// TaskOutput — tipo de output de tarefa, compartilhado entre #TaskSpec
// (governance/build-time/work-governance.cue, definição operacional) e
// #WaveTask (architecture/artifact-schemas/wave-plan.cue, definição de
// planejamento). Morada aqui por adr-184 dec 3: o tipo é consumido por dois
// schemas em dois packages, que é a definição da zona declarada no _meta
// ("tipos de baixo nível usados por múltiplos schemas"). Antes do adr-184
// existiam DUAS definições independentes de shape idêntico, e o comentário
// que afirmava compartilhamento era falso em ambos os lados.

// SubordinateRepo — enumeração FECHADA dos repositórios subordinados aos
// contratos do mesh-spec (adr-148 e adr-157). Fechada por decisão: admitir um
// quarto repositório é ato de ADR, não digitação. adr-184 dec 2.
#SubordinateRepo: "mesh-runtime" | "mesh-frontend-runtime"

// TaskOutput — união discriminada por PRESENÇA RESOLVIDA POR DEFAULT
// (adr-184 dec 3). O ramo local carrega o marcador `*` porque em CUE um ramo
// a que falta campo obrigatório fica INCOMPLETO, não errado, e a disjunção
// não resolve sozinha: sem o marcador, `cue vet ./...` sai 1 com 243 valores
// incompletos e o `cue export` do wave-plan falha. O marcador vive no SCHEMA,
// então as 138 task-specs e o wave-plan conformam sem toque.
//
// Ramo local: artefato produzido ou alterado dentro deste repositório.
// Ramo remoto: EFEITO ESPERADO em repositório subordinado — condição de
// conclusão da tarefa, nunca ordem de serviço nem reivindicação de autoria
// (adr-184 dec 1). O repositório-alvo permanece soberano sobre implementação.
// A PROVA do efeito não vive aqui: vive no evento de conclusão, em
// #CompletionValidation.effectProofs (adr-184 dec 4/5) — expectativa é
// pré-execução, prova é pós-execução.
#TaskOutput: *{
	artifact: string & !=""
	type:     "create" | "update" | "validate"
} | {
	artifact:         string & !=""
	type:             "create" | "update" | "validate"
	effectExpectedIn: #SubordinateRepo
}
