package agent_probes

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// drc.cue — probe-record do Ciclo 4 (adr-134) para o canvas DRC. Conforma a
// #AgentProbeRecord. Registro append-only da campanha de calibração (N=4):
// probe isolado de contexts/drc/canvas.cue, triado pelo founder. REGISTRA os
// buracos (audit-trail); a correção do canvas DRC é trabalho próprio.

records: "drc": artifact_schemas.#AgentProbeRecord & {
	targetCanvas:    "contexts/drc/canvas.cue"
	protocolVersion: "1"
	triaged:         true

	runs: [{
		probedAt: "2026-06-01"
		rationale: """
			Probe isolado contra contexts/drc/canvas.cue. 8 gaps reais (5 high: A-1
			comando ausente, A-2 enum outcome, A-3 suficiência de evidência, A-4
			threshold, A-10 cardinalidade de publishers; 3 médios), 1 cross-bc-gap
			(oq-drc-4), 3 agrupamentos não-defeito. Zero alucinação material
			(probe-noise=0). DRC rendeu mais gaps altos que FCE/BDG — coerente:
			resolução por julgamento (não gate determinístico) gera mais pontos de
			indefinição. Os 3 padrões presentes: A-2 (taxonomia), A-14
			(estado/transição), A-3 (predicado). Over-reach de nível-teste agrupado
			em already-specified.
			"""
		findings: [
			{
				id:           "pf-drc-1"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "ownership register-dispute + capabilities.hasSyncSurface + communication.inbound QueryDisputeStatus"
				description:  "A-1 — register-dispute lista 'alegação de parte' como gatilho e hasSyncSurface=true, mas a superfície sync enumera só QueryDisputeStatus. Falta o comando inbound de abertura de disputa por parte."
				rationale:    "Padrão (b) estado/evento sem caminho completo: o gatilho de abertura por parte é citado mas não tem comando inbound na superfície sync."
				disposition: {acceptedAsResidual: "Correção do canvas DRC — formalizar comando de abertura por parte."}
			},
			{
				id:           "pf-drc-2"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "communication.inbound QueryDisputeStatus.returnType (resolutionOutcome)"
				description:  "A-2 — campo resolutionOutcome citado mas o conjunto de valores não é enumerado."
				rationale:    "Padrão (a) taxonomia citada-mas-não-fechada: o desfecho da disputa governa reações downstream, mas seus valores não são estáveis na spec."
				disposition: {acceptedAsResidual: "Correção do canvas DRC — enumerar resolutionOutcome."}
			},
			{
				id:           "pf-drc-3"
				category:     "spec-ambiguity"
				severity:     "high"
				specLocation: "bd-resolution-requires-evidence"
				description:  "A-3 — 'evidência suficiente' (a invariante central bd-resolution-requires-evidence) não quantificada."
				rationale:    "Padrão (c) predicado de gate impreciso: a invariante própria do DRC pende de um critério de suficiência que a spec não define."
				disposition: {acceptedAsResidual: "Correção do canvas DRC — definir critério de suficiência de evidência."}
			},
			{
				id:           "pf-drc-4"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "bd-material-resolution-human-gated (threshold de materialidade)"
				description:  "A-4 — estrutura do threshold de materialidade (o gate central de autonomia) não definida."
				rationale:    "O threshold material/imaterial é o discriminante de autonomia (autônomo vs supervisionado), mas sua estrutura/dimensões não constam."
				disposition: {acceptedAsResidual: "Correção do canvas DRC — definir estrutura do threshold."}
			},
			{
				id:           "pf-drc-5"
				category:     "spec-ambiguity"
				severity:     "high"
				specLocation: "communication.outbound (DisputeResolved / CommitmentSuspensionOrdered / FinancialCompensationOrdered)"
				description:  "A-10 — cardinalidade entre os 3 publishers não especificada: relação entre DisputeResolved (âncora?) e CommitmentSuspensionOrdered/FinancialCompensationOrdered (adicionais?)."
				rationale:    "A spec lista 3 eventos de saída mas não diz se DisputeResolved sempre acompanha os outros dois ou são mutuamente exclusivos — ambiguidade de contrato de saída."
				disposition: {acceptedAsResidual: "Correção do canvas DRC — especificar cardinalidade dos eventos de saída."}
			},
			{
				id:           "pf-drc-6"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "communication.inbound DeliveryVerified (post-verification-dispute)"
				description:  "A-5 — duração da janela de economic finality (post-verification-dispute) não especificada."
				rationale:    "A reação post-verification-dispute pressupõe uma janela cuja duração a spec não declara."
				disposition: {acceptedAsResidual: "Correção do canvas DRC."}
			},
			{
				id:           "pf-drc-7"
				category:     "spec-ambiguity"
				severity:     "medium"
				specLocation: "QueryDisputeStatus.status (open/under-evaluation/resolved)"
				description:  "A-14 — regras de transição entre estados (e skip de under-evaluation para disputa imaterial categórica) não definidas."
				rationale:    "Padrão (b): os estados são enumerados mas as transições (e o skip no caso categórico) não — state machine subespecificada."
				disposition: {acceptedAsResidual: "Correção do canvas DRC."}
			},
			{
				id:           "pf-drc-8"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "QueryDisputeStatus.status ('resolved')"
				description:  "A-15 — finalidade de 'resolved' (ausência de appeal/reabertura) não declarada."
				rationale:    "A spec não diz se 'resolved' é terminal ou admite reabertura/appeal — lacuna no ciclo de vida da disputa."
				disposition: {acceptedAsResidual: "Correção do canvas DRC."}
			},
			{
				id:           "pf-drc-9"
				category:     "cross-bc-gap"
				severity:     "medium"
				specLocation: "communication.outbound DisputeResolved/FinancialCompensationOrdered (→ fce)"
				description:  "oq-drc-4 — DisputeResolved e FinancialCompensationOrdered são publicados para o FCE, mas o canvas FCE não enumera DRC como source (forward-ref cross-BC)."
				rationale:    "Gap real, mas owned por OUTRO canvas (FCE): o DRC publica corretamente; a reconciliação do consumo é do lado FCE."
				disposition: {acceptedAsResidual: "oq-drc-4 — reconciliação cross-BC; FCE formaliza consumo. Owned pela correção do FCE."}
			},
			{
				id:           "pf-drc-10"
				category:     "already-specified"
				severity:     "low"
				specLocation: "escalationCriteria suspected-dispute-fraud + verificationMetrics frivolous-dispute-rate"
				description:  "A-17 — sinal de detecção de fraude: o canvas já dá escalationCriteria suspected-dispute-fraud + métrica frivolous-dispute-rate; o limiar exato é provisório e declarado."
				rationale:    "Already-specified: o mecanismo de detecção consta; o limiar provisório é open question declarada, não buraco oculto."
			},
			{
				id:           "pf-drc-11"
				category:     "already-specified"
				severity:     "low"
				specLocation: "communication.inbound ContractTermsSuperseded ('disputas em curso')"
				description:  "A-9 — escopo de reavaliação por supersessão ('disputas em curso' = open/under-evaluation, não resolved): leitura fiel do canvas."
				rationale:    "Already-specified: 'em curso' segue diretamente dos estados não-terminais; o probe assumiu o que a spec já implica."
			},
			{
				id:          "pf-drc-12"
				category:    "already-specified"
				severity:    "low"
				description: "A-6/A-7/A-8/A-11/A-12/A-13/A-16 — inferências seguras (integrityProof, idempotência, ordem parcial, fluxo de penalidade, tipo de decidedBy, cardinalidade disputa-compromisso, derivação de prazo regulatório)."
				rationale:   "Already-specified (agrupa inferências-seguras): a spec sustenta o nível de canvas; os pontos assumidos são detalhe de implementação ou derivam de campos já declarados."
			},
		]
	}]

	summary: """
		Probe de calibração do Ciclo 4 no DRC (supporting, operational-enabler,
		default supervisionado). 8 buracos reais, 0 alucinação. BC de maior superfície
		semântica dos três supporting.
		"""

	rationale: """
		Record append-only do probe DRC (3º da campanha N=4). DoD-completeness: 8 gaps
		reais deste canvas + 1 cross-bc-gap (oq-drc-4) carregam disposition
		acceptedAsResidual (correção = trabalho próprio; o cross-bc é owned pelo FCE);
		os 3 agrupamentos already-specified não carregam disposition. probe-noise=0
		(zero alucinação; over-reach de nível-teste agrupado em already-specified). DRC
		rendeu o maior nº de gaps high entre os supporting — coerente com resolução por
		julgamento (P10), não gate determinístico. Triado pelo founder.
		"""
}
