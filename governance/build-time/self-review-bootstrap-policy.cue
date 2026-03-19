package build_time

// self-review-bootstrap-policy.cue — Exceções controladas de bootstrap.
//
// Define como o sistema entra em vigor sem recursão ou deadlock na
// primeira adoção do próprio mecanismo de self-review.
//
// Exceções listam artefatos GOVERNADOS (matched por artifact_type_for_path
// e presentes em governedTypes) que são criados/modificados no commit
// inaugural. Artefatos build-time (quality-gate.cue, self-review-report.cue,
// etc.) não precisam de exceção porque não são governedTypes.
//
// Após o commit inaugural, o modo pode transicionar para strict-from-start.

#BootstrapMode: "strict-from-start" | "bootstrap-exception"

#BootstrapException: {
	artifactPath: string & !=""
	rationale:    string & !=""
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
		rationale:    "Modificado para adicionar #QualityCriterionFinding e #ArtifactType no mesmo commit que institui o sistema; exigir self-review prévio seria circular."
	}, {
		artifactPath: "architecture/adrs/adr-013-self-review-report-evidence.cue"
		rationale:    "ADR que institui o contrato de evidência; não pode ter evidência de um sistema que ele próprio está criando."
	}, {
		artifactPath: "architecture/adrs/adr-014-self-review-ci-enforcement.cue"
		rationale:    "ADR que institui o enforcement; mesma circularidade de adr-013."
	}, {
		artifactPath: "architecture/adrs/adr-015-self-review-bootstrap-exception.cue"
		rationale:    "ADR que documenta esta própria exceção; circularidade de terceira ordem."
	}]

	rationale: """
		A exceção é estritamente limitada aos 4 artefatos governados
		(3 ADRs + 1 schema modificado) do commit inaugural. Artefatos
		build-time não precisam de exceção porque não são governedTypes.
		Após o commit inaugural, transicionar para strict-from-start.
		"""
}
