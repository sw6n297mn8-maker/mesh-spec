package build_time

// frontend-codegen-contract.cue -- Contrato declarativo de codegen spec->frontend-runtime (adr-158).
//
// STATUS: V1 PROPOSED -- hipótese falsificável (CUE->TS); migra para accepted no
// 1º golden-example do frontend-runtime que gere a superfície FCE e compile TS
// (molde adr-140, que nasceu proposed e flipou no run-001). Enquanto proposed,
// nenhum gerado existe (o frontend-runtime não nasceu). def-064 observa este flip
// como sinal do 2º runtime real.
//
// AUTORIZADO POR: adr-158 (esta relação de codegen) + adr-157 (handoff/morada do
// frontend-runtime) + adr-150 (lei AI-first + FF-FE) + adr-155 (domínio FCE do
// override). Schema-exempt pelo mesmo precedente de codegen-contract.cue (sem
// #Type/_schema.location; precedente subagent-execution-log). Promoção a schema só
// se >1 família de frontend o exigir.
//
// ESCOPO: contrato DECLARATIVO (mapa inputs->outputs) da família TS de domain-types.
// A família Rust WASM (paridade de cálculo cliente/servidor, FF-FE-05) é governada
// por adr-150 item 6 (sob adr-147) -- este contrato APONTA, não re-decide. Output
// vive no frontend-runtime, nunca committado aqui (P1 estrito). Forma TS = runtime-
// local (def-060).

frontendCodegenContract: {
	version: "v1"

	// Nasce proposed (hipótese CUE->TS); migra para accepted no 1º golden-example do
	// frontend que gere a superfície FCE e compile (molde adr-140).
	status: "proposed"

	authorizedBy: ["adr-158", "adr-157", "adr-150", "adr-155"]

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
		// Semântica de UX: a lei AI-first que a superfície gerada obedece.
		uxSemantics: {
			source:    "architecture/adrs/adr-150-frontend-ai-first-invariants.cue"
			provides:  ["Approval-as-Confirmation", "Generative Form", "Action-as-Tool"]
			rationale: "A lei do adr-150 que a superfície honra: ação financeira termina em botão estruturado (Approval-as-Confirmation, P10), form pré-preenchido pelo agente (Generative Form), ação = botão+tool de uma definição (Action-as-Tool). APONTA, não copia."
		}
	}

	// (2) TRANSFORM -- estágios declarativos (de -> para + ADR que autoriza); NÃO engine.
	// O "to" descreve a CAPACIDADE (tipos que preservam as distinções do domínio, P14),
	// NÃO a sintaxe TS (forma = runtime-local, def-060).
	transform: [
		{
			stage:     "domain-types"
			from:      "contexts/fce/domain-model.cue (cmd-resolve-guard-escalation + vo-supervisor-id + vo-overridden-guard-conditions + os 3 events)"
			to:        "tipos de frontend que PRESERVAM as distinções compile-time-verificáveis do domínio (P14): value-class inescapável para os VOs, presença non-null dos campos required, union fechada onde o domínio fecha. A CAPACIDADE, não a sintaxe TS."
			authority: "adr-146 (P14) + adr-158"
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
			to:        "a definição de ação (botão humano = tool de agente, de UMA definição) que TERMINA em confirmação estruturada, com form pré-preenchível pelos campos do command -- a CAPACIDADE de Approval-as-Confirmation na superfície, não o componente TS."
			authority: "adr-150 + adr-158"
		},
	]

	// (3) OUTPUT -- onde vive (nunca aqui).
	output: {
		artifacts:     ["domain-types da superfície FCE", "enum de lifecycle do Payment", "definição de ação do override"]
		livesIn:       "frontend-runtime"
		committedHere: false // P1 estrito: gerado NUNCA committado no mesh-spec
		goldenExample: "pendente -- materializa no 1º run do frontend-runtime que gere a superfície FCE e compile TS; até lá nenhum gerado existe (frontend-runtime inexistente)"
	}

	// (4) CONTRACT-GATE REFORÇADO -- frontend-scoped, sobre o ContractGate de adr-140.
	// As 3 capabilities fecham os 3 buracos do codegen do mesh-runtime (rtd-014/017/018)
	// como CAPACIDADES declaradas; o MECANISMO é runtime-local (def-060). NÃO retroage no
	// mesh-runtime (cujos buracos seguem dívida runtime-local própria).
	contractGate: {
		authority: "adr-158 (reforço frontend-scoped sobre o ContractGate de adr-140 item 5)"
		validates: [
			"shape: cue vet sobre a view da superfície FCE consumida",
			"poda-de-órfãos: detectar REMOÇÃO de artefato FCE consumido -- gerado sem fonte é erro, não verde silencioso (fecha buraco i do mesh-runtime, rtd-014)",
			"hand-compile: compilar o HAND (a tela) contra o gerado ANTES de declarar verde -- quebra de tela contra contrato novo falha o build NO runtime, não só no pipeline do spec (fecha buraco ii, rtd-017)",
			"revalidação-no-avanço-da-spec: a superfície FCE avançando na spec-main DEVE poder disparar revalidação do runtime (fecha buraco iii, rtd-018)",
			"piso-herdado: a superfície gerada NÃO introduz caminho que o domínio não tem -- vo-overridden-guard-conditions SEM flag de integridade-criptográfica propaga, logo a tela não pode oferecer override de breach (o gate verifica que o gerado não excede o domínio)",
		]
		mechanism:           "runtime-local (def-060): repository_dispatch vs cron para o trigger; poda via git vs checksum; em qual job compila o hand. O gate declara a CAPACIDADE; o frontend-runtime escolhe o mecanismo."
		breakOnSchemaChange: "superfície FCE incompatível com a forma declarada (P14) = build failure no frontend-runtime CI"
		runsIn:              "frontend-runtime CI"
		scope:               "frontend-scoped: NÃO retroage no mesh-runtime (buracos i/ii/iii seguem dívida runtime-local própria, rtd-014/017/018)"
	}

	// (5) FRONTEIRAS ATIVAS -- deferrals que este contrato pressupõe.
	activeBoundaries: ["def-060", "def-064"]

	rationale: "Autorizado por adr-158 (esta relação de codegen) sobre adr-140/146 (contrato/P14) + adr-150 (lei) + adr-155 (domínio). Materializa P1 (superfície de frontend gerada da spec, nunca escrita à mão, nunca committada aqui) com fidelidade de forma P14 (a geração preserva as distinções compile-time do domínio FCE). Nasce proposed = hipótese CUE->TS falsificável, validada pelo 1º golden-example do frontend (molde adr-140, run-001). Fronteira QUE=spec (superfície + gate + P1-estrito) / COMO=runtime (forma TS + linguagem do gerador + stack, def-060). Família TS escopada; Rust WASM (FF-FE-05) governada por adr-150 item 6, apontada não re-decidida."
}
