package build_time

// frontend-codegen-contract.cue -- Contrato declarativo de codegen spec->frontend-runtime (adr-158).
//
// V2 (adr-178): +2ª família de superfície (p2pSurface — o início da jornada:
// submissão de requisição + fila de triagem). Extensão IN-PLACE deliberada
// (adr-178 D3): a promoção a schema first-class é ESPERADA na 3ª família (o
// mapa de cotações do ssc) — gatilho nomeado, decisão prevista, não surpresa.
// Conteúdo obrigatório da promoção pré-fixado per adr-179 — ver schemaPromotionMandate.
//
// V2.1 (WI-156): família p2p estendida IN-PLACE com a superfície da TRIAGEM
// (cmd-triage-requisition + evt-purchase-requisition-triaged + action-surface
// da decisão com outcome). MESMA família — não é a 3ª; o gatilho da promoção
// permanece adr-178 D3 (mapa de cotações), inalterado.
//
// STATUS: PROPOSED -- hipótese falsificável (CUE->superfície-de-frontend); o flip a accepted
// é por EVIDÊNCIA spec-side (precedente codegen-validation-evidence.cue + revisão de
// causa-raiz do founder + write-back gated, adr-148 item 8); o HARNESS que produz essa
// evidência é deferido em def-065 (prerequisite downstream, não pendurado). A superfície
// FCE (v1) JÁ foi gerada e compilou no frontend-runtime (pin armado); o flip formal segue
// aguardando o harness do def-065. def-064 observa este flip como sinal do 2º runtime real.
//
// AUTORIZADO POR: adr-158 (esta relação de codegen) + adr-157 (handoff/morada do
// frontend-runtime) + adr-150 (lei AI-first + FF-FE) + adr-155 (domínio FCE do
// override) + adr-178 (2ª família: superfície P2P do início da jornada + origem
// net-new). Schema-exempt pelo mesmo precedente de codegen-contract.cue (sem
// #Type/_schema.location; precedente subagent-execution-log). Promoção a schema
// esperada quando a 3ª família (mapa de cotações) chegar — per adr-178.
//
// ESCOPO: contrato DECLARATIVO (mapa inputs->outputs) da família de domain-types de
// frontend. O QUE o contrato fixa é a CAPACIDADE da superfície (agnóstica de linguagem,
// P14); a LINGUAGEM-ALVO e a FORMA/sintaxe são runtime-local (def-060), não nomeadas
// aqui. A família Rust WASM
// (paridade de cálculo cliente/servidor, FF-FE-05) é governada por adr-150 item 6 (sob
// adr-147) -- este contrato APONTA, não re-decide. Output vive no frontend-runtime,
// nunca committado aqui (P1 estrito).

