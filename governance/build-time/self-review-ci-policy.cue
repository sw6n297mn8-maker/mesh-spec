package build_time

import "list"

// self-review-ci-policy.cue — Política de enforcement de CI para self-review.
//
// #GovernedArtifactType é subset de artifact_schemas.#ArtifactType.
// Excluídos do enforcement:
//   - "canvas": BCs ainda não existem; será adicionado quando o primeiro
//     canvas for criado (wave W001 task wi-003+).
// Expansão de governedTypes exige inclusão aqui e atualização do CI.

#GovernedArtifactType:
	"adr" |
	"domain-definition" |
	"lens" |
	"artifact-schema" |
	"stakeholder-map" |
	"task-template" |
	"wave-plan"

#AssociationRule: {
	reportDirectory:      string & !=""
	reportFileNameFormat: string & !=""
	matchingRule:         string & !=""
	rationale:            string & !=""
}

#RolloutPolicy: {
	mode: "changed-only" | "all-governed"
	rationale: string & !=""
}

#RequiredCheck: {
	id:          string & =~"^ci-sr-[0-9]{2}$"
	description: string & !=""
	rationale:   string & !=""
}

#SelfReviewCIPolicy: {
	governedTypes: [#GovernedArtifactType, ...#GovernedArtifactType] & list.UniqueItems
	rollout:      #RolloutPolicy
	association:  #AssociationRule
	requiredChecks: [#RequiredCheck, ...#RequiredCheck]
	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^governance/build-time/self-review-ci-policy\\.cue$"
			fileNameRegex:      "^self-review-ci-policy\\.cue$"
			description:        "Política de enforcement do CI para self-review reports."
			rationale:          "Separa contrato de self-review da política de enforcement em pipeline."
			cardinality:        "singleton"
			allowNested:        false
		}
	}
}

selfReviewCIPolicy: #SelfReviewCIPolicy & {
	governedTypes: [
		"adr",
		"domain-definition",
		"lens",
		"artifact-schema",
		"stakeholder-map",
		"task-template",
		"wave-plan",
	]

	rollout: {
		mode: "changed-only"
		rationale: """
			Enforcement incremental. Exigir self-review apenas para artefatos
			governados novos ou alterados evita backfill massivo imediato
			e reduz blast radius da adoção.
			"""
	}

	association: {
		reportDirectory:      "governance/build-time/self-reviews/"
		reportFileNameFormat: "<artifact-base-name>.self-review.cue"
		matchingRule: """
			Para cada artefato governado alterado, existe exatamente um report
			em governance/build-time/self-reviews/ cujo campo artifactPath é
			igual ao path canônico do artefato.
			"""
		rationale: """
			O CI confia no campo artifactPath como vínculo canônico.
			O nome do arquivo ajuda discovery humana, mas a associação real
			é pelo conteúdo do report.
			"""
	}

	requiredChecks: [{
		id:          "ci-sr-01"
		description: "Todo artefato governado alterado tem self-review report correspondente"
		rationale:   "Sem report, não há evidência de autovalidação."
	}, {
		id:          "ci-sr-02"
		description: "Self-review report conforma com #SelfReviewReport"
		rationale:   "Report inválido não conta como evidência."
	}, {
		id:          "ci-sr-03"
		description: "artifactPath do report aponta exatamente para o artefato alterado"
		rationale:   "Evita report reciclado ou associado ao arquivo errado."
	}, {
		id:          "ci-sr-04"
		description: "artifactType do report pertence ao conjunto governado e é compatível com o artefato"
		rationale:   "Impede mismatch semântico entre report e artefato."
	}, {
		id:          "ci-sr-05"
		description: "status stable implica zero findings fail"
		rationale:   "Report não pode afirmar estabilidade e manter falhas bloqueantes."
	}, {
		id:          "ci-sr-06"
		description: "O artefato principal conforma com seu artifact schema"
		rationale:   "Self-review não substitui conformidade estrutural do artefato."
	}]

	rationale: """
		Validar apenas existência do report seria insuficiente — reports
		inválidos, reciclados ou desassociados derrotam o propósito.
		Os seis checks garantem que cada report é evidência real vinculada
		ao artefato correto.
		"""
}
