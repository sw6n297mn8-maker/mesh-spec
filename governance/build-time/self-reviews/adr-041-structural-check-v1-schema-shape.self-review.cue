package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr041: build_time.#SelfReviewReport & {
	reportId: "srr-adr-041"

	artifactPath:       "architecture/adrs/adr-041-structural-check-v1-schema-shape.cue"
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
			de #ADR). Artefato: adr-041, que decide o shape concreto do
			schema structural-check v1 — 8 campos, 3 kinds (required-block,
			reference-exists, same-artifact-consistency), rule como dado
			estruturado e não snippet CUE, sem severity (sempre fail).
			ADR derivada de adr-040.

			uq-01 (rationale=WHY): rationale do ADR justifica
			decisionClass=structural (cria tipo novo, estabelece contrato
			que subsequentes instâncias consomem), reversibility=medium
			(reversível sem custo de dados mas commit a contrato),
			blastRadius=cross-cutting (condiciona como todos os tipos de
			artefato serão estruturalmente validados), [P10, P12] (P10
			pela coerência interna entre rule estruturada e fronteira
			determinístico/interpretativo, P12 pela materialização de
			governance as code). Cada justificativa explica WHY. Pass.

			uq-02 (Mesh-specific): substitution test "Mesh → qualquer
			fintech" falha porque o argumento central é a aplicação interna
			de P10 ao próprio mecanismo de gate (princípio Mesh-specific)
			e a referência ao caso vc-cv-03 sobre canvas IDC (artefato
			Mesh-specific). A disciplina anti-mini-DSL é especificamente
			sobre não reintroduzir a confusão de categoria que adr-040
			corrige no contexto Mesh. Pass.

			uq-03 (referências cruzadas existem): adr-040 existe
			(committed 9ca2cda); architecture/artifact-schemas/structural-check.cue
			será criado como output direto desta decisão; architecture/structural-checks/canvas.cue
			será criado como derivado; vc-cv-03 e canvas IDC referenciados
			em texto descritivo (não em campos de path); P10 e P12 existem
			em architecture/design-principles.cue. Pass.

			uq-04 (consistência com princípios): a decisão de manter rule
			como dado estruturado preserva a fronteira de adr-040 dentro
			do próprio mecanismo de gate. P10 não é violado, é aplicado
			com mais profundidade. P12 é satisfeito mantendo regras como
			CUE versionado. Sem contradição com outros princípios. Nota:
			versão preliminar do conteúdo continha contradição interna
			entre decision (reference-exists soava cross-artifact) e
			consequences (declarava cross-artifact fora da v1). Contradição
			corrigida na revisão de proposta antes do drafting deste
			report — versão final restringe reference-exists a referências
			internas ao mesmo artefato e declara cross-artifact-check
			explicitamente como v2. Pass.

			uq-05 (limitações declaradas): consequences negativas listam
			4 limitações concretas: (1) limitação expressiva temporária —
			alguns checks desejáveis para canvas podem não caber nos 3
			kinds atuais; (2) custo de adição de cada novo kind exige
			decisão explícita; (3) sem cardinalidade genérica na v1;
			(4) sem cross-artifact-check na v1 — referências entre
			artefatos distintos ficam para v2. Pass.

			uq-06 (ubiquitous language): termos consistentes — kind, rule,
			declarativo, gate, structural, decidível, runner-friendly.
			Sem mistura de sinônimos. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD/a-definir. Pass.

			uq-08 (conforma com schema #ADR): id matches ^adr-[0-9]{3}$;
			status=accepted (NonSupersededStatus, supersededBy ausente);
			date format válido; decisionClass/reversibility/blastRadius
			valores válidos dos enums; affectedArtifacts não-vazio (1
			path); derivedArtifacts presente (1 path); principlesApplied
			não-vazio (2 entries); todos os campos obrigatórios
			preenchidos. Pass.

			tq-adr-01 (alternativas com justificativa de rejeição):
			context descreve a alternativa rejeitada — rule como snippet
			CUE arbitrário embutido. Justificativa de rejeição:
			"transforma o schema em mini-DSL cuja semântica de execução
			não é decidível por inspection direta — runner futuro
			precisaria de motor de avaliação CUE genérico, e a fronteira
			entre determinístico e interpretativo passaria a depender
			de quem escreve cada snippet. Isso reintroduz, em forma
			mais sutil, exatamente o problema que adr-040 corrige".
			Pass.

			tq-adr-02 (metadata de risco reflete decisão): reversibility
			medium é defensável — schema novo é reversível sem custo de
			dados (nenhuma instância existe ainda), mas commit a contrato
			que primeiras instâncias vão consumir; mudar shape após
			instâncias existirem exige coordenação. Não é high (há
			propagação coordenada se shape mudar), não é low (nada
			persistido em SoT). blastRadius cross-cutting porque a v1
			condiciona como todos os tipos de artefato serão
			estruturalmente validados no futuro; não é local (define
			padrão para todo artifact-schemas/), não é repo-wide (não
			toca CI pipeline ainda). Pass.

			tq-adr-03 (paths em affectedArtifacts são reais): único
			path em affectedArtifacts (architecture/artifact-schemas/structural-check.cue)
			será criado como output direto desta decisão em commit
			imediato após esta ADR. Path em derivedArtifacts
			(architecture/structural-checks/canvas.cue) será criado em
			passo subsequente da sequência. Pass.
			"""
	}]

	findings: {}

	summary: """
		ADR-041 deriva de adr-040 e decide o shape concreto do
		schema structural-check v1: 8 campos, 3 kinds estritamente
		declarativos (required-block, reference-exists interno,
		same-artifact-consistency), rule como dado estruturado e
		não snippet CUE, sem severity (sempre fail). Mantém a v1
		deliberadamente conservadora para evitar reintroduzir
		mini-DSL. Cobre o caso real imediato (vc-cv-03 falso
		positivo sobre presença de bloco). Estável em 1 round —
		todos os 11 critérios passam após correção da contradição
		interna sobre reference-exists feita antes do drafting.
		"""

	singleRoundRationale: """
		ADR foi moldado por diálogo iterativo com founder antes
		do drafting. A versão preliminar continha contradição
		interna entre decision (reference-exists descrito como
		cross-artifact) e consequences (declarava cross-artifact
		fora da v1). Founder identificou a inconsistência na
		revisão de proposta e instruiu a restrição do
		reference-exists a referências internas ao mesmo
		artefato. Dois ajustes opcionais também recomendados
		(title mais seco, remoção de menção a P1 no context)
		foram aplicados. Os 3 ajustes foram aplicados antes
		desta avaliação. Critérios são objetivamente verificáveis
		por inspection direta — paths existem ou são output
		declarado, conformance a #ADR é checável por shape,
		alternativa rejeitada está documentada com justificativa
		explícita. Não houve ambiguidade pendente que exigisse
		round adicional para descobrir.
		"""
}
