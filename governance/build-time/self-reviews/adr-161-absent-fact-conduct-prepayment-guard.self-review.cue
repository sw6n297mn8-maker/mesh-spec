package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do adr-161 (conduta de fato ausente no PrePaymentGuard: ausência de
// invoice/eligibility fica guarded waiting-for-information, não escala). Revisa
// a ADR filha de adr-160 que refina a semântica do residual not-clean (itens
// 4/6) para o caso de ausência, mais a emenda casada no domain-model do FCE
// (rationales de sel-prepayment-clean/-not-clean + cláusula do evento) e o
// def-069 (deferimento do timeout de ausência prolongada). Self-review em
// subagente ISOLADO (quality-gate executionPolicy.rollout: adr→isolated-
// subagent; sem o histórico da conversa que produziu os artefatos). 1 round,
// stable.

adr161AbsentFactConduct: build_time.#SelfReviewReport & {
	reportId: "srr-adr-161-absent-fact-conduct-prepayment-guard"

	artifactPath:       "architecture/adrs/adr-161-absent-fact-conduct-prepayment-guard.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-28"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 1 — self-review do adr-161 + emenda casada no domain-model do FCE + def-069,
			executado em SUBAGENTE ISOLADO (sem o histórico da conversa) contra o #ADR
			(architecture/artifact-schemas/adr.cue), o PG-ADR, o #DeferredDecision e os
			universalCriteria do quality-gate, com verificação factual via Read/filesystem.
			cue vet ./... EXIT=0 (com adr-161, def-069 e a emenda).

			[CONFORMIDADE ESTRUTURAL #ADR]: PASS. Campos obrigatórios com valores válidos nos
			enums: decisionClass "structural", decider "founder", status "proposed"
			(#NonSupersededStatus → supersededBy omitido), reversibility "medium", blastRadius
			"cross-artifact", date 2026-06-28 (regex ISO), id adr-161 (próximo livre — último no
			disco adr-160). falsificationCondition com condition + observableSignal.
			principlesApplied não-vazio.

			[tq-adr-01 / tq-adrg-01 alternativas]: PASS. context traz "Alternativas avaliadas: (a)
			escalar-a-ausência / (b) tratar-como-breach", cada uma com razão de rejeição substantiva
			(audit falso + contradição "PRESENTE" para (a); P11-é-sobre-prova-não-sobre-informação-
			faltante para (b)), não decorativa. A tétrade (c) é a escolha contrastada.

			[tq-adr-02 / tq-adrg-02 metadata de risco]: PASS. blastRadius "cross-artifact" verificado
			COERENTE — o impacto comportamental é FCE-local (toca contexts/fce/domain-model.cue + a
			leitura FCE de adr-160 + def-069; NÃO toca engine/schema/DLV/CMT/REW); corretamente mais
			estreito que o "cross-cutting" do pai adr-160 (que tocava schema + 2 BCs + codegen).
			reversibility "medium" coerente (reverter = desfazer emenda + predicado de presença do
			runtime; nada persistido travado). Não-genérica.

			[tq-adr-03 / tq-adrg-03 paths reais]: PASS. affectedArtifacts contexts/fce/domain-model.cue
			existe; plannedOutputs def-069-absent-fact-prolonged-conduct.cue existe (new-created);
			defersTo def-069 resolve; adr-160 e adr-155 referenciados existem. Disciplina 3-way
			schema-supported (existing-altered → affectedArtifacts; new-created → plannedOutputs).

			[tq-adr-04 impacto rastreável]: PASS. affectedArtifacts + plannedOutputs não-vazios.

			[uq-01 rationale=por quê / uq-02 especificidade-Mesh]: PASS. rationale e cada entry de
			principlesApplied registram POR QUE. Especificidade: gate de 3 condições do PrePaymentGuard,
			QueryEligibility sync ao REW, piso inv-breach-bypasses-escalation, freeze
			p11-invariant-breach-detected — quebra sob substituição por "qualquer fintech".

			[uq-03/uq-04 cross-refs + princípios]: PASS. P11/P10/P14/P0 verificados como chaves reais
			em design-principles.cue; nenhuma afirmação os contradiz (adr-161 afirma P11 piso-intacto e
			P10 sem-money-move-autônomo); tensão "nenhuma" declarada.

			[#DeferredDecision def-069 tq-def-01..04]: PASS. tq-def-01 trade-off concreto (custo evitado
			= policy de timeout arbitrária; custo de deferir = baixo, sem produção); tq-def-02 trigger
			codificado (manual-review reason ≥40); tq-def-03 manual-only justificado (não machine-
			evaluable hoje — sem scheduler/Payments de produção); tq-def-04 low+local coerente.

			[COERÊNCIA INTERNA — checagem load-bearing]: PASS. A afirmação central do adr-161 — piso
			(inv-breach-bypasses-escalation) INALTERADO; ausência de invoice/eligibility NÃO escala
			(guarded via NoApplicableTransition/failedSelector); breach segue roteado-e-barrado
			(failedGuard) — é consistente com (1) a invariante inalterada, (2) o rationale emendado de
			sel-prepayment-not-clean (estreita para PRESENTES, mantém breach roteado-e-barrado, carve-out
			da ausência), (3) a cláusula acrescentada ao evt-payment-guard-escalated (ausência→waiting
			distinta de breach→freeze e stale-presente→escala). Sem contradição com adr-160 (status
			proposed confirmado; refina itens 4/6, não supersede). A assimetria failedGuard vs
			failedSelector é suportada pela forma {to, failedGuard?, failedSelector?} de adr-160.

			Finding info (não-bloqueante): uq-05 — a limitação PRESENÇA-vs-FRESCOR hand-authored no
			runtime (fatia 3) está adequadamente declarada em consequences N3c e na
			falsificationCondition ("predicado insuficiente"); não há violação, registrado como info.
			"""
	}]

	findings: {}

	summary: """
		SRR do adr-161 — ADR estrutural filha de adr-160 (refina a semântica do residual not-clean
		dos itens 4/6 para o caso de ausência; não-amend/não-supersede), acompanhada da emenda casada
		no domain-model do FCE (rationales de sel-prepayment-clean/-not-clean + cláusula final do
		evt-payment-guard-escalated) e do def-069 (deferimento da conduta de ausência prolongada).
		Decide a TÉTRADE de conduta do PrePaymentGuard — clean→authorized, stale-presente→escalated,
		breach→guarded+freeze, ausente-de-fato→guarded waiting-for-information — resolvendo a
		contradição entre o selector-design de adr-160 ("residual amplo escala tudo não-limpo") e o
		evento/VO/piso ("só PRESENTE escala"). Sem mudança de schema/gerador/motor. Self-review em
		subagente ISOLADO (sem histórico da conversa) per quality-gate rollout adr→isolated-subagent.

		VEREDITO: 0 fail / 0 warn / 1 info, stable em 1 round. Conformidade #ADR PASS (enums válidos,
		status proposed → supersededBy omitido). tq-adr-01 PASS (2 alternativas com rejeição real +
		a tétrade escolhida). tq-adr-02 PASS (blastRadius cross-artifact coerente — FCE-local, mais
		estreito que o cross-cutting do pai; reversibility medium justificada). tq-adr-03 PASS (todos
		os paths existem no disco; disciplina 3-way). tq-adr-04 PASS. uq-01/uq-02/uq-03/uq-04 PASS
		(rationale=por quê; especificidade-Mesh; P11/P10/P14/P0 reais; sem contradição). def-069
		tq-def-01..04 PASS. Coerência interna PASS — o piso não se move (breach roteado-e-barrado,
		failedGuard recuperável; ausência carve-out via failedSelector). cue vet ./... EXIT=0. info
		único (uq-05): limitação PRESENÇA-vs-FRESCOR do runtime já declarada em N3c — sem ação.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round porque (a) as 3 sections do ADR já tinham passado por auto-check no
		authoring gated antes da escrita, e (b) a revisão independente foi feita por um subagente
		ISOLADO (sem o histórico da conversa, per quality-gate rollout adr→isolated-subagent), cujo
		viés de auto-ratificação é menor — e ainda assim retornou 0 fail / 0 warn. O ataque central —
		o piso P11 sob a nova conduta de ausência — foi desenhado para NÃO mover a barreira: o breach
		de evidência continua roteado-e-barrado pelo MESMO guard terminal inv-breach-bypasses-escalation
		(failedGuard recuperável), e só a ausência de invoice/eligibility (que NÃO é violação de
		integridade) é carve-out para waiting (failedSelector); o subagente verificou essa coerência
		contra a invariante inalterada e contra os dois rationales emendados, sem contradição. As
		demais dimensões (conformidade #ADR com enums lidos do schema; tq-adr-01..04; tq-adrg-01..04;
		uq-01..09; def-069 tq-def-01..04) deram PASS na primeira passada, cada afirmação factual
		verificada via Read/filesystem (enums do #ADR, existência de affectedArtifacts/plannedOutputs/
		defersTo, P11/P10/P14/P0 reais em design-principles.cue). O único achado foi um info
		não-bloqueante (uq-05) sobre limitação JÁ declarada em consequences N3c — não exigia correção
		nem re-rodada. cue vet ./... EXIT=0.
		"""
}
