package agent_instructions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// Mapa de templates de execução de tarefas.
// Chave = template ID. Constraint [ID=string]: ... & {id: ID}
// garante que chave e campo id nunca divergem.
templates: [ID=string]: artifact_schemas.#TaskTemplate & {id: ID}

// ════════════════════════════════════════════════════════════
// tmpl-create-schema
// ════════════════════════════════════════════════════════════

templates: "tmpl-create-schema": {
	version:       1
	kind:          "create-schema"
	title:         "Criar artifact schema"
	applicability: "Tarefas que produzem um novo schema #Type em architecture/artifact-schemas/."
	rationale:     "Schemas são contratos estruturais. Erros propagam para todas as instâncias. Protocolo garante consistência com design-principles e schemas existentes."

	preReads: [{
		target:     "architecture/design-principles.cue"
		targetType: "path"
		rationale:  "Princípios informam decisões de modelagem (P0: SoTs, P1: schema-first, P6: idempotência)."
	}, {
		target:     "architecture/artifact-schemas/*.cue"
		targetType: "glob"
		rationale:  "Schemas existentes definem padrão de estilo: _schema.location, rationale obrigatório, patterns de constraints."
	}, {
		target:     "governance/bounded-context-completeness.cue"
		targetType: "path"
		condition:  "if-applicable"
		rationale:  "Ler se o schema afeta artefatos de BC, para entender quais conditions de completude dependem de seus campos."
	}]

	steps: [{
		action:    "Identificar o tipo de artefato e onde suas instâncias vivem (path pattern, cardinality, nesting)."
		rationale: "Localização é parte do schema (_schema.location). Definir antes de modelar campos evita retrabalho."
	}, {
		action:    "Listar os campos obrigatórios a partir do contexto de uso: quem consome este artefato e o que precisa dele."
		rationale: "Schema derivado de consumidores, não de estrutura abstrata. Campos sem consumidor são especulação."
	}, {
		action:    "Propor o schema completo no chat com rationale por campo."
		rationale: "Founder valida semântica antes de materialização. Ciclo proposta→aprovação do CLAUDE.md."
	}, {
		action:    "Após aprovação, escrever o arquivo e rodar cue vet."
		rationale: "Validação sintática obrigatória antes de commit."
	}, {
		action:    "Se existirem instâncias pré-existentes, validar retrocompatibilidade com cue vet contra elas."
		rationale: "Schema novo não pode invalidar artefatos já commitados (bootstrapping exception: WI-004)."
	}]

	qualityGates: [{
		gate:      "cue vet passa sem erros"
		rationale: "CUE sintaticamente inválido nunca é commitado."
	}, {
		gate:      "Schema inclui _schema.location com canonicalPathRegex"
		rationale: "CI usa location para file classification. Schema sem location é invisível ao CI."
	}, {
		gate:      "Todo campo carrega rationale"
		rationale: "Regra do CLAUDE.md: artefato sem rationale onde schema exige = incompleto."
	}, {
		gate:      "Instâncias pré-existentes (se houver) passam cue vet contra o novo schema"
		rationale: "Retrocompatibilidade verificada, não assumida."
	}]
}

// ════════════════════════════════════════════════════════════
// tmpl-validate-artifact
// ════════════════════════════════════════════════════════════

templates: "tmpl-validate-artifact": {
	version:       1
	kind:          "validate-artifact"
	title:         "Validar artefato existente contra schema"
	applicability: "Tarefas cujo output type é 'validate'. Artefato já existe; objetivo é verificar conformidade e completude."
	rationale:     "Artefatos criados antes dos schemas podem ter divergências. Validação explícita fecha o gap entre intenção e conformidade."

	preReads: [{
		target:     "outputs[0].artifact"
		targetType: "derived-from-task-output"
		rationale:  "Artefato alvo da validação. Path resolvido em runtime a partir da TaskSpec."
	}, {
		target:     "architecture/artifact-schemas/*.cue"
		targetType: "glob"
		rationale:  "Schema correspondente ao tipo do artefato. Referência normativa para validação."
	}, {
		target:     "architecture/design-principles.cue"
		targetType: "path"
		rationale:  "Princípios informam se gaps são erros de conformidade ou tensões legítimas."
	}]

	steps: [{
		action:    "Rodar cue vet do artefato contra o schema. Registrar erros sintáticos."
		rationale: "Validação mecânica primeiro. Erros estruturais são objetivos e não requerem julgamento."
	}, {
		action:    "Para cada erro, classificar: (a) fix mecânico (campo faltando, tipo errado) ou (b) decisão semântica (campo presente mas significado diverge)."
		rationale: "Fixes mecânicos o agente corrige diretamente; decisões semânticas requerem proposta ao founder."
	}, {
		action:    "Aplicar fixes mecânicos. Propor decisões semânticas no chat com contexto suficiente para o founder decidir."
		rationale: "Separar automação de decisão. Agente não decide semântica sozinho."
	}, {
		action:    "Verificar completude: todos os campos required pelo schema estão preenchidos com conteúdo significativo (não placeholders)."
		rationale: "Campo presente mas vazio ou genérico é incompleto, não conforme."
	}, {
		action:    "Rodar cue vet final após todas as correções."
		rationale: "Validação de regressão: fixes não introduziram novos erros."
	}]

	qualityGates: [{
		gate:      "cue vet passa sem erros após correções"
		rationale: "Conformidade estrutural verificada."
	}, {
		gate:      "Nenhum campo required está vazio ou com conteúdo placeholder"
		rationale: "Completude semântica além da conformidade sintática."
	}, {
		gate:      "Decisões semânticas aprovadas pelo founder ou registradas como tensão"
		rationale: "Divergências não são ignoradas silenciosamente."
	}]
}

