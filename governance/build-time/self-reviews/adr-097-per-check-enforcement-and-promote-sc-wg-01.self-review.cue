package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr097PerCheckEnforcementAndPromoteScWg01: build_time.#SelfReviewReport & {
	reportId: "srr-adr-097-per-check-enforcement-and-promote-sc-wg-01"

	artifactPath:       "architecture/adrs/adr-097-per-check-enforcement-and-promote-sc-wg-01.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-25"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-097 (enforcement por-check + promoção de sc-wg-01),
			cujo delta foi aprovado pelo founder antes da escrita. Confirmações:

			(a) Conformância #ADR: id ^adr-[0-9]{3}$; status "accepted"
			(não-superseded, supersededBy ausente); decisionClass "structural"
			coerente (altera schema #StructuralCheck + contrato de exit do runner
			+ gate de CI); reversibility "medium" + blastRadius "repo-wide"
			consistentes com a decisão. tq-adr-01 (alternativa allowlist-no-CI
			rejeitada com motivo); tq-adr-02 (metadata reflete a mudança);
			tq-adr-03/04 (affectedArtifacts = 4 paths reais e alterados, ≥1
			bloco de rastreabilidade).

			(b) Verificação empírica antes da proposta (mecânica, per
			manualAuthoringProtocol): cue vet ./... EXIT 0; runner --self-test
			PASS; runner em modo default → 21 findings, 0 bloqueantes, exit 0
			(sc-wg-01 verde; os 21 são sc-cv-02/03 em warn). Confirma que a
			promoção não quebra o CI.

			(c) Coerência da semântica de três vias do --mode (default respeita
			check.enforcement; warn força report-only; reject força blocking) com
			o que foi implementado no runner (effective_enforcement + blocking_total)
			e com o consumo default no validate.yml (exit via PIPESTATUS para não
			mascarar o gate). Escopo negativo respeitado: sc-cv-02/03 intocados.
			"""
	}]

	findings: {}

	summary: """
		adr-097 conforma a #ADR e registra a decisão (aprovada pelo founder) de
		adicionar enforcement por-check ao #StructuralCheck e promover sc-wg-01 a
		reject. Sem findings fail/warn. Verificação empírica confirma default = 0
		bloqueantes (CI não quebra) e os três modos de override funcionando.
		Enforcement vive no check (P0), não em allowlist de CI.
		"""

	singleRoundRationale: """
		Uma rodada basta: o delta (campo enforcement + runner blocking_total +
		--mode três-vias + CI default + sc-wg-01=reject) foi proposto e aprovado
		pelo founder explicitamente antes da escrita, e a verificação empírica
		(cue vet, self-test, default→0 bloqueantes) é determinística e passou.
		Sem espaço de decisão aberto a red-team adicional.
		"""
}
