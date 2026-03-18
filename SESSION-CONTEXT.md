# Contexto de Sessão — 2026-03-17

Este arquivo é temporário. Existe para transferir contexto entre sessões. Pode ser deletado após a retomada.

---

## O que foi feito nesta sessão (2026-03-17)

### 1. `governance/repo-principles.cue` — COMMITADO E PUSHADO (b603390)

Princípios orientadores do repositório (RP1–RP10) extraídos do README.md para CUE formal.
- Prefixo RP (evita colisão com Design Principles P0–P12)
- Map keyed por ID com constraint `[ID=string]: #RepoPrinciple & {id: ID}`
- Bloco único `principles: { RP1: {...} ... RP10: {...} }`
- `_schema.location` com cardinality singleton
- 6 grupos: Organization, Format, Granularity, Consumption, Quality, Governance

### 2. Quality Gate — SOLUÇÃO DESENHADA E APROVADA, NÃO ESCRITA

Problema: o agente entrega rascunhos com gaps críticos que exigem 4-5 rounds de red-team manual do founder. Solução: camada de self-review pré-proposta.

**Conteúdo completo de `governance/quality-gate.cue` foi proposto e aprovado com 5 ajustes do founder:**
1. Tabela corrigida: cue vet dentro do loop, não como camada separada
2. maxRounds: 3 (3 internos + ~1 do founder ≈ paridade com os 4-5 manuais)
3. Transparência escalonada: uma linha sempre, detalhes só em falha ou sob demanda
4. uq-02: especificidade para domínio da Mesh como critério "fail" próprio (teste: "substituir Mesh por qualquer fintech")
5. migrationTrigger explícito: 400 linhas OU 8+ tipos → migrar para `_qualityCriteria` nos schemas

**Camadas de validação (modelo aprovado):**

| Camada | Quando | Quem | O que valida |
|---|---|---|---|
| Self-review (NOVA) | Pré-proposta, loop interno | Mesmo agente | cue vet + crítica semântica contra critérios universais e por tipo |
| Procedural (quality gates) | Pré-commit | Mesmo agente | Checklist de completude do task template |
| Semântica (validation prompts) | Pós-commit, sessão separada | Agente diferente | Viés, blind spots, coerência profunda |

---

## Artefatos pendentes (sequência de implementação)

### 2a. Criar `governance/quality-gate.cue` — CONTEÚDO APROVADO

**Schemas:** `#Severity`, `#QualityCriterion`, `#TypeSpecificCriteria`, `#TransparencyPolicy`, `#MigrationTrigger`, `#SelfReviewProtocol`

**selfReviewProtocol:**
- maxRounds: 3
- stabilityCondition: nenhum finding "fail" na última passada
- exitOnMaxRounds: propor com disclaimer + findings não resolvidos
- deterministicGate: cue vet como primeiro passo de cada round
- transparency: always (1 linha), onFailure (listar fails), onRequest (detalhes das correções)
- migrationTrigger: 400 linhas OU 8+ tipos

**7 critérios universais (severity=fail exceto uq-05=warn):**
- uq-01: Rationale explica WHY, não WHAT
- uq-02: Especificidade Mesh (teste fintech)
- uq-03: Referências cruzadas existem
- uq-04: Consistência com design/repo principles
- uq-05: Limitações declaradas (warn)
- uq-06: Ubiquitous language
- uq-07: Zero placeholder

**5 blocos de critérios por tipo:**
- adr: 3 critérios (alternativas com rationale, metadata específica, paths reais em affectedArtifacts)
- canvas: 3 critérios (custos específicos, classificação justificada, capabilities reais vs aspiracionais)
- domain-definition: 2 critérios (mecanismos concretos, fronteiras testáveis)
- lens: 2 critérios (ativação testável, protocolo concreto)
- artifact-schema: 2 critérios (constraints de domínio, _schema.location presente)

### 2b. Modificar `governance/claude/config.cue` — CONTEÚDO APROVADO

