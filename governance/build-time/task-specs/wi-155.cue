package task_specs

taskSpecs: "WI-155": {
	version:     1
	title:       "Higiene B do gate agente↔modelo (adr-175) — drift pré-existente: cmt (2 itens) + triagem do rew por exclusão-de-classe (invariants de engine + events de ingestão) + exclusões formais nos BCs limpos onde o gate real acusar; fecha o baseline para a catraca warn→reject"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-175-agent-model-coverage-gate.cue — o critério de exclusão legítima (decisão 3) é a régua da triagem: classe estruturalmente identificável (ex.: commands policy-issued via policies[].issuesCommand) OU doutrinariamente fechada com rationale citando a marcação em prosa (ex.: invariants com enforcement declarado externo ao agente — 'enforcement EXTERNAL TO REW', replayHash mecânico). 'Dava trabalho cobrir' não satisfaz.",
		"governance/build-time/task-specs/wi-154.cue — higiene A (deltas das fatias) precede ou acompanha; a catraca warn→reject do sc-ag-02 só arma quando AMBAS zerarem o baseline.",
		"contexts/rew/agents/rew-primary-agent.cue + contexts/rew/domain-model.cue — a maior parcela do baseline (35 itens no anúncio de ativação) concentrada numa família: a amostragem da revisão de arquiteto classificou a maioria como exclusão-legítima (leis de engine/arquitetura, não responsabilidade de verificação do agente) — candidata natural à PRIMEIRA exclusão por classe do repo. Triagem, não carimbo: cada classe proposta com rationale que satisfaça o critério; o que for cobertura real (ex.: events de ingestão que o agente consome) vai para operationalScope.",
		"contexts/cmt/agents/cmt-primary-agent.cue + contexts/cmt/domain-model.cue — os 2 itens pré-existentes do cmt (candidatos: policy-issued per padrão estrutural).",
		"Saída do runner estrutural (sc-ag-02) no tip da branch da higiene — a lista viva por BC é a spec operacional; se BCs hoje limpos acusarem itens novos (fatias intermediárias), entram aqui.",
		"O número WI-155 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/rew/agents/rew-primary-agent.cue"
		type:     "update"
	}, {
		artifact: "contexts/cmt/agents/cmt-primary-agent.cue"
		type:     "update"
	}]
	affects: [
		"architecture/structural-checks/agent-spec.cue",
	]
	rationale: """
		O gate nasceu warn porque o baseline é sujo por construção (adr-175);
		esta fatia fecha a parcela PRÉ-EXISTENTE — o drift que o gate pagou o
		próprio custo ao revelar. rew é o caso dimensionante: dezenas de
		invariants de engine cuja exclusão por id seria carimbo repetido — a
		forma por classe do scopeExclusions existe para isso (1 regra
		auditável por classe, refs como extensão verificável). A triagem
		decide id a id: exclusão-legítima (per critério do adr-175) vs
		cobertura real faltante; o volume medido aqui também alimenta a
		decisão deferida de estruturar campos de ator/enforcement (fatia
		ortogonal futura).

		Ao final desta higiene (com a A), o baseline do sc-ag-02 deve estar em
		ZERO — condição da catraca warn→reject, que entra por decisão própria
		(precedente adr-117→123), não automaticamente.

		CLASSIFICAÇÃO: edições em instâncias de schema existente (#AgentSpec)
		→ tmpl-create-instance@v1. Exclusões formais em outros BCs, se o gate
		real acusar, são a mesma classe de edição.
		"""
}
