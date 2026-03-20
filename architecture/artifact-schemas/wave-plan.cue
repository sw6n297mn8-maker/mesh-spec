package artifact_schemas

import "list"

// WavePlan — schema para planejamento de ondas de trabalho.
//
// Define a estrutura de um plano de execução: waves contendo tasks,
// com dependências verificáveis e outputs tipados.
//
// Constraints estruturais:
// - Task IDs globalmente únicos (list.UniqueItems).
// - Toda dependência referencia um task ID existente (list.Contains).
// - Cada wave tem pelo menos 1 task; cada task tem pelo menos 1 output.

#WavePlan: {
	id:        string & =~"^W[0-9]{3}$"
	title:     string & !=""
	rationale: string & !=""

	waves: {
		[_]: #Wave
	}

	// ── Constraints ──

	// Lista plana de todos os task IDs no plano.
	_allTaskIDs: [
		for _, w in waves
		for _, t in w.tasks {t.id}
	]

	// Unicidade global: list.UniqueItems falha se houver duplicata,
	// inclusive entre waves diferentes. Mensagem de erro identifica
	// posições dos IDs conflitantes.
	_allTaskIDs: list.UniqueItems

	// Validação de dependências: cada dep deve existir na lista de IDs.
	// Se list.Contains retorna false, a unificação com true falha.
	// Chave composta "dep_{taskId}_{depId}" para mensagem de erro legível.
	_depsCheck: {
		for _, w in waves
		for _, t in w.tasks
		for _, d in t.dependsOn {
			"dep_\(t.id)_\(d)": list.Contains(_allTaskIDs, d) & true
		}
	}

	// Metadata do schema — não exportado para instâncias.
	_schema: {
		location: {
			canonicalPathRegex: "^governance/wave-plan\\.cue$"
			fileNameRegex:      "^wave-plan\\.cue$"
			description:        "Plano de ondas de trabalho: o que entra em cada wave, critérios, dependências."
			rationale:          "Artefato singleton em governance/. Nome fixo porque governa a sequência global de execução."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-wp-01"
			description: "Dependências categorizadas corretamente"
			test:        "Cada entry em dependsOn é necessária para executabilidade, validade estrutural ou correção semântica do output — sua remoção tornaria o output inválido, inconsistente ou semanticamente incorreto. Dependências que servem apenas como contexto ou orientação de modelagem, sem bloquear execução nem invalidar o resultado, devem viver em semanticPrerequisites, não em dependsOn."
			severity:    "fail"
			rationale:   "dependsOn e semanticPrerequisites existem como categorias distintas. Colocar dependência de conhecimento em dependsOn serializa trabalho que poderia ser paralelo; colocar dependência estrutural em semanticPrerequisites permite execução com inputs inválidos."
		}, {
			id:          "tq-wp-02"
			description: "Outputs com paths conformes à estrutura do repositório"
			test:        "Cada output.artifact usa um path que conforma com governance/repo-structure.cue — o diretório destino é uma zona válida e o nome segue as convenções de nomenclatura. Paths inventados que não cabem na estrutura declarada são erro."
			severity:    "fail"
			rationale:   "Wave plan é upstream de execução. Paths inválidos propagam erro para task specs e execução, onde o custo de correção é maior."
		}]
		rationale: "Wave plan governa a sequência de execução. Critérios garantem que dependências e outputs são operacionais, não especulativos."
	}
}

#Wave: {
	id:        string & =~"^W[0-9]{3}-[a-z0-9-]+$"
	title:     string & !=""
	rationale: string & !=""
	tasks:     [...#WaveTask] & list.MinItems(1)
}

// WaveTask — unidade de planejamento dentro de uma wave.
//
// Diferente de #TaskSpec (governance/build-time/work-governance.cue)
// que é a definição operacional completa com version e templateRef,
// usada pelo sistema de execução. #WaveTask é a definição de
// planejamento: o que fazer, o que produz, o que impacta.
// Ambos compartilham #TaskOutput para tipagem consistente de outputs.
#WaveTask: {
	id:         string & =~"^WI-[0-9]{3}$"
	title:      string & !=""
	tshirtSize: "S" | "M" | "L" | "XL"

	// IDs de tasks das quais esta depende.
	dependsOn: [...string & =~"^WI-[0-9]{3}$"]

	// Condições semânticas (não rastreáveis por ID) que devem ser
	// verdadeiras antes da execução.
	semanticPrerequisites: *[] | [...string & !=""]

	// outputs: artefatos produzidos ou alterados diretamente pela tarefa.
	// Devem existir ao final da execução.
	outputs: [...#TaskOutput] & list.MinItems(1)

	// affects: superfície semântica e operacional impactada pela mudança,
	// além dos outputs diretos. Inclui artefatos futuros, regras de CI,
	// validações e instâncias que dependem dos outputs.
	// Útil para: análise de blast radius, descoberta de tarefas
	// dependentes, revisão humana/IA, priorização de revalidação.
	// Omitir quando a tarefa impacta apenas seus outputs diretos.
	// NÃO deve repetir mecanicamente outputs[*].artifact.
	affects: *[] | [...string & !=""]

	rationale: string & !=""
}

#TaskOutput: {
	artifact: string & !=""
	type:     "create" | "update" | "validate"
}
