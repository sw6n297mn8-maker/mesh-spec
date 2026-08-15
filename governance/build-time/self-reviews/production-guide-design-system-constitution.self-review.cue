package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

productionGuideDesignSystemConstitution: build_time.#SelfReviewReport & {
	reportId: "srr-production-guide-design-system-constitution"

	artifactPath:       "architecture/production-guides/design-system-constitution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-14"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Nota de modo: production-guide está em rollout DUPLO —
			authoring subagent-drafted (authoring-policy) + review
			isolated-subagent (quality-gate executionPolicy). O ambiente do
			builder da missão M7.5 não dispõe de ferramenta de dispatch:
			AUTORIA por manual takeover (fallbackPolicy + CLAUDE.md; motivo
			no commit message; entry disp-011 no subagent-execution-log) e
			REVIEW em modo self-reported honesto — o viés de
			auto-ratificação (adr-054 dec 10) fica mitigado apenas pelo
			founder review no PR da missão, limitação declarada. Passada
			fresh-eyes contra uq-01..09 + tq-pg-01..06 + tq-mg-01/03/04 +
			tq-dcg-01..03: 1 warn (tq-pg-06): action "Classificar a mudança
			de token..." fora da lista canônica de verbos imperativos usada
			pelos PGs recentes (Ler, Verificar, Avaliar, Declarar, Compor,
			Documentar, Identificar, Listar — molde fcc/disp-010); corrigido
			para "Avaliar o regime da mudança de token pelo texto da camada".
			tq-pg-01 ✓ (workOrder = permutação exata das 3 sections);
			tq-pg-02 ✓ (targets #DesignSystemConstitution, #TokenContract,
			#CanonicalCase existem no schema alvo); tq-mg-04 ✓ (gapPolicy
			contém "NÃO invente"/"NÃO infira" + cláusulas concretas de
			preservação, STOP sem elo, anti-reclassificação, anti-lens);
			tq-mg-03 ✓ (último step é submissão ao founder como step próprio,
			com a nota adr-193 de como o gate se cumpre em missão).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Re-avaliação pós-correção do verbo: todos os process[].action
			agora iniciam com verbo da lista canônica. Regressão checada:
			doneCriteria avaliáveis por leitura (tq-pg-03); ifGap de cada
			section devolve ao founder em vez de inventar (coerente com
			gapPolicy); reconciliation pairs cross-field conferem
			tokens↔camadas, emendas↔ADR, pendências↔classificação e a
			completude da instância composta via cue export. Guide MÍNIMO
			confirmado contra a proibição da missão (nenhum tratado: 3
			sections, 3 critérios, só o que o shape não garante). Zero
			findings novos — estável.
			"""
	}]

	findings: {}

	summary: """
		PG do tipo novo design-system-constitution (adr-194; cascade adr-053 +
		adr-054 dec 13 — PG nasce na MESMA fatia do schema; sc-pg-01
		coveredSchemas += no mesmo commit). Autoria por MANUAL TAKEOVER
		documentado (dispatch indisponível no ambiente — disp-011), aplicando
		o meta-guide com o molde do PG-fcc: guide mínimo com 3 sections
		(amendment-and-derivation, token-and-promulgation,
		jurisprudence-and-pendencias) cobrindo exatamente o que o shape não
		alcança — cadeia de derivação + trade-off (STOP sem elo superior),
		fronteiras emenda/calibração e lei/promulgação, disciplina de
		jurisprudência (caso novo = candidato até decisão do founder) e
		classificação de pendências. Round 1 → 1 warn de verbo canônico
		(corrigido); round 2 → zero. Estável em 2/4 rounds.
		"""
}

// ── Emenda 1.1 (adr-195) ── segundo report sobre o MESMO guide: o
// alinhamento da section token-and-promulgation ao critério causal.
productionGuideDesignSystemConstitutionAmendment11: build_time.#SelfReviewReport & {
	reportId: "srr-production-guide-design-system-constitution-amendment-1-1"

	artifactPath:       "architecture/production-guides/design-system-constitution.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-08-15"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	singleRoundRationale: """
		A mudança é de redação em cinco lugares que enunciavam o critério
		antigo com exemplos que a emenda 1.1 torna falsos (tinta e ranges
		de movimento citados como bound): a action e o detail do primeiro
		passo de token-and-promulgation, o test de tq-dcg-02, a cláusula de
		regime no gapPolicy, o objective e o doneCriteria da section, e o
		passo correspondente em finalValidation. Nenhuma section foi
		criada, removida ou reordenada — workOrder permanece a permutação
		exata das três chaves de sections (tq-pg-01 conferido), targets e
		sources idênticos. Round único porque a verificação é fechada: o
		conjunto de ocorrências foi levantado por grep sobre o arquivo
		('pelo texto', 'derivado do texto') e cada uma foi classificada
		antes de editar — as duas que falam de CLASSIFICAÇÃO DE PENDÊNCIA
		('porquê derivado do texto', tq-dcg-03 e o objective de
		jurisprudence-and-pendencias) foram deliberadamente NÃO tocadas,
		porque ali 'derivado do texto' continua correto e nada tem a ver
		com regime de token.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Verificação do alinhamento da section token-and-promulgation:
			o guide passa a instruir a decisão de regime pela CAUSA (resta
			valor livre dentro da moldura?) e traz exemplos dos dois lados
			que batem com o contrato vigente pós-emenda — pressionado,
			links, raio estrutural e ease-out do lado bound; off-white,
			hex semânticos sobre piso, espessura de foco e base de grid do
			lado calibratable. gapPolicy mantém as duas proibições que
			importam (não reclassificar por conveniência; não calibrar
			valor vivo editando o spec) e troca apenas o critério que as
			resolve. cue vet ./architecture/production-guides/ verde.
			"""
	}]

	findings: {}

	summary: """
		Emenda pontual no production-guide da Constituição: a section
		token-and-promulgation deixa de ensinar o critério sintático e passa
		a ensinar o causal (adr-195), com exemplos corrigidos dos dois
		lados. Sem mudança estrutural — três sections, mesma workOrder,
		mesmos targets. Estável em 1 round, com rationale declarado e com
		registro explícito das duas ocorrências de 'derivado do texto' que
		NÃO foram tocadas por pertencerem à classificação de pendências.
		"""
}
