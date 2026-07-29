package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

stakeholderMapScWi157: build_time.#SelfReviewReport & {
	reportId: "srr-stakeholder-map-sc-wi-157"

	artifactPath:       "architecture/structural-checks/stakeholder-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-29"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	singleRoundRationale: """
		Round único (precedente srr-frontend-codegen-contract-sc, WI-160):
		os checks foram aprovados pelo founder na direção D3 do WI-157
		("checks reais + lacunas nomeadas, num movimento só") e as
		resoluções de shape foram verificadas mecanicamente — kinds
		conformes por união discriminada (cue vet), evaluators existentes
		no runner para os 3 kinds usados, e exercício provado por script
		na fatia (13 costRefs/0 dangling; exatamente sh-07/08/09 sem
		cobertura de canvas; 9 categorias no enum de 7). A dimensão
		restante é o founder review final da fatia.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — os 3 checks do tipo stakeholder-map (exit do def-076,
			camada 2 do silêncio fechando): sc-sm-01 (tq-sm-02, costRef →
			value.costsEliminated[].id, cross-file-id-exists, REJECT —
			exercitado: 13 refs, 0 dangling), sc-sm-02 (tq-sm-03, cobertura
			por canvas, cross-file-id-exists, WARN per severity do próprio
			critério — 3 warns esperados e legítimos: sh-07/08/09 até a
			operacionalização das personas no WI-158+), sc-sm-03 (resíduo
			avaliável do tq-sm-04, enum de 7 categorias pós-adr-181,
			regex-pattern-match, REJECT — sonda adversarial rejeitou valor
			fora do enum). LACUNAS NOMEADAS no header (padrão rule-latente
			do sc-pg-01/sc-fcc): tq-sm-01/06/07 (unicidade — nenhum kind do
			runner; verificadas por script NESTA fatia, incluindo a
			unicidade dos mv-* por stakeholder), tq-sm-04 condicional
			(predicado por item — sem kind; 1ª camada é review + definição
			da classe no schema), tq-sm-05 (interpretativo — deliberadamente
			NÃO vira check, P10). tq-sc-01..03 conferidos (errorMessages
			específicas; rules conformes aos kinds; rationales ancorados em
			def-076/adr-181/tq-sm-*). A entry stale do meta-coverage
			(exemptTypes stakeholder-map — alegava proteção fictícia citando
			a shape v0) foi REMOVIDA no mesmo commit: o tipo agora tem
			checks reais (sc-meta-02 cobre via artifactType).
			"""
	}]

	findings: {}

	summary: """
		Gates do tipo stakeholder-map nascendo com a re-autoria da
		instância (exit completo do def-076 num movimento só, direção D3
		do founder): 2 reject exercitados com a catraca verificada no ato
		+ 1 warn deliberado com os 3 avisos esperados declarados; lacunas
		de runner nomeadas com a evidência de script da fatia. Baseline do
		runner: 29 → 32 warns / 0 bloqueantes (declarado no checkpoint).
		"""
}
