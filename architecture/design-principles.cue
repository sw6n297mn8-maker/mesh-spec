package design_principles

// 13 princípios que governam como o sistema Mesh é desenhado.
// Diferentes dos Princípios Orientadores (P1-P10 do README):
// aqueles governam a organização da spec; estes governam o design do sistema.

#PrincipleGroup: "Foundation" | "StructuralInvariants" | "DesignPhilosophy" | "SystemNature" | "Governance"

#DesignPrinciple: {
	id:        string
	group:     #PrincipleGroup
	statement: string
	rationale: string
}

principles: [ID=string]: #DesignPrinciple & {id: ID}

// ═══════════════════════════════════════════
// Foundation (P0–P2)
// Axiomas inegociáveis do sistema.
// ═══════════════════════════════════════════

principles: P0: {
	group:     "Foundation"
	statement: """
		O sistema possui exatamente três Sources of Truth: Event Log (fatos),
		Ledger (valor), Workflow History (execução). Tudo mais — read models,
		índices de busca, caches, analytics — é materialização descartável,
		reconstruível a partir dos SoTs. Este princípio se estende a toda
		informação do sistema: cada unidade de conhecimento possui exatamente
		uma localização canônica; todas as outras referências são ponteiros,
		nunca cópias.
		"""
	rationale: """
		Duplicação é drift por construção. Quando a mesma informação vive em
		dois lugares, eles inevitavelmente divergem, e o sistema não tem como
		saber qual está correto.
		"""
}

principles: P1: {
	group:     "Foundation"
	statement: """
		Schemas CUE são a source of truth de todos os contratos de domínio.
		Código é gerado, nunca escrito manualmente, para tipos, validadores,
		stubs e projetores. Compatibilidade backward e forward é gate de CI,
		não verificação manual.
		"""
	rationale: """
		Código escrito manualmente diverge da spec. Código gerado é
		materialização da spec — sempre atual, sempre consistente.
		"""
}

principles: P2: {
	group:     "Foundation"
	statement: """
		Zero vendor SDK em domain/ e contracts/. Vendors existem apenas atrás
		de adapters em platform/adapters/. O domínio se comunica através de
		Ports canônicos, nunca através de APIs de vendor.
		"""
	rationale: """
		O domínio deve sobreviver a mudanças de arquitetura. Lock-in de vendor
		no domínio é permanente; lock-in atrás de um Port é uma migração.
		"""
}

// ═══════════════════════════════════════════
// Structural Invariants (P3–P6)
// Propriedades estruturais que devem valer sempre.
// ═══════════════════════════════════════════

principles: P3: {
	group:     "StructuralInvariants"
	statement: """
		O Event Log é append-only, single-writer por stream, com optimistic
		concurrency, global_position gap-free e grafo causal obrigatório.
		Eventos são fatos imutáveis. Correção é por novos eventos, nunca por
		edição do passado.
		"""
	rationale: """
		Um log append-only é a única estrutura de dados onde "o que aconteceu"
		nunca é questão de opinião. Mutabilidade no event log torna
		auditabilidade impossível.
		"""
}

principles: P4: {
	group:     "StructuralInvariants"
	statement: """
		O Ledger é imutável, double-entry, com posting rules versionadas e
		reconciliação determinística. Todo movimento financeiro cria
		lançamentos de débito e crédito correspondentes atomicamente.
		"""
	rationale: """
		Double-entry é o único modelo contábil onde erros são auto-reveladores.
		Sistemas single-entry escondem desequilíbrios até virarem crises.
		"""
}

principles: P5: {
	group:     "StructuralInvariants"
	statement: """
		Workflows usam durable execution com persistência journal-based,
		versionamento e human-in-the-loop como primitiva de primeira classe.
		Workflow History é Source of Truth, não visão derivada.
		"""
	rationale: """
		Workflows financeiros que perdem estado no meio da execução causam
		dano monetário real. Durabilidade não é feature — é requisito de
		segurança.
		"""
}

