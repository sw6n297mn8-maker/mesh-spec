package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr171PromoteDomainStoryGatesToReject: build_time.#SelfReviewReport & {
	reportId: "srr-adr-171-promote-domain-story-gates-to-reject"

	artifactPath:       "architecture/adrs/adr-171-promote-domain-story-gates-to-reject.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-08"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — review por sub-agente ISOLADO (sem histórico da conversa;
			inputContract do quality-gate). ZERO findings. Todas as alegações
			verificáveis do ADR foram REPRODUZIDAS no disco pelo sub-agente:
			8/8 sc-ds com enforcement reject e header fiel; 1ª instância real
			existe com code correto (única no diretório — '1ª story' é factual);
			'7 exercitados + sc-ds-06 vacuamente verde' conferido por grep
			(policyRefs: zero ocorrências na story); TODAS as refs preenchidas
			resolvidas elemento a elemento na coleção correta do domain-model do
			BC do próprio passo (com números de linha); runner 31/0 exit 0 com
			zero sc-ds no output — prova forte, pois em reject qualquer violação
			seria bloqueante; SELF-TEST PASS; cue vet limpo; precedentes conferem
			(adr-097 catraca; adr-114/123 reversão 1-linha; adr-169 fixture;
			adr-170 defere textualmente a promoção para 'junto da 1ª story
			real').

			Critérios: uq-01..08 OK; tq-adr-01 OK (alternativa 'promover só os 7'
			rejeitada com justificativa); tq-adr-02 OK (reversibility high per
			precedente; cross-cutting defensável) com OBSERVAÇÃO de calibração
			sem severidade: a família de promoções não tem convenção estável de
			blastRadius (adr-114 repo-wide para 5 checks; adr-123 local para 1);
			tq-adr-03/04 OK. uq-04: o sub-agente avaliou e descartou como
			não-violação a tensão sc-ds-06-vacuamente-verde vs leitura estrita da
			catraca — declarada e vigiada em falsificationCondition, não
			contradição silenciosa. uq-09: não-avaliável em isolamento (por
			construção); evidência de section gates registrada AQUI: PG-ADR
			aplicado dentro do arco de checkpoint único definido pelo founder
			(fatia 1 aprovada com 'Sim' após proposta integral), auto-checks em
			batch no checkpoint (cláusula batch do serializationRule, pattern
			def-074).
			"""
	}]

	findings: {}

	summary: """
		adr-171 (catraca: sc-ds-01..08 warn→reject junto da 1ª story real):
		review ISOLADO com ZERO findings — condição de catraca reproduzida no
		disco (não alegada), refs da story verificadas elemento a elemento,
		baseline 31/0 com gates já em reject, precedentes fiéis. VEREDITO:
		stable, apto a proposta sem disclaimer.
		"""

	singleRoundRationale: """
		Round único isolado suficiente: o ADR executa uma decisão JÁ deferida
		textualmente pelo adr-170 ('promoção junto da 1ª story real') sob
		condição machine-verificável que o próprio review reproduziu (runner
		31/0 com reject ativo); não há dimensão interpretativa residual que um
		segundo round alcançaria além do que o gate determinístico já prova.
		"""
}
