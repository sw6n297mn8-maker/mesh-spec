package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr003: artifact_schemas.#ADR & {
	id:    "adr-003"
	title: "Introdução de ADRs tipados com enforcement determinístico"
	date:  "2026-03-15"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	context: """
		Decisões arquiteturais e de governança estavam sendo tomadas sem
		registro formal. Em um sistema operado por agentes de IA, a ausência
		de registro tipado e enforcement determinístico significa que decisões
		podem ser esquecidas, duplicadas, contraditas ou mal rastreadas.
		Regras de operating model (CLAUDE.md) são necessárias mas insuficientes
		como guardrail único — agentes podem errar, ignorar ou interpretar mal.
		"""

	decision: """
		Adotar ADRs como artefatos CUE tipados (schema adr.cue) com:
		(a) união discriminada por status para constraint de supersededBy
		    no nível do tipo — não como comentário;
		(b) campos de risco (reversibility, blastRadius, decisionClass);
		(c) rastreabilidade bidirecional (affectedArtifacts, derivedArtifacts,
		    supersedes/supersededBy);
		(d) status sem ambiguidade (proposed/accepted/rejected/superseded/withdrawn);
		(e) enforcement em CI via duas phases complementares:
		    adr-coverage (toda mudança semântica tem ADR correspondente) e
		    adr-consistency (invariants relacionais entre ADRs como DAG);
		(f) taxonomia de mudanças (semântica/editorial/mecânica/derivada)
		    para evitar ADRs artificiais ou omissões;
		(g) regra de workflow no operating model: ao superseder um ADR,
		    atualizar antigo e criar novo no mesmo commit.
		"""

	consequences: """
		Positivas: decisões rastreáveis por tipo, risco e blast radius;
		enforcement em três camadas (tipo, CI, workflow) reduz dependência
		de disciplina de agente; histórico de decisão é pesquisável e tipado.
		Negativas: overhead de criar ADR para cada mudança semântica;
		CI precisa de dois scripts adicionais (adr-coverage e adr-consistency).
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/adr.cue",
		"governance/repo-structure.cue",
		"CLAUDE.md",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P12",
	]

	rationale: "Meta-decisão: o próprio sistema de ADRs precisa de ADR. Sem este registro, a decisão de adotar ADRs seria a primeira decisão sem rastreabilidade — contradição fundacional."
}
