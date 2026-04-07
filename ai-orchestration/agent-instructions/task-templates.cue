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

// ════════════════════════════════════════════════════════════
// tmpl-create-script
// ════════════════════════════════════════════════════════════

templates: "tmpl-create-script": {
	version:       1
	kind:          "create-script"
	title:         "Criar script de build ou governança rastreado como WI"
	applicability: "Tarefas que produzem shell script (ou equivalente executável) com função de build de artefato derivado, enforcement de governança ou CI check. Não aplicável a scripts experimentais, descartáveis ou de investigação local — esses permanecem fora do sistema de WI."
	rationale:     "Scripts com função de governança têm blast radius equivalente aos artefatos que derivam ou validam. Protocolo dedicado separa critérios de qualidade de script (idempotência, reprodutibilidade, atomicidade script↔derivado) dos critérios de artefato CUE (conformidade com schema, ubiquitous language), evitando ritual cruzado. Política de fronteira canônica vive em adr-042 (campo decision): um script deve ser rastreado como WI quando altera, deriva ou valida artefato versionado com papel normativo no sistema; na dúvida, rastrear. Este rationale é ponteiro operacional, não fonte normativa — a ADR é SoT."

	preReads: [{
		target:     "outputs[0].artifact"
		targetType: "derived-from-task-output"
		rationale:  "Path do script a ser criado. Determina diretório destino e convenções de nomenclatura."
	}, {
		target:     "architecture/adrs/adr-042-tmpl-create-script-and-script-wi-tracking.cue"
		targetType: "path"
		rationale:  "Fonte normativa da política de fronteira entre scripts rastreados e não-rastreados. Confirma que o script alvo qualifica para WI via teste altera/deriva/valida."
	}, {
		target:     "architecture/design-principles.cue"
		targetType: "path"
		rationale:  "P0 (zero duplicação), P1 (schema-first), P12 (governance as code) informam decisões de conteúdo do script."
	}, {
		target:     "scripts/ci/"
		targetType: "path"
		condition:  "if-exists"
		rationale:  "Scripts existentes são referência de estilo: set -euo pipefail, estrutura de flags, modos check/--fix, mensagens de erro. São exemplo de padrão, não fonte retroativa de conformidade."
	}]

	steps: [{
		action:    "Identificar o artefato source do qual o output do script deriva (caso de script de build) ou o artefato que o script valida (caso de check de governança). Declarar no cabeçalho do script como comentário. Se o script não possui source único — caso multi-source ou validação transversal a múltiplos artefatos — declarar explicitamente esta condição no cabeçalho em vez de forçar um source principal artificial."
		rationale: "Script de governança sem referência explícita ao artefato governado é ritual opaco. Rastreabilidade source→script→output é pré-requisito para auditoria. A opção de declarar 'multi-source' ou 'transversal' evita modelar o mundo de forma errada quando o script legitimamente não tem um source único."
	}, {
		action:    "Implementar o script com cabeçalho padrão: shebang, set -euo pipefail, bloco de documentação com propósito, modos de operação e exit codes declarados."
		rationale: "Cabeçalho padrão é convenção herdada de scripts/ci/ e reduz carga cognitiva na leitura. set -euo pipefail transforma falhas silenciosas em falhas detectáveis."
	}, {
		action:    "Implementar gate de idempotência: executar o script duas vezes consecutivas sobre o mesmo input deve produzir o mesmo output. Comparação byte-a-byte é a forma preferencial — recorrer a hash somente quando normalização de output for necessária (e.g., timestamps embutidos que exigem mascaramento) e declarar explicitamente a normalização no cabeçalho."
		rationale: "Idempotência é pré-requisito de script de build — sem ela, o output varia entre execuções e não pode servir como source of truth derivado. Preferência por byte-a-byte evita esconder divergência real atrás de hash normalizado; a exceção existe mas exige declaração explícita."
	}, {
		action:    "Implementar gate de reprodutibilidade: falhar com mensagem clara quando input esperado não existe, quando ferramenta externa (cue, jq, etc.) não está no PATH, ou quando resultado não pode ser validado. Nunca retornar exit 0 com output parcial."
		rationale: "Script que passa silenciosamente sobre falhas produz artefato derivado corrompido sem sinal. Falha alta e visível é condição de usabilidade."
	}, {
		action:    "Propor o script completo no chat (conteúdo inline + path de destino) antes de escrever. Incluir a saída esperada de uma execução limpa."
		rationale: "Ciclo proposta→aprovação aplica-se a scripts como a qualquer artefato rastreado. Saída esperada documenta o contrato."
	}, {
		action:    "Após aprovação, escrever o arquivo com permissão de execução (chmod +x) e rodar o script contra o input real para validar idempotência: executar duas vezes e comparar outputs."
		rationale: "Validação empírica do gate de idempotência antes do commit. Falha aqui significa defeito no script, não no protocolo."
	}, {
		action:    "Se o script gera artefato derivado versionado no repo (ex: CLAUDE.md), commitar o artefato derivado atualizado no mesmo commit do script. Script e derivado nascem juntos em estado consistente."
		rationale: "Commit atômico evita janela de inconsistência entre script novo e derivado antigo. Consistência é invariante do repo, não responsabilidade do próximo commit."
	}]

	qualityGates: [{
		gate:      "Gate de idempotência passa empiricamente: duas execuções consecutivas produzem outputs idênticos byte-a-byte (ou iguais após normalização declarada no cabeçalho)"
		rationale: "Verificação do invariante declarado no script. Sem evidência empírica, o gate é apenas documentação."
	}, {
		gate:      "Script falha com exit code não-zero e mensagem específica para cada classe de erro conhecida"
		rationale: "Falha silenciosa ou genérica esconde defeito. Gate força mapeamento explícito de erro → mensagem → exit code."
	}, {
		gate:      "Cabeçalho declara source (ou ausência de source único), output, modos de operação e exit codes"
		rationale: "Documentação inline é a única que sobrevive ao drift. Gate força disciplina no ponto de escrita."
	}, {
		gate:      "Se o script gera artefato derivado versionado, o derivado atualizado está incluído no mesmo commit"
		rationale: "Atomicidade script↔derivado. Verificável via git diff antes do commit."
	}]
}
