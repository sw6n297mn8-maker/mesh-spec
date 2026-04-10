package conventions

// api-spec-convention.cue — Convenção de presença condicionada
// de API specs por capability flags do canvas.
//
// Primeira instância concreta da categoria architecture/conventions/
// criada por adr-046. Sem #Convention schema central nesta fase
// (deferido até n=2, pattern ten-009).
//
// Tipos governados: canvas (#Canvas), openapi-spec (#OpenAPISpec),
// asyncapi-spec (#AsyncAPISpec).
//
// SoT upstream: canvas.capabilities.hasSyncSurface e
// canvas.capabilities.hasAsyncSurface dirigem a presença dos
// specs downstream correspondentes.
//
// Política de materialização: derived — specs são derivados
// mecanicamente de service-contract.cue (SoT autoral em CUE, P1);
// esta convenção declara a relação normativa de presença, não
// gera conteúdo.
//
// Enforcement: structural (determinístico, a ser materializado em
// WI-027 B.2) + advisory (interpretativo, follow-up).
// Separação per adr-040.
//
// ADR correspondente: adr-048.

apiSpecConvention: {
	// ── Tipos governados ──

	governedTypes: [{
		artifactType: "canvas"
		schema:       "architecture/artifact-schemas/canvas.cue"
		definition:   "#Canvas"
		role:         "upstream"
		rationale:    "Canvas declara capability flags (hasSyncSurface, hasAsyncSurface) que dirigem a presença dos specs downstream. É fonte de verdade da intenção de superfície do BC."
	}, {
		artifactType: "openapi-spec"
		schema:       "architecture/artifact-schemas/api-spec.cue"
		definition:   "#OpenAPISpec"
		role:         "downstream"
		rationale:    "Spec derivado da superfície síncrona. Presença é consequência da flag hasSyncSurface no canvas upstream. Conteúdo derivado de service-contract.cue."
	}, {
		artifactType: "asyncapi-spec"
		schema:       "architecture/artifact-schemas/api-spec.cue"
		definition:   "#AsyncAPISpec"
		role:         "downstream"
		rationale:    "Spec derivado da superfície assíncrona. Presença é consequência da flag hasAsyncSurface no canvas upstream. Conteúdo derivado de service-contract.cue."
	}]

	// ── Fontes de verdade por relação ──
	//
	// Nota: sourceField é referência documental para agente/humano,
	// não referência compile-time ao canvas schema. Staleness é
	// detectada pelo structural-check que lê o canvas diretamente,
	// não por este string path.

	upstreamSources: [{
		relation:    "canvas → openapi-spec"
		upstream:    "contexts/{bc}/canvas.cue"
		downstream:  "contexts/{bc}/api.yaml"
		sourceField: "capabilities.hasSyncSurface"
		rationale:   "P0: canvas é a localização canônica da declaração de superfície síncrona. Presença de api.yaml é materialização dessa declaração, não decisão independente."
	}, {
		relation:    "canvas → asyncapi-spec"
		upstream:    "contexts/{bc}/canvas.cue"
		downstream:  "contexts/{bc}/async-api.yaml"
		sourceField: "capabilities.hasAsyncSurface"
		rationale:   "P0: canvas é a localização canônica da declaração de superfície assíncrona. Presença de async-api.yaml é materialização dessa declaração, não decisão independente."
	}]

	// ── Condições de presença ──
	//
	// Precondição geral: canvas.cue deve existir no BC para que
	// as condições abaixo ativem. BC sem canvas.cue → condições
	// não se aplicam (canvas é upstream; sem upstream, não há
	// derivação).
	//
	// Cada condição é bicondicional (if-and-only-if): flag true
	// exige spec, flag false proíbe spec. O campo `inverse` é
	// derivável da negação de `condition` — mantido para clareza
	// de leitura humana; quando o schema central #Convention
	// existir (n=2), pode ser calculado e validado como redundância
	// intencional.
	//
	// A decomposição em campos separados (condition/effect/inverse/
	// scope) é a parte mecanicamente verificável exigida pelo
	// template. Enforcement real é pelo structural-check (B.2) que
	// implementa a lógica — não por parsing destas strings.

	presenceConditions: [{
		condition:     "canvas.capabilities.hasSyncSurface == true"
		effect:        "contexts/{bc}/api.yaml DEVE existir"
		inverse:       "canvas.capabilities.hasSyncSurface == false → contexts/{bc}/api.yaml NÃO DEVE existir"
		scope:         "por bounded context (contexts/{bc}/)"
		migrationNote: "BC que desativa hasSyncSurface deve remover api.yaml no mesmo commit ou no commit imediatamente seguinte. Flag false com spec presente não é estado válido estável — é drift a ser removido antes do próximo gate de conformidade estrutural."
		rationale:     "Flag true sem spec é superfície declarada mas não materializada — promessa vazia. Flag false com spec é spec órfão sem cobertura de canvas — drift silencioso. Bicondicionalidade mantém consistência nos dois sentidos."
	}, {
		condition:     "canvas.capabilities.hasAsyncSurface == true"
		effect:        "contexts/{bc}/async-api.yaml DEVE existir"
		inverse:       "canvas.capabilities.hasAsyncSurface == false → contexts/{bc}/async-api.yaml NÃO DEVE existir"
		scope:         "por bounded context (contexts/{bc}/)"
		migrationNote: "BC que desativa hasAsyncSurface deve remover async-api.yaml no mesmo commit ou no commit imediatamente seguinte. Mesma regra: flag false com spec presente é drift, não estado válido estável."
		rationale:     "Mesma lógica bicondicional: flag e spec devem ser mutuamente consistentes."
	}]

	// ── Política de materialização ──

	materialization: {
		classification: "derived"
		rationale:      "api.yaml e async-api.yaml são derivados mecanicamente de service-contract.cue (SoT autoral em CUE, P1). A convenção governa QUANDO o spec deve existir (bicondicionalidade com canvas flags) — não COMO o conteúdo é gerado. Até que o generator exista, derivação manual é bootstrap operacional, não mudança de classificação."
	}

	// ── Política de validação ──

	validationPolicy: {
		structural: {
			status: "implemented"
			description: """
				Invariante de presença condicionada a flags do canvas
				é fato decidível por inspeção do filesystem — cabe no
				domínio de structural-check per adr-040. Materializada
				em WI-027 B.2 (adr-049).

				Kind utilizado: conditional-file-presence (adicionado
				ao schema de structural-check por adr-049). Instâncias
				sc-cv-02 (hasSyncSurface → api.yaml) e sc-cv-03
				(hasAsyncSurface → async-api.yaml) em
				architecture/structural-checks/canvas.cue enforçam a
				bicondicionalidade: flag true exige target, flag false
				proíbe target.
				"""
			rationale: "Enforcement estrutural materializado por kind dedicado. Análise de expressividade dos kinds v1 (todos intra-artifact) concluiu que extensão explícita era necessária — composição não era semanticamente suficiente."
		}
		advisory: {
			status: "follow-up"
			description: """
				Coerência entre superfícies declaradas no canvas
				(communication entries com interactionMode sync/async)
				e operações declaradas nos specs (paths no OpenAPI,
				channels no AsyncAPI) é dimensão interpretativa —
				LLM pode avaliar se os endpoints cobrem os command
				handlers e queries declarados.

				Cross-ref: tq-cv-11 no canvas schema já avalia
				consistência entre flags e communication entries como
				warn. Esta dimensão advisory estenderia a verificação
				do canvas para o spec downstream — complementar a
				tq-cv-11, não duplicada.

				Não existe validation prompt para 'convention' como
				artifactType. Follow-up para quando este tipo entrar
				no regime de design review.
				"""
			rationale: "Dimensão advisory real mas de custo alto — exige parsing de OpenAPI/AsyncAPI e comparação com communication block do canvas. Deferida conscientemente, não omitida."
		}
	}

	// ── Fronteira regulatória ──

	regulatoryBoundary: {
		statement: """
			Esta convenção governa PRESENÇA de api.yaml/async-api.yaml
			condicionada a flags do canvas — não governa CONTEÚDO dos
			specs. api.yaml e async-api.yaml de BCs regulados (FCE, SCF,
			BKR, REW, IDC, ATO, INS, ITC) podem conter contratos com
			obrigações regulatórias (dp-10, LGPD, KYC/AML). Constraints
			regulatórias sobre conteúdo são responsabilidade de cada BC
			e de enforcement futuro específico ao padrão externo, não
			desta convenção de presença.
			"""
		rationale: "CLAUDE.md fixa constraints regulatórias como invioláveis. Presença condicionada a flag é decisão de completude estrutural, não de conteúdo regulado. Separar explicitamente evita que a convenção seja interpretada como autorizando conteúdo arbitrário em specs de BCs regulados."
	}

	rationale: "Primeira convenção concreta do repositório — codifica o protocolo de presença bicondicional (if-and-only-if) entre canvas (upstream, capability flags) e API specs (downstream, derivados de service-contract.cue). Flag true exige spec, flag false proíbe spec. Materialização derived: specs são projeção mecânica de service-contract.cue (P1). Esta convenção fixa a norma antes do mecanismo; a materialização do gate estrutural permanece dependente de decisão adicional sobre a expressividade do schema de structural-check. Advisory é follow-up complementar a tq-cv-11, deferido por custo de parsing."
}
