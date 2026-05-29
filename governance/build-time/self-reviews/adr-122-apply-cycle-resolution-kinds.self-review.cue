package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr122: build_time.#SelfReviewReport & {
	reportId: "srr-adr-122"

	artifactPath:       "architecture/adrs/adr-122-apply-cycle-resolution-kinds.cue"
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
			ADR documenta PR-3 aplicação substantiva: 6 arestas
			ganham kind typed + 3 edgeFilters notEquals no sc-cm-07.
			Escopo expandido após descoberta empírica via Ajuste 1
			da Fase 3 (warn-first → validate → promote).

			Escopo original (4 arestas): cmt-to-drc + drc-to-cmt
			(bidirectional-orchestration via def-026); rew-to-cmt +
			rew-to-ins (policy-reaction via def-027 + scan
			complementar).

			Escopo expandido (2 arestas adicionais): rew-to-fce +
			fce-to-rew (policy-execution-feedback via adr-124, novo
			enum value motivado por descoberta empírica do sub-ciclo
			fce↔rew quando W3 desfez).

			Ajuste 1 funcionou como projetado: ciclo emergente
			capturado ANTES da promoção warn→reject. Sem Ajuste 1,
			adr-123 promoção causaria 1 FAIL imediato em CI,
			requerendo PR de reversão. Pattern repetível registrado
			em adr-124 + este ADR + adr-123 prose.

			Scan complementar policy-reaction (Tarefa 5 do plano)
			executado durante Fase 1 do PR-3: 5 candidatos avaliados.
			Aplicação ontologicamente correta a rew-to-cmt (canônico)
			+ rew-to-ins (borderline genuíno; INS com agência clara).
			REJEITADOS: rew-to-scf (published-language formal),
			rew-to-fce (não é policy-reaction; é policy-execution-
			feedback per adr-124), drc-to-fce (command propagation).

			Scan das 3 query-surfaces não-W4 (Tarefa 4 do plano)
			confirmou: idc-to-log/idc-to-dlv/npm-to-ctr são genuínas
			query-surfaces (IDC SoT crypto; NPM SoT qualification).
			P3 do adr-120 (generalização proativa) confirmado pós-
			facto.

			Resultado factual pós-aplicação completa: 0 ciclos em
			sc-cm-07 (W1/W2/W3 + sub-ciclo fce↔rew resolvidos; W4
			já resolvido em PR-2). Precondição satisfeita para
			promoção warn→reject em adr-123 (mesmo PR-3).

			4 alternativas explicitamente rejeitadas: (a) entregar
			PR-3 parcial sem fce↔rew (arco fica meio-aberto); (b) só
			rew-to-cmt sem rew-to-ins (hidden coupling risk); (c)
			extensão maximalista policy-reaction a todas arestas REW
			(semantic drift); (d) promover no mesmo ADR (viola 1 ADR
			= 1 decisão).

			Decisão de NÃO usar defersTo: mesma análise. def-026/027
			criados em PR #83 anterior; este ADR resolve
			substantivamente; resolvedBy populated no próprio
			def-XXX. fce↔rew não tem def-XXX pré-existente
			(descoberta empírica).

			Precondições adr-121 (notEquals) + adr-124 (policy-
			execution-feedback) materializadas no mesmo PR-3. Sem
			ambos, sc-cm-07 não compila ou ainda reportaria ciclo.

			principlesApplied: P0, P1, P12. decisionClass=structural,
			reversibility=high, blastRadius=cross-artifact. cue vet
			./... EXIT=0. sc-cm-07 reporta 0 ciclos (validado pre-
			merge com enforcement ainda warn).

			Risco categórico em N3 (mitigado): futuras arestas com
			kind typed serão excluídas automaticamente; mitigação via
			ADR-gate em adições de enum value + safety net retroativo
			via adr-123 (reject).

			Pattern paralelo a adr-049/056/063/076/080 (instanciação
			de schema extensions).
			"""
	}]

	findings: {}

	summary: """
		ADR-122 aplica Família A em 6 arestas (cmt-to-drc/drc-to-cmt →
		bidirectional-orchestration; rew-to-cmt/rew-to-ins →
		policy-reaction; rew-to-fce/fce-to-rew → policy-execution-
		feedback) + 3 edgeFilters notEquals no sc-cm-07. Resolve
		def-026/027 substantivamente. Precondições: adr-121
		(notEquals capability) + adr-124 (policy-execution-feedback
		enum value via descoberta Ajuste 1). Scan complementar de 5
		candidatos policy-reaction + scan confirmação 3 query-
		surfaces não-W4 incluídos. defersTo não usado.
		"""

	singleRoundRationale: """
		Aplicação direta de schema extensions já validadas em PR #84
		(adr-118/119) + capability já validada em adr-121 (mesmo PR)
		+ novo enum value adr-124 (mesmo PR, descoberta Ajuste 1).
		Scan complementar rigoroso (5 candidatos avaliados) executado
		em Fase 1 do PR-3 com direção founder explícita (Q2=ii).
		Descoberta Ajuste 1 capturada e endereçada via adr-124 +
		expansão de escopo deste ADR. Validações locais PASS.
		Round único suficiente.
		"""
}
