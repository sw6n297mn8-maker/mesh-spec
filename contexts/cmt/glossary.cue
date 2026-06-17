package cmt

// glossary.cue — Ubiquitous Language: Commitment Management.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Termos canônicos do BC CMT. Define o vocabulário que agentes,
// código, contratos e interfaces usam ao operar neste contexto.
//
// Lenses aplicadas:
// - lens-domain-language-and-terminology-design (primária):
//   bilingual mapping, term selection, cross-layer consistency
// - lens-contractual-and-legal-architecture (secundária):
//   precisão jurídica de termos que criam obrigações
//
// 3 rounds de red team interno + 4 correções do founder + 2 rounds
// de red team isolado (5+4 correções aceitas, 1+7 rejeitadas), stable.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

glossary: artifact_schemas.#Glossary & {
	code: "cmt"
	name: "Glossário CMT — Commitment Management"

	boundedContextRef: "cmt"

	terms: [{
		code:       "term-compromisso"
		name:       "Compromisso"
		termEn:     "Commitment"
		definition: "Acordo econômico formalizado entre duas organizações com aceite mútuo bilateral, representando obrigação de execução e pagamento rastreável end-to-end via CommitmentId."
		category:   "entity"
		rationale:  "Conceito central do BC. Compromisso é mais preciso que 'pedido' (unilateral) ou 'contrato' (instrumento jurídico que vive em CTR). Compromisso é a entidade que nasce do aceite bilateral e permeia todo o commitment lifecycle."
		synonyms: ["Acordo Bilateral"]
		antiTerms: [{
			term:          "Contrato"
			clarification: "Contrato é instrumento jurídico que vive em CTR. Compromisso é a entidade operacional que referencia termos contratuais mas não é o contrato em si. Um contrato pode gerar múltiplos compromissos."
		}, {
			term:          "Pedido"
			clarification: "Pedido é unilateral. Compromisso exige aceite bilateral — invariante central do CMT."
		}, {
			term:          "Recebível"
			clarification: "Recebível é ativo financeiro materializado downstream (INV → SCF) a partir de fatura vinculada a entrega verificada. Compromisso é a obrigação bilateral que origina o lifecycle — anterior e distinto do recebível."
		}, {
			term:          "Duplicata"
			clarification: "Duplicata é título de crédito (instrumento jurídico) emitido contra fatura, vivendo em INV/SCF. Na construção civil brasileira, 'temos um compromisso' é frequentemente usado como sinônimo de 'temos uma duplicata a receber' — são conceitos em stages diferentes do lifecycle."
		}, {
			term:          "Medição"
			clarification: "Medição (boletim de medição de obra) é verificação de entrega que vive em DLV. 'Medição aprovada' não é compromisso aceito — é entrega verificada contra compromisso previamente formalizado."
		}]
		rejectedAlternatives: [{
			term:   "Acordo"
			reason: "Genérico demais — não captura a formalização bilateral nem a rastreabilidade end-to-end."
		}, {
			term:   "Obrigação"
			reason: "Implica unilateralidade jurídica. Compromisso na Mesh é bilateral por design."
		}]
		examples: [{
			context:   "Construtora e fornecedor de concreto"
			instance:  "Compromisso de fornecimento de 500m³ de concreto para obra X, aceito bilateralmente, gerando CommitmentId cmt-2026-0042."
			rationale: "Exemplo concreto do vertical de construção civil — caso de uso primário da Mesh."
		}]
		relatedTerms: ["term-commitment-id", "term-aceite-mutuo-bilateral", "term-estado-compromisso"]
		domainModelRefs: ["agg-commitment"]
		layerMapping: {
			codeTerm: "Commitment"
			apiTerm:  "commitments"
			uiLabel:  "Compromisso"
		}
	}, {
		code:       "term-commitment-id"
		name:       "CommitmentId"
		termEn:     "Commitment ID"
		definition: "Identificador canônico gerado exclusivamente em CMT no momento da proposta, antes do aceite bilateral. Permeia todos os contexts downstream (BDG, DLV, INV, FCE) como fio de rastreabilidade end-to-end do commitment lifecycle."
		category:   "value"
		rationale:  "CommitmentId merece termo canônico separado porque é o conceito cross-cutting mais referenciado do sistema — 5 BCs downstream carregam este identificador. Sem termo explícito, agentes tratam como campo técnico genérico (e.g., 'id', 'reference') perdendo a semântica de ponto único de origem em CMT."
		antiTerms: [{
			term:          "Número do Pedido"
			clarification: "Pedidos são unilaterais e podem existir sem aceite bilateral. CommitmentId nasce na proposta em CMT — anterior ao aceite, mas dentro do fluxo formal de formalização."
		}]
		examples: [{
			context:  "Rastreabilidade cross-context"
			instance: "CommitmentId cmt-2026-0042 aparece em BDG (aprovação orçamentária), DLV (verificação de entrega), INV (faturamento) e FCE (liquidação)."
		}]
		relatedTerms: ["term-compromisso"]
		domainModelRefs: ["vo-commitment-id"]
		layerMapping: {
			codeTerm: "CommitmentId"
			apiTerm:  "commitment_id"
			uiLabel:  "ID do Compromisso"
		}
	}, {
		code:       "term-aceite-mutuo-bilateral"
		name:       "Aceite Mútuo Bilateral"
		termEn:     "Mutual Bilateral Acceptance"
		definition: "Invariante inviolável do CMT: nenhum compromisso progride no lifecycle sem confirmação explícita de ambas as partes (proponente e contraparte). Gate determinístico que autoriza publicação de CommitmentAccepted."
		category:   "rule"
		rationale:  "Classificado como rule (invariant) porque é barreira determinística — não é processo negociável nem estado transitório. dp-08 exige que custos de manipulação excedam benefícios por design; aceite bilateral é a implementação desta exigência em CMT. dp-10 exige responsabilidade jurídica identificável; aceite bilateral garante que ambas as partes são juridicamente identificáveis na formalização."
		rejectedAlternatives: [{
			term:   "Aprovação"
			reason: "Aprovação implica decisão de mérito por autoridade. Aceite bilateral é confirmação mútua — ambas as partes confirmam os mesmos termos."
		}, {
			term:   "Confirmação"
			reason: "Genérico — não captura bilateralidade. Uma confirmação pode ser unilateral."
		}]
		examples: [{
			context:  "Fluxo de formalização"
			instance: "Fornecedor propõe compromisso. Construtora confirma aceite com mesmos termos. Somente após ambos confirmarem, CommitmentAccepted é publicado."
		}]
		relatedTerms: ["term-compromisso", "term-contraparte", "term-proponente", "term-confirmar-aceite"]
		domainModelRefs: ["inv-mutual-bilateral-acceptance"]
	}, {
		code:       "term-proponente"
		name:       "Proponente"
		termEn:     "Proposer"
		definition: "Parte que submete proposta de compromisso com termos, partes e escopo. No vertical de construção civil, tipicamente o fornecedor."
		category:   "role"
		rationale:  "Papel funcional no fluxo de formalização — distinto de 'fornecedor' (papel na rede) e 'cedente' (papel jurídico na cessão). Proponente é quem inicia o commitment lifecycle."
		examples: [{
			context:  "Vertical construção civil"
			instance: "Fornecedor de concreto propõe compromisso de 500m³ para obra X. Neste contexto, fornecedor é o proponente."
		}, {
			context:  "Multi-vertical futuro"
			instance: "Em logística, o transportador poderia ser proponente de compromisso de entrega. O papel de proponente é genérico — não depende do vertical."
			rationale: "Exemplo que demonstra que proponente é papel funcional, não sinônimo de fornecedor."
		}]
		relatedTerms: ["term-contraparte", "term-compromisso", "term-propor-compromisso"]
		layerMapping: {
			codeTerm: "Proposer"
			apiTerm:  "proposer"
			uiLabel:  "Proponente"
		}
	}, {
		code:       "term-contraparte"
		name:       "Contraparte"
		termEn:     "Counterparty"
		definition: "Parte que confirma aceite do compromisso proposto, completando o gate de aceite mútuo bilateral. No vertical de construção civil, tipicamente a construtora."
		category:   "role"
		rationale:  "Papel funcional no fluxo de aceite — distinto de 'construtora' (papel na rede) e 'sacado' (papel jurídico). Contraparte é genérico para permitir multi-vertical sem alterar a UL do CMT."
		antiTerms: [{
			term:          "Aprovador"
			clarification: "Aprovador implica hierarquia e poder de decisão unilateral. Contraparte confirma aceite bilateral — ambas as partes têm peso igual."
		}]
		examples: [{
			context:  "Vertical construção civil"
			instance: "Construtora confirma aceite do compromisso proposto pelo fornecedor. Neste contexto, construtora é a contraparte."
		}, {
			context:  "Simetria de papéis"
			instance: "Proponente e contraparte são papéis simétricos no aceite — a diferença é apenas quem inicia. Se construtora propusesse o compromisso, o fornecedor seria a contraparte."
			rationale: "Demonstra que contraparte não é sinônimo fixo de construtora."
		}]
		relatedTerms: ["term-proponente", "term-aceite-mutuo-bilateral"]
		layerMapping: {
			codeTerm: "Counterparty"
			apiTerm:  "counterparty"
			uiLabel:  "Contraparte"
		}
	}, {
		code:       "term-estado-compromisso"
		name:       "Estado do Compromisso"
		termEn:     "Commitment State"
		definition: "Estado canônico do compromisso no seu ciclo de vida: proposto, aceito, em risco, suspenso, cancelado. CMT é SoT deste estado — BCs downstream consomem via QueryCommitmentState ou eventos de transição."
		category:   "value"
		rationale:  "Estado como valor tipado garante que transições são explícitas e auditáveis. Sem SoT de estado, BCs downstream operam sobre estado inconsistente."
		examples: [{
			context:  "Transições"
			instance: "Proposto → Aceito (via aceite bilateral). Aceito → Em Risco (sinal autônomo de REW). Em Risco → Suspenso (escalação supervisionada) ou Aceito (risco resolvido). Suspenso → Aceito (reativação) ou Cancelado (decisão definitiva)."
		}]
		relatedTerms: ["term-compromisso", "term-suspensao-compromisso"]
		domainModelRefs: ["vo-commitment-state"]
		layerMapping: {
			codeTerm: "CommitmentState"
			apiTerm:  "commitment_state"
			uiLabel:  "Estado"
		}
	}, {
		code:       "term-propor-compromisso"
		name:       "Propor Compromisso"
		termEn:     "Propose Commitment"
		definition: "Ação canônica que inicia a formalização de um compromisso. Proponente submete proposta contendo termos, partes, escopo e referências a termos contratuais de CTR. Gera evento interno CommitmentProposed que inicia workflows de negociação e preparação de aceite."
		category:   "command"
		rationale:  "Command canônico do CMT. CommitmentProposed é evento interno do BC — não cruza fronteira. Proposta pode ser rejeitada ou abandonada; compromisso formalizado só existe após aceite bilateral."
		relatedTerms: ["term-compromisso", "term-proponente", "term-commitment-proposed", "term-termos-contratuais"]
		domainModelRefs: ["cmd-propose-commitment"]
		layerMapping: {
			codeTerm: "ProposeCommitment"
			apiTerm:  "commitments"
			uiLabel:  "Nova Proposta"
		}
	}, {
		code:       "term-confirmar-aceite"
		name:       "Confirmar Aceite de Compromisso"
		termEn:     "Confirm Commitment Acceptance"
		definition: "Command canônico que completa o gate de aceite mútuo bilateral. Contraparte confirma os mesmos termos propostos pelo proponente. Sync porque a contraparte precisa de confirmação imediata. Resultado: publicação de CommitmentAccepted se invariante bilateral satisfeita."
		category:   "command"
		rationale:  "Par direto de ProposeCommitment — sem este command, o aceite bilateral não se completa. Sync por exigência de confirmação imediata à contraparte, diferente de ProposeCommitment que é async."
		relatedTerms: ["term-aceite-mutuo-bilateral", "term-contraparte", "term-commitment-accepted"]
		domainModelRefs: ["cmd-confirm-commitment-acceptance"]
		layerMapping: {
			codeTerm: "ConfirmCommitmentAcceptance"
			apiTerm:  "commitments/{id}/acceptance"
			uiLabel:  "Confirmar Aceite"
		}
	}, {
		code:       "term-commitment-proposed"
		name:       "CommitmentProposed"
		termEn:     "Commitment Proposed"
		definition: "Evento interno do BC publicado após ProposeCommitment ser aceito pelo agente. Trigger para workflows internos de negociação e preparação de aceite. Não cruza fronteira — consumers são exclusivamente internos ao CMT."
		category:   "event"
		rationale:  "Distingue 'proposta submetida' de 'proposta aceita bilateralmente' (CommitmentAccepted). Evento interno por design — canvas explicita que não cruza fronteira. Essencial para agentes que geram código do fluxo interno de formalização."
		relatedTerms: ["term-propor-compromisso", "term-compromisso"]
		domainModelRefs: ["evt-commitment-proposed"]
		layerMapping: {
			codeTerm: "CommitmentProposed"
		}
	}, {
		code:       "term-suspensao-compromisso"
		name:       "Suspensão de Compromisso"
		termEn:     "Commitment Suspension"
		definition: "Interrupção temporária de um compromisso ativo, classificada como supervisedDecision no governance scope do CMT. Disparada por sinal externo — alerta de risco de contraparte (CounterpartyRiskAlertRaised de REW) ou determinação de disputa (CommitmentSuspensionOrdered de DRC). Agente sinaliza e recomenda; gate de supervisão humana (mech-agent-gate) autoriza a suspensão efetiva. Compromisso suspenso não progride no lifecycle até reativação ou cancelamento."
		category:   "process"
		rationale:  "Suspensão é processo supervisionado (não autônomo) porque afeta todo o commitment lifecycle downstream — BDG, DLV, INV e FCE operam sobre estado do compromisso. mech-agent-gate garante que agente nunca suspende unilateralmente: recomenda com base em severidade, humano autoriza. Classificação como process (não estado) porque envolve avaliação de severidade, recomendação do agente e decisão supervisionada."
		relatedTerms: ["term-estado-compromisso", "term-compromisso"]
		layerMapping: {
			codeTerm: "CommitmentSuspension"
			apiTerm:  "suspensions"
			uiLabel:  "Suspensão"
		}
	}, {
		code:       "term-commitment-accepted"
		name:       "CommitmentAccepted"
		termEn:     "Commitment Accepted"
		definition: "Evento de domínio publicado quando o gate de aceite mútuo bilateral é aprovado com sucesso. Sinal canônico de entrada no commitment lifecycle — BDG inicia aprovação orçamentária, DRC registra contexto para disputas futuras."
		category:   "event"
		rationale:  "Evento cross-context mais importante do CMT. Nome no formato PascalCase passado (Entity+Action) seguindo convenção do domain model. Publicado para BDG e DRC."
		relatedTerms: ["term-aceite-mutuo-bilateral", "term-compromisso"]
		domainModelRefs: ["evt-commitment-accepted"]
		layerMapping: {
			codeTerm: "CommitmentAccepted"
		}
	}, {
		code:       "term-commitment-state-changed"
		name:       "CommitmentStateChanged"
		termEn:     "Commitment State Changed"
		definition: "Evento de domínio publicado quando o estado do compromisso transiciona por sinal externo (risco, disputa) ou ação interna (suspensão, cancelamento, reativação). Consumido por DRC para atualizar contexto de disputas."
		category:   "event"
		rationale:  "Evento genérico de transição — cobre todas as mudanças de estado exceto o aceite inicial (coberto por CommitmentAccepted). Escolha deliberada: evento único vs eventos por transição. Evento único simplifica consumers e permite extensão de estados sem novos event types."
		relatedTerms: ["term-estado-compromisso", "term-compromisso"]
		domainModelRefs: ["evt-commitment-state-changed"]
		layerMapping: {
			codeTerm: "CommitmentStateChanged"
		}
	}, {
		code:       "term-termos-contratuais"
		name:       "Termos Contratuais"
		termEn:     "Contract Terms"
		definition: "Referência aos termos de contrato vigentes em CTR que um compromisso deve satisfazer como pré-condição de formalização. CMT valida existência e vigência via QueryContractTerms antes de aceitar proposta."
		category:   "value"
		rationale:  "Termos são value object consultado de CTR — CMT não os armazena nem modifica. Dependência sync de CTR é ponto de falha documentado em business decisions e assumptions do canvas."
		antiTerms: [{
			term:          "Contrato"
			clarification: "Contrato é o instrumento jurídico completo em CTR. Termos contratuais são as cláusulas específicas que um compromisso referencia."
		}]
		relatedTerms: ["term-compromisso"]
	}, {
		code:       "term-cancelar-compromisso"
		name:       "Cancelar Compromisso"
		termEn:     "Cancel Commitment"
		definition: "Ação canônica que cancela definitivamente um compromisso. Decisão terminal — um compromisso cancelado não pode ser reativado."
		category:   "command"
		rationale:  "Command terminal do lifecycle do compromisso; distingue-se da suspensão (reversível) por ser irreversível."
		domainModelRefs: ["cmd-cancel-commitment"]
		relatedTerms: ["term-compromisso", "term-suspender-compromisso"]
	}, {
		code:       "term-suspender-compromisso"
		name:       "Suspender Compromisso"
		termEn:     "Suspend Commitment"
		definition: "Ação canônica que suspende um compromisso ativo, disparada por sinalização de risco ou determinação de disputa. Pausa o compromisso preservando-o para reativação."
		category:   "command"
		rationale:  "Command de transição reversível (oposto de cancelar). Forma-verbo do ato, distinta do substantivo-estado Commitment Suspension (term-suspensao-compromisso) — norm() exato não colide."
		domainModelRefs: ["cmd-suspend-commitment"]
		relatedTerms: ["term-compromisso", "term-reativar-compromisso"]
	}, {
		code:       "term-reativar-compromisso"
		name:       "Reativar Compromisso"
		termEn:     "Reactivate Commitment"
		definition: "Ação canônica que reativa um compromisso suspenso após resolução favorável de disputa ou redução de risco. Retorna o compromisso ao estado ativo."
		category:   "command"
		rationale:  "Command de retorno ao estado ativo (oposto de suspender); só aplicável a compromissos suspensos."
		domainModelRefs: ["cmd-reactivate-commitment"]
		relatedTerms: ["term-compromisso", "term-suspender-compromisso"]
	}, {
		code:       "term-sinalizar-risco"
		name:       "Sinalizar Risco"
		termEn:     "Flag At Risk"
		definition: "Ação canônica que sinaliza um compromisso ativo como em-risco quando a contraparte recebe alerta de risco do REW."
		category:   "command"
		rationale:  "Command de gestão de risco de contraparte; marca o compromisso sem suspendê-lo (a suspensão é decisão separada)."
		domainModelRefs: ["cmd-flag-at-risk"]
		relatedTerms: ["term-compromisso", "term-limpar-flag-risco"]
	}, {
		code:       "term-limpar-flag-risco"
		name:       "Limpar Sinalização de Risco"
		termEn:     "Clear Risk Flag"
		definition: "Ação canônica que remove a sinalização de risco de um compromisso at-risk, retornando-o ao estado aceito."
		category:   "command"
		rationale:  "Command oposto de Flag At Risk; aplica-se a compromissos previamente sinalizados como em-risco."
		domainModelRefs: ["cmd-clear-risk-flag"]
		relatedTerms: ["term-compromisso", "term-sinalizar-risco"]
	}, {
		code:       "term-tratar-resolucao-disputa"
		name:       "Tratar Resolução de Disputa"
		termEn:     "Handle Dispute Resolution"
		definition: "Ação canônica que processa a resolução de uma disputa do DRC (cancel | modify_terms | maintain) sobre um compromisso, aplicando o efeito determinado no lifecycle do compromisso."
		category:   "command"
		rationale:  "Command que materializa no compromisso a decisão de disputa do DRC; CMT executa o efeito (cancelar/modificar/manter), não decide a disputa."
		domainModelRefs: ["cmd-handle-dispute-resolution"]
		relatedTerms: ["term-compromisso"]
	}]

	rationale: "Glossário do CMT cobre os conceitos centrais do commitment lifecycle: a entidade (Compromisso), sua identidade (CommitmentId), a invariante de aceite bilateral, os papéis funcionais (Proponente, Contraparte), os commands do fluxo bilateral (ProposeCommitment, ConfirmCommitmentAcceptance), os estados e transições, os eventos internos (CommitmentProposed) e cross-context (CommitmentAccepted, CommitmentStateChanged), e a dependência de termos contratuais de CTR. domainModelRefs prospectivos vinculam termos aos building blocks táticos previstos (WI-025). Lenses aplicadas: domain-language (bilingual mapping pt-BR/en, term selection criteria, cross-layer consistency) e contractual-legal (precisão jurídica de termos que criam obrigações — especialmente Aceite e Compromisso)."
}
