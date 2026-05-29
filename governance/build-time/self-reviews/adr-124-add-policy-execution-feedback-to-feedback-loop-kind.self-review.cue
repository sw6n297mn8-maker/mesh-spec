package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr124: build_time.#SelfReviewReport & {
	reportId: "srr-adr-124"

	artifactPath:       "architecture/adrs/adr-124-add-policy-execution-feedback-to-feedback-loop-kind.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR documenta extensão do enum #FeedbackLoopKind com 2º
			valor "policy-execution-feedback", após descoberta
			empírica de ciclo fce↔rew via Ajuste 1 da Fase 3 do PR-3.

			Pattern paralelo a adr-118 (extensão orgânica de enum com
			1 valor adicional quando caso concreto emerge). Pattern
			adr-049/056/063 de minimalismo: 1 valor por ADR; expansão
			via ADRs follow-on.

			Descoberta empírica via Ajuste 1: warn-first → validate →
			promote. Após aplicação adr-122 das 4 arestas originais
			com enforcement ainda warn, sc-cm-07 reportou 1 ciclo NÃO
			PREVISTO: fce → rew → fce (2 arestas com feedbackLoop
			declarado). Causa: sub-ciclo agregado dentro do SCC grande
			de W3 antes da quebra; emergiu como detectado
			independentemente.

			Análise semântica registrada no ADR:
			- bidirectional-orchestration (adr-118) NÃO aplica:
			  fce↔rew não é orquestração sequencial; é assimetria
			  policy-side (decisão) ↔ execution-side (state stream).
			- policy-reaction (adr-119) NÃO aplica: rejeitado em scan
			  complementar — FCE sem agência via invariante;
			  PaymentSettled é state event.
			fce↔rew exige nomeação própria → "policy-execution-feedback".

			4 alternativas explicitamente rejeitadas: (a) forçar
			bidirectional-orchestration (drift semântico); (b) aceitar
			warn perpétuo (catraca adr-097 não cumprida); (c) refactor
			removendo aresta (viola def-019 + adr-104); (d) naming
			"continuous-learning-feedback" (nome de mecanismo ML, não
			estrutura DDD).

			Naming "policy-execution-feedback" escolhido por:
			- Captura estrutura canônica policy-side ↔ execution-side.
			- Complementar a policy-reaction (adr-119): policy-reaction
			  é signal unidirecional + agency; policy-execution-feedback
			  é loop bidirecional com feedback execution→policy.
			- Alinha com vocabulário DDD (estrutura, não mecanismo).

			Aplicação concreta NÃO é parte deste ADR — é parte de
			adr-122 (mesmo PR-3). Este ADR é apenas extensão do enum
			(infraestrutura). Estritamente paralelo a adr-118 (que
			também é só enum value, sem aplicação concreta —
			aplicação veio em adr-122).

			Validação empírica do Ajuste 1 documentada como
			consequência positiva (P3): pattern warn-first → validate
			→ promote capturou ciclo emergente ANTES da promoção,
			evitando PR de reversão. Pattern repetível.

			Decisão de NÃO usar defersTo: nenhum def-XXX foi criado
			para fce↔rew — descoberta empírica durante PR-3, não
			decisão deferida. Sem registro pré-existente para apontar.

			principlesApplied: P0, P1, P12. decisionClass=structural,
			reversibility=high, blastRadius=cross-artifact. cue vet
			./... EXIT=0. Aplicação em adr-122 resulta em 0 ciclos
			(validado pre-promoção).

			Pattern paralelo a adr-049/056/063/076/080/117/118/119/
			120/121 — décima extensão orgânica de framework + segunda
			extensão do enum #FeedbackLoopKind.
			"""
	}]

	findings: {}

	summary: """
		ADR-124 adiciona "policy-execution-feedback" como 2º valor do
		enum #FeedbackLoopKind. Motivação: descoberta empírica de
		ciclo fce↔rew via Ajuste 1 da Fase 3 do PR-3. Pattern
		paralelo a adr-118 (1 valor por ADR; extensão orgânica).
		Categoria semântica distinta de bidirectional-orchestration
		(orquestração sequencial) e de policy-reaction
		(signal+agency unidirecional). Aplicação em adr-122 (mesmo
		PR-3). defersTo não usado (descoberta empírica, sem def-XXX
		pré-existente).
		"""

	singleRoundRationale: """
		Pattern bem-estabelecido (décima extensão orgânica de
		framework de check; precedentes adr-049/056/063/076/080/117/
		118/119/120/121). Decisão passou por descoberta empírica
		Ajuste 1 + análise semântica rigorosa de 4 alternativas +
		naming decision per founder direction (Q2=policy-execution-
		feedback). Sem aplicação concreta neste ADR (capability
		extension apenas); aplicação validada em adr-122. Round
		único suficiente.
		"""
}
