package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-155 — Override humano do PrePaymentGuard no FCE. Modela a exceção humana
// SANCIONADA ao gate money-on-proof: estado escalated explícito + comando
// supervisionado. Irmão de exceção do adr-128 (128 estabeleceu o gate; 155 modela
// o que acontece quando o gate não passa autonomamente). Fecha o T2 do FCE para o
// caso override. Status proposed: a materialização no domain-model (frente
// seguinte) é o que o ratifica (proposed → accepted).

adr155: artifact_schemas.#ADR & {
	id:    "adr-155"
	title: "Override humano do PrePaymentGuard no FCE: estado escalated + comando supervisionado (fecha T2 do override)"
	date:  "2026-06-18"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		LACUNA T2. A fatia do guard-path do FCE (claim parcial do WI-043, decisão
		founder 2026-06-12) modelou os 4 commands do caminho feliz (materialize →
		authorize → dispatch → settle) e deixou EXPLICITAMENTE de fora os estados de
		falha/exceção: "bloqueio do guard NÃO é estado de falha — o Payment permanece
		em guarded com motivo; estados de falha entram com os fluxos de exceção". O
		override-prepayment-guard existe hoje só como supervisedDecision (prosa de
		governança no canvas, ownership.governanceScope) — NÃO como fluxo de domínio.
		Este ADR fecha o T2 PARA O CASO OVERRIDE.

		A CLÁUSULA QUE JÁ PREVÊ O OVERRIDE. O comando não pede licença para uma exceção
		a P11 — ele CUMPRE cláusulas que já existem. (i) P10 (design-principles): "Todo
		command com impacto financeiro passa por gate que impõe invariantes, thresholds
		e aprovações humanas" — a aprovação humana é parte do que o gate impõe, mandada
		por P10. (ii) inv-guard-deterministic (fce domain-model): "override do guard é
		sempre supervisedDecision". (iii) inv-money-moves-only-on-proof proíbe override
		AUTÔNOMO ("bloqueia o dispatch sem override autônomo") — não override humano.
		Logo o comando OPERACIONALIZA cláusulas existentes; não institui exceção a P11.

		ÁREA DE CONSTRAINT NÍVEL-1. O FCE é fronteira regulatória SCD/Bacen; P11 ancora
		integridade legal (adr-128). Modelar o override do gate de dinheiro exige
		cautela máxima — e é por isso o estado ESCALATED EXPLÍCITO (decisão do founder):
		a máquina registra que PAROU e esperou um julgamento humano nominalmente
		atribuído ao supervisor. O estado escalado É a evidência auditável de que o
		override foi supervisionado, não automático — sem ele, a transição
		guarded → authorized por exceção seria indistinguível do caminho autônomo,
		apagando a fronteira P10 entre recomendação (agente) e aprovação (humano).

		AMARRAÇÃO. Este ADR é o irmão de exceção do adr-128: 128 estabeleceu o gate
		money-on-proof (a regra), 155 DECIDE o desenho da exceção humana sancionada (o
		que acontece quando a regra não pode passar autonomamente). Status proposed: o
		ADR fixa o desenho, mas é a MATERIALIZAÇÃO no domain-model — estado escalated +
		command + event + a propagação de codegen para am-payment/schemas/events, na
		frente seguinte — que o RATIFICA (transiciona para accepted quando o
		domain-model fechar). Ordem: o ADR decide; o domain-model materializa e torna
		vigente.
		"""

	decision: """
		(1) STATE MACHINE B — estado ESCALATED explícito. O lifecycle do Payment ganha
		um estado entre o gate e a autorização: guarded → escalated → authorized OU →
		[terminal de recusa]. Três transições novas:
		- guarded → escalated (AUTOMÁTICA): dispara quando o PrePaymentGuard NÃO passa
		  de forma limpa — qualquer das 3 condições (fatura / elegibilidade / evidência)
		  stale, incompleta ou ambígua (verbatim da supervisedDecision). NÃO é o
		  bloqueio-limpo: a reprovação determinística simples permanece em guarded com
		  motivo (T2 do caminho feliz, intocado). escalated = "o guard não passou
		  autonomamente E a falha é do tipo que admite override humano".
		- escalated → authorized (HUMANA): o command de override, com atribuição nominal
		  ao supervisor. Só daqui o Payment reentra no trilho autônomo existente (segue
		  para dispatch). É a única porta da exceção de volta ao caminho de pagamento.
		- escalated → [recusa] (HUMANA): negação do override (item 3).

		(2) COMMAND de override (supervisionado). Campos OBRIGATÓRIOS, derivados da
		supervisedDecision ("confirmação humana nominalmente atribuída ao supervisor"):
		supervisorId (atribuição nominal — QUEM autorizou), reason (POR QUE),
		overriddenConditions (QUAL das 3 condições do guard foi sobreposta). Emite um
		event de override (nome a confirmar contra a convenção de events do FCE —
		proposta: PaymentGuardOverridden) carregando os 3 campos para o audit trail
		(Event Log imutável). GARANTIA ESTRUTURAL, não prosa: o schema do command torna
		IMPOSSÍVEL emiti-lo sem supervisorId — um agente não consegue produzi-lo por
		construção (P10 enforçado pela forma, não pela disciplina).

		(3) TERMINAL DE RECUSA — estado próprio, NÃO acoplado a default. A negação do
		override leva a um estado terminal dedicado (nome a confirmar contra a convenção
		de estados do FCE — proposta: override-denied) que registra supervisorId +
		reason e NÃO emite PaymentObligationDefaulted. O que ACONTECE com a obrigação
		após a recusa (default, reissuance, encerramento) é a supervisedDecision #4
		(confirm-payment-obligation-default) — fatia própria, fora deste ADR. Acoplar a
		recusa ao default incharia esta fatia com um fluxo de exceção distinto.

		(4) O QUE O OVERRIDE NÃO PODE FAZER — linhas vermelhas explícitas (constraint
		nível-1, não-tensionável):
		- NÃO é autônomo: exige supervisorId nominal (garantia estrutural do item 2).
		- NÃO sobrepõe a integridade criptográfica da evidência. O override cobre as 3
		  condições quando STALE / AMBÍGUA / INCOMPLETA-mas-PRESENTE — onde um humano
		  julga que a prova subjacente EXISTE e o check automático não a confirmou de
		  forma limpa (ex.: elegibilidade REW expirada/indeterminada; fatura ambígua;
		  evidência com âncora de notarização pendente). O PISO INOVERRIDÁVEL é o breach
		  genuíno de P11 — evidência AUSENTE ou com integridade criptográfica FALHA
		  (adulterada): isso NÃO é "condição stale/ambígua", é violação da invariante
		  central, roteada para o escalationCriterion p11-invariant-breach-detected
		  (freeze fail-safe), JAMAIS para escalated → authorized. Nenhum humano autoriza
		  pagamento sobre prova ausente ou forjada (P11 nível-1, não-tensionável).
		- DEIXA rastro auditável completo: o estado escalated registra que a máquina
		  PAROU e esperou; o event de override registra QUEM / POR QUÊ / O QUÊ. O wait é
		  o ativo de prova de que o override foi supervisionado, não automático.

		(5) NÃO FAZER AGORA. A materialização — edit do domain-model (estado escalated +
		command + event + invariante de atribuição) + propagação de codegen para
		am-payment/schemas/events — vem na frente seguinte SOB este ADR, e é o que o
		transiciona de proposed para accepted. As outras 3 supervisedDecisions
		(resolve-settlement-indeterminate-persistent, authorize-cancel-then-reissue,
		confirm-payment-obligation-default) são fatias próprias, fora deste ADR.

		ALTERNATIVAS CONSIDERADAS.
		(a) Máquina A — transição direta guarded → authorized por exceção, sem estado
		    escalated. REJEITADA: human-in-the-loop sem estado de espera explícito apaga
		    a evidência auditável do wait; numa fronteira nível-1, a PROVA de que a
		    máquina parou e esperou um humano nominalmente atribuído é o ativo —
		    indistinguir a exceção do caminho autônomo dissolve a fronteira P10.
		(b) Recusa acoplada a confirm-payment-obligation-default (#4). REJEITADA: acopla
		    esta fatia ao destino da obrigação após recusa (fluxo de exceção fora de
		    escopo) e incha a fatia; o terminal de recusa próprio a mantém coesa.
		(c) Override como flag/campo no command cmd-authorize-payment existente (não
		    command próprio). REJEITADA: esconde o override dentro do caminho autônomo e
		    viola a fronteira P10 (recomendação-vs-aprovação) — o override humano merece
		    command + event próprios para o audit trail o distinguir do gate-pass
		    autônomo. Um flag num command autônomo é exatamente o que P10 separa.
		"""

	consequences: """
		Positivas.
		(P1c) Fecha o T2 do override: a supervisedDecision de governança vira fluxo de
		domínio modelável (estado + command + event), saindo da prosa do canvas para a
		state machine do Payment.
		(P2c) O estado escalated dá a evidência auditável do wait human-in-the-loop — a
		máquina registra que PAROU e esperou um julgamento humano nominalmente atribuído.
		Numa fronteira nível-1, essa prova é ativo regulatório.
		(P3c) O piso inoverridável torna EXPLÍCITO no design que evidência ausente/forjada
		nunca é overridable — a brecha mais perigosa (autorizar pagamento sem prova
		genuína) fica fechada por construção, roteada a freeze, não por vigilância.

		Negativas (limites intrínsecos).
		(N1) O estado escalated expande a state machine do Payment (mais superfície, mais
		transições a manter e testar). Custo aceito: a alternativa (máquina A) apaga a
		prova do wait, que numa fronteira nível-1 é o ativo.
		(N2) A garantia estrutural de P10 (supervisorId obrigatório) depende de a
		materialização no schema realmente torná-lo não-omitível. O ADR DECIDE; a garantia
		só é REAL quando o domain-model/codegen a enforçam — até lá é compromisso, não
		enforcement. A transição proposed → accepted (materialização) é o que fecha isso.
		(N3) O limite stale-vs-ausente exige um JUÍZO na fronteira (quando uma evidência é
		"stale-mas-presente" vs "ausente"?). Zona cinza que o design NOMEIA mas não
		elimina; casos de fronteira precisarão de critério calibrado na materialização — o
		piso inoverridável fixa o lado seguro (na dúvida entre stale e breach, roteia a
		freeze, não a override).

		Fronteira regulatória (constraint nível-1). O FCE é fronteira SCD/Bacen; P11 ancora
		integridade legal (adr-128). Este ADR formaliza a exceção humana SANCIONADA ao gate
		de integridade legal; o piso inoverridável garante que a exceção nunca degrada P11
		(evidência ausente/forjada vai a freeze, jamais a override). Não é decisão
		operacional sobre um pagamento concreto — é o invariante de design do fluxo de exceção.
		"""

	reversibility: "low"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			O design estará errado em QUALQUER um dos dois lados: (falso-permissivo) um
			override autoriza sobre evidência que era breach genuíno de P11 — o piso
			inoverridável foi furado, dinheiro moveu sem prova; ou (falso-restritivo) o
			freeze fail-safe captura casos legitimamente stale/ambíguos que deviam ter ido a
			escalated — o gate trava override legítimo, regredindo a operação.
			"""
		observableSignal: """
			(falso-permissivo) um PaymentGuardOverridden cujo overriddenConditions inclui
			integridade-criptográfica-falha — o caso que deveria ter ido a
			p11-invariant-breach-detected / freeze. (falso-restritivo)
			p11-invariant-breach-detected disparando sobre evidência presente-mas-velha
			(stale), travando override legítimo — visível na correlação entre taxa de freeze
			e taxa de override negado por staleness.
			"""
	}

	affectedArtifacts: [
		// Alterados pela materialização SOB este ADR (frente seguinte; affectedArtifacts
		// conceitual, precedente adr-154/def-060): estado escalated + command + event +
		// invariante de atribuição entram nestes arquivos existentes.
		"contexts/fce/domain-model.cue",
		"contexts/fce/canvas.cue",
		"contexts/fce/aggregate-manifests/am-payment.cue",
		"contexts/fce/schemas/events.cue",
	]

	// plannedOutputs vazio: a materialização EDITA arquivos existentes, não cria arquivo
	// novo. Golden-example dedicado do override, se criado, seria o plannedOutput —
	// decisão da frente seguinte.
	plannedOutputs:   []
	derivedArtifacts: []

	// defersTo vazio: nenhum deferral novo. As 3 outras supervisedDecisions já existem no
	// governanceScope do canvas e são fatias futuras (decision item 5), não deferred-
	// decision com trade-off + gatilho.
	defersTo: []

	principlesApplied: [
		"P10 — aprovações humanas como parte do gate: o ADR materializa a cláusula 'gate que impõe ... aprovações humanas' (P10 statement) — o command de override É a aprovação humana mandada por P10, com supervisorId não-omitível por construção (a fronteira recomendação-vs-aprovação enforçada pela forma, não pela disciplina).",
		"P11 — o override respeita a integridade cripto: o piso inoverridável fixa que evidência ausente/forjada (breach de P11) nunca é overridable — vai a freeze, jamais a escalated→authorized; o override cobre só stale/ambíguo-mas-presente. P11 não é tensionado, é respeitado.",
		"P0 — localização canônica: o desenho da exceção vive aqui (ADR); a materialização (estado/command/event) viverá no domain-model do FCE sem duplicação — canvas e am-payment apontam, não copiam. Espelha o [P11,P10,P0] do adr-128.",
		"adr-128 — irmão de exceção: 128 estabeleceu o gate money-on-proof (a regra); 155 modela a exceção humana sancionada (o que acontece quando a regra não passa autonomamente). 155 não altera 128 — o excetua, ancorado no mesmo P11/integridade-legal nível-1.",
	]

	rationale: """
		A máquina B (estado escalated explícito) entre (a)-(c): (a) máquina-direta apaga a
		prova do wait; (b) recusa-acoplada-ao-default incha a fatia; (c) flag-no-authorize
		esconde o override no caminho autônomo e dissolve a fronteira P10. B é a única que
		dá evidência auditável de que a máquina parou e esperou um humano nominalmente
		atribuído — o ativo numa fronteira nível-1.

		decisionClass structural: adiciona estado + command + event + transições à state
		machine (estrutura entre artefatos), operacionalizando P10/P11 existentes — não
		define base nova. status proposed: o ADR decide o desenho; a materialização no
		domain-model é o que o ratifica (→ accepted). reversibility low: um override
		sancionado do gate de dinheiro é load-bearing para integridade legal — uma vez vivo,
		removê-lo órfã o escape-hatch legal do gate e overrides reais são irreversíveis.
		blastRadius cross-cutting: o override é a exceção ao gate que compõe INV/REW/evidência
		(FCE↔INV↔REW↔BKR) e a recusa tem alcance reputacional em REW.

		A DECISÃO-CHAVE é o piso inoverridável (decision item 4): separar 'condição
		stale/ambígua-mas-presente' (humano pode julgar que a prova existe → override) de
		'evidência ausente/forjada' (breach de P11 → freeze, jamais override). Sem esse piso,
		o override seria uma porta para mover dinheiro sem prova — exatamente o que P11 e o
		FCE existem para impedir. Com ele, o override CUMPRE P11 em vez de excetuá-lo.

		P10/P11/P0: o override é a aprovação humana que P10 manda o gate impor (P10), com o
		piso que garante que a exceção nunca degrada a prova (P11), em localização canônica
		única materializada sem duplicação no domain-model (P0). adr-128 é o irmão que
		estabelece o gate; este o excetua sem alterá-lo.

		Tensão com axiomas: nenhuma. O override CUMPRE P10 ('aprovações humanas' é parte do
		gate) e não tensiona P11 — o piso inoverridável garante que evidência ausente/forjada
		nunca é autorizada. A invariante já previa o override (proíbe override AUTÔNOMO, não
		humano); este ADR a operacionaliza.
		"""
}
