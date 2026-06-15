package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

wavePlanWi141: build_time.#SelfReviewReport & {
	reportId: "srr-wave-plan-wi-141-derived-materialization-health"

	artifactPath:       "governance/wave-plan.cue"
	artifactSchemaPath: "architecture/artifact-schemas/wave-plan.cue"
	artifactType:       "wave-plan"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-15"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Self-review em sessao: insercao de WI-141 (restaurar materializacao dos derivados
			auto-commitados structure-index + repo-tree/README e tornar a falha audivel) no grupo
			W001-governance-ci. Conforma #WaveTask: id "WI-141" unico (_allTaskIDs list.UniqueItems,
			imposto por cue vet — pass), dependsOn [] (trivialmente resolve), outputs 5 itens (>=1)
			todos type "update" com paths reais do repo (governance/readme/*, README.md,
			.github/workflows/materialize-*.yml) conformes a estrutura (tq-wp-02), semanticPrerequisites
			+ affects + rationale preenchidos, tshirtSize M. Classificacao bug/gap -> WI per anti-catch-all
			(nao DD: sem trade-off; nao tension: sem forcas concorrentes) — confirmada por leitura do
			CLAUDE.md. Achado de disco que motiva o WI verificado: structure-index e tree-generated em main
			ambos sem adr-149..151/def-062 (os dois derivados auto-commitados stale; doenca class-level no
			pipeline materialize-*, nao no gerador). work-graph.cue NAO exige co-update (cobre W001-W005 em
			phases; o append de task a grupo existente segue precedente WI-133..140). cue vet pass. 1 info:
			o arquivo carrega drift de cue fmt repo-wide pre-existente (nao introduzido por este edit;
			diff = so o bloco WI-141 — confirmado).
			"""
	}]

	findings: {}

	summary: """
		wave-plan.cue (WI-141 em W001-governance-ci; dependsOn vazio). Registra como bug/gap o achado de
		saude do repo: os dois derivados auto-commitados (structure-index + repo-tree/README) estao stale
		em main porque os workflows materialize-* nao estao landando o auto-commit (doenca class-level,
		provavel branch-protection). O WI exige (a) re-materializar, (b) achar a causa-raiz e (c) tornar a
		falha um SINAL VISIVEL (nao log silencioso). Self-review LIMPO: conforma #WaveTask (unicidade de id
		+ outputs validos via cue vet), classificacao bug/gap correta, registrar nao executa as acoes
		(trabalho futuro do proprio WI). cue vet pass. 1 info: drift de fmt repo-wide pre-existente (nao
		deste edit).
		"""

	singleRoundRationale: """
		1 round: o #WavePlan impoe unicidade de WI-141 e validade de outputs via cue vet (pass); a insercao
		e um append de task coerente com o padrao de WIs do grupo W001-governance-ci, com classificacao
		bug/gap verificada contra o anti-catch-all do CLAUDE.md — sem fail.
		"""
}
