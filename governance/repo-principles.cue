package governance

// repo-principles.cue — Princípios Orientadores do Repositório (RP1–RP10).
//
// Source of truth canônico para os princípios que governam como a spec
// é organizada, consumida e mantida. Diferentes dos Design Principles
// (architecture/design-principles.cue) que governam como o sistema é desenhado.

#RepoPrincipleGroup: "Organization" | "Format" | "Granularity" | "Consumption" | "Quality" | "Governance"

#RepoPrinciple: {
	id:        =~"^RP[0-9]+$"
	group:     #RepoPrincipleGroup
	statement: string & !=""
	rationale: string & !=""
}

_schema: {
	location: {
		canonicalPathRegex: "^governance/repo-principles\\.cue$"
		fileNameRegex:      "^repo-principles\\.cue$"
		description:        "Princípios orientadores do repositório."
		rationale:          "Artefato singleton em governance/. Source of truth dos princípios de organização e manutenção da spec."
		cardinality:        "singleton"
		allowNested:        false
	}
}

principles: [ID=string]: #RepoPrinciple & {id: ID}

principles: {
	// ═══════════════════════════════════════════
	// Organization (RP1)
	// Como o repositório se organiza.
	// ═══════════════════════════════════════════

	RP1: {
		group: "Organization"
		statement: """
			Bounded Context como unidade primária de organização.
			O repositório é organizado por bounded context, não por camada
			de abstração. Documentos transversais existem fora dos BCs,
			mas são minoria. A maior parte do conhecimento vive dentro
			de um contexto específico.
			"""
		rationale: """
			Camadas descrevem a ordem de descoberta do conhecimento.
			Bounded contexts descrevem a unidade de consumo — o pacote
			coeso que um agente de IA recebe quando vai executar qualquer
			tarefa.
			"""
	}

	// ═══════════════════════════════════════════
	// Format (RP2)
	// Formato e representação dos artefatos.
	// ═══════════════════════════════════════════

	RP2: {
		group: "Format"
		statement: """
			CUE como formato universal, com exceções operacionais declaradas.
			Todo artefato é definido em CUE — incluindo artefatos que
			em repositórios tradicionais seriam markdown: ADRs, domain
			stories, threat models, glossários, coding conventions,
			agent instructions, protocolos de governança.
			"""
		rationale: """
			CUE é simultaneamente machine-readable (CI valida, agentes
			consomem) e human-readable (estrutura autoexplicativa, campo
			rationale por elemento). Não existe formato paralelo.
			"""
	}

	// ═══════════════════════════════════════════
	// Granularity (RP3)
	// Granularidade dos artefatos.
	// ═══════════════════════════════════════════

	RP3: {
		group: "Granularity"
		statement: """
			Granularidade atômica com composição explícita.
			Cada unidade de conhecimento (um command, um event, uma
			invariante) é identificável e endereçável individualmente.
			Quando a granularidade por arquivo gera mais ruído que valor,
			unidades vivem como seções dentro de um arquivo do BC.
			"""
		rationale: """
			O critério é: se um agente precisaria desse item isoladamente
			com frequência, ele merece seu próprio arquivo. Granularidade
			é decisão de consumo, não de estética.
			"""
	}

	// ═══════════════════════════════════════════
	// Consumption (RP4–RP5)
	// Como artefatos são consumidos.
	// ═══════════════════════════════════════════

	RP4: {
		group: "Consumption"
		statement: """
			Autocontido por contexto, com dependências transversais
			declaradas. Cada BC deve ser compreensível lendo apenas
			sua pasta + os documentos transversais que ele referencia.
			Dependências são declaradas via referência explícita em
			context-dependencies.cue, nunca via conhecimento implícito.
			"""
		rationale: """
			Um agente nunca deveria precisar vasculhar outro bounded
			context para entender o que está implementando.
			"""
	}

	RP5: {
		group: "Consumption"
		statement: """
			Retrieval patterns como artefato de primeira classe.
			A camada ai-orchestration/ define retrieval patterns e
			prioridades de injeção para montar o contexto certo por
			tipo de tarefa, dentro do orçamento de tokens disponível.
			"""
		rationale: """
			Sem retrieval patterns explícitos, o agente recebe ou
			contexto demais (poluição, estouro de context window) ou
			de menos (alucinação). Tokens são recurso arquitetural
			explícito, não restrição invisível.
			"""
	}

	// ═══════════════════════════════════════════
	// Quality (RP6–RP7)
	// Garantias de qualidade dos artefatos.
	// ═══════════════════════════════════════════

	RP6: {
		group: "Quality"
		statement: """
			Negative specs têm o mesmo peso que positive specs.
			Anti-patterns, restrições arquiteturais e fronteiras de
			responsabilidade precisam ser explícitos. Cada BC tem
			anti-patterns.cue e cada ADR tem alternativas rejeitadas.
			"""
		rationale: """
			Para humanos, proibições são inferidas do contexto. Para IA,
			não. Omissão de negative specs é convite a alucinação.
			"""
	}

	RP7: {
		group: "Quality"
		statement: """
			Golden examples como padrão de qualidade.
			Implementações de referência dentro de cada BC servem como
			template para o agente. Um agregado exemplar implementado
			corretamente vale mais que dez páginas de documentação
			sobre como implementar agregados.
			"""
		rationale: """
			IA aprende mais por pattern matching concreto do que por
			instrução abstrata.
			"""
	}

	// ═══════════════════════════════════════════
	// Governance (RP8–RP10)
	// Como a spec é governada e evolui.
	// ═══════════════════════════════════════════

	RP8: {
		group: "Governance"
		statement: """
			Versionamento semântico da spec. Mudanças no domain model,
			invariantes ou contratos são commits com mensagens que
			referenciam o BC afetado e o tipo de mudança.
			"""
		rationale: """
			Permite que agentes saibam se o contexto que consumiram
			mudou desde a última execução.
			"""
	}

	RP9: {
		group: "Governance"
		statement: """
			Cobertura auditável. Para cada BC, deve ser possível
			verificar automaticamente: todo command tem pelo menos
			uma invariante? Todo event tem schema? Todo aggregate tem
			state model? O grafo de dependências entre BCs é acíclico?
			"""
		rationale: """
			Audit commands na camada de governança existem para impor
			esta verificabilidade. Completude que depende de disciplina
			humana não escala.
			"""
	}

	RP10: {
		group: "Governance"
		statement: """
			Formal first, rationale always. Todo artefato é definido como
			estrutura formal em CUE — a representação canônica é sempre
			formal. Narrativa persistida só existe quando explicitamente
			tratada como exceção operacional do repositório. Cada elemento
			formal carrega um campo rationale: por que aquela regra existe.
			"""
		rationale: """
			Rationale não descreve o que a regra faz. Quando um humano
			precisa entender um artefato, lê a estrutura ou pede ao
			agente que explique sob demanda. A explicação é gerada, não
			persistida — nunca fica desatualizada.
			"""
	}
}
