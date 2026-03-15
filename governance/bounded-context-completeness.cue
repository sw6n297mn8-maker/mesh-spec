package governance

// bounded-context-completeness.cue — Regras de completude por BC.
//
// Verifica PRESENÇA de artefatos, não conteúdo.
// Validação de conteúdo é responsabilidade da phase schema-conformance.
// completeness pass + schema-conformance pass = BC estruturalmente válido.

bcCompleteness: #BCCompleteness

#BCCompleteness: {
	scope:        string & !=""
	rationale:    string & !=""
	rootArtifact: #RootArtifact
	rules:        [...#CompletionRule]
}

#RootArtifact: {
	artifact: string & !=""
	role:     string & !=""

	// Obrigatoriedade explícita — não derivada do papel de raiz.
	mustExist: bool

	stabilityRequirements: {
		schemaStability: "high" | "medium" | "low"
		changePolicy:    string & !=""
		rationale:       string & !=""
	}

	// Comportamento quando rootArtifact não existe no BC.
	absentPolicy: "block-completeness-evaluation" | "warn-and-skip"
	rationale:    string & !=""
}

#CompletionRule: {
	artifactType:   string & !=""
	condition:      string & !="" // expressão avaliável contra campos do canvas; "true" = incondicional
	presencePolicy: "required" | "forbidden"
	rationale:      string & !=""
}

// ── Instância ──

bcCompleteness: {
	scope:     "existence-only"
	rationale: "Completude e conformidade são concerns separados. Este artefato governa existência. Schemas governam forma."

	rootArtifact: {
		artifact:  "canvas"
		role:      "Documento raiz do Bounded Context. Todos os conditions de completude são avaliados contra campos do canvas."
		mustExist: true

		stabilityRequirements: {
			schemaStability: "high"
			changePolicy:    "Canvas schema changes require review of all conditions in this file."
			rationale:       "Canvas é pivô de governança contextual. Sua estabilidade é prerequisito para confiabilidade do sistema de completude."
		}

		absentPolicy: "block-completeness-evaluation"
		rationale:    "Se mustExist && canvas ausente: fail de completude + bloqueio de avaliação das rules. São consequências distintas: fail porque canvas é obrigatório; block porque conditions não podem ser avaliadas sem ele."
	}

	rules: [
		{
			artifactType:   "ubiquitous-language"
			condition:      "true"
			presencePolicy: "required"
			rationale:      "Linguagem ubíqua é o contrato semântico do BC."
		},
		{
			artifactType:   "invariants"
			condition:      "true"
			presencePolicy: "required"
			rationale:      "Invariantes definem o que o sistema garante. BC sem invariantes não tem contrato verificável."
		},
		{
			artifactType:   "commands"
			condition:      "canvas.classification != \"generic-subdomain\""
			presencePolicy: "required"
			rationale:      "Subdomínios genéricos podem não ter commands próprios (apenas consomem). Core e supporting sempre têm."
		},
		{
			artifactType:   "events"
			condition:      "canvas.classification != \"generic-subdomain\""
			presencePolicy: "required"
			rationale:      "Mesmo critério de commands — events são a contrapartida."
		},
		{
			artifactType:   "commands"
			condition:      "canvas.classification == \"generic-subdomain\""
			presencePolicy: "forbidden"
			rationale:      "Subdomínios genéricos não possuem comportamento de domínio próprio. Comandos indicam erro de classificação ou violação de contorno."
		},
		{
			artifactType:   "events"
			condition:      "canvas.classification == \"generic-subdomain\""
			presencePolicy: "forbidden"
			rationale:      "Mesmo critério de commands — events são a contrapartida. Presença indica erro de classificação."
		},
		{
			artifactType:   "state-model"
			condition:      "true"
			presencePolicy: "required"
			rationale:      "Todo BC mantém pelo menos um modelo de estado."
		},
		{
			artifactType:   "agents"
			condition:      "canvas.capabilities.hasDomainAgents == true"
			presencePolicy: "required"
			rationale:      "Agent specs só são required se o canvas declara que o BC opera com agentes de domínio."
		},
		{
			artifactType:   "api"
			condition:      "canvas.capabilities.hasSyncSurface == true"
			presencePolicy: "required"
			rationale:      "API spec (OpenAPI) só é required se o BC expõe superfície síncrona."
		},
		{
			artifactType:   "async-api"
			condition:      "canvas.capabilities.hasAsyncSurface == true"
			presencePolicy: "required"
			rationale:      "AsyncAPI spec só é required se o BC expõe superfície assíncrona."
		},
	]
}
