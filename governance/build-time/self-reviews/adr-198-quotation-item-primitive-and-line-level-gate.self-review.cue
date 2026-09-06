package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr198QuotationItemPrimitiveAndLineLevelGate: build_time.#SelfReviewReport & {
	reportId: "srr-adr-198-quotation-item-primitive-and-line-level-gate"

	artifactPath:       "architecture/adrs/adr-198-quotation-item-primitive-and-line-level-gate.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-06"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 0
		summary: """
			Dois fails corrigidos na autoria: (a) a leitura do disparo da
			falsificação (a) do adr-177 — a condição materializou por direção
			não antecipada (split por linha no one-shot, não o domínio
			preferred/strategic que ela vigiava); registrada com essa
			honestidade no context, sem retrofit (falsificação que só acerta
			reescrita não prova nada). (b) A primeira forma do gate mantinha
			quantity singular ao lado das lines — redundância incoerente;
			migrado integralmente para as linhas com Σ lineAmount == amount
			como total (tq-adr-02: a decisão real é por linha).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Ajuste do founder na aprovação incorporado: N2
			reescrito apontando def-093 nominalmente (defersTo) com o motivo
			de urgência (unidades divergentes quebram a comparação por linha
			EM SILÊNCIO), substituindo 'candidata a def na aprovação'.
			Warn declarado: nomes de vo-item-award e dos outcomes
			(awarded/no-quotation/withheld) são INDICATIVOS — glossário do
			ssc decide na fatia (precedente adr-196), ratificado nominalmente.
			Enum decisionClass conferido (structural; precedentes
			adr-174/175/177/180); supersedes verificado como NÃO-cabível
			(adr-177 segue majoritariamente vigente — união discriminada
			exigiria supersessão total); defersTo aponta apenas o def que
			esta decisão cria. def-087/def-088 flipados open→resolved neste
			mesmo commit (padrão def-079/adr-177), cobertos pelos próprios
			SRRs.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message:     "O alcance da coevolução dos espelhos P14 (contexts/*/schemas/events.cue) e das superfícies api.yaml foi descoberto NA EXECUÇÃO — não constava do diff aprovado arquivo a arquivo; escalado ao founder antes do commit com opções e recomendação."
			rationale:   "Transparência do gap entre o diff descrito e o alcance real medido no ato — a decisão de incluir os espelhos na fatia é do founder, não inferência do agente."
		}]
	}

	summary: """
		adr-198 accepted por aprovação nominal do founder sobre o texto
		redigido (com o ajuste do N2 → def-093 incorporado): item como
		primitiva (VO com identidade local, alt-2 rejeitada), proposta
		parcial legítima, adjudicação por item com linha vazia nomeada
		(no-quotation/withheld), elo no nível do item carregado pelo p2p
		(alt-3/(i-b) não reabertas), 2º braço reexpresso por linha com
		total como soma (alt-4/alt-5 rejeitadas), sob a primeira
		falsificação disparada do repo (adr-177 (a), por direção não
		antecipada). Evidência de prática: Mesa de Adjudicação (protótipo,
		não norma). Resolve def-087/def-088; cria def-093.
		"""
}
