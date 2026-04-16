package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr017: artifact_schemas.#ADR & {
	id:    "adr-017"
	title: "README blocks as derived artifacts with pre-commit enforcement"
	date:  "2026-03-19"

	decisionClass: "structural"
	decider:       "founder"

	context: """
		ADR-016 introduziu blocos machine-readable no README e um script
		de check. Porém, blocos e árvore eram ambos mantidos manualmente.
		O modelo discipline-based (agente lembra de atualizar) falha na
		prática — o próprio commit de ADR-016 precisou corrigir 3
		diretórios detectados pelo script durante a primeira execução.
		Alternativas consideradas: (a) blocos totalmente manuais com CI
		check — rejeitada: enforcement que só detecta sem corrigir
		transfere trabalho repetitivo para o humano/agente; (b) auto-fix
		de blocos E da árvore visual — rejeitada: árvore tem comentários
		descritivos que requerem contexto semântico, não automatizáveis
		em bash; (c) hook do Claude Code (PostToolUse) — rejeitada: só
		funciona para agente Claude Code, não para humanos; pre-commit
		é universal.
		"""

	decision: """
		Blocos machine-readable tornam-se artefatos derivados: regenerados
		do filesystem pelo script com flag --fix. Pre-commit hook em
		scripts/hooks/pre-commit executa --fix (auto-corrige blocos, stage
		README) e depois verifica presença textual de cada item no README
		(heurística por basename via grep — o sistema não parseia markdown
		tree syntax; presença textual em qualquer lugar do README é aceita
		como evidência de documentação). Blocos auto-corrigidos → nunca
		stale. Presença textual enforced → commit bloqueado se entry falta,
		humano/agente escreve a descrição. Instalação do hook: git config
		core.hooksPath scripts/hooks.
		"""

	consequences: """
		Positivas: blocos nunca ficam desatualizados (automação);
		presença textual é enforced no pre-commit (barreira antes do
		commit, não só no CI remoto); zero dependências externas
		(bash + git); hook é tracked no repo (scripts/hooks/) e instalado
		com um comando git config.
		Negativas: cada clone precisa de git config core.hooksPath
		scripts/hooks (one-time setup, não automático); textual presence
		check usa grep no README inteiro, podendo aceitar menção em
		prosa como suficiente (falso negativo raro — filenames são
		específicos); a árvore visual e os blocos são duplicação aceita
		com risco de drift nos comentários descritivos (mitigado pela
		baixa cadência de mudança). Nota: o bloco repo-governance-protocols
		inclui protocolos de governança e enforcement tooling operacional
		— o nome é mantido por estabilidade de contrato, mas o escopo
		real abrange qualquer arquivo operacional nas zonas governadas.
		"""

	status:        "superseded"
	supersededBy:  "adr-051"

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"scripts/ci/check-readme-coevolution.sh",
		"scripts/hooks/pre-commit",
		"governance/repo-structure.cue",
		"README.md",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: """
		P12 exige governança como código. Blocos derivados são a forma
		mais pura: o filesystem É a source of truth, o bloco é
		materialização. Pre-commit hook é enforcement local imediato —
		feedback loop de segundos vs minutos de CI remoto. Textual
		presence check é o compromisso entre enforcement completo
		(parsear árvore markdown — frágil) e zero enforcement (só
		blocos — insuficiente). Grep por filename é heurística simples
		que cobre 99% dos casos sem complexidade de parsing.
		"""
}
