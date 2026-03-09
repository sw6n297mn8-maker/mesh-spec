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

Nunca criar ou alterar artefatos diretamente. O ciclo é:
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

Validação semântica é executada com separação de contexto — nunca pelo mesmo agente na mesma sessão que produziu o artefato.
Após produzir qualquer artefato CUE, commitar na branch ativa. Verificar se existe validation prompt correspondente em architecture/validation-prompts/.
Se existir: NÃO executar na mesma sessão. Instruir o usuário a executar a validação em sessão separada do Claude Code antes de fazer merge (se em branch separada) ou antes de prosseguir com artefatos dependentes (se em main), indicando qual validation prompt usar e contra qual artefato. Formato:
  Artefato commitado em [nome da branch]: [path do artefato]
  Para validação semântica, execute em nova sessão:
    Validar [path do validation prompt] contra [path do artefato]
Se não existir: prosseguir sem validação semântica. Não reportar a ausência.
Na sessão de validação, o agente:
  1. Lê o artefato, o validation prompt, e referências declaradas no validation prompt.
  2. Reporta findings categorizados como: pass, warning, fail.
  3. Findings fail: reportar com contexto suficiente para que o usuário decida se é erro a corrigir ou tensão legítima a documentar.
  4. Findings warning: incluir no output.
  5. Findings pass: não mencionar individualmente.
Merge (se em branch) ou prosseguimento só após resolução de findings fail ou decisão explícita do usuário de aceitar a tensão.
Limitação conhecida: esta validação depende do usuário abrir a sessão separada. Quando o volume justificar, migrar para step automatizado do CI com API key dedicada.

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

Lenses analíticas (architecture/artifacts/lenses/):
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
