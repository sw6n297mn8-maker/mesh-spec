package claude

// TODO: proposta pendente referencia artefatos que precisam ser criados:
//   - architecture/artifact-schemas/lens.cue (schema de lenses analíticas)
//   - architecture/artifact-schemas/autonomy-envelope.cue (schema de envelopes de governança)
//   - architecture/artifact-schemas/tension-entry.cue (schema de tension-log)
//   - architecture/lenses/ (diretório de lenses)
//   - architecture/artifacts/governance/ (diretório de autonomy envelopes)
//   - architecture/tension-log/ (diretório de tensões registradas)
//   - architecture/validation-prompts/ (diretório de prompts de validação semântica)

config: #AgentConfig & {
	repo:    "mesh-spec"
	heading: "Instruções para Agentes"
	sections: [
		{
			title:           "Idioma"
			canonicalSource: "self"
			content:         "Comunicação em português brasileiro. Termos técnicos (DDD, CUE, CloudEvents) em inglês. Comentários e campos `rationale` dentro de arquivos .cue em português brasileiro."
			rationale:       "Agentes defaultam para inglês sem instrução explícita."
		},
		{
			title:           "Modelo de Operação"
			canonicalSource: "self"
			content: #"""
				O agente opera via conversa no Claude Code: propõe conteúdo no chat, o founder aprova, o agente escreve o arquivo e commita na branch ativa. Não cria branches nem PRs — gestão de branches é responsabilidade do usuário. O founder é a única autoridade de aprovação. O modelo de 3 tiers (Read/Propose/Decide) do README governa o cenário futuro com múltiplos agentes — este CLAUDE.md governa o agente atual.

				Axiomas operacionais (domain/domain-definition.cue seção foundingPrinciples.axioms) são hipóteses estratégicas, não verdades absolutas. Aplique-os como diretriz padrão.
				Quando uma decisão concreta tensionar um axioma — a melhor solução aparente contradiz o axioma — não ignore silenciosamente:
				1. No artefato: registrar a tensão no campo rationale com (a) qual axioma, referenciando o id; (b) por que a decisão diverge.
				2. No tension-log: criar arquivo em architecture/tension-log/ conforme o schema architecture/artifact-schemas/tension-entry.cue, com id incremental.
				3. No output: sinalizar com a tag [TENSÃO: ax-XX].
				"""#
			rationale: "Modo atual difere dos 3 tiers do README; regra explícita evita conflito. Sem instrução sobre tensões, o agente trata axiomas como regras absolutas ou os ignora silenciosamente. Registro em três camadas garante visibilidade imediata (output), contexto local (rationale) e padrão acumulado (tension-log)."
		},
		{
			title:           "Escopo"
			canonicalSource: "self"
			content:         "Este CLAUDE.md governa operações dentro de mesh-spec/ exclusivamente. Nunca modificar arquivos fora deste repositório. Documentos em diretórios adjacentes (mesh-architecture/*.md) são fontes de conhecimento para leitura, não alvos de edição."
			rationale:       "Previne edição acidental de documentos de design fora do repo."
		},
		{
			title:           "Regra Fundamental"
			canonicalSource: "self"
			content: #"""
				Este repositório é a autoridade do sistema. Toda mudança é uma decisão de design. Antes de criar ou alterar qualquer artefato, leia o contexto ao redor (canvas.cue do BC, invariants.cue, design-principles.cue) para entender o porquê do que existe.

				Este repositório distingue dois tipos de diretriz:
				1. Constraints invioláveis: integridade legal (e.g.: Bacen, SCD, LGPD, KYC/AML) e responsabilidade jurídica explícita (dp-10). Estas não são tensionáveis. Nenhuma decisão de design, velocidade ou conveniência as sobrepõe. Se não é possível fazer de forma legal e com responsabilidade jurídica identificável, não se faz.
				2. Axiomas e princípios operacionais: os axiomas e derivados em domain/domain-definition.cue seção foundingPrinciples. Estes são hipóteses estratégicas aplicadas como default. Podem ser tensionados com justificativa explícita conforme descrito no Modelo de Operação (seção 2).

				Quando houver conflito entre diretrizes, consultar domain/domain-definition.cue seção foundingPrinciples.conflictResolution para a hierarquia de precedência.
				"""#
			rationale: "Sem esta regra, agentes criam artefatos sem entender contexto existente. Sem a distinção entre inviolável e tensionável, o agente não sabe quais regras são absolutas e quais admitem justificativa."
		},
		{
			title:           "Zero Duplicação"
			canonicalSource: "self"
			content:         "Consequência direta de P0 (architecture/design-principles.cue): cada unidade de conhecimento possui exatamente uma localização canônica; todas as outras referências são ponteiros, nunca cópias. Este CLAUDE.md contém regras comportamentais e ponteiros para sources of truth. Nunca resumir, listar ou copiar conteúdo que vive no README.md ou em arquivos .cue. Violação desta regra é drift por construção."
			rationale:       "Instrução comportamental derivada de P0; princípio vive no design-principles.cue, aplicação comportamental vive aqui."
		},
		{
			title:           "Proposta Antes de Implementar"
			canonicalSource: "self"
			content: #"""
				Nunca escrever, criar, alterar ou deletar qualquer arquivo no repositório diretamente — incluindo arquivos temporários, notas de contexto, scripts auxiliares ou qualquer outro conteúdo. Toda escrita no repositório é uma decisão que requer aprovação. O ciclo é:
				1. Mostrar o conteúdo proposto no chat. Para arquivos grandes, mostrar as seções alteradas com contexto suficiente para o founder avaliar.
				2. Esperar aprovação explícita do founder.
				3. Só então escrever no arquivo.

				Correções de sintaxe CUE detectadas por `cue vet` (token faltando, vírgula, parêntese) não exigem novo ciclo de proposta — o agente corrige, mostra a correção, e prossegue. Mudanças estruturais (adicionar/remover campos, alterar tipos, renomear) sempre exigem proposta.
				"""#
			rationale: "Ciclo de aprovação humana protege contra qualquer escrita não revisada. A regra cobre todo tipo de arquivo — não apenas artefatos formais — porque qualquer conteúdo commitado no repo se torna parte do histórico permanente."
		},
		{
			title:           "Incerteza"
			canonicalSource: "self"
			content:         "Quando não souber se uma mudança conforma, se um naming está correto, ou se um artefato deveria existir: parar e perguntar ao founder. Nunca prosseguir com incerteza não declarada."
			rationale:       "Incerteza silenciosa produz artefatos incorretos que custam mais para corrigir depois."
		},
		{
			title:           "Estrutura do Repositório"
			canonicalSource: "self"
			content: #"""
				Antes de criar, mover ou deletar qualquer arquivo ou diretório:
				1. Leia governance/repo-structure.cue (se existir).
				2. Valide que a operação conforma com a estrutura declarada.
				3. Se a operação exige mudança estrutural (novo diretório, novo tipo de artefato), atualize repo-structure.cue E README.md antes de criar o arquivo.

				Se governance/repo-structure.cue ainda não existir, use a árvore declarada no README.md como referência.
				"""#
			rationale: "Procedimento comportamental; a estrutura canônica vive em repo-structure.cue ou README.md."
		},
		{
			title:           "Formato"
			canonicalSource: "README.md#P2"
			content:         "Todo artefato autoral é CUE. Exceções declaradas no README.md seção P2. Nunca criar arquivos markdown para conteúdo que pode ser CUE."
			rationale:       "Lista de exceções vive canonicamente no README.md P2; aqui apenas ponteiro + instrução comportamental."
		},
		{
			title:           "Artefatos Derivados"
			canonicalSource: "self"
			content:         "Nunca editar manualmente artefatos derivados — aqueles gerados por tooling ou derivados de outro artefato source. Na dúvida se um artefato é autoral ou derivado: se existe um source do qual ele pode ser regenerado, é derivado."
			rationale:       "Edição manual de derivados cria divergência que a próxima geração sobrescreve."
		},
		{
			title:           "Conformidade com Artifact Schemas"
			canonicalSource: "self"
			content:         "Todo .cue que é instância de um tipo de artefato (canvas, invariant, command, event, workflow, etc.) deve conformar com o schema correspondente em architecture/artifact-schemas/. Durante bootstrap (schemas ainda não criados), o agente valida contra a estrutura descrita no README. Após architecture/artifact-schemas/ estar populado, ausência de schema correspondente para um tipo conhecido é erro — não permissão para ignorar."
			rationale:       "Schemas validam estrutura via CI; bootstrap permite operação antes dos schemas existirem."
		},
		{
			title:           "Rationale Obrigatório"
			canonicalSource: "self"
			content:         "Todo elemento formal em CUE carrega um campo `rationale`: frase curta que registra por que aquela regra existe. Rationale não descreve o que a regra faz. Artefato sem rationale onde o schema exige = incompleto."
			rationale:       "Instrução comportamental derivada de P10; princípio vive no README, aplicação vive aqui."
		},
		{
			title:           "Convenções de Nomenclatura"
			canonicalSource: "README.md#Convenções de Nomenclatura"
			content: #"""
				Seguir a seção "Convenções de Nomenclatura" do README.md. Nomes de arquivo e diretório em inglês (exceto termos de domínio já canonizados no universal glossary ou na ubiquitous language do BC).
				"""#
			rationale: "Regras de naming vivem canonicamente no README; aqui apenas ponteiro + exceção resumida."
		},
		{
			title:           "Validação"
			canonicalSource: "self"
			content: #"""
				Rodar `cue vet` antes de qualquer commit. Se CUE CLI não estiver disponível, perguntar ao founder como proceder. CUE sintaticamente inválido nunca é commitado.

				Validação semântica deve ocorrer com separação de contexto — por execução isolada, sem acesso ao histórico da sessão que produziu o artefato.

				Após commit local de qualquer artefato CUE na branch ativa, o agente deve:
				1. Identificar quais arquivos commitados têm validation prompt correspondente em architecture/validation-prompts/ (matching via matchPatterns declarados nos prompts).
				2. Para cada match, disparar validação semântica em execução isolada com:
				   - path do artefato commitado
				   - path do validation prompt correspondente
				   - leitura do artefato, references e checks definidos no prompt
				3. Reportar findings ao usuário:
				   - fail: sempre reportar com contexto suficiente para decisão
				   - warn: incluir no output
				   - info: omitir por padrão, detalhar sob demanda
				4. O fluxo só é considerado concluído após resolução dos findings fail ou decisão explícita do usuário de aceitar a tensão.

				Se não existir validation prompt correspondente, prosseguir sem bloquear e registrar que o tipo ainda não entrou no regime de validação semântica.

				Hooks post-commit podem atuar como safety net para commits feitos fora do fluxo principal, enfileirando validações pendentes para processamento posterior.
				"""#
			rationale: "Gate comportamental; previne commits com CUE quebrado. Execução isolada satisfaz separação de contexto (zero histórico de autoria) sem depender de sessão separada manual. Findings alinhados com vocabulário do sistema (fail/warn/info). Ausência de validation prompt é registrada, não silenciada."
		},
		{
			title:           "Commits"
			canonicalSource: "self"
			content:         "Um commit por mudança lógica coesa. Mensagens em inglês, concisas, referenciando o artefato ou BC afetado."
			rationale:       "Commits atômicos facilitam bisect e auditoria."
		},
		{
			title:           "Referências por Tipo de Operação"
			canonicalSource: "self"
			content: #"""
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
				"""#
			rationale: "Lookup table comportamental; norma canônica vive nos próprios artefatos. Decisões irreversíveis com trigger restrito aos cinco domínios de impacto. Lenses com check de diretório vazio como primeira instrução, referências genéricas ao schema. Governança com autonomia zero por default. Envelopes e reversibilidade como mecanismos complementares."
		},
		{
			title:           "Autovalidação Pré-Proposta"
			canonicalSource: "governance/build-time/quality-gate.cue"
			content: #"""
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
				"""#
			rationale: """
				Ativa governance/build-time/quality-gate.cue como protocolo
				obrigatório de self-review antes da proposta de artefatos e
				exige evidência estruturada da execução. Mantém separação entre
				norma (quality-gate.cue), instrução comportamental (esta seção)
				e evidência auditável (self-review-report.cue).
				"""
		},
	]
}
