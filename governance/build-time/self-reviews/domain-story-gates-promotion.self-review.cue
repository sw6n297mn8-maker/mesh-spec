package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainStoryGatesPromotion: build_time.#SelfReviewReport & {
	reportId: "srr-domain-story-gates-promotion"

	artifactPath:       "architecture/structural-checks/domain-story.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-08"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review da EDIÇÃO de promoção (adr-171): os 8 sc-ds
			enforcement warn→reject + header comment atualizado. Segunda SRR
			deste artefato (a primeira, srr-domain-story-structural-checks,
			cobriu a criação em adr-170 e registrou o warn de vácuo-verde).

			[ESCOPO DA MUDANÇA]: exatamente 8 substituições de enforcement (uma
			por check, verificado por contagem: 8 'reject', 0 'warn' residual) +
			header refletindo adr-171. Nenhuma rule, errorMessage, rationale ou
			id tocado — a promoção muda enforcement, não mecanismo (P10 mantido).

			[CONDIÇÃO DE CATRACA — adr-097]: verificada NO ATO, não alegada:
			runner full com a 1ª instância real no disco = 31/0 e zero violações
			sc-ds ANTES da promoção; re-verificado APÓS a promoção (mesma
			contagem — reject com zero violações não altera o total). 7 dos 8
			gates exercitados com refs reais; sc-ds-06 vacuamente verde,
			DECLARADO no adr-171 (não escondido).

			[RESOLUÇÃO DO WARN RESIDUAL ANTERIOR]: o warn uq-05 da SRR de criação
			(vácuo-verde: 'nenhuma instância real para morder') está RESOLVIDO
			pela existência da instância — os gates agora mordem conteúdo real;
			este é precisamente o evento que aquela SRR previa como resolução.

			[uq-08]: OK — cue vet EXIT=0; shape inalterada. [uq-03]: OK — adr-171
			existe no mesmo working tree e referencia este path em
			affectedArtifacts (ADR no mesmo commit per CLAUDE.md, mudança
			semântica de enforcement). [uq-01/06/07]: OK — header novo registra
			porquê (condição verificada), terminologia consistente, zero
			placeholder. [uq-04]: OK — promoção alinhada a adr-097 (catraca) e
			adr-170 (decisão deferida executada). [uq-09]: edição de enforcement
			dentro do arco de checkpoint único (batch, pattern def-074).
			"""
	}]

	findings: {}

	summary: """
		Promoção warn→reject dos 8 sc-ds (adr-171), junto da 1ª story real.
		VEREDITO: stable, 0 fail. Condição de catraca verificada
		deterministicamente antes E depois da edição (31/0, zero violações
		sc-ds); mudança cirúrgica de enforcement (8 linhas + header); o warn de
		vácuo-verde da SRR de criação fica resolvido pela instância.
		"""

	singleRoundRationale: """
		Round único proporcional: edição mecânica de enforcement (8 tokens) cuja
		justificativa semântica vive no adr-171 (classe isolated, review por
		sub-agente separado no mesmo arco) e cuja condição de segurança é
		verificada por gate determinístico re-executável (runner), não por
		julgamento.
		"""
}
