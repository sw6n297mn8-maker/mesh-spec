package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

apiSpecPg: build_time.#SelfReviewReport & {
	reportId: "srr-api-spec-pg"

	artifactPath:       "architecture/production-guides/api-spec.cue"
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
			Self-review do production-guide para api.yaml (target #APISpec). Texto
			proposto e aprovado pelo founder no chat com 7 ajustes finais
			incorporados antes da escrita.

			(a) Conformância #ProductionGuide: workOrder (6 elementos) bate com chaves
			de sections (info-header, servers-or-deferred, paths-and-operations,
			components-schemas, components-responses-and-errors, security-or-deferred);
			cada section tem target, objective, process (≥3 passos concretos),
			doneCriteria, sources e heuristics. prerequisites com collectFromFounder de
			8 itens substantivos + gapPolicy. finalValidation com 7 steps.
			_qualityCriteria com 5 critérios (tq-api-01..05) cobrindo coverage,
			fidelidade SEMÂNTICA (não só shape), naming RPC, error envelope cross-BC,
			auth+servers gateados por ADR. _schema.location consistente com convenção
			de PGs (singleton).

			(b) 7 ajustes do founder incorporados:
			1. Decisões 1-4 (OpenAPI 3.0.3, URL-versioned /v1/, RPC POST pra commands,
			   GET pra queries) — embutidas em info-header + paths-and-operations.
			2. RFC 7807 explícito como CROSS-BC SHARED CONTRACT, NÃO customizável por
			   BC — section components-responses-and-errors + tq-api-04 carregam essa
			   regra; heuristic explícita proíbe fork local.
			3. x-mesh-cue-ref NÃO referencia commands.cue como se existisse — section
			   components-schemas trata como conditional: 'QUANDO schemas/commands.cue
			   for criado no futuro... este section refatora pra apontar pra ele'.
			   Hoje o request SoT é domain-model.cue#commands.<code>.
			4. NÃO criar commands.cue agora — prerequisites.description articula a
			   regra explicitamente (commands.cue só nasce com 2º consumidor real ou
			   necessidade de auditoria independente; abstração prematura é evitada,
			   mesma lógica do def-022).
			5. tq-api-02 inclui DRIFT DE INTENÇÃO operacional além de shape — drift de
			   required fields, lifecycle transitions, emitted events falham. Mirror
			   sem semântica casada é contrato pseudo-fiel.
			6. paths-and-operations PROIBE PUT/PATCH/DELETE 'porque REST' sem command
			   correspondente — princípio editorial não-negociável no topo do arquivo
			   e enforçado em tq-api-03. 'OpenAPI é só transporte HTTP do modelo
			   operacional Mesh; não força resource-oriented REST'.
			7. Sequência aprovada: PG → api.yaml com request inline (mirror do
			   domain-model) → eventual def-024 SE durante a autoria do api.yaml
			   aparecer repetição real de payloads — NÃO antes.

			(c) Verificação: cue vet ./architecture/production-guides/... exit 0;
			structural-check-runner 0 bloqueantes; PG é singleton (cardinality declarada).
			"""
	}]

	summary: "production-guide para api.yaml conforma #ProductionGuide: 6 sections (info-header, servers-or-deferred, paths-and-operations, components-schemas, components-responses-and-errors, security-or-deferred); 5 quality criteria (coverage, fidelidade semântica + shape, naming RPC anti-REST-cargo-cult, error envelope cross-BC RFC 7807, auth+servers só com ADR); 7 ajustes do founder incorporados literalmente. Verificado: cue vet exit 0, runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round: estrutura proposta e aprovada pelo founder no chat com refinamentos específicos (RFC 7807 cross-BC, sem commands.cue, drift de intenção em tq-api-02, anti-REST-cargo-cult); conformância verificada por cue vet + runner sem findings."
}
