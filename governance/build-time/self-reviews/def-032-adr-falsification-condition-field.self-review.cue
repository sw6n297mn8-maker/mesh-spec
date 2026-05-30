package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def032AdrFalsificationConditionField: build_time.#SelfReviewReport & {
	reportId: "srr-def-032-adr-falsification-condition-field"

	artifactPath:       "architecture/deferred-decisions/def-032-adr-falsification-condition-field.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-30"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-032 (Camada 2 da auditoria: campo
			falsificationCondition no #ADR — hipótese falsificável por decisão).
			Registra, como deferimento de horizonte IMINENTE (PR-#1), a evolução
			do schema #ADR + structural-check.

			Conformância #DeferredDecision (tq-def-01/02/03/04):
			(tq-def-01) deferralRationale ≥100 runes: o ponto delicado deste DD é
			que a decisão de FAZER já foi tomada (iminente) — o deferralRationale
			articula explicitamente que o defer é só até o PR-#1 subsequente
			(manter o PR de registro leve/classe-única vs evolução de schema
			base), NÃO incerteza sobre fazer. Distinção iminente-vs-diferido
			registrada para evitar tratamento zumbi no dd-status. PASS.
			(tq-def-02) triggers conformam #Trigger: manual-review (reason ≥40)
			+ recurrence filename (ADRs derive-* threshold 5). cue vet EXIT 0.
			PASS.
			(tq-def-03) backstop recurrence é non-manual-review — satisfaz
			mesmo com primário manual-review. PASS. Manual-review primário
			justificado: evolução de schema base é founder-only e revisita já
			agendada (não sinal emergente).
			(tq-def-04) severity=high + blastRadius=repo-wide coerentes — campo
			do schema base #ADR afeta todo ADR presente/futuro; barato de
			adicionar, alto valor (destrava revisita disciplinada + métrica 2 do
			painel def-034). PASS.

			Distinção de campos existentes (registrada na description):
			falsificationCondition ≠ defersTo (deferimento) ≠ reversibility
			(custo) ≠ supersededBy (sucessão). É a condição que INVALIDA a
			decisão — gap real, não redundância.

			Verificação: cue vet EXIT 0; shape conforma "open";
			originatingArtifacts cita session:feedback-cycles-audit + adr.cue
			(path real); recurrence pattern derive-*-bounded-context casa os
			ADRs de derivação (fce/drc/scf hoje = N=3, dispara no 5º).
			"""
	}]

	findings: {}

	summary: """
		def-032 conforma #DeferredDecision (tq-def-01..04 PASS). Camada 2
		(falsificationCondition no #ADR). Horizonte: IMINENTE (PR-#1);
		manual-review primário + recurrence N=5 backstop. severity high,
		repo-wide (schema base). Distinto de defersTo/reversibility/supersededBy.
		cue vet EXIT 0.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round: decisão de fazer já tomada na auditoria
		(horizonte iminente); o trabalho deste DD foi calibrar o deferralRationale
		para distinguir iminente-de-diferido (ajuste explícito do founder) e os
		triggers (manual primário + recurrence backstop). Conformidade tq-def-NN
		verificada + cue vet EXIT 0.
		"""
}
