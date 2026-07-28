package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

frontendCodegenContractSchema: build_time.#SelfReviewReport & {
	reportId: "srr-frontend-codegen-contract-schema"

	artifactPath:       "architecture/artifact-schemas/frontend-codegen-contract.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-28"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 3
		warnCount: 1
		infoCount: 0
		summary: """
			Sub-agente isolado (rollout artifact-schema → isolated-subagent)
			avaliou o draft com testes CUE EMPÍRICOS (cue vet/eval em cópia
			scratchpad, incluindo a instância v2.1 migrada como fixture).
			3 fails: (i) uq-08 — a forma `#Family: #Base & {campos novos}`
			NÃO compila contra def fechado (`field not allowed`); correção:
			EMBEDDING (`#Family: {#Base, ...}`), verificada empiricamente
			(8 testes: os 2 ramos validam; os 2 casos adversariais rejeitam;
			guards movesMoney e net-new mordem; canvas força regime; v2.1
			migrada valida com -c). (ii) uq-03 — o desenho exigia queryRef
			qry-* para TODA readSurface, mas o FCE tem ZERO qry-* no
			domain-model (a fila escalada é canvas query-surface
			QueryEscalatedPayments); correção: #ReadSurface como união
			query-backed | canvas-backed com o ramo canvas FORÇANDO
			hand-grandfathered por shape. (iii) uq-04 — regexes de ref
			inline duplicadas-com-drift vs os refs canônicos do
			domain-model.cue (#CommandRef/#EventRef/#AggregateRef/
			#BoundedContextRef/#ValueObjectRef, mesmo package); correção:
			usar os canônicos. 1 warn (cascade do PG) REJEITADO como
			falso-positivo com registro de calibração: o PG nasce na MESMA
			fatia — fora do input isolado do reviewer.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-avaliação do schema corrigido (embedding + união de
			ReadSurface + refs canônicos) com re-execução dos testes
			empíricos: os 8 verdes. O reviewer declarou e corrigiu bug do
			PRÓPRIO harness do round 1 (fields de teste hidden mascaravam
			incompletude — regulares no round 2). Zero findings; condição
			de estabilidade satisfeita.
			"""
	}]

	findings: {}

	summary: """
		Schema #FrontendCodegenContract (promoção adr-180; mandato
		adr-179) revisado em modo isolated-subagent com validação CUE
		empírica em scratchpad — o coração do mandato (exclusão mútua por
		shape; 3 slots por construção; movesMoney⇒approvalAsConfirmation;
		net-new⇒justificativa+migração; canvas-backed⇒hand-grandfathered)
		provado por vet real, não por inspeção. Round 1 → 3 fails
		(embedding vs extensão de def fechado; ramo canvas-backed para o
		legado FCE sem qry formal; refs canônicos vs regexes inline) +
		1 warn rejeitado como falso-positivo (calibração registrada);
		round 2 → zero findings, estável em 2/4 rounds. DELTA
		PÓS-ESTABILIZAÇÃO aprovado explicitamente pelo founder (§2 da
		proposta consolidada): confirmation.returnsEvent (singular) →
		confirmation.returnsEvents lista ≥1 — perda de fidelidade
		descoberta pelo main agent na migração da família FCE (o resolve
		devolve oneOf de DOIS eventos: Overridden | OverrideRefused); é o
		N1 do adr-180 (risco de transcrição) pego pelo diff e declarado,
		validado por cue vet na escrita.
		"""
}
