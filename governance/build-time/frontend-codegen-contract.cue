package build_time

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// frontend-codegen-contract.cue -- Contrato declarativo de codegen spec->frontend-runtime (adr-158).
//
// V3 (adr-180): PROMOÇÃO A SCHEMA FIRST-CLASS executada — o gatilho do
// adr-178 D3 disparou com a 3ª família (o mapa de cotações do ssc) e o
// conteúdo obrigatório seguiu o mandato do adr-179. A instância deixa de
// ser schema-exempt: conforma a #FrontendCodegenContract
// (architecture/artifact-schemas/frontend-codegen-contract.cue), com as
// famílias como estrutura TIPADA (união discriminada por capacidade,
// exclusão mútua por shape). Os 7 transform stages da v2.1 foram
// ABSORVIDOS pela estrutura tipada das famílias (a informação vive nos
// campos; zero capacidade perdida); as notas de transparência P14
// (decision do override aberto; outcome da triagem aberto) permanecem no
// lar original — schemas/api dos BCs — e nos slots das actions.
// schemaPromotionMandate REMOVIDO: cumprido; o registro canônico do
// cumprimento é o adr-180.
//
// STATUS: PROPOSED -- hipótese falsificável (CUE->superfície-de-frontend); o flip a accepted
// é por EVIDÊNCIA spec-side (precedente codegen-validation-evidence.cue + revisão de
// causa-raiz do founder + write-back gated, adr-148 item 8); o HARNESS que produz essa
// evidência é deferido em def-065 (prerequisite downstream, não pendurado). A superfície
// FCE (v1) JÁ foi gerada e compilou no frontend-runtime (pin armado); o flip formal segue
// aguardando o harness do def-065. def-064 observa este flip como sinal do 2º runtime real.
//
// ESCOPO: contrato DECLARATIVO (famílias de superfície) da família de domain-types de
// frontend. O QUE o contrato fixa é a CAPACIDADE da superfície (agnóstica de linguagem,
// P14); a LINGUAGEM-ALVO e a FORMA/sintaxe são runtime-local (fronteira QUE=spec/
// COMO=runtime do adr-158; pós-decomposição adr-159 os deferrals vivos são
// def-066/def-067/def-068 — vendors específicos; linguagem/forma sem def pendente).
// A família Rust WASM (paridade de cálculo cliente/servidor, FF-FE-05) é governada
// por adr-150 item 6 (sob adr-147) -- este contrato APONTA, não re-decide. Output
// vive no frontend-runtime, nunca committado aqui (P1 estrito).

