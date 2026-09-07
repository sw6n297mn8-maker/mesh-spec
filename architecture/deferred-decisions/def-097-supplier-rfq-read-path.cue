package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def097: artifact_schemas.#DeferredDecision & {
	id:     "def-097"
	title:  "O fornecedor convidado não tem por onde ler a RFQ — o ssc não expõe caminho de leitura ao lado vendedor, e o comando que ele precisa invocar exige o rfqId"
	date:   "2026-09-07"
	status: "open"

	description: """
		O passo 4 da ds-supplier-network-journey narra o fornecedor tomando
		conhecimento da RFQ para a qual foi convidado — escopo, itens, prazo
		da janela. NÃO EXISTE, no ssc, caminho de leitura que sustente esse
		passo. Medido no domain-model e no api.yaml em 2026-09-07:

		As quatro projections do ssc, uma a uma, e quem cada uma serve:
		- prj-active-sourcing-decisions — 'Consumido por P2P' (pós-decisão);
		- prj-sourcing-decision-by-id — lookup para P2P/CTR/auditoria;
		- prj-rfq-history-by-category — 'Read model INTERNO', estatística
		para o svc-fitness-rule-evaluator, explicitamente 'não input do
		fornecedor';
		- prj-quotation-map — 'Consumido intra-organização; NUNCA exposto a
		fornecedores' (confidencialidade competitiva, e corretamente assim).
		Nenhuma projeta a RFQ aberta para quem foi convidado.

		O api.yaml do ssc confirma pela borda: dos 8 endpoints, apenas DOIS
		são de leitura — /v1/ssc/queries/active-sourcing-decisions e
		/v1/ssc/queries/quotation-map/{rfqId} —, e nenhum é do fornecedor.

		A CONSEQUÊNCIA MECÂNICA, que é o que torna isto mais que uma lacuna
		de narrativa: cmd-submit-quotation exige o campo rfqId (fields:
		rfqId, supplierRef, lines, currency, termsNotes, paymentTerms,
		deliverySchedule). O fornecedor precisa fornecer um identificador
		que NENHUM caminho de leitura do contrato lhe entrega. O passo 5 da
		story depende de informação que o passo 4 não tem como obter.

		DISTINÇÃO com o que a story já declarava: o rationale do passo 4
		registra que o VEÍCULO da notificação não está modelado (o ntf não é
		BC; o mesh-spec declara só o papel) e que o dev serve do
		mesh-runtime materializou um stand-in de PULL autenticado como
		decisão runtime-local. Isto aqui é maior e anterior: não falta o
		veículo que ENTREGA o aviso — falta a SUPERFÍCIE que o fornecedor
		consulta. Um push por e-mail resolveria o veículo e não resolveria
		isto.

		Fica deferida a decisão de qual leitura o lado vendedor tem no ssc.
		Formas identificadas, sem escolha: (a) projection própria de RFQs
		abertas escopada ao fornecedor convidado; (b) recorte do que já
		existe com escopo por supplierRef; (c) a leitura não pertence ao ssc
		e vive noutro lugar (o papel do ntf, um BC de portal do fornecedor);
		(d) o fornecedor nunca lê — recebe tudo por push e o rfqId chega no
		payload da notificação.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a escolha entre (a)/(b)/(c)/(d) decide se o
		ssc ganha superfície de leitura VOLTADA AO FORNECEDOR — e essa é uma
		decisão de fronteira, não de modelagem. O ssc é o BC do processo
		competitivo do comprador; abrir nele uma leitura do lado vendedor
		mexe na fronteira do BC e na postura de confidencialidade que o
		canvas sustenta (o mesmo BC declara o mapa 'nunca exposto a
		fornecedores'). Modelar antes de decidir de quem é a superfície
		criaria a projection no lugar errado. Custo evitado: uma projection
		de leitura na fronteira errada, que depois nenhum ADR desfaz sem
		migração.

		CUSTO DE CONTINUAR DEFERINDO, e é o que pesa: a lacuna JÁ ESTÁ SENDO
		PREENCHIDA por decisão runtime-local. O dev serve do mesh-runtime
		materializou um stand-in de pull autenticado, e a tela do modo
		supplier no mesh-frontend-runtime está de pé sobre ele. Ou seja: o
		contrato não tem a leitura, o runtime inventou uma, e a tela já a
		consome. Cada dia de adiamento é mais superfície construída sobre
		uma decisão que deveria ser do spec — a inversão exata que a
		fronteira dos repos existe para impedir. E enquanto isso o passo 5
		da story do fornecedor permanece com uma dependência impossível: o
		rfqId que ninguém lhe entrega.

		O QUE ESTE DEF NÃO FAZ: não escolhe a forma, não cria projection,
		não emenda o passo 4 da story (que hoje narra corretamente uma
		leitura que o modelo não tem — a lacuna é o achado, per adr-170), e
		não julga o stand-in do runtime, que foi decisão local legítima na
		ausência de contrato.
		"""

	triggerCalibrationRationale: """
		O manual-review carrega o sinal real: de quem é a superfície de
		leitura do fornecedor é decisão de fronteira de BC, do founder, e
		nenhum predicado a antecipa. O adjacent-need é machine-evaluable e
		pega o momento em que a decisão foi tomada NOUTRO LUGAR sem passar
		por aqui: se aparecer 'supplierRef' nas projections do domain-model
		do ssc, alguém já escolheu a forma (a) ou (b) e este def precisa ser
		reconciliado com o que foi escrito. Não é o gatilho da decisão — é o
		gatilho de detectar que ela aconteceu por fora.
		"""

	originatingArtifacts: [
		"contexts/ssc/domain-model.cue",
		"strategic/domain-stories/supplier-network-journey.cue",
		"session:fatia-0-cobertura-derivada",
	]

	costOfDeferral: {
		severity:    "high"
		blastRadius: "cross-cutting"
		description: """
			high pela mesma lógica com que o founder calibrou o def-095, e
			NÃO pela do def-096: aqui não é alcance de verificação que se
			perde — é o lado vendedor do produto que não tem de onde ler. A
			jornada do fornecedor tem seis atos, e o segundo deles
			(cmd-submit-quotation) exige um rfqId que o contrato não
			entrega; sem essa leitura, o fornecedor não entra no processo
			competitivo, e sem fornecedor no processo não há competição —
			nada quebra porque nada está acontecendo do lado de lá. O
			agravante é de governança: a lacuna já está preenchida por
			stand-in runtime-local com tela viva em cima, o que torna cada
			dia de adiamento mais custoso de reverter, não menos.
			cross-cutting porque toca o ssc (a fronteira e a postura de
			confidencialidade), a ds-supplier-network-journey (passos 4 e
			5), o papel do ntf e o canvas de comunicação. Exit: a decisão do
			founder sobre de quem é a superfície, seguida da modelagem no BC
			que ela couber.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "De quem é a superfície de leitura do fornecedor é decisão de fronteira de BC — o ssc é o BC do processo competitivo do comprador e declara o mapa nunca exposto a fornecedores; abrir nele leitura do lado vendedor é julgamento do founder, não fato observável em disco."
	}, {
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "contexts/ssc/domain-model.cue"
			pattern: "supplierRef.*projection|projections.*supplierRef"
		}
	}]
}
