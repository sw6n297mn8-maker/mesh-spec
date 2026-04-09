package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

apiSpecConventionSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-api-spec-convention"

	artifactPath:       "architecture/conventions/api-spec-convention.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"

	generatedAt: "2026-04-09"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		Convenção é artefato singleton sem schema parent
		#Convention (deferido até n=2 per adr-046). Não unifica
		contra nenhum #Type — portanto artifactType 'artifact-schema'
		é o closest match funcional na enum #ArtifactType (a
		convenção vive em architecture/ e é artefato estrutural).
		Sem _qualityCriteria type-specific, entra em regime
		fallback-to-universal (apenas uq-01..uq-08). 3 ciclos de
		ataque adversarial foram executados ANTES do self-review:
		13 findings, 7 correções aplicadas, 3 aceitos sem correção,
		3 ruído descartado. A superfície semântica do artefato já
		foi exaustivamente revisada nesses ciclos — um round
		adicional de self-review não revelaria dimensão nova.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 sobre api-spec-convention.cue aplicando regime
			fallback-to-universal (uq-01..uq-08). Convenção não tem
			_qualityCriteria type-specific — shape livre sem schema
			parent nesta fase.

			- uq-01 (rationale como WHY, fail): PASS. Rationales em
			  governedTypes, upstreamSources, presenceConditions,
			  materialization, validationPolicy e regulatoryBoundary
			  declaram propósito conceitual ('P0: canvas é a
			  localização canônica da declaração de superfície
			  síncrona'), não consequência mecânica.

			- uq-02 (ancoragem em fontes canônicas, fail): PASS.
			  Ancora em adr-040 (split structural/advisory), adr-046
			  (categoria conventions), adr-047 (extensão #ArtifactType),
			  canvas.cue capabilities (hasSyncSurface/hasAsyncSurface),
			  api-spec.cue (#OpenAPISpec/#AsyncAPISpec), P0, P1, P10,
			  P12, tq-cv-11.

			- uq-03 (referências verificáveis, fail): PASS. Schemas
			  referenciados existem: architecture/artifact-schemas/
			  canvas.cue, api-spec.cue. ADRs referenciados: adr-040,
			  adr-046, adr-048 (same commit). Canvas instances com
			  hasSyncSurface/hasAsyncSurface confirmados em cmt, ctr,
			  idc, npm.

			- uq-04 (alinhamento com princípios, fail): PASS. P0
			  (localização canônica única do protocolo), P1 (schemas
			  dos tipos existem antes da convenção), P10 (separação
			  structural/advisory), P12 (governance as code — convenção
			  é CUE versionada).

			- uq-05 (limitações declaradas, warn): WARN. Três
			  limitações a registrar: (1) enforcement exclusivamente
			  editorial/manual até B.2; (2) shape livre sem #Convention
			  schema até n=2; (3) sourceField é string documental, não
			  referência compile-time. Ver findings.warn.

			- uq-06 (rationale específico ao contexto, fail): PASS.
			  Rationales referenciam hasSyncSurface/hasAsyncSurface
			  por nome, mencionam padrões externos (OpenAPI 3.x,
			  AsyncAPI 2.x), citam tq-cv-11 como cross-ref — não são
			  frases genéricas.

			- uq-07 (convenções de naming, fail): PASS. Arquivo
			  api-spec-convention.cue em kebab-case, package
			  conventions, campo apiSpecConvention em camelCase.

			- uq-08 (conformidade ao schema, fail): PASS vacuamente
			  — não há schema parent contra o qual unificar. Estrutura
			  segue padrão editorial de tmpl-create-convention@v1
			  (governedTypes, upstreamSources, presenceConditions,
			  materialization, validationPolicy, regulatoryBoundary,
			  rationale).

			Conclusão: 0 fail, 1 warn (uq-05 com 3 limitações),
			0 info. Estável em 1 round — artefato já passou por 3
			ciclos adversariais antes deste self-review.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Limitação 1 — enforcement da norma é exclusivamente
				editorial/manual até WI-027 B.2 materializar o
				structural-check. Agentes que não leiam a convenção
				podem violar o protocolo sem sinal mecânico.
				"""
			rationale: """
				Estado esperado: norma existe antes do mecanismo.
				B.2 é follow-up explícito com gap documentado sobre
				expressividade dos kinds v1 do schema de
				structural-check.
				"""
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Limitação 2 — shape livre sem schema parent
				#Convention. cue vet valida apenas sintaxe, não
				estrutura. Convenções futuras podem divergir de
				shape sem sinal até #Convention schema existir (n=2).
				"""
			rationale: """
				Decisão deliberada per adr-046 (deferimento de
				schema central até segundo caso concreto, pattern
				ten-009). Risk aceito: n=1 é referência editorial;
				n=2 será fonte de generalização.
				"""
		}, {
			criterionId: "uq-05"
			severity:    "warn"
			message: """
				Limitação 3 — sourceField em upstreamSources é
				string documental ('capabilities.hasSyncSurface'),
				não referência compile-time ao canvas schema. Se
				canvas renomeia o campo, a string fica stale sem
				sinal de compilação. Staleness é detectada pelo
				structural-check que lê o canvas diretamente.
				"""
			rationale: """
				Sem #Convention schema com referência tipada a
				campos de outros schemas, string documental é o
				melhor mecanismo disponível. O structural-check
				(B.2) operará sobre o canvas real, contornando o
				gap. Registrado para visibilidade.
				"""
		}]
	}

	summary: """
		Self-review stable em 1 round para api-spec-convention.cue
		— primeira convenção concreta do repositório, codificando
		protocolo de presença bicondicional entre canvas capability
		flags e API specs. 3 ciclos adversariais executados antes
		do self-review (13 findings, 7 correções, 3 aceitos, 3
		ruído). Regime fallback-to-universal (uq-01..uq-08), sem
		_qualityCriteria type-specific. Zero fails, 1 warn em
		uq-05 expandido em 3 limitações: enforcement editorial/manual
		até B.2, shape livre sem #Convention até n=2, sourceField
		como string documental.
		"""
}
