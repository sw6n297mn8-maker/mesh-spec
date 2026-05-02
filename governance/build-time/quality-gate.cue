package build_time

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// quality-gate.cue — Protocolo de autovalidação pré-proposta.
//
// O agente executa este protocolo internamente antes de propor qualquer
// artefato ao founder. Não substitui validation prompts (sessão separada)
// nem a aprovação do founder. Reduz rounds de revisão humana.
//
// Camadas de validação do sistema:
// | Camada                  | Quando                      | Quem             | O que valida                                                              |
// | Self-review             | Pré-proposta, loop interno  | Mesmo agente     | cue vet + crítica semântica contra critérios                              |
// | Procedural              | Pré-commit                  | Mesmo agente     | Checklist de completude do task template                                  |
// | Estrutural pós-commit   | Pós-commit                  | Tooling          | structural-checks — gate determinístico pós-commit; único mecanismo que pode bloquear |
// | Semântica pós-commit    | Pós-commit, sessão separada | Agente diferente | validation-prompts — design review advisory; recomendações ao founder; não bloqueia    |
//
// Per adr-040: as camadas estrutural e semântica são categoricamente
// distintas — a primeira é determinística e gating; a segunda é
// interpretativa e advisory. Nenhuma pode ser colapsada na outra
// sem reincidir em ten-006.
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

// #ArtifactType, #Severity, #QualityCriterion e #QualityCriteria vivem em
// architecture/artifact-schemas/quality-criteria.cue (package artifact_schemas).
// Importados via artifact_schemas. Direção: governance → schemas.

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

#SubagentRolloutEntry: {
	artifactType: artifact_schemas.#ArtifactType
	mode:         #ExecutionMode
	rationale:    string & !=""
}

