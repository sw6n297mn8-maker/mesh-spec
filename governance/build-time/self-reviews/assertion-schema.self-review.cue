package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

assertionSchema: build_time.#SelfReviewReport & {
	reportId: "srr-assertion-schema"

	artifactPath:       "architecture/shared-schemas/assertion-schema.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 2
		summary: """
			Re-review isolado dedicado (sub-agente fresco, sem acesso a autoria) da gramatica #Assertion:
			0 fail. Confirmou via cue vet que as discriminated unions COMPRAM a arity -- relacao binaria sem
			right rejeitada, unaria com right rejeitada (right?: _|_), not=1/implies=2/and|or>=2 por tupla
			fixa, source enum fechado, leaf fechado rejeitando campo estranho; valido bilateral (and de
			exists+exists+eq) aceito; 4 malformados rejeitados. 1 WARN (CORRIGIDO neste round): o header
			apontava os deferimentos por labels descritivos (def-A3 / def-expressividade) em vez dos ids
			canonicos -- substituido por def-053 / def-054 (forward-ref agora grep-able; def-049 ja estava
			por id). 2 info nao-bloqueantes: (a) regex de id exige cauda >=2 chars (intencional, evita id de
			1 letra); (b) variables pode ser vazio com #VarRef no predicate -- coberto por def-053 (gap de
			resolucao, review-trusted), nao buraco novo. Deferimentos honestos (def-053 enforcement, def-054
			gramatica), referencias adr-140 item 6 + lens-testing-and-validation-for-financial-systems
			presentes, sem _schema.location (correto p/ shared-schema, precedente money.cue), Zero
			Duplicacao (estrutura o ex-texto-livre de #DomainInvariantRule.assertion).
			"""
	}]

	findings: {}

	summary: """
		#Assertion (gramatica foundational para codegen de property-based tests, adr-140 item 6). Re-review
		isolado dedicado 0 fail: a arity e garantida pelas discriminated unions (verificado por cue vet
		independente -- 4 malformados rejeitados, valido aceito), deferimentos honestos (def-053 enforcement
		/ def-054 gramatica), c-puro. 1 warn CORRIGIDO (forward-ref agora por id canonico), 2 info cobertos.
		NOTA DE GOVERNANCA: o gate (artifact_type_for_path) nao mapeia shared-schemas/ -- este SRR e
		VOLUNTARIO (blast-radius foundational: invariants/policies/state-models importam #Assertion).
		Follow-up: o mapeamento do gate tem gap -- shared-schemas/ nao-governado por SRR nem structural-check.
		"""

	singleRoundRationale: """
		1 round: o re-review isolado dedicado nao achou fail; o unico warn (forward-ref por label) foi
		corrigido no mesmo round para os ids canonicos def-053/def-054, e os 2 info sao intencionais ou
		cobertos por def-053 -- shape validado por cue vet (4 malformados rejeitados, valido aceito).
		"""
}