// ════════════════════════════════════════════════════════════
// tmpl-create-instance
// ════════════════════════════════════════════════════════════

templates: "tmpl-create-instance": {
	version:       1
	kind:          "create-instance"
	title:         "Criar instância de artefato a partir de schema"
	applicability: "Tarefas que produzem novo artefato cujo schema já existe. Output type é 'create' e schema correspondente está em architecture/artifact-schemas/."
	rationale:     "Instâncias são o conteúdo real do sistema. Protocolo garante que cada instância nasce conforme, com contexto semântico adequado e rastreabilidade."

	preReads: [{
		target:     "outputs[0].artifact"
		targetType: "derived-from-task-output"
		rationale:  "Artefato alvo a ser criado. Path resolvido em runtime a partir da TaskSpec — usado para identificar o schema correspondente."
	}, {
		target:     "architecture/design-principles.cue"
		targetType: "path"
		rationale:  "Princípios informam conteúdo semântico (não apenas estrutura)."
	}, {
		target:     "domain/domain-definition.cue"
		targetType: "path"
		condition:  "if-exists"
		rationale:  "Identidade do domínio contextualiza decisões de conteúdo. Se ainda não existe, consultar SESSION-CONTEXT.md para foundingPrinciples propostos."
	}, {
		target:     "contexts/{bc}/canvas.cue"
		targetType: "contextual-pattern"
		condition:  "if-applicable"
		rationale:  "Ler canvas do BC afetado quando a tarefa produz artefato dentro de um BC."
	}, {
		target:     "contexts/{bc}/golden-examples/"
		targetType: "contextual-pattern"
		condition:  "if-applicable"
		rationale:  "Exemplos aprovados definem padrão de qualidade esperado. Ler quando existirem para o BC alvo."
	}]

	steps: [{
		action:    "Verificar que o schema existe e está validado. Se não existe, sinalizar ao founder no chat que a tarefa está bloqueada e qual schema é necessário."
		rationale: "Instância sem schema não pode ser validada. Em Phase 0, bloqueios são comunicados via chat, não via eventos formais."
	}, {
		action:    "Identificar semanticPrerequisites da TaskSpec. Verificar que todas as condições são verdadeiras no estado atual do repositório."
		rationale: "Pre-requisitos semânticos capturam condições não rastreáveis por dependência estrutural."
	}, {
		action:    "Construir o conteúdo da instância campo a campo, com rationale para cada decisão de conteúdo."
		rationale: "Rastreabilidade de decisões. Cada campo é uma micro-decisão de design."
	}, {
		action:    "Propor a instância completa no chat."
		rationale: "Ciclo proposta→aprovação. Instâncias são decisões de design, não geração mecânica."
	}, {
		action:    "Após aprovação, escrever o arquivo e rodar cue vet contra o schema."
		rationale: "Validação sintática obrigatória antes de commit."
	}, {
		action:    "Verificar se existe validation prompt correspondente em architecture/validation-prompts/. Se existir, instruir o founder a executar em sessão separada."
		rationale: "Validação semântica separada por contexto conforme CLAUDE.md seção 14."
	}]

	qualityGates: [{
		gate:      "cue vet passa contra o schema correspondente"
		rationale: "Conformidade estrutural verificada."
	}, {
		gate:      "Todo campo carrega rationale significativo (não genérico)"
		rationale: "Rationale é obrigatório e deve explicar o porquê, não o quê."
	}, {
		gate:      "Conteúdo referencia princípios ou axiomas quando aplicável"
		rationale: "Rastreabilidade entre instância e fundamentos."
	}, {
		gate:      "Se validation prompt existe, instrução de validação entregue ao founder"
		rationale: "Validação semântica é gate de prosseguimento, não step opcional."
	}]
}
