package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr142: build_time.#SelfReviewReport & {
	reportId: "srr-adr-142-cmt-bilateral-acceptance-contract"

	artifactPath:       "architecture/adrs/adr-142-cmt-bilateral-acceptance-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-03"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-142 (aceite bilateral do CMT: contrato + integridade criptográfica de
			termos) por SUB-AGENTE ISOLADO (per quality-gate executionPolicy rollout: adr →
			isolated-subagent), sem acesso ao histórico da sessão de autoria — isolation reduz viés de
			auto-ratificação. Avaliado contra 9 universalCriteria + tq-adr-01..04. 1 finding fail:
			uq-03 — defersTo:["def-046"] referencia um #DeferredDecision ainda inexistente no disco
			(o schema diz "deve resolver para def-XXX-*.cue existente"). Todos os demais passaram:
			uq-02 (Mesh-specificity: mech-evidence, dp-08/dp-10, CommitmentId, golden-example/P1);
			uq-03 verificou no filesystem que os 5 affectedArtifacts existem; principlesApplied
			P0/P1/P6/P7/P10/P11 confirmados em design-principles.cue e dp-08/dp-10 em
			domain-definition.cue; tq-adr-01 (6 eixos de alternativas com motivo de rejeição concreto);
			tq-adr-02 (low/cross-cutting coerentes com contrato publicado CommitmentAccepted +
			consumidores BDG/DLV/INV); tq-adr-03 (paths reais). uq-09 N/A (subagente isolado não recebe
			transcript de autoria).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			findingEvaluation do uq-03 pelo main agent (verificação, não aplicação cega per
			executionPolicy.findingEvaluation): finding factualmente correto sobre o snapshot de
			meio-de-autoria, mas NÃO é defeito do adr-142 — o padrão defersTo↔plannedOutputs para um
			def criado ATOMICAMENTE no mesmo commit é o idioma correto do adr-062, com precedente direto
			no adr-139 (defersTo ["def-037","def-038","def-039"], criados no mesmo commit). O "existente"
			do schema é satisfeito no momento do commit/CI. RESOLVIDO por completude de pacote:
			def-046-ctr-availability-sla.cue autorado no mesmo pacote; re-verificado que o arquivo existe
			→ a referência resolve. 0 fail residual. cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		adr-142 materializa pela primeira vez o contrato de aceite bilateral do CMT com predicado
		verificável: hash criptográfico de {contractTermsRef, scope} (proponente implícito via
		ProposeCommitment, contraparte explícita via ConfirmCommitmentAcceptance), fail-closed em
		propose-time (SLA → def-046), idempotência no-op (P6), publicação única de CommitmentAccepted
		com evidência aditiva (termsHash + confirmedBy) e zero-drift com sc-cmt-01/02. Self-review por
		SUB-AGENTE ISOLADO (rollout adr): 1 fail (uq-03, defersTo→def-046) resolvido por completude de
		pacote (precedente adr-139), 0 residual. Estável em 2 rounds.
		"""
}
