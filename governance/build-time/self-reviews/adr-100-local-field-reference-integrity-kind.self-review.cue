package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr100LocalFieldReferenceIntegrityKind: build_time.#SelfReviewReport & {
	reportId: "srr-adr-100-local-field-reference-integrity-kind"

	artifactPath:       "architecture/adrs/adr-100-local-field-reference-integrity-kind.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-100 (kind local-field-reference-integrity + 4 checks
			intra-arquivo do context-map). Design + ajuste de nomenclatura ("local-"
			em vez de "field-") aprovados pelo founder antes da escrita. Confirmacoes:

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"; decisionClass
			"structural" (novo kind + rule shape + evaluator + 4 instancias);
			reversibility "medium" + blastRadius "repo-wide"; defersTo ["def-002"]
			(integridade cross-file fica explicitamente para o cross-file-id-exists).
			tq-adr-01: alternativa rejeitada com motivo (sobrecarregar _idset com
			extracao de campo configuravel mistura conceitos; kind dedicado segue o
			padrao adr-049/063/064/080/090). affectedArtifacts = 3 paths reais.

			(b) Premissa validada empiricamente ANTES (a "tentativa de autorar"):
			reference-exists/_idset/filesystem-path-exists nao expressam os refs
			aninhados; protótipo sobre os dados reais confirmou 0 drift em
			endpoints/reverseRelationshipId/ownerContext => checks nascem verdes.

			(c) Escopo negativo honesto: cobre so INTRA-arquivo; a integridade
			context↔disco (25 contexts declarados vs 11 BCs) permanece descoberta ate
			def-002 — declarado para nao dar falsa sensacao de cobertura total.

			(d) Verificacao: cue vet ./... EXIT 0; runner --self-test PASS; runner
			default → sc-cm-01..04 verdes, sc-meta-01 verde (M1 segue verde: kind +
			evaluator no mesmo commit), context-map fora da lista do M2 (51→50), 0
			bloqueantes, exit 0.
			"""
	}]

	findings: {}

	summary: """
		adr-100 conforma a #ADR e registra a decisao (aprovada pelo founder, com o
		ajuste de nome para local-field-reference-integrity) de adicionar o kind de
		integridade referencial INTRA-arquivo + 4 checks born-warn do context-map (o
		tipo do drift original). Sem findings fail/warn. defersTo def-002 para a
		dimensao cross-file. Verificacao: checks verdes, M1 verde, context-map sai do
		M2, 0 bloqueantes.
		"""

	singleRoundRationale: """
		Uma rodada basta: o design e o ajuste de nome foram aprovados pelo founder
		antes da escrita; a viabilidade foi validada por protótipo sobre dados reais
		(0 drift) e por cue vet + self-test + execucao do runner. Sem espaco de decisao
		aberto a red-team adicional.
		"""
}
