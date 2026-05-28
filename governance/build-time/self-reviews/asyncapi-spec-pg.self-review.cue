package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

asyncapiSpecPg: build_time.#SelfReviewReport & {
	reportId: "srr-asyncapi-spec-pg"

	artifactPath:       "architecture/production-guides/asyncapi-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-28"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do production-guide para async-api.yaml (target #AsyncAPISpec).
			Texto proposto e aprovado pelo founder no chat com 6 refinamentos
			incorporados antes da escrita.

			(a) Conformância #ProductionGuide: workOrder (5 elementos) bate com chaves de
			sections (info-header, channels, messages, components-schemas,
			bindings-or-deferred); cada section tem target, process (≥3 passos
			concretos), doneCriteria, gapPolicy.sources e heuristics. prerequisites com
			collectFromFounder de 5 itens substantivos. _qualityCriteria com 4 critérios
			(tq-async-01..04) cobrindo coverage, fidelidade, naming, bindings.
			_schema.location regex consistente com convenção de PGs (singleton em
			architecture/production-guides/).

			(b) 6 ajustes do founder incorporados literalmente:
			1. Channel naming inclui versão: 'mesh.<bc-code>.<event-name>.v1'. tq-async-03
			   reflete o padrão. Heuristics explicita por que.
			2. publish/subscribe: arquivo do BC produtor declara APENAS 'publish'.
			   doneCriteria da section channels exige 'Nenhuma operação subscribe presente'.
			   Consumers são descobertos via context-map, não via subscribe local.
			3. Payload mirror: tq-async-02 e a section components-schemas explicitam que
			   JSON Schema é derivado MANUALMENTE; x-mesh-cue-ref é vínculo de auditoria
			   pra revisão humana, NÃO mecanismo automático.
			4. Bindings só com ADR de transport: section bindings-or-deferred + tq-async-04
			   exigem ADR de stack/transport OU gap registrado em tension-entry/def-XXX.
			5. AsyncAPI 2.6.0 declarado em info-header.process.
			6. tq-async-01 troca 'visibility=external' por 'events publicados em
			   strategic/context-map.cue relationships' — visibility está no context-map,
			   não no domain-model.

			(c) Verificação: cue vet ./architecture/production-guides/... exit 0;
			structural-check-runner 0 bloqueantes; PG é singleton (cardinality declarada).
			"""
	}]

	summary: "production-guide para async-api.yaml conforma #ProductionGuide: 5 sections com workOrder consistente; 4 quality criteria (coverage, fidelidade CUE↔JSON Schema, naming versionado, bindings só com ADR); 6 ajustes do founder incorporados literalmente. Verificado: cue vet exit 0, runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round: estrutura proposta e aprovada pelo founder no chat com refinamentos específicos (versão no nome do canal, publish-only, payload manual, bindings disciplinados); conformância verificada por cue vet + runner sem findings."
}
