package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr149: build_time.#SelfReviewReport & {
	reportId: "srr-adr-149-consumption-contract-cross-bc"

	artifactPath:       "architecture/adrs/adr-149-consumption-contract-cross-bc.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-06-13"

	roundsExecuted: 2
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-149 (contrato-de-consumo cross-BC) executado por SUB-AGENTE
			ISOLADO (rollout executionPolicy: adr → isolated-subagent), sem o histórico de
			autoria. Avaliado contra uq-01..09 + tq-adr-01..04. Resultado: 1 finding fail.

			FINDING uq-06 (fail, ubiquitous language): o ADR descrevia o consumo de
			#EligibilityConsumption como "a faceta eligibility" (singular) em context, decision
			item 2/4 e P2, mas o artefato governado contexts/fce/schemas/events.cue declara
			_projectsFacets: ["eligibility", "context"] (DUAS facetas). Ambas reais no fato do
			produtor #RiskEvaluationEmitted.data (eligibility + context). O ADR — autoridade que
			estabelece o mecanismo e nomeia #EligibilityConsumption como o exemplo canônico de
			projeção-de-parte (n=2) — mischaracterizava a própria evidência.

			Os outros 12 critérios passaram, ancorados em verificação direta: cue vet
			./architecture/adrs/ EXIT=0; refs adr-104/adr-105/sc-cm-06/def-019/022/025/057/059
			existem no filesystem; os 7 paths de affectedArtifacts existem (tq-adr-03);
			alternativas (a)-(d) com motivo de rejeição (tq-adr-01); reversibility=medium +
			blastRadius=cross-artifact coerentes (tq-adr-02); P0/P13 dizem o que o ADR invoca
			(uq-04); N1/N2/N3 declaram known-gaps (uq-05).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			O agente principal VERIFICOU o finding uq-06 factualmente (findingEvaluation): leu
			#ApplicableContext (rew:191-194 — entityRef + policyVersion) e #EligibilityDecision
			(rew:178-179 — decision), confirmando que os campos do #EligibilityConsumption
			mapeiam decision ← eligibility e entityRef+policyVersion ← context. Logo context É
			consumido: o finding é correto (não falso-positivo). Decisão do founder: corrigir o
			ADR (não o schema do passo-1).

			Correção aplicada ao adr-149: context, decision item 2 ("as facetas [eligibility,
			context]" — casa verbatim com _projectsFacets), decision item 4, P2 e a alternativa
			(a) passam a descrever projeção-de-parte como SUBCONJUNTO de facetas, não faceta
			singular. Reconciliado também o comentário inline contradizente em
			contexts/fce/schemas/events.cue (dizia "context NÃO consumido"; agora explicita
			decision ← eligibility / entityRef+policyVersion ← context).

			Re-review por SUB-AGENTE ISOLADO sobre o adr-149 corrigido: uq-06 RESOLVIDO sem
			resíduo (ocorrências singulares remanescentes em context/P1 são o mecanismo
			genérico, não o exemplo n=2), ZERO findings, sem regressão. cue vet EXIT=0.
			Estabilização satisfeita: zero fail pendente, nenhum fail novo vs round anterior.
			"""
	}]

	findings: {}

	summary: """
		adr-149 estabelece o contrato-de-consumo como mecanismo canônico de consumo cross-BC
		de eventos (projeção-do-todo espelho + projeção-de-parte subset), resolvendo def-057
		(mecanismo, opção d) e def-059 (fantasma removido). Self-review por SUB-AGENTE ISOLADO
		(rollout adr→isolated-subagent): round 1 achou 1 fail uq-06 (ADR descrevia consumo como
		faceta singular vs _projectsFacets:[eligibility,context] real); agente principal
		verificou (entityRef+policyVersion derivam de #ApplicableContext = facet context),
		corrigiu o ADR + o comentário contradizente do schema; round 2 isolado confirmou
		uq-06 resolvido, zero findings, sem regressão. cue vet EXIT=0. Estável em 2 rounds.
		"""
}
