package domain

// Instância de #DomainDefinition (architecture/artifact-schemas/domain-definition.cue).
// Artefato singleton — identidade do domínio Mesh.
//
// Convenção de namespacing: conteúdo encapsulado sob domainDefinition
// para evitar colisão top-level no package domain.
//
// Validação:
//   cue vet ./domain/domain-definition.cue ./architecture/artifact-schemas/domain-definition.cue -d '#DomainDefinition'

domainDefinition: {
	name:    "Mesh"
	tagline: "Sistema operacional do ciclo de compromissos econômicos em cadeias produtivas B2B — onde operação e dinheiro são primitivas nativas"

	coreThesis: {
		statement: """
			Cadeias produtivas B2B operam com uma separação estrutural entre
			operação, logística e dinheiro — cada etapa vive em sistema
			diferente, com linguagem diferente, sob governança diferente.
			O resultado: custos de transação desproporcionais, ciclos de
			pagamento longos, crédito caro e decisões baseadas em informação
			fragmentada. A Mesh elimina essa separação — não por integração
			de sistemas legados, mas porque evidência criptograficamente
			verificável, agentes de IA com gates determinísticos e fontes
			de verdade imutáveis são primitivas nativas do ciclo econômico
			inteiro, da demanda interna ao pagamento, do strategic sourcing
			à repercussão fiscal. Quatro resultados: crédito mais barato,
			governança contínua por dados transacionais, cadeias que se
			organizam sob governança e execução integrada.
			"""
		rationale: """
			A tese não é "digitalizar processos existentes" nem apenas
			"infraestrutura financeira" — é eliminar a separação estrutural
			entre quem opera e quem financia. Quando demanda, strategic
			sourcing, compromisso, execução, liquidação e repercussão vivem
			no mesmo sistema com evidência verificável, o custo de confiança
			cai a ponto de viabilizar crédito mais barato, governança
			contínua e cadeias que se auto-organizam sob governança. A
			construção civil brasileira é a vertical inicial — escolhida
			por concentrar os maiores custos de transação informacional e
			a menor digitalização — mas o padrão é transversal a qualquer
			cadeia produtiva B2B.
			"""
	}

	mechanisms: [{
		id:   "mech-evidence"
		name: "Lastreamento em Evidência"
		description: """
			Toda transição financeira exige evidência vinculada com integridade
			criptográfica (CAS, DSSE, Merkle proofs). A cadeia de evidência é
			tamper-evident em 6 camadas, do hash de conteúdo ao anchor externo.
			Dinheiro só se move quando a operação comprova.
			"""
		thesisConnection: """
			Elimina a assimetria informacional entre quem executa e quem financia.
			Em cadeias produtivas B2B, quem entrega (fornecedor, prestador) tipicamente
			não consegue provar execução de forma verificável por terceiros. Evidência
			verificável substitui confiança interpessoal por confiança computacional.
			"""
		stages: [
			"Captura de evidência no ponto de origem",
			"Verificação de integridade criptográfica",
			"Vinculação à operação financeira",
			"Registro imutável no Event Log",
			"Reconciliação determinística no Ledger",
			"Anchor externo para auditabilidade independente",
		]
		rationale: "Mecanismo central da tese: sem evidência verificável, operações financeiras dependem de confiança — e confiança não escala."
	}, {
		id:   "mech-agent-gate"
		name: "Agentes Estocásticos com Gates Determinísticos"
		description: """
			Agentes de IA recomendam e processam informação. Gates determinísticos
			validam invariantes, thresholds e aprovações antes de autorizar qualquer
			operação financeira. Gate autoriza; runtime executa. Nenhum agente executa
			commands financeiros diretamente. A fronteira é declarada na
			governança de agentes: architecture/agent-governance.cue (global)
			e contexts/{bc}/agents/{name}.governance.cue (per-agent envelope).
			"""
		thesisConnection: """
			Permite automação de processos que hoje exigem análise humana (verificação
			de execução, compliance, scoring) sem introduzir risco de execução
			financeira não-determinística. Velocidade de agente com segurança de gate.
			"""
		stages: [
			"Agente coleta e processa informação",
			"Agente emite recomendação estruturada",
			"Gate valida invariantes, thresholds e aprovações",
			"Gate autoriza command",
			"Runtime executa command autorizado",
		]
		rationale: "Separação estocástico/determinístico é o que permite usar IA em operações financeiras reguladas sem violar requisitos de auditabilidade."
	}, {
		id:   "mech-three-sots"
		name: "Três Sources of Truth Imutáveis"
		description: """
			O sistema possui exatamente três Sources of Truth: Event Log (fatos
			append-only), Ledger (valor double-entry), Workflow History (execução
			journal-based). Tudo mais é materialização descartável, reconstruível
			a partir dos SoTs. Correção é por novos eventos, nunca por mutação.
			"""
		thesisConnection: """
			Imutabilidade dos SoTs garante que o histórico de operações é auditável
			e não-repudiável. Em cadeias produtivas onde disputas sobre "o que
			aconteceu" são comuns e caras, ter uma fonte de verdade incontestável
			reduz custos de litígio e seguro.
			"""
		rationale: "Três SoTs não é arquitetura — é decisão de domínio. O domínio exige que fatos, valor e execução sejam fontes de verdade independentes e imutáveis."
	}, {
		id:   "mech-network"
		name: "Efeito de Rede Informacional"
		description: """
			Cada operação processada pela Mesh gera dados estruturados que alimentam
			modelos de scoring, precificação e análise de risco. Quanto mais
			participantes operam na rede, mais preciso o modelo se torna para todos.
			O flywheel informacional cria barreira de entrada progressiva.
			"""
		thesisConnection: """
			Cadeias produtivas B2B são mercados onde dados de performance são escassos
			e fragmentados. A Mesh acumula esses dados como subproduto da operação
			financeira, transformando informação operacional em vantagem competitiva
			estrutural.
			"""
		rationale: "Efeito de rede é o mecanismo de defensibilidade. Sem ele, a Mesh seria replicável por qualquer fintech com capital suficiente."
	}, {
		id:   "mech-scd"
		name: "SCD como Veículo Regulatório"
		description: """
			Sociedade de Crédito Direto (SCD) como entidade regulada pelo Bacen,
			operando sob arcabouço legal que permite emissão de crédito direto com
			funding próprio. Compliance regulatório (KYC/AML, LGPD, reporting Bacen)
			é constraint nativo, não camada adicional.
			"""
		thesisConnection: """
			SCD é o veículo que permite à Mesh operar como infraestrutura financeira
			própria em vez de depender de parceiros bancários. Controle do veículo
			regulatório é pré-condição para internalizar custos de transação que
			intermediários impõem.
			"""
		rationale: "Sem veículo regulatório próprio, a Mesh seria marketplace — não infraestrutura. A diferença é quem captura o valor da redução de custo."
	}]

	foundingPrinciples: {
		conflictResolution: {
			levels: [{
				level: 1
				name:  "Integridade Legal"
				description: """
					Compliance regulatório (Bacen, SCD, LGPD, KYC/AML) e
					responsabilidade jurídica explícita. Constraints invioláveis —
					não tensionáveis por nenhuma decisão de design.
					"""
				rationale: "Violar a lei não é trade-off — é risco existencial. Nenhuma velocidade ou conveniência justifica."
				principleIds: ["ax-07", "dp-04", "dp-05", "dp-10"]
			}, {
				level: 2
				name:  "Contenção de Dano"
				description: """
					Controle de blast radius, isolamento de falhas, proteção de
					dados em produção. Prioridade sobre otimizações de velocidade
					ou experiência.
					"""
				rationale: "Dano não contido se propaga. Em sistema financeiro multi-tenant, falha não isolada afeta todos os participantes."
				principleIds: ["ax-05", "dp-03", "dp-11"]
			}, {
				level: 3
				name:  "Operabilidade"
				description: """
					Capacidade do sistema de ser operado, mantido e evoluído por
					agentes e humanos. Inclui automação, redução de custos de
					transação e alinhamento de incentivos.
					"""
				rationale: "Sistema que não pode ser operado não entrega valor, independente de quão correto seja o design."
				principleIds: ["ax-01", "ax-02", "dp-01", "dp-02", "dp-08"]
				stageWeighting: {
					preProductMarketFit:  "Priorizar velocidade de iteração e aprendizado sobre eficiência operacional"
					postProductMarketFit: "Priorizar eficiência, resiliência e escalabilidade sobre velocidade de mudança"
					transitionTrigger:    "3+ tenants em produção com volume financeiro recorrente por 6+ meses"
				}
			}, {
				level: 4
				name:  "Evolução"
				description: """
					Capacidade de evoluir sem reescrita, acumular informação como
					ativo e escalar estruturalmente. Prioridade mais baixa, mas
					jamais ignorada — decisões que comprometem evolução devem
					ser explicitamente justificadas.
					"""
				rationale: "Evolução é o que diferencia infraestrutura de projeto. Sacrificar evolução é aceitar dívida técnica como destino."
				principleIds: ["ax-03", "ax-04", "ax-06", "dp-06", "dp-07", "dp-09"]
				stageWeighting: {
					preProductMarketFit:  "Aceitar dívida técnica local desde que não viole SoTs nem contratos públicos"
					postProductMarketFit: "Pagar dívida acumulada; investir em extensibilidade e backward compatibility"
					transitionTrigger:    "3+ tenants em produção com volume financeiro recorrente por 6+ meses"
				}
			}]

			reversibilityThreshold: {
				description: """
					Decisões que satisfazem qualquer um destes critérios são
					classificadas como irreversíveis e exigem escalação ao
					humano designado antes de implementação, independentemente
					de autonomy envelopes.
					"""
				criteriaForIrreversible: [
					"Afeta schema de dados persistidos em SoTs",
					"Altera contratos públicos (APIs, eventos consumidos por terceiros)",
					"Modifica estrutura de isolamento entre tenants",
					"Impacta obrigações legais, fiscais ou regulatórias",
					"Requer migração de dados em produção",
				]
			}
		}

		axioms: [{
			id: "ax-01"
			statement: """
				A Mesh é operada por IA. Agentes são os operadores primários do
				sistema — humanos supervisionam, escalam e decidem em pontos
				críticos. A arquitetura é desenhada para ser consumida e operada
				por agentes, não adaptada para eles depois.
				"""
			rationale: "Se agentes são afterthought, o sistema será otimizado para humanos e remendado para agentes — o pior dos dois mundos."
		}, {
			id: "ax-02"
			statement: """
				Software é feito para agentes com humans-in-the-loop. Interfaces
				humanas existem para supervisão, decisão e exceção — não para
				operação rotineira. O design default é agent-first; interfaces
				humanas são adicionadas onde necessário, não o contrário.
				"""
			rationale: "Inverter a polaridade (human-first com agent assist) limita a automação ao que humanos conseguem supervisionar em tempo real."
		}, {
			id: "ax-03"
			statement: """
				Pagar o custo de complexidade cedo. Decisões estruturais corretas
				são mais caras no curto prazo e mais baratas no longo prazo.
				A Mesh escolhe consistentemente a opção que reduz custo total
				de propriedade, não custo de implementação inicial.
				"""
			rationale: "Startups que otimizam só para velocidade inicial acumulam dívida que mata. Em fintech regulada, o custo de refazer é ordens de magnitude maior."
		}, {
			id: "ax-04"
			statement: """
				Decidir hoje o que gostaríamos de ter decidido em 5–10 anos.
				Cada decisão é avaliada pela pergunta: 'quando este sistema
				tiver 100x o volume atual, esta decisão ainda será correta?'
				Se não, qual decisão seria — e qual o custo de tomá-la agora?
				"""
			rationale: "Decisões de infraestrutura financeira são cumulativas. O custo de migrar dados, contratos e integrações cresce exponencialmente com o tempo."
		}, {
			id: "ax-05"
			statement: """
				Não assumir só o melhor cenário. Todo mecanismo crítico tem modo
				de falha documentado, blast radius definido e procedimento de
				contenção. O sistema é desenhado para funcionar quando as coisas
				dão errado, não apenas quando dão certo.
				"""
			rationale: "Em sistema financeiro, o cenário de falha não é 'inconveniente' — é perda monetária real, exposição regulatória e dano reputacional."
		}, {
			id: "ax-06"
			statement: """
				Maximizar efeitos de rede. Cada participante adicional na rede
				deve aumentar o valor para todos os existentes. Decisões de
				design que não contribuem para efeito de rede são neutras;
				decisões que o impedem são negativas.
				"""
			rationale: "Efeito de rede é o único mecanismo de defensibilidade que escala sublinearmente com investimento. Sem ele, vantagem competitiva é temporária."
		}, {
			id: "ax-07"
			statement: """
				Dinheiro e operação são primitivas nativas. O sistema não
				'integra com' serviços financeiros — ele é infraestrutura
				financeira. Ledger, compliance, evidência e auditoria são
				primitivas de primeira classe, não features adicionadas.
				"""
			rationale: "Tratar operações financeiras como integração cria latência, inconsistência e pontos de falha em cada boundary crossing."
		}]

		derived: [{
			id: "dp-01"
			statement: """
				Domínio antes de tecnologia. Decisões de domínio precedem
				decisões de tecnologia. A tecnologia serve o domínio, nunca
				o contrário. Quando uma restrição tecnológica conflita com
				um requisito de domínio, a tecnologia muda.
				"""
			rationale: "Tecnologia é substituível; domínio é identidade. Decisões de domínio erradas por conveniência tecnológica criam débito permanente."
			derivedFrom: ["ax-03", "ax-04"]
		}, {
			id: "dp-02"
			statement: """
				Volume financeiro sob governança como critério primário
				de valor. Toda feature, integração e decisão de design é
				avaliada pelo quanto contribui para aumentar o volume de
				obrigações financeiras que a plataforma enxerga, governa
				e pode otimizar — e pela taxa de ativação desse volume
				em serviços concretos (antecipação, netting, e futuros).
				"""
			rationale: """
				A tese econômica da Mesh é que cadeias produtivas operam
				com custo de transação desnecessariamente alto porque
				informação financeira e operacional estão separadas. A
				Mesh elimina essa separação. Custo de transação é a
				variável fundamental — mas não é observável diretamente
				em tempo real. Volume financeiro sob governança é o proxy
				operacional: quanto maior a superfície de obrigações que
				a Mesh enxerga e pode otimizar, maior o potencial de
				redução de custo para a cadeia.

				Uma obrigação está sob governança quando: ambos os lados
				são participantes ativos, a obrigação é confirmada, e
				dados são suficientes para a Mesh agir. Sem essas três
				condições: é pipeline, não governança.

				Health metrics testam se o proxy está conectado ao
				fundamento: spread comprime vs mercado (valor econômico
				real), default within predicted (qualidade do scoring),
				participant retention acima de 90% (rede é sticky),
				settlement em D+1 (velocidade), participant count
				crescente (diversificação), e eligible activation rate
				crescente (plataforma age, não apenas observa).

				Se volume sob governança cresce mas spread não comprime
				vs alternativas de mercado: proxy está desconectado do
				fundamento. Volume está sendo acumulado sem criar valor
				econômico real. Nesse cenário: investigar por que
				governança não está se traduzindo em redução de custo.

				Decisões devem maximizar volume sob governança e taxa de
				ativação, desde que health metrics permaneçam dentro de
				limites aceitáveis. Se uma decisão aumenta volume mas
				degrada qualquer health metric materialmente, ela deve
				ser rejeitada ou revista.

				Fricção que protege a rede (compliance, cessão
				formalizada, qualificação) é investimento em governança,
				não custo a ser eliminado. Recebível sem compliance não
				atinge elegibilidade, não conta como ativável, e não
				contribui para activation rate. Mais compliance = mais
				elegíveis = mais ativação.
				"""
			derivedFrom: ["ax-06", "ax-07"]
		}, {
			id: "dp-03"
			statement: """
				Controle de blast radius. Toda falha deve ter escopo contido
				e previsível. Isolamento entre tenants, entre bounded contexts
				e entre operações é invariante estrutural, não otimização.
				"""
			rationale: "Em sistema multi-tenant financeiro, falha não isolada afeta participantes que não têm relação com a causa. Isso é inaceitável regulatoriamente e comercialmente."
			derivedFrom: ["ax-03", "ax-05"]
		}, {
			id: "dp-04"
			statement: """
				Determinismo operacional. Operações financeiras produzem
				resultados previsíveis e reproduzíveis. Nenhuma operação
				financeira depende de output estocástico sem validação
				determinística intermediária.
				"""
			rationale: "Reguladores e auditores exigem que o sistema explique por que cada operação aconteceu. 'O modelo achou que era boa ideia' não é explicação aceitável."
			derivedFrom: ["ax-05", "ax-07"]
		}, {
			id: "dp-05"
			statement: """
				Auditabilidade total. Toda operação, decisão e transição de
				estado é rastreável até sua origem, com evidência verificável
				e cadeia de responsabilidade identificável. O sistema é
				auditável por construção, não por instrumentação posterior.
				"""
			rationale: "Auditabilidade adicionada depois é sempre incompleta. Auditabilidade by design é completa porque é pré-condição de operação, não feature."
			derivedFrom: ["ax-05", "ax-07"]
		}, {
			id: "dp-06"
			statement: """
				Escalabilidade estrutural. O sistema escala adicionando
				capacidade, não reescrevendo. Bounded contexts são unidades
				de deploy independentes. SoTs escalam horizontalmente.
				Novos produtos são novos BCs, não modificações nos existentes.
				"""
			rationale: "Escalabilidade que exige reescrita não é escalabilidade — é redesign. Infraestrutura financeira não pode parar para ser redesenhada."
			derivedFrom: ["ax-03", "ax-04", "ax-06"]
		}, {
			id: "dp-07"
			statement: """
				Evolução contínua sem reescrita. Schemas são versionados com
				backward e forward compatibility. Posting rules são versionadas.
				Workflows são versionados. Nenhuma mudança exige big bang
				migration — tudo coexiste durante a transição.
				"""
			rationale: "Big bang migrations são o modo mais comum de sistemas financeiros causarem incidentes. Coexistência de versões é mais cara de implementar e mais barata de operar."
			derivedFrom: ["ax-03", "ax-04"]
		}, {
			id: "dp-08"
			statement: """
				Incentive compatibility. O sistema alinha incentivos de todos
				os participantes. Cada ator se beneficia ao operar corretamente
				e paga custo ao tentar manipular. Custos de manipulação excedem
				benefícios potenciais por design.
				"""
			rationale: "Sistemas onde manipulação é mais barata que operação correta são explorados. Em cadeias produtivas com múltiplos atores, incentivos desalinhados são a norma — o sistema deve corrigir, não perpetuar."
			derivedFrom: ["ax-05", "ax-06"]
		}, {
			id: "dp-09"
			statement: """
				Acumulação informacional. Toda operação gera dados estruturados
				que alimentam modelos de scoring, precificação e análise de
				risco. Informação é ativo cumulativo — nunca descartada, sempre
				refinada. O valor da rede cresce com o volume de operações
				processadas.
				"""
			rationale: "Dados de performance em cadeias produtivas são escassos e fragmentados. Acumular esses dados como subproduto da operação cria vantagem competitiva que não pode ser comprada — só construída."
			derivedFrom: ["ax-06", "ax-07"]
		}, {
			id: "dp-10"
			statement: """
				Responsabilidade jurídica explícita. Toda operação com impacto
				financeiro, regulatório ou contratual tem responsável jurídico
				identificável. Nenhuma decisão consequente é tomada por sistema
				autônomo sem humano accountable. A cadeia de responsabilidade
				é rastreável do evento até a pessoa.
				"""
			rationale: "Em SCD regulada pelo Bacen, responsabilidade jurídica difusa é infração. O sistema deve tornar impossível a pergunta 'quem autorizou isso?' ficar sem resposta."
			derivedFrom: ["ax-05", "ax-07"]
		}, {
			id: "dp-11"
			statement: """
				Redundância de mecanismos críticos. Todo mecanismo cuja falha
				causa dano financeiro, regulatório ou reputacional possui ao
				menos um caminho alternativo de operação. Redundância não é
				duplicação — é independência de modo de falha. Dois componentes
				que falham pela mesma causa não são redundantes.
				"""
			rationale: "Mecanismo único sem redundância é ponto único de falha. Em infraestrutura financeira, ponto único de falha é risco existencial — não aceitável independente do custo de redundância."
			derivedFrom: ["ax-05", "ax-07"]
		}]
	}

	value: {
		costsEliminated: [{
			id:               "ce-01"
			cost:             "Custo de verificação de execução para liberação financeira"
			bearer:           "Financiador (banco, fundo, incorporadora)"
			mechanismRef:     "mech-evidence"
			thesisConnection: "Evidência criptograficamente verificável elimina necessidade de verificação presencial repetitiva e laudos manuais para liberar tranches financeiras."
			rationale:        "Na construção civil, isso aparece como medição de obra, vistoria técnica e laudo de engenheiro. Cada visita custa R$2-5k e atrasa liberação em dias. O padrão se repete em qualquer cadeia onde liberação financeira depende de comprovação de execução física."
		}, {
			id:               "ce-02"
			cost:             "Custo de compliance documental da operação"
			bearer:           "Tomador de crédito e financiador"
			mechanismRef:     "mech-agent-gate"
			thesisConnection: "Agentes processam e validam documentação automaticamente; gates garantem conformidade determinística com requisitos regulatórios."
			rationale:        "Compliance documental manual é lento, propenso a erro e caro. Cada operação de crédito exige dezenas de documentos verificados — processo que leva dias e envolve múltiplos profissionais. Na construção: CNDs, ARTs, alvarás, seguros. Em outras cadeias: documentação equivalente de habilitação e conformidade."
		}, {
			id:               "ce-03"
			cost:             "Custo de reconciliação financeira multi-sistema"
			bearer:           "Operador financeiro (SCD, banco)"
			mechanismRef:     "mech-three-sots"
			thesisConnection: "Ledger double-entry com posting rules determinísticas e Event Log imutável eliminam reconciliação manual entre sistemas."
			rationale:        "Reconciliação é trabalho que existe apenas porque sistemas diferentes discordam sobre o que aconteceu. SoTs imutáveis eliminam a divergência na origem."
		}, {
			id:               "ce-04"
			cost:             "Custo de avaliação de risco com dados incompletos"
			bearer:           "Financiador"
			mechanismRef:     "mech-network"
			thesisConnection: "Dados estruturados de performance acumulados pela rede alimentam modelos de scoring mais precisos que análises pontuais baseadas em demonstrativos contábeis."
			rationale:        "Análise de crédito tradicional em cadeias produtivas é cara e imprecisa porque se baseia em dados escassos e auto-reportados. Na construção: balanços de construtoras e laudos de engenharia. Dados operacionais verificados são superiores em qualquer cadeia."
		}, {
			id:               "ce-05"
			cost:             "Custo de intermediação financeira sem vantagem informacional"
			bearer:           "Tomador de crédito (sh-01)"
			mechanismRef:     "mech-scd"
			thesisConnection: "SCD própria elimina intermediários entre capital e tomador, internalizando o spread que bancos cobram por operações que a Mesh pode executar diretamente."
			rationale:        "Intermediação bancária adiciona custo sem adicionar informação. Quando o originador do crédito tem a informação, o intermediário é custo puro."
		}, {
			id:               "ce-06"
			cost:             "Custo de alongamento do ciclo de recebimento do fornecedor"
			bearer:           "Fornecedor (sh-02)"
			mechanismRef:     "mech-scd"
			thesisConnection: "SCD como veículo próprio permite antecipar recebíveis lastreados em evidência, eliminando o ciclo de pagamento que obriga o fornecedor a financiar a cadeia involuntariamente."
			rationale:        "É a dor mais aguda do fornecedor em qualquer cadeia produtiva B2B e o driver primário de adoção. Na construção: ciclos de 60–120 dias são norma. Resolver isso cria o incentivo de entrada na rede e alimenta o flywheel."
		}, {
			id:               "ce-07"
			cost:             "Custo de due diligence sobre lastro de recebíveis"
			bearer:           "Instituição financeira parceira (sh-03)"
			mechanismRef:     "mech-evidence"
			thesisConnection: "Evidência criptograficamente verificável substitui auditoria manual de lastro. O funding partner pode verificar a qualidade do portfólio programaticamente."
			rationale:        "sh-03 fornece capital — o input mais crítico. Sem proposta de valor explícita para funders, o flywheel tem dependência oculta sem incentivo declarado."
		}]

		capabilitiesCreated: [{
			id:               "cc-01"
			capability:       "Liberação financeira vinculada a evidência de execução em tempo real"
			enabledBy:        "mech-evidence"
			thesisConnection: "Evidência verificável automaticamente permite liberação de tranches em horas, não semanas. Ciclo de caixa do tomador melhora proporcionalmente."
			rationale:        "Capacidade inexistente no mercado atual. Liberação rápida vinculada a evidência é viável apenas com verificação computacional — inspeção humana não escala."
		}, {
			id:               "cc-02"
			capability:       "Scoring de risco baseado em dados operacionais verificados"
			enabledBy:        "mech-network"
			thesisConnection: "A rede acumula dados de performance real (prazos cumpridos, qualidade de entrega, histórico de compliance) que nenhum bureau de crédito possui."
			rationale:        "Depende da qualidade do lastro criptográfico (mech-evidence) e do volume de operações na rede (mech-network). Scoring sem evidência verificada é regressão ao modelo cadastral; sem volume, é amostra insuficiente."
		}, {
			id:               "cc-03"
			capability:       "Operação financeira 24/7 sem intervenção humana rotineira"
			enabledBy:        "mech-agent-gate"
			thesisConnection: "Agentes processam operações continuamente; gates garantem segurança. Humanos intervêm por exceção, não por rotina."
			rationale:        "Operação contínua reduz latência de processamento e elimina gargalos de horário bancário. Possível apenas com separação estocástico/determinístico."
		}, {
			id:               "cc-04"
			capability:       "Auditoria contínua e automatizada"
			enabledBy:        "mech-three-sots"
			thesisConnection: "SoTs imutáveis com cadeia de evidência permitem auditoria automatizada em tempo real, não auditoria periódica retroativa."
			rationale:        "Auditoria periódica descobre problemas tarde demais. Auditoria contínua previne — e é viável apenas quando os dados são estruturados e imutáveis."
		}, {
			id:               "cc-05"
			capability:       "Acesso programático a portfólios de recebíveis com evidência verificável e auditabilidade contínua"
			enabledBy:        "mech-evidence"
			thesisConnection: "Funding partners podem avaliar e monitorar portfólios de recebíveis em tempo real, com evidência criptográfica de cada ativo subjacente."
			rationale:        "Capacidade que transforma a relação com sh-03: de due diligence periódica e opaca para monitoramento contínuo e transparente. Reduz prêmio de risco exigido pelo funder."
		}]
	}

	flywheel: {
		description: """
			Ciclo de acumulação evidência → crédito → rede: cada evidência de
			execução validada gera receivable antecipável, que atrai fornecedores,
			que trazem tomadores, que produzem mais evidência. Cada volta do flywheel
			aumenta a barreira de entrada para concorrentes e o valor para
			participantes existentes. O ciclo é agnóstico à cadeia produtiva —
			funciona em qualquer vertical onde execução física gera evidência
			verificável.
			"""
		steps: [{
			id:        "fw-01"
			order:     1
			action:    "Participante submete evidência de execução à plataforma."
			feedsInto: "fw-02"
			rationale: "Evidência é o insumo primário do flywheel — sem ela não há receivable verificável. Na construção: medição de obra, entrega de material, aceite de serviço."
		}, {
			id:        "fw-02"
			order:     2
			action:    "Plataforma valida evidência com integridade criptográfica (CAS, DSSE, Merkle) e vincula ao receivable correspondente."
			feedsInto: "fw-03"
			rationale: "Transformar evidência bruta em receivable bankable — o gap entre 'execução alegada' e 'execução comprovada' é onde mora a fraude."
		}, {
			id:        "fw-03"
			order:     3
			action:    "Mesh origina crédito (antecipação de receivable) via SCD, com gate determinístico autorizando e runtime executando a operação."
			feedsInto: "fw-04"
			rationale: "Crédito evidenciado é o produto central. Gate autoriza; runtime executa — separação que garante auditabilidade (dp-05)."
		}, {
			id:        "fw-04"
			order:     4
			action:    "Fornecedor recebe pagamento antecipado, resolvendo sua dor mais aguda de liquidez."
			feedsInto: "fw-05"
			rationale: "Aceleração de pagamento é a proposta de valor que resolve a assimetria informacional do fornecedor e cria incentivo para permanecer na rede. Na construção: redução de ciclo de 60–120 dias."
		}, {
			id:        "fw-05"
			order:     5
			action:    "Dados de cada operação (evidência, crédito, pagamento, inadimplência) acumulam no Event Log, alimentando modelos de scoring."
			feedsInto: "fw-06"
			rationale: "dp-09 (acumulação informacional): cada operação torna a próxima mais precisa. Informação é o ativo que não se depleta com uso."
		}, {
			id:        "fw-06"
			order:     6
			action:    "Modelos de risco são retreinados e validados com dados acumulados, melhorando precisão de scoring e reduzindo spread progressivamente."
			feedsInto: "fw-07"
			rationale: "Melhoria de modelo requer volume, diversidade de cenários e ciclos de feedback de crédito (12–36 meses). O efeito é real mas não-linear — lento no início, acelerando com volume. at-02 cobre o risco de os dados não serem mais preditivos que dados tradicionais."
		}, {
			id:        "fw-07"
			order:     7
			action:    "Taxas menores e liquidez mais rápida atraem novos participantes à rede."
			feedsInto: "fw-01"
			rationale: "Expansão de rede fecha o ciclo: mais participantes → mais evidência → mais dados → melhores modelos → taxas ainda menores (dp-02)."
		}]
		rationale: """
			O flywheel é defensível porque cada volta acumula ativo informacional
			que não pode ser replicado sem o mesmo volume de operações verificadas.
			Concorrentes precisariam não apenas da tecnologia, mas do histórico —
			e histórico não se compra.
			"""
	}

	inScope: [{
		description: "Ciclo econômico inter-organizacional em cadeias produtivas B2B — da demanda interna à repercussão fiscal, quando envolve compromisso econômico entre organizações participantes da rede"
		rationale:   "Princípio de fronteira: tudo que é inter-organizacional e gera compromisso econômico está dentro; tudo que é intra-organizacional ou não gera compromisso está fora. Sem esta fronteira, escopo infla para ERP genérico."
	}, {
		description: "Demanda interna e procure-to-pay: requisição, aprovações por alçada, rastreabilidade de demanda até compromisso"
		rationale:   "Sem visibilidade sobre a demanda que origina o compromisso, a Mesh não consegue rastrear o ciclo econômico desde a origem nem alimentar inteligência de rede sobre padrões de consumo."
	}, {
		description: "Strategic sourcing e category management: cotação estruturada, equalização TCO, spend analysis, seleção de fornecedores"
		rationale:   "Sem strategic sourcing, decisões de fornecedor acontecem fora da rede e a Mesh perde o dado mais valioso para NIM: como e por que um fornecedor foi escolhido."
	}, {
		description: "Qualificação, homologação e compliance contínuo de participantes — KYB (Know Your Business), IQF, gestão documental"
		rationale:   "Qualificação é pré-condição de participação na rede e input de risco. Sem compliance contínuo, a rede aceita participantes que degradam confiança sistêmica."
	}, {
		description: "Formalização contratual: contratos, framework agreements, ordens de serviço, monitoramento de SLAs"
		rationale:   "Termos contratuais são a base jurídica sob a qual compromissos são firmados. SLA monitoring fecha o gap entre contrato formalizado e execução real."
	}, {
		description: "Logística como dimensão do compromisso e como atividade fim: rastreabilidade, evidência operacional, transporte"
		rationale:   "Logística não é apenas fonte de evidência — é atividade econômica com compromissos, faturamento e liquidação próprios. Excluí-la fragmenta o ciclo."
	}, {
		description: "Comércio exterior: freight forwarding, despacho aduaneiro, documentação de comex"
		rationale:   "Cadeias produtivas B2B com componente internacional geram compromissos e repercussões fiscais sob regulação aduaneira específica que não pode ser tratada como extensão do doméstico."
	}, {
		description: "Operações de crédito e financiamento via SCD regulada pelo Bacen: antecipação de recebíveis, reverse factoring, capital de giro, preparação de ativos para mercado de capitais"
		rationale:   "SCD é o veículo regulatório próprio. Stack de funding expandido porque compromissos econômicos geram múltiplos instrumentos financeiros além de antecipação simples."
	}, {
		description: "Tesouraria corporativa informada pelos compromissos: posição de caixa, projeção de fluxo, estratégia de liquidez"
		rationale:   "Sem tesouraria, cada liquidação é evento isolado sem visão de posição corporativa. Compromissos sob governança da Mesh são o input primário para projeção de fluxo."
	}, {
		description: "Proteção e transferência de risco: seguro garantia, seguro de carga, performance bonds"
		rationale:   "Compromissos econômicos geram exposição que precisa de instrumentos de proteção. Seguros afetam pricing de crédito e elegibilidade — excluí-los deixa o modelo de risco incompleto."
	}, {
		description: "Verificação de execução: entrega, medição, aceite técnico, vendas ao consumidor final como ponto terminal do ciclo"
		rationale:   "Execução operacional gera a evidência que lastreia o ciclo financeiro (mech-evidence). Venda ao consumidor final fecha o ciclo do compromisso e liquida o recebível."
	}, {
		description: "Compliance regulatório (KYC/AML, LGPD, reporting Bacen) e repercussão fiscal/contábil (inteligência fiscal, NF-e, obrigações acessórias)"
		rationale:   "Compliance é constraint inviolável (nível 1 de conflictResolution). Repercussão fiscal é consequência de toda operação na Mesh — não feature, mas primitiva."
	}]

	outOfScope: [{
		description: "Gestão de produção e manufatura (chão de fábrica, linha de montagem, formulação)"
		rationale:   "A Mesh opera sobre o ciclo econômico entre organizações, não sobre a transformação física de insumos em produtos. Na construção: não faz gestão de canteiro nem cronograma de obra."
	}, {
		description: "Banking as a Service genérico (contas digitais, cartões, pagamentos de varejo)"
		rationale:   "A Mesh não é banco digital genérico. O veículo SCD serve operações de crédito vinculadas a cadeias produtivas B2B."
	}, {
		description: "Marketplace de SKUs ou catálogo de produtos"
		rationale:   "A Mesh conecta participantes por capacidade, confiança e histórico de rede — não por catálogo. SSC opera por equalização TCO e strategic sourcing, não por listagem de produtos."
	}, {
		description: "CRM, gestão de leads e funil de vendas"
		rationale:   "Relação comercial pré-rede e gestão de pipeline de vendas estão fora. A Mesh entra quando há intenção de formalizar compromisso econômico inter-organizacional."
	}, {
		description: "Funções corporativas internas: RH, comunicação interna, gestão de ativos fixos, gestão de projetos (Gantt)"
		rationale:   "Operações intra-organizacionais sem relação direta com compromissos econômicos entre organizações. Teste de fronteira: se não gera compromisso inter-organizacional, está fora."
	}, {
		description: "Gestão contábil interna das empresas participantes"
		rationale:   "A Mesh gera lançamentos e inteligência fiscal para os participantes, mas não substitui o sistema contábil de cada empresa. ATO opera sobre as operações da Mesh, não sobre a contabilidade geral."
	}, {
		description: "E-commerce B2C e crédito PF genérico"
		rationale:   "Mesh opera em cadeias B2B. Vendas ao consumidor final são in-scope apenas como ponto terminal do ciclo de compromisso B2B, não como plataforma de e-commerce."
	}, {
		description: "Infraestrutura de mercado regulada: câmara de compensação, securitizadora, registradora"
		rationale:   "A Mesh origina e gerencia ativos (recebíveis, crédito), mas não opera como infraestrutura de mercado regulada. Pode preparar ativos para cessão a securitizadora, mas não é securitizadora."
	}, {
		description: "Serviços profissionais especializados: consultoria tributária, auditoria externa, assessoria jurídica"
		rationale:   "A Mesh gera inteligência fiscal e evidência auditável, mas não substitui o julgamento profissional especializado. Consome outputs desses serviços quando necessário."
	}, {
		description: "Data-as-a-service e BI genérico"
		rationale:   "Dados acumulados pela Mesh são moat interno (mech-network, dp-09), não produto externo. Participantes acessam dados sobre suas próprias operações; modelos de scoring e precificação consomem dados agregados internamente. Decisão estratégica: monetizar dados indiretamente via crédito mais barato e governança melhor — não diretamente via venda de dados ou analytics."
	}]

	notIdentity: [{
		id:          "ni-01"
		notThis:     "Plataforma de antecipação de recebíveis"
		whyConfused: "Antecipação de recebíveis é o produto visível mais imediato da Mesh, e o mercado tende a classificar pelo produto mais legível."
		distinction: "Antecipação é um mecanismo, não a identidade. A Mesh é infraestrutura financeira operada por IA onde evidência verificável é a primitiva — antecipação é uma das operações possíveis sobre essa primitiva."
		rationale:   "Plataformas de antecipação competem por spread. Mesh compete por qualidade de evidência e custo operacional — dinâmicas fundamentalmente diferentes."
	}, {
		id:          "ni-02"
		notThis:     "Banco digital setorial"
		whyConfused: "A Mesh tem SCD e processa operações financeiras, o que superficialmente parece um banco digital verticalizado para um setor."
		distinction: "Banco digital oferece conta, cartão, pagamento — serviços bancários genéricos para um setor. A Mesh é infraestrutura financeira especializada onde operações são lastreadas em evidência de execução. A diferença é estrutural: o banco processa transações; a Mesh vincula transações a fatos verificáveis."
		rationale:   "Confusão com banco digital leva a comparações erradas (Nubank, C6) e expectativas erradas (conta digital, cartão corporativo)."
	}, {
		id:          "ni-03"
		notThis:     "Fintech de crédito setorial"
		whyConfused: "A Mesh origina crédito para participantes de cadeias produtivas, o que parece uma fintech de crédito verticalizada."
		distinction: "Fintech de crédito usa análise de risco tradicional (balanço, score bureau) e distribui capital. A Mesh usa evidência operacional verificável para precificar risco e amarra liberação a comprovação de execução. A diferença é o mecanismo de decisão: análise estática vs. evidência dinâmica."
		rationale:   "Confusão com fintech de crédito ignora o diferencial central: lastreamento em evidência. Sem ele, a Mesh seria apenas mais uma originadora."
	}, {
		id:          "ni-04"
		notThis:     "ERP ou plataforma de gestão operacional interna"
		whyConfused: "A Mesh inclui P2P, strategic sourcing, logística e execução, o que parece um ERP verticalizado para cadeias produtivas."
		distinction: "A Mesh opera o ciclo econômico entre organizações — não a gestão interna de cada empresa. P2P, sourcing e logística existem na Mesh enquanto dimensões do compromisso econômico inter-organizacional, não como módulos de gestão interna. Um ERP gerencia a operação de uma empresa; a Mesh gerencia o ciclo econômico da rede."
		rationale:   "Com o escopo expandido, a confusão com ERP se torna mais provável. A distinção é: inter-organizacional (Mesh) vs intra-organizacional (ERP). Na construção: Sienge gerencia a obra da construtora; a Mesh gerencia os compromissos entre construtora, fornecedores e financiadores."
	}]

	antiThesis: [{
		id:         "at-01"
		assumption: "Participantes de cadeias produtivas vão adotar um sistema que exige evidência verificável para cada operação"
		ifWrong:    "Se o custo de produzir evidência for maior que o benefício de crédito mais barato, a adoção será insuficiente. Mitigação: começar com evidências que já existem digitalmente (notas fiscais, documentos de transporte, medições digitais) e expandir gradualmente."
		rationale:  "Adoção é o risco existencial número 1. A tese assume que o benefício econômico supera o custo de mudança de comportamento."
	}, {
		id:         "at-02"
		assumption: "Dados operacionais verificados são significativamente mais preditivos que dados tradicionais (balanço, score bureau) para risco de crédito em cadeias produtivas"
		ifWrong:    "Se dados operacionais não melhorarem materialmente a precisão do scoring, o efeito de rede informacional não gera vantagem competitiva. Mitigação: validar com operações piloto antes de escalar, usar dados tradicionais como fallback."
		rationale:  "Se dados operacionais não são mais preditivos, o flywheel informacional não gira — e a defensibilidade da Mesh se reduz a eficiência operacional, que é replicável."
	}, {
		id:         "at-03"
		assumption: "É possível operar uma SCD com custo operacional suficientemente baixo para que a internalização do veículo regulatório seja vantajosa"
		ifWrong:    "Se o custo de compliance de SCD for maior que o spread de intermediação bancária, operar veículo próprio destrói valor. Mitigação: modelar breakeven antes de operar; considerar parceria bancária como fallback até atingir escala."
		rationale:  "SCD própria só faz sentido se o custo de operar for menor que o custo de intermediação. Abaixo de certo volume, parceria bancária pode ser mais eficiente."
	}, {
		id:         "at-04"
		assumption: "O framework regulatório brasileiro para SCDs permanece estável o suficiente para construir sobre ele"
		ifWrong:    "Mudança regulatória material (restrição de escopo, aumento de capital mínimo, proibição de operação por IA) pode invalidar o veículo jurídico ou tornar compliance economicamente inviável."
		rationale:  "Risco regulatório é existencial para SCD. Mitigação possível (diversificação de licença, lobby, adaptação), mas o risco não é eliminável — e é ortogonal ao custo operacional de at-03."
	}, {
		id:         "at-05"
		assumption: "Agentes de IA operam com taxa de erro suficientemente baixa para que gates determinísticos capturem falhas antes de impacto financeiro"
		ifWrong:    "Se agentes erram de formas que gates não capturam (erros semânticos, adversariais, edge cases não modelados), o sistema causa dano financeiro real — e em sistema agent-first, o impacto é estrutural, não pontual."
		rationale:  "Erro de agente em sistema operado por IA não é incidente operacional — é risco estrutural. A combinação ax-01 + ax-05 exige que falha de agente seja modelada como cenário de dano, não como exceção improvável."
	}, {
		id:         "at-06"
		assumption: "Evidência de execução submetida à plataforma é verdadeira na origem — não apenas íntegra após captura"
		ifWrong:    "Se participantes fabricam ou coludem para criar evidência falsa que passa verificação criptográfica (documentos forjados, entregas fictícias, medições infladas), o sistema lastreia crédito em ficção. Integridade criptográfica prova que dados não foram adulterados após captura — não prova que eram verdadeiros na captura."
		rationale:  "Este é o ataque mais óbvio à tese. Cadeias produtivas B2B têm histórico de fraude em comprovações de execução. dp-08 (incentive compatibility) mitiga parcialmente, mas não elimina conluio coordenado."
	}, {
		id:         "at-07"
		assumption: "A vertical inicial gera volume de operações suficiente e estável para sustentar o flywheel informacional até a expansão para outras cadeias"
		ifWrong:    "Contração setorial prolongada na vertical inicial reduz volume de originação e aumenta inadimplência simultaneamente, atacando ambos os lados do modelo antes que a diversificação para outras cadeias mitigue o risco. Modelos de scoring treinados em período benigno podem degradar exatamente quando mais importam."
		rationale:  "Dependência de vertical única na fase inicial cria risco cíclico que o flywheel não diversifica. Mitigação de longo prazo: expandir para outras cadeias produtivas B2B (a tese é generalizável por design). Mitigação de curto prazo: conservadorismo em provisioning e capital."
	}]

	designPrinciplesRef: "architecture/design-principles.cue"
	stakeholderMapRef:   "domain/stakeholder-map.cue"
}
