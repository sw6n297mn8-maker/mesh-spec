package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr194EstablishDesignSystemConstitution: build_time.#SelfReviewReport & {
	reportId: "srr-adr-194-establish-design-system-constitution"

	artifactPath:       "architecture/adrs/adr-194-establish-design-system-constitution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-14"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			Nota de modo: rollout adr → isolated-subagent, mas o ambiente do
			builder da missão M7.5 não dispõe de ferramenta de dispatch de
			subagente — self-reported honesto (mesma limitação registrada em
			disp-011 do subagent-execution-log); mitigação: verificação de
			toda citação cross-file contra o arquivo-fonte real via grep/Read.
			1 fail (uq-03/fidelidade de citação): a falsificação (b) do
			adr-157 estava citada entre aspas como "runtime cristalizar
			design system como decisão canônica do spec" — paráfrase vestida
			de verbatim; o texto real é "ela CRISTALIZAR uma hipótese
			runtime-local (vendor, transporte, design system) como decisão
			canônica do mesh-spec — fronteira de autoridade falhou"
			(verificado por leitura de adr-157 l.145-151). Corrigido: dec 2
			agora cita o texto real com marcação verbatim. Demais checagens
			do round: citações de adr-157 dec 3/dec 5 e adr-150 N1 conferidas
			byte a byte contra os arquivos ✓; os 12 nomes de lens da dec 8
			conferidos contra ls de architecture/lenses/ ✓; todos os paths de
			affectedArtifacts/plannedOutputs/derivedArtifacts existem no
			working tree ✓ (tq-adr-03); cue vet OK (deterministicGate).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-avaliação pós-correção: a citação da falsificação (b) agora é
			verbatim e a leitura ("vigia hipótese nascendo NO runtime; aqui a
			decisão nasceu do founder NO spec") permanece válida sobre o texto
			real. Regressão checada critério a critério: tq-adr-01
			(alternativas a-d com motivo de rejeição) ✓; tq-adr-02
			(medium/cross-cutting calibrados com justificativa própria no
			rationale, não default) ✓; tq-adr-04 (3 blocos de rastreabilidade
			populados; disciplina 3-way adr-059: affected=existentes
			alterados, planned=criados, derived=regenerados) ✓; uq-04 (dec 9
			conforma a P10/adr-040/ten-006 — nenhum gate interpretativo
			criado) ✓; uq-06 (Constituição/token-contract/camada usados
			consistentemente) ✓. Zero findings novos — estável.
			"""
	}]

	findings: {}

	summary: """
		adr-194 (canonização da Constituição do Design System) autorado sob
		missão M7.5/adr-193 seguindo o PG-ADR (workOrder de 3 sections,
		serialmente: scaffold-and-classification →
		context-decision-and-alternatives →
		consequences-rationale-and-traceability), com auto-checagem por
		section contra doneCriteria. Evidência uq-09 (Camada 3): dentro de
		missão adr-193 o founder não atua como aprovador por seção
		(adr-193 dec 4); a decisão semântica — conteúdo integral da
		Constituição + ordem de canonização com 10 itens de decisão
		pré-tomados — veio do founder na autorização da missão, e o gate
		humano final é o review do PR da missão; os section gates foram
		exercidos como auto-checagem serial documentada (padrão registrado
		aqui, não silenciado). Self-review em modo self-reported (dispatch
		indisponível no ambiente — ver round 1): round 1 → 1 fail de
		fidelidade de citação (corrigido na fonte), round 2 → zero findings.
		Estável em 2/4 rounds.
		"""
}
