package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-012": artifact_schemas.#DeferredDecision & {
	id:    "def-012"
	title: "Adicionar structural-check sc-be-01 bootstrap-exception-stale-detection quando primeira stale transient exception observada OR volume cumulativo crescer"
	date:  "2026-05-03"

	description: """
		adr-070 promoveu #BootstrapException a schema first-class
		(category + lifecycle + exitCondition?). Schema agora permite
		query mecânica por categoria + lifecycle, mas detecção
		automática de stale transient exceptions (entries cuja
		artifactPath PASSOU a ter SRR matching, deveriam ter sido
		removidas do policy) ainda exige structural-check próprio.

		Stale detection sc-be-01 hipotético:
		- For each transient bootstrap exception entry e em
		  self-review-bootstrap-policy.cue:
		    Check if any *.self-review.cue file in governance/
		    build-time/self-reviews/ has artifactPath == e.artifactPath
		    If yes → warn 'transient bootstrap exception for
		             e.artifactPath is stale; SRR exists; remove
		             from policy'

		Quando trigger fire, decidir entre:
		(a) implementar sc-be-01 com kind existing (e.g.,
		conditional-file-presence INVERTIDO: warn quando file Y
		exists para cada entry); design fits if kinds são flexíveis
		o suficiente;
		(b) introduzir novo sc kind 'cross-file-relationship-presence'
		ou similar (mais general, scope adicional);
		(c) absorver detection em runner script externo (não sc) —
		menos consistente com pattern adr-040 (sc é deterministic
		gate canônico).

		Status atual: zero stale exceptions observadas
		empiricamente — nenhuma das 14 transient entries teve SRR
		matching path criado ainda. Sem evidence empírica, design
		do sc-be-01 seria especulação.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-070-promote-bootstrap-exception-to-firstclass-schema.cue",
		"governance/build-time/self-review-bootstrap-policy.cue",
	]

	deferralRationale: """
		Pattern ten-009 expand-when-needed: zero stale exceptions
		observadas empiricamente. Design do sc-be-01 sem casos
		concretos seria especulação sobre (a) qual kind sc usar (b)
		threshold de severity (c) action message format (d) onde
		executar (cross-cutting sc ou per-policy sc).

		Custo evitado: design + implementation + retroativos sem
		evidence empírica do que stale detection deve fazer.
		Custo de continuar deferindo: cleanup de stale exceptions
		é manual — founder lembra ao criar SRR matching path para
		entry transient OR volume crescente sinaliza crise. Manual
		é factível com 14 entries.

		Trade-off favorável a aguardar primeira stale empirical OR
		volume cumulativo significativo (threshold codificado em
		trigger 1).
		"""

	triggerCalibrationRationale: """
		Trigger 1 (file-content-occurrence-count, kind novo per
		adr-071) usa path 'governance/build-time/self-review-
		bootstrap-policy.cue' + pattern 'lifecycle:\\s+\"transient\"'
		threshold=20. Conta occurrences de 'lifecycle: "transient"'
		dentro do policy file. Baseline pós-adr-070 = 14 entries
		(cada com 'lifecycle: "transient"' = 1 occurrence). Threshold
		=20 fires +6 acima de baseline (i.e., quando 6 novas transient
		entries forem adicionadas em path-mapping ADRs subsequents).
		Calibração conservadora — não fires no commit que cria def-012
		(count=14 < 20) e absorve crescimento de 1-2 next path-mapping
		ADRs antes de fire.

		Pattern self-match check: pattern regex 'lifecycle:\\s+
		\"transient\"' busca chars 'lifecycle: "transient"' (com
		whitespace real, não escaped \\s+). def-012.cue contém literal
		'lifecycle:\\s+\"transient\"' (escaped) — não match na regex.
		Verified clean.

		Trigger 2 (manual-review) escape porque founder pode querer
		acionar antes (e.g., observar stale empirically antes de
		threshold; OR decidir implementar sc-be-01 antes de volume
		threshold por outras razões — e.g., infraestrutura de sc
		amadureceu separadamente).

		Por que adr-071 trigger kind file-content-occurrence-count
		é uso apropriado aqui (não abuse): policy file é singleton
		governance file canônico; sinal é quantidade de occurrences
		dentro desse arquivo (não files com matches across repo);
		recurrence scope=file-content não serve porque conta arquivos.
		Use case que originou o kind.
		"""

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Severity low porque stale detection é optimization (cleanup
			automation) não correctness gate. Manual cleanup permanece
			factível. BlastRadius local porque escopo é governance/
			build-time/self-review-bootstrap-policy.cue + structural-
			checks correlatos. Cresce marginalmente com volume de
			transient entries.
			"""
	}

	triggers: [{
		kind:      "file-content-occurrence-count"
		path:      "governance/build-time/self-review-bootstrap-policy.cue"
		pattern:   "lifecycle:\\s+\"transient\""
		threshold: 20
	}, {
		kind:   "manual-review"
		reason: "Founder pode querer acionar sc-be-01 antes do threshold (e.g., observar primeira stale exception empiricamente; OR maturação de outras decisões sobre sc kinds que faciliten design; OR re-priorização). Trigger automático é signal conservador, não gate de obrigação."
	}]

	status: "open"
}
