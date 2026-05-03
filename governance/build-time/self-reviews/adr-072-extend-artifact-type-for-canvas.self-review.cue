package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr072: build_time.#SelfReviewReport & {
	reportId: "srr-adr-072"

	artifactPath:       "architecture/adrs/adr-072-extend-artifact-type-for-canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-03"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "ADR estende artifact_type_for_path em scripts/ci/check-self-review.sh para cobrir canvas instances per pattern progressivo de adr-060/066/067/068/069. Pattern broad ('contexts/*/canvas.cue') reflete convenção estrutural fixa (cada BC, 1 canvas em path canônico). Não colide com canvas schema/SC/VP em outros diretórios já cobertos. 4 instances totais (cmt, ctr, idc, npm); via git diff origin/main...HEAD ZERO modificadas nesta branch → zero retroativos in-flight. Primeiro path-mapping ADR pós-adr-070 — uso operacional do schema first-class de bootstrap exception (category + lifecycle + exitCondition?). Regularização transitória de 4 canvas main pre-path-mapping via 4 entries em self-review-bootstrap-policy.cue (categoria pre-mapping-transient com schema first-class; total cumulativo da categoria pós-adr-072=18). Wording de rationale dos exceptions ajustado per founder explicit guidance: 'Foi revisada no contexto dos ADRs originadores, mas não havia SRR path-matching porque o mapping ainda não existia' (em vez de claim de cobertura indireta). def-012 trigger NÃO fires neste commit (count 18 < threshold 20). def-011 RESOLVED em adr-070 — SKIPPED pelo runner. 4 alternativas explicitamente rejeitadas (status quo, narrow pattern, batch BC artifacts, wait until 1+ modified). principlesApplied: P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-cutting. Volume baixo (5 arquivos) reflete maturidade do pattern e zero retros. cue vet ./... EXIT=0; CI self-review-check local PASSED."
	}]

	findings: {}

	summary: "ADR-072 adiciona canvas ao CI mapping (continuação adr-060/066/067/068/069 progressive + uso operacional schema first-class adr-070). Pattern broad contexts/*/canvas.cue. Zero retros + 4 transient bootstrap exceptions. def-012 não fires (count 18 < 20). Commit consolidado 5 arquivos."

	singleRoundRationale: "Pattern bem-estabelecido (adr-060/066/067/068/069 directly applicable) + schema first-class de bootstrap exception (adr-070) operacional. Zero retros + zero ambiguity de design. Round único suficiente."
}
