package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

ntf_primary_agent_governance_deletion: build_time.#SelfReviewReport & {
	reportId: "srr-ntf-primary-agent-governance-deletion"

	artifactPath:       "contexts/ntf/agents/ntf-primary-agent.governance.cue"
	artifactSchemaPath: "architecture/artifact-schemas/agent-governance.cue"
	artifactType:       "agent-governance"

	recordType:      "artifact-deletion"
	deletionContext: "Removido no reset corretivo (PR #43): BC NTF descontinuado; envelope de governanca do primary-agent deletado junto com o contexto. Strategic intent preservado em strategic/subdomains/ntf.cue."

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-21"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Deletion-only SRR. Esta SRR documenta a operação de DELETE
			do artifact, NÃO revisa conteúdo deletado.

			Per founder direction durante reset Phase desta sessão:
			artifact v1 apagado por contaminação por escalada semântica
			cumulativa observada entre 2026-05-13 e 2026-05-15. Conteúdo
			deletado preservado em git history para auditabilidade.
			Strategic intent em strategic/subdomains/ntf.cue preservado
			como ponto de partida canonical para futura restauração.

			Esta SRR é puramente operacional: existe para satisfazer
			check-self-review.sh que atualmente trata arquivos deletados
			como arquivos modificados (sem distinção via diff-filter).
			NÃO há rationale de design substancial — a decisão de design
			está no commit message do reset, não aqui.

			Deferred issue registrado para hardening futuro:
			"self-review-check treats deleted governed artifacts as
			modified artifacts and requires SRR. Evaluate whether delete-
			only diffs should require deletion SRR or be excluded via
			diff-filter in future governance hardening."
			"""
	}]

	findings: {}

	summary: """
		Deletion-only SRR para contexts/ntf/agents/ntf-primary-agent.governance.cue. Artifact apagado durante reset
		Phase por contaminação por escalada semântica. Strategic intent
		preservado em strategic/subdomains/ntf.cue. Decisão de design
		vive no commit message do reset, não nesta SRR.
		"""

	singleRoundRationale: """
		Single-round deletion SRR. Não há conteúdo novo a revisar —
		operação é DELETE, não MODIFY. SRR existe apenas para satisfazer
		check-self-review.sh enforcement que não distingue delete de
		modify. Deferred follow-up registrado para revisar este
		comportamento em hardening futuro do governance script.
		"""
}
