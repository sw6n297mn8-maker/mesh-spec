package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

// SRR do def-084, o deferimento consciente do VERIFICADOR da prova de efeito
// cross-repo instalada pelo adr-184. Autoria manual sob manualAuthoringProtocol
// (deferred-decision não está no rollout de authoring, cai em defaultMode
// "manual", e existe PG). As três sections do workOrder do PG foram autoradas
// com auto-checagens SEPARADAS e apresentadas juntas; o founder aprovou em
// lote, caminho que o serializationRule admite explicitamente quando cada
// section chega com sua própria auto-checagem antes da aprovação.

def084: build_time.#SelfReviewReport & {
	reportId: "srr-def-084-cross-repo-effect-proof-verification"

	artifactPath:       "architecture/deferred-decisions/def-084-cross-repo-effect-proof-verification.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

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
			Round 1 — self-review sobre as três sections do workOrder do PG de deferred-decision,
			cada uma com auto-checagem própria antes da aprovação em lote do founder.

			SECTION scaffold-and-origin. id def-084 re-derivado do REMOTO pelo freshness gate no ato
			da escrita (G2), não citado de memória; regex ^def-[0-9]{3}$ satisfeito;
			originatingArtifacts aponta o adr-184, que é #OriginRef válida e o artefato que de fato
			origina o deferimento; status open, que exige #TriggerStrict — satisfeito na section 3.

			SECTION substance-and-deferral-rationale. tq-def-01 (trade-off articulado, severity fail):
			PASS. O custo evitado é NOMEADO e concreto — construir e manter leitor cross-repo por
			repositório e por tarefa antes de existir volume que o justifique, sendo que o único
			precedente de leitura cross-repo spec-side (codegen-validation.yml) é harness sob medida
			de alvo único, e generalizá-lo inverteria a divisão QUE=spec/COMO=runtime que o adr-157 e
			o adr-148 instituem. O custo de continuar é igualmente concreto e CRESCENTE: cada prova
			não-verificada é afirmação do declarante, e quando forem muitas a amostragem manual do
			falsificationCondition deixa de escalar. Não é "fazer depois quando der tempo".
			tq-def-04 (coerência custo↔escopo, warn): PASS. severity medium porque o dano é cumulativo
			e não bloqueia caminho crítico; blastRadius cross-cutting porque alcança a governança de
			trabalho deste repositório mais a fronteira declarada de dois repositórios subordinados —
			mesmo escopo que o adr-184 declara para a própria decisão.

			SECTION trigger-design. tq-def-02 (machine-evaluable, severity fail): PASS. Dois gatilhos,
			nenhum manual-review. tq-def-03 (≥1 não-manual, warn): PASS pelo mesmo motivo.
			#TriggerStrict exige pathScope ancorado em ^ para recurrence scope=file-content —
			satisfeito (^governance/build-time/task-specs/). VERIFICAÇÃO POR EXECUÇÃO, não por
			raciocínio, porque foi exigência explícita do founder após o def-083 ter nascido
			disparado: rodado scripts/ci/evaluate-deferred-triggers.sh com o def-084 no disco, saída
			"0 of 84 fired", com o def-084 avaliado explicitamente e ambos os gatilhos abaixo do
			limiar (recurrence count 0 < threshold 3; temporal age 0 < maxAgeDays 180).

			CALIBRAÇÃO DO LIMIAR, registrada porque é a escolha não-óbvia: o gatilho primário é
			VOLUME DE USO e não tempo, porque o custo do deferimento é função do número de provas
			não-verificadas e não da idade da decisão. Limiar 3 é o ponto em que a conferência manual
			deixa de ser exaustiva e vira amostragem de verdade. O temporal de 180 dias é rede
			durável com pergunta própria: se o mecanismo passar meio ano sem uso nenhum, a revisita
			deve perguntar se ele deveria existir, não só se deveria ser verificado.
			"""
	}]

	findings: {
		info: [{
			criterionId: "uq-03"
			severity:    "info"
			message: """
				def-084 e def-065 sao adjacentes e a relacao esta declarada no deferralRationale (o
				write-back do harness de codegen-validation e o gancho natural), mas nao ha campo
				estruturado de relacao entre deferred-decisions no schema — o vinculo vive em prosa.
				Limitacao do tipo, nao deste artefato; registrada para que a adjacencia nao pareca
				omitida.
				"""
		}]
	}

	singleRoundRationale: """
		Estabilizou em um round porque o artefato é pequeno, inteiramente derivado de uma decisão
		já submetida a quatro rounds de sub-agente isolado, e porque o risco real dele — o gatilho
		nascer disparado, que foi o defeito observado e datado no def-083 — não é resolvível por
		mais leitura: é resolvível por execução do runner, e o runner foi executado com o artefato
		no disco antes desta submissão. Um segundo round de revisão textual sobre um artefato cujo
		único ponto de falha já foi verificado mecanicamente seria cerimônia, não revisão.
		"""

	summary: """
		Deferimento consciente do verificador da prova de efeito cross-repo, com custo evitado e
		custo de continuar ambos nomeados e concretos, e gatilhos que medem exatamente a passagem
		em que a amostragem manual deixa de escalar. Os dois critérios fail do tipo (trade-off
		articulado e triggers machine-evaluable) passam, e o segundo foi verificado por EXECUÇÃO do
		runner — "0 of 84 fired", def-084 explicitamente sem match — em vez de por calibração
		raciocinada, conforme exigência do founder motivada pelo def-083 ter nascido disparado.
		"""
}