frontendCodegenContract: artifact_schemas.#FrontendCodegenContract & {
	version: "v3"

	// Nasce proposed (hipótese CUE->superfície-de-frontend); migra para o estado validado no 1º golden-example
	// do frontend, por evidência spec-side + decisão do founder (harness em def-065; molde
	// adr-140). O flip deste campo no golden-example é o sinal observado por def-064.
	// A promoção estrutural (v3) NÃO antecipa o flip.
	status: "proposed"

	authorizedBy: ["adr-158", "adr-157", "adr-150", "adr-155", "adr-178", "adr-179", "adr-180"]

	// Semântica de UX: a lei AI-first que TODA superfície gerada obedece.
	uxSemantics: {
		source:    "architecture/adrs/adr-150-frontend-ai-first-invariants.cue"
		provides:  ["Approval-as-Confirmation", "Generative Form", "Action-as-Tool"]
		rationale: "A lei do adr-150 que a superfície honra: ação financeira termina em botão estruturado (Approval-as-Confirmation, P10), form pré-preenchido pelo agente (Generative Form), ação = botão+tool de uma definição (Action-as-Tool). APONTA, não copia. Na v3 os 3 patterns viram CONSTRAINTS do schema (slots por construção; movesMoney⇒approvalAsConfirmation; net-new⇒justificativa+migração)."
	}

	families: {
		// ── Família 1 (v1, adr-158/adr-155): o override do guard de
		// pagamento — a 1ª tela, action-bearing, dinheiro move.
		"fce-override": {
			kind:              "action-bearing"
			boundedContextRef: "fce"
			sourceModel:       "contexts/fce/domain-model.cue"
			aggregateRef:      "agg-payment"
			lifecycleStates: ["escalated"]
			valueObjects: ["vo-supervisor-id", "vo-overridden-guard-conditions"]
			events: ["evt-payment-guard-escalated", "evt-payment-guard-overridden", "evt-payment-guard-override-refused"]
			actions: [{
				commandRef: "cmd-resolve-guard-escalation"
				actionPairing: {
					description: "Resolver a escalação do guard: o supervisor decide o override (approve/deny) sobre um pagamento retido em escalated. Botão humano na fila escalada e tool de agente derivam de UMA definição desta action (adr-150 dec 2a) — a mesma superfície que o mesh-runtime gera em Kotlin (rtd-018)."
					rationale:   "O override é a decisão humana terminal do guard: o sistema retém e recomenda, o supervisor decide — o par decide-execute do P10 na 1ª tela."
				}
				confirmation: {
					returnsEvents: ["evt-payment-guard-overridden", "evt-payment-guard-override-refused"]
					movesMoney:             true
					approvalAsConfirmation: true
					rationale:              "O resolve autoriza (ou nega) a saída de dinheiro retida pelo guard — movesMoney true pelo domínio (adr-155); Approval-as-Confirmation entra por constraint (P10 em pixel: a ação financeira TERMINA em confirmação estruturada). O POST devolve oneOf dos 2 eventos conforme a decisão — a razão da lista returnsEvents ≥1."
				}
				generativeForm: {
					origin:      "system"
					prefillNote: "Form pré-preenchido do item da fila escalada: contexto do payment, condições do guard violadas (vo-overridden-guard-conditions) e a recomendação do agente-analista quando o runtime de agente existir. decision viaja ABERTA (string) — P14: o domínio não fecha o enum; a tela conhece os 2 valores legais (approve|deny) pelas 2 transições do lifecycle. Selar é backlog do domain-model, não do contrato."
					rationale:   "Generative Form padrão da adr-150: toda a informação da decisão já vive no sistema (o item escalado) — origem system, sem exceção."
				}
				rationale: "A action da 1ª fatia do frontend (adr-158): exatamente o command que a tela do override aciona, com o piso herdado do domínio (breach não-overridável vive no domain-model, não aqui)."
			}]
			readSurfaces: [{
				canvasSurfaceRef: "QueryEscalatedPayments"
				view:             "escalated-queue"
				viewRegime:       "hand-grandfathered"
				rationale:        "A fila escalada da 1ª família: view HAND existente antes do adr-180 (precedente escalated-queue.ts do frontend-runtime), ancorada na query-surface QueryEscalatedPayments do canvas do fce — SEM qry-* formal no domain-model, por isso o ramo canvas-backed (que força o regime hand-grandfathered por shape). Dívida tipada: migra a generated quando a query capability nascer no domain-model, em fatia própria."
			}]
			rationale: "Domínio FCE é a fonte da superfície de tipos da 1ª tela: cmd-resolve-guard-escalation + os 2 VOs + estado escalated + os 3 events — recorte verbatim da v1 (adr-158), agora tipado. Mesma superfície que o mesh-runtime já gera em Kotlin (rtd-018)."
		}

		// ── Família 2 (v2/v2.1, adr-178 + WI-156): o início da jornada —
		// submissão de requisição (origem net-new) + triagem da fila.
		"p2p-journey-start": {
			kind:              "action-bearing"
			boundedContextRef: "p2p"
			sourceModel:       "contexts/p2p/domain-model.cue"
			aggregateRef:      "agg-purchase-requisition"
			lifecycleStates: ["submitted", "triaged", "approved", "converted", "rejected", "cancelled"]
			valueObjects: ["vo-requisition-id", "vo-category-ref", "vo-purchase-scope"]
			events: ["evt-purchase-requisition-submitted", "evt-purchase-requisition-triaged"]
			actions: [{
				commandRef: "cmd-submit-purchase-requisition"
				actionPairing: {
					description: "Submeter requisição de compra: o engenheiro registra a necessidade observada no canteiro (categoria, escopo, volume estimado, prazo) e a jornada nasce. Botão humano e tool de agente de UMA definição (adr-150 dec 2a) — o POST do contexts/p2p/api.yaml é a mesma superfície."
					rationale:   "O passo 1 da ds-buyer-procurement-journey: sem a submissão nada existe para triar, cotar ou aprovar — a action de entrada da jornada inteira."
				}
				confirmation: {
					returnsEvents: ["evt-purchase-requisition-submitted"]
					movesMoney:             false
					approvalAsConfirmation: false
					rationale:              "A submissão NÃO move dinheiro (a reserva de cobertura pertence a cmd-approve-purchase, fatia futura) — Approval-as-Confirmation não é exigida (adr-150 dec 2c); a confirmação estruturada devolvendo o evento emitido é disciplina de superfície (molde CMT/FCE), não P10-gate."
				}
				generativeForm: {
					origin:              "net-new"
					netNewJustification: "O cronograma físico do canteiro não existe no sistema até a observação do engenheiro na visita técnica — a informação NASCE fora do sistema no ato (critério adr-178 dec 4, demonstração do founder registrada na 2ª família): não há fonte interna da qual pré-preencher."
					migrationRef:        "def-081"
					prefillNote:         "O form nasce com o SHAPE da Generative Form (pré-preenchível campo a campo); o CONTEÚDO de origem é hoje digitação humana LEGÍTIMA per adr-178 — quando o cronograma virar input de sistema, o preenchedor-agente entra sem mudança de shape (def-081)."
					rationale:           "O não-padrão net-new da lei (adr-178 dec 4): exceção demonstrada com âncora de migração — não digitação-por-preguiça."
				}
				rationale: "A action da 2ª família (adr-178): o command da submissão com o evento-confirmação que o POST devolve — recorte espelha contexts/p2p/api.yaml."
			}, {
				commandRef: "cmd-triage-requisition"
				actionPairing: {
					description: "Triar requisição: a decisão do comprador sobre o item da fila — outcome routed-to-sourcing | returned | rejected (os 3 valores legais do domain-model; o campo viaja ABERTO porque o domínio não fecha — P14, molde da nota da v2.1). Botão humano na fila de triagem e tool de agente de UMA definição."
					rationale:   "A triagem é a 1ª decisão humana da jornada pós-submissão: rotear ao sourcing, devolver ou rejeitar — o degrau que o WI-156 fechou de ponta a ponta (spec→motor→tela)."
				}
				confirmation: {
					returnsEvents: ["evt-purchase-requisition-triaged"]
					movesMoney:             false
					approvalAsConfirmation: false
					rationale:              "A triagem NÃO é ação financeira — nenhum dinheiro move (a reserva de cobertura pertence ao cmd-approve-purchase, fatia futura); Approval-as-Confirmation não é exigida (adr-150 dec 2c). O POST devolve PurchaseRequisitionTriaged como confirmação estruturada; narrative obrigatória em returned/rejected é invariante de handler — a superfície reflete a obrigação por comportamento, não por shape."
				}
				generativeForm: {
					origin:      "system"
					prefillNote: "Form pré-preenchido a partir do ITEM DA FILA selecionado (qry-pending-requisitions): a informação da requisição já vive no sistema — Generative Form PADRÃO da adr-150, sem exceção; o agente-analista preenche a recomendação de outcome quando o runtime de agente existir."
					rationale:   "A triagem não é origem net-new (contraste deliberado com a submissão): tudo que a decisão consome já é estado do sistema — o default da lei aplica."
				}
				rationale: "A 2ª action da mesma família (WI-156): a decisão do comprador sobre a fila — mesmo aggregate, mesmo lifecycle, nenhum VO novo (outcome/triagedBy/narrative são primitivos)."
			}]
			readSurfaces: [{
				queryRef:   "qry-pending-requisitions"
				view:       "triage-queue"
				viewRegime: "hand-grandfathered"
				rationale:  "A fila de triagem da 2ª família: query capability FORMAL (qry-pending-requisitions) com view em regime hand declarado ANTES do adr-180 (v2.1: 'a view do GET é espelho HAND no frontend-runtime, não-contrato — precedente escalated-queue.ts'). Dívida tipada: migra a generated em fatia própria, sem retrabalho acoplado à promoção (adr-180 alternativa (c) rejeitada)."
			}]
			rationale: "Domínio P2P é a fonte da superfície de tipos da 2ª família (adr-178 + WI-156): submissão (origem net-new, migração def-081) + triagem (decisão com outcome) + o enum COMPLETO do lifecycle para a fila (a tela do FCE precisava de 1 estado-gatilho; esta precisa dos 6 — #PurchaseRequisitionState nos schemas, rtd-013). Recorte espelha contexts/p2p/api.yaml (3 paths)."
		}

		// ── Família 3 (v3, adr-180): o mapa de cotações do ssc — a 1ª
		// família READ-ONLY (o gatilho da promoção) e a 1ª view GERADA.
		"ssc-quotation-map": {
			kind:              "read-only"
			boundedContextRef: "ssc"
			sourceModel:       "contexts/ssc/domain-model.cue"
			readSurfaces: [{
				queryRef:   "qry-quotation-map"
				view:       "QuotationMapView"
				viewRegime: "generated"
				rationale:  "A 1ª view do regime GERADO (adr-180 dec 3: a partir da 3ª família, generated é o regime — fim do hand-espelho para famílias novas). A view mais rica do arco: cotações lado a lado com equalização TCO DERIVADA deterministicamente + carimbo de decisão (ranking evaluatedSuppliers, tradeoffs, fitnessRuleSnapshot) — exatamente onde espelho-hand divergiria do contrato mais caro. Superfície HTTP: GET /v1/ssc/queries/quotation-map/{rfqId} (contexts/ssc/api.yaml, molde by-id do FCE)."
			}]
			rationale: "A 3ª família — o gatilho que executou a promoção (adr-178 D3): o mapa de cotações, a comparação consolidada que o comprador usa para escolher (prj-quotation-map/qry-quotation-map, WI-152; passo do mapa da ds-buyer-procurement-journey). READ-ONLY genuína: o recorte não expõe command algum — a não-aplicabilidade do action-surface é POR SHAPE (o campo actions não existe no ramo; mandato adr-179). Confidencialidade competitiva: superfície de comprador/supervisor/auditoria — NUNCA de fornecedor (os events de cotação são internal; NTF não propaga o mapa)."
		}
	}

	// CONTRACT-GATE REFORÇADO -- frontend-scoped, sobre o ContractGate de adr-140.
	// As capabilities fecham os 3 buracos do codegen do mesh-runtime (rtd-014/017/018)
	// como REQUISITO VINCULANTE; o MECANISMO é runtime-local. NÃO retroage no
	// mesh-runtime (cujos buracos seguem dívida runtime-local própria).
	contractGate: {
		authority: "adr-158 (reforço frontend-scoped sobre o ContractGate de adr-140 item 5)"
		binding:   "REQUISITO VINCULANTE: o build do frontend-runtime CI falha sem as 3 capabilities; enforcement build-failing materializado quando o mecanismo é construído (não na spec)."
		validates: [
			"shape: cue vet sobre a view da superfície consumida (por família: FCE v1, P2P v2 per adr-178, SSC v3 per adr-180)",
			"poda-de-órfãos: detectar REMOÇÃO de artefato consumido de qualquer família -- gerado sem fonte é erro, não verde silencioso (fecha buraco i do mesh-runtime, rtd-014)",
			"hand-compile: compilar o HAND (a tela) contra o gerado ANTES de declarar verde -- quebra de tela contra contrato novo falha o build NO runtime, não só no pipeline do spec (fecha buraco ii, rtd-017)",
			"revalidação-no-avanço-da-spec: superfície de qualquer família avançando na spec-main DEVE poder disparar revalidação do runtime (fecha buraco iii, rtd-018)",
			"piso-herdado (DEFESA-EM-PROFUNDIDADE): o piso (breach não-overridável) é garantido PRIMARIAMENTE pelo domínio (vo-overridden-guard-conditions sem flag cripto + cmd alcançável só de escalated, ao qual breach nunca chega por inv-breach-bypasses-escalation), herdado à superfície por geração fiel (P14); este check verifica que o gerado NÃO excede o domínio -- defesa contra gerador INFIEL que adicionasse um caminho, não a garantia primária",
		]
		mechanism:           "runtime-local (fronteira adr-158; pós-decomposição adr-159 não há def único para o mecanismo do gate — o COMO pertence ao frontend-runtime): repository_dispatch vs cron para o trigger; poda via git vs checksum; em qual job compila o hand. O gate declara a CAPACIDADE e ONDE ela roda, não o COMO."
		breakOnSchemaChange: "superfície de qualquer família incompatível com a forma declarada (P14) = build failure no frontend-runtime CI"
		runsIn:              "frontend-runtime CI"
		scope:               "frontend-scoped: NÃO retroage no mesh-runtime (buracos i/ii/iii seguem dívida runtime-local própria, rtd-014/017/018)"
	}

	// OUTPUT -- onde vive (nunca aqui).
	output: {
		artifacts: [
			"domain-types da superfície FCE", "enum de lifecycle do Payment", "definição de ação do override",
			"domain-types da superfície P2P (submissão)", "enum de lifecycle da PurchaseRequisition", "definição de ação da submissão (origem net-new, adr-178)",
			"definição de ação da triagem (decisão com outcome, WI-156)",
			"view gerada do mapa de cotações (QuotationMapView — 3ª família, 1ª view no regime generated, adr-180)",
		]
		livesIn:       "frontend-runtime"
		committedHere: false // P1 estrito: gerado NUNCA committado no mesh-spec
		goldenExample: "FCE (1ª família): materializado -- superfície gerada e compilada no frontend-runtime (contexts/fce-generated, pin armado); o flip formal a accepted aguarda o harness do def-065. P2P (2ª família, adr-178): pendente -- materializa no 1º run do gerador que estenda o discovery à superfície P2P e compile. SSC (3ª família, adr-180): pendente -- materializa no 1º run do gerador que produza a QuotationMapView (1ª view no regime generated) e compile."
	}

	// FRONTEIRAS ATIVAS -- deferrals VIVOS que este contrato pressupõe.
	// def-060 SAIU (withdrawn per adr-159 — a decomposição vive em
	// def-066/067/068, nenhum dos quais é pressuposto DESTE contrato);
	// def-081 ENTROU (pressuposto da família p2p: a migração da origem
	// net-new da submissão). Lista verificada por STATUS (open/triggered)
	// contra architecture/deferred-decisions/ — existência de arquivo não
	// basta (per PG do tipo, reconciliation pair 4).
	activeBoundaries: ["def-064", "def-065", "def-081"]

	rationale: "Autorizado por adr-158 (esta relação de codegen) sobre adr-140/146 (contrato/P14) + adr-150 (lei) + adr-155 (domínio FCE) + adr-178 (2ª família P2P) + adr-179 (mandato da promoção) + adr-180 (a promoção executada). Materializa P1 (superfície de frontend gerada da spec, nunca escrita à mão, nunca committada aqui) com fidelidade de forma P14 (a geração preserva as distinções compile-time do domínio). Nasce proposed = hipótese CUE->superfície-de-frontend falsificável, validada por golden-example por evidência spec-side + flip do founder (harness em def-065; molde adr-140, run-001). Fronteira QUE=spec (superfície + gate + P1-estrito) / COMO=runtime (linguagem-alvo + forma/sintaxe + gerador + stack — pós-decomposição adr-159: vendors vivos em def-066/067/068; linguagem/forma runtime-local sem def pendente). V3 (adr-180): o contrato re-expresso como instância TIPADA de #FrontendCodegenContract — 3 famílias por capacidade (fce-override action-bearing/dinheiro-move; p2p-journey-start action-bearing/net-new+system; ssc-quotation-map read-only/view gerada), exclusão mútua por shape, 3 slots do adr-179 por construção, grandfathering TIPADO das 2 views hand pré-adr-180 (dívida visível, migrável por fatia própria). Rust WASM (FF-FE-05) governada por adr-150 item 6, apontada não re-decidida."
}
