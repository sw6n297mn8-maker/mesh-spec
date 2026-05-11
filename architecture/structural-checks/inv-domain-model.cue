package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// inv-domain-model.cue — Structural checks para INV domain-model.
// Per ADR-080: kind 'domain-invariant' unifica filesystem +
// semantic enforcement. 8 invariants do contexts/inv/domain-model.cue
// declarados como garantias com limites explícitos (runtime-gap
// canonicalmente declarado quando runtimeRequired=true).
//
// Phase 3.5 do WI-053 INV bootstrap. Materializa princípio
// 'declaração de garantia + declaração explícita de limite' —
// honesty arquitetural por construção. Runtime gaps NÃO são
// falhas; são limites conhecidos e documentados do sistema.
//
// Coverage distribution (8 checks):
// - 1 fully build-time (lifecycle-states via CUE enum constraint)
// - 5 com runtime-gap declarado canonicamente (atomic-dual-emission,
//   idempotent-issuance, regime-immutability, cancellation-boundary,
//   fiscal-doc-ref-integrity)
// - 5 com validation-time advisory (regime-immutability, lifecycle-
//   states, fiscal-doc-ref-integrity, cancellation-event-required,
//   receivable-referential-integrity)
//
// Forbidden patterns são state/property prohibitions (não actions —
// per founder lint pre-write: forbidden é proibição de ESTADO ou
// PROPRIEDADE, não de ação procedural; previne reintrodução de
// orchestration implícita).
//
// DISCAP RETROACTIVE PATCH (WI-077; per adr-086 + PG patch WI-076):
// Adicionado layer declarations + war-game evidence em 8 rules
// (pre-DISCAP authoring — INV antecedeu meta-template level-2
// emergent em REW Phase 3.5a). Cada rule declara applicable layers
// + non-applicable rationale compacto + RE-VAL flag + war-game
// pre-production failure mode articulado.
//
// Behavioral non-applicability discipline (per adr-086 D6):
// INV domain-model 8 invariants são TODAS structurally enforceable
// (com runtime gaps declarados onde aplicável); NENHUMA é behavioral
// pura (architectural review OR anti-corruption discipline). Contraste
// arquitetural com REW (semanticamente contextual/adversarial-heavy
// com 2 behavioral invariants explicit non-applicable): INV é quase
// totalmente structural-local — demonstra que progressive ladder per
// adr-086 D2 é genuinamente seletivo, não checklist rígido.

