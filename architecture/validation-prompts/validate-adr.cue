package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-adr": artifact_schemas.#ValidationPrompt & {
	id:    "vp-adr"
	title: "Validação semântica de Architecture Decision Records"

	matchPatterns: ["^architecture/adrs/adr-[0-9]{3}-[a-z0-9-]+\\.cue$"]

	appliesTo: ["adr"]

	references: [
		"architecture/artifact-schemas/adr.cue",
		"architecture/design-principles.cue",
		"domain/domain-definition.cue",
	]

	checks: [{
		id:         "vc-adr-01"
		question:   "O context descreve um problema concreto que motivou a decisão, ou é descrição abstrata de cenário?"
		lookFor:    "Context genérico que poderia aplicar-se a qualquer projeto. Ausência de trigger concreto ('observou-se que...', 'durante X, identificou-se...'). Descrição do tipo 'é importante ter X' sem explicar por que agora."
		outputMode: "pass-fail"
		severity:   "fail"
		rationale:  "ADR sem problema concreto é declaração de intenção, não registro de decisão. O valor está em capturar o porquê-agora."
	}, {
		id:         "vc-adr-02"
		question:   "O campo consequences é honesto sobre os trade-offs negativos, ou lista apenas benefícios?"
		lookFor:    "Consequences que mencionam apenas resultados positivos. Ausência de qualificadores como 'porém', 'limitação', 'custo'. Padrão: 'isso melhora X e resolve Y' sem mencionar o que piora ou o que não resolve."
		outputMode: "pass-fail"
		severity:   "fail"
		rationale:  "Consequences só-positivas indicam análise incompleta ou marketing interno. Toda decisão tem custo — omiti-lo impede avaliação futura de trade-offs."
	}, {
		id:         "vc-adr-03"
		question:   "A decisão descrita em decision resolve logicamente o problema descrito em context?"
		lookFor:    "Desconexão lógica: context descreve problema A mas decision resolve problema B. Decision que assume premissas não declaradas em context. Soluções que resolvem sintoma mas não causa raiz do problema descrito."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "Conexão context→decision é o núcleo lógico do ADR. Self-review pelo mesmo agente que escreveu sofre viés de coerência — perspectiva externa detecta gaps lógicos que o autor não percebe."
	}, {
		id:         "vc-adr-04"
		question:   "Os affectedArtifacts cobrem todos os artefatos materialmente afetados pela decisão?"
		lookFor:    "Artefatos mencionados em decision ou consequences que não aparecem em affectedArtifacts. Artefatos derivados que deveriam estar em derivedArtifacts mas foram omitidos. Paths que não existem no repo e não serão criados pela decisão."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "affectedArtifacts incompleto reduz rastreabilidade mas não invalida a decisão. warn porque o agente pode não conhecer todo o grafo de dependências."
	}]

	rationale: "ADRs são o registro de decisão do sistema. Validação semântica complementa o schema estrutural verificando qualidade do raciocínio: problema concreto, honestidade de trade-offs, conexão lógica context→decision, e completude de rastreabilidade."
}
