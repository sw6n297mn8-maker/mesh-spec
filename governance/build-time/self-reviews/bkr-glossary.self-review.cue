package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bkrGlossary: build_time.#SelfReviewReport & {
	reportId: "srr-bkr-glossary"

	artifactPath:       "contexts/bkr/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-12"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Glossário BKR Phase 2 do WI-062 BKR bootstrap. Materializa
			UL canônica de execução técnica de settlement sob intenção
			econômica autorizada upstream. Authoring manual per
			manualAuthoringProtocol (adr-057) section gates seguindo
			workOrder do PG glossary.cue (context-and-term-identification
			→ term-content-and-anchoring → validation-and-meta).
			Cascade ordering per adr-053/adr-054: schema #Glossary
			existe; PG glossary existe; canvas BKR Phase 1 stable
			(srr-bkr-canvas closure em f6dfc69); domain-model BKR
			Phase 3 ainda não existe (domainModelRefs vazios em todos
			os 15 termos — preenchimento incremental quando Phase 3
			materializar building blocks).

			15 termos canônicos cobrindo 5 categorias semânticas
			(entity 1 / value 9 / process 4 / rule 1):

			Identity gateway:
			- term-payment-instruction (value, FCE-originated DTO)
			- term-authorization-proof (value, cryptographic evidence)

			Settlement lifecycle entity + states:
			- term-settlement-attempt (entity, BKR-owned per execução)
			- term-settlement-finality (value, canonical assertion
			  post-Reconciliation com proof)
			- term-settlement-indeterminate (value, epistemic non-
			  final state)
			- term-reconciliation (process, deterministic match
			  producing trichotomic outcome)

			4-way ID separation (anti-replay / anti-double-settlement
			core):
			- term-instruction-id (value, FCE-owned business
			  correlation)
			- term-attempt-id (value, BKR-owned per execution)
			- term-idempotency-key (value, BKR-constructed enforcement)
			- term-rail-reference-id (value, rail-owned external)

			Rail selection + windows + classification:
			- term-technical-rail-selection (process, 4 critérios
			  estritamente técnicos, anti-economic-optimization)
			- term-operational-window (value, per-rail availability
			  constraint)
			- term-failure-classification (process, 5 categorias com
			  ownership causal)

			Boundary normativa:
			- term-regulatory-boundary (rule, BKR consumes regulatory
			  constraints, does not enforce)
			- term-reverse-settlement (process, NOT BKR-owned;
			  upstream-authorized execution only)

			Phase 2 materializada via authoring section-gated em 3
			batches pre-write (Phase 2.2.B Batch 1 settlement
			lifecycle core / Batch 2 identity lineage / Batch 3
			boundary normativa) + Phase 2.2.A pattern validation com
			3 termos exemplares (PaymentInstruction, SettlementFinality,
			TechnicalRailSelection). Founder iterative review aplicou
			16 ajustes totais pre-write: 5 ajustes finos Phase 2.2.A
			(SettlementFinality definition harden / PaymentInstruction
			AuthorizationProof clause / TechnicalRailSelection latency
			admissibility / SettlementInstruction rejected reason
			refinement / Rail Finality multi-rail clarification) + 4
			ajustes Batch 1 (SettlementAttempt new dispatch wording /
			SettlementIndeterminate antiTerm Finality / Reconciliation
			antiTerm Dispatch / AuthorizationProof technically
			admissible) + 3 ajustes Batch 2 (InstructionId no-rail-
			knowledge / IdempotencyKey new dispatch wording /
			RailReferenceId 0..N cardinality) + 4 ajustes Batch 3
			(FailureClassification provider-or-rail-reject with 4
			subtypes / RegulatoryBoundary no regulatory authority
			clause / ReverseSettlement antiTerm Correction /
			OperationalWindow Pix window-closed phrasing).

			Densidade adversarial: ~73 antiTerms entries / ~50
			rejectedAlternatives / 36 examples distribuídos pelos 15
			termos. ReverseSettlement com 8 antiTerms (max force —
			vector #1 de scope creep BKR→DRC/FCE/treasury).

			Cross-anti-collapse matrix dos 4 IDs completa: cada um dos
			InstructionId / AttemptId / IdempotencyKey / RailReferenceId
			carrega antiTerm explícito contra os outros 3, formando
			matriz 4×3 = 12 anti-collapse pares (preserva separation
			por ownership × granularidade × direção de fluxo).

			Cobertura dos 5 anti-termos centrais (founder gate
			principal):
			- Pagamento (Payment): PaymentInstruction, SettlementAttempt,
			  AuthorizationProof, InstructionId, ReverseSettlement
			- Liquidação (Settlement genérico): SettlementAttempt,
			  Reconciliation, SettlementFinality, RailReferenceId,
			  ReverseSettlement
			- Dispatch: PaymentInstruction, SettlementAttempt,
			  Reconciliation, AttemptId, ReverseSettlement
			- Confirmation: SettlementFinality, Reconciliation,
			  SettlementAttempt, SettlementIndeterminate, AttemptId
			- Finality: SettlementFinality, SettlementIndeterminate,
			  ReverseSettlement

			Schema satisfação tq-gl-XX verificada por inspeção
			transversal + cue vet:
			- tq-gl-01 (code único): 15 codes únicos ✓
			- tq-gl-02 (relatedTerms refs intra-glossary): todas as
			  refs em terms[].relatedTerms[] existem em terms[].code
			  do mesmo glossário ✓
			- tq-gl-03 (domainModelRefs prefixos válidos): N/A — todos
			  os terms têm domainModelRefs vazio em Phase 2;
			  preenchimento incremental Phase 3+
			- tq-gl-04 (cobertura aggregates): N/A — domain-model
			  não existe; warn skipped
			- tq-gl-05 (definition não-redundante): cada definition
			  ≥ 200 runes substantiva, distinta de name e synonyms
			  (synonyms NÃO usado) ✓
			- tq-gl-06 (antiTerms não repetem terms): inspeção
			  transversal — nenhum antiTerm.term coincide com
			  terms[].name no glossário ✓
			- tq-gl-07 (boundedContextRef alinha com canvas):
			  boundedContextRef "bkr" === canvas.code "bkr" ✓
			- tq-gl-08 (self-reference): nenhum term referencia
			  próprio code em relatedTerms ✓
			- tq-gl-09 (ancoragem semântica ≥1): cada term declara
			  examples + antiTerms + relatedTerms (3+ anchors típico,
			  muito acima do mínimo 1) ✓
			- tq-gl-10 (layerMapping não-vazio quando presente):
			  todos os 15 terms com layerMapping declaram codeTerm
			  (≥1 campo não-vazio) ✓
			- tq-gl-11 (termEn semanticamente adequado): termEn
			  preserva intenção operacional + ressoa com domain
			  literature (HTTP Idempotency-Key / ISO 20022 / Bacen
			  operational hours / SWIFT MX) ✓
			- tq-gl-12 (termEn único): 15 termEn únicos ✓
			- tq-gl-13 (name único): 15 names únicos (mix pt-BR
			  conversational form e PascalCase para IDs) ✓

			Quality gate guide PG tq-gg-XX satisfeito:
			- tq-gg-01 unicidade dos 3 campos (code/name/termEn): ✓
			- tq-gg-02 ancoragem semântica per term (≥1 entre
			  examples/antiTerms/relatedTerms/domainModelRefs;
			  synonyms e rejectedAlternatives NÃO contam): 3+ anchors
			  por term em média (max 4 anchors em payment-instruction
			  com examples+antiTerms+relatedTerms+layerMapping) ✓
			- tq-gg-03 definitions não-redundantes: cada definition
			  substantiva e operacional; nenhuma circular ✓
			- tq-gg-04 rejectedAlternatives substantivos: 50 entries
			  com (a) alternativa, (b) razão de rejeição, (c) motivo
			  da escolha canônica articulado ✓

			Lenses ativadas (5) articuladas no outer rationale:
			- lens-domain-language-and-terminology-design (primária):
			  bilingual mapping pt-BR/en com regex satisfeitos; term
			  selection criteria via 50 rejectedAlternatives; cross-
			  layer consistency via layerMapping conservador (codeTerm
			  sempre; apiTerm quando endpoint claro; uiLabel omitido
			  Phase 0)
			- lens-regulatory-compliance-as-architecture: term-
			  regulatory-boundary explícita 'RegulatoryBoundary
			  constrains BKR behavior but does not grant BKR regulatory
			  authority'; FailureClassification subtype provider-or-
			  rail-reject preserva account-status / rail-limit /
			  provider-policy distinct de regulatory
			- lens-distributed-systems-design: 4-way ID separation
			  formal + cross-anti-collapse matrix; atomic state
			  machine per attempt cristalizado em SettlementAttempt
			  definition; reconciliation determinism em Reconciliation
			  com 4 condições + trichotomic outcome
			- lens-trust-and-credibility-design: AuthorizationProof
			  com 5 componentes cryptographic; 'BKR consumes
			  authorization semantics; it does not originate them' é
			  axioma constitutivo
			- lens-mechanism-design: anti-decision boundary
			  cristalizada como vocabulário canônico em
			  TechnicalRailSelection (anti economic-optimization /
			  treasury-decision / fee-arbitrage / smart-routing /
			  cross-rail-failover-automatic), ReverseSettlement (anti
			  refund / chargeback / estorno / correction / treasury-
			  adjustment / autonomous-reversal) e RegulatoryBoundary
			  (anti compliance-enforcement / bacen-integration /
			  policy-implementation / regulator-reporting)

			Boundary integrity preserved transversalmente — 'BKR não
			vira mini-X' tests:
			- NÃO vira mini-FCE: PaymentInstruction is not Payment
			  (axioma constitutivo); AuthorizationProof validity is
			  consumed, never interpreted; bd-settlement-authorization-
			  upstream enforcement em term content
			- NÃO vira mini-TCM: TechnicalRailSelection antiTerm
			  Treasury Decision; OperationalWindow antiTerm Scheduling
			  Policy; ReverseSettlement antiTerm Treasury Adjustment
			- NÃO vira mini-DRC: ReverseSettlement antiTerm Chargeback;
			  rationale explícita 'adjudication NÃO é BKR'
			- NÃO vira mini-regulator: RegulatoryBoundary antiTerm
			  Regulatory Compliance Enforcement; 'BKR observes
			  rejection, does not decide policy'

			SFN-aware nomenclatura preservada: Pix via SPI ISO 20022
			pacs.008/002/004; TED via STR (Bacen) ou SITRAF (CIP);
			boleto via SILOC com D+0/D+1; SWIFT MX standards; DICT
			external resolution para Pix keys; PSTI homologada / banco
			parceiro como access pattern Phase 0 para SCD; Drex
			emerging via Bacen (futuro).

			Event naming intentionally deferred to domain-model
			authoring (Phase 3) declared no outer rationale per founder
			direction — preserve distinction between operational
			completion and canonicalized settlement finality. Domain-
			model emergerá com prefixos canônicos agg-/ent-/vo-/evt-/
			cmd-/inv-; domainModelRefs preenchidos incrementalmente.

			Forward-looking acknowledged sem overclaim: glossário cobre
			Phase 0/Phase 1 conceptual surface; termos para emerging
			rails (Drex CBDC, Pix internacional, Open Finance ITP) e
			expanding fronteiras (ReverseSettlement workflow completo,
			secondary reconciliation automation, recurring payment
			lineage cross-BC) virão em wave futura quando openQuestions
			do canvas (clusters OQ-A/B/C) resolverem.

			cue vet -c ./... clean (EXIT=0) confirmado pre-write final.
			"""
	}]

	findings: {}

	summary: """
		BKR glossary Phase 2 WI-062 closure. 15 termos canônicos
		distribuídos em 5 categorias semânticas (1 entity / 9 value /
		4 process / 1 rule). Densidade adversarial elevada (~73
		antiTerms + ~50 rejectedAlternatives + 36 examples) refletindo
		a posição constitutiva do BC como boundary técnica entre
		intenção econômica (FCE) e execução de rails comoditizados.

		Cobertura completa dos 5 anti-termos centrais (Pagamento /
		Liquidação / Dispatch / Confirmation / Finality) cristalizada
		em antiTerms cross-term. Cross-anti-collapse matrix 4×3 dos
		IDs (InstructionId × AttemptId × IdempotencyKey ×
		RailReferenceId) completa — núcleo anti-replay / anti-double-
		settlement do BC.

		Identidade canônica do glossário: 'This glossary is a boundary-
		hardening artifact, not an onboarding dictionary.' Schema
		satisfação tq-gl-01..13 verificada por inspeção transversal +
		cue vet. PG quality gate tq-gg-01..04 satisfeito. 5 lenses
		ativadas articuladas. Event naming deferred to domain-model
		authoring (Phase 3) per founder direction.

		Phase 3 (domain-model) próxima per manualAuthoringProtocol
		section gates ordering.
		"""

	singleRoundRationale: """
		Round único suficiente paralelo a DLV/P2P/CMT/SSC/canvas
		approach. Founder iterative review aplicou 16 ajustes finos
		totais distribuídos pre-write em 5 batches (Phase 2.2.A
		pattern validation + Batch 1 settlement lifecycle + Batch 2
		identity lineage + Batch 3 boundary normativa + outer
		rationale framing) materializando quality discipline antes do
		write — NÃO conta como self-review rounds canonical per
		quality-gate protocol.

		Phase-by-phase authoring per manualAuthoringProtocol section
		gates (context-and-term-identification → term-content-and-
		anchoring → validation-and-meta) integrou findings substantivos
		antes do closure. Founder gate principal 'cada termo precisa
		ter antiTerms fortes para impedir colapso entre payment /
		dispatch / confirmation / reconciliation / finality' verificado
		via cobertura matrix transversal.

		Final state: cue vet -c clean (EXIT=0); schema constraints
		tq-gl-01..13 satisfeitos por inspeção transversal; PG quality
		criteria tq-gg-01..04 satisfeito; properties anti-replay /
		anti-double-settlement / boundary-integrity verificáveis pelo
		design (4-way ID cross-anti-collapse matrix completa, atomic
		state machine cristalizada, RegulatoryBoundary anti-overreach
		rule, ReverseSettlement gatekeeper máximo com 8 antiTerms).

		Iteração adicional pos-hoc não revelaria findings novos pois a
		revisão é schema-driven + boundary-driven + canvas-grounded —
		toda violação seria capturada por (a) cue vet structural
		constraints, (b) tq-gl-XX semantic checks executados pre-write,
		(c) cross-anti-collapse matrix verificável por inspeção. Phase
		2 BKR glossary é UL-complete para conceitual surface Phase
		0/1; Phase 3-5 (domain-model, agent-spec, agent-governance)
		constroem sobre vocabulário canonicalizado aqui.
		"""
}
