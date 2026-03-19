package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr016: artifact_schemas.#ADR & {
	id:    "adr-016"
	title: "README coevolution via CI enforcement"
	date:  "2026-03-19"

	decisionClass: "structural"
	decider:       "founder"

	context: """
		O README.md contém uma árvore prescritiva da estrutura do repositório
		(~320 linhas) e é o mapa mental primário para humanos e agentes novos.
		O modelo mental do repo muda quando surgem novas zonas estruturais,
		novos tipos canônicos de artefato, ou novos mecanismos de governança —
		não apenas quando surgem novos diretórios. CLAUDE.md instrui
		coevolução ("atualize repo-structure.cue E README.md antes de criar o
		arquivo"), mas enforcement por disciplina não escala (P12).
		Drift acumulado: artifact-schemas/ listava 21 schemas inexistentes sem
		separação de futuros e omitia 6 existentes; governance/build-time/
		mostrava 1 arquivo de 6; scripts/ci/ não constava na árvore.
		Alternativas consideradas: (a) gerar README da árvore de filesystem —
		rejeitada porque README é prescrição (target), não descrição; (b) phase
		única para diretórios novos (structural-change-coverage) — rejeitada
		após red-team: cobre apenas topologia física, não gramática nem
		governança; (c) duas phases separadas (structural + logic) — rejeitada
		por redundância: ambas respondem "README precisa mudar?" com triggers
		diferentes; (d) trigger de boundary semântico via CI — rejeitada:
		mudanças de papel de zona sem campo explícito não são detectáveis
		deterministicamente em bash.
		"""

	decision: """
		Introduzir phase única readme-coevolution que usa o estado atual do
		filesystem como fonte de verificação — não apenas o delta do PR. Isso
		resolve drift legado e não depende de base-ref para correção. Três
		classes de trigger: A (estrutural: diretório depth ≤ 2 existente não
		declarado), B (tipológico: arquivo existente em artifact-schemas/ não
		declarado), C (governança: protocolo existente em governance/,
		governance/build-time/, governance/claude/ ou scripts/ci/ não
		declarado). Cada classe tem bloco machine-readable no README
		(repo-structure-paths, repo-artifact-schemas, repo-governance-protocols).
		Script compara filesystem contra blocos; item existente não declarado =
		FAIL; item declarado não existente = WARN. Boundary semântico
		(classe D) fica como disciplina de agente — não entra no CI.
		"""

	consequences: """
		Positivas: drift de entendimento detectado automaticamente para 3 das
		4 classes de mudança de modelo mental; mensagens de CI indicam trigger
		e bloco específico, facilitando correção; drift acumulado na árvore
		(artifact-schemas e governance) resolvido no commit de introdução.
		Negativas: boundary semântico (classe D) não coberto — requer
		julgamento que bash não faz; 3 blocos machine-readable coexistem com
		árvore visual (duplicação aceita — formatos diferentes para consumidores
		diferentes, risco de drift entre eles mitigado por adjacência e baixa
		cadência de mudança); heurística depth ≤ 2 no trigger A não cobre
		diretórios nível 3+; file-level check pode ser satisfeito por mudança
		trivial no README (aceitável para modelo operacional atual: agente +
		founder review).
		"""

	status: "proposed"

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/repo-structure.cue",
		"README.md",
		"scripts/ci/check-readme-coevolution.sh",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: """
		P12 exige que governança seja código, não disciplina. P0 exige single
		source — mas blocos machine-readable são duplicação aceita porque
		parsear árvore visual markdown em bash é frágil (formato para humanos,
		não máquinas). Uma phase com 3 trigger classes é mais simples que 2
		phases separadas e cobre as 3 dimensões determinísticas de mudança de
		modelo mental. Classe D (boundary semântico) deliberadamente excluída
		do CI: tentativa de detectar em bash produziria falsos positivos que
		treinam a ignorar o gate. O gate opera sobre filesystem atual, não
		sobre diff, porque drift legado é tão nocivo quanto drift incremental
		— um agente novo vê o estado atual do README, não a história de PRs.
		"""
}
