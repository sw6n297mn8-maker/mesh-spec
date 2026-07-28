package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

frontendCodegenContractProductionGuide: build_time.#SelfReviewReport & {
	reportId: "srr-frontend-codegen-contract-production-guide"

	artifactPath:       "architecture/production-guides/frontend-codegen-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-28"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 2
		infoCount: 0
		summary: """
			PG SUBAGENT-DRAFTED (disp-010 per authoring-policy rollout
			Phase 1 — draft manual prévio do main agent DESCARTADO por
			regime error, provado pelo subagent-execution-log). Review
			isolado (executionPolicy: production-guide →
			isolated-subagent) sobre o draft do authoring subagent.
			1 fail: def-060 citado como delegação runtime-local VIVA em 4
			pontos normativos (gapPolicy; process/heuristic/source da
			section envelope-gate-and-output) — def-060 está WITHDRAWN per
			adr-159 (decomposto em def-066/067/068; o mecanismo do gate
			ficou runtime-local SEM def pendente); o exit rule de
			activeBoundaries só cobria "resolved" (withdrawn ficaria na
			lista); reconciliation pair 4 checava EXISTÊNCIA de arquivo
			(withdrawn preserva arquivo e passaria). Main agent VERIFICOU
			na fonte (status do def-060; adr-159; os 3 sucessores vivos) e
			CONFIRMOU. 2 advisories: heuristic de read-only citava a fila
			do p2p como exemplo de família read-only (ela vive como
			readSurface DENTRO da família action-bearing); validatorNote
			sem menção à 2ª camada determinística (sc-fcc).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round de estabilização (retry 1 per
			fallbackPolicy.onSelfReviewFail): 8 deltas cirúrgicos
			aplicados (deltas 1-6: fronteira QUE=spec/COMO=runtime do
			adr-158 + decomposição adr-159 + regra de saída por status
			VIVO — resolved OU withdrawn — + pair 4 exigindo def VIVO
			open/triggered; delta 7: mapa de cotações como precedente
			fundador de read-only, fila do p2p removida como exemplo;
			delta 8: validatorNote ganha a 2ª camada sc-fcc). Reviewer
			confirmou o fail RESOLVIDO com fidelidade verificada
			(incluindo a precisão de que o mecanismo do gate nunca foi
			peça nomeada do def-060), os 2 advisories incorporados sem
			violação nova, e regressão zero critério a critério
			(uq + tq-pg + tq-mg). STABLE.
			"""
	}]

	findings: {}

	summary: """
		Production guide do tipo frontend-codegen-contract, autorado via
		DISPATCH REAL (disp-010; transparência obrigatória per CLAUDE.md
		"Authoring Declarativo" — entry append-only no
		subagent-execution-log com reasoning report e calibração), 4
		sections (family-classification, action-slots, read-surfaces,
		envelope-gate-and-output) + 4 tq-fcg espelhando 1:1 os tq-fcc do
		schema. Pipeline: authoring dispatch → review isolado (1 fail
		def-060-withdrawn + 2 advisories) → round de estabilização com 8
		deltas → STABLE em 2/4 rounds. 5 would-have-asked do authoring
		apresentados ao founder na proposta consolidada e aceitos como
		propostos (tq-fcg-03 escopo estendido; tq-fcg-04 warn; section
		action-slots condicional via objective+ifGap; nota "nasce na mesma
		fatia" nos sources; header do arquivo → subagent-drafted
		founder-approved na escrita). Na escrita: propagação mecânica do
		delta returnsEvents (§2 aprovado no schema) aos textos do PG que
		nomeiam o campo, declarada no checkpoint; e correção de fidelidade
		no detail da síntese do rationale (linguagem-alvo runtime-local sem
		def único pendente pós-adr-159 — mesma classe do fail do round 1),
		declarada no checkpoint.
		"""
}
