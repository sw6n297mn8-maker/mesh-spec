package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-154 — Critério mesh-local para um runtime subordinado a um spec virar repo
// próprio. Torna EXPLÍCITO o critério que adr-148 exerceu implicitamente no
// mesh-runtime, e o aplica para autorizar o frontend-runtime — disparando def-060.
// Autoriza EXISTÊNCIA + fixa critério; NÃO materializa o repo nem entrega
// bootstrap/handoff (isso é PR/repo downstream, fora deste repo).

adr154: artifact_schemas.#ADR & {
	id:    "adr-154"
	title: "Critério para runtime subordinado virar repo próprio (mesh-local); autoriza o frontend-runtime"
	date:  "2026-06-17"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		DEPENDÊNCIA QUEBRADA (a motivação). def-060 (frontend client vendor stack)
		defere a seleção de vendor "materializada JIT quando esse repo nascer" —
		pressupondo um frontend-runtime — mas NENHUM ADR autoriza esse repo a
		existir. def-060 espera uma pré-condição ("o repo nasce") que decisão
		nenhuma no disco satisfaz: dependência quebrada, não teoria. Este ADR existe
		para consertar ISSO — autorizar o repo que def-060 já pressupõe —, não para
		teorizar sobre organização de repositórios.

		CONSERTO SEM AD-HOC. O conserto pontual seria autorizar o frontend-runtime
		caso-a-caso, como adr-148 fez para o mesh-runtime. Mas é a SEGUNDA vez que um
		runtime subordinado a este spec precisa nascer; decidir ad-hoc de novo
		repetiria a derivação implícita em vez de registrá-la. Então formalizamos o
		CRITÉRIO (mesh-local, reusável) e o aplicamos ao caso concreto no mesmo ato. O
		princípio é o MEIO de resolver o def-060 com disciplina — não um exercício de
		taxonomia: sem o frontend-runtime a destravar, não haveria ADR.

		DISTINÇÃO ESTRUTURAL — por que do mesh-spec e não do tekton. Há DUAS
		categorias de repo com governança distinta. (a) Repo de EMPRESA (família
		-spec) nasce no PORTFÓLIO: tekton governa via #RepoBootstrapPlan, cujo
		repoSlug é constrangido por regex a =~"^[a-z0-9-]+-spec$" — o schema
		estruturalmente NÃO consegue representar um "frontend-runtime" (não termina em
		-spec); e o allocator/portfolio-map.cue de tekton registra empresas, não
		runtimes. (b) Runtime SUBORDINADO a um spec (mesh-runtime, frontend-runtime)
		nasce por ADR do SPEC dono — invisível ao portfólio. O regex faz só a perna negativa: prova que o frontend-runtime não nasce pelo
		mecanismo de empresa/portfólio (não é -spec), não que nasça no mesh-spec. A
		perna positiva vem do precedente adr-148 (o mesmo que originou o mesh-runtime):
		como runtime subordinado (categoria b), nasce por ADR do spec dono — logo do
		mesh-spec, não de tekton.

		ESCOPO. DENTRO: o critério para um runtime subordinado a um spec existente
		virar repo próprio. FORA, e NÃO governado por este ADR: repo de empresa (nasce
		no tekton/portfólio, categoria (a)); biblioteca compartilhada; tooling
		genérico; e layout interno de um repo — este último é #RepoStructure /
		adr-052, coisa categorialmente diferente (organiza diretórios DENTRO de um
		repo, não decide SE um repo existe). Cada uma dessas categorias decide-se
		quando surgir, com o mecanismo próprio.

		PRECEDENTE. adr-148 (bootstrap/handoff do mesh-runtime) já aplicou este
		critério, porém IMPLICITAMENTE: derivou a morada do mesh-runtime do filtro
		spec×runtime de adr-138/139 (a spec governa o estável — codegen path P1,
		contratos de Port P7; o runtime detém o volátil — vendor, build, execução —
		atrás da fronteira). adr-148 é precedente de RUNTIME SUBORDINADO, não de
		empresa. Este ADR torna EXPLÍCITO o critério que adr-148 exerceu sem nomear.

		AMARRAÇÃO E EFEITO. Este ADR generaliza adr-148 para regra mesh-local e, ao
		autorizar o frontend-runtime sob essa regra, DISPARA def-060: a pré-condição
		"quando esse repo nascer" passa a estar satisfeita (open → triggered,
		transição editada pelo founder — o runner de triggers não muta arquivos). NÃO
		RESOLVE def-060: o vendor concreto (framework, motor de sync, design system)
		resolve JIT quando o frontend-runtime rodar e escolher seu stack. Este ADR
		autoriza EXISTÊNCIA e fixa o critério; não entrega bootstrap/handoff — o
		análogo concreto de adr-148 (specs de tela, contrato de cliente) vem quando
		houver fatia de frontend real.
		"""

	decision: """
		(1) CRITÉRIO-MÃE (o teste). Um runtime subordinado a um spec existente deve
		virar repo PRÓPRIO quando satisfaz, CONJUNTAMENTE, os três: (i) é
		IMPLEMENTAÇÃO VOLÁTIL — stack/vendor que o spec deliberadamente não decide e
		gira em ciclo próprio, não conteúdo canônico de spec; (ii) vive atrás de uma
		FRONTEIRA DE CONTRATO MATERIAL E VERSIONÁVEL — existe artefato concreto (Ports,
		contrato de API, invariantes) com ORIGEM INDEPENDENTE da decisão de separar,
		não fabricado para passar no teste; (iii) tem INCOMPATIBILIDADE DE CO-HABITAÇÃO
		com o spec repo alta o suficiente para que manter junto custe mais que separar.
		Os três são necessários: faltando qualquer um, fica módulo.

		(2) OS 5 SINAIS — evidência do critério-mãe, NÃO checklist de votos. São
		sintomas correlacionados da mesma raiz (estável-vs-volátil), não cinco
		critérios independentes: (s1) código de natureza distinta / gerado
		não-committável no spec; (s2) stack volátil deferida; (s3) atrás de fronteira
		de contrato (P7/P2); (s4) lifecycle de build/exec/deploy próprio + cadência de
		agente própria; (s5) autoridade clivável — testada pela PRESENÇA do contrato de
		fronteira (ii), não por julgamento subjetivo de "separabilidade". DECLARADO
		EXPLICITAMENTE: um módulo que exibe UM sinal isolado (ex.: só volatilidade
		interna, s2) NÃO vira repo — os sinais evidenciam o critério-mãe, não votam por
		ele.

		(3) ASSIMETRIA DE ERRO (qual erro temer). INCOMPATIBILIDADE FÍSICA (linguagem,
		toolchain, PERÍMETRO de execução, público, ciclo de release distintos) → viés
		SEPARAR: manter junto é o erro caro, contamina o repo estável. Mera
		VOLATILIDADE INTERNA sem incompatibilidade física → viés MÓDULO: separar é o
		erro caro — overhead de coordenação para um founder-solo + agentes, e
		re-absorver é mais barato do que parece porque o contrato de fronteira já isola.
		NA DÚVIDA sem incompatibilidade física: fica módulo.

		(4) APLICAÇÃO ao frontend-runtime (a razão PRÓPRIA, não "satisfaz os sinais do
		mesh-runtime"). O frontend é categoria-SEPARAR pela TRÍADE de incompatibilidade
		física: executa FORA DO PERÍMETRO de controle da Mesh (device do usuário, não
		servidor da Mesh) + PÚBLICO EXTERNO (usuários finais, não operadores) + CICLO DE
		RELEASE PRÓPRIO (app stores, browsers, ciclos de framework). A tríade é o que o
		distingue de mera integração com SDK próprio: um adapter BACEN tem stack
		distinta (s2) mas roda no servidor da Mesh, serve público interno e libera com o
		backend → MÓDULO atrás de Port, não repo. A fronteira de contrato de origem
		independente (ii) está presente: invariantes do adr-150 (AI-first, 3 UX
		patterns, FF-FE-01..08) + contrato de API — ambos preexistem a esta decisão.
		Este item AUTORIZA a existência do frontend-runtime; NÃO entrega handoff (sem
		specs de tela nem contrato de cliente concreto ainda).

		(5) NÃO FAZER AGORA (deferir / fasear). O bootstrap/handoff concreto do
		frontend-runtime (o análogo de adr-148: specs de tela, harness) vem quando
		houver fatia de frontend real. O vendor de stack permanece em def-060 — este
		ADR DISPARA def-060 (open → triggered), não o resolve. O critério é MESH-LOCAL:
		promovível a tekton (regra de portfólio) QUANDO 2+ EMPRESAS o provarem
		(idealmente auster → auster-runtime); hoje 1 empresa (mesh) com 2 runtimes não
		basta para universalizar.

		ALTERNATIVAS CONSIDERADAS.
		(a) Autorização ad-hoc do frontend-runtime (só a decisão pontual, sem
		    formalizar o critério). Rejeitada: é a 2ª derivação do mesmo critério; não
		    registrá-lo força uma 3ª decisão do zero (runtimes futuros de Auster/Agni).
		    O custo de formalizar mesh-local é baixo; o de re-decidir ad-hoc repete-se a
		    cada vez.
		(b) Princípio GERAL de topologia de repos (governando empresa + biblioteca +
		    tooling + layout interno). Rejeitada: overclaim de completude. Empresa nasce
		    no tekton; biblioteca/tooling são categorias não-provadas (N=0); layout
		    interno é adr-052/#RepoStructure. Generalizar além de runtime-subordinado
		    seria teoria sem instância.
		(c) ADR no tekton (nível portfólio). Rejeitada: o frontend-runtime é categoria-B
		    (o regex -spec do #RepoBootstrapPlan o exclui); com N=1 empresa o critério
		    não é portfolio-wide ainda; e tekton não dispõe do maquinário de validação
		    (self-review, structural-checks) que uma decisão estrutural deste peso pede
		    — o mesh-spec dispõe.
		(d) Critério como checklist de 5 eixos com votos independentes. Rejeitada: os 5
		    sinais são correlacionados (mesma raiz), então votos independentes seriam
		    teatro de rigor; critério-mãe + sinais-como-sintomas é mais honesto sobre o
		    que o teste faz.
		"""

	consequences: """
		Positivas.
		(P1c) Conserta a dependência quebrada: def-060 pressupunha um frontend-runtime
		que ADR nenhum autorizava; este ADR autoriza o repo que def-060 já esperava,
		fechando a pré-condição sem decisão ad-hoc.
		(P2c) Critério mesh-local reusável: a próxima decisão de runtime-repo (runtimes
		futuros de Auster/Agni) consulta a regra explícita em vez de re-derivar do zero
		— a 2ª derivação (frontend) é a que paga o custo de formalizar, e as seguintes
		colhem.
		(P3c) Fronteira spec/runtime com teste explícito: o critério-mãe + a assimetria
		de erro dão um teste auditável que resiste aos dois erros — over-fragmentar
		(módulo virar repo por volatilidade isolada) e contaminar (manter junto o
		fisicamente incompatível).

		Negativas (limites intrínsecos do critério, declarados).
		(N1) CUSTO DA SEPARAÇÃO. Todo repo a mais impõe overhead permanente de
		coordenação cross-repo (contrato versionado, CI duplo, cadência) a um
		founder-solo + agentes. O critério mitiga com a assimetria de erro (viés módulo
		quando não há incompatibilidade física), mas não elimina: separar é uma aposta
		cujo custo é contínuo, não um evento único. Por isso o teste exige os três
		conjuntos, não a mera conveniência de isolar.
		(N2) GENERALIZAÇÃO N-PEQUENO. O critério é indutivo sobre 2 runtimes de 1
		empresa (mesh-runtime + frontend-runtime). Pode não capturar o padrão de outra
		empresa; o risco é parecer mais geral do que a evidência sustenta. Mitigação
		estrutural: o critério é mesh-local e só promove a tekton (regra de portfólio)
		com 2+ empresas — a generalização prematura é barrada pela própria regra de
		promoção.
		(N3) CLÁUSULA DE CONTRATO FABRICÁVEL. A condição (ii) exige contrato de ORIGEM
		INDEPENDENTE porque um contrato pode ser fabricado post-hoc para justificar uma
		separação já desejada. A salvaguarda ("não fabricado para passar no teste") é
		declarativa, não enforçável por gate determinístico: o critério resiste ao
		gaming apenas na medida em que quem o aplica respeita a origem-independente do
		contrato. É um limite honesto — o teste pressupõe aplicação de boa-fé na
		clivagem (ii), não a garante.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			O critério estará errado se, na aplicação, produzir erro sistemático em
			QUALQUER um dos dois lados: (a) FALSO-SEPARAR — autorizar como repo próprio
			algo que deveria ser módulo, onde o custo de coordenação cross-repo supera o
			benefício da separação; ou (b) FALSO-MÓDULO — reter como módulo algo que
			deveria ser repo, onde a incompatibilidade física contamina o repo estável.
			Os dois lados importam: um critério que só evita (a) recai em monorepo, e um
			que só evita (b) recai em fragmentação.
			"""
		observableSignal: """
			(a) um repo autorizado por este critério é re-absorvido como módulo de volta
			a um spec, com ADR de reversão registrando custo-de-coordenação > benefício;
			(b) um módulo mantido sob este critério precisa ser extraído tardiamente para
			repo próprio, com ADR de extração citando contaminação física e custo de
			migração maior que o da separação no momento original da decisão.
			"""
	}

	affectedArtifacts: [
		"architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue", // disparado open→triggered (ato do founder per lifecycle manual-review; runner não muta); existente-alterado, não defersTo (def-060 pre-existe, criado por adr-150)
	]

	// frontend-runtime NÃO é plannedOutput: é repo downstream (outro repo), não path
	// de mesh-spec — sua autorização vive na decision. Nenhum artefato novo de
	// mesh-spec é criado além deste ADR.
	plannedOutputs:   []
	derivedArtifacts: []

	// defersTo vazio: este ADR não CRIA deferral novo. def-060 (disparado) é
	// pre-existente. A promoção a tekton e o handoff concreto são escopo futuro
	// (ver rationale), não deferrals governados deste ADR.
	defersTo: []

	principlesApplied: [
		"P1 — gerado nunca hand-authored no spec: o sinal s1 (código não-committável no spec) e a condição (i) de volatilidade alocam a implementação gerada/volátil ao runtime; o critério é P1 elevado de fronteira-de-arquivo para fronteira-de-repo.",
		"P2 — vendor atrás de fronteira: a condição (i) exige que o stack/vendor volátil viva atrás do contrato (ii), nunca no spec; o repo separado é a fronteira física que isola o vendor (anti-lock-in) — P2 aplicado à decisão de morada.",
		"P7 — contrato de Port como fronteira: a condição (ii) é o boundary P7/API concreto; é a PRESENÇA de um contrato preexistente e de origem independente que torna o runtime clivável (s5) — sem Port/contrato, não há o que separar.",
		"P14 — capacidades, não tecnologias: o eixo estável-vs-volátil do critério é o filtro de adr-139 — a spec fixa capacidade/contrato (estável), o runtime detém a tecnologia (volátil); o critério codifica esse filtro como teste de morada de repo.",
		"adr-148 — precedente tornado explícito: adr-148 exerceu este critério implicitamente ao alojar o mesh-runtime; adr-154 o nomeia e generaliza (mesh-local) sem alterar adr-148, que permanece o handoff concreto do mesh-runtime.",
		"adr-138 — raiz da condição (iii): a estratégia de runtime bootstrap (repo separado/subordinado/cadência-de-agente) é a origem da incompatibilidade-de-co-habitação; adr-154 nomeia o que adr-138 decidiu por caso.",
		"adr-139 — filtro spec×runtime: a separação 'spec decide o estável, defere o volátil ao runtime' é a fonte das condições (i)/(ii); adr-154 estende o filtro de 'o que a spec decide' para 'quando o runtime vira repo'.",
	]

	rationale: """
		Opção (formalizar critério mesh-local + aplicá-lo ao frontend-runtime) entre as
		alternativas (a)-(d) da decision: ad-hoc (a) força re-decisão a cada runtime;
		princípio geral de topologia (b) é overclaim sem instância; ADR no tekton (c)
		erra a morada (categoria-B + N=1 empresa) e o maquinário de validação;
		checklist-de-votos (d) finge rigor sobre sinais correlacionados. A escolhida é a
		única que conserta a dependência quebrada de def-060 com disciplina reusável.

		decisionClass structural: cria um critério/relação novo entre artefatos (a regra
		de morada de repo para runtime subordinado), sem redefinir princípio base nem
		SoT de domínio. reversibility medium: reverter enquanto status=proposed e o
		frontend-runtime não materializado é barato (remover o ADR, def-060 volta a
		open); após o repo nascer, reverter custa re-absorção — esforço moderado, sem
		dado persistido nem contrato público. blastRadius repo-wide: o critério é regra
		de governança que toda decisão futura de runtime-repo consulta, e a fronteira
		spec/runtime atravessa o repo inteiro.

		P1/P2/P7/P14: o critério é o filtro estável-vs-volátil (P14/adr-139)
		materializado como teste de morada — a implementação gerada/volátil (P1) e o
		vendor (P2) vivem atrás do contrato de Port (P7), e o repo separado é a fronteira
		física desse isolamento. adr-148/138/139 são a derivação que o critério torna
		explícita.

		Deferimentos e escopo: este ADR DISPARA def-060 (open → triggered), não o cria
		nem o resolve — o vendor concreto resolve quando o frontend-runtime rodar. O
		bootstrap/handoff concreto (o análogo de adr-148: specs de tela, harness) é
		escopo futuro gated por uma fatia de frontend real — NÃO é deferral governado,
		porque é trabalho bloqueado por pré-requisito ausente, não trade-off com gatilho.
		A promoção do critério a tekton é possibilidade futura condicionada a 2+ empresas
		(promoção por evidência do portfólio), não compromisso deste ADR.

		Tensão com axiomas: nenhuma. O critério é conservador quanto a separar (viés
		módulo sob dúvida), alinhado à operação enxuta de um founder-solo; autorizar o
		frontend-runtime não fragmenta por conveniência — satisfaz a tríade de
		incompatibilidade física (perímetro + público + ciclo de release).
		"""
}
