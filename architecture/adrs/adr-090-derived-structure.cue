package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr090: artifact_schemas.#ADR & {
	id:    "adr-090"
	title: "Estrutura derivada: eliminar duplicação config↔schemas que causa map-drift"
	date:  "2026-05-24"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Auditoria + 3 rodadas de simulação convergiram numa causa-raiz única: o
		config.cue AUTORA uma árvore estrutural (tree.entries; arquivos nomeados em
		conventions/prosa) que DUPLICA o conhecimento de localização que já vive
		canonicamente nas _schema.location de cada artifact-schema. Duas fontes da
		mesma informação divergem por construção — daí universal-glossary.cue e
		business-model.cue declarados-e-ausentes, ubiquitous-language.cue vs
		glossary.cue real, e agent-governance.cue global ausente.

		Alternativa considerada e REJEITADA: gates detectando a divergência
		(config-path-existence permanente). Simulada e reprovada — inunda de
		falso-positivo porque config.cue é aspiracional, e não pega phantoms
		sem-schema. Detectar um mapa mentiroso é inferior a fazer um mapa que não
		consegue mentir.
		"""

	decision: """
		Eliminar a duplicação na origem: config.cue deixa de afirmar fatos
		estruturais; a estrutura é DERIVADA. Nove componentes:

		(1) Derivação. A seção estrutural é gerada de _schema.location + scan do
		filesystem por scripts/ci/generate-structure-index.sh, materializada em
		governance/readme/structure-index.cue (consumida pelo config), registrada
		em derivedArtifacts e validada por derived-artifact-sync. config.cue mantém
		só narrativa/rationale, ancorada aos paths derivados.

		(2) Gerador = diff assimétrico por cardinalidade. Singletons: path literal
		→ checa presença (revela ausentes). Collections: classificação + órfãos.
		Auto-verifica que canonicalPathRegex de singleton é literal-âncora.

		(3) Exclusive-match: arquivo casando ≥2 schemas → ambíguo → reject
		(política fileClassification já declarada).

		(4) Ausentes sem veredito. Lista singletons ausentes; ANOTA "agendado
		WI-xxx" vs "não-contabilizado" lendo o wave-plan read-only e DEGRADÁVEL
		(inválido/ausente → "status desconhecido", nunca falha). Classificar
		drift-vs-planejado é juízo do founder (P10).

		(5) Infra. Reusa scope.excluded para "ignorar" + allowlist MÍNIMO e
		auto-checado-existe para os poucos paths não-schema MOSTRADOS (scripts/,
		.github/). Fundacionais sem schema (design-principles, shared-types) ganham
		schema via ADRs follow-on SEPARADOS.

		(6) Correção do gerador. Determinístico (pode ser gate, ≠ ten-006);
		implementa o algoritmo fileClassification JÁ declarado em repo-structure
		(sem lógica nova); golden-fixture SINTÉTICA MÍNIMA, atualizada só quando o
		algoritmo muda.

		(7) Narrativa anti-phantom. config proíbe path literal salvo (a) resolve no
		índice ou (b) plannedIn: WI-xxx — e plannedIn é VERIFICADO (o WI existe e
		tem o path em outputs[type=create]). Regex-determinístico; templates isentos.

		(8) Cutover one-shot. config-path-existence existe APENAS como ferramenta
		TRANSITÓRIA de diff durante a janela de cutover (config antigo × índice
		derivado), DESCOMISSIONADA após. Extração over-inclusive dos paths do config
		antigo; cada um deve estar no índice OU no wave-plan OU decidido-morto.
		Default: universal-glossary.cue e business-model.cue tratados como MORTOS
		(removidos do config autoral), salvo evidência explícita no wave-plan.

		(9) Gates retidos: sc-sg-01 singleton-coverage (trava de regressão, nasce
		verde); sc-wg-02 directory-pair-coverage (task-specs↔work-events).

		FORA DE ESCOPO (sequenciados depois, não misturados): criação do
		agent-governance.cue global (o índice derivado o SURFACE como ausente — o
		correto); integridade de referência cross-file (def-002); drift semântico
		(P10); plan-coherence completo.
		"""

	consequences: """
		Positivas: (1) o mapa não consegue mentir sobre estrutura schema-governada,
		por construção; (2) a primeira regeneração AUTO-CORRIGE o mapa — conserto e
		detector ao mesmo tempo; (3) P0-puro (remove a duplicação-raiz); (4)
		substitui 3 mecanismos de detecção por 1 derivação + 1 gerador.

		Negativas: (1) superfície nova concentrada em gerador + allowlist mínimo +
		fixture, contida por determinismo + lógica-já-declarada + golden-test; (2)
		cutover tem sequência estrita; (3) acoplamento SOFT (degradável) ao
		wave-plan; (4) órfão→reject só DEPOIS de schematizar fundacionais — antes,
		bloquearia arquivos legítimos (governado por def-018); (5) exige ADRs
		follow-on para os fundacionais.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"governance/repo-structure.cue",
		"governance/readme/config.cue",
		"architecture/artifact-schemas/structural-check.cue",
	]
	plannedOutputs: [
		"scripts/ci/generate-structure-index.sh",
		"architecture/structural-checks/singleton-coverage.cue",
		"architecture/structural-checks/work-event-task-spec-pairing.cue",
		"architecture/deferred-decisions/def-018-promote-orphan-detection-to-reject.cue",
	]
	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo:          ["def-018"]
	principlesApplied: ["P0", "P10", "P12"]

	rationale: """
		Responde às 3 simulações documentadas (par evidência→decisão, como
		ten-006→adr-040): cada falha simulada tem componente correspondente. P0 é
		central — o map-drift era duplicação config↔schemas; derivar a remove. P10:
		gateia só o decidível (estrutura); referência cross-file (def-002) e
		semântica ficam advisory. P12: gerador determinístico + derived-artifact-sync.

		decisionClass structural (altera contrato de validação, estrutura do config,
		e schema #StructuralCheck — kind singleton-coverage); não foundational
		(P0–P12 intactos; isto os APLICA). reversibility medium; blastRadius
		cross-cutting.

		def-018 governa a promoção de órfão→reject com DUPLA condição: fundacionais
		schematizados E orphan-findings==0 — senão bloqueia arquivos legítimos.

		SEQUÊNCIA DE CUTOVER: (i) ADRs follow-on schematizam fundacionais; (ii)
		D2/D3 — remover universal-glossary/business-model do config (mortos por
		default) salvo evidência no wave-plan; (iii) construir + golden-testar
		gerador; (iv) cutover (config-path-existence transitório); (v) virar config
		p/ derivado; (vi) crescer whitelist sc-sg-01. agent-governance global e
		órfão→reject vêm DEPOIS, fora desta decisão.
		"""
}
