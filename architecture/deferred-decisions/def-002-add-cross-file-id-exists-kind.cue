package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-002": artifact_schemas.#DeferredDecision & {
	id:    "def-002"
	title: "Add cross-file-id-exists kind ao framework structural-check"
	date:  "2026-05-03"

	description: """
		Adicionar kind cross-file-id-exists ao framework #StructuralCheck
		(architecture/artifact-schemas/structural-check.cue) com rule
		shape suportando lookup de id em outro arquivo .cue. Cobertura
		pretendida: sc-adr-principlesApplied (P-XX existem em design-
		principles.cue), sc-te-relatedADR (id em adrs/), sc-ts-templateRef
		(template id em fonte de templates).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-063-add-filesystem-path-exists-kind-to-structural-check.cue",
		"governance/build-time/task-specs/wi-068.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) executou
		Opção B do WI-068: adicionar 1 novo kind (filesystem-path-exists,
		adr-063) cobrindo casos imediatos. cross-file-id-exists foi
		formalmente deferido porque (a) casos atuais cobertos por
		filesystem-path-exists eram suficientes para fechar gap mais
		comum (artifactPath/manifestsIn não existir), (b) cross-file-id-
		exists requer parser de .cue files que extraia ids — runner
		ficaria mais complexo, e (c) framework minimalism per adr-041
		prefere kind-by-kind quando concrete need materializa.
		Custo evitado por NÃO adicionar agora: complexity do runner +
		3 structural-checks que beneficiariam mas não são bloqueadores.
		Custo de continuar deferindo: principlesApplied (P-XX),
		relatedADR, templateRef ficam sem enforcement determinístico —
		agentes podem inserir ids fictícios que cue vet não detecta
		(regex de format passa, semantic existence não verificado).
		Aceitável enquanto disciplina manual + validation-prompts
		cobrirem (vp-adr vc-adr-04 captura affectedArtifacts coverage
		semelhantemente).
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence) usa pattern framing-aware
		'(missing|needs|requires|would benefit).{0,30}cross-file-id'
		com scope=file-content e threshold=2. Lição aprendida ao
		calibrar: pattern simples por nome do kind ('cross-file.{0,5}id')
		matches em todos os files que MENCIONAM o kind, incluindo o
		próprio def-002 e adr-063 (registration vs demand confusion).
		Pattern framing-aware captura PROSA DE DEMANDA ('needs X',
		'missing X', 'would benefit from X') — esse pattern não aparece
		em def-002 ou adr-063 (que usam framing declarativo: 'kind para
		X', 'cobertura pretendida: X'). False-positive verified:
		atualmente 0 matches em todo o repo; threshold=2 captura
		2+ files com framing de demanda externa. Trigger 2
		(manual-review) escape para priorização explícita.
		"""

	costOfDeferral: {
		severity: "medium"
		blastRadius: "cross-artifact"
		description: """
			3 structural-checks pretendidos (sc-adr-principlesApplied,
			sc-te-relatedADR, sc-ts-templateRef) ficam sem cobertura
			determinística. Drift potencial: ids fictícios que regex
			de formato aceita mas referencem entidades inexistentes.
			Mitigação parcial: validation-prompts já advisory-cover
			alguns aspectos (vc-adr-04 paths em affectedArtifacts).
			Severity medium porque coverage gap é cumulativo conforme
			tipos crescem; blastRadius cross-artifact porque toca
			múltiplos schemas (adr, tension-entry, task-spec).
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "(missing|needs|requires|would benefit).{0,30}cross-file-id"
		scope:     "file-content"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar adição do kind antes de recurrence threshold materializar — e.g., quando 3º caso concreto aparece em WI futuro com prose de demanda."
	}]

	status: "open"
}
