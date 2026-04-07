package artifact_schemas

import (
	"list"

	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// lens.cue — Schema para lentes analíticas.
//
// Lenses orientam análise e decisão. Não autorizam execução.
// São artefatos de raciocínio aplicados por agentes para examinar
// problemas da Mesh sob um ângulo específico.

// ═══════════════════════════════════════════════════
// Tipos reutilizáveis
// ═══════════════════════════════════════════════════

#PrincipleRef:     string & =~"^(ax-[0-9]{2}|dp-[0-9]{2}|P[0-9]{1,2})$"
#LensRef:          string & =~"^lens-[a-z][a-z0-9-]*$"
#ConceptRef:       string & =~"^[a-z][a-z0-9]+-[a-z][a-z0-9-]*$"
#NonEmptyString:   string & !=""
#PrincipleRefList: [#PrincipleRef, ...#PrincipleRef]

// ═══════════════════════════════════════════════════
// Referência cross-lens a conceito específico
// ═══════════════════════════════════════════════════

#CrossLensConceptRef: {
	lensId:    #LensRef
	conceptId: #ConceptRef
	context:   #NonEmptyString
}

// ═══════════════════════════════════════════════════
// Lente Analítica
// ═══════════════════════════════════════════════════

#AnalyticalLens: {
	id:   #LensRef
	name: #NonEmptyString

	// Síntese em 1-2 frases do que a lens cobre e por que existe.
	// Permite ao agente decidir se carrega a lens antes de ler 75k+ chars.
	purpose?: #NonEmptyString

	status: *"draft" | "active" | "deprecated"

	// Aplicabilidade por vertical de cadeia produtiva.
	// Opcional na Fase 1 do rollout definido em adr-043:
	// novas lenses devem declarar; lenses existentes permanecem
	// válidas sob backfill progressivo guiado pelo warning de
	// tq-ln-05. Fase 2 (ADR posterior) promove a obrigatório
	// estrutural.
	verticalApplicability?: shared_types.#VerticalApplicability

	trigger: {
		conditions:   [#NonEmptyString, ...#NonEmptyString] & list.MinItems(3)
		keywords:     [#NonEmptyString, ...#NonEmptyString] & list.MinItems(5)
		excludeWhen?: [#NonEmptyString, ...#NonEmptyString]
		rationale:    #NonEmptyString
	}

	concepts:          [#LensConcept, ...#LensConcept] & list.MinItems(5)
	reasoningProtocol: [#ReasoningStep, ...#ReasoningStep] & list.MinItems(4)
	meshExamples:      [#LensExample, ...#LensExample] & list.MinItems(2)

	principleIds: #PrincipleRefList

	relatedLenses?: [#LensRelation, ...#LensRelation]

	limitations: [#LensLimitation, ...#LensLimitation] & list.MinItems(2)

	rationale: #NonEmptyString

	// ── Constraints ──

	_allConceptIDs: [for c in concepts {c.id}]
	_allConceptIDs: list.UniqueItems

	_depsCheck: {
		for c in concepts
		if c.dependsOn != _|_
		for d in c.dependsOn {
			"dep_\(c.id)_\(d)": list.Contains(_allConceptIDs, d) & true
		}
	}

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/lenses/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "Lente analítica para orientar raciocínio de agentes."
			rationale:          "Cada lens vive como arquivo individual em architecture/lenses/."
			cardinality:        "collection"
			allowNested:        false
		}
	}
}

// ═══════════════════════════════════════════════════
// Critérios de qualidade
// ═══════════════════════════════════════════════════

_qualityCriteria: #QualityCriteria & {
	criteria: [{
		id:          "tq-ln-01"
		description: "Critérios de ativação são testáveis"
		test:        "Dado um tipo de decisão concreto, é possível determinar deterministicamente se a lens ativa ou não."
		severity:    "fail"
		rationale:   "Lens que ativa em tudo ou em nada gera overhead sem valor."
	}, {
		id:          "tq-ln-02"
		description: "Protocolo de raciocínio agrega capacidade analítica própria"
		test:        "Os reasoning steps contêm perguntas específicas que levam a análise diferente da aplicação direta de princípios gerais."
		severity:    "fail"
		rationale:   "Lens que duplica princípios é peso morto no context window."
	}, {
		id:          "tq-ln-03"
		description: "Exemplos Mesh são concretos"
		test:        "Cada meshExample referencia cenário reconhecível da Mesh com análise e recomendação específicas."
		severity:    "fail"
		rationale:   "A lens só é útil se mostrar como muda decisões reais dentro da Mesh."
	}, {
		id:          "tq-ln-04"
		description: "Limitações são reais e delimitam uso"
		test:        "Cada limitation descreve onde a lens falha, com alternativa concreta."
		severity:    "warn"
		rationale:   "Lens sem fronteira explícita tende a ser aplicada fora de contexto."
	}, {
		id:          "tq-ln-05"
		description: "Aplicabilidade por vertical declarada (Fase 1 advisory)"
		test:        "O campo verticalApplicability está presente e declara explicitamente o modo (vertical-agnostic, vertical-specific ou vertical-adaptable) com rationale. Ausência do campo é warning na Fase 1 do rollout definido em adr-043; novas lenses devem declarar o campo já na criação. Lenses existentes permanecem estruturalmente válidas e entram em backfill progressivo guiado por este warning."
		severity:    "warn"
		rationale:   "adr-043 Fase 1: campo opcional no schema, obrigatoriedade normativa de authoring sinalizada por warn advisory. Fase 2 promove a fail após backfill completo verificado."
	}]
	rationale: "Critérios garantem que a lens seja acionável, distintiva e calibrada para a Mesh."
}

// ═══════════════════════════════════════════════════
// Conceito dentro de uma lente
// ═══════════════════════════════════════════════════

#LensConcept: {
	id:   #ConceptRef
	name: #NonEmptyString

	// O que o conceito é.
	nature: "theoretical" | "operational"

	// Como o agente o usa.
	role: "framework" | "method" | "property" | "heuristic"

	definition:        #NonEmptyString
	meshManifestation: #NonEmptyString
	meshImplication:   #NonEmptyString
	rationale:         #NonEmptyString

	// CI valida que IDs existem na mesma lens.
	dependsOn?: [#ConceptRef, ...#ConceptRef]

	// CI valida que lensId e conceptId existem.
	crossDependsOn?: [#CrossLensConceptRef, ...#CrossLensConceptRef]

	// Para conceitos operacionais que degradam com o tempo.
	reviewCadence?: "monthly" | "quarterly" | "semi-annual" | "annual" | "event-driven"

	// Condição para ativação do conceito; se ausente, sempre ativo.
	appliesWhen?: #NonEmptyString
}

// ═══════════════════════════════════════════════════
// Step do protocolo de raciocínio
// ═══════════════════════════════════════════════════

#ReasoningStep: {
	question:  #NonEmptyString
	reveals:   #NonEmptyString
	rationale: #NonEmptyString

	appliesWhen?: #NonEmptyString
}

// ═══════════════════════════════════════════════════
// Exemplo concreto na Mesh
// ═══════════════════════════════════════════════════

#LensExample: {
	id:             string & =~"^ex-[a-z][a-z0-9-]*$"
	scenario:       #NonEmptyString
	analysis:       #NonEmptyString
	recommendation: #NonEmptyString

	principlesApplied: #PrincipleRefList

	assumptions: [#NonEmptyString, ...#NonEmptyString]

	rationale: #NonEmptyString
}

// ═══════════════════════════════════════════════════
// Relação qualificada com outra lente
// ═══════════════════════════════════════════════════

#LensRelation: {
	lensId: #LensRef

	// complementsWith: capacidades se somam, bidirecional.
	// tensionWith: lenses podem recomendar ações opostas — agente arbitra.
	// feedsInto: output desta lens é input de outra, direcional.
	// dependsOn: esta lens requer outra como pré-requisito.
	// extends: esta lens aprofunda aspecto coberto superficialmente por outra.
	// supersededBy: esta lens foi substituída por outra (para deprecated).
	// alternativeTo: lenses cobrem mesmo problema com abordagens diferentes.
	relation: "complementsWith" | "tensionWith" | "feedsInto" | "dependsOn" | "extends" | "supersededBy" | "alternativeTo"

	context: #NonEmptyString
}

// ═══════════════════════════════════════════════════
// Limitação da lente
// ═══════════════════════════════════════════════════

#LensLimitation: {
	description: #NonEmptyString
	alternative: #NonEmptyString
	rationale:   #NonEmptyString
}
