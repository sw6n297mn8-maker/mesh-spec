package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def060WithdrawDecomposition: build_time.#SelfReviewReport & {
	reportId: "srr-def-060-withdraw-decomposition"

	artifactPath:       "architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-23"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da TRANSIÇÃO de def-060: triggered → withdrawn, decomposto por adr-159. (SRR
			separado do existente srr-def-060-frontend-client-vendor-stack, que revisou o deferral original; este
			cobre o withdraw.)

			[uq-08 schema — withdrawn shape]: PASS. A união discriminada exige withdrawalRationale (presente, ≥50
			runes) e proíbe resolvedBy (ausente — def-060 nunca o teve); triggeredAt + triggeredCondition são
			opcionais permitidos no shape withdrawn e foram MANTIDOS como história (o DD de fato foi triggered por
			adr-154). cue vet limpo.

			[uq-03 refs do withdrawalRationale]: PASS. Aponta os 4 destinos — framework → adr-159 (via rtd-004);
			sync → def-066; orquestração-IA → def-067; design → def-068 — todos existem no disco.

			[integridade referencial preservada]: PASS. def-060 PERMANECE no disco; os defersTo de adr-150/157/158 e
			o foundation pointer cross-repo do frontend-runtime seguem resolvendo (esse era o motivo de preservar vs
			split destrutivo).

			[tq-def-01/04 — campos de deferral históricos]: PASS. deferralRationale e costOfDeferral (low/
			cross-artifact) permanecem intactos como registro; o withdraw não os invalida. tq-def-02/03: trigger
			manual-review intacto (moot pós-withdraw, mas conformante).
			"""
	}]

	findings: {}

	summary: """
		Self-review da transição def-060 triggered → withdrawn (decomposto por adr-159, forma parent-withdrawn +
		sucessores-per-peça). O withdrawalRationale (≥50 runes) aponta os 4 destinos (framework → adr-159/rtd-004;
		sync → def-066; orquestração-IA → def-067; design → def-068). def-060 permanece no disco como charneira
		histórica para que os ponteiros existentes (defersTo de adr-150/157/158 + foundation pointer cross-repo do
		frontend-runtime) sigam resolvendo. SRR separado do existente (que cobriu o deferral original); 1 round.

		VEREDITO: 0 fail / 0 warn / 0 info. O shape withdrawn conforma (withdrawalRationale presente, resolvedBy
		ausente, triggeredAt/triggeredCondition retidos como história); todas as refs do withdrawalRationale
		resolvem; a integridade referencial é preservada por construção (def-060 não deletado). Estável em 1 round.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque o withdraw é uma transição de lifecycle de superfície pequena e bem-definida,
		exercitada inteira numa passada: o shape withdrawn da união discriminada (withdrawalRationale obrigatório
		presente; resolvedBy proibido ausente; triggeredAt/triggeredCondition opcionais retidos) confirmado por cue
		vet limpo; as 4 refs do withdrawalRationale (adr-159, def-066/067/068) verificadas no disco; e a invariante
		que motivou preservar def-060 (ponteiros cross-repo + defersTo de adr-150/157/158 seguem resolvendo)
		confirmada — def-060 permanece no disco. Sem delta a corrigir; a 1 round reflete o escopo mínimo do edit,
		não bypass.
		"""
}
