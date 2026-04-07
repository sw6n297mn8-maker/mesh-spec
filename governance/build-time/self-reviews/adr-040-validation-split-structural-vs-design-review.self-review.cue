package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr040: build_time.#SelfReviewReport & {
	reportId: "srr-adr-040"

	artifactPath:       "architecture/adrs/adr-040-validation-split-structural-vs-design-review.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação contra 11 critérios (8 universais + 3 type-specific
			de #ADR). Artefato: adr-040, que formaliza split entre
			structural verification (gate determinístico) e design review
			(advisory interpretativo) como correção de categoria sobre
			ten-006-validation-non-determinism.

			uq-01 (rationale=WHY): rationale do ADR justifica
			decisionClass=structural (cria categoria nova, reposiciona
			contrato existente, não muda P0-P12), reversibility=medium
			(propagação coordenada de quality-gate.cue/CLAUDE.md, nada
			persistido), blastRadius=cross-cutting (multiple domains,
			não repo-wide pois CI pipeline ainda não tocado), e
			principlesApplied=[P10, P12] (P10 é peça central — split é
			P10 aplicado ao próprio sistema de validação). Cada
			justificativa explica WHY, não WHAT. Pass.

			uq-02 (Mesh-specific): substitution test "Mesh → qualquer
			fintech" falha porque o argumento central é ancorado em
			P10 ("agentes estocásticos recomendam, gates determinísticos
			validam"), princípio específico da Mesh, e referencia
			artefatos Mesh-specific (vp-canvas, canvas IDC, ten-006,
			validation-prompts/, quality-gate.cue). O reframing do
			validador é especificamente sobre como Mesh distingue
			determinístico de interpretativo. Pass.

			uq-03 (referências cruzadas existem): ten-006-validation-non-determinism.cue
			existe (committed b1aed79); governance/build-time/quality-gate.cue
			existe; CLAUDE.md existe; architecture/artifact-schemas/validation-prompt.cue
			existe (verificado em derivedArtifacts); todos os
			architecture/validation-prompts/validate-*.cue existem
			(verificado por listing); structural-check.cue e
			structural-checks/canvas.cue serão criados em commits
			subsequentes como output direto desta decisão. P10 e P12
			existem em architecture/design-principles.cue. Pass.

			uq-04 (consistência com princípios): a decisão aplica P10
			ao próprio sistema de validação por analogia explícita
			(LLM como agente estocástico, structural-check como gate
			determinístico). Não contradiz P10 — opera dentro do seu
			espírito. P12 (governance as code) é satisfeito mantendo
			structural verification em CUE puro. Sem contradição com
			outros princípios. Pass.

			uq-05 (limitações declaradas): consequences negativas lista
			5 limitações concretas: (1) custo de infraestrutura para
			criar schema novo, primeiras regras e runner; (2) risco de
			fronteira mal desenhada (regras quase-interpretativas
			vazando para gate); (3) janela de transição com prompts
			ainda no formato antigo; (4) trabalho de migração não
			capturado nesta ADR (CLAUDE.md, quality-gate.cue, refator
			de prompts); (5) ten-006 não move automaticamente para
			resolved até que schema estrutural exista e cubra vc-cv-03.
			Pass.

			uq-06 (ubiquitous language): termos consistentes ao longo
			do ADR — "structural verification" / "deterministic"
			emparelhados; "interpretive" / "design review" / "advisory"
			emparelhados; "gate" usado consistentemente para mecanismo
			bloqueante. Sem mistura de sinônimos. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD/a-definir/texto
			genérico. Cada campo elaborado. Pass.

			uq-08 (conforma com schema #ADR): id matches ^adr-[0-9]{3}$;
			status=accepted (NonSupersededStatus, supersededBy
			corretamente ausente conforme união discriminada); date
			matches ^[0-9]{4}-[0-9]{2}-[0-9]{2}$; decisionClass valor
			válido do enum (#DecisionClass); reversibility e blastRadius
			valores válidos dos enums; affectedArtifacts não-vazio
			(3 paths); derivedArtifacts presente (12 paths);
			principlesApplied não-vazio (2 paths); todos os campos
			obrigatórios (decider, context, decision, consequences,
			rationale) preenchidos e não-vazios. Pass.

			tq-adr-01 (alternativas com justificativa de rejeição):
			context dedica parágrafo específico à proposta incremental
			rejeitada — typed findings, consensus por múltiplas
			execuções, evidence requirement, uncertain-reading,
			openQuestions protection, separação de modos gate vs análise.
			Justificativa de rejeição: "mitiga sintomas sem corrigir a
			confusão de categoria — mantém um mecanismo único acumulando
			propriedades incompatíveis e a fronteira continua dependendo
			de disciplina interna do LLM". Os elementos úteis dessa
			alternativa são reaproveitados explicitamente como mecânica
			interna do revisor interpretativo, não rejeitados em
			absoluto. Pass.

			tq-adr-02 (metadata de risco reflete decisão): reversibility
			medium é defensável — schema novo e regras serão reversíveis
			sem custo de dados, mas refator coordenado de
			quality-gate.cue + CLAUDE.md exige propagação. Não é high
			(há propagação coordenada necessária); não é low (nada
			persistido). blastRadius cross-cutting reflete que a decisão
			atinge architecture/ + governance/ + o contrato de validação
			que todos os BCs consomem ao validar artefatos. Não é local
			(múltiplos artefatos), não é cross-artifact (múltiplos
			domínios), não é repo-wide (não toca CI pipeline ainda nem
			cada BC individualmente). Pass.

			tq-adr-03 (paths em affectedArtifacts são reais): os 3 paths
			em affectedArtifacts (ten-006-validation-non-determinism.cue,
			governance/build-time/quality-gate.cue, CLAUDE.md) existem
			no repositório. Pass.
			"""
	}]

	findings: {}

	summary: """
		ADR-040 formaliza correção de categoria no sistema de
		validação da Mesh: split entre verificação determinística
		(structural verification, gate em CUE) e julgamento
		interpretativo (design review, advisory em prompts LLM).
		Responde diretamente a ten-006-validation-non-determinism.
		Aplica P10 ao próprio mecanismo de validação. Reposicionamento
		dos validation-prompts existentes como advisory entra em
		vigor pela aceitação da ADR; refator de schema, criação de
		structural-check, e atualização de quality-gate.cue/CLAUDE.md
		são commits subsequentes. Estável em 1 round — todos os 11
		critérios passam.
		"""

	singleRoundRationale: """
		ADR foi moldado através de diálogo iterativo com founder
		antes do drafting: proposta inicial recebeu 3 ajustes
		específicos (mover validation-prompt.cue de affectedArtifacts
		para derivedArtifacts; remover P0 de principlesApplied
		mantendo apenas P10+P12; suavizar detalhes de implementação
		do schema/path novo na decision deixando como direção e não
		núcleo decisório); os 3 ajustes foram aplicados antes desta
		avaliação. Critérios são objetivamente verificáveis: paths
		em affectedArtifacts/derivedArtifacts foram listados via
		filesystem; conformance estrutural ao schema #ADR é checável
		por inspection direta dos campos; alternativas e justificativa
		de rejeição estão explicitamente no context. Não houve
		ambiguidade que exigisse round adicional para descobrir.
		"""
}
