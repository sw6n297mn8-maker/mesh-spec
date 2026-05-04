package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-011": artifact_schemas.#DeferredDecision & {
	id:    "def-011"
	title: "Promover #BootstrapException a schema first-class — fields category + lifecycle + exitCondition"
	date:  "2026-05-03"

	description: """
		adr-067 estabeleceu path-mapping para production-guide e
		introduziu 3ª categoria de exceptions em self-review-bootstrap-
		policy.cue ('pre-mapping-transient'): 4 PGs em main que existem
		sem SRR matching path porque foram criadas/modificadas pre-adr-
		067 enforcement. Categoria distingue-se das duas anteriores
		(inaugural-circularity, predecessor-supersession-only) por ser
		TRANSIENTE — exception sai do policy quando próxima modificação
		criar SRR matching path.

		Hoje a distinção transient vs permanent + identidade da categoria
		vivem APENAS no campo 'rationale' (prose). Schema #BootstrapException
		tem só 2 campos: artifactPath + rationale. Sem field para category,
		lifecycle, exitCondition, ou enforcement automático de stale
		exception cleanup.

		Quando trigger fire, decidir entre:
		(a) promover schema com fields category (enum), lifecycle
		('permanent' | 'transient'), exitCondition (string conditional
		on lifecycle == 'transient') + criar structural-check
		'bootstrap-exception-stale-detection' que warn quando transient
		exception persiste após SRR matching path passar a existir;
		(b) manter pattern atual (semantica em rationale prose) — aceita
		ausência de enforcement de cleanup como custo;
		(c) hybrid — adicionar só campo 'category' enum sem lifecycle/
		exitCondition (cleanup permanece manual mas categorização é
		queryable mecanicamente).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-067-extend-artifact-type-for-production-guide.cue",
		"governance/build-time/self-review-bootstrap-policy.cue",
	]

	deferralRationale: """
		Volume insuficiente para generalização (pattern ten-009 expand-
		when-needed): 1 categoria nova com 4 entries em batch único.
		Sem evidence empírica de quais campos são realmente necessários
		— enum 'category' fechado em n=1 calcificaria taxonomia
		prematuramente; field 'exitCondition' especulativo sem volume
		de transient exceptions stale detectadas. Custo evitado:
		ceremony de schema bump + migration de 6 entries existentes (que
		precisariam classificação retroativa) + structural-check novo
		sem volume validado. Custo de continuar: stale exception cleanup
		é manual (founder revisita ao tocar PG); ausência de query
		mecânica por categoria. Trade-off favorável a aguardar próximos
		path-mapping ADRs (structural-check, validation-prompt) — se
		gerarem novos batches de transient exceptions, n cresce e
		evidência calibra schema.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence scope=filename) usa pattern
		'^architecture/adrs/adr-\\\\d+-extend-artifact-type-for-.*\\\\.cue$'
		threshold=4. Conta hoje: 3 (adr-061, adr-066, adr-067). O
		trigger dispara quando houver o próximo, isto é, a 4ª ocorrência
		— ao próximo path-mapping ADR (adr-068+) ser criado. Calibração
		intencional: threshold marca momento em que pattern de extensão
		progressiva acumulou evidence suficiente (3 ADRs já estabelecem
		recurrência; +1 confirma que padrão segue gerando exception
		batches transient e justifica schema first-class). Pattern
		self-match check: este def-011 file não está em
		architecture/adrs/, não causa false positive.

		Trigger 2 (manual-review) escape porque automação completa NÃO
		é viável neste caso: schema atual não tem field para distinguir
		transient/permanent → contagem mecânica de transient exceptions
		requereria parser do prose rationale (frágil). Founder revisita
		quando próximo ADR de path-mapping for redigido OR quando
		percepção de stale-exception accumulation justificar schema bump.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "local"
		description: """
			Severity low porque #BootstrapException é mecanismo de governance
			meta-estrutural (não BC operacional, não contrato público).
			BlastRadius local porque escopo é governance/build-time/self-
			review-bootstrap-policy.cue + structural-checks correlatos
			apenas. Cleanup stale exception manual permanece factível com
			4 entries; cresce marginalmente se múltiplos path-mapping ADRs
			adicionarem batches.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "^architecture/adrs/adr-\\d+-extend-artifact-type-for-.*\\.cue$"
		scope:     "filename"
		threshold: 4
	}, {
		kind:   "manual-review"
		reason: "Schema atual sem field category/lifecycle → contagem mecânica de transient exceptions requereria parser de prose rationale (frágil). Founder revisita quando próximo path-mapping ADR for redigido OR quando percepção de stale-exception accumulation justificar schema bump. Automação completa não viável até schema first-class existir (que é exatamente o que este def-011 difere)."
	}]

	status:             "resolved"
	triggeredAt:        "2026-05-03"
	triggeredCondition: "Trigger 1 fired duas vezes consecutivas em adr-068 (count 3→4) e adr-069 (count 4→5); founder articulou em adr-069 Known gaps que def-011 deveria ser actively reconsidered before next path-mapping ADR. Reconsideração ativa decidiu por promoção a schema first-class."
	resolvedBy:         "architecture/adrs/adr-070-promote-bootstrap-exception-to-firstclass-schema.cue"
}
