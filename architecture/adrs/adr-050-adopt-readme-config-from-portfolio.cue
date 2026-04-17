package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr050: artifact_schemas.#ADR & {
	id:    "adr-050"
	title: "Adopt #ReadmeConfig from tekton-spec for README.md governance"
	date:  "2026-04-16"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		README.md de mesh-spec tem 834 linhas e continua crescendo conforme a
		spec evolui. A manutenção manual tem três problemas que se agravam
		com o tempo:

		(1) Tree drift: a árvore ASCII no README lista diretórios que podem
		existir ou não no filesystem; não há gate automático. Cada refactor
		estrutural exige sincronização manual meticulosa, que falha em
		silêncio quando esquecida.

		(2) Duplicação conceitual: conteúdo sobre princípios, camadas, autoridades
		vive tanto no README quanto em artefatos .cue (design-principles.cue,
		agent-governance.cue). P0 (uma localização canônica) é violado por
		construção toda vez que o README repete conteúdo autorativo.

		(3) Zero auditabilidade estrutural: descrição de cada diretório é texto
		livre em comentário ASCII; não é consumível por CI, não valida shape,
		não permite queries.

		Tekton-spec (portfolio de governança) criou schema #ReadmeConfig
		(ADR-005 portfolio) com tree governada por #RepositoryTree +
		#DirectoryNote — cada diretório vira entry estruturada com purpose,
		conventions, rationale. README.md passa a ser artefato derivado via
		cue export de governance/readme/.

		Mesh-spec ainda não adotou nada de tekton-spec — não existe
		governance/adopted-artifacts.cue. Esta ADR é a primeira adoção
		cross-repo, estabelecendo o pattern para adoções futuras. Precedente
		interno: adr-004 (CLAUDE.md como artefato derivado) já estabeleceu
		que mesh-spec deriva documentos markdown de source CUE; esta ADR
		estende o mesmo pattern ao README.md.

		Alternativas consideradas:
		- Manter README manual: rejeitado. Com mesh-spec crescendo ativamente,
		  o custo de manutenção manual aumenta, drift se acumula, P0 é
		  violado por construção.
		- Criar schema local #MeshReadmeConfig próprio: rejeitado. Duplica o
		  trabalho já feito em tekton-spec, fragmenta portfolio, e mesh-spec
		  deveria ser primeiro cliente real do #ReadmeConfig — se o shape
		  é inadequado, é oportunidade de propor evolução no portfolio, não
		  bypass local.
		- Adotar só #ReadmeConfig sem tree: rejeitado. Tree é exatamente
		  o campo que resolve o problema (1) acima; promover sem tree é
		  adoção estética, não operacional.
		- Preservar ASCII art das camadas no template de output: rejeitado.
		  Acopla template a convenção visual específica, complica manutenção,
		  e mistura estrutura (tree) com interpretação (camadas). Camadas
		  viram sections narrativas separadas, preservando a semântica sem
		  poluir o render da tree.
		"""

	decision: """
		Adotar os schemas #ReadmeConfig + #ReadmeSection + #RepositoryTree +
		#DirectoryNote de tekton-spec em modo verbatim no âmbito de SCHEMA.
		O template de renderização (governance/readme/output.cue) é
		implementação LOCAL de mesh-spec, podendo divergir do template de
		tekton-spec quando necessário — sem quebrar o contrato do schema
		adotado.

		Resumo do que é verbatim vs local:
		- architecture/artifact-schemas/readme-config.cue: adotado verbatim
		  de tekton-spec (hash rastreado em adopted-artifacts.cue).
		- governance/readme/output.cue: implementação local derivada do
		  pattern de tekton-spec, pode evoluir para atender necessidades
		  visuais de mesh-spec sem impacto no shape.
		- governance/readme/config.cue: instância autoral de #ReadmeConfig;
		  é o source a partir do qual README.md é gerado.

		Decisão de rendering: tree é renderizada como tabela markdown
		derivada de #RepositoryTree (sem ASCII art). A semântica de camadas
		(0-4 em mesh-spec atual) é preservada em #ReadmeSection narrativas
		específicas, não em decoração estrutural do template. Separa
		estrutura (tree) de interpretação (camadas) — cada um no seu lugar
		canônico.

		Sequenciamento de execução em commits separados:

		(a) governance/adopted-artifacts.cue — primeiro manifest da história
		de mesh-spec. Adota #AdoptedArtifactsManifest (sua própria definição)
		+ #ReadmeConfig + sub-tipos.

		(b) architecture/artifact-schemas/readme-config.cue — cópia verbatim
		do schema de tekton-spec. Hash registrado em adopted-artifacts.cue.

		(c) governance/readme/output.cue — template markdown local que consome
		config.cue e gera README.md (tree como tabela, camadas em sections).

		(d) governance/readme/config.cue — instância de #ReadmeConfig com
		conteúdo atual do README.md estruturado: description em 3 camadas,
		tree com entries cobrindo filesystem real, sections para princípios
		orientadores, organização em camadas, convenções, autorização.

		(e) README.md regenerado — derivado de (d) via cue export.

		(f) governance/repo-structure.cue atualizado para registrar README.md
		como artefato derivado (mesmo pattern de adr-004 para CLAUDE.md).

		README.md é o único artefato derivado introduzido por esta ADR;
		output.cue e config.cue são autorais. Cada commit passa cue vet em
		isolamento.
		"""

	consequences: """
		Positivas:
		(1) README.md passa a ser derivado com sync enforcement via CI
		(extending o pattern já consolidado em adr-004 para CLAUDE.md).
		(2) Tree auditável: cada diretório governado tem entry com purpose/conventions/rationale;
		drift entre README e filesystem vira detectável (futuro CI check).
		(3) P0 honrado: conteúdo de princípios/camadas/autoridades passa a
		apontar para .cue canônicos em vez de duplicar. Redução de drift
		estrutural.
		(4) Mesh-spec vira primeiro cliente real do #ReadmeConfig do portfolio,
		exercitando o shape e provendo feedback para tekton-spec.
		(5) Pattern de adoção cross-repo estabelecido — futuras adoções
		(schemas portfolio adicionais) seguem mesmo processo.

		Negativas:
		(1) Trabalho de parsing substancial: 834 linhas de README precisam ser
		estruturadas em ~50 #DirectoryNotes e ~15 #ReadmeSections. Estimativa
		4-8h de trabalho cuidadoso.
		(2) Visualização em camadas via ASCII art perde-se no render tabular;
		semântica migra para sections narrativas. Leitores acostumados ao
		visual anterior precisam reler para encontrar as âncoras de camadas.
		Aceitável — a informação não se perde, apenas muda de lugar.
		(3) Introduz dependência formal entre mesh-spec e tekton-spec. Semver
		de tekton-spec (#ReadmeConfig) passa a afetar mesh-spec; mudanças
		breaking em #ReadmeConfig exigem migration plan documentado per
		tekton-spec compatibility-policy.
		(4) Primeiro adopted-artifacts.cue força criação da convenção de adoção
		em mesh-spec. Trabalho one-time; simplifica adoções futuras.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"governance/adopted-artifacts.cue",
		"architecture/artifact-schemas/readme-config.cue",
		"governance/readme/output.cue",
		"governance/readme/config.cue",
		"governance/repo-structure.cue",
	]

	derivedArtifacts: [
		"README.md",
	]

	principlesApplied: [
		"P0",
		"P1",
	]

	rationale: """
		P0 (única localização canônica) é o princípio mais violado pela
		manutenção manual do README — cada restruturação cria drift entre
		tree-no-README, filesystem real e schemas governados. Adoção de
		#ReadmeConfig coloca tree em source CUE com cada diretório governado
		por artefato único. P1 (schemas CUE como SoT de contratos) cobre a
		formalização do source autoral (governance/readme/config.cue) e
		dos schemas adotados (architecture/artifact-schemas/readme-config.cue)
		— CUE é SoT do shape e do conteúdo estrutural do README. O regime
		de derivados (README.md regenerado de config.cue com sync enforcement
		no CI) é operacionalizado localmente via governance/readme/output.cue
		e atualização de governance/repo-structure.cue — mesmo pattern já
		consolidado em adr-004 para CLAUDE.md, portanto não requer princípio
		novo nem extensão de P1 para cobrir regime operacional de derivados.
		Reversibility medium porque reverter exige restaurar README manual e
		remover infraestrutura de derivação — possível mas custoso. Blast
		radius repo-wide porque toca governance, architecture/artifact-schemas,
		cria nova convenção (adopted-artifacts) e altera processo de edição
		de README. Primeira adoção cross-repo: serve de template para futuras
		(quando mesh adotar outros schemas portfolio).
		"""
}
