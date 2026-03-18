package build_time

// quality-gate.cue — Protocolo de autovalidação pré-proposta.
//
// O agente executa este protocolo internamente antes de propor qualquer
// artefato ao founder. Não substitui validation prompts (sessão separada)
// nem a aprovação do founder. Reduz rounds de revisão humana.
//
// Camadas de validação do sistema:
// | Camada         | Quando                      | Quem             | O que valida                                  |
// | Self-review    | Pré-proposta, loop interno  | Mesmo agente     | cue vet + crítica semântica contra critérios  |
// | Procedural     | Pré-commit                  | Mesmo agente     | Checklist de completude do task template      |
// | Semântica      | Pós-commit, sessão separada | Agente diferente | Viés, blind spots, coerência profunda         |
//
// Aplicação de critérios:
// Para cada artefato, o agente aplica TODOS os universalCriteria deste
// arquivo mais os critérios em _qualityCriteria do artifact schema
// correspondente ao artifactType (em architecture/artifact-schemas/<tipo>.cue).
// Se o schema não tiver _qualityCriteria, aplicar apenas universalCriteria.
// Nunca aplicar critérios de schemas de tipos não correspondentes.

// ═══════════════════════════════════════════════════════════════
// Tipos fundamentais
// ═══════════════════════════════════════════════════════════════

#Severity: "fail" | "warn" | "info"

// #ArtifactType é deliberadamente restrito aos artefatos com critérios
// de qualidade específicos validados na prática. Expandir quando novos
// tipos entrarem no regime de self-review. A enum é fechada por fase
// operacional, não ontologicamente completa.
#ArtifactType:
	"adr" |
	"canvas" |
	"domain-definition" |
	"lens" |
	"artifact-schema" |
	"stakeholder-map" |
	"task-template" |
	"wave-plan"

#QualityCriterion: {
	id:          string & !=""
	description: string & !=""
	test:        string & !=""
	severity:    #Severity
	rationale:   string & !=""
}

// #QualityCriteria é o bloco reutilizável que cada artifact schema usa
// em _qualityCriteria após a migração definida no ADR-010.
#QualityCriteria: {
	criteria:  [#QualityCriterion, ...#QualityCriterion]
	rationale: string & !=""
}

#SeverityPolicy: {
	fail:      string & !=""
	warn:      string & !=""
	info:      string & !=""
	rationale: string & !=""
}

#TransparencyPolicy: {
	always:    string & !=""
	onFailure: string & !=""
	onRequest: string & !=""
	rationale: string & !=""
}

#CriteriaResolution: {
	universal:    string & !=""
	typeSpecific: string & !=""
	fallback:     string & !=""
	rationale:    string & !=""
}

#MigrationRecord: {
	status:    "completed"
	date:      string & !=""
	trigger:   string & !=""
	action:    string & !=""
	adrRef:    string & !=""
	rationale: string & !=""
}

#QualityGateSchema: {
	type:     "quality-gate"
	location: "governance/build-time/quality-gate.cue"
}

#QualityGateArtifact: {
	_schema:            #QualityGateSchema
	severityPolicy:     #SeverityPolicy
	transparency:       #TransparencyPolicy
	criteriaResolution: #CriteriaResolution
	migrationRecord:    #MigrationRecord
	universalCriteria:  [#QualityCriterion, ...#QualityCriterion]
	maxRounds:          int & >0
	stabilityCondition: string & !=""
	exitOnMaxRounds:    string & !=""
	deterministicGate:  string & !=""
	rationale:          string & !=""
}

// ═══════════════════════════════════════════════════════════════
// Instância canônica
// ═══════════════════════════════════════════════════════════════