structuralChecks: "sc-inv-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-01"
	title:        "Atomic Dual Emission domain invariant"
	artifactType: "domain-model"
	description: """
		Invoice e Receivable devem coexistir como par 1:1 com referência integral (Receivable.invoiceId aponta para Invoice válida) + amount + currency coincidentes (BD7). Violação seria Invoice sem Receivable correspondente, Receivable órfã, múltiplos Receivables paired ao mesmo Invoice, OR amount/currency divergentes.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: Invoice + Receivable both materialized
		- L2 CROSS-FIELD: cardinality 1:1 + amount/currency coincidence

		Layers non-applicable: L2.5, L3, L4, L5, L6, L7
		Non-applicability rationale: invariant é structural-local cardinality + value coincidence; sem semantic adoption binding, sem contract resolution requirement, sem version dependency, sem temporal aging, sem interpretation step, sem decision context scaling.

		RE-VAL: N/A (atomic invariant timeless; não evolui ao longo do tempo).

		War-game evidence (per adr-086 D5):
		Outbox bypass — direct DB write to Invoice sem paired Receivable insert via maintenance script OR DBA convenience; transactional outbox guarantee bypassed; consumer SCF vê Invoice referenced com receivable=null causando antecipation fail mid-pipeline + audit trail divergence cross-BC.
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-atomic-dual-emission"
		assertion: """
			∀ invoiceId:
			  exists Invoice(invoiceId)
			    ⇒ exists Receivable(r) where r.invoiceId == invoiceId
			∧ ∀ receivableId:
			    exists Receivable(receivableId)
			      ⇒ exists Invoice(Receivable.invoiceId)
			∧ ∀ invoiceId:
			    count(Receivable where Receivable.invoiceId == invoiceId) == 1
			∧ Invoice.amount == Receivable.amount
			    (where Invoice.invoiceId == Receivable.invoiceId)
			∧ Invoice.currency == Receivable.currency
			    (where Invoice.invoiceId == Receivable.invoiceId)
			"""
		coverage: {
			buildTime:       false
			validationTime:  false
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Atomicidade entre dois eventos não verificável em build-time ou validação estática — requer garantia de execução transactional. Falha implica estado impossível no domínio: Invoice sem Receivable, Receivable sem Invoice, múltiplos Receivables por Invoice, OR divergence amount/currency entre par."
			enforcedBy:  "infrastructure transactional outbox primitive (atomic emit guarantee at event publication boundary)"
		}
		forbidden: [
			"Invoice exists without corresponding Receivable",
			"Receivable exists without corresponding Invoice",
			"multiple Receivables paired to same Invoice",
			"amount mismatch between Invoice and paired Receivable",
			"currency mismatch between Invoice and paired Receivable",
		]
	}
	errorMessage: "domain-invariant inv-atomic-dual-emission: violação detectada — Invoice e Receivable devem coexistir 1:1 com amount + currency idênticos (BD7). Verifique enforcedBy layer (transactional outbox primitive)."
	rationale:    "Materializa BD7 atomic-dual-emission. Cardinalidade 1:1 explícita em assertion (anti-ambiguidade). Atomicidade lógica é propriedade do domínio (declarada como contract); mecanismo de garantia é responsabilidade da infrastructure (fora do escopo build-time)."
}

structuralChecks: "sc-inv-02": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-02"
	title:        "Idempotent Issuance domain invariant"
	artifactType: "domain-model"
	description: """
		Tupla (commitmentRef, evidenceRef) define unicidade canônica do fato no domínio. Identity NÃO inclui criteriaVersion nem regimeVersion — versions são attributes, não componentes de unicidade (BD3). Violação seria duas Invoices distintas sob mesma tupla.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: commitmentRef + evidenceRef present
		- L2 CROSS-FIELD: unicity constraint per tuple
		- L3 RESOLVABLE CONTRACT: tuple AS canonical identity (não technical key UUID)

		Layers non-applicable: L2.5, L4, L5, L6, L7
		Non-applicability rationale: invariant é identity-unicity discipline; versions são attributes (não identity components per design); sem adoption proof, freshness drift, interpretation step, decision context scaling.

		RE-VAL: N/A (unicity discipline timeless; não evolui).

		War-game evidence (per adr-086 D5):
		Replay attack — mesmo evidence document submetido via diferentes intake paths (ex.: API + email gateway + manual ingestion); sem tuple-based unicity enforcement em ponto de persistência, múltiplas Invoices materializadas + Receivables duplicados + audit trail polluído + downstream SCF antecipation duplicate.
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-idempotent-issuance"
		assertion: """
			∀ (commitmentRef, evidenceRef):
			  count(Invoice where
			    Invoice.commitmentRef == commitmentRef
			    ∧ Invoice.evidenceRef == evidenceRef
			  ) ≤ 1
			∧ identity(Invoice) does not include regimeVersion or criteriaVersion
			"""
		coverage: {
			buildTime:       false
			validationTime:  false
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Unicidade depende de event log query OR database constraint runtime — não verificável em build-time. Identity como condição semântica de unicidade do fato no domínio (não chave técnica) requer enforcement em ponto de persistência/emissão."
			enforcedBy:  "database unique constraint on (commitmentRef, evidenceRef) OR event log dedup ancorado em identity tuple"
		}
		forbidden: [
			"two Invoice instances with same (commitmentRef, evidenceRef) tuple",
			"Invoice identity dependent on criteriaVersion or regimeVersion",
			"Invoice identity based on technical key (UUID) instead of canonical tuple",
			"Invoice instances differing in regimeVersion sharing identity tuple",
		]
	}
	errorMessage: "domain-invariant inv-idempotent-issuance: duas Invoices distintas sob mesma tupla (commitmentRef, evidenceRef). Identity é canônica e única — verifique constraint de unicidade no enforcedBy layer."
	rationale:    "Materializa BD3 issuance-idempotent. Não-dependência de versions explícita em assertion (anti-reintrodução de regimeVersion/criteriaVersion como identity components). Runtime gap explícito porque event log uniqueness é runtime concern."
}

