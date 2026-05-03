package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-004": artifact_schemas.#DeferredDecision & {
	id:    "def-004"
	title: "Formalize tq-as-05 quality criterion in #ArtifactSchema OR convert ~30 repo-wide references"
	date:  "2026-05-03"

	description: """
		tq-as-05 é convenção informal usada em 30+ referências cross-repo
		(em production-guides, ADRs, self-reviews) mas NUNCA formalmente
		definida em architecture/artifact-schemas/artifact-schema.cue
		_qualityCriteria. Schema atual define apenas tq-as-01 a tq-as-03.
		Resolução exige escolha entre dois caminhos: (a) formalizar
		definição de tq-as-05 no schema (audit dos 30+ refs para
		consistency); ou (b) converter todos refs para tq-as-XX existentes
		ou novo critério com id diferente.
		"""

	originatingArtifacts: [
		"architecture/production-guides/tension-entry.cue",
		"governance/build-time/subagent-execution-log.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) WI-069 first
		dispatch: review subagent identificou que tq-as-05 é referenciado
		em ~30 lugares mas não formalmente definido em
		artifact-schema.cue. Review explicit: "NÃO é defeito introduzido
		por este PG — shared problem do repo".
		Custo evitado por NÃO resolver agora: cleanup de 30+ refs
		(production-guides, ADRs, self-reviews) é trabalho mecânico mas
		não trivial; founder ainda não articulou trade-off entre
		formalizar (definir tq-as-05 com test/severity/rationale
		específicos) vs converter (escolher tq-as-XX equivalente OU criar
		novo id consistente). Escolha exige design judgment não
		formalizado ainda. Continuar usando convenção informal funciona
		operacionalmente — nenhum consumer atual falha por falta da
		definição (regex de format passa; semantic é assumido).
		Custo de continuar deferindo: novos refs continuam acumulando
		(este commit adiciona pelo menos 1 mais via tension-entry PG);
		drift potencial entre intenção semântica de tq-as-05 e usage
		efetivo se não houver definição central; risk de inconsistency
		latent quando founder decidir formalizar (alguns refs podem não
		corresponder ao test definido).
		"""

	triggerCalibrationRationale: """
		Trigger 1 (volume-threshold) calibrado em 35 refs: hoje 30+
		conhecidos + commits desta sessão adicionam ~3-5 (tension-entry
		PG + execution log + def-004 + commit message). Threshold 35
		captura crescimento para 50% além do baseline atual — sinal de
		que convenção está crescendo sem decisão. Pattern usa
		recurrence (não volume-threshold do schema) porque artifactType
		'tq-as-05-reference' não existe — é texto livre dispersado.
		Trigger 2 (manual-review) escape: founder pode priorizar
		quando schema cleanup major surgir (e.g., adr para artifact-
		schema evolution). False-positive verified: pattern 'tq-as-05'
		é específico (não matches outros tq-as-XX); ocorrências atuais
		são todas legítimas refs à convenção informal.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "cross-cutting"
		description: """
			Convenção funciona operacionalmente; nenhum quality-gate
			falha por falta da definição. Drift potencial é hipotético
			(depende de futuro author entender tq-as-05 diferentemente
			do uso histórico). blastRadius cross-cutting porque refs
			estão dispersos entre architecture/production-guides/,
			architecture/adrs/, governance/build-time/self-reviews/.
			Severity low porque cleanup é mecânico (busca + replace ou
			adicionar definition) sem risco de regressão semântica
			imediata.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "tq-as-05"
		scope:     "file-content"
		threshold: 35
	}, {
		kind:   "manual-review"
		reason: "Founder pode formalizar tq-as-05 OR convert refs durante schema cleanup major futuro — e.g., quando authoring-policy evolution ou structural-check refactor surge oportunidade adjacente."
	}]

	status: "open"
}
