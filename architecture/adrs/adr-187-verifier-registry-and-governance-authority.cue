package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr187: artifact_schemas.#ADR & {
	id:    "adr-187"
	title: "Estabelecer o Verifier Registry Mesh e o domínio verifier-governance"
	date:  "2026-08-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		Estado precedente. adr-186 adotou o modelo de prova Tekton
		(evidence-types.cue + verifier-types.cue, incluindo o schema
		#VerifierRegistry) como schemas dormentes, declarou o binding Mesh e
		fixou a condição de resolução de def-084 — mas deliberadamente deixou ao
		binding a morada canônica da instância do Registry no Mesh, a autoridade
		que a governa, e seu lifecycle. Hoje não existe instância de
		#VerifierRegistry no Mesh, e o Mesh não tem allocator/ (a home do
		Registry no Tekton, camada portfolio-level). O motor de work-governance,
		seu estado event-sourced (governance/build-time/work-events/,
		projections/) e sua autoridade de comando (command-rights.cue) vivem
		todos em governance/build-time/ — declarada em repo-structure.cue como
		schemaExemptZone (adr-098): "engine de work-governance + config de
		build-time, subsume task-specs/work-events/projections".

		Trigger. M-182 materializa o enforcement que adr-186 declarou. A primeira
		peça que o enforcement exige é um trust root governado de identidade de
		verifier — sem ele, nada resolve e a catraca de admission (Slice C) não
		tem contra o quê resolver. Mas o trust root não pode ser largado em
		qualquer lugar: é estado de governança event-sourced cujo lifecycle
		precisa de dono. Logo, antes de TaskSpecV2/admission (Slices B/C), a
		morada + a autoridade do Registry precisam ser decididas — a decisão
		estrutural que adr-186 deixou aberta.

		Alternativas avaliadas.
		(a) Morada em allocator/ (espelhar o Tekton). Rejeitada: o Mesh é empresa,
		não o portfólio; allocator/ é a camada portfolio-level do Tekton
		(compatibility/promotion/registry portfolio-wide). O trust root de
		verifier do Mesh é estado do work-governance do Mesh, não allocation de
		portfólio.
		(b) Morada em architecture/artifact-schemas/ ou governance/ raiz (como
		schema/config). Rejeitada: o Registry é instância event-sourced de estado
		governado, não schema nem config declarativa; colocá-lo numa camada de
		tipo/config esconderia estado operacional — o risco nomeado
		explicitamente.
		(c) verifier-governance como autoridade derivada (authorityDerived, como
		ReconcileTask no Tekton) em vez de founder-static. Rejeitada no binding: o
		core Tekton mantém "autoridade competente"; a Mesh decide concretamente
		founder-held para o trust root. authorityDerived reabriria uma decisão que
		o binding fecha.
		(d) Adiar a morada (Registry inline no work-governance.cue ou sem home até
		Slice B). Rejeitada: sem morada + autoridade, o Registry não tem dono de
		lifecycle; B/C bindariam contra um trust root sem governança — o "config
		comum editável" que queremos evitar.
		"""

	decision: """
		(1) ESTABELECER a morada canônica do Verifier Registry Mesh como singleton
		em governance/build-time/verifier-registry.cue — na camada declarada
		(repo-structure schemaExemptZone, adr-098) que já hospeda o motor de
		work-governance e seu estado event-sourced. Instância de #VerifierRegistry
		(schema adotado em adr-186), seed events: [] — nenhum verifier
		pré-registrado; o primeiro entra por evento governado quando houver
		necessidade concreta.

		(2) ESTABELECER verifier-governance como authority domain do binding Mesh,
		com o founder como autoridade decisória terminal desse domínio. Razão
		própria: alterar o trust root muda quais adjudicadores tornam prova
		governada válida → exige a autoridade terminal mais alta do binding Mesh
		(adr-183 é precedente de postura, não a razão — é autoridade de
		reconciliation, distinta). A decisão normativa: registrar/deprecar/revogar
		verifier e conceder/revogar grant exigem decisão founder-held
		(allowedRoles: [founder]). A materialização reusa a taxonomia real de
		eventos do schema adotado (#VerifierRegistryEvent), sem inventar um command
		type por verbo se não for necessário. founder-held != founder executa
		mutações: a autoridade decisória é do founder; agentes executam comandos
		autorizados (separação decisão × execução, como em Git e command-rights).
		A autoridade decisória de verifier-governance existe normativamente desde
		adr-187; adr-187 não cria um direito operacional de mutação. A autorização
		executável e o caminho seguro de mutação nascem juntos no slice que
		materializar os dentes temporais.

		(3) FIXAR a semântica de trust root event-sourced como propriedade
		normativa obrigatória desde a criação: estado canônico = história
		append-only de eventos; identidade/versionamento governados; lifecycle
		forward-only (active → deprecated → revoked, terminal); grants/revogações
		governados; sem edição retrospectiva silenciosa; lifecycle/grants efetivos
		= projeção derivada dos eventos.

		(4) DECLARAR a fase inaugural como não-operacional para mutação. Os dentes
		temporais que tornam a história realmente append-only e causalmente válida
		— equivalentes às invariantes dos gates Tekton check-verifier-append-only e
		check-verifier-causal — não são materializados neste slice; pertencem ao
		Slice C. Até que esses dentes e o caminho governado de mutação estejam
		ativos, o Registry permanece imutável no seed events: []: nenhuma mutação
		produtiva de seu event stream é permitida, mesmo quando a autoridade
		decisória para os comandos já esteja declarada. Nenhuma tarefa Mesh pode
		depender do Registry para admission/completion nesse período. A semântica
		event-sourced/forward-only é normativa desde a criação; Slice C transforma
		essa semântica em enforcement operacional.
		"""

	consequences: """
		Positivas.
		P1 — O trust root de identidade de verifier ganha morada canônica e dono
		de lifecycle na camada correta (build-time, onde o motor e o estado
		event-sourced já vivem); Slices B/C bindam contra governança, não contra
		config editável.
		P2 — A autoridade verifier-governance é explícita e founder-held com razão
		própria — quem pode tornar prova governada válida é decisão terminal, não
		implícita.
		P3 — Seed vazio + semântica event-sourced desde o primeiro byte preserva o
		trust root de estado inaugural especial; o primeiro verifier entra por
		evento governado.
		P4 — A fase inaugural não-operacional é segura por construção: não há
		janela de trust root mutável sem proteção temporal (o Registry é imutável
		em events: [] até Slice C).
		P5 — Escopo tight: não pré-decide TaskSpecV2/admission/completion/verifier
		cross-repo — cada slice seguinte decide o seu.

		Negativas.
		N1 — Estado intermediário: o Registry existe mas é não-operacional até
		Slice C; peça presente sem uso produtivo por um período (mitigado:
		declarado explicitamente bloqueado; nenhuma tarefa depende dele).
		N2 — A autoridade decisória é declarada antes de existir caminho de
		execução seguro (aceito: separação decisão × execução; Slice C fecha).
		N3 — Valor só aparece quando B/C materializam; A isolado é infra sem
		consumidor (justificado: enforcement precisa de trust root primeiro).
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se o Verifier Registry não puder permanecer
			na camada governance/build-time/ sem violar as fronteiras dessa camada,
			ou se a autoridade founder-held impedir o lifecycle normal do trust root
			de ser governado com segurança e disponibilidade sem reclassificar
			operações rotineiras como decisões excepcionais.
			"""
		observableSignal: """
			Slice C só consegue implementar append-only/causal ou mutação governada
			movendo estado/autoridade para outra camada; OU operações legítimas e
			recorrentes de registrar/deprecar/revogar/grant exigem sistematicamente
			uma autoridade diferente da definida aqui para o sistema permanecer
			operável.
			"""
	}

	affectedArtifacts: []

	plannedOutputs: [
		"governance/build-time/verifier-registry.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: ["P0", "P10", "P12", "P14"]

	supersedes: []

	rationale: """
		P0 — localização canônica única: o trust root tem exatamente uma morada;
		adr-186 apontou o schema, adr-187 fixa a instância e sua camada. P10 —
		agentes recomendam, gates validam: o Registry é trust root de gate; a
		autoridade decisória é do founder e agentes apenas executam comandos
		autorizados; e a fase não-operacional (item 4) impede creditar enforcement
		à mera presença do singleton. P12 — governança é código: o Registry + o
		authority domain + a semântica são policy-as-code versionada; e é
		justamente P12 ("toda regra que importa é imposta automaticamente") que
		exige o item 4 — declarar a semântica forward-only sem os dentes que a
		impõem seria uma regra não-enforçada fingindo-se operacional; bloquear uso
		produtivo até Slice C honra P12 em vez de violá-lo. P14 — o modelo tem
		dentes compile-time (invariantes U/R/C do #VerifierRegistry em cue vet) e a
		propriedade runtime-only (append-only/causal da história) coberta por gate
		determinístico em Slice C — exatamente a divisão P14.

		A morada em governance/build-time/ é positiva, não por eliminação: é a
		camada declarada (repo-structure schemaExemptZone, adr-098) do motor de
		work-governance e do seu estado event-sourced. founder-held tem razão
		própria (alterar o trust root muda quais adjudicadores tornam prova
		válida), com adr-183 só como precedente de postura. reversibility medium —
		seed vazio e sem consumidores hoje, mas a decisão cria uma autoridade
		canônica que B/C passam a depender; reverter exige desfazer relações de
		governança, esforço moderado, não trivial. blastRadius cross-artifact — o
		change é puramente aditivo e confina-se a poucos artefatos de governança no
		mesmo domínio build-time (o ADR, o Registry seed, o authority domain
		declarado normativamente, o índice derivado); não toca nenhum artefato
		existente nem TaskSpec/admission/completion (isso é cross-cutting em B/C, não
		aqui).
		"""
}
