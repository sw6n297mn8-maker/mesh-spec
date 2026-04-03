package ctr

// canvas.cue — Bounded Context Canvas: Contract & Terms Registry.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// CTR é o registry canônico de termos contratuais. Termos são imutáveis
// e versionados — qualquer alteração cria nova versão. Lifecycle
// explícito (draft → active → superseded → expired → cancelled).
// CMT, SCF e DRC consomem CTR como SoT de validade jurídica.
//
// Lenses aplicadas:
// - lens-contractual-and-legal-architecture (primária):
//   contract stack, imutabilidade, liability, evidence de aceite
// - lens-temporal-modeling-for-financial-systems (primária):
//   bitemporalidade, validity windows, supersession dates
// - lens-contract-theory (primária):
//   contratos incompletos, residual rights, cadeia contratual
// - lens-event-driven-architecture-patterns (secundária):
//   append-only history, schema evolution, Published Language
// - lens-regulatory-compliance-as-architecture (secundária):
//   audit trail, reconstrução temporal, compliance by design
// - lens-platform-evolution-and-backwards-compatibility (secundária):
//   versionamento backward-compatible, supersession sem quebra

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

canvas: artifact_schemas.#Canvas & {
	code: "ctr"
	name: "Contract & Terms Registry"

	purpose: """
		Registrar, versionar e expor termos contratuais como fonte de
		verdade jurídica operacional para o commitment lifecycle. CTR
		garante que toda referência a termos — por CMT, SCF ou DRC —
		aponta para uma versão específica, imutável e vigente. Sem CTR,
		cada BC downstream resolve "quais são os termos?" de forma
		independente, criando inconsistência contratual que degrada
		disputas, precificação de crédito e formalização de compromissos.
		CTR não é sistema de gestão de contratos nem workflow de
		negociação — é registry versionado, imutável e auditável.
		"""

	ubiquitousLanguageRef: "contexts/ctr/glossary.cue"

	// ==============================
	// CLASSIFICAÇÃO ESTRATÉGICA
	// ==============================

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque formalização contratual é domínio bem
			entendido e não proprietário — padrões contratuais de
			construção civil são exógenos à Mesh. Operational-enabler
			porque CTR habilita operação de CMT, SCF e DRC sem ser
			gerador de receita direto. Product porque padrões de
			registry contratual existem no mercado — a Mesh adapta com
			versionamento imutável e bitemporalidade, mas não inventa
			o conceito.
			"""
	}

	// ==============================
	// DOMAIN ROLES
	// ==============================

	domainRoles: {
		primary: "specification"
		rationale: """
			Specification como primário: CTR define e expõe termos
			contratuais como artefatos formais consumidos por BCs
			downstream. Não executa workflows (CMT faz isso) nem
			processa eventos (DRC faz isso). CTR especifica as
			condições sob as quais compromissos são firmados,
			financiados e disputados.
			"""
	}

	// ==============================
	// CAPABILITIES
	// ==============================

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua de termos contratuais: cada registro,
				ativação, supersession e expiração é fato imutável no
				Event Log. Reconstrução temporal (as-of queries) permite
				ao regulador saber quais termos estavam vigentes em
				qualquer data passada.
				"""
			rationale: "Termos contratuais são base jurídica de operações financeiras. Se não são auditáveis com bitemporalidade, reconstituição regulatória é impossível."
		}, {
			description: """
				Registry versionado de termos contratuais: cada conjunto
				de termos é imutável após registro. Alterações criam nova
				versão com lineage explícita. Invariante: exatamente uma
				versão active por contrato+escopo (e.g., contrato de
				obra #123 + escopo 'fornecimento de concreto').
				"""
			rationale: "Imutabilidade com versionamento é o único modelo que permite reconstrução determinística. Mutação de termos in-place quebraria rastreabilidade end-to-end de compromissos, crédito e disputas."
		}, {
			description: """
				Published Language de termos contratuais: modelo canônico
				exposto via sync queries para CMT (formalização), SCF
				(precificação) e DRC (base jurídica de disputas).
				"""
			rationale: "Três BCs downstream consomem termos com semânticas diferentes. Published Language garante que todos referenciam a mesma fonte com tradução via ACL local."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// ==============================
	// COMUNICAÇÃO
	// ==============================

	communication: {
		inbound: [{
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Organização submete registro de termos contratuais com partes, cláusulas, condições e escopo."
			command:         "RegisterContractTerms"
			resultingEvents: ["ContractTermsDrafted"]
			description: "Inicia lifecycle do termo em estado draft. Agente valida completude estrutural e existência das partes em NPM. ContractTermsDrafted é evento interno."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Operador ou agente ativa termos contratuais após validação completa."
			command:         "ActivateContractTerms"
			resultingEvents: ["ContractTermsActivated"]
			description: "Transiciona termos de draft para active. Interface sync — caller recebe confirmação imediata de vigência. Execução interna pode envolver workflow de aprovação multi-step (e.g., revisão jurídica, compliance) antes da ativação efetiva. Gate verifica: unicidade de versão active por contrato+escopo, partes qualificadas, cláusulas válidas."
		}, {
			type:            "command-handler"
			interactionMode: "async"
			trigger:         "Organização submete nova versão de termos para contrato existente."
			command:         "RegisterTermsRevision"
			resultingEvents: ["ContractTermsDrafted"]
			description: "Cria nova versão em draft com lineage para versão anterior. Versão anterior permanece active até nova versão ser ativada."
		}, {
			type:            "command-handler"
			interactionMode: "sync"
			trigger:         "Operador cancela termos por invalidação (fraude, erro, regulatória)."
			command:         "CancelContractTerms"
			resultingEvents: ["ContractTermsCancelled"]
			description: "Transiciona termos para cancelled — estado terminal. Supervisionado por irreversibilidade e impacto em compromissos ativos downstream."
		}, {
			type:        "query-surface"
			query:       "QueryContractTerms"
			returnType:  "ContractTerms"
			description: "Retorna termos contratuais por ID+versão (version-pinned, preferido para operações já formalizadas) ou pela versão active de um contrato+escopo (para novos compromissos). Interface primária consumida por CMT, SCF e DRC."
		}, {
			type:        "query-surface"
			query:       "QueryContractClauses"
			returnType:  "ContractClauses"
			description: "Retorna cláusulas específicas de termos contratuais. Interface consumida por DRC para avaliar disputas contra base contratual."
		}]
		outbound: [{
			type:        "event-publisher"
			trigger:     "Termos contratuais ativados com sucesso."
			event:       "ContractTermsActivated"
			consumers:   ["cmt", "scf"]
			description: "Sinal de novos termos disponíveis. CMT pode referenciar em novos compromissos. SCF atualiza condições de elegibilidade."
		}, {
			type:        "event-publisher"
			trigger:     "Versão de termos superseded por nova versão ativada."
			event:       "ContractTermsSuperseded"
			consumers:   ["cmt", "scf", "drc"]
			description: "Sinal de que versão anterior não é mais a active. Compromissos existentes que referenciam versão superseded permanecem válidos — novos compromissos devem usar versão active."
		}, {
			type:        "event-publisher"
			trigger:     "Termos contratuais cancelados por invalidação."
			event:       "ContractTermsCancelled"
			consumers:   ["cmt", "drc"]
			description: "Sinal de invalidação. CMT deve avaliar compromissos ativos que referenciam estes termos. DRC registra como base para disputa."
		}, {
			type:          "query-dependency"
			targetContext: "npm"
			query:         "QueryParticipantStatus"
			purpose:       "Validar que partes referenciadas nos termos existem e estão qualificadas em NPM."
			description:   "CTR consome qualificação como pré-condição para registro. ACL traduz modelo de NPM para linguagem contratual."
		}]
		rationale: """
			Inbound: 4 commands (registro async + ativação sync + revisão
			async + cancelamento sync), 2 query surfaces (termos e
			cláusulas). Outbound: 3 event publishers (ativação para
			CMT/SCF, supersession para CMT/SCF/DRC, cancelamento para
			CMT/DRC), 1 query dependency (qualificação de partes via
			NPM). Padrão: CTR é upstream puro de termos contratuais,
			com uma única dependência de qualificação em NPM — publica
			sinais de lifecycle que downstream consome para manter
			referências válidas. Queries sync são interface principal
			(registry). hasAsyncSurface é true porque registro e
			revisão são async (não exigem resposta imediata) e CTR
			publica eventos de lifecycle consumidos por 3 BCs.
			"""
	}

	// ==============================
	// DECISÕES DE NEGÓCIO
	// ==============================

	businessDecisions: [{
		id:           "bd-terms-immutability"
		decision:     "Termos contratuais são imutáveis após ativação. Qualquer alteração cria nova versão com lineage explícito."
		rationale:    "Imutabilidade é pré-requisito para reconstrução temporal, auditoria regulatória e precificação correta em SCF. Termos mutáveis criariam inconsistência entre compromisso e base contratual."
		consequences: "Aditivos sempre geram nova versão — não é possível 'corrigir' termos ativos. Aumenta volume de versões, mas custo de storage é negligível comparado a custo de inconsistência."
	}, {
		id:           "bd-single-active-version"
		decision:     "Para um mesmo contrato+escopo, apenas uma versão de termos pode estar active simultaneamente."
		rationale:    "Ambiguidade sobre qual versão é vigente criaria disputas irresolvíveis em DRC, precificação incorreta em SCF e referência ambígua em CMT. Unicidade é invariante de integridade do sistema inteiro."
		consequences: "Ativar nova versão automaticamente supersede a anterior. Consumers que referenciavam versão antiga mantêm referência (snapshot), mas novos consumers usam versão active."
	}, {
		id:           "bd-lifecycle-explicit"
		decision:     "Termos têm lifecycle explícito com 5 estados (draft, active, superseded, expired, cancelled) e transições determinísticas."
		rationale:    "Sem lifecycle, CTR seria storage passivo — qualquer BC poderia referenciar termos inválidos. Lifecycle garante que apenas termos active são consumíveis por novos compromissos. Estados terminais (superseded, expired, cancelled) são consultáveis mas não referenciáveis."
		consequences: "CMT valida estado active antes de aceitar referência. Expiração requer mecanismo temporal (scheduled check ou event). Cancelamento requer supervisão humana."
	}]

	// ==============================
	// STAKEHOLDERS
	// ==============================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Registrante primário de termos contratuais — submete termos vinculados a contratos de obra com fornecedores."
		impactDescription: "Registry versionado dá à construtora controle sobre evolução contratual com auditabilidade completa. Aditivos não reescrevem histórico."
		rationale:         "Construtora origina a maioria dos contratos no vertical de construção civil. É quem mais se beneficia de termos formalizados e rastreáveis."
	}, {
		stakeholderRef:    "sh-02"
		roleInContext:     "Contraparte de termos contratuais — confirma termos e consome referência para validação de compromissos."
		impactDescription: "Termos imutáveis e versionados dão ao fornecedor garantia de que a base contratual não muda retroativamente. Cada versão é verificável."
		rationale:         "Fornecedor é a parte mais vulnerável a mudanças unilaterais de termos. Imutabilidade protege contra reescrita de histórico."
	}, {
		stakeholderRef:    "sh-03"
		roleInContext:     "Consumidor indireto — qualidade e vigência dos termos determinam qualidade do lastro para operações de crédito em SCF."
		impactDescription: "Termos vigentes e auditáveis melhoram qualidade de due diligence sobre recebíveis. Versionamento permite rastrear base contratual de cada operação."
		rationale:         "IF parceira depende de termos válidos para decisão de crédito. Termo expirado ou cancelado invalida o lastro."
	}, {
		stakeholderRef:    "sh-04"
		roleInContext:     "Regulador — exige que operações de crédito via SCD tenham base contratual documentada, auditável e reconstituível."
		impactDescription: "Registry imutável com bitemporalidade permite reconstrução temporal completa — 'quais termos estavam vigentes na data X da operação Y'."
		rationale:         "Compliance regulatório é constraint inviolável. Bacen exige rastreabilidade de base contratual de operações de crédito."
	}, {
		stakeholderRef:    "sh-05"
		roleInContext:     "Operador primário — registra termos, valida qualificação de partes, gerencia lifecycle, expõe Published Language."
		impactDescription: "Governance scope com boundaries claras: registro e validação autônomos, ativação e cancelamento supervisionados."
		rationale:         "Agente IA opera sobre registry imutável — não pode alterar termos, apenas registrar novas versões e gerenciar transições de lifecycle."
	}]

	// ==============================
	// CUSTOS ELIMINADOS
	// ==============================

	costsEliminated: [{
		costRef: "ce-02"
		contribution: """
			CTR elimina custo de compliance documental na formalização
			contratual: termos registrados como entidades estruturadas
			e auditáveis substituem documentos ad-hoc e processos
			manuais de verificação de vigência. Cada consulta de CMT
			ou SCF é respondida por query determinístico contra
			registry, não por busca em arquivos.
			"""
		rationale: "ce-02 se aplica diretamente: compliance documental de termos contratuais é custo de transação que CTR estrutura e automatiza."
	}, {
		costRef: "ce-07"
		contribution: """
			CTR reduz custo de due diligence sobre lastro de
			recebíveis: termos versionados e imutáveis permitem que
			IF parceira (sh-03) verifique base contratual de cada
			recebível por query, sem análise manual de documentos.
			Lineage de versões torna auditável a evolução contratual.
			"""
		rationale: "ce-07 se aplica porque due diligence sobre recebíveis exige verificação da base contratual — e CTR é o SoT que responde essa verificação."
	}]

	// ==============================
	// INCENTIVE ANALYSIS
	// ==============================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:             "sh-01"
			participantType:           "registrante"
			desiredBehavior:           "Registrar termos contratuais precisos, completos e atualizados, refletindo acordos reais com fornecedores."
			correctOperationIncentive: "Termos precisos evitam disputas em DRC e aceleram formalização de compromissos em CMT. Termos imprecisos bloqueiam pipeline de antecipação em SCF — custo financeiro direto."
			manipulationVector:        "Registrar termos que favoreçam unilateralmente a construtora — cláusulas de retenção excessivas, prazos irreais, condições unilaterais de cancelamento."
			manipulationCost:          "Termos são imutáveis e versionados — adulteração posterior é impossível. Contraparte (sh-02) confirma termos. DRC pode referenciar versão exata em disputa. REW detecta padrões anômalos de termos."
			vsBenefit:                 "Benefício de termos enviesados é limitado ao gap entre registro e contestação. Custo inclui disputa em DRC com base documental desfavorável, deterioração de score em REW e bloqueio de pipeline em SCF."
			designResponse:            "Imutabilidade impede reescrita. Versionamento com lineage torna adulteração detectável. Contraparte confirma termos bilateralmente. DRC tem base jurídica objetiva (versão referenciada). REW monitora padrões anômalos cross-contrato."
			rationale:                 "Construtora como registrante tem incentivo para termos enviesados. Design response usa imutabilidade + bilateralidade + rastreabilidade para tornar manipulação mais cara que operação correta."
		}, {
			stakeholderRef:             "sh-02"
			participantType:           "contraparte"
			desiredBehavior:           "Revisar e confirmar apenas termos cujas condições são realizáveis e juridicamente equilibradas."
			correctOperationIncentive: "Termos equilibrados garantem que entrega verificada em DLV gera pagamento previsível via FCE. Termos desequilibrados geram disputas que bloqueiam pagamento."
			manipulationVector:        "Aceitar termos sem revisão para acelerar formalização, ou aceitar termos sabendo que pretende contestar cláusulas específicas posteriormente em DRC."
			manipulationCost:          "Termos aceitos são imutáveis e vinculam compromissos em CMT. DRC resolve disputas contra a versão exata aceita — contestar o que aceitou tem custo jurídico alto. Score em REW deteriora com disputas recorrentes."
			vsBenefit:                 "Benefício de aceite apressado é velocidade de formalização. Custo é vinculação a termos desfavoráveis com base documental irrefutável em disputa."
			designResponse:            "Imutabilidade cria consequência permanente do aceite. Versionamento com lineage documenta exatamente o que foi aceito e quando. DRC tem base objetiva. REW penaliza disputas recorrentes."
			rationale:                 "Fornecedor como contraparte tem incentivo para aceitar rápido. Design response vincula aceite a consequências documentadas e permanentes."
		}]
		rationale: """
			Análise foca nos dois participantes diretos do registro
			de termos (registrante e contraparte). Ambos têm vetores
			de manipulação com custos que excedem benefícios por design:
			imutabilidade impede reescrita, versionamento com lineage
			torna adulteração detectável, bilateralidade distribui
			responsabilidade, DRC tem base jurídica objetiva para
			resolver disputas (dp-08).
			"""
	}

	// ==============================
	// OWNERSHIP & GOVERNANCE
	// ==============================

	ownership: {
		domainAgentSpec: "contexts/ctr/agents/ctr-primary-agent.cue"
		governanceScope: {
			autonomousDecisions: [{
				id:          "validate-participant-qualification"
				description: "Validar automaticamente que partes referenciadas nos termos estão qualificadas em NPM."
				rationale:   "Validação é determinística — query sync contra NPM com resposta binária. Sem margem para erro de julgamento."
			}, {
				id:          "record-terms-draft"
				description: "Registrar termos submetidos em estado draft no Event Log."
				rationale:   "Registro de rascunho é append-only e determinístico. Não cria obrigação — apenas registra intenção."
			}, {
				id:          "detect-expired-terms"
				description: "Detectar e transicionar automaticamente termos cuja data de vigência expirou."
				rationale:   "Expiração é evento temporal determinístico — não requer julgamento. Data de vigência é campo explícito dos termos."
			}, {
				id:          "publish-lifecycle-events"
				description: "Publicar eventos de transição de lifecycle para consumers downstream."
				rationale:   "Publicação de fatos é append-only e determinístico. Downstream decide como reagir."
			}]
			supervisedDecisions: [{
				id:          "activate-contract-terms"
				description: "Ativar termos contratuais — transicionar de draft para active."
				rationale:   "Ativação cria base jurídica para compromissos em CMT e elegibilidade em SCF. Supervisão garante que termos foram revisados por humano antes de vincular sistema."
			}, {
				id:          "cancel-contract-terms"
				description: "Cancelar termos contratuais — invalidação definitiva por erro, fraude ou decisão regulatória."
				rationale:   "Cancelamento afeta compromissos existentes que referenciam esses termos. Decisão irreversível com impacto cross-context — exige supervisão humana."
			}]
			escalationCriteria: [{
				id:        "novel-contract-type"
				condition: "Tipo de contrato não previsto nos templates existentes — novo vertical, novo instrumento jurídico."
				action:    "Escalar ao founder para definição de template e validação de conformidade jurídica."
				rationale: "Tipos novos podem ter cláusulas e requisitos regulatórios não previstos. Decisão irreversível se termos ativados sob premissas incorretas."
			}, {
				id:        "high-value-contract"
				condition: "Valor do contrato excede threshold definido no autonomy envelope."
				action:    "Escalar ao humano designado para revisão antes de ativar termos."
				rationale: "Contratos de alto valor têm blast radius jurídico e financeiro proporcional. Supervisão humana é controle de contenção."
			}, {
				id:        "regulatory-ambiguity"
				condition: "Cláusulas ou estrutura do contrato caem em zona cinza regulatória não coberta por regras existentes."
				action:    "Escalar ao compliance officer para parecer antes de ativar."
				rationale: "Integridade legal é constraint inviolável (nível 1). Zona cinza exige julgamento humano especializado."
			}]
		}
		rationale: """
			ctr-primary-agent como operador, referenciado por path
			canônico (contexts/ctr/agents/ctr-primary-agent.cue) —
			SoT local do BC. 4 decisões autônomas (validação de
			qualificação, registro de draft, detecção de expiração,
			publicação de eventos), 2 decisões supervisionadas
			(ativação e cancelamento de termos), 3 critérios de
			escalação (tipo novo, alto valor, ambiguidade
			regulatória). Boundaries refletem mech-agent-gate:
			agente registra e valida, supervisão humana para decisões
			que criam base jurídica ou a invalidam.
			"""
	}

	// ==============================
	// ASSUMPTIONS & OPEN QUESTIONS
	// ==============================

	assumptions: [{
		id:                 "as-ctr-1"
		assumption:         "Modelo de versionamento com lineage linear (v1→v2→v3) é suficiente — não há necessidade de branching de versões."
		invalidationSignal: "Surgimento de contratos que exigem versões paralelas para o mesmo escopo (e.g., termos condicionais por cenário de mercado)."
		rationale:          "Lineage linear simplifica invariante de unicidade de versão ativa. Branching adicionaria complexidade significativa ao modelo."
	}, {
		id:                 "as-ctr-2"
		assumption:         "NPM como SoT de qualificação de participantes está disponível com latência aceitável para validação síncrona."
		invalidationSignal: "Latência de QueryParticipantQualification consistentemente acima de SLA ou indisponibilidade frequente de NPM."
		rationale:          "Dependência sync de NPM é ponto de falha. Se NPM não é confiável, CTR precisa de estratégia de resiliência."
	}, {
		id:                 "as-ctr-3"
		assumption:         "Expiração automática por data é suficiente — não há necessidade de expiração condicional baseada em eventos de negócio."
		invalidationSignal: "Contratos com prazo indefinido ou prazo condicional a marco de obra (não data fixa)."
		rationale:          "Expiração temporal é determinística e automatizável. Expiração condicional exigiria integração com BCs de execução (DLV, LOG)."
	}]

	openQuestions: [{
		id:        "oq-ctr-1"
		question:  "Qual o threshold de valor contratual para escalação de ativação? Como definir thresholds por vertical?"
		impact:    "Sem threshold definido, toda ativação requer supervisão humana, eliminando benefício de automação."
		deadline:  "2026-06-01"
		rationale: "Threshold deve ser calibrado com dados reais de operação. Bloqueante para autonomy envelope completo."
	}, {
		id:        "oq-ctr-2"
		question:  "CTR deve publicar eventos de expiração proativamente ou consumers devem consultar vigência sob demanda?"
		impact:    "Padrão push (eventos) vs pull (queries) afeta acoplamento e latência de reação de CMT e SCF."
		deadline:  "2026-07-01"
		rationale: "Decisão de arquitetura de comunicação que afeta 3 BCs downstream. Canvas assume push (eventos) como default."
	}]

	// ==============================
	// VERIFICATION METRICS
	// ==============================

	verificationMetrics: [{
		id:        "terms-activation-time"
		metric:    "Tempo médio entre RegisterContractTerms e ActivateContractTerms"
		target:    "< 24 horas para termos standard"
		rationale: "Mede eficiência do fluxo de registro → revisão → ativação."
	}, {
		id:        "active-terms-validity-rate"
		metric:    "Percentual de termos active que são efetivamente referenciados por compromissos em CMT"
		target:    "> 90% dos termos ativados"
		rationale: "Taxa baixa indica termos ativados sem demanda — possível ineficiência no fluxo de registro."
	}, {
		id:        "terms-dispute-reference-rate"
		metric:    "Percentual de disputas em DRC que referenciam termos cancelados ou expirados"
		target:    "< 2% das disputas"
		rationale: "Taxa alta indica que compromissos estão sendo formalizados sob termos que deveriam ter sido invalidados — falha no lifecycle."
	}]

	// ==============================
	// RATIONALE GERAL
	// ==============================

	rationale: """
		Canvas do CTR como documento raiz de identidade. CTR é o
		registry canônico de termos contratuais da Mesh — fundação
		jurídica sobre a qual CMT formaliza compromissos, SCF precifica
		antecipações e DRC resolve disputas. Supporting porque
		formalização contratual é domínio entendido; product porque
		nenhuma solução existente integra versionamento imutável com
		lifecycle financeiro. Specification como archetype primário
		porque CTR define e expõe Published Language consumida por 3
		BCs. Communication: 4 commands inbound (register, activate,
		amend, cancel), 1 event consumer (NPM), 2 query surfaces
		(termos + cláusulas), 4 event publishers (lifecycle
		transitions), 1 query dependency (NPM qualificação). Decisões
		de negócio: imutabilidade, unicidade de versão active e
		lifecycle explícito. Governance: registro e validação autônomos;
		ativação e cancelamento supervisionados. Incentive analysis
		demonstra que manipulação por registrante ou contraparte é mais
		cara que operação correta por design: imutabilidade,
		bilateralidade, rastreabilidade e base jurídica objetiva para
		disputas (dp-08).
		"""
}
