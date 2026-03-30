package cross_context_workflows

// commitment-lifecycle.cue — Commitment Lifecycle Flow.
// Instância de #CrossContextFlow (architecture/artifact-schemas/cross-context-flow.cue).
//
// Documenta a composição linear de bounded contexts que realiza
// o ciclo de vida do compromisso econômico — da formalização à
// liquidação financeira. Substitui ECL como subdomínio monolítico
// por composição explícita com ownership por fase.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

commitmentLifecycle: artifact_schemas.#CrossContextFlow & {
	code: "commitment-lifecycle"
	name: "Commitment Lifecycle"

	purpose: """
		Documentar como bounded contexts independentes se compõem para
		realizar o ciclo de vida do compromisso econômico — da
		formalização bilateral à liquidação financeira. Este flow é o
		coração operacional da Mesh: cada fase é owned por um BC
		específico, e a invariante central da tese (dinheiro só move
		quando operação comprova) emerge da composição dos gates locais.
		"""

	topology: "linear"

	scope: {
		startsWhen: """
			Uma organização propõe compromisso econômico a uma contraparte
			qualificada sob termos registrados.
			"""
		endsWhen: """
			O pagamento correspondente ao compromisso é liquidado
			fisicamente via rails bancários e o compromisso é encerrado.
			"""
		outOfScope: [
			"Qualificação de participantes — pré-condição do flow.",
			"Formalização de termos contratuais genéricos — pré-condição.",
			"Originação de produtos financeiros — downstream do flow.",
			"Disputas e reversões — fluxo de exceção.",
			"Computação de reputação — downstream do flow.",
			"Precificação de risco — transversal ao flow, não fase sequencial.",
		]
		rationale: """
			O escopo cobre o happy path do compromisso econômico: da proposta
			à liquidação. Fluxos de exceção, pré-condições e consequências
			downstream interagem com este flow por eventos, não por
			subordinação sequencial.
			"""
	}

	phases: [{
		name:           "Commitment Formalization"
		ownerContext:   "cmt"
		ownerSubdomain: "cmt"
		description: """
			Proposta, negociação e aceite bilateral do compromisso econômico.
			CommitmentId é gerado. Partes, termos, escopo e condições são
			formalizados. O gate de aceite mútuo garante que ambas as partes
			concordam antes de qualquer progressão.
			"""
		preconditions: [
			"Ambas as partes qualificadas.",
			"Termos contratuais registrados.",
		]
		localGates: [
			"Aceite bilateral verificado — ambas as partes confirmaram.",
			"CommitmentId gerado e registrado no Event Log.",
		]
		completionSignal: "CommitmentAccepted"
		integrationEvents: [
			"CommitmentAccepted",
		]
		consumedBy: [{
			context:  "bdg"
			phase:    "Budget Approval"
			consumes: "CommitmentAccepted"
		}]
		rationale: """
			Fase inicial do flow. Sem formalização válida, nenhuma fase
			downstream pode operar. O gate de aceite mútuo é a primeira
			barreira contra compromissos unilaterais ou fraudulentos.
			"""
	}, {
		name:           "Budget Approval"
		ownerContext:   "bdg"
		ownerSubdomain: "bdg"
		description: """
			Verificação de cobertura orçamentária e aprovação do
			comprometimento. Valida saldo disponível no centro de custo,
			alçada de aprovação e limites de comprometimento. O gate
			orçamentário impede que compromissos avancem sem funding.
			"""
		preconditions: [
			"CommitmentAccepted recebido de CMT.",
		]
		localGates: [
			"Saldo disponível no centro de custo suficiente.",
			"Alçada de aprovação respeitada.",
			"Limite de comprometimento não excedido.",
		]
		completionSignal: "BudgetApproved"
		integrationEvents: [
			"BudgetApproved",
			"BudgetCommitted",
		]
		consumedBy: [{
			context:  "dlv"
			phase:    "Delivery Verification"
			consumes: "BudgetApproved"
		}]
		rationale: """
			Gate financeiro que protege a rede contra comprometimento sem
			cobertura. Sem esta fase, compromissos poderiam progredir para
			execução sem garantia de capacidade de pagamento.
			"""
	}, {
		name:           "Delivery Verification"
		ownerContext:   "dlv"
		ownerSubdomain: "dlv"
		description: """
			Verificação de execução operacional e decisão sobre suficiência
			de evidência. Consome evidência física, avalia contra critérios
			do compromisso formalizado em CMT, e decide se a execução é
			suficiente para progressão. O gate de evidência é o diferencial
			central da tese.
			"""
		preconditions: [
			"BudgetApproved recebido de BDG.",
			"Evidência operacional disponível.",
		]
		localGates: [
			"Evidência operacional verificada e suficiente.",
			"Critérios de aceite técnico satisfeitos.",
			"Verificação registrada no Event Log com integridade criptográfica.",
		]
		completionSignal: "DeliveryVerified"
		integrationEvents: [
			"DeliveryVerified",
			"EvidenceRecorded",
		]
		consumedBy: [{
			context:  "inv"
			phase:    "Invoicing"
			consumes: "DeliveryVerified"
		}, {
			context:  "rew"
			consumes: "EvidenceRecorded"
		}, {
			context:  "nim"
			consumes: "EvidenceRecorded"
		}]
		rationale: """
			Fase mais crítica do flow. É onde a invariante 'dinheiro só move
			quando operação comprova' é materialmente enforçada. Sem
			evidência verificada, nenhuma fatura válida pode progredir.
			"""
	}, {
		name:           "Invoicing"
		ownerContext:   "inv"
		ownerSubdomain: "inv"
		description: """
			Emissão de NF-e e materialização do direito creditório. Vincula
			a fatura ao compromisso verificado, transformando execução
			verificada em recebível financeiro. Produz o lastro consumido
			por contextos financeiros downstream.
			"""
		preconditions: [
			"DeliveryVerified recebido de DLV.",
		]
		localGates: [
			"NF-e emitida e validada.",
			"Fatura vinculada ao CommitmentId e à evidência de verificação.",
		]
		completionSignal: "InvoiceIssued"
		integrationEvents: [
			"InvoiceIssued",
			"ReceivableMaterialized",
		]
		consumedBy: [{
			context:  "fce"
			phase:    "Financial Settlement"
			consumes: "InvoiceIssued"
		}, {
			context:  "scf"
			consumes: "ReceivableMaterialized"
		}, {
			context:  "ato"
			consumes: "InvoiceIssued"
		}]
		rationale: """
			Fase onde execução operacional se transforma em instrumento
			financeiro. O recebível materializado é o ativo que alimenta o
			ecossistema financeiro downstream.
			"""
	}, {
		name:           "Financial Settlement"
		ownerContext:   "fce"
		ownerSubdomain: "fce"
		description: """
			Execução financeira do compromisso — payment lifecycle,
			settlement e liberação condicional de retenções. Vincula cada
			pagamento ao compromisso e à evidência que o originou. Consome
			decisões de risco transversais e executa liquidação física.
			"""
		preconditions: [
			"InvoiceIssued recebido de INV.",
			"Decisão de risco/elegibilidade disponível.",
		]
		localGates: [
			"Pagamento vinculado a CommitmentId e InvoiceId.",
			"PrePaymentGuard satisfeito.",
			"Ledger atualizado atomicamente (double-entry).",
		]
		completionSignal: "PaymentSettled"
		integrationEvents: [
			"PaymentSettled",
			"CommitmentClosed",
		]
		rationale: """
			Fase terminal do flow. O pagamento é consequência verificável da
			cadeia completa: compromisso formalizado, orçamento aprovado,
			execução verificada e fatura emitida. O encerramento do
			compromisso é o sinal de ciclo completo.
			"""
	}]

	emergentInvariants: [{
		statement: "Nenhum fluxo financeiro existe sem evento operacional verificado."
		implementedBy: [{
			context:      "cmt"
			phase:        "Commitment Formalization"
			contribution: "Garante que todo compromisso tem aceite bilateral formalizado — sem compromisso válido, nenhuma execução é reconhecida."
		}, {
			context:      "dlv"
			phase:        "Delivery Verification"
			contribution: "Garante que execução operacional é verificada com evidência íntegra — sem verificação, nenhuma fatura válida é emitida."
		}, {
			context:      "fce"
			phase:        "Financial Settlement"
			contribution: "Garante que pagamento é vinculado a compromisso e evidência — sem lastro verificado, nenhum dinheiro se move."
		}]
		verificationStrategy: "Integration test end-to-end: submeter compromisso sem evidência verificada e confirmar que FCE rejeita pagamento. Submeter compromisso com evidência válida e confirmar progressão até liquidação."
		rationale: """
			Invariante central da tese Mesh. É implementada pela composição
			de múltiplos gates locais, cada um com owner claro e
			testabilidade isolada.
			"""
	}, {
		statement: "Todo compromisso tem cobertura orçamentária antes de execução."
		implementedBy: [{
			context:      "cmt"
			phase:        "Commitment Formalization"
			contribution: "Formaliza o valor e os termos do compromisso que servirão de base para a verificação de cobertura."
		}, {
			context:      "bdg"
			phase:        "Budget Approval"
			contribution: "Verifica saldo, alçada e limites antes de permitir progressão para execução."
		}, {
			context:      "fce"
			phase:        "Financial Settlement"
			contribution: "Garante que o pagamento executado respeita o compromisso aprovado e não excede o valor autorizado."
		}]
		verificationStrategy: "Integration test: submeter compromisso com valor acima do saldo disponível e confirmar rejeição em BDG. Submeter compromisso com cobertura válida e confirmar progressão."
		rationale: """
			Protege a rede contra compromissos sem funding. O fluxo só
			progride quando a cobertura foi validada explicitamente.
			"""
	}]

	crossCuttingConcepts: [{
		name:          "CommitmentId"
		originPhase:   "Commitment Formalization"
		originContext: "cmt"
		consumedBy: [{
			context: "bdg"
			phase:   "Budget Approval"
			usage:   "Vincula a aprovação orçamentária ao compromisso específico."
		}, {
			context: "dlv"
			phase:   "Delivery Verification"
			usage:   "Permite verificar evidência contra os critérios do compromisso."
		}, {
			context: "inv"
			phase:   "Invoicing"
			usage:   "Vincula a fatura ao compromisso e à verificação correspondente."
		}, {
			context: "fce"
			phase:   "Financial Settlement"
			usage:   "Vincula o pagamento ao compromisso, à evidência e à fatura correspondente."
		}]
		rationale: """
			CommitmentId é o fio de rastreabilidade end-to-end do flow.
			Nasce em CMT e é consumido por todos os contexts downstream.
			"""
	}]

	costRefs: [
		"ce-04",
	]

	capabilityRefs: [
		"cc-01",
	]

	failureModes: [{
		name:        "Fase travada sem progressão"
		description: "Compromisso fica preso em uma fase sem avançar nem ser rejeitado — por exemplo, evidência submetida mas DLV não decide."
		detectedBy: [
			"SLA de progressão por fase excedido.",
			"Alertas observáveis sobre compromissos em fase por mais de X dias.",
		]
		mitigatedBy: [
			"Timeout configurável por fase com escalação automática.",
			"Fluxo de exceção assume compromissos travados como caso tratável.",
		]
		rationale: """
			Fase travada é um dos modos de falha mais comuns em fluxos
			multi-context. Sem timeout explícito, compromissos podem ficar
			em limbo indefinidamente.
			"""
	}, {
		name:        "Rejeição em fase intermediária"
		description: "Uma fase intermediária rejeita o compromisso — por exemplo, falta de orçamento ou evidência insuficiente — exigindo cancelamento, retorno ou renegociação."
		detectedBy: [
			"Evento de rejeição emitido pela fase correspondente.",
		]
		mitigatedBy: [
			"CMT é notificado para renegociação ou cancelamento.",
			"Recursos comprometidos são liberados ou revertidos.",
			"Fluxo de exceção pode ser acionado se houver disputa sobre a rejeição.",
		]
		rationale: """
			Rejeição é parte normal do fluxo. O artifact precisa documentar
			o que acontece quando um gate local falha, não apenas quando
			todos passam.
			"""
	}, {
		name:        "Inconsistência entre fases por falha de comunicação"
		description: "Evento de integração perdido ou duplicado — por exemplo, DLV verifica com sucesso mas INV não consome o sinal correspondente."
		detectedBy: [
			"Reconciliação periódica entre estados de fases adjacentes.",
			"Fila de dead letters não vazia para consumers de integration events.",
		]
		mitigatedBy: [
			"Transactional outbox garante publicação atômica.",
			"Idempotência de consumers garante processamento correto de duplicatas.",
			"Reconciliação automatizada detecta divergências entre estados locais.",
		]
		rationale: """
			Em fluxo distribuído, falhas de comunicação são inevitáveis.
			O flow deve ser resiliente a eventos perdidos ou duplicados por
			design, não por esperança.
			"""
	}]

	knownLimitations: [
		"v1 modela fluxo linear — aceite parcial, medição por milestone e entregas programadas com progressão paralela ficam fora do escopo.",
		"Referências entre fases são por nome (string), sem validação CUE nativa — enforcement de conectividade depende de CI runner.",
	]

	assumptions: [
		"Os BCs do Wave 0 correspondentes a CMT, BDG, DLV, INV e FCE existem ou existirão conforme o catálogo estratégico e o boundary design definidos.",
		"Qualificação de participantes e gestão contratual são pré-condições satisfeitas antes do flow iniciar.",
		"Funções transversais de risco e reputação consomem sinais do flow sem se tornarem fases sequenciais dele.",
	]

	rationale: """
		Este flow substitui ECL como subdomínio monolítico por composição
		explícita de BCs com ownership por fase. A invariante central da
		tese ('dinheiro só move quando operação comprova') emerge da
		composição de gates locais, cada um com owner claro e testável
		isoladamente. O flow permanece agnóstico a runtime — a escolha
		entre choreography, orchestration ou saga pertence à arquitetura
		de execução, não à spec estratégica. CommitmentId como conceito
		cross-cutting garante rastreabilidade end-to-end.
		"""
}
