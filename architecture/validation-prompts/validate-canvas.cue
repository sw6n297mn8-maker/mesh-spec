package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-canvas": artifact_schemas.#ValidationPrompt & {
	id:    "vp-canvas"
	title: "Validação semântica de Bounded Context Canvas"

	matchPatterns: ["^contexts/[a-z][a-z0-9-]*/canvas\\.cue$"]

	appliesTo: ["canvas"]

	references: [
		"architecture/artifact-schemas/canvas.cue",
		"architecture/design-principles.cue",
		"domain/domain-definition.cue",
		"strategic/context-map.cue",
	]

	checks: [{
		id:       "vc-cv-01"
		question: "O purpose cria um contorno genuinamente separado dos BCs vizinhos, ou a responsabilidade declarada é reivindicável por outro BC?"
		lookFor:  "Purpose que descreve funcionalidade exercida por outro BC no context map. Responsabilidades que se sobrepõem com BCs adjacentes sem que o canvas explique por que a fronteira está aqui e não lá. Teste: substituir o nome do BC no purpose — se o texto ainda faz sentido para outro BC, o contorno está fraco."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "tq-cv-01 verifica presença e intenção de justificativa. Este check avalia se a justificativa é efetiva — o validador precisa do context map e domain-definition como referência para comparar responsabilidades entre BCs."
	}, {
		id:       "vc-cv-02"
		question: "A análise de incentivos é genuinamente adversarial ou otimista? Os vetores de manipulação são os que um participante real tentaria?"
		lookFor:  "Vetores de manipulação óbvios ausentes — especialmente manipulação por conluio, manipulação por timing (front-running), ou manipulação por omissão. manipulationCost que depende de boa-fé em vez de enforcement arquitetural. vsBenefit que compara custo de manipulação com benefício trivial quando o benefício real é substancial. Ausência de análise para participantes com poder assimétrico (e.g., operador da plataforma)."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "dp-08 exige que custos de manipulação excedam benefícios por design — não por apelo moral. tq-cv-03 verifica presença estrutural; este check avalia se a análise é honesta. Viés do autor: quem projetou o incentivo tende a acreditar que ele funciona."
	}, {
		id:       "vc-cv-03"
		question: "O padrão de comunicação inbound/outbound é coerente com o domain role declarado e a posição do BC na topologia?"
		lookFor:  "BC com archetype 'execution' que não recebe commands. BC com archetype 'gateway' que não tem integrações outbound. Canais declarados que não aparecem em nenhum relationship do context map. Canais ausentes que seriam esperados dado o papel do BC na topologia (e.g., BC que consome eventos mas nunca publica reações). Desproporção entre volume de inbound e outbound sem justificativa."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "tq-cv-06 valida coerência flags↔entries. tq-cv-12 valida que refs existem no context map. Este check avalia o padrão como um todo: o BC se comunica de forma consistente com o papel que diz ter? Perspectiva externa detecta gaps que quem modelou o BC naturaliza."
	}, {
		id:       "vc-cv-04"
		question: "As business decisions são decisões reais com trade-offs concretos, ou são afirmações de intenção disfarçadas de decisão?"
		lookFor:  "Decisões sem alternativa rejeitada implícita — se não havia escolha, não é decisão. Consequences que listam apenas benefícios sem custos ou riscos aceitos. Decisões que repetem o purpose em vez de registrar um trade-off específico. Decisões técnicas que deveriam viver no ACC ou em ADRs, não no canvas de negócio."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "Business decisions são o registro de trade-offs do BC. Decisão sem alternativa rejeitada é política, não escolha arquitetural. Decisão técnica no canvas viola a fronteira canvas↔ACC."
	}, {
		id:       "vc-cv-05"
		question: "O governance scope é proporcional ao risco operacional do BC? Decisões autônomas incluem ações cujo erro seria irreversível ou financeiramente significativo?"
		lookFor:  "Decisões em autonomousDecisions que envolvem mutação de estado financeiro, obrigações jurídicas ou dados regulados — estas deveriam ser supervisedDecisions ou ter escalation criteria explícito. Ausência de escalation criteria para cenários de falha não-triviais. supervisedDecisions que são triviais demais para justificar supervisão humana (over-governance). Governance scope que não referencia o agent-governance envelope quando este existir."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "P10 exige que agentes nunca executem operações financeiras sem gate. Governance scope no canvas é a primeira declaração de boundaries — se está desbalanceada aqui, o agent-governance envelope herda o desbalanceio."
	}]

	rationale: "Canvas é o documento raiz de cada BC — erros semânticos aqui propagam para todos os artefatos downstream. Validação cobre o que quality criteria estruturais não alcançam: genuinidade do contorno (vs. context map), qualidade adversarial da análise de incentivos (dp-08), coerência do padrão de comunicação com o role declarado, substância das business decisions, e proporcionalidade do governance scope ao risco operacional."
}
