package readme

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// config.cue — Instância de #ReadmeConfig para mesh-spec.
//
// Stages 4a+4b de adr-050: tree.entries com 33 diretórios governados
// e sections com 15 narrativas consolidadas extraídas do README.md atual.
//
// Escopo da tree: cobre todo diretório autoral governado do repo.
// Instance containers (self-reviews/, task-specs/, agents/, events/,
// commands/, golden-examples/, etc.) não recebem entry própria quando
// o conteúdo é puramente coleção de instâncias do tipo declarado no
// diretório-pai — convenção sobre nomes de slug vive no schema do tipo,
// não na tree do README.
//
// Consolidação de sections (vs README.md manual):
//   - "Nota sobre Nível 6" integrada ao final de "Mapeamento".
//   - "Recovery e Compensation" integrada a "Evolução de Eventos".
//   - "Orçamento de Contexto", "Ciclo de Vida do Agente" e "Fronteira
//     Estocástico/Determinístico" unificadas em "Governança de Agentes".
//   - "Critérios de Completude" reduzida a ponteiro para
//     governance/bounded-context-completeness.cue (evita duplicação
//     do machine-readable per P0).

config: artifact_schemas.#ReadmeConfig & {
	repo:    "mesh-spec"
	heading: "Estrutura Canônica do Repositório de Especificação"
	description: #"""
		mesh-spec é o repositório de especificação do sistema Mesh. Todo artefato que descreve o que o sistema é e como se comporta vive aqui. Este documento (landing page derivada) é a única exceção ao formato CUE; todo conteúdo estrutural é governado via governance/readme/config.cue e regenerado por cue export.
		"""#
	tree: {
		rootPath: "mesh-spec"
		entries: [
			// ── Top-level ──
			{
				path:    ".claude/"
				purpose: "Configuração local do Claude Code para este repositório (hooks, settings de sessão)."
				conventions: [
					"Não contém spec de domínio nem governança autoral.",
					"settings.json e hooks/ são artefatos de ferramenta, não de domínio.",
				]
				rationale: "Separar configuração de ferramenta de conteúdo governado evita confusão entre autoridade da spec e comportamento do cliente."
			},
			{
				path:    ".claude/hooks/"
				purpose: "Scripts de hook específicos da instância local do Claude Code."
				conventions: [
					"Scripts são locais à sessão; não devem assumir disponibilidade em CI.",
					"Lógica de gate permanece em scripts/ci/ e scripts/hooks/.",
				]
				rationale: "Hooks do Claude Code são convenientes para DX mas não podem virar autoridade — duplicaria scripts/hooks/ e violaria P0 (zero duplicação)."
			},
			{
				path:    "ai-orchestration/"
				purpose: "Layer 5 da espec: como montar contexto certo para tarefa certa dentro do orçamento de tokens."
				conventions: [
					"retrieval-patterns.cue, dependency-graph.cue e agent-lifecycle.cue são top-level do diretório.",
					"Prompt-templates em ai-orchestration/agent-instructions/.",
				]
				rationale: "Orquestração de IA é problema que a literatura DDD não endereça; separar em layer própria evita poluir Layers 0-4 com preocupações de runtime estocástico."
			},
			{
				path:    "ai-orchestration/agent-instructions/"
				purpose: "Prompt-templates por tarefa recorrente (implementar agregado, expor API, gerar testes, evoluir evento)."
				conventions: [
					"Um arquivo por tarefa; nome no formato verbo-substantivo (implement-aggregate.cue).",
					"Cada template referencia artefatos source da spec, nunca duplica conteúdo.",
				]
				rationale: "Templates reutilizáveis por tarefa garantem consistência de execução e reduzem drift entre sessões de agente."
			},
			// ── Architecture (Layer 3) ──
			{
				path:    "architecture/"
				purpose: "Layer 3 da espec: decisões arquiteturais globais que não pertencem a nenhum BC individual."
				conventions: [
					"Artefatos cross-context (ADRs globais, schemas, lenses, princípios) vivem aqui.",
					"design-principles.cue é top-level; demais artefatos em subdiretórios por tipo.",
				]
				rationale: "Concentrar decisões que afetam múltiplos BCs em um só lugar evita espalhar conhecimento transversal pelas pastas de contexto."
			},
			{
				path:    "architecture/adrs/"
				purpose: "ADRs globais do sistema (stack, patterns, deploy strategy, protocolos cross-context)."
				conventions: [
					"Formato adr-NNN-slug.cue com numeração contínua e incremental.",
					"Cada ADR conforma com architecture/artifact-schemas/adr.cue.",
					"Supersession atualiza os dois ADRs no mesmo commit (ADR novo + status do antigo).",
				]
				rationale: "ADR é a forma canônica de registrar decisão com contexto, alternativas consideradas e consequências — histórico imutável evita perda de justificativa."
			},
			{
				path:    "architecture/artifact-schemas/"
				purpose: "Schemas de validação para cada tipo de artefato instanciado no repo (#Canvas, #ADR, #Lens, etc.)."
				conventions: [
					"Um arquivo por tipo de artefato; nome em singular kebab-case (canvas.cue, adr.cue).",
					"Schemas definem shape + rationale + location + qualityCriteria.",
					"CI valida que toda instância do tipo conforma com seu schema.",
				]
				rationale: "Schemas são meta-nível: governam validade de instâncias. Centralizar em um diretório permite discovery e auditoria de cobertura por tipo."
			},
			{
				path:    "architecture/artifacts/"
				purpose: "Instâncias de artefatos operacionais cross-context (governance envelopes, lenses produzidos)."
				conventions: [
					"artifacts/governance/ contém autonomy envelopes.",
					"artifacts/lenses/ reservado para outputs produzidos pelas lenses analíticas.",
				]
				rationale: "Separar instâncias cross-context de schemas deixa claro que conteúdo aqui é produto de aplicação, não meta-definição."
			},
			{
				path:    "architecture/c4/"
				purpose: "Diagramas C4 do sistema (Structurizr DSL como source, views derivadas em .mmd/.png)."
				conventions: [
					"workspace.dsl é o source of truth; views/ contém derivados.",
					"Diagramas nunca editados no formato renderizado — regenerados do DSL.",
				]
				rationale: "C4 provê linguagem visual compartilhada para arquitetura; manter DSL como source mantém versionamento textual auditável."
			},
			{
				path:    "architecture/conventions/"
				purpose: "Convenções arquiteturais condicionais a capability flags do BC (API sync/async, etc.)."
				conventions: [
					"Cada convenção declara condição de ativação (ex: hasSyncSurface).",
					"CI valida conformidade apenas quando condição é satisfeita no BC.",
				]
				rationale: "Convenção condicional evita impor regra universal a BCs que não têm a capability; flexibilidade sem perder auditoria."
			},
			{
				path:    "architecture/cross-context-workflows/"
				purpose: "Processos que atravessam múltiplos bounded contexts (ex: commitment lifecycle)."
				conventions: [
					"Cada workflow documenta BCs participantes e eventos trocados.",
					"Conformam com architecture/artifact-schemas/cross-context-flow.cue.",
				]
				rationale: "Workflows cross-context não pertencem a nenhum BC individual; alocar em architecture/ preserva ownership distribuído dos BCs."
			},
			{
				path:    "architecture/lenses/"
				purpose: "Lenses analíticas: protocolos de raciocínio para domínios especializados (economia, segurança, crédito, AI)."
				conventions: [
					"Nome no formato lens-slug.cue.",
					"Cada lens declara critérios de ativação e protocolo de raciocínio.",
					"Agente referencia a lens aplicada no rationale do artefato produzido.",
				]
				rationale: "Lenses expandem capacidade analítica do agente sem inflar princípios universais; ativação condicional garante custo cognitivo apenas quando relevante."
			},
			{
				path:    "architecture/shared-schemas/"
				purpose: "Schemas compartilhados entre BCs (Money canônico, CloudEvents envelope, assertions formais, Ion rules)."
				conventions: [
					"Um arquivo por schema; uso cross-BC justifica presença aqui.",
					"Schemas locais a um BC vivem em contexts/{bc}/schemas/, nunca aqui.",
				]
				rationale: "Schemas usados por mais de um BC ganham localização canônica única; duplicação entre BCs seria drift por construção."
			},
			{
				path:    "architecture/shared-types/"
				purpose: "Tipos reutilizáveis entre artifact-schemas (#StrategicClassification, #VerticalApplicability)."
				conventions: [
					"Tipos de baixo nível usados por múltiplos schemas.",
					"Não contém instâncias; apenas definições de tipo.",
				]
				rationale: "Extrair tipos compartilhados evita que cada artifact-schema redefina os mesmos tipos — previne drift de definição."
			},
			{
				path:    "architecture/structural-checks/"
				purpose: "Checks estruturais determinísticos executados pós-commit como gate (P10)."
				conventions: [
					"Um arquivo por tipo de artefato coberto; nome casa o tipo (canvas.cue cobre #Canvas).",
					"4 kinds suportados: required-block, reference-exists, same-artifact-consistency, conditional-file-presence.",
					"Apenas structural-checks podem bloquear o fluxo; validation-prompts são advisory.",
				]
				rationale: "Gate determinístico separado de revisão semântica é consequência de P10 — LLM recomenda, regra bloqueia."
			},
			{
				path:    "architecture/tension-log/"
				purpose: "Tensões arquiteturais: fricções cross-artifact que não são defeito de nenhum lado individual."
				conventions: [
					"Nome no formato ten-NNN-slug.cue.",
					"Cada tensão referencia artefatos em tensão e descreve por que não é defeito de um deles.",
					"Conformam com architecture/artifact-schemas/tension-entry.cue.",
				]
				rationale: "Registrar tensões torna explícita fricção estrutural que seria perdida se tratada como bug isolado em cada lado."
			},
			{
				path:    "architecture/validation-prompts/"
				purpose: "Prompts de design review advisory executados por agente isolado pós-commit."
				conventions: [
					"Nome no formato validate-{artifactType}.cue.",
					"Findings são recomendações, nunca veredito de gate (P10).",
					"Matching via matchPatterns declarados em cada prompt.",
				]
				rationale: "Revisão semântica complementa gate estrutural cobrindo dimensões interpretativas — separar prompts de checks preserva a categorização."
			},
			// ── Contexts (Layer 2) ──
			{
				path:    "contexts/"
				purpose: "Layer 2 da espec: bounded contexts autocontidos, cada um um pacote completo."
				conventions: [
					"Um subdiretório por BC, nome lowercase de 3 letras (cmt, ctr, idc, npm).",
					"Cada BC contém canvas, invariants, commands, events, workflows e demais artefatos declarados em governance/bounded-context-completeness.cue.",
				]
				rationale: "Autocontenção do BC é o que permite paralelizar trabalho entre agentes — dependências cross-BC passam por contratos explícitos em strategic/context-map.cue."
			},
			{
				path:    "contexts/cmt/"
				purpose: "Bounded Context Commitment Management: gestão do ciclo de vida de compromissos entre participantes."
				conventions: [
					"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
					"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
				]
				rationale: "Commitment é o centro operacional do sistema Mesh; isolamento em BC próprio permite evolução independente do vocabulário de compromissos."
			},
			{
				path:    "contexts/ctr/"
				purpose: "Bounded Context Contract & Terms Registry: registro versionado de contratos e cláusulas canônicas."
				conventions: [
					"Versionamento de contratos é backward-compatible por construção; quebra exige supersession.",
					"Cláusulas são referenciadas por outros BCs via IDs estáveis.",
				]
				rationale: "Separar ctr como BC dedicado evita que cada BC consumidor redefina termos contratuais — fonte canônica única para obrigações jurídicas."
			},
			{
				path:    "contexts/idc/"
				purpose: "Bounded Context Identity & Data Governance: identidade de participantes e governança de dados pessoais (LGPD, integridade criptográfica)."
				conventions: [
					"Event log com integridade criptográfica end-to-end.",
					"Dados pessoais governados por políticas declaradas aqui; outros BCs consultam, não redefinem.",
				]
				rationale: "Identidade e conformidade regulatória são responsabilidades que tangenciam todos os BCs; BC dedicado evita dispersão de lógica sensível."
			},
			{
				path:    "contexts/npm/"
				purpose: "Bounded Context Network Participant Management: cadastro e lifecycle de participantes da rede Mesh."
				conventions: [
					"Participante é entidade cross-BC; idc governa identidade, npm governa papel na rede.",
					"Onboarding e offboarding são workflows próprios deste BC.",
				]
				rationale: "Separar participante como entidade da rede do seu registro de identidade permite lifecycle de network-membership sem misturar com governança de dados pessoais."
			},
			// ── Domain (Layer 0) ──
			{
				path:    "domain/"
				purpose: "Layer 0 da espec: identidade do domínio (tese, outcomes, flywheel, glossário universal, atores)."
				conventions: [
					"domain-definition.cue é a tese da empresa; outros artefatos de domain/ referenciam.",
					"universal-glossary.cue contém termos cross-context; glossários locais vivem em contexts/{bc}/ubiquitous-language.cue.",
				]
				rationale: "Identidade do domínio vive em layer separada porque muda em ritmo diferente do design tático — estabilizar tese antes de decompor em BCs."
			},
			// ── Governance (Layer 4) ──
			{
				path:    "governance/"
				purpose: "Layer 4 da espec: governança e qualidade (estrutura do repo, princípios operacionais, protocolos)."
				conventions: [
					"repo-structure.cue e repo-principles.cue são top-level do diretório.",
					"Protocolos (self-review, wave-plan, red-team, audit) vivem aqui.",
					"Configuração source-of-truth de CLAUDE.md e README.md em subdiretórios dedicados.",
				]
				rationale: "Governança não produz conhecimento novo — audita o existente. Separar em layer própria evita confundir metarregra com spec de domínio."
			},
			{
				path:    "governance/build-time/"
				purpose: "Especificações de build-time: work governance, quality-gate, self-review, task-specs."
				conventions: [
					"Schemas de protocolo em arquivos top-level do diretório.",
					"self-reviews/ e task-specs/ são containers de instâncias — schemas correspondentes em architecture/artifact-schemas/.",
					"work-graph.cue e projections/ derivam de eventos; nunca editados manualmente.",
				]
				rationale: "Protocolos de build-time orquestram como o trabalho acontece; isolamento em subdiretório facilita auditoria de governança de execução sem ruído de domínio."
			},
			{
				path:    "governance/claude/"
				purpose: "Source of truth das regras comportamentais do agente (CLAUDE.md é artefato derivado)."
				conventions: [
					"config.cue é a instância; schema.cue e output.cue governam shape e renderização.",
					"CLAUDE.md nunca editado diretamente — regenerado por cue export.",
					"Schema conforma com portfolio-wide #ClaudeConfig adotado em governance/adopted-artifacts.cue.",
				]
				rationale: "Regras comportamentais governadas como CUE permitem cue vet, review por PR e evolução rastreável — mesmo regime dos demais artefatos."
			},
			{
				path:    "governance/readme/"
				purpose: "Source of truth da estrutura do README.md (README.md é artefato derivado)."
				conventions: [
					"config.cue contém a instância; output.cue o template; schema é portfolio-wide.",
					"README.md nunca editado diretamente — regenerado por cue export.",
					"Schema conforma com portfolio-wide #ReadmeConfig adotado em governance/adopted-artifacts.cue.",
				]
				rationale: "README governado como CUE elimina drift entre landing page e filesystem; toda mudança de estrutura passa pelo mesmo gate dos demais artefatos."
			},
			// ── Scripts (Tooling operacional) ──
			{
				path:    "scripts/"
				purpose: "Tooling operacional de CI e automação; não contém spec de domínio."
				conventions: [
					"Scripts de gate em scripts/ci/; git hooks em scripts/hooks/.",
					"Nenhuma lógica de domínio vive aqui — apenas orquestração de validação.",
				]
				rationale: "Separar tooling de spec deixa explícito que código aqui é infraestrutura de qualidade, não conhecimento autoral do sistema."
			},
			{
				path:    "scripts/ci/"
				purpose: "Scripts de CI que enforçam gates determinísticos (self-review, coevolução README, cobertura)."
				conventions: [
					"Cada script tem um workflow correspondente em .github/workflows/.",
					"Falha de script bloqueia merge; ajustes exigem decisão explícita.",
				]
				rationale: "CI scripts são a implementação executável das políticas declaradas em governance/; manter juntos facilita auditoria de cobertura de gate."
			},
			{
				path:    "scripts/hooks/"
				purpose: "Git hooks locais (pre-commit, post-commit) que antecipam validação antes de chegar em CI."
				conventions: [
					"Instalação via git config core.hooksPath scripts/hooks.",
					"Hook local é safety net, nunca substitui gate de CI.",
				]
				rationale: "Hooks locais reduzem latência do feedback loop; manter a fonte em scripts/hooks/ versionado evita que cada dev configure o próprio."
			},
			// ── Strategic (Layer 1) ──
			{
				path:    "strategic/"
				purpose: "Layer 1 da espec: design estratégico (subdomínios, context map, flywheel informacional, domain stories)."
				conventions: [
					"context-map.cue é SoT de relações entre BCs; manifestos em contexts/{bc}/context-dependencies.cue são derivados.",
					"informational-flywheel.cue mapeia eventos que alimentam modelos cross-BC.",
				]
				rationale: "Decomposição estratégica vive entre identidade do domínio (Layer 0) e BCs táticos (Layer 2); separação permite evoluir fronteiras sem mexer no tático."
			},
			{
				path:    "strategic/domain-stories/"
				purpose: "Fluxos de negócio narrados como sequências ator → ação → work item."
				conventions: [
					"Um arquivo por story; nome no formato slug kebab-case.",
					"Cada story referencia BCs e eventos envolvidos por ID.",
				]
				rationale: "Domain stories ancoram design em exemplos concretos de uso; reduzem risco de decomposição correta porém desconectada de cenários reais."
			},
			{
				path:    "strategic/subdomains/"
				purpose: "Classificação de subdomínios (Core/Supporting/Generic), complexidade, volatilidade, propósito."
				conventions: [
					"Um arquivo por subdomínio; nome no formato subdomain-code.cue.",
					"Classificação orienta alocação de esforço — Core recebe investimento maior.",
				]
				rationale: "Separar classificação de subdomínio do BC que o realiza permite reavaliar core/supporting sem mexer na estrutura tática."
			},
		]
		rationale: "Tree cobre 33 diretórios governados — todos os top-level mais subdiretórios autorais com função distinta. Instance containers (self-reviews/, task-specs/, agents/, events/ etc.) herdam regra do diretório-pai e não ganham entry dedicada para evitar ruído."
	}
	sections: [{
		title: "Como Este Repositório Funciona"
		content: #"""
			mesh-spec é a autoridade do sistema. Todo artefato que descreve o que a Mesh é, como se comporta e quais contratos governa vive aqui. Nenhuma linha de código é escrita sem que a spec a justifique. Nenhuma divergência entre spec e implementação é aceitável — se divergem, o código está errado.

			O repositório usa um formato único: CUE. Todo artefato — domain model, invariantes, policies, state machines, schemas, ADRs, threat models, domain stories, coding conventions, agent specs, glossários, protocolos de governança, instruções de agente — é definido em CUE com campo `rationale` por elemento. Não existe descrição narrativa paralela do mesmo conteúdo. Quando um humano precisa entender um artefato formal, ele lê a estrutura ou pede ao agente que explique sob demanda. A explicação é gerada, não persistida — e portanto nunca fica desatualizada. A única exceção é o README.md raiz (este documento), que serve como landing page do repositório e é artefato derivado de `governance/readme/config.cue`.

			A organização é vertical, não horizontal. O agente que vai implementar o Commitment Management (CMT) lê a pasta `contexts/cmt/` e encontra tudo: canvas, linguagem ubíqua, modelo de domínio, invariantes, state machines, schemas, contratos, agents, workflows, anti-patterns, threat model, exemplos e specs de teste. Não precisa garimpar 15 documentos espalhados. Artefatos transversais — glossário global, context map, princípios universais de agentes, shared schemas, artifact schemas — existem fora dos BCs, mas cada BC declara explicitamente quais consome via manifesto derivado.

			Schemas CUE são a source of truth de todos os contratos de domínio — events, commands, types, authorization, routing, posting rules, reconciliation, projections, workflow state, required evidence, interaction contracts. Os artefatos gerados (.proto, Ion Schema, JSON Schema) vivem no mesh-runtime ou são produzidos no CI do runtime. Nada gerado é editado manualmente, nada gerado vive neste repositório.

			mesh-spec muda em cadência humana. Cada commit é uma decisão de design, não um bug fix. Agentes de código têm acesso read-only. O repositório de implementação — mesh-runtime — é subordinado e muda em cadência de agente. A subordinação não é unidirecional: o runtime emite spec-gap events quando descobre lacunas, agentes de governança sintetizam propostas, e a decisão final de evolução permanece humana.
			"""#
		rationale: "Landing page precisa ancorar o leitor nas três decisões fundamentais — spec como autoridade, CUE como formato único, organização por BC — antes de qualquer detalhe estrutural."
	}, {
		title: "Dois Repositórios, Papéis Distintos, Hierarquia Clara"
		content: #"""
			**mesh-spec** é o repositório de especificação. Contém tudo que descreve o que o sistema é e como se comporta: domain definition, subdomínios, bounded contexts, domain models, invariantes, policies, state models, commands, events, schemas CUE, context map, glossário, ADRs, governance, ai-orchestration. É a autoridade. Muda em cadência humana.

			**mesh-runtime** é o repositório de implementação. Contém tudo que executa: código dos serviços por BC, testes gerados a partir da spec, artefatos gerados dos CUE (.proto, Ion Schema, JSON Schema), CI/CD, infra, observabilidade, deploy. Muda em cadência de agente. É subordinado à spec — se há divergência, o runtime está errado.

			Os schemas CUE vivem em mesh-spec porque são artefatos de especificação que definem contratos de domínio. Os artefatos gerados a partir deles vivem em mesh-runtime ou são produzidos no CI do runtime — nunca editados manualmente, portanto não precisam de versionamento autoral.

			**Três tiers de autorização:**

			| Tier | Agente | Permissão no mesh-spec |
			|---|---|---|
			| **Read** | Agentes de código (implementam BCs) | Leitura de qualquer artefato. Zero escrita. |
			| **Propose** | Agentes de governança (auditoria, spec-gap) | Criar branch + abrir draft PR. Zero merge. Lista explícita em governance/. |
			| **Decide** | Humanos (founder, CODEOWNERS) | Aprovar e fazer merge. Modificar branches protegidos. |

			Nenhum agente pode fazer merge. PRs de agentes Propose são sempre draft.
			"""#
		rationale: "Separação spec/runtime e os três tiers são os dois contratos organizacionais cuja violação desfaz toda a disciplina do repo — precisam estar explícitos na landing page."
	}, {
		title: "Princípios Orientadores"
		content: #"""
			Estes princípios governam a organização da spec (como o conhecimento é estruturado no repositório). São distintos de `architecture/design-principles.cue` (P0-P12), que governa o design do sistema. Ambos coexistem e não se sobrepõem.

			**P1 — Bounded Context como unidade primária de organização.** O repositório não é organizado por camada de abstração (estratégico → tático → aplicacional → infra). É organizado por bounded context. Camadas descrevem a ordem de descoberta do conhecimento. BCs descrevem a unidade de consumo — o pacote coeso que um agente de IA recebe quando vai executar qualquer tarefa.

			**P2 — CUE como formato universal, README.md como única exceção.** Todo artefato do repositório é definido em CUE — incluindo artefatos que em repositórios tradicionais seriam markdown. CUE é simultaneamente machine-readable (CI valida, agentes consomem) e human-readable (estrutura autoexplicativa, campo `rationale` por elemento). Exceções são apenas formatos impostos por ferramenta ou plataforma externa (README.md, CLAUDE.md derivado, OpenAPI/AsyncAPI, Structurizr DSL, CODEOWNERS, .github/). Payloads em trânsito são serializados em Amazon Ion, governados por quatro regras canônicas (Ion-1 a Ion-4). Git é o único sistema de versionamento.

			**P3 — Granularidade atômica com composição explícita.** Cada unidade de conhecimento (um command, um event, uma invariante) é identificável e endereçável individualmente. Quando faz sentido, essas unidades vivem como arquivos separados (commands/, events/). Quando a granularidade por arquivo gera mais ruído que valor (invariantes, policies), elas vivem como seções dentro de um arquivo do BC. O critério é: se um agente precisaria desse item isoladamente com frequência, ele merece seu próprio arquivo.

			**P4 — Autocontido por contexto, com dependências transversais declaradas.** Cada BC deve ser compreensível lendo apenas sua pasta + os documentos transversais que ele referencia. Dependências entre contextos ou com artefatos transversais são declaradas via referência explícita, não via conhecimento implícito. Cada BC mantém um manifesto de dependências (`context-dependencies.cue`) derivado de `strategic/context-map.cue` — nunca editado manualmente.

			**P5 — Retrieval patterns como artefato de primeira classe.** A camada `ai-orchestration/` não é acessória — é tão importante quanto o domain model. Resolve o problema que a literatura DDD não endereça: como montar o contexto certo para a tarefa certa, dentro do orçamento de tokens. Sem ela, o agente recebe ou contexto demais (poluição) ou de menos (alucinação).

			**P6 — Negative specs têm o mesmo peso que positive specs.** Para humanos, proibições são inferidas do contexto. Para IA, não. Anti-patterns, restrições arquiteturais e fronteiras de responsabilidade precisam ser explícitos. Cada BC tem um `anti-patterns.cue` e cada ADR tem uma seção de alternativas rejeitadas.

			**P7 — Golden examples como padrão de qualidade.** A IA aprende mais por pattern matching concreto do que por instrução abstrata. Implementações de referência dentro de cada BC servem como template. Um agregado exemplar implementado corretamente vale mais que dez páginas de documentação abstrata.

			**P8 — Versionamento semântico da spec.** Mudanças no domain model, invariantes ou contratos são commits com mensagens que referenciam o BC afetado e o tipo de mudança. Permite que agentes saibam se o contexto mudou desde a última execução.

			**P9 — Cobertura auditável.** Para cada BC, deve ser possível verificar automaticamente: todo command tem pelo menos uma invariante? Todo event tem schema? Todo aggregate tem state model? O grafo de dependências entre BCs é acíclico? Os audit commands na camada de governança existem para isso.

			**P10 — Formal first, rationale only.** Todo artefato é definido como estrutura formal em CUE — e a estrutura formal é a única representação. Cada elemento formal carrega um campo `rationale`: uma frase curta que registra por que aquela regra existe. O rationale não descreve o que a regra faz, não é consumido por CI, e não tem compromisso de sincronia com a estrutura. A explicação humana é gerada sob demanda, não persistida.
			"""#
		rationale: "Os 10 princípios orientadores são as hipóteses fundadoras sobre como organizar uma spec AI-operated; colocá-los no README explicita o racional que está embutido em cada decisão estrutural do repo."
	}, {
		title: "Mapeamento: Níveis de Abstração → Arquivos no Repo"
		content: #"""
			Tabela de tradução entre os níveis clássicos de DDD e onde cada conceito vive neste repositório. Leia top-down (Nível 1 → 12) para entender o repo como um todo; leia por coluna (Localização) para entender o papel de um diretório específico.

			| Nível | Nome | Localização primária |
			|---|---|---|
			| 1 | Visão / Propósito do domínio | domain/domain-definition.cue, domain/business-model.cue |
			| 2 | Subdomínios | strategic/subdomains/ |
			| 3 | Bounded Contexts | contexts/{bc-code}/canvas.cue |
			| 4 | Context Map | strategic/context-map.cue |
			| 5 | Ubiquitous Language | domain/universal-glossary.cue (global) + contexts/{bc-code}/ubiquitous-language.cue (local) |
			| 6 | EventStorming | Absorvido nos artefatos derivados: commands/, events/, policies.cue, state-models.cue |
			| 7 | Capabilities / Invariantes | contexts/{bc-code}/invariants.cue (assertions formais + rationale) |
			| 8 | Aggregates / Entities / VOs | contexts/{bc-code}/domain-model.cue |
			| 9 | Contratos e Tipos | contexts/{bc-code}/schemas/*.cue, api.yaml, async-api.yaml, architecture/shared-schemas/ |
			| 10 | Ports & Adapters | contexts/{bc-code}/ports.cue, adapters.cue |
			| 11 | Aplicação / Workflows | contexts/{bc-code}/workflows/*.cue + architecture/cross-context-workflows/ |
			| 12 | Infra | architecture/infrastructure.cue, database-strategy.cue, security.cue |
			| — | Agentes de domínio | contexts/{bc-code}/agents/{agent}.cue + {agent}.governance.cue + architecture/agent-governance.cue (global) |
			| — | Contratos de consumo inter-BC | contexts/{bc-code}/schemas/interaction-contracts.cue + architecture/shared-schemas/agent-interaction-envelope.cue |
			| — | Incentive analysis | contexts/{bc-code}/canvas.cue (seção obrigatória do canvas) |
			| — | Threat modeling | contexts/{bc-code}/threat-model.cue + governance/red-team-protocol.cue |
			| — | Acumulação informacional | strategic/informational-flywheel.cue |
			| — | Decision log de agentes | architecture/shared-schemas/agent-decision-record.cue |
			| — | Assertion schema | architecture/shared-schemas/assertion-schema.cue (gramática formal com rationale) |
			| — | Ciclo de aprendizado | governance/spec-gap-protocol.cue + architecture/shared-schemas/spec-gap-event.cue |
			| — | Autorização do repo | Três tiers (Read/Propose/Decide) documentados neste README |
			| — | Governança | governance/ |
			| — | Configuração do agente | governance/claude/ (config.cue → CLAUDE.md derivado) |
			| — | Orquestração de IA | ai-orchestration/ (retrieval com prioridades, lifecycle, instructions) |
			| — | Testabilidade | contexts/{bc-code}/test-specs.cue + architecture/testing-strategy.cue + governance/validation-protocol.cue |
			| — | Observabilidade | contexts/{bc-code}/observability.cue + architecture/observability-strategy.cue |
			| — | Evolução de eventos | contexts/{bc-code}/schemas/_migrations/ + architecture/event-evolution.cue |
			| — | Recovery / Compensation | contexts/{bc-code}/failure-modes.cue + workflows/*.cue + architecture/compensation-patterns.cue |
			| — | Artifact schemas | architecture/artifact-schemas/ (schemas de validação para tipos de artefato) |
			| — | Design principles | architecture/design-principles.cue (13 princípios do sistema) |

			**Nota sobre o Nível 6 (EventStorming).** EventStorming é um método de descoberta, não um artefato de persistência. Seus outputs — events, commands, aggregates, policies, read models — são capturados nos arquivos táticos de cada BC. Diagramas resultantes de workshops podem ser armazenados como imagens de referência em `contexts/{bc-code}/eventstorming/`, mas não são a fonte de verdade. Os arquivos derivados são.
			"""#
		rationale: "Novos leitores chegam com modelo mental DDD canônico; a tabela de mapeamento reduz tempo de orientação de horas para minutos ao conectar conceito conhecido com localização concreta no repo."
	}]
}
