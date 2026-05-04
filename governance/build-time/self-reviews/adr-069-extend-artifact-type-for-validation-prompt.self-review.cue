package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr069: build_time.#SelfReviewReport & {
	reportId: "srr-adr-069"

	artifactPath:       "architecture/adrs/adr-069-extend-artifact-type-for-validation-prompt.cue"
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
		summary:   "ADR estende artifact_type_for_path em scripts/ci/check-self-review.sh para cobrir validation-prompt instances per pattern progressivo de adr-060/066/067/068. Prerequisite mecânico: estende #ArtifactType enum em quality-criteria.cue com 'validation-prompt' (paralelo a adr-061/062/064 quando adicionaram tipos novos; adr-066/067/068 não precisaram porque tipos já estavam no enum). quality-criteria.cue está em bootstrap-exempt — sem SRR matching path requerido. Pattern narrow ('architecture/validation-prompts/validate-*.cue') paralelo a adr-066 (def-*) — convenção de prefixo estabelecida em todos os 14 VPs preserva opção de futuros arquivos não-validate sem amendment. 14 instances totais; via git diff origin/main...HEAD 5 VPs modificados nesta branch (validate-adopted-artifacts, validate-deferred-decision, validate-production-guide, validate-readme-config, validate-tension-entry), nenhuma com SRR matching path antes deste commit → 5 retroativos in-flight materializados. Regularização transitória de 9 VPs main pre-path-mapping via 9 entries em self-review-bootstrap-policy.cue (categoria pre-mapping-transient extendida; total cumulativo da categoria=14: 4 PGs + 1 SC + 9 VPs). adr-069 intentionally increases the empirical basis for def-011; the repeated trigger is evidence, not failure: count de path-mapping ADRs vai 4→5 (adr-061, adr-066, adr-067, adr-068, adr-069), 2 refires consecutivos acumulam evidence calibrating decision. Known gap: After this commit, def-011 should be actively reconsidered before the next path-mapping ADR. 4 alternativas explicitamente rejeitadas (status quo, broad pattern, batch com BC artifacts, resolver def-011 antes). defersTo: [def-011]. principlesApplied: P10, P12. decisionClass=structural, reversibility=high, blastRadius=cross-cutting. Pattern paralelo a adr-060/068 (5 retros) + continuidade direta de adr-067/068 (categoria pre-mapping-transient). cue vet ./... EXIT=0; CI self-review-check local PASSED."
	}]

	findings: {}

	summary: "ADR-069 adiciona validation-prompt ao CI mapping (continuação adr-060/066/067/068 progressive). Pattern narrow validate-*.cue. 5 retroativos in-flight + 9 bootstrap exceptions transientes para VPs main pre-mapping (categoria total=14) + def-011 trigger refires intencionalmente (count 4→5). Commit consolidado 17 arquivos."

	singleRoundRationale: "Pattern bem-estabelecido (adr-060/066/067/068 directly applicable). Retroativos in-flight + regularização transitória + trigger refire intencional + revisita ativa de def-011 declarada em Known gaps. Round único suficiente."
}
