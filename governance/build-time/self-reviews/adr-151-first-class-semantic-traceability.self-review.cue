package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr151: build_time.#SelfReviewReport & {
	reportId: "srr-adr-151-first-class-semantic-traceability"

	artifactPath:       "architecture/adrs/adr-151-first-class-semantic-traceability.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
			Round 1 -- review por SUB-AGENTE ISOLADO (rollout adr -> isolated-subagent),
			sem o historico da sessao de autoria, sobre adr-151 + def-062. Sete pontos de
			ataque, verificacao contra o disco. PASS: (1) factualidade -- o regex proposto
			casa os 12 glossarios e o candidato shared com ZERO orfao/ambiguidade nova
			(re-rodou o file_classification real do structural-check-runner); bkr/
			vo-settlement-value com amount>0 existe (contexts/bkr/domain-model.cue:1028);
			is_type_definition_file pula money.cue (alternativa 3 confirmada). (2) as 4
			condicoes de falsificacao sao falsificaveis, cond 2 testavel agora e nao
			violada. (4) affectedArtifacts:[] + plannedOutputs satisfaz sc-adr-01 (warn).
			(5) defersTo resolve + def-062 conforma. (6) P0/P1/P10/P12 aplicados com
			mecanismo (P1 cruzado com adr-144/adr-122 = uso convencional do repo). (7)
			coerencia ADR<->def-062. 1 WARN (ponto 3): o non-goal conflava dois casos --
			afirmava que o 4e se encaminha a fila via "shared + mismatch de coreNoun", mas
			um 4e de nome IDENTICO nao gera mismatch, logo a rota deterministica nao engata
			para o caso que invoca. cue vet EXIT=0.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 2 -- re-review por SUB-AGENTE ISOLADO fresco, sobre as secoes corrigidas.
			WARN do round 1 RESOLVIDO, verificado verbatim: os dois non-goals (decision +
			consequences) agora distinguem (i) especializacao coreNoun-DIVERGENTE ->
			flagrada deterministicamente pelo mismatch -> fila; (ii) masquerade 4e de
			nome+shape IDENTICO -> sem sinal estrutural -> exposto so por revisao humana/
			self-review periodica. A afirmacao absoluta "nada escapa silencioso" foi
			removida (grep zero); a afirmacao precisa esta presente ("o gate nao da
			falso-flag, e o caso divergente nao escapa; o masquerade identico depende de
			olho humano periodico"). Nenhum WARN/FAIL novo aberto; coerencia ADR<->def-062
			mantida (def-062 costOfDeferral alinhado). 1 INFO sem acao: o item pre-existente
			das Positivas (false-desonesto exposto por G4 + fila) -- caso DISTINTO do 4e
			(o false-desonesto tem sinal estrutural via G4; o masquerade identico nao),
			defensavel, nao introduzido por esta revisao. cue vet EXIT=0. Zero fail
			residual -> estavel.
			"""
	}]

	findings: {}

	summary: """
		adr-151 (proposed) estabelece rastreabilidade semantica first-class entre a
		linguagem ubiqua e o domain-model: declaracao explicita firstClass, Forma A
		(owned, cobertura dedicada) e Forma B (shared, termo canonico + schema ref) com
		extensao minima do #Glossary regex para lar canonico; materializacao (deltas de
		schema, glossario-kernel, gate de producao, backfill) e plannedOutput. Self-review
		por SUB-AGENTE ISOLADO em 2 rounds (rollout adr -> isolated-subagent): round 1
		atacou 7 pontos contra o disco e achou 1 WARN (non-goal conflava o 4e de nome
		identico com a rota deterministica de mismatch) + 6 PASS; round 2 confirmou o WARN
		resolvido (os dois regimes agora separados: divergente flagrado deterministicamente,
		identico so por revisao periodica) sem novo WARN/FAIL e com coerencia ADR<->def-062
		mantida. cue vet EXIT=0. Zero fail residual; estavel em 2 rounds.
		"""
}
