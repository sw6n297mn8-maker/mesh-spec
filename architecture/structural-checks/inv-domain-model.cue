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

structuralChecks: "sc-inv-01": artifact_schemas.#StructuralCheck & {
	id:           "sc-inv-01"
	title:        "Atomic Dual Emission domain invariant"
	artifactType: "domain-model"
	description:  "Invoice e Receivable devem coexistir como par 1:1 com referência integral (Receivable.invoiceId aponta para Invoice válida) + amount + currency coincidentes (BD7). Violação seria Invoice sem Receivable correspondente, Receivable órfã, múltiplos Receivables paired ao mesmo Invoice, OR amount/currency divergentes."
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
	description:  "Tupla (commitmentRef, evidenceRef) define unicidade canônica do fato no domínio. Identity NÃO inclui criteriaVersion nem regimeVersion — versions são attributes, não componentes de unicidade (BD3). Violação seria duas Invoices distintas sob mesma tupla."
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
	description:  "regimeVersion + amount + currency são write-once por Invoice (BD2). Bump de version aplica-se a invoices futuras, NUNCA a invoices históricas."
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
	description:  "Invoice.status pertence ao enum {issued, cancelled} apenas (BD5). Sem transição para qualquer outro estado."
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
	description:  "Cancellation INV-owned APENAS dentro de janela fiscal regulada via cancellationWindow(regimeVersion). Pós-cancel, Invoice fields são imutáveis (BD5 + G3)."
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
	description:  "Toda Invoice tem fiscalDocRef non-empty + write-once post-creation (cc-04 audit trail regulatory-grade)."
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
	description:  "Invoice.status==cancelled implica existência de InvoiceCancelled event correspondente (G3 explicit-event-only — sem soft-delete)."
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
	description:  "Toda Receivable referencia Invoice válida via invoiceId (não há Receivable órfã)."
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
