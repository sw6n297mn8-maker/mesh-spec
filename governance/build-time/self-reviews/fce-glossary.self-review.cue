package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fceGlossarySelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-fce-glossary"

	artifactPath:       "contexts/fce/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-06-12"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 1
		infoCount: 0
		summary: """
			Round de proposta (chat, modo batch aprovado): fail — as 5
			categorias narrativas planejadas (estilo DLV) eram organização
			de comentário, não o enum #TermCategory real
			(entity|value|process|role|rule|event|command|metric|document|
			classification); remapeadas (rule/process/value). Warn —
			rejectedAlternatives presentes apenas onde houve seleção real
			(2 termos), demais omitidos deliberadamente.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Pós-escrita: cue vet OK; categorias validadas contra o enum;
			7 termos com definition/rationale/antiTerms derivados do
			canvas (zero semântica nova); domainModelRefs apontam para a
			fatia do domain-model do mesmo pacote; boundary com
			REW/INV/DLV/BKR/SCF/ATO preservada via antiTerms.
			"""
	}]

	findings: {}

	summary: """
		Glossary FCE — fatia do caminho do guard (claim parcial WI-043,
		NÃO conclui o WI; precedente WI-140). 7 termos derivados do
		canvas. NOTA DE RENASCIMENTO: glossary v1 foi deletado no reset
		corretivo (PR #43, SRR fce-glossary-deletion); esta é instância
		NOVA derivada do canvas pós-reset (#88) — não restauração do
		conteúdo deletado. sc-srr-03 (warn) sinaliza o par
		deleção-SRR/arquivo-renascido; tratamento do record antigo é
		decisão do founder registrada no checkpoint do pacote.
		"""
}
