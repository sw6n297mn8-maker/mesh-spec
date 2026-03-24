

# mesh-spec — Estrutura Canônica do Repositório de Especificação

## Como Este Repositório Funciona

mesh-spec é a autoridade do sistema. Todo artefato que descreve o que a Mesh é, como se comporta e quais contratos governa vive aqui. Nenhuma linha de código é escrita sem que a spec a justifique. Nenhuma divergência entre spec e implementação é aceitável — se divergem, o código está errado.

O repositório usa um formato único: CUE. Todo artefato — domain model, invariantes, policies, state machines, schemas, ADRs, threat models, domain stories, coding conventions, agent specs, glossários, protocolos de governança, instruções de agente — é definido em CUE com campo `rationale` por elemento. Não existe descrição narrativa paralela do mesmo conteúdo. Quando um humano precisa entender um artefato formal, ele lê a estrutura ou pede ao agente que explique sob demanda. A explicação é gerada, não persistida — e portanto nunca fica desatualizada. A única exceção é o README.md raiz (este documento), que serve como landing page do repositório.

A organização é vertical, não horizontal. O agente que vai implementar o Commitment Management (CMT) lê a pasta `contexts/cmt/` e encontra tudo: canvas, linguagem ubíqua, modelo de domínio, invariantes, state machines, schemas, contratos, agents, workflows, anti-patterns, threat model, exemplos e specs de teste. Não precisa garimpar 15 documentos espalhados. Artefatos transversais — glossário global, context map, princípios universais de agentes, shared schemas, artifact schemas — existem fora dos BCs, mas cada BC declara explicitamente quais consome via manifesto derivado.

Schemas CUE são a source of truth de todos os contratos de domínio — events, commands, types, authorization, routing, posting rules, reconciliation, projections, workflow state, required evidence, interaction contracts. Os artefatos gerados (.proto, Ion Schema, JSON Schema) vivem no mesh-runtime ou são produzidos no CI do runtime. Nada gerado é editado manualmente, nada gerado vive neste repositório. A visão consolidada de todos os contratos do sistema é um artefato derivado (CI step que indexa os .cue distribuídos por BC), não source of truth.

mesh-spec muda em cadência humana. Cada commit é uma decisão de design, não um bug fix. Agentes de código têm acesso read-only. O repositório de implementação — mesh-runtime — é subordinado e muda em cadência de agente. A separação é intencional: quem especifica e quem implementa operam em ritmos diferentes, e misturá-los cria acoplamento que degrada ambos.

Essa subordinação não é unidirecional. O runtime inevitavelmente descobre lacunas na spec — failure modes não previstos, invariantes insuficientes, edge cases não documentados. Em vez de depender exclusivamente de observação humana, o sistema opera com um ciclo de aprendizado institucionalizado: o runtime emite evidências estruturadas de lacuna ("spec gap events"), agentes de governança sintetizam o problema e preparam propostas, e a decisão final de evolução permanece humana. A spec continua sendo autoridade, mas evolui continuamente a partir da experiência operacional.

---

## Dois Repositórios, Papéis Distintos, Hierarquia Clara

**mesh-spec** é o repositório de especificação. Contém tudo que descreve o que o sistema é e como se comporta: domain definition, subdomínios, bounded contexts, domain models, invariantes, policies, state models, commands, events, schemas CUE, context map, glossário, ADRs, governance, ai-orchestration. É a autoridade. Muda em cadência humana.

**mesh-runtime** é o repositório de implementação. Contém tudo que executa: código dos serviços por BC, testes gerados a partir da spec, artefatos gerados dos CUE (.proto, Ion Schema, JSON Schema), CI/CD, infra, observabilidade, deploy. Muda em cadência de agente. É subordinado à spec — se há divergência, o runtime está errado.

Os schemas CUE vivem em mesh-spec porque são artefatos de especificação que definem contratos de domínio. Os artefatos gerados a partir deles vivem em mesh-runtime ou são produzidos no CI do runtime — nunca editados manualmente, portanto não precisam de versionamento autoral. A decisão de como o runtime se organiza internamente é uma ADR futura dentro do próprio mesh-runtime, resolvida quando a implementação do primeiro BC começar.

**Três tiers de autorização:**

| Tier | Agente | Permissão no mesh-spec |
|---|---|---|
| **Read** | Agentes de código (implementam BCs) | Leitura de qualquer artefato. Zero escrita. |
| **Propose** | Agentes de governança (auditoria, spec-gap) | Criar branch + abrir draft PR. Zero merge. Lista explícita em governance/. |
| **Decide** | Humanos (founder, CODEOWNERS) | Aprovar e fazer merge. Modificar branches protegidos. |

Nenhum agente pode fazer merge. PRs de agentes Propose são sempre draft.

---

## Princípios Orientadores

**P1 — Bounded Context como unidade primária de organização**

O repositório não é organizado por camada de abstração (estratégico → tático → aplicacional → infra). É organizado por bounded context. Camadas descrevem a ordem de descoberta do conhecimento. Bounded contexts descrevem a unidade de consumo — o pacote coeso que um agente de IA recebe quando vai executar qualquer tarefa. Documentos transversais (domain definition, context map, glossário global) existem fora dos bounded contexts, mas são minoria. A maior parte do conhecimento vive dentro de um contexto específico.

**P2 — CUE como formato universal, README.md como única exceção**

Todo artefato do repositório é definido em CUE — incluindo artefatos que em repositórios tradicionais seriam markdown: ADRs, domain stories, threat models, glossários, coding conventions, agent instructions, protocolos de governança. CUE é simultâneamente machine-readable (CI valida, agentes consomem) e human-readable (estrutura autoexplicativa, campo `rationale` por elemento). Não existe formato paralelo. Exceções (formato imposto por ferramenta, plataforma ou spec externa):
- README.md (landing page humana do repositório)
- CLAUDE.md (instruções para agentes — restrição da ferramenta Claude Code)
- api.yaml / async-api.yaml (formato imposto por spec externa: OpenAPI, AsyncAPI)
- workspace.dsl (Structurizr — formato imposto pela ferramenta C4)
- Diagramas derivados em architecture/c4/views/ (.mmd, .png — gerados, não autorais)
- CODEOWNERS, .gitignore, Taskfile.yml, .github/ (arquivos operacionais — formato imposto pela plataforma ou ferramenta) Payloads em trânsito são serializados em Amazon Ion, governados por quatro regras canônicas: Ion-1 (canonicalization), Ion-2 (SchemaRef dual), Ion-3 (compatibility em 3 camadas), Ion-4 (decimal normalization). Valores monetários em REST JSON são sempre type: string (decimal string, conforme ADR-C4-2.11 §2.11.5). Git é o único sistema de versionamento.

**P3 — Granularidade atômica com composição explícita**

