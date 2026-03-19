package artifact_schemas

import "list"

// TaskTemplate — schema para instruções reutilizáveis de execução de tarefas.
//
// Define o "como" de um tipo de tarefa: o que ler antes, quais passos seguir,
// e quais gates de qualidade devem passar. Complementa #TaskSpec (o "quê")
// com protocolo de execução.
//
// Instâncias vivem num mapa indexado por ID em arquivo singleton.
// Map pattern garante unicidade de IDs e evita colisão de campos CUE
// entre múltiplas definições no mesmo package.

#TaskTemplate: {
	id:      string & =~"^tmpl-[a-z][a-z0-9-]*$"
	version: int & >=1

	// Classificação fechada do tipo de tarefa. Permite roteamento
	// por agente, validação de templateRef e analytics.
	kind: "create-schema" | "validate-artifact" | "create-instance"

	title:         string & !=""
	applicability: string & !=""
	rationale:     string & !=""

	// Leituras obrigatórias antes de iniciar execução.
	// Complementa a tabela "Referências por Tipo de Operação" do CLAUDE.md
	// com leituras específicas do tipo de tarefa.
	preReads: [...#PreRead] & list.MinItems(1)

	// Passos de execução. Ordem é posição na lista — sem campo order
	// explícito para eliminar ambiguidade de duplicatas ou gaps.
	// Agente segue sequencialmente, mas pode adaptar quando rationale
	// do passo não se aplica ao contexto concreto.
	steps: [...#Step] & list.MinItems(1)

	// Gates de qualidade obrigatórios antes de considerar a tarefa completa.
	// Todo gate é mandatório — se algo é opcional, não é gate.
	qualityGates: [...#QualityGate] & list.MinItems(1)

	_schema: {
		location: {
			canonicalPathRegex: "^ai-orchestration/agent-instructions/task-templates\\.cue$"
			fileNameRegex:      "^task-templates\\.cue$"
			description:        "Templates de execução de tarefas. Mapa indexado por template ID."
			rationale:          "Arquivo singleton com mapa evita colisão de campos CUE. Se volume crescer, migrar para package com arquivos separados."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-tt-01"
			description: "Steps verificáveis como concluídos"
			test:        "Cada step.action descreve uma ação com resultado observável: é possível determinar se o step foi executado ou não. Ações como 'considerar o contexto' ou 'pensar sobre implicações' não são verificáveis — devem ser reformuladas como ações com output concreto (e.g., 'listar implicações no rationale')."
			severity:    "fail"
			rationale:   "Templates com steps não verificáveis permitem execução ritual sem substância — o agente 'passa pelos steps' sem produzir resultado observável."
		}, {
			id:          "tq-tt-02"
			description: "Quality gates não redundantes com universalCriteria"
			test:        "Nenhum quality gate do template repete ou parafraseia um critério já coberto por universalCriteria de quality-gate.cue. Para distinguir: se o gate se aplica a qualquer tipo de artefato, é universal e pertence a quality-gate.cue; se só faz sentido para o tipo de tarefa do template, é especialização legítima."
			severity:    "warn"
			rationale:   "Redundância entre gates e universalCriteria cria ambiguidade sobre qual prevalece e infla o checklist sem agregar cobertura."
		}]
		rationale: "Task templates governam execução do agente. Critérios garantem que o protocolo é operacional, não cerimonial."
	}
}

#PreRead: {
	// Path, glob, referência indireta ou pattern contextual.
	// targetType tipifica a semântica para evitar que agente
	// trate prosa como path literal.
	target:     string & !=""
	targetType: "path" | "glob" | "derived-from-task-output" | "contextual-pattern"

	// Tipifica condicionalidade em vez de expressar em prosa.
	// "always": ler sempre. "if-exists": ler se o arquivo existir no repo.
	// "if-applicable": ler se o contexto da tarefa demandar (rationale explica quando).
	condition: *"always" | "if-exists" | "if-applicable"

	rationale: string & !=""
}

#Step: {
	action:    string & !=""
	rationale: string & !=""
}

#QualityGate: {
	gate:      string & !=""
	rationale: string & !=""
}
