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
	}, {
		artifactPath: "architecture/adrs/adr-016-readme-coevolution.cue"
		rationale:    "ADR de 2026-03-19 predecede o mecanismo de self-review. Editado posteriormente apenas para supersession mecânica (status + supersededBy) per protocolo de supersession do CLAUDE.md. Superseded por ADR-051."
	}, {
		artifactPath: "architecture/adrs/adr-017-readme-blocks-as-derived-artifacts.cue"
		rationale:    "Mesmo padrão de ADR-016: 2026-03-19, predecede self-review, editado apenas para supersession mecânica. Superseded por ADR-051."
	}, {
		artifactPath: "architecture/production-guides/adr.cue"
		rationale:    "PG criada/modificada em main antes de adr-067 estabelecer path-mapping para production-guide instances. Modificações cobertas indiretamente pelos SRRs dos ADRs originadores (e.g., adr-058, adr-059) cujo artifactPath aponta para o ADR, não para a PG. Categoria pre-mapping-transient: sai desta exception quando próxima modificação criar SRR matching path. Schema first-class para transient lifecycle deferido per def-011."
	}, {
		artifactPath: "architecture/production-guides/agent-governance.cue"
		rationale:    "Mesma categoria pre-mapping-transient de architecture/production-guides/adr.cue: PG em main pre-adr-067 path-mapping; modificações cobertas indiretamente por SRRs de ADRs originadores. Sai desta exception na próxima modificação com SRR matching path. Schema first-class para transient lifecycle deferido per def-011."
	}, {
		artifactPath: "architecture/production-guides/agent-spec.cue"
		rationale:    "Mesma categoria pre-mapping-transient de architecture/production-guides/adr.cue: PG em main pre-adr-067 path-mapping; modificações cobertas indiretamente por SRRs de ADRs originadores. Sai desta exception na próxima modificação com SRR matching path. Schema first-class para transient lifecycle deferido per def-011."
	}, {
		artifactPath: "architecture/production-guides/structural-check.cue"
		rationale:    "Mesma categoria pre-mapping-transient de architecture/production-guides/adr.cue: PG em main pre-adr-067 path-mapping; modificações cobertas indiretamente por SRRs de ADRs originadores. Sai desta exception na próxima modificação com SRR matching path. Schema first-class para transient lifecycle deferido per def-011."
	}, {
		artifactPath: "architecture/structural-checks/canvas.cue"
		rationale:    "Categoria pre-mapping-transient (extensão de adr-067 a structural-check via adr-068): SC em main pre-adr-068 path-mapping; modificação coberta indiretamente por SRR do ADR originador. Sai desta exception na próxima modificação com SRR matching path. Schema first-class para transient lifecycle deferido per def-011."
	}]

	rationale: """
		Três categorias de exceções:
		(1) Commit inaugural do sistema de self-review (4 artefatos:
		ADR-013/014/015 + quality-criteria.cue) — circularidade.
		(2) ADRs predecessores ao mecanismo, editados apenas para
		supersession mecânica (ADR-016/017).
		(3) Artefatos em main pre-path-mapping (4 PGs adr/agent-
		governance/agent-spec/structural-check via adr-067 + 1 SC
		canvas via adr-068) — exception transiente, sai quando
		próxima modificação criar SRR matching path. Categoria/
		lifecycle vivem na prose rationale; promoção a schema
		first-class deferida per def-011. Artefatos build-time
		não precisam de exceção porque não são governedTypes.
		"""
}
