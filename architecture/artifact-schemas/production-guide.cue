package artifact_schemas

// production-guide.cue — Meta-schema para production guides.
//
// Define o shape que todo production guide deve satisfazer.
// Production guides são artefatos simétricos a validation prompts:
// validation prompts verificam depois; production guides orientam antes.
//
// Cada production guide governa como um agente produz instâncias
// de um tipo de artefato específico. O guide referencia o schema
// do artefato alvo via sections[].target.
//
// Instâncias vivem em portfolio/production-guides/ (portfólio-wide)
// ou em {repo}/architecture/production-guides/ (repo-local).

import (
	"list"
	"strings"
)

// ──────────────────────────────────────────────
// Tipo principal
// ──────────────────────────────────────────────

#ProductionGuide: {
	_schema: {
		location: {
			canonicalPathRegex: string & !=""
			fileNameRegex:      string & !=""
			description:        string & !=""
			rationale:          string & !=""
			cardinality:        "singleton" | "collection"
			allowNested:        bool | *false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [...#QualityCriterion]
		rationale: string & !=""
	}

	prerequisites:   #Prerequisites
	depthGuidance?:  #DepthGuidance
	workOrder:       [...string & !=""] & list.MinItems(1)
	sections: {[string]: #SectionSpec}
	finalValidation: #FinalValidation

	// ── Invariante estrutural ──
	// workOrder deve ser permutação das chaves de sections.
	// CUE não enforça nativamente "chaves de struct == elementos de lista".
	// Enforçado por structural check ou CI.
}

// ──────────────────────────────────────────────
// Pré-requisitos
// ──────────────────────────────────────────────

#Prerequisites: {
	description: string & strings.MinRunes(20)

	// O que coletar do founder antes de iniciar.
	collectFromFounder: [...string & !=""] & list.MinItems(1)

	// Política de lacunas. Obrigatória em todo guide.
	gapPolicy: string & strings.MinRunes(50)

	// Nota sobre quem valida na fase atual.
	validatorNote?: string & strings.MinRunes(20)

	// Nota sobre o formato esperado dos outputs.
	outputNote?: string & strings.MinRunes(20)

	// Campos adicionais específicos do guide.
	...
}

// ──────────────────────────────────────────────
// Profundidade por fase
// ──────────────────────────────────────────────

#DepthGuidance: {
	description: string & strings.MinRunes(20)

	// Estrutura interna é flexível.
	// Cada guide define a taxonomia de fases conforme o tipo
	// de artefato que governa.
	...
}

// ──────────────────────────────────────────────
// Especificação de seção
// ──────────────────────────────────────────────

#SectionSpec: {
	target:    string & =~"^#[A-Z][A-Za-z]+$"
	objective: string & strings.MinRunes(20)
	process:   [...#ProcessStep] & list.MinItems(1)
	sources?:    [...string & !=""] & list.MinItems(1)
	heuristics?: [...string & !=""] & list.MinItems(1)
	doneCriteria: string & strings.MinRunes(20)
	ifGap?:       string & strings.MinRunes(20)
}

#ProcessStep: {
	action:  string & strings.MinRunes(10)
	detail?: string & strings.MinRunes(10)
}

// ──────────────────────────────────────────────
// Validação final
// ──────────────────────────────────────────────

#FinalValidation: {
	reconciliation?: #Reconciliation
	steps: [...string & !=""] & list.MinItems(1)
}

#Reconciliation: {
	description: string & strings.MinRunes(20)
	pairs: [...string & strings.MinRunes(20)] & list.MinItems(1)
}

// ──────────────────────────────────────────────
// Quality criteria do meta-schema
// ──────────────────────────────────────────────

_productionGuideMeta: {
	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-pg-01"
			description: "workOrder é consistente com chaves de sections"
			test:        "Cada elemento de workOrder existe como chave em sections, e cada chave de sections existe em workOrder. Enforçado por structural check ou CI."
			severity:    "fail"
			rationale:   "Inconsistência entre ordem de trabalho e seções disponíveis quebra o fluxo do agente."
		}, {
			id:          "tq-pg-02"
			description: "Cada seção tem target que resolve para tipo no schema alvo"
			test:        "sections[].target referencia tipo (#TypeName) que existe no artifact schema correspondente. Enforçado por structural check cross-file."
			severity:    "fail"
			rationale:   "Target que não resolve significa que o agente produz output sem shape validável."
		}, {
			id:          "tq-pg-03"
			description: "doneCriteria é avaliável, não aspiracional"
			test:        "Cada sections[].doneCriteria descreve condição verificável por humano ou agente. Advisory: requer julgamento."
			severity:    "warn"
			rationale:   "Critério aspiracional ('deve ser bom') não orienta o agente."
		}, {
			id:          "tq-pg-04"
			description: "gapPolicy é substantiva"
			test:        "prerequisites.gapPolicy tem ao menos 50 runes e inclui instrução concreta sobre como lidar com dados indisponíveis. Enforçado parcialmente por shape (MinRunes); substantividade é advisory."
			severity:    "warn"
			rationale:   "Sem gapPolicy clara, o agente inventa ou trava."
		}, {
			id:          "tq-pg-05"
			description: "Último step de validação é submissão ao founder"
			test:        "finalValidation.steps[-1] menciona submissão, revisão ou aprovação do founder. Advisory: semântico."
			severity:    "warn"
			rationale:   "O founder é o quality gate final. Se o guide não termina com submissão, o ciclo propor→aprovar→escrever está quebrado."
		}, {
			id:          "tq-pg-06"
			description: "Process steps são acionáveis"
			test:        "Cada sections[].process[].action descreve ação concreta que o agente pode executar (pesquisar, perguntar, documentar, calcular, listar), não instrução vaga. Advisory."
			severity:    "warn"
			rationale:   "Ação vaga produz output inconsistente entre execuções."
		}]
		rationale: "Critérios garantem que production guides são operacionais: ordem consistente com seções, targets resolvem, critérios de aceite são avaliáveis, gaps são tratados, e o founder é gate final."
	}

	_schema: {
		location: {
			canonicalPathRegex: "^(portfolio/production-guides|architecture/production-guides)/[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^[a-z0-9-]+\\.cue$"
			description:        "Production guides: instruções de produção para artefatos governados."
			rationale:          "Vivem em portfolio/production-guides/ (portfólio-wide) ou architecture/production-guides/ (repo-local). Simétricos a validation prompts."
			cardinality:        "collection"
			allowNested:        false
		}
	}
}
