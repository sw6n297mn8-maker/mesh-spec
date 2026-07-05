package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainStoryProductionGuide: build_time.#SelfReviewReport & {
	reportId: "srr-domain-story-production-guide"

	artifactPath:       "architecture/production-guides/domain-story.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-05"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — review por sub-agente ISOLADO, SEPARADO do authoring subagent (per adr-054
			decision item 10: isolation authoring vs review reduz viés de auto-ratificação; o PG
			foi autorado via dispatch disp-009, rollout production-guide = subagent-drafted). ZERO
			findings. Verificações: uq-03 — refs existem (adr-169/170, adr-054 dec 13, adr-056/057,
			def-075, sc-ds-01..08; pattern tq-gg/tq-teg verificado nos PGs de glossary e
			tension-entry); uq-08 — conforma #ProductionGuide (prerequisites completo, workOrder,
			sections com todos os campos, finalValidation; location singleton per precedente dos
			outros PGs; cue vet limpo). tq-pg-01/tq-mg-01 (workOrder = permutação exata das 3
			sections) OK; tq-pg-02 (targets #DomainStory/#StoryStep existem) OK; tq-pg-03
			(doneCriteria verificáveis) OK; tq-pg-04/tq-mg-04 (gapPolicy com 6+ cláusulas
			proibitivas anti-invenção) OK; tq-pg-05/tq-mg-03 (último step = submissão ao founder
			como gate próprio bloqueante, adr-057) OK; tq-pg-06/tq-mg-02 (actions com verbo
			imperativo concreto) OK. tq-mg-05..09 N/A com disciplina presente onde tangencia
			(heurística 'dois enforcers, papéis distintos'); tq-mg-10 (canonical removal test)
			presente como heurística E step de finalValidation com a resposta correta (story é
			observador/teste de cobertura, não enforcer). Auto-consistência tq-dsg-01..04: o guide
			cumpre os próprios critérios (verificação por leitura direta; relatório de lacunas
			como entregável; fonte real anti-retrofit; refs limpas + cópia consumida não é dono).
			uq-09 N/A (tipo em rollout subagent-drafted; manualAuthoringProtocol não aplica).
			"""
	}]

	findings: {}

	summary: """
		PG domain-story (disp-009, subagent-drafted): review ISOLADO separado do authoring per
		adr-054 item 10 — ZERO findings. 3 sections espelhando o fluxo real de autoria
		(narrativa→resolução→lacunas+submissão); 4 tq-dsg (3 fail + 1 warn) codificando as duas
		metades do princípio do adr-170 (refs verificadas; lacuna honesta), a direção anti-retrofit
		('ordem da dor') e o escopo por-item do adr-169. VEREDITO: stable.
		"""

	singleRoundRationale: """
		Round único isolado suficiente: o pipeline adr-054 já forneceu duas camadas anteriores —
		o authoring subagent validou o draft com cue vet REAL em scratch (VET-OK primeira tentativa)
		e retornou reasoning report com 8 itens de calibração (apresentados ao founder no
		checkpoint); este review isolado é a camada de review SEPARADA exigida pelo item 10 e não
		encontrou findings. Founder review no checkpoint permanece o gate final (P10 + adr-054).
		"""
}
