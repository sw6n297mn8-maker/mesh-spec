# Contexto de Sessão — 2026-03-13

Este arquivo é temporário. Existe para transferir contexto entre sessões. Pode ser deletado após a retomada.

---

## O que foi feito nesta sessão

### 1. Atualização do config.cue (commit ee2e8af)

Quatro seções do `governance/claude/config.cue` foram alteradas. CLAUDE.md foi regenerado automaticamente.

**Seção 2 — Modelo de Operação:** Adicionado protocolo de tensão. Axiomas são hipóteses estratégicas, não verdades absolutas. Quando uma decisão tensionar um axioma, o agente deve: (a) registrar no rationale do artefato, (b) criar entrada em `architecture/tension-log/`, (c) sinalizar com `[TENSÃO: ax-XX]` no output.

**Seção 4 — Regra Fundamental:** Adicionada distinção entre dois tipos de diretriz: (1) constraints invioláveis (integridade legal + dp-10), que nunca cedem; (2) axiomas e princípios operacionais, que são tensionáveis com justificativa. Referência a `domain/domain-definition.cue` para hierarquia de precedência.

**Seção 14 — Validação:** Adicionada validação semântica com separação de contexto. Após produzir artefato CUE, o agente commita na branch ativa e instrui o usuário a executar validação em sessão separada usando validation prompts. Categorização: pass/warning/fail.

**Seção 16 — Referências por Tipo de Operação:** Adicionadas 4 categorias: (1) decisões irreversíveis com 5 critérios — escalar ao usuário por default; (2) lenses analíticas — carregar quando disponíveis, proceder com princípios quando não; (3) governança com autonomia zero por default; (4) validation prompts.

**Avaliação de mudança aplicada:** 10 findings identificados, 4 ajustes aplicados antes de commitar: CM-01 (consistência de workflow entre seções 2 e 14), CM-05 (prefixo "e.g." em regulamentos), CM-06 (escopo de validação delegado ao prompt), CM-08 (referências genéricas a schema de lenses).

### 2. Proposta de foundingPrinciples (NÃO commitada)

Proposta completa dos princípios fundacionais para `domain/domain-definition.cue` foi discutida e aceita em conversa, mas **NÃO foi escrita no repositório**. O conteúdo aceito:

**7 axiomas:**
- ax-01: Operada por IA
- ax-02: Software feito para agentes com humans-in-the-loop
- ax-03: Pagar o custo de complexidade cedo
- ax-04: Decidir hoje o que gostaríamos de ter decidido em 5–10 anos
- ax-05: Não assumir só o melhor cenário
- ax-06: Maximizar efeitos de rede
- ax-07: Dinheiro e operação como primitivas nativas

**10 princípios derivados:**
- dp-01: Domínio antes de tecnologia (ax-03, ax-04)
- dp-02: Redução de custo de transação (ax-06, ax-07)
- dp-03: Controle de blast radius (ax-03, ax-05)
- dp-04: Determinismo operacional (ax-05, ax-07)
- dp-05: Auditabilidade total (ax-05, ax-07)
- dp-06: Escalabilidade estrutural (ax-03, ax-04, ax-06)
- dp-07: Evolução contínua sem reescrita (ax-03, ax-04)
- dp-08: Incentive compatibility (ax-05, ax-06)
- dp-09: Acumulação informacional (ax-06, ax-07)
- dp-10: Responsabilidade jurídica explícita (ax-05, ax-07)

**4 níveis de resolução de conflito:**
1. Integridade Legal (ax-07, dp-04, dp-05, dp-10)
2. Contenção de Dano (ax-05, dp-03)
3. Operabilidade (ax-01, ax-02, dp-01, dp-02, dp-08)
4. Evolução (ax-03, ax-04, ax-06, dp-06, dp-07, dp-09)

**reversibilityThreshold — 5 critérios:**
1. Afeta schema de dados persistidos em SoTs
2. Altera contratos públicos
3. Modifica estrutura de isolamento entre tenants
4. Impacta obrigações legais, fiscais ou regulatórias
5. Requer migração de dados em produção

### 3. Insight crítico: ordem de construção

A conversa chegou a um insight que **muda a sequência de trabalho inteira**. A ordem original era: princípios → schemas → conteúdo. O insight:

**O agente é o ator primário do sistema (ax-01, ax-02).** Portanto, a ordem correta é:

1. **Definir o agente** — agent card (quem ele é, capabilities, limites, autonomia)
2. **Definir o trabalho** — work items (o que precisa ser feito, dependências, quem executa)
3. **Definir os princípios** — bússola de decisão
4. **Definir o ambiente** — schemas, estrutura, envelopes, lenses
5. **Produzir conteúdo** — artefatos de domínio

**Consequências:**
- CLAUDE.md deveria ser DERIVADO do agent card, não escrito à mão
- Autonomy envelopes são propriedades do agente, não artefatos soltos
- Validation é uma capability de um agente de validação
- Work items no repositório transformam o humano de "operador" em "supervisor"

**Hoje o repo não tem:**
- Definição do agente (agent card)
- Representação de trabalho (work items, backlog, DAG de tarefas)
- Ligação entre agente e trabalho

---

## Dependências pendentes (TODO no topo do config.cue)

7 artefatos referenciados pelo config.cue que não existem:
- `architecture/artifact-schemas/lens.cue`
- `architecture/artifact-schemas/autonomy-envelope.cue`
- `architecture/artifact-schemas/tension-entry.cue`
- `architecture/artifacts/lenses/`
- `architecture/artifacts/governance/`
- `architecture/tension-log/`
- `architecture/validation-prompts/`

---

## Backlog completo (coletado nesta sessão)

### Infraestrutura do mesh-spec
- Criar schema CUE para agent card (perfis de agente)
- Criar schema CUE para work items (DAG de tarefas com dependências)
- Criar schema CUE para perfis de briefing humano
- Criar schema CUE para envelopes de decisão humana
- Criar schema CUE para escalações roteadas
- Criar protocolo de decomposição e priorização de trabalho no CLAUDE.md
- Criar diretório operations/human-interfaces/ com templates
- Criar tags de significância para commits/PRs (routine, notable, strategic, escalation)
- Expandir CI para validar coerência entre artefatos de diferentes domínios
- Criar mecanismo de resolução de conflitos entre lenses
- Definir hierarquia de precedência entre blocos de lenses

### Lenses
- Criar as 35 novas lenses no formato do schema #AnalyticalLens

### Agente de briefing
- Criar perfil de agente do CEO briefing
- Definir template de briefing diário
- Implementar agente que lê estado do repo e gera briefing
- Rodar, testar e refinar antes de criar briefings para outros humanos

### Identidade de marca e sistema de design
- Definir os 6 princípios de marca como artefatos formais
- Criar design token system (paleta, tipografia, espaçamento, elevação)
- Definir tom de voz e linguagem da marca
- Criar primeiros componentes do sistema de design

### Ações humanas (sem agentes)
- Encontrar advogado de regulação financeira e validar estrutura (FIDC, SCD, SCFI)
- Identificar 2-3 relacionamentos no setor de construção civil (anchor tenants)
- Começar a construir em público (posts sobre tese, arquitetura, lenses)
- Mapear ecossistema fintech brasileiro para identificar potencial CTO
- Identificar advisors de mercado de capitais/estruturação financeira

---

## Para retomar

O próximo passo decidido: **criar o schema de agent card** (`architecture/artifact-schemas/agent-card.cue`), porque o agente é o ator primário e tudo mais deriva dele.

Após o agent card: criar schema de work item, depois popular o backlog acima como instâncias CUE no repositório.

O `domain/domain-definition.cue` (com foundingPrinciples) está desenhado mas não escrito — pode ser criado em paralelo ou após o agent card, conforme preferência do founder.

**Referências importantes no repo:**
- `architecture/artifact-schemas/domain-definition.cue` — schema existente (145 linhas, 3 rounds de red team)
- `architecture/design-principles.cue` — 13 princípios de design (P0-P12)
- `governance/claude/config.cue` — fonte do CLAUDE.md (203 linhas, 16 seções)
- `governance/claude/schema.cue` — schema de #Section e #AgentConfig
- `governance/claude/output.cue` — template que gera CLAUDE.md

**Referências fora do repo (mesh-architecture/):**
- `agent-map-principles-mesh-ecl.md` — 7 premissas fundacionais + 24 princípios de agentes
- `mesh-domain-model.md` — modelo de domínio estratégico (20 subdomínios)
- Todos os documentos de DDD (big-picture, process-level, wave-0, BCs, aggregates, etc.)

**Ferramentas:**
- CUE CLI v0.16.0 em `~/bin/cue` (requer `export PATH="$HOME/bin:$PATH"`)
- GitHub repo: `sw6n297mn8-maker/mesh-spec` (privado, branch main, HTTPS com gh credential helper)
- Geração CLAUDE.md: `cue export ./governance/claude -e output --out text > CLAUDE.md`
