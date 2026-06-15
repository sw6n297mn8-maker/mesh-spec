package readme

// tree-generated.cue — DERIVADO. Gerado por scripts/ci/generate-repo-tree.py
// a partir dos _meta.cue (#DirectoryMeta) por diretório + scan do filesystem.
// NÃO editar à mão; regenerar via 'make sync-readme' (ou o gerador direto). (adr-115)
//
// treeAscii vive fora de config.tree porque #ReadmeConfig não declara campo
// 'ascii'; treeEntries alimenta config.tree.entries (#DirectoryNote).

treeAscii: """
	mesh-spec/
	├── ai-orchestration/            # Layer 5 da espec: como montar contexto certo para tarefa certa dentro do orçamento de tokens.
	│   └── agent-instructions/      # Prompt-templates por tarefa recorrente (implementar agregado, expor API, gerar testes, evoluir evento).
	├── architecture/                # Layer 3 da espec: decisões arquiteturais globais que não pertencem a nenhum BC individual.
	│   ├── adrs/                    # ADRs globais do sistema (stack, patterns, deploy strategy, protocolos cross-context).
	│   ├── agent-probes/            # Protocolo agent-probe (Ciclo 4) e os probe-records append-only por canvas — validação semântica advisory que dá um canvas fechado a um agente limpo e trata cada buraco como defeito de spec.
	│   ├── artifact-schemas/        # Schemas de validação para cada tipo de artefato instanciado no repo (#Canvas, #ADR, #Lens, etc.).
	│   ├── artifacts/               # Instâncias de artefatos operacionais cross-context (governance envelopes, lenses produzidos).
	│   │   ├── governance/          # Instâncias de autonomy envelopes por domínio.
	│   │   └── lenses/              # Outputs produzidos pela aplicação de lenses analíticas em decisões concretas.
	│   ├── c4/                      # Diagramas C4 do sistema (Structurizr DSL como source, views derivadas em .mmd/.png).
	│   │   └── views/               # Views derivadas do modelo arquitetural C4.
	│   ├── conventions/             # Convenções arquiteturais condicionais a capability flags do BC (API sync/async, etc.).
	│   ├── cross-context-workflows/ # Processos que atravessam múltiplos bounded contexts (ex: commitment lifecycle).
	│   ├── deferred-decisions/      # Deferimentos conscientes governados: decisões explícitas de não resolver agora, com trade-off articulado e condição codificada de revisita (per adr-062).
	│   ├── lenses/                  # Lenses analíticas: protocolos de raciocínio para domínios especializados (economia, segurança, crédito, AI).
	│   ├── production-guides/       # Production guides: instruções de produção executadas por agente antes de criar instância de cada tipo de artefato governado (simétricos a validation-prompts, que validam depois).
	│   ├── shared-schemas/          # Schemas compartilhados entre BCs (Money canônico, CloudEvents envelope, assertions formais, Ion rules).
	│   ├── shared-types/            # Tipos reutilizáveis entre artifact-schemas (#StrategicClassification, #VerticalApplicability).
	│   ├── structural-checks/       # Checks estruturais determinísticos executados pós-commit como gate (P10).
	│   ├── tension-log/             # Tensões arquiteturais: fricções cross-artifact que não são defeito de nenhum lado individual.
	│   └── validation-prompts/      # Prompts de design review advisory executados por agente isolado pós-commit.
	├── contexts/                    # Layer 2 da espec: bounded contexts autocontidos, cada um um pacote completo.
	│   ├── bdg/                     # Bounded Context Budget & Approval: verifica cobertura orçamentária de compromissos formalizados em CMT e emite o gate canônico de aprovação que habilita a progressão do commitment lifecycle.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Budget & Approval.
	│   ├── bkr/                     # Bounded Context Banking Rails & Settlement: liquidação física via rails bancários (Pix/SPI, TED/STR, boleto, SWIFT) sob autorização upstream — boundary entre a Mesh e o sistema regulado pelo Bacen.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Banking Rails & Settlement.
	│   ├── cmt/                     # Bounded Context Commitment Management: gestão do ciclo de vida de compromissos entre participantes.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Commitment Management.
	│   ├── ctr/                     # Bounded Context Contract & Terms Registry: registro versionado de contratos e cláusulas canônicas.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Contract & Terms Registry.
	│   ├── dlv/                     # Bounded Context Delivery & Verification: verifica execução operacional contra critérios versionados acordados em CMT e decide deterministicamente a suficiência de evidência para progressão econômica.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Delivery & Verification.
	│   ├── idc/                     # Bounded Context Identity & Data Governance: identidade de participantes e governança de dados pessoais (LGPD, integridade criptográfica).
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Identity & Data Governance.
	│   ├── inv/                     # Bounded Context Invoicing: materializa a obrigação de faturamento (InvoiceIssued) e o direito creditório a partir de DeliveryVerified, sob regime fiscal regulado determinístico.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Invoicing.
	│   ├── npm/                     # Bounded Context Network Participant Management: cadastro e lifecycle de participantes da rede Mesh.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Network Participant Management.
	│   ├── p2p/                     # Bounded Context Procure-to-Pay: emite Purchase Orders sob autoridade de sourcing pré-existente e faz hand-off da demanda formalizada para CMT — gateway entre sourcing (SSC) e compromisso.
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Procure-to-Pay.
	│   ├── rew/                     # Bounded Context Risk Engine & Risk Observability: avaliação de risco e elegibilidade como camada derivada da operação verificada da rede, consolidando sinais para BCs consumidores (SCF, CMT e outros).
	│   │   └── agents/              # Specs e governance envelopes dos agentes do BC Risk Engine & Risk Observability.
	│   └── ssc/                     # Bounded Context Strategic Sourcing & Category: decide qual fornecedor atende qual categoria via regras determinísticas sobre sinais estruturados (NPM, RFQ, respostas); início do macrofluxo Mesh.
	│       └── agents/              # Specs e governance envelopes dos agentes do BC Strategic Sourcing & Category.
	├── domain/                      # Layer 0 da espec: identidade do domínio (tese, outcomes, flywheel, atores).
	├── governance/                  # Layer 4 da espec: governança e qualidade (estrutura do repo, princípios operacionais, protocolos).
	│   ├── build-time/              # Especificações de build-time: work governance, quality-gate, self-review, task-specs.
	│   │   ├── projections/         # Read models derivados do event stream de work governance.
	│   │   ├── self-reviews/        # Instâncias de self-review dos artefatos submetidos a quality gate.
	│   │   ├── task-specs/          # Specs dos work items consumidos pelo motor de work governance.
	│   │   └── work-events/         # Eventos append-only do event sourcing de work governance.
	│   ├── claude/                  # Source of truth das regras comportamentais do agente (CLAUDE.md é artefato derivado).
	│   └── readme/                  # Source of truth da estrutura do README.md (README.md é artefato derivado).
	└── strategic/                   # Layer 1 da espec: design estratégico (subdomínios, context map, flywheel informacional, domain stories).
	    ├── domain-stories/          # Fluxos de negócio narrados como sequências ator → ação → work item.
	    ├── economic-model/          # Layer -1 (Economic Reality, ri-*) + Layer 1 (Economic Mechanisms, mech-*): foundation econômica (adr-082/083). Layer -1 declara realidades adversariais; Layer 1, mecanismos que reduzem exploitability.
	    └── subdomains/              # Classificação de subdomínios (Core/Supporting/Generic), complexidade, volatilidade, propósito.
	"""

