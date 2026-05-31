package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentProbeRecord: build_time.#SelfReviewReport & {
	reportId: "srr-agent-probe-record"

	artifactPath:       "architecture/artifact-schemas/agent-probe-record.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-31"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do schema #AgentProbeRecord (Ciclo 4, adr-134). Avaliado
			contra 8 universalCriteria + 3 type-specific de #ArtifactSchema (tq-as).

			uq-01 (rationale=WHY): rationale do #ProbeFinding discriminated-union
			explica POR QUE a disposição é obrigatória para findings não-noise
			(neutraliza Goodhart — record vazio/sem-disposição falha cue vet). Pass.
			uq-02 (Mesh-specific): substitution falha — record é o audit-trail do
			Ciclo 4 (targetCanvas aponta a canvas Mesh; categorias são da tese de
			modelagem). Pass.
			uq-03 (refs existem): targetCanvas é cross-ref a contexts/<bc>/canvas.cue
			(verificado por sc-apr-01 filesystem-path-exists, fora do schema). Pass.
			uq-04 (princípios): P10 (record é evidência advisory, não gate); P0
			(disposição linka a 1 tracker canônico, não duplica). Pass.
			uq-05 (limitações): runs[] append-only declara o limite (cada probe é 1
			entry imutável; não se edita run anterior — audit trail). Pass.
			uq-06 (ubiquitous language): probe, run, finding, category, disposition,
			triaged — estáveis. Pass.
			uq-07 (zero placeholder): nenhum. Pass.
			uq-08 (conforma schema): _schema.location collection
			(architecture/agent-probes/records/[a-z0-9-]+.cue); discriminated union
			#ProbeFinding (category≠probe-noise → disposition obrigatório) é shape
			válido. cue vet EXIT=0. Pass.
			tq-as-01 (localização canônica): _schema.location preenchido. Pass.
			tq-as-02 (critérios acionáveis): tq-apr-01/02 concretos (todo run tem ≥1
			finding; finding não-noise tem disposition). Pass.
			tq-as-03 (rationale do conjunto): explica que os critérios cobrem
			integridade do audit-trail (append-only) + DoD-completeness (Goodhart). Pass.
			"""
	}]

	findings: {}

	summary: """
		#AgentProbeRecord materializa o registro de probe do Ciclo 4: targetCanvas
		(cross-ref), protocolVersion, triaged, runs[] append-only (cada probe = 1
		entry), e #ProbeFinding como UNIÃO DISCRIMINADA por #ProbeFindingCategory —
		category≠probe-noise exige disposition (#ProbeDisposition: linkedTo |
		acceptedAsResidual). Esta união é o mecanismo DoD-completeness que neutraliza
		Goodhart (record-stub não passa cue vet). Collection em
		architecture/agent-probes/records/. Estável em 1 round, zero findings.
		"""

	singleRoundRationale: """
		Schema desenhado a partir de spec detalhada do founder (runs[] append-only,
		finding{category, description, specLocation?, severity, linkedTo? |
		acceptedAsResidual?}, união discriminada category≠probe-noise → disposition).
		Mirror do padrão de união discriminada de #SelfReviewReport (status↔fail) e
		#StructuralCheck (kind↔rule). Verificável por inspeção direta; a própria
		união é testável por cue vet (instância sem disposição em finding real falha).
		Sem ambiguidade pendente.
		"""
}
