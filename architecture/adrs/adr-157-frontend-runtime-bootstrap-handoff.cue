package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-157 — Bootstrap/handoff do frontend-runtime. Irmão-frontend do adr-148 (que
// handoffou o mesh-runtime): define a morada da camada de frontend + a 1ª fatia real
// (a tela de override Approval-as-Confirmation do FCE) + a divisão de autoridade
// (semântica/contrato = mesh-spec; implementação/distribuição/vendor = frontend-runtime,
// def-060). Status proposed: é contrato de bootstrap, não de execução — a 1ª sessão do
// frontend-runtime (repo ainda inexistente) é quem executa a fatia downstream; a
// ratificação (→ accepted) viria quando o runtime nascer e consumir o contrato (molde
// adr-148, não adr-156 que era same-commit). Resolve a dependência quase-circular que o
// adr-154 nomeou (o handoff esperava "uma fatia de frontend real"; esta É a fatia) — o
// adr-154 flipa accepted no mesmo arco.

adr157: artifact_schemas.#ADR & {
	id:    "adr-157"
	title: "Bootstrap/handoff do frontend-runtime: morada + 1ª fatia (override do FCE)"
	date:  "2026-06-19"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "repo-wide"

	context: """
		A LACUNA QUE O adr-154 DECLAROU. O adr-154 (proposed) autorizou a EXISTÊNCIA do
		frontend-runtime e fixou o critério-de-repo, mas deixou o bootstrap/handoff como
		"escopo futuro fora deste ADR... trabalho bloqueado por pré-requisito ausente, não
		trade-off com gatilho". O pré-requisito que ele nomeou: "uma fatia de frontend real".
		Este ADR é essa fatia — remove o bloqueio, e com isso o adr-154 flipa proposed →
		accepted no mesmo arco (a razão do seu proposed deixa de existir).

		A DEPENDÊNCIA QUASE-CIRCULAR. O bootstrap esperava uma fatia real; a fatia real (a tela
		do override) esperava o bootstrap. O adr-150 nomeou a tela do override do PrePaymentGuard
		como "a primeira tela do banco / o próximo passo"; o adr-155 modelou o domínio dela. A
		fatia já existe em SUBSTRATO — lei (adr-150) e domínio (adr-155) em main —; falta o
		handoff que a declara a 1ª fatia do frontend-runtime. Este ADR corta o círculo,
		exatamente como o adr-154 antecipou (nomear a fatia É o gate).

		FUNDAÇÕES PRONTAS — o handoff APONTA, não copia (P0). adr-150 (accepted): a LEI que a tela
		obedece — Approval-as-Confirmation ("ação financeira TERMINA em botão estruturado, NUNCA
		chat livre — P10 na superfície") + FF-FE-01/02/08 (isolamento da camada de IA) + FF-FE-06
		(real-time do escalated). adr-155 (accepted): o DOMÍNIO que a tela aciona —
		cmd-resolve-guard-escalation + estado escalated + os 3 events + os VOs. Ambos em main;
		referência por id/path, não duplicação.

		MOLDE adr-148. Irmão-frontend do adr-148 (que handoffou o mesh-runtime): mesma estrutura
		(DECIDIDO-vs-A-EXECUTAR, morada, divisão de autoridade, fatia-mínima, exclusões, teste de
		suficiência), mesma divisão semântica-spec/implementação-runtime, mesmo status proposed
		(contrato de bootstrap cuja execução é downstream). Categoria-B (runtime subordinado,
		invisível ao portfólio, nasce por ADR do spec dono) — a mesma do mesh-runtime.
		"""

	decision: """
		(1) DECIDIDO vs A-EXECUTAR. DECIDIDO (itens 2-8): morada, divisão de autoridade, a 1ª
		fatia, exclusões, teste de suficiência. A-EXECUTAR (downstream): criação do repo, vendor
		(def-060), construção da tela, run vivo. Nada aqui afirma a tela construída — a execução
		segue pendente no frontend-runtime (que ainda não existe).

		(2) MORADA: o frontend-runtime (autorizado pelo adr-154) é a morada da camada de frontend
		— repo separado, subordinado aos contratos do mesh-spec, responsável por vendor, tela,
		build e execução. Categoria-B, nasce por ESTE ADR do spec dono, invisível ao portfólio do
		tekton (o #RepoBootstrapPlan é para repos -spec de empresa; runtime subordinado nasce por
		ADR, como o mesh-runtime via adr-148).

		(3) DIVISÃO DE AUTORIDADE: SEMÂNTICA/contrato — o QUE a tela confirma, os invariantes que
		obedece (adr-150) — = mesh-spec; IMPLEMENTAÇÃO/distribuição/vendor — framework, sync,
		design system, transporte HTTP — = frontend-runtime (def-060). Espelha o adr-148.

		(4) A 1ª FATIA — a tela de override do FCE. Approval-as-Confirmation sobre um Payment em
		escalated: o agente (agt-fce-primary, #170) RECOMENDA; o humano supre o supervisorId e
		confirma em ação estruturada (nunca chat). APONTA, sem copiar:
		- adr-150: Approval-as-Confirmation + Generative Form (form pré-preenchido pelo agente,
		  humano confirma/edita) + FF-FE-01/02/08 + FF-FE-06.
		- adr-155 / contexts/fce/domain-model.cue: cmd-resolve-guard-escalation (paymentId,
		  supervisorId, reason, decision approve|deny, overriddenConditions) + estado escalated +
		  evt-payment-guard-overridden/-override-refused + inv-override-requires-attribution +
		  vo-supervisor-id + vo-overridden-guard-conditions (3 flags fatura/elegibilidade/frescor;
		  SEM flag cripto = o piso — breach vai a freeze, jamais a esta tela).
		O piso (breach nunca overridável) é herdado do domínio, não re-decidido aqui.

		(5) CAPACIDADE CANÔNICA vs TECNOLOGIA RUNTIME-LOCAL: a CAPACIDADE (confirmar override com
		atribuição nominal, em ação estruturada P10) é canônica/spec; a TECNOLOGIA (framework,
		componente de botão/form, design system) é runtime-local (def-060). Espelha P14 + filtro
		adr-139.

		(6) EXCLUSÕES EXPLÍCITAS. NÃO inclui: o bootstrap físico do repo (downstream); a resolução
		do def-060 (vendor JIT); as outras 3 supervisedDecisions do FCE (fatias futuras,
		canvas-prose-only); e — GAP REGISTRADO, não escondido — a SUPERFÍCIE HTTP do override:
		contexts/fce/api.yaml não existe (oq-fce-1 aberto, não-bloqueante) e o override não tem
		endpoint em lugar nenhum. O contrato de cliente HTTP é deferido ao frontend-runtime
		(def-060: "seu contrato com a API"), espelhando o adr-148 que apontou para o domínio
		(am-commitment), não HTTP. O contrato que a tela honra é o DOMÍNIO, não um transporte.

		(7) NOTA ADITIVA: este ADR não cria arquivo novo além de si (plannedOutputs vazio) —
		aponta para adr-150, adr-155, contexts/fce/domain-model.cue, def-060 como o contrato.
		affectedArtifacts registra o flip companion do adr-154.

		(8) HANDOFF + TESTE DE SUFICIÊNCIA: a 1ª sessão do frontend-runtime lê este ADR + adr-150
		+ adr-155/domain-model.cue como contrato SUFICIENTE para construir a tela de override sem
		re-perguntar nada já decidido e SEM INFERIR SILENCIOSAMENTE decisões ausentes. Lacuna
		material → escalar ao founder (default na ausência de governança no repo nascente),
		interromper só o passo afetado; NÃO cristalizar hipótese runtime-local (vendor, transporte)
		como decisão canônica do mesh-spec.

		ALTERNATIVAS CONSIDERADAS.
		(a) Esperar — não autorar o handoff até o repo existir. REJEITADA: é a dependência
		    circular que trava tudo; o adr-154 já a resolveu nomeando a fatia como o gate.
		(b) Puxar a superfície HTTP do override para o spec (autorar api.yaml agora). REJEITADA:
		    adiciona trabalho que o adr-148 deixa downstream e crava transporte antes do vendor; o
		    contrato que a tela honra é o domínio, não o HTTP (o gap fica como exclusão).
		(c) Bootstrapar o repo direto, sem ADR de handoff. REJEITADA: pula a divisão de autoridade
		    e o contrato legível; o runtime nasceria sem a fronteira semântica/implementação — o
		    que o adr-148 estabeleceu para o mesh-runtime.
		"""

	consequences: """
		Positivas.
		(P1c) A dependência quase-circular é CORTADA: o handoff declara a tela de override a 1ª fatia,
		removendo o bloqueio que o adr-154 nomeou — o frontend-runtime ganha morada + fatia + contrato
		SEM ainda nascer.
		(P2c) A fronteira semântica/implementação é definida ANTES do 1º código, não retrofitada: o QUE
		a tela confirma (spec) vs o COMO (runtime/vendor) fica fixado no contrato que a 1ª sessão lê —
		espelha o que o adr-148 deu ao mesh-runtime.
		(P3c) O PISO é herdado pela tela POR CONSTRUÇÃO: vo-overridden-guard-conditions não tem flag
		cripto, logo a tela não tem como oferecer override de breach (que vai a freeze). A tela não
		pode violar o piso porque o domínio que ela aciona não o expõe.

		Negativas (limites intrínsecos).
		(N1) A EXECUÇÃO segue pending num repo que não existe — este ADR é proposed; a evidência (a
		tela construída) é downstream, fora do mesh-spec.
		(N2) O GAP HTTP fica aberto até o frontend-runtime resolver (def-060): o override não tem
		superfície de transporte em lugar nenhum. Registrado como exclusão (item 6), não escondido —
		mas real.
		(N3) A fatia cobre SÓ o override; as outras 3 supervisedDecisions do FCE ficam para fatias
		futuras (canvas-prose-only hoje).
		(N4) Depende de uma SESSÃO FUTURA seguir o teste de suficiência: se a 1ª sessão inferir
		silenciosamente uma decisão ausente em vez de escalar, a fronteira de autoridade é furada.
		Risco MITIGADO pela cláusula anti-inferência (item 8), não eliminado.
		"""

	falsificationCondition: {
		condition: """
			O contrato de handoff estará errado se, na 1ª sessão do frontend-runtime: (a) ela tiver que
			RE-PERGUNTAR uma decisão que este ADR (+ adr-150 + adr-155) deveria conter — contrato
			insuficiente; (b) ela CRISTALIZAR uma hipótese runtime-local (vendor, transporte, design
			system) como decisão canônica do mesh-spec — fronteira de autoridade falhou; (c) a tela puder
			oferecer override de um BREACH de P11 — o piso não foi herdado; (d) a confirmação terminar em
			CHAT LIVRE em vez de ação estruturada — Approval-as-Confirmation violada; ou (e) a confirmação
			NÃO exigir o supervisorId nominal — inv-override-requires-attribution não herdada.
			"""
		observableSignal: """
			Observável na 1ª sessão real do frontend-runtime: (a) escalação ao founder por lacuna de
			contrato (ou, pior, prosseguir inferindo) vs executar sem re-perguntar; (b) um artefato do
			mesh-spec ganha uma decisão de vendor/transporte nascida no runtime (drift cross-repo
			detectável por review da fronteira); (c) a tela expõe caminho de confirmação para um Payment
			reprovado por evidência ausente/forjada (deveria ser inalcançável — breach roteia a freeze);
			(d) a superfície de confirmação é um turno de chat, não um botão estruturado; (e) um
			evt-payment-guard-overridden sem supervisorId nominal. (a)/(b) → contrato/fronteira
			insuficiente; (c)/(d)/(e) → piso/lei não herdados — ambos PIVOTAR (revisar o handoff), não
			falha do runtime.
			"""
	}

	affectedArtifacts: [
		"architecture/adrs/adr-154-runtime-repo-criterion.cue",
	]
	plannedOutputs:   []
	derivedArtifacts: []
	defersTo: ["def-060"]

	principlesApplied: [
		"P0 — localização canônica única: o handoff APONTA para adr-150 (lei), adr-155 + domain-model.cue (domínio) e def-060 (vendor), nunca copia.",
		"P1 — schema CUE como SoT do contrato: o que a tela honra é o DOMÍNIO (cmd-resolve-guard-escalation + VOs, em CUE), não um transporte HTTP; o código de tela é derivado da spec.",
		"P10 — Approval-as-Confirmation é P10 na superfície: o gate determinístico (agente recomenda, humano aprova) traduzido para botão estruturado de confirmação, nunca chat livre.",
		"P14 — capacidade canônica vs tecnologia runtime-local: a capacidade (confirmar override com atribuição nominal) é spec; framework/componente/design-system são hipóteses runtime-locais (def-060) — filtro adr-139.",
	]

	rationale: """
		Contrato de bootstrap, não de execução. O valor deste ADR é a 1ª sessão do frontend-runtime
		nascer lendo um contrato único (este ADR + adr-150 + adr-155) em vez de arqueologia — e o item 1
		impede confundir a existência do contrato com a execução da tela (pending, downstream). Daí
		proposed: espelha o adr-148 (execução = 1ª sessão do runtime), NÃO o adr-156 (accepted, same-
		commit). A ratificação → accepted viria quando o runtime construir a tela.

		A fronteira semântica/implementação é o ANTÍDOTO da contaminação. A divisão (QUE = spec; COMO =
		runtime/vendor) + a cláusula anti-inferência (item 8) impede o vendor/transporte de subir
		indevidamente ao mesh-spec — o mecanismo que o adr-148 deu ao mesh-runtime, aqui contra cravar
		framework/design-system cedo demais.

		O piso herdado por construção: a tela não pode oferecer override de breach porque o domínio
		(vo-overridden-guard-conditions, SEM flag cripto) não o expõe — o piso do adr-155 propaga à
		superfície sem ser re-decidido. P0/P1/P10/P14 ancoram a decisão.

		O flip companion do adr-154: ele declarou seu proposed como "bloqueado por pré-requisito
		ausente" (a fatia real); este ADR É a fatia, então a razão do proposed deixa de existir e o
		adr-154 flipa accepted no mesmo commit — coerente, sem condição codificada (decisão do founder).

		Tensão com axiomas: nenhuma. O handoff honra P0/P1/P10/P14, defere ao runtime só o runtime-local
		(def-060), e registra o gap HTTP como exclusão explícita. Piso e atribuição nominal são herdados
		do adr-155, não tensionados.
		"""
}
