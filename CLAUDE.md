# mesh-spec — Instruções para Agentes

## Idioma

Comunicação em português brasileiro. Termos técnicos (DDD, CUE, CloudEvents) em inglês. Comentários e campos `rationale` dentro de arquivos .cue em português brasileiro.

## Modelo de Operação

O agente opera via conversa no Claude Code: propõe conteúdo no chat, o founder aprova, o agente escreve o arquivo e commita na branch ativa. Não cria branches nem PRs no workflow atual. O founder é a única autoridade de aprovação. O modelo de 3 tiers (Read/Propose/Decide) do README governa o cenário futuro com múltiplos agentes — este CLAUDE.md governa o agente atual.

## Escopo

Este CLAUDE.md governa operações dentro de mesh-spec/ exclusivamente. Nunca modificar arquivos fora deste repositório. Documentos em diretórios adjacentes (mesh-architecture/*.md) são fontes de conhecimento para leitura, não alvos de edição.

## Regra Fundamental

Este repositório é a autoridade do sistema. Toda mudança é uma decisão de design. Antes de criar ou alterar qualquer artefato, leia o contexto ao redor (canvas.cue do BC, invariants.cue, design-principles.cue) para entender o porquê do que existe.

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
| Alterar CLAUDE.md | README.md (para consistência de referências cruzadas) |
| Alterar README.md | governance/repo-structure.cue (para consistência de estrutura) |
