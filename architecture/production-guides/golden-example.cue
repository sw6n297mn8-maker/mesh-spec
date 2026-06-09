package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// golden-example.cue -- Production guide para GoldenExample (adr-145).
//
// Schema alvo: #GoldenExample (architecture/artifact-schemas/golden-example.cue).
// Cardinality collection -- um GoldenExample por experimento spec->codigo de BC,
// em contexts/{bc}/golden-examples/{bd-slug}.cue. Cascade ordering (sc-pg-01):
// este PG existe ANTES de qualquer instancia (WI-137).
//
// DECLARACAO-PURA: o autor preenche so a declaracao (recorte de spec, assertions,
// alvo de codegen, gates como condicao, papel de template). A EVIDENCIA de run
// (qual gate, divergencias) NAO e autorada aqui -- vive em codegen-validation-
// evidence (WI-137), que referencia o golden-example.

goldenExampleGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/golden-example\\.cue$"
			fileNameRegex:      "^golden-example\\.cue$"
			description:        "Production guide para autoria de GoldenExample (per-BC) em mesh-spec."
			rationale:          "#GoldenExample e instanciavel (cardinality collection); sc-pg-01 exige PG antes de instancia (WI-137). Cascade ordering (adr-054 dec 13)."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-geg-01"
			description: "Guide forca refs reais no specSlice/assertionRefs"
			test:        "Process exige verificar que cada invariant/command/event/aggregate do specSlice e cada assertionRef existe no domain-model/canvas do BC (ou como instancia #Assertion) ANTES de declarar. Hardening de tq-ge-02 pelo lado de processo."
			severity:    "fail"
			rationale:   "O agente tende a preencher refs por inferencia; golden-example sobre ref inexistente nao gera codigo (o harness WI-137 falha)."
		}, {
			id:          "tq-geg-02"
			description: "Guide proibe modelar evidencia (declaracao-pura)"
			test:        "gapPolicy declara que o resultado de run (qual gate atingido, divergencias medidas, status) NAO e autorado no golden-example -- vive em codegen-validation-evidence (WI-137). O autor preenche so a declaracao; gates sao condicao, nao resultado."
			severity:    "fail"
			rationale:   "Declaracao com evidencia embutida quebra o template-role (P3c) -- a copia do fan-out arrastaria resultado obsoleto. Direcao canonica evidencia->declaracao."
		}]
		rationale: "2 criterios cobrem as disciplinas centrais de autoria de GoldenExample: refs reais (tq-geg-01, hardening de tq-ge-02) e declaracao-pura (tq-geg-02, separacao declaracao/evidencia). tq-ge-01/02/03 do schema cobrem a instancia; tq-geg-XX cobrem o processo de autoria."
	}

	prerequisites: {
		description: "Antes de autorar um GoldenExample, o agente le o schema #GoldenExample, o adr-138 (mecanismo: escopo microscopico, pipeline, gates item 7, P1-strict, template P3c), o adr-145 (o tipo), o codegen-contract (adr-140, o que se gera) e o domain-model/canvas/assertions do BC para saber quais refs o recorte usa. GoldenExample DECLARA o experimento; a evidencia de run vive em codegen-validation-evidence (WI-137)."
		collectFromFounder: [
			"boundedContextRef: code do BC dono do experimento -- verificar que contexts/{bc}/ existe.",
			"businessDecisionRef: a bd-<slug> que o golden-example prova (= stem do arquivo).",
			"specSlice: invariantRefs (inv-*), commandRefs (cmd-*), eventRefs, aggregateRef (agg-*) + a transicao de estado provada -- todos existentes no domain-model/canvas do BC.",
			"assertionRefs: instancias #Assertion (assertion-schema) que viram testes (>=1 caso valido + >=1 invalido).",
			"codegenTarget.kinds: o que o codegen-contract gera (output.artifacts do codegen-contract adr-140 + assertion-tests adr-138 item 2): types/validators/stubs/aggregate-skeleton/port-contracts/contract-tests/assertion-tests.",
			"gates: as condicoes CONTINUAR/PIVOTAR/ABANDONAR + p1Strict + falsificationSignal (adr-138 item 7) -- como CONDICAO, nao resultado.",
			"templateRole: papel de template (P3c) + politica de divergencia (divergencia estrutural exige ADR).",
		]
		gapPolicy:     "NAO inventar refs -- verifique que cada invariant/command/event/aggregate/assertion existe; ref inexistente quebra o harness (WI-137). NAO modele EVIDENCIA: resultado de run (qual gate atingido, divergencias medidas, status de execucao) vive em codegen-validation-evidence (WI-137), nao no golden-example. NAO exprima gates como resultado -- gates sao condicao definida ANTES do run (real-options, adr-138). NAO copie spec do domain-model -- aponte por ref (P0). Quando duvida, pergunte ao founder; nunca preencha por inferencia."
		validatorNote: "Em Phase 0: (a) cue vet para shape (regex de id ge-*, campos required, #CodegenKind membership, UniqueItems); (b) founder review semantico; (c) ref-integrity do specSlice/assertionRefs e REVIEW + harness-trusted (WI-137 exercita os refs ao gerar codigo) -- NAO ha structural-check estatico (adr-145 N1, escolha vs redundancia com o harness). sc-pg-01 cobre a existencia deste PG."
		outputNote:    "Output e contexts/{bc}/golden-examples/{bd-slug}.cue conformante a #GoldenExample. 1+ por BC. Declaracao-pura: zero campo de evidencia."
	}

	workOrder: [
		"identity-and-slice",
		"assertions",
		"codegen-target",
		"gates",
		"template-role-and-rationale",
	]

	sections: {
		"identity-and-slice": {
			target:    "#GoldenExample"
			objective: "Declarar identidade (id ge-*, boundedContextRef, businessDecisionRef) e o specSlice (invariant/command/event/aggregate refs) do recorte microscopico."
			process: [{
				action: "Determinar id ge-<slug> e businessDecisionRef"
				detail: "id type-prefixed (^ge-[a-z0-9-]+$), tipicamente ge-<bc>-<bd-slug>. businessDecisionRef e a bd-* provada (= stem do arquivo)."
			}, {
				action: "Declarar boundedContextRef verificando o BC"
				detail: "code do BC; verificar que contexts/{bc}/ existe."
			}, {
				action: "Listar specSlice por ref"
				detail: "invariantRefs/commandRefs/eventRefs/aggregateRef -- cada um existente no domain-model/canvas do BC. Aponte, nao copie (P0)."
			}]
			sources: [
				"architecture/artifact-schemas/golden-example.cue (#GoldenExample, specSlice)",
				"contexts/{bc}/domain-model.cue + canvas.cue (invariants/commands/events/aggregates reais)",
				"architecture/adrs/adr-138-runtime-bootstrap-strategy.cue (escopo microscopico, item 2)",
			]
			heuristics: [
				"Escopo MICROSCOPICO: um aggregate em torno de uma businessDecision, nao o BC inteiro (adr-138 item 2).",
				"Todo ref do specSlice existe no domain-model/canvas -- nao inventar.",
			]
			doneCriteria: "id ge-* valido; boundedContextRef de BC existente; businessDecisionRef bd-*; specSlice com invariant/command/event/aggregate refs reais e nao-vazios."
			ifGap:        "Se nao se sabe qual recorte, derivar da businessDecision microscopica de adr-138; nao adivinhar refs."
		}
		"assertions": {
			target:    "#GoldenExample"
			objective: "Declarar assertionRefs -- as instancias #Assertion que viram testes (caso valido + invalido)."
			process: [{
				action: "Listar assertionRefs existentes"
				detail: "Refs a instancias #Assertion (assertion-schema, WI-133). >=1 assertion cujo teste cobre >=1 caso valido + >=1 invalido."
			}]
			sources: [
				"architecture/shared-schemas/assertion-schema.cue (#Assertion)",
				"contexts/{bc}/domain-model.cue (o invariant que a assertion formaliza)",
			]
			heuristics: [
				"A assertion e a ponte invariant->teste; sem assertion real nao ha teste gerado (o gate CONTINUAR de adr-138 exige testes que passam).",
			]
			doneCriteria: "assertionRefs nao-vazio; cada ref e instancia #Assertion; cobrem caso valido + invalido."
			ifGap:        "Se a assertion ainda nao existe, ela e pre-requisito (WI-137 materializa a instancia #Assertion) -- nao referenciar id fantasma."
		}
		"codegen-target": {
			target:    "#GoldenExample"
			objective: "Declarar codegenTarget.kinds -- o que o codegen-contract (adr-140) deve gerar para o recorte."
			process: [{
				action: "Listar os kinds esperados"
				detail: "Subconjunto do vocabulario de output do codegen-contract (adr-140): types/validators/stubs/aggregate-skeleton/port-contracts/contract-tests/assertion-tests."
			}]
			sources: [
				"architecture/artifact-schemas/golden-example.cue (#CodegenKind)",
				"governance/build-time/codegen-contract.cue (o contrato spec->runtime)",
				"architecture/adrs/adr-138-runtime-bootstrap-strategy.cue (pipeline, item 6)",
			]
			heuristics: [
				"codegenTarget DECLARA o esperado; o codigo gerado NAO e commitado aqui (P1 estrito, mesh-runtime/scratch).",
			]
			doneCriteria: "codegenTarget.kinds nao-vazio, sem duplicatas, coerente com o pipeline de adr-138."
			ifGap:        "Se nao se sabe o que gerar, derivar do pipeline de adr-138 item 6; nao listar kind sem uso no recorte."
		}
		"gates": {
			target:    "#GoldenExample"
			objective: "Declarar os gates (CONTINUAR/PIVOTAR/ABANDONAR + p1Strict + falsificationSignal) como CONDICAO, per adr-138 item 7."
			process: [{
				action: "Declarar cada gate como condicao"
				detail: "continuar/pivotar/abandonar conforme adr-138 item 7; p1Strict = proibicao de edicao semantica do gerado + excecoes (header/format/scaffolding documentado fora do gerado); falsificationSignal = definicao do sinal (ex.: divergencia estrutural > 0 sem ADR)."
			}]
			sources: [
				"architecture/adrs/adr-138-runtime-bootstrap-strategy.cue (gates, item 7; falsificationCondition)",
			]
			heuristics: [
				"Gate e CONDICAO definida ANTES do run (real-options) -- nunca o resultado medido (esse e evidencia, WI-137).",
				"p1Strict lista as UNICAS excecoes permitidas a edicao do gerado.",
			]
			doneCriteria: "continuar, pivotar, abandonar, p1Strict e falsificationSignal preenchidos como condicao."
			ifGap:        "Se uma condicao nao e clara, citar adr-138 item 7 literalmente; nao exprimir como resultado."
		}
		"template-role-and-rationale": {
			target:    "#GoldenExample"
			objective: "Declarar templateRole (P3c) e compor o rationale do golden-example."
			process: [{
				action: "Declarar templateRole"
				detail: "isTemplate (tipicamente true) + divergencePolicy (divergencia estrutural do template exige ADR, adr-138 falsificationCondition)."
			}, {
				action: "Compor rationale"
				detail: "Por que este recorte e o golden-example do BC -- ancorado no escopo microscopico real, nao generico."
			}]
			sources: [
				"architecture/adrs/adr-138-runtime-bootstrap-strategy.cue (template P3c)",
				"architecture/adrs/adr-145-golden-example-artifact-governance.cue (o tipo, separacao declaracao/evidencia)",
			]
			heuristics: [
				"templateRole e papel/politica (declaracao), nao medicao de divergencia (evidencia).",
				"rationale explica o recorte, nao repete os campos.",
			]
			doneCriteria: "templateRole preenchido (isTemplate + divergencePolicy); rationale substantivo; zero campo de evidencia em toda a instancia."
			ifGap:        "Se o rationale fica generico, ancorar no aggregate/businessDecision concreto do BC."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instancia valida contra #GoldenExample (id ge-*, campos required, #CodegenKind membership, UniqueItems).",
			"Verificar tq-pg-01: workOrder e permutacao exata das chaves de sections (5 sections).",
			"Verificar tq-pg-02: cada section.target = #GoldenExample (existe no schema).",
			"Verificar tq-geg-01: specSlice/assertionRefs apontam artefatos reais do BC (review + harness WI-137).",
			"Verificar tq-geg-02 (declaracao-pura): nenhum campo modela evidencia/resultado de run (vive em codegen-validation-evidence, WI-137).",
			"Submeter ao founder para aprovacao explicita antes de commit (gate humano, adr-057).",
		]
	}
}
