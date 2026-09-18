package task_specs

taskSpecs: "WI-164": {
	version:     1
	title:       "Tipar a recusa da contraparte no causeType do cmt: um valor novo para separar recusa de cancelamento administrativo e de abandono — e registrar, sem agir, a suspeita de sobrecarga do operational"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"O GAP: vo-state-change-reason.causeType é enum fechado de cinco valores (risk-signal, risk-cleared, dispute-resolution, dispute-suspension, operational). A recusa da contraparte — a transição proposed→cancelled descrita no lifecycle do agg-commitment como 'Proposta rejeitada ou abandonada antes do aceite bilateral', com métrica de canvas de ~15% das propostas — não tem tipo próprio. Chega como operational, indistinguível de cancelamento administrativo e de abandono.",
		"POR QUE DESTRAVA: o roteamento do reencaminhamento de linha decide o destino pelo motivo tipado. Recusa que chega como operational não roteia — o gatilho da recusa é o único dos gatilhos que depende deste enum; os motivos de retirada no ato da decisão vivem em outro enum, no vo-item-award do ssc, e não estão bloqueados.",
		"ESCOPO É MENOR DO QUE PARECE, verificado em 2026-09-18: o enum fechado existe SÓ no campo constraints do vo-state-change-reason em contexts/cmt/domain-model.cue. contexts/cmt/schemas/events.cue declara causeType como `string & !=\"\"`; contexts/cmt/api.yaml e contexts/cmt/async-api.yaml declaram `type: string, minLength: 1`. Nenhum dos três enumera. Acrescentar um valor não toca superfície nem envelope.",
		"E O MANIFEST NÃO ENTRA: contexts/cmt/aggregate-manifests/am-commitment.cue espelha VERBATIM commands, events e invariants — não value objects. Verificado; fora da fatia.",
		"SUSPEITA A REGISTRAR, NÃO A RESOLVER: o operational está sob suspeita de sobrecarga. A evidência é de UM caso — descobrimos que a recusa cai ali porque fomos olhar a recusa. Não se sabe se cancelamento administrativo e abandono também estão espremidos por falta de tipo ou se são genuinamente operacionais. Refazer a taxonomia a partir de um caso é calibrar régua por uma medida. A passada geral espera o SEGUNDO caso mal tipado, quando se justifica sozinha.",
		"ONDE A SUSPEITA MORA: no rationale do próprio vo-state-change-reason, não apenas neste WI. Work item é consumido quando conclui; a suspeita precisa sobreviver a ele para que o segundo caso encontre o primeiro já registrado. Esta é adição do agente à instrução do founder — se o founder preferir a suspeita só no WI, o output correspondente sai.",
		"A FROUXIDÃO DO ESPELHO, nomeada e NÃO corrigida nesta fatia: o conjunto fechado não é obrigado em lugar nenhum fora do domain-model. É a razão estrutural de a sobrecarga não aparecer sozinha — nenhum gate acusa um causeType fora do conjunto. Corrigir isso é fatia própria, da mesma classe da passada geral que este WI declina.",
		"contexts/cmt/glossary.cue — o naming do valor novo decide-se sob o glossário do BC, e há armadilha conhecida: 'declinar' já está ocupado no ssc pela resposta à contraposta (cmd-decline-counter-terms) e 'recusa' também é usada lá para o mesmo ato. O termo do cmt precisa não herdar a ambiguidade do vizinho.",
		"O número WI-164 segue a mesma condição já confirmada pelo arquiteto para esta branch: o G2 deriva de origin/main e não enxerga WI-162 nem WI-163, que vivem em claude/quirky-cray-3tkf9a com PR #263 aberto. Mesma causa, mesma resolução — não é decisão nova.",
	]
	outputs: [{
		artifact: "contexts/cmt/domain-model.cue"
		type:     "update"
	}, {
		artifact: "contexts/cmt/glossary.cue"
		type:     "update"
	}]
	affects: [
		"contexts/cmt/schemas/events.cue",
		"contexts/cmt/api.yaml",
		"contexts/cmt/async-api.yaml",
	]
	rationale: """
		Um valor, não uma taxonomia. A escolha entre acrescentar o tipo da
		recusa e refazer o conjunto foi decidida pelo founder a favor do
		primeiro, por dois motivos que valem escritos: a evidência de
		sobrecarga é de um caso só, e o adr-199 está parado atrás desta peça —
		uma passada geral viraria discussão própria com o ADR esperando.

		Declarar a suspeita sem agir sobre ela não é decidir por omissão: é o
		oposto. Omissão seria acrescentar o valor e deixar o operational
		parecendo íntegro. O registro faz com que o segundo caso mal tipado
		encontre o primeiro já anotado, e aí a passada geral chega com duas
		evidências em vez de uma.

		O que este WI NÃO faz: não refaz o enum, não aperta o espelho frouxo
		das três superfícies, não cria o roteamento do reencaminhamento. Fecha
		a pré-condição de tipo que o gatilho da recusa exige.
		CLASSIFICAÇÃO: instanciação (sem ADR novo — precedente WI-161; aqui é
		um valor em enum existente).
		"""
}
