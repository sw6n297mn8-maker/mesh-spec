package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-194 — Canoniza a Constituição do Design System Mesh como artifact
// de primeira classe: cria o tipo #DesignSystemConstitution + instância
// em architecture/design-system/, refina a fronteira de autoridade do
// adr-157 para o domínio da expressão (lei = spec; vendor/tooling =
// runtime, def-086 sucessor do def-068), e declara o regime de mudança
// (emenda de camada via ADR; calibração de token via commit no runtime).

adr194: artifact_schemas.#ADR & {
	id:    "adr-194"
	title: "Estabelecer a Constituição do Design System como artefato canônico de primeira classe"
	date:  "2026-08-14"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		Fonte e autoridade. A Constituição do Design System Mesh (Versão 1.0,
		julho/2026, documento canônico; camadas I–VI congeladas, pendências
		registradas ao final) foi fornecida INTEGRALMENTE pelo founder na
		autorização da missão M7.5 (sessão 2026-08-14), com a ordem explícita de
		canonizá-la como artifact de primeira classe SEM alteração de conteúdo —
		preservação é lei: nenhuma lei, trade-off, caso limite, personalidade,
		jurisprudência, pendência, cláusula de reabertura, significado de token ou
		distinção preparado/verificado/decidido/registrado desaparece ou é
		"melhorada". Reconciliação com o adr-193 (execução autônoma escopada a
		missão): criar um artifact type novo é classe STOP (5)(a) — semântica
		nova; aqui NÃO é STOP porque a semântica não nasce do agente: o conteúdo
		e a ordem de canonização vieram do founder na própria autorização da
		missão — a autorização É a decisão semântica; a missão executa a
		materialização (a implementação de semântica já decidida que o adr-193
		tira do caminho serial do founder).

		Estado precedente da lei de expressão. O adr-150 legisla o COMPORTAMENTO
		do frontend AI-first (3 patterns: Action-as-Tool, Generative Form,
		Approval-as-Confirmation; FF-FE-01..08) e declara no N1, verbatim:
		"Invariante ratificado, implementacao ausente: vendor de cliente, telas e
		design system visual (tokens, tipografia, marca) NAO existem -- escopo
		declarado-ausente, deferido a def-060." A decomposição do def-060
		(adr-159) fez o design system viver em def-068 (open, manual-review). O
		adr-157 aloca, verbatim (dec 3): "DIVISÃO DE AUTORIDADE:
		SEMÂNTICA/contrato — o QUE a tela confirma, os invariantes que obedece
		(adr-150) — = mesh-spec; IMPLEMENTAÇÃO/distribuição/vendor — framework,
		sync, design system, transporte HTTP — = frontend-runtime (def-060)"; e
		(dec 5): "a CAPACIDADE (confirmar override com atribuição nominal, em
		ação estruturada P10) é canônica/spec; a TECNOLOGIA (framework,
		componente de botão/form, design system) é runtime-local (def-060)."
		Ou seja: a ÚNICA lei vigente sobre expressão visual era a de que ela é
		runtime-local e deferida. O próprio def-068 condicionava o deferimento a
		"antes de a marca estar definida" — a Constituição É a marca sendo
		definida pelo founder: a premissa do deferimento amadureceu.

		Trigger concreto. A promulgação da Constituição pelo founder (julho/2026)
		e a ordem de canonização na missão M7.5. Sem canonização, a lei da
		expressão viveria fora do repositório-autoridade — exatamente a classe de
		drift que P0 (localização canônica única) e P12 (governança é código)
		existem para impedir.

		Alternativas avaliadas:
		(a) Manter a expressão integralmente runtime-local (status quo adr-157
		    dec 3/5 + def-068). REJEITADA: a identidade agora está DECIDIDA pelo
		    founder — mantê-la fora do spec deixaria a decisão semântica sem
		    localização canônica (viola P0) e sem enforcement de governança
		    (viola P12); a premissa do def-068 ("antes de a marca estar
		    definida") deixou de valer.
		(b) Canonizar como documento prose (markdown) ou como ADR gigante sem
		    tipo. REJEITADA: artefato sem schema vira órfão na classificação
		    type-centric (gate de órfão reject, adr-098) e fica fora do regime
		    universal de governança (quality criteria, self-review, PG, sc) —
		    cascade adr-053; markdown para conteúdo CUE-ável viola o contrato do
		    repo.
		(c) Estender o #FrontendCodegenContract com campos de expressão.
		    REJEITADA: aquele contrato governa a GERAÇÃO de superfícies POR
		    FAMÍLIA (adr-180) e deliberadamente não tem slot de expressão visual;
		    a lei da expressão é TRANSVERSAL a famílias — acoplá-la ao contrato
		    de codegen forçaria toda mudança de token a passar pelo artefato de
		    geração, blast radius errado.
		(d) ESCOLHIDA: tipo first-class #DesignSystemConstitution + instância
		    composta em architecture/design-system/ + REFINAMENTO da fronteira de
		    autoridade (lei da expressão = spec; vendor/tooling = runtime,
		    def-086) + regime de mudança explícito (emenda vs calibração), com o
		    pacote completo do tipo novo no molde adr-180 (schema + PG + sc +
		    enum + coveredSchemas no mesmo commit).
		"""

	decision: """
		(1) CANONIZAR a Constituição do Design System como artifact de primeira
		classe: schema #DesignSystemConstitution em
		architecture/artifact-schemas/design-system-constitution.cue
		(_schema.location: architecture/design-system/; _qualityCriteria
		tq-dsc-01..05) e instância ÚNICA composta por merge de structs CUE em
		architecture/design-system/ — constitution.cue (preâmbulo, I-V, camadas
		VI, regime de tokens VII, cláusula de proteção IX, pendências) +
		canonical-cases.cue (jurisprudência VIII, 8 casos verbatim) +
		token-contract.cue (contrato de tokens). Preservação integral do texto
		promulgado; estrutura tipada só onde há uso mecânico (ids, derivesFrom
		como enum fechado — P14, changeRegime, classification, verbos canônicos
		como enum fechado). Nota de execução: cardinality declarada "collection"
		pela forma física multi-arquivo — o tooling V1 de singleton
		(structure-index, sc-sg-01) exige canonicalPathRegex literal e acusaria
		falso-ausente permanente; a unicidade lógica (UMA Constituição) é
		invariante declarado no schema e guardado por sc-dsc-01/02.

		(2) REFINAR A FRONTEIRA DE AUTORIDADE do adr-157 SEM editá-lo (molde
		adr-178: o ADR institui sobre o qualificador, citando a lei verbatim
		onde citada — a lei não é editada nem parafraseada). O termo "design
		system" nas cláusulas citadas no context (adr-157 dec 3 e dec 5) é
		REFINADO: a LEI DA EXPRESSÃO — identidade, camadas (cor, tipografia,
		movimento, forma, linguagem, procedência), contrato de tokens e regime
		de mudança — é SEMÂNTICA e vive no mesh-spec (esta Constituição);
		VENDOR, component library, styling tooling e a MECÂNICA de promulgação
		(como os valores viram tema/lint/build) permanecem runtime-local
		(def-086, sucessor estreitado do def-068). Os VALORES promulgados vivem
		no mesh-frontend-runtime SOB o token-contract — o runtime materializa,
		nunca legisla (mesma gramática QUE=spec/COMO=runtime do adr-158). A
		falsificação (b) do adr-157 — verbatim: "ela CRISTALIZAR uma hipótese
		runtime-local (vendor, transporte, design system) como decisão canônica
		do mesh-spec — fronteira de autoridade falhou" — permanece VÁLIDA no
		sentido original: ela vigia hipótese nascendo NO runtime e cristalizando
		como lei; aqui a decisão nasceu do founder NO spec, o lado correto da
		fronteira, e o que segue runtime-local (def-086) continua fora da lei. A camada VI.6
		(gramática visual da procedência) APONTA o regime V.2; o contrato de
		DADO de proveniência de captura segue em def-061 — não re-decidido aqui.

		(3) DECLARAR a relação com o adr-150: o adr-150 legisla COMPORTAMENTO
		(3 patterns, FF-FE-01..08) e declara em N1 o design system visual como
		escopo-ausente deferido; a Constituição preenche EXATAMENTE esse vazio.
		A cadeia é: adr-150 (comportamento AI-first) → Constituição
		(manifestação visual, linguística e epistemológica desse comportamento).
		A distinção preparado/verificado/decidido/registrado (V.2 + VI.6)
		ESTENDE a distinção agente-prepara/humano-confirma do adr-150 — a
		Constituição a referencia e a veste; não a duplica nem a re-decide.
		Nenhuma cláusula do adr-150 é alterada.

		(4) DECLARAR a relação com architecture/design-principles.cue:
		princípios do SISTEMA (P0-P14) ≠ Constituição da EXPRESSÃO. A seção II
		da Constituição declara derivação dos invariantes do sistema (P3
		imutabilidade/correção-por-novos-eventos; P10 gates determinísticos
		acima do julgamento da máquina; P11 evidência antes de dinheiro) — a
		relação é DERIVAÇÃO declarada, não fusão: os artefatos permanecem
		separados, cada um com sua autoridade.

		(5) REGIME DE MUDANÇA (a cláusula IX vira operação): camadas I-VI estão
		CONGELADAS — emenda exige ADR apontando qual elo superior mudou
		(invariante de arquitetura, personalidade ou lei transversal); sem elo
		mudado não há reabertura ("preferência não legisla"). Tokens, por
		regime declarado no token-contract: calibratable = MANUTENÇÃO (commit
		no mesh-frontend-runtime dentro da moldura, sem tocar o spec);
		constitution-bound = valor/range fixado pela camada — alterar EXIGE
		emenda via ADR. Nenhum valor entra sem referência à decisão que o
		autoriza (VII).

		(6) RECONCILIAR def-068 pela forma do adr-159 (parent withdrawn +
		sucessor por peça ainda deferida): def-068 → status "withdrawn" com
		withdrawalRationale apontando este ADR e o sucessor; def-086 nasce open
		com escopo ESTREITADO — SOMENTE vendor, component library e
		styling/tooling (+ mecânica de promulgação); a identidade (tokens,
		tipografia, marca) está DECIDIDA por este ADR e pela Constituição — não
		é mais deferível. O input de partida (Mesh-Old §2.9, shadcn/ui + Radix +
		Tailwind 4 red-teamed) é preservado no sucessor como leitura, sem
		decidir nada. O arquivo def-068 permanece no disco (charneira histórica;
		ponteiros cross-repo seguem resolvendo). Cleanup cross-repo (CLAUDE.md
		do mesh-frontend-runtime aponta def-068) é passo futuro NO
		frontend-runtime, sob o regime daquele repo — o mesh-spec não escreve lá
		(molde adr-159 dec 4).

		(7) READING CONTRACT: a Constituição ENTRA na leitura obrigatória de
		fatia de tela. O reading contract instituído pelo adr-179 dec 2 (adr-150
		+ frontend-codegen-contract + adr-157 + adr-178) ganha, POR ESTE ADR, o
		5º ponteiro: architecture/design-system/ (a Constituição inteira — lei,
		jurisprudência e token-contract). O adr-179 NÃO é editado; o spec
		declara a extensão aqui, e o VEÍCULO runtime é o config do
		mesh-frontend-runtime (governance/claude/), atualizado lá sob o regime
		daquele repo — mesmo padrão cross-repo do item (6).

		(8) LENSES DE DESIGN PERMANECEM ADVISORY, SEM EDIÇÃO. As ~12 lenses
		draft que tocam expressão (lens-color-as-functional-language,
		lens-typographic-systems-for-dense-interfaces,
		lens-design-tokens-and-systematic-composition,
		lens-information-density-design,
		lens-interaction-patterns-for-professional-tools,
		lens-data-visualization-semiotics,
		lens-progressive-disclosure-and-information-architecture,
		lens-multi-sided-platform-ux, lens-trust-and-credibility-design,
		lens-domain-language-and-terminology-design,
		lens-internationalization-and-localization-architecture,
		lens-jobs-to-be-done-and-workflow-design) contêm recomendações
		concretas que CONTRADIZEM a Constituição em pontos nomeados: Inter como
		typeface ótima vs IBM Plex titular; brand navy vs tinta preto-no-branco;
		"dark mode as option" vs dark mode proibido por iniciativa própria;
		transições 150ms vs range 120–200ms. RESOLUÇÃO: a Constituição é LEI;
		lenses são material analítico advisory por definição de schema ("Lenses
		orientam análise e decisão. Não autorizam execução.") e permanecem no
		disco INEDITADAS, em status draft. Onde conflitarem, a Constituição
		prevalece; a recomendação de lens só volta ao jogo como PROPOSTA de
		emenda via cláusula IX (apontando elo superior mudado).

		(9) ENFORCEMENT SOB P10/adr-040/ten-006: só o machine-decidable pode ser
		gate — shape via cue vet (enums fechados de verbos canônicos,
		derivesFrom, changeRegime, classification; structs fechados de camada),
		valores bound registrados no token-contract, e os checks determinísticos
		sc-dsc-01/02 (co-presença dos arquivos da instância composta; born-warn
		per adr-097 — os evaluators por-arquivo do runner V1 não alcançam
		conteúdo de instância multi-arquivo, limitação documentada no próprio
		check). JULGAMENTO ESTÉTICO NUNCA É GATE: conformidade interpretativa
		(quietude, tom, substância de cadeia de derivação) é advisory —
		self-review + founder review (tq-dsc-01..05), jamais veredito de CI.
		Nenhum linter constitucional, registry ou fitness function novo nasce
		aqui.

		(10) PENDÊNCIAS CLASSIFICADAS (zero defs novos além do def-086): o
		Registro de Pendências da Constituição entra classificado por regime —
		(pend-01) teste ao sol = empirical-calibration: obrigação de validação
		empírica cuja saída ajusta VALOR, não norma (a própria norma o declara);
		NÃO é def. (pend-02) dataviz e (pend-03) palco = deferred-decision
		governada NO artefato, SEM def formal: ambas são camadas futuras da
		PRÓPRIA Constituição (não decisões fora dela) com trigger textual real
		(analytics no registro escritório; pós-produto) — quando nascerem,
		nascem como emenda/extensão via ADR sob a cláusula IX, exatamente o
		veículo que um def apontaria; o gatilho é fato de produto fora do disco
		(invisível ao runner — mesma lição dos def-066/067/068). (pend-04) Mona
		Sans = reserve-condition: condição de reserva com convocação declarada
		na camada, não decisão pendente. (pend-05) motivo em divergências =
		out-of-scope-governance: a própria Constituição a classifica como
		política de alçada (o slot existe no design; a obrigatoriedade é
		governança por organização) — pointer para a governança de alçada
		futura.

		PACOTE DO TIPO NOVO (molde adr-180 dec 5 / cascade adr-053 + adr-054 dec
		13): production-guide
		architecture/production-guides/design-system-constitution.cue (tipo
		production-guide em rollout subagent-drafted; NESTA missão o dispatch de
		subagente não estava disponível no ambiente do builder — fallback manual
		documentado per authoring-policy fallbackPolicy + CLAUDE.md, com entry
		no subagent-execution-log e transparência no commit message);
		structural-checks sc-dsc-01/02; enum #ArtifactType +=
		"design-system-constitution" (abreviações tq-dsc / tq-dcg registradas);
		sc-pg-01 coveredSchemas += "design-system-constitution" no MESMO commit
		(change-on-touch que o próprio check declara).
		"""

	consequences: """
		Positivas:
		(P1c) A lei da expressão ganha localização canônica única no
		repositório-autoridade (P0): o vazio do N1 do adr-150 fecha — toda tela
		futura tem a quem obedecer em identidade, cor, tipografia, movimento,
		forma, linguagem e procedência, com jurisprudência e contrato de tokens.
		(P2c) O regime de mudança vira operação governada: emenda de camada
		exige ADR com elo superior mudado (cláusula IX mecanizada em processo);
		calibração de token vira commit no runtime dentro da moldura — o
		founder deixa de ser consultado para ajuste de hex dentro de moldura e
		permanece a única autoridade para emenda.
		(P3c) A distinção epistemológica preparado/verificado/decidido/
		registrado (a extensão visual do agente-prepara/humano-confirma do
		adr-150) vira enum fechado — compile-time (P14), não disciplina.
		(P4c) O tipo entra no regime universal de governança na origem: schema
		+ PG + sc + quality criteria no mesmo commit (cascade adr-053/sc-pg-01
		sem janela).
		(P5c) def-068 sai do limbo premissa-envelhecida ("antes de a marca
		estar definida" — a marca foi definida) para sucessor honesto e
		estreito (def-086: só vendor/tooling).

		Negativas:
		(N1) O spec passa a carregar um artefato normativo extenso cuja
		substância (julgamento estético) não é 100% mecanizável — a fidelidade
		do conteúdo depende de review humano; os gates cobrem shape, co-presença
		e enums, não beleza (limitação declarada, dec 9).
		(N2) A instância multi-arquivo fica fora do alcance dos evaluators
		por-arquivo do runner V1 e do singleton-coverage (regex não-literal) —
		mitigado por enum fechado em cue vet + sc-dsc-01/02 + cardinality
		"collection" documentada; um evaluator package-aware é evolução futura
		possível do runner, NÃO criada aqui (dec 9: zero enforcement genérico
		novo).
		(N3) As ~12 lenses draft de design carregam recomendações agora
		contraditas por lei (Inter, navy, dark-mode-as-option, 150ms) e
		permanecem no disco sem edição — risco de leitura ingênua por sessão
		futura; mitigação: dec 8 registra a precedência e o caminho único de
		volta (emenda via cláusula IX).
		(N4) Cleanup cross-repo pendente e devido FORA deste commit: o
		mesh-frontend-runtime aponta def-068 (agora withdrawn) e seu reading
		contract ainda não lista a Constituição — ambos migram lá, sob o regime
		daquele repo (dec 6/7).
		"""

	falsificationCondition: {
		condition:        "Esta canonização estará ERRADA SE (a) a lei da expressão no spec precisar de exceção por vendor — um component library/styling tooling concreto exigir mudar camada ou token bound para ser adotável, invertendo QUE/COMO; OU (b) o regime de mudança provar-se inoperante — emendas de camada passando sem ADR com elo superior, ou calibrações exigindo founder por medo de fronteira ambígua; OU (c) a separação lei-no-spec/valores-no-runtime gerar drift real (runtime materializando valores que contradizem token bound sem falha de gate)."
		observableSignal: "(a) PR do frontend-runtime propondo emenda à Constituição motivada por limitação de vendor — visível na cadeia de reabertura da cláusula IX (o elo apontado seria tecnologia, não invariante/personalidade/lei transversal). (b) diff em architecture/design-system/ sem ADR correspondente no mesmo commit (CI adr-coverage acusa mudança semântica em architecture/ sem ADR); ou recalibração de token calibratable escalada ao founder registrada em sessão. (c) divergência nomeada entre valor bound do token-contract e o materializado no runtime, reportada em review ou no futuro harness da linha def-065."
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/structural-checks/production-guide.cue",
		"architecture/deferred-decisions/def-068-frontend-design-system-vendor.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/design-system-constitution.cue",
		"architecture/design-system/_meta.cue",
		"architecture/design-system/constitution.cue",
		"architecture/design-system/canonical-cases.cue",
		"architecture/design-system/token-contract.cue",
		"architecture/production-guides/design-system-constitution.cue",
		"architecture/structural-checks/design-system-constitution.cue",
		"architecture/deferred-decisions/def-086-frontend-design-system-vendor-and-tooling.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
		"governance/readme/tree-generated.cue",
		"README.md",
	]

	defersTo: ["def-086"]

	principlesApplied: [
		"P0 — localização canônica única: a lei da expressão ganha UM lar (spec); valores vivos apontam para ela (runtime materializa sob o token-contract); lenses e adr-150 são referenciados, nunca copiados.",
		"P1 — a Constituição é source of truth da expressão; o que o runtime deriva dela (tema, lint) é gerado/materializado, nunca legislado à mão no runtime.",
		"P10 — gates determinísticos validam (cue vet enums/shape, sc-dsc, valores bound); julgamento estético recomenda (advisory) — nunca veredito.",
		"P12 — governança é código: o regime de mudança (emenda vs calibração) e a classificação de pendências viram estrutura tipada e processo verificável, não prosa solta.",
		"P14 — invariante expressável em tipo é compile-time: verbos canônicos, derivesFrom, changeRegime, classification e o vocabulário de campos de camada são enums/structs fechados.",
	]

	supersedes: []

	rationale: """
		Por que (d) entre (a)-(d): manter runtime-local (a) deixaria decisão
		semântica do founder sem lar canônico — a premissa do def-068 ("antes de
		a marca estar definida") venceu no momento em que a marca foi definida;
		prose sem tipo (b) criaria órfão fora do regime universal de governança;
		acoplar ao contrato de codegen (c) daria à lei transversal o blast
		radius do artefato de geração. O tipo first-class com instância composta
		é o único desenho dos quatro em que preservação integral, governança
		universal (cascade adr-053) e o regime de mudança em dois trilhos
		(emenda/calibração) coexistem.

		Fronteira: este ADR REFINA o qualificador "design system" do adr-157
		sem editá-lo (molde adr-178 — institui sobre o termo, citando a lei
		verbatim), EXECUTA a forma adr-159 no def-068 (withdrawn + sucessor
		estreito), PRESERVA adr-150/adr-158/adr-179/adr-180 intocados e APONTA
		def-061 para procedência de captura. A autoridade semântica do spec sai
		REFORÇADA: a expressão deixa de ser o único domínio de superfície sem
		lei no repositório-autoridade.

		Riscos calibrados: reversibility medium — reverter exige demover um
		tipo do enum/checks/PG e re-alargar def-086 (der-registro trabalhoso,
		sem dado persistido); blastRadius cross-cutting — toca a cadeia de
		frontend (adr-150/157/159/179), a governança de tipos (enum, sc-pg-01,
		sc-meta-02 por derivação) e 3 diretórios de architecture/, mas não
		reescreve mecânica de CI nem contratos de domínio (não é repo-wide).

		Tensão com axiomas: nenhuma. Lenses: as 12 de design fizeram match e
		foram tratadas na dec 8 — a Constituição prevalece como lei; nenhuma
		lens é editada. Precedentes aplicados: adr-180 (pacote completo de tipo
		novo), adr-178 (instituir sobre o qualificador com citação verbatim),
		adr-159 (decomposição withdrawn + sucessor), adr-097/099 (born-warn +
		meta-cobertura), adr-193 (missão como veículo de execução da decisão do
		founder).
		"""
}
