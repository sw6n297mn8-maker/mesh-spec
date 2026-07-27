package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-179 -- Fixa o mandato de conteúdo da promoção a schema do
// frontend-codegen-contract (aplicabilidade tipada do action-surface +
// três slots dos patterns do adr-150) e estabelece o reading contract
// de fatia de tela. Non-trigger explícito: o gatilho da promoção
// permanece exclusivamente o do adr-178 D3 (chegada da 3ª família).
// Cadeia causal: adr-150 define a lei; adr-178 define quando a promoção
// deixa de ser opcional; adr-179 define o que ela é obrigada a conter.

adr179: artifact_schemas.#ADR & {
	id:    "adr-179"
	title: "Fixar mandato de patterns na promoção a schema e reading contract de fatia de tela"

	date: "2026-07-27"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		A lei de frontend AI-first vive no adr-150: os 3 patterns de UX como lei
		de comportamento (Action-as-Tool, Generative Form, Approval-as-Confirmation)
		e as obrigações FF-FE-01..08 como compliance do frontend-runtime. O
		frontend-codegen-contract.cue (v2 per adr-178) materializa essa lei nas
		duas famílias de superfície existentes: os estágios action-surface (FCE)
		e action-surface-p2p exigem o par botão-humano+tool-de-agente de UMA
		definição, terminação em confirmação estruturada e form pré-preenchível
		campo a campo, com o input uxSemantics apontando o adr-150 nominalmente.
		A promoção do contrato a schema first-class é decisão PREVISTA com
		gatilho nomeado pelo adr-178 D3: a chegada da 3ª família (o mapa de
		cotações do ssc).

		O gap: a conformidade da lei ainda depende de repetição disciplinada
		pelo autor de cada nova família. O comportamento correto existe nas
		duas famílias — mas sua continuidade é probabilística, não estrutural.
		O adr-178 definiu QUANDO a promoção ocorrerá; não definiu O QUE ela
		deverá obrigatoriamente preservar. Sem esse mandato, o schema pode
		nascer sem mecanizar a própria lei — e a janela de mecanização se
		perde: a lei seguiria dependendo de leitura (probabilística, por
		sessão) em vez de estrutura (determinística, cue vet). O próprio
		adr-150 declara em N3 que as FF-FE são "contrato no papel" até o CI
		do runtime nascer — o lado spec-side dessa mecanização é exatamente o
		que este ADR fixa antecipadamente. Trigger concreto: a sessão
		2026-07-27 de revisão do enforcement da lei de frontend mapeou os
		degraus de força (leitura probabilística → campo de schema → gate de
		CI) e identificou a janela aberta pré-3ª-família.

		Segundo gap, menor: o conjunto suficiente de leitura para fatia de tela
		existe como teste de suficiência dentro de adr-157/adr-178 (a sessão lê
		o conjunto e não re-pergunta a lei), mas não como norma nomeada e
		citável — cada sessão reconstrói a trilha de ADRs, e custo de contexto
		alto reduz a probabilidade de leitura real por agente.

		Alternativas avaliadas:
		(a) Consolidar a lei num artefato novo, re-declarando patterns e
		    invariantes num lugar só. REJEITADA: duplicação por construção (P0)
		    — a lei já tem localização canônica (adr-150) e materialização
		    vigente (o contrato); re-declarar cria segunda fonte que diverge.
		(b) Antecipar a promoção a schema agora, sem esperar a 3ª família.
		    REJEITADA: contraria o gatilho nomeado do adr-178 D3 e a prática de
		    promover por evidência — desenhar o schema sem o 3º caso calibrador
		    é over-modeling antes do consumidor.
		(c) Fixar por ADR o conteúdo obrigatório da promoção futura, sem
		    disparar a promoção, e nomear o reading contract como norma.
		    ESCOLHIDA: fecha a janela de mecanização preservando a cadeia
		    causal — adr-150 define a lei; adr-178 define quando a promoção
		    deixa de ser opcional; adr-179 define o que a promoção é obrigada
		    a conter.
		"""

	decision: """
		(1) FIXAR o mandato de conteúdo da promoção a schema do
		frontend-codegen-contract: quando a promoção prevista pelo adr-178 D3
		disparar (chegada da 3ª família), o schema DEVE exigir, por família de
		superfície, uma declaração estruturada de APLICABILIDADE do bloco
		action-surface. Para famílias que exponham command ou ação mutável, o
		bloco é obrigatório e contém os três slots: (a) par
		botão-humano+tool-de-agente derivado de UMA definição (Action-as-Tool,
		adr-150 dec 2a); (b) terminação em confirmação estruturada, com
		Approval-as-Confirmation obrigatória quando o command da família move
		dinheiro (adr-150 dec 2c; P10 na superfície); (c) shape de Generative
		Form — prefill por campo — com justificativa explícita de
		fonte-fora-do-sistema quando a origem declarada for net-new (critério
		do adr-178; a migração de regime da origem permanece def-081). Para
		famílias legitimamente sem ação, a não-aplicabilidade DEVE ser
		declarada por shape tipado — sem action-surface vazio ou placeholder.
		O shape concreto da declaração é desenho da promoção, não antecipado
		aqui; a obrigação fixada é que a aplicabilidade seja explícita e a
		omissão silenciosa dos patterns seja impossível. Este ADR NÃO dispara
		nem antecipa a promoção — o gatilho permanece exclusivamente o do
		adr-178 D3 — e NÃO altera nem complementa o critério de promoção
		definido pelo adr-178; este ADR responde apenas à pergunta "quando a
		promoção acontecer, o que obrigatoriamente deverá existir no schema?".

		(2) ESTABELECER o reading contract canônico de fatia de tela como
		norma nomeada: toda sessão que autorar ou alterar fatia de tela no
		frontend-runtime lê, antes do trabalho: adr-150 (a lei),
		governance/build-time/frontend-codegen-contract.cue (a materialização
		vigente), adr-157 (handoff e morada do frontend-runtime) e adr-178
		(família do início da jornada e origem net-new). As referências são
		ponteiros, nunca cópias (P0) — o reading contract não re-declara
		conteúdo; promove a norma nomeada o teste de suficiência já operante
		em adr-157/adr-178.

		(3) DECLARAR a expectativa de espelho: o foundation pointer do
		frontend-runtime SHOULD refletir o reading contract do item (2). A
		escrita lá é ação daquele repo, fora do escopo do mesh-spec —
		registrada aqui como expectativa verificável em review.

		(4) ANOTAR o mandato no ponto de uso: adicionar ao
		frontend-codegen-contract.cue o campo schemaPromotionMandate apontando
		este ADR, para que quem tocar o contrato na chegada da 3ª família
		reencontre o mandato sem depender de memória — mesma técnica de âncora
		que o def-081 já usa no action-surface-p2p.
		"""

	consequences: """
		Positivas:
		(P1c) Fecha a janela de mecanização antes do consumidor: o conteúdo
		obrigatório da promoção existe ANTES da 3ª família que a dispara —
		elimina o cenário em que o schema nasce sem os campos e a continuidade
		da lei permanece dependente de repetição disciplinada por autor.
		(P2c) O enforcement spec-side ganha caminho observável: pós-promoção,
		família aplicável sem os três slots — ou família não aplicável sem
		declaração tipada de não-aplicabilidade — NÃO valida (cue vet). A
		conformidade dos patterns sai de review interpretativo e entra no
		gate determinístico, sem esperar o CI do frontend-runtime (janela N3
		do adr-150, cujo fechamento é matéria do runtime: mecanismo
		runtime-local per def-060; harness de evidência do flip per def-065).
		(P3c) O reading contract barateia a camada probabilística que resta:
		sessão de fatia de tela lê 4 ponteiros nomeados em vez de reconstruir
		a trilha de ADRs — e o review ganha pergunta citável ("a sessão leu o
		reading contract?").
		(P4c) Cadeia causal citável para manutenção: adr-150 responde "qual é
		a lei", adr-178 "quando a promoção deixa de ser opcional", adr-179 "o
		que obrigatoriamente existirá quando ela acontecer" — nenhum dos três
		precisa ser reaberto para responder a pergunta dos outros.
		(P5c) A âncora no ponto de uso (schemaPromotionMandate, dec 4) elimina
		dependência de memória cross-sessão — técnica já provada pelo def-081
		no action-surface-p2p.

		Negativas:
		(N1) Mandato dormante até o gatilho: entre este ADR e a chegada da 3ª
		família, o mandato existe sem enforcement ativo — consequência
		deliberada do non-trigger (dec 1); mitigada pela âncora do dec 4.
		(N2) Custo estrutural da aplicabilidade: o schema da promoção
		precisará distinguir deterministicamente famílias action-bearing de
		famílias legitimamente read-only (como a fila do P2P no regime hand
		não-contrato). A distinção adiciona um pequeno custo de modelagem,
		mas impede simultaneamente a omissão silenciosa dos patterns e o
		action-surface fictício.
		(N3) Expectativa de espelho sem gate daqui: o foundation pointer do
		frontend-runtime está fora do alcance do mesh-spec (dec 3 é SHOULD);
		a verificação permanece em review humano até aquele repo cabear o
		espelho.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Este ADR estará ERRADO SE os três patterns não puderem ser
			representados como obrigações estruturais condicionadas à
			capacidade da família — isto é, se a distinção action-bearing vs
			read-only não for derivável de shape tipado, exigindo
			classificação subjetiva por família ou produzindo declarações
			artificiais para validar.
			"""
		observableSignal: """
			O PR da promoção a schema precisar de exceções ad hoc por família,
			nomes concretos de famílias no schema, ou bypasses não derivados
			de uma capacidade tipada — visível no diff do schema. Sinal
			secundário: action-surface vazio/placeholder, ou declaração de
			não-aplicabilidade em família que expõe command.
			"""
	}

	affectedArtifacts: [
		"governance/build-time/frontend-codegen-contract.cue",
	]

	principlesApplied: ["P0", "P1", "P10", "P12"]

	rationale: """
		Opção (c) entre (a)-(c): fixa o conteúdo obrigatório da promoção sem
		disparar a promoção — fecha a janela de mecanização preservando o
		gatilho nomeado do adr-178 D3 e a promoção-por-evidência (o schema é
		desenhado quando o 3º caso calibrador existir). (a) re-declararia a
		lei criando segunda fonte que diverge; (b) desenharia schema sem
		consumidor.

		P0 (localização canônica única): o reading contract é composto de
		ponteiros — nomeia o conjunto, não re-declara conteúdo; a rejeição de
		(a) é aplicação direta. P1 (contratos como source of truth, código
		gerado): mecanizar a lei NO schema que governa a geração das famílias
		é P1 aplicado à superfície. P10 (agentes recomendam, gates
		determinísticos validam): a continuidade dos patterns migra de
		disciplina de autor (probabilística) para cue vet (determinístico); o
		slot (b) do mandato leva Approval-as-Confirmation — P10 em pixel, per
		adr-150 — para dentro da estrutura obrigatória. P12 (governança
		executável): o mandato converte lei comportamental em estrutura
		validável.

		Relações: executa a mecanização spec-side da lei do adr-150 (cuja N3
		— "contrato no papel" — permanece verdadeira para o lado CI do
		runtime, fora deste escopo); respeita o gatilho de promoção definido
		pelo adr-178 e preserva a relação de geração estabelecida pelo
		adr-158 — este ADR anota o conteúdo no contrato via dec 4, sem
		emendar nenhum dos dois; preserva def-081 (migração de regime da
		origem net-new intocada — o slot (c) exige o campo de justificativa,
		não muda o critério nem o gatilho de migração).

		Tensão com axiomas: nenhuma.
		"""
}
