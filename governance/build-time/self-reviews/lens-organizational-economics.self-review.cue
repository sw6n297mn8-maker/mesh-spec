package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

lensOrganizationalEconomics: build_time.#SelfReviewReport & {
	reportId: "srr-lens-organizational-economics"

	artifactPath:       "architecture/lenses/lens-organizational-economics.cue"
	artifactSchemaPath: "architecture/artifact-schemas/lens.cue"
	artifactType:       "lens"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-03-27"

	roundsExecuted: 1
	maxRounds:      4

	status: "max-rounds-reached"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary:   "Artefato parcial por decisão do founder: contém id, name, purpose, status, trigger e concepts (10 conceitos). Campos obrigatórios do schema ausentes: reasoningProtocol, meshExamples, principleIds, limitations, rationale. uq-08 falha porque o artefato não conforma com #AnalyticalLens — campos obrigatórios faltam. Demais critérios universais avaliados sobre o conteúdo presente: uq-01 (rationale = why) pass, uq-02 (Mesh-specific) pass, uq-03 (cross-refs) pass (crossDependsOn referencia pd-critical-mass em lens-platform-dynamics existente), uq-04 (design principles) pass, uq-05 (limitações) não aplicável (campo ausente), uq-06 (ubiquitous language) pass, uq-07 (zero placeholder) pass. Critérios type-specific (tq-ln-01 a tq-ln-04) parcialmente avaliáveis: tq-ln-01 pass (trigger tem 12 condições testáveis e 5 excludeWhen), tq-ln-02 a tq-ln-04 não avaliáveis (campos ausentes)."
	}]

	findings: {
		fail: [{
			criterionId: "uq-08"
			severity:    "fail"
			message:     "Artefato não conforma com #AnalyticalLens: campos obrigatórios reasoningProtocol, meshExamples, principleIds, limitations e rationale estão ausentes. O artefato está sendo adicionado parcialmente por decisão explícita do founder, que fornecerá as partes restantes em mensagens subsequentes."
		}]
	}

	summary: """
		Lente parcial de economia organizacional com trigger completo (12 condições,
		34 keywords, 5 exclusões) e 10 conceitos cobrindo bottleneck do solo founder,
		delegação para IA, context window, conhecimento organizacional,
		complementaridades, exploration/exploitation, design de autoridade, cultura
		via defaults, escala sem hierarquia e saúde organizacional. Founder optou
		por adicionar em partes — campos obrigatórios do schema (reasoningProtocol,
		meshExamples, principleIds, limitations, rationale) serão fornecidos em
		mensagens subsequentes. cue vet falhará até o artefato estar completo.
		"""
}
