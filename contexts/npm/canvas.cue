package npm

// canvas.cue — Bounded Context Canvas: Network Participant Management.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// NPM gerencia ciclo de vida de participantes da rede Mesh:
// onboarding, qualificação (KYC/AML), monitoramento contínuo,
// suspensão, reativação e terminação. CTR depende diretamente
// de NPM via query sync para validar qualificação antes de
// registrar termos. REW, NIM e SSC consomem eventos de
// lifecycle para atualizar modelos, topologia e sourcing
// respectivamente. SSC também consome NPM via hybrid
// (eventos async + query sync QueryParticipantQualificationStatus).
// NGR consome evento de registro
// (ParticipantRegistered) para métricas de crescimento.
//
// IDC fornece verificação de identidade base. NPM consome o
// resultado de duas formas complementares: evento push
// (IdentityVerificationCompleted — IDC notifica conclusão) e
// query pull (QueryIdentityVerificationStatus — NPM confirma
// status antes de prosseguir). Evento inicia o fluxo, query
// garante consistência no momento da decisão.
//
// Convenção local de eventos de lifecycle:
// O context-map declara o published language estratégico como
// NetworkParticipantStatusChanged (evento agregado). Este canvas
// especializa em eventos granulares de transição de status
// (ParticipantQualified, ParticipantSuspended,
// ParticipantReactivated, ParticipantTerminated) que são
// decomposições locais do mesmo sinal. ParticipantRegistered
// é evento de criação de entidade, não transição de status —
// não faz parte desta convenção. O runner trata cada evento
// granular de transição como instância tipada do status change
// estratégico. Esta é uma convenção local deste canvas, não
// uma regra institucional — candidata a promoção para artefato
// de convenção global se o padrão se repetir em outros BCs.
//
// Lenses aplicadas:
// - lens-regulatory-compliance-as-architecture (primária):
//   KYC/AML como constraint nativo, audit trail, compliance by design
// - lens-security-trust-infrastructure (primária):
//   trust chain, qualificação como gate de acesso à rede
// - lens-cold-start-and-network-bootstrapping (secundária):
//   onboarding como gargalo do cold start, fricção vs. segurança
// - lens-event-driven-architecture-patterns (secundária):
//   participant lifecycle events consumidos por 4+ BCs
// - lens-network-theory (terciária):
//   topologia de participantes, efeito de rede informacional

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