Cada unidade de conhecimento (um command, um event, uma invariante) é identificável e endereçável individualmente. Quando faz sentido, essas unidades vivem como arquivos separados (commands/, events/). Quando a granularidade por arquivo gera mais ruído que valor (invariantes, policies), elas vivem como seções dentro de um arquivo do bounded context. O critério é: se um agente precisaria desse item isoladamente com frequência, ele merece seu próprio arquivo.

**P4 — Autocontido por contexto, com dependências transversais declaradas**

Cada bounded context deve ser compreensível lendo apenas sua pasta + os documentos transversais que ele referencia. Um agente nunca deveria precisar vasculhar outro bounded context para entender o que está implementando. Quando há dependência entre contextos ou com artefatos transversais, ela é declarada via referência explícita, não via conhecimento implícito. Cada BC mantém um manifesto de dependências (context-dependencies.cue) que lista exatamente quais artefatos transversais ele consome — shared schemas, termos do glossário global, contratos de outros BCs via context map. O manifesto é gerado ou validado automaticamente a partir de strategic/context-map.cue — nunca editado manualmente.

**P5 — Retrieval patterns como artefato de primeira classe**

A camada ai-orchestration/ não é acessória — é tão importante quanto o domain model. Ela resolve o problema que a literatura DDD não endereça: como montar o contexto certo para a tarefa certa, dentro do orçamento de tokens disponível. Sem ela, o agente recebe ou contexto demais (poluição, estouro de context window) ou de menos (alucinação). Cada artefato da spec carrega prioridade de injeção por tipo de tarefa para que o orquestrador gerencie tokens como recurso arquitetural explícito, não como restrição invisível.

**P6 — Negative specs têm o mesmo peso que positive specs**

Para humanos, proibições são inferidas do contexto. Para IA, não. Anti-patterns, restrições arquiteturais e fronteiras de responsabilidade precisam ser explícitos. Cada bounded context tem um anti-patterns.cue e cada ADR tem uma seção de alternativas rejeitadas.

**P7 — Golden examples como padrão de qualidade**

A IA aprende mais por pattern matching concreto do que por instrução abstrata. Implementações de referência (golden examples) dentro de cada bounded context servem como template para o agente. Um agregado exemplar implementado corretamente vale mais que dez páginas de documentação sobre como implementar agregados.

**P8 — Versionamento semântico da spec**

Mudanças no domain model, invariantes ou contratos são commits com mensagens que referenciam o bounded context afetado e o tipo de mudança. Isso permite que agentes saibam se o contexto que consumiram mudou desde a última execução.

**P9 — Cobertura auditável**

Para cada bounded context, deve ser possível verificar automaticamente: todo command tem pelo menos uma invariante? Todo event tem schema? Todo aggregate tem state model? O grafo de dependências entre BCs é acíclico? Os audit commands na camada de governança existem para isso.

**P10 — Formal first, rationale only**

Todo artefato é definido como estrutura formal em CUE — e a estrutura formal é a única representação. Não existe descrição narrativa paralela do mesmo conteúdo. Cada elemento formal carrega um campo `rationale`: uma frase curta que registra por que aquela regra existe — a motivação de domínio que não é derivável da estrutura. O rationale não descreve o que a regra faz, não é consumido por CI ou geradores, e não tem compromisso de sincronia com a estrutura. Quando um humano precisa entender uma invariante, ele lê a estrutura — autoexplicativa para quem conhece o domínio — ou pede ao agente que explique sob demanda a partir da estrutura, do rationale e do contexto do BC. A explicação é gerada, não persistida, e portanto nunca fica desatualizada.

---

## Estrutura