frontendCodegenContract: {
	version: "v2"

	// Nasce proposed (hipótese CUE->superfície-de-frontend); migra para o estado validado no 1º golden-example
	// do frontend, por evidência spec-side + decisão do founder (harness em def-065; molde
	// adr-140). O flip deste campo no golden-example é o sinal observado por def-064.
	status: "proposed"

	authorizedBy: ["adr-158", "adr-157", "adr-150", "adr-155", "adr-178", "adr-179"]

	// (1) INPUTS -- consumidos read-only; APONTA por path/id (P0), nunca copia.
	inputs: {
		// Domínio FCE: a superfície que a 1ª tela gera. Source canônico do override.
		domainModel: {
			source:   "contexts/fce/domain-model.cue"
			provides: ["command", "valueObject", "event", "aggregateLifecycleState"]
			// Superfície FCE concreta da 1ª fatia (codes/ids, não cópia):
			fceSurface: {
				command:        "cmd-resolve-guard-escalation"
				valueObjects:   ["vo-supervisor-id", "vo-overridden-guard-conditions"]
				events:         ["evt-payment-guard-escalated", "evt-payment-guard-overridden", "evt-payment-guard-override-refused"]
				aggregate:      "agg-payment"
				lifecycleState: "escalated"
			}
			rationale: "Domínio FCE é a fonte da superfície de tipos da tela; a 1ª fatia gera exatamente cmd-resolve-guard-escalation + os 2 VOs + estado escalated + os 3 events. Mesma superfície que o mesh-runtime já gera em Kotlin (rtd-018)."
		}
		// Domínio P2P: a 2ª família de superfície (adr-178 — o início da
		// jornada: submissão de requisição + fila de triagem).
		domainModelP2p: {
			source:   "contexts/p2p/domain-model.cue"
			provides: ["command", "valueObject", "event", "aggregateLifecycleState"]
			// Superfície P2P concreta da 2ª família (codes/ids, não cópia):
			p2pSurface: {
				command:      "cmd-submit-purchase-requisition"
				valueObjects: ["vo-requisition-id", "vo-category-ref", "vo-purchase-scope"]
				events:       ["evt-purchase-requisition-submitted"]
				// Triagem (WI-156): o 2º command da família — a decisão do
				// comprador sobre a fila. Mesmo aggregate, mesmo lifecycle;
				// nenhum VO novo (outcome/triagedBy/narrative são primitivos).
				triageCommand: "cmd-triage-requisition"
				triageEvent:   "evt-purchase-requisition-triaged"
				aggregate:    "agg-purchase-requisition"
				// Disjunção COMPLETA do lifecycle (a fila mostra estados; a tela
				// do FCE precisava de 1 estado-gatilho, esta precisa do enum
				// inteiro — #PurchaseRequisitionState nos schemas).
				lifecycleStates: ["submitted", "triaged", "approved", "converted", "rejected", "cancelled"]
				// A fila de triagem (qry-pending-requisitions) segue o REGIME DA
				// 1ª FAMÍLIA: a view do GET é espelho HAND no frontend-runtime
				// (não-contrato; precedente escalated-queue.ts da tela FCE), não
				// superfície gerada. Incluir views de query no codegen é decisão
				// da promoção a schema (3ª família, adr-178) — não antecipada aqui.
				query: "qry-pending-requisitions"
			}
			rationale: "Domínio P2P é a fonte da superfície de tipos da 2ª tela-família: o command da submissão (origem net-new per adr-178; migração def-081) + o evento-confirmação que o POST devolve + o enum completo do lifecycle para a fila. Recorte espelha contexts/p2p/api.yaml (adr-178); mesma superfície que o mesh-runtime passa a gerar em Kotlin via discovery rtd-013 (schemas + manifests da mesma fatia). A triagem (WI-156) estende a mesma família: o command da decisão do comprador e seu evento-confirmação — o recorte segue espelhando contexts/p2p/api.yaml, agora com 3 paths."
		}
		// Semântica de UX: a lei AI-first que a superfície gerada obedece.
		uxSemantics: {
			source:    "architecture/adrs/adr-150-frontend-ai-first-invariants.cue"
			provides:  ["Approval-as-Confirmation", "Generative Form", "Action-as-Tool"]
			rationale: "A lei do adr-150 que a superfície honra: ação financeira termina em botão estruturado (Approval-as-Confirmation, P10), form pré-preenchido pelo agente (Generative Form), ação = botão+tool de uma definição (Action-as-Tool). APONTA, não copia."
		}
	}

	// (2) TRANSFORM -- estágios declarativos (de -> para + ADR que autoriza); NÃO engine.
	// O "to" descreve a CAPACIDADE (tipos que preservam as distinções do domínio, P14),
	// NÃO a forma/sintaxe da linguagem-alvo (runtime-local, def-060).
	transform: [
		// ── Família 1: superfície FCE (v1, adr-158) ──
		{
			stage:     "domain-types"
			from:      "contexts/fce/domain-model.cue (cmd-resolve-guard-escalation + vo-supervisor-id + vo-overridden-guard-conditions + os 3 events)"
			to:        "tipos de frontend que PRESERVAM as distinções compile-time-verificáveis do domínio (P14): value-class inescapável para os VOs, presença non-null dos campos required, union fechada onde o domínio fecha. A CAPACIDADE, não a forma/sintaxe da linguagem-alvo."
			authority: "adr-146 (P14) + adr-158"
			// Transparência (propriedade do domínio, não gap do contrato): o campo `decision`
			// de cmd-resolve-guard-escalation é type:"string" no domain-model -- o domínio NÃO
			// o fecha, então a superfície gerada emite `decision` ABERTO (string), não enum
			// fechado. É backlog P14 do domain-model (selar lá), NÃO do contrato: a 1ª sessão
			// NÃO inventa um tipo fechado que o domínio não tem (violaria P14 + o piso). A tela
			// conhece os 2 valores legais (approve|deny) das 2 transições do lifecycle.
			note: "decision gera aberto (string); selar é backlog P14 do domain-model, não gap do contrato."
		},
		{
			stage:     "lifecycle-state"
			from:      "agg-payment lifecycle (estado escalated + transições via cmd-resolve-guard-escalation)"
			to:        "enum/union fechado do estado do Payment (guarded/escalated/authorized/refused) de modo que a tela só possa acionar transições que o domínio declara -- adicionar um estado sem tratá-lo não compila (P14)."
			authority: "adr-155 + adr-158"
		},
		{
			stage:     "action-surface"
			from:      "cmd-resolve-guard-escalation + adr-150 (Action-as-Tool, Generative Form, Approval-as-Confirmation)"
			to:        "a definição de ação (botão humano = tool de agente, de UMA definição) que TERMINA em confirmação estruturada, com form pré-preenchível pelos campos do command -- a CAPACIDADE de Approval-as-Confirmation na superfície, não o componente concreto."
			authority: "adr-150 + adr-158"
		},
		// ── Família 2: superfície P2P do início da jornada (v2, adr-178) ──
		{
			stage:     "domain-types-p2p"
			from:      "contexts/p2p/domain-model.cue (cmd-submit-purchase-requisition + vo-requisition-id/vo-category-ref/vo-purchase-scope + evt-purchase-requisition-submitted)"
			to:        "tipos de frontend que PRESERVAM as distinções compile-time-verificáveis do domínio (P14): value-class inescapável para os VOs, presença non-null dos campos required, decimal-como-string (Ion-4) para estimatedVolume. A CAPACIDADE, não a forma/sintaxe da linguagem-alvo."
			authority: "adr-146 (P14) + adr-178"
		},
		{
			stage:     "lifecycle-state-p2p"
			from:      "agg-purchase-requisition lifecycle (6 estados: submitted/triaged/approved/converted/rejected/cancelled)"
			to:        "enum/union fechado do estado da PurchaseRequisition de modo que a fila só possa rotular estados que o domínio declara -- adicionar um estado sem tratá-lo não compila (P14). Reusa #PurchaseRequisitionState dos schemas (schemas-preference, rtd-013)."
			authority: "adr-174 + adr-178"
		},
		{
			stage: "action-surface-p2p"
			from:  "cmd-submit-purchase-requisition + adr-150 (Action-as-Tool, Generative Form) + adr-178 (origem net-new)"
			to:    "a definição de ação da submissão (botão humano = tool de agente, de UMA definição) que termina em confirmação estruturada devolvendo o evento emitido. O form nasce com o SHAPE da Generative Form (pré-preenchível campo a campo); o CONTEÚDO de origem é hoje digitação humana LEGÍTIMA per adr-178 (não-padrão net-new: o cronograma físico não existe no sistema até a observação do engenheiro) — quando o cronograma virar input de sistema, o preenchedor-agente entra sem mudança de shape (def-081)."
			// Transparência (propriedade do domínio, não gap do contrato): a
			// submissão NÃO é ação financeira — Approval-as-Confirmation não é
			// exigida aqui (nenhum dinheiro move); a confirmação estruturada
			// devolvendo o evento é disciplina de superfície, não P10-gate.
			authority: "adr-150 + adr-178"
		},
		{
			stage: "action-surface-p2p-triage"
			from:  "cmd-triage-requisition + adr-150 (Action-as-Tool, Generative Form) + adr-174/adr-160 (outcome-split: routed-to-sourcing | returned | rejected)"
			to:    "a definição de ação da triagem (botão humano = tool de agente, de UMA definição) que termina em confirmação estruturada devolvendo PurchaseRequisitionTriaged. outcome viaja ABERTO (P14: o domínio não fecha — o espelho não inventa enum; a tela conhece os 3 valores legais pelo domain-model); narrative obrigatória em returned/rejected é invariante de handler — a superfície reflete a obrigação por comportamento, não por shape. Form pré-preenchível campo a campo a partir do ITEM DA FILA (seleção na tela da fila): a triagem NÃO é origem net-new — a informação já vive no sistema; Generative Form PADRÃO da adr-150 aplica sem exceção, e o agente-analista preenche a recomendação quando o runtime de agente existir."
			// Transparência (propriedade do domínio, não gap do contrato): a
			// triagem NÃO é ação financeira — nenhum dinheiro move (a reserva
			// de cobertura pertence ao cmd-approve-purchase, fatia futura);
			// Approval-as-Confirmation não é exigida (adr-150 dec 2c).
			authority: "adr-150 + adr-174 + adr-178"
		},
	]

	// (3) OUTPUT -- onde vive (nunca aqui).
	output: {
		artifacts: [
			"domain-types da superfície FCE", "enum de lifecycle do Payment", "definição de ação do override",
			"domain-types da superfície P2P (submissão)", "enum de lifecycle da PurchaseRequisition", "definição de ação da submissão (origem net-new, adr-178)",
			"definição de ação da triagem (decisão com outcome, WI-156)",
		]
		livesIn:       "frontend-runtime"
		committedHere: false // P1 estrito: gerado NUNCA committado no mesh-spec
		goldenExample: "FCE (1ª família): materializado -- superfície gerada e compilada no frontend-runtime (contexts/fce-generated, pin armado); o flip formal a accepted aguarda o harness do def-065. P2P (2ª família, adr-178): pendente -- materializa no 1º run do gerador que estenda o discovery à superfície P2P e compile."
	}

	// (4) CONTRACT-GATE REFORÇADO -- frontend-scoped, sobre o ContractGate de adr-140.
	// As 3 capabilities fecham os 3 buracos do codegen do mesh-runtime (rtd-014/017/018)
	// como REQUISITO VINCULANTE; o MECANISMO é runtime-local (def-060). NÃO retroage no
	// mesh-runtime (cujos buracos seguem dívida runtime-local própria).
	contractGate: {
		authority: "adr-158 (reforço frontend-scoped sobre o ContractGate de adr-140 item 5)"
		// As capabilities são VINCULANTES: o build do frontend-runtime CI falha sem elas.
		// Enforcement build-failing (real), mas materializa quando o runtime constrói o
		// mecanismo -- não ativo na spec hoje (adr-158 N4 own a janela).
		binding: "REQUISITO VINCULANTE: o build do frontend-runtime CI falha sem as 3 capabilities; enforcement build-failing materializado quando o mecanismo é construído (não na spec)."
		validates: [
			"shape: cue vet sobre a view da superfície consumida (por família: FCE v1, P2P v2 per adr-178)",
			"poda-de-órfãos: detectar REMOÇÃO de artefato consumido de qualquer família -- gerado sem fonte é erro, não verde silencioso (fecha buraco i do mesh-runtime, rtd-014)",
			"hand-compile: compilar o HAND (a tela) contra o gerado ANTES de declarar verde -- quebra de tela contra contrato novo falha o build NO runtime, não só no pipeline do spec (fecha buraco ii, rtd-017)",
			"revalidação-no-avanço-da-spec: superfície de qualquer família avançando na spec-main DEVE poder disparar revalidação do runtime (fecha buraco iii, rtd-018)",
			"piso-herdado (DEFESA-EM-PROFUNDIDADE): o piso (breach não-overridável) é garantido PRIMARIAMENTE pelo domínio (vo-overridden-guard-conditions sem flag cripto + cmd alcançável só de escalated, ao qual breach nunca chega por inv-breach-bypasses-escalation), herdado à superfície por geração fiel (P14); este check verifica que o gerado NÃO excede o domínio -- defesa contra gerador INFIEL que adicionasse um caminho, não a garantia primária",
		]
		mechanism:           "runtime-local (def-060): repository_dispatch vs cron para o trigger; poda via git vs checksum; em qual job compila o hand. O gate declara a CAPACIDADE; o frontend-runtime escolhe o mecanismo."
		breakOnSchemaChange: "superfície FCE incompatível com a forma declarada (P14) = build failure no frontend-runtime CI"
		runsIn:              "frontend-runtime CI"
		scope:               "frontend-scoped: NÃO retroage no mesh-runtime (buracos i/ii/iii seguem dívida runtime-local própria, rtd-014/017/018)"
	}

	// (5) FRONTEIRAS ATIVAS -- deferrals que este contrato pressupõe.
	// def-060 (stack/linguagem-alvo/forma), def-064 (ladder de auto-merge), def-065 (harness +
	// write-back de evidência que carrega o flip).
	activeBoundaries: ["def-060", "def-064", "def-065"]

	// (6) MANDATO DA PROMOÇÃO A SCHEMA -- conteúdo obrigatório pré-fixado da
	// promoção prevista em adr-178 D3 (3ª família). Âncora no ponto de uso
	// (técnica do def-081): quem tocar o contrato na chegada da 3ª família
	// reencontra o mandato sem depender de memória cross-sessão.
	schemaPromotionMandate: {
		authority: "adr-179"
		binding:   "Quando a promoção a schema first-class disparar (gatilho adr-178 D3 — não alterado nem complementado pelo adr-179), o schema DEVE exigir por família declaração estruturada de APLICABILIDADE do action-surface: família com command/ação mutável → bloco obrigatório com os três slots (par botão+tool de UMA definição; confirmação estruturada com Approval-as-Confirmation onde dinheiro move; Generative Form com prefill por campo + justificativa de origem net-new); família legitimamente sem ação → não-aplicabilidade declarada por shape tipado, sem action-surface vazio ou placeholder."
		rationale: "Resumo operacional com ponteiro (P0): o conteúdo canônico e completo vive no adr-179; este campo garante o reencontro do mandato no ponto de uso na chegada da 3ª família."
	}

	rationale: "Autorizado por adr-158 (esta relação de codegen) sobre adr-140/146 (contrato/P14) + adr-150 (lei) + adr-155 (domínio FCE) + adr-178 (2ª família P2P). Materializa P1 (superfície de frontend gerada da spec, nunca escrita à mão, nunca committada aqui) com fidelidade de forma P14 (a geração preserva as distinções compile-time do domínio). Nasce proposed = hipótese CUE->superfície-de-frontend falsificável, validada por golden-example por evidência spec-side + flip do founder (harness em def-065; molde adr-140, run-001). Fronteira QUE=spec (superfície + gate + P1-estrito) / COMO=runtime (linguagem-alvo + forma/sintaxe + gerador + stack, def-060); a linguagem-alvo é runtime-local (def-060), não decisão deste contrato. V2 (adr-178): 2ª família (P2P início da jornada) estendida IN-PLACE — a promoção a schema first-class é o gatilho NOMEADO da 3ª família (mapa de cotações), decisão prevista, não surpresa, com conteúdo obrigatório pré-fixado per adr-179 (schemaPromotionMandate); a view da fila segue o regime hand não-contrato da 1ª família até essa promoção. Rust WASM (FF-FE-05) governada por adr-150 item 6, apontada não re-decidida."
}
