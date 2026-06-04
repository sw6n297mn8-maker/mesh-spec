package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

cmtCanvas: build_time.#SelfReviewReport & {
	reportId: "srr-canvas-cmt"

	artifactPath:       "contexts/cmt/canvas.cue"
	artifactSchemaPath: "architecture/artifact-schemas/canvas.cue"
	artifactType:       "canvas"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-03"

	roundsExecuted: 4
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliou CMT canvas contra 8 critérios universais (uq-01..08) e
			12 type-specific (tq-cv-01..12). Zero findings. Destaques:
			uq-02 (Mesh-specific) passa porque canvas referencia
			mech-evidence, mech-agent-gate, CommitmentId, dp-08, dp-10.
			uq-03 (cross-refs) passa com sh-01..05, ce-02, cc-04 e 4
			context refs (rew, drc, ctr, bdg) validados contra
			stakeholder-map, domain-definition e context-map. tq-cv-03
			(incentive analysis) passa com manipulationCost concreto para
			proponente (inflação detectada por DLV/REW) e contraparte
			(sub-dimensionamento detectado na verificação). tq-cv-06
			(communication coherence) passa com sync entries
			(ConfirmCommitmentAcceptance, QueryCommitmentState,
			QueryContractTerms) e async entries (ProposeCommitment,
			3 event-consumers, 2 event-publishers). tq-cv-10 (core BC
			com costsEliminated) passa com ce-02 preenchido.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 (adr-043 Fase 1 backfill — primeira descida ao plano
			operacional canvas): adicionado campo verticalApplicability
			ao canvas CMT. Classificação: vertical-adaptable / construction.

			Análise estrutural: o núcleo do CMT (aceite mútuo bilateral
			como invariante, CommitmentId como fio de rastreabilidade
			end-to-end, validação síncrona de termos contra CTR,
			communication patterns DDD, governance scope mech-agent-gate)
			é universal — padrões de teoria dos contratos B2B e DDD,
			reutilizáveis em qualquer cadeia produtiva com formalização
			de compromissos econômicos rastreáveis.

			Smoking gun para adaptable (não agnostic): o próprio canvas
			enumera três pontos de variação concretos por vertical, cada
			um amarrado a uma assumption ou open question existente:
			(1) as-cmt-1 escopa "aceite bilateral síncrono" ao "vertical
			de construção civil"; (2) as-cmt-3 reconhece que "construção
			civil demanda compromissos hierárquicos por medição" —
			vocabulário de obra embebido na premissa; (3) oq-cmt-2
			declara textualmente "Mesh planeja expansão multi-vertical.
			Invariante que funciona na construção civil pode não
			funcionar em logística ou energia". Esta enumeração explícita
			satisfaz o critério de ten-007: "adaptable exige identificar
			pontos de variação concretos no artefato".

			Stakeholders confirmam o anchoring construção em sh-01
			("Construtora", "contratos de obra"). Demais stakeholders
			(fornecedor, IF, regulador, agente) descritos em vocabulário
			cross-vertical neutro.

			Calibração da heurística de ten-007: hipótese a priori
			vertical-adaptable/construction (~55% confiança); análise
			confirmou (~85% confiança). Sem erro de calibração — caso
			genuinamente híbrido com evidência textual nas duas direções.
			Diferente do erro conservador observado em scf, onde a
			ausência de pontos de variação enumerados deveria ter
			sinalizado agnostic já no a priori.

			Cross-plane test: cmt subdomain ainda não classificado
			(strategic/subdomains/cmt.cue sem verticalApplicability).
			Fica como experimento deliberado próximo, não como apêndice
			deste commit. Hipótese para cross-plane test futuro: o
			subdomain pode aparecer como agnostic ou adaptable mais
			raso, dado que opera no plano de fronteira (negativeBoundaries)
			onde os pontos de variação operacionais (sincronia de
			aceite, hierarquia, padrão cultural) tipicamente não
			aparecem.

			tq-cv-13 (novo critério em canvas.cue) pass: campo presente,
			mode coerente com evidência estrutural, primaryVertical
			declarado, rationale explicita os três pontos de variação
			com referências a IDs internos do canvas (as-cmt-1, as-cmt-3,
			oq-cmt-2). cue vet pass.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 3 (adr-142, Fatia A+C — correção do contrato de aceite): bd-mutual-acceptance reescrito
			para o aceite bilateral assimétrico (proponente implícito via ProposeCommitment; contraparte
			explícita via ConfirmCommitmentAcceptance) com "termos idênticos" verificado por igualdade de
			termsHash (sha256 de canonical({contractTermsRef, scope})). bd-terms-validation declara
			fail-closed em propose-time e remete o SLA numérico a def-046. communication.outbound
			CommitmentAccepted: publicação única no aceite (sem sobreposição com CommitmentStateChanged) +
			payload com termsHash/confirmedBy (mech-evidence). Zero findings: uq-02 mantém Mesh-specificity
			(mech-evidence, dp-08/dp-10, CommitmentId); uq-03 cross-refs ok (def-046 criado no mesmo
			pacote); uq-06 ubiquitous language consistente (termsHash/AcceptanceConfirmation). cue vet
			./... EXIT=0.
			"""
	}, {
		round:     4
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 4 (adr-143, Fatia B — orquestração de disputa): inbound DisputeResolved detalha o ACL
			consumer (enum local #DisputeResolution {cancel | modify_terms | maintain}; canonicalização DRC
			deferida a def-047) e as 3 resoluções (cancel / modify_terms-revalida-CTR / maintain-supervisionado).
			Nova businessDecision bd-dispute-bounded-by-ctr: disputa não cria termo material fora do CTR
			(modify_terms revalida CTR fail-closed; notificação downstream deferida a def-048). Zero findings:
			uq-02 Mesh-specific (CTR/DRC/hierarquia/dp-08/dp-10); uq-03 refs ok (def-047/048/adr-143 no mesmo
			pacote); uq-06 ubiquitous language consistente. cue vet ./... EXIT=0.
			"""
	}]

	findings: {}

	summary: """
		CMT canvas é o primeiro BC canvas instanciando o schema evoluído
		(ADR-034). Cobre identidade, classificação (core/revenue-generator/
		custom), domain roles (execution + draft), 3 capabilities operacionais,
		comunicação alinhada com context map (5 relationships), 3 business
		decisions (aceite bilateral, CommitmentId origin, validação de termos),
		5 stakeholders, custo eliminado (ce-02), incentive analysis com 2
		participantes, ownership com domainAgentSpec canônico por path,
		governance scope (3 autônomas, 2 supervisionadas, 3 escalação),
		3 assumptions, 2 open questions e 3 verification metrics. Estável
		em 1 round após 3 rounds de red-team e 4 ajustes do founder.
		"""
}