```
mesh-spec/
│
├── README.md                              # Este documento (única exceção ao formato CUE)
├── CLAUDE.md                              # Regras comportamentais para agentes que operam
│                                          #   neste repositório. Aponta para artefatos .cue
│                                          #   como source of truth — zero duplicação.
│
│   ╔══════════════════════════════════════════════════════════════╗
│   ║  CAMADA 0 — IDENTIDADE DO DOMÍNIO                          ║
│   ║  Responde: o que é essa empresa, por que existe,            ║
│   ║  qual a tese, quem são os atores.                           ║
│   ╚══════════════════════════════════════════════════════════════╝
│
├── domain/
│   ├── domain-definition.cue             # Tese, outcomes, flywheel, in/out of scope.
│   │                                     #   Referencia architecture/design-principles.cue
│   │                                     #   como fundação das decisões de design.
│   ├── business-model.cue                # Proposta de valor, segmentos, canais, revenue
│   ├── wardley-map.cue                   # Posicionamento de capacidades no eixo de evolução (futuro)
│   ├── stakeholder-map.cue               # Atores do ecossistema (futuro)
│   └── universal-glossary.cue            # Glossário global do domínio — termos cross-context
│
│   ╔══════════════════════════════════════════════════════════════╗
│   ║  CAMADA 1 — DESIGN ESTRATÉGICO                              ║
│   ║  Responde: como o domínio se decompõe, quais as             ║
│   ║  fronteiras, quem é dono do quê, como se integram.          ║
│   ╚══════════════════════════════════════════════════════════════╝
│
├── strategic/
│   ├── subdomains/
│   │   └── {subdomain-code}.cue          # Core/Supporting/Generic, complexidade, volatilidade, propósito
│   ├── context-map.cue                   # Topologia de integração — machine-readable (SoT de relações entre BCs).
│   │                                     #   Agentes geram visualização humana sob demanda.
│   ├── informational-flywheel.cue        # Mapa: quais eventos de quais BCs alimentam quais modelos
│   │                                     #   de scoring/precificação. CI valida que eventos referenciados
│   │                                     #   existem nos BCs produtores.
│   ├── async-api-shared.yaml             # AsyncAPI — channels e schemas compartilhados entre BCs
│   └── domain-stories/
│       └── {story-slug}.cue              # Fluxos de negócio narrados: ator → ação → work item
│
│   ╔══════════════════════════════════════════════════════════════╗
│   ║  CAMADA 2 — BOUNDED CONTEXTS (Tático + Aplicacional)        ║
│   ║  Cada BC é um pacote autocontido com tudo que um agente     ║
│   ║  precisa para implementar qualquer artefato dentro dele.    ║
│   ╚══════════════════════════════════════════════════════════════╝
│
├── contexts/
│   └── {bc-code}/                         # Código lowercase: stl/, cmt/, ngr/, etc.
│       │
│       │   # ── Identidade do Contexto ──
│       │
│       ├── canvas.cue                    # Bounded Context Canvas: propósito, capabilities,
│       │                                 #   linguagem dominante, classificação, stakeholders,
│       │                                 #   custos de transação eliminados (para quem),
│       │                                 #   incentive analysis (participantes afetados,
│       │                                 #   incentivos criados, custo de manipulação vs benefício).
│       │                                 #   Instância de architecture/artifact-schemas/canvas.cue.
│       ├── context-dependencies.cue      # Manifesto DERIVADO de strategic/context-map.cue:
│       │                                 #   shared schemas, glossary terms, contratos de outros BCs.
│       │                                 #   Nunca editado manualmente.
│       ├── ubiquitous-language.cue       # Glossário local do BC: term, definition, aliases,
│       │                                 #   prohibited_synonyms, source_bc + rationale por termo.
│       │
│       │   # ── Modelo de Domínio ──
│       │
│       ├── domain-model.cue             # Aggregates, entities, value objects — mapa conceitual
│       ├── invariants.cue               # Por invariante: assertion formal (subject, variables,
│       │                                #   predicate) + rationale. Geração de testes consome
│       │                                #   apenas a assertion. CI valida cobertura.
│       │                                #   Spec → property-based tests.
│       ├── policies.cue                 # Por policy: trigger, condition, action (formal) + rationale.
│       │                                #   CI valida que trigger events existem no BC.
│       │                                #   Spec → integration tests.
│       ├── state-models.cue             # FSM formal: estados, transições, guards como estrutura CUE.
│       │                                #   CI valida completude (sem estados inalcançáveis,
│       │                                #   sem dead-ends). Spec → FSM tests.
│       │
│       ├── commands/
│       │   └── {command-slug}.cue       # Por command: preconditions, postconditions,
│       │                                #   invariant_refs, schema_ref + rationale.
│       │                                #   Spec → contract tests.
│       │
│       ├── events/
│       │   └── {event-slug}.cue         # Schema, produtor, consumidores, semântica + rationale
│       │
│       ├── projections.cue              # Read models: source events → target schema → query patterns.
│       │                                #   CI valida que source events existem no BC.
│       │
│       │   # ── Agentes de Domínio ──
│       │
│       ├── agents/
│       │   └── {agent-slug}.cue         # Spec do agente: capabilities servidas, guardrails,
│       │                                #   inputs, outputs, dependências, failure modes + rationale
│       ├── autonomy-policy.cue          # Fronteira estocástico/determinístico: quais commands
│       │                                #   são gated (exigem validação determinística), quais
│       │                                #   são os gates, quais agentes alimentam quais gates.
│       │                                #   Spec → gate tests.
│       │
│       │   # ── Contratos e Tipos ──
│       │
│       ├── api.yaml                     # OpenAPI — superfície síncrona (Money = decimal string)
│       ├── async-api.yaml               # AsyncAPI — superfície assíncrona deste BC
│       ├── schemas/
│       │   ├── {type-slug}.cue          # CUE — source of truth de cada schema
│       │   ├── authorization.cue        # Regras de auth do BC
│       │   ├── routing.cue              # Regras de delivery routing
│       │   ├── posting-rules.cue        # Ledger posting rules
│       │   ├── workflow-state.cue       # State schemas dos process managers
│       │   ├── reconciliation.cue       # Specs de reconciliação
│       │   ├── required-evidence.cue    # Event types que exigem evidence linkada
│       │   ├── interaction-contracts.cue # Contratos de consumo inter-BC: para cada par
│       │   │                            #   emissor→receptor, quais campos do event schema são
│       │   │                            #   obrigatórios para aquele consumidor e quais garantias
│       │   │                            #   semânticas carregam. Não define campos novos — anota
│       │   │                            #   campos existentes. Ownership segue context-map pattern
│       │   │                            #   (OHS→emissor, C/S→receptor, ACL→receptor).
│       │   │                            #   CI valida que campos referenciados existem no event schema.
│       │   ├── cloudevents.cue          # Envelope CloudEvents do BC (type, source, subject)
│       │   └── _migrations/
│       │       └── {event-slug}-v{N}-to-v{N+1}.cue  # Upcasters: transformação entre versões
│       │
│       │   # ── Aplicação e Workflows ──
│       │
│       ├── ports.cue                    # Interfaces do domínio: port name, operações, parâmetros,
│       │                                #   return types. CI valida que adapters implementam todos.
│       ├── adapters.cue                 # Integrações concretas (implementações dos ports)
│       ├── workflows/
│       │   └── {workflow-slug}.cue      # Por workflow: steps, compensation, timeouts, gates,
│       │                                #   escalation + rationale. Spec → workflow tests.
│       │
│       │   # ── Qualidade e Padrão para IA ──
│       │
│       ├── anti-patterns.cue            # Por anti-pattern: description, why_wrong, alternative
│       │                                #   + rationale. Consumido por agentes como constraint.
│       ├── coding-conventions.cue       # Nomes, estrutura de pastas, padrões de código deste BC
│       ├── error-taxonomy.cue           # Erros de domínio: código, tipo, recuperável/fatal.
│       │                                #   CI valida unicidade de códigos.
│       ├── golden-examples/
│       │   └── {example-slug}.cue       # Implementações de referência que servem como template
│       │
│       │   # ── Testabilidade ──
│       │
│       ├── test-specs.cue               # Regras de geração de testes: artefato source → tipo de
│       │                                #   teste → regras. Referencia assertions formais dos .cue.
│       │                                #   CI valida que referências existem.
│       │
│       │   # ── Observabilidade ──
│       │
│       ├── observability.cue            # Contrato: métricas nomeadas, logs tipados, traces com
│       │                                #   contexto semântico que este BC deve emitir
│       │
│       │   # ── Resiliência e Segurança ──
│       │
│       ├── failure-modes.cue            # Por failure mode: trigger, impact, dependency,
│       │                                #   fallback, escalation + rationale.
│       │                                #   Spec → chaos tests.
│       ├── threat-model.cue             # Modelagem adversarial: cenários, vetores, defesas,
│       │                                #   custo de manipulação + rationale
│       │
│       │   # ── Decisões Arquiteturais Locais ──
│       │
│       └── adrs/
│           └── {nnn}-{slug}.cue         # ADRs específicos deste BC
│
│   ╔══════════════════════════════════════════════════════════════╗
│   ║  CAMADA 3 — ARQUITETURA E INFRAESTRUTURA                    ║
│   ║  Decisões globais sobre como o software é construído,       ║
│   ║  deployado e operado. Não pertence a nenhum BC individual.  ║
│   ╚══════════════════════════════════════════════════════════════╝
│
├── architecture/
│   ├── adrs/
│   │   └── {nnn}-{slug}.cue             # ADRs globais (stack, patterns, deploy strategy)
│   ├── c4/
│   │   ├── workspace.dsl                # Structurizr DSL — source of truth dos diagramas C4
│   │   └── views/                       # Diagramas derivados (.mmd, .png, exports)
│   ├── artifact-schemas/                # Schemas de validação para tipos de artefato.
│   │   │                                #   Define #Canvas, #Command, #Event, etc.
│   │   │                                #   CI valida que toda instância conforma com seu schema.
│   │   │                                #   NÃO são templates — agentes leem o schema + golden
│   │   │                                #   examples e geram instâncias conformantes.
│   │   │                                #
│   │   │                                #   ── Existentes ──
│   │   ├── adr.cue                      # #ADR
│   │   ├── domain-definition.cue        # #DomainDefinition
│   │   ├── lens.cue                     # #Lens
│   │   ├── quality-criteria.cue         # #QualityCriteria, #QualityCriterion, #Severity
│   │   ├── stakeholder-map.cue          # #StakeholderMap
│   │   ├── task-template.cue            # #TaskTemplate
│   │   ├── wave-plan.cue               # #WavePlan
│   │   │                                #
│   │   │                                #   ── Futuros (previstos, ainda não criados) ──
│   │   ├── canvas.cue                   # #Canvas
│   │   ├── domain-model.cue             # #DomainModel
│   │   ├── invariant.cue                # #Invariant
│   │   ├── policy.cue                   # #Policy
│   │   ├── state-model.cue              # #StateModel
│   │   ├── command.cue                  # #Command
│   │   ├── event.cue                    # #Event
│   │   ├── workflow.cue                 # #Workflow
│   │   ├── agent-spec.cue               # #AgentSpec
│   │   ├── threat-model.cue             # #ThreatModel
│   │   ├── golden-example.cue           # #GoldenExample
│   │   ├── anti-pattern.cue             # #AntiPattern
│   │   ├── failure-mode.cue             # #FailureMode
│   │   ├── coding-convention.cue        # #CodingConvention
│   │   ├── domain-story.cue             # #DomainStory
│   │   ├── agent-instruction.cue        # #AgentInstruction
│   │   ├── observability-contract.cue   # #ObservabilityContract
│   │   ├── projection.cue              # #Projection
│   │   ├── port.cue                    # #Port
│   │   ├── adapter.cue                 # #Adapter
│   │   └── error-taxonomy-entry.cue    # #ErrorEntry
│   ├── design-principles.cue              # 13 princípios que governam como o sistema é
│   │                                      #   desenhado. 5 grupos: #Foundation (P0-P2),
│   │                                      #   #StructuralInvariants (P3-P6),
│   │                                      #   #DesignPhilosophy (P7-P9),
│   │                                      #   #SystemNature (P10-P11),
│   │                                      #   #Governance (P12).
│   │                                      #   Diferentes dos Princípios Orientadores (P1-P10
│   │                                      #   do README): aqueles governam a organização
│   │                                      #   da spec; estes governam o design do sistema.
│   ├── agent-universal-principles.cue   # Princípios que governam todos os agentes de domínio.
│   │                                    #   Cada princípio: id, statement, rationale, examples.
│   ├── infrastructure.cue               # Stack, CI/CD, observabilidade, secrets
│   ├── database-strategy.cue            # Schema isolation, migration strategy
│   ├── error-taxonomy-global.cue        # Taxonomia de erros cross-context. CI valida unicidade
│   │                                    #   de códigos e consistência com taxonomias locais.
│   ├── security.cue                     # Autenticação, autorização, compliance
│   ├── event-evolution.cue              # Versionamento de eventos: upcasting, downcasting,
│   │                                    #   regras de compatibilidade, migração de consumidores
│   ├── compensation-patterns.cue        # Patterns globais de recovery em sagas
│   ├── observability-strategy.cue       # Estratégia global: métricas, logs, traces obrigatórios,
│   │                                    #   naming conventions, SLOs por BC
│   ├── testing-strategy.cue             # Como testes são gerados a partir da spec.
│   │                                    #   Detalha o assertion schema canônico e como
│   │                                    #   geradores consomem estrutura formal, não prosa.
│   ├── shared-schemas/
│   │   ├── money.cue                    # Tipo Money canônico (decimal string em REST, Ion decimal)
│   │   ├── cloudevents-envelope.cue     # Envelope CloudEvents base para todos os BCs
│   │   ├── assertion-schema.cue         # Gramática formal das assertions: #Assertion
│   │   │                                #   (subject, variables, predicate + rationale),
│   │   │                                #   #Variable, #Predicate. Todo invariants.cue,
│   │   │                                #   policies.cue e state-models.cue importa este schema.
│   │   │                                #   CUE é container das assertions, não engine de avaliação.
│   │   ├── agent-decision-record.cue    # Schema tipado do registro de decisão de agentes:
│   │   │                                #   inputs, política aplicada, output, confiança, timestamp
│   │   ├── agent-interaction-envelope.cue # Schema do contrato de consumo inter-BC:
│   │   │                                #   estrutura que descreve quais campos do event schema
│   │   │                                #   um receptor requer e quais garantias semânticas carregam.
│   │   ├── spec-gap-event.cue           # Schema tipado do evento de lacuna na spec:
│   │   │                                #   gap_type, affected_artifact, evidence_refs,
│   │   │                                #   hypothesis, severity, source_bc
│   │   └── ion-rules.cue               # 4 regras canônicas: Ion-1 thru Ion-4
│   └── cross-context-workflows/
│       └── {workflow-slug}.cue          # Processos que atravessam múltiplos BCs
│
│   ╔══════════════════════════════════════════════════════════════╗
│   ║  CAMADA 4 — GOVERNANÇA E QUALIDADE                          ║
│   ║  Garante coerência ao longo do tempo.                       ║
│   ║  Não produz conhecimento novo — audita o existente.         ║
│   ╚══════════════════════════════════════════════════════════════╝
│
├── governance/
│   ├── repo-structure.cue               # Estrutura válida do repositório (machine-readable).
│   │                                    #   CI valida que o filesystem conforma.
│   ├── repo-principles.cue              # Princípios operacionais do repositório.
│   ├── bounded-context-completeness.cue # Critérios de completude por BC.
│   ├── wave-plan.cue                    # O que entra em cada wave, critérios, dependências.
│   │                                    #   BCs ordenados por volume de custo de transação
│   │                                    #   eliminado — o critério fundacional de priorização.
│   ├── validation-protocol.cue          # Como rodar a suíte de testes gerada da spec
│   ├── red-team-protocol.cue            # Protocolo de red-teaming: quando executar, escopo,
│   │                                    #   critérios de severidade, como findings são
│   │                                    #   incorporados (threat-model.cue por BC, ADRs, invariants).
│   ├── spec-gap-protocol.cue            # Ciclo de aprendizado runtime → spec.
│   ├── audit-commands.cue               # Protocolos de auditoria como checks executáveis.
│   ├── build-time/                      # Especificações arquiteturais de build-time.
│   │   ├── work-governance.cue          # Governança de trabalho: coordenação multi-agente,
│   │   │                                #   dual state machine (admission × execution),
│   │   │                                #   event sourcing sobre git.
│   │   ├── work-graph.cue              # Grafo de dependências e topologia de work items.
│   │   ├── quality-gate.cue            # Protocolo de autovalidação pré-proposta:
│   │   │                               #   critérios universais, severidade, rounds, saída.
│   │   ├── self-review-report.cue      # Schema de evidência de self-review (#SelfReviewReport).
│   │   ├── self-review-ci-policy.cue   # Política de enforcement de self-review no CI.
│   │   ├── self-review-bootstrap-policy.cue # Exceções de bootstrap para self-review.
│   │   ├── self-reviews/                # Instâncias de self-review reports.
│   │   ├── task-specs/                  # Specs de work items (instâncias — não protocolos).
│   │   └── projections/                 # Read models derivados do work graph (instâncias).
│   └── claude/                          # Configuração do agente que opera neste repositório.
│       ├── config.cue                   # Source of truth das regras comportamentais do agente.
│       │                                #   CLAUDE.md é artefato derivado deste arquivo.
│       ├── schema.cue                   # Schema de validação da config do agente.
│       └── output.cue                   # Template de geração do CLAUDE.md.
│
│   ╔══════════════════════════════════════════════════════════════╗
│   ║  CAMADA 5 — ORQUESTRAÇÃO DE IA                              ║
│   ║  Resolve o problema que a literatura DDD não endereça:       ║
│   ║  como montar o contexto certo para a tarefa certa,          ║
│   ║  dentro do orçamento de tokens disponível.                   ║
│   ╚══════════════════════════════════════════════════════════════╝
│
└── ai-orchestration/
    ├── retrieval-patterns.cue           # Plano de injeção por tipo de tarefa:
    │                                    #   tarefa → lista de artefatos com prioridade de injeção
    │                                    #   (critical/important/supplementary).
    │                                    #   Artefatos critical (invariants, state-models, schemas)
    │                                    #   são sempre injetados integralmente. Supplementary
    │                                    #   podem ser resumidos sob demanda ou omitidos.
    │                                    #   Token estimates e summaries são computados pelo
    │                                    #   orquestrador (mesh-runtime), não persistidos aqui.
    ├── dependency-graph.cue             # Dependências entre arquivos (machine-readable)
    ├── agent-lifecycle.cue              # Ciclo de vida do agente de desenvolvimento:
    │                                    #   receive-task → load-context → plan → implement →
    │                                    #   self-validate → submit → respond-to-review.
    │                                    #   Prescritivo para artefatos financeiros,
    │                                    #   advisory para os demais.
    └── agent-instructions/
        ├── implement-aggregate.cue      # Prompt-template: como implementar um agregado
        ├── implement-event-handler.cue  # Prompt-template: como implementar um handler
        ├── implement-workflow.cue       # Prompt-template: como implementar process manager/saga
        ├── expose-api.cue              # Prompt-template: como expor API de um BC
        ├── add-projection.cue          # Prompt-template: como adicionar read model
        ├── define-schema.cue           # Prompt-template: como criar schema CUE
        ├── generate-tests.cue          # Prompt-template: como gerar testes a partir da spec
        ├── evolve-event.cue            # Prompt-template: como versionar evento com upcaster
        ├── define-observability.cue    # Prompt-template: como especificar contrato de observabilidade
        └── review-invariants.cue       # Prompt-template: como auditar invariantes
│
│   ╔══════════════════════════════════════════════════════════════╗
│   ║  TOOLING OPERACIONAL                                        ║
│   ║  Scripts de CI e automação. Não contêm spec de domínio.     ║
│   ╚══════════════════════════════════════════════════════════════╝
│
├── scripts/
│   ├── ci/
│   │   ├── check-self-review.sh         # Enforcement de self-review evidence.
│   │   └── check-readme-coevolution.sh  # Enforcement de coevolução README ↔ repo.
│   │                                    #   --fix regenera blocos machine-readable.
│   └── hooks/
│       └── pre-commit                   # Hook: auto-fix blocos + textual presence check.
│                                        #   Instalação: git config core.hooksPath scripts/hooks
```

