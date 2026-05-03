package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-003": artifact_schemas.#DeferredDecision & {
	id:    "def-003"
	title: "Add regex-pattern-match kind ao framework structural-check"
	date:  "2026-05-03"

	description: """
		Adicionar kind regex-pattern-match ao framework #StructuralCheck
		(architecture/artifact-schemas/structural-check.cue) com rule
		shape suportando validação de que valor de campo conforma a
		regex (potencialmente derivada de canonicalPathRegex de outro
		schema). Cobertura pretendida: sc-srr-02 (artifactSchemaPath
		match canonicalPathRegex do tipo), sc-ts-02 (outputs.artifact
		paths conformes a canonicalPathRegex dos schemas de destino).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-063-add-filesystem-path-exists-kind-to-structural-check.cue",
		"governance/build-time/task-specs/wi-068.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) executou
		Opção B do WI-068: adicionar 1 novo kind (filesystem-path-
		exists, adr-063) cobrindo casos imediatos. regex-pattern-match
		foi formalmente deferido porque (a) casos cobertos pelo novo
		kind eram suficientes para fechar gap mais comum, (b) regex-
		pattern-match exige derivação de regex de outro schema
		(canonicalPathRegex resolve cross-artifact) — mistura semantics
		com cross-file-id-exists (ambos cross-file), e (c) framework
		minimalism per adr-041 prefere kind quando casos concretos
		materializarem dois ou mais cases distintos.
		Custo evitado por NÃO adicionar agora: complexity do runner +
		2 structural-checks que beneficiariam mas não são bloqueadores;
		risco de over-engineering com regex generics quando 2 casos
		são insuficientes para calibrar shape do kind.
		Custo de continuar deferindo: artifactSchemaPath de self-review
		reports e outputs.artifact paths em task-specs ficam sem
		enforcement de conformidade com canonicalPathRegex — paths
		podem ser semanticamente errados (apontam para schema X mas
		path conforma com schema Y). Mitigação parcial: shape regex
		dos próprios paths já força format básico em alguns casos.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence) usa pattern framing-aware
		'(missing|needs|requires|would benefit) [a-z ]{0,30}regex-pattern-match'
		com scope=file-content e threshold=2. Calibração paralela a
		def-002 (2 rounds): Round 1 simples por nome do kind, Round 2
		framing-aware com '.{0,30}', Round 3 (WI-069 first dispatch
		surfaced) [a-z ]{0,30} para evitar self-match em string literais
		regex (que contêm ')' '.' '{' '}' caracteres). Post-fix verified:
		0 matches em todo repo; threshold=2 captura 2+ files com
		framing genuíno externo. Trigger 2 (manual-review) escape para
		priorização explícita.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "local"
		description: """
			2 structural-checks pretendidos (sc-srr-02, sc-ts-02)
			ficam sem cobertura determinística. Drift potencial:
			artifactSchemaPath aponta para tipo X mas path conforma
			com regex de tipo Y — schema mismatch silencioso.
			Mitigação: schemas de destino (artifact-schemas) raramente
			mudam path; convenção de naming reduz drift natural.
			Severity low porque casos atuais são poucos (2) e impacto
			é detectável downstream (cue vet falha quando schema é
			carregado errado). blastRadius local porque toca apenas
			self-review-report e task-spec coverage.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "(missing|needs|requires|would benefit) [a-z ]{0,30}regex-pattern-match"
		scope:     "file-content"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar adição do kind antes de recurrence threshold materializar — e.g., quando 3º+ caso concreto aparece em WI futuro com prose explícita de demanda por regex-pattern-match."
	}]

	status: "open"
}
