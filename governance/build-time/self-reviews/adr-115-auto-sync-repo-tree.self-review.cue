package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr115AutoSyncRepoTree: build_time.#SelfReviewReport & {
	reportId: "srr-adr-115-auto-sync-repo-tree"

	artifactPath:       "architecture/adrs/adr-115-auto-sync-repo-tree.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

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
			Self-review do adr-115 (auto-sync da árvore do repositório via _meta.cue por
			diretório). Plano e número (115) aprovados pelo founder antes da escrita;
			escopo full-parity com auster adr-028 adaptado à stack Python da mesh.

			(a) Conformância #ADR (tq-adr-01..04): id ^adr-[0-9]{3}$ ("adr-115");
			status "accepted"; decisionClass "structural" (introduz tipo #DirectoryMeta +
			nova relação derivada filesystem→tree-generated→README, sem redefinir SoTs).
			tq-adr-01: três alternativas registradas em context com motivo de rejeição
			(B lista-central-renderizada; C síntese-por-doc-comment; A escolhida).
			tq-adr-02: reversibility "medium" (reverter exige restaurar lista central +
			remover _meta.cue dos dirs — esforço moderado, sem dados persistidos) +
			blastRadius "repo-wide" (geração do README + artefato em dirs de todo o repo)
			— consistentes com a decisão real. tq-adr-03/04: affectedArtifacts (config.cue,
			output.cue, meta-coverage.cue) são paths reais; plannedOutputs lista os novos
			(schema, gerador, tree-generated). ≥1 bloco de rastreabilidade populado.

			(b) Decisão de cobertura sc-meta-02: escolhida ISENÇÃO em vez de structural-check
			próprio, por simetria explícita com readme-config (consistência guardada por
			script, não por check). Aprovado pelo founder. O ADR documenta o porquê.

			(c) Verificação empírica antes da proposta: cue vet ./architecture/... EXIT 0;
			structural-check-runner → 0 bloqueantes (sc-meta-02 resolvido pela isenção; só
			os 21 warns pré-existentes sc-cv-02/03 permanecem). A decisão registra o pattern
			e o schema base; rollout de _meta.cue/gerador/migração segue em commits da feature.
			"""
	}]

	summary: "adr-115 conforma #ADR (tq-adr-01..04): 3 alternativas com motivo de rejeição, metadata de risco consistente (reversibility medium, blastRadius repo-wide), rastreabilidade real (affectedArtifacts + plannedOutputs). Cobertura sc-meta-02 via isenção aprovada pelo founder. Verificado: cue vet ./architecture/... exit 0; structural-check-runner 0 bloqueantes."

	singleRoundRationale: "Estabilizou em 1 round: plano, número (115) e decisão de cobertura (isenção) aprovados pelo founder antes da escrita; conformância de schema verificada empiricamente (cue vet + runner) sem findings fail/warn nos artefatos da etapa 1."
}
