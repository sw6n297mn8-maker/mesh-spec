package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

agentSpecPgAdr175Coevolution: build_time.#SelfReviewReport & {
	reportId: "srr-agent-spec-pg-adr-175-coevolution"

	artifactPath:       "architecture/production-guides/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — coevolução do PG agent-spec com o adr-175 (F2 do review
			isolado, decisão (a) do founder): o guide que ensina a autorar
			#AgentSpec ensinava a doutrina PRÉ-adr-175 — exatamente o vetor
			pelo qual a próxima autoria recriaria o drift que o gate mata.
			Elo duplo aplicado (mesmo padrão do PG domain-model): (a) critério
			tq-agg-11 em _qualityCriteria (o guide contém a disciplina de
			cobertura 6-famílias + exclusão legítima; rationale do bloco
			10→11); (b) operativo nas sections e no finalValidation — process
			ganhou o passo 'Decidir cobertura vs exclusão para o catálogo
			operável' (duas formas, critério de legitimidade, dangling
			validado); heuristics corrigidas (svc- movido para os prefixos de
			operationalScope; mod-/pol- com doutrina explícita organizacional/
			runtime em vez de 'scope próprio' genérico; heuristic nova
			'cobertura ≠ exclusão ≠ omissão' com a preferência por classe
			quando ≥3 ids); finalValidation com o passo de cobertura (rodar o
			runner, zero itens do BC no sc-ag-02) e o passo de integridade
			referencial estendido a scopeExclusions (dangling é violação,
			sc-ag-01); doneCriteria da section 1 exige o catálogo particionado.

			[uq-04/P0]: o critério de legitimidade é APONTADO ao adr-175 em
			cada ocorrência, nunca copiado por extenso — zero duplicação.
			[uq-08]: cue vet EXIT=0. [uq-03]: refs a adr-175/sc-ag-01/sc-ag-02
			resolvem no working tree desta fatia. [uq-07]: zero placeholder.
			Escopo respeitado: SÓ o guide — o schema do agent-spec não foi
			reaberto (a 6ª família e o scopeExclusions já estavam
			materializados no batch).
			"""
	}]

	findings: {}

	summary: """
		PG agent-spec coevoluído com o adr-175 pelo padrão do elo duplo:
		tq-agg-11 (critério) + passo de cobertura-vs-exclusão no process +
		heuristics com a doutrina das 6 famílias e do scopeExclusions +
		finalValidation com o passo do sc-ag-02 e dangling via sc-ag-01.
		Fecha o F2 do review isolado: o guide agora ensina o mundo
		pós-adr-175. VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: coevolução de guide com desenho já decidido
		(adr-175 + decisão (a) do founder sobre o F2) e molde provado na
		mesma fatia (elo duplo do PG domain-model); este round confirmou
		consistência das 4 superfícies do guide (critérios, process,
		heuristics, finalValidation) e zero duplicação do critério de
		legitimidade.
		"""
}
