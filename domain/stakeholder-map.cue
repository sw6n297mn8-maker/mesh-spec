package domain

stakeholderMap: {
	description: "Atores do ecossistema Mesh: participantes da cadeia produtiva da construção civil e entidades regulatórias que interagem com a infraestrutura financeira."

	stakeholders: [{
		id:              "sh-01"
		name:            "Construtora"
		type:            "organization"
		description:     "Empresa responsável pela execução da obra. Contrata fornecedores, gerencia cronograma e é tomadora de crédito."
		role:            "Tomadora de crédito e originadora de evidências de medição"
		meshInteraction: "Submete evidências de medição, solicita antecipações, consome projeções financeiras da obra."
		influence:       "high"
		concerns: [
			"Acesso a crédito com custo menor que mercado",
			"Visibilidade do fluxo de caixa da obra",
			"Simplicidade operacional na submissão de evidências",
		]
		interactsWith: ["sh-02", "sh-03", "sh-05"]
		rationale:       "É o nó central da cadeia produtiva — sem construtora não há obra, e sem obra não há fluxo financeiro a intermediar."
	}, {
		id:              "sh-02"
		name:            "Fornecedor"
		type:            "organization"
		description:     "Empresa que fornece materiais ou serviços à construtora. Possui recebíveis vinculados a medições de obra."
		role:            "Cedente de recebíveis lastreados em evidência de entrega"
		meshInteraction: "Seus recebíveis são antecipados com base em evidência de entrega verificada. Recebe pagamento antecipado via operação da Mesh."
		influence:       "medium"
		concerns: [
			"Redução do ciclo de recebimento (hoje 60-120 dias)",
			"Transparência sobre status de pagamento",
			"Custo da antecipação versus alternativas de mercado",
		]
		interactsWith: ["sh-01", "sh-05"]
		rationale:       "É quem mais sofre com a assimetria informacional — entrega material mas depende de ciclos longos de pagamento sem visibilidade."
	}, {
		id:              "sh-03"
		name:            "Instituição financeira parceira"
		type:            "organization"
		description:     "Banco ou fundo que fornece funding para operações de crédito intermediadas pela Mesh."
		role:            "Funding provider para operações de crédito"
		meshInteraction: "Consome dados de risco e evidência da Mesh para decisão de crédito. Não opera diretamente na plataforma."
		influence:       "high"
		concerns: [
			"Qualidade e verificabilidade do lastro dos recebíveis",
			"Conformidade regulatória da SCD",
			"Retorno ajustado ao risco das operações",
		]
		interactsWith: ["sh-04", "sh-05"]
		rationale:       "A Mesh como SCD origina e gerencia crédito, mas pode usar funding externo — o parceiro financeiro viabiliza escala sem capital próprio proporcional."
	}, {
		id:              "sh-04"
		name:            "Bacen"
		type:            "regulator"
		description:     "Banco Central do Brasil. Regula SCDs, define requisitos prudenciais, de capital e de reporting."
		role:            "Regulador primário da operação financeira"
		meshInteraction: "Define o envelope operacional da Mesh como SCD. Recebe reporting regulatório. Compliance é constraint inviolável (nível 1 de conflictResolution)."
		influence:       "high"
		concerns: [
			"Conformidade prudencial e de capital",
			"Proteção do sistema financeiro nacional",
			"Transparência e rastreabilidade das operações",
		]
		rationale: "Operar como SCD sem conformidade com o Bacen é ilegal. Toda decisão de design deve ser compatível com o framework regulatório vigente."
	}, {
		id:              "sh-05"
		name:            "Agente de IA Mesh"
		type:            "agent"
		description:     "Agente autônomo que executa operações dentro dos limites definidos por autonomy envelopes e gates determinísticos."
		role:            "Operador primário do sistema"
		meshInteraction: "Recomenda decisões, executa operações aprovadas por gates, escala decisões que excedem seu envelope ao humano designado."
		influence:       "medium"
		concerns: [
			"Clareza dos limites de autonomia por domínio",
			"Disponibilidade e qualidade dos dados de entrada",
			"Rastreabilidade de cada decisão para auditoria",
		]
		interactsWith: ["sh-01", "sh-02", "sh-03"]
		rationale:       "Sem o agente como stakeholder explícito, decisões de design tratam IA como ferramenta em vez de ator — e o sistema perde coerência com sua tese central (ax-01, ax-02)."
	}]
}
