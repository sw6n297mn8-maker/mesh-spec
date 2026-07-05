package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def075StoryTermGlossaryResolution: build_time.#SelfReviewReport & {
	reportId: "srr-def-075-story-term-glossary-resolution"

	artifactPath:       "architecture/deferred-decisions/def-075-story-term-glossary-resolution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-05"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do def-075 (resolução canônica de termos em domain stories
			cross-BC; o elo FROUXO do termRefs declarado no adr-170 item 4).

			[uq-08 CONFORMÂNCIA #DeferredDecision]: OK. cue vet EXIT=0; id/title/date/status/
			description/deferralRationale/triggerCalibrationRationale/originatingArtifacts/
			costOfDeferral/triggers todos presentes e tipados. Número def-075 confirmado
			próximo-livre via freshness --assert (G2).

			[ANTI-CATCH-ALL — é DD, não WI/tension/bug]: OK. Deferimento consciente genuíno:
			decisão explícita de NÃO decidir agora o modelo de resolução (a/b/c enumeradas),
			COM trade-off articulado E condição codificada de revisita. Não é trabalho rotineiro
			(nada a executar até amostra existir), não é tensão entre forças (é ausência de
			evidência), não é bug (o elo frouxo é escolha declarada, não defeito).

			[tq-def-01 TRADE-OFF CONCRETO]: OK. Custo evitado: gate de termo nascido errado
			(apontando o lar errado) + artefato novo sem evidência. Custo de continuar: typo em
			termRef passa silencioso até a decisão — mitigado por opcionais + founder review
			integral da 1ª story. Não é 'fazer depois'.

			[tq-def-02 TRIGGERS CODIFICADOS]: OK. recurrence file-content 'termRefs:' com
			pathScope ^strategic/domain-stories/ e threshold 2 — pega o USO real do elo, não a
			mera existência de stories.

			[tq-def-03 ≥1 NON-MANUAL]: OK. O recurrence é machine-evaluable; o manual-review
			adicional carrega reason substantiva (arquitetura de glossários é julgamento do
			founder), não default por preguiça.

			[tq-def-04 costOfDeferral COERENTE]: OK. low/local coerente com termRefs opcionais
			sem gate — ausência de decisão não corrompe nada; escopo = subsistema story+glossários.

			[uq-03 REFS]: OK, verificadas no disco — tq-gl-02 existe no schema de glossary
			(cross-glossário não-suportado), adr-151 existe (kernel compartilhado), adr-170 e
			o schema domain-story.cue entram no mesmo commit (originatingArtifacts resolve).
			[uq-01 WHY]: OK. [uq-02 MESH]: OK — ancorado na arquitetura por-BC dos glossários
			da Mesh e no kernel adr-151. [uq-04]: OK — defere em vez de contradizer tq-gl-02.
			[uq-05]: OK — a limitação (typo silencioso) está declarada no próprio deferralRationale.
			[uq-06 UL]: OK. [uq-07]: OK — zero placeholder.

			[uq-09 SECTION GATES]: PG deferred-decision aplicado; autoria dentro do arco de
			checkpoint único definido pelo founder (Tempo 2); auto-checks em batch no checkpoint
			(cláusula batch do serializationRule, pattern def-074).
			"""
	}]

	findings: {}

	summary: """
		def-075: deferimento consciente da resolução canônica de termos cross-BC em domain stories
		(convenção-sem-gate atual vs glossário-de-story vs kernel adr-151) até existir amostra real
		(>=2 stories usando termRefs). VEREDITO: stable, 0 fail, 0 warn. Trade-off concreto, trigger
		recurrence machine-evaluable com threshold no USO do elo, manual-review com reason
		substantiva, custo low/local coerente com refs opcionais sem gate.
		"""

	singleRoundRationale: """
		Round único proporcional: o deferimento codifica exatamente a decisão D-elo-frouxo tomada
		no desenho do pacote domain-story (o review isolado pré-escrita do schema apontou o def
		fantasma como BLOCKER — este artefato é a correção que o materializa de verdade). O
		conteúdo substantivo (opções a/b/c, tq-gl-02, adr-151) foi validado na investigação da
		teia de coerência que precedeu a fatia; o round confirmou conformância e calibração sem
		findings novos.
		"""
}
