package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr116: artifact_schemas.#ADR & {
	id:    "adr-116"
	title: "Modelo de operação híbrido: propor-no-chat (semântico) vs PR direto (derivado/mecânico)"
	date:  "2026-05-27"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	context: """
		O Modelo de Operação no CLAUDE.md (governance/claude/config.cue) dizia: "o agente
		propõe conteúdo no chat, o founder aprova, o agente escreve e commita na branch
		ativa. Não cria branches nem PRs — gestão de branches é responsabilidade do
		usuário." Esse texto foi escrito para o modo Claude Code local.

		A realidade operacional mudou: o agente passou a operar no Claude Code na web, um
		ambiente efêmero baseado em PR. Na prática o agente vinha criando branches, abrindo
		PRs e até mergeando (sob instrução do founder), e escrevendo artefatos antes de
		propor — divergindo do texto vigente sem sinalizar. O founder identificou a
		divergência e pediu reconciliação.

		Alternativas avaliadas:
		- Modo estrito (status quo do texto): agente só propõe no chat, founder faz todo o
		  git. REJEITADA: não reflete o ambiente web baseado em PR e gera atrito enorme em
		  mudanças derivadas/mecânicas (regen de README, structure-index, fixes de CI).
		- Autonomia total via PR: agente escreve tudo direto via PR. REJEITADA: erode o
		  controle semântico do founder sobre schemas, ADRs, domain-model e decisões.
		- Híbrido por classe de mudança. ESCOLHIDA.
		"""

	decision: """
		Dois modos de escrita, por classe de mudança:
		1. Semântica/estrutural (schemas, ADRs, domain-model, canvas, invariantes, eventos,
		   comandos, design-principles, protocolos de governança, task-specs): o agente
		   PROPÕE o conteúdo no chat e espera aprovação explícita antes de escrever.
		2. Derivada/mecânica (artefatos regenerados — README, CLAUDE.md, structure-index,
		   tree-generated; scripts/workflows/hooks de CI que NÃO alterem política de
		   governança ou enforcement; correções mecânicas necessárias para restaurar
		   cue vet sem alterar semântica): o agente pode escrever, criar branch e abrir
		   PR draft direto, sem proposta prévia.

		Default conservador: na dúvida sobre a classe, tratar como semântica (propor no
		chat). O founder é a única autoridade de aprovação E merge — o agente não faz
		merge sem instrução explícita.

		Dois guard-rails contra erosão: (a) CI/scripts só são mecânicos se não mexem em
		política de governança/enforcement (required checks, promotion warn→reject, branch
		protection viram semântica); (b) "fix de cue vet" só é mecânico se não altera
		comportamento.
		"""

	consequences: """
		Positivas: (1) o CLAUDE.md passa a refletir a realidade operacional (web/PR), em vez
		de uma regra que era violada na prática; (2) preserva o controle do founder onde
		importa (semântica) e remove atrito onde não importa (derivado/mecânico); (3) o
		default 'na dúvida, semântica' impede erosão gradual do controle.

		Negativas: (1) introduz uma fronteira de classificação que pode ser ambígua — uma
		mudança de CI pode virar semântica rápido (enforcement); mitigado pelos dois
		guard-rails explícitos e pelo default conservador; (2) exige disciplina do agente em
		auto-classificar honestamente — auditável via PR + chat.
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"governance/claude/config.cue",
	]

	derivedArtifacts: [
		"CLAUDE.md",
	]

	principlesApplied: [
		"P0 — config.cue é a fonte canônica única do CLAUDE.md; a regra vive no source, não em memória do agente",
		"dp-07 — evolução contínua sem reescrita: amenda o Modelo de Operação para a realidade PR sem redefinir os 3 tiers do README",
		"P10 — founder permanece a autoridade humana de aprovação e merge; o split apenas reposiciona ONDE o gate humano incide",
	]

	defersTo: []

	rationale: """
		decisionClass foundational: altera o protocolo de governança que define como o
		agente escreve no repositório — base operacional, não instância. reversibility high
		(reverter é editar o texto de volta, sem dados/contratos afetados); blastRadius
		repo-wide (governa toda operação do agente).

		tq-adr-01: três alternativas registradas em context com motivo de rejeição (estrito,
		autonomia total, híbrido). Aprovado pelo founder no chat, com dois refinamentos
		incorporados (guard-rails de enforcement e de 'fix sem semântica').

		Aplicação: edita governance/claude/config.cue (seções Modelo de Operação e Proposta
		Antes de Implementar) e regenera CLAUDE.md (derivado).
		"""
}
