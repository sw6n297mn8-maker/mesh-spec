package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr046: build_time.#SelfReviewReport & {
	reportId: "srr-adr-046"

	artifactPath:       "architecture/adrs/adr-046-conventions-category-and-tmpl-create-convention.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-08"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	singleRoundRationale: """
		Esta versão da Parte A passou por excisão estrita de um
		draft anterior que combinava Parte A com Parte B e foi
		rejeitado pelo founder por contaminação de escopo. Round
		único é apropriado porque a operação aplicada é redutiva:
		remove conteúdo fora de escopo sem introduzir estrutura
		nova sobre a qual abrir nova superfície de ataque. O
		histórico do draft rejeitado é mencionado apenas como
		contexto operacional — o conteúdo deste self-review é a
		verificação do artefato atual contra os critérios.
		"""

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Verificação dos critérios sobre o artefato atual.

			tq-adr-01 (alternativas com rejeição): 4 alternativas
			(a)-(d) presentes em context. Argumento ontológico
			em (a) ('schemas em artifact-schemas/ descrevem
			estrutura interna de um tipo; convenção descreve
			relação entre tipos já definidos') explícito. Pass.

			tq-adr-02 (metadata de risco coerente):
			reversibility=high ancorada em rationale que declara
			escopo estritamente meta-estrutural e contrasta
			explicitamente com reversibility de convenções
			concretas futuras. blastRadius=cross-cutting
			justificado pelo atravessamento de
			artifact-schemas/, ai-orchestration/, governance/ e
			pela criação de architecture/conventions/, sem
			atingir CI inteiro nem repo inteiro. Pass.

			tq-adr-03 (paths reais em affectedArtifacts): 4
			paths — task-template.cue, task-templates.cue,
			task-governance.cue, wi-027.cue — todos existentes
			no repositório e editados neste mesmo commit.
			derivedArtifacts ausente (campo opcional no schema).
			Pass.

			uq-01 (rationale=WHY): rationale explica por que
			resolver os 3 gaps em decisão acoplada, por que
			split Parte A / Parte B, e por que reversibility=high
			se aplica a meta-estrutura. Não descreve o que a
			decisão faz. Pass.

			uq-02 (Mesh-specific): ancorada em P0/P1/P12,
			pattern de singletons governados em
			repo-structure.cue e bounded-context-completeness.cue,
			adr-040 validation split, BCs regulados nomeados
			(FCE/SCF/BKR/REW/IDC/ATO/INS/ITC). Teste de
			substituição ('qualquer fintech') falha — conteúdo
			rastreável a mecanismos específicos do mesh-spec.
			Pass.

			uq-03 (referências cruzadas): adr-042 (pattern de
			coupled decision), adr-040 (validation split),
			ten-009 (deferral n=2), P0/P1/P12,
			design-principles.cue, repo-structure.cue,
			bounded-context-completeness.cue — todas verificadas
			como existentes. Pass.

			uq-04 (consistência com princípios): P0 (zero
			duplicação), P1 (schema-first), P12 (governance as
			code) aplicados corretamente. Nenhuma contradição
			com design-principles.cue. Pass.

			uq-05 (limitações declaradas): 3 known gaps
			explícitos em consequences — #Convention central
			deferido até n=2, taxonomia 3 camadas local-a-esta-ADR,
			follow-ups de convenções concretas fora de escopo.
			Pass.

			uq-06 (ubiquitous language): convention, derivation,
			co-evolution, cross-artefato, meta-estrutural,
			Parte A/Parte B usados consistentemente. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD. Pass.

			uq-08 (conforma com #ADR): status=accepted →
			supersededBy ausente (união discriminada satisfeita);
			id/date conformes; decisionClass=structural,
			reversibility=high, blastRadius=cross-cutting nos
			enums; affectedArtifacts (4) e principlesApplied
			(3) não vazios; supersedes=[] válido; rationale
			não vazio. Pass.

			Zero findings. Stable.
			"""
	}]

	findings: {}

	summary: """
		adr-046 Parte A estável. Escopo estritamente
		meta-estrutural: criação da categoria
		architecture/conventions/, extensão de #TaskTemplate.kind
		com create-convention, criação de
		tmpl-create-convention@v1, override em task-governance,
		reclassificação de WI-027 (v1→v2 + templateRef). Nenhuma
		convenção concreta incluída. 8 critérios universais e 3
		type-specific verificados. Zero findings pendentes.
		"""
}
