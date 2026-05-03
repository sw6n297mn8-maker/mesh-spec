package build_time

// self-review-bootstrap-policy.cue — Exceções controladas de bootstrap.
//
// Define como o sistema entra em vigor sem recursão ou deadlock na
// primeira adoção do próprio mecanismo de self-review.
//
// Exceções listam artefatos GOVERNADOS (matched por artifact_type_for_path
// e presentes em governedTypes) que são criados/modificados no commit
// inaugural OU em main pre-path-mapping (categoria pre-mapping-transient).
// Artefatos build-time (quality-gate.cue, self-review-report.cue,
// etc.) não precisam de exceção porque não são governedTypes.
//
// Schema first-class per adr-070: cada exception declara category +
// lifecycle explícitos. Categoria/lifecycle hoje têm relação 1:1
// (inaugural-circularity → permanent, predecessor-supersession-only →
// permanent, pre-mapping-transient → transient) mas declaração explícita
// preserva opção de futura categoria com lifecycle distinto.

#BootstrapMode: "strict-from-start" | "bootstrap-exception"

#BootstrapExceptionCategory:
	"inaugural-circularity" |
	"predecessor-supersession-only" |
	"pre-mapping-transient"

#BootstrapExceptionLifecycle: "permanent" | "transient"

#BootstrapException: {
	artifactPath:   string & !=""
	rationale:      string & !=""
	category:       #BootstrapExceptionCategory
	lifecycle:      #BootstrapExceptionLifecycle
	exitCondition?: string & !=""
}

#SelfReviewBootstrapPolicy: {
	mode: #BootstrapMode

	exceptions?: [#BootstrapException, ...#BootstrapException]

	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^governance/build-time/self-review-bootstrap-policy\\.cue$"
			fileNameRegex:      "^self-review-bootstrap-policy\\.cue$"
			description:        "Política de bootstrap para adoção do enforcement de self-review."
			rationale:          "Explicita exceções temporárias para evitar recursão no primeiro commit do próprio sistema."
			cardinality:        "singleton"
			allowNested:        false
		}
	}
}

selfReviewBootstrapPolicy: #SelfReviewBootstrapPolicy & {
	mode: "bootstrap-exception"

	exceptions: [{
		artifactPath: "architecture/artifact-schemas/quality-criteria.cue"
		category:     "inaugural-circularity"
		lifecycle:    "permanent"
		rationale:    "Modificado para adicionar #QualityCriterionFinding e #ArtifactType no mesmo commit que institui o sistema; exigir self-review prévio seria circular."
	}, {
		artifactPath: "architecture/adrs/adr-013-self-review-report-evidence.cue"
		category:     "inaugural-circularity"
		lifecycle:    "permanent"
		rationale:    "ADR que institui o contrato de evidência; não pode ter evidência de um sistema que ele próprio está criando."
	}, {
		artifactPath: "architecture/adrs/adr-014-self-review-ci-enforcement.cue"
		category:     "inaugural-circularity"
		lifecycle:    "permanent"
		rationale:    "ADR que institui o enforcement; mesma circularidade de adr-013."
	}, {
		artifactPath: "architecture/adrs/adr-015-self-review-bootstrap-exception.cue"
		category:     "inaugural-circularity"
		lifecycle:    "permanent"
		rationale:    "ADR que documenta esta própria exceção; circularidade de terceira ordem."
	}, {
		artifactPath: "architecture/adrs/adr-016-readme-coevolution.cue"
		category:     "predecessor-supersession-only"
		lifecycle:    "permanent"
		rationale:    "ADR de 2026-03-19 predecede o mecanismo de self-review. Editado posteriormente apenas para supersession mecânica (status + supersededBy) per protocolo de supersession do CLAUDE.md. Superseded por ADR-051."
	}, {
		artifactPath: "architecture/adrs/adr-017-readme-blocks-as-derived-artifacts.cue"
		category:     "predecessor-supersession-only"
		lifecycle:    "permanent"
		rationale:    "Mesmo padrão de ADR-016: 2026-03-19, predecede self-review, editado apenas para supersession mecânica. Superseded por ADR-051."
	}, {
		artifactPath:  "architecture/production-guides/adr.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "PG criada/modificada em main antes de adr-067 estabelecer path-mapping para production-guide instances. Modificações cobertas indiretamente pelos SRRs dos ADRs originadores (e.g., adr-058, adr-059) cujo artifactPath aponta para o ADR, não para a PG."
	}, {
		artifactPath:  "architecture/production-guides/agent-governance.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "PG em main pre-adr-067 path-mapping; modificações cobertas indiretamente por SRRs de ADRs originadores."
	}, {
		artifactPath:  "architecture/production-guides/agent-spec.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "PG em main pre-adr-067 path-mapping; modificações cobertas indiretamente por SRRs de ADRs originadores."
	}, {
		artifactPath:  "architecture/production-guides/structural-check.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "PG em main pre-adr-067 path-mapping; modificações cobertas indiretamente por SRRs de ADRs originadores."
	}, {
		artifactPath:  "architecture/structural-checks/canvas.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "SC em main pre-adr-068 path-mapping; modificação coberta indiretamente por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-adr.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; modificação coberta indiretamente por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-agent-governance.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-agent-spec.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-artifact-schema.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-canvas.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-domain-definition.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-domain-model.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-glossary.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}, {
		artifactPath:  "architecture/validation-prompts/validate-self-review-report.cue"
		category:      "pre-mapping-transient"
		lifecycle:     "transient"
		exitCondition: "Remove exception when artifact receives a matching SRR after next modification."
		rationale:     "VP em main pre-adr-069 path-mapping; cobertura indireta por SRR do ADR originador."
	}]

	rationale: """
		Schema first-class per adr-070: cada exception declara category +
		lifecycle + exitCondition (opcional, presente em transient).
		Três categorias atuais:
		(1) inaugural-circularity (permanent, 4 entries): commit inaugural
		do sistema de self-review (ADR-013/014/015 + quality-criteria.cue).
		(2) predecessor-supersession-only (permanent, 2 entries): ADRs
		predecessores ao mecanismo, editados apenas para supersession
		mecânica (ADR-016/017).
		(3) pre-mapping-transient (transient, 14 entries): artefatos em
		main pre-path-mapping. 4 PGs (adr/agent-governance/agent-spec/
		structural-check via adr-067) + 1 SC (canvas via adr-068) +
		9 VPs (validate-adr/agent-governance/agent-spec/artifact-schema/
		canvas/domain-definition/domain-model/glossary/self-review-report
		via adr-069). Sai quando próxima modificação criar SRR matching
		path. Cleanup mecânico (stale detection) deferido per def-012
		até primeira stale exception observada.

		Artefatos build-time não precisam de exceção porque não são
		governedTypes.
		"""
}