#ExecutionPolicy: {
	defaultMode:       #ExecutionMode
	rollout:           [...#SubagentRolloutEntry]
	inputContract:     string & !=""
	outputContract:    string & !=""
	findingEvaluation: string & !=""
	promptTemplate:    string & !=""
	rationale:         string & !=""
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
	universalCriteria:  [artifact_schemas.#QualityCriterion, ...artifact_schemas.#QualityCriterion]
	maxRounds:          int & >0
	stabilityCondition: string & !=""
	exitOnMaxRounds:    string & !=""
	deterministicGate:  string & !=""
	executionPolicy:    #ExecutionPolicy
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

	maxRounds: 4

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

	executionPolicy: {
		defaultMode: "self-reported"

		rollout: [{
			artifactType: "artifact-schema"
			mode:         "isolated-subagent"
			rationale:    "Critérios type-specific (tq-as-01/02/03) são estruturais e mecânicos — alta confiança de avaliação por sub-agente isolado. Meta-schemas têm maior blast radius na governança."
		}, {
			artifactType: "adr"
			mode:         "isolated-subagent"
			rationale:    "Critérios type-specific (tq-adr-01/02/03) são objetivos (alternativas? metadata de risco? paths existem?). ADRs são decisões de design — viés de confirmação aqui tem custo alto."
		}, {
			artifactType: "production-guide"
			mode:         "isolated-subagent"
			rationale:    "Per adr-054 decision item 10: production-guides authored via subagent-drafted dispatch (authoring-policy.cue rollout) precisam de review subagent SEPARADO do authoring subagent. Isolation authoring vs review reduz viés de auto-ratificação. Critérios type-specific tq-pg-01..06 são objetivos (workOrder consistency, target resolution, doneCriteria avaliáveis, gapPolicy substantiva)."
		}]

		inputContract: """
			O sub-agente recebe como contexto:
			1. Path e conteúdo do artefato sendo revisado.
			2. Path e conteúdo do artifact schema correspondente.
			3. Critérios aplicáveis: universalCriteria de quality-gate.cue
			   + _qualityCriteria do artifact schema (se existir).
			4. Artefatos de referência necessários para avaliar critérios
			   cross-file (e.g., design-principles.cue para uq-04,
			   domain-definition.cue para uq-06).
			5. Findings do round anterior (se round > 1) + artefato
			   corrigido pelo agente principal.
			O sub-agente NÃO recebe: histórico da conversa que produziu
			o artefato, contexto de decisões anteriores, nem instruções
			do founder sobre o artefato.
			"""

		outputContract: """
			O sub-agente retorna uma lista de findings, cada um com:
			- criterionId: id do critério avaliado (e.g., "uq-01")
			- severity: idêntica ao severity do critério (sem reclassificação)
			- message: descrição específica do problema encontrado
			- rationale: (opcional) contexto adicional
			Formato: lista estruturada em texto, um finding por bloco.
			Se nenhum finding, retornar declaração explícita de zero
			findings com breve justificativa por critério avaliado.
			"""

		findingEvaluation: """
			O agente principal NÃO aplica findings cegamente. Para cada
			finding retornado pelo sub-agente:
			1. Verificar se o finding é factualmente correto consultando
			   o artefato e artefatos referenciados.
			2. Se correto: corrigir o artefato.
			3. Se incorreto (falso-positivo): rejeitar o finding e
			   registrá-lo como rejectedFinding no roundDetails.summary
			   com justificativa. Findings rejeitados são dados de
			   calibração — medem a taxa de falso-positivo do modelo
			   de sub-agente.
			4. Nunca corrigir um artefato para satisfazer um finding
			   que o agente principal sabe ser incorreto.
			"""

		promptTemplate: """
			Você é um sub-agente de revisão de qualidade. Sua tarefa é
			avaliar um artefato CUE contra critérios de qualidade.

			Você NÃO tem acesso ao histórico da conversa que produziu
			este artefato. Avalie exclusivamente com base no conteúdo
			do artefato, no schema e nos critérios fornecidos.

			## Artefato
			Path: {artifactPath}
			Leia o arquivo.

			## Schema
			Path: {artifactSchemaPath}
			Leia o arquivo.

			## Critérios a avaliar
			### Universais (de quality-gate.cue)
			{universalCriteria}

			### Type-specific (de {artifactSchemaPath})
			{typeSpecificCriteria}

			## Referências obrigatórias
			Para uq-03 (referências cruzadas): verificar existência dos
			artefatos referenciados.
			Para uq-04 (consistência com princípios): ler
			architecture/design-principles.cue.
			Para uq-06 (ubiquitous language): ler
			domain/domain-definition.cue seção glossary (se existir).

			## Findings do round anterior
			{previousFindings}

			## Instruções
			1. Leia o artefato e o schema.
			2. Para cada critério, avalie e produza um finding APENAS
			   se houver violação. Não produza findings para critérios
			   que passam.
			3. Para cada finding, declare:
			   - criterionId
			   - severity (DEVE ser idêntica ao severity do critério)
			   - message (específica ao artefato — falha no teste de
			     substituição se genérica)
			   - rationale (opcional, contexto adicional)
			4. Se zero findings, declare explicitamente com breve
			   justificativa.
			"""

		rationale: """
			Rollout controlado com replacement direto (não shadow mode)
			para artifact-schema e adr. Dois tipos com critérios mais
			objetivos calibram qualidade dos findings, taxa de
			falso-positivo e valor por round. Demais tipos mantêm
			self-reported até calibração justificar expansão. Evidence
			trail via roundDetails existente (sem hash de execução —
			tooling atual não suporta). CI enforcement de executionMode
			diferido para pós-calibração.
			"""
	}

	rationale: """
		4 rounds é o default operacional da fase atual — não verdade
		permanente. Observação empírica: artefatos de governança e
		meta-schemas precisam consistentemente de 4 rounds para
		estabilizar (encontrar + corrigir + confirmar + verificar
		regressão). Artefatos simples podem estabilizar em 1-2 rounds.
		Quando o padrão de uso justificar, considerar maxRounds
		variável por tipo.
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
		typeSpecific: "Carregar _qualityCriteria do artifact schema correspondente em architecture/artifact-schemas/<tipo>.cue. O campo _qualityCriteria conforma com #QualityCriteria definido em architecture/artifact-schemas/quality-criteria.cue."
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
	}, {
		id:          "uq-09"
		description: "Conformidade com manualAuthoringProtocol section gates (quando aplicável)"
		test:        "Para artefato autorado via manualAuthoringProtocol (mode 'manual' em authoring-policy.cue rollout OU tipo não registrado caindo em defaultMode 'manual', E PG existente em architecture/production-guides/<type>.cue), self-review report registra evidência de que cada section em PG.workOrder passou por gate: (a) section content proposto ao founder com transcript de auto-checagem; (b) confirmação explícita do founder ANTES da próxima section per manualAuthoringProtocol.founderConfirmation. Trivial corrections (per manualAuthoringProtocol.trivialCorrectionException) reportadas no próximo checkpoint. roundDetails[].summary OU singleRoundRationale documenta o pattern de gate seguido. Não-conformidade: section gates pulados sem trivialCorrectionException válida OU evidence ausente no report."
		severity:    "warn"
		rationale:   "Camada 3 supplementary do sistema de defesa em 3 camadas (Camada 1: adr-056 production-guide-coverage structural-check; Camada 2: adr-057 manualAuthoringProtocol section-level gates). Detection post-hoc de skip de section gates durante autoria. Severity 'warn' porque correção retroativa de gates pulados é impossível (artefato já existe); detection surface a issue para founder decidir remediação (aceitar OU exigir reautoria per adr-057 failureMode). 'fail' seria circular — agente bloqueado de propor antes do founder ter visto. Composta com Camadas 1+2 preventivas: falha em uma camada é capturada por outra."
	}]
}
