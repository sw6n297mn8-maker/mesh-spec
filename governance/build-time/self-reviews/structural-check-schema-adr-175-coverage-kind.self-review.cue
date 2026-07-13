package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckSchemaAdr175CoverageKind: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-schema-adr-175-coverage-kind"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da adição do kind instance-scoped-cross-file-
			coverage (adr-175): kind no enum #StructuralCheckKind + rule shape
			#InstanceScopedCrossFileCoverageRule no union #StructuralCheckRule
			(referencePaths + exclusionPaths + scopeField + targetGlobTemplate +
			targetIdPaths; exclusionPaths REQUIRED distingue o shape do
			#InstanceScopedCrossFileIdExistsRule na disjunção — defs fechadas
			desambiguam nos dois sentidos). FINDING FAIL pego pelo vet da
			instância sc-ag-02: o #StructuralCheck é uma UNIÃO DISCRIMINADA
			kind↔rule (linhas 36+) além do enum e do union de rules — o branch
			{kind: "instance-scoped-cross-file-coverage", rule:
			#InstanceScopedCrossFileCoverageRule} faltava, e a instância nova
			caía em 'empty disjunction'. A tríade enum+union era incompleta:
			são TRÊS pontos de registro no schema.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — branch adicionado à união discriminada (posicionado após
			o instance-scoped-cross-file-id-exists, ordem do enum preservada).
			cue vet EXIT=0 em artifact-schemas E structural-checks (a instância
			sc-ag-02 valida). [uq-08]: os 3 pontos de registro consistentes
			(enum, união discriminada, union de rule shapes). [uq-03/uq-04]:
			comentário do shape aponta adr-175 e herda a semântica de escopo
			fantasma do adr-113 por referência — zero duplicação. [uq-07]: zero
			placeholder. Self-asserção do runner (sc-meta-01
			evaluator-coverage) confirmada verde na validação integral: o kind
			novo tem evaluator em EVAL — cartaz com fiscal, no mesmo commit.
			"""
	}]

	findings: {}

	summary: """
		Kind instance-scoped-cross-file-coverage registrado nos TRÊS pontos do
		schema (enum #StructuralCheckKind, união discriminada kind↔rule do
		#StructuralCheck, union #StructuralCheckRule) com rule shape próprio
		cuja exclusionPaths required desambigua a disjunção vs o shape irmão
		do adr-113. Round 1 pegou a união discriminada faltante (empty
		disjunction na instância); round 2 fechou. cue vet EXIT=0. VEREDITO:
		stable, 0 fail residual.
		"""
}
