package agent_probes

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// bdg.cue — probe-record do Ciclo 4 (adr-134) para o canvas BDG. Conforma a
// #AgentProbeRecord. Registro append-only da campanha de calibração (N=4):
// probe isolado de contexts/bdg/canvas.cue, triado pelo founder. Este record
// REGISTRA os buracos (audit-trail); a correção do canvas BDG é trabalho próprio
// (sessão própria), não feita aqui.

records: "bdg": artifact_schemas.#AgentProbeRecord & {
	targetCanvas:    "contexts/bdg/canvas.cue"
	protocolVersion: "1"
	triaged:         true

	runs: [{
		probedAt: "2026-06-01"
		rationale: """
			Probe isolado contra contexts/bdg/canvas.cue. 6 gaps reais (2 high: A2
			taxonomia de rejeição, A9 liberação sem gatilho; 4 médios), 1
			deferred-by-design (oq-bdg-2), 2 agrupamentos already-specified. Zero
			alucinação material (probe-noise=0). A11 (moeda) é over-reach de
			nível-teste, agrupado em already-specified, não finding próprio. A9
			conecta ao evento órfão do flow (Ciclo 3).
			"""
		findings: [
			{
				id:           "pf-bdg-1"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "communication.inbound RejectBudget → BudgetRejected ('motivo estruturado')"
				description:  "A2 — BudgetRejected exige 'motivo estruturado' mas o conjunto de motivos não é enumerado no canvas."
				rationale:    "Padrão (a) taxonomia citada-mas-não-fechada: consumidores (CMT/DRC) reagem ao motivo, mas o vocabulário de motivos não é estável na spec."
				disposition: {acceptedAsResidual: "Correção do canvas BDG — enumerar motivos de rejeição. Sessão própria."}
			},
			{
				id:           "pf-bdg-2"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "capabilities cc-04 + QueryBudgetApprovalStatus (estado 'liberado')"
				description:  "A9 — estado 'liberado' e a operação de liberação aparecem em cc-04 e na query, mas nenhum command/gatilho inbound de liberação é formalizado. Liga ao evento órfão BudgetCommitmentReleased do flow commitment-lifecycle."
				rationale:    "Padrão (b) estado/evento sem caminho completo: o canvas declara o estado mas não o caminho que o produz; o evento de liberação é órfão no flow (Ciclo 3, sc-ccf-03)."
				disposition: {acceptedAsResidual: "Correção do canvas BDG — formalizar gatilho de liberação. Relação com def-031 (Ciclo 3, evento órfão)."}
			},
			{
				id:           "pf-bdg-3"
				category:     "spec-ambiguity"
				severity:     "medium"
				specLocation: "bd-coverage-as-invariant / gate determinístico de cobertura"
				description:  "A4 — critério de suficiência de cobertura (saldo >= valor vs saldo > valor) não declarado."
				rationale:    "Padrão (c) predicado de gate impreciso: a invariante central depende de um comparador que a spec não fixa."
				disposition: {acceptedAsResidual: "Correção do canvas BDG."}
			},
			{
				id:           "pf-bdg-4"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "bd-cost-center-as-sot ('saldo disponível')"
				description:  "A3 — definição de 'saldo disponível' (limite menos soma de comprometimentos ativos; o que conta como ativo) não declarada."
				rationale:    "O gate compara contra 'saldo disponível', mas a derivação do saldo (o que conta como comprometimento ativo) não está na spec."
				disposition: {acceptedAsResidual: "Correção do canvas BDG."}
			},
			{
				id:           "pf-bdg-5"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "ownership.autonomousDecisions register-budget-commitment"
				description:  "A5 — atomicidade e concorrência por centro de custo (double-spend) não tratadas no canvas."
				rationale:    "Registrar comprometimento + atualizar saldo sob concorrência é caminho clássico de double-spend; a spec não declara a garantia."
				disposition: {acceptedAsResidual: "Correção do canvas BDG."}
			},
			{
				id:           "pf-bdg-6"
				category:     "spec-ambiguity"
				severity:     "medium"
				specLocation: "bd-cost-center-as-sot + escalationCriteria"
				description:  "A7 — compromisso sem centro de custo identificável: distinção entre estado 'pendente' e 'rejeitado' não explícita."
				rationale:    "Padrão (b): ambiguidade de estado — a spec escala a ambiguidade de centro de custo mas não distingue o estado resultante (pendente vs rejeitado)."
				disposition: {acceptedAsResidual: "Correção do canvas BDG."}
			},
			{
				id:           "pf-bdg-7"
				category:     "deferred-by-design"
				severity:     "low"
				specLocation: "oq-bdg-2"
				description:  "A10 — publicação cross-context de BudgetRejected para CMT/DRC. É exatamente oq-bdg-2 (declarado, pendente de formalização)."
				rationale:    "Deferred-by-design: open question declarada no próprio canvas (oq-bdg-2), não buraco oculto."
			},
			{
				id:           "pf-bdg-8"
				category:     "already-specified"
				severity:     "low"
				specLocation: "ownership.governanceScope.escalationCriteria"
				description:  "A13/A14/A15 — não-cacheamento de decisão fora de alçada, pausa de autonomia por fracionamento e reação a mudança de policy: o canvas já afirma os três nos escalationCriteria."
				rationale:    "Already-specified: os três constam literalmente em escalationCriteria (out-of-alcada-threshold, fragmentation-pattern-detected, cost-center-policy-change). Probe over-assumiu."
			},
			{
				id:          "pf-bdg-9"
				category:    "already-specified"
				severity:    "low"
				description: "A1/A6/A8/A11/A12 — inferências seguras (payload de eventos, idempotência, estrutura de alçada, moeda/precisão, conteúdo de CommitmentAccepted). A spec sustenta; o probe over-assumiu detalhes de implementação."
				rationale:   "Already-specified (agrupa inferências-seguras): a spec sustenta o nível de canvas; os detalhes assumidos são de implementação. A11 (moeda) é over-reach de nível-teste, não finding próprio."
			},
		]
	}]

	summary: """
		Probe de calibração do Ciclo 4 no BDG (supporting, compliance-enforcer). 6
		buracos reais, 0 alucinação. Padrões: taxonomia citada-mas-não-fechada (A2),
		estado sem caminho completo (A9), predicado de gate impreciso (A4).
		"""

	rationale: """
		Record append-only do probe BDG (2º da campanha N=4, após FCE). DoD-completeness:
		os 6 gaps reais + o cross-context deferido carregam categoria; os gap-real
		carregam disposition acceptedAsResidual (correção = trabalho próprio do canvas
		BDG, não feita aqui); os não-defeitos (1 deferred-by-design + 2 already-specified)
		não carregam disposition. probe-noise=0 (zero alucinação material; a over-reach
		A11 é nível-teste, agrupada em already-specified). Triado pelo founder.
		"""
}