treeEntries: [
	{
		"conventions": [
			"retrieval-patterns.cue, dependency-graph.cue e agent-lifecycle.cue são top-level do diretório.",
			"Prompt-templates em ai-orchestration/agent-instructions/."
		],
		"path": "ai-orchestration",
		"purpose": "Layer 5 da espec: como montar contexto certo para tarefa certa dentro do orçamento de tokens.",
		"rationale": "Orquestração de IA é problema que a literatura DDD não endereça; separar em layer própria evita poluir Layers 0-4 com preocupações de runtime estocástico."
	},
	{
		"conventions": [
			"Um arquivo por tarefa; nome no formato verbo-substantivo (implement-aggregate.cue).",
			"Cada template referencia artefatos source da spec, nunca duplica conteúdo."
		],
		"path": "ai-orchestration/agent-instructions",
		"purpose": "Prompt-templates por tarefa recorrente (implementar agregado, expor API, gerar testes, evoluir evento).",
		"rationale": "Templates reutilizáveis por tarefa garantem consistência de execução e reduzem drift entre sessões de agente."
	},
	{
		"conventions": [
			"Artefatos cross-context (ADRs globais, schemas, lenses, princípios) vivem aqui.",
			"design-principles.cue é top-level; demais artefatos em subdiretórios por tipo."
		],
		"path": "architecture",
		"purpose": "Layer 3 da espec: decisões arquiteturais globais que não pertencem a nenhum BC individual.",
		"rationale": "Concentrar decisões que afetam múltiplos BCs em um só lugar evita espalhar conhecimento transversal pelas pastas de contexto."
	},
	{
		"conventions": [
			"Formato adr-NNN-slug.cue com numeração contínua e incremental.",
			"Cada ADR conforma com architecture/artifact-schemas/adr.cue.",
			"Supersession atualiza os dois ADRs no mesmo commit (ADR novo + status do antigo)."
		],
		"path": "architecture/adrs",
		"purpose": "ADRs globais do sistema (stack, patterns, deploy strategy, protocolos cross-context).",
		"rationale": "ADR é a forma canônica de registrar decisão com contexto, alternativas consideradas e consequências — histórico imutável evita perda de justificativa."
	},
	{
		"conventions": [
			"protocol.cue — instância singleton de #AgentProbeProtocol.",
			"records/<bc>.cue — instância de #AgentProbeRecord, 1 por canvas probado."
		],
		"path": "architecture/agent-probes",
		"purpose": "Protocolo agent-probe (Ciclo 4) e os probe-records append-only por canvas — validação semântica advisory que dá um canvas fechado a um agente limpo e trata cada buraco como defeito de spec.",
		"rationale": "Co-localiza o protocolo singleton e seus registros (records/) num lar canônico (P0), em vez de dispersá-los; o mecanismo de probe é distinto das camadas de gate (structural-checks) e de advisory por-tipo (validation-prompts)."
	},
	{
		"conventions": [
			"Um arquivo por tipo de artefato; nome em singular kebab-case (canvas.cue, adr.cue).",
			"Schemas definem shape + rationale + location + qualityCriteria.",
			"CI valida que toda instância do tipo conforma com seu schema."
		],
		"path": "architecture/artifact-schemas",
		"purpose": "Schemas de validação para cada tipo de artefato instanciado no repo (#Canvas, #ADR, #Lens, etc.).",
		"rationale": "Schemas são meta-nível: governam validade de instâncias. Centralizar em um diretório permite discovery e auditoria de cobertura por tipo."
	},
	{
		"conventions": [
			"artifacts/governance/ contém autonomy envelopes.",
			"artifacts/lenses/ reservado para outputs produzidos pelas lenses analíticas."
		],
		"path": "architecture/artifacts",
		"purpose": "Instâncias de artefatos operacionais cross-context (governance envelopes, lenses produzidos).",
		"rationale": "Separar instâncias cross-context de schemas deixa claro que conteúdo aqui é produto de aplicação, não meta-definição."
	},
	{
		"conventions": [
			"Um arquivo por envelope; nome no formato {domain-slug}.governance.cue.",
			"Conteúdo instanciado, não schema nem protocolo cross-domain."
		],
		"path": "architecture/artifacts/governance",
		"purpose": "Instâncias de autonomy envelopes por domínio.",
		"rationale": "Container de instâncias: separar instâncias de governance de definições autorais cross-domain. Diretório reservado antecipadamente como slot canônico — pode conter apenas marcador de presença, mas a função permanente independe de quando os primeiros envelopes serão materializados."
	},
	{
		"conventions": [
			"Um arquivo por output; nome referencia a lens aplicada e o artefato analisado.",
			"Conteúdo derivado da execução de lens, não definição da lens."
		],
		"path": "architecture/artifacts/lenses",
		"purpose": "Outputs produzidos pela aplicação de lenses analíticas em decisões concretas.",
		"rationale": "Container de derivados: lenses em architecture/lenses/ são protocolos de raciocínio; seus outputs são instâncias materializadas aqui. Diretório reservado antecipadamente — outputs surgem on-demand quando agente aplica lens em decisão."
	},
	{
		"conventions": [
			"workspace.dsl é o source of truth; views/ contém derivados.",
			"Diagramas nunca editados no formato renderizado — regenerados do DSL."
		],
		"path": "architecture/c4",
		"purpose": "Diagramas C4 do sistema (Structurizr DSL como source, views derivadas em .mmd/.png).",
		"rationale": "C4 provê linguagem visual compartilhada para arquitetura; manter DSL como source mantém versionamento textual auditável."
	},
	{
		"conventions": [
			"Arquivos gerados a partir de workspace.dsl via Structurizr CLI.",
			"Views derivadas nunca são editadas manualmente.",
			"Formatos de saída podem incluir .mmd, .png e outros exports do pipeline."
		],
		"path": "architecture/c4/views",
		"purpose": "Views derivadas do modelo arquitetural C4.",
		"rationale": "Container de derivados: separar views materializadas do source workspace.dsl impede que artefatos derivados sejam confundidos com a fonte autoral do modelo."
	},
	{
		"conventions": [
			"Cada convenção declara condição de ativação (ex: hasSyncSurface).",
			"CI valida conformidade apenas quando condição é satisfeita no BC."
		],
		"path": "architecture/conventions",
		"purpose": "Convenções arquiteturais condicionais a capability flags do BC (API sync/async, etc.).",
		"rationale": "Convenção condicional evita impor regra universal a BCs que não têm a capability; flexibilidade sem perder auditoria."
	},
	{
		"conventions": [
			"Cada workflow documenta BCs participantes e eventos trocados.",
			"Conformam com architecture/artifact-schemas/cross-context-flow.cue."
		],
		"path": "architecture/cross-context-workflows",
		"purpose": "Processos que atravessam múltiplos bounded contexts (ex: commitment lifecycle).",
		"rationale": "Workflows cross-context não pertencem a nenhum BC individual; alocar em architecture/ preserva ownership distribuído dos BCs."
	},
	{
		"conventions": [
			"Nome no formato def-NNN-slug.cue com numeração contínua e incremental.",
			"Conformam com architecture/artifact-schemas/deferred-decision.cue.",
			"Status inicial open; lifecycle avaliado por scripts/ci/evaluate-deferred-triggers.sh (runner não muta arquivos)."
		],
		"path": "architecture/deferred-decisions",
		"purpose": "Deferimentos conscientes governados: decisões explícitas de não resolver agora, com trade-off articulado e condição codificada de revisita (per adr-062).",
		"rationale": "Separar deferimento consciente de prose 'Known gaps' em ADRs e de WIs rotineiros torna a dívida deliberada rastreável e sujeita a trigger — evita virar dumping ground de débito técnico genérico."
	},
	{
		"conventions": [
			"Nome no formato lens-slug.cue.",
			"Cada lens declara critérios de ativação e protocolo de raciocínio.",
			"Agente referencia a lens aplicada no rationale do artefato produzido."
		],
		"path": "architecture/lenses",
		"purpose": "Lenses analíticas: protocolos de raciocínio para domínios especializados (economia, segurança, crédito, AI).",
		"rationale": "Lenses expandem capacidade analítica do agente sem inflar princípios universais; ativação condicional garante custo cognitivo apenas quando relevante."
	},
	{
		"conventions": [
			"Nome no formato {schema-basename}.cue (1:1 com architecture/artifact-schemas/{schema-basename}.cue).",
			"Conformam com architecture/artifact-schemas/production-guide.cue.",
			"Cobertura universal por convenção: todo artifact-schema instanciável tem guide correspondente (adr-053)."
		],
		"path": "architecture/production-guides",
		"purpose": "Production guides: instruções de produção executadas por agente antes de criar instância de cada tipo de artefato governado (simétricos a validation-prompts, que validam depois).",
		"rationale": "Production guides são localização canônica única para 'como produzir instância de schema X' — orientação que não cabe no schema (process, gapPolicy, heuristics, doneCriteria) ganha lugar próprio."
	},
	{
		"conventions": [
			"Um arquivo por schema; uso cross-BC justifica presença aqui.",
			"Schemas locais a um BC vivem em contexts/{bc}/schemas/, nunca aqui."
		],
		"path": "architecture/shared-schemas",
		"purpose": "Schemas compartilhados entre BCs (Money canônico, CloudEvents envelope, assertions formais, Ion rules).",
		"rationale": "Schemas usados por mais de um BC ganham localização canônica única; duplicação entre BCs seria drift por construção."
	},
	{
		"conventions": [
			"Tipos de baixo nível usados por múltiplos schemas.",
			"Não contém instâncias; apenas definições de tipo."
		],
		"path": "architecture/shared-types",
		"purpose": "Tipos reutilizáveis entre artifact-schemas (#StrategicClassification, #VerticalApplicability).",
		"rationale": "Extrair tipos compartilhados evita que cada artifact-schema redefina os mesmos tipos — previne drift de definição."
	},
	{
		"conventions": [
			"Um arquivo por tipo de artefato coberto; nome casa o tipo (canvas.cue cobre #Canvas).",
			"4 kinds suportados: required-block, reference-exists, same-artifact-consistency, conditional-file-presence.",
			"Apenas structural-checks podem bloquear o fluxo; validation-prompts são advisory."
		],
		"path": "architecture/structural-checks",
		"purpose": "Checks estruturais determinísticos executados pós-commit como gate (P10).",
		"rationale": "Gate determinístico separado de revisão semântica é consequência de P10 — LLM recomenda, regra bloqueia."
	},
	{
		"conventions": [
			"Nome no formato ten-NNN-slug.cue.",
			"Cada tensão referencia artefatos em tensão e descreve por que não é defeito de um deles.",
			"Conformam com architecture/artifact-schemas/tension-entry.cue."
		],
		"path": "architecture/tension-log",
		"purpose": "Tensões arquiteturais: fricções cross-artifact que não são defeito de nenhum lado individual.",
		"rationale": "Registrar tensões torna explícita fricção estrutural que seria perdida se tratada como bug isolado em cada lado."
	},
	{
		"conventions": [
			"Nome no formato validate-{artifactType}.cue.",
			"Findings são recomendações, nunca veredito de gate (P10).",
			"Matching via matchPatterns declarados em cada prompt."
		],
		"path": "architecture/validation-prompts",
		"purpose": "Prompts de design review advisory executados por agente isolado pós-commit.",
		"rationale": "Revisão semântica complementa gate estrutural cobrindo dimensões interpretativas — separar prompts de checks preserva a categorização."
	},
	{
		"conventions": [
			"Um subdiretório por BC, nome lowercase de 3 letras (ex.: cmt, ssc, bkr).",
			"Cada BC contém canvas, invariants, commands, events, workflows e demais artefatos declarados em governance/bounded-context-completeness.cue."
		],
		"path": "contexts",
		"purpose": "Layer 2 da espec: bounded contexts autocontidos, cada um um pacote completo.",
		"rationale": "Autocontenção do BC é o que permite paralelizar trabalho entre agentes — dependências cross-BC passam por contratos explícitos em strategic/context-map.cue."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/bdg",
		"purpose": "Bounded Context Budget & Approval: verifica cobertura orçamentária de compromissos formalizados em CMT e emite o gate canônico de aprovação que habilita a progressão do commitment lifecycle.",
		"rationale": "Isolar o gate orçamentário em BC próprio evita que ele fique diluído entre CMT (formalização) e a execução financeira — owner único do estado de comprometimento orçamentário e das regras de alçada."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/bdg/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Budget & Approval.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/bkr",
		"purpose": "Bounded Context Banking Rails & Settlement: liquidação física via rails bancários (Pix/SPI, TED/STR, boleto, SWIFT) sob autorização upstream — boundary entre a Mesh e o sistema regulado pelo Bacen.",
		"rationale": "Liquidação física toca regulação Bacen/SPB e responsabilidade jurídica de instituição autorizada; BC dedicado isola o boundary regulado da lógica financeira proprietária da Mesh — BKR não decide mérito econômico."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/bkr/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Banking Rails & Settlement.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/cmt",
		"purpose": "Bounded Context Commitment Management: gestão do ciclo de vida de compromissos entre participantes.",
		"rationale": "Commitment é o centro operacional do sistema Mesh; isolamento em BC próprio permite evolução independente do vocabulário de compromissos."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/cmt/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Commitment Management.",
		"rationale": "Container de instâncias: agentes de domínio vivem dentro do BC porque dependem de canvas, invariants e schemas locais; separar spec de envelope mantém capacidade e autoridade auditáveis."
	},
	{
		"conventions": [
			"Versionamento de contratos é backward-compatible por construção; quebra exige supersession.",
			"Cláusulas são referenciadas por outros BCs via IDs estáveis."
		],
		"path": "contexts/ctr",
		"purpose": "Bounded Context Contract & Terms Registry: registro versionado de contratos e cláusulas canônicas.",
		"rationale": "Separar ctr como BC dedicado evita que cada BC consumidor redefina termos contratuais — fonte canônica única para obrigações jurídicas."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/ctr/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Contract & Terms Registry.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/dlv",
		"purpose": "Bounded Context Delivery & Verification: verifica execução operacional contra critérios versionados acordados em CMT e decide deterministicamente a suficiência de evidência para progressão econômica.",
		"rationale": "Verificação determinística de evidência é responsabilidade distinta da formalização (CMT) e da execução; BC próprio mantém critérios versionados e decisões idempotentes/replay-able auditáveis."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/dlv/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Delivery & Verification.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"Event log com integridade criptográfica end-to-end.",
			"Dados pessoais governados por políticas declaradas aqui; outros BCs consultam, não redefinem."
		],
		"path": "contexts/idc",
		"purpose": "Bounded Context Identity & Data Governance: identidade de participantes e governança de dados pessoais (LGPD, integridade criptográfica).",
		"rationale": "Identidade e conformidade regulatória são responsabilidades que tangenciam todos os BCs; BC dedicado evita dispersão de lógica sensível."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/idc/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Identity & Data Governance.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/inv",
		"purpose": "Bounded Context Invoicing: materializa a obrigação de faturamento (InvoiceIssued) e o direito creditório a partir de DeliveryVerified, sob regime fiscal regulado determinístico.",
		"rationale": "A linguagem fiscal (NF-e, CFOP, alíquotas, retenções) tem regulação tributária própria e cadência distinta; separar de DLV/FCE/ATO/SCF evita acoplar regime fiscal ao fluxo operacional."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/inv/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Invoicing.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"Participante é entidade cross-BC; idc governa identidade, npm governa papel na rede.",
			"Onboarding e offboarding são workflows próprios deste BC."
		],
		"path": "contexts/npm",
		"purpose": "Bounded Context Network Participant Management: cadastro e lifecycle de participantes da rede Mesh.",
		"rationale": "Separar participante como entidade da rede do seu registro de identidade permite lifecycle de network-membership sem misturar com governança de dados pessoais."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/npm/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Network Participant Management.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — localização por bounded context preserva autonomia operacional sem perder uniformidade estrutural."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/p2p",
		"purpose": "Bounded Context Procure-to-Pay: emite Purchase Orders sob autoridade de sourcing pré-existente e faz hand-off da demanda formalizada para CMT — gateway entre sourcing (SSC) e compromisso.",
		"rationale": "Sem PO canônico vinculado a authority válida, a demanda flui fora da rede e o porquê da compra se perde; o BC gateway preserva o registro da decisão na formalização."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/p2p/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Procure-to-Pay.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/rew",
		"purpose": "Bounded Context Risk Engine & Risk Observability: avaliação de risco e elegibilidade como camada derivada da operação verificada da rede, consolidando sinais para BCs consumidores (SCF, CMT e outros).",
		"rationale": "Centralizar risco evita que cada BC consumidor implemente lógica local e gere score fragmentado; REW existe como função dos dados operacionais verificados, não como motor independente."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/rew/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Risk Engine & Risk Observability.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
			"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue."
		],
		"path": "contexts/ssc",
		"purpose": "Bounded Context Strategic Sourcing & Category: decide qual fornecedor atende qual categoria via regras determinísticas sobre sinais estruturados (NPM, RFQ, respostas); início do macrofluxo Mesh.",
		"rationale": "Sem decisão de sourcing canônica a escolha de fornecedor acontece fora da rede e o dado mais valioso (como e por que um fornecedor foi escolhido) se perde; o BC ancora o início do macrofluxo."
	},
	{
		"conventions": [
			"Um par de arquivos por agente: {agent-slug}.cue e {agent-slug}.governance.cue.",
			"Specs conformam com architecture/artifact-schemas/agent-spec.cue.",
			"Governance envelopes conformam com architecture/artifact-schemas/agent-governance.cue."
		],
		"path": "contexts/ssc/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Strategic Sourcing & Category.",
		"rationale": "Container de instâncias: mesmo padrão dos demais BCs — agentes permanecem localizados no contexto que governa seus invariants e decisões operacionais."
	},
	{
		"conventions": [
			"domain-definition.cue é a tese da empresa; outros artefatos de domain/ referenciam."
		],
		"path": "domain",
		"purpose": "Layer 0 da espec: identidade do domínio (tese, outcomes, flywheel, atores).",
		"rationale": "Identidade do domínio vive em layer separada porque muda em ritmo diferente do design tático — estabilizar tese antes de decompor em BCs."
	},
	{
		"conventions": [
			"repo-structure.cue e repo-principles.cue são top-level do diretório.",
			"Protocolos (self-review, wave-plan, red-team, audit) vivem aqui.",
			"Configuração source-of-truth de CLAUDE.md e README.md em subdiretórios dedicados."
		],
		"path": "governance",
		"purpose": "Layer 4 da espec: governança e qualidade (estrutura do repo, princípios operacionais, protocolos).",
		"rationale": "Governança não produz conhecimento novo — audita o existente. Separar em layer própria evita confundir metarregra com spec de domínio."
	},
	{
		"conventions": [
			"Schemas de protocolo em arquivos top-level do diretório.",
			"self-reviews/ e task-specs/ são containers de instâncias — schemas correspondentes em architecture/artifact-schemas/.",
			"work-graph.cue e projections/ derivam de eventos; nunca editados manualmente."
		],
		"path": "governance/build-time",
		"purpose": "Especificações de build-time: work governance, quality-gate, self-review, task-specs.",
		"rationale": "Protocolos de build-time orquestram como o trabalho acontece; isolamento em subdiretório facilita auditoria de governança de execução sem ruído de domínio."
	},
	{
		"conventions": [
			"Um arquivo por projection; nome reflete o read model materializado.",
			"Conteúdo é derivado de work-events/ e nunca editado manualmente.",
			"Formato e integridade são governados pelos artefatos de build-time correspondentes."
		],
		"path": "governance/build-time/projections",
		"purpose": "Read models derivados do event stream de work governance.",
		"rationale": "Container de derivados: projections separam estado consultável da fonte de eventos e devem permanecer claramente distintas dos artefatos autorais que as definem."
	},
	{
		"conventions": [
			"Um arquivo por artefato revisado; nome no formato {artifact-slug}.self-review.cue.",
			"Conforma com governance/build-time/self-review-report.cue.",
			"CI enforça presença via scripts/ci/check-self-review.sh."
		],
		"path": "governance/build-time/self-reviews",
		"purpose": "Instâncias de self-review dos artefatos submetidos a quality gate.",
		"rationale": "Container de instâncias: self-reviews são evidência operacional do quality gate e devem permanecer agrupadas sem competir com os protocolos que as governam."
	},
	{
		"conventions": [
			"Um arquivo por work item; nome no formato wi-XXXXX.cue.",
			"_constraints.cue define invariants globais sobre task-specs.",
			"Conforma com o schema de task spec em governance/build-time/work-governance.cue."
		],
		"path": "governance/build-time/task-specs",
		"purpose": "Specs dos work items consumidos pelo motor de work governance.",
		"rationale": "Container de instâncias: task-specs são a entrada operacional do motor de work governance e devem permanecer separadas dos protocolos que governam sua execução."
	},
	{
		"conventions": [
			"Um arquivo por work item agregando seus eventos; nome no formato wi-XXXXX.cue.",
			"_constraints.cue define o shape dos eventos e invariants relacionais.",
			"Eventos committed não são editados retroativamente."
		],
		"path": "governance/build-time/work-events",
		"purpose": "Eventos append-only do event sourcing de work governance.",
		"rationale": "Container de eventos: o diretório torna explícito que o source de verdade do fluxo de trabalho é o histórico de eventos, não os read models derivados."
	},
	{
		"conventions": [
			"config.cue é a instância; schema.cue e output.cue governam shape e renderização.",
			"CLAUDE.md nunca editado diretamente — regenerado por cue export.",
			"Schema conforma com portfolio-wide #ClaudeConfig adotado em governance/adopted-artifacts.cue."
		],
		"path": "governance/claude",
		"purpose": "Source of truth das regras comportamentais do agente (CLAUDE.md é artefato derivado).",
		"rationale": "Regras comportamentais governadas como CUE permitem cue vet, review por PR e evolução rastreável — mesmo regime dos demais artefatos."
	},
	{
		"conventions": [
			"config.cue contém a instância; output.cue o template; schema é portfolio-wide.",
			"README.md nunca editado diretamente — regenerado por cue export.",
			"Schema conforma com portfolio-wide #ReadmeConfig adotado em governance/adopted-artifacts.cue."
		],
		"path": "governance/readme",
		"purpose": "Source of truth da estrutura do README.md (README.md é artefato derivado).",
		"rationale": "README governado como CUE elimina drift entre landing page e filesystem; toda mudança de estrutura passa pelo mesmo gate dos demais artefatos."
	},
	{
		"conventions": [
			"context-map.cue é SoT de relações entre BCs; manifestos em contexts/{bc}/context-dependencies.cue são derivados.",
			"informational-flywheel.cue mapeia eventos que alimentam modelos cross-BC."
		],
		"path": "strategic",
		"purpose": "Layer 1 da espec: design estratégico (subdomínios, context map, flywheel informacional, domain stories).",
		"rationale": "Decomposição estratégica vive entre identidade do domínio (Layer 0) e BCs táticos (Layer 2); separação permite evoluir fronteiras sem mexer no tático."
	},
	{
		"conventions": [
			"Um arquivo por story; nome no formato slug kebab-case.",
			"Cada story referencia BCs e eventos envolvidos por ID."
		],
		"path": "strategic/domain-stories",
		"purpose": "Fluxos de negócio narrados como sequências ator → ação → work item.",
		"rationale": "Domain stories ancoram design em exemplos concretos de uso; reduzem risco de decomposição correta porém desconectada de cenários reais."
	},
	{
		"conventions": [
			"Singleton instances: mesh-economic-assumptions.cue (Layer -1) + mesh-economic-mechanisms.cue (Layer 1).",
			"Prefix discipline Layer -1: ri-* reality invariants (DISTINCT de inv-* domain invariants); cap-adv-* capabilities; imp-* implications.",
			"Prefix discipline Layer 1: mech-* economic mechanisms (DISTINCT de mech-* subdomain mechanisms via #EconomicMechanismRef alias); rr-* residual risks.",
			"Reality invariants são propriedades do mundo NÃO tensionáveis (sistema sobrevive apesar de). Economic mechanisms reduzem exploitability — não eliminate, não solve.",
			"Honesty enforcement: cada mechanism MUST declare failure surface (falsePositiveRisks OR underspecifications OR residualRisks) per tq-emm-03 — hidden risk inválido por discipline."
		],
		"path": "strategic/economic-model",
		"purpose": "Layer -1 (Economic Reality, ri-*) + Layer 1 (Economic Mechanisms, mech-*): foundation econômica (adr-082/083). Layer -1 declara realidades adversariais; Layer 1, mecanismos que reduzem exploitability.",
		"rationale": "2 layers canonicamente declarados: 'truths that constrain design but are not design decisions' (Layer -1 ri-*) + 'mechanisms reduce exploitability' (Layer 1 mech-*). Layer 1 protege Layer -1 realities. v1 sistema observa fraude → v2 sistema desincentiva fraude. Mechanism layer aguarda NIM bootstrap para Phase B cross-cutting refs + structural enforcement."
	},
	{
		"conventions": [
			"Um arquivo por subdomínio; nome no formato subdomain-code.cue.",
			"Classificação orienta alocação de esforço — Core recebe investimento maior."
		],
		"path": "strategic/subdomains",
		"purpose": "Classificação de subdomínios (Core/Supporting/Generic), complexidade, volatilidade, propósito.",
		"rationale": "Separar classificação de subdomínio do BC que o realiza permite reavaliar core/supporting sem mexer na estrutura tática."
	}
]
