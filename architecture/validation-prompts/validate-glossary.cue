package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-glossary": artifact_schemas.#ValidationPrompt & {
	id:    "vp-glossary"
	title: "Validação semântica de Ubiquitous Language Glossary"

	matchPatterns: ["^contexts/[a-z][a-z0-9-]*/glossary\\.cue$"]

	appliesTo: ["glossary"]

	references: [
		"architecture/artifact-schemas/glossary.cue",
		"architecture/design-principles.cue",
		"domain/domain-definition.cue",
		"strategic/context-map.cue",
	]

	checks: [{
		id:       "vc-gl-01"
		question: "As definições são operacionalmente precisas o suficiente para orientar naming, modeling e boundary decisions por agentes, ou são descrições enciclopédicas que não distinguem conceitos próximos?"
		lookFor:  "Definições que descrevem o conceito em abstrato sem delimitar fronteira operacional. Teste: dois termos do mesmo glossário cujas definições, se trocadas, ainda fariam sentido — indica que a definição não ancora o conceito no contexto específico do BC. Definições que começam com 'é um tipo de...' ou 'refere-se a...' sem dizer o que distingue este conceito dos adjacentes."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "tq-gl-05 verifica redundância definition↔name. Este check avalia precisão operacional — a definição serve como spec para orientar decisões de agentes? Imprecisão propaga para naming de classes, campos e boundaries."
	}, {
		id:       "vc-gl-02"
		question: "Os termos cobrem os conceitos centrais do domain model, ou há building blocks importantes sem representação no glossário?"
		lookFor:  "Aggregates, value objects significativos ou invariants centrais do domain model sem nenhum termo correspondente no glossário. Conceitos que aparecem em descriptions de commands/events do domain model mas não existem como termos. Teste: ler o domain model do mesmo BC e identificar conceitos de domínio que um novo membro da equipe precisaria entender mas não encontraria no glossário."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "tq-gl-04 verifica cobertura de aggregates via domainModelRefs. Este check avalia cobertura conceitual mais ampla — value objects, invariants e conceitos implícitos no domain model que merecem entrada no glossário. Validador precisa do domain model como referência."
	}, {
		id:       "vc-gl-03"
		question: "Os anti-termos capturam confusões reais que ocorreriam no domínio da Mesh, ou são distinções acadêmicas que ninguém confundiria na prática?"
		lookFor:  "Anti-termos que distinguem conceitos de domínios completamente diferentes (e.g., 'não confundir com X' onde X nunca apareceria em conversas sobre este BC). Anti-termos ausentes para homônimos entre BCs adjacentes — usar o context-map para identificar BCs vizinhos e verificar se termos compartilhados têm anti-termos cruzados. Quando glossários adjacentes existirem, comparar diretamente; quando não existirem, inferir a partir dos nomes de BCs e termos visíveis no context-map."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "tq-gl-06 verifica que anti-termos não repetem termos do glossário. Este check avalia utilidade prática — anti-termos servem para prevenir confusão real entre agentes operando em BCs adjacentes."
	}, {
		id:       "vc-gl-04"
		question: "O termEn produzirá naming de código claro e não-ambíguo, ou gerará colisões semânticas com vocabulário técnico genérico ou com termos de outros BCs?"
		lookFor:  "termEn que é palavra genérica demais (e.g., 'Status', 'Record', 'Entry') sem qualificador que ancore no BC. termEn que colide com termos técnicos de frameworks ou linguagens (e.g., 'Event', 'Action', 'Model'). termEn que, usado como nome de classe, seria indistinguível de classe de outro BC sem namespace. Quando glossários de BCs adjacentes (via context-map) existirem, comparar para detectar colisões; quando não existirem, avaliar risco de colisão com base nos nomes e domínios dos BCs vizinhos."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "tq-gl-11 valida adequação semântica e tq-gl-12 unicidade intra-glossário. Este check avalia colisão cross-BC e cross-layer — um termEn que é único neste glossário mas gera ambiguidade quando código é gerado no contexto da Mesh como um todo."
	}]

	rationale: "Glossário é a fonte de verdade da Ubiquitous Language consumida por agentes para naming, modeling e disambiguação. Validação semântica cobre o que quality criteria estruturais não alcançam: precisão operacional das definições (vs. descrições genéricas), cobertura conceitual além de aggregates (vs. apenas domainModelRefs), utilidade prática de anti-termos (vs. apenas não-repetição), e qualidade de termEn para code generation cross-BC (vs. apenas unicidade intra-glossário)."
}
