package task_specs

taskSpecs: "WI-151": {
	version:     1
	title:       "Fatia da requisição de compra no BC p2p — materializar o conceito de requisição (requisitante declara demanda) e as 3 decisões de desenho anunciadas (vínculo bdg, fato-de-origem, forma da triagem); ordem da aprovação carved-out a def-078"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/domain-stories/buyer-procurement-journey.cue — a story revelou que o modelo começa tarde: a jornada nasce no canteiro, o modelo só ganha corpo na cotação (passos 4+). A requisição é a PORTA (passos 1–3), hoje inexistente em qualquer BC. Fonte de cobertura da fatia — anti-retrofit: fecha refs vazias que a story já declara honestamente, não sintetiza do modelo.",
		"strategic/subdomains/p2p.cue — a língua JÁ existe: declara 'requisição, aprovação por alçada' e 'requisição, aprovação, pedido de compra, alçada' + 'requisitantes técnicos'. Execução, não descoberta.",
		"contexts/p2p/glossary.cue — term-requisitante e term-comprador já definidos (Phase 0 absorbidos em sh-01 originadora; requisitante declara demanda técnica que precede EmitPurchaseOrder pelo comprador). A fatia materializa o que o glossário já nomeia.",
		"contexts/p2p/domain-model.cue — superfície de escrita da fatia (materializar command/event/policy/readModel da requisição). Output.",
		"contexts/bdg/domain-model.cue — 1ª decisão de desenho: vínculo da requisição com centro de custo / etapa de orçamento. Acoplamento a resolver na execução.",
		"architecture/deferred-decisions/def-078-approval-order-gate-vs-consequence.cue (open) — a ORDEM DA APROVAÇÃO (gate vs consequência) é carved-out desta fatia: o passo de triagem/alçada NÃO fecha sem def-078 resolvido. def-078 é pré-requisito do passo 3, não item paralelo. Resolver na conversa de modelo que abre esta fatia.",
		"O número WI-151 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "contexts/p2p/domain-model.cue"
		type:     "update"
	}]
	affects: [
		"strategic/domain-stories/buyer-procurement-journey.cue",
	]
	rationale: """
		A requisição de compra não existe em nenhum BC — mas a LÍNGUA já está
		pronta (subdomínio p2p declara requisição/aprovação/alçada; glossário
		tem term-requisitante/term-comprador; cmd-emit-purchase-order já carrega
		'originadora'). É execução, não descoberta: a fatia materializa o que o
		vocabulário já nomeia. É a PORTA da jornada de compras (passos 1–3 da
		ds-buyer-procurement-journey), onde o modelo hoje começa tarde.

		Três decisões de desenho anunciadas, a resolver na execução da fatia:
		(1) vínculo com bdg (centro de custo / etapa de orçamento);
		(2) fato-de-origem (o que registra a demanda que precede o pedido);
		(3) forma da triagem (roteamento/screening da requisição).

		CARVE-OUT explícito: a ORDEM DA APROVAÇÃO (aprovação-como-gate vs
		aprovação-como-consequência) NÃO é decidida nesta fatia — é decisão de
		modelo do founder registrada em def-078, e é PRÉ-REQUISITO do passo de
		triagem/alçada. A forma da triagem (roteamento) é separável da ordem da
		aprovação (momento da alçada relativo ao pedido); a fatia pode desenhar
		o roteamento sem comprometer a ordem, mas não fecha o passo de aprovação
		sem def-078.

		CLASSIFICAÇÃO: instância de schema existente (edições no domain-model do
		p2p) → tmpl-create-instance@v1. Escopo fino (steps-1-2 vs steps-1-3) se
		decide no read-only da própria fatia, sob OK do founder.
		"""
}
