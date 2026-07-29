package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr181ExtendStakeholderCategoryAdversarialActorClass: build_time.#SelfReviewReport & {
	reportId: "srr-adr-181-extend-stakeholder-category-adversarial-actor-class"

	artifactPath:       "architecture/adrs/adr-181-extend-stakeholder-category-adversarial-actor-class.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-29"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 0
		infoCount: 0
		summary: """
			Sub-agente isolado (rollout adr → isolated-subagent) avaliou o
			draft contra uq-01..09 + tq-adr-01..04 com verificação de
			fidelidade cross-file integral (schema stakeholder-map; instância
			v0; def-076; os 6 canvases que citam sh-06 — atribuição por
			canvas conferida linha a linha; adr-172 lido na íntegra; adr-049;
			P0/P12/dp-08 em design-principles). 2 fails: (F1, uq-03) a
			enumeração da taxonomia v0 no context omitia "system" — o header
			real lista 5 valores (person|organization|system|agent|
			regulator); (F2, tq-adr-03 direção complementar) o path do
			def-076 ausente de affectedArtifacts embora o próprio rationale
			anuncie a edição (resolvedBy → este ADR) — precedente uniforme
			adr-102/adr-145/adr-174 (+adr-177 confirmado pelo main agent).
			Main agent VERIFICOU ambos na fonte e CONFIRMOU; correções
			aplicadas (taxonomia completa; def-076 como 3ª entry). 2
			observações editoriais também aplicadas: O1 (ambiguidade sobre
			onde a origem WI-046 vive — rationale reescrito: origem no texto
			datado do ADR; comentário do schema define e cita o ADR, sem
			precedente nem membership) e O2 (precisão: 6 canvases + arquivos
			satélites dos mesmos BCs). cue vet exit 0.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round de estabilização: F1/F2 confirmados RESOLVIDOS por
			releitura contra as mesmas fontes (taxonomia valor a valor na
			mesma ordem; def-076 como path real na rastreabilidade); O1
			verificado contra a versão ATUAL do schema estendido (grep
			WI-046/R4 = 0; grep sh-06 = 0 no schema — as 4 alegações da
			frase nova são verdadeiras); O2 fiel (11 arquivos em contexts/
			mencionam sh-06 — 6 canvases + 5 satélites de rew/fce; grep
			actor-class = 0). Regressão zero critério a critério
			(uq-01..09 + tq-adr-01..04). ESTÁVEL.
			"""
	}]

	findings: {}

	summary: """
		adr-181 autorado via manualAuthoringProtocol (PG-ADR, 3 section
		gates) na sessão 2026-07-29: Gate 1 (scaffold) confirmado pelo
		founder com os 6 campos calibrados (structural/founder/accepted —
		3 gates precedem o commit, molde adr-180 — /medium/cross-artifact
		ancorado na verificação dos 6 canvases/supersedes vazio); Gate 2
		(context-decision-alternativas) confirmado com 1 ajuste cosmético
		do founder (comentário do schema define a classe e cita o ADR SEM
		enumerar membership — a enumeração vive no texto datado do ADR);
		Gate 3 (consequences-rationale-traceability) confirmado com 1
		adição do founder (N3: a assimetria do dec 2 — a obrigação de
		vetores deixa de ser proxy de participante legítimo; mitigação na
		definição da classe). Verificação pedida pelo founder executada por
		leitura ANTES dos gates: os 6 canvases citam sh-06 por id estável;
		zero refs à categoria. Self-review isolated-subagent: round 1 → 2
		fails verificados na fonte e corrigidos + 2 observações
		incorporadas; round 2 → estável. Evidência uq-09 (Camada 3)
		registrada aqui e nos roundDetails.
		"""
}
