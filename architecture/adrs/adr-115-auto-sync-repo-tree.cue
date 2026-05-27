package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr115: artifact_schemas.#ADR & {
	id:    "adr-115"
	title: "Auto-sync da árvore do repositório no README via meta.cue por diretório"
	date:  "2026-05-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		A descrição estrutural do repositório vive hoje como lista central inline em
		governance/readme/config.cue (config.tree.entries): um bloco repo-wide que
		enumera cada diretório e seu purpose. Esse desenho tem dois problemas.

		(1) Viola P0 / Zero Duplicação: a descrição de cada diretório deveria residir
		junto do diretório que descreve, não em config remoto. Hoje a fonte da verdade
		da descrição está longe do que ela descreve.

		(2) Viola Modularidade e controle de blast radius: adicionar, renomear ou
		remover 1 diretório exige editar um artefato de escopo repo-wide, e o README
		só fica correto se o autor lembrar de sincronizar a lista à mão — drift por
		omissão é silencioso.

		auster-spec já resolveu isto em seu adr-028 (meta.cue por diretório + gerador
		que caminha o filesystem). O founder requisitou paridade na mesh. Três opções
		foram avaliadas:
		- Opção A — meta.cue por diretório (filesystem como SoT da estrutura, descrição
		  co-localizada). ESCOLHIDA.
		- Opção B — manter lista central, só renderizar como árvore ASCII. REJEITADA:
		  resolve a aparência mas mantém a violação de P0 e o drift por omissão.
		- Opção C — sintetizar descrições de package doc-comments. REJEITADA: descrições
		  ficariam menos autoritativas e estáveis, e acopladas a comentário de código.

		Diferença de stack vs auster: a mesh NÃO tem toolchain Go. O gerador é
		implementado em Python reusando a infra determinística existente
		(scripts/ci/structural-check-runner.py + generate-structure-index.py), evitando
		introduzir um runtime novo só para isto.
		"""

	decision: """
		Filesystem é source of truth da estrutura do repositório. Cada diretório
		governado contém um _meta.cue (architecture/artifact-schemas/directory-meta.cue
		declara o tipo #DirectoryMeta, criado por esta decisão) declarando um campo
		`meta` como mapa keyed pelo path, com no mínimo:
		- canonicalPath: path declarado, validado contra o path real do arquivo.
		- purpose: descrição em uma frase (20-200 runes).

		Duas adaptações à stack da mesh (vs auster):
		- Nome _meta.cue (prefixo _): os canonicalPathRegex dos schemas de instância
		  (agent-spec, lens, subdomain, etc.) exigem filename iniciando em [a-z0-9];
		  "meta.cue" casaria todos e geraria classificação ambígua. "_meta.cue" não
		  casa nenhum, classificando só como directory-meta.
		- Forma de mapa plana, SEM importar o schema: artifact_schemas importa
		  shared_types (e é amplamente importado), então um _meta.cue importando o
		  schema criaria ciclo; e subdirs que compartilham o package do pai (ex:
		  contexts/*/agents) colidiriam no campo `meta`. O mapa keyed pelo path resolve
		  ambos. A validação contra #DirectoryMeta é feita pelo gerador (P10).

		Um gerador determinístico (scripts/ci/generate-repo-tree.py) caminha o
		filesystem, lê cada _meta.cue, valida canonicalPath == path real (tq-dm-01),
		purpose 20-200 runes (tq-dm-02) e sem substring '.cue' (tq-dm-04), e emite
		governance/readme/tree-generated.cue (bloco ASCII treeAscii + entries) com
		header explícito de artefato derivado.

		governance/readme/config.cue passa a importar tree-generated.cue e remove as
		entries inline; governance/readme/output.cue renderiza o bloco ASCII antes da
		tabela detalhada. A consistência (canonicalPath == path real, sync do derivado)
		é guardada pelo próprio gerador determinístico; directory-meta é registrado como
		isento em meta-coverage.exemptTypes (sc-meta-02), simétrico ao readme-config
		(cuja consistência é guardada por check-readme-coevolution.sh, não por
		structural-check). A orphan-detection passa a reconhecer _meta.cue como instância
		classificada (via canonicalPathRegex do schema), não órfão.

		Correção pontual no structural-check-runner.py: o detector de "arquivo de
		schema" (sc-meta-02) usava substring "_schema" — falso-positivo para _meta.cue
		em architecture/artifact-schemas (package artifact_schemas contém "_schema").
		Trocado por regex de declaração `^\\s*_schema:`.

		Esta decisão registra o pattern e cria o schema base; o rollout dos meta.cue,
		do gerador, do check e da migração do config.cue é executado em commits
		subsequentes desta mesma feature (plannedOutputs).
		"""

	consequences: """
		Positivas: (1) a descrição de cada diretório passa a ter localização canônica
		única, junto do diretório (P0); (2) adicionar/renomear/remover diretório vira
		operação local (1 meta.cue) em vez de edit em artefato repo-wide; (3) a árvore
		do README fica auto-sincronizada e o drift por omissão é eliminado — o gate
		deterministic falha se o derivado estiver fora de sync; (4) paridade estrutural
		com auster-spec/tekton-spec, facilitando adoção cruzada de tooling.

		Negativas: (1) introduz um _meta.cue em cada diretório governado (56 arquivos),
		criados uma vez reusando as descrições já existentes no config.cue; (2) um
		gerador novo a manter (mitigado por reuso da infra Python determinística e
		--self-test); (3) a orphan-detection precisa reconhecer meta.cue — tratado pela
		classificação via canonicalPathRegex do schema + isenção em sc-meta-02, senão
		meta.cue viraria órfão e quebraria o gate (adr-098); (4) a migração do config.cue é a edição mais
		delicada (afeta render do README e o check de co-evolução adr-016) e é feita
		por último, com regeneração e validação.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"governance/readme/config.cue",
		"governance/readme/output.cue",
		"architecture/structural-checks/meta-coverage.cue",
		"scripts/ci/structural-check-runner.py",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/directory-meta.cue",
		"scripts/ci/generate-repo-tree.py",
		"governance/readme/tree-generated.cue",
	]

	principlesApplied: [
		"P0 — Zero Duplicação: a descrição do diretório passa a ter localização canônica única, junto do diretório que descreve",
		"P10 — gate determinístico: gerador reproduzível + structural-check de sync substituem manutenção manual sujeita a drift por omissão",
		"adr-028 — adota o pattern de auster-spec (meta.cue por diretório + filesystem como SoT da estrutura), adaptado à stack Python da mesh",
		"adr-090 — precedente de estrutura derivada do filesystem (structure-index)",
		"adr-016 — README é artefato derivado co-evoluído; a árvore passa a ser gerada, não autorada",
		"dp-07 — sem big-bang: schema base primeiro, rollout de meta.cue/gerador/check/migração em commits subsequentes",
	]

	defersTo: []

	rationale: """
		decisionClass structural: introduz um novo tipo de artefato (#DirectoryMeta) e
		uma nova relação derivada (filesystem + meta.cue → tree-generated.cue → README),
		sem redefinir princípios base nem SoTs de domínio.

		reversibility medium: reverter exige restaurar a lista central no config.cue e
		remover os meta.cue dos diretórios — esforço moderado, sem impacto em dados
		persistidos ou contratos públicos. blastRadius repo-wide: afeta a geração do
		README e adiciona artefato em diretórios de todo o repo.

		Alternativas avaliadas e rejeitadas estão registradas em context (Opção B
		lista-central-renderizada; Opção C síntese-por-doc-comment). Opção A escolhida
		por co-localização canônica (P0) e estabilidade autoritativa das descrições.
		"""
}
