package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr120: build_time.#SelfReviewReport & {
	reportId: "srr-adr-120"

	artifactPath:       "architecture/adrs/adr-120-edge-filter-exists-operator.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-29"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			ADR documenta PR-2 do plano de cycle-resolution (Família B
			da taxonomia def-028): capability-extension no
			#DirectedAcyclicityRule.edgeFilters (novo operator
			exists: bool) + first-consumer no sc-cm-07 (4ª entrada
			{path: "events", exists: true}).

			Investigação prévia (Fase 1) sobre as 47 relationships do
			strategic/context-map.cue identificou exatamente 4 arestas
			sem field events: tcm-to-fce (W4 do sc-cm-07) + 3 outras
			query-surfaces benignas (idc-to-log, idc-to-dlv, npm-to-ctr).
			Validação factual: nenhuma das 3 não-W4 participa de
			qualquer ciclo atual do sc-cm-07 (W1 drc↔cmt, W2
			cmt→rew→dlv→bdg→cmt, W3 fce→drc→cmt→rew→fce permanecem
			inalterados após o filter). Generalização proativa do
			critério não introduz regression no estado vigente.

			Decisão passou por Fase 1 (mapping + validação factual de
			47 arestas) + Fase 2 (red team 3 ciclos, calibração de
			alternativas Opção α vs β, framing das 3 query-surfaces
			não-W4 como benefício P3 per direção founder, não como
			side-effect a documentar como gap). 4 alternativas
			explicitamente rejeitadas: (a) critério rigoroso 3-condições
			+ edgeExcludeFilters (2 conceitos novos vs 1, cobertura
			idêntica); (b) operators present + absent separados (dobra
			superfície vs binary exists); (c) ad-hoc per-path (anti-DRY);
			(d) equals: "<absent>" (gambiarra semântica).

			Pattern paralelo a adr-049 (conditional-file-presence),
			adr-056 (production-guide-coverage), adr-063 (filesystem-
			path-exists), adr-076 (at-least-one-block-present), adr-080
			(domain-invariant), adr-117 (directed-acyclicity inicial),
			adr-118 (bidirectional-orchestration), adr-119 (policy-
			reaction) — oitava extensão orgânica de framework de check.

			Internalização do scan complementar previsto em
			def-028.triggerCalibrationRationale: filter aplica
			uniformemente nas 4 query-surfaces, reduzindo o escopo do
			PR-3 (que originalmente carregaria identificação +
			validação manual de outras query-surfaces). PR-3 só
			precisa CONFIRMAR (não identificar) que nenhuma das 3
			não-W4 esconde coupling arquitetural — confirmação simples
			via inspeção de subdomain owner intent.

			Decisão de NÃO usar defersTo: mesma análise que adr-118/119
			em PR #84. def-028 foi criado em PR #83 anterior; este ADR
			só materializa o passo 2 do plano. Schema #ADR.defersTo
			descreve "Deferimentos CRIADOS por esta decisão" (semântica
			estrita); relacionamento documentado em prose (context +
			rationale). Resolução de def-028 ocorre em PR-3 via
			resolvedBy → ADR de PR-3.

			principlesApplied: P0, P1, P12. decisionClass=structural,
			reversibility=high, blastRadius=cross-artifact.
			affectedArtifacts: 3 (structural-check.cue + runner.py +
			context-map.cue structural-check). plannedOutputs: 3.
			supersedes: vazio. cue vet ./... EXIT=0.

			Risco categórico em N3 (hipotético): se uma das 3 query-
			surfaces não-W4 se revelar coupling arquitetural disfarçado
			(publisher deveria publicar event mas usa query síncrona),
			filter esconderia o coupling do sc-cm-07. Mitigação:
			confirmação manual em PR-3 + revisitação se canvas do BC
			produtor materializar event flow distinto. Risco zero no
			estado vigente.

			Zero risco de regression no equals puro: sc-g-01 pré-
			existente no --self-test cobre regression do operator
			anterior. Novos casos sc-g-02 (exists:true presente +
			cycle), sc-g-03 (AND-composto equals+exists), sc-g-04
			(exists:false inverso) cobrem capability nova.
			"""
	}]

	findings: {}

	summary: """
		ADR-120 estende #DirectedAcyclicityRule.edgeFilters com operator
		exists: bool (binary, primitiva mínima) + adiciona 4ª entrada
		{path: "events", exists: true} no sc-cm-07. Resolve W4 (fce↔tcm)
		por filter declarativo + internaliza scan complementar de 3
		outras query-surfaces (idc-to-log, idc-to-dlv, npm-to-ctr) per
		generalização proativa (P3). Pattern paralelo a adr-049/056/
		063/076/080/117/118/119. defersTo não usado (semântica estrita;
		def-028 criado em PR #83 anterior).
		"""

	singleRoundRationale: """
		Pattern bem-estabelecido (oitava extensão orgânica de framework
		de check; precedentes adr-049/056/063/076/080/117/118/119).
		Decisão passou por Fase 1 (validação factual 47 arestas) +
		Fase 2 (red team 3 ciclos, calibração de alternativas,
		reframing das 3 query-surfaces não-W4 como benefício P3 per
		direção founder) antes da escrita. Self-test PASS (sc-g-02/03/
		04 novos + sc-g-01 regression). Validação local PASS (sc-cm-07
		reporta 3 WARN — W1/W2/W3; W4 saiu). Round único suficiente.
		"""
}
