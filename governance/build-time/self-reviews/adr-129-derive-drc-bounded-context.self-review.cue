package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr129: build_time.#SelfReviewReport & {
	reportId: "srr-adr-129"

	artifactPath:       "architecture/adrs/adr-129-derive-drc-bounded-context.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-30"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR-129 documenta a derivação do BC DRC — segunda aplicação de
			P13/adr-125, primeira em modo batch. Registra os 3 testes de
			separação (linguagem ubíqua de disputa: alegação/evidência/resolução/
			impacto/reversão/penalidade, disjunta de cmt/fce/ctr; invariante
			própria: resolução-requer-evidência via mech-evidence; ownership
			canônico: estado do Dispute + fato DisputeResolved) todos PASSED, o
			teste de remoção (fluxo normal do compromisso sobrevive sem disputas
			→ perda de função, não acoplamento), e a classificação das 5 arestas
			(ciclo cmt↔drc tipado bidirectional-orchestration conforme adr-122 W1
			— DRC conforma ao kind canônico, NÃO deriva kind novo; dlv-to-drc,
			ctr-to-drc, drc-to-fce unidirecionais acíclicas). Decisões de escopo:
			costsEliminated ce-02+ce-03 (espelho bdg, encaixe defensável não
			dispute-specific, ce-08 candidato futuro); cc-04 como ref local;
			businessRole operational-enabler; sem invariante cross-cutting que
			mereça ADR próprio (≠ FCE/P11) — bd-resolution-requires-evidence é
			instância de mech-evidence já existente. tq-adr-01 PASSED:
			alternativas explicitadas e rejeitadas (merge DRC em CMT — rejeitado
			por 3/3 testes + o próprio subdomain teme inflar a state machine do
			CMT; ce-08 novo no domain-definition — rejeitado por scope creep,
			deferido). tq-adr-02 PASSED: reversibility=medium (fronteira de BC é
			redesign se desfeita), blastRadius=cross-cutting (DRC toca cmt/dlv/
			ctr/fce + context-map). tq-adr-03/04 PASSED: plannedOutputs=[canvas].
			principlesApplied=[P13,P10,P0]. cue vet ./contexts/drc/ EXIT=0. def-029
			(validation-prompt advisory de derivação) DISPARA neste scaffold (DRC
			é o 13º canvas, recurrence threshold 13) — reportado como advisory ao
			founder, não materializado unilateralmente.
			"""
	}]

	findings: {}

	summary: """
		ADR-129 deriva o BC DRC via P13 (segunda aplicação, primeira em batch):
		3 testes de separação 3/3 + teste de remoção PASSED + classificação das
		5 arestas (ciclo cmt↔drc conforma a bidirectional-orchestration adr-122,
		sem kind novo). Sem 2º ADR (DRC não tem invariante cross-cutting tipo
		P11). costsEliminated ce-02+ce-03 com nota ce-08 futuro. def-029 dispara
		(13º canvas) — advisory. cue vet EXIT=0.

		AMENDMENT (2026-05-30 per adr-132, def-032): backfill de
		falsificationCondition derivada do teste de remoção P13 —
		condition = fluxo normal do compromisso (CMT) passar a DEPENDER do DRC
		no caso comum (disputas deixarem de ser excepcionais; CMT parar sem
		DRC); OU o ciclo cmt↔drc deixar de conformar ao kind
		bidirectional-orchestration (adr-122) e exigir kind novo;
		observableSignal = reaplicação do teste de remoção ao mudar canvas CMT
		+ sc-cm-07 sobre cmt↔drc + razão de fluxos CMT que acionam DRC no
		caminho comum vs. excepcional. Campo opcional; nenhum gate novo
		(deferido em def-032).
		"""

	singleRoundRationale: """
		Conteúdo da derivação (S1 boundary-derivation do canvas batch) é o
		registro canônico (Opção i — derivação não vira campo do canvas).
		Alternativas (merge em CMT, ce-08 novo) explicitadas e rejeitadas. O
		ciclo cmt↔drc apenas CITA adr-122 (já canônico), reduzindo a superfície
		de decisão nova. Round único suficiente.
		"""
}
