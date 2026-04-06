package npm

// glossary.cue — Ubiquitous Language: Network Participant Management.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC NPM. Define o vocabulário que agentes,
// código, contratos e interfaces usam ao operar neste contexto.
//
// Lenses aplicadas:
// - lens-domain-language-and-terminology-design (primária):
//   bilingual mapping, term selection, cross-layer consistency
// - lens-regulatory-compliance-as-architecture (secundária):
//   precisão regulatória de termos KYC/AML que criam obrigações
//   de compliance

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "npm"
	name: "Glossário NPM — Network Participant Management"

	boundedContextRef: "npm"

	terms: [{
		code:       "term-participante"
		name:       "Participante"
		termEn:     "Participant"
		definition: "Organização registrada na rede Mesh com ciclo de vida gerenciado por NPM. Identificada por CNPJ, transita entre 4 estados (pending, qualified, suspended, terminated). NPM é SoT do participante — BCs downstream referenciam via query ou consomem eventos de lifecycle."
		category:   "entity"
		rationale:  "Conceito central do BC. Participante é mais preciso que 'empresa' (nem todo participante é empresa no futuro multi-vertical), 'membro' (implica adesão voluntária sem gate) ou 'cliente' (implica relação comercial unilateral). Participante captura a bilateralidade: a organização se registra, a rede qualifica."
		synonyms: ["Membro da rede"]
		antiTerms: [{
			term:          "Usuário"
			clarification: "Usuário é pessoa física que opera em nome de um participante. NPM gerencia organizações, não pessoas. Gestão de identidade de pessoas vive em IDC."
		}, {
			term:          "Cliente"
			clarification: "Cliente implica relação comercial unilateral (vendedor→comprador). Participante é bilateral — comprador e fornecedor são ambos participantes com o mesmo ciclo de vida de qualificação."
		}, {
			term:          "Cedente"
			clarification: "Cedente é papel jurídico na cessão de crédito (SCF/INV). Participante é o conceito operacional de quem pode operar na rede — anterior e mais amplo que o papel financeiro."
		}]
		rejectedAlternatives: [{
			term:   "Membro"
			reason: "Implica pertencimento voluntário sem gate. Na Mesh, participação exige qualificação KYC/AML — não é adesão livre."
		}, {
			term:   "Operador"
			reason: "Confuso com operador da plataforma (sh-05 no stakeholder-map). Operador na Mesh é o agente IA ou o humano que administra, não quem opera comercialmente."
		}]
		examples: [{
			context:   "Vertical construção civil"
			instance:  "Construtora XYZ Ltda registrada como participante-comprador, qualificada após KYC/AML, com status 'qualified' habilitando registro de termos em CTR."
			rationale: "Exemplo do vertical primário — construtora é o caso de uso âncora."
		}, {
			context:   "Fornecedor qualificado"
			instance:  "Fornecedor de concreto ABC S.A. com status 'qualified', referenciado por CTR para registro de termos e por REW para scoring de risco."
		}]
		relatedTerms: ["term-status-de-participante", "term-qualificacao", "term-perfil-de-participante"]
		domainModelRefs: ["agg-participant"]
		layerMapping: {
			codeTerm: "Participant"
			apiTerm:  "participants"
			uiLabel:  "Participante"
		}
	}, {
		code:       "term-status-de-participante"
		name:       "Status de Participante"
		termEn:     "Participant Status"
		definition: "Estado canônico do participante no ciclo de vida NPM: pending (registrado, aguardando qualificação), qualified (aprovado para operar), suspended (temporariamente bloqueado por irregularidade), terminated (excluído definitivamente). NPM é SoT deste status — CTR consulta via QueryParticipantStatus antes de registrar termos."
		category:   "value"
		rationale:  "Status como value object tipado garante transições explícitas e auditáveis. Sem SoT de status, BCs downstream operam sobre estado inconsistente. Quatro estados cobrem o ciclo completo: entrada, operação, pausa reversível, saída irreversível."
		antiTerms: [{
			term:          "Score de Risco"
			clarification: "Score é avaliação contínua de risco operacional em REW. Status é estado discreto de habilitação em NPM. Participante qualified pode ter score baixo; participante suspended pode ter score alto antes da irregularidade."
		}]
		examples: [{
			context:   "Transições"
			instance:  "pending → qualified (ApproveQualification). pending → terminated (TerminateParticipant — fraude durante onboarding). qualified → suspended (SuspendParticipant). suspended → qualified (ReactivateParticipant). qualified → terminated (TerminateParticipant). suspended → terminated (TerminateParticipant)."
			rationale: "Diagrama de estados completo com 6 transições. Não existe transição pending → suspended nem terminated → qualquer estado."
		}]
		relatedTerms: ["term-participante", "term-gate-de-qualificacao"]
		domainModelRefs: ["vo-participant-status"]
		layerMapping: {
			codeTerm: "ParticipantStatus"
			apiTerm:  "participant_status"
			uiLabel:  "Status"
		}
	}, {
		code:       "term-qualificacao"
		name:       "Qualificação"
		termEn:     "Qualification"
		definition: "Processo de verificação KYC/AML que transiciona participante de pending para qualified. Envolve recepção de documentação, verificação contra fontes externas (Receita Federal, Junta Comercial) via IDC, e decisão supervisionada de aprovação. Resultado é binário: qualified ou não — sem tiers intermediários (bd-qualification-as-gate)."
		category:   "process"
		rationale:  "Qualificação é mais preciso que 'aprovação' (implica decisão discricionária) ou 'verificação' (IDC faz verificação de identidade — qualificação é o processo completo de KYC/AML que consome a verificação). A razão de NPM existir com a complexidade que tem é a qualificação KYC/AML (canvas: compliance-enforcer)."
		rejectedAlternatives: [{
			term:   "Homologação"
			reason: "Homologação implica conformidade técnica — não captura a dimensão regulatória KYC/AML que é a essência do processo."
		}, {
			term:   "Certificação"
			reason: "Certificação implica atestado emitido por autoridade externa. Qualificação é decisão interna da Mesh baseada em verificações externas."
		}]
		examples: [{
			context:   "Fluxo completo"
			instance:  "Fornecedor registra → submete documentos KYC/AML → IDC verifica identidade → NPM confirma via query → supervisor aprova qualificação → ParticipantQualified publicado."
		}]
		relatedTerms: ["term-participante", "term-gate-de-qualificacao", "term-aprovar-qualificacao", "term-documentacao-de-qualificacao"]
		layerMapping: {
			codeTerm: "Qualification"
			apiTerm:  "qualifications"
			uiLabel:  "Qualificação"
		}
	}, {
		code:       "term-gate-de-qualificacao"
		name:       "Gate de Qualificação"
		termEn:     "Qualification Gate"
		definition: "Regra de negócio que impõe qualificação como pré-condição binária para operações contratuais e financeiras na rede. Participante qualified opera; participante em qualquer outro status não gera novos termos em CTR. BCs como REW e NIM referenciam participantes em qualquer estado para fins de observação (scoring, topologia) — o gate restringe operações, não observação."
		category:   "rule"
		rationale:  "Decisão vigente bd-qualification-as-gate no canvas. Gate binário é deliberado: simplifica validação downstream (CTR verifica um boolean, não tiers), reduz superfície de ataque (sem estado intermediário manipulável), e alinha com postura regulatória conservadora de SCD. Tiers são evolução futura (oq-npm-1)."
		antiTerms: [{
			term:          "Tier de Acesso"
			clarification: "Tiers implicam gradação. Gate de qualificação é binário por design — qualified ou not-qualified-to-operate. Evolução para tiers é questão aberta (oq-npm-1), não estado atual."
		}]
		relatedTerms: ["term-status-de-participante", "term-qualificacao"]
		domainModelRefs: ["inv-qualification-gate"]
	}, {
		code:       "term-monitoramento-continuo"
		name:       "Monitoramento Contínuo"
		termEn:     "Continuous Monitoring"
		definition: "Processo pós-qualificação que reavalia periodicamente a conformidade do participante. Opera com cadência trimestral fixa (as-npm-4) e consulta fontes externas. Deterioração detectada pode disparar suspensão. Canal de feedback de REW para reavaliação sob demanda não modelado (oq-npm-4)."
		category:   "process"
		rationale:  "Qualificação é gate de entrada; monitoramento contínuo é o enforcement permanente. Sem monitoramento, participante qualificado que deteriora continua operando — risco regulatório e de efeito de rede (participante ruim degrada confiança da rede inteira)."
		relatedTerms: ["term-qualificacao", "term-suspensao-de-participante"]
		layerMapping: {
			codeTerm: "ContinuousMonitoring"
			uiLabel:  "Monitoramento"
		}
	}, {
		code:       "term-suspensao-de-participante"
		name:       "Suspensão de Participante"
		termEn:     "Participant Suspension"
		definition: "Transição de qualified para suspended, bloqueando temporariamente operações do participante na rede. Decisão supervisionada — agente detecta irregularidade e recomenda, supervisor autoriza. Reversível via reativação (suspended → qualified). REW, NIM e SSC consomem o evento ParticipantSuspended para atualizar scoring, topologia e sourcing pool respectivamente."
		category:   "process"
		rationale:  "Suspensão como processo supervisionado (não autônomo) porque afeta todo o ecosystem downstream. Reversibilidade distingue suspensão de terminação — participante suspenso pode resolver irregularidade e retornar."
		relatedTerms: ["term-status-de-participante", "term-terminacao-de-participante", "term-participante"]
		layerMapping: {
			codeTerm: "ParticipantSuspension"
			apiTerm:  "suspensions"
			uiLabel:  "Suspensão"
		}
	}, {
		code:       "term-terminacao-de-participante"
		name:       "Terminação de Participante"
		termEn:     "Participant Termination"
		definition: "Exclusão definitiva e irreversível do participante da rede. Transiciona de qualified, suspended ou pending para terminated. Decisão supervisionada com justificativa documentada. Não existe caminho de volta — terminated é estado final. Evento ParticipantTerminated notifica REW, NIM e SSC."
		category:   "process"
		rationale:  "Irreversibilidade exige supervisão e documentação — dp-10 (responsabilidade jurídica). Terminação é a sanção máxima da rede, reservada para irregularidades graves ou violações irrecuperáveis. Impacto em compromissos ativos pendente de decisão topológica (oq-npm-3)."
		antiTerms: [{
			term:          "Suspensão"
			clarification: "Suspensão é reversível (suspended → qualified via reativação). Terminação é irreversível (terminated é estado final sem transição de saída)."
		}]
		relatedTerms: ["term-suspensao-de-participante", "term-status-de-participante"]
		layerMapping: {
			codeTerm: "ParticipantTermination"
			apiTerm:  "terminations"
			uiLabel:  "Terminação"
		}
	}, {
		code:       "term-registrar-participante"
		name:       "Registrar Participante"
		termEn:     "Register Participant"
		definition: "Command que inicia o ciclo de vida do participante em NPM. Recebe dados cadastrais e inicia o participante em estado pending. Async porque não depende de resposta imediata — o fluxo de qualificação é subsequente. Gera evento ParticipantRegistered consumido por NGR (métricas de crescimento), REW (modelo de risco baseline) e NIM (topologia)."
		category:   "command"
		rationale:  "Ponto de entrada canônico no lifecycle. Separado de qualificação porque registro é autônomo (validação de completude) enquanto qualificação é supervisionada (decisão material). Cold start depende de registro frictionless (oq-npm-2 SLA)."
		relatedTerms: ["term-participante", "term-participant-registered"]
		domainModelRefs: ["cmd-register-participant"]
		layerMapping: {
			codeTerm: "RegisterParticipant"
			apiTerm:  "participants"
			uiLabel:  "Novo Registro"
		}
	}, {
		code:       "term-aprovar-qualificacao"
		name:       "Aprovar Qualificação"
		termEn:     "Approve Qualification"
		definition: "Command supervisionado que transiciona participante de pending para qualified. Sync porque supervisor precisa de confirmação imediata. Pré-condição: query a IDC (QueryIdentityVerificationStatus) confirma verificação de identidade — em divergência com evento previamente recebido, query prevalece. Gera evento ParticipantQualified."
		category:   "command"
		rationale:  "Gate de qualificação materializado como command supervisionado. Sync por exigência de feedback imediato ao supervisor. Integração dual com IDC (evento push + query pull) garante consistência no momento da decisão — não na chegada do evento."
		relatedTerms: ["term-qualificacao", "term-gate-de-qualificacao", "term-participant-qualified"]
		domainModelRefs: ["cmd-approve-qualification"]
		layerMapping: {
			codeTerm: "ApproveQualification"
			apiTerm:  "qualifications/{id}/approval"
			uiLabel:  "Aprovar Qualificação"
		}
	}, {
		code:       "term-participant-qualified"
		name:       "ParticipantQualified"
		termEn:     "Participant Qualified"
		definition: "Evento de domínio publicado quando participante transiciona para qualified. Sinal cross-context mais importante do NPM — REW incorpora em modelos de risco, NIM atualiza topologia, SSC considera para sourcing. CTR consome status via query sync, não via evento. Context-map referencia como NetworkParticipantStatusChanged — convenção local especializa em eventos granulares por transição."
		category:   "event"
		rationale:  "Evento que habilita operações downstream. Nome granular (ParticipantQualified) em vez de genérico (ParticipantStatusChanged) porque consumers precisam distinguir tipo de transição sem parsear payload. Convenção local documentada no canvas header."
		relatedTerms: ["term-qualificacao", "term-participante"]
		domainModelRefs: ["evt-participant-qualified"]
		layerMapping: {
			codeTerm: "ParticipantQualified"
		}
	}, {
		code:       "term-participant-registered"
		name:       "ParticipantRegistered"
		termEn:     "Participant Registered"
		definition: "Evento de domínio publicado quando novo participante é registrado em estado pending. Consumido por NGR (métricas de crescimento), REW (modelo de risco baseline) e NIM (topologia). Context-map referencia como NetworkParticipantOnboarded — divergência de nome documentada. Evento de criação de entidade, não transição de status — não faz parte da convenção local de eventos de lifecycle."
		category:   "event"
		rationale:  "Sinal de registro é distinto de sinal de qualificação. NGR precisa saber que novo registro aconteceu (funil de conversão) independente do resultado da qualificação. Divergência de nome com context-map (ParticipantRegistered vs NetworkParticipantOnboarded) documentada explicitamente."
		relatedTerms: ["term-registrar-participante", "term-participante"]
		domainModelRefs: ["evt-participant-registered"]
		layerMapping: {
			codeTerm: "ParticipantRegistered"
		}
	}, {
		code:       "term-perfil-de-participante"
		name:       "Perfil de Participante"
		termEn:     "Participant Profile"
		definition: "Visão composta do participante: dados cadastrais, histórico de qualificação, estado atual. Exposto via QueryParticipantProfile para SSC (decisão de sourcing). REW obtém dados via eventos de lifecycle, não via query sync (npm-to-rew é async-only no context-map)."
		category:   "value"
		rationale:  "Perfil é value object de leitura que agrega informações para consumers. Distinto de Status (campo singular) — perfil é o pacote completo. Exposição via query surface segue OHS pattern."
		relatedTerms: ["term-participante", "term-status-de-participante"]
		domainModelRefs: ["vo-participant-profile"]
		layerMapping: {
			codeTerm: "ParticipantProfile"
			apiTerm:  "participants/{id}/profile"
			uiLabel:  "Perfil do Participante"
		}
	}, {
		code:       "term-documentacao-de-qualificacao"
		name:       "Documentação de Qualificação"
		termEn:     "Qualification Documentation"
		definition: "Conjunto de documentos KYC/AML submetidos pelo participante para sustentar qualificação: documentação societária, comprovantes fiscais, certidões negativas, e demais evidências exigidas pela regulação SCD. Verificada contra fontes externas (Receita Federal, Junta Comercial) via IDC. Submissão é assíncrona (SubmitQualificationDocuments); recepção gera evento interno QualificationDocumentsReceived."
		category:   "document"
		rationale:  "Documentação é o insumo material da qualificação. Sem termo canônico, agentes tratam como 'arquivos' ou 'docs' genéricos, perdendo a semântica regulatória: são documentos com exigência legal específica (SCD, KYC/AML), não uploads genéricos."
		antiTerms: [{
			term:          "Identidade"
			clarification: "Identidade é verificação de quem é a organização — vive em IDC. Documentação de qualificação é o conjunto de evidências para qualificar a organização para operar — processo em NPM que consome identidade verificada de IDC."
		}]
		relatedTerms: ["term-qualificacao"]
		layerMapping: {
			codeTerm: "QualificationDocumentation"
			apiTerm:  "qualifications/{id}/documents"
			uiLabel:  "Documentação"
		}
	}]

	rationale: "Glossário do NPM cobre os conceitos centrais do lifecycle de participantes: a entidade (Participante), sua identidade de estado (Status de Participante, Perfil de Participante), o processo core (Qualificação) e sua regra binária (Gate de Qualificação), o enforcement contínuo (Monitoramento Contínuo), as transições materiais (Suspensão, Terminação), os commands de entrada e gate (Registrar Participante, Aprovar Qualificação), os eventos cross-context (ParticipantQualified, ParticipantRegistered), e o insumo regulatório (Documentação de Qualificação). domainModelRefs prospectivos vinculam termos aos building blocks táticos previstos. Lenses aplicadas: domain-language (bilingual mapping pt-BR/en, term selection, cross-layer consistency) e regulatory-compliance (precisão de termos KYC/AML que criam obrigações de compliance — especialmente Qualificação, Gate e Documentação)."
}
