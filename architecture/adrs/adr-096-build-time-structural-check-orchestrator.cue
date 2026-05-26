package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr096: artifact_schemas.#ADR & {
	id:    "adr-096"
	title: "Ativar orquestração build-time dos structural-checks determinísticos"
	date:  "2026-05-25"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-040 separou a validação pós-commit em duas camadas e declarou os
		structural-checks como o ÚNICO gate determinístico que pode bloquear o
		fluxo. Os kinds foram acumulando (adr-041/049/056/063/064/080/090: de
		required-block a domain-invariant e singleton-coverage) e ~15 arquivos de
		structural-check foram autorados — mas NUNCA existiu um executor. As regras
		eram dados declarativos que ninguém rodava: o CLAUDE.md delega a execução ao
		agente "à mão" pós-commit, o que é estocástico e CONTRADIZ o P10 que os
		checks dizem encarnar. Consequência observada: o D7 (work-events sem
		task-spec) e outros drifts persistiram porque o gate que os pegaria era
		especificação, não programa.

		adr-090 (estrutura derivada) introduz o GERADOR de índice estrutural
		(generate-structure-index.sh) e a política fileClassification, mas trata da
		derivação do mapa — NÃO do executor que avalia as regras #StructuralCheck.
		O avaliador permaneceu sem ADR.

		Alternativa considerada e REJEITADA: manter a execução "pelo agente"
		(status quo). Reprovada — estocástica, não-reproduzível, sem accountability;
		viola P10 e foi a causa direta do drift silencioso (D7).
		"""

	decision: """
		Introduzir o Build-Time Structural Check Orchestrator
		(scripts/ci/structural-check-runner.py): avaliador DETERMINÍSTICO que faz
		parte do build-time governance layer — não executa lógica de produto nem
		runtime operacional; avalia, em CI/build-time, se os artefatos do
		repositório respeitam os structural-checks declarados como código.

		Mecânica: (1) carrega structuralChecks via cue export; (2) despacha cada
		check por kind a um evaluator — cobertura dos 10 kinds; (3) resolve
		_schema.location (inclusive campos ocultos + disjunções) para mapear
		artifactType→arquivos; (4) aplica fileClassification (órfão=INFO; ambíguo
		≥2 schemas=violação) implementando a política já declarada no adr-090;
		(5) exclui as zonas governadas por work-governance. Resiliente: cada
		evaluator roda isolado (try/except) — check que estoura vira [ERROR] e não
		aborta o inventário.

		Dois modos: warn (report-only, exit 0) e reject (exit 1 em violação).
		Plugado no validate.yml em modo WARN inicialmente — "passada de descoberta"
		que torna o drift visível sem travar merges. Promoção de checks específicos
		para gate bloqueante (reject) é incremental e por evidência, FORA do escopo
		desta decisão.
		"""

	consequences: """
		Positivas: (1) os structural-checks declarados finalmente EXECUTAM
		deterministicamente — fecha o gap "regra sem robô"; (2) honra P10 (programa
		reproduzível, não LLM como gate); (3) torna drift (D7, ambiguidade,
		singletons ausentes) VISÍVEL em CI; (4) é a base de execução que o cutover
		do adr-090 e as futuras meta-trancas de cobertura exigem; (5) self-test
		sintético protege o próprio avaliador contra regressão.

		Negativas: (1) modo warn não bloqueia — drift ainda faz merge até a promoção
		(intencional, anti-big-bang); (2) custo de performance: shell-out a `cue`
		por check/artefato; (3) domain-invariant só é checado na parte
		build-time-decidível (runtime-gap fica advisory); (4) o inventário hardcoda
		fallbacks (scope default) que idealmente derivam do structure-index do
		adr-090 — alinhamento futuro.
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: []
	plannedOutputs: [
		"scripts/ci/structural-check-runner.py",
		".github/workflows/validate.yml",
	]

	principlesApplied: [
		"P10 — agentes recomendam, gates determinísticos validam: o runner é o gate determinístico que faltava",
		"adr-040 — separação structural (gate) vs advisory: operacionaliza o gate declarado",
		"adr-090 — implementa a política fileClassification e consome _schema.location",
		"dp-04 — determinismo operacional",
	]

	rationale: """
		ADR retroativo (backfill): o runner foi commitado (efbcced) + plugado no CI
		(d081b28) SEM ADR, violando a regra do CLAUDE.md de que artefato estrutural
		exige ADR no mesmo commit. Esta ADR registra a decisão de fato já vigente.

		decisionClass structural: introduz mecanismo de execução novo na camada de
		governança/CI sem redefinir princípios base (P0–P12 intactos — isto os
		APLICA, como adr-090). reversibility high: em modo warn é puramente aditivo,
		removível sem impacto em dados/contratos. blastRadius repo-wide: mecanismo de
		CI/governança que avalia o repositório inteiro.

		plannedOutputs vs affectedArtifacts: a decisão É "criar o runner E ativá-lo
		em build-time" — logo tanto o script novo quanto a alteração do validate.yml
		(o wiring que materializa a ativação) são OUTPUTS DIRETOS da decisão, ambos
		em plannedOutputs. affectedArtifacts vazio: nenhum artefato normativo
		pré-existente é meramente afetado sem ser output direto desta decisão.

		Distinção de adr-090: lá o GERADOR deriva o mapa; aqui o ORCHESTRATOR executa
		as regras #StructuralCheck. Artefatos e responsabilidades distintos,
		complementares.

		Próximo passo (fora desta decisão): promover checks de warn→reject por
		evidência (a "catraca"), começando pelos que nascem verdes.
		"""
}
