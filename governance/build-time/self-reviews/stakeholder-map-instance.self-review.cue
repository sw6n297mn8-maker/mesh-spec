package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

stakeholderMapInstanceSelfReview: build_time.#SelfReviewReport & {
	reportId: "srr-stakeholder-map-instance"

	artifactPath:       "domain/stakeholder-map.cue"
	artifactSchemaPath: "architecture/artifact-schemas/stakeholder-map.cue"
	artifactType:       "stakeholder-map"

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
		infoCount: 1
		summary: """
			Instância domain/stakeholder-map.cue modificada em commit fbe0b2d (REW Phase 1 canvas WI-046) — adição de sh-06 'Adversário econômico' como stakeholder canonical cross-BC.

			MUDANÇA APLICADA: 1 entry adicionada ao stakeholders[] array (sh-06). Demais 5 entries (sh-01..sh-05) inalteradas. Schema fields preenchidos seguindo V0 instance pattern existente: code + name + type + description + role + meshInteraction + influence + concerns + interactsWith + rationale.

			JUSTIFICATIVA CANONICAL (founder R5++++ directive em REW Section 6 dialectic): 'Sem modelagem explícita de adversário, sistemas implicitamente assumem que ele não existe — vetor estrutural de cego'. R4+++ modelagem em INV Round 2 SRR demonstrou empiricamente que adversários compostos satisfazem mecanismos legítimos simultaneamente. Adversário como sh-06 canonical permite que BCs declarem manipulationVector + designResponse com identidade adversarial primária — não derivada de stakeholders legítimos.

			TYPE='actor-class' INTRODUZIDO: campo type estendido com valor novo (existing values: organization, regulator, agent). 'actor-class' representa CLASSE de actor (não actor individual nem organização específica) — semantically apropriado para adversário canonical. Schema instance NÃO é constrained pelo schema artifact_schemas (different package; cue vet não unifica) — não enforcement issue.

			CROSS-CUTTING IMPACT: REW canvas (contexts/rew/canvas.cue) é primeiro consumer (Section 6 stakeholders array + incentiveAnalysis participants). Outros BCs futuros podem retroativamente referenciar sh-06 quando manipulationVector adversarial primary applicable. Pattern paralelo a outros sh-NN canonical refs.

			[INFO infoCount=1] V0/V1 SCHEMA DRIFT EXISTENTE: Instance `domain/stakeholder-map.cue` está em V0 (legacy schema fields: type/role/meshInteraction/influence/concerns/interactsWith/rationale). Schema V1 em `architecture/artifact-schemas/stakeholder-map.cue` evoluiu (category/platformRelationships/interests/painPoints/incentiveProfile.manipulationVectors). Instance NÃO migrado para V1 — é dívida técnica pre-existente (não introduzida por sh-06 addition). Migração V0→V1 é WI separado fora do scope desta SRR. cue vet não detecta drift porque instance package=domain (não unificado com schema package=artifact_schemas).

			VALIDATIONS POST-CHANGE:
			- cue vet ./... EXIT=0 (instance permanece structurally valid)
			- check-self-review.sh: missing SRR detected (resolved por esta SRR)
			- Cross-canvas integrity: REW canvas Section 6 stakeholders array references sh-06 — mutual dependency satisfied no mesmo commit (fbe0b2d)
			- Stakeholder-map contém 6 entries unique codes (sh-01..sh-06) — tq-sm-01 satisfeito por inspeção

			SCHEMA SATISFACTION POR INSPEÇÃO:
			- code 'sh-06' regex match ^sh-[0-9]{2}$ (canonical pattern) ✓
			- name non-empty + descritivo ✓
			- description ≥ 50 runes substantivo ✓
			- rationale articula valor da addition + cross-BC reusability ✓
			- interactsWith refs válidos (sh-01, sh-02, sh-05 todos existentes) ✓
			- concerns 3 entries non-empty ✓

			PHASE 0 LIMITATIONS HONEST:
			- V0/V1 schema drift permanece pre-existing technical debt (não bloqueia sh-06 addition)
			- type='actor-class' não está em V0 type enum se houver enforcement futuro (currently no enforcement)
			- Adversarial dimension restricted ao stakeholder-map V0 fields (não usa V1 incentiveProfile.manipulationVectors structure que seria mais expressivo)

			Round único suficiente — change escopo limitado (1 entry adicionada); founder directive R5++++ pre-write durante REW Phase 1 dialectic substituiu rounds adversariais pos-hoc.
			"""
	}]

	findings: {}

	summary: """
		Instance domain/stakeholder-map.cue modificada em commit fbe0b2d (REW Phase 1 canvas WI-046) — sh-06 'Adversário econômico' adicionado como stakeholder canonical cross-BC. 1 entry adicionada (5→6 stakeholders); demais entries inalteradas. type='actor-class' introduz nova valor (V0 instance pattern preserved; schema package separation impede enforcement). Justificativa: founder R5++++ directive 'sem modelagem explícita de adversário, sistemas implicitamente assumem que ele não existe'. R4+++ patterns são intent primary para sh-06 (vs desvio comportamental para sh-01/sh-02). Cross-cutting impact: REW canvas é primeiro consumer; outros BCs reusable. V0/V1 schema drift pre-existing (out of scope). cue vet ./... EXIT=0. Round único; founder dialectic pre-write substituiu rounds pos-hoc.
		"""

	singleRoundRationale: """
		SRR criada para resolver CI gate failure detectado em commit fbe0b2d (self-review-check identificou domain/stakeholder-map.cue modificado sem SRR correspondente — existing srr-stakeholder-map-schema é para architecture/artifact-schemas/stakeholder-map.cue, NÃO para a instance). Instância e schema têm SRRs separados por convention (artifactPath distinto; artifactType distinto). Round único suficiente — change escopo limitado a 1 entry adicionada; qualidade incorporada via founder R5++++ directive durante REW canvas Phase 1 dialectic Section 6 (sh-06 modelado canonical com manipulationVector + designResponse + incentiveAnalysis participant entries em REW canvas + cross-BC reusability rationale). Pattern paralelo a fix anteriores 5b4b271 (srr-def-015 missing) — lesson canonical: novos artifacts/instances modificados sempre exigem co-commit SRR.
		"""
}
