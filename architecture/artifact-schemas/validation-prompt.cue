package artifact_schemas

// validation-prompt.cue — Schema para validation prompts.
//
// Validation prompts são instruções estruturadas para validação
// semântica de artefatos por agente em sessão/processo separado.
// matchPatterns permite que o hook post-commit encontre
// automaticamente quais prompts aplicar a cada commit.
// Queue (.validation-queue) acumula pendências; processamento
// é batch por comando dedicado.

#ValidationTargetType:
	#ArtifactType |
	"self-review-report"

// Regex pattern para matching de paths.
// Tipo nomeado melhora legibilidade nos matchPatterns.
#RegexPattern: string & !=""

// Modo de output esperado de cada check.
//   pass-fail:     resultado binário, sem narrativa
//   finding-only:  detecta sinais que constituem findings
//   narrative:     avaliação qualitativa com julgamento contextual
#CheckOutputMode: "pass-fail" | "finding-only" | "narrative"

#ValidationPrompt: {
	id:    string & =~"^vp-[a-z][a-z0-9-]*$"
	title: string & !=""

	// Path regex patterns que ativam este prompt.
	// Hook post-commit testa cada arquivo commitado contra estes patterns.
	matchPatterns: [#RegexPattern, ...#RegexPattern]

	// Tipos de artefato que este prompt valida.
	// Enum controlada com extensão explícita para tipos fora de #ArtifactType.
	appliesTo: [#ValidationTargetType, ...#ValidationTargetType]

	// Arquivos que o validador deve ler como contexto antes de avaliar.
	// O agente de validação opera sem histórico de sessão — references
	// são o único contexto disponível além do artefato sob validação.
	references: [string & !="", ...string & !=""]

	// Checks semânticos estruturados.
	checks: [#ValidationCheck, ...#ValidationCheck]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/validation-prompts/validate-[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^validate-[a-z0-9-]+\\.cue$"
			description:        "Validation prompts: instruções estruturadas para validação semântica por agente separado."
			rationale:          "Validation prompts vivem em architecture/ porque governam qualidade cross-cutting. Automação via hook post-commit com queue."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-vp-01"
			description: "Checks são semanticamente distintos de quality criteria"
			test:        "Cada check valida algo que schema e quality criteria do tipo NÃO capturam — requer leitura e julgamento contextual. Checks que duplicam critérios estruturais são redundantes."
			severity:    "fail"
			rationale:   "Validation prompts existem para camada semântica. Se um check é verificável por cue vet ou self-review, não pertence aqui."
		}, {
			id:          "tq-vp-02"
			description: "References suficientes para avaliação"
			test:        "References contêm todo contexto necessário para agente separado (sem histórico de sessão) avaliar os checks. Nenhum check requer informação não acessível via references."
			severity:    "fail"
			rationale:   "Validação separada opera sem contexto implícito. References incompletas tornam avaliação impossível."
		}, {
			id:          "tq-vp-03"
			description: "matchPatterns consistentes com schema location"
			test:        "Cada regex em matchPatterns alinha com canonicalPathRegex do artifact schema correspondente. Não mais amplo nem restrito sem justificativa."
			severity:    "warn"
			rationale:   "Divergência entre matchPatterns e schema location indica prompt desalinhado com tipo alvo."
		}]
		rationale: "Critérios garantem que validation prompts adicionam valor semântico genuíno, são auto-contidos via references, e estão alinhados com tipos que validam."
	}
}

#ValidationCheck: {
	id:         string & =~"^vc-[a-z0-9-]+-[0-9]{2}$"
	question:   string & !=""  // Pergunta que o validador aplica ao artefato
	lookFor:    string & !=""  // O que constitui um finding
	outputMode: #CheckOutputMode
	severity:   #Severity
	rationale:  string & !=""
}