<!-- BEGIN:repo-structure-paths
.claude/
.claude/hooks/
ai-orchestration/
ai-orchestration/agent-instructions/
architecture/
architecture/adrs/
architecture/artifact-schemas/
architecture/artifacts/
architecture/c4/
architecture/cross-context-workflows/
architecture/shared-schemas/
architecture/tension-log/
architecture/validation-prompts/
contexts/
domain/
governance/
governance/build-time/
governance/claude/
scripts/
scripts/ci/
scripts/hooks/
strategic/
strategic/domain-stories/
strategic/subdomains/
END:repo-structure-paths -->

<!-- BEGIN:repo-artifact-schemas
adr.cue
artifact-schema.cue
canvas.cue
domain-definition.cue
lens.cue
quality-criteria.cue
stakeholder-map.cue
subdomain.cue
task-template.cue
validation-prompt.cue
wave-plan.cue
END:repo-artifact-schemas -->

<!-- BEGIN:repo-governance-protocols
governance/bounded-context-completeness.cue
governance/build-time/claim-expiration-validation.cue
governance/build-time/command-rights.cue
governance/build-time/completion-gates.cue
governance/build-time/event-validation.cue
governance/build-time/projection-drift.cue
governance/build-time/quality-gate.cue
governance/build-time/self-review-bootstrap-policy.cue
governance/build-time/self-review-ci-policy.cue
governance/build-time/self-review-report.cue
governance/build-time/task-governance.cue
governance/build-time/validation-findings-w001.cue
governance/build-time/work-governance.cue
governance/build-time/work-graph.cue
governance/claude/config.cue
governance/claude/output.cue
governance/claude/schema.cue
governance/repo-principles.cue
governance/repo-structure.cue
governance/wave-plan.cue
scripts/ci/check-readme-coevolution.sh
scripts/ci/check-self-review.sh
scripts/hooks/post-commit
scripts/hooks/pre-commit
END:repo-governance-protocols -->

