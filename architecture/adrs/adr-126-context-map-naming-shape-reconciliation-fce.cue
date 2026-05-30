package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr126: artifact_schemas.#ADR & {
	id:    "adr-126"
	title: "Reconciliação de naming + shape do context-map com canvases adjacentes (bkr-to-fce, rew-to-fce)"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Durante o scaffold do BC FCE (adr-127), a autoria da section
		communication do canvas expôs divergência entre os nomes
		"candidatos canônicos estratégicos" declarados no context-map
		(strategic/context-map.cue) e os nomes já refinados nos canvases
		adjacentes BKR e REW, ambos mergeados. O próprio context-map
		declara em knownLimitations que "os nomes de eventos, commands e
		queries neste mapa são candidatos canônicos estratégicos; validação
		definitiva depende dos canvas e domain models de cada BC". Logo, os
		canvases são a autoridade quando divergem.

		Duas arestas divergiam:

		(1) bkr-to-fce: context-map declarava evento BankSettlementConfirmed
		    e command InitiateBankTransfer. O canvas BKR (mergeado) publica
		    para FCE cinco outcomes canônicos (SettlementFinalized,
		    SettlementFailed, SettlementIndeterminate, FailureClassified,
		    InstructionRejected) e expõe os command-handlers
		    DispatchPaymentInstruction + RequestSettlementCancellation.

		(2) rew-to-fce: context-map declarava evento CreditEligibilityDecided
		    e communication.type async. O canvas REW (mergeado) publica
		    EligibilityEmitted/RiskScoreEmitted E expõe as query-surfaces
		    QueryEligibility/QueryRiskScore nomeando explicitamente
		    "FCE (PrePaymentGuard)". Reconciliar exige, além do naming, mudar
		    communication.type de async para hybrid e adicionar o campo
		    queries — ou seja, um shape change, não só renomeação.

		A aresta inv-to-fce NÃO divergia (InvoiceIssued/InvoiceCancelled
		coincidem context-map↔INV); fce-to-scf/ato/tcm e tcm-to-fce também
		não. Logo apenas 2 arestas mudam.

		Decisão de escopo (founder, Q1=A): o canvas vence (aplicação
		COMPLETA do princípio, não cherry-pick) e o context-map é
		reconciliado no mesmo PR do scaffold FCE.

		Alternativa considerada e rejeitada (Q1=B): manter só o naming e
		deixar o shape change de rew-to-fce em openQuestions. REJEITADA:
		dividir naming de shape é aplicação parcial que cria dívida cuja
		resolução exigiria outro ADR de naming/shape no futuro — pior trade
		que +1 campo (queries) no diff agora. Q1=A foi aceito por princípio
		("canvas vence"), não por escopo limitado.
		"""

	decision: """
		Reconciliar 2 arestas em strategic/context-map.cue alinhando ao
		canvas adjacente (autoridade):

		(1) bkr-to-fce:
		    events: [BankSettlementConfirmed] →
		      [SettlementFinalized, SettlementFailed, SettlementIndeterminate,
		       FailureClassified, InstructionRejected]
		    commands: [InitiateBankTransfer] →
		      [DispatchPaymentInstruction, RequestSettlementCancellation]
		    communication.type permanece hybrid; patterns OHS/ACL inalterados.

		(2) rew-to-fce:
		    events: [CreditEligibilityDecided] → [EligibilityEmitted, RiskScoreEmitted]
		    communication.type: async → hybrid
		    queries: (ausente) → [QueryEligibility, QueryRiskScore]
		    feedbackLoop.kind policy-execution-feedback PRESERVADO; patterns
		    OHS-PL/ACL inalterados; reverseRelationshipId fce-to-rew inalterado.

		Nenhum pattern DDD muda; nenhuma direção muda; nenhuma aresta nova é
		criada. A acyclicity permanece: o ciclo fce↔rew já era tipado
		(policy-execution-feedback, adr-124) e o par fce↔tcm permanece
		gate-acíclico por events-required filter (adr-120, tcm→fce query-only)
		— sc-cm-07 deve permanecer reportando 0 ciclos (catraca adr-097/123).
		"""

	consequences: """
		Positivas:
		(P1) A section communication do canvas FCE passa tq-cv-02 (toda
		relation cross-checked com context-map) sem relations em
		openQuestions — integração fechada na materialização do BC.
		(P2) Context-map deixa de carregar nomes provisórios que contradiziam
		canvases já mergeados (bkr, rew) — elimina drift estrutural existente.
		(P3) O shape de rew-to-fce passa a refletir a dependência real do
		PrePaymentGuard real-time (sync query) que o canvas REW já modelava.

		Negativas:
		(N1) Nenhuma material. O shape change de rew-to-fce adiciona o campo
		queries a uma aresta que já tinha events + feedbackLoop; cue vet
		confirma conformidade. Reversível trivialmente (high) se algum canvas
		futuro revelar nome diferente.

		Fronteira regulatória: nenhuma. Reconciliação de vocabulário de
		integração entre artefatos de spec. Sem efeito em Bacen/SCD/LGPD.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"strategic/context-map.cue",
	]

	principlesApplied: ["P0"]

	supersedes: []

	rationale: """
		P0 (uma localização canônica): o nome canônico de cada evento/command/
		query de um BC vive no canvas/domain-model desse BC (autoridade per
		knownLimitations do context-map); o context-map referencia esses nomes,
		não os define concorrentemente. Reconciliar elimina a cópia divergente
		— o context-map vira ponteiro consistente, não fonte concorrente.

		Aplicação completa do princípio Q1=A: o founder aceitou "canvas vence"
		por princípio, não por escopo limitado. Por isso o shape change de
		rew-to-fce (async→hybrid + queries) entra junto do naming — separá-los
		seria cherry-pick incoerente com a própria reconciliação.

		Acyclicity preservada por construção: nenhuma aresta nova, nenhuma
		direção alterada. O ciclo fce↔rew permanece tipado (adr-124) e o par
		fce↔tcm permanece isento (adr-120). A catraca sc-cm-07 (reject,
		adr-123) permanece verde.

		Tensão com axiomas: nenhuma.
		"""
}
