package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-159 — Precedente de decomposição de DD agrupado em sucessores per-peça.
// Figura: a FORMA reutilizável (parent withdrawn + um sucessor DD por peça ainda
// deferida; peça já resolvida reconhecida no próprio ADR, não vira DD). Fundo: a
// aplicação a def-060 (4 vendors de cliente de frontend num DD agrupado — dívida
// de modelagem vs o padrão per-peça do backend def-041..045). Reconhece a peça-
// framework resolvida no frontend-runtime (rtd-004 @ 5cd1b3b, referência textual
// pinada — não path cross-repo). Precedente para futuros splits, incl. def-041..045.

adr159: artifact_schemas.#ADR & {
	id:    "adr-159"
	title: "Estabelecer decomposição de DD agrupado em sucessores per-peça"
	date:  "2026-06-23"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		def-060 nasceu (criado por adr-150, disparado por adr-154) como UM deferimento
		agrupando quatro vendors de cliente de frontend independentes — framework web,
		motor de sync mobile offline, runtime de orquestração de agente IA, e design
		system visual. O padrão do portfólio para vendor-atrás-de-fronteira é o oposto:
		os vendors de backend são deferidos PER-PEÇA (def-041..045, um DD por Port). O
		agrupamento de def-060 é dívida de modelagem — quatro decisões de vendor de
		subsistemas distintos num único DD.

		O schema #DeferredDecision (adr-062) é ATÔMICO: status é união discriminada sobre
		o DD inteiro (open|triggered|resolved|withdrawn), resolvedBy é um único #OriginRef,
		e não há campo de sucessão (decomposedInto) como o #ADR tem (supersedes/
		supersededBy). Logo um DD agrupado não tem forma nativa de registrar "uma peça
		resolvida, as outras ainda deferidas".

		O gatilho concreto: a peça-framework de def-060 foi resolvida no frontend-runtime
		(rtd-004), com o vendor vivendo atrás da fronteira P2, coerente com adr-150 (que
		recusa nomear o vendor em lei de spec) e adr-158 (codegen vendor-agnóstico). Uma
		peça resolveu; três seguem deferidas; o DD atômico não representa isso. Some-se que
		def-060 é ponteiro load-bearing cross-repo: o manifesto do frontend-runtime
		(governance/spec-dependencies.cue, verificado por verify-spec-pointers.sh) o lista
		como foundation, e adr-150/157/158 o referenciam em defersTo — removê-lo quebraria
		referências que o mesh-spec não pode consertar sozinho.

		Alternativas avaliadas:
		(a) Paridade estrita com sucessor nascendo resolved — a peça-framework viraria um DD
		    criado já em status resolved, simétrico aos def-041..045. Rejeitada: troca a
		    exceção de AGRUPAMENTO (o outlier def-060) por uma exceção de LIFECYCLE (DD
		    nascendo resolved contradiz o lifecycle canônico "status inicial open" do schema
		    + PG deferred-decision) e exigiria emendar o PG — apenas MOVE a exceção, não a
		    elimina. A assimetria que sobra (peça resolvida sem DD vivo) é honesta: DD
		    registra deferral VIVO, e peça resolvida não tem deferral vivo.
		(b) Resolver def-060 inteiro (status resolved, resolvedBy único). Rejeitada: falso à
		    atomicidade do schema — três das quatro peças seguem deferidas; marcar o DD
		    inteiro resolved as misrepresenta.
		(c) Split destrutivo (remover/renomear def-060 e substituí-lo pelos sucessores).
		    Rejeitada: quebra o foundation pointer cross-repo do frontend-runtime
		    (spec-dependencies.cue) — conserto vive no outro repo, fora do alcance do
		    mesh-spec — e pendura os defersTo de adr-150/157/158.
		"""

	decision: """
		(1) ESTABELECER a forma reutilizável de decomposição de DD agrupado: quando um DD
		agrupa N peças independentes (dívida de modelagem), decompõe-se em parent WITHDRAWN
		+ um sucessor DD por peça AINDA DEFERIDA (cada um em status open). A peça já
		RESOLVIDA é reconhecida NESTE ADR de decomposição, NÃO vira DD — DD registra
		deferral vivo, e peça resolvida não tem deferral vivo. O parent permanece no disco
		(withdrawn, nunca deletado) como charneira histórica: seus ponteiros — incluindo
		cross-repo — seguem resolvendo, e a sucessão é apontada na sua withdrawalRationale
		(o schema #DeferredDecision não tem campo decomposedInto). Forma precedente para
		futuros splits, incluindo os vendor DDs de backend def-041..045 quando resolverem.

		(2) APLICAR a forma a def-060: o DD agrupado dos quatro vendors independentes de
		cliente de frontend decompõe-se — def-060 → withdrawn; sync mobile offline → def-066;
		orquestração de agente IA → def-067; design system → def-068 (todos open, um por
		peça, alinhando def-060 ao padrão per-peça do backend def-041..045).

		(3) RECONHECER a peça-framework resolvida no frontend-runtime via rtd-004 (React 19 +
		TypeScript no web; React Native + Expo no mobile) — o vendor vive atrás da fronteira
		P2 no runtime, coerente com adr-150 e adr-158. Referência TEXTUAL PINADA ao commit
		5cd1b3b do frontend-runtime (padrão de governance/build-time/codegen-validation-
		evidence.cue: escalar pinado, não path cross-repo — o runner determinístico do
		mesh-spec não resolve arquivo de outro repo). A peça resolvida NÃO vira DD (sem
		deferral vivo); seu registro spec-side é este reconhecimento.

		(4) REGISTRAR que o cleanup cross-repo é devido, fora deste commit: o foundation
		pointer do frontend-runtime (governance/spec-dependencies.cue) e o rtd-004 apontam
		def-060 (agora withdrawn); migrá-los para os sucessores (def-066/067/068) + este ADR
		é passo futuro NO frontend-runtime, sob seu regime gated próprio — o mesh-spec não
		escreve no outro repo.
		"""

	consequences: """
		Positivas:
		(P1c) Elimina o outlier de modelagem: def-060 deixa de ser o único DD de vendor
		agrupado. Cada vendor de cliente de frontend passa a ter localização canônica
		própria (ou, para o resolvido, reconhecimento próprio), alinhado ao padrão
		per-peça do backend (def-041..045).
		(P2c) A forma é reutilizável e barata: futuros splits — incluindo os def-041..045
		quando resolverem — seguem parent-withdrawn + sucessores-per-peça sem reinventar
		E sem tocar o engine de governança (schema #DeferredDecision, PG e CI intactos).
		(P3c) Zero quebra de ponteiros: def-060 permanece no disco (withdrawn), então os
		defersTo de adr-150/157/158 e o foundation pointer cross-repo do frontend-runtime
		seguem resolvendo — a charneira histórica preserva a integridade referencial.

		Negativas / limitações:
		(N1c) Assimetria honesta: a peça-framework resolvida não tem DD vivo (só
		reconhecimento neste ADR), enquanto as três deferidas têm DD. É consequência fiel
		de DD registrar deferral VIVO — não defeito; mas significa que "todo vendor é um
		DD" não vale para vendors já resolvidos.
		(N2c) Cleanup cross-repo fica devido: o foundation pointer do frontend-runtime e o
		rtd-004 apontam def-060 (withdrawn) até serem migrados aos sucessores — janela de
		staleness semântica (não quebra) até o passo futuro NO frontend-runtime.
		(N3c) O precedente enraíza: uma vez que os def-041..045 sigam esta forma, mudá-la
		fica caro (coerente com reversibility=medium) — vira norma de facto sem emenda de
		schema/PG.
		"""

	falsificationCondition: {
		condition: """
			A forma estará errada se uma decomposição futura de DD agrupado NÃO puder usar
			parent-withdrawn + sucessores-per-peça e exigir shape diferente — tipicamente
			precisar de um campo de sucessão (decomposedInto) no schema #DeferredDecision
			que a withdrawalRationale em prosa não supre —, OU se o parent withdrawn quebrar
			algum consumidor apesar de permanecer no disco.
			"""
		observableSignal: """
			Um split futuro que exija emendar o schema #DeferredDecision para registrar
			sucessão estruturada (em vez de prosa na withdrawalRationale), OU
			verify-spec-pointers / adr-consistency falhando por referência a def-060 após o
			withdraw (sinal de que "permanecer no disco" não bastou).
			"""
	}

	affectedArtifacts: [
		"architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue",
	]
	plannedOutputs: [
		"architecture/deferred-decisions/def-066-frontend-mobile-sync-vendor.cue",
		"architecture/deferred-decisions/def-067-frontend-ai-orchestration-vendor.cue",
		"architecture/deferred-decisions/def-068-frontend-design-system-vendor.cue",
	]
	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]
	defersTo: ["def-066", "def-067", "def-068"]

	principlesApplied: [
		"P0 — localização canônica única: cada vendor ainda deferido ganha DD próprio (def-066/067/068); a peça resolvida é apontada (rtd-004), não copiada; o parent withdrawn mantém ponteiros resolvendo sem duplicar conhecimento.",
		"P2 — vendor atrás de fronteira: o framework vive atrás da fronteira no frontend-runtime; o reconhecimento honra P2 — o spec aponta o vendor sem nomeá-lo em lei (coerente com adr-150).",
	]

	supersedes: []

	rationale: """
		A decomposição escolhe a forma menos custosa que respeita três constraints
		simultâneos: a atomicidade do #DeferredDecision (adr-062), que proíbe resolução
		parcial; a integridade referencial cross-repo (o foundation pointer do
		frontend-runtime não pode quebrar); e o lifecycle canônico do DD (status inicial
		open). Parent-withdrawn + sucessores-per-peça satisfaz os três sem emendar schema,
		PG ou CI — ao contrário da paridade-born-resolved, que apenas moveria a exceção de
		agrupamento para o lifecycle.

		P0: cada vendor ainda deferido ganha localização canônica própria (def-066/067/068),
		e a peça resolvida é apontada — não copiada — via referência textual pinada ao
		rtd-004 (o vendor mora no runtime, sua localização canônica; o spec aponta). O parent
		withdrawn mantém os ponteiros existentes resolvendo, sem duplicar conhecimento. P2: o
		reconhecimento honra a fronteira — o framework vive atrás dela no frontend-runtime, e
		o spec reconhece sem nomear o vendor em lei (coerente com adr-150).

		reversibility=medium / blastRadius=cross-cutting: cross-cutting porque a forma alcança
		decomposições de DD em múltiplos domínios (frontend agora, backend def-041..045 depois)
		sem tocar o engine de governança; medium porque o custo-de-dado de reverter é zero
		(artefatos de governança), mas a forma enraíza conforme adotada — desfazê-la após os
		def-041..045 a seguirem fica caro.

		Tensão com axiomas: nenhuma. A decisão honra P0/P2, defere ao runtime só o
		runtime-local, e a assimetria framework-sem-DD é consequência fiel de DD registrar
		deferral vivo, não tensão.
		"""
}
