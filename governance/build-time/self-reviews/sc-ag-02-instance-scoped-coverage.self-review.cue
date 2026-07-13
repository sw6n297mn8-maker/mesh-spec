package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

scAg02InstanceScopedCoverage: build_time.#SelfReviewReport & {
	reportId: "srr-sc-ag-02-instance-scoped-coverage"

	artifactPath:       "architecture/structural-checks/agent-spec.cue"
	artifactSchemaPath: "architecture/artifact-schemas/structural-check.cue"
	artifactType:       "structural-check"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-07-13"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 — self-review do sc-ag-02 (kind novo instance-scoped-cross-
			file-coverage, adr-175) + extensão do sc-ag-01 (operationalScope.
			domainServices[] em referencePaths — a 6ª família vale nas duas
			direções). ESTE ROUND REGISTRA TAMBÉM A EVIDÊNCIA DO MOTOR (o
			runner é script, sem tipo próprio no enum #ArtifactType; precedente
			adr-096/133/153 revisa o motor junto do ADR/check): o evaluator
			ev_instance_scoped_cross_file_coverage NASCEU COM A FIXTURE no
			mesmo commit — a fixture da suíte de self-test cobre os 5 casos
			exigidos (id coberto via scope OK; id coberto via action refs OK;
			id não coberto sem exclusão VIOLA — único finding esperado; id
			excluído por ref OK; ids excluídos por classe OK; família fora de
			targetIdPaths ignorada). `structural-check-runner.py --self-test`
			= PASS. Self-asserção M1 (sc-meta-01 evaluator-coverage) verde:
			kind declarado/usado tem evaluator em EVAL.

			[tq-sc-01 acionabilidade]: errorMessage nomeia o id, o BC e as DUAS
			saídas válidas (coevoluir operationalScope/actions OU declarar
			scopeExclusions com rationale, apontando o critério do adr-175).
			[tq-sc-02 união por kind]: rule conforma ao shape novo
			(exclusionPaths required presente). [tq-sc-03 rationale rastreável]:
			cita o caso concreto (WI-151/152/153 driftaram sem gate) e o
			princípio (direção inversa do adr-113; born-warn adr-097 com
			precedente adr-117→123). [uq-08]: cue vet EXIT=0.

			Execução real na ativação: sc-ag-02 ANUNCIA 61 itens em WARN, 0
			bloqueantes — bdg 3 (delta WI-153), cmt 2 (pré-existente), p2p 16
			(delta WI-151), rew 35 (pré-existente + delta de medição
			estruturada-vs-textual da simulação), ssc 5 (3 delta WI-152 + 2
			svc- que a 6ª família tornou exigíveis). Nenhum check existente
			mudou de resultado (sc-ag-01 segue 0 violações — a referencePath
			nova não invalida ref alguma; sc-cm-07 sem aresta nova).
			Enforcement WARN nato per adr-097 — catraca a reject condicionada
			a baseline zero (WI-154/WI-155), decisão futura própria.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — F4 do review isolado do adr-175 (decisão (a) do
			founder): sc-ag-01 ganhou os 2 paths de scopeExclusions
			(scopeExclusions[].ref e scopeExclusions[].refs[]) em
			referencePaths — ids EXCLUÍDOS agora são validados como
			existentes no domain-model do BC pela mesma máquina que valida
			os cobertos (kind instance-scoped-cross-file-id-exists, reject).
			Exclusão dangling (typo, ou building block removido depois da
			exclusão) vira violação em vez de silêncio — fecha a versão
			mecânica do cenário 'exclusão-como-válvula-de-escape' da
			falsificationCondition (a) do adr-175. Description do sc-ag-01
			atualizada declarando a extensão. Escopo respeitado: NADA mudou
			no sc-ag-02 nem no kind novo. Verificação: cue vet EXIT=0;
			runner real — sc-ag-01 segue com ZERO violações (nenhuma
			instância tem scopeExclusions populado ainda; os paths novos são
			vazios em todas — nenhum falso-positivo introduzido); TOTAL do
			runner inalterado (92/0).
			"""
	}]

	findings: {}

	summary: """
		sc-ag-02 born-warn fecha a direção inversa do contrato agente↔modelo
		(catálogo das 6 famílias coberto-ou-excluído, união por escopo) e o
		sc-ag-01 ganha a 6ª família na direção existente. Motor + fixture
		nasceram juntos (self-test PASS; 5 casos; M1 verde). Baseline
		anunciado: 61 warns, 0 bloqueantes, composição explicada por BC.
		Round 2 (F4 do review isolado, decisão do founder): sc-ag-01
		estendido com os 2 paths de scopeExclusions — exclusão dangling é
		violação; zero falso-positivo introduzido (runner inalterado 92/0).
		VEREDITO: stable, 0 fail.
		"""
}
