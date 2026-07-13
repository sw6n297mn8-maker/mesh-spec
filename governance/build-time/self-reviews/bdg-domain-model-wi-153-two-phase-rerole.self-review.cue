package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

bdgDomainModelWi153TwoPhaseRerole: build_time.#SelfReviewReport & {
	reportId: "srr-bdg-domain-model-wi-153-two-phase-rerole"

	artifactPath:       "contexts/bdg/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-model.cue"
	artifactType:       "domain-model"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do RE-PAPEL TWO-PHASE (WI-153 executa adr-174
			lado bdg, decisões D1-D6 do founder aplicadas): +evt-coverage-
			reserved (o evento de reserva do adr-174 dec 4, published, fase 1
			keyed por requisitionRef), +cmd-confirm-budget-reservation (fase 2,
			interno de policy — carve-out tq-dm-12, paralelo cmd-convert-
			requisition), +inv-confirmation-requires-active-reservation (a lei
			da fase 2: efetivação sem reserva NUNCA auto-aprova nem re-roda o
			gate — escalada supervisionada confirm-without-reservation, P10);
			cmd-approve-budget re-keyed (D2: commitmentId REMOVIDO,
			requisitionRef entra — o único invocador pós-re-papel é o portão);
			pol-commitment-accepted-triggers-approval re-papelizada (code
			mantido por histórico de refs; issuesCommand → confirm; de
			gate-tardio para EFETIVAÇÃO); ent-budget-commitment com fases
			reserved|confirmed|released + requisitionRef + confirmedAt
			(commitmentId populado só na efetivação); release estendido
			(originContext +p2p; commitmentId condicional; budgetCommitmentId
			= coverageReservationRef do p2p); projeções re-papelizadas
			(availability consome a RESERVA — o saldo reduz na fase 1;
			status responde por requisitionRef OU commitmentId).

			[BREAKING DECLARADO — D3 founder]: o valor 'approved' do
			vo-budget-approval-status foi REMOVIDO, split em
			reserved|confirmed. Consumidores do contrato de status no disco e
			o que cada um passa a ler: (1) p2p — dependsOnAggregateState de
			inv-approval-requires-coverage-reservation via
			QueryBudgetApprovalStatus → lê 'reserved' no portão (fase 1); (2)
			CMT — visibilidade pós-formalização via query → lê 'confirmed';
			(3) DRC — contexto de disputa via query → lê 'confirmed'/
			'released'; (4) DLV — NÃO consome o enum: consome o EVENTO
			BudgetApproved (spine bdg-to-dlv), cujo contrato de fields
			(commitmentId, budgetCommitmentId, amount) fica INTOCADO — muda
			apenas o momento de emissão (efetivação, pós-commitment — o
			momento em que habilitar execução faz sentido). Phase 0 sem
			runtime: custo de migração zero agora; adiado custaria migração
			de dados + consumers vivos.

			[uq-08]: cue vet EXIT=0; wiring tq-dm-01..17 fechado por inspeção
			(confirm handled pelo agg; coverage-reserved em emitsEvents;
			inv-confirmation protegida; policy refs resolvem tq-dm-05;
			projections consomem só catálogo tq-dm-06). [uq-03]: refs
			cross-BC verificadas — requisitionRef aponta p2p vo-requisition-id
			(existe); coverageReservationRef do p2p = budgetCommitmentId
			(declarado nos dois lados); cadeia de enriquecimento D1
			(commitment → purchaseOrderRef → requisitionRef) confirmada no
			disco no Tempo 1 (agg do cmt guarda purchaseOrderRef;
			QueryPurchaseOrderById do p2p retorna requisitionRef) — cmt
			INTOCADO. [uq-05]: premissa do enriquecimento ACL declarada
			(paralela a as-bdg-1); anchor do consumo async de CoverageReserved
			declarado (query sync é o caminho Phase 0). [uq-06]: UL em par —
			term-efetivacao-de-reserva + fases no term-comprometimento
			(glossário 16 terms). [uq-07]: zero placeholder. [uq-09]: batch
			com checkpoint único per comando estruturado do founder (Tempo 1
			read-only serviu de section-gate do desenho; decisões D1-D6
			pré-cravadas).
			"""
	}]

	findings: {}

	summary: """
		Re-papel two-phase do bdg (WI-153 executa adr-174): a policy de
		aprovação-tardia virou EFETIVAÇÃO; a reserva ganhou fato próprio
		(CoverageReserved) e chave por requisição; o estado ganhou a fase que
		o padrão sempre implicou (reserved → confirmed → released); efetivação
		sem reserva escala para supervisão. BREAKING do enum de status
		DECLARADO (D3): approved → reserved|confirmed, consumidores mapeados
		(p2p lê reserved; CMT/DRC leem confirmed; DLV consome o evento — spine
		intocado). VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: materialização de decisão registrada
		(adr-174) cujo desenho fino foi proposto, verificado contra o disco e
		aprovado no Tempo 1 (read-only) com as decisões D1-D6 do founder
		pré-cravadas — o Tempo 1 funcionou como a revisão substantiva; este
		round confirmou conformância, wiring e a declaração do breaking.
		"""
}
