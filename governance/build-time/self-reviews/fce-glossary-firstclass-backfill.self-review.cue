package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fceGlossaryFirstClassBackfill: build_time.#SelfReviewReport & {
	reportId: "srr-fce-glossary-firstclass-backfill"

	artifactPath:       "contexts/fce/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-17"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- self-review self-reported (rollout default p/ glossary) da edicao do
			glossario fce na onda 3 do backfill Forma A (adr-151 passo vi). SRR sob nome
			QUALIFICADO (fce-glossary-firstclass-backfill) -- o fce-glossary.self-review.cue de
			authoring ja existe; colisao evitada por construcao (licao do dlv). Edicao: +8 termos
			novos (1 entity: pagamento; 4 command: materializar/autorizar/liquidar-pagamento,
			despachar-instrucao-de-pagamento; 3 event: pagamento-autorizado/liquidado,
			instrucao-de-pagamento-despachada), 0 add-ref. Onda 3 e 100% owned (0 foreign; os 2
			sourceContext do domain-model -- evt-invoice-issued@inv, evt-settlement-finalized@bkr --
			sao ACL consumidos, fora dos 8). PASS: cada termo novo tem termEn == coreNoun do conceito
			(norm-exato) e domainModelRefs apontando o code (G1); reason 8x financial (fce
			monoliticamente financeiro -- cada conceito cruza contrato POR mover/decidir dinheiro;
			authorize-payment=financial, decisao economica, nao compliance regulatoria). Padrao
			coisa/ato/fato: as definitions distinguem EXPLICITAMENTE o ato (comando) e o fato
			(evento) do processo existente -- Authorization/Authorize Payment/Payment Authorized,
			Settlement/Settle Payment/Payment Settled; rationale reforca a distincao (uq-01).
			category entity/command/event coerente; relatedTerms resolvem (termos-processo
			existentes Authorization/Settlement/Financialization/PrePaymentGuard + irmaos ato<->fato).
			Verificado: nenhum termEn/code novo colide com os 7 existentes -> sem G3-correspondence,
			sem code-clash. Dois termos referenciam agg-payment (Payment novo + Financialization
			existente) -- G1 exige UM termo com termEn==coreNoun ("Payment" casa); o adicional nao
			dispara finding. cue vet EXIT=0 + evaluator first-class-traceability contra o disco:
			report VAZIO (os 8 owned do fce passam G1 com 8 termos novos). 0 fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Edicao do glossario fce na onda 3 do backfill Forma A (adr-151 passo vi): 8 termos novos
		(1 entity + 4 command + 3 event) dando cobertura dedicada (G1) aos 8 conceitos
		cross-contract owned do fce, todos reason financial. SRR sob nome qualificado (o de
		authoring existe). Self-review self-reported em 1 round: uq-01..09 + criterios de glossary
		contra o disco, 0 fail / 0 warn. Padrao coisa/ato/fato distinguido nas proprias
		definitions. Fidelidade provada pelo evaluator (report VAZIO pos-onda; worklist 17->9).
		cue vet EXIT=0. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: edicao aditiva de 8 termos declarativos conformando ao #Glossary (cue vet
		EXIT=0), cada termo com termEn==coreNoun + ref (G1) e rationale substantivo reforcando a
		distincao ato/fato/processo; comportamento do gate validado empiricamente (evaluator report
		vazio pos-onda). Nenhum finding tocou a substancia; round unico porque os termos sao
		declarativos e o gate foi validado a parte.
		"""
}
