package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def090: artifact_schemas.#DeferredDecision & {
	id:     "def-090"
	title:  "Verificação de PROCEDÊNCIA do vo-fitness-signals (completude estrutural existe; procedência não)"
	date:   "2026-09-06"
	status: "open"

	description: """
		vo-fitness-signals (contexts/ssc/domain-model.cue) é a struct de
		inputs que o SSC consome para aplicar fitness rules — e o único
		check existente é de COMPLETUDE ESTRUTURAL: act-evaluate-signal-
		sufficiency (agent-spec do ssc) verifica campos required presentes
		e não-nulos, não de onde vieram nem se foram conferidos. As oq
		existentes tocam outras coisas (oq-ssc-1 sinais/eventos do NIM,
		oq-ssc-6 escopo de qualificação, oq-ssc-7 compromissos do CTR,
		oq-ssc-8 config/versionamento das fitness rules). Fica deferida a
		decisão de COMO verificar procedência: o que conta como sinal
		conferido, quem confere, e o que a decisão pode consumir sem
		conferência. Decisão do founder registrada (origem: protótipo,
		2026-09-06): dado não conferido NÃO sustenta decisão que a Mesh
		endossa — por isso o histórico saiu da tela de decisão. Consequência
		medida na superfície: custo de 1 célula de 13 no mapa, 0 na tela
		decidida. O que a verificação destrava: os sinais optional Phase 0
		(NIM performanceScore, CTR existingCommitments) entrando na decisão
		com procedência conferida, não presumida.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: em Phase 0 os sinais optional são null por
		construção (NIM e CTR ainda não populam) e os required nascem de
		consultas internas (NPM eligibility, RFQ context/responses) — a
		superfície onde procedência importa de verdade só materializa
		quando sinal externo começar a entrar na decisão. Desenhar o
		mecanismo de conferência antes disso é modelar verificador sem
		verificando. Custo evitado: mecanismo de procedência especulativo
		sobre sinais que ainda não fluem. Custo de continuar deferindo:
		quando performanceScore/existingCommitments popularem, a decisão
		endossada pela Mesh passa a consumir dado não conferido —
		exatamente o que a decisão do founder proíbe; a mitigação atual
		(histórico fora da tela) é postura de superfície, não verificação.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito): a condição real de revisita é
		sinal externo (NIM/CTR) começar a popular os campos optional — fato
		cross-BC de runtime futuro, não estado de disco deste repo que o
		runner possa avaliar sem falso-positivo.
		"""

	originatingArtifacts: [
		"contexts/ssc/domain-model.cue",
		"contexts/ssc/agents/ssc-primary-agent.cue",
		"session:passe-de-morada",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "local"
		description: """
			medium porque o custo cresce no tempo: hoje os sinais externos
			são null e a exposição é zero; quando popularem, decisão
			endossada sobre dado não conferido fere a tese da Mesh (dinheiro
			se move sobre fato provado). local porque o território é
			ssc-interno (1 VO + 1 act + a superfície de decisão). Exit:
			desenhar a conferência de procedência quando o primeiro sinal
			externo entrar no fluxo (pós-bootstrap NIM ou CTR cross-BC).
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "A condição real de revisita — NIM performanceScore ou CTR existingCommitments deixando de ser null no fluxo vivo — é fato de runtime cross-BC, invisível ao disco deste repo; predicado de conteúdo sobre 'procedência' dispararia em prosa existente e predicado de existência cravaria shape de mecanismo não-desenhado."
	}]
}
