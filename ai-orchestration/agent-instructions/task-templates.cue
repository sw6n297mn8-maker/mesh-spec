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

// ════════════════════════════════════════════════════════════
// tmpl-create-convention
// ════════════════════════════════════════════════════════════

templates: "tmpl-create-convention": {
	version:       1
	kind:          "create-convention"
	title:         "Criar convenção de derivação/co-evolução entre tipos"
	applicability: "Tarefas que produzem artefato em architecture/conventions/ declarando protocolo formal de derivação, co-evolução ou relação cross-artefato entre dois ou mais tipos de artefato governados do repositório. Não aplicável a schemas (que definem o que é um tipo), princípios (invariantes universais do sistema) nem scripts executáveis — distinção fixada em adr-046."
	rationale:     "Convenções cross-artefato são protocolo, não ontologia nem axioma. Protocolo dedicado separa critérios de qualidade de convenção (tipos alvo explícitos, política de materialização classificada, SoT upstream canônico, separação determinístico/advisory) dos critérios de schema (estrutura de #Type) e script (idempotência, reprodutibilidade). Evita o cast que colapsaria convenção em schema ou script — motivação central de adr-046. A política de fronteira canônica vive em adr-046 (campo decision, seção 1): convenção governa relação entre 2+ tipos específicos, princípio governa o sistema inteiro. Este rationale é ponteiro operacional, não fonte normativa."

	preReads: [{
		target:     "outputs[0].artifact"
		targetType: "derived-from-task-output"
		rationale:  "Path da convenção a ser criada. Resolvido em runtime a partir da TaskSpec — confirma localização em architecture/conventions/ e nomenclatura."
	}, {
		target:     "architecture/adrs/adr-046-conventions-category-and-tmpl-create-convention.cue"
		targetType: "path"
		rationale:  "Fonte normativa meta-estrutural: enquadramento das 3 camadas (schema/princípio/convenção), política de singleton, vocabulário blockId, separação determinístico/advisory, fronteira regulatória. ADR é SoT da categoria."
	}, {
		target:     "schemas dos tipos governados (identificados na TaskSpec)"
		targetType: "contextual-pattern"
		rationale:  "Convenção governa relação entre tipos já existentes. Leitura dos schemas dos tipos alvo é pré-requisito: sem conhecer a estrutura de cada tipo, não há como declarar quais campos dirigem derivação, quais capability flags ativam o protocolo, nem onde as instâncias vivem. Tipos alvo são resolvidos em runtime a partir de governedTypes da TaskSpec — ler apenas os schemas referenciados, não o diretório inteiro."
	}, {
		target:     "architecture/design-principles.cue"
		targetType: "path"
		rationale:  "P0 (zero duplicação) governa política de materialização — conteúdo derivado não duplica source. P1 (schema-first) exige que schemas dos tipos alvo existam antes da convenção. P12 (governance as code) exige que a convenção seja CUE versionada. P10 (agentes recomendam, gates validam) sustenta a separação determinístico/advisory."
	}, {
		target:     "architecture/conventions/*.cue"
		targetType: "glob"
		condition:  "if-exists"
		rationale:  "Convenções pré-existentes são referência de shape. Durante n=0 (antes da primeira convenção concreta) o glob retorna vazio; a partir de n>=1 servem de golden example. Decisão sobre #Convention schema central é deferida até n=2 (pattern ten-009)."
	}, {
		target:     "governance/repo-structure.cue"
		targetType: "path"
		rationale:  "Singleton análogo estabelecido, e home de derivedArtifacts que registra zonas derivadas em artefatos híbridos. Convenção com materialization=hybrid deve fazer repo-structure.cue referenciar o blockId que ela declara — continuidade lexical fixada por adr-046 decisão 2."
	}]

	steps: [{
		action:    "Listar explicitamente o conjunto governedTypes: no mínimo dois tipos alvo. Cada tipo pode ser (a) tipo top-level com schema em architecture/artifact-schemas/, (b) subtipo aninhado dentro de outro artefato (ex: domain events dentro de canvas.cue), ou (c) artefato derivado registrado em governance/repo-structure.cue.derivedArtifacts. Declarar para cada tipo o path canônico e a referência estrutural (schema, campo no artefato container, ou entry em derivedArtifacts). Se o conjunto tem apenas um tipo, PARAR a execução e sinalizar ao founder no chat: (i) criar o tipo faltante antes via tmpl-create-schema, (ii) reclassificar a tarefa para create-schema se o objetivo real é definir ontologia, ou (iii) reclassificar para mudança em design-principles.cue se o invariante é universal. Não prosseguir com convenção de tipo único."
		rationale: "Convenção sem 2+ tipos alvo explícitos colapsa a distinção schema/princípio/convenção. Este step força o teste ontológico antes da materialização. Aceitar subtipos aninhados e artefatos derivados evita excluir padrões latentes (domain events dentro de canvas, schema↔CLAUDE.md derivado) citados em adr-046 como motivadores da categoria."
	}, {
		action:    "Identificar e declarar upstreamSources: para cada relação de derivação ou co-evolução governada, qual tipo é fonte de verdade canônica (upstream) e qual é derivado, coevolutivo ou dependente (downstream). Declarar SoT por relação, não globalmente — uma convenção pode ter múltiplas relações internas com diferentes SoTs. Se a relação é simétrica (nenhum lado é upstream), declarar explicitamente e justificar no rationale por que não há direção de derivação."
		rationale: "P0 exige uma única localização canônica por unidade de conhecimento. Sem SoT upstream declarado por relação, conflitos resolvem ad-hoc — drift por construção. Simetria declarada é distinta de omissão."
	}, {
		action:    "Identificar e declarar presenceConditions: dentro do escopo dos tipos governados, sob quais condições o protocolo ativa. Condições podem ser (a) co-existência dos tipos alvo (ativa sempre que ambos existem no escopo relevante); (b) valores específicos de campos ou capability flags no upstream; (c) tags, propriedades estruturais ou estado de outro tipo; (d) combinação das anteriores. Declarar de forma mecanicamente verificável — não em prosa."
		rationale: "Sem presenceConditions explícitas, enforcement é impossível: validator não sabe quando o protocolo aplica. 'Sempre que ambos os tipos existem' é presença válida — declarar explicitamente em vez de implícito. Convenção não se torna princípio por ativar sempre — a distinção é escopo (par de tipos vs sistema inteiro), não frequência de ativação."
	}, {
		action:    "Classificar materialization como exatamente um de: pure-derived (output é regenerado integralmente do source, sem conteúdo autoral no downstream), pure-authored (downstream é escrito manualmente conforme a convenção, sem geração mecânica — convenção apenas declara relação normativa), hybrid (downstream mistura zonas derivadas delimitadas por blockMarkers com zonas autorais). Registrar a classificação como campo explícito da convenção com rationale curto."
		rationale: "Política de materialização determina quais mecanismos de enforcement são viáveis. pure-derived admite regeneração mecânica; pure-authored admite apenas validação; hybrid exige marker de zona. Sem classificação, o próximo passo (enforcement) fica ambíguo e drift vira invisível."
	}, {
		action:    "Se materialization=hybrid, declarar blockMarkers com blockId(s) e sintaxe específica do formato alvo. Usar blockId como nome do identificador por continuidade lexical com repo-structure.cue.derivedArtifacts (vocabulário herdado per adr-046 decisão 2). A convenção é SoT do blockId e da sintaxe do marker — repo-structure.cue.derivedArtifacts REFERENCIA o blockId declarado pela convenção, não redeclara. A sintaxe concreta do marker depende do formato do arquivo alvo (markdown, CUE, YAML, etc.) e deve ser documentada inline com exemplo. Se materialization!=hybrid, omitir blockMarkers."
		rationale: "Híbrido sem marker é drift garantido — zona derivada contamina zona autoral ou vice-versa. Marker explícito é pré-requisito de enforcement. SoT único do blockId (convenção declara, repo-structure referencia) previne duplicação P0-violadora entre os dois mecanismos análogos. Sintaxe varia por formato e não cabe no template."
	}, {
		action:    "Separar validationPolicy em duas camadas declaradas per adr-040: (a) structural — regras determinísticas em architecture/structural-checks/ que podem bloquear o fluxo; declarar 'none' explicitamente quando não há gate estrutural viável, com justificativa; (b) advisory — revisão interpretativa em architecture/validation-prompts/ que recomenda mas nunca bloqueia; declarar 'none' explicitamente quando não há dimensão interpretativa que justifique o custo. Não misturar as duas camadas no mesmo slot. Nenhum gate declarado em 'structural' pode depender de LLM (P10 + ten-006)."
		rationale: "adr-040 estabelece que gates determinísticos bloqueiam e advisory recomenda. Convenção que declara validação sem separar camadas força reclassificação retroativa — ou pior, trata LLM como gate (violação de P10). Separação explícita desde a criação previne drift semântico."
	}, {
		action:    "Avaliar fronteira regulatória: se qualquer tipo governado pertence a BC regulado (FCE, SCF, BKR, REW, IDC, ATO, INS, ITC) ou se o protocolo afeta conteúdo sob dp-10/LGPD/KYC, declarar o contrato regulatório explicitamente no rationale da convenção: quais constraints aplicam, qual artefato concreto carrega a responsabilidade jurídica identificável, quais BCs regulados são afetados. Constraints regulatórias não são tensionáveis pelo protocolo da convenção."
		rationale: "CLAUDE.md fixa constraints regulatórias como invioláveis, distintos dos axiomas tensionáveis. Convenção que toca conteúdo regulado sem declarar o contrato é risco de compliance silencioso. Responsabilidade jurídica identificável (dp-10) exige que o ponto de responsabilidade seja declarado, não implícito."
	}, {
		action:    "Propor a convenção completa no chat antes de escrever, com cada seção (governedTypes, upstreamSources, presenceConditions, materialization, blockMarkers se hybrid, validationPolicy, contrato regulatório se aplicável) e rationale por decisão estrutural. Incluir referência cruzada ao ADR da convenção concreta (obrigatório para criação de convenção per CLAUDE.md tabela 'Referências por Tipo de Operação': mudança semântica em architecture/ exige ADR no mesmo commit)."
		rationale: "Convenções são decisões estruturais semânticas. Ciclo proposta→aprovação aplica-se integralmente. ADR próprio é obrigatório porque cria artefato estrutural em architecture/ — a regra vive em CLAUDE.md, não é específica deste template."
	}, {
		action:    "Após aprovação, escrever a convenção em architecture/conventions/<nome>.cue e rodar cue vet. Se materialization=hybrid e a convenção introduz nova zona derivada em artefato versionado, atualizar governance/repo-structure.cue.derivedArtifacts com entry referenciando o blockId declarado pela convenção (não redeclarando), no mesmo commit. Se validationPolicy.structural declara check(s) concreto(s), criar arquivo(s) correspondente(s) em architecture/structural-checks/ no mesmo commit OU registrar explicitamente como follow-up com gap declarado no rationale da convenção — nunca declaração silenciosa de gate inexistente."
		rationale: "Atomicidade convenção↔repo-structure e convenção↔structural-check previne janelas de inconsistência. Commit único mantém o invariante do repo. Follow-up explícito é aceitável; silêncio sobre gate inexistente é drift de construção (gate declarado mas não implementado)."
	}, {
		action:    "Verificar cobertura de design review advisory: existe validation prompt para artifactType 'convention' em architecture/validation-prompts/? Se sim, instruir o founder a executar em sessão separada sobre a convenção criada. Se não, registrar explicitamente no output ao founder que o tipo ainda não está coberto por design review advisory, conforme CLAUDE.md seção 14 item 5."
		rationale: "Transparência de cobertura de validação é gate da seção 14 do CLAUDE.md. Gap silencioso = ritualização. Registrar explicitamente é pré-requisito para que o founder decida se a ausência é aceitável ou se exige criação de validation prompt."
	}]

	qualityGates: [{
		gate:      "governedTypes contém dois ou mais tipos explicitamente declarados, cada um referenciado por schema canônico, subtipo aninhado em artefato container, ou entry em repo-structure.cue.derivedArtifacts"
		rationale: "Teste ontológico mecânico — menos de dois tipos = não é convenção. Aceitar 3 formas de referência cobre os padrões latentes (schema-a-schema, subtipo-a-subtipo, schema-a-derivado) sem forçar cast incorreto."
	}, {
		gate:      "upstreamSources declara SoT canônico por relação de derivação/co-evolução governada; relações simétricas são declaradas explicitamente como tais com justificativa"
		rationale: "P0 aplicado por relação, não globalmente. Sem SoT explícito, conflitos resolvem ad-hoc. Simetria declarada é distinta de omissão."
	}, {
		gate:      "presenceConditions declara mecanicamente quando o protocolo ativa dentro do escopo dos tipos governados (co-existência, campos, flags, tags, ou combinação) — nunca em prosa"
		rationale: "Enforcement exige condição verificável. Prosa livre é não-enforceável e vira interpretação."
	}, {
		gate:      "materialization está classificada como exatamente um de pure-derived | pure-authored | hybrid, com rationale curto"
		rationale: "Sem classificação, enforcement é impossível. Gate força a escolha no ponto de escrita."
	}, {
		gate:      "Se materialization=hybrid, blockMarkers está declarado com blockId único (a convenção é SoT do blockId; repo-structure.cue.derivedArtifacts apenas referencia) e sintaxe exemplificada inline; se materialization!=hybrid, blockMarkers é omitido"
		rationale: "Híbrido sem marker é drift. Não-híbrido com marker é ruído. SoT único previne duplicação P0-violadora."
	}, {
		gate:      "validationPolicy separa explicitamente camada structural (determinístico) de camada advisory (interpretativo), mesmo quando uma das camadas é 'none'; nenhum gate declarado em structural depende de LLM"
		rationale: "Separação por adr-040 é invariante estrutural. P10 impede LLM como gate determinístico."
	}, {
		gate:      "Pelo menos uma das camadas de validationPolicy (structural ou advisory) declara conteúdo não-'none'; se ambas são 'none', rationale da convenção contém justificativa explícita para convenção puramente declarativa (ex: fase intermediária, com follow-up de enforcement registrado como tensão ou ADR)"
		rationale: "Convenção sem enforcement algum pode virar ritual vazio silenciosamente. Gate força que o modo puramente declarativo seja decisão consciente e registrada, não deriva por omissão."
	}, {
		gate:      "ADR próprio da convenção concreta está incluído no mesmo commit (ou no commit imediatamente anterior referenciado pela convenção)"
		rationale: "CLAUDE.md tabela de operações: criar artefato estrutural em architecture/ exige ADR. Convenção concreta é artefato estrutural semântico por definição."
	}, {
		gate:      "cue vet passa sem erros"
		rationale: "Conformidade sintática obrigatória antes de commit."
	}]
}
