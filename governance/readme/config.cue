package readme

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// config.cue — Instância de #ReadmeConfig para mesh-spec.
//
// Stages 4a+4b de adr-050: tree.entries com 43 diretórios governados
// e sections com 15 narrativas consolidadas extraídas do README.md atual.
//
// Escopo da tree: cobre todo diretório que contém arquivo versionável
// (per ADR-051 check-readme-coevolution.sh). Inclui containers de
// instâncias (agents/, self-reviews/, task-specs/, work-events/,
// projections/) e containers de derivados (c4/views/, artifacts/lenses/)
// — cada container ganha entry própria com marcador conceitual no
// rationale (instâncias / derivados / source autoral / eventos
// append-only). Convenções sobre nomes de slug vivem no schema do
// tipo correspondente, não na tree do README.
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
				path:    "architecture/artifacts/governance/"
				purpose: "Instâncias de autonomy envelopes por domínio."
				conventions: [
					"Um arquivo por envelope; nome no formato {domain-slug}.governance.cue.",
					"Conteúdo instanciado, não schema nem protocolo cross-domain.",
				]
				rationale: "Container de instâncias: separar instâncias de governance de definições autorais cross-domain. Diretório reservado antecipadamente como slot canônico — pode conter apenas marcador de presença, mas a função permanente independe de quando os primeiros envelopes serão materializados."
			},
			{
				path:    "architecture/artifacts/lenses/"
				purpose: "Outputs produzidos pela aplicação de lenses analíticas em decisões concretas."
				conventions: [
					"Um arquivo por output; nome referencia a lens aplicada e o artefato analisado.",
					"Conteúdo derivado da execução de lens, não definição da lens.",
				]
				rationale: "Container de derivados: lenses em architecture/lenses/ são protocolos de raciocínio; seus outputs são instâncias materializadas aqui. Diretório reservado antecipadamente — outputs surgem on-demand quando agente aplica lens em decisão."
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
				path:    "architecture/c4/views/"
				purpose: "Views derivadas do modelo arquitetural C4."
				conventions: [
					"Arquivos gerados a partir de workspace.dsl via Structurizr CLI.",
					"Views derivadas nunca são editadas manualmente.",
					"Formatos de saída podem incluir .mmd, .png e outros exports do pipeline.",
				]
				rationale: "Container de derivados: separar views materializadas do source workspace.dsl impede que artefatos derivados sejam confundidos com a fonte autoral do modelo."
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
				path:    "architecture/production-guides/"
				purpose: "Production guides: instruções de produção executadas por agente antes de criar instância de cada tipo de artefato governado (simétricos a validation-prompts, que validam depois)."
				conventions: [
					"Nome no formato {schema-basename}.cue (1:1 com architecture/artifact-schemas/{schema-basename}.cue).",
					"Conformam com architecture/artifact-schemas/production-guide.cue.",
					"Cobertura universal por convenção: todo artifact-schema instanciável tem guide correspondente (adr-053).",
				]
				rationale: "Production guides são localização canônica única para 'como produzir instância de schema X' — orientação que não cabe no schema (process, gapPolicy, heuristics, doneCriteria) ganha lugar próprio."
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
				path:    "contexts/cmt/agents/"
				purpose: "Specs e governance envelopes dos agentes do BC Commitment Management."
				conventions: [
					"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
					"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
					"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
				]
				rationale: "Container de instâncias: agentes de domínio vivem dentro do BC porque dependem de canvas, invariants e schemas locais; separar spec de envelope mantém capacidade e autoridade auditáveis."
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
				path:    "contexts/ctr/agents/"
				purpose: "Specs e governance envelopes dos agentes do BC Contract & Terms Registry."
				conventions: [
					"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
					"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
					"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
				]
				rationale: "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
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
			{
				path:    "contexts/npm/agents/"
				purpose: "Specs e governance envelopes dos agentes do BC Network Participant Management."
				conventions: [
					"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
					"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
					"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue.",
				]
				rationale: "Container de instâncias: mesmo padrão dos demais BCs — localização por bounded context preserva autonomia operacional sem perder uniformidade estrutural."
			},
			// ── Domain (Layer 0) ──
			{
				path:    "domain/"
				purpose: "Layer 0 da espec: identidade do domínio (tese, outcomes, flywheel, atores)."
				conventions: [
					"domain-definition.cue é a tese da empresa; outros artefatos de domain/ referenciam.",
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
				path:    "governance/build-time/projections/"
				purpose: "Read models derivados do event stream de work governance."
				conventions: [
					"Um arquivo por projection; nome reflete o read model materializado.",
					"Conteúdo é derivado de work-events/ e nunca editado manualmente.",
					"Formato e integridade são governados pelos artefatos de build-time correspondentes.",
				]
				rationale: "Container de derivados: projections separam estado consultável da fonte de eventos e devem permanecer claramente distintas dos artefatos autorais que as definem."
			},
			{
				path:    "governance/build-time/self-reviews/"
				purpose: "Instâncias de self-review dos artefatos submetidos a quality gate."
				conventions: [
					"Um arquivo por artefato revisado; nome no formato {artifact-slug}.self-review.cue.",
					"Conforma com governance/build-time/self-review-report.cue.",
					"CI enforça presença via scripts/ci/check-self-review.sh.",
				]
				rationale: "Container de instâncias: self-reviews são evidência operacional do quality gate e devem permanecer agrupadas sem competir com os protocolos que as governam."
			},
			{
				path:    "governance/build-time/task-specs/"
				purpose: "Specs dos work items consumidos pelo motor de work governance."
				conventions: [
					"Um arquivo por work item; nome no formato wi-XXXXX.cue.",
					"_constraints.cue define invariants globais sobre task-specs.",
					"Conforma com o schema de task spec em governance/build-time/work-governance.cue.",
				]
				rationale: "Container de instâncias: task-specs são a entrada operacional do motor de work governance e devem permanecer separadas dos protocolos que governam sua execução."
			},
			{
				path:    "governance/build-time/work-events/"
				purpose: "Eventos append-only do event sourcing de work governance."
				conventions: [
					"Um arquivo por work item agregando seus eventos; nome no formato wi-XXXXX.cue.",
					"_constraints.cue define o shape dos eventos e invariants relacionais.",
					"Eventos committed não são editados retroativamente.",
				]
				rationale: "Container de eventos: o diretório torna explícito que o source de verdade do fluxo de trabalho é o histórico de eventos, não os read models derivados."
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
			{
				path:    "strategic/economic-model/"
				purpose: "Layer -1 (Economic Reality, ri-*) + Layer 1 (Economic Mechanisms, mech-*): foundation econômica do sistema (per adr-082 + adr-083). Layer -1 declara realidades adversariais não controladas; Layer 1 declara mecanismos que reduzem exploitability."
				conventions: [
					"Singleton instances: mesh-economic-assumptions.cue (Layer -1) + mesh-economic-mechanisms.cue (Layer 1).",
					"Prefix discipline Layer -1: ri-* reality invariants (DISTINCT de inv-* domain invariants); cap-adv-* capabilities; imp-* implications.",
					"Prefix discipline Layer 1: mech-* economic mechanisms (DISTINCT de mech-* subdomain mechanisms via #EconomicMechanismRef alias); rr-* residual risks.",
					"Reality invariants são propriedades do mundo NÃO tensionáveis (sistema sobrevive apesar de). Economic mechanisms reduzem exploitability — não eliminate, não solve.",
					"Honesty enforcement: cada mechanism MUST declare failure surface (falsePositiveRisks OR underspecifications OR residualRisks) per tq-emm-03 — hidden risk inválido por discipline.",
				]
				rationale: "2 layers canonicamente declarados: 'truths that constrain design but are not design decisions' (Layer -1 ri-*) + 'mechanisms reduce exploitability' (Layer 1 mech-*). Layer 1 protege Layer -1 realities. v1 sistema observa fraude → v2 sistema desincentiva fraude. Mechanism layer aguarda NIM bootstrap para Phase B cross-cutting refs + structural enforcement."
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
			| 1 | Visão / Propósito do domínio | domain/domain-definition.cue |
			| 2 | Subdomínios | strategic/subdomains/ |
			| 3 | Bounded Contexts | contexts/{bc-code}/canvas.cue |
			| 4 | Context Map | strategic/context-map.cue |
			| 5 | Ubiquitous Language | contexts/{bc-code}/ubiquitous-language.cue (local) |
			| 6 | EventStorming | Absorvido nos artefatos derivados: commands/, events/, policies.cue, state-models.cue |
			| 7 | Capabilities / Invariantes | contexts/{bc-code}/invariants.cue (assertions formais + rationale) |
			| 8 | Aggregates / Entities / VOs | contexts/{bc-code}/domain-model.cue |
			| 9 | Contratos e Tipos | contexts/{bc-code}/schemas/*.cue, api.yaml, async-api.yaml, architecture/shared-schemas/ |
			| 10 | Ports & Adapters | contexts/{bc-code}/ports.cue, adapters.cue |
			| 11 | Aplicação / Workflows | contexts/{bc-code}/workflows/*.cue + architecture/cross-context-workflows/ |
			| 12 | Infra | infraestrutura (planejado), database-strategy.cue, security.cue |
			| — | Agentes de domínio | contexts/{bc-code}/agents/{agent}.cue + {agent}.governance.cue + architecture/agent-governance.cue (global) |
			| — | Contratos de consumo inter-BC | contexts/{bc-code}/schemas/interaction-contracts.cue + architecture/shared-schemas/agent-interaction-envelope.cue |
			| — | Incentive analysis | contexts/{bc-code}/canvas.cue (seção obrigatória do canvas) |
			| — | Threat modeling | contexts/{bc-code}/threat-model.cue + protocolo de red-team (planejado) |
			| — | Acumulação informacional | flywheel informacional (planejado) |
			| — | Decision log de agentes | architecture/shared-schemas/agent-decision-record.cue |
			| — | Assertion schema | architecture/shared-schemas/assertion-schema.cue (gramática formal com rationale) |
			| — | Ciclo de aprendizado | protocolo de spec-gap (planejado) + architecture/shared-schemas/spec-gap-event.cue |
			| — | Autorização do repo | Três tiers (Read/Propose/Decide) documentados neste README |
			| — | Governança | governance/ |
			| — | Configuração do agente | governance/claude/ (config.cue → CLAUDE.md derivado) |
			| — | Orquestração de IA | ai-orchestration/ (retrieval com prioridades, lifecycle, instructions) |
			| — | Testabilidade | contexts/{bc-code}/test-specs.cue + estratégia de testes global (planejada) + protocolo de validação (planejado) |
			| — | Observabilidade | contexts/{bc-code}/observability.cue + estratégia de observabilidade global (planejada) |
			| — | Evolução de eventos | contexts/{bc-code}/schemas/_migrations/ + regras de evolução de eventos (planejado) |
			| — | Recovery / Compensation | contexts/{bc-code}/failure-modes.cue + workflows/*.cue + patterns de compensação globais (planejado) |
			| — | Artifact schemas | architecture/artifact-schemas/ (schemas de validação para tipos de artefato) |
			| — | Design principles | architecture/design-principles.cue (13 princípios do sistema) |

			**Nota sobre o Nível 6 (EventStorming).** EventStorming é um método de descoberta, não um artefato de persistência. Seus outputs — events, commands, aggregates, policies, read models — são capturados nos arquivos táticos de cada BC. Diagramas resultantes de workshops podem ser armazenados como imagens de referência em `contexts/{bc-code}/eventstorming/`, mas não são a fonte de verdade. Os arquivos derivados são.
			"""#
		rationale: "Novos leitores chegam com modelo mental DDD canônico; a tabela de mapeamento reduz tempo de orientação de horas para minutos ao conectar conceito conhecido com localização concreta no repo."
	}, {
		title: "Pipeline de Schemas (CUE → Artefatos Gerados)"
		content: #"""
			CUE é a source of truth única de todos os schemas e contratos compiláveis. Os `.cue` vivem em mesh-spec (`contexts/{bc-code}/schemas/`, artefatos `.cue` por BC, e `architecture/shared-schemas/`). Nenhum `.proto`, `.isl` ou `.json` é editado manualmente — todos são gerados no CI do mesh-runtime. A visão consolidada de todos os contratos do sistema é um artefato derivado (CI step que indexa os `.cue` distribuídos por BC), não source of truth.

			```
			 ┌─────────────┐     ┌──────────────────┐     ┌──────────────────────┐
			 │  mesh-spec   │     │  mesh-runtime CI │     │  mesh-runtime        │
			 │  .cue files  │────▸│  cue export      │────▸│  .proto  (codegen)   │
			 │  (source of  │     │  cue vet         │     │  .isl    (runtime)   │
			 │   truth)     │     │  pipelines       │     │  .json   (docs/spec) │
			 └─────────────┘     └──────────────────┘     └──────────────────────┘
			```

			Tipos compartilhados entre BCs (Money, CloudEvents envelope, IDs globais, agent decision record, agent interaction envelope, spec gap event, assertion schema) vivem em `architecture/shared-schemas/` e são importados nos `.cue` locais de cada BC via referência CUE.

			Amazon Ion governa a serialização de payloads com quatro regras canônicas documentadas em `architecture/shared-schemas/ion-rules.cue`:
			- **Ion-1 — Canonicalization.** Forma canônica para hashing e comparação.
			- **Ion-2 — SchemaRef dual.** Todo payload carrega referência ao schema (type + version).
			- **Ion-3 — Compatibility 3 camadas.** Backward, forward e full compatibility por schema.
			- **Ion-4 — Decimal normalization.** Decimais financeiros normalizados (sem trailing zeros espúrios).

			Money em REST JSON é sempre `type: string` (decimal string), conforme ADR-C4-2.11 §2.11.5. Em payloads Ion, Money usa o tipo nativo `decimal`. Eventos seguem o envelope CloudEvents; cada BC define seus `type` e `source` em `schemas/cloudevents.cue`.
			"""#
		rationale: "Pipeline CUE → artefatos gerados é o contrato mecânico que permite spec governar runtime; explicitar direção e regras Ion evita que consumidores inventem caminhos alternativos."
	}, {
		title: "Artifact Schemas — Validação de Conformidade"
		content: #"""
			O diretório `architecture/artifact-schemas/` contém schemas CUE que definem a estrutura válida para cada tipo de artefato no repositório. Todo `canvas.cue` de um BC deve conformar com `#Canvas`. Todo `invariants.cue` deve conformar com `#Invariant`. CI executa `cue vet` para validar conformidade.

			**Artifact schemas não são templates.** Um schema define estrutura e constraints — campos obrigatórios, tipos permitidos, relações. Um template seria um arquivo-starter com placeholders (TODOs) que se copia para começar. Em um repositório operado por agentes, templates são desnecessários: o agente lê o schema (sabe a estrutura válida), lê golden examples (sabe o que "bom" significa), lê o domínio (sabe o conteúdo), e gera a instância conformante.

			**Três mecanismos, cada um no seu lugar:**

			```
			architecture/artifact-schemas/           ← Schemas (validação CI, define estrutura válida)
			contexts/{bc}/golden-examples/           ← Exemplos reais aprovados (referência para agentes)
			(templates)                              ← Não existe (desnecessário em repo AI-operated)
			```

			Exemplo de uso:

			```cue
			import "mesh-spec/architecture/artifact-schemas"

			artifact_schemas.#Canvas & {
			    purpose: "Manages the lifecycle of economic commitments..."
			    capabilities: ["create-commitment", "approve-commitment"]
			    classification: "core"
			}
			```
			"""#
		rationale: "Distinção schema-vs-template é contraintuitiva para quem vem de ecossistemas com scaffolding; sem ela, agentes recriam templates e geram drift de estrutura."
	}, {
		title: "Spec → Testes (Testing Strategy)"
		content: #"""
			A spec não é documentação — é a fonte a partir da qual testes são gerados. Esta é potencialmente a contribuição de maior valor do repositório para um sistema AI-operated: artefatos formais produzem testes automaticamente, eliminando a lacuna entre "o domínio diz que X" e "o código garante que X".

			O `assertion-schema.cue` (em `architecture/shared-schemas/`) define a gramática formal: `#Assertion` (subject, variables, predicate + rationale), `#Variable` (name, source, filter), `#Predicate` (left, relation, right). Todo `invariants.cue`, `policies.cue` e `state-models.cue` importa esse schema. CUE é o container das assertions — não a engine de avaliação. Um gerador de testes no CI do mesh-runtime consome as assertions e produz código de teste. O padrão é o mesmo de CUE → `.proto`: CUE define estrutura, codegen produz artefato executável.

			A conexão entre artefatos da spec e tipos de teste é:

			```
			invariants.cue         → property-based tests (assertions formais: variáveis, relação, condição)
			state-models.cue       → FSM tests (transições formais: toda transição ilegal rejeitada)
			commands/{cmd}.cue     → contract tests (preconditions/postconditions formais)
			schemas/*.cue          → validation tests (payloads inválidos → rejeição; round-trip Ion ↔ CUE)
			policies.cue           → integration tests (trigger/condition/action formal → comando executado)
			failure-modes.cue      → chaos tests (trigger/dependency/fallback formais)
			workflows/{wf}.cue     → workflow tests (steps/compensation/timeouts formais)
			threat-model.cue       → adversarial tests (fonte formal: agent-governance + invariants)
			{agent}.governance.cue → gate tests (agente estocástico sem gate → rejeição)
			ports.cue              → adapter tests (todo port declarado tem adapter implementado)
			error-taxonomy.cue     → error tests (códigos únicos, categorização consistente)
			interaction-contracts  → contract tests (emissor sem campos obrigatórios → rejeição)
			```

			Cada BC documenta suas regras de geração em `test-specs.cue`. A estratégia global — incluindo como o assertion schema funciona e como geradores consomem estrutura formal — será definida na estratégia de testes global (planejada). O protocolo de execução — quando rodar, que cobertura mínima, como validar antes de merge — será definido no protocolo de validação (planejado).
			"""#
		rationale: "Testes-a-partir-da-spec é a proposta de valor central para sistemas AI-operated; sem explicitar o mapeamento artefato → tipo de teste, a geração fica implícita e não auditável."
	}, {
		title: "Contratos de Consumo entre BCs"
		content: #"""
			O schema CUE de um evento define a estrutura de dados que cruza a fronteira entre BCs. Mas quando um agente de scoring do BC de Network Intelligence (NTI) emite um evento consumido pelo agente de pricing do BC de Settlement (STL), o schema sozinho não basta. O receptor precisa saber quais campos são obrigatórios para sua decisão e quais garantias semânticas eles carregam.

			Os campos de contexto decisório — confidence, reasoning_category, data_sufficiency — pertencem ao event schema. São fatos que o emissor observou no momento da emissão. O `schemas/interaction-contracts.cue` não define campos novos — ele declara requisitos de consumo sobre campos que já existem no schema do evento: quais são obrigatórios para aquele receptor e quais garantias semânticas carregam.

			O `agent-decision-record.cue` é complementar: registra o que aconteceu após o fato (auditoria). O interaction contract define a expectativa antes do fato (contrato de consumo).

			**Ownership segue o context-map.** O `strategic/context-map.cue` já define o pattern de cada relação entre BCs (OHS/CF, Customer/Supplier, ACL). O interaction contract segue a mesma regra de ownership:

			| Pattern no context-map | Owner do interaction contract |
			|---|---|
			| OHS/CF (Open Host Service / Conformist) | Emissor (upstream) |
			| Customer/Supplier | Receptor (customer) |
			| ACL (Anti-Corruption Layer) | Receptor (downstream) |

			CI valida que: (1) todo campo referenciado no interaction contract existe no event schema, (2) todo event consumido por agente de outro BC tem interaction contract declarado, (3) o owner do contrato é consistente com o pattern no context-map.
			"""#
		rationale: "Schema de evento responde 'quais dados'; interaction contract responde 'quais são obrigatórios para mim'. Sem a distinção, cada receptor reimplementa validação e gera drift de expectativa."
	}, {
		title: "Contratos de Observabilidade"
		content: #"""
			Para um sistema AI-operated com trilha de auditoria completa, observabilidade não é infraestrutura opcional — é contrato. Cada BC declara em `observability.cue` quais métricas, logs e traces emite, com schemas tipados.

			O contrato de observabilidade inclui: métricas nomeadas com labels semânticos (não contadores genéricos), logs estruturados com schema (não texto livre), traces com contexto de domínio (qual aggregate, qual command, qual evento), e health checks semânticos (o agente de scoring está respondendo dentro do SLA, não apenas o container está up).

			Decisões de agentes de domínio são registradas com schema tipado (`architecture/shared-schemas/agent-decision-record.cue`): inputs, política aplicada, output, confiança, timestamp. Todo BC que possui agentes de domínio emite decision records como parte do contrato de observabilidade.

			A estratégia global — naming conventions de métricas, níveis de log obrigatórios, SLOs por tier de BC — será definida na estratégia de observabilidade global (planejada). O contrato local por BC é o `.cue` que pode ser validado: se o código de um BC não emite uma métrica declarada no contrato, o CI falha.
			"""#
		rationale: "Observabilidade como contrato (não infraestrutura) é virada conceitual em sistemas AI-operated; explicitar o contrato torna validável a correspondência código ↔ telemetria emitida."
	}, {
		title: "Ciclo de Aprendizado Runtime → Spec"
		content: #"""
			A spec é a autoridade e o runtime é subordinado. Mas o runtime inevitavelmente descobre informações que revelam lacunas: failure modes não previstos, anti-patterns emergentes, invariantes insuficientes, edge cases não documentados. Se a única forma de atualização for observação humana manual, cria-se um gargalo de governança que escala mal.

			O fluxo estruturado de evidência opera em três passos:

			1. **Detecção.** O runtime emite um spec-gap event estruturado (schema em `architecture/shared-schemas/spec-gap-event.cue`): tipo de lacuna, artefato afetado, referências a evidências no event log, hipótese, severidade.

			2. **Síntese.** Um agente de governança (tier Propose) consome a fila, agrupa por artefato afetado, analisa evidências e gera draft PR no mesh-spec com proposta de alteração.

			3. **Decisão humana.** O founder ou CODEOWNERS (tier Decide) revisa e decide se a spec precisa evoluir, como e quando.

			O protocolo completo — critérios de emissão, SLA de triagem, formato da proposta, mecanismo de priorização — será definido no protocolo de spec-gap (planejado).
			"""#
		rationale: "Autoridade unidirecional spec→runtime criaria gargalo de governança; o ciclo de aprendizado formaliza o canal reverso sem diluir autoridade — humano continua decidindo."
	}, {
		title: "Evolução de Eventos e Recovery"
		content: #"""
			**Evolução de eventos (upcasting/downcasting).** Ion-3 (compatibility em 3 camadas) define a política, mas não define a mecânica. Quando `CommitmentCreated v1` precisa virar v2, três coisas acontecem:

			1. O schema v2 é definido no `.cue` como uma nova versão.
			2. O upcaster — a transformação de v1 para v2 — é definido em `schemas/_migrations/commitment-created-v1-to-v2.cue`.
			3. Consumidores que ainda esperam v1 continuam recebendo v1 até migrarem, porque o sistema mantém compatibilidade backward por pelo menos uma versão.

			As regras globais — quantas versões são mantidas em paralelo, quando uma versão é aposentada, como consumidores são notificados de deprecação — serão definidas nas regras globais de evolução de eventos (planejado). Os upcasters concretos vivem dentro do BC que produz o evento.

			**Recovery e compensation em workflows.** Para um sistema financeiro, falha em saga é safety-critical. `contexts/{bc-code}/workflows/*.cue` documenta a compensation de cada workflow individual como estrutura formal, mas os patterns globais que governam como toda saga se comporta sob falha serão definidos nos patterns de compensação globais (planejado).

			Esse artefato cobre: idempotência como requisito universal (reprocessar nunca duplica), compensation como evento (não como rollback — append-only), dead letter como escalação (não como descarte), timeout com semântica de negócio (não apenas técnico), e escalação humana como último recurso com critérios explícitos de quando acionar. Cada `workflow.cue` referencia quais patterns aplica e documenta seus failure modes específicos em `failure-modes.cue`.
			"""#
		rationale: "Evolução de eventos e recovery compartilham a mesma mecânica conceitual (regra global + instância local por BC); consolidá-los evita duplicar a mesma estrutura de seção duas vezes."
	}, {
		title: "Governança de Agentes"
		content: #"""
			Esta seção consolida três responsabilidades que operam em conjunto quando um agente executa tarefa no repo: o que o agente carrega de contexto, como seu ciclo de vida se estrutura, e onde termina a sua autonomia.

			**Gestão de orçamento de contexto.** O context window do modelo é um recurso escasso que precisa ser gerenciado explicitamente. Em um BC maduro é plausível que existam trinta ou mais artefatos de especificação. Um agente que precise implementar ou modificar um command pode ultrapassar dezenas de milhares de tokens apenas ao carregar documentos de referência.

			A responsabilidade é separada em duas camadas. **Spec** define prioridades de injeção por tipo de tarefa em `retrieval-patterns.cue`. Artefatos `critical` — invariants, state-models, schemas do command — são sempre injetados integralmente. Artefatos `important` — policies, error-taxonomy, anti-patterns — se o orçamento permitir. Artefatos `supplementary` — golden-examples, observability, coding-conventions — apenas se sobrar espaço. **Orquestrador** (mesh-runtime) computa dinamicamente token estimates, summaries sob demanda e degradação controlada. Quando omite ou resume, registra no contexto do agente — o agente sabe que opera com contexto parcial e pode sinalizar incerteza.

			**Ciclo de vida do agente de desenvolvimento.** Prompt-templates em `ai-orchestration/agent-instructions/` especificam tarefas atômicas, mas agentes operam em ciclos: `receive-task → load-context → plan → implement → self-validate → submit → respond-to-review`. O ciclo completo (planejado) cobre:

			1. **Receive task.** Task description com escopo e critérios de aceitação.
			2. **Load context.** `retrieval-patterns.cue` determina quais artefatos injetar; orquestrador computa budget e aplica degradação. O agente sabe quais artefatos foram resumidos ou omitidos.
			3. **Plan.** Decomposição explícita em sub-passos antes de implementar.
			4. **Implement.** `agent-instructions/` fornece template por tipo de sub-tarefa.
			5. **Self-validate.** Antes de submeter: invariants, state-models, test-specs, interaction-contracts. Falha = não submeter.
			6. **Submit.** Com contexto sobre quais artefatos foram consultados e quais decisões ocorreram com contexto parcial.
			7. **Respond to review.** Feedback → retorna ao passo 3 se necessário.

			Prescritivo para artefatos financeiros (invariantes de pagamento, posting rules, settlement). Advisory para os demais.

			**Fronteira estocástico/determinístico.** Para um sistema AI-operated que processa transações financeiras, a separação entre recomendação e execução é safety-critical. Agentes estocásticos (IA) nunca emitem comandos financeiros diretamente — eles recomendam. Um gate determinístico valida a recomendação e executa se e somente se ela passa por todas as invariantes.

			A governança de agentes opera em dois níveis (ADR-037): `architecture/agent-governance.cue` define defaults globais (autonomia, escalation, blast radius, drift detection, auditoria) e cada agente recebe um envelope em `contexts/{bc}/agents/{name}.governance.cue` que especializa esses defaults com lifecycle stage, escalation routing, autonomy overrides e calibração. Sem esses artefatos, a separação entre recomendação e execução fica implícita no código, violando o princípio de que tudo é especificado antes de implementado (P10 do `design-principles.cue`: agentes estocásticos recomendam, gates determinísticos validam).
			"""#
		rationale: "Orçamento de contexto, lifecycle e fronteira estocástico/determinístico são três facetas do mesmo problema — como agentes operam com disciplina — e juntar em uma seção mostra a coerência dos três mecanismos."
	}, {
		title: "Convenções de Nomenclatura"
		content: #"""
			Nomes de arquivo e diretório em inglês (exceto termos de domínio já canonizados no universal glossary ou na ubiquitous language do BC). Esta seção é a fonte canônica — CLAUDE.md aponta aqui.

			- Diretórios de bounded context: código lowercase (ex: `cmt`, `ctr`, `idc`, `npm`). Nome completo vive no `canvas.cue` de cada BC.
			- Arquivos de command: `{verbo}-{substantivo}.cue` — ex: `approve-commitment.cue`.
			- Arquivos de event: `{substantivo}-{particípio}.cue` — ex: `commitment-approved.cue`.
			- Arquivos de ADR: `{nnn}-{slug}.cue` — ex: `001-postgres-per-module.cue`.
			- Arquivos de schema (CUE): `{nome-do-tipo}.cue` — ex: `commitment-created-event.cue`.
			- Arquivos de glossário: `ubiquitous-language.cue` por BC.
			- Arquivos de workflow: `{nome-do-processo}.cue` — ex: `commitment-fulfillment-flow.cue`.
			- Arquivos de migration: `{event-slug}-v{N}-to-v{N+1}.cue` — ex: `commitment-created-v1-to-v2.cue`.
			- Arquivos de agente: `{agent-slug}.cue` — ex: `scoring-agent.cue`.
			- Arquivos de contrato de consumo: `interaction-contracts.cue` (por BC, dentro de `schemas/`).
			- Arquivos de domain story: `{story-slug}.cue` — ex: `supplier-delivers-materials.cue`.
			- Arquivos de golden example: `{example-slug}.cue` — ex: `commitment-aggregate-impl.cue`.
			- Arquivos de artifact schema: `{artifact-type}.cue` — ex: `canvas.cue`, `command.cue`.
			- Artefatos universais: todo artefato cross-context leva "universal" no nome.
			"""#
		rationale: "Convenção de nomes é consumida por agentes ao gerar arquivos novos; manter fonte única no README (apontada por CLAUDE.md) evita que cada protocolo reinvente o padrão."
	}, {
		title: "Critérios de Completude por Bounded Context"
		content: #"""
			Um BC é considerado "spec-complete" quando todos os critérios declarados em `governance/bounded-context-completeness.cue` são satisfeitos. O artefato machine-readable é a fonte de verdade — CI valida automaticamente, agentes consomem para planejar trabalho faltante, e evolução dos critérios é rastreada via ADR.

			Em alto nível, completude cobre sete dimensões:

			1. **Identidade.** `canvas.cue` com propósito, capabilities, classificação, custos de transação eliminados e incentive analysis. `context-dependencies.cue` derivado de `context-map.cue`. `ubiquitous-language.cue` local.
			2. **Modelo de domínio.** `domain-model.cue`, `invariants.cue` (ao menos uma assertion formal por aggregate), `state-models.cue` para aggregates com lifecycle.
			3. **Contratos.** Todo command em `commands/{cmd}.cue` com pré/pós-condições e `invariant_refs`. Todo event em `events/{event}.cue` com schema CUE, envelope CloudEvents e lista de consumidores. `schemas/` com as 8 famílias ContractGate aplicáveis. `interaction-contracts.cue` se o BC consome eventos de outros BCs.
			4. **Aplicação.** `policies.cue` com trigger/condition/action formal. `projections.cue` com read models. `ports.cue` com interfaces do domínio. `workflows/` com steps, compensation e timeouts formais.
			5. **Qualidade e padrão para IA.** `anti-patterns.cue` com ao menos 3 restrições. `coding-conventions.cue`. `error-taxonomy.cue` com códigos únicos. Pelo menos 1 `golden-example`.
			6. **Agentes (quando aplicável).** `agents/{agent}.cue` e `agents/{agent}.governance.cue` com envelope per-agent.
			7. **Operação e superfícies.** `api.yaml` ou `async-api.yaml` conforme superfície. `test-specs.cue` referenciando assertions formais. `observability.cue`. `failure-modes.cue`. `threat-model.cue`. `_migrations/` para eventos v2+. ADRs locais em `adrs/` para decisões não-triviais.

			A lista exaustiva, o formato machine-readable e as regras de validação vivem exclusivamente em `governance/bounded-context-completeness.cue` — este README mantém apenas o mapa conceitual para orientar leitura humana.
			"""#
		rationale: "Checklist exaustivo pertence ao machine-readable (P0: zero duplicação); manter aqui apenas o mapa conceitual evita drift entre README e governance/ sem perder função de orientação para novos leitores."
	}, {
		title: "Ordem de Criação Recomendada"
		content: #"""
			Ordem sugerida para bootstrap de um repositório de especificação do zero. Ordem reflete dependências conceituais: cada etapa consome artefatos criados nas anteriores.

			1. Criar repositório mesh-spec com estrutura de diretórios vazia + `README.md` raiz.
			2. Criar `architecture/artifact-schemas/` — schemas de validação para todos os tipos de artefato (`#Canvas`, `#Command`, `#Event`, etc.).
			3. Criar `architecture/design-principles.cue` — 13 princípios de design em 5 grupos (`#Foundation`, `#StructuralInvariants`, `#DesignPhilosophy`, `#SystemNature`, `#Governance`). Precede `domain/` porque `domain-definition.cue` referencia os princípios.
			4. Criar `domain/` — `domain-definition.cue`.
			5. Criar `strategic/` — subdomínios em `.cue`, `context-map.cue`, `informational-flywheel.cue`.
			6. Criar `contexts/cmt/` — primeiro BC (Economic Commitment Lifecycle, Minimum Economic Loop).
			7. Criar `architecture/` (restante) — ADRs globais em `.cue`, `agent-universal-principles.cue`, C4, shared schemas (incluindo `assertion-schema.cue` com rationale, `agent-interaction-envelope.cue`, `spec-gap-event.cue`), error taxonomy global, `testing-strategy.cue`.
			8. Criar `governance/` — `wave-plan.cue`, `red-team-protocol.cue`, `spec-gap-protocol.cue`, `audit-commands.cue`, `validation-protocol.cue`.
			9. Criar `ai-orchestration/` — `retrieval-patterns.cue` com prioridades, `dependency-graph.cue`, `agent-lifecycle.cue`, `agent-instructions/`.
			10. Validar: um agente consegue implementar um agregado do CMT usando apenas o repo? A self-validation funciona?
			11. Iterar para os demais BCs por ordem de `wave-plan.cue`.
			"""#
		rationale: "Ordem de bootstrap captura dependências conceituais que não são óbvias sem o repo existir; documentar explicitamente permite reconstruir o padrão em futuros repos e validar retrospectivamente o caminho percorrido."
	}]
}
