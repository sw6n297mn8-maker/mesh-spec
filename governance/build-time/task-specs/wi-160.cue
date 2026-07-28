package task_specs

taskSpecs: "WI-160": {
	version:     1
	title:       "Mapa de cotações — a 3ª família do codegen de frontend: dispara a promoção do contrato a schema first-class (gatilho adr-178 D3; conteúdo obrigatório per adr-179) e traz a view-de-query para o regime gerado"
	templateRef: "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"architecture/adrs/adr-178-journey-start-surface-kit-and-net-new-origin.cue — D3: 'Promoção a schema só se >1 família de frontend o exigir' com gatilho NOMEADO na 3ª família (o mapa) — esta fatia É a chegada; a view-de-query entrar no codegen é parte da mesma revisita.",
		"architecture/adrs/adr-179-frontend-promotion-mandate-reading-contract.cue — o mandato: por família, declaração estruturada de APLICABILIDADE do action-surface; o mapa é candidato a família legitimamente read-only — não-aplicabilidade declarada por shape tipado, sem action-surface vazio ou placeholder; o shape concreto é desenho DESTA promoção (decisão deliberada do adr-179).",
		"governance/build-time/frontend-codegen-contract.cue — campo schemaPromotionMandate (âncora no ponto de uso); o contrato v2 vira instância do schema promovido; as 2 famílias existentes migram sem perda das decisões vigentes (regime hand da fila, origem net-new/def-081).",
		"contexts/ssc/domain-model.cue — prj-quotation-map/qry-quotation-map (WI-152): a comparação consolidada consultável, viva na janela de RFQ, carimbada pela decisão — o instrumento central do comprador (mínimo três preços lado a lado, equalização TCO).",
		"contexts/ssc/api.yaml — criado pelo WI-159 (dependência dura em work-graph): o GET do mapa entra como update nesta fatia, no molde dos GETs de query existentes.",
		"O número WI-160 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; o número do ADR da promoção (família adr) é re-derivado na EXECUÇÃO (adr-168).",
	]
	outputs: [{
		artifact: "contexts/ssc/api.yaml"
		type:     "update"
	}, {
		artifact: "governance/build-time/frontend-codegen-contract.cue"
		type:     "update"
	}, {
		artifact: "architecture/artifact-schemas/ — schema first-class do contrato de codegen de frontend; nome/lar exatos são desenho da promoção per adr-179 dec 1, decididos na execução"
		type:     "create"
	}, {
		artifact: "architecture/adrs/adr-NNN — ADR da promoção (mudança semântica estrutural: schema novo exige ADR no mesmo commit); NNN re-derivado pelo gate G2 na execução (adr-168)"
		type:     "create"
	}]
	affects: [
		"architecture/adrs/adr-150-frontend-ai-first-invariants.cue",
	]
	rationale: """
		A fatia mais pesada do arco e o fecho do Bloco 4: a chegada da 3ª
		família dispara a promoção prevista — a lei de frontend (adr-150)
		migra de repetição disciplinada por autor para estrutura validável por
		cue vet (adr-179 P2c), e a view-de-query entra no regime gerado (fim do
		regime hand-espelho para famílias novas; as 2 famílias existentes
		migram por decisão da execução). O passo 7 da story ganha superfície:
		o mapa que o comprador usa para comparar. Dois outputs declaram
		lar/número a-derivar: o shape do schema é desenho da promoção POR
		DECISÃO do adr-179 (antecipá-lo aqui violaria o próprio ADR), e números
		da família adr não são reserváveis ex-ante (adr-168) — limitação
		declarada, não vagueza. Affects adr-150: a promoção é o degrau de
		mecanização spec-side da janela N3 daquele ADR (referência, sem
		edição). CLASSIFICAÇÃO: o centro de gravidade é criação de schema →
		tmpl-create-schema@v1 (criticality do template aplica); updates de
		instâncias acompanham no mesmo arco de execução.
		"""
}
