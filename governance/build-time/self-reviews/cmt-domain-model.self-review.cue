package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

cmtDomainModelStructuralCheck: build_time.#SelfReviewReport & {
	reportId: "srr-cmt-domain-model-structural-check"

	artifactPath:       "architecture/structural-checks/cmt-domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-03"

	roundsExecuted: 4
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 1 (context-and-rule-identification) per PG
			structural-check (commit 9544ffa) + ADR-086.

			Lido CMT domain-model (8 invariants declared); cross-
			referenced com primary-agent (8 constraints 1:1 coverage).

			8 invariants candidate identificados:
			(1) inv-mutual-bilateral-acceptance
			(2) inv-terms-reference-valid (cross-BC CTR dependency)
			(3) inv-commitment-id-uniqueness
			(4) inv-suspension-requires-supervision (P10 gate)
			(5) inv-cancellation-irreversible
			(6) inv-reactivation-requires-supervision (P10 gate)
			(7) inv-proposer-counterparty-distinct
			(8) inv-cancelled-is-terminal

			War-game admissibility per rule articulado — cada cenário
			é pre-production failure mode credible (NÃO especulação
			genérica). Bacen credit context + cascade CMT → BDG/DLV/
			INV/FCE reforça severity.

			Behavioral non-applicability assessment: NENHUM invariant
			é behavioral puro (architectural review OR anti-corruption
			discipline) — todos 8 são structurally enforceable. Pattern
			paralelo a INV pos-patch: CMT é structural+cross-BC mid-
			band entre INV (structural-local L1/L2/L4) e REW
			(semanticamente contextual L5/L6/L7).

			3 founder ajustes Section 1 incorporados:
			(1) sc-cmt-02 add L6 (interpretation coherence cross-BC
			    downstream BDG/INV reference frozen termsVersion)
			(2) sc-cmt-03 remove L3 (uniqueness é L1/L2 local;
			    downstream referential integrity é BDG/DLV/INV/FCE
			    concerns)
			(3) sc-cmt-04/06 add L2 (state-transition references
			    SupervisionApproval.id consistency)
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 2 (rule-composition) per PG structural-check +
			ADR-086 Domain-Invariant Structural Check Authoring
			Protocol D2..D6 application.

			Per rule composição:
			- 8 fields obrigatórios (id/title/artifactType/description/
			  kind/rule/errorMessage/rationale)
			- assertion formal logic ∀⇒∧
			- coverage flags + runtimeGap quando runtimeRequired=true
			- forbidden patterns como state/property prohibitions
			  (per founder lint: NÃO actions procedurais)
			- DISCAP block em description multi-line:
			  applicable layers + non-applicable rationale compacto +
			  RE-VAL flag + war-game evidence

			5 founder ajustes Section 2 incorporados:
			(1) sc-cmt-01 terminology neutra — checked CMT domain-model
			    events: evt-commitment-proposed (single) +
			    evt-commitment-accepted (single carries parties +
			    termsRef). NÃO há AcceptEvent_proposer + AcceptEvent_
			    counterparty separados; usado neutral term
			    'BilateralAcceptanceEvidence(proposer/counterparty)'
			    representing bilateral evidence structure (field-level
			    em evt-commitment-accepted OR signals capturados pelo
			    gate pre-emission).
			(2) sc-cmt-03 coverage F/T/T → T/T/T (build-time pode
			    declarar field required + uniqueness intent em CUE
			    schema; runtime garante via persistence; validation-
			    time lint cross-instance).
			(3) sc-cmt-07 coverage T/T/F → T/T/T + runtimeGap added
			    (alias resolution / legal-entity identity graph
			    requires runtime identity registry; sem isso, literal
			    comparison é insufficient — vetor manipulation aberto
			    via alias accounts).
			(4) sc-cmt-08 coverage T/T/F → T/T/T + runtimeGap added
			    (post-cancellation transition absence requires event
			    log query runtime + aggregate command handler reject).
			(5) errorMessage 3-part acionável (o que / por quê / como
			    corrigir) preenchido em sc-cmt-03..08 (estava apenas
			    explicit em 01/02 da proposta; tq-scg-02 fail exige
			    em todos).

			Final layer assignments demonstram DISCAP ladder seletivo
			(per founder observation empirical validation):
			- sc-cmt-01 (bilateral-acceptance): L1+L2+L6
			- sc-cmt-02 (terms-reference): L3+L4+L5+L6 + RE-VAL
			- sc-cmt-03 (id-uniqueness): L1+L2
			- sc-cmt-04 (suspension-supervision): L1+L2+L7
			- sc-cmt-05 (cancellation-irreversible): L1+L2+L4+L7 + RE-VAL
			- sc-cmt-06 (reactivation-supervision): L1+L2+L7
			- sc-cmt-07 (proposer-counterparty-distinct): L1+L2
			- sc-cmt-08 (cancelled-is-terminal): L1+L2+L4

			CMT como structural+cross-BC mid-band confirmado: 6/8 rules
			com L1+L2 base; sc-cmt-02 peak semantic complexity (L3+L4+
			L5+L6 — cross-BC terms resolution); supervision gates
			(sc-cmt-04/05/06) introduzem L7 decision context; sc-cmt-05
			adiciona L4 (post-cancel immutability) + RE-VAL.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Section 3 (validation-and-meta) per PG structural-check
			finalValidation steps.

			Schema satisfaction verified:
			- ✅ Todas 8 rules têm 8 campos obrigatórios preenchidos
			  (id/title/artifactType/description/kind/rule/errorMessage/
			  rationale)
			- ✅ kind: domain-invariant em todas
			- ✅ rule sub-schema #DomainInvariantRule conforme
			- ✅ assertion formal logic ∀⇒∧ presente
			- ✅ coverage struct at-least-one-true em todas
			- ✅ runtimeGap presente quando runtimeRequired=true
			  (8/8 rules com runtimeRequired=true; 8/8 runtimeGap
			  preenchido com description + enforcedBy)
			- ✅ forbidden patterns são state/property prohibitions
			  (NÃO actions procedurais per founder lint)
			- ✅ errorMessage 3-part acionável em todas

			DISCAP compliance (per ADR-086 + PG patch WI-076):
			- ✅ tq-scg-04 (D2 layer applicability): 8/8 rules declaram
			  applicable layers explicit + non-applicable rationale
			  compacto em description DISCAP block
			- ✅ tq-scg-05 (D3 coverage flags): 8/8 declared with
			  at-least-one-true
			- ✅ tq-scg-06 (D4 runtimeGap): 8/8 runtimeRequired rules
			  com runtimeGap completo
			- ✅ tq-scg-07 (D5 war-game evidence): 8/8 com pre-
			  production failure mode articulado explicit
			- ✅ tq-scg-08 (D6 behavioral non-applicability): header
			  declara explicit que todos 8 invariants são structurally
			  enforceable; nenhum é behavioral puro

			cue vet ./... EXIT=0; cue vet -c ./... EXIT=0 (sem
			incomplete instances).

			Tamanho file: ~590 linhas (estimativa 440-500 ligeiramente
			ultrapassada por DISCAP block multi-line per rule +
			rationale rico para 8 rules cross-BC).

			Forward-application pattern paralelo a INV/REW pos-DISCAP-
			retroactive-patch (sc-inv-* + sc-rew-*), MAS autorado FROM
			SCRATCH com protocol canonical aplicado — não retroactive
			backfill. Demonstra DISCAP transferable per ADR-086 D7
			(PG patch goal: 'pattern transferable post-canonicalization
			— each BC authors per protocol').
			"""
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 4 (adr-142, Fatia A+C — zero-drift do structural-check): sc-cmt-01 reescrito para o
			predicado de hash assimétrico — proponente confirma implicitamente via ProposeCommitment
			(fixa referenceTermsHash = sha256(canonical({contractTermsRef, scope}))), contraparte
			explicitamente via AcceptanceConfirmation; assertion troca termsRef-coherence por
			AcceptanceConfirmation.termsHash == referenceTermsHash; forbidden + rationale alinhados.
			sc-cmt-02 reescrito para propose-time + fail-closed (CTR indisponível/timeout em propose-time
			⇒ ProposeCommitment rejeitado; termsVersionAtProposal frozen; SLA → def-046). Mantém zero-drift
			com inv-mutual-bilateral-acceptance + bd-terms-validation reescritos no mesmo pacote. Zero
			findings; cue vet ./... EXIT=0; structural-check-runner inalterado (sc-cmt-* são domain-invariant
			validation-time, não disparam por reescrita de texto).
			"""
	}]

	findings: {}

	summary: """
		CMT structural-check (sc-cmt-01..08) — primeira aplicação
		DISCAP-guided forward authoring per ADR-086 + PG patch WI-076.

		8 rules cobrindo 8 invariants do CMT domain-model: bilateral
		acceptance + terms reference cross-BC (CTR) + commitment-id
		uniqueness + supervision gates (suspension + cancellation +
		reactivation) + proposer-counterparty distinct + cancelled-
		terminal.

		CMT severity tier ALTO: Bacen credit scrutiny + cascade CMT
		→ BDG/DLV/INV/FCE; commitment root das obligation chains
		downstream.

		Layer matrix demonstra DISCAP progressive ladder seletivo:
		CMT structural+cross-BC mid-band entre INV (L1/L2/L4
		structural-local) e REW (L5/L6/L7 semanticamente contextual).
		sc-cmt-02 peak semantic complexity (L3+L4+L5+L6 cross-BC
		terms resolution + version freeze + freshness + interpretation
		coherence downstream); supervision gates (sc-cmt-04/05/06)
		introduzem L7 decision context.

		Behavioral non-applicability: NENHUM invariant é behavioral
		puro; todos 8 structurally enforceable (header declara
		explicit). Pattern paralelo a INV: quase totalmente structural
		com cross-BC dimension (CTR terms reference) adicionada.

		3 rounds executed (Section 1 + 2 + 3); 8 founder ajustes
		incorporados pre-write (3 Section 1 + 5 Section 2). cue vet
		./... EXIT=0 (-c clean).

		Cascade complete (Tier 1 first BC): CMT é primeira aplicação
		forward DISCAP-guided pos-canonicalization; 7 BCs pending
		(dlv/ssc/ctr/p2p/bdg/idc/npm per founder priority order).

		Pattern transferable validated: protocol canonical aplicado
		FROM SCRATCH (não retroactive backfill) produz BC-specific
		layer matrix conforme natureza do BC; complexidade
		epistemológica capturada via ladder selectivo.
		"""
}
