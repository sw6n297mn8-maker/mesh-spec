package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def093: artifact_schemas.#DeferredDecision & {
	id:     "def-093"
	title:  "Canonização da unidade de medida (unit) — do string declarado à comparabilidade verificada por linha"
	date:   "2026-09-06"
	status: "open"

	description: """
		O adr-198 fez o item emergir com unit como STRING DECLARADA
		(vo-rfq-item e vo-purchase-item) — suficiente para o item existir,
		insuficiente para a comparação ser segura. Fica deferida a
		canonização da unidade: taxonomia/VO próprio, fator de normalização
		entre unidades da mesma grandeza (o protótipo pratica: barra de
		12 m ÷ fator → kg), e onde a verificação de compatibilidade mora
		(gate de linha? validação de submissão?). A urgência é maior que
		'conceito emergiu': unidades divergentes quebram a comparação por
		linha EM SILÊNCIO — um fornecedor cota o rolo, outro o metro, e a
		matriz compara números incomparáveis sem erro visível; é a mesma
		grandeza do caso do caminhão (400 m² contra 300 m² só é comparável
		porque a unidade coincide por sorte, não por construção).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a canonização exige decidir quem GOVERNA a
		taxonomia de unidades (a organização, como em vo-category-ref? o
		catálogo por categoria? padrão externo?) e onde o fator de
		normalização vive (config versionada como FitnessRuleContent? campo
		da linha?) — decisões com dono e consequência que a fatia do item
		deliberadamente não toma; tomá-las de passagem seria decidir
		governança de taxonomia dentro de uma fatia de estrutura. Custo
		evitado: cravar taxonomia sem caso real de conflito de unidade
		observado. Custo de continuar deferindo: a janela em que a
		comparação por linha aceita unidades incomparáveis em silêncio —
		mitigada apenas pela prática (cotações da mesma categoria tendem à
		mesma unidade), não por construção.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito): o gatilho real é o primeiro
		conflito de unidade observado em uso (ou a fatia de recebimento —
		def-091 — exigir a comparabilidade para o saldo por item);
		predicado de conteúdo sobre 'unit' dispararia em todo o modelo
		itemizado que o adr-198 acabou de criar.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-198-quotation-item-primitive-and-line-level-gate.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			medium porque a falha é silenciosa mas condicionada (só fere
			quando unidades divergem na mesma linha — a prática da categoria
			mitiga); cross-artifact porque a canonização tocará ssc (linha
			da cotação, equalização) e p2p (item do pedido, saldo do
			def-091). Exit: VO/taxonomia de unidade + fator de normalização
			+ morada da verificação, no primeiro conflito observado ou
			quando def-091 abrir.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é o primeiro conflito de unidade observado em uso, ou a fatia do recebimento (def-091) exigir comparabilidade para o saldo por item — fatos de uso/sequenciamento, não de disco; predicado de conteúdo sobre 'unit' dispararia em todo o modelo itemizado recém-criado pelo adr-198."
	}]
}
