package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainStoryStructuralChecks: build_time.#SelfReviewReport & {
	reportId: "srr-domain-story-structural-checks"

	artifactPath:       "architecture/structural-checks/domain-story.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-05"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 — self-review dos 8 gates referenciais das domain stories (sc-ds-01..08,
			adr-170; sc-ds-04..08 primeiros consumidores do kind item-scoped adr-169).

			[uq-08 CONFORMÂNCIA #StructuralCheck]: OK. cue vet EXIT=0; runner carregou os 8
			checks (contagem de checks subiu; violações 31/0 inalteradas — zero instâncias de
			story no disco). tq-sc-02 (rule↔kind via união discriminada): os 3 cross-file-id-exists
			carregam referencePath/targetGlob/targetIdPath; os 5 item-scoped carregam os 5 campos
			da #ItemScopedCrossFileIdExistsRule (itemsPath/scopeField/refFields/targetGlobTemplate
			com {scope}/targetIdPaths) — vet valida a união.

			[uq-03 REFS CRUZADAS]: OK, verificadas no disco. Alvos existem: domain/stakeholder-map.cue
			com stakeholders[].code (presente nas DUAS shapes — a ponte do def-076); contexts/*/canvas.cue
			com code; strategic/subdomains/*.cue com code; contexts/{scope}/domain-model.cue com
			commands[].code, events[].code, policies[].code, projections[].code,
			projections[].queryCapabilities[].code (path aninhado provado no sc-ag-01).
			artifactType "domain-story" existe no enum #ArtifactType (mesmo commit).

			[tq-sc-01 errorMessage ESPECÍFICA]: OK. Cada mensagem nomeia o elo violado e a
			remediação na regra única do adr-170 (corrigir ref OU registrar a lacuna — nunca
			inventar); sc-ds-05 explica a não-validade da cópia consumida.

			[tq-sc-03 rationale→CASO CONCRETO]: OK. sc-ds-05 cita o cenário provado no self-test
			(evt-invoice-issued em passo cmt FALHA; união global passaria via cópia consumida do
			fce); sc-ds-03 cita o finding WARN 6 do review isolado; demais conectam a adr-169/170.

			[uq-01 WHY]: OK — rationales registram por que o elo importa (ilha narrativa,
			implementação fantasma, falso-verde), não o que a regra faz. [uq-02 MESH]: OK —
			ancorado em sh-*, sourceContext, jornada de compras (sc-ds-08). [uq-04 PRINCÍPIOS]:
			OK — gates determinísticos (P10); born-warn per adr-097 (catraca); refs limpas per P0.
			[uq-06 UL]: OK — read model = projection declarado onde importa (sc-ds-07). [uq-07]:
			OK — zero placeholder.

			[uq-05 LIMITAÇÕES — warn residual declarado]: os 8 checks nascem em VÁCUO-VERDE
			(zero instâncias de domain-story no disco): o runner os avalia trivialmente sem
			violações até a 1ª story existir. A mordida real foi provada por FIXTURE determinística
			no self-test do runner (cmt FALHA / fce PASSA / escopo fantasma acusa), não por
			instância real. Declarado no header do arquivo e no adr-170 (consequências negativas).
			Residual até a 1ª story — promoção warn→reject é a decisão que a acompanha.

			[uq-09 SECTION GATES]: instâncias de structural-check autoradas dentro do arco de
			checkpoint único definido pelo founder (ordem Tempo 2: pacote completo → checkpoint
			pré-commit); auto-checks apresentados em batch no checkpoint (cláusula batch do
			serializationRule — mesmo pattern do def-074).
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message:     "Vácuo-verde: os 8 checks não têm instância real para morder até a 1ª domain story existir; a prova de mordida vive na fixture do self-test do runner (determinística, re-executável), não em instância do disco."
			rationale:   "Limitação DECLARADA (header do arquivo + adr-170 consequências) e vigiada pela falsificationCondition (c) do adr-170; resolve-se na fatia da 1ª story real, junto da decisão de promoção warn→reject."
		}]
	}

	summary: """
		sc-ds-01..08: gates referenciais das domain stories — 3 cross-file plain (ator/BC/subdomínio)
		+ 5 item-scoped (adr-169, building blocks contra o domain-model DO BC DO PASSO). Todos
		born-warn per adr-097. VEREDITO: stable, 0 fail, 1 warn residual declarado (vácuo-verde até
		a 1ª story; mordida provada por fixture determinística no self-test do runner). Refs de alvo
		verificadas no disco; errorMessages específicas com remediação na regra única do adr-170;
		rationales conectados aos casos concretos (falso-verde por cópia consumida; findings do
		review isolado).
		"""

	singleRoundRationale: """
		Round único proporcional: instâncias de tipo existente (#StructuralCheck) cujo desenho foi
		validado em DUAS camadas anteriores — o read-only do Tempo 1 (reconciliação das 3
		manifestações + desenho do kind, aprovado pelo founder) e o review isolado pré-escrita do
		schema #DomainStory (3 BLOCKERs/7 WARNs, todos endereçados no pacote). A mordida dos 5
		item-scoped foi provada deterministicamente na fixture do self-test antes desta revisão.
		Nenhum finding novo emergiu no round além do warn residual já conhecido e declarado.
		"""
}
