package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def027RewCmtPolicyReaction: build_time.#SelfReviewReport & {
	reportId: "srr-def-027-rew-cmt-policy-reaction"

	artifactPath:       "architecture/deferred-decisions/def-027-rew-cmt-policy-reaction.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do def-027 (W2 cmt→rew→dlv→bdg→cmt, Família A da
			taxonomia de exclusão do grafo do sc-cm-07). Proposta passou por
			3 ciclos pré-aprovação:

			Ciclo 1 (propose): agrupamento topológico.
			Ciclo 2 (refine): canvas REW confirmou "decisão ≠ execução" como
			tese categórica — fundamenta opção (c) [PREFERRED] (policy-reaction
			como kind) e refuta (a) mutual-dependency forçada e (b) deleção
			de aresta.
			Ciclo 3 (validate subdomains): subdomain FCE confirmou "FCE executa
			decisões de risco, não as produz" — reforça que REW é producer
			de signals/decisões; consumers reagem por policy. commitment-
			lifecycle.cue confirma "risco transversal ao flow".

			Conformância #DeferredDecision (tq-def-01/02/03/04):

			(tq-def-01 — deferralRationale articula trade-off concreto):
			deferralRationale ≥100 runes explicita MOTIVO (decisão DDD + scan
			complementar para hidden coupling + sequenciamento de PRs) +
			RISCO (hidden coupling se aplicar só a rew-to-cmt) + CUSTO. PASS.

			(tq-def-02 — triggers codificados, não prose): triggers conforma
			#Trigger discriminated union — manual-review com reason ≥40 runes
			+ adjacent-need file-contains. PASS (cue vet exit 0).

			(tq-def-03 — pelo menos 1 trigger non-manual-review): adjacent-need
			file-contains é non-manual-review machine-evaluable. PASS.

			(tq-def-04 — costOfDeferral coerente com escopo): severity=high
			+ blastRadius=cross-artifact justificados (4 BCs envolvidos +
			hipótese estrutural com aplicação além de 1 aresta +
			inconsistência com commitment-lifecycle.cue declared
			transversalidade). PASS — severity high alinha com blast cross-
			artifact por hipótese estrutural; não é combinação suspeita
			(high+local seria; high+cross-artifact é coerente).

			Verificação:
			- cue vet ./architecture/deferred-decisions/ EXIT 0;
			- shape conforma à variante "open";
			- originatingArtifacts cita 6 referências reais (context-map.cue,
			  sc-cm-07, adr-117, cmt canvas, rew canvas, commitment-lifecycle);
			- triggers[1].condition.pattern com aspas escapadas restringe
			  match a atribuição CUE em instance — evita FP em adr-119 (PR-1).
			"""
	}]

	findings: {}

	summary: """
		def-027 conforma #DeferredDecision (tq-def-01/02/03/04 todos passados).
		Família A da taxonomia (relationship.kind semântico novo). Cobre W2
		do sc-cm-07. Severity high justificada por blast estrutural (hipótese
		policy-reaction como categoria DDD com aplicação além de 1 aresta;
		scan complementar obrigatório no PR-1). Verificado: cue vet exit 0;
		pattern do trigger secundário restrito a atribuição CUE.
		"""

	singleRoundRationale: """
		Estabilizou em 1 round após 3 ciclos de calibração pré-escrita.
		Conformidade verificada por cue vet + análise tq-def-NN. Sem espaço
		de decisão aberto a red-team adicional — decisão DDD (categoria
		policy-reaction) foi articulada pelos canvases (REW + CMT) antes
		do def existir.
		"""
}
