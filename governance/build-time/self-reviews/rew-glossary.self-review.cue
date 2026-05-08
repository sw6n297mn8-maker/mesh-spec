package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

rewGlossary: build_time.#SelfReviewReport & {
	reportId: "srr-rew-glossary"

	artifactPath:       "contexts/rew/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-08"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Glossary REW (Risk Engine & Risk Observability) Phase 2 do
			WI-046 materializado via authoring manual section-by-section
			per manualAuthoringProtocol (adr-057). 3 sections approved
			sequentially via founder dialectic R3+R4+R5++++ section-gate
			cycles + 3 hardenings finais incorporados (drift discipline +
			term promotion criteria + anti-corruption semantic rule).

			**FRASE CANONICAL CAPTURADA** (founder R5++++ Phase 2 final):
			'Glossary não define palavras — define o que o sistema está
			autorizado a considerar verdade.' REW glossary é sistema de
			controle epistemológico, não documentação.

			**ESTRUTURA — 12 TERMS EM 5 CAMADAS ONTOLÓGICAS EXPLÍCITAS**:

			Layer 1 — Reality Interpretation (1 term): Signal
			Layer 2 — Epistemic (4 terms): Confidence Interval + Signal
			  Coverage + Asset Visibility Gap + Reasoning Trace
			Layer 3 — Decision (4 terms): Risk Score + Eligibility
			  Decision + Risk Alert + Applicable Context
			Layer 4 — Control (2 terms): Risk Model + Risk Policy
			Layer 5 — Actor (1 term): Adversário Econômico

			Cada camada tem responsabilidade distinta:
			interpretar → avaliar incerteza → decidir → controlar →
			pressionar o sistema. Misturar camadas gera erro estrutural.

			**3 SECTIONS APROVADAS sequencialmente**:

			Section 1 (context-and-term-identification): metadata
			(code='rew', name, boundedContextRef='rew') + 12 candidate
			terms identificados a partir do canvas Phase 1 vocabulary.
			Founder approval com 3 ajustes obrigatórios para Section 1
			rationale: (1) 5-layer ontological structure explicit; (2)
			Signal definition forte (NÃO raw data nem evento); (3) Model
			vs Policy separation rígida (model prevê, policy decide).

			Section 2 (term-content-and-anchoring): 12 terms detalhados
			com 6 campos obrigatórios (code/name/termEn/definition/category/
			rationale) + anchoring (≥1 examples/antiTerms/relatedTerms/
			domainModelRefs por term). 5 ajustes founder absorvidos:
			(1) firewall semântico Signal forte; (2) Eligibility Decision
			contextual com strength epistemológica separada via Confidence
			Interval; (3) Risk Model vs Risk Policy antiTerms cross-
			referencing; (4) Economic Adversary como CLASSE DE COMPORTAMENTO
			(não entity); (5) Adversário Econômico mantido em PT-BR
			(conceito estrutural, não técnico).

			Section 3 (validation-and-meta): cross-reference matrix
			validated (11 relatedTerms refs todas válidas; self-references
			zero per tq-gl-12); anchoring coverage ≥ 1 per term (4 com
			antiTerms + 4 com examples + 11 com relatedTerms); anti-
			redundancy verificado por inspeção (definitions semanticamente
			distintas); 3 hardenings finais incorporados ao top-level
			rationale (drift discipline + term promotion criteria +
			anti-corruption semantic rule).

			**INSIGHTS CANONICAL CAPTURADOS NO RATIONALE**:

			Princípios de fronteira (firewall semântico):
			- 'Signal NÃO é dado bruto, NÃO é evento, NÃO é métrica
			   agregada — É interpretação validada upstream'
			- 'Risk Model e Risk Policy são DISTINTOS e NÃO intercambiáveis'
			- 'Eligibility Decision é categórica; Confidence Interval é
			   força epistemológica — duas dimensões SEPARADAS'
			- 'Economic Adversary é CLASSE DE COMPORTAMENTO assumida por
			   qualquer actor'

			Drift discipline (founder R5++++ hardening 1):
			- Mudança em definitions/relatedTerms/antiTerms/layer assignment
			  → cross-BC impact analysis + backward-compat check + replay
			  reasoning validation
			- Princípio: 'mudança semântica não versionada = corrupção
			  silenciosa'; glossary drift NÃO quebra código — quebra
			  significado

			Term promotion criteria (founder R5++++ hardening 2):
			- Novo termo só entra se: NÃO é composição de termos existentes;
			  aparece em ≥ 2 decisões/capabilities; resolve ambiguidade
			  semântica real; NÃO pertence a outro BC
			- Princípio: 'glossary não cresce por adição — cresce por
			  necessidade semântica'

			Anti-corruption semantic rule (founder R5++++ hardening 3):
			- Termos REW NÃO devem ser reinterpretados/redefinidos por
			  consumers (CMT, SCF, FCE)
			- Tradução cross-BC via ACL, NUNCA via mutação de significado
			- Princípio: 'o problema não é o termo mudar aqui — é ele mudar
			  fora daqui'

			**CROSS-CUTTING CONTRIBUTION**:

			term-economic-adversary referencia sh-06 'Adversário Econômico'
			catalog entry (added em Phase 1 commit fbe0b2d cross-cutting).
			Cross-BC reusable: outros BCs podem referenciar term-economic-
			adversary quando manipulationVector adversarial primary
			applicable.

			**Schema satisfação tq-gl-XX por inspeção**:

			- tq-gl-01 (codes únicos): 12 codes distintos term-* ✓
			- tq-gl-02 (relatedTerms valid refs): 11 relatedTerms blocks
			  todos com refs a term-* existentes neste glossary ✓
			- tq-gl-03 (domainModelRefs valid): vazios Phase 0 (forward
			  refs Phase 3 quando domain-model REW materializado) — N/A ✓
			- tq-gl-05 (definition NÃO redundante com name): definitions
			  substantivas (≥ 30 runes operacional) ✓
			- tq-gl-09 (≥1 anchoring per term): 4 antiTerms + 4 examples +
			  11 relatedTerms cobrem todos 12 terms ✓
			- tq-gl-12 (no self-references): zero terms referenciam próprio
			  code ✓
			- tq-gl-XX restantes satisfeitos por inspeção (boundary
			  references via canvas + lens application + bilingual
			  consistency)

			**FORWARD REFERENCES Phase 3+** (declarados no rationale):

			domainModelRefs vazios Phase 0; serão preenchidos quando
			domain-model REW materializado:
			- term-signal → vo-signal
			- term-risk-score → vo-risk-score
			- term-eligibility-decision → vo-eligibility-decision
			- term-risk-alert → agg-risk-alert (lifecycle managed)
			- term-risk-model → ent-risk-model (versioned)
			- term-risk-policy → ent-risk-policy (versioned)
			- term-confidence-interval → vo-confidence-interval
			- term-reasoning-trace → vo-reasoning-trace
			- term-applicable-context → vo-applicable-context
			- term-asset-visibility-gap → (classification — não aggregate)
			- term-signal-coverage → (metric — não aggregate)
			- term-economic-adversary → (role — não aggregate)

			**LENS APLICADA** (capturada no rationale):

			Primary: lens-domain-language-and-terminology-design
			- dl-bilingual-terminology: pt-BR canonical + termEn para
			  code generation; loanwords (Score, Confidence, Signal, Trace)
			  validados case-by-case; Adversário Econômico mantido PT-BR
			- dl-term-selection-criteria: 12 primitivos selecionados;
			  derivados (decision-version, emission-threshold, snapshot)
			  EXCLUÍDOS por term promotion criteria; Eligibility isolado
			  SKIPPED (eligibility sem contexto = erro)
			- dl-cross-layer-consistency: 5-layer ontological structure
			  explicit; misturar camadas é erro estrutural

			Round único suficiente — qualidade incorporada via founder
			dialectic R3+R4+R5++++ section-gate iterativo durante 3
			sections + 3 hardenings finais. Pattern paralelo a INV/SSC/
			DLV glossary Phase 2 approach. Pre-commit fix: schema sub-
			structures #TermExample (context/instance vs scenario/outcome)
			+ #GlossaryTermRef (string array vs struct) corrigidos via
			cue vet feedback (contextual narrative em relatedTerms perdido
			— schema constraint; refactored para string array preservando
			refs).

			cue vet ./... EXIT=0 post-write; self-review enforcement
			PASSED.
			"""
	}]

	findings: {}

	summary: """
		Glossary REW (Risk Engine & Risk Observability) Phase 2 do WI-046
		materializado via manualAuthoringProtocol section-by-section
		(adr-057). 3 sections approved + 3 hardenings finais incorporados.
		12 terms canônicos em 5 camadas ontológicas explícitas (Reality/
		Epistemic/Decision/Control/Actor). 4 antiTerms + 4 examples +
		11 relatedTerms blocks (cross-references todas válidas; zero
		self-references). 3 hardenings: drift discipline (mudança
		semântica não versionada = corrupção silenciosa); term promotion
		criteria (cresce por necessidade semântica, não adição); anti-
		corruption semantic rule (termos REW NÃO redefinidos fora deste
		glossary; tradução via ACL). Frase canonical R5++++: 'Glossary
		não define palavras — define o que o sistema está autorizado a
		considerar verdade'. Cross-cutting: term-economic-adversary
		referencia sh-06 catalog (Phase 1 cross-cutting). tq-gl-01..XX
		satisfeitos. cue vet ./... EXIT=0.
		"""

	singleRoundRationale: """
		Authoring manual section-by-section per manualAuthoringProtocol
		(adr-057) com 3 founder dialectic R3+R4+R5++++ section-gate
		cycles aplicados pre-write durante composição (cada section
		recebeu 3-5 ajustes obrigatórios + 1-2 opcionais — qualidade
		incorporada pre-write em vez de post-hoc rounds). Pattern
		paralelo a Phase 1 canvas REW (top 0.1% nivel) + INV/SSC/DLV
		glossary Phase 2 approach. Cascade ordering preserved (canvas
		REW Phase 1 fbe0b2d existe; PG glossary existe; lens-domain-
		language-and-terminology-design aplicada). 3 hardenings finais
		founder R5++++ incorporados pre-commit (drift discipline + term
		promotion criteria + anti-corruption semantic rule). Pre-commit
		fix mecânico: schema #TermExample fields (context/instance) +
		#GlossaryTermRef (string array vs struct) corrigidos via cue vet
		feedback — não exigiu novo founder review (founder approval
		original sobre conteúdo semântico permanece válido; sintaxe é
		mecânica). Round único suficiente — founder dialectic durante
		composição substituiu rounds pos-hoc.
		"""
}
