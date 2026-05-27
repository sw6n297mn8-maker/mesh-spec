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
		"conventions": [],
		"path": "ai-orchestration",
		"purpose": "Layer 5 da espec: como montar contexto certo para tarefa certa dentro do orçamento de tokens.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "ai-orchestration/agent-instructions",
		"purpose": "Prompt-templates por tarefa recorrente (implementar agregado, expor API, gerar testes, evoluir evento).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture",
		"purpose": "Layer 3 da espec: decisões arquiteturais globais que não pertencem a nenhum BC individual.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/adrs",
		"purpose": "ADRs globais do sistema (stack, patterns, deploy strategy, protocolos cross-context).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/artifact-schemas",
		"purpose": "Schemas de validação para cada tipo de artefato instanciado no repo (#Canvas, #ADR, #Lens, etc.).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/artifacts",
		"purpose": "Instâncias de artefatos operacionais cross-context (governance envelopes, lenses produzidos).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/artifacts/governance",
		"purpose": "Instâncias de autonomy envelopes por domínio.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/artifacts/lenses",
		"purpose": "Outputs produzidos pela aplicação de lenses analíticas em decisões concretas.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/c4",
		"purpose": "Diagramas C4 do sistema (Structurizr DSL como source, views derivadas em .mmd/.png).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/c4/views",
		"purpose": "Views derivadas do modelo arquitetural C4.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/conventions",
		"purpose": "Convenções arquiteturais condicionais a capability flags do BC (API sync/async, etc.).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/cross-context-workflows",
		"purpose": "Processos que atravessam múltiplos bounded contexts (ex: commitment lifecycle).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/deferred-decisions",
		"purpose": "Deferimentos conscientes governados: decisões explícitas de não resolver agora, com trade-off articulado e condição codificada de revisita (per adr-062).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/lenses",
		"purpose": "Lenses analíticas: protocolos de raciocínio para domínios especializados (economia, segurança, crédito, AI).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/production-guides",
		"purpose": "Production guides: instruções de produção executadas por agente antes de criar instância de cada tipo de artefato governado (simétricos a validation-prompts, que validam depois).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/shared-schemas",
		"purpose": "Schemas compartilhados entre BCs (Money canônico, CloudEvents envelope, assertions formais, Ion rules).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/shared-types",
		"purpose": "Tipos reutilizáveis entre artifact-schemas (#StrategicClassification, #VerticalApplicability).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/structural-checks",
		"purpose": "Checks estruturais determinísticos executados pós-commit como gate (P10).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/tension-log",
		"purpose": "Tensões arquiteturais: fricções cross-artifact que não são defeito de nenhum lado individual.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "architecture/validation-prompts",
		"purpose": "Prompts de design review advisory executados por agente isolado pós-commit.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts",
		"purpose": "Layer 2 da espec: bounded contexts autocontidos, cada um um pacote completo.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/bdg",
		"purpose": "Bounded Context Budget & Approval: verifica cobertura orçamentária de compromissos formalizados em CMT e emite o gate canônico de aprovação que habilita a progressão do commitment lifecycle.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/bdg/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Budget & Approval.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/bkr",
		"purpose": "Bounded Context Banking Rails & Settlement: liquidação física via rails bancários (Pix/SPI, TED/STR, boleto, SWIFT) sob autorização upstream — boundary entre a Mesh e o sistema regulado pelo Bacen.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/bkr/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Banking Rails & Settlement.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/cmt",
		"purpose": "Bounded Context Commitment Management: gestão do ciclo de vida de compromissos entre participantes.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/cmt/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Commitment Management.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/ctr",
		"purpose": "Bounded Context Contract & Terms Registry: registro versionado de contratos e cláusulas canônicas.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/ctr/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Contract & Terms Registry.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/dlv",
		"purpose": "Bounded Context Delivery & Verification: verifica execução operacional contra critérios versionados acordados em CMT e decide deterministicamente a suficiência de evidência para progressão econômica.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/dlv/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Delivery & Verification.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/idc",
		"purpose": "Bounded Context Identity & Data Governance: identidade de participantes e governança de dados pessoais (LGPD, integridade criptográfica).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/idc/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Identity & Data Governance.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/inv",
		"purpose": "Bounded Context Invoicing: materializa a obrigação de faturamento (InvoiceIssued) e o direito creditório a partir de DeliveryVerified, sob regime fiscal regulado determinístico.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/inv/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Invoicing.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/npm",
		"purpose": "Bounded Context Network Participant Management: cadastro e lifecycle de participantes da rede Mesh.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/npm/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Network Participant Management.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/p2p",
		"purpose": "Bounded Context Procure-to-Pay: emite Purchase Orders sob autoridade de sourcing pré-existente e faz hand-off da demanda formalizada para CMT — gateway entre sourcing (SSC) e compromisso.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/p2p/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Procure-to-Pay.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/rew",
		"purpose": "Bounded Context Risk Engine & Risk Observability: avaliação de risco e elegibilidade como camada derivada da operação verificada da rede, consolidando sinais para BCs consumidores (SCF, CMT e outros).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/rew/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Risk Engine & Risk Observability.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/ssc",
		"purpose": "Bounded Context Strategic Sourcing & Category: decide qual fornecedor atende qual categoria via regras determinísticas sobre sinais estruturados (NPM, RFQ, respostas); início do macrofluxo Mesh.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "contexts/ssc/agents",
		"purpose": "Specs e governance envelopes dos agentes do BC Strategic Sourcing & Category.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "domain",
		"purpose": "Layer 0 da espec: identidade do domínio (tese, outcomes, flywheel, atores).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance",
		"purpose": "Layer 4 da espec: governança e qualidade (estrutura do repo, princípios operacionais, protocolos).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance/build-time",
		"purpose": "Especificações de build-time: work governance, quality-gate, self-review, task-specs.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance/build-time/projections",
		"purpose": "Read models derivados do event stream de work governance.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance/build-time/self-reviews",
		"purpose": "Instâncias de self-review dos artefatos submetidos a quality gate.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance/build-time/task-specs",
		"purpose": "Specs dos work items consumidos pelo motor de work governance.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance/build-time/work-events",
		"purpose": "Eventos append-only do event sourcing de work governance.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance/claude",
		"purpose": "Source of truth das regras comportamentais do agente (CLAUDE.md é artefato derivado).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "governance/readme",
		"purpose": "Source of truth da estrutura do README.md (README.md é artefato derivado).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "strategic",
		"purpose": "Layer 1 da espec: design estratégico (subdomínios, context map, flywheel informacional, domain stories).",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "strategic/domain-stories",
		"purpose": "Fluxos de negócio narrados como sequências ator → ação → work item.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "strategic/economic-model",
		"purpose": "Layer -1 (Economic Reality, ri-*) + Layer 1 (Economic Mechanisms, mech-*): foundation econômica (adr-082/083). Layer -1 declara realidades adversariais; Layer 1, mecanismos que reduzem exploitability.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	},
	{
		"conventions": [],
		"path": "strategic/subdomains",
		"purpose": "Classificação de subdomínios (Core/Supporting/Generic), complexidade, volatilidade, propósito.",
		"rationale": "Diretório governado declarado em _meta.cue local (adr-115)."
	}
]