structuralChecks: "sc-inv-03": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-03"
	title:        "Regime Immutability domain invariant"
	artifactType: "domain-model"
	description: """
		regimeVersion + amount + currency são write-once por Invoice (BD2). Bump de version aplica-se a invoices futuras, NUNCA a invoices históricas.

		Layers ativos (per adr-086 D2):
		- L4 VERSIONED: regimeVersion frozen post-creation; bump aplica apenas a Invoices futuras
		- L7 DECISION CONTEXT: qual versão regulatória governou a decisão fiscal histórica DEVE permanecer reconstruível (decision context preservation per founder ajuste)

		Layers non-applicable: L1, L2, L2.5, L3, L5, L6
		Non-applicability rationale: presence + cross-field cobertos em sc-inv-01/02; sem adoption proof binding, contract resolution discipline, freshness drift (immutability é timeless), interpretation step.

		RE-VAL: Yes — periodic audit re-evaluates regimeVersion immutability em snapshots históricos detectando retroactive regime modification.

		War-game evidence (per adr-086 D5):
		Regulatory change — new regimeVersion activated por compliance update; sem immutability discipline, Invoices históricas auto-updated to new regime via 'helpful' migration script; NF-e ≥5yr retention audit fails porque historical regime context perdido; defesa regulatória em fiscalização impossível.
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-regime-immutability"
		assertion: """
			∀ invoiceId:
			  Invoice.regimeVersion is write-once post-creation
			∧ Invoice.amount is write-once post-creation
			∧ Invoice.currency is write-once post-creation
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Build-time não vê histórico de Invoice — não detecta mutação pós-criação. Validation-time pode detectar via lint script comparando snapshots; runtime requer enforcement de write-once em layer de persistência."
			enforcedBy:  "persistence layer write-once constraint (database immutable column OR event-sourced append-only) + validation-time lint comparing historical snapshots"
		}
		forbidden: [
			"Invoice.regimeVersion mutated post-creation",
			"Invoice.amount mutated post-creation",
			"Invoice.currency mutated post-creation",
			"historical Invoice records modified to reflect new regimeVersion",
		]
	}
	errorMessage: "domain-invariant inv-regime-immutability: mutação detectada em regimeVersion/amount/currency de Invoice existente. Estes fields são write-once — mudanças aplicam apenas a invoices futuras via novo InvoiceIssued."
	rationale:    "Materializa BD2 deterministic-fiscal-projection. Coverage corrigida pre-write per founder lint: build-time não vê histórico (não pode detectar mutation); validation-time + runtime cobrem via persistence layer + lint snapshot comparison."
}