canvas: artifact_schemas.#Canvas & {
	code: "npm"
	name: "Network Participant Management"

	purpose: """
		Gerenciar ciclo de vida de participantes da rede Mesh —
		onboarding, qualificação, monitoramento contínuo, suspensão,
		reativação e terminação — como gate de acesso que garante que apenas
		organizações verificadas e qualificadas operam na rede.
		CTR consulta qualificação em NPM via query sync antes de
		registrar termos — participantes não qualificados não
		geram novos termos, o que limita operações downstream
		que dependam deles. NPM não é gestão de identidade
		(IDC faz isso) nem growth (NGR faz isso) — é o registro
		canônico de quem está qualificado para operar e sob
		quais condições.
		"""

	ubiquitousLanguageRef: "contexts/npm/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "compliance-enforcer"
		wardleyEvolution: "custom"
		rationale: """
			Supporting porque não é a proposta de valor final da
			Mesh, embora seja gate operacional e regulatório
			central da rede. Compliance-enforcer porque NPM é o
			gate de KYC/AML — sem NPM, a Mesh como SCD viola
			requisitos do Bacen. Custom porque KYC/AML para SCD
			em cadeia produtiva B2B exige adaptação significativa
			dos processos padrão de mercado.
			"""
	}

	domainRoles: {
		primary:   "gateway"
		secondary: ["execution"]
		rationale: """
			Gateway como primário: NPM é o ponto de entrada da
			rede — controla quem pode operar. Execution como
			secundário: NPM executa o processo de onboarding e
			qualificação com steps sequenciais (registro →
			verificação de identidade → documentação KYC/AML →
			aprovação). O resultado para downstream é binário:
			qualified ou not-qualified-to-operate
			(bd-qualification-as-gate). Internamente, NPM
			modela 4 estados de lifecycle (bd-lifecycle-explicit).
			"""
	}

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua de qualificação de participantes:
				cada onboarding, qualificação, suspensão, reativação
				e terminação é fato imutável no Event Log.
				Monitoramento contínuo de compliance detecta
				degradação de qualificação pós-onboarding.
				"""
			rationale: "KYC/AML exige trail auditável e reconstituível. Qualificação sem auditoria contínua é snapshot estático — insuficiente para regulador."
		}, {
			description: """
				Qualificação de participantes: verificação de
				identidade (via IDC), análise documental KYC/AML
				e avaliação de perfil de negócio, com resultado
				operacional binário para fins de gate downstream
				(qualified ou not-qualified-to-operate) e monitoramento
				contínuo pós-qualificação. Cada passo do processo
				gera evidência verificável.
				"""
			rationale: "Qualificação com evidência verificável em cada passo permite reconstituição regulatória e alimenta REW com dados padronizados. Resultado binário simplifica gate para downstream."
		}, {
			description: """
				Modelo canônico de status de participante exposto
				via OHS (Open Host Service) e sync queries para CTR
				(registro de termos) e SSC (sourcing).
				"""
			rationale: "Múltiplos BCs downstream consomem status de qualificação. OHS garante que todos referenciam a mesma fonte com tradução via ACL local."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Organização submete solicitação de ingresso na rede Mesh com dados cadastrais e representante legal."
			command:         "RegisterParticipant"
			resultingEvents: ["ParticipantRegistered"]
			description:     "Inicia lifecycle do participante em estado pending. Agente valida completude cadastral e solicita verificação de identidade a IDC."
		}, {
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Participante ou agente submete documentação para qualificação KYC/AML."
			command:         "SubmitQualificationDocuments"
			resultingEvents: ["QualificationDocumentsReceived"]
			description:     "Recebe documentação KYC/AML. Agente valida completude documental e encaminha para análise. Evento interno — não publicado."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Supervisor aprova qualificação após análise KYC/AML completa e identidade verificada por IDC."
			command:         "ApproveQualification"
			resultingEvents: ["ParticipantQualified"]
			description:     "Transiciona participante de pending para qualified. Decisão supervisionada — KYC/AML é compliance material. Gate verifica: identidade verificada por IDC (confirmada via query pull), documentação completa, análise de perfil concluída."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Supervisor suspende participante por irregularidade, expiração de documentos ou decisão regulatória."
			command:         "SuspendParticipant"
			resultingEvents: ["ParticipantSuspended"]
			description:     "Transiciona participante para suspended — estado reversível. Sync porque suspensão precisa bloquear novas operações com este participante em tempo real. Downstream decide como tratar operações existentes."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Supervisor reativa participante após resolução de irregularidade."
			command:         "ReactivateParticipant"
			resultingEvents: ["ParticipantReactivated"]
			description:     "Transiciona participante de suspended para qualified. Decisão supervisionada — reativação exige evidência de resolução."
		}, {
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Decisão irreversível de exclusão — fraude confirmada, sanção regulatória, decisão judicial ou saída voluntária."
			command:         "TerminateParticipant"
			resultingEvents: ["ParticipantTerminated"]
			description:     "Supervisão humana ocorre antes da emissão do comando — supervisor valida justificativa e autoriza terminação. Comando entra async porque execução (notificação a downstream, arquivamento, reporte ao Bacen) não exige resposta síncrona do chamador. Estado terminal, irreversível. Downstream deve tratar consequências."
		}, {
			type:          "event-consumer"
			sourceContext: "idc"
			event:         "IdentityVerificationCompleted"
			reaction:      "Atualiza status de verificação de identidade do participante. Habilita prosseguimento do processo de qualificação KYC/AML."
			description:   "Evento push de IDC: notifica que verificação de identidade concluiu. NPM registra resultado e avança no processo. Complementado por query pull no momento da decisão. Se evento e query divergirem, query é autoritativa — evento é trigger de fluxo, não SoT. Outros artefatos que referenciem verificação de identidade devem consumir a query, não tratar este evento como fonte de verdade."
		}, {
			type:          "event-consumer"
			sourceContext: "ngr"
			event:         "NetworkGrowthTargetDefined"
			reaction:      "Atualiza prioridades de onboarding — segmentos ou regiões priorizados por NGR recebem SLA de processamento diferenciado."
			description:   "Evento de partnership ngr↔npm: NGR define metas de crescimento, NPM ajusta capacidade e priorização de onboarding. Consistente com mutual-dependency declarada no context-map."
		}, {
			type:        "query-surface"
			query:       "QueryParticipantStatus"
			returnType:  "ParticipantStatus"
			description: "Retorna status de qualificação (pending, qualified, suspended, terminated) e data de última qualificação. Interface primária consumida por CTR (registro de termos) e SSC (decisão de sourcing). Context-map usa dois nomes para esta query: QueryParticipantStatus em npm-to-ctr e QueryParticipantQualificationStatus em npm-to-ssc — divergência a alinhar no context-map."
		}, {
			type:        "query-surface"
			query:       "QueryParticipantProfile"
			returnType:  "ParticipantProfile"
			description: "Retorna perfil completo: dados cadastrais, histórico de qualificação, estado atual. Interface consumida por SSC (decisão de sourcing). REW obtém dados de participante via eventos de lifecycle (npm-to-rew é async-only no context-map)."
		}]

		outbound: [{
			type:        "event-publisher"
			trigger:     "Participante qualificado com sucesso."
			event:       "ParticipantQualified"
			consumers:   ["rew", "nim", "ssc"]
			description: "Sinal de novo participante disponível para operar na rede. REW incorpora em modelos de risco. NIM atualiza topologia. SSC considera para decisões de sourcing. CTR consome status via query sync (QueryParticipantStatus), não via evento."
		}, {
			type:        "event-publisher"
			trigger:     "Participante suspenso por irregularidade."
			event:       "ParticipantSuspended"
			consumers:   ["rew", "nim", "ssc"]
			description: "Sinal de participante temporariamente impedido. REW atualiza scoring. NIM atualiza topologia (nó indisponível). SSC remove de pool de sourcing ativo. CTR descobre suspensão via query sync na próxima tentativa de registro — não consome evento."
		}, {
			type:        "event-publisher"
			trigger:     "Participante terminado definitivamente."
			event:       "ParticipantTerminated"
			consumers:   ["rew", "nim", "ssc"]
			description: "Sinal de saída definitiva da rede. REW arquiva modelo de risco. NIM remove nó da topologia. SSC exclui de sourcing pool. CTR descobre terminação via query sync. Publicação direta para CMT é decisão topológica pendente (oq-npm-3) — enquanto não formalizada no context-map, não é modelada aqui."
		}, {
			type:        "event-publisher"
			trigger:     "Participante reativado após resolução."
			event:       "ParticipantReactivated"
			consumers:   ["rew", "nim", "ssc"]
			description: "Sinal de participante reabilitado. REW reavalia scoring. NIM reativa nó na topologia. SSC reincorpora em sourcing pool. CTR descobre reativação via query sync na próxima operação."
		}, {
			type:        "event-publisher"
			trigger:     "Novo participante registrado (pendente de qualificação)."
			event:       "ParticipantRegistered"
			consumers:   ["ngr", "rew", "nim"]
			description: "Sinal de novo registro na rede. NGR consome para métricas de crescimento e funil de conversão. REW inicializa modelo de risco baseline para o participante. NIM atualiza topologia com novo nó. Context-map referencia este evento como NetworkParticipantOnboarded — nome estratégico para o mesmo sinal de registro. Consistente com npm-to-nim e partnership ngr↔npm."
		}, {
			type:          "query-dependency"
			targetContext: "idc"
			query:         "QueryIdentityVerificationStatus"
			purpose:       "Confirmar status de verificação de identidade no momento da decisão de qualificação — query pull que complementa o evento push IdentityVerificationCompleted."
			description:   "Gate check síncrono antes de ApproveQualification. Garante consistência mesmo se houve delay entre evento e aprovação. Em caso de divergência com evento previamente recebido, query prevalece — estado atual de IDC é autoritativo."
		}]
		rationale: """
			Inbound: 6 commands (registro async + documentação async
			+ aprovação sync + suspensão sync + reativação sync
			+ terminação async), 2 event consumers (IDC —
			IdentityVerificationCompleted push; NGR —
			NetworkGrowthTargetDefined partnership), 2 query
			surfaces (status + perfil). Outbound: 5 event publishers
			(qualificado para REW/NIM/SSC, suspenso para
			REW/NIM/SSC, terminado para REW/NIM/SSC, reativado
			para REW/NIM/SSC, registrado para NGR/REW/NIM), 1 query
			dependency (verificação de identidade via IDC — pull).
			IDC integração dual: evento push notifica conclusão,
			query pull confirma estado no ponto de decisão — em
			caso de divergência, query prevalece. NPM é upstream
			de qualificação para 4 BCs via evento (REW, NIM, SSC,
			NGR) e 2 via query sync (CTR e SSC — npm-to-ssc é
			hybrid no context-map). NIM e SSC consomem
			todos os status changes (não apenas qualificação) —
			consistente com NetworkParticipantStatusChanged no
			context-map. Publicação de terminação para CMT
			pendente de decisão topológica (oq-npm-3).
			"""
	}

	businessDecisions: [{
		id:           "bd-kyc-aml-at-npm"
		decision:     "KYC/AML é responsabilidade de NPM, não de IDC. IDC fornece verificação de identidade base; NPM executa qualificação de negócio."
		rationale:    "Separação deliberada: IDC verifica quem é a entidade (identidade, autenticidade). NPM verifica se a entidade pode operar na rede (KYC/AML, documentação, perfil de risco). Misturar os dois criaria coupling indevido entre identidade e qualificação de negócio."
		consequences: "NPM depende de IDC para pré-condição (identidade verificada), mas executa qualificação de forma independente. Se IDC não responde, NPM não pode qualificar — dependência declarada."
	}, {
		id:           "bd-qualification-as-gate"
		decision:     "Qualificação em NPM é gate binário para operações contratuais e financeiras na rede. Participante não qualificado não pode ser usado como contraparte habilitada em operações que exigem qualificação. BCs como REW e NIM referenciam participantes em qualquer estado para fins de scoring e topologia — a restrição do gate aplica-se a operações contratuais e financeiras, não a observação."
		rationale:    "Gate binário simplifica invariante para downstream: CTR verifica apenas QueryParticipantStatus == qualified. Sem gate, cada BC implementaria sua própria lógica de verificação — inconsistência garantida."
		consequences: "Qualquer interrupção em NPM bloqueia operações que envolvam novos participantes. Participantes já qualificados continuam operáveis — status é cached por downstream via evento ou última query."
	}, {
		id:           "bd-lifecycle-explicit"
		decision:     "Participantes têm lifecycle explícito com 4 estados (pending, qualified, suspended, terminated) e transições determinísticas."
		rationale:    "Internamente, NPM modela quatro estados de lifecycle (pending, qualified, suspended, terminated) com transições determinísticas. Externamente, para fins de gate operacional downstream, a decisão efetiva é binária: qualified versus not-qualified-to-operate — downstream consulta QueryParticipantStatus e age sobre essa distinção. pending→qualified via aprovação KYC/AML. qualified→suspended via irregularidade (reversível). suspended→qualified via resolução (reversível). qualified/suspended→terminated via decisão irreversível (fraude, sanção, saída voluntária). Estado terminated é prática prudencial em instituições financeiras reguladas — capacidade de impedir continuidade de partes com irregularidade grave."
		consequences: "CTR valida status qualified antes de registrar termos. Terminação invalida status para CTR (query sync) e REW (evento). Propagação para BCs sem relação direta com NPM (e.g., CMT) depende de topologia ainda não formalizada (oq-npm-3) — blast radius real é proporcional ao histórico do participante, mas mecanismo de propagação completo é pendente."
	}]

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Participante-comprador — submete onboarding e documentação para operar como contratante na rede."
		impactDescription: "Onboarding com processo claro e resultado operacional binário (qualified ou not-qualified-to-operate) permite rastreabilidade completa. Reduz time-to-first-operation versus processos manuais de cadastro."
		rationale:         "Construtora é o participante âncora da rede no vertical de construção civil. Experiência de onboarding determina conversão."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Participante-fornecedor — submetido a onboarding para operar como contraparte em termos contratuais e compromissos."
		impactDescription: "Qualificação é pré-requisito para receber pagamentos via Mesh. Processo claro e rápido reduz barreira de entrada — crítico para efeito de rede."
		rationale:         "Fornecedor é o lado da rede com menor poder de barganha sobre o processo de onboarding. Fricção excessiva impede adoção e mata efeito de rede."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulador — exige que SCD realize KYC/AML sobre todas as partes envolvidas em operações de crédito."
		impactDescription: "NPM centraliza compliance KYC/AML com trail auditável. Regulador pode solicitar reconstituição de qualificação de qualquer participante em qualquer data."
		rationale:         "KYC/AML é constraint inviolável (nível 1). Operar sem qualificação adequada é risco existencial para a SCD."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operador primário — processa onboarding, valida documentação, monitora compliance contínuo, expõe Published Language de status."
		impactDescription: "Governance scope com boundaries claras: registro e validação documental autônomos, qualificação/suspensão/reativação/terminação supervisionados."
		rationale:         "Agente IA opera como gateway — decisões de qualificação, suspensão e terminação têm blast radius sobre toda a rede e exigem supervisão humana."
	}]

	costsEliminated: [{
		costRef: "ce-02"
		contribution: """
			NPM elimina custo de compliance documental no onboarding
			de participantes: verificação de documentos KYC/AML
			automatizada substitui processos manuais de análise
			cadastral. Cada verificação de qualificação por CTR
			é respondida por query determinístico contra NPM, não
			por busca em cadastros dispersos.
			"""
		rationale: "ce-02 se aplica diretamente: compliance documental de qualificação de participantes é custo de transação que NPM automatiza."
	}, {
		costRef: "ce-04"
		contribution: """
			NPM reduz custo de avaliação de risco com dados
			incompletos ao fornecer dados de participantes —
			perfil de negócio, histórico de qualificação, status
			de compliance — que alimentam modelos de scoring de
			REW. Sem NPM, REW operaria sobre dados cadastrais
			fragmentados.
			"""
		rationale: "ce-04 se aplica porque avaliação de risco depende de qualidade dos dados de participante — NPM fornece a base que REW consome."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:             "sh-01"
			participantType:           "participante-comprador"
			desiredBehavior:           "Submeter dados cadastrais precisos, documentação KYC/AML completa e atualizada, refletindo realidade da organização."
			correctOperationIncentive: "Qualificação rápida habilita operações na rede — contratos, compromissos, crédito. Dados imprecisos atrasam qualificação e bloqueiam pipeline operacional."
			manipulationVector:        "Submeter documentação falsificada ou dados inflados para acelerar qualificação ou obter perfil de risco mais favorável em REW."
			manipulationCost:          "IDC verifica identidade com integridade criptográfica — falsificação de identidade é detectável. Documentação KYC/AML é verificada contra fontes externas (Receita Federal, Junta Comercial). REW monitora performance real — divergência entre perfil declarado e comportamento operacional deteriora scoring. Suspensão imediata afeta todos os BCs downstream."
			vsBenefit:                 "Benefício de dados falsos é aceleração de qualificação ou perfil de risco inflado. Custo inclui detecção por verificação cruzada com fontes externas, deterioração de score real em REW, e suspensão que bloqueia toda operação na rede."
			designResponse:            "Verificação de identidade via IDC com integridade criptográfica. Verificação documental contra fontes externas. Monitoramento contínuo pós-qualificação. REW cruza perfil declarado com performance operacional real. Suspensão como consequência automática de irregularidade detectada."
			rationale:                 "Comprador como participante âncora tem incentivo para qualificação rápida. Design response usa verificação multi-camada (IDC + fontes externas + REW) para tornar falsificação mais cara que operação correta."
		}, {
			stakeholderRef:             "sh-02"
			participantType:           "participante-fornecedor"
			desiredBehavior:           "Submeter documentação real e manter qualificação atualizada para operar continuamente na rede."
			correctOperationIncentive: "Qualificação é pré-requisito para receber pagamentos via Mesh. Documentação expirada ou suspensão bloqueia recebimentos — custo financeiro direto e imediato."
			manipulationVector:        "Submeter documentação de empresa diferente (identidade emprestada) para operar na rede quando a real não qualifica, ou omitir mudanças relevantes (mudança de controle, pendências fiscais)."
			manipulationCost:          "IDC verifica identidade da organização — substituição detectável. Monitoramento contínuo cruza dados cadastrais com fontes externas periodicamente. Suspensão bloqueia recebimentos em andamento — custo financeiro imediato."
			vsBenefit:                 "Benefício de identidade emprestada é acesso à rede. Custo é detecção por monitoramento contínuo, suspensão retroativa e possível responsabilização criminal por falsidade."
			designResponse:            "Verificação de identidade via IDC. Monitoramento contínuo contra fontes externas. Suspensão automática por divergência detectada. Trail auditável para responsabilização."
			rationale:                 "Fornecedor tem incentivo para manter acesso à rede para receber pagamentos. Design response torna manutenção legítima mais barata que manipulação."
		}, {
			stakeholderRef:             "sh-01"
			participantType:           "participante-qualificado"
			desiredBehavior:           "Reportar proativamente mudanças materiais que afetem qualificação — restrições judiciais, sanções, mudança de controle societário."
			correctOperationIncentive: "Reporte proativo permite reavaliação sem suspensão — participante mantém operação contínua. Ocultação detectada resulta em terminação irreversível, que é pior que suspensão temporária."
			manipulationVector:        "Omitir fato material que levaria a suspensão ou terminação (e.g., nova restrição judicial, sanção, mudança de controle) para manter status qualified e continuar operando."
			manipulationCost:          "Monitoramento contínuo cruza dados com fontes externas periodicamente (as-npm-4). REW detecta divergência comportamental. Ocultação descoberta escala de suspensão para terminação — consequência mais severa que o cenário original. Trail auditável documenta omissão deliberada para responsabilização."
			vsBenefit:                 "Benefício de ocultação é manutenção temporária de operação. Custo é terminação irreversível quando descoberto — versus suspensão reversível se reportado proativamente."
			designResponse:            "Monitoramento contínuo contra fontes externas detecta mudanças não reportadas. REW cruza perfil com comportamento operacional. Descoberta de ocultação escala severidade: suspensão→terminação. Trail auditável para responsabilização e reporte ao Bacen."
			rationale:                 "Participante já qualificado tem incentivo para ocultar deterioração porque disclosure voluntário pode resultar em suspensão. Design response torna ocultação mais cara que disclosure: detecção por monitoramento + escalada de severidade + terminação irreversível."
		}, {
			stakeholderRef:             "sh-05"
			participantType:           "operador-plataforma"
			desiredBehavior:           "Processar onboarding e qualificação com imparcialidade, monitorar compliance continuamente e publicar status para downstream sem seletividade."
			correctOperationIncentive: "Operação imparcial mantém confiança de participantes e de BCs downstream. Favoritismo detectado degrada credibilidade da plataforma como gateway neutro e gera responsabilidade jurídica (dp-10)."
			manipulationVector:        "Acelerar onboarding de determinado participante por priorização de fila, atrasar processamento de documentação de concorrentes, omitir publicação de suspensão para manter participante operando, ou postergar terminação para proteger participante com quem tem alinhamento."
			manipulationCost:          "Event Log imutável registra timestamps de cada operação — desvio de SLA por participante é detectável estatisticamente. Qualificação, suspensão e terminação são supervisionadas — agente não executa autonomamente. Publicação de eventos é append-only e determinística."
			vsBenefit:                 "Benefício de favoritismo é vantagem competitiva para participante preferencial ou proteção de participante alinhado. Custo: supervisão humana elimina execução autônoma de decisões materiais, Event Log torna atrasos e omissões detectáveis, consumers detectam ausência de eventos esperados."
			designResponse:            "Qualificação supervisionada (ApproveQualification) elimina favorecimento autônomo. Suspensão e terminação supervisionadas impedem proteção seletiva e postergação — agente propõe, humano decide. Event Log imutável cria trail auditável. SLA de processamento monitorado por OBS."
			rationale:                 "Agente IA como operador de gateway tem poder assimétrico sobre quem entra e permanece na rede. Design response usa supervisão humana para todas as decisões materiais (qualificação, suspensão, terminação), Event Log para detectabilidade de favoritismo e postergação."
		}, {
			stakeholderRef:             "sh-01"
			participantType:           "participantes-em-conluio"
			desiredBehavior:           "Cada participante submete documentação independente e opera sem coordenação para manipular qualificação ou contornar terminação."
			correctOperationIncentive: "Operação independente preserva qualificação individual. Conluio detectado resulta em terminação de todos os envolvidos — custo multiplicado por número de participantes."
			manipulationVector:        "Comprador e fornecedor coordenam para registrar entidades-fachada (shell companies) que contornam terminação de entidade relacionada, ou fabricam documentação cruzada para acelerar qualificação mútua."
			manipulationCost:          "IDC verifica identidade de cada entidade independentemente — vínculos societários e de controle são verificáveis contra fontes externas (Receita Federal, Junta Comercial). Monitoramento contínuo cruza padrões comportamentais entre participantes — operação coordenada anômala é sinal estatístico detectável por REW. Terminação de uma entidade dispara reavaliação de entidades vinculadas."
			vsBenefit:                 "Benefício de conluio é contornar terminação ou acelerar qualificação. Custo: detecção por verificação cruzada de vínculos + monitoramento de padrões coordenados + terminação em cascata de todos os envolvidos."
			designResponse:            "Verificação de vínculos societários e de controle via fontes externas. REW monitora padrões comportamentais coordenados entre participantes. Terminação de entidade dispara reavaliação de entidades vinculadas. Trail auditável documenta vínculos para responsabilização. Limitação reconhecida: conluio sofisticado sem vínculos formais é parcialmente mitigado por monitoramento comportamental mas não eliminado por design (at-06)."
			rationale:                 "at-06 do domain-definition identifica conluio coordenado como ameaça que dp-08 mitiga parcialmente mas não elimina. Schema exige stakeholderRef singular — sh-01 é usado como representante, mas o vetor envolve sh-01 + sh-02 coordenados. Design response torna conluio mais caro mas não impossível. Detecção depende de vínculos formais verificáveis e padrões comportamentais — conluio sem rastro formal é risco residual."
		}]
		rationale: """
			Análise cobre 5 vetores em 4 classes: (a) falsificação
			cadastral — comprador submete dados falsos (sh-01
			participante-comprador); (b) identidade emprestada —
			fornecedor opera com documentação de terceiro (sh-02);
			(c) ocultação de deterioração — participante já
			qualificado omite fato material para evitar suspensão
			ou terminação (sh-01 participante-qualificado);
			(d) agent misalignment — operador favorece participantes
			ou posterga terminação (sh-05); (e) conluio —
			comprador e fornecedor coordenam para registrar
			entidades-fachada ou fabricar documentação cruzada
			(sh-01 participantes-em-conluio). O vetor (c) reutiliza
			sh-01 porque o stakeholder-map não modela 'participante
			qualificado' como papel distinto. Vetores (a)-(d) têm
			custos que excedem benefícios por design. Vetor (e)
			é parcialmente mitigado — conluio sofisticado sem
			vínculos formais é risco residual reconhecido (at-06).
			Verificação multi-camada (IDC + fontes externas + REW),
			monitoramento contínuo pós-qualificação, supervisão
			humana para decisões materiais, escalada de severidade,
			Event Log imutável (dp-08). sh-04 (Bacen) é
			stakeholder regulatório mas não participante econômico
			— incentive analysis modela vetores de manipulação por
			agentes que operam no sistema, não conformidade
			regulatória (que é constraint inviolável, não incentivo).
			"""
	}

	ownership: {
		domainAgentSpec: "contexts/npm/agents/npm-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "validate-registration-completeness"
				description: "Validar automaticamente completude cadastral e documental de submissão de registro."
				rationale:   "Validação de completude é determinística — checklist de campos obrigatórios e formatos. Sem margem para erro de julgamento."
			}, {
				id:          "request-identity-verification"
				description: "Solicitar verificação de identidade a IDC automaticamente após registro aceito."
				rationale:   "Requisição é determinística e sem efeito colateral — apenas inicia processo em IDC. Não cria obrigação."
			}, {
				id:          "monitor-qualification-expiry"
				description: "Monitorar expiração de documentos e sinalizar necessidade de renovação."
				rationale:   "Monitoramento temporal é determinístico — data de expiração é campo explícito. Sinalização não altera status."
			}, {
				id:          "publish-lifecycle-events"
				description: "Publicar eventos de transição de lifecycle para consumers downstream."
				rationale:   "Publicação de fatos é append-only e determinístico. Downstream decide como reagir."
			}]
			supervisedDecisions: [{
				id:          "approve-qualification"
				description: "Aprovar qualificação KYC/AML de participante."
				rationale:   "Qualificação habilita operação em toda a rede — blast radius alto. KYC/AML é compliance material (nível 1). Supervisão humana garante que documentação foi analisada antes de habilitar participante."
			}, {
				id:          "suspend-participant"
				description: "Suspender participante por irregularidade detectada."
				rationale:   "Suspensão bloqueia novas operações com este participante em todos os BCs downstream. Impacto cross-context — exige supervisão humana para evitar suspensão indevida."
			}, {
				id:          "reactivate-participant"
				description: "Reativar participante após resolução de irregularidade."
				rationale:   "Reativação reabilita operação na rede. Exige evidência de resolução — julgamento humano sobre suficiência da evidência."
			}, {
				id:          "terminate-participant"
				description: "Terminar participante definitivamente — exclusão irreversível da rede."
				rationale:   "Terminação invalida status de qualificação consumido por CTR (query sync) e REW (evento). BCs que dependem indiretamente de qualificação são afetados via cadeia. Decisão irreversível com blast radius alto — exige supervisão humana e justificativa documentada."
			}]
			escalationCriteria: [{
				id:        "novel-participant-type"
				condition: "Tipo de organização não previsto nos templates de qualificação existentes — e.g., novo segmento de mercado, estrutura jurídica atípica."
				action:    "Escalar ao founder para definição de template de qualificação e validação de requisitos KYC/AML aplicáveis."
				rationale: "Tipos novos podem ter requisitos regulatórios não previstos. Qualificação sob premissas incorretas é risco de compliance."
			}, {
				id:        "regulatory-change"
				condition: "Mudança regulatória que afeta requisitos de KYC/AML ou qualificação de participantes."
				action:    "Escalar ao compliance officer para avaliação de impacto e atualização de critérios de qualificação."
				rationale: "Compliance regulatório é constraint inviolável (nível 1). Mudança regulatória pode invalidar qualificações existentes."
			}, {
				id:        "mass-suspension-trigger"
				condition: "Condição que dispararia suspensão de múltiplos participantes simultaneamente — e.g., expiração em massa de documento obrigatório."
				action:    "Escalar ao founder para decisão sobre estratégia de notificação e timeline de suspensão."
				rationale: "Suspensão em massa tem blast radius proporcional ao número de participantes — pode paralisar segmento inteiro da rede."
			}, {
				id:        "contested-termination"
				condition: "Participante contesta terminação ou suspensão — alega erro ou desproporcionalidade."
				action:    "Escalar ao founder para decisão com parecer jurídico. Se necessário, encaminhar para processo formal em DRC."
				rationale: "Terminação contestada tem implicação jurídica — decisão incorreta expõe Mesh a responsabilidade (dp-10). DRC é o BC de disputas, mas NPM precisa routing para o cenário."
			}]
		}
		rationale: """
			npm-primary-agent como operador, referenciado por path
			canônico. 4 decisões autônomas (validação de completude,
			requisição de identidade, monitoramento de expiração,
			publicação de eventos), 4 decisões supervisionadas
			(qualificação, suspensão, reativação, terminação),
			4 critérios de escalação (tipo novo, mudança regulatória,
			suspensão em massa, terminação contestada). Boundaries
			refletem mech-agent-gate: agente valida e monitora,
			supervisão humana para decisões que habilitam, bloqueiam
			ou excluem participantes da rede.
			"""
	}

	assumptions: [{
		id:                 "as-npm-1"
		assumption:         "IDC como SoT de verificação de identidade está disponível com latência aceitável para qualificação."
		invalidationSignal: "Latência de QueryIdentityVerificationStatus consistentemente acima de SLA ou indisponibilidade frequente de IDC."
		rationale:          "Dependência de IDC é ponto de falha para onboarding. Se IDC não é confiável, NPM precisa de estratégia de resiliência."
	}, {
		id:                 "as-npm-2"
		assumption:         "Qualificação binária (qualified/not-qualified-to-operate) é suficiente para todos os BCs downstream."
		invalidationSignal: "BCs downstream precisam de níveis de qualificação diferentes — e.g., CTR exige qualificação plena para contratos de alto valor mas aceita qualificação básica para contratos standard."
		rationale:          "Qualificação binária simplifica gate de acesso. Se tiers forem necessários, o modelo precisa de extensão sem quebrar invariante existente."
	}, {
		id:                 "as-npm-3"
		assumption:         "Fontes externas de verificação (Receita Federal, Junta Comercial) são acessíveis programaticamente com latência aceitável."
		invalidationSignal: "APIs de consulta a fontes externas indisponíveis ou com latência que inviabiliza onboarding em tempo aceitável."
		rationale:          "Verificação contra fontes externas é parte material do KYC/AML. Se indisponíveis, NPM opera com verificação parcial — risco de compliance."
	}, {
		id:                 "as-npm-4"
		assumption:         "Reavaliação periódica de qualificação com cadência trimestral é suficiente para monitoramento contínuo de qualificação."
		invalidationSignal: "Deterioração de participante detectada entre reavaliações periódicas — sinal de que cadência é insuficiente para o perfil de risco da rede."
		rationale:          "Monitoramento contínuo opera com reavaliação periódica (cadência fixa) e fontes externas. Canal de feedback de REW para reavaliação sob demanda é possível mas não modelado (oq-npm-4). Se a cadência fixa não captura deterioração, precisa ser encurtada ou complementada por feedback reativo."
	}]

	openQuestions: [{
		id:        "oq-npm-1"
		question:  "Se a Mesh evoluir além do gate binário atual, quais seriam os tiers de qualificação e quais operações cada tier habilitaria?"
		impact:    "Sem tiers, todo participante precisa de qualificação plena para qualquer operação. Com tiers, onboarding pode ser mais rápido para operações iniciais, mas gate de acesso fica mais complexo — cascateia para QueryParticipantStatus, validação em CTR e gate downstream mediado por CTR e demais consumers."
		deadline:  "2026-07-01"
		rationale: "bd-qualification-as-gate é decisão vigente. Esta questão explora cenário evolutivo futuro — não reabre a decisão. Caso tiers se mostrem necessários, a mudança cascateia para QueryParticipantStatus, validação em CTR e gate downstream mediado por CTR e demais consumers."
	}, {
		id:        "oq-npm-2"
		question:  "Qual o SLA de onboarding end-to-end (registro → qualificado) aceitável para não matar conversão?"
		impact:    "SLA muito longo mata efeito de rede (cold start). SLA muito curto pode comprometer profundidade de KYC/AML."
		deadline:  "2026-06-15"
		rationale: "Trade-off entre segurança e fricção. Decisão informa dimensionamento de capacidade do agente e do supervisor."
	}, {
		id:        "oq-npm-3"
		question:  "NPM deve publicar eventos de terminação diretamente para CMT, ou CMT descobre via CTR?"
		impact:    "Evento direto npm→cmt permite reação imediata a terminação de participante. Via CTR, CMT só descobre na próxima operação que envolva o participante — latência pode ser significativa para compromissos ativos."
		deadline:  "2026-07-01"
		rationale: "Context-map v2 não declara relação npm→cmt. Este canvas não modela a relação operacionalmente enquanto não formalizada — ParticipantTerminated publica para REW, NIM e SSC, mas não para CMT. Decisão topológica pendente: se latência de descoberta via CTR for inaceitável para compromissos ativos, relação direta npm→cmt deverá ser adicionada ao context-map."
	}, {
		id:        "oq-npm-4"
		question:  "REW deve publicar sinais de risco que disparem reavaliação de qualificação em NPM, ou NPM opera apenas com monitoramento periódico próprio?"
		impact:    "Sem feedback de REW, monitoramento depende exclusivamente de cadência fixa (as-npm-4) e fontes externas. Com feedback, deterioração comportamental detectada por REW dispara reavaliação sob demanda — reduz janela de exposição."
		deadline:  "2026-07-15"
		rationale: "Canvas modela relação unidirecional npm→rew. as-npm-4 assume monitoramento periódico apenas; canal de feedback de REW para reavaliação sob demanda é possível mas não modelado. O canal rew→npm não existe no context-map. Se feedback for necessário, relação deve ser adicionada ao context-map."
	}]

	verificationMetrics: [{
		id:        "onboarding-completion-time"
		metric:    "Tempo médio entre RegisterParticipant e ParticipantQualified"
		target:    "< 48 horas para participantes com documentação completa"
		rationale: "Mede eficiência do processo de onboarding. Bloqueante para efeito de rede — cada dia de atraso é conversão perdida."
	}, {
		id:        "qualification-approval-rate"
		metric:    "Percentual de participantes registrados que completam qualificação"
		target:    "> 80% dos registros"
		rationale: "Taxa baixa indica fricção excessiva no processo ou aquisição de leads não qualificados por NGR."
	}, {
		id:        "suspension-rate"
		metric:    "Percentual de participantes qualificados que são suspensos no primeiro ano"
		target:    "< 5%"
		rationale: "Taxa alta indica falha no processo de qualificação — participantes que não deveriam ter sido qualificados."
	}]

	rationale: """
		Canvas do NPM como documento raiz de identidade. NPM é
		gate de qualificação da rede — gerencia ciclo de vida
		de participantes como pré-condição para operação.
		Supporting porque não é a proposta de valor final da
		Mesh, embora seja gate operacional e regulatório central;
		compliance-enforcer porque KYC/AML é a razão de NPM
		existir com a complexidade que tem; custom porque
		qualificação para SCD em cadeia produtiva B2B exige
		adaptação significativa. Gateway como archetype primário
		porque NPM controla quem pode operar; execution como
		secundário porque executa o processo de onboarding.
		Communication alinhada com context-map v2: 6 commands
		inbound, 2 event consumers (IDC —
		IdentityVerificationCompleted push; NGR —
		NetworkGrowthTargetDefined partnership), 2 query
		surfaces, 5 event publishers, 1 query dependency (IDC —
		QueryIdentityVerificationStatus, pull). Integração dual
		com IDC: evento push notifica conclusão, query pull
		confirma estado no ponto de decisão — em divergência,
		query prevalece. CTR consome NPM exclusivamente via
		query sync, não via evento — alinhado com npm-to-ctr
		no context-map. Eventos de lifecycle são especializações
		locais do published language estratégico
		NetworkParticipantStatusChanged do context-map —
		convenção local candidata a promoção. Runner trata
		cada evento granular como instância tipada do
		NetworkParticipantStatusChanged estratégico. Decisões de
		negócio: KYC/AML em NPM (não IDC), qualificação como
		gate binário (bd-qualification-as-gate), lifecycle
		explícito com 4 estados. Governance: registro e
		monitoramento autônomos; qualificação, suspensão,
		reativação e terminação supervisionados. Incentive
		analysis cobre 5 vetores (falsificação cadastral,
		identidade emprestada, ocultação de deterioração,
		agent misalignment, conluio coordenado) — vetores
		individuais com custos que excedem benefícios por
		design; conluio parcialmente mitigado (adversarial threat at-06,
		design principle dp-08). Relação npm→cmt
		pendente de formalização topológica (oq-npm-3).
		"""
}
