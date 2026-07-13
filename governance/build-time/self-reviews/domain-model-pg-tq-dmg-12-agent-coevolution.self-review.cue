package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainModelPgTqDmg12AgentCoevolution: build_time.#SelfReviewReport & {
	reportId: "srr-domain-model-pg-tq-dmg-12-agent-coevolution"

	artifactPath:       "architecture/production-guides/domain-model.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do ELO DUPLO no PG domain-model (adr-175):
			(a) critério tq-dmg-12 em _qualityCriteria — assegura que o GUIDE
			contém a disciplina de coevolução do agent-spec (teste por inspeção
			do guide, padrão dos 11 critérios irmãos); (b) passo operativo em
			finalValidation.steps (posicionado antes do 'Submeter ao founder',
			após o post-edit consistency check) — exige, ao alterar building
			blocks das 6 famílias, verificar coevolução (operationalScope/
			actions/scopeExclusions) E veracidade da prosa das actions,
			coevoluindo no mesmo ciclo ou justificando a não-edição. O elo
			duplo é a correção da revisão de arquiteto: só o critério deixaria
			a classe-2 descoberta — instâncias seguem process/finalValidation
			(os tq-dmg-* asseguram o guide, não a instância); o uq-09 (warn)
			vigia os section gates.

			[Severidade warn no tq-dmg-12 — decisão declarada]: classe-2
			(prosa envelhecida) é interpretativa; P10 veda gate LLM; o
			critério força a PERGUNTA de coevolução, não a resposta — a
			decisão pertence ao founder. Consistente com tq-dmg-04/08/09
			(warns interpretativos do mesmo bloco). [uq-08]: cue vet EXIT=0.
			[uq-04]: rationale do bloco atualizado 11→12 critérios com a
			derivação (drift WI-151/152/153, adr-175) — contagens consistentes
			(post-edit check do próprio PG aplicado ao PG). [uq-07]: zero
			placeholder. [uq-03]: refs a adr-175 e sc-ag-02 resolvem no disco
			desta fatia.
			"""
	}]

	findings: {}

	summary: """
		Elo duplo materializado no PG domain-model: tq-dmg-12 (critério — o
		guide contém a disciplina) + passo operativo em finalValidation.steps
		(a instância executa a verificação de coevolução do agent-spec,
		cobrindo a classe-2 que gate mecânico nenhum vê). Severidade warn por
		P10 (interpretativa). cue vet EXIT=0; contagens do bloco atualizadas.
		VEREDITO: stable, 0 fail.
		"""

	singleRoundRationale: """
		Round único proporcional: adição de 1 critério + 1 passo com desenho
		pré-cravado pelo founder (elo duplo explícito no comando) e verificado
		contra o mecanismo real (revisão de arquiteto sobre uq-09/typeSpecific
		desta sessão); este round confirmou posicionamento, severidade e
		consistência de contagens.
		"""
}
