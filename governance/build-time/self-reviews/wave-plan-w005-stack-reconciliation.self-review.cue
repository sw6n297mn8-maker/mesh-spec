package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

waveplanW005StackReconciliation: build_time.#SelfReviewReport & {
	reportId: "srr-wave-plan-w005-stack-reconciliation"

	artifactPath:       "governance/wave-plan.cue"
	artifactSchemaPath: "architecture/artifact-schemas/wave-plan.cue"
	artifactType:       "wave-plan"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Cobre as 6 edições da reconciliação de stack do W005 per adr-139 (NÃO o wave-plan inteiro):
			(1) W005 intro reescrita keystone-first + filtro spec×runtime; (2) WI-102 → adr-140 +
			def-040; (3) WI-103 → adr-141 + def-041..045; (4) remoção de WI-104..108 (ids adr-099..105
			abandonados); (5) WI-109 estreitado (coherence in-scope, dependsOn [WI-102, WI-103]); (6)
			WI-087 só rationale (topologia lógica → adr-141, física → def-038).

			Mudança de planejamento (nenhum schema/instância criado por estas edições — só re-escopo de
			WIs). Conformidade ao #WavePlan:
			- tq-wp-01 (dependsOn = blocker; conhecimento → semanticPrerequisites): PASS. adr-139 entrou
			  em semanticPrerequisites de WI-102/WI-103 (dep de conhecimento, não serializa), NÃO em
			  dependsOn. WI-109 dependsOn [WI-102, WI-103] — ambos estruturais (coherence check precisa
			  dos 2 ADRs existirem).
			- tq-wp-02 (paths conformes): PASS. outputs em architecture/adrs/, architecture/
			  deferred-decisions/, architecture/structural-checks/ — zonas válidas.
			- Invariantes do schema: _allTaskIDs ainda único (WI-104..108 removidos de W005 + dos nós
			  p9 do work-graph); _depsCheck OK — nenhuma dependsOn órfã (WI-109 não referencia mais
			  WI-104..108; nada externo os referenciava exceto a prose de WI-089, intocada). cue vet
			  EXIT=0.

			Coerência cross-file: work-graph.cue co-atualizado por coerência determinística (nós
			WI-104..108 removidos; WI-109.dependsOn estreitado; rationales p9/g11 + comentário). Sem isso
			_depsCheck/cue vet quebraria — por isso o work-graph entrou no mesmo pacote. Intacto: WI-089
			linha 1799 byte-intacta (prose stale deferida a W004 per adr-139 N1); adr-097/WI-085 não tocado.
			"""
	}]

	findings: {}

	summary: """
		As 6 edições de reconciliação do W005 (per adr-139): keystone-first (WI-102→adr-140,
		WI-103→adr-141), abandono dos ids colididos adr-099..105, remoção de WI-104..108, WI-109
		estreitado, WI-087 só-rationale. Conforma #WavePlan (tq-wp-01/02; _allTaskIDs único; _depsCheck
		sem órfã); work-graph co-atualizado por coerência determinística; cue vet EXIT=0. Mudança de
		planejamento (nenhum schema/instância criado). Estável em 1 round, 0 findings.
		"""

	singleRoundRationale: """
		Re-escopo de planejamento de escopo contido (6 edições em WIs do W005 + co-update determinístico
		do work-graph), cuja conformidade ao #WavePlan e ausência de dependsOn órfã foram verificadas por
		cue vet EXIT=0 + grep de referências. As decisões semânticas (keystone-first, abandono de ids,
		remoção de WIs) foram travadas pelo founder antes da escrita. Rounds adicionais não revelariam
		novos findings.
		"""
}
