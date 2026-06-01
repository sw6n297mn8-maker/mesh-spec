package agent_probes

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// scf.cue — probe-record do Ciclo 4 (adr-134) para o canvas SCF. Conforma a
// #AgentProbeRecord. Registro append-only da campanha de calibração (N=4):
// probe isolado de contexts/scf/canvas.cue, triado pelo founder. REGISTRA os
// buracos (audit-trail); a correção do canvas SCF é trabalho próprio.

records: "scf": artifact_schemas.#AgentProbeRecord & {
	targetCanvas:    "contexts/scf/canvas.cue"
	protocolVersion: "1"
	triaged:         true

	runs: [{
		probedAt: "2026-06-01"
		rationale: """
			Probe isolado contra contexts/scf/canvas.cue. 9 gaps reais (5 high
			incluindo as-T-13, 4 médios), 1 cross-bc-gap (oq-scf-2), 2 agrupamentos
			não-defeito. Zero alucinação material (probe-noise=0). as-T-13 é o achado
			mais valioso da campanha: o probe detectou uma contradição entre
			businessDecision e topologia (não uma lacuna de valor) — classe emergente
			de inconsistência interna. SCF é specification/analysis, natureza distinta
			de execução/gate, e os 3 padrões aparecem mesmo assim: as-T-03 (taxonomia),
			as-T-12 (estado/conflação), as-T-04/16 (predicado). Over-reach de
			nível-teste agrupado em already-specified.
			"""
		findings: [
			{
				id:           "pf-scf-1"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "bd-structures-not-executes vs communication.outbound ReceivableAdvanceOriginated (consumers: ['ato'])"
				description:  "as-T-13 — bd-structures-not-executes afirma que 'o SCF especifica o que o FCE executará downstream', mas consumers de ReceivableAdvanceOriginated lista apenas 'ato'; não há aresta scf->fce. A businessDecision contradiz a topologia de comunicação — o disbursement ao fornecedor não tem canal modelado. Classe emergente: inconsistência interna entre seções (contradição, não mera lacuna). Achado mais grave da campanha."
				rationale:    "Classe emergente — inconsistência interna entre seções: a businessDecision pressupõe um canal scf→fce que a topologia de comunicação não declara. Não é lacuna de valor (P0/etc.), é contradição entre duas seções da mesma spec."
				disposition: {acceptedAsResidual: "Correção do canvas SCF — adicionar aresta scf->fce OU reframe de bd-structures-not-executes. PRIORITÁRIO."}
			},
			{
				id:           "pf-scf-2"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "verificationMetrics funding-adverse-selection-ratio + QueryPortfolioEligibility"
				description:  "as-T-14 — a métrica funding-adverse-selection-ratio exige ratio fondado/disponível, mas QueryPortfolioEligibility é read-only e não há sinal de feedback do sh-03 sobre o que foi fondado. Métrica de controle de vetor adversarial inobservável na topologia atual."
				rationale:    "Padrão (b): a métrica de controle do vetor sh-03 pressupõe um sinal de feedback (o que foi fondado) que a topologia não modela — controle declarado mas inobservável."
				disposition: {acceptedAsResidual: "Correção do canvas SCF — modelar sinal de feedback de funding."}
			},
			{
				id:           "pf-scf-3"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "bd-eligibility-multi-source-composition (status conditionally-eligible)"
				description:  "as-T-03 — status conditionally-eligible citado mas o comportamento autônomo (origina ou roteia para supervisão?) não definido."
				rationale:    "Padrão (a) taxonomia citada-mas-não-fechada: o status existe mas a consequência de autonomia (originar vs escalar) não está na spec."
				disposition: {acceptedAsResidual: "Correção do canvas SCF."}
			},
			{
				id:           "pf-scf-4"
				category:     "spec-incompleteness"
				severity:     "high"
				specLocation: "ownership override-eligibility-on-stale-source (frescor por fonte)"
				description:  "as-T-04 — janela de frescor (TTL) por fonte não definida; governa o override de fonte stale (linha vermelha P10/P11)."
				rationale:    "Padrão (c): a linha vermelha (override de fonte stale) pende de um predicado de frescor (TTL) que a spec não declara."
				disposition: {acceptedAsResidual: "Correção do canvas SCF."}
			},
			{
				id:           "pf-scf-5"
				category:     "spec-ambiguity"
				severity:     "high"
				specLocation: "bd-structuring-not-funding-guarantee vs originate-advance-on-eligibility"
				description:  "as-T-12 — 'estruturar produto' (sem funding, bd-structuring-not-funding-guarantee) e 'originar antecipação' (capital ao fornecedor) conflacionados; distinção load-bearing."
				rationale:    "Padrão (b) estado/conflação: duas operações economicamente distintas (estruturar vs originar) não são separadas na spec, apesar de a distinção ser load-bearing para a invariante de honestidade."
				disposition: {acceptedAsResidual: "Correção do canvas SCF."}
			},
			{
				id:           "pf-scf-6"
				category:     "spec-ambiguity"
				severity:     "medium"
				specLocation: "communication query-dependency QueryRiskScore/QueryEligibility vs cache RiskScoreEmitted/EligibilityEmitted"
				description:  "as-T-05 — precedência entre query sync e cache event-driven no gate de originação não definida ('complementar' + 'drift detectável', mas qual prevalece?)."
				rationale:    "Ambiguidade de precedência: a spec diz 'complementar' mas não qual fonte prevalece no gate quando divergem."
				disposition: {acceptedAsResidual: "Correção do canvas SCF."}
			},
			{
				id:           "pf-scf-7"
				category:     "spec-ambiguity"
				severity:     "medium"
				specLocation: "bd-eligibility-multi-source-composition (consistência cross-source)"
				description:  "as-T-16 — 'termos que não batem' e 'cobertura divergente' (predicado de inconsistência cross-source) não definidos; a invariante própria multi-source depende disso."
				rationale:    "Padrão (c) predicado impreciso: a invariante própria (composição multi-fonte) pende de um predicado de consistência que a spec não fixa."
				disposition: {acceptedAsResidual: "Correção do canvas SCF."}
			},
			{
				id:           "pf-scf-8"
				category:     "spec-ambiguity"
				severity:     "medium"
				specLocation: "communication.inbound ContractTermsSuperseded"
				description:  "as-T-07 — efeito de ContractTermsSuperseded sobre operações já originadas ('pode afetar condições') ambíguo: retroativo ou pinado?"
				rationale:    "Ambiguidade: a spec não diz se operações originadas são pinadas aos termos vigentes na originação ou re-sujeitas à supersessão."
				disposition: {acceptedAsResidual: "Correção do canvas SCF."}
			},
			{
				id:           "pf-scf-9"
				category:     "spec-incompleteness"
				severity:     "medium"
				specLocation: "communication.inbound ins (CoverageActivated/Lapsed)"
				description:  "as-T-08 — condicionalidade da cobertura INS (requerida vs opcional por produto) não definida."
				rationale:    "Lacuna: a spec consome estado de cobertura mas não declara quando a cobertura é pré-requisito de elegibilidade vs opcional por produto."
				disposition: {acceptedAsResidual: "Correção do canvas SCF."}
			},
			{
				id:           "pf-scf-10"
				category:     "cross-bc-gap"
				severity:     "low"
				specLocation: "communication.inbound ins CoverageActivated/Lapsed/ClaimFiled"
				description:  "as-T-09 — eventos INS (CoverageActivated/Lapsed/ClaimFiled) assumidos como carregando ref ao ativo; INS não scaffolded (oq-scf-2)."
				rationale:    "Gap real owned por OUTRO canvas (INS): o contrato dos eventos de cobertura é do INS, ainda não scaffolded."
				disposition: {acceptedAsResidual: "oq-scf-2 — scaffold do INS valida bidirecional."}
			},
			{
				id:           "pf-scf-11"
				category:     "already-specified"
				severity:     "low"
				specLocation: "as-scf-4"
				description:  "as-T-10 — critérios de securitização como input externo: o canvas já diz isso em as-scf-4."
				rationale:    "Already-specified: as-scf-4 declara que os critérios de securitização são input regulatório externo; o probe assumiu o que a spec já fixa."
			},
			{
				id:          "pf-scf-12"
				category:    "already-specified"
				severity:    "low"
				description: "as-T-01/02/06/11/15 — inferências seguras (productType discriminador, payload de eventos, chave de correlação, authz da query, idempotência/ordenação)."
				rationale:   "Already-specified (agrupa inferências-seguras): a spec sustenta o nível de canvas; os pontos assumidos são detalhe de implementação."
			},
		]
	}]

	summary: """
		Probe de calibração do Ciclo 4 no SCF (supporting, revenue-generator,
		specification/analysis). 9 buracos reais incluindo pf-scf-1 (contradição BD vs
		topologia, classe emergente). 0 alucinação.
		"""

	rationale: """
		Record append-only do probe SCF (4º da campanha N=4). DoD-completeness: 9 gaps
		reais deste canvas + 1 cross-bc-gap (oq-scf-2) carregam disposition
		acceptedAsResidual; os 2 agrupamentos already-specified não carregam. probe-noise=0.
		Destaque: pf-scf-1 (as-T-13) é uma classe emergente — inconsistência interna
		entre seções (businessDecision contradiz topologia), não lacuna de valor; o
		achado mais valioso da campanha e PRIORITÁRIO na correção do SCF. Triado pelo founder.
		"""
}
