package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr173SchemeQualifiedLegalIdentity: build_time.#SelfReviewReport & {
	reportId: "srr-adr-173-scheme-qualified-legal-identity"

	artifactPath:       "architecture/adrs/adr-173-scheme-qualified-legal-identity.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-12"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 — review por sub-agente ISOLADO. Confirmado no disco: VO novo
			com scheme+value; rootIdentity 'legalIdentifier'; invariante do npm
			generalizado; glossários (termo novo com antiTerms + termo central
			ajustado + 2 termos npm); agent atualizado como declarado; zero refs
			ESTRUTURAIS órfãs ao code antigo; PROVENIÊNCIA CONFIRMADA VERBATIM
			(Mesh-Old mesh-domain-model.md linha 60: 'nas jurisdições em que o
			grupo opera, incluindo identificação fiscal local'); def-077 conforma
			e defersTo resolve; baseline 31/0 com zero sc-ag-*; 5/5
			affectedArtifacts editados de fato.

			FINDINGS: [uq-03 fail] 2 refs órfãs ao NOME antigo do VO em
			rationales (catálogo do domainModel idc; rationale de glossary do
			agent). [uq-06 fail] residual da lei antiga: rationale do aggregate
			ainda dizia 'cada CNPJ tem exactly um Identidade'; chave da
			projeção/query de verificação descrita como CNPJ (não coberto pelo
			item 5 — é regra/chave, não exemplo). [uq-05 warn] residuais
			não-declarados: (a) campo cnpj do agg-participant npm como chave do
			invariante generalizado; (b) inv-registration-completeness com CNPJ
			literal; (c) signerCnpj vs signerIdentity; (d) def-077 ausente de
			plannedOutputs (precedente adr-162).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — TODAS as correções aplicadas e re-verificadas
			deterministicamente: [uq-03] catálogo e rationale do agent →
			LegalEntityIdentifier (grep CnpjIdentifier: 0 no repo fora de
			narrativa de ADR/SRR append-only). [uq-06] rationale do aggregate e
			descriptions da projeção/query generalizados para identificador
			qualificado (grep 'cada CNPJ': 0). [uq-05] em vez de só declarar,
			os residuais foram CORRIGIDOS: (a) campo do agg-participant npm
			renomeado cnpj → legalIdentifier com description esquema+valor;
			(b) inv-registration-completeness generalizado; (c) signerCnpj →
			signerIdentity; (d) def-077 adicionado a plannedOutputs. O ADR
			ganhou o item (3b) declarando a completude da generalização e o
			round de correção. cue vet EXIT=0; runner re-executado: 31/0 com
			diff VAZIO vs baseline (zero sc-ag-*; o par agent↔domain-model
			permaneceu consistente através do rename do campo de assinatura).
			"""
	}]

	findings: {}

	summary: """
		adr-173 (identidade legal qualificada por esquema): review ISOLADO
		encontrou 2 fails + 1 warn — todos residuais de materialização (refs de
		nome antigas em rationales; regra/chave antigas em aggregate e projeção;
		campo npm e completude cadastral não-generalizados; plannedOutputs) —
		TODOS corrigidos no round 2 com re-verificação determinística (greps
		zero; vet; runner 31/0 diff vazio). A decisão em si saiu ilesa do
		review: proveniência verbatim, refs cruzadas e baseline confirmados.
		VEREDITO: stable, 0 fail residual.
		"""
}
