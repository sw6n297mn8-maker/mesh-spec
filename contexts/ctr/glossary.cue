package ctr

// glossary.cue — Ubiquitous Language: Contract & Terms Registry.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC CTR. Define o vocabulário que agentes,
// código, contratos e interfaces usam ao operar neste contexto.
//
// Lenses aplicadas:
// - lens-domain-language-and-terminology-design (primária):
//   bilingual mapping, term selection, cross-layer consistency
// - lens-contractual-and-legal-architecture (secundária):
//   precisão jurídica de termos que governam base contratual

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "ctr"
	name: "Glossário CTR — Contract & Terms Registry"

	boundedContextRef: "ctr"

	terms: [{
		code:       "term-termos-contratuais"
		name:       "Termos Contratuais"
		termEn:     "Contract Terms"
		definition: "Conjunto imutável e versionado de cláusulas, condições e obrigações que governam um contrato entre partes. Entidade central do CTR — cada instância é registrada em draft, ativada, e eventualmente supersedida, expirada ou cancelada. Após ativação, termos são imutáveis: qualquer alteração cria nova versão com lineage explícito."
		category:   "entity"
		rationale:  "Conceito central do BC. 'Termos Contratuais' é mais preciso que 'contrato' (instrumento jurídico completo, broader que escopo do CTR) ou 'cláusulas' (sub-unidade dos termos). CTR gerencia termos como entidade versionada, não o contrato como instrumento."
		synonyms: ["Termos", "Conjunto de Termos"]
		antiTerms: [{
			term:          "Contrato"
			clarification: "Contrato é o instrumento jurídico completo (partes, objeto, foro, etc.). Termos Contratuais são as condições específicas (cláusulas de SLA, retenção, garantia, penalidade) registradas e versionadas em CTR. Um contrato pode ter múltiplas versões de termos ao longo do tempo."
		}, {
			term:          "Compromisso"
			clarification: "Compromisso é a entidade bilateral de CMT — nasce do aceite mútuo e referencia termos de CTR. CTR não gerencia compromissos; CMT os formaliza referenciando termos vigentes."
		}]
		rejectedAlternatives: [{
			term:   "Condições Contratuais"
			reason: "Ambíguo — 'condições' pode referir a pré-condições de execução ou a cláusulas do contrato. 'Termos' é mais preciso no vocabulário jurídico brasileiro."
		}, {
			term:   "Instrumento Contratual"
			reason: "Instrumento é o documento completo. CTR gerencia termos (cláusulas, condições) — não o instrumento em si."
		}]
		examples: [{
			context:   "Contrato de obra com fornecedor de concreto"
			instance:  "Termos contratuais v1: SLA de entrega 48h, retenção de 5%, penalidade por atraso de 0,5%/dia, garantia de 12 meses. Após aditivo, v2 criada com retenção de 3% — v1 transiciona para superseded."
			rationale: "Exemplo do vertical de construção civil mostrando versionamento com lineage."
		}]
		relatedTerms: ["term-versao-de-termos", "term-clausula-contratual", "term-estado-de-termos", "term-lineage"]
		domainModelRefs: ["agg-contract-terms"]
		layerMapping: {
			codeTerm: "ContractTerms"
			apiTerm:  "contract-terms"
			uiLabel:  "Termos Contratuais"
		}
	}, {
		code:       "term-versao-de-termos"
		name:       "Versão de Termos"
		termEn:     "Terms Version"
		definition: "Instância imutável e numerada de um conjunto de termos contratuais. Cada versão é snapshot permanente — alterações criam nova versão, nunca modificam a existente. Invariante: exatamente uma versão active por contrato+escopo."
		category:   "value"
		rationale:  "Versão como value object garante que consumers (CMT, SCF, DRC) sempre referenciam snapshot específico, nunca 'o contrato' genérico. Sem versionamento explícito, reconstrução temporal é impossível."
		antiTerms: [{
			term:          "Revisão"
			clarification: "Revisão implica modificação do mesmo documento. Em CTR, não há modificação — há criação de nova versão imutável. RegisterTermsRevision é o command, mas o resultado é nova versão, não revisão da existente."
		}]
		examples: [{
			context:  "Lineage de versões"
			instance: "v1 (active) → RegisterTermsRevision → v2 (draft) → ActivateContractTerms → v2 (active), v1 (superseded). Consumers que referenciavam v1 mantêm referência; novos consumers usam v2."
		}]
		relatedTerms: ["term-termos-contratuais", "term-lineage", "term-unicidade-versao-active"]
		domainModelRefs: ["vo-terms-version"]
		layerMapping: {
			codeTerm: "TermsVersion"
			apiTerm:  "version"
			uiLabel:  "Versão"
		}
	}, {
		code:       "term-lineage"
		name:       "Lineage"
		termEn:     "Lineage"
		definition: "Cadeia de referências entre versões sucessivas de termos contratuais. Cada nova versão aponta para a versão anterior via campo supersedes, formando cadeia linear (v1→v2→v3). Permite reconstrução temporal e auditoria da evolução contratual."
		category:   "value"
		rationale:  "Lineage como conceito explícito porque é o mecanismo que torna versionamento auditável. Sem lineage, versões seriam ilhas desconectadas — regulador não conseguiria reconstruir evolução contratual. Assumption as-ctr-1 assume lineage linear (sem branching)."
		antiTerms: [{
			term:          "Histórico"
			clarification: "Histórico é genérico — pode ser log de eventos, audit trail. Lineage é especificamente a cadeia de referências entre versões de termos."
		}]
		relatedTerms: ["term-versao-de-termos", "term-supersessao"]
		domainModelRefs: ["vo-lineage"]
	}, {
		code:       "term-escopo-contratual"
		name:       "Escopo Contratual"
		termEn:     "Contract Scope"
		definition: "Dimensão que, combinada com o identificador do contrato, delimita a unicidade de versão active. Define qual parte da relação contratual os termos governam (e.g., contrato de obra #123 + escopo 'fornecimento de concreto'). Invariante: uma versão active por contrato+escopo."
		category:   "value"
		rationale:  "Escopo como conceito explícito porque a invariante de unicidade depende dele. Sem escopo, um contrato poderia ter apenas um conjunto de termos — insuficiente para contratos de obra com múltiplos escopos de fornecimento."
		examples: [{
			context:  "Contrato de obra com múltiplos escopos"
			instance: "Contrato #123 com fornecedor X: escopo 'fornecimento de concreto' (termos v2 active) + escopo 'serviço de bombeamento' (termos v1 active). Cada escopo tem sua própria linha de versões."
		}]
		relatedTerms: ["term-termos-contratuais", "term-unicidade-versao-active"]
		domainModelRefs: ["vo-contract-scope"]
		layerMapping: {
			codeTerm: "ContractScope"
			apiTerm:  "scope"
			uiLabel:  "Escopo"
		}
	}, {
		code:       "term-estado-de-termos"
		name:       "Estado de Termos"
		termEn:     "Terms State"
		definition: "Estado canônico no lifecycle de uma versão de termos: draft (registrado, não vigente), active (vigente, referenciável por novos compromissos), superseded (substituído por nova versão), expired (prazo natural expirado), cancelled (invalidado por decisão supervisionada). Estados terminais (superseded, expired, cancelled) são consultáveis mas não referenciáveis por novos compromissos."
		category:   "value"
		rationale:  "Estado como value tipado garante que transições são explícitas e determinísticas. Sem lifecycle, CTR seria storage passivo e qualquer BC downstream poderia referenciar termos inválidos."
		relatedTerms: ["term-termos-contratuais", "term-vigencia", "term-supersessao"]
		domainModelRefs: ["vo-terms-state"]
		layerMapping: {
			codeTerm: "TermsState"
			apiTerm:  "state"
			uiLabel:  "Estado"
		}
	}, {
		code:       "term-clausula-contratual"
		name:       "Cláusula Contratual"
		termEn:     "Contract Clause"
		definition: "Sub-unidade dos termos contratuais que define uma condição específica: SLA de entrega, percentual de retenção, penalidade por atraso, garantia, condições de cancelamento. Consultável individualmente via QueryContractClauses — interface consumida por DRC para resolução de disputas."
		category:   "value"
		rationale:  "Cláusula como conceito separado de Termos porque DRC precisa referenciar cláusulas específicas em disputas, não o conjunto completo de termos. QueryContractClauses existe por essa necessidade."
		examples: [{
			context:  "Disputa sobre prazo de entrega"
			instance: "DRC consulta cláusula de SLA dos termos v2 do contrato #123: 'entrega em até 48h úteis após confirmação de pedido'. DRC avalia se entrega de 72h violou a cláusula."
		}]
		relatedTerms: ["term-termos-contratuais"]
		domainModelRefs: ["vo-contract-clause"]
		layerMapping: {
			codeTerm: "ContractClause"
			apiTerm:  "clauses"
			uiLabel:  "Cláusula"
		}
	}, {
		code:       "term-vigencia"
		name:       "Vigência"
		termEn:     "Validity Period"
		definition: "Intervalo temporal durante o qual termos contratuais estão operativos e podem ser referenciados por novos compromissos em CMT. Vigência tem data de início (ativação) e data de fim (expiração natural ou supersessão). Termos com vigência expirada transicionam automaticamente para estado expired."
		category:   "value"
		rationale:  "Vigência como conceito explícito porque é o campo que governa expiração automática (decisão autônoma detect-expired-terms no canvas). Sem vigência explícita, expiração seria impossível de automatizar."
		antiTerms: [{
			term:          "Validade"
			clarification: "Validade em contexto jurídico brasileiro implica que o ato é conforme requisitos legais. Vigência refere-se ao período de aplicabilidade temporal — conceito distinto."
		}]
		relatedTerms: ["term-estado-de-termos", "term-termos-contratuais"]
		domainModelRefs: ["vo-validity-period"]
		layerMapping: {
			codeTerm: "ValidityPeriod"
			apiTerm:  "validity_period"
			uiLabel:  "Vigência"
		}
	}, {
		code:       "term-supersessao"
		name:       "Supersessão"
		termEn:     "Supersession"
		definition: "Transição pela qual uma nova versão ativada substitui a versão anterior como active. Versão anterior transiciona para estado superseded. Compromissos existentes em CMT que referenciam versão supersedida mantêm referência (snapshot) — apenas novos compromissos devem usar versão active."
		category:   "process"
		rationale:  "Supersessão como processo nomeado porque é o mecanismo central de evolução contratual em CTR. Evento ContractTermsSuperseded sinaliza downstream. Diferente de 'atualização' (que implica mutação in-place)."
		antiTerms: [{
			term:          "Atualização"
			clarification: "Atualização implica modificar a versão existente. Em CTR, versões são imutáveis — supersessão cria nova versão que substitui a anterior como active."
		}]
		relatedTerms: ["term-versao-de-termos", "term-lineage", "term-estado-de-termos"]
		layerMapping: {
			codeTerm: "Supersession"
		}
	}, {
		code:       "term-unicidade-versao-active"
		name:       "Unicidade de Versão Active"
		termEn:     "Single Active Version"
		definition: "Invariante inviolável do CTR: para um mesmo contrato+escopo, exatamente uma versão de termos pode estar no estado active simultaneamente. Gate verificado em ActivateContractTerms — ativação de nova versão automaticamente supersede a anterior."
		category:   "rule"
		rationale:  "Invariante central que garante integridade de todo o sistema. Ambiguidade sobre qual versão é vigente criaria disputas irresolvíveis em DRC, precificação incorreta em SCF e referência ambígua em CMT. Decisão de negócio bd-single-active-version."
		relatedTerms: ["term-versao-de-termos", "term-escopo-contratual", "term-supersessao"]
		domainModelRefs: ["inv-single-active-version"]
	}, {
		code:       "term-imutabilidade"
		name:       "Imutabilidade Pós-Ativação"
		termEn:     "Post Activation Immutability"
		definition: "Invariante inviolável do CTR: termos contratuais são imutáveis após transição para estado active. Nenhum campo de uma versão ativada pode ser alterado — qualquer mudança requer RegisterTermsRevision que cria nova versão em draft. Imutabilidade é pré-requisito para reconstrução temporal e auditoria regulatória."
		category:   "rule"
		rationale:  "Invariante que distingue CTR de um sistema de gestão de contratos tradicional (onde documentos são editáveis). Decisão de negócio bd-terms-immutability. Sem imutabilidade, reconstituição regulatória ('quais termos estavam vigentes na data X') é impossível."
		relatedTerms: ["term-termos-contratuais", "term-versao-de-termos"]
		domainModelRefs: ["inv-post-activation-immutability"]
	}, {
		code:       "term-registrante"
		name:       "Registrante"
		termEn:     "Registrant"
		definition: "Parte que submete registro de termos contratuais em CTR com partes, cláusulas, condições e escopo. No vertical de construção civil, tipicamente a construtora (sh-01). Registrante é papel funcional em CTR — distinto de 'proponente' (papel em CMT)."
		category:   "role"
		rationale:  "Papel funcional no fluxo de registro de termos. Distinto de 'proponente' (CMT) porque em CTR quem registra termos não necessariamente é quem propõe compromissos. Construtora registra termos; fornecedor pode propor compromisso sob esses termos."
		antiTerms: [{
			term:          "Proponente"
			clarification: "Proponente é papel em CMT (quem propõe compromisso). Registrante é papel em CTR (quem registra termos). Podem ser partes diferentes: construtora registra termos, fornecedor propõe compromisso."
		}]
		relatedTerms: ["term-contraparte-ctr"]
		layerMapping: {
			codeTerm: "Registrant"
			apiTerm:  "registrant"
			uiLabel:  "Registrante"
		}
	}, {
		code:       "term-contraparte-ctr"
		name:       "Contraparte de Termos"
		termEn:     "Terms Counterparty"
		definition: "Parte que confirma termos contratuais registrados pela outra parte, completando o registro bilateral. No vertical de construção civil, tipicamente o fornecedor (sh-02). Contraparte confirma que aceita as condições antes da ativação."
		category:   "role"
		rationale:  "Papel funcional no aceite de termos. Distinto de 'contraparte' em CMT porque aqui refere-se à confirmação de termos (base jurídica), não à confirmação de compromisso (obrigação operacional). O fornecedor é contraparte de termos em CTR e pode ser proponente de compromisso em CMT."
		relatedTerms: ["term-registrante"]
		layerMapping: {
			codeTerm: "TermsCounterparty"
			apiTerm:  "counterparty"
			uiLabel:  "Contraparte"
		}
	}, {
		code:       "term-published-language"
		name:       "Published Language"
		termEn:     "Published Language"
		definition: "Modelo canônico de termos contratuais exposto por CTR via queries sync para consumers downstream. CMT consome para validar referência, SCF para avaliar elegibilidade, DRC para base jurídica de disputas. Cada consumer traduz via ACL para sua linguagem local."
		category:   "classification"
		rationale:  "Pattern DDD que define a natureza da interface de CTR. CTR não expõe APIs ad-hoc — expõe vocabulário formal (termos, cláusulas, versões, estados) que downstream adota como fonte de verdade. domainRoles.primary = specification no canvas."
		antiTerms: [{
			term:          "API"
			clarification: "API é mecanismo técnico de comunicação. Published Language é padrão de design que define o modelo conceitual compartilhado — implementado via API mas conceitualmente diferente."
		}]
		examples: [{
			context:  "Consumo por 3 BCs downstream"
			instance: "CMT consulta QueryContractTerms para validar referência antes de aceitar compromisso. SCF consulta para avaliar elegibilidade de antecipação. DRC consulta QueryContractClauses para base jurídica de disputa. Todos consomem o mesmo modelo via ACL local."
		}]
		relatedTerms: ["term-termos-contratuais"]
	}, {
		code:       "term-contract-terms-drafted"
		name:       "ContractTermsDrafted"
		termEn:     "Contract Terms Drafted"
		definition: "Evento interno publicado após RegisterContractTerms ou RegisterTermsRevision ser aceito. Indica que nova versão de termos foi registrada em estado draft. Não cruza fronteira do BC — consumers são exclusivamente internos ao CTR."
		category:   "event"
		rationale:  "Evento interno que distingue 'termos registrados' de 'termos ativados'. Trigger para workflows internos de validação e preparação de ativação."
		relatedTerms: ["term-termos-contratuais", "term-estado-de-termos"]
		domainModelRefs: ["evt-contract-terms-drafted"]
		layerMapping: {
			codeTerm: "ContractTermsDrafted"
		}
	}, {
		code:       "term-contract-terms-activated"
		name:       "ContractTermsActivated"
		termEn:     "Contract Terms Activated"
		definition: "Evento publicado quando termos transicionam de draft para active. Sinal cross-context para CMT (novos termos disponíveis para referência) e SCF (condições de elegibilidade atualizadas). Publicação é decisão autônoma do agente (publish-lifecycle-events)."
		category:   "event"
		rationale:  "Evento cross-context mais importante do CTR — sinaliza que nova base jurídica está disponível. Consumers: CMT e SCF."
		relatedTerms: ["term-termos-contratuais", "term-estado-de-termos"]
		domainModelRefs: ["evt-contract-terms-activated"]
		layerMapping: {
			codeTerm: "ContractTermsActivated"
		}
	}, {
		code:       "term-contract-terms-superseded"
		name:       "ContractTermsSuperseded"
		termEn:     "Contract Terms Superseded"
		definition: "Evento publicado quando versão de termos é substituída por nova versão ativada. Sinal para CMT, SCF e DRC que versão referenciada não é mais a active. Compromissos existentes mantêm referência à versão supersedida — novos compromissos devem usar versão active."
		category:   "event"
		rationale:  "Evento que completa o ciclo de supersessão. Consumers precisam saber que versão referenciada mudou de status para decidir ações (CMT: invalidar cache, SCF: reavaliar elegibilidade, DRC: contexto para disputas)."
		relatedTerms: ["term-supersessao", "term-estado-de-termos"]
		domainModelRefs: ["evt-contract-terms-superseded"]
		layerMapping: {
			codeTerm: "ContractTermsSuperseded"
		}
	}, {
		code:       "term-contract-terms-cancelled"
		name:       "ContractTermsCancelled"
		termEn:     "Contract Terms Cancelled"
		definition: "Evento publicado quando termos são cancelados por decisão supervisionada (fraude, erro, regulatória). Sinal de invalidação para CMT (bloqueia novos compromissos) e DRC (contexto para disputas). Cancelamento é irreversível — estado terminal."
		category:   "event"
		rationale:  "Evento de invalidação com maior blast radius. Decisão supervisionada (cancel-contract-terms) por irreversibilidade e impacto cross-context."
		relatedTerms: ["term-estado-de-termos", "term-termos-contratuais"]
		domainModelRefs: ["evt-contract-terms-cancelled"]
		layerMapping: {
			codeTerm: "ContractTermsCancelled"
		}
	}]

	rationale: """
		Glossário do CTR cobre os conceitos centrais do registry de termos
		contratuais: a entidade (Termos Contratuais), sua estrutura
		(Cláusula, Escopo), o modelo de versionamento (Versão, Lineage,
		Supersessão), o lifecycle (Estado, Vigência), as invariantes
		(Unicidade de Versão Active, Imutabilidade Pós-Ativação), os
		papéis (Registrante, Contraparte de Termos), o pattern de
		interface (Published Language) e os eventos de domínio
		(Drafted, Activated, Superseded, Cancelled). domainModelRefs
		prospectivos vinculam termos aos building blocks táticos
		previstos. Lenses aplicadas: domain-language (bilingual mapping
		pt-BR/en, term selection criteria, cross-layer consistency) e
		contractual-legal (precisão jurídica de termos que governam
		base contratual — especialmente Vigência e Imutabilidade).
		"""
}