structuralChecks: "sc-inv-04": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-04"
	title:        "Lifecycle States domain invariant"
	artifactType: "domain-model"
	description: """
		Invoice.status pertence ao enum {issued, cancelled} apenas (BD5). Sem transição para qualquer outro estado.

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: status field populated
		- L2 CROSS-FIELD: enum membership constraint
		- L6 DECISION↔INTERPRETATION COHERENCE: lifecycle semantics não admitem interpretação divergente entre consumers (app A trata 'pending' como aceito; app B ignora; app C converte para issued — coherence breaks downstream decisioning)

		Layers non-applicable: L2.5, L3, L4, L5, L7
		Non-applicability rationale: invariant é structural-local enum + interpretation coherence; sem adoption proof binding, contract resolution discipline, version dependency (enum é timeless), freshness drift, decision context scaling.

		RE-VAL: N/A (state machine fechada; enum é constante).

		War-game evidence (per adr-086 D5):
		State introduction — application code adiciona estado intermediário ('pending', 'draft', 'amended') silently para handling de edge case operacional; consumer SCF vê Invoice com status desconhecido + behavior divergente (treat as issued / treat as cancelled / skip); cascade integration breaks; reconciliation diverge silently entre CMT/SCF/REW.
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-lifecycle-states"
		assertion: """
			∀ invoiceId:
			  Invoice.status ∈ {issued, cancelled}
			∧ no transition exists to any other state
			"""
		coverage: {
			buildTime:       true
			validationTime:  true
			runtimeRequired: false
		}
		forbidden: [
			"Invoice.status outside enum {issued, cancelled}",
			"Invoice transitioned from issued to state other than cancelled",
			"Invoice with intermediate states (pending, processing, paid, reversed, draft, amended)",
		]
	}
	errorMessage: "domain-invariant inv-lifecycle-states: Invoice.status fora do enum canônico {issued, cancelled}. Lifecycle é fechado por construção — paid é FCE concern; pending/processing/reversed são DRC/ATO concerns; draft é integration concern."
	rationale:    "Materializa BD5 lifecycle 2 estados. State machine fechada via CUE enum constraint + lifecycle.states declared. Único check fully build-time (CUE valida enum estaticamente)."
}

structuralChecks: "sc-inv-05": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-05"
	title:        "Cancellation Boundary domain invariant"
	artifactType: "domain-model"
	description: """
		Cancellation INV-owned APENAS dentro de janela fiscal regulada via cancellationWindow(regimeVersion). Pós-cancel, Invoice fields são imutáveis (BD5 + G3).

		Layers ativos (per adr-086 D2):
		- L3 RESOLVABLE CONTRACT: cancellationWindow lookup by regimeVersion depende de authoritative versioned regime registry external (ATO/CMT BC owns regime definition; INV resolves at decision time)
		- L4 VERSIONED: cancellationWindow é função de regimeVersion frozen at Invoice creation
		- L5 FRESHNESS HEURISTIC: within-window temporal check ((cancelledAt - issuedAt) ≤ window)
		- L7 DECISION CONTEXT: cancellation decision scope (per-Invoice; respect to regime-defined window) + magnitude (regulatory boundary breach is HARD)

		Layers non-applicable: L1, L2, L2.5, L6
		Non-applicability rationale: presence + cardinality cobertos em sc-inv-01/04; sem adoption proof binding; sem interpretation coherence step (cancellation é declarative state transition not interpretive).

		RE-VAL: Yes — replay engine + periodic audit catches out-of-window cancellation patterns post-hoc; cross-BC sync com ATO regime updates valida cancellationWindow resolution remains consistent.

		War-game evidence (per adr-086 D5):
		Mini-ATO stealth — developer convenience adicionando cancellationWindow calculation inline dentro de INV (ao invés de chamada à regime/policy authority externa); regime updates exigem coordinating com ATO BC; mini-ATO inline fragments authoritative regime regulation + INV BC absorve responsabilidade que pertence ao ATO domain; future regime updates desincronizadas + audit trail divergence.
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-cancellation-boundary"
		assertion: """
			∀ invoiceId:
			  Invoice.status == cancelled
			    ⇒ Invoice was previously issued (state history shows issued before cancelled)
			∧ Invoice.status == cancelled
			    ⇒ no further mutation allowed on Invoice fields
			∧ Invoice.status == cancelled
			    ⇒ (cancelledAt - issuedAt) ≤ cancellationWindow(regimeVersion)
			"""
		coverage: {
			buildTime:       false
			validationTime:  false
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Within-window check depende de tempo runtime atual + regimeVersion lookup — não verificável em build-time. Ordering (cancelled implies previously issued) requer event log history. Pós-cancel immutability requer mutation prevention runtime."
			enforcedBy:  "application layer guard pre-cancel (cancellationWindow é pure function externa de regime/policy layer; INV usa, não define — protege contra implementação inline = mini-ATO stealth) + event log temporal ordering verification"
		}
		forbidden: [
			"Invoice.status == cancelled with no preceding issued state in history",
			"Invoice fields mutated after status == cancelled",
			"Invoice.status == cancelled with (cancelledAt - issuedAt) > cancellationWindow(regimeVersion)",
			"Invoice cancelled without paired InvoiceCancelled event",
		]
	}
	errorMessage: "domain-invariant inv-cancellation-boundary: cancellation tentada fora da janela fiscal OR mutação pós-cancel detectada OR ordering violation. Cancellation só dentro de cancellationWindow(regimeVersion); pós-window é DRC/ATO scope."
	rationale:    "Materializa BD5 + G3. cancellationWindow é pure function externa ao domínio (regime/policy layer responsibility); INV usa, não define — protege contra implementação inline (mini-ATO stealth). Runtime gap explícito porque temporal check + ordering requerem event log + tempo atual."
}

