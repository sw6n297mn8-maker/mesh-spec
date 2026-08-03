package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR da MATERIALIZAÇÃO do adr-184 no artifact-schema wave-plan.cue. Distinto
// do SRR do próprio adr-184 (srr-adr-184-cross-repo-effect-as-completion-
// condition, que revisou a DECISÃO) e do srr-wave-plan (que revisou o schema
// em si). Este revisa a única alteração que o dec 3 faz naquele arquivo: a
// #TaskOutput local dá lugar ao alias da morada única em shared-types, com o
// import correspondente. Existe porque o check-self-review.sh mapeia
// architecture/artifact-schemas/*.cue e sai 1 sem ele — verificado por
// execução, e é o sexto ponto do N4 do ADR.

waveplanAdr184: build_time.#SelfReviewReport & {
	reportId: "srr-wave-plan-adr-184-taskoutput-unification"

	artifactPath:       "architecture/artifact-schemas/wave-plan.cue"
	artifactSchemaPath: "architecture/artifact-schemas/wave-plan.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-03"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 1
		summary: """
			Round 1 — self-review da alteração do dec 3 do adr-184 em wave-plan.cue. A mudança é
			mínima e inteiramente estrutural: (a) a definição local #TaskOutput (2 campos) dá lugar a
			#TaskOutput: shared_types.#TaskOutput, alias da morada única criada em
			architecture/shared-types/task-output.cue; (b) o import de shared_types entra ao lado do
			import "list" já existente; (c) o comentário que afirmava "Ambos compartilham #TaskOutput"
			— falso enquanto havia duas definições independentes — passa a nomear a morada e a ser
			verdadeiro por construção.

			CONFORMIDADE ESTRUTURAL: cue vet ./... EXIT=0 sobre o repositório inteiro, com as 138
			task-specs, o wave-plan e os 133 streams de work-events conformando SEM TOQUE. A união
			discriminada que o alias traz carrega o marcador de default no ramo local, sem o qual a
			disjunção não resolve — executado e registrado no round 3 do SRR do ADR (cue vet exit 1,
			243 valores incompletos, cue export do wave-plan falhando, phantom-gate reprovando).

			NÃO-REGRESSÃO, verificada por execução e não por leitura: cue export do wave-plan exit 0
			com saída byte-idêntica ao baseline; generate-structure-index.py exit 0 com saída
			byte-idêntica; três drift gates 0/0/0; phantomCandidates vazio.

			SUPERFÍCIE SEMÂNTICA: #WaveTask.outputs passa a admitir o ramo remoto (effectExpectedIn),
			que antes era inexpressável. Consequência declarada no N7 do ADR e não escondida aqui: a
			mesma expectativa passa a ter DUAS superfícies de declaração — #WaveTask.outputs e
			#TaskSpec.outputs — sem regra de qual é autoritativa nem gate de concordância.

			ZERO alteração em qualquer outro campo do schema: waves, tasks, dependsOn, tshirtSize e
			os _qualityCriteria seguem intocados. A mudança não é de política do wave-plan; é de
			morada de um tipo que ele consome.
			"""
	}]

	findings: {
		info: [{
			criterionId: "uq-03"
			severity:    "info"
			message: """
				O tipo migra para architecture/shared-types/, zona que NÃO está no mapa de
				artifact_type_for_path do scripts/ci/check-self-review.sh — verificado: zero
				ocorrencias de shared-types naquele script. O arquivo novo que carrega o tipo
				load-bearing desta decisao nao exige SRR proprio, enquanto a edicao de uma linha em
				wave-plan.cue exige este. Assimetria de cobertura do gate, pre-existente e nao criada
				por esta mudanca; declarada como N12 no ADR em vez de passar calada.
				"""
		}]
	}

	singleRoundRationale: """
		Estabilizou em um round porque a alteração é de uma linha mais um import, e todo o risco
		semântico dela — a forma da união, a cardinalidade, a não-regressão dos consumidores —
		já havia sido atacado por quatro rounds de sub-agente isolado no SRR do próprio adr-184,
		os dois últimos com EXECUÇÃO obrigatória em cópias do repositório. Revisar de novo aqui
		seria repetir o mesmo ataque contra a mesma superfície: a decisão de forma foi tomada e
		testada lá, e o que resta neste arquivo é a aplicação dela. A não-regressão foi
		reverificada por execução nesta materialização, e não herdada por confiança.
		"""

	summary: """
		Materialização mínima e verificada: uma definição local vira alias da morada única, o
		import entra, e um comentário falso passa a ser verdadeiro. Nenhum consumidor muda de
		comportamento (export e structure-index byte-idênticos), nenhuma política do wave-plan é
		tocada, e a única consequência semântica — a segunda superfície de declaração da mesma
		expectativa — está declarada no ADR como negativa, não omitida. O info registrado é sobre
		a zona de destino não ser coberta pelo gate de self-review, assimetria que precede esta
		decisão e que o ADR declara.
		"""
}
