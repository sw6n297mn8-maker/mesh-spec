package build_time

// session-log-fce-override-cross-repo.cue — Meta-aprendizados de processo da
// frente FCE override cross-repo (adr-154 critério de repos -> def-060 triggered
// -> adr-155 override humano do PrePaymentGuard -> materialização estágio-1:
// mesh-spec domain-model + mesh-runtime catch-up). Registro V1-simples no
// schemaExemptZone governance/build-time/ — mesmo padrão de session-log-adr-151
// (precedente subagent-execution-log/worklist: "V1 simples sem schema quando o
// volume não justifica; formalizar como tipo só quando recorrência justifique").
// NÃO é tipo governado: sem schema, sem ADR, sem SRR.
//
// Propósito: reuso em frentes futuras de materialização cross-repo spec<->runtime
// e coordenação sob deadlock estrutural de codegen. Cada learning carrega lição +
// evidência + aplicabilidade. IDs continuam a sequência GLOBAL do session-log do
// adr-151 (ln-01..ln-04) — aqui ln-05..ln-08 — para evitar colisão.

sessionLogFceOverrideCrossRepo: {
	arc:  "Recuperação do fio da decisão de frontend (origem da pergunta sobre Payment) -> destravamento da frente via adr-154 (critério de repos) -> def-060 triggered -> adr-155 (override humano do PrePaymentGuard) -> materialização cross-repo (mesh-spec domain-model + mesh-runtime catch-up)."
	date: "2026-06-18"

	learnings: [{
		id:            "ln-05"
		title:         "Coordenação cross-repo sob deadlock estrutural"
		lesson:        "Quando spec e runtime se acoplam via codegen sem pin (CI do runtime faz checkout da spec-main live), \"os dois repos verdes antes de qualquer merge\" é topologicamente impossível — cada PR depende do main do outro. Saída: spec-first, com o codegen-validation aceito como INFORMACIONAL (adr-148: exit codes informam, veredito por causa-raiz é do founder), o patch do runtime pronto-e-aprovado ANTES do merge da spec, e os 2 merges em sequência contígua para minimizar a janela de runtime-main-vermelho."
		evidence:      "Materialização adr-155 — #168 (spec) e #12 (runtime) mergeados em sequência, janela de minutos; deadlock mapeado: o codegen-validation do #168 faz checkout do runtime-main, e o regenerate-check do PR-runtime faz checkout do spec-main."
		applicability: "Toda materialização futura que toque contexts/** e dispare codegen-validation."
	}, {
		id:            "ln-06"
		title:         "O codegen-validation pega o que o cue vet não vê"
		lesson:        "cue vet valida a FORMA da spec; o codegen-validation valida que a spec GERA CÓDIGO QUE COMPILA contra o runtime. Camadas distintas — spec pode passar cue vet e deixar o runtime não-exaustivo. Verificar com mesh-codegen pipeline (compila gerado+hand), nunca generate+grep (rtd-017)."
		evidence:      "A materialização passou cue vet / runner / self-review e mesmo assim o codegen-validation #168 ficou vermelho (when não-exaustivo no PaymentSlice)."
		applicability: "A fronteira spec<->runtime é camada de validação própria, não coberta pelo verde da spec."
	}, {
		id:            "ln-07"
		title:         "Gate que só olha quando provocado deixa drift crescer no silêncio"
		lesson:        "O FF-CG-03 da main do runtime só re-roda com push no runtime — não quando a spec-main muda sozinha. Uma drift spec<->runtime-baseline pode acumular sem detecção entre acionamentos. É a tese da Mesh aplicada ao próprio repo: a malha pega o que o operador deixa passar, mas só se acionada; gates passivos têm pontos cegos entre acionamentos."
		evidence:      "O baseline do runtime estava estale em eligibility desde o #11 (carregava EligibilityEmitted* já removido da spec-main); pego DE CARONA ao regenerar pelo adr-155; rtd-018 registra."
		openQuestion:  "Como detectar drift spec-main<->runtime-baseline sem depender de push no runtime?"
		applicability: "Gates passivos (só-on-push) têm pontos cegos; mudanças upstream-only não os acionam."
	}, {
		id:            "ln-08"
		title:         "Inércia verificada, não assumida (fronteira nível-1)"
		lesson:        "Num PR de gate de dinheiro, \"parece tipos não-usados\" não basta — a inércia de uma mudança de carona tem que ser PROVADA (grep no hand + pipeline + testes), não lida como plausível. Senão um cleanup não-auditado viaja no commit do gate sem escrutínio."
		evidence:      "O Check 1 do cleanup de eligibility achou um hit real (RewNumberAxisTest usa EligibilityDecisionKind) que parecia órfão — rastrear confirmou que resolve para a cópia REW sobrevivente, não a duplicata FCE removida; pipeline 36/36."
		applicability: "Em fronteira nível-1, mudanças de carona exigem verificação própria antes de entrar no commit auditado."
	}]

	arcInNumbers: {
		frente:         "adr-154 (critério de repos) -> def-060 (open->triggered) -> adr-155 (override humano do PrePaymentGuard, proposed) -> materialização estágio-1 (domain-model FCE + runtime catch-up)"
		prsMeshSpec:    "#165 (session-log adr-151), #166 (def-060 triggered), #167 (adr-155 ADR), #168 (materialização domain-model)"
		prsMeshRuntime: "#12 (catch-up: regen 7-guard + 2 guards dormentes fail-closed + cleanup eligibility de carona)"
		adr155Status:   "proposed — estágio 2 (agente FCE / oq-fce-3 + evolução do codegen para outcome-split + freeze-routing) ratifica para accepted"
		driftCorrigida: "EligibilityEmitted* stale no baseline do runtime desde #11, removida de carona, registrada em rtd-018"
		repos:          "mesh-spec main 2c89c5e (7-guard) / mesh-runtime main a9515e2 (committed 7-guard); ambos verdes"
	}
}
