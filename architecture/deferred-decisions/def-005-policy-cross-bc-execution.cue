package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-005": artifact_schemas.#DeferredDecision & {
	id:    "def-005"
	title: "Policy cross-BC execution mechanism — onde e como avaliar policies que cruzam fronteira de BC"
	date:  "2026-05-03"

	description: """
		adr-065 estabeleceu PLR como registry-only com schema enforcement:
		'external' literal-locked. Quando primeira policy cross-BC
		concreta materializar (scope: cross-bc), decidir qual mecanismo
		de execução: (a) policy executada em cada BC com coordenação por
		evento; (b) policy executada em coordinator dedicado (acoplamento);
		(c) workflow/saga em cross-context-flow patterns. Decisão depende
		de policy concreta + maturity de cross-BC operations + requisitos
		de latência/atomicidade/retry.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-065-establish-policy-registry-as-supporting-subdomain.cue",
		"governance/build-time/task-specs/wi-040.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Sessão 2026-05-03 founder reframe: PLR registry-only para evitar
		solution-in-search-of-problem. Engine cross-BC sem cliente real
		seria over-engineering — cada policy concreta tem requisitos
		diferentes (latência, atomicidade, retry semantics). Escolha de
		engine deve emergir do primeiro caso, não preceder. Custo de
		continuar deferindo: zero HOJE (sem policies cross-BC ativas);
		cresce com adoption se policy cross-BC for criada sem mecanismo.
		Trade-off explícito: aguardar sinal real (1ª cross-bc instance)
		vs commitment prematuro com requisitos hipotéticos.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence) detecta materialização de cross-bc
		policies via pattern de field assignment em instance file
		(scope field com valor cross-bc). Pattern verificado para
		NÃO self-match em policy.cue schema (schema declaration tem
		' | ' separador entre enum values, NÃO matches \\s+ pattern
		do trigger). Threshold=2 — schema constraint mínimo recurrence
		(>=2); 2ª cross-bc instance é sinal claro de pattern recurring
		(não one-off). Para 1ª cross-bc instance (sinal mais precoce),
		manual-review captura — founder review imediato vs aguardar
		recurrence.
		Trigger 2 (manual-review) escape para founder priorizar antes
		— e.g., antecipação de regulatory cross-BC requirement (Bacen
		reporting rules) OR primeira cross-bc instance materializando
		(antes do recurrence threshold).
		"""

	costOfDeferral: {
		severity: "medium"
		blastRadius: "cross-cutting"
		description: """
			Sem mecanismo de execução cross-BC definido, policies marcadas
			como scope=cross-bc ficam declarativas mas inexecutáveis.
			Risco: policy registrada como cross-bc sem ninguém efetivamente
			avaliando — gera segurança falsa via identidade sem
			enforcement. blastRadius cross-cutting porque qualquer caso
			afeta múltiplos BCs simultaneamente.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "scope:\\s+\"cross-bc\""
		scope:     "file-content"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "Founder pode priorizar engine cross-BC antes de 2ª instância — e.g., 1ª cross-bc policy materializando (recurrence ainda não fires) OR regulatory requirement Bacen antecipa cross-BC enforcement obrigatório."
	}]

	status: "open"
}
