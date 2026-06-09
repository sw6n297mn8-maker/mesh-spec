package artifact_schemas

import "list"

// golden-example.cue -- Schema para GoldenExample (adr-145).
//
// GoldenExample e a DECLARACAO spec-side de um experimento spec->codigo de um BC:
// o recorte de spec que entra no codegen, as assertions que viram testes, o alvo
// de codegen esperado, e os gates (CONTINUAR/PIVOTAR/ABANDONAR + P1-strict) que
// decidem se a stack continua/pivota/abandona (adr-138 item 7).
//
// DECLARACAO-PURA: zero campo de evidencia. O RESULTADO de rodar o experimento
// (qual gate foi atingido, divergencias medidas) vive em
// governance/build-time/codegen-validation-evidence.cue (WI-137), que REFERENCIA
// o golden-example (direcao evidencia->declaracao, padrao agent-probe-record ->
// targetCanvas). Separar declaracao de evidencia serve o template-role (P3c): o
// fan-out copia a declaracao estavel; a evidencia e por-BC, gerada ao rodar.
//
// Os refs do specSlice/assertionRefs sao strings (ids), validados por review + pelo
// harness de codegen-validation (WI-137) que os EXERCITA ao gerar codigo -- nao por
// structural-check estatico (escolha de adr-145, ver consequences N1).

#GoldenExample: {
	// Identidade type-prefixed: ge-<slug> (tipicamente ge-<bc>-<bd-slug>).
	id: string & =~"^ge-[a-z0-9-]+$"

	// BC dono do experimento.
	boundedContextRef: #BoundedContextRef

	// A businessDecision que o golden-example prova (bd-<slug>); tambem o stem do
	// arquivo (contexts/{bc}/golden-examples/{bd-slug}.cue). String + review/harness
	// (nao cross-ref estatico) -- coerente com a escolha de ref-integrity de adr-145.
	businessDecisionRef: string & !=""

	// Recorte de spec que entra no codegen. Tudo REF (id), nunca copia (P0): a spec
	// canonica vive no domain-model/canvas do BC; aqui so se aponta.
	specSlice: {
		invariantRefs: [string & !="", ...string & !=""] // inv-* provados (>=1)
		commandRefs: [string & !="", ...string & !=""] // cmd-* do fluxo (>=1)
		eventRefs: [string & !="", ...string & !=""] // eventos emitidos (>=1)
		aggregateRef:                                string & !="" // agg-* + a transicao de estado provada
		rationale:                                   string & !=""
	}

	// Refs a instancias #Assertion (assertion-schema, WI-133) que viram testes:
	// >=1 caso valido + >=1 invalido derivam dessas assertions. Strings (ids).
	assertionRefs: [string & !="", ...string & !=""]

	// O que o codegen-contract (adr-140) DEVE gerar para o recorte -- declaracao do
	// esperado, NAO o gerado (o codigo gerado vive no mesh-runtime/scratch, nunca
	// commitado; P1 estrito).
	codegenTarget: {
		kinds: [#CodegenKind, ...#CodegenKind] & list.UniqueItems
		rationale: string & !=""
	}

	// Gates de adr-138 item 7 como CONDICAO (criterio de decisao), nunca resultado.
	// O resultado medido (qual gate foi atingido) vive na evidencia (WI-137).
	gates: {
		continuar:           string & !="" // condicao de CONTINUAR
		pivotar:             string & !="" // condicao de PIVOTAR (revisar spec/toolchain)
		abandonar:           string & !="" // condicao de ABANDONAR/re-escolher toolchain
		p1Strict:            string & !="" // proibicao de edicao semantica do gerado + excecoes permitidas
		falsificationSignal: string & !="" // definicao do sinal (ex.: divergencia estrutural > 0 sem ADR) -- definicao, nao medicao
		rationale:           string & !=""
	}

	// Papel de template do fan-out (P3c): a declaracao e o molde copiado para outros
	// BCs; divergencia estrutural do template exige ADR (politica, nao medicao).
	templateRole: {
		isTemplate:       bool | *true
		divergencePolicy: string & !="" // ex.: "divergencia estrutural do template exige ADR"
		rationale:        string & !=""
	}

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/golden-examples/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "GoldenExample: declaracao spec-side do experimento spec->codigo de um BC (per-BC, em golden-examples/)."
			rationale:          "Vive em contexts/{bc}/golden-examples/ porque e per-BC e referencia para agentes (README); cardinality collection (1+ por BC). A evidencia de run e separada (codegen-validation-evidence, WI-137)."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-ge-01"
			description: "Declaracao-pura: zero campo de evidencia/resultado"
			test:        "A instancia NAO contem resultado de run (qual gate foi atingido, divergencias medidas, status de execucao) nem ponteiro de evidencia. gates.* sao CONDICAO, nao resultado. A evidencia vive em governance/build-time/codegen-validation-evidence.cue (WI-137), que referencia o golden-example."
			severity:    "fail"
			rationale:   "Misturar declaracao/evidencia quebra o template-role (P3c): o fan-out copiaria resultado-de-run obsoleto. A direcao canonica e evidencia->declaracao (padrao agent-probe-record)."
		}, {
			id:          "tq-ge-02"
			description: "specSlice e assertionRefs apontam artefatos reais do BC"
			test:        "Cada invariantRef/commandRef/eventRef/aggregateRef existe no domain-model/canvas do boundedContextRef; cada assertionRef existe como instancia #Assertion. Verificado por review + pelo harness de codegen-validation (WI-137); nao ha structural-check estatico (adr-145 N1)."
			severity:    "fail"
			rationale:   "Golden-example sobre refs inexistentes nao gera codigo -- o harness falha. Refs reais sao a substancia do experimento spec->codigo."
		}, {
			id:          "tq-ge-03"
			description: "gates completos e expressos como condicao"
			test:        "gates declara continuar, pivotar, abandonar, p1Strict e falsificationSignal, cada um como CONDICAO (criterio de decisao), nunca como resultado medido. Coerente com adr-138 item 7."
			severity:    "fail"
			rationale:   "Gate incompleto ou expresso como resultado descaracteriza o real-options de adr-138 (gates definidos ANTES do run) e contamina a declaracao com evidencia."
		}]
		rationale: "Os 3 criterios cobrem a disciplina central do GoldenExample: declaracao-pura (tq-ge-01, a separacao declaracao/evidencia que serve o template-role), refs reais (tq-ge-02, a substancia do experimento, review/harness-trusted) e gates-como-condicao (tq-ge-03, o real-options de adr-138). A conformance de codegen real e a evidencia de run sao da WI-137, fora destes criterios."
	}
}

// Tipos de artefato que o codegen-contract (adr-140) gera a partir do recorte.
// Vocabulario = output.artifacts do codegen-contract (adr-140, fonte canonica do
// que se gera) + assertion-tests do pipeline adr-138 item 2. Localizacao canonica
// unica do enum (P0).
#CodegenKind: "types" | "validators" | "stubs" | "aggregate-skeleton" | "port-contracts" | "contract-tests" | "assertion-tests"
