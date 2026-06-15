package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def062SelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-def-062-local-specialization-shared-primitive"

	artifactPath:       "architecture/deferred-decisions/def-062-local-specialization-shared-primitive.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-15"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 -- review por SUB-AGENTE ISOLADO (junto de adr-151). Conformidade PASS:
			def-062 conforma a #DeferredDecision (cue export limpo; arm status=open sem
			campos auxiliares; MinRunes todos satisfeitos -- description, deferralRationale,
			triggerCalibrationRationale, costOfDeferral.description e os 2 reasons
			manual-review); tq-def-03 e WARN advisory (nao bloqueante) e o escape esta
			satisfeito (manual-only justificado: um trigger de recurrence contaria CABECAS
			e violaria o corte formas-nao-cabecas); coerencia com adr-151 (regra de corte,
			n=1, caso bkr, semantica dos gatilhos) bate. 1 WARN (reflexo do ponto 3 do
			adr-151): o costOfDeferral re-importava a conflacao "mismatch -> fila -> nada
			escapa" sem distinguir o masquerade de nome identico.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 -- re-review por SUB-AGENTE ISOLADO fresco. WARN RESOLVIDO: o
			costOfDeferral.description agora diz que bkr e coreNoun-DIVERGENTE (e por isso o
			mismatch dispara e vai a fila) e que o gatilho-risco e manual-review por MOTIVO
			DISTINTO (o masquerade de nome IDENTICO nao gera mismatch, logo nenhum flag
			estrutural o expoe -- so revisao humana periodica). Sem conflacao residual entre
			def-062 e adr-151; os dois arquivos concordam. Nenhum WARN/FAIL novo. cue vet
			EXIT=0. Zero fail residual -> estavel.
			"""
	}]

	findings: {}

	summary: """
		def-062 (open) defere a Forma B.2 (especializacao local de primitivo compartilhado:
		campos specializes/localConstraint) do adr-151 -- n=1 de forma no disco (bkr/
		vo-settlement-value, Money excluindo zero), corte por formas distintas nao cabecas,
		ambos os triggers manual-review por construcao. Self-review por SUB-AGENTE ISOLADO
		em 2 rounds (junto do adr-151): round 1 confirmou conformidade a #DeferredDecision +
		escape do tq-def-03 + coerencia, com 1 WARN (costOfDeferral re-importava a
		conflacao do 4e); round 2 confirmou o WARN resolvido (bkr divergente vs masquerade
		identico agora separados) sem novo finding. cue vet EXIT=0. Zero fail residual;
		estavel em 2 rounds.
		"""
}
