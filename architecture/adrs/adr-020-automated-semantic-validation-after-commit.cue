package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr020: artifact_schemas.#ADR & {
	id:    "adr-020"
	title: "Automated semantic validation after commit via isolated execution"
	date:  "2026-03-20"

	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		A validação semântica era regida por instrução de abrir sessão separada
		manualmente no Claude Code. Isso dependia do usuário lembrar de executar
		a validação, criando gap entre commit e validação. O objetivo real —
		separação de contexto para eliminar viés de confirmação — pode ser
		satisfeito por execução isolada automatizada, sem depender de ritual
		operacional manual.
		"""

	decision: """
		Alterar a seção Validação de governance/claude/config.cue para:
		1. Definir separação de contexto como execução isolada sem histórico da
		   sessão autora — independente de mecanismo específico.
		2. Exigir que validação semântica ocorra após commit local e antes de
		   considerar o fluxo concluído.
		3. Alinhar vocabulário de findings com o resto do sistema: fail, warn,
		   info.
		4. Registrar explicitamente quando validation prompt não existe para um
		   tipo de artefato.
		5. Manter hooks post-commit como safety net para commits fora do fluxo
		   principal.
		"""

	consequences: """
		Positivas: validação semântica automática sem dependência de ação
		manual do usuário; separação de contexto preservada por design,
		não por ritual; regra de governança desacoplada de mecanismo de
		execução; visibilidade sobre tipos de artefato ainda sem regime
		de validação.
		Negativas: execução isolada consome contexto adicional de LLM por
		validação; ausência de validation prompt agora gera registro,
		aumentando ruído inicial até a cobertura estabilizar.
		"""

	status: "accepted"

	affectedArtifacts: [
		"governance/claude/config.cue",
		"CLAUDE.md",
		"architecture/validation-prompts/",
	]

	principlesApplied: ["P0", "P1", "P12"]

	rationale: """
		A mudança preserva a propriedade importante — separação de contexto —
		enquanto elimina dependência de disciplina manual. A governança passa
		a definir a propriedade exigida da execução, não uma ferramenta ou ritual
		específico. Isso reduz falhas operacionais sem acoplar a regra a um único
		runtime.
		"""
}
