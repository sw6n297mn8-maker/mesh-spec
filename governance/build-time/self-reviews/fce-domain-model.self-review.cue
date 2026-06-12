package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fceDomainModelSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-fce-domain-model"

	artifactPath:       "contexts/fce/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-06-12"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Pós-escrita, gates locais: fail sc-ev-01 — 6 events[].name com
			espaço (corrigidos para PascalCase); fail sc-cm-06 — arestas
			do context-map com FCE in-scope exigem PaymentObligationDefaulted
			(produtor fce) e RiskScoreEmitted (rew→fce) no catálogo;
			adicionados como eventos de CATÁLOGO com fluxo declaradamente
			fora da fatia (T2) e fixture-contract respectivamente. Warn —
			ajuste estrutural +1 command/+1 event exigido por
			#StateTransition (transição authorized→dispatched), declarado
			no header.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-run: cue vet OK; structural-check-runner 0 bloqueantes
			(sc-ev-01 e sc-cm-06 resolvidos). Gaps T1/T2 + subconjunto
			5/11 de invariantes + fixtures REW/BKR com forward-ref
			oq-fce-4 declarados no header; lifecycle 4 estados com guards
			mapeando as 5 invariantes da fatia; INV consumido REAL
			(espelho de #InvoiceIssued).
			"""
	}]

	findings: {}

	summary: """
		Domain-model FCE — fatia do caminho do guard (claim parcial
		WI-043, NÃO conclui o WI; precedente WI-140): 8 events (3
		consumidos: INV real + REW/BKR fixtures; 2 internos; 1 publicado
		no fluxo + 2 de catálogo exigidos por sc-cm-06), 4 commands, 5
		invariantes (subconjunto declarado das 11), 4 VOs, agg-payment
		com lifecycle guarded→authorized→dispatched→settled. Âncoras
		para o cenário terminal do WI-138.
		"""
}
