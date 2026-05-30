package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr130: build_time.#SelfReviewReport & {
	reportId: "srr-adr-130"

	artifactPath:       "architecture/adrs/adr-130-context-map-naming-shape-reconciliation-scf.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-30"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-130 reconcilia naming + shape de 1 aresta do context-map
			(rew-to-scf) com o canvas REW mergeado (autoridade per knownLimitations
			do context-map), no mesmo PR do scaffold SCF. Espelho fiel do adr-126
			(que reconciliou bkr-to-fce + rew-to-fce). rew-to-scf: events
			CounterpartyRiskScoreUpdated/CreditEligibilityDecided →
			RiskScoreEmitted/EligibilityEmitted; communication.type async→hybrid;
			queries (ausente) → QueryRiskScore/QueryEligibility. publishedLanguage
			'Risk score and eligibility model' + patterns OHS-PL/ACL PRESERVADOS.
			REW publica RiskScoreEmitted/EligibilityEmitted com consumers incl.
			scf (rew canvas:332-339) e expõe QueryRiskScore/QueryEligibility
			nomeando SCF ('Consumed primarily by SCF', rew:316,321). tq-adr-01
			PASSED: alternativa (só naming, deixar shape em openQuestion)
			explicitada e rejeitada (cherry-pick cria dívida, mesma lógica Q1=A do
			FCE). tq-adr-02 PASSED: reversibility=high (renomeação reversível),
			blastRadius=cross-artifact (context-map + canvas REW + canvas SCF que
			usam os nomes). tq-adr-03/04 PASSED: affectedArtifacts=[context-map]
			existe. principlesApplied=[P0] — canvas REW é autoridade, context-map
			vira ponteiro consistente. Acyclicity: nenhuma aresta nova/direção
			alterada (rew-to-scf é unidirecional, 0 ciclos antes e depois) —
			sc-cm-07 mantém 0 ciclos. Recorrência REW (rew-to-fce no #88, rew-to-scf
			agora) registrada para eventual PR de varredura rew-* (não agora). cue
			vet ./strategic/ EXIT=0 pós-edit; rew-to-scf landing verificado por
			grep (lição #91: edit single-line ASCII anchor + grep de confirmação).
			"""
	}]

	findings: {}

	summary: """
		ADR-130 reconcilia 1 aresta do context-map (rew-to-scf) com o canvas REW
		— naming + shape (async→hybrid + queries). Espelho fiel do adr-126.
		Aplicação completa do princípio canvas-vence (1 edge vs 2 do adr-126).
		Acyclicity preservada (0 ciclos). cue vet EXIT=0, landing verificado por
		grep.
		"""

	singleRoundRationale: """
		ADR mecânico-estrutural de reconciliação com diff exato pré-validado na
		section communication do canvas (founder gate S5). Alternativa única (só
		naming) explicitada e rejeitada; risco baixo e reversível. Espelho do
		adr-126 (mesma mecânica naming+shape). Acyclicity verificável por
		construção (aresta unidirecional). Round único suficiente.
		"""
}
