package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

frontendCodegenContractSc: build_time.#SelfReviewReport & {
	reportId: "srr-frontend-codegen-contract-sc"

	artifactPath:       "architecture/structural-checks/frontend-codegen-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-28"

	roundsExecuted: 1
	maxRounds:      3
	status:         "stable"

	singleRoundRationale: """
		Round único: o conteúdo dos checks foi aprovado pelo founder na
		proposta consolidada (§4, com a correção #4 explícita) e as
		resoluções de execução foram VERIFICADAS mecanicamente contra as
		fontes deterministas (shape do #StructuralCheck; evaluators do
		runner; sondas adversariais cue vet em scratchpad; runner real
		verde) — a dimensão restante é reporte de escolha ao founder no
		checkpoint, não julgamento adicional de review. Precedente de modo
		e rounds: srr-production-guide-sc-golden-example-coverage
		(structural-check → self-reported, round único).
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review dos 6 checks sc-fcc-01..06 (adr-180 dec 5),
			born-reject com a condição da catraca verificada no ato
			(instância única do contrato verde por construção; precedentes
			adr-171 + sc-ag-03/adr-176). Draft dos 5 checks aprovado pelo
			founder na proposta consolidada (§4) com 1 correção explícita
			("sc-fcc-05 deve cobrir activeBoundaries[] como a description
			promete") e 2 decisões de execução delegadas com dever de
			reporte. Resolução na escrita, verificada contra o schema
			#StructuralCheck e o runner reais: (a) #CrossFileIdExistsRule
			tem referencePath SINGULAR → cobertura dividida em sc-fcc-05
			(migrationRef) + sc-fcc-06 (activeBoundaries) — a opção
			'check próprio' da correção do founder; (b) nenhum kind
			expressa predicado condicional por item → sc-fcc-01/02 nascem
			com o kind mais próximo (regex-pattern-match: commandRef
			bem-formado; discriminador do enum fechado) com a lacuna do
			runner NOMEADA no próprio check (padrão rule-latente do
			sc-pg-01) — o caso adversarial integral é fechado pela 1ª
			camada (cue vet, provado por 4 sondas adversariais em
			scratchpad); (c) descoberta na escrita: ev_item_scoped do
			runner itera apenas itemsPath-LISTA e families é struct-keyed
			→ sc-fcc-03/04 declaram a semântica item-scoped exata
			(adr-169) e ficam LATENTES até o runner iterar dict-values —
			lacuna nomeada no header e nas descriptions. tq-sc-01..03
			conferidos (errorMessages específicas; rules conformes aos
			kinds via união discriminada — cue vet pass; rationales
			ancorados em adr-179/adr-180/adr-169). Runner real executado:
			sc-fcc-05/06 EXERCITADOS com refs reais (def-081;
			def-064/065/081), sc-fcc-01/02 exercitados nos valores reais
			(3 commandRefs; 3 kinds), 29 warns pré-existentes / 0
			bloqueantes — os 6 checks verdes.
			"""
	}]

	findings: {}

	summary: """
		Gates do tipo frontend-codegen-contract nascendo na mesma fatia da
		promoção (cascade adr-170): 2 checks adversariais do mandato
		adr-179 (com expressividade honesta — resíduo avaliável hoje +
		lacunas do runner nomeadas, padrão rule-latente), 2 checks
		item-scoped de refs de domínio (semântica adr-169 exata; latentes
		até o runner iterar dict-values), 2 checks cross-file de defs
		(migrationRef + activeBoundaries — split exigido pelo shape
		singular do kind, per correção do founder na aprovação). Todos
		born-reject com catraca verificada no ato; escolhas de execução
		reportadas no checkpoint da fatia per instrução do founder.
		"""
}
