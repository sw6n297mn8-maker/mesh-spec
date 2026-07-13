package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr176PromoteAgentCoverageCheckToReject: build_time.#SelfReviewReport & {
	reportId: "srr-adr-176-promote-agent-coverage-check-to-reject"

	artifactPath:       "architecture/adrs/adr-176-promote-agent-coverage-check-to-reject.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-13"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 1
		infoCount: 4
		summary: """
			Round 1 — review por SUB-AGENTE ISOLADO (rollout adr →
			isolated-subagent), sem o histórico da sessão de autoria, sobre o
			adr-176 + o flip materializado, verificação contra o disco. Núcleo
			PASS: flip exato (enforcement reject + frase de fecho com
			61→37→0); sc-ag-03 conforme (kind/globs/reject); kind
			directory-pair-coverage JÁ existente (enum + rule shape +
			evaluator + fixture — zero motor confirmado); 12/12 pares e
			drc/scf canvas-only confirmados; runner 31/0 bloqueantes com
			ambos em reject; self-test PASS; adr-175 intocado (precedente
			adr-123/adr-117 confirmado por grep no commit histórico);
			aritmética do arco 61→37→0 confirmada contra adr-175, commits
			das higienes e SRRs; alternativas genuínas; falsificação
			observável; metadata idêntica ao adr-123.

			2 FAILS: F1 — '52 coberturas reais' no rationale era
			aritmeticamente impossível (o certo é 27: 21 do WI-154 + 6 do
			WI-155; 27+34=61 fecha, 52+34=86 contradiz o próprio ADR) —
			NOTA: o erro foi detectado e corrigido pela PRÓPRIA AUTORIA
			minutos após o dispatch do reviewer (self-check da soma), e o
			reviewer o confirmou lendo a janela pré-correção; F2 — o
			rationale citava 'lens-governance-as-code', arquivo que NÃO
			existe (o conceito é aag-governance-as-code DENTRO de
			lens-ai-agent-governance; o adr-123 usa o nome fantasma,
			grandfathered lá — repeti-lo seria drift novo). 1 WARN: W1 —
			'nasce reject direto per precedente sc-ag-01/adr-114' era
			OVERCLAIM: sc-ag-01 nasceu warn-default (adr-113) e foi
			promovido em ADR separado (adr-114); não existe precedente de
			born-reject no repo — sc-ag-03 é o PRIMEIRO, e o ADR deveria
			declarar a novidade normativa, não vesti-la de aplicação. 4
			INFOS: structure-index pendente de regeneração no momento da
			leitura (regenerado em seguida); P12 no rationale mas fora de
			principlesApplied (adr-123 lista); a frase-modelo do sc-ag-01
			vive em comentário de cabeçalho, não no campo rationale
			(cosmético); a família de promoções não é uniforme (adr-114
			structural/repo-wide) — seguir adr-123 é defensável.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 2
		summary: """
			Round 2 — correções aplicadas: F1 RESOLVIDO — partição corrigida
			e refinada com a decomposição honesta ('27 coberturas reais + 34
			exclusões conscientes: 3 padrão-C por chave estrutural + 30
			por-classe com frase-marca + 1 por-id honesty; 27+34=61'),
			incorporando também a nuance do reviewer de que 'marca literal'
			não descrevia as 3 estruturais. F2 RESOLVIDO — lens corrigida
			para lens-ai-agent-governance (conceito aag-governance-as-code),
			com nota explícita de que o nome fantasma do adr-123 é
			imprecisão grandfathered NÃO repetida. W1 RESOLVIDO — o
			born-reject do sc-ag-03 reformulado nos 3 pontos (decision do
			ADR, principlesApplied, rationale do próprio check) como
			PRIMEIRA ocorrência no repo e EXTENSÃO consciente do precedente
			(sc-ag-01 nasceu warn-default e foi promovido em adr-114
			imediato; adr-097 defaulta warn sem proibir born-reject; a razão
			de ser do born-warn — anunciar baseline sujo — não existe com
			12/12 verificado), com 'o founder aprova sabendo da novidade'
			no texto da decisão. I1 RESOLVIDO — P12 adicionado a
			principlesApplied. I2 (cosmético, frase-modelo em comentário) e
			a nota de família não-uniforme permanecem como infos aceitos.
			cue vet EXIT=0 pós-correções; runner re-confirmado 31/0.
			"""
	}]

	findings: {}

	summary: """
		adr-176 (accepted) executa a catraca do gate agente↔modelo: sc-ag-02
		warn→reject com baseline zero verificado no ato (arco 61→37→0 em 3
		PRs no mesmo dia) + sc-ag-03 born-green reject fechando a janela do
		BC-sem-agente (12/12 pares; kind existente, zero motor). Review
		isolado: 2 fails corrigidos (aritmética da partição — pega pela
		própria autoria e confirmada pelo reviewer; lens fantasma herdada do
		adr-123 não repetida), 1 warn reformulado (born-reject declarado
		como primeira ocorrência/extensão de precedente, não aplicação), P12
		alinhado. Runner pós-tudo: 31/0 bloqueantes com os dois checks em
		reject. VEREDITO: stable, 0 fail residual, zero warn residual.
		"""
}
