package agent_probes

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// fce.cue — 1º probe-record do Ciclo 4 (adr-134). Registra o agent-probe do
// canvas FCE feito nesta sessão. Conforma a #AgentProbeRecord.
//
// Classificação fiel à triagem (zero alucinação material): 5 gaps reais (4 deste
// canvas: S6/S7/S9/P0 + 1 cross-bc: S3) com disposition; 11 não-defeitos
// (4 deferred-by-design + 7 already-specified) sem disposition; 0 probe-noise.
//
// NOTA: os gaps reais deste canvas (S6/S7/S9/P0) são BACKLOG DE CORREÇÃO do FCE —
// sessão própria, adr-135+. Este record os REGISTRA (audit-trail), não os corrige.

records: "fce": artifact_schemas.#AgentProbeRecord & {
	targetCanvas:    "contexts/fce/canvas.cue"
	protocolVersion: "1"
	triaged:         true

	runs: [{
		probedAt: "2026-05-31"
		model:    "agent-probe v1 (Given/When/Then F1-F21)"
		rationale: """
			Probe gerou testes de aceitação F1-F21 a partir do canvas FCE fechado, com
			15 assunções (S1-S15) onde a spec foi insuficiente. Triagem adversarial contra
			o canvas: 5 gaps reais (4 deste canvas — S6/S7/S9/P0, cluster no guard/
			financialization/enum-de-estado; + 1 cross-BC — S3, contrato de REW) e 11
			não-defeitos (a spec sustenta ou defere conscientemente). ZERO alucinação
			material (probe-noise=0): a única over-reach foi de NÍVEL DE TESTE (F4 afirmou
			'mutação externa rejeitada', mas o FCE não tem superfície de mutação inbound —
			a invariante é mais forte que o teste; nuance de teste, não assunção S#, logo
			não é finding). Ratio spec-finding/probe-noise alto valida o protocolo.
			"""
		findings: [
			{
				id:          "pf-fce-s6"
				category:    "spec-incompleteness"
				severity:    "high"
				specLocation: "communication.inbound SettlementFailed + reissue-on-transient-within-policy"
				description: "Taxonomia de FailureClass nunca enumerada; FailureClassified não diz se FCE ou BKR classifica. A fronteira autônomo (reissue technical-transient) vs supervisionado depende dessa classe existir como categoria estável (dp-04)."
				rationale:   "Autonomia do agente depende de uma taxonomia que a spec referencia mas não define — gap que muda comportamento."
				disposition: {acceptedAsResidual: "Backlog FCE (adr-135+); a enumeração é cross-BC (coordenar com canvas BKR — BKR classifica)."}
			},
			{
				id:          "pf-fce-s7"
				category:    "spec-ambiguity"
				severity:    "high"
				specLocation: "bd-financialization-atomic"
				description: "'reverte ou mantém não-final' tensiona a irreversibilidade física pós-SettlementFinalized. Atômico pós-finality só pode ser forward-recovery idempotente da cauda, nunca rollback. Spec não declara o ponto-de-não-retorno."
				rationale:   "Claim 'all-or-nothing' esconde a realidade distribuída — erro de modelagem caro se não distinguir abort-pré-dispatch de forward-recovery-pós-finality."
				disposition: {acceptedAsResidual: "Backlog FCE (adr-135+); leitura forward-recovery sem fork."}
			},
			{
				id:          "pf-fce-s9"
				category:    "spec-ambiguity"
				severity:    "high"
				specLocation: "bd-money-moves-only-on-proof + bd-realizes-not-allocates-budget + as-fce-5"
				description: "Contagem de condições do guard: 'BudgetApproved bloqueia dispatch' vs 'FCE não re-verifica cobertura' (as-fce-5) — cobertura é 4ª condição do guard ou precondição estrutural upstream? Leituras incompatíveis."
				rationale:   "O invariante central do BC (contagem de condições do PrePaymentGuard) fica ambíguo. Recomendação de triagem: leitura upstream-only (guard=3, budget=precondição)."
				disposition: {acceptedAsResidual: "Backlog FCE (adr-135+); fork de leitura é decisão do founder."}
			},
			{
				id:          "pf-fce-p0"
				category:    "spec-incompleteness"
				severity:    "medium"
				specLocation: "QueryPaymentSettlementStatus.returnType (enum de estado do Payment)"
				description: "O conjunto de estados do Payment só vive como detalhe incidental do returnType de uma query — sem lar canônico. Ironia: viola o P0 que o próprio FCE prega. Subordina S2/S8 (state machine + estado pós-InstructionRejected)."
				rationale:   "Localização canônica única (P0): o enum deveria ter lar no domain-model/glossary, não numa assinatura de query."
				disposition: {acceptedAsResidual: "oq-fce-7 (enum de estado sem lar → domain-model FCE, WI futuro)."}
			},
			{
				id:          "pf-fce-s3"
				category:    "cross-bc-gap"
				severity:    "low"
				specLocation: "communication.outbound query-dependency QueryEligibility (→ REW)"
				description: "Shape de retorno de QueryEligibility não definido. Booleano local é placeholder seguro, mas o contrato real é owned pelo canvas REW, não pelo FCE."
				rationale:   "Gap real, mas de OUTRO canvas — o FCE não pode (nem deve) especificar o contrato de REW. Buraco de interaction-contract, não do FCE."
				disposition: {acceptedAsResidual: "Owned por REW (contrato QueryEligibility); fora do escopo do canvas FCE. Tracking no lado REW."}
			},
			{id: "pf-fce-s2", category: "deferred-by-design", severity: "low", specLocation: "bd-payment-canonical-state", description: "Topologia da state machine do Payment.", rationale: "Deferred-by-design: bd-payment-canonical-state defere o detalhamento das 11 invariantes ao domain-model (WI futuro). Não é defeito de canvas."},
			{id: "pf-fce-s4", category: "deferred-by-design", severity: "low", specLocation: "as-fce-1", description: "Predicado exato de integridade da evidência no gate.", rationale: "Deferred: mecanismo (assinatura+hash chain+notarização) em as-fce-1; detalhe em adr-128 (ref nominal)."},
			{id: "pf-fce-s8", category: "deferred-by-design", severity: "low", specLocation: "communication.inbound InstructionRejected", description: "Estado do Payment pós-InstructionRejected (o enum não tem estado distinto).", rationale: "Subordinado a P0/S2 — resolve-se junto com o enum/state-machine no domain-model. Não é finding independente."},
			{id: "pf-fce-s13", category: "deferred-by-design", severity: "low", specLocation: "verificationMetrics prepayment-guard-consistency", description: "Threshold exato de 'stale' (< 24h provisório).", rationale: "Deferred: é literalmente oq-fce-5 (provisório, deadline 2026-09-30). Open question declarada, não buraco oculto."},
			{id: "pf-fce-s1", category: "already-specified", severity: "low", specLocation: "as-fce-2", description: "Identidade/chave de idempotência do Payment.", rationale: "Already-specified: as-fce-2 dá a tupla (commitmentRef, invoice). Probe assumiu; a spec sustenta."},
			{id: "pf-fce-s5", category: "already-specified", severity: "low", specLocation: "communication.inbound InvoiceIssued/InvoiceCancelled", description: "'fatura válida' no momento do gate.", rationale: "Already-specified o suficiente: issued ∧ ¬cancelled segue diretamente das reações inbound declaradas."},
			{id: "pf-fce-s10", category: "already-specified", severity: "low", specLocation: "bd-execution-not-treasury", description: "Caixa nunca bloqueia o gate P11.", rationale: "Already-specified: bd-execution-not-treasury enuncia quase literalmente ('ordenar, não decidir SE paga'). Probe over-assumiu."},
			{id: "pf-fce-s11", category: "already-specified", severity: "low", specLocation: "bd-settlement-fact-canonical + as-fce-2", description: "Unicidade de PaymentSettled (≤1 por tupla).", rationale: "Already-specified: segue de bd-settlement-fact-canonical + as-fce-2. Síntese fiel."},
			{id: "pf-fce-s12", category: "already-specified", severity: "low", specLocation: "governanceScope confirm-payment-obligation-default", description: "Confirmação humana de PaymentObligationDefaulted.", rationale: "Already-specified: confirm-payment-obligation-default já é supervisedDecision. A spec afirma; probe marcou como assunção."},
			{id: "pf-fce-s14", category: "already-specified", severity: "low", specLocation: "bd-economic-authority-not-rails + as-fce-3", description: "Presença/validação da authorization proof.", rationale: "Already-specified: os 4 elementos da proof dados + validação por BKR (as-fce-3)."},
			{id: "pf-fce-s15", category: "already-specified", severity: "low", specLocation: "QueryPaymentSettlementStatus.returnType", description: "Regra de presença de settledAt/railReferenceId por estado.", rationale: "Already-specified: returnType marca os campos opcionais + 'não emite outcome sob não-final'. Micro-nota (railReferenceId em dispatched) é editorial."},
		]
	}]

	summary: """
		Probe FCE (Ciclo 4, 1º record): 16 findings classificados — 5 gaps reais
		(4 deste canvas: S6 spec-incompleteness, S7/S9 spec-ambiguity, P0 spec-incompleteness;
		+ 1 cross-bc-gap: S3, contrato de REW), todos com disposition acceptedAsResidual
		(backlog FCE adr-135+ / oq-fce-7 / lado REW); 11 não-defeitos (4 deferred-by-design
		S2/S4/S8/S13 + 7 already-specified S1/S5/S10/S11/S12/S14/S15); 0 probe-noise.
		Ratio spec-finding/probe-noise alto (5:0) valida o protocolo. Os gaps deste canvas
		NÃO são corrigidos aqui — backlog FCE.
		"""

	rationale: """
		Record append-only do 1º agent-probe. Demonstra o DoD-completeness: cada gap
		real (5) carrega disposition (sem ela, cue vet falharia); os 11 não-defeitos
		não carregam (não são buracos). probe-noise=0 é honesto — a triagem achou zero
		alucinação material (a micro-over-reach do F4 é nível-de-teste, registrada na
		run.rationale, não é finding S#). Triado pelo founder (triaged: true). Entra
		como o 1º dos 14 records de cobertura → sc-apr-02 nasce com 13 warns.
		"""
}
