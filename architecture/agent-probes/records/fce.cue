package agent_probes

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// fce.cue — 1º probe-record do Ciclo 4 (adr-134). Registra o agent-probe do
// canvas FCE feito nesta sessão. Conforma a #AgentProbeRecord.
//
// NOTA: os findings reais (S6/S7/S9/P0) são BACKLOG DE CORREÇÃO do FCE — sessão
// própria, adr-135+. Este record os REGISTRA (audit-trail), não os corrige aqui.

records: "fce": artifact_schemas.#AgentProbeRecord & {
	targetCanvas:    "contexts/fce/canvas.cue"
	protocolVersion: "1"
	triaged:         true

	runs: [{
		probedAt: "2026-05-31"
		model:    "agent-probe v1 (Given/When/Then F1-F21)"
		rationale: """
			Probe gerou testes de aceitação F1-F21 a partir do canvas FCE fechado,
			com 15 assunções (S1-S15) onde a spec foi insuficiente. Triagem adversarial
			contra o canvas: 3 defeitos reais (S6/S7/S9, cluster no guard/financialization)
			+ 1 meta (P0, enum de estado sem lar) + 12 noise (deferidos-by-design ou
			já-respondidos pela spec). Ratio sinal/ruído alto — calibra a falsificationCondition.
			"""
		findings: [
			{
				id:          "pf-fce-s9"
				category:    "spec-ambiguity"
				severity:    "high"
				specLocation: "bd-money-moves-only-on-proof + bd-realizes-not-allocates-budget + as-fce-5"
				description: "Contagem de condições do guard: 'BudgetApproved bloqueia dispatch' vs 'FCE não re-verifica cobertura' (as-fce-5) — cobertura é 4ª condição do guard ou precondição estrutural upstream? Leituras incompatíveis."
				rationale:   "Três frases, duas leituras; o invariante central do BC (contagem de condições do PrePaymentGuard) fica ambíguo. Recomendação de triagem: leitura upstream-only (guard=3, budget=precondição)."
				disposition: {acceptedAsResidual: "Backlog de correção FCE (adr-135+, sessão própria); fork de leitura é decisão do founder."}
			},
			{
				id:          "pf-fce-s7"
				category:    "spec-ambiguity"
				severity:    "high"
				specLocation: "bd-financialization-atomic"
				description: "'reverte ou mantém não-final' tensiona a irreversibilidade física pós-SettlementFinalized. Atômico pós-finality só pode ser forward-recovery idempotente da cauda, nunca rollback. Spec não declara o ponto-de-não-retorno."
				rationale:   "Claim 'all-or-nothing' esconde a realidade distribuída (settlement físico irreversível) — erro de modelagem caro se não distinguir abort-pré-dispatch de forward-recovery-pós-finality."
				disposition: {acceptedAsResidual: "Backlog de correção FCE (adr-135+); leitura forward-recovery sem fork."}
			},
			{
				id:          "pf-fce-s6"
				category:    "spec-incompleteness"
				severity:    "high"
				specLocation: "communication.inbound SettlementFailed + reissue-on-transient-within-policy"
				description: "Taxonomia de FailureClass nunca enumerada; FailureClassified não diz se FCE ou BKR classifica. A fronteira autônomo (reissue technical-transient) vs supervisionado depende dessa classe existir como categoria estável (dp-04)."
				rationale:   "A autonomia do agente (reissue-on-transient) depende de uma taxonomia que a spec referencia mas não define — gap que muda comportamento."
				disposition: {acceptedAsResidual: "Backlog FCE (adr-135+); enumeração é cross-BC (coordenar com canvas BKR — BKR classifica)."}
			},
			{
				id:          "pf-fce-p0"
				category:    "spec-incompleteness"
				severity:    "medium"
				specLocation: "QueryPaymentSettlementStatus.returnType (enum de estado do Payment)"
				description: "O conjunto de estados do Payment {guarded,authorized,dispatched,settled,failed,indeterminate,cancelled} só vive como detalhe incidental do returnType de uma query — sem lar canônico. Ironia: viola o P0 que o próprio FCE prega."
				rationale:   "Localização canônica única (P0): o enum de estados deveria ter lar no domain-model/glossary, não numa assinatura de query. Também subordina S2/S8 (state machine + estado pós-InstructionRejected)."
				disposition: {acceptedAsResidual: "oq-fce-7 (enum de estado sem lar → domain-model FCE, WI futuro)."}
			},
			{id: "pf-fce-s1", category: "probe-noise", severity: "low", description: "Identidade/chave de idempotência do Payment — JÁ-RESPONDIDO: as-fce-2 dá a tupla (commitmentRef, invoice).", rationale: "Probe assumiu; a spec sustenta. Sem ação."},
			{id: "pf-fce-s2", category: "probe-noise", severity: "low", description: "Topologia da state machine — DEFERRED-BY-DESIGN: bd-payment-canonical-state defere ao domain-model (WI futuro).", rationale: "Deferimento explícito, não defeito de canvas. Sem ação no canvas."},
			{id: "pf-fce-s3", category: "probe-noise", severity: "low", description: "Shape de QueryEligibility — CROSS-BC: contrato de REW, não do canvas FCE; booleano local é placeholder seguro.", rationale: "Externo a este canvas. Sem ação no FCE."},
			{id: "pf-fce-s4", category: "probe-noise", severity: "low", description: "Predicado de integridade da evidência — DEFERRED: mecanismo em as-fce-1, detalhe em adr-128.", rationale: "Coberto por ref nominal a adr-128. Sem ação."},
			{id: "pf-fce-s5", category: "probe-noise", severity: "low", description: "'fatura válida' no gate — JÁ-RESPONDIDO o suficiente: issued ∧ ¬cancelled segue das reações inbound declaradas.", rationale: "Piso razoável sustentado pela spec; resíduo é menor. Sem ação prioritária."},
			{id: "pf-fce-s8", category: "probe-noise", severity: "low", description: "Estado pós-InstructionRejected — SUBORDINADO a P0/S2 (mesmo domain-model); o enum atual não tem estado distinto.", rationale: "Resolve-se junto com P0 (enum no domain-model). Não é finding independente."},
			{id: "pf-fce-s10", category: "probe-noise", severity: "low", description: "Caixa nunca bloqueia — JÁ-RESPONDIDO: bd-execution-not-treasury enuncia quase literalmente.", rationale: "Probe over-assumiu; spec explícita. Sem ação."},
			{id: "pf-fce-s11", category: "probe-noise", severity: "low", description: "Unicidade de PaymentSettled — JÁ-RESPONDIDO: bd-settlement-fact-canonical + as-fce-2 ⇒ ≤1 por tupla.", rationale: "Síntese fiel da spec. Sem ação."},
			{id: "pf-fce-s12", category: "probe-noise", severity: "low", description: "Confirmação humana de default — JÁ-RESPONDIDO: confirm-payment-obligation-default é supervisedDecision.", rationale: "A spec afirma; probe marcou como assunção. Sem ação."},
			{id: "pf-fce-s13", category: "probe-noise", severity: "low", description: "Threshold de 'stale' — DEFERRED-BY-DESIGN: oq-fce-5 (provisório, deadline 2026-09-30).", rationale: "Open question declarada, não buraco oculto. Sem ação."},
			{id: "pf-fce-s14", category: "probe-noise", severity: "low", description: "Presença da proof — JÁ-RESPONDIDO: 4 elementos dados + validação por BKR (as-fce-3).", rationale: "Spec completa. Sem ação."},
			{id: "pf-fce-s15", category: "probe-noise", severity: "low", description: "Read model da query — JÁ-RESPONDIDO: returnType marca settledAt?/railReferenceId? opcionais + 'não emite outcome sob não-final'.", rationale: "Spec explícita; micro-nota (railReferenceId poderia existir já em dispatched) é editorial. Sem ação."},
		]
	}]

	summary: """
		Probe FCE (Ciclo 4, 1º record): 16 findings — 4 reais (S6 spec-incompleteness,
		S7/S9 spec-ambiguity, P0 spec-incompleteness), todos cluster no coração core
		do BC (PrePaymentGuard / financialization atômica / enum de estado), com
		disposition acceptedAsResidual (backlog FCE adr-135+ / oq-fce-7); 12 noise
		(deferidos-by-design ou já-respondidos). Ratio sinal/ruído alto valida o
		protocolo. Os reais NÃO são corrigidos aqui — são backlog do FCE.
		"""

	rationale: """
		Record append-only do 1º agent-probe. Demonstra o DoD-completeness: cada
		finding real carrega disposition (sem ela, cue vet falharia). Triado pelo
		founder nesta sessão (triaged: true). Entra como o 1º dos 14 records de
		cobertura → sc-apr-02 nasce com 13 warns.
		"""
}
