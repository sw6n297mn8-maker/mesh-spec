package artifact_schemas

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"

// canvas.cue — Artifact schema para Bounded Context Canvas.
//
// Define a estrutura válida para o documento raiz de cada BC.
// Campos classification e capabilities são consumidos por
// bounded-context-completeness.cue para avaliação condicional
// de presença de artefatos.

#Canvas: {
	// Código lowercase do BC.
	// CI valida que id coincide com o nome do diretório em contexts/<id>/.
	id: string & =~"^[a-z][a-z0-9-]*$"

	// Nome completo do Bounded Context.
	name: string & !=""

	// Propósito do BC — por que este contexto existe.
	purpose: string & !=""

	// Classificação estratégica do subdomínio.
	classification: #BCClassification

	// Capabilities declaradas — governam completude condicional.
	capabilities: {
		// Capacidades operacionais que o BC entrega.
		operational: [#OperationalCapability, ...#OperationalCapability]

		// Flags consumidas por bounded-context-completeness.cue.
		hasDomainAgents: bool
		hasSyncSurface:  bool
		hasAsyncSurface: bool
	}

	// Stakeholders afetados por este BC, com referência ao mapa canônico.
	stakeholders: [#CanvasStakeholder, ...#CanvasStakeholder]

	// Custos de transação que este BC elimina, com referência aos ce-NN canônicos.
	costsEliminated: [#CanvasCostContribution, ...#CanvasCostContribution]

	// Referência ao glossário local do BC.
	// CI valida que o artefato referenciado existe.
	ubiquitousLanguageRef: string & !=""

	// Análise de incentivos — alinhamento com dp-08.
	incentiveAnalysis: #IncentiveAnalysis

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^contexts/[a-z][a-z0-9-]*/canvas\\.cue$"
			fileNameRegex:      "^canvas\\.cue$"
			description:        "Bounded Context Canvas: documento raiz de identidade e capabilities de cada BC."
			rationale:          "Canvas é o rootArtifact do sistema de completude. Vive na raiz do diretório do BC porque é a primeira coisa que um agente deve ler ao operar no contexto."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-cv-01"
			description: "Purpose justifica o contorno do BC"
			test:        "O campo purpose explica por que este contexto é separado e qual responsabilidade é exclusivamente dele. Um purpose que descreve funcionalidade, que poderia ser nome de módulo, ou que se aplicaria igualmente a outro BC, falha."
			severity:    "fail"
			rationale:   "Purpose guia decisões de contorno. Se não justifica separação, o BC não tem critério para aceitar ou rejeitar responsabilidades."
		}, {
			id:          "tq-cv-02"
			description: "Stakeholder refs apontam para IDs existentes no stakeholder map"
			test:        "Cada stakeholders[].stakeholderRef corresponde a um id válido em domain/stakeholder-map.cue. Referência a sh-NN inexistente é finding fail."
			severity:    "fail"
			rationale:   "Referências quebradas a stakeholders tornam a rastreabilidade ilusória."
		}, {
			id:          "tq-cv-03"
			description: "Incentive analysis identifica manipulação com custo concreto"
			test:        "incentiveAnalysis.participants contém pelo menos uma entrada com manipulationCost e vsBenefit preenchidos. Custo deve ser concreto e comparável ao benefício — 'difícil de manipular' sem quantificação relativa falha."
			severity:    "fail"
			rationale:   "dp-08 exige que custos de manipulação excedam benefícios por design. Canvas sem análise concreta não demonstra alinhamento."
		}, {
			id:          "tq-cv-04"
			description: "Custos eliminados são rastreáveis ao domínio"
			test:        "Cada costRef em costsEliminated referencia ce-NN existente em domain/domain-definition.cue. contribution explica como ESTE BC especificamente contribui — não repete a descrição genérica do custo."
			severity:    "fail"
			rationale:   "Cost elimination é a justificativa econômica do BC na Mesh. Referência quebrada ou contribuição genérica derrota a rastreabilidade tese→mecanismo→custo→BC."
		}]
		rationale: "Critérios do canvas cobrem as três dimensões que governam decisões downstream: contorno (purpose), rastreabilidade (stakeholder refs, cost refs) e alinhamento econômico (incentive analysis com dp-08)."
	}
}

#BCClassification: shared_types.#SubdomainClassification

#OperationalCapability: {
	// Referência a cc-NN de domain-definition.cue, quando aplicável.
	// CI valida que capabilityRef existe em domain-definition.cue se preenchido.
	capabilityRef?: string & =~"^cc-[0-9]{2}$"

	// Descrição da capability no contexto específico deste BC.
	description: string & !=""

	rationale: string & !=""
}

#CanvasStakeholder: {
	// Referência ao sh-NN canônico em domain/stakeholder-map.cue.
	// CI valida existência.
	stakeholderRef: string & =~"^sh-[0-9]{2}$"

	// Papel específico deste stakeholder no contexto deste BC.
	roleInContext: string & !=""

	rationale: string & !=""
}

#CanvasCostContribution: {
	// Referência ao ce-NN canônico em domain/domain-definition.cue.
	// CI valida existência.
	costRef: string & =~"^ce-[0-9]{2}$"

	// Como este BC contribui para a eliminação deste custo.
	contribution: string & !=""

	rationale: string & !=""
}

#IncentiveAnalysis: {
	// Análise por participante — alinhamento com dp-08.
	participants: [#IncentiveParticipant, ...#IncentiveParticipant]

	rationale: string & !=""
}

#IncentiveParticipant: {
	// Referência ao sh-NN canônico.
	stakeholderRef: string & =~"^sh-[0-9]{2}$"

	// Incentivo que o sistema cria para este participante operar corretamente.
	correctOperationIncentive: string & !=""

	// Custo concreto que o participante paga ao tentar manipular.
	manipulationCost: string & !=""

	// Comparação: por que custo de manipulação > benefício potencial.
	vsBenefit: string & !=""

	rationale: string & !=""
}
