package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

invStructuralCheck: build_time.#SelfReviewReport & {
	reportId: "srr-inv-structural-check"

	artifactPath:       "architecture/structural-checks/inv-domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-07"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			INV structural-check materializado em 1 commit pos ADR-080
			fundação (commit 0132762). 8 checks domain-invariant
			cobrindo 8 invariants do contexts/inv/domain-model.cue.
			Phase 3.5 do WI-053 INV bootstrap. Materializa princípio
			'declaração de garantia + declaração explícita de limite'
			(honesty arquitetural por construção).

			**LIMITES SEMÂNTICOS DE COVERAGE — EXPLÍCITOS** (founder
			obrigatório pre-SRR):

			Coverage triplet em cada check declara:
			- buildTime = MODEL-LEVEL conformance only (NOT runtime
			  instance guarantee). Verifica schema declaration via
			  CUE constraints; NÃO verifica runtime instances.
			- validationTime = PLANNED capability (Phase 1+ runner
			  work). Hoje é declaração de intenção; não implementado.
			- runtimeRequired = ACTUAL enforcement layer responsibility
			  (transactional outbox, DB constraint, persistence
			  layer, application guard, event log).

			Esta distinção é CRÍTICA: agente futuro lendo
			'buildTime: true' poderia assumir runtime guarantee — não é.
			Phase 0 honesty: validation-time runner não existe ainda;
			runtime enforcement depende de implementação futura. Único
			check fully build-time enforced (sc-inv-04 lifecycle-states)
			tem overclaim sutil — CUE enum constraint valida MODEL
			declaration, não instance status runtime.

			**SCHEMA OPENNESS GAP — DECLARADO** (founder obrigatório):
			domain-model.cue allows field extension unless explicitly
			constrained — boundary enforcement de field-set fechado
			(allowed fields list) NÃO é capturado por nenhum dos 8
			structural-checks. Adicionar field a Invoice (e.g.,
			paymentStatus = mini-FCE) OR Receivable (e.g.,
			eligibilityScore = mini-SCF) PASSA todos os 8 checks +
			cue vet. Boundary enforcement contra field injection
			depende de glossary antiTerms + review discipline +
			validation-prompt advisory (NÃO structural gate). Future
			work: structural-check kind 'allowed-fields-closed' OR
			schema closed-struct enforcement.

			**ADVERSARIAL PROOF — 15 ATTACK TESTS em 5 dimensões**:

			Dimensão 1 — Domain Violation Attacks (3):

			Attack A1 (silent recomposition):
			Tentativa: Mutar Invoice.regimeVersion in-place quando
			regimeVersion-N+1 publicada (sem nova InvoiceIssued).
			Should block: sc-inv-03 (regime-immutability).
			Coverage: validationTime+runtime; gap: lint snapshot
			runner Phase 1+.
			Risk residual Phase 0: proteção apenas via runtime
			persistence layer + manual review (validation-time
			fantasma per E2).

			Attack A2 (duplicate emission):
			Tentativa: Emit dois Invoices distintos sob mesma
			(commitmentRef, evidenceRef).
			Should block: sc-inv-02 (idempotent-issuance).
			Coverage: runtime only (DB unique constraint OR event
			log dedup); gap absoluto build/validation-time.

			Attack A3 (half-emission atomic break):
			Tentativa: Emit InvoiceIssued + crash antes de
			ReceivableMaterialized.
			Should block: sc-inv-01 (atomic-dual-emission).
			Coverage: runtime only (transactional outbox primitive);
			gap: sem outbox real, gap absoluto.

			Dimensão 2 — Enforcement Mismatch Attacks (4 — main
			vetor de erro de IA):

			Attack E1 (schema vs instance scope confusion) — RISK
			ALTO 1:
			Tentativa: Adicionar status='paid' em INSTÂNCIA runtime
			de Invoice (não em domain-model.cue).
			Should block: sc-inv-04 (lifecycle-states).
			Coverage declarado: buildTime: true.
			Gap CRÍTICO: buildTime: true verifica que SCHEMA do
			Invoice declara enum {issued, cancelled} — NÃO impede
			instância runtime ter status='paid'. Único check
			'fully build-time' tem overclaim semântico — buildTime
			coverage é model-level, não instance-level.
			Mitigação SRR: limite explicitado canonicamente; agentes
			futuros não podem assumir runtime guarantee de buildTime.

			Attack E2 (validation-time promised but not delivered) —
			RISK ALTO 2:
			Tentativa: Mutate Invoice.fiscalDocRef post-creation.
			Should block: sc-inv-06 (fiscal-doc-ref-integrity,
			validationTime: true).
			Coverage declarado: validationTime: true + runtimeRequired.
			Gap CRÍTICO: enforcedBy 'lint comparing historical
			snapshots' — esse runner Phase 1+ NÃO existe Phase 0.
			validationTime: true é PROMESSA, não realidade.
			Mitigação SRR: limite explicitado — validationTime =
			planned capability Phase 1+, não active guarantee.

			Attack E3 (runtime gap subspecified — cancellationWindow
			contract):
			Tentativa: Implementar cancellationWindow(regimeVersion)
			inline em INV (mini-ATO stealth).
			Should block: sc-inv-05 rationale 'pure function externa'.
			Gap: 'externa' é declarado em rationale + runtimeGap mas
			SEM contract de interface (signature; layer canônico).
			Risco residual: boundary protector tem letra mas execução
			ambígua.

			Attack E4 (field addition undetected):
			Tentativa: Adicionar Invoice.paymentStatus (mini-FCE) OR
			Receivable.eligibilityScore (mini-SCF) ao domain-model.cue.
			Should block: NENHUM check captura field addition.
			Gap CRÍTICO: structural-checks validam shape conformance
			+ enum values + reference integrity — NÃO restringem field
			SET no schema.
			Mitigação: glossary antiTerms (anti-mini-SCF, anti-mini-
			FCE) + review discipline; structural-check kind
			'allowed-fields-closed' deferred Phase 1+.

			Dimensão 3 — Boundary Leakage Attacks (3) — RISK ALTO 3
			(field/policy injection):

			Attack L1 (mini-orchestrator via policy introduction):
			Tentativa: Adicionar policies: [pol-payment-settled-handler]
			ao domain-model.cue (consume FCE event, react).
			Should block: ?
			Gap CRÍTICO: NENHUM check valida 'domain-model has 0
			policies' OR 'policies don't consume cross-BC events'.
			Founder check Phase 3 (L7 Policy Absence) PASSED só porque
			INV foi escrito assim — estrutural não previne adição
			futura. BD10 anti-orchestrator é semântico, não enforced.
			Risco residual: Phase 4+ poderia introduzir policy 'para
			integração' sem trigger.

			Attack L2 (mini-SCF via Receivable enrichment):
			Tentativa: Adicionar Receivable.eligibilityScore ou
			.transferRate (campos SCF).
			Should block: term-receivable antiTerm 'instrumento
			financeiro com pricing'.
			Gap: structural-check sc-inv-* NÃO valida campos SET de
			Receivable contra glossary antiTerms. Field addition
			passa cue vet.

			Attack L3 (cross-BC drift via communication enrichment):
			Tentativa: Adicionar campos ao InvoiceIssued payload
			(e.g., paymentMethod) no domain-model events.
			Should block: canvas anti-payload-bloat antiTerms.
			Gap: sc-inv-* operam sobre invariants, NÃO sobre event
			payloads.

			Dimensão 4 — Interaction Attacks (2):

			Attack I1 (asymmetric coverage atomic invariant):
			Tentativa: Emit Invoice sem Receivable correspondente
			(cardinality 0).
			Should block: sc-inv-01 covers both directions.
			Sutileza: sc-inv-08 (referential-integrity) só cobre
			Receivable→Invoice direção. Se Invoice existe sem
			Receivable, sc-inv-08 NÃO catch (não há Receivable
			órfã, há Invoice órfã).
			Gap: Coverage assimétrica — depende EXCLUSIVAMENTE de
			sc-inv-01 cobrir Invoice→Receivable.
			Mitigação: cardinalidade 1:1 explícita em sc-inv-01
			assertion (count(Receivable per invoiceId) == 1)
			fortalece coverage simétrica.

			Attack I2 (identity composition drift):
			Tentativa: Sistema runtime computa identity como
			(commitmentRef, evidenceRef, regimeVersion) — enriquece
			além do declarado.
			Should block: sc-inv-02 assertion 'identity does not
			include regimeVersion or criteriaVersion'.
			Sutileza: assertion é DECLARATIVO; runtime impl pode
			internamente usar regimeVersion como dedup key disfarçada.
			Gap: structural-check valida domain-model declaration,
			NÃO runtime impl behavior.
			Risco residual: drift implementation invisível (false
			determinism — sistema parece fechado mas runtime
			composição pode diferir).

			Dimensão 5 — Determinism Attacks (1):

			Attack D1 (clock skew + cancellation window):
			Tentativa: Cancel invoice quando local clock disagrees
			com canonical clock (NTP drift, distributed system).
			Should block: sc-inv-05 (cancellation-boundary; cancelledAt
			- issuedAt ≤ window).
			Gap CRÍTICO: enforcedBy NÃO declara qual clock é
			authoritative. Diferentes interpretações geram comportamento
			divergente cross-agent.
			Risco residual: Sistema parece determinístico mas depende
			de clock authority não-declarado — gap silencioso em
			ambiente distribuído.

			**ATTACKS NEW (founder additions pre-SRR — 2)**:

			Attack N1 (event-order ambiguity):
			Tentativa: Receber InvoiceCancelled antes de InvoiceIssued
			(reorder de eventos in-flight).
			Should block: sc-inv-05 + sc-inv-07.
			Gap: Nenhum invariant declara EXPLICITAMENTE 'InvoiceIssued
			MUST precede InvoiceCancelled' no event log. Existem
			'cancelled ⇒ was previously issued' e 'cancelled ⇒ exists
			InvoiceCancelled' — mas dependem de histórico consistente
			+ ordering correto. Não modelado como ordering constraint
			no event log.
			Risco residual: Sistema pode aceitar cancelled sem issued
			visível ainda OR aplicar lógica errada por reorder.
			Mitigação Phase 0: enforcedBy declara 'event log temporal
			ordering verification'; Phase 1+ promotion para invariant
			explícito de event log ordering.

			Attack N2 (projection poisoning):
			Tentativa: Corromper prj-invoice-by-identity (projection
			diz invoice existe, aggregate não tem).
			Should block: NENHUM check direto.
			Gap CRÍTICO: declarei 'projection não é autoritativa' em
			domain-model rationale + glossary, MAS não existe
			invariant/check que PROÍBA usar projection como fonte de
			verdade. Erro clássico IA + event-driven systems.
			Risco residual: idempotency check baseado em projection →
			false positive; dedup errado → perda de emissão válida.
			Mitigação Phase 0: declaração canonical 'projection é
			cache, identity canonical permanece em aggregate via
			cmd-issue-invoice'; Phase 1+ promotion para invariant
			explícito 'identity check MUST query aggregate state, not
			projection'.

			**COVERAGE MATRIX** (qual invariant tem qual gap):

			| Invariant | A | E | L | I | D | N |
			|-----------|---|---|---|---|---|---|
			| sc-inv-01 atomic | A3 | — | — | I1 | — | — |
			| sc-inv-02 idempotent | A2 | — | — | I2 | — | N2 |
			| sc-inv-03 regime-immut | A1 | — | — | — | — | — |
			| sc-inv-04 lifecycle | — | E1 | L2-L3 | — | — | — |
			| sc-inv-05 cancel-bound | — | E3 | L1 | — | D1 | N1 |
			| sc-inv-06 fiscal-doc | — | E2 | — | — | — | — |
			| sc-inv-07 cancel-event | — | — | — | — | — | N1 |
			| sc-inv-08 receivable-ref | — | — | L2 | I1 | — | — |

			**RISCOS RESIDUAIS ALTOS — DECLARAÇÕES EXPLÍCITAS**
			(founder obrigatório):

			RISCO ALTO 1 — Schema vs Instance scope (E1):
			sc-inv-04 buildTime: true significa MODEL CONFORMANCE
			ONLY, não runtime instance guarantee. Único check
			'fully build-time' tem overclaim subtle. Limite
			declarado canonicamente neste SRR.

			RISCO ALTO 2 — Validation-time fantasma (E2):
			validationTime: true em sc-inv-03 + sc-inv-06 é PLANNED
			CAPABILITY Phase 1+, não active guarantee. Runner não
			implementado Phase 0. Limite declarado canonicamente.

			RISCO ALTO 3 — Schema openness (L1-L3 + E4):
			Domain-model NÃO é semanticamente fechado contra field/
			policy injection. Boundary enforcement contra extensions
			depende de glossary + review + validation-prompt advisory.
			Future work: structural-check kind 'allowed-fields-closed'
			deferred Phase 1+. Limite declarado canonicamente.

			**LINT ARCHITECTURAL VALIDATION** (founder pre-write
			lint — 4 corrections incorporated):

			(L1) sc-inv-01 assertion corrected — relação Invoice ↔
			Receivable via Receivable.invoiceId reference (NÃO
			biconditional 1:1 por chave igual). Cardinalidade 1:1
			explícita pos founder micro-tightening.
			(L2) Coverage corrigida em sc-inv-03/06/08 — sem
			'build-time wishful thinking'; build-time não vê
			histórico (não pode detectar mutation); validation-time
			+ runtime cobrem.
			(L3) Forbidden patterns reescritos como state/property
			prohibitions (NÃO actions) — previne reintrodução de
			orchestration implícita; founder rule 'forbidden é
			proibição de ESTADO ou PROPRIEDADE'.
			(L4) cancellationWindow declarado EXPLICITAMENTE como
			pure function externa em sc-inv-05 rationale +
			runtimeGap.enforcedBy — protege contra implementação
			inline (anti-mini-ATO stealth).

			Plus founder micro-tightenings:
			(M1) sc-inv-01 cardinalidade 1:1 explícita
			(count(Receivable per invoiceId) == 1) na assertion.
			(M2) sc-inv-02 non-dependence on versions explícita
			(identity does not include regimeVersion or criteriaVersion)
			na assertion.

			**SCHEMA SATISFAÇÃO** (tq-sc-XX por inspeção):
			tq-sc-01 (errorMessage específica per check, não genérica)
			✓ — todos referenciam invariant + enforcedBy layer
			tq-sc-XX (8 IDs regex sc-inv-NN compliant; artifactType
			'domain-model' valid; kind 'domain-invariant' per ADR-080;
			rule shape #DomainInvariantRule satisfeito) ✓ via cue vet

			cue vet ./architecture/structural-checks/ EXIT=0;
			cue vet ./... EXIT=0.

			**EXHAUSTIVITY PROOF**:
			8/8 invariants do contexts/inv/domain-model.cue mapeados
			a 8/8 structural-checks (1:1). Cada check declara
			coverage triplet + (runtimeGap quando runtimeRequired) +
			forbidden state/property prohibitions. 15 attack tests
			(13 originais + 2 founder additions) cobrem 5 dimensões
			de violação possível.

			**HONESTY ARQUITETURAL PROVADA**:
			SRR declara canonicamente NÃO apenas o que É garantido,
			mas TAMBÉM:
			- O que NÃO É garantido (3 riscos altos declarados)
			- Onde está enforcement do gap (runtimeGap.enforcedBy
			  per check)
			- Limites semânticos de coverage triplet (model vs
			  runtime; planned vs active)
			- Schema openness gap (field/policy injection não
			  capturado)

			Sistema deixa de fingir cobertura completa — declara
			canonicamente o ESCOPO REAL de enforcement.

			Phase 3.5 fechamento: estrutura formal de garantias +
			limites materializada. Phase 4 (agent-spec) opera dentro
			deste boundary explícito; Phase 5 (envelope) elabora
			runtime enforcement layer per cada runtimeGap declarado.
			"""
	}]

	findings: {}

	summary: """
		INV structural-check materializado em 1 commit pos ADR-080
		fundação. 8 checks domain-invariant cobrindo 8 invariants.
		ADVERSARIAL PROOF estruturada em 5 dimensões (15 attack
		tests): 3 domain violations + 4 enforcement mismatches +
		3 boundary leakages + 2 interactions + 1 determinism + 2
		founder additions (event-order ambiguity, projection
		poisoning). 3 RISCOS ALTOS declarados canonicamente: E1
		schema vs instance scope (buildTime overclaim subtle); E2
		validation-time fantasma (Phase 1+ runner pending); L1-L3
		schema openness (field/policy injection não capturado).
		LIMITES SEMÂNTICOS DE COVERAGE explícitos: buildTime =
		model conformance only; validationTime = planned capability
		Phase 1+; runtimeRequired = actual enforcement layer
		responsibility. SCHEMA OPENNESS GAP declarado: domain-model
		allows field extension; boundary enforcement contra
		extensions depende de glossary + review + validation-prompt
		advisory. Founder lint architectural validation 4 corrections
		+ 2 micro-tightenings incorporados. tq-sc-XX satisfeitos.
		cue vet clean. Sistema deixa de fingir cobertura completa —
		declara escopo real de enforcement (honesty arquitetural por
		construção).
		"""

	singleRoundRationale: """
		Authoring manual via founder pre-write lint architectural
		validation (4 corrections + 2 micro-tightenings) + attack
		map structured em 5 dimensões (founder accept + 2 additions
		N1 N2) + 3 risk residual declarations explícitas obrigatórias
		(E1 buildTime overclaim; E2 validation-time fantasma; L1-L3
		schema openness gap). Round único suficiente — qualidade
		incorporada via founder review iterativo durante composição
		(ANTES dos commits): pushback bilateral em coverage
		(buildTime wishful thinking corrigido para 3 checks);
		assertion cardinality 1:1 explícita; non-version-dependence
		explícita; forbidden state-based; cancellationWindow pure-
		external. Pattern paralelo glossary SRR adversarial proof —
		mas elevado nível: SRR não apenas valida cobertura, declara
		canonicamente os LIMITES (o que sistema NÃO garante).
		Honesty arquitetural por construção é o moat real Mesh-level.
		"""
}
