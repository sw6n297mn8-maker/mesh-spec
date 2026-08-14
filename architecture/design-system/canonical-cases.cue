package design_system

// canonical-cases.cue — VIII. Casos Canônicos (jurisprudência) da
// Constituição do Design System (adr-194). Conteúdo VERBATIM da
// promulgação v1.0. Compõe a MESMA instância designSystemConstitution
// de constitution.cue (merge de structs CUE).
//
// Disciplina de jurisprudência (adr-194): casos novos são CANDIDATOS —
// nunca entram sem decisão do founder.

designSystemConstitution: canonicalCases: [{
	id:   "case-recibo"
	name: "Recibo"
	content: """
		"Pedido emitido." (600, primeira linha) + tabela campo-a-campo:
		pedido P-1204 · fornecedor · valor R$ 45.000,00 · alçada J. Costa ·
		procedência C-88 · registrado em 25/07/2026 14:32:07. Fecho em cor de recibo:
		"Recibo íntegro. Cobertura orçamentária: reservada."
		"""
}, {
	id:   "case-erro"
	name: "Erro"
	content: """
		"CNPJ do fornecedor: dígito verificador inválido. Os demais 11 campos
		estão corretos. Corrija para prosseguir." — o sistema já conferiu o resto.
		"""
}, {
	id:   "case-aviso-de-limite"
	name: "Aviso de limite"
	content: """
		(borda tracejada). "A Mesh verificou o aceite bilateral desta
		entrega. Não verificou a qualidade física do material — isso permanece entre as
		partes."
		"""
}, {
	id:   "case-gate"
	name: "Gate"
	content: """
		"✓ gate de cobertura: reservado R$ 7.360,00" · "◌ gate de preço:
		excedente 8,4% — alçada nível 2". Estado literal, regra nomeada, valor presente.
		"""
}, {
	id:   "case-sugestao-do-agente"
	name: "Sugestão do agente"
	content: """
		Bloco sobre fundo-apoio: "Preparado pela Mesh •
		Qualificação — Fornecedor sugerido: Cimenorte. Porque: menor custo médio entre 3
		cotações · SLA 96,3% vs. 91,0% · documentação válida até 12/09. Por quê completo:
		toque para ver." Ao confirmar, o fundo sai; na auditoria, a procedência fica.
		"""
}, {
	id:   "case-divergencia"
	name: "Divergência"
	content: """
		"14:32 · Mesh preparou fornecedor A" / "14:35 · J. Costa
		selecionou fornecedor B — preço negociado diretamente." Evolução do processo, sem
		conflito.
		"""
}, {
	id:   "case-tabela-fila"
	name: "Tabela (fila)"
	content: """
		Cabeçalhos peso 500 caixa normal; números à direita com
		unidade; escalada é a única linha que acende (tracejado marrom, fundo tingido);
		crise sem adrenalina: "Pagamento P-1204 não liquidado. Motivo: saldo insuficiente.
		O compromisso permanece aberto. Nova tentativa: hoje, 16h. Nenhuma outra transação
		foi afetada."
		"""
}, {
	id:   "case-timeline-de-auditoria"
	name: "Timeline de auditoria"
	content: """
		Eventos datados em ordem, carimbos em mono, nada se
		edita — correções aparecem como novos eventos.
		"""
}]