principles: P6: {
	group:     "StructuralInvariants"
	statement: """
		Toda operação de escrita carrega chave de idempotência única
		(command_id, event_id, transfer_id, workflow_id). Processar a mesma
		chave duas vezes produz o mesmo resultado. Correção é por eventos
		compensatórios, nunca por mutação.
		"""
	rationale: """
		Em sistemas distribuídos, entrega exactly-once é impossível.
		Operações idempotentes tornam entrega at-least-once segura.
		"""
}

// ═══════════════════════════════════════════
// Design Philosophy (P7–P9)
// Guiam como construímos.
// ═══════════════════════════════════════════

principles: P7: {
	group:     "DesignPhilosophy"
	statement: """
		O runtime expõe 5 Ports canônicos (EventLogPort, LedgerPort,
		WorkflowPort, DeliveryPort, EvidencePort). Cada Port retorna
		PortResult<T>. Fronteiras de Port são cruzadas apenas por value
		classes — zero raw String/Long. Vendors implementam adapters atrás
		dos Ports.
		"""
	rationale: """
		Ports são as costuras onde o sistema pode ser desmontado e remontado.
		Sem Ports explícitos, mudanças de vendor se tornam reescritas.
		"""
}

principles: P8: {
	group:     "DesignPhilosophy"
	statement: """
		Read models, índices de busca, stores analíticos, caches e grafos são
		projeções derivadas dos SoTs. Podem ser deletados e reconstruídos a
		qualquer momento. Nunca são source of truth para qualquer decisão.
		"""
	rationale: """
		Se uma materialização não pode ser reconstruída, é um SoT escondido —
		e SoTs escondidos são os que causam os piores incidentes.
		"""
}

principles: P9: {
	group:     "DesignPhilosophy"
	statement: """
		Eventos de domínio carregam contexto OTel (trace_id, span_id). Spans
		OTel carregam contexto de domínio (event_id, command_id, tenant_id).
		Dois grafos causais (domínio e infraestrutura) são conectados
		bidirecionalmente. Alertas são fatos registrados no Event Log.
		"""
	rationale: """
		Sem a ponte, debugar uma anomalia de negócio exige correlação manual
		entre dois mundos desconectados. A ponte torna causalidade navegável.
		"""
}

// ═══════════════════════════════════════════
// System Nature (P10–P11)
// Definem que tipo de sistema a Mesh é.
// ═══════════════════════════════════════════

principles: P10: {
	group:     "SystemNature"
	statement: """
		Agentes estocásticos (IA) recomendam. Gates determinísticos validam.
		Agentes nunca executam commands financeiros diretamente. Todo command
		com impacto financeiro passa por gate que impõe invariantes,
		thresholds e aprovações humanas. A fronteira é declarada em
		autonomy-policy.cue por BC.
		"""
	rationale: """
		Recomendações de IA são probabilísticas. Execução financeira deve ser
		determinística. Misturá-las cria um sistema onde ninguém sabe se um
		pagamento foi decisão ou alucinação.
		"""
}

principles: P11: {
	group:     "SystemNature"
	statement: """
		Dinheiro só se move quando a operação comprova. Toda transição
		financeira exige evidência vinculada com integridade criptográfica
		(CAS, DSSE, Merkle proofs). A cadeia de evidência é tamper-evident
		em 6 camadas, do hash de conteúdo ao anchor Bitcoin.
		"""
	rationale: """
		Em cadeias produtivas da construção civil, o gap entre "trabalho
		reivindicado" e "trabalho realizado" é onde fraude vive. Operações
		lastreadas em evidência fecham esse gap por construção.
		"""
}

// ═══════════════════════════════════════════
// Governance (P12)
// ═══════════════════════════════════════════

principles: P12: {
	group:     "Governance"
	statement: """
		Governança não é documentação — é código. Fitness functions validam
		invariantes estruturais no CI. Policy-as-code é versionado e
		auditável. Observabilidade é causal, não apenas baseada em métricas.
		Toda regra que importa é imposta automaticamente.
		"""
	rationale: """
		Governança que depende de humanos lerem documentos e lembrarem regras
		não escala. Governança que roda no CI é proporcional ao sistema que
		governa.
		"""
}
