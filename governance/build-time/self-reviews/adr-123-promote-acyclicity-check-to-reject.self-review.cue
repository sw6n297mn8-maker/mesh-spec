package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr123: build_time.#SelfReviewReport & {
	reportId: "srr-adr-123"

	artifactPath:       "architecture/adrs/adr-123-promote-acyclicity-check-to-reject.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR documenta PR-3 promoção terminal: sc-cm-07 enforcement
			warn → reject. Catraca adr-097 cumprida (4 ciclos no
			original + 1 sub-ciclo emergente → 0 ciclos após plano
			cycle-resolution completo PR-1+PR-2+PR-3). Resolve def-028
			(W4 resolvido por adr-120 PR-2; este ADR finaliza o arco
			completo per compromisso registrado em adr-120 prose).

			decisionClass: foundational (não structural — é decisão de
			gate, não de schema). principlesApplied: P0, P12.
			reversibility=high (ADR explícito reverteria);
			blastRadius=local (toca 1 structural-check + 1 def).

			Precondições factuais (todas no mesmo PR-3):
			- adr-121 (capability notEquals) materializada
			- adr-124 (policy-execution-feedback enum value) materializado
			- adr-122 (aplicação Família A em 6 arestas + 3
			  edgeFilters notEquals) materializada — garante 0
			  ciclos pre-promoção
			Sem qualquer um destes, promoção causaria FAIL em CI
			imediatamente.

			4 alternativas explicitamente rejeitadas: (a) manter warn
			(drift de política; warn perpétuo é tag inútil); (b)
			promover em PR-4 separado (Ajuste 1 já forneceu evidência
			empírica intermediária no mesmo PR); (c) promover a "info"
			(perde gate); (d) promover runner mode global (scope
			creep).

			Decisão de NÃO usar defersTo: mesma análise. def-028
			criado em PR #83 anterior; resolvedBy populated no
			próprio def-028 apontando para este ADR.

			Sequência merge no PR-3 atomicidade: adr-121 (cap) +
			adr-124 (cap) → adr-122 (apply) → adr-123 (promote).
			Coexistência garantida pelo squash merge.

			Pattern instância adr-097 (born-warn → reject lifecycle):
			conformidade explícita; cycle-resolution completo em 29
			dias após introdução do sc-cm-07. Pattern repetível para
			outros born-warn checks futuros. Adicionalmente registra
			eficácia empírica do Ajuste 1 (warn-first → validate →
			promote) como complement operacional da catraca.

			Risco categórico em N2 (hipotético): futuro ciclo
			legítimo exigiria ADR de novo kind + edgeFilter notEquals
			novo. Custo aceitável per pattern adr-118/119/120/121/124.

			cue vet ./... EXIT=0. sc-cm-07 reporta 0 ciclos com
			enforcement reject ativo. Self-test cobertura já
			garantida em adr-121.
			"""
	}]

	findings: {}

	summary: """
		ADR-123 promove sc-cm-07 enforcement de warn para reject.
		Catraca adr-097 cumprida (0 ciclos pós-PR-3). Resolve def-028
		como passo terminal do arco cycle-resolution. decisionClass=
		governance. Precondições: adr-121 (notEquals capability) +
		adr-124 (policy-execution-feedback enum value) + adr-122
		(aplicação completa garante 0 ciclos). defersTo não usado.
		Ajuste 1 validado empiricamente.
		"""

	singleRoundRationale: """
		Decisão simples e governance-class: 1 field mudança
		(enforcement: "warn" → "reject"). Catraca adr-097 é política
		canônica pré-existente; este ADR é instanciação. Validações
		locais PASS confirmam precondição factual (0 ciclos com
		enforcement ainda warn antes da promoção, validado via
		Ajuste 1). Round único suficiente.
		"""
}
