package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr015: artifact_schemas.#ADR & {
	id:            "adr-015"
	title:         "Bootstrap exception for inaugural self-review artifacts"
	date:          "2026-03-19"
	status:        "accepted"
	decisionClass: "structural"
	decider:       "founder"
	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		ADRs 013 e 014 instituem self-review evidence e CI enforcement.
		O commit inaugural cria/altera artefatos governados (ADRs,
		quality-criteria.cue) que o CI exigiria reports prévios — mas
		o sistema não existia antes deste commit. Alternativas:
		(1) Isentar o PR inteiro do CI check — rejeitada porque é
		    mais ampla que necessário; artefatos não-inaugurais no
		    mesmo PR ficariam sem enforcement.
		(2) Gerar self-review reports retroativos para os artefatos
		    inaugurais — rejeitado porque evidência fabricada
		    retroativamente derrota o propósito de auditabilidade.
		"""

	decision: """
		Criar governance/build-time/self-review-bootstrap-policy.cue
		com modo bootstrap-exception listando exatamente os artefatos
		governados do commit inaugural: quality-criteria.cue (modificado)
		e ADRs 013, 014, 015 (criados). O CI consulta esta policy
		antes de exigir report. Após o commit inaugural, o modo pode
		transicionar para strict-from-start.
		"""

	consequences: """
		Positivas: evita recursão sem fraquejar o modelo; exceção
		é explícita, auditável e granular (por artifact path).
		Negativas: janela controlada onde 4 artefatos governados
		entram sem evidência de self-review.
		"""

	affectedArtifacts: []

	plannedOutputs: [
		"governance/build-time/self-review-bootstrap-policy.cue",
	]

	principlesApplied: ["P0", "P12"]

	rationale: """
		Bootstrap circular — exigir evidência do próprio mecanismo que
		cria a evidência — é impossível por construção. A alternativa
		de isenção ampla (PR inteiro) sacrifica granularidade
		desnecessariamente. Exceção por path é mínima e auditável.
		"""
}
