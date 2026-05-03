# mesh-spec — Instruções para Agentes

## Idioma

Comunicação em português brasileiro. Termos técnicos (DDD, CUE, CloudEvents) em inglês. Comentários e campos `rationale` dentro de arquivos .cue em português brasileiro.

## Modelo de Operação

O agente opera via conversa no Claude Code: propõe conteúdo no chat, o founder aprova, o agente escreve o arquivo e commita na branch ativa. Não cria branches nem PRs — gestão de branches é responsabilidade do usuário. O founder é a única autoridade de aprovação. O modelo de 3 tiers (Read/Propose/Decide) do README governa o cenário futuro com múltiplos agentes — este CLAUDE.md governa o agente atual.

Axiomas operacionais (domain/domain-definition.cue seção foundingPrinciples.axioms) são hipóteses estratégicas, não verdades absolutas. Aplique-os como diretriz padrão.
Quando uma decisão concreta tensionar um axioma — a melhor solução aparente contradiz o axioma — não ignore silenciosamente:
1. No artefato: registrar a tensão no campo rationale com (a) qual axioma, referenciando o id; (b) por que a decisão diverge.
2. No tension-log: criar arquivo em architecture/tension-log/ conforme o schema architecture/artifact-schemas/tension-entry.cue, com id incremental.
3. No output: sinalizar com a tag [TENSÃO: ax-XX].

## Escopo