qualityGate: #QualityGateArtifact & {
	_schema: {
		type:     "quality-gate"
		location: "governance/build-time/quality-gate.cue"
	}

	maxRounds: 3

	stabilityCondition: """
		Nenhum finding com severity 'fail' pendente na última passada,
		e a última passada não introduziu novos findings 'fail' que não
		existiam na passada anterior. Correção que cria regressão não
		é estabilização.
		"""

	exitOnMaxRounds: """
		Propor ao founder com disclaimer explícito listando findings não
		resolvidos. O founder decide se aceita, corrige ou pede mais rounds.
		"""

	deterministicGate: """
		cue vet é o primeiro passo de cada round. Se falhar, corrigir
		sintaxe antes de prosseguir com critérios semânticos.
		"""

	rationale: """
		3 rounds é o default operacional da fase atual — não verdade
		permanente. Observação empírica: 3 rounds internos + ~1 round
		do founder ≈ paridade com os 4-5 rounds de red-team manual.
		Mais que 3 rounds internos tem retorno decrescente — o agente
		tende a circular. Artefatos simples podem estabilizar em 1
		round; artefatos complexos podem precisar de 4. Quando o padrão
		de uso justificar, considerar maxRounds variável por tipo.
		"""

	severityPolicy: {
		fail: """
			Bloqueia proposta limpa. O agente não pode propor ao founder
			sem resolver ou declarar explicitamente no disclaimer.
			"""
		warn: """
			Permite proposta, mas deve ser carregado no resumo se material.
			Warn ignorado silenciosamente é violação do protocolo — o
			founder deve ter visibilidade para decidir se é aceitável.
			"""
		info: """
			Orientação de melhoria. Não bloqueia, não exige menção no
			resumo individual. Registrado internamente para o agente
			considerar, reportado apenas sob demanda. Porém, padrões
			recorrentes de info (mesmo critério ativando em múltiplos
			artefatos consecutivos) devem ser agregados e promovidos
			para warn — recorrência transforma orientação em sinal.
			"""
		rationale: """
			Três níveis cobrem o espectro: bloqueio (fail), visibilidade
			obrigatória (warn), orientação opcional (info). Binário
			fail/warn forçava escolhas artificiais entre bloquear e ignorar.
			"""
	}

	transparency: {
		always:    "Self-review: N/M rounds — uma linha sempre visível ao propor."
		onFailure: "Listar findings com severity 'fail' que não foram resolvidos e findings 'warn' materiais, com contexto suficiente para o founder avaliar."
		onRequest: "Detalhar todas as correções feitas em cada round, incluindo findings com severity 'info'."
		rationale: """
			Transparência escalonada: não poluir o output normal, mas nunca
			esconder falhas. O founder deve poder aprofundar sob demanda.
			"""
	}

	criteriaResolution: {
		universal:    "Aplicar universalCriteria deste arquivo a todo artefato, independente de tipo."
		typeSpecific: "Carregar _qualityCriteria do artifact schema correspondente em architecture/artifact-schemas/<tipo>.cue. O campo _qualityCriteria conforma com #QualityCriteria definido neste arquivo."
		fallback:     "Se o schema do tipo não tiver _qualityCriteria, aplicar apenas universalCriteria. Ausência de _qualityCriteria em schema existente não é erro — significa que o tipo ainda não entrou no regime de self-review type-specific."
		rationale: """
			Colocação de critérios junto ao schema reduz drift entre o que
			o schema define e o que o self-review valida. O agente resolve
			critérios em runtime: universal (fixo) + type-specific
			(por schema).
			"""
	}

	migrationRecord: {
		status:  "completed"
		date:    "2026-03-18"
		trigger: """
			typeSpecific atingiu 8 entries (adr, canvas, domain-definition,
			lens, artifact-schema, stakeholder-map, task-template,
			wave-plan), satisfazendo condição '8+ entries em typeSpecific'.
			"""
		action: """
			Critérios migrados de quality-gate.cue para _qualityCriteria em
			cada artifact schema correspondente em
			architecture/artifact-schemas/.
			"""
		adrRef: "architecture/adrs/adr-010-quality-criteria-colocation.cue"
		rationale: """
			Centralização era viável enquanto o volume era baixo. Com 8
			tipos, critérios colocados com o schema que validam reduzem
			drift e facilitam manutenção por contexto — quem edita o
			schema vê os critérios de qualidade no mesmo arquivo.
			"""
	}

	universalCriteria: [{
		id:          "uq-01"
		description: "Rationale explica WHY, não WHAT"
		test:        "Para cada campo rationale no artefato: ele responde 'por que esta decisão foi tomada?' em vez de 'o que este campo faz?'. Se remover o rationale não perde informação além do 'por quê', está correto."
		severity:    "fail"
		rationale:   "Rationale que descreve o que a regra faz é redundante com o campo statement — não agrega informação. O valor do rationale é exclusivamente o registro da razão."
	}, {
		id:          "uq-02"
		description: "Especificidade para o domínio Mesh"
		test:        "Teste de substituição: trocar 'Mesh' por 'qualquer fintech' no artefato. Se o texto continuar igualmente verdadeiro, está genérico demais — falta ancoragem nos mecanismos específicos da Mesh (evidência verificável, agentes com gates, três SoTs, efeito de rede informacional, SCD como veículo)."
		severity:    "fail"
		rationale:   "Artefatos genéricos não diferenciam a Mesh de qualquer outro sistema. Cada afirmação deve ser rastreável a pelo menos um mecanismo ou princípio que é específico da Mesh."
	}, {
		id:          "uq-03"
		description: "Referências cruzadas existem"
		test:        "Toda referência a outro artefato (mechanismRef, derivedFrom, enabledBy, stakeholder IDs, principle IDs) aponta para um identificador que existe no artefato referenciado."
		severity:    "fail"
		rationale:   "Referência quebrada é pior que ausência de referência — cria ilusão de rastreabilidade."
	}, {
		id:          "uq-04"
		description: "Consistência com design principles e repo principles"
		test:        "Nenhuma afirmação no artefato contradiz princípios em architecture/design-principles.cue ou governance/repo-principles.cue. Se contradizer, a tensão deve estar documentada no rationale com referência ao princípio tensionado."
		severity:    "fail"
		rationale:   "Contradição não documentada é bug. Contradição documentada é tensão legítima — o sistema de tensões existe para isso."
	}, {
		id:          "uq-05"
		description: "Limitações conhecidas declaradas"
		test:        "Se o artefato tem limitações, premissas não validadas ou dependências externas, elas estão declaradas explicitamente (em rationale, antiThesis ou campo dedicado)."
		severity:    "warn"
		rationale:   "Limitações omitidas são descobertas pelo founder no review — exatamente o que o self-review deve antecipar. Warn porque nem todo artefato tem limitações."
	}, {
		id:          "uq-06"
		description: "Ubiquitous language consistente"
		test:        "Termos de domínio usam a mesma palavra em todo o artefato e são consistentes com o glossário do BC (quando existir) e com domain/domain-definition.cue. Não misturar sinônimos (e.g., 'receivable' vs 'recebível' vs 'crédito a receber' no mesmo artefato)."
		severity:    "fail"
		rationale:   "Inconsistência terminológica é ambiguidade — e ambiguidade em spec de domínio financeiro é risco operacional."
	}, {
		id:          "uq-07"
		description: "Zero placeholder"
		test:        "Nenhum campo contém 'TODO', 'TBD', 'a definir', texto genérico de preenchimento ou valor que claramente não foi elaborado. Se um campo não pode ser preenchido, o artefato não está pronto para proposta."
		severity:    "fail"
		rationale:   "Placeholder proposto ao founder transfere trabalho de elaboração do agente para o humano — inversão do modelo operacional."
	}, {
		id:          "uq-08"
		description: "Artefato conforma com seu artifact schema"
		test:        "O artefato é estruturalmente válido contra o schema correspondente em architecture/artifact-schemas/. Todos os campos obrigatórios do schema estão presentes, tipos conferem, constraints de domínio (regex, enums, cardinalidade) são satisfeitos. Quando o artefato avaliado é ele próprio um artifact schema, _schema.location deve estar presente e preenchido."
		severity:    "fail"
		rationale:   "cue vet no deterministicGate valida sintaxe CUE, não conformidade semântica com o schema do tipo. Este critério torna a conformidade estrutural parte explícita da gramática de qualidade — não apenas ritual do round, mas regra verificável que o agente aplica a cada artefato."
	}]
}