structuralChecks: "sc-inv-06": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-06"
	title:        "Fiscal Document Reference Integrity domain invariant"
	artifactType: "domain-model"
	description: """
		Toda Invoice tem fiscalDocRef non-empty + write-once post-creation (cc-04 audit trail regulatory-grade).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: fiscalDocRef non-empty
		- L4 VERSIONED: write-once post-creation (no mutation allowed)

		Layers non-applicable: L2, L2.5, L3, L5, L6, L7
		Non-applicability rationale: invariant é structural presence + write-once discipline; sem cross-field coherence (referência standalone); sem adoption proof binding, contract resolution, freshness drift, interpretation step, decision context scaling.

		RE-VAL: N/A (write-once é immutability discipline; não evolui).

		War-game evidence (per adr-086 D5):
		Replacement scenario — operational mistake fixing typo no fiscalDocRef via UPDATE direto OR script de migration; NF-e audit trail broken (≥5yr retention requires immutable reference); fiscalização Bacen/Receita identifica gap; compliance exposure + sanção regulatória.
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-fiscal-doc-ref-integrity"
		assertion: """
			∀ invoiceId:
			  exists Invoice(invoiceId)
			    ⇒ Invoice.fiscalDocRef is non-empty
			∧ Invoice.fiscalDocRef is write-once post-creation
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Build-time não vê histórico — não detecta mutação pós-criação de fiscalDocRef. Non-empty constraint é validação statica; write-once requer enforcement runtime."
			enforcedBy:  "persistence layer write-once constraint on fiscalDocRef field + validation-time check non-empty na criação"
		}
		forbidden: [
			"Invoice with fiscalDocRef null or empty string",
			"Invoice.fiscalDocRef mutated post-creation",
			"Invoice.fiscalDocRef replaced by new identifier post-association",
		]
	}
	errorMessage: "domain-invariant inv-fiscal-doc-ref-integrity: Invoice sem fiscalDocRef OR mutação detectada. Reference é canonical para audit trail regulatory-grade (≥5 anos NF-e); non-empty obrigatório + write-once absoluto."
	rationale:    "Materializa cc-04 audit trail regulatory-grade. Coverage corrigida pre-write per founder lint — non-empty é validation-time; write-once é runtime (persistence layer)."
}