Este CLAUDE.md governa operações dentro de mesh-spec/ exclusivamente. Nunca modificar arquivos fora deste repositório. Documentos em diretórios adjacentes (mesh-architecture/*.md) são fontes de conhecimento para leitura, não alvos de edição.

## Regra Fundamental

Este repositório é a autoridade do sistema. Toda mudança é uma decisão de design. Antes de criar ou alterar qualquer artefato, leia o contexto ao redor (canvas.cue do BC, invariants.cue, design-principles.cue) para entender o porquê do que existe.

Este repositório distingue dois tipos de diretriz:
1. Constraints invioláveis: integridade legal (e.g.: Bacen, SCD, LGPD, KYC/AML) e responsabilidade jurídica explícita (dp-10). Estas não são tensionáveis. Nenhuma decisão de design, velocidade ou conveniência as sobrepõe. Se não é possível fazer de forma legal e com responsabilidade jurídica identificável, não se faz.
2. Axiomas e princípios operacionais: os axiomas e derivados em domain/domain-definition.cue seção foundingPrinciples. Estes são hipóteses estratégicas aplicadas como default. Podem ser tensionados com justificativa explícita conforme descrito no Modelo de Operação (seção 2).

Quando houver conflito entre diretrizes, consultar domain/domain-definition.cue seção foundingPrinciples.conflictResolution para a hierarquia de precedência.

## Zero Duplicação

Consequência direta de P0 (architecture/design-principles.cue): cada unidade de conhecimento possui exatamente uma localização canônica; todas as outras referências são ponteiros, nunca cópias. Este CLAUDE.md contém regras comportamentais e ponteiros para sources of truth. Nunca resumir, listar ou copiar conteúdo que vive no README.md ou em arquivos .cue. Violação desta regra é drift por construção.

## Proposta Antes de Implementar

Nunca escrever, criar, alterar ou deletar qualquer arquivo no repositório diretamente — incluindo arquivos temporários, notas de contexto, scripts auxiliares ou qualquer outro conteúdo. Toda escrita no repositório é uma decisão que requer aprovação. O ciclo é:
1. Mostrar o conteúdo proposto no chat. Para arquivos grandes, mostrar as seções alteradas com contexto suficiente para o founder avaliar.
2. Esperar aprovação explícita do founder.
3. Só então escrever no arquivo.

Correções de sintaxe CUE detectadas por `cue vet` (token faltando, vírgula, parêntese) não exigem novo ciclo de proposta — o agente corrige, mostra a correção, e prossegue. Mudanças estruturais (adicionar/remover campos, alterar tipos, renomear) sempre exigem proposta.

## Incerteza

Quando não souber se uma mudança conforma, se um naming está correto, ou se um artefato deveria existir: parar e perguntar ao founder. Nunca prosseguir com incerteza não declarada.

## Estrutura do Repositório

Antes de criar, mover ou deletar qualquer arquivo ou diretório:
1. Leia governance/repo-structure.cue (se existir).
2. Valide que a operação conforma com a estrutura declarada.
3. Se a operação exige mudança estrutural (novo diretório, novo tipo de artefato), atualize repo-structure.cue E README.md antes de criar o arquivo.

Se governance/repo-structure.cue ainda não existir, use a árvore declarada no README.md como referência.

## Formato

Todo artefato autoral é CUE. Exceções declaradas no README.md seção P2. Nunca criar arquivos markdown para conteúdo que pode ser CUE.

## Artefatos Derivados

Nunca editar manualmente artefatos derivados — aqueles gerados por tooling ou derivados de outro artefato source. Na dúvida se um artefato é autoral ou derivado: se existe um source do qual ele pode ser regenerado, é derivado.

## Conformidade com Artifact Schemas

Todo .cue que é instância de um tipo de artefato (canvas, invariant, command, event, workflow, etc.) deve conformar com o schema correspondente em architecture/artifact-schemas/. Durante bootstrap (schemas ainda não criados), o agente valida contra a estrutura descrita no README. Após architecture/artifact-schemas/ estar populado, ausência de schema correspondente para um tipo conhecido é erro — não permissão para ignorar.

## Rationale Obrigatório

Todo elemento formal em CUE carrega um campo `rationale`: frase curta que registra por que aquela regra existe. Rationale não descreve o que a regra faz. Artefato sem rationale onde o schema exige = incompleto.

## Convenções de Nomenclatura

Seguir a seção "Convenções de Nomenclatura" do README.md. Nomes de arquivo e diretório em inglês (exceto termos de domínio já canonizados no universal glossary ou na ubiquitous language do BC).

## Validação

Rodar `cue vet` antes de qualquer commit. Se CUE CLI não estiver disponível, perguntar ao founder como proceder. CUE sintaticamente inválido nunca é commitado.

Validação pós-commit é dividida em duas categorias com papéis distintos (per adr-040):

1. Estrutural (deterministic gate). Structural checks vivem em architecture/structural-checks/<artifactType>.cue e implementam regras declarativas (kinds: required-block, reference-exists, same-artifact-consistency, conditional-file-presence). São o ÚNICO mecanismo de validação pós-commit que pode bloquear o fluxo. Reproduzíveis, auditáveis, sem variância entre execuções.

2. Semântica advisory (design review interpretativo). Validation prompts vivem em architecture/validation-prompts/validate-<artifactType>.cue e produzem revisão por agente em sessão isolada. Findings são RECOMENDAÇÕES para decisão do founder, NUNCA veredito de gate. Cobrem dimensões interpretativas (genuinidade de contornos, qualidade adversarial de análise, coerência semântica) que estrutura não alcança.

Após commit local de qualquer artefato CUE na branch ativa, o agente deve:

1. Identificar quais structural-checks aplicam-se ao artefato (matching por artifactType + canonicalPathRegex declarado no schema). Para cada match, executar a regra. Violações estruturais bloqueiam o fluxo até correção da instância ou alteração explícita da regra por decisão arquitetural.

2. Identificar quais validation prompts aplicam-se (matching via matchPatterns declarados nos prompts). Para cada match, disparar revisão advisory em execução isolada com:
   - path do artefato commitado
   - path do validation prompt correspondente
   - leitura do artefato, references e checks definidos no prompt

3. Reportar findings advisory ao usuário como recomendação:
   - strong recommendation (mapeia para severity=fail no schema): recomendação forte de revisão; reportar com contexto suficiente para decisão
   - warning (mapeia para severity=warn no schema): incluir no output
   - info: omitir por padrão, detalhar sob demanda

   Findings advisory NUNCA bloqueiam o fluxo. O agente prossegue após o reporte; a decisão de aplicar, ignorar ou registrar como tensão pertence ao founder.

4. Se não existir structural-check correspondente, prosseguir sem bloquear e registrar explicitamente que o artifactType ainda não está coberto por gate estrutural.

5. Se não existir validation prompt correspondente, prosseguir sem bloquear e registrar explicitamente que o artifactType ainda não está coberto por design review advisory.

Hooks post-commit podem atuar como safety net para commits feitos fora do fluxo principal, enfileirando validações pendentes para processamento posterior.

Princípio (P10): agentes estocásticos recomendam, gates determinísticos validam. Qualquer uso de LLM como mecanismo de gate viola este princípio — ten-006 documenta a impossibilidade de tratar LLM como gate determinístico e adr-040 formaliza a separação categórica entre as duas camadas.

## Commits

Um commit por mudança lógica coesa. Mensagens em inglês, concisas, referenciando o artefato ou BC afetado.

## Referências por Tipo de Operação

| Antes de... | Ler obrigatoriamente |
|---|---|
| Criar ou alterar artefato de BC | canvas.cue do BC + artifact-schema correspondente + golden-examples/ do BC (se existirem) |
| Criar ou alterar artefato de arquitetura | architecture/design-principles.cue |
| Criar ou mover arquivo/diretório | governance/repo-structure.cue (ou README.md) |
| Nomear qualquer arquivo | README.md seção Convenções de Nomenclatura |
| Deletar artefato | Verificar quem consome: interaction-contracts.cue, context-dependencies.cue, policies.cue (trigger refs), projections.cue (source refs) |
| Alterar CLAUDE.md | governance/claude/config.cue (fonte) + README.md (referências cruzadas) |
| Alterar README.md | governance/repo-structure.cue (para consistência de estrutura) |
| Criar ou alterar semanticamente artefato estrutural em architecture/ ou governance/ | Criar ADR correspondente em architecture/adrs/ no mesmo commit. ADR deve referenciar os paths afetados em affectedArtifacts. |

Classificação de mudanças para fins de ADR:
  - Semântica: altera significado, política, tipo, relação ou constraint de artefatos estruturais (schemas, princípios, protocolos, governance). → exige ADR.
  - Instanciação: cria instância de um tipo já definido por schema existente (lense, canvas, subdomain, etc.) sem alterar o schema. → não exige ADR. A decisão de design foi registrada no ADR do schema.
  - Editorial: corrige typo, melhora redação sem alterar semântica. → não exige ADR.
  - Mecânica: ajuste de sintaxe CUE detectado por cue vet, reformatação. → não exige ADR.
  - Derivada: regeneração de artefato a partir de source canônico. → não exige ADR.
  Na dúvida se uma mudança é semântica ou editorial: é semântica. Errar para o lado de registrar.

Supersession de ADRs:
  Quando um ADR novo substitui outro, atualizar os dois no mesmo commit:
  - ADR novo: incluir id do antigo em supersedes.
  - ADR antigo: alterar status para "superseded" e preencher supersededBy com id do novo.
  Isto minimiza a janela de inconsistência relacional que o CI (phase adr-consistency) valida.

Decisões irreversíveis:
  → Antes de implementar uma decisão que possa afetar:
    - Schema de dados persistidos em SoTs.
    - Contratos públicos (APIs, eventos consumidos por terceiros).
    - Estrutura de isolamento entre tenants.
    - Obrigações legais, fiscais ou regulatórias.
    - Dados em produção.
  → Escalar ao usuário por default. Apresentar: qual decisão, quais critérios de irreversibilidade são satisfeitos, quais alternativas existem, e recomendação fundamentada.
  → Isto se aplica independentemente de existir autonomy envelope. Envelopes governam ações operacionais. Reversibilidade governa decisões estruturais. São mecanismos complementares.
  → Referência completa dos critérios: domain/domain-definition.cue seção foundingPrinciples.conflictResolution.reversibilityThreshold.

Lenses analíticas (architecture/lenses/):
  → Se o diretório de lenses estiver vazio, proceder com princípios apenas.
  → Para qualquer decisão que não seja trivialmente resolvida pelos princípios, consultar as lenses disponíveis.
  → Comparar o tipo de decisão contra os critérios de ativação definidos no schema da lente.
  → Se uma ou mais lenses fizerem match, carregá-las.
  → Se múltiplas lenses fizerem match, verificar no schema se devem ser usadas em conjunto.
  → Aplicar o protocolo de raciocínio da lente como sequência de perguntas antes de chegar à recomendação.
  → Referenciar a lente utilizada no rationale do artefato produzido.
  → Se nenhuma lente fizer match, proceder com princípios apenas.

Governança (architecture/artifacts/governance/):
  → Para ações sobre o sistema (aprovar, rejeitar, escalar, configurar limites, alterar parâmetros operacionais), consultar o autonomy envelope aplicável ao domínio da decisão.
  → Se existir envelope: nenhuma ação que o ultrapasse é permitida sem escalação ao humano designado.
  → Se não existir envelope: escalar ao usuário por default. O agente não atua autonomamente em domínios sem envelope definido. Apresentar a decisão ao usuário com contexto e recomendação, e sugerir criação de envelope se o padrão de decisão for recorrente.

Validation prompts (architecture/validation-prompts/):
  → Após produzir qualquer artefato, executar conforme seção 14.

## Autovalidação Pré-Proposta

Antes de propor qualquer artefato ao founder, o agente deve
executar o protocolo de self-review definido em
governance/build-time/quality-gate.cue e emitir um relatório
estruturado conforme governance/build-time/self-review-report.cue.

Esta seção não redefine o protocolo. O agente deve resolver
critérios, severidades, rounds, condição de saída e regras de
transparência exclusivamente a partir do artefato canônico.

O agente não deve reimplementar, resumir nem simplificar o
protocolo por memória. Deve consumi-lo diretamente como fonte
de verdade operacional.

O artefato só pode ser proposto quando:
- a condição de saída definida no artefato canônico for satisfeita, e
- o relatório estruturado de self-review tiver sido produzido.

Transparência obrigatória:
- Sempre reportar o resultado do self-review ao propor o artefato.
- Se houver findings não resolvidos, listá-los explicitamente.
- Sob demanda, detalhar as correções realizadas em cada round.

## Authoring Declarativo

Esta seção complementa "Autovalidação Pré-Proposta": authoring é
a fase de criação que precede self-review. Authoring declarativo
substitui aplicação manual ad-hoc do meta-guide por dispatch
codificado em policy CUE — para tipos com volume suficiente
para justificar a automação.

Quando o agente identifica necessidade de criar um artefato
governado (artifactType com schema em architecture/artifact-
schemas/) cujo tipo esteja registrado em authoring-policy.cue
rollout com mode "subagent-drafted", deve aplicar o dispatch
declarativo per adr-054 em vez de authoring manual.

Esta seção não redefine a policy. O agente deve resolver mode,
triggerCondition, inputContract, outputContract, promptTemplate
e fallbackPolicy exclusivamente a partir do artefato canônico
governance/build-time/authoring-policy.cue.

O agente não deve reimplementar, resumir nem simplificar a
policy por memória. Deve consumi-la diretamente como fonte de
verdade operacional.

Para artifactTypes não registrados no rollout ou registrados
com mode "manual": agente segue authoring manual aplicando o
meta-guide (architecture/production-guides/production-guide.cue)
ou production-guide específico do tipo quando existir.

Pré-condição de instância (cascade ordering): production-guide
para schema X deve existir antes de authoring de qualquer
instância de X. Antes de criar instância de artifactType com
schema em architecture/artifact-schemas/, o agente verifica
que architecture/production-guides/{type}.cue existe. Se
ausente: cria PG primeiro (manual em Phase 0; via dispatch
em Phase 1+ quando type registrado em rollout) e aguarda
founder approval do PG antes de proceder à instância. Regra
deriva de adr-053 universal coverage + adr-054 decision
item 13. Recursão aplica se a instância também é registrada
para subagent-drafted authoring.

Phase 0: schema #AuthoringPolicy e instância authoringPolicy
materializadas; primeira execução real de subagent dispatch
para authoring ocorre após WI-069 (implementação de Phase 1).
Em Phase 0, o agente apenas informa que o artifactType seria
elegível para dispatch; NÃO invoca subagent nem trata draft
como subagent-drafted; authoring permanece manual até ativação
operacional.

Pós-dispatch (Phase 1+, quando review subagent estiver
operacional): draft retornado pelo subagent ainda passa por
self-review per "Autovalidação Pré-Proposta". Per adr-054
decision item 10, review subagent é SEPARADO do authoring
subagent — isolation reduz viés de auto-ratificação. Authoring
policy NÃO substitui self-review; precede e complementa.

Founder review permanece gate final em todos os casos
(P10 + adr-054). Subagent draft é proposta, não decisão.

Transparência obrigatória ao propor artefato subagent-drafted
ao founder. Veículo: registrar na proposta ao founder e, quando
houver commit, no commit message ou session log. Conteúdo
obrigatório:
- Registrar que houve dispatch (vs authoring manual)
- Apresentar reasoning report retornado pelo authoring subagent
- Apresentar findings do review subagent (per quality-gate.cue
  executionPolicy)
- Quando fallback manual ocorre: documentar motivo no commit
  message ("subagent dispatch failed: {motivo}; manual takeover")

Failure rate de subagent dispatches é métrica observável
registrada no execution log ou em métrica equivalente definida
pela quality-gate policy, usada para calibração de promptTemplate
ao longo do tempo.

## Aplicação de Production Guides

Esta seção complementa "Authoring Declarativo": quando o agente
autora instância de tipo com production-guide existente em modo
manual (defaultMode "manual" OU tipo sem rollout entry, caindo
em defaultMode "manual"), aplica manualAuthoringProtocol
declarado em governance/build-time/authoring-policy.cue.

Esta seção não redefine o protocolo. O agente deve resolver
applicabilityCondition, sectionGate, founderConfirmation,
serializationRule, selfReviewScope, failureMode e
trivialCorrectionException exclusivamente a partir do artefato
canônico.

O agente não deve reimplementar, resumir nem simplificar o
protocolo por memória. Deve consumi-lo diretamente como fonte
de verdade operacional.

Sistema de defesa em 3 camadas (per adr-057):
- Camada 1: structural-check production-guide-coverage
  (sc-pg-01 per adr-056) garante PG existe ANTES de instância
  de schema tipado.
- Camada 2: manualAuthoringProtocol section gates (per adr-057)
  garante PG é seguido section-by-section durante autoria —
  founder confirma cada section antes de progressão.
- Camada 3: uq-09 em quality-gate.cue valida post-hoc
  conformidade aos section gates.

Para artifactTypes em rollout com mode "subagent-drafted":
dispatch authoring subagent per "Authoring Declarativo";
manualAuthoringProtocol NÃO aplica (subagentes não são
governados por este protocolo; seguem inputContract/output-
Contract e quality-gate próprios per adr-054).

## Deferimento Consciente Governado

Quando o agente ou founder decidem NÃO resolver agora um
problema identificado — tipicamente ao escolher cobertura
parcial em vez de completa — o deferimento consciente deve
ser registrado per adr-062 como instância de
#DeferredDecision em architecture/deferred-decisions/, NÃO
como prose em "Known gaps declarados" em ADR e NÃO como
WI rotineiro em task-approved sem trigger.

Esta seção não redefine o schema. O agente deve resolver
lifecycle, kinds de trigger, contratos de OriginRef e
constraints exclusivamente a partir do artefato canônico
architecture/artifact-schemas/deferred-decision.cue + PG
correspondente architecture/production-guides/deferred-
decision.cue.

O agente não deve reimplementar, resumir nem simplificar
o protocolo por memória. Deve consumi-lo diretamente como
fonte de verdade operacional.

Critério de pertinência (anti-catch-all):
- Deferimento consciente: decisão explícita de não
  resolver agora COM trade-off articulado (custo evitado
  vs custo de continuar) E condição codificada de
  revisita.
- NÃO é deferred-decision: trabalho rotineiro pendente
  sem trade-off (esses são WIs em task-approved); tensão
  de design entre forças concorrentes (essas são
  tension-entries); bug ou gap travestido (esses
  deveriam virar WI per vc-te-01).

Naming: "deferimento consciente governado" — o termo
restrito evita o tipo virar dumping ground para
qualquer dívida técnica genérica.

Lifecycle automatizado:
- Status inicial 'open' no commit que cria def-XXX.
- Runner determinístico (scripts/ci/evaluate-deferred-
  triggers.sh) avalia triggers a cada commit em CI.
- Trigger fired → annotations no PR + step summary;
  runner NÃO muta arquivos.
- Founder revisa annotations e edita status manualmente
  (open → triggered) ou age sobre o deferimento (cria
  ADR/WI de resolução; status → resolved com resolvedBy
  populado).

ADRs pós-adr-062 SHOULD usar field defersTo (em #ADR
schema) referenciando def-XXX em vez de prose 'Known
gaps declarados'. ADRs pré-adr-062 mantêm prose
grandfathered; backfill é separate WI futuro.

Quando deferimento NÃO admite trigger automático
(decisão estratégica que só founder revisita; condição
não machine-evaluable): trigger kind 'manual-review' com
reason articulando POR QUE automação não é viável neste
caso — não usar como default por preguiça.
