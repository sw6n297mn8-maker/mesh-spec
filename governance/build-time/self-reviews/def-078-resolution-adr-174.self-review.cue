package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def078ResolutionAdr174: build_time.#SelfReviewReport & {
	reportId: "srr-def-078-resolution-adr-174"

	artifactPath:       "architecture/deferred-decisions/def-078-approval-order-gate-vs-consequence.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-12"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da RESOLUÇÃO do def-078 (edição de lifecycle:
			status open → resolved + resolvedBy adr-174). A decisão aconteceu
			EXATAMENTE como o trigger manual-review previa: o founder resolveu
			gate vs consequência ('A — portão') na conversa de modelo que abriu
			o WI-151 — o def não precisou de vigilância automática para ser
			encontrado, ele bloqueava o passo de triagem da fatia que o citava.

			[uq-08 CONFORMÂNCIA]: cue vet EXIT=0 — o branch resolved da união
			discriminada #DeferredDecision exige resolvedBy #OriginRef;
			populado com o path do adr-174. [uq-03 REFS]: resolvedBy resolve no
			disco (adr-174 existe no working tree da mesma fatia). [LIFECYCLE
			per adr-062/adr-174 decisão 6]: a resolução viaja NO MESMO COMMIT
			da materialização do portão — status resolved não chega ao remoto
			antes da prova no disco. Comentário de status registra decisão do
			founder + data + veículo (conversa do WI-151), audit trail na
			própria linha. [uq-07]: edição de 2 campos + comentário; zero
			placeholder; conteúdo restante do def INTACTO (append-only espírito
			— description/deferralRationale/triggers preservados como registro
			histórico do deferimento).
			"""
	}]

	findings: {}

	summary: """
		def-078 resolvido: founder decidiu PORTÃO (opção A) na conversa que
		abriu o WI-151, per o próprio trigger manual-review do def; resolvedBy
		aponta adr-174; a resolução viaja no mesmo commit da materialização
		(adr-174 decisão 6). VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: transição de lifecycle prevista pelo schema
		(open → resolved) executando decisão explícita do founder, com o ADR de
		resolução revisado isoladamente na mesma fatia; nada a revisar além da
		conformância do branch e da resolução da ref.
		"""
}
