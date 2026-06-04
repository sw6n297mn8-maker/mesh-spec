package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

waveplanAdr140Wi102Outputs: build_time.#SelfReviewReport & {
	reportId: "srr-wave-plan-adr-140-wi102-outputs"

	artifactPath:       "governance/wave-plan.cue"
	artifactSchemaPath: "architecture/artifact-schemas/wave-plan.cue"
	artifactType:       "wave-plan"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-04"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Cobre a única edição deste pacote no wave-plan: adicionar
			architecture/deferred-decisions/def-049-assertion-to-test-mechanism.cue aos outputs de WI-102
			(def-040 já estava listado; adr-140 cria os dois defs, então ambos são outputs type:create de
			WI-102). NÃO toca o resto do wave-plan.
			Conformidade ao #WavePlan:
			- tq-wp-01 (dependsOn = blocker; conhecimento → semanticPrerequisites): PASS — a edição não
			  altera dependsOn nem semanticPrerequisites; só acrescenta um output.
			- tq-wp-02 (paths conformes): PASS — output em architecture/deferred-decisions/, zona válida;
			  o arquivo existe.
			- Invariantes do schema: _allTaskIDs intacto; _depsCheck sem órfã (nenhuma dependsOn alterada).
			  cue vet ./... EXIT=0.
			Formatação: o bloco adicionado espelha exatamente o bloco def-040 (tabs + alinhamento). O
			cue fmt --check do arquivo acusa drift PRÉ-EXISTENTE (~40 linhas espalhadas, presente em HEAD
			sem este edit, fora do bloco editado) — deliberadamente NÃO reformatado para manter o pacote
			scoped. work-graph NÃO afetado (acrescentar output não muda deps/phases). adr-097/WI-085/
			adr-138/adr-139/adr-142/adr-143 intactos.
			"""
	}]

	findings: {}

	summary: """
		Edição do wave-plan: def-049 acrescentado aos outputs de WI-102 (pacote adr-140; def-040 já
		presente), evitando stale outputs quando adr-140 cria os dois defs. Escopo mínimo,
		style-consistent com o bloco def-040, cue vet ./... EXIT=0; fmt-drift pré-existente do arquivo
		não tocado (fora de escopo); work-graph não afetado. Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Edição de escopo mínimo (um output acrescentado a WI-102), style-consistent com o bloco def-040
		adjacente, verificada por cue vet ./... EXIT=0. A decisão (adicionar def-049 aos outputs para
		evitar stale outputs) foi travada pelo founder no Gate 1. O fmt-drift do arquivo é pré-existente
		e fora de escopo deste pacote. Rounds adicionais não revelariam novos findings.
		"""
}
