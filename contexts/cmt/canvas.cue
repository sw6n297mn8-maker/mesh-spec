package cmt

// canvas.cue — Bounded Context Canvas: Commitment Management.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// CMT é o ponto de entrada do commitment lifecycle.
// CommitmentId nasce aqui e permeia todos os contexts downstream.
//
// 3 rounds de red team + 4 ajustes do founder.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

canvas: artifact_schemas.#Canvas & {
	code: "cmt"
	name: "Commitment Management"

	purpose: """
		Formalizar compromissos econômicos entre organizações com aceite
		mútuo bilateral, gerenciar o estado canônico do compromisso como
		entidade rastreável, e garantir que CommitmentId — o fio de
		rastreabilidade end-to-end do commitment lifecycle — nasça com
		integridade. Sem CMT como unidade separada, a criação e o aceite
		de compromissos ficam distribuídos entre contratos (CTR) e
		execução financeira (FCE), sem owner canônico do estado do
		compromisso. CMT é o ponto de entrada do commitment lifecycle:
		compromisso mal formalizado degrada verificação, faturamento e
		liquidação downstream.
		"""

	ubiquitousLanguageRef: "contexts/cmt/glossary.cue"

	// ==============================
	// CLASSIFICAÇÃO ESTRATÉGICA
	// ==============================

	classification: {
		subdomainType:    "core"
		businessRole:     "revenue-generator"
		wardleyEvolution: "custom"
		rationale: """
			Core porque a formalização de compromissos econômicos com aceite
			mútuo e rastreabilidade é proprietária da Mesh — não existe
			padrão de mercado. Revenue-generator porque todo fluxo financeiro
			da plataforma (antecipação, pagamento, liquidação) nasce de um
			compromisso formalizado em CMT. Custom porque a solução é
			proprietária mas o problema (formalização de acordos) é
			compreendido — não é genesis.
			"""
	}

	// ==============================
	// DOMAIN ROLES
	// ==============================

	domainRoles: {
		primary: "execution"
		secondary: ["draft"]
		rationale: """
			Execution como primário: CMT opera o ciclo de vida do
			compromisso com gates determinísticos — proposta, negociação,
			confirmação bilateral. O gate de aceite mútuo é o ponto
			crítico. Draft como secundário: a fase de proposta e
			negociação envolve composição e formalização de termos antes
			do gate de confirmação.
			"""
	}

	// ==============================
	// CAPABILITIES
	// ==============================

	capabilities: {
		operational: [{
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua de compromissos: cada formalização,
				aceite e mudança de estado é registrada como fato imutável
				no Event Log, habilitando auditoria em tempo real.
				"""
			rationale: "Compromissos são a base do commitment lifecycle. Se não são auditáveis desde a formalização, a cadeia inteira perde rastreabilidade."
		}, {
			description: """
				Formalização automatizada de compromissos: agentes
				processam documentos de proposta, validam termos contra
				CTR, e preparam aceite bilateral. Gates determinísticos
				verificam invariantes de aceite mútuo antes de autorizar
				progressão.
				"""
			rationale: "Automatização via agentes com gates reduz custo de compliance documental (ce-02) e elimina latência humana no fluxo de formalização."
		}, {
			description: """
				Gestão de estado do compromisso: mantém o estado canônico
				(proposto, aceito, suspenso, cancelado) como SoT, publica
				transições como eventos, e reage a sinais externos (risco,
				disputas) que afetam compromissos ativos.
				"""
			rationale: "Sem SoT de estado, BCs downstream (BDG, DLV, DRC) operam sobre estado inconsistente ou desatualizado do compromisso."
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}
}