Nova seção "Autovalidação Pré-Proposta" entre "Incerteza" (seção 7) e "Estrutura do Repositório" (seção 8).
- canonicalSource: "governance/quality-gate.cue"
- Ciclo de 6 passos: gerar → cue vet → criticar universais → criticar tipo → revisar fails → repetir
- Formato: "Self-review: N/M rounds"
- Explicitamente NÃO substitui validation prompts

### 2c. Criar `architecture/adrs/adr-009-self-review-quality-gate.cue` — NÃO PROPOSTO AINDA

Deve documentar:
- Decisão de adicionar camada de self-review pré-proposta
- Alternativas consideradas
- migrationTrigger como decisão diferida com thresholds
- affectedArtifacts: governance/quality-gate.cue, governance/claude/config.cue, CLAUDE.md

### 2d. Regenerar CLAUDE.md

```
cue export ./governance/claude -e output --out text > CLAUDE.md
```

### 2e. Atualizar referências cruzadas ao README

Migrar ponteiros para `governance/repo-principles.cue`:

**governance/claude/config.cue (14 referências):**
- L96-98: canonicalSource "README.md#P2" → repo-principles.cue#RP2
- L116: rationale "P10" → repo-principles.cue
- L120-124: canonicalSource "README.md#Convenções de Nomenclatura" → TBD
- L164-168: tabela de referências → atualizar ponteiros
- L26, 34, 59, 88, 90, 92, 109: menções narrativas

**architecture/design-principles.cue L4:** "P1-P10 do README" → "RP1-RP10 de governance/repo-principles.cue"

**governance/repo-structure.cue L125:** rationale → atualizar

**architecture/adrs/ — NÃO ALTERAR** (registros históricos)

---

## Contexto da sessão anterior (2026-03-13) — ainda válido

### foundingPrinciples para domain-definition.cue — PROPOSTO, NÃO ESCRITO
7 axiomas (ax-01 a ax-07), 10 princípios derivados (dp-01 a dp-10), 4 níveis de resolução de conflito, reversibilityThreshold com 5 critérios. Ver detalhes na seção "Proposta de foundingPrinciples" abaixo.

### Insight de ordem de construção
O agente é o ator primário (ax-01, ax-02). Ordem: definir agente → definir trabalho → definir princípios → definir ambiente → produzir conteúdo. Próximo passo decidido: schema de agent card.

### 7 artefatos referenciados por config.cue que não existem
- architecture/artifact-schemas/lens.cue
- architecture/artifact-schemas/autonomy-envelope.cue
- architecture/artifact-schemas/tension-entry.cue
- architecture/artifacts/lenses/
- architecture/artifacts/governance/
- architecture/tension-log/
- architecture/validation-prompts/

---

## foundingPrinciples (proposta aceita, não escrita)

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

---

## Backlog completo

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

### Identidade de marca e sistema de design
- Definir os 6 princípios de marca como artefatos formais
- Criar design token system
- Definir tom de voz e linguagem da marca

### Ações humanas (sem agentes)
- Encontrar advogado de regulação financeira
- Identificar 2-3 anchor tenants no setor de construção civil
- Começar a construir em público
- Mapear ecossistema fintech brasileiro para potencial CTO
- Identificar advisors de mercado de capitais

---

## Referências importantes

**No repo:**
- `architecture/artifact-schemas/domain-definition.cue` — schema existente
- `architecture/design-principles.cue` — 13 princípios de design (P0-P12)
- `governance/claude/config.cue` — fonte do CLAUDE.md (16 seções)
- `governance/claude/schema.cue` — schema de #Section e #AgentConfig
- `governance/claude/output.cue` — template que gera CLAUDE.md
- `governance/repo-principles.cue` — NEW: 10 princípios do repo (RP1-RP10)
- `governance/repo-structure.cue` — escopo e validação estrutural

**Fora do repo (mesh-architecture/):**
- `agent-map-principles-mesh-ecl.md` — 7 premissas + 24 princípios de agentes
- `mesh-domain-model.md` — modelo de domínio estratégico (20 subdomínios)

**Ferramentas:**
- CUE CLI v0.16.0 em `~/bin/cue`
- GitHub repo: `sw6n297mn8-maker/mesh-spec` (privado)
- Geração CLAUDE.md: `cue export ./governance/claude -e output --out text > CLAUDE.md`
