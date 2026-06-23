package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-158 — Estabelece o contrato de codegen do frontend-runtime: a relação de
// geração spec→frontend-runtime que o adr-157 (handoff) deixou ao domínio sem
// contrato de geração (item 7). Irmão-frontend do adr-140/146 (que fundaram o
// codegen do mesh-runtime). Cria governance/build-time/frontend-codegen-contract.cue
// (schema-exempt, precedente codegen-contract.cue) + def-064 (defere a ladder de
// propagação) + def-065 (defere o harness de validação + write-back de evidência que
// carrega o flip). Status proposed: a relação CUE→superfície-de-frontend é hipótese falsificável, flipa a
// accepted no 1º golden-example do frontend — molde adr-140 (proposed até run-001),
// não adr-156 (same-commit accepted).

adr158: artifact_schemas.#ADR & {
	id:    "adr-158"
	title: "Estabelecer o contrato de codegen do frontend-runtime (superfície FCE)"
	date:  "2026-06-20"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		O GAP QUE O adr-157 DEIXOU. O adr-157 (handoff do frontend-runtime) fechou o
		contrato SEMÂNTICO da 1ª tela — o QUE ela confirma (adr-150, lei AI-first +
		Approval-as-Confirmation) e o domínio que aciona (adr-155 + contexts/fce/
		domain-model.cue) — mas conscientemente NÃO criou o contrato de GERAÇÃO
		(item 7, "aponta, não cria arquivo novo"). O princípio "o código de tela é
		derivado da spec" vive no principlesApplied P1 do adr-157 — ASSERTADO sem a
		máquina que o sustenta. Sem um contrato de codegen, a 1ª sessão do
		frontend-runtime teria que INFERIR a superfície de geração a partir do domínio —
		exatamente a inferência-silenciosa que o adr-157 item 8 proíbe ("SEM INFERIR
		SILENCIOSAMENTE decisões ausentes"). Este ADR fecha esse degrau: a relação de
		codegen nasce governada no spec, não inferida downstream.

		O PRECEDENTE — o mesh-runtime nasceu COM o contrato. adr-140 (contrato de
		codegen) + adr-146 (P14, fidelidade de forma) fundaram a relação de geração
		spec→mesh-runtime ANTES do repo nascer; governance/build-time/codegen-contract.cue
		materializou inputs→transform→output, P1-estrito (committedHere: false) e o
		ContractGate. O frontend espelha o precedente: a relação de codegen é CONTRATO
		(semântica governada pelo spec, adr-148 item 3), não convenção implícita a ser
		reconstruída na 1ª sessão.

		A SUPERFÍCIE É BATTLE-TESTED. Os inputs que a tela gera —
		cmd-resolve-guard-escalation (+ vo-supervisor-id, vo-overridden-guard-conditions),
		o estado escalated do agg-payment, e os 3 events (evt-payment-guard-escalated/
		-overridden/-override-refused) — são os MESMOS que o mesh-runtime já gera em
		Kotlin (rtd-018 do mesh-runtime: o enum PaymentGuard regenerou 5→7 com o override
		do adr-155). A hipótese ainda NÃO validada é só o ALVO da geração de frontend — CUE→superfície-de-frontend, não CUE→Kotlin (já provado no mesh-runtime) —,
		daí o status proposed até o 1º golden-example do frontend (molde adr-140, que
		nasceu proposed e flipou a accepted no run-001).

		A FRONTEIRA QUE=spec / COMO=runtime (adr-148 item 3). O spec decide a SUPERFÍCIE
		gerada (quais artefatos de domínio FCE viram tipos) + o gate + P1-estrito; o
		frontend-runtime decide o COMO — a linguagem do gerador, a FORMA/SINTAXE dos tipos,
		o componente, o stack — atrás da fronteira (def-060). O QUE o spec fixa é a
		CAPACIDADE da superfície (agnóstica de linguagem, P14: soma fechada, non-null,
		wrapper inescapável); a LINGUAGEM-ALVO e a FORMA/sintaxe concreta são runtime-local —
		este contrato NÃO as nomeia, e a falsificação
		(d) abaixo guarda precisamente contra o contrato re-nomear a linguagem. A família
		Rust WASM (paridade de cálculo cliente/servidor, FF-FE-05) JÁ é governada por
		adr-150 item 6 (fonte Rust única, sob adr-147): este contrato ESCOPA a família de
		domain-types de frontend e APONTA para adr-150 item 6 pela família Rust — não
		re-decide o que já existe.
		"""
	decision: """
		(1) CRIAR o contrato de codegen do frontend em
		governance/build-time/frontend-codegen-contract.cue, espelhando o
		codegen-contract.cue do mesh-runtime e schema-exempt pelo mesmo precedente
		(instanciação de adr-140/146/148 + adr-150 + este ADR; sem #Type/_schema.location,
		como subagent-execution-log; promoção a schema só se >1 família de frontend o
		exigir). Declara: inputs (domínio FCE de contexts/fce/domain-model.cue +
		semântica de form/ação de adr-150: Approval-as-Confirmation, Generative Form);
		transform[] (superfície FCE → tipos de frontend, cada estágio from/to/authority,
		SEM fixar a forma/linguagem = runtime); output (livesIn: frontend-runtime,
		committedHere: false [P1-estrito], goldenExample pendente até o 1º run do frontend).

		(2) REFORÇAR o contractGate, frontend-scoped, com TRÊS capabilities que o codegen
		do mesh-runtime não enforça por construção (são gaps de implementação dele,
		rtd-014/017/018) — as três viram REQUISITO VINCULANTE do contractGate (o build do
		frontend-runtime CI falha sem elas), não prosa aspiracional; o enforcement vive no
		runtime CI e materializa quando o mecanismo é construído (ver N4): (a) DETECTAR
		REMOÇÃO de artefato consumido (poda de órfãos) — remoção no spec é detectada, não
		silenciada por gerado órfão; (b) COMPILAR O HAND (a tela) contra o gerado ANTES de
		declarar verde — quebra de tela contra contrato novo falha o build NO runtime, não
		só no pipeline do spec; (c) REVALIDÁVEL no avanço da spec — capability do trigger
		(avanço da spec-main DEVE poder disparar revalidação do runtime). As três são
		CAPACIDADES declaradas; o MECANISMO (repository_dispatch vs cron; poda via git vs
		checksum; em qual job compila) é runtime-local (def-060). Frontend-scoped: NÃO
		retroage no mesh-runtime, cujos buracos seguem dívida runtime-local própria (rtd-018).

		(3) CRIAR def-064, que defere a LADDER DE PROPAGAÇÃO (níveis crescentes de
		automação do bump spec→runtime: detectar/preparar automático → auto-merge de
		verde sob critérios → live sem pin), com trade-off (custo evitado: governança
		especulativa de política multi-runtime com N=1 runtime real) e revisita (quando
		houver 2º runtime real — espelha a promoção-por-evidência do adr-154: regra
		mesh-local só universaliza com 2+ provando). A capability (c) do contractGate —
		revalidação no avanço da spec — NÃO é deferida: vive no gate agora; só a política
		de auto-merge defere.

		(4) NASCER proposed (este ADR e o contrato): a relação CUE→superfície-de-frontend é hipótese
		falsificável sem run validador (o frontend-runtime não existe). O flip
		proposed→accepted exige EVIDÊNCIA spec-side do 1º golden-example do frontend
		(precedente: codegen-validation-evidence.cue registrou o run-001 + revisão de
		causa-raiz do founder + write-back gated, adr-148 item 8 — o veículo do flip do
		adr-140). O HARNESS de codegen-validation + write-back de evidência do frontend é
		prerequisite downstream que o adr-157 NÃO estabeleceu — DEFERIDO em def-065 (a fonte
		da verdade do mecanismo; este ADR aponta, não descreve, para evitar duplicação). Molde
		adr-140 (proposed→accepted no run-001), não adr-156 (same-commit). O contrato nasce
		com status "proposed" + nota de migração tipada.

		ALTERNATIVAS CONSIDERADAS.
		(a) Não criar artefato agora; deixar a 1ª sessão do frontend-runtime criar o
		    contrato de codegen. REJEITADA: a relação de codegen mais crítica do sistema —
		    a tela ↔ o domínio que MOVE DINHEIRO sob supervisão BACEN — nasceria por
		    convenção implícita, e a 1ª sessão INFERIRIA a superfície (o degrau onde o erro
		    entra silencioso, vedado pelo adr-157 item 8). O mesh-runtime NÃO nasceu assim:
		    tinha codegen-contract.cue antes do bootstrap.
		(b) #RuntimeDecision no spec (schema para o log de decisões do runtime). REJEITADA:
		    o spec ditaria o FORMATO do log do runtime = tecnologia runtime-local, furando
		    a própria fronteira QUE=spec/COMO=runtime (adr-148 item 3 / filtro adr-139). O
		    formato do log é decisão do frontend-runtime.
		(c) ADR de política de propagação completa (a ladder como ADR agora). REJEITADA:
		    prematuro com N=1 runtime real (disciplina do adr-154: regra mesh-local só
		    promove com 2+ provando); vira def-064, não ADR.
		"""

	consequences: """
		Positivas.
		(P1c) A relação de codegen do frontend nasce GOVERNADA no spec, não inferida na 1ª
		sessão — a inferência-silenciosa que o adr-157 item 8 proíbe deixa de ter onde
		acontecer (o contrato declara a superfície em vez de a sessão adivinhá-la).
		(P2c) O princípio P1 do adr-157 ("código de tela derivado da spec") ganha a MÁQUINA
		que faltava: deixa de ser asserção em principlesApplied e vira contrato com
		inputs/transform/output + gate determinístico.
		(P3c) O gate nasce MAIS FORTE que o do mesh-runtime: os 3 buracos (rtd-014/017/018)
		viram REQUISITO VINCULANTE de gate frontend-scoped — o build do runtime CI falha sem
		poda-de-órfãos, hand-compile e revalidação. O enforcement é build-failing (real), mas
		materializa quando o runtime constrói o mecanismo, não ativo na spec hoje (N4 own a janela).
		(P4c) A superfície battle-tested estreita o risco da hipótese: os inputs já geram em
		Kotlin (rtd-018); só o alvo de frontend (CUE→superfície-de-frontend) falta validar — o proposed é estreito, não
		especulativo.

		Negativas (limites intrínsecos).
		(N1) REVISITA o adr-157, que ficou um degrau curto (fechou o contrato semântico, não
		o de geração nem o harness de validação) — honesto e registrado (def-065), não
		silenciado; mas é admitir que o adr-157 não fechou tudo que a 1ª sessão precisa.
		(N2) O contrato nasce proposed: a hipótese CUE→superfície-de-frontend só valida no 1º run downstream
		(frontend-runtime inexistente) — a lei existe sem prova de execução até lá.
		(N3) Criar o contrato e os defs agora tem custo de autoria — aceito porque a
		alternativa de não-criar empurra para a 1ª sessão o degrau de inferência, mais caro
		numa relação que move dinheiro.
		(N4) Poda/hand-compile/trigger são CAPACIDADES declaradas; a 1ª sessão ainda CONSTRÓI
		os mecanismos — o gate EXIGE, não implementa. Há janela entre o requisito (agora) e o
		mecanismo (downstream).
		"""

	falsificationCondition: {
		condition: """
			O contrato estará errado se, no 1º run do frontend-runtime: (a) a 1ª sessão gerar a
			superfície FCE e ela NÃO compilar na linguagem-alvo — a hipótese CUE→superfície-de-frontend falsa (mantém proposed,
			desfecho PIVOTAR); (b) a 1ª sessão tiver que INFERIR algo da superfície que o contrato
			deveria declarar — contrato insuficiente; (c) o gate reforçado não conseguir detectar
			uma remoção/quebra que promete pegar — capability prometida não-realizável; (d) a
			fronteira vazar — o contrato fixar a forma/linguagem (COMO) que devia ser runtime-local.
			"""
		observableSignal: """
			Observável no 1º golden-example do frontend: (a) o gerador emite a superfície FCE e o
			compile da linguagem-alvo falha; (b) escalação ao founder por lacuna do contrato (ou, pior, inferência
			silenciosa em vez de escalar); (c) uma remoção/rename no domínio FCE passa o gate sem
			ser detectada (órfão ou quebra de hand em verde); (d) o contrato (transform[].to / output)
			nomeia um tipo/framework/componente concreto em vez de descrever uma CAPACIDADE —
			observável lendo o próprio contrato, no 1º run ou antes (não depende do runtime).
			(a)/(b)/(c) → PIVOTAR (revisar contrato/gate); (d) → fronteira furada (revisar QUE/COMO).
			"""
	}

	affectedArtifacts: []
	plannedOutputs: [
		"governance/build-time/frontend-codegen-contract.cue",
		"architecture/deferred-decisions/def-064-spec-runtime-propagation-ladder.cue",
	]
	derivedArtifacts: []
	defersTo: ["def-060", "def-064", "def-065"]

	principlesApplied: [
		"P0 — localização canônica única: o contrato APONTA para adr-150 (lei), adr-155 + contexts/fce/domain-model.cue (domínio), codegen-contract.cue (precedente) e def-060/064/065 — nunca copia; o mecanismo de flip mora em def-065, não duplicado aqui.",
		"P1 — código gerado, CUE SoT: a superfície de frontend é GERADA do domínio CUE, P1-estrito (committedHere false); dá ao 'código de tela derivado da spec' (adr-157 P1) a máquina que faltava.",
		"P2 — vendor atrás de fronteira: o stack de frontend (linguagem-alvo, framework, gerador, forma) fica atrás da fronteira (def-060), runtime-local — P2 aplicado ao cliente, como adr-150 o aplicou ao vendor de cliente.",
		"P10 — gates determinísticos validam: o contractGate reforçado é gate determinístico (as 3 capabilities); o flip do contrato é por evidência determinística (golden-example) + decisão do founder, não edição solta; Approval-as-Confirmation traduz P10 à superfície (herdado de adr-150/157).",
		"P12 — governança é código: as 3 capabilities são requisito VINCULANTE de fitness function no CI do runtime (build-failing quando o mecanismo existe) — governança-como-código; o enforcement vive no runtime CI, não na spec.",
		"P14 — fidelidade de forma: a superfície de frontend gerada preserva toda distinção compile-time-verificável do domínio FCE (especializa P1); o gerador CUE→superfície-de-frontend honra P14 como o CUE→Kotlin do mesh-runtime.",
	]

	rationale: """
		O contrato-de-codegen-precede-o-runtime: o codegen-contract.cue existiu no spec ANTES
		do mesh-runtime nascer (adr-140); criar o contrato do frontend agora honra esse
		precedente — a relação de geração mais crítica (a tela que move dinheiro) nasce
		governada, não reconstruída por arqueologia na 1ª sessão. O gate-mais-forte-por-construção:
		os 3 buracos do mesh-runtime (rtd-014/017/018) fecham como REQUISITO VINCULANTE de gate
		frontend-scoped (não retroativo) — P12 (governança-é-código) materializa as 3 como fitness
		function build-failing no CI do runtime; P10 (gate determinístico) governa o desfecho.
		Proposed-até-golden-example: P1/P14 são hipótese de geração (CUE→superfície-de-frontend) que só o 1º run valida
		— molde adr-140 (proposed→accepted no run-001), não adr-156 (same-commit). O flip é por
		EVIDÊNCIA spec-side (precedente codegen-validation-evidence.cue), e o harness que a produz é
		deferido em def-065 (não uma dependência pendurada: dono = bootstrap do frontend-runtime
		autorizado pelo adr-157, trigger = nascimento do runtime). A fronteira QUE/COMO honrada:
		superfície + gate + P1-estrito = spec; linguagem-alvo + forma/sintaxe + gerador + stack =
		runtime (def-060) — P14 + filtro adr-139; a linguagem-alvo é runtime-local (def-060),
		não decisão deste contrato. P2 aloca o stack de frontend atrás da fronteira; P0 ancora o
		apontar-não-copiar. reversibility medium / blastRadius cross-cutting coerentes: cross-cutting
		porque funda o PADRÃO de codegen de todo frontend (não 1 tela); medium porque é reversível
		enquanto proposed e sem run validador, mais caro após a forma do gerador materializar.

		Tensão com axiomas: nenhuma. O contrato defere ao runtime só o runtime-local (def-060,
		def-064, def-065). O piso (breach não-overridável) é garantido PRIMARIAMENTE pelo domínio
		(cmd só alcançável de escalated, ao qual breach nunca chega por inv-breach-bypasses-escalation;
		+ vo-overridden-guard-conditions sem flag cripto), herdado à superfície por geração fiel (P14);
		o check piso-herdado do contractGate é DEFESA-EM-PROFUNDIDADE contra gerador infiel, não a
		garantia primária. Herdado do adr-155, não tensionado.
		"""
}
