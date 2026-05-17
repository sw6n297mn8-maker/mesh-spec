package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

invDomainModel: build_time.#SelfReviewReport & {
	reportId: "srr-inv-domain-model"

	artifactPath:       "contexts/inv/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-06"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Domain Model INV materializado em 4 commits incrementais
			Phase 3 (Part 1 catalogs + aggregate skeleton 4e95f15;
			Part 2 aggregate completion + projection + outer rationale
			edc7a20; temporal disambiguation comment 3dee397; temporal
			disambiguation upgrade normativo per founder lint final)
			per founder framing 'compilation do glossary, não design
			livre'.

			**COMPILATION DISCIPLINE** — domain-model é tradução
			determinística do glossary (18 termos canônicos) em sistema
			formal verificável:
			- Glossary entity (Layer 1: term-invoice + term-receivable) →
			  Aggregate root + Entity interna
			- Glossary process (Layer 1: term-invoice-issuance-process +
			  term-invoice-cancellation-process) → Commands
			- Glossary event (Layer 2: 3 events) → Domain Events
			  (published cross-BC, append-only)
			- Glossary mechanism (Layer 3: 4 mechanisms) → Invariants
			  (forma lógica formal ∀⇔∧⇒)
			- Glossary value (Layer 1+3: 6 termos) → Value Objects
			- Glossary edge condition (Layer 4: 5 termos) → predicates
			  + invariant rule references (cancellationWindow function
			  externa; staleness/freshness/replay implícitos em
			  invariants/projection design)

			Composição: 3 events + 2 commands + 8 invariants +
			8 valueObjects + 1 aggregate (root Invoice + entity
			interna Receivable + lifecycle 2 estados) + 1 projection
			internal + 0 policies + outer rationale comprehensive.

			**FOUNDER LINT ARCHITECTURAL VALIDATION — 8 CHECKS**:

			(L1) Aggregate Integrity 🟢 PASS forte:
			1 aggregate único (agg-invoice); Receivable embutido como
			entity interna SEM lifecycle/status próprio; nenhum caminho
			de mutação independente de Receivable. Single source of
			truth garantido — não há estado fora do aggregate boundary.

			(L2) Lifecycle Closure 🟢 PASS perfeito:
			States ∈ {issued, cancelled} apenas; sem estados
			intermediários (pending/processing/reconciled/paid/reversed
			explicitamente NÃO presentes — esses são FCE/ATO/DRC
			territory). Máquina de estados mínima e fechada por
			construção.

			(L3) Invariants 🟢 PASS nível alto:
			8 invariants em forma lógica formal (∀, ⇔, ∧, ⇒); não
			procedurais; alinhados com glossary. Cobrem 4 pilares
			essenciais de domínio financeiro:
			- Atomicidade (inv-atomic-dual-emission)
			- Identidade (inv-idempotent-issuance +
			  inv-receivable-referential-integrity)
			- Imutabilidade (inv-regime-immutability +
			  inv-fiscal-doc-ref-integrity)
			- Boundary temporal (inv-lifecycle-states +
			  inv-cancellation-boundary +
			  inv-cancellation-event-required)

			(L4) Projection 🟡 PASS com observação:
			prj-invoice-by-identity é internal (consome SOMENTE
			evt-invoice-issued próprio do domain-model), não
			autoritativa. CHECKS satisfeitos:
			- Nenhum invariant depende da projection (invariants
			  operam sobre Invoice/Receivable entity state, não
			  sobre projection cache)
			- Projection não define existência de invoice (identity
			  canonical permanece em aggregate via cmd-issue-invoice)
			- Projection não entra em identity (tupla
			  (commitmentRef, evidenceRef) é attribute do Invoice,
			  projection é cache derivado)
			Projection é Phase 1+ optimization para BD3 idempotency
			check; Phase 0 caminho sync via aggregate state lookup
			direct é alternativa válida.

			(L5) Commands 🟢 PASS limpos:
			Apenas 2 commands (cmd-issue-invoice + cmd-cancel-invoice);
			sem overload de funcionalidade; sem lógica embutida em
			command (commands são intent declarations, decisions
			pertencem ao aggregate); sem command que decide estado
			fora do lifecycle declarado.

			(L6) Events 🟡 → 🟢 PASS upgraded (alerta endereçado
			normativamente):
			3 events append-only com payload mínimo categórico (sem
			lógica embutida; sem orchestration intent). ALERTA
			endereçado em 2 níveis: (a) inicialmente via comment
			explicativo 'NUNCA usar eventTimestamp para regras de
			domínio' (commit 3dee397); (b) upgraded para REGRA
			NORMATIVA per founder lint final: 'qualquer invariant ou
			predicate que referencie eventTimestamp é INVÁLIDO por
			definição do domínio'. Forma normativa elimina path para
			'justificar exceção' no futuro — proibição por construção
			semântica, não convenção interpretável.

			(L7) Policy Absence 🟢 PASS decisão acima da média:
			Zero policies declaradas — INV não orquestra, apenas
			declara. Cross-BC event consumption (evt-delivery-verified
			DLV; CommitmentAccepted CMT) é canvas/agent territory
			(event-consumer entries em communication; agent reaction
			Phase 4), NÃO domain-model concern. Pattern paralelo DLV
			(que usa policies SOMENTE para eventos internos
			evt-supersession-applied). Zero risco de domain-model virar
			orchestrator.

			(L8) Glossary → Model Fidelity 🟢 PASS muito forte:
			Compilation determinística verificada — todos os conceitos
			vêm do glossary; nenhuma semântica nova introduzida; nenhuma
			ambiguidade reintroduzida. Mapping rastreável:
			18 termos glossary → 3 events + 2 commands + 8 invariants +
			8 valueObjects + 1 aggregate + 1 projection. Glossary é
			input, domain-model é output da compilation; modelo não
			deriva com tempo porque qualquer extensão futura DEVE
			passar pela disciplina compilation (extensão arbitrária
			seria glossary-violation visível).

			**RISCO RESIDUAL ÚNICO ENDEREÇADO** (founder lint):
			Ambiguidade temporal dupla (issuedAt entity vs
			eventTimestamp event) — endereçada em 2 níveis no outer
			rationale do domain-model: (a) explicação preventiva +
			(b) **REGRA NORMATIVA upgraded** ('qualquer invariant ou
			predicate que referencie eventTimestamp é INVÁLIDO por
			definição do domínio'). Forma normativa preserva a
			disambiguação como inviolável-by-design — não como
			convenção opcional.

			**ANTI-MINI BOUNDARY PRESERVATION** (transversal):
			- reasonCode: string (não enum no type) — taxonomia em
			  policy/regime/adapter (anti-mini-ATO)
			- cancellationWindow: função pura externa ao domínio —
			  domínio usa, não define (anti-orchestrator +
			  anti-procedural-leakage)
			- Receivable como entity interna sem autonomia
			  (anti-mini-SCF — transferibilidade decidida por SCF)
			- Lifecycle 2 estados fechado (anti-mini-FCE — paid não
			  existe)
			- Projection derivada não autoritativa
			  (anti-runtime-coupling — replay-safe sem cache fallback)

			**SCHEMA SATISFAÇÃO** (tq-dm-XX por inspeção):
			tq-dm-01 (todo command handled por exatamente 1 aggregate:
			cmd-issue-invoice + cmd-cancel-invoice ambos em
			agg-invoice.handlesCommands) ✓
			tq-dm-02 (todo event emitted por ≥1 aggregate: 3 events em
			agg-invoice.emitsEvents) ✓
			tq-dm-03+ (refs internos válidos: VOs/events/commands/
			invariants codes consistentes) ✓ via cue vet
			tq-dm-XX (lifecycle states + transitions internamente
			consistentes; states 'issued'+'cancelled' definidos +
			initialState='issued' válido + transition issued→cancelled
			referencia cmd-cancel-invoice + emits evt-invoice-cancelled
			+ guard inv-cancellation-boundary) ✓ via cue vet

			cue vet ./contexts/inv/ EXIT=0; cue vet ./... EXIT=0.

			**PHASE 0 LIMITATIONS HONEST**:
			- cancellationWindow(regimeVersion) função externa — Phase
			  0 lookup tabela declarativa; Phase 1+ multi-jurisdictional
			  adapter per oq-inv-4 canvas
			- Projection prj-invoice-by-identity é Phase 1+ optimization;
			  Phase 0 idempotency check via aggregate state direct
			- Cross-BC event consumption é canvas/agent territory
			  (não modelado em domain-model — paralelo DLV)
			- 4 forward-refs declarados (Phase 4 agent-spec; Phase 5
			  envelope; Phase 1+ adapter SEFAZ; Phase 1+ regime adapter
			  multi-jurisdictional)

			Domain Model INV é agora COMPILAÇÃO formalmente verificável
			do glossary — não design livre. Boundary fechado por
			construção; qualquer regra futura que NÃO encaixa no modelo
			NÃO pertence ao INV (anti-drift estrutural).

			**Próximo nível** (Phase 3.5 — fora do scope deste SRR):
			structural enforcement transformará invariants em checks
			executáveis + guards em gates reais + anti-patterns em
			bloqueios formais. Após Phase 3.5, sistema deixa de
			depender de disciplina do agente — vira inviolável por
			construção.
			"""
	}]

	findings: {}

	summary: """
		Domain Model INV materializado em 4 commits Phase 3 (Part 1
		catalogs + skeleton 4e95f15; Part 2 wiring + projection +
		outer rationale edc7a20; temporal disambiguation 3dee397;
		temporal upgrade normativo). Composição: 3 events + 2 commands
		+ 8 invariants + 8 valueObjects + 1 aggregate (root Invoice +
		entity interna Receivable + lifecycle {issued, cancelled}) +
		1 projection internal + 0 policies. Founder lint architectural
		validation PASSED em 8 checks: (L1) aggregate integrity 🟢;
		(L2) lifecycle closure 🟢; (L3) invariants 4-pillars 🟢;
		(L4) projection derivada não autoritativa 🟡 com observação;
		(L5) commands limpos 🟢; (L6) events sem leak temporal 🟡 → 🟢
		upgraded via REGRA NORMATIVA ('qualquer invariant ou predicate
		referenciando eventTimestamp é INVÁLIDO por definição do
		domínio'); (L7) zero policies (anti-orchestrator) 🟢; (L8)
		glossary→model fidelity 🟢. Risco temporal duplo (issuedAt vs
		eventTimestamp) endereçado em forma normativa inviolável-by-
		design. Anti-mini boundary preservation transversal. tq-dm-XX
		satisfeitos via cue vet. Compilation determinística do
		glossary — extensão arbitrária seria glossary-violation
		visível.
		"""

	singleRoundRationale: """
		Authoring manual incremental section-by-section + part-by-part
		(2 parts founder pattern para reduzir blast radius cue vet) +
		founder lint architectural validation pre-SRR (8 checks
		PASSED + 2 yellow alerts endereçados) + temporal
		disambiguation upgrade normativo per founder lint final.
		Founder review iterativo aplicou ajustes em cada part: 5
		ajustes Part 1 finais (reasonCode → string; cancellationWindow
		→ declarativa; eventTimestamp uniforme; appendOnlyEventLog
		removido; invariant 8 reduzido) + 4 founder checks Part 2
		satisfeitos (aggregate integrity; lifecycle closure;
		projection não autoritativa; sem policy cross-BC). Pushback
		bilateral em Part 1 mecânicas: refs strings simples (não
		structs); PrimitiveType enum strict (datetime not timestamp;
		decimal not number); rootIdentity struct {kind,
		valueObjectRef}; usesValueObjects strings (não structs).
		Round único suficiente — qualidade incorporada via founder
		review iterativo durante composição (ANTES dos commits).
		Founder lint architectural validation post-Part 2 (8 checks)
		fornece prova estrutural pre-SRR — SRR é ratification de
		validação já passada, não validação inicial. Forma normativa
		do risco temporal (upgrade pre-SRR commit) elimina path para
		justificar exceção futura — proibição por construção
		semântica.
		"""
}
