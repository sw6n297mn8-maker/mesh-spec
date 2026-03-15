package governance

// bounded-context-completeness.cue — Regras de completude por BC.
//
// Verifica PRESENÇA de artefatos required, não conteúdo.
// Validação de conteúdo é responsabilidade da phase schema-conformance.
// completeness pass + schema-conformance pass = BC estruturalmente válido.

bcCompleteness: #BCCompleteness

#BCCompleteness: {
	scope:     string & !=""
	rationale: string & !=""

	// Quando canvas não existe, conditions que dependem dele
	// são irresolvíveis. Este campo define o comportamento.
	canvasAbsentPolicy: string & !=""

	required: [...#RequiredArtifact]
}

#RequiredArtifact: {
	artifactType: string & !=""
	condition:    string & !="" // "always" ou expressão avaliável contra canvas
	rationale:    string & !=""
}

// ── Instância ──

bcCompleteness: {
	scope:     "existence-only"
	rationale: "Completude e conformidade são concerns separados. Este artefato governa existência. Schemas governam forma."

	canvasAbsentPolicy: "block-with-explicit-error"

	required: [
		{
			artifactType: "canvas"
			condition:    "always"
			rationale:    "Canvas é o artefato raiz do BC. Sem canvas, nenhuma condition pode ser avaliada."
		},
		{
			artifactType: "ubiquitous-language"
			condition:    "always"
			rationale:    "Linguagem ubíqua é o contrato semântico do BC."
		},
		{
			artifactType: "invariants"
			condition:    "always"
			rationale:    "Invariantes definem o que o sistema garante. BC sem invariantes não tem contrato verificável."
		},
		{
			artifactType: "commands"
			condition:    "canvas.classification != \"generic-subdomain\""
			rationale:    "Subdomínios genéricos podem não ter commands próprios (apenas consomem). Core e supporting sempre têm."
		},
		{
			artifactType: "events"
			condition:    "canvas.classification != \"generic-subdomain\""
			rationale:    "Mesmo critério de commands — events são a contrapartida."
		},
		{
			artifactType: "state-model"
			condition:    "always"
			rationale:    "Todo BC mantém pelo menos um modelo de estado."
		},
		{
			artifactType: "agents"
			condition:    "canvas.capabilities.hasDomainAgents == true"
			rationale:    "Agent specs só são required se o canvas declara que o BC opera com agentes de domínio."
		},
		{
			artifactType: "api"
			condition:    "canvas.capabilities.hasSyncSurface == true"
			rationale:    "API spec (OpenAPI) só é required se o BC expõe superfície síncrona."
		},
		{
			artifactType: "async-api"
			condition:    "canvas.capabilities.hasAsyncSurface == true"
			rationale:    "AsyncAPI spec só é required se o BC expõe superfície assíncrona."
		},
	]
}
