package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

directoryMetaSchema: build_time.#SelfReviewReport & {
	reportId: "srr-directory-meta-schema"

	artifactPath:       "architecture/artifact-schemas/directory-meta.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-27"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do schema #DirectoryMeta (architecture/artifact-schemas/
			directory-meta.cue), criado por adr-115. Adotado de auster-spec adr-028,
			adaptado ao módulo e às convenções da mesh.

			(a) Shape do tipo: canonicalPath (string !=""); purpose (strings.MinRunes(20)
			& MaxRunes(200)); rationale opcional (MinRunes(20) quando presente). Os
			_meta.cue declaram `meta` como mapa keyed pelo path, em forma plana SEM
			importar o schema (evita ciclo artifact_schemas→shared_types e colisão de
			campo entre subdir e pai de mesmo package). A conformância é validada pelo
			gerador (tq-dm-01/02/04), não por unificação CUE — coerente com a isenção.

			(b) _schema.location: canonicalPathRegex ^([a-z0-9][a-z0-9-]*/)*_meta\\.cue$,
			fileNameRegex ^_meta\\.cue$, cardinality "collection", allowNested true. O
			prefixo _ é deliberado: schemas de instância (agent-spec, lens, subdomain…)
			têm canonicalPathRegex exigindo filename em [a-z0-9], então "meta.cue" daria
			classificação ambígua; "_meta.cue" classifica só como directory-meta e a
			orphan-detection não o trata como órfão (adr-098).

			(c) _qualityCriteria tq-dm-01..04 (mesma semântica do auster): tq-dm-01 (path
			real == canonicalPath, fail, verificado pelo gerador), tq-dm-02 (purpose 20-200,
			fail por shape), tq-dm-03 (rationale ≥20 quando presente, fail por shape),
			tq-dm-04 (purpose sem ".cue", warn) — alinhado a Zero Duplicação (P0).

			(d) Cobertura meta (sc-meta-02): directory-meta é isento em meta-coverage.
			exemptTypes por simetria com readme-config (consistência guardada pelo gerador
			determinístico, não por structural-check). Decisão aprovada pelo founder.

			(e) Verificação: cue vet ./architecture/... EXIT 0; structural-check-runner
			0 bloqueantes.
			"""
	}]

	summary: "Schema #DirectoryMeta conforma o meta-schema artifact-schema.cue: shape canonicalPath + purpose(20-200) + rationale?, _schema.location com regex que classifica _meta.cue (evita órfão adr-098), tq-dm-01..04 alinhados a Zero Duplicação (P0). Verificado: cue vet exit 0; structural-check-runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round: adoção fiel do padrão auster adr-028 (já validado em produção lá), adaptado ao módulo e às convenções da mesh; conformância verificada por cue vet + runner sem findings."
}
