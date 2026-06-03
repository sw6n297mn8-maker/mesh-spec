package agent_probes

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// cmt.cue — probe-record do Ciclo 4 (adr-134) para o canvas CMT. Conforma a
// #AgentProbeRecord. Registro append-only da campanha de calibração: probe
// isolado de contexts/cmt/canvas.cue, triado pelo founder. REGISTRA os
// buracos (audit-trail); a correção do canvas CMT é trabalho próprio.

records: "cmt": artifact_schemas.#AgentProbeRecord & {
	targetCanvas:    "contexts/cmt/canvas.cue"
	protocolVersion: "1"
	triaged:         true

	runs: [{
		probedAt: "2026-06-03"
		rationale: """
			Probe isolado contra contexts/cmt/canvas.cue. 7 gaps reais (1 high:
			pf-cmt-1 semântica bilateral ambígua; 5 medium incluindo pf-cmt-2
			sobreposição StateChanged/Accepted, pf-cmt-3 resiliência CTR, pf-cmt-4
			payload DisputeResolved, pf-cmt-6 modify_terms vs CTR, pf-cmt-7 maintain
			vs suspended; 1 low: pf-cmt-5 idempotência), 1 deferred-by-design
			(oq-cmt-1), 2 agrupamentos already-specified. Zero alucinação material
			(probe-noise=0). Nota metodológica: três buracos identificados por análise
			estática complementar (AcceptanceConfirmation sem shape canônica em CUE,
			CommitmentScope inline/TODO, discrepância 11 eventos definidos vs 10 wired)
			NÃO foram detectados pelo probe — operam no nível de codificação CUE, fora
			do escopo de testes-de-aceitação; serão tratados na sessão de correção mas
			não creditados ao protocolo. Decisão da campanha: correção completa (todos
			os 7 gap-real) em sessão própria, não só a fatia bd-mutual-acceptance.
			"""
		findings: [
			{
				id:           "pf-cmt-1"
				category:     "spec-ambiguity"
				severity:     "high"
				specLocation: "bd-mutual-acceptance / cmd-confirm-commitment-acceptance / inv-mutual-bilateral-acceptance"
				description:  "S-03 — Semântica 'ambas as partes' ambígua: o canvas diz 'confirmação explícita de ambas as partes' mas o modelo provê uma confirmação explícita (contraparte) e uma implícita (proponente via ProposeCommitment). O probe precisou assumir que ProposeCommitment constitui a primeira confirmação."
				rationale:    "Padrão (c) predicado de gate impreciso: o invariante central pende de uma semântica que a spec não fixa. Convergência parcial com achado de análise estática (proponente implícito vs contraparte explícita)."
				disposition: {acceptedAsResidual: "Correção do canvas CMT — fixar semântica bilateral. PRIORITÁRIO (afeta o golden-example)."}
			},
			{
				id:           "pf-cmt-2"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "CommitmentStateChanged / CommitmentAccepted (overlap)"
				description:  "S-09 — Não declarado se CommitmentStateChanged é publicado na transição proposed→accepted ou só nas outras. Sobreposição com CommitmentAccepted ambígua: ou ambos são publicados (duplicação semântica) ou só o segundo (state-changed não é universal)."
				rationale:    "Padrão (b) estado/evento sem caminho completo: o canvas declara dois eventos para mudança de estado sem especificar a cardinalidade entre eles."
				disposition: {acceptedAsResidual: "Correção do canvas CMT — declarar a regra de publicação."}
			},
			{
				id:           "pf-cmt-3"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "bd-terms-validation / QueryContractTerms"
				description:  "S-11 — Estratégia de resiliência quando CTR está indisponível não declarada. O probe assumiu fail-closed (rejeitar a proposta), mas o canvas defere essa decisão sem registro como openQuestion."
				rationale:    "Padrão (b): pré-condição inviolável depende de query síncrona cujo comportamento sob falha não está na spec."
				disposition: {acceptedAsResidual: "Correção do canvas CMT — declarar política de resiliência (decisão de SLA do founder)."}
			},
			{
				id:           "pf-cmt-4"
				category:     "spec-ambiguity"
				severity:     "medium"
				specLocation: "communication.inbound DisputeResolved (de drc)"
				description:  "S-08 — Payload de DisputeResolved não modelado em CUE; a spec só diz em prosa 'pode cancelar, modificar termos ou manter'. O probe precisou assumir um enum {cancel, modify_terms, maintain} para escrever os testes."
				rationale:    "Padrão (a) taxonomia citada-mas-não-fechada: o contrato do evento cross-BC governa transições críticas mas não é estável na spec."
				disposition: {acceptedAsResidual: "Correção cross-BC — enumerar payload de DisputeResolved (owned pelo DRC ou CMT como consumer?)."}
			},
			{
				id:           "pf-cmt-5"
				category:     "spec-ambiguity"
				severity:     "low"
				specLocation: "cmd-confirm-commitment-acceptance"
				description:  "T-CMD-CONF-03 — Idempotência de ConfirmCommitmentAcceptance quando compromisso já está accepted: rejeitar ou tratar como no-op? Não especificado."
				rationale:    "Padrão (c) predicado impreciso: comportamento sob duplicação não está na spec."
				disposition: {acceptedAsResidual: "Correção do canvas CMT — declarar idempotência."}
			},
			{
				id:           "pf-cmt-6"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "DisputeResolved decision=modify_terms"
				description:  "T-EVT-DRC-02 — Modificação de termos via disputa exige revalidação contra CTR? Não declarado."
				rationale:    "Padrão (b) caminho não fechado: a modificação altera termos vigentes mas a relação com a invariante de lastro CTR não é explícita."
				disposition: {acceptedAsResidual: "Correção do canvas CMT — declarar relação modify_terms ↔ CTR."}
			},
			{
				id:           "pf-cmt-7"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "DisputeResolved decision=maintain + estado suspended"
				description:  "T-EVT-DRC-03 — 'maintain' para compromisso suspended retorna a accepted via reativação automática ou exige aceite supervisionado? Caminho não fechado."
				rationale:    "Padrão (b) estado/evento sem caminho completo: a reativação por maintain não é declarada."
				disposition: {acceptedAsResidual: "Correção do canvas CMT — declarar o caminho de reativação."}
			},
			{
				id:           "pf-cmt-8"
				category:     "deferred-by-design"
				severity:     "low"
				specLocation: "oq-cmt-1"
				description:  "S-06 / T-GOV-ESC-02 — Threshold de escalação por valor para aceite supervisionado. É exatamente oq-cmt-1 (declarado, pendente até deadline 2026-06-01)."
				rationale:    "Deferred-by-design: openQuestion declarada no canvas; o probe corretamente derivou que todo aceite é supervisionado enquanto não resolvido."
			},
			{
				id:           "pf-cmt-9"
				category:     "already-specified"
				severity:     "low"
				specLocation: "communication.inbound CounterpartyRiskAlertRaised/Cleared"
				description:  "S-01/S-02 — Estado at-risk e transições accepted↔at-risk via REW: derivam fielmente das reações declaradas. O canvas as sustenta."
				rationale:    "Already-specified: inferência segura a partir das reações declaradas."
			},
			{
				id:          "pf-cmt-10"
				category:    "already-specified"
				severity:    "low"
				description: "S-04, S-05, S-07, S-10 — Inferências seguras: CommitmentId gerado em CommitmentProposed (bd-commitment-id-origin sustenta); vigente=active (lifecycle de CTR sustenta); snapshot de termos no aceite (consequência natural da invariante); validação CTR em ProposeCommitment (pré-condição declarada). A spec sustenta cada um; o probe corretamente inferiu."
				rationale:   "Already-specified (agrupa inferências-seguras): detalhes derivados de campos declarados."
			},
		]
	}]

	summary: """
		Probe de calibração do Ciclo 4 no CMT (core, revenue-generator, hub do
		commitment-spine). 7 buracos reais incluindo pf-cmt-1 (semântica bilateral,
		afeta golden-example), 0 alucinação. Convergência parcial com análise
		estática complementar — métodos complementares, não redundantes.
		"""

	rationale: """
		Record append-only do probe CMT (5º da campanha de calibração do Ciclo 4,
		adr-134). DoD-completeness: os 7 gaps reais deste canvas carregam disposition
		acceptedAsResidual; pf-cmt-8 (deferred-by-design → oq-cmt-1) e os 2
		agrupamentos already-specified (pf-cmt-9, pf-cmt-10) não carregam.
		probe-noise=0. Destaque: pf-cmt-1 (semântica bilateral 'ambas as partes'
		ambígua) é PRIORITÁRIO — afeta o golden-example bd-mutual-acceptance. Decisão
		da campanha: correção completa dos 7 gap-real em sessão própria. Convergência
		parcial com análise estática complementar registrada na run.rationale. Triado
		pelo founder.
		"""
}
