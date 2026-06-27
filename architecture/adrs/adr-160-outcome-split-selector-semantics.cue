package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-160 — Semântica de outcome-split no decide() gerado: selector roteia,
// guards terminam. Estabelece como uma transição COLIDENTE (mesmo
// (from, triggeredByCommand) com >1 destino) é resolvida: um selector nomeado
// roteia (exatamente um candidato casa) e os guards DELE atuam como invariantes
// terminais. Filho de adr-141 (estende a semântica do estágio aggregate-skeleton;
// NÃO emenda, NÃO supersede — adr-141 fica accepted). Precedente de parentesco:
// adr-146 filho de adr-140; idiom de relação-em-principlesApplied: adr-155→adr-128.
// Fronteira spec-only declarada no próprio ADR.

adr160: artifact_schemas.#ADR & {
	id:    "adr-160"
	title: "Semântica de outcome-split no decide() gerado: selector roteia, guards terminam"
	date:  "2026-06-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		LACUNA DE RESOLUÇÃO. O decide() gerado a partir do AggregateManifest (estágio
		aggregate-skeleton do codegen-contract.cue, autoridade adr-141 item 5) é
		SILENCIOSO sobre como resolver mais de uma transição candidata para o mesmo
		par (from, triggeredByCommand). A materialização de runtime (mesh-runtime
		tools/codegen/internal/gen/skeleton.go, NÃO editada por este ADR) seleciona
		com transitions.firstOrNull: para um par colidente apenas a PRIMEIRA linha do
		domain-model dispara. O resto da máquina fica DORMENTE — não há erro, há um
		caminho que nunca executa. A forma do domain-model promete bifurcação que o
		código gerado não entrega.

		MEDIDA NO DISCO. Dois dos quatro aggregates gerados têm pares colidentes; CMT
		e REW não têm. No FCE (contexts/fce/domain-model.cue, agg-payment):
		guarded→authorized e guarded→escalated colidem sob cmd-authorize-payment;
		escalated→authorized e escalated→refused colidem sob cmd-resolve-guard-escalation
		com guards IDÊNTICOS (inv-override-requires-attribution nos dois) — distintos só
		pelo destino, pelo event e pelo payload (command.decision approve/deny). No DLV
		(contexts/dlv/domain-model.cue, agg-verification): evaluating→verified /
		evaluating→rejected / evaluating→exception-pending colidem (3 vias) sob
		cmd-evaluate-verification; exception-pending→verified e exception-pending→rejected
		colidem sob cmd-transition-exception-state. Sob firstOrNull, guarded→escalated,
		escalated→authorized, escalated→refused (FCE) e evaluating→rejected,
		evaluating→exception-pending, exception-pending→rejected (DLV) estão
		inalcançáveis no decide().

		POR QUE ESTRUTURAL E POR QUE AGORA. O #StateTransition
		(architecture/artifact-schemas/domain-model.cue, def #StateTransition) funde
		hoje DOIS papéis no guard: rotear (qual destino) E validar (invariante terminal).
		Para o par escalated→authorized/refused, cujos guards são idênticos, a fusão é
		provadamente insuficiente: nenhum guard discrimina o destino — o discriminante é
		o payload (command.decision), que invariante terminal não lê para rotear.
		Resolver isto é decisão de contrato sobre a forma da spec e sobre a semântica da
		capacidade-mãe decide(), compartilhada por TODOS os aggregates gerados via um
		template único — não escolha local de um BC.

		Alternativas avaliadas: (a) sobrecarregar guard para também rotear — REJEITADA:
		colapsa roteamento e invariante terminal num só conceito e quebra no par de
		guards idênticos (escalated→authorized/refused); perde o vocabulário
		recuperável-vs-terminal. (b) ordenar as transições e manter firstOrNull com a
		primeira-que-casa — REJEITADA: torna a ordem textual do domain-model
		semanticamente significativa (frágil, invisível, não-determinística sob
		reordenação inocente) e não resolve guards idênticos. (c) um guard composto por
		par que decide tudo internamente — REJEITADA: esconde a bifurcação dentro de
		prosa de invariante, mata a exaustividade verificável por tipo (P14) e impede o
		gate adversarial do piso de inspecionar breach-vs-stale isoladamente. Selector
		explícito separado de guard (a decisão abaixo) é a única que preserva
		determinismo, exaustividade e o vocabulário, e mantém a barreira do piso
		exatamente onde está hoje (o guard breach-bypasses-escalation).
		"""

	decision: """
		(1) SELECTOR como predicado de ROTEAMENTO, separado de guard. Cada transição
		COLIDENTE (mesmo (from, triggeredByCommand) com >1 destino) declara um campo
		NOVO `selector`: um predicado NOMEADO sobre (state, command, context), com
		rationale própria, que decide se ESTE destino é o aplicável. O selector PODE ler
		o payload do comando — é o que resolve escalated→authorized vs escalated→refused
		por command.decision, onde os guards são idênticos. guard MANTÉM o significado
		atual: invariante TERMINAL verificada após a seleção.

		(2) decide() em DUAS FASES sobre o par (from, command). FASE-ROTEAMENTO: avaliar
		os selectors das candidatas; EXATAMENTE UMA deve casar. FASE-VALIDAÇÃO: avaliar
		os guards DA candidata selecionada como invariantes terminais; falha de guard =
		rejeita, SEM cascade para outra candidata (o selector já fixou a transição;
		guard não re-roteia). Transição não-colidente (par único) dispensa selector: a
		candidata única é selecionada por construção e seus guards atuam como hoje —
		CMT e REW ficam inalterados.

		(3) VOCABULÁRIO recuperável-vs-terminal como núcleo semântico: selector =
		roteamento — NÃO-casar NÃO é erro, é "esta transição não se aplica"; guard =
		invariante terminal — falha APÓS seleção é rejeição. Essa separação É o
		vocabulário, não detalhe de implementação.

		(4) O PISO POR CONSTRUÇÃO (a barreira não se move). O selector da transição de
		exceção roteia o RESIDUAL AMPLO ao candidato: para guarded→escalated, o selector
		é "not-clean" (todo caso não-limpo, incluindo breach), de modo que o guard
		terminal breach-bypasses-escalation — que existe HOJE na transição — seja
		efetivamente avaliado. Assim breach (evidência ausente OU integridade
		criptográfica falha) É roteado ao candidato escalated e ALI o guard terminal o
		rejeita → o Payment fica guarded e o sinal de freeze (p11-invariant-breach-detected,
		inv-breach-bypasses-escalation) é preservado. A barreira do piso permanece
		exatamente onde está hoje (o guard); o selector só adiciona roteamento em volta
		dela. As duas barreiras independentes (roteamento + invariante terminal) ficam
		restauradas — o outcome-split NÃO enfraquece o piso.

		(5) REGRA DE PARADA + DETERMINISMO no tipo de retorno de decide(). O retorno é
		um sum-type fechado (P14) com TRÊS desfechos:
		- Transitioned — uma candidata roteou e seus guards passaram.
		- Rejected.NoApplicableTransition{from, command, attempts: [{to, failedGuard?,
		  failedSelector?}]} — NENHUM selector casou (cada attempt carrega failedSelector)
		  OU a candidata selecionada falhou um guard (o attempt carrega failedGuard).
		  decide() NÃO produz Transitioned: estado corrente intacto, ZERO eventos. O
		  campo attempts PRESERVA o destino e o motivo (selector que não casou ou guard
		  que barrou) — é o que torna o sinal de freeze recuperável downstream (breach →
		  failedGuard: inv-breach-bypasses-escalation).
		- AmbiguousTransition{from, command, matched} — >1 selector casou. NÃO é uma
		  Rejected (rejeição de domínio): é ERRO DE DESIGN que viola inv-guard-deterministic
		  (selectors de um par devem ser mutuamente exclusivos e exaustivos). Desfecho
		  distinto justamente para não confundir defeito-de-spec com rejeição legítima —
		  a separação que o vocabulário do item (3) existe para preservar.

		(6) APLICAÇÃO a FCE e DLV JUNTOS (capacidade-mãe; um template de decide(), não
		dois). FCE: guarded→authorized selector "clean" / guarded→escalated selector
		"not-clean" (residual amplo, item 4) — complementares, exatamente um casa;
		escalated→authorized / escalated→refused selectors por command.decision
		(approve/deny). DLV: evaluating→verified / →rejected por veredito, →exception-pending
		o residual; exception-pending→verified / →rejected por payload de resolução.
		CMT e REW: sem colisão, selector ausente, intocados.

		(7) MUDANÇA DE SCHEMA. Adicionar ao architecture/artifact-schemas/domain-model.cue:
		(i) uma def nova #TransitionSelector { name: string&!=""; readsPayload?: bool;
		rationale: string&!="" } — predicado de roteamento nomeado, com rationale
		obrigatória (paralelo ao tratamento de invariantes); (ii) campo OPCIONAL
		`selector?: #TransitionSelector` em #StateTransition. Optional porque toda
		transição de par único permanece válida sem ele; a obrigatoriedade-em-colisão
		(toda transição de par colidente DEVE ter selector; selectors de um par mutuamente
		exclusivos) é gate determinístico de fatia posterior (structural-check), declarada
		aqui como N2, não materializada por este ADR. O corpo do predicado é
		hand-authored no runtime: a spec NOMEIA e justifica o roteamento; o runtime o
		implementa.

		(8) FRONTEIRA spec-only. Este ADR decide SEMÂNTICA + VOCABULÁRIO + forma do tipo
		(selector field + os três desfechos de decide()) + a obrigação de teste do item
		(9). Ele NÃO toca skeleton.go (o gerador — Peça B do runtime), NÃO toca os
		guard-bodies / selector-bodies / fixtures / stateOf / buildEvents do runtime
		(Peça B), NÃO toca o handler resolve-guard-escalation nem auth/def-024 (Stage 2).
		A materialização (gerador emitindo a resolução em duas fases; corpos de selector
		e guard; selectors nas instâncias FCE/DLV; nota no codegen-contract) é fatia
		posterior governada por este contrato.

		(9) OBRIGAÇÃO DE TESTE (consequência testável) — o gate adversarial do piso, com
		CONTROLE POSITIVO OBRIGATÓRIO. A fatia de materialização DEVE provar: (a) breach
		(evidência ausente OU integridade cripto falha) NUNCA resulta em Transitioned a
		escalated — fica guarded, e o NoApplicableTransition carrega
		failedGuard: inv-breach-bypasses-escalation (sinal de freeze recuperável); E (b,
		controle positivo) stale-não-breach (condição presente-mas-velha/ambígua) DEVE
		resultar em Transitioned a escalated. Sub-pontos: o discriminante breach-vs-stale
		é o guard terminal (testável isoladamente); a regra de parada preserva o sinal de
		freeze nos attempts. Sem (b), (a) é vacuamente satisfeito por um selector/guard
		que nunca escala nada.
		"""

	consequences: """
		Positivas.
		(P1c) Os caminhos hoje dormentes sob firstOrNull (FCE guarded→escalated,
		escalated→authorized, escalated→refused; DLV evaluating→rejected,
		evaluating→exception-pending, exception-pending→rejected) tornam-se alcançáveis
		por construção — a forma do domain-model passa a ser fielmente executável.
		(P2c) Vocabulário recuperável-vs-terminal único e compartilhado: o mesmo decide()
		resolve FCE e DLV (capacidade-mãe), sem um motor de resolução por BC.
		(P3c) O piso de P11 não se move: breach continua barrado pelo MESMO guard terminal
		(breach-bypasses-escalation) de hoje; o selector só adiciona roteamento em volta.
		As duas barreiras independentes (roteamento + invariante) ficam restauradas, e o
		sinal de freeze fica recuperável via attempts[].failedGuard.
		(P4c) Determinismo verificável: >1 selector casando produz AmbiguousTransition
		(erro nomeado); 0 produz NoApplicableTransition. Os três desfechos como sum-type
		fechado (P14) forçam o consumidor à exaustividade — estado ilegal não compila.

		Negativas (limites intrínsecos).
		(N1) Introduz um segundo conceito (selector) ao lado de guard no #StateTransition:
		custo de aprendizado e risco de declarar como guard o que é roteamento (ou
		vice-versa) até a fatia de materialização e o structural-check de presença/
		exclusividade existirem.
		(N2) O campo é optional no schema; a obrigatoriedade-em-colisão e a exclusividade
		mútua dos selectors de um par NÃO são enforçadas por cue vet — uma transição
		colidente sem selector, ou dois selectors sobrepostos, passam o shape e só falham
		no gate determinístico posterior (structural-check) ou em runtime
		(AmbiguousTransition). Janela de inconsistência declarada, fechada por fatia futura.
		(N3) O corpo do predicado de selector é hand-authored no runtime: a spec nomeia e
		justifica, o runtime implementa — divergência entre o nome e o corpo é possível
		até o gate regen+diff e a obrigação de teste do item (9) cobrirem o caso.

		Compliance / fitness (obrigação de teste — item 9, fronteira spec→materialização).
		A fatia que materializar este contrato DEVE entregar, como gate, a prova
		adversarial do piso com controle positivo: (a) nenhum input de breach resulta em
		Transitioned a escalated — fica guarded e o NoApplicableTransition carrega
		failedGuard: inv-breach-bypasses-escalation; (b) controle positivo — stale-não-breach
		DEVE resultar em Transitioned a escalated; e a regra de parada preserva o sinal de
		freeze nos attempts. Sem (b), (a) é vacuamente satisfeito.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se a separação selector/guard não resolver os
			pares colidentes deterministicamente: ou (falso-positivo de roteamento) algum
			par exige discriminar destino por algo que NÃO é predicado sobre
			(state, command, context) — caso em que selector como nomeado-sobre-essa-tripla
			é insuficiente; ou (degeneração) na prática toda transição precisa de selector
			(inclusive pares únicos de CMT/REW), provando que "opcional só em colisão" é
			distinção falsa e o conceito deveria ter nascido obrigatório; ou (vazamento do
			piso) algum par de exceção exige que breach seja barrado FORA de um guard
			terminal, provando que rotear o residual amplo + guard terminal não preserva o
			piso por construção.
			"""
		observableSignal: """
			(falso-positivo) um selector de transição colidente que precisa ler fonte fora
			de (state, command, context) na fatia de materialização. (degeneração) a
			contagem de #StateTransition com selector preenchido converge a 100% das
			transições, em vez de ficar restrita aos pares colidentes de FCE+DLV.
			(vazamento) o gate adversarial do piso (item 9) falha o caso breach mesmo com
			selectors mutuamente exclusivos — sinal de que o guard terminal não é avaliado
			no caminho de exceção.
			"""
	}

	affectedArtifacts: [
		// Alterado por ESTE ADR (a mudança de schema que a decisão estabelece):
		"architecture/artifact-schemas/domain-model.cue",
		// Alterados pela materialização SOB este ADR (frente seguinte; idiom adr-155):
		"contexts/fce/domain-model.cue",
		"contexts/dlv/domain-model.cue",
		"governance/build-time/codegen-contract.cue",
	]

	plannedOutputs: []

	derivedArtifacts: []

	defersTo: []

	principlesApplied: [
		"P14 — fidelidade de forma compile-time: os três desfechos de decide() (Transitioned, Rejected.NoApplicableTransition, AmbiguousTransition) entram como sum-type fechado, forçando o consumidor à exaustividade (roteou-e-passou / não-roteou-ou-barrou / ambíguo) e tornando o caminho dormente não-compilável — gerar da spec não basta se a resolução de outcome-split degradar o tipo a ponto de o compilador não recusar o caminho que nunca executa.",
		"P1 — código gerado da spec: o decide() é gerado do AggregateManifest; este ADR fixa a SEMÂNTICA que a geração deve preservar (firstOrNull silencioso não é fiel à forma bifurcada), sem mover a geração para escrita manual.",
		"P12 — governança executável: o determinismo (AmbiguousTransition) e o piso adversarial (item 9) entram como gate testável na materialização, não como prosa.",
		"P11 — money-on-proof preservado: o piso inoverridável de adr-128/adr-155 fica POR CONSTRUÇÃO — breach é roteado ao candidato escalated mas barrado pelo MESMO guard terminal breach-bypasses-escalation de hoje; vai a freeze, e a regra de parada preserva o sinal nos attempts. A barreira do piso não se move.",
		"P10 — gate determinístico sobre recomendação estocástica: selector e guards são predicados determinísticos; o override humano (escalated→authorized/refused) continua roteado por payload sancionado, não por agente — a separação não abre brecha à execução autônoma de command financeiro.",
		"P0 — localização canônica: a semântica de outcome-split vive aqui (ADR) e a forma vive no #StateTransition; o runtime aponta para este contrato, não o redecide (mesh-runtime subordinado).",
		"adr-141 — parent: o item 5 autoriza o estágio aggregate-skeleton a derivar o aggregate base do manifest; este ADR ESTENDE a semântica desse estágio (como decide() resolve colisão) sem emendar nem supersedê-lo (adr-141 permanece accepted). Parentesco análogo a adr-146→adr-140.",
		"adr-155 — irmão de contexto (accepted): adr-155 desenhou o override do guard do FCE (escalated + override supervisionado); este ADR fornece a SEMÂNTICA GENÉRICA de resolução que o decide() gerado precisa para que aqueles caminhos (e os do DLV) deixem de ser dormentes. adr-155 não é reaberto nem re-ratificado.",
	]

	supersedes: []

	rationale: """
		A separação selector/guard é escolhida contra as três alternativas porque é a
		única que sobrevive ao caso mais forte de colisão no disco: escalated→authorized
		vs escalated→refused têm guards IDÊNTICOS (inv-override-requires-attribution),
		logo nenhum guard discrimina o destino — o discriminante é o payload
		(command.decision), que invariante terminal não deveria ler para rotear.
		Sobrecarregar guard (alt a), ordenar transições (alt b) ou compor um guard que
		decide tudo (alt c) ou quebram nesse caso ou colapsam o vocabulário
		recuperável-vs-terminal que É o ponto.

		O vocabulário é a decisão-chave, não o field. "Selector roteia, guard termina" dá
		nomes distintos a dois fenômenos que firstOrNull funde silenciosamente: não-casar
		(esta transição não se aplica — recuperável) versus falhar invariante após
		selecionada (rejeição terminal). Sem essa separação, o caminho dormente é
		indistinguível de rejeição legítima e o sinal de freeze de P11 se perde num
		retorno vazio. Os três desfechos (Transitioned, NoApplicableTransition com
		attempts, AmbiguousTransition) tornam ambos os fenômenos — e o defeito de
		determinismo — observáveis e, por sum-type fechado, exaustivamente tratáveis (P14).

		O piso é o ponto mais delicado e foi desenhado para NÃO se mover. O selector da
		transição de exceção roteia o residual amplo (not-clean, incluindo breach) ao
		candidato, de modo que o guard terminal breach-bypasses-escalation — que já existe
		hoje na transição guarded→escalated — seja efetivamente avaliado e rejeite o
		breach. Assim a barreira do piso permanece exatamente onde está; o outcome-split
		adiciona roteamento em volta dela, restaurando as duas barreiras independentes
		(roteamento + invariante) e mantendo o sinal de freeze recuperável via
		attempts[].failedGuard. É por isso que a forma {to, failedGuard} cobre o caso
		breach; failedSelector? cobre o caso ortogonal de nenhuma rota aplicável.

		decisionClass structural: adiciona uma def (#TransitionSelector) e um campo ao
		#StateTransition e três desfechos ao retorno de decide(), alterando a relação
		entre o domain-model e o código gerado de TODOS os aggregates que compartilham o
		decide() — não é contido num artefato. status proposed: a forma do tipo e a
		obrigação de teste ainda serão ratificadas pela materialização; a aprovação do
		founder promove proposed → accepted. reversibility medium: o campo é optional
		(remover o conceito exige migrar instâncias que já o usem e ajustar o gerador —
		esforço moderado, não irreversível; nenhum dado persistido ou contrato público
		externo é travado). blastRadius cross-cutting: toca o schema base de máquina de
		estado, dois BCs (FCE, DLV) e o estágio de codegen — múltiplos domínios, mas não
		governança/CI do repo inteiro (não é repo-wide). Coerente com o irmão adr-155
		(também cross-cutting).

		Fronteira spec-only deliberada: este ADR é o contrato; o gerador e os corpos de
		predicado são implementação subordinada (mesh-runtime). Decidir aqui semântica +
		vocabulário + forma do tipo + obrigação de teste, e deixar skeleton.go /
		guard-bodies / handler para fatia posterior, mantém a separação spec↔runtime de
		adr-148 e evita cristalizar hipótese de implementação como lei.

		Tensão com axiomas: nenhuma. A decisão cumpre P11/P10 (piso de money-on-proof e
		gate determinístico permanecem invioláveis — breach jamais conclui em escalated,
		override permanece humano-sancionado) e especializa P14/P1 sem contradizê-los.
		"""
}