---

## Mapeamento: Níveis de Abstração → Arquivos no Repo

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
| 9 | Contratos e Tipos | contexts/{bc-code}/schemas/*.cue (source of truth), api.yaml, async-api.yaml, architecture/shared-schemas/ |
| 10 | Ports & Adapters | contexts/{bc-code}/ports.cue, adapters.cue |
| 11 | Aplicação / Workflows | contexts/{bc-code}/workflows/*.cue + architecture/cross-context-workflows/ |
| 12 | Infra | architecture/infrastructure.cue, database-strategy.cue, security.cue |
| — | Agentes de domínio | contexts/{bc-code}/agents/{agent}.cue + autonomy-policy.cue (fronteira) + architecture/agent-universal-principles.cue (princípios globais) |
| — | Contratos de consumo inter-BC | contexts/{bc-code}/schemas/interaction-contracts.cue + architecture/shared-schemas/agent-interaction-envelope.cue (schema base). Ownership segue context-map. |
| — | Incentive analysis | contexts/{bc-code}/canvas.cue (seção obrigatória do canvas) |
| — | Threat modeling | contexts/{bc-code}/threat-model.cue + governance/red-team-protocol.cue |
| — | Acumulação informacional | strategic/informational-flywheel.cue |
| — | Decision log de agentes | architecture/shared-schemas/agent-decision-record.cue |
| — | Assertion schema | architecture/shared-schemas/assertion-schema.cue (gramática formal com rationale) |
| — | Ciclo de aprendizado | governance/spec-gap-protocol.cue + architecture/shared-schemas/spec-gap-event.cue |
| — | Autorização do repo | Três tiers (Read/Propose/Decide) documentados no README |
| — | Governança | governance/ |
| — | Configuração do agente | governance/claude/ (config.cue → CLAUDE.md derivado) |
| — | Orquestração de IA | ai-orchestration/ (retrieval com prioridades, lifecycle, instructions) |
| — | Testabilidade | contexts/{bc-code}/test-specs.cue + architecture/testing-strategy.cue + governance/validation-protocol.cue |
| — | Observabilidade | contexts/{bc-code}/observability.cue + architecture/observability-strategy.cue |
| — | Evolução de eventos | contexts/{bc-code}/schemas/_migrations/ + architecture/event-evolution.cue |
| — | Recovery / Compensation | contexts/{bc-code}/failure-modes.cue + workflows/*.cue + architecture/compensation-patterns.cue |
| — | Artifact schemas | architecture/artifact-schemas/ (schemas de validação para tipos de artefato) |
| — | Design principles | architecture/design-principles.cue (13 princípios em 5 grupos: Foundation, StructuralInvariants, DesignPhilosophy, SystemNature, Governance) |

---

## Nota sobre o Nível 6 (EventStorming)

EventStorming é um método de descoberta, não um artefato de persistência. Seus outputs — events, commands, aggregates, policies, read models — são capturados nos arquivos táticos de cada bounded context. Diagramas de EventStorming resultantes de workshops podem ser armazenados como imagens de referência em contexts/{bc-code}/eventstorming/, mas não são a fonte de verdade. Os arquivos derivados são.

---

## Pipeline de Schemas (CUE → Artefatos Gerados)

CUE é a source of truth única de todos os schemas e contratos compiláveis. Os .cue vivem em mesh-spec (contexts/{bc-code}/schemas/, artefatos .cue por BC, e architecture/shared-schemas/). Nenhum .proto, .isl ou .json é editado manualmente — todos são gerados no CI do mesh-runtime. A visão consolidada de todos os contratos do sistema é um artefato derivado (CI step que indexa os .cue distribuídos por BC), não source of truth.

```
 ┌─────────────┐     ┌──────────────────┐     ┌──────────────────────┐
 │  mesh-spec   │     │  mesh-runtime CI │     │  mesh-runtime        │
 │  .cue files  │────▸│  cue export      │────▸│  .proto  (codegen)   │
 │  (source of  │     │  cue vet         │     │  .isl    (runtime)   │
 │   truth)     │     │  pipelines       │     │  .json   (docs/spec) │
 └─────────────┘     └──────────────────┘     └──────────────────────┘
```

Tipos compartilhados entre BCs (Money, CloudEvents envelope, IDs globais, agent decision record, agent interaction envelope, spec gap event, assertion schema) vivem em architecture/shared-schemas/ e são importados nos .cue locais de cada BC via referência CUE.

Amazon Ion governa a serialização de payloads com quatro regras canônicas documentadas em architecture/shared-schemas/ion-rules.cue:
- Ion-1 — Canonicalization: forma canônica para hashing e comparação.
- Ion-2 — SchemaRef dual: todo payload carrega referência ao schema (type + version).
- Ion-3 — Compatibility 3 camadas: backward, forward e full compatibility por schema.
- Ion-4 — Decimal normalization: decimais financeiros normalizados (sem trailing zeros espúrios).

Money em REST JSON é sempre type: string (decimal string), conforme ADR-C4-2.11 §2.11.5. Em payloads Ion, Money usa o tipo nativo decimal.

Eventos seguem o envelope CloudEvents. Cada BC define seus type e source em schemas/cloudevents.cue.

---

## Artifact Schemas — Validação de Conformidade

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

---

## Spec → Testes (Testing Strategy)

A spec não é documentação — é a fonte a partir da qual testes são gerados. Esta é potencialmente a contribuição de maior valor do repositório para um sistema AI-operated: artefatos formais produzem testes automaticamente, eliminando a lacuna entre "o domínio diz que X" e "o código garante que X".

O assertion-schema.cue (architecture/shared-schemas/) define a gramática formal: `#Assertion` (subject, variables, predicate + rationale), `#Variable` (name, source, filter), `#Predicate` (left, relation, right). Todo invariants.cue, policies.cue e state-models.cue importa esse schema. CUE é o container das assertions — não a engine de avaliação. Um gerador de testes no CI do mesh-runtime consome as assertions e produz código de teste. O padrão é o mesmo de CUE → .proto: CUE define estrutura, codegen produz artefato executável.

A conexão entre artefatos da spec e tipos de teste é:

```
invariants.cue         → property-based tests (assertions formais: variáveis, relação, condição)
state-models.cue       → FSM tests (transições formais: toda transição ilegal rejeitada)
commands/{cmd}.cue     → contract tests (preconditions/postconditions formais)
schemas/*.cue          → validation tests (payloads inválidos → rejeição; round-trip Ion ↔ CUE)
policies.cue           → integration tests (trigger/condition/action formal → comando executado)
failure-modes.cue      → chaos tests (trigger/dependency/fallback formais)
workflows/{wf}.cue     → workflow tests (steps/compensation/timeouts formais)
threat-model.cue       → adversarial tests (fonte formal: autonomy-policy.cue + invariants.cue)
autonomy-policy.cue    → gate tests (agente estocástico sem gate → rejeição)
ports.cue              → adapter tests (todo port declarado tem adapter implementado)
error-taxonomy.cue     → error tests (códigos únicos, categorização consistente)
interaction-contracts   → contract tests (emissor sem campos obrigatórios → rejeição)
```

Cada BC documenta suas regras de geração em test-specs.cue. A estratégia global — incluindo como o assertion schema funciona e como geradores consomem estrutura formal — vive em architecture/testing-strategy.cue. O protocolo de execução — quando rodar, que cobertura mínima, como validar antes de merge — vive em governance/validation-protocol.cue.

---

## Contratos de Consumo entre BCs

O schema CUE de um evento define a estrutura de dados que cruza a fronteira entre BCs. Mas quando um agente de scoring do BC de Network Intelligence (NTI) emite um evento consumido pelo agente de pricing do BC de Settlement (STL), o schema sozinho não basta. O receptor precisa saber quais campos são obrigatórios para sua decisão e quais garantias semânticas eles carregam.

Os campos de contexto decisório — confidence, reasoning_category, data_sufficiency — pertencem ao event schema. São fatos que o emissor observou no momento da emissão. O schemas/interaction-contracts.cue não define campos novos — ele declara requisitos de consumo sobre campos que já existem no schema do evento: quais são obrigatórios para aquele receptor e quais garantias semânticas carregam.

O agent-decision-record.cue é complementar: registra o que aconteceu após o fato (auditoria). O interaction contract define a expectativa antes do fato (contrato de consumo).

**Ownership segue o context-map.** O context-map já define o pattern de cada relação entre BCs (OHS/CF, Customer/Supplier, ACL). O interaction contract segue a mesma regra de ownership:

| Pattern no context-map | Owner do interaction contract |
|---|---|
| OHS/CF (Open Host Service / Conformist) | Emissor (upstream) |
| Customer/Supplier | Receptor (customer) |
| ACL (Anti-Corruption Layer) | Receptor (downstream) |

CI valida que: (1) todo campo referenciado no interaction contract existe no event schema, (2) todo event consumido por agente de outro BC tem interaction contract declarado, (3) o owner do contrato é consistente com o pattern no context-map.

---

## Gestão de Orçamento de Contexto

O context window do modelo é um recurso escasso que precisa ser gerenciado explicitamente. Em um bounded context maduro é plausível que existam trinta ou mais artefatos de especificação. Um agente que precise implementar ou modificar um command nesse contexto pode ultrapassar dezenas de milhares de tokens apenas ao carregar documentos de referência.

A responsabilidade é separada em duas camadas:

**Spec (mesh-spec)** define prioridades de injeção por tipo de tarefa em retrieval-patterns.cue. Artefatos marcados como critical — invariants.cue, state-models.cue, schemas do command sendo implementado — são sempre injetados integralmente. Artefatos important — policies.cue, error-taxonomy.cue, anti-patterns.cue — são injetados integralmente se o orçamento permitir. Artefatos supplementary — golden-examples, observability.cue, coding-conventions.cue — são incluídos apenas se sobrar espaço. Essa priorização é decisão de design que muda em cadência humana.

**Orquestrador (mesh-runtime ou tooling)** computa dinamicamente: token estimates a partir do tamanho atual de cada artefato + tokenizer do modelo em uso, summaries sob demanda quando o budget não comporta o documento completo, e a lógica de degradação controlada. Quando o orquestrador omite ou resume um artefato, essa decisão é registrada no contexto do agente. O agente sabe que está operando com contexto parcial e pode sinalizar incerteza.

---

## Contratos de Observabilidade

Para um sistema AI-operated com trilha de auditoria completa, observabilidade não é infraestrutura opcional — é contrato. Cada BC declara em observability.cue quais métricas, logs e traces emite, com schemas tipados.

O contrato de observabilidade inclui: métricas nomeadas com labels semânticos (não contadores genéricos), logs estruturados com schema (não texto livre), traces com contexto de domínio (qual aggregate, qual command, qual evento), e health checks semânticos (o agente de scoring está respondendo dentro do SLA, não apenas o container está up).

Decisões de agentes de domínio são registradas com schema tipado (architecture/shared-schemas/agent-decision-record.cue): inputs, política aplicada, output, confiança, timestamp. Todo BC que possui agentes de domínio emite decision records como parte do contrato de observabilidade.

A estratégia global — naming conventions de métricas, níveis de log obrigatórios, SLOs por tier de BC — vive em architecture/observability-strategy.cue. O contrato local por BC é o .cue que pode ser validado: se o código de um BC não emite uma métrica declarada no contrato, o CI falha.

---

## Ciclo de Aprendizado Runtime → Spec

A spec é a autoridade e o runtime é subordinado. Mas o runtime inevitavelmente descobre informações que revelam lacunas: failure modes não previstos, anti-patterns emergentes, invariantes insuficientes, edge cases não documentados. Se a única forma de atualização for observação humana manual, cria-se um gargalo de governança que escala mal.

O fluxo estruturado de evidência opera em três passos:

1. **Detecção.** O runtime emite um spec-gap event estruturado (schema em architecture/shared-schemas/spec-gap-event.cue): tipo de lacuna, artefato afetado, referências a evidências no event log, hipótese, severidade.

2. **Síntese.** Um agente de governança (tier Propose) consome a fila, agrupa por artefato afetado, analisa evidências e gera draft PR no mesh-spec com proposta de alteração.

3. **Decisão humana.** O founder ou CODEOWNERS (tier Decide) revisa e decide se a spec precisa evoluir, como e quando.

O protocolo completo — critérios de emissão, SLA de triagem, formato da proposta, mecanismo de priorização — vive em governance/spec-gap-protocol.cue.

---

## Ciclo de Vida do Agente de Desenvolvimento

Os prompt-templates em agent-instructions/ especificam tarefas atômicas. Mas agentes de desenvolvimento operam em ciclos: receive-task → load-context → plan → implement → self-validate → submit → respond-to-review.

O ciclo especificado em ai-orchestration/agent-lifecycle.cue cobre:

1. **Receive task.** Task description com escopo e critérios de aceitação.
2. **Load context.** retrieval-patterns.cue determina quais artefatos injetar, respeitando prioridades. Orquestrador computa budget e aplica degradação se necessário. O agente sabe quais artefatos foram resumidos ou omitidos.
3. **Plan.** Decomposição explícita em sub-passos antes de implementar.
4. **Implement.** agent-instructions/ fornece template por tipo de sub-tarefa.
5. **Self-validate.** Antes de submeter: invariants.cue (assertions violadas?), state-models.cue (transições ilegais?), test-specs.cue (testes passam?), interaction-contracts.cue (campos obrigatórios presentes?). Falha = não submeter.
6. **Submit.** Com contexto sobre quais artefatos foram consultados, quais self-validations passaram, e quais decisões com contexto parcial.
7. **Respond to review.** Feedback de humano ou agente → retorna ao passo 3 se necessário.

Prescritivo para artefatos financeiros (invariantes de pagamento, posting rules, settlement). Advisory para os demais.

---

## Evolução de Eventos (Upcasting / Downcasting)

Ion-3 (compatibility em 3 camadas) define a política, mas não define a mecânica. Quando CommitmentCreated v1 precisa virar v2, três coisas acontecem:

1. O schema v2 é definido no .cue como uma nova versão.
2. O upcaster — a transformação de v1 para v2 — é definido em schemas/_migrations/commitment-created-v1-to-v2.cue.
3. Consumidores que ainda esperam v1 continuam recebendo v1 até migrarem, porque o sistema mantém compatibilidade backward por pelo menos uma versão.

As regras globais — quantas versões são mantidas em paralelo, quando uma versão é aposentada, como consumidores são notificados de deprecação — vivem em architecture/event-evolution.cue. Os upcasters concretos vivem dentro do BC que produz o evento.

---

## Recovery e Compensation em Workflows

Para um sistema financeiro, falha em saga é safety-critical. contexts/{bc-code}/workflows/*.cue documenta a compensation de cada workflow individual como estrutura formal, mas os patterns globais que governam como toda saga se comporta sob falha vivem em architecture/compensation-patterns.cue.

Esse artefato cobre: idempotência como requisito universal (reprocessar nunca duplica), compensation como evento (não como rollback — append-only), dead letter como escalação (não como descarte), timeout com semântica de negócio (não apenas técnico), e escalação humana como último recurso com critérios explícitos de quando acionar. Cada workflow.cue referencia quais patterns aplica e documenta seus failure modes específicos em failure-modes.cue.

---

## Fronteira Estocástico/Determinístico (Autonomy Policy)

Para um sistema AI-operated que processa transações financeiras, a separação entre recomendação e execução é safety-critical. Agentes estocásticos (IA) nunca emitem comandos financeiros diretamente — eles recomendam. Um gate determinístico valida a recomendação e executa se e somente se ela passa por todas as invariantes.

Cada BC que possui agentes de domínio declara em autonomy-policy.cue: quais commands são gated (exigem validação determinística antes de execução), quais são os gates (invariantes, thresholds, aprovações humanas), e quais agentes estocásticos alimentam quais gates. Sem esse artefato, a separação entre recomendação e execução fica implícita no código, violando o princípio de que tudo é especificado antes de implementado.

---

## Convenções de Nomenclatura

- Diretórios de bounded context: código lowercase (`stl`, `cmt`, `ngr`, `bdg`, `dlv`, `inv`, `nti`, `adt`). Nome completo vive no canvas.cue de cada BC.
- Arquivos de command: `{verbo}-{substantivo}.cue` — ex: `approve-commitment.cue`.
- Arquivos de event: `{substantivo}-{particípio}.cue` — ex: `commitment-approved.cue`.
- Arquivos de ADR: `{nnn}-{slug}.cue` — ex: `001-postgres-per-module.cue`.
- Arquivos de schema (CUE): `{nome-do-tipo}.cue` — ex: `commitment-created-event.cue`.
- Arquivos de glossário: `ubiquitous-language.cue` por BC, `domain/universal-glossary.cue` global.
- Arquivos de workflow: `{nome-do-processo}.cue` — ex: `commitment-fulfillment-flow.cue`.
- Arquivos de migration: `{event-slug}-v{N}-to-v{N+1}.cue` — ex: `commitment-created-v1-to-v2.cue`.
- Arquivos de agente: `{agent-slug}.cue` — ex: `scoring-agent.cue`.
- Arquivos de contrato de consumo: `interaction-contracts.cue` (por BC, dentro de schemas/).
- Arquivos de domain story: `{story-slug}.cue` — ex: `supplier-delivers-materials.cue`.
- Arquivos de golden example: `{example-slug}.cue` — ex: `commitment-aggregate-impl.cue`.
- Arquivos de artifact schema: `{artifact-type}.cue` — ex: `canvas.cue`, `command.cue`.
- Artefatos universais: todo artefato cross-context leva "universal" no nome.

---

## Critérios de Completude por Bounded Context

Um BC é considerado "spec-complete" quando:

- [ ] canvas.cue preenchido com propósito, capabilities, classificação, custos de transação eliminados e incentive analysis. Conforma com architecture/artifact-schemas/canvas.cue (#Canvas).
- [ ] context-dependencies.cue gerado e validado contra context-map.cue.
- [ ] ubiquitous-language.cue com termos locais do BC em formato estruturado.
- [ ] domain-model.cue com todos os aggregates, entities e value objects.
- [ ] invariants.cue com pelo menos uma assertion formal por aggregate + rationale.
- [ ] Todo command documentado em commands/{cmd}.cue com preconditions, postconditions, invariant_refs + rationale.
- [ ] Todo event documentado em events/{event}.cue com schema CUE, envelope CloudEvents e lista de consumidores.
- [ ] state-models.cue para todo aggregate que possui lifecycle — transições formais.
- [ ] policies.cue com todas as reações automáticas — trigger/condition/action formal + rationale.
- [ ] projections.cue com todos os read models.
- [ ] ports.cue com todas as interfaces do domínio.
- [ ] agents/{agent}.cue com spec de cada agente de domínio do BC (se aplicável).
- [ ] schemas/interaction-contracts.cue com contratos de consumo para cada par emissor→receptor, ownership consistente com context-map (se BC consome eventos de outros BCs).
- [ ] autonomy-policy.cue com fronteira estocástico/determinístico (se BC possui agentes).
- [ ] schemas/ com todas as 8 famílias ContractGate aplicáveis ao BC.
- [ ] anti-patterns.cue com pelo menos 3 restrições em formato estruturado + rationale.
- [ ] coding-conventions.cue com estrutura de pastas e naming.
- [ ] error-taxonomy.cue com códigos únicos por tipo de erro.
- [ ] Pelo menos 1 golden example em golden-examples/{example}.cue.
- [ ] api.yaml (OpenAPI) ou async-api.yaml (AsyncAPI) conforme a superfície do BC.
- [ ] test-specs.cue com regras de geração que referenciam assertions formais.
- [ ] observability.cue com métricas, logs tipados, traces e decision records de agentes.
- [ ] failure-modes.cue com fallbacks para toda dependência externa em formato estruturado + rationale.
- [ ] threat-model.cue com vetores de ataque, defesas e custo de manipulação.
- [ ] workflows/*.cue com steps, compensation, timeouts formais + rationale.
- [ ] _migrations/ com upcasters para todo evento que já tem v2+.
- [ ] ADRs em adrs/{nnn}-{slug}.cue para toda decisão arquitetural não-trivial.

---

## Ordem de Criação Recomendada

1. Criar repositório mesh-spec com estrutura de diretórios vazia + README.md raiz.
2. Criar architecture/artifact-schemas/ — schemas de validação para todos os tipos de artefato (#Canvas, #Command, #Event, etc.).
3. Criar architecture/design-principles.cue — 13 princípios de design em 5 grupos (#Foundation, #StructuralInvariants, #DesignPhilosophy, #SystemNature, #Governance). Precede domain/ porque domain-definition.cue referencia os princípios.
4. Criar domain/ — domain-definition.cue, business-model.cue, universal-glossary.cue.
5. Criar strategic/ — subdomínios em .cue, context-map.cue, informational-flywheel.cue.
6. Criar contexts/cmt/ — primeiro BC (Economic Commitment Lifecycle, Minimum Economic Loop).
7. Criar architecture/ (restante) — ADRs globais em .cue, agent-universal-principles.cue, C4, shared schemas (incluindo assertion-schema.cue com rationale, agent-interaction-envelope.cue, spec-gap-event.cue), error taxonomy global, testing-strategy.cue.
8. Criar governance/ — wave-plan.cue, red-team-protocol.cue, spec-gap-protocol.cue, audit-commands.cue, validation-protocol.cue.
9. Criar ai-orchestration/ — retrieval-patterns.cue com prioridades, dependency-graph.cue, agent-lifecycle.cue, agent-instructions/.
10. Validar: um agente consegue implementar um agregado do CMT usando apenas o repo? A self-validation funciona?
11. Iterar para os demais BCs por ordem de wave-plan.cue.
