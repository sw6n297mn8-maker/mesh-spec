package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

taskTemplateSchemaV2: build_time.#SelfReviewReport & {
	reportId: "srr-task-template-kind-create-script"

	artifactPath:       "architecture/artifact-schemas/task-template.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Mudança cirúrgica de superfície mínima: adiciona "create-script"
		como quarto valor do enum fechado #TaskTemplate.kind na linha 21.
		Nenhum outro campo, constraint, _schema.location ou
		_qualityCriteria é tocado. O enum continua fechado (mesma
		disciplina semântica de kinds), apenas ganha um valor cuja
		semântica é definida externamente pela ADR-042 e instanciada
		por tmpl-create-script@v1 no mesmo commit. Não há ambiguidade
		estrutural a descobrir em rounds adicionais — a decisão de
		design (criar categoria nova em vez de reutilizar existente)
		vive na ADR, não no schema; o schema apenas materializa a
		extensão. Revisão por inspection direta é suficiente.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação contra 8 critérios universais + 3 type-specific
			de #ArtifactSchema (tq-as-01/02/03).

			uq-01 (rationale=WHY): a extensão do enum não altera campos
			com rationale no schema. Rationale da decisão vive em adr-042
			e justifica por que criar categoria nova em vez de reutilizar
			tmpl-create-instance: scripts não são instâncias de schemas,
			reutilizar contamina o template-alvo com ritual inaplicável
			(tq-tt-01). Pass.

			uq-02 (Mesh-specific): o valor "create-script" do enum é
			neutro, mas o motivo da extensão é ancorado em mecanismos
			Mesh — CLAUDE.md como artefato derivado de config.cue +
			output.cue, política de rastreamento de scripts de governança
			como WI (adr-042), e P0/P1/P12. Substitution test: "scripts
			de build em qualquer fintech" não carrega o compromisso
			específico Mesh de governance-as-code sobre o próprio sistema
			de templates. Pass.

			uq-03 (refs cruzadas): o schema não ganha referências novas.
			A instância que consome o novo valor (tmpl-create-script@v1)
			é criada no mesmo commit em task-templates.cue e referenciada
			por task-governance.cue. Pass.

			uq-04 (consistência com princípios): a extensão não tensiona
			P0 (zero duplicação) — há uma única definição do enum. Não
			tensiona P1 (schema-first) — a extensão do schema precede a
			instância do template no mesmo commit. Aplica P12
			(governance as code) ao tratar script de build como artefato
			versionado com protocolo formal. Pass.

			uq-05 (limitações declaradas): a limitação primária é
			declarada em adr-042 — o template resultante cobre apenas
			scripts de build/governança, não scripts experimentais.
			Política de fronteira está na ADR, não no schema. Pass.

			uq-06 (ubiquitous language): "create-script" segue o padrão
			kebab-case dos outros três valores do enum
			(create-schema, validate-artifact, create-instance).
			Consistência lexical preservada. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD. Pass.

			uq-08 (conforma com schema #ArtifactSchema): o schema
			continua válido após a extensão — enum fechado com 4
			valores, sem dependência circular, _schema.location e
			_qualityCriteria preservados intactos. cue vet verifica
			conformidade estrutural no pre-commit. Pass.

			tq-as-01 (canonicalPathRegex plausível): não alterado,
			continua ^architecture/artifact-schemas/task-template\\.cue$.
			Pass.

			tq-as-02 (critérios de qualidade tipo-específicos
			acionáveis): não alterados. tq-tt-01 e tq-tt-02 continuam
			válidos e aplicáveis à categoria nova do enum — um template
			de script também precisa ter steps verificáveis
			(tq-tt-01) e gates não redundantes com universalCriteria
			(tq-tt-02). Pass.

			tq-as-03 (schema completo): todos os campos obrigatórios
			preservados. kind continua como união fechada, discriminação
			implícita por valor. Pass.
			"""
	}]

	findings: {}

	summary: """
		Schema #TaskTemplate recebe quarto valor "create-script" no
		enum kind, sem outras alterações. Mudança cirúrgica ancorada
		em adr-042 (ADR no mesmo commit). Enum permanece fechado,
		contrato existente preservado, tq-tt-01/02 continuam
		aplicáveis à categoria nova. Zero findings — a decisão de
		design (criar categoria em vez de reutilizar) vive na ADR,
		o schema apenas materializa. Estável em 1 round via
		inspection direta.
		"""
}

taskTemplateSchemaV3: build_time.#SelfReviewReport & {
	reportId: "srr-task-template-kind-create-convention"

	artifactPath:       "architecture/artifact-schemas/task-template.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-08"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Mudança cirúrgica de superfície mínima: adiciona
		"create-convention" como quinto valor do enum fechado
		#TaskTemplate.kind na linha 21. Nenhum outro campo,
		constraint, _schema.location ou _qualityCriteria é tocado.
		O enum continua fechado (mesma disciplina semântica de
		kinds), apenas ganha um valor cuja semântica é definida
		externamente pela adr-046 (Parte A) e instanciada por
		tmpl-create-convention@v1 no mesmo pacote de commits. Não
		há ambiguidade estrutural a descobrir em rounds adicionais
		— a decisão de design (criar categoria meta-estrutural
		conventions/ em vez de reutilizar tmpl-create-schema,
		tmpl-create-instance ou tmpl-create-script) vive na ADR,
		não no schema; o schema apenas materializa a extensão.
		Revisão por inspection direta é suficiente.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação contra 8 critérios universais + 3 type-specific
			de #ArtifactSchema (tq-as-01/02/03).

			uq-01 (rationale=WHY): a extensão do enum não altera
			campos com rationale no schema. Rationale da decisão
			vive em adr-046 e justifica por que criar categoria nova
			em vez de reutilizar tmpl-create-schema (convenção não
			define #Type contra o qual instâncias unificam),
			tmpl-create-instance (convenção não pressupõe schema
			pré-existente de si mesma) ou tmpl-create-script
			(convenção não é executável com gates de idempotência
			e reprodutibilidade). Pass.

			uq-02 (Mesh-specific): o valor "create-convention" do
			enum é neutro, mas o motivo da extensão é ancorado em
			mecanismos Mesh — três camadas schema/princípio/
			convenção como enquadramento interno, pattern de
			singletons governados (repo-structure.cue,
			bounded-context-completeness.cue), adr-040 validation
			split, e P0/P1/P12. Substitution test: "templates de
			convenção em qualquer sistema" não carrega o compromisso
			Mesh de governance-as-code sobre o próprio sistema de
			protocolos de derivação cross-artefato. Pass.

			uq-03 (refs cruzadas): o schema não ganha referências
			novas. A instância que consome o novo valor
			(tmpl-create-convention@v1) é criada no mesmo pacote
			de commits em task-templates.cue e referenciada por
			task-governance.cue. Pass.

			uq-04 (consistência com princípios): a extensão não
			tensiona P0 (zero duplicação) — há uma única definição
			do enum. Não tensiona P1 (schema-first) — a extensão
			do schema precede a instância do template. Aplica P12
			(governance as code) ao tratar convenção cross-artefato
			como artefato versionado com protocolo formal de
			criação. Pass.

			uq-05 (limitações declaradas): a limitação primária é
			declarada em adr-046 — o template resultante cobre
			apenas protocolo de criação; #Convention schema central
			fica deferido até n=2 convenções concretas (pattern
			ten-009). Política de fronteira está na ADR, não no
			schema. Pass.

			uq-06 (ubiquitous language): "create-convention" segue
			o padrão kebab-case dos quatro valores existentes
			(create-schema, validate-artifact, create-instance,
			create-script). Consistência lexical preservada. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD. Pass.

			uq-08 (conforma com schema #ArtifactSchema): o schema
			continua válido após a extensão — enum fechado com 5
			valores, sem dependência circular, _schema.location e
			_qualityCriteria preservados intactos. cue vet verifica
			conformidade estrutural no pre-commit. Pass.

			tq-as-01 (canonicalPathRegex plausível): não alterado,
			continua ^architecture/artifact-schemas/task-template\\.cue$.
			Pass.

			tq-as-02 (critérios de qualidade tipo-específicos
			acionáveis): não alterados. tq-tt-01 e tq-tt-02
			continuam válidos e aplicáveis à categoria nova do
			enum — um template de convenção também precisa ter
			steps verificáveis (tq-tt-01) e gates não redundantes
			com universalCriteria (tq-tt-02). Pass.

			tq-as-03 (schema completo): todos os campos
			obrigatórios preservados. kind continua como união
			fechada, discriminação implícita por valor. Pass.
			"""
	}]

	findings: {}

	summary: """
		Schema #TaskTemplate recebe quinto valor "create-convention"
		no enum kind, sem outras alterações. Mudança cirúrgica
		ancorada em adr-046 (Parte A já commitada no mesmo pacote).
		Enum permanece fechado, contrato existente preservado,
		tq-tt-01/02 continuam aplicáveis à categoria nova. Zero
		findings — a decisão de design (criar categoria
		meta-estrutural em vez de reutilizar) vive na ADR, o
		schema apenas materializa. Estável em 1 round via
		inspection direta.
		"""
}
