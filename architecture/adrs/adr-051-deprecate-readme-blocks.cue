package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr051: artifact_schemas.#ADR & {
	id:    "adr-051"
	title: "Deprecate README machine-readable blocks in favor of config.cue tree.entries"
	date:  "2026-04-16"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		ADR-050 promoveu o README.md a artefato derivado de
		governance/readme/config.cue via #ReadmeConfig. Tree.entries
		de config.cue é agora a declaração canônica da estrutura de
		diretórios governados — com shape enforcement (path, purpose
		MinRunes(20), conventions, rationale por entry) e cue vet
		validando coerência.

		Simultaneamente, ADR-016 e ADR-017 estabeleceram um mecanismo
		paralelo: três blocos machine-readable no README
		(repo-structure-paths, repo-artifact-schemas,
		repo-governance-protocols) mantidos pelo
		check-readme-coevolution.sh com pre-commit auto-fix. Motivação
		original (ADR-017): evitar drift entre filesystem e descrição
		no README, quando README era manual.

		Com README agora derivado de config.cue, os blocos tornam-se
		redundância estrutural: a mesma informação de diretórios vive em
		tree.entries (com shape mais rico e rationale por entry). Os
		blocos repo-artifact-schemas e repo-governance-protocols também
		são listagens de filesystem que cue vet já valida (schemas
		precisam conformar com meta-schema, protocolos com seus tipos).

		Manter os três mecanismos em paralelo cria duas fontes de
		verdade para "o que existe no repo" — violação direta de P0 e
		do princípio que motivou ADR-050. A solução é unificar.
		"""

	decision: """
		Deprecar os três blocos machine-readable no README. Estrutura de
		diretórios governados passa a viver exclusivamente em
		governance/readme/config.cue tree.entries. Listagens de
		artifact-schemas e governance-protocols saem de README — validação
		continua via cue vet (shape) e via presença textual no README
		derivado.

		check-readme-coevolution.sh passa a operar em modo único de
		validação (flags --fix e --block removidas). Falha com exit 1
		se:
		  (1) algum tree.entries[].path não existir no filesystem;
		  (2) algum diretório governado do filesystem (após aplicar
		      validationScope.excluded) não aparecer em tree.entries;
		  (3) README.md materializado divergir da saída de
		      cue export ./governance/readme -e output --out text.

		Pre-commit hook passa a chamar o script em modo check, não
		mais auto-fix. Regeneração de README.md vira comando explícito
		(cue export) documentado em
		governance/repo-structure.cue.derivedArtifacts.

		governance/repo-structure.cue remove os três blockIds e adiciona
		README.md como full-file derivedArtifact com
		source=governance/readme/config.cue e template fixo em
		governance/readme/output.cue (o schema atual de derivedArtifacts
		suporta um source por entry; o template é documentado no
		generator e no rationale da entry).

		ADR-051 supersedes ADR-016 e ADR-017. Os ADRs antigos
		permanecem como registro histórico, mas seus mecanismos
		operacionais (README blocks, auto-fix por blockId, pre-commit
		associado) deixam de ser norma vigente.

		Alternativas consideradas:
		  (a) Manter os blocos e tree.entries em paralelo, com check de
		      consistência cruzada — rejeitada: duas fontes de verdade
		      para a mesma informação. Complexidade cresce: check que
		      valida A contra B contra filesystem em vez de A contra
		      filesystem. Viola P0 por construção.
		  (b) Gerar os blocos via cue export a partir de config.cue
		      (manter blocos no README, mas como derivação de
		      tree.entries) — rejeitada: ainda mantém redundância (mesma
		      info aparece duas vezes no README, tree table + blocos
		      machine-readable). Sem consumer downstream dos blocos, o
		      custo de gerar duplicata não tem benefício compensador.
		  (c) Deprecar só o bloco repo-structure-paths (sobreposto com
		      tree.entries); manter artifact-schemas e
		      governance-protocols — rejeitada: meia-medida. Os outros
		      dois blocos também são listagens de filesystem sem consumer
		      downstream; cue vet já valida conformidade com schemas.
		      Manter metade do mecanismo preserva complexidade sem razão
		      estrutural.
		"""

	consequences: """
		Positivas: (1) uma única fonte de verdade para estrutura
		governada do repo (tree.entries), alinhado com P0; (2) shape
		enforcement mais rico que os blocos (purpose MinRunes, rationale
		obrigatório, conventions listadas); (3) README derivado
		integralmente vira padrão consistente (casa com CLAUDE.md,
		que já é derivado full-file).
		Negativas: (1) regeneração de README deixa de ser automática no
		commit — agente/humano deve rodar cue export quando tree.entries
		muda (mitigado por CI check que falha se README stale);
		(2) README deixa de ser superfície de inspeção mecânica para
		artifact-schemas e governance-protocols; essa auditoria passa a
		existir apenas via CUE + filesystem checks. Reduz redundância,
		mas elimina a inspeção textual espelhada;
		(3) scripts/hooks/pre-commit precisa ser atualizado ou perde
		função de auto-fix de blocos — clarificado no próprio refactor.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/adrs/adr-016-readme-coevolution.cue",
		"architecture/adrs/adr-017-readme-blocks-as-derived-artifacts.cue",
		"scripts/ci/check-readme-coevolution.sh",
		"scripts/hooks/pre-commit",
		"governance/repo-structure.cue",
		"governance/readme/config.cue",
		"governance/readme/output.cue",
		"README.md",
	]

	supersedes: ["adr-016", "adr-017"]

	principlesApplied: [
		"P0",
		"P2",
		"P10",
	]

	rationale: """
		P0 (uma localização canônica) é o princípio-raiz sob tensão
		quando a mesma informação de estrutura do repo vive em
		tree.entries E em blocos no README. ADR-050 promoveu config.cue
		a essa localização canônica; ADR-051 completa a migração
		removendo a fonte paralela. P2 (CUE como formato universal)
		reforça: blocos são manifesto em markdown quando o mesmo papel
		pode ser cumprido por CUE com shape mais rico. P10 (derived
		files como evidência determinística): README inteiro como
		derivado full-file é mais determinístico que README parcial com
		blocos auto-fix. Reversibilidade é medium — recriar os blocos a
		partir de tree.entries é mecanicamente simples (comando cue
		export), mas semanticamente regressivo: reintroduz redundância
		estrutural removida por esta ADR e mexe em cinco artefatos
		operacionais (script, hook, repo-structure, README, convenção
		editorial).
		"""
}