structuralChecks: "sc-inv-07": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-07"
	title:        "Cancellation Event Required domain invariant"
	artifactType: "domain-model"
	description: """
		Invoice.status==cancelled implica existência de InvoiceCancelled event correspondente (G3 explicit-event-only — sem soft-delete).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: InvoiceCancelled event existe no event log para invoiceId cancelled
		- L2 CROSS-FIELD: status→event consistency (status=cancelled ⇒ event existe)
		- L3 RESOLVABLE CONTRACT: event log reference resolution (cancellation reconstrutível via event audit)

		Layers non-applicable: L2.5, L4, L5, L6, L7
		Non-applicability rationale: invariant é state-event consistency + event log resolution; events são immutable records (não versioned); sem adoption proof binding, freshness drift, interpretation step, decision context scaling.

		RE-VAL: Yes — periodic audit catches state-event mismatches via cross-instance lint comparing Invoice.status com event log entries.

		War-game evidence (per adr-086 D5):
		Soft-delete — DBA convenience flips Invoice.status=cancelled directly em DB para handling 'duplicada' (no UI ticket request) skipping event emission; consumers downstream (SCF/REW) não veem InvoiceCancelled event; SCF continua antecipando receivable invalida; reconciliation diverge silently entre INV state + event log + downstream BCs.
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-cancellation-event-required"
		assertion: """
			∀ invoiceId:
			  Invoice.status == cancelled
			    ⇒ exists InvoiceCancelled(invoiceId) in event log
			∧ Invoice record persists post-cancellation (no deletion)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: true
		}
		runtimeGap: {
			description: "Existência de InvoiceCancelled event para invoiceId cancelled requer event log query — não verificável em build-time. Append-only persistence (no deletion) requer storage guarantee runtime."
			enforcedBy:  "event log + persistence layer (append-only constraint + state-event consistency check via lint cross-instance + runtime audit)"
		}
		forbidden: [
			"Invoice.status == cancelled without paired InvoiceCancelled event in log",
			"Invoice record absent post-cancellation (deleted instead of status-marked)",
			"InvoiceIssued event mutated silently (overwrite)",
			"Invoice.status flipped to cancelled without event emission",
		]
	}
	errorMessage: "domain-invariant inv-cancellation-event-required: Invoice cancelled sem InvoiceCancelled event correspondente OR Invoice record removido. G3 exige sempre evento explícito + entity record persiste com lineage completo."
	rationale:    "Materializa G3 cancellation explicit-event-only. Validation-time advisory cross-instance + runtime gap canonical (event log query)."
}

structuralChecks: "sc-inv-08": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-08"
	title:        "Receivable Referential Integrity domain invariant"
	artifactType: "domain-model"
	description: """
		Toda Receivable referencia Invoice válida via invoiceId (não há Receivable órfã).

		Layers ativos (per adr-086 D2):
		- L1 PRESENCE: Receivable + Invoice both exist
		- L2 CROSS-FIELD: Receivable.invoiceId resolves to existing Invoice
		- L3 RESOLVABLE CONTRACT: referential integrity (FK-style discipline)

		Layers non-applicable: L2.5, L4, L5, L6, L7
		Non-applicability rationale: invariant é structural referential integrity; sem adoption proof binding, version dependency, freshness drift, interpretation step, decision context scaling.

		RE-VAL: N/A (referential integrity timeless; não evolui).

		War-game evidence (per adr-086 D5):
		Orphan Receivable — Invoice deletada (hard delete via DBA operação OR migration script) ao invés de soft-cancelled per sc-inv-07; Receivable still references non-existent invoiceId; SCF tenta antecipate receivable órfã; integration breaks + financial loss exposure (antecipação sobre invoice inexistente).
		"""
	kind:         "domain-invariant"
	rule: {
		invariantId: "inv-receivable-referential-integrity"
		assertion: """
			∀ receivableId:
			  exists Receivable(receivableId)
			    ⇒ exists Invoice(Receivable.invoiceId)
			"""
		coverage: {
			buildTime:       false
			validationTime:  true
			runtimeRequired: false
		}
		forbidden: [
			"Receivable with invoiceId pointing to non-existent Invoice",
			"Receivable orphaned without paired Invoice",
			"Receivable.invoiceId mutated post-creation",
		]
	}
	errorMessage: "domain-invariant inv-receivable-referential-integrity: Receivable referencia Invoice inexistente OR órfã detectada. Receivable é entity interna do InvoiceAggregate; invoiceId deve apontar para Invoice válida."
	rationale:    "Materializa receivable referential integrity (distinto de inv-atomic-dual-emission que cobre amount/currency + cardinalidade). Coverage corrigida pre-write per founder lint — depende de instâncias (não só schema), portanto validation-time check (lint cross-instance), não build-time."
}
