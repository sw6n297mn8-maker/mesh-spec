package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def028: artifact_schemas.#DeferredDecision & {
	id:     "def-028"
	title:  "Resolver ciclo FCE↔TCM (sc-cm-07 W4) — excluir sync-only-query relationships do grafo de dependência"
	date:   "2026-05-29"
	status: "open"

	description: """
		sc-cm-07 (directed-acyclicity, adr-117) detectou 4 ciclos. Este
		deferimento cobre W4 (fce → tcm → fce, 2-BC). As 2 arestas têm
		modos de comunicação assimétricos:
		- tcm-to-fce: communication.type="sync", queries=["QueryCashAvailability",
		  "QueryCashForecast"], SEM events declarados
		- fce-to-tcm: communication.type="async", events=["PaymentSettled"]

		Decisão conceitual registrada: o par FCE↔TCM NÃO forma loop semântico
		genuíno. Subdomain FCE: "FCE utiliza informações de disponibilidade
		fornecidas por TCM para otimizar execução, sem assumir gestão de
		posição de caixa." Subdomain TCM: "TCM projeta e planeja; FCE executa.
		Projeção de fluxo é prospectiva; pagamento é efetivo. Fusão misturaria
		planejamento com execução — cadências e responsabilidades distintas...
		cadência de evolução independente (ciclos de projeção diários/semanais
		vs execução transacional)." A aresta tcm-to-fce é call-site operacional
		(FCE consulta TCM via query síncrona para otimizar timing); a aresta
		fce-to-tcm é event publish-subscribe normal. Não há projection-
		adjustment loop estrutural.

		Família B da taxonomia de exclusão do grafo do sc-cm-07: o context-map
		JÁ CARREGA fields que distinguem dependência arquitetural de coupling
		operacional (communication.type + queries + events). Não é necessário
		estender vocabulário do schema (Família A); basta um edgeFilter
		adicional no sc-cm-07 sobre dado existente.

		Distinção entre Famílias (registrada para fechar loop conceitual):
		- Família A (def-026, def-027): relação tem natureza qualitativa nova
		  que vale nomear no vocabulário do schema do context-map.
		- Família B (def-028): relação já tem campos que distinguem dependência
		  arquitetural de coupling operacional; basta filter no sc-cm-07.

		Decisão a materializar: estender edgeFilters do sc-cm-07 (sem mudar
		schema do context-map) para excluir arestas com communication.type==
		"sync" AND queries declarado (não-vazio) AND events ausente (ou vazio).
		Esta combinação caracteriza query-surface — call-site operacional onde
		consumer (FCE no caso) consulta sincronamente um SoT (TCM) sem que isso
		constitua dependência arquitetural bidirecional. Resultado no grafo:
		aresta tcm-to-fce sai; aresta fce-to-tcm (async + event) permanece como
		dependência direcionada legítima; ciclo W4 quebra.

		Generaliza além de W4: outras queries sync cross-BC futuras ganham
		mesmo tratamento sem novo trabalho de schema-extension. Aresta cmt-to-
		ctr existente (CMT consulta CTR para termos contratuais) é candidato
		potencial — PR-2 que materializar adr-120 deve fazer scan complementar.

		Opções consideradas (preferred destacado):

		(a) Promover FCE↔TCM a direction:"mutual-dependency". REJEITADA:
		subdomains FCE e TCM declaram explicitamente "cadências de evolução
		independente" e responsabilidades disjuntas — mutualidade em DDD
		orthodoxy implica acoplamento estrutural que os subdomains
		categoricamente negam. "TCM projeta; FCE executa" é separação one-way
		dominante.

		(b) [PREFERRED] Estender edgeFilters do sc-cm-07 para excluir arestas
		com communication.type=="sync" + queries declarado + events ausente.
		Família B da taxonomia. Não muda schema do context-map (zero risco
		de regressão em outros checks/usos); generaliza automaticamente para
		futuras queries sync; reflete a verdade que query-surface é call-site
		operacional, não dependência arquitetural cross-BC. Cobre W4 diretamente.
		Trabalho mínimo no PR-2 + scan complementar para detectar outras
		query-surfaces (cmt-to-ctr é candidato).

		(c) Estender #FeedbackLoopKind com "projection-adjustment" (proposta
		original do agente na Fase 1). REFUTADA pela leitura dos subdomains
		(reportada na pausa pré-Fase 2): não há projection-adjustment loop
		estrutural — TCM projeta a partir de muitos eventos cross-BC, não em
		feedback de FCE. PaymentSettled é uma observação entre dezenas,
		não loop bilateral. Conceitualmente errado.

		(d) Modelar tcm-to-fce com novo direction:"query-only" (Família A
		para query-surfaces). REJEITADA: introduz novo vocabulário do schema
		para algo que já está expressível via communication.type existente.
		Sem ganho de expressividade — viola P0 (uma localização canônica para
		cada conceito). Família B é a leitura correta.

		ADR de resolução planejado: adr-120-exclude-sync-only-queries-from-
		acyclicity-graph (a ser criado em PR-2 do plano em
		triggerCalibrationRationale).
		"""

	deferralRationale: """
		MOTIVO: a resolução exige (1) decisão sobre forma exata do edgeFilter
		composto (sync + queries + ausência de events; vs sync sozinho; vs
		regex sobre tipos de relationship), (2) ADR adjacente registrando a
		decisão de Família B vs Família A para query-surface (adr-120
		planejado), (3) scan complementar para identificar outras query-
		surfaces no context-map que devem ser excluídas pelo mesmo filter,
		(4) materialização em PR separado (PR-2 do plano).

		RISCO de resolver agora sem deferred-decision: edgeFilter composto mal-
		desenhado pode excluir arestas que NÃO são query-only puras (e.g.,
		hybrid sync+async como CTR-CMT que carrega events E queries — pode
		merecer tratamento distinto).

		Custo de deferir: 1 ciclo (W4) WARN; reversível mecanicamente quando
		PR-2 materializar.
		"""

	triggerCalibrationRationale: """
		Trigger primário manual-review porque a forma exata do edgeFilter
		composto é interpretativa: (a) só sync + queries + sem events vs
		sync + queries (independente de events); (b) lugar do filter (no
		sc-cm-07 instance vs no schema #DirectedAcyclicityRule como capability
		genérica); (c) escopo do scan complementar (apenas tcm-to-fce ou todas
		query-surfaces). Não machine-evaluable.

		Trigger secundário adjacent-need file-contains em architecture/
		structural-checks/context-map.cue detectando pattern "communication.type"
		— string que aparecerá no rule do sc-cm-07 quando o filter for adicionado
		(novo path: "communication.type" no edgeFilters). Pattern verifica que
		filter foi materializado no check, não em qualquer arquivo. Pattern
		conservador: o "." em regex é "qualquer char" mas a string aparece
		organicamente apenas no contexto do filter (baixo risco de FP).

		Plano de PRs (sequenciamento):
		- PR-1: adr-118 + adr-119 (família A — def-026/def-027 schema
		  extensions)
		- PR-2: adr-120 (família B — este deferimento; só check filter)
		- PR-3: aplicação nas arestas concretas do context-map (para família
		  A) + scan complementar para outras query-surfaces + promoção
		  sc-cm-07 warn → reject

		Pattern atualizado em PR-2 (adr-120) de communication.type para
		exists:\\s*true refletindo a implementação final Opção β (events
		exists via capability nova) em vez do critério 3-condições Família
		B original. Refinamento preserva acoplamento entre trigger e
		realidade materializada — evita precedente de triggers silenciosos.
		"""

	originatingArtifacts: [
		"strategic/context-map.cue",
		"architecture/structural-checks/context-map.cue",
		"architecture/adrs/adr-117-add-directed-acyclicity-kind-to-structural-check.cue",
		"strategic/subdomains/fce.cue",
		"strategic/subdomains/tcm.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			1 ciclo (W4) WARN até resolução; severity medium porque (a) escopo
			contido a 2 BCs (FCE/TCM); (b) decisão é tática (edgeFilter shape)
			vs estratégica (vocabulário DDD); (c) reversível mecanicamente
			no PR-2. blastRadius cross-artifact porque resolução toca
			sc-cm-07 + strategic/context-map.cue (uso) + potencialmente outras
			query-surfaces detectadas no scan complementar (cmt-to-ctr é
			candidato a verificar). Sem mudança de schema do context-map;
			limitação a 2 arquivos no caso minimal (sc-cm-07 + strategic/
			context-map.cue se outras arestas ficarem inalteradas).
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Decisão sobre forma do edgeFilter composto (sync + queries + sem
			events vs sync + queries) + escopo do scan complementar de outras
			query-surfaces + lugar do filter (instance vs schema). Founder
			revisita preparando PR-2. Não machine-evaluable porque exige
			julgamento sobre semântica de query-surface (definir critério
			canônico de "sync que não é dependência arquitetural").
			"""
	}, {
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "architecture/structural-checks/context-map.cue"
			pattern: "exists:\\s*true"
		}
	}]
}
