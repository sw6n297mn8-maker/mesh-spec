package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-artifact-schema": artifact_schemas.#ValidationPrompt & {
	id:    "vp-artifact-schema"
	title: "Validação semântica de Artifact Schemas"

	matchPatterns: ["^architecture/artifact-schemas/[a-z0-9-]+\\.cue$"]

	appliesTo: ["artifact-schema"]

	references: [
		"architecture/artifact-schemas/artifact-schema.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/design-principles.cue",
	]

	checks: [{
		id:         "vc-as-01"
		question:   "O schema captura a estrutura essencial do tipo sem ser excessivamente prescritivo nem excessivamente permissivo?"
		lookFor:    "Campos obrigatórios que deveriam ser opcionais (over-specification). Campos com tipo 'string' onde um enum ou regex seria mais preciso (under-specification). Campos que replicam informação disponível via referência a outro artefato."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "Schema over-specified impede evolução legítima. Schema under-specified permite instâncias semanticamente inválidas. O equilíbrio depende do estágio de maturidade do tipo."
	}, {
		id:         "vc-as-02"
		question:   "Os quality criteria em _qualityCriteria cobrem os riscos específicos do tipo de artefato?"
		lookFor:    "Critérios genéricos que se aplicariam a qualquer tipo (já cobertos por universalCriteria). Ausência de critérios para os aspectos mais críticos do tipo — aqueles cuja falha causaria mais dano. Critérios aspiracionais que não podem ser avaliados objetivamente."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "Quality criteria são o contrato entre o schema e o self-review. Critérios genéricos ou incompletos tornam self-review ineficaz para o tipo."
	}, {
		id:         "vc-as-03"
		question:   "O _schema.location é consistente com onde instâncias realmente existem ou devem existir no repositório?"
		lookFor:    "canonicalPathRegex que não faz match com instâncias existentes do tipo. fileNameRegex incompatível com convenções de nomenclatura observadas. cardinality que não reflete a realidade (e.g., 'singleton' para tipo com múltiplas instâncias)."
		outputMode: "pass-fail"
		severity:   "fail"
		rationale:  "Location incorreto torna instâncias invisíveis para CI e hook de validação — quebrando tanto a governança estrutural quanto a automação de validation prompts."
	}, {
		id:         "vc-as-04"
		question:   "O schema permite evolução razoável do tipo sem breaking changes, ou mudanças futuras previsíveis exigiriam reescrever o schema?"
		lookFor:    "Campos com tipo fechado (enum) onde valores futuros são previsíveis mas não acomodáveis sem alterar o schema. Ausência de campos opcionais para extensões naturais do tipo. Constraints excessivamente rígidos em campos que poderão relaxar (e.g., regex muito restritivo para IDs). Inversamente: schema tão aberto que qualquer mudança é backward-compatible por vacuidade."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "Schema que exige breaking change para evolução previsível cria custo desproporcional. Perspectiva externa detecta rigidez que o autor não percebe porque está focado no estado atual."
	}]

	rationale: "Artifact schemas governam todos os outros artefatos do repositório. Validação semântica verifica o que cue vet não consegue: equilíbrio de especificidade, cobertura de quality criteria, accuracy de location, e preparação para evolução futura."
}
