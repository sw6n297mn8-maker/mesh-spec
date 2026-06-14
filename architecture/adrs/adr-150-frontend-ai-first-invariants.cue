package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-150 -- Ratifica os invariantes de frontend AI-first como lei de spec e
// defere a selecao de vendor de cliente ao frontend-runtime. Resolve def-039
// (frontend/clients) e cria def-060 (vendor de cliente) + def-061 (contrato de
// dado de proveniencia de captura). Aplica o filtro spec×runtime do adr-139: a
// spec decide comportamento + fronteira; o vendor vive atras da fronteira (P2).

adr150: artifact_schemas.#ADR & {
	id:    "adr-150"
	title: "Estabelecer invariantes de frontend AI-first e deferir seleção de vendor de cliente"

	date: "2026-06-13"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Os invariantes de frontend AI-first da Mesh foram explorados e
		red-teamed num arco de trabalho de arquitetura anterior cujos artefatos
		nao persistem na governanca atual. Este ADR os internaliza como decisao
		propria e autonoma do mesh-spec -- nao referencia fonte externa; e, ele
		mesmo, a fonte canonica desta decisao (inclusive das oito obrigacoes
		FF-FE-01..08 definidas no item 5).

		O caminho-B fechou: o fluxo commitment->entrega->fatura->PrePaymentGuard
		->pagamento esta provado por teste, com falsificacao de prova bloqueando
		o movimento de dinheiro. A primeira tela do banco -- o botao de aprovacao
		humana sobre o PrePaymentGuard -- e o proximo passo. Construir a tela
		exige que a lei que governa telas esteja registrada primeiro.

		Trigger (porque agora): def-039 (frontend/clients) esta OPEN com trigger
		adjacent-need file-exists adr-140 -- e adr-140 existe, entao a condicao
		ja esta satisfeita. O gatilho de revisita do frontend disparou. Este ADR
		e o ultimo portao antes da primeira tela.

		Alternativas consideradas:
		(a) Cravar o stack de vendors como lei de spec (nomes de framework web,
		    mobile sync, runtime de UI-de-agente e motor de workflow como
		    referencias vinculantes). REJEITADA: contradiz o filtro spec×runtime
		    do adr-139 (frontend = runtime; vendor atras de fronteira) e a
		    moldura do def-039; exigiria tension-entry + supersessao parcial do
		    adr-139. Stack de frontend troca de lider em ciclos de ~18-24 meses
		    -- cravar nome de vendor em lei de spec e gravar em pedra o que
		    envelhece por design.
		(b) Adiar a ratificacao. REJEITADA: a decisao ja esta madura e
		    red-teamed; um ADR documenta resultado, nao reabre exploracao; o
		    def-039 ja disparou; adiar trava a primeira tela sem ganho.
		(c) Estabelecer so os invariantes (premissa AI-first, os 3 patterns de
		    UX, as fronteiras de isolamento da camada AI, as obrigacoes
		    FF-FE-01..08) e deferir a selecao de vendor de cliente. ESCOLHIDA --
		    fixa como lei o que e duradouro (comportamento e fronteira) e defere
		    o que envelhece (escolha de vendor) ao frontend-runtime via def-060,
		    coerente com o filtro spec×runtime do adr-139.
		"""

	decision: """
		(1) ESTABELECER como invariante de spec a premissa AI-first do frontend:
		a interface e onde agentes e humanos co-operam -- agentes operam, humanos
		entram por excecao; nao e o locus primario de operacao humana.

		(2) ESTABELECER os 3 patterns de UX como lei de comportamento:
		(a) Action-as-Tool -- toda acao e simultaneamente botao (humano) e
		    ferramenta invocavel por agente, a partir de uma definicao;
		(b) Generative Form -- formularios pre-preenchidos pelo agente, com o
		    humano confirmando/editando, nunca digitando do zero por padrao;
		(c) Approval-as-Confirmation -- toda acao financeira TERMINA num botao
		    estruturado de confirmacao, NUNCA num turno de chat livre. E a regra
		    do gate deterministico (P10) traduzida para a superficie: agente
		    recomenda, humano confirma em acao estruturada.

		(3) FIXAR as fronteiras de isolamento da camada AI: a orquestracao de
		agente NAO carrega regra de negocio dentro de si (zero-business-logic); o
		acesso a qualquer runtime de UI-de-agente passa por um bridge dedicado
		(nao-penetracao); a logica de dominio mora atras das fronteiras de Port
		canonicas (adr-141), nao na camada de apresentacao. O COMPORTAMENTO e
		lei; o VENDOR que o implementa e recomendacao deferida ao def-060, nao
		nome vinculante.

		(4) ANCORAR a proveniencia de evidencia de captura (foto do inspetor de
		campo) na camada de INGESTAO LOCAL (validacao network-independent, per o
		modelo BD11 do DLV em contexts/dlv/port-manifest.cue), com o EvidencePort
		(adr-141) como camada de CUSTODIA -- nao como verificador de captura. O
		contrato de dado de proveniencia de captura fica DEFERIDO ao def-061
		(linha de evidencia): este ADR declara a costura (captura-local ->
		custodia), NAO fixa o tipo de proveniencia, cuja formalizacao e decisao
		futura.

		(5) DECLARAR como obrigacoes de compliance do frontend-runtime --
		implementadas e verificadas no CI do runtime, NAO como codigo no
		mesh-spec -- as oito fitness functions FF-FE-01..08, definidas aqui em
		termos comportamentais e agnosticos a vendor (o mesh-spec e a fonte
		canonica destas obrigacoes; o runtime as cumpre com enforcement
		especifico de stack):
		  FF-FE-01 -- todo acesso de codigo de negocio ao runtime de UI-de-agente
		    passa exclusivamente por um bridge dedicado; nenhum modulo de dominio
		    ou aplicacao importa o runtime de agente diretamente.
		  FF-FE-02 -- nenhuma regra de negocio (qualificacao, posting rules,
		    criterios de risco) vive dentro do framework de orquestracao de
		    agente; tools, prompts e criterios vivem em modulos agnosticos a
		    framework.
		  FF-FE-03 -- a biblioteca de visualizacao de grafo de rede e acessada
		    apenas atraves de um componente com API propria da Mesh; nenhum
		    consumidor a importa diretamente.
		  FF-FE-04 -- toda configuracao de grafico passa por validacao de schema
		    antes de renderizar; nenhuma configuracao crua nao-validada chega ao
		    renderizador.
		  FF-FE-05 -- o output de cada modulo de calculo compartilhado executado
		    no cliente e bit-identico ao do mesmo modulo no servidor, para um
		    input canonico.
		  FF-FE-06 -- todo transporte real-time passa por uma abstracao unica;
		    nenhum consumidor instancia primitivos de transporte (SSE/WebSocket)
		    diretamente.
		  FF-FE-07 -- operacoes criadas offline (inspecao, aceite de entrega)
		    sincronizam sem perda quando a conexao e restaurada.
		  FF-FE-08 -- nenhum import da camada de IA penetra os modulos de
		    dominio; a camada de IA nao e dependencia do dominio.

		(6) RECONHECER que os calculos financeiros compartilhados entre cliente e
		servidor (state machine ECL, normalizacao decimal, parser NF-e, posting
		rules) rodam a partir de uma fonte Rust unica compilada para os dois
		alvos -- garantindo a paridade bit-identica exigida por FF-FE-05 --, e
		que o decimal obedece a regra Ion-4 ja canonica no adr-140. Esta paridade
		DEPENDE da capacidade de codegen CUE->Rust de domain-types cuja
		linguagem-alvo o adr-147 governa, mas NAO e o co-alvo de modulos criticos
		de backend do adr-147 item (5b) (Rust nativo de backend != calculo
		compartilhado de cliente); e concern de frontend-runtime, distinto.

		(7) RESOLVER def-039 (a decisao de frontend/clients deferida) via este
		ADR (resolvedBy), DEFERIR ao def-060 a selecao de vendor de cliente --
		framework web, mobile sync, motor de orquestracao de agente IA
		(nao-deterministico, distinto do WorkflowPort de dominio cujo vendor esta
		em def-043), design system visual e specs de tela --, que carrega os
		watchpoints datados como criterios de decisao; e DEFERIR ao def-061 o
		contrato de dado de proveniencia de captura (dominio de evidencia,
		trigger proprio).
		"""

	consequences: """
		Positivas:
		(P1c) Elimina a classe de drift "vendor-como-lei": nomear framework web /
		mobile sync / runtime de UI-de-agente como referencia vinculante gravaria
		em lei de spec um stack que troca de lider em ciclos de ~18-24 meses.
		Ratificar comportamento + fronteira e deferir o vendor (def-060) mantem a
		lei estavel enquanto o stack envelhece atras dela.
		(P2c) O comportamento ratificado sobrevive a troca de stack: os 3
		patterns e as fronteiras de isolamento valem independentemente de qual
		framework/runtime os implementa -- exit de vendor e troca de adapter
		atras da fronteira, nao reescrita de lei (P2 aplicado ao cliente).
		(P3c) Approval-as-Confirmation materializa P10 na superficie: a regra
		"agente recomenda, gate/humano confirma acao financeira em acao
		estruturada" deixa de ser so backend e vira invariante de pixel -- a
		primeira tela (botao sobre o PrePaymentGuard) nasce obedecendo o gate,
		nao retrofitada.
		(P4c) A proveniencia de evidencia nasce verificada na captura via
		ingestao local network-independent (BD11 do DLV) e custodiada pelo
		EvidencePort (adr-141) -- o gap "trabalho reivindicado vs realizado"
		(P11) fecha na borda do canteiro, antes de qualquer rede.
		(P5c) Destrava a primeira tela: a lei que governa telas passa a existir e
		o def-039 sai de OPEN para resolved -- construir a tela deixa de esperar
		uma decisao de frontend ausente.

		Negativas:
		(N1) Invariante ratificado, implementacao ausente: vendor de cliente,
		telas e design system visual (tokens, tipografia, marca) NAO existem --
		escopo declarado-ausente, deferido a def-060. adr-150 e lei sem
		implementacao ate o frontend-runtime nascer.
		(N2) Dependencia em base "proposed": o item (6) apoia-se na capacidade de
		codegen CUE->Rust que o adr-147 (status "proposed", nao accepted)
		governa -- referenciada como DIRECAO, nao lei consolidada. Se o adr-147
		mudar na promocao a accepted, a nota de direcao da paridade
		cliente/servidor acompanha.
		(N3) FF-FE-01..08 sao obrigacoes declaradas sem enforcement ativo: o
		mesh-spec registra a obrigacao, mas o CI que as roda nasce no
		frontend-runtime. Ate la sao contrato no papel, verificadas por review do
		founder, nao por gate deterministico (mesmo padrao do N1 de adr-149 sobre
		campos hidden sem structural-check).
		(N4) Costura declarada, tipo nao formalizado: o item (4) ancora
		captura-local -> custodia mas defere o contrato de dado de proveniencia a
		def-061 (linha de evidencia). Ha janela em que a costura existe sem o tipo
		formalizado, dependente da ratificacao-irma do Evidence Store.

		Fronteira regulatoria: o ponto que toca regulacao e a proveniencia de
		evidencia (P11). Este ADR apenas ANCORA a camada de verificacao (ingestao
		local) e DEFERE o contrato de dado (def-061) -- nao fixa tipo de
		proveniencia, nao move dinheiro, nao altera contrato persistido. Nenhuma
		obrigacao regulatoria nova e criada aqui.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Este ADR estara ERRADO SE, ao formalizar o tipo de proveniencia de
			captura (def-061), a verificacao de proveniencia NAO couber na camada
			de ingestao local network-independent (BD11) que o item (4) ancora --
			exigindo travessia do EvidencePort (rede) ou de um Port novo para
			verificar a captura. Nesse caso a ancora "proveniencia nasce
			verificada localmente; o EvidencePort so custodia" cai, e o item (4) e
			revisitado.
			"""
		observableSignal: """
			A resolucao de def-061 (ou do ADR-irmao de Evidence Store) cujo design
			do tipo de proveniencia exija verificacao de captura dependente de rede
			/ travessia de Port -- visivel no PR que formaliza def-061. Gatilho
			concreto: a materializacao de def-061. Sinal secundario: um teste de
			FF-FE-07 (integridade offline) que so passe com round-trip de rede
			contradiz diretamente a ancora BD11.
			"""
	}

	affectedArtifacts: [
		"architecture/deferred-decisions/def-039-frontend-clients-stack.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-060-frontend-client-vendor-stack.cue",
		"architecture/deferred-decisions/def-061-capture-provenance-data-contract.cue",
	]

	defersTo: ["def-060", "def-061"]

	principlesApplied: ["P10", "P11", "P2", "P1", "P12"]

	rationale: """
		Opcao (c) entre (a)-(c): ratifica o que dura (comportamento + fronteira)
		e defere o que envelhece (vendor), aplicando o filtro spec×runtime do
		adr-139 ao frontend -- a spec decide o estavel e estrutural, o vendor de
		cliente vive atras da fronteira (P2) e e selecionado JIT no
		frontend-runtime (def-060). (a) crava vendor em lei de spec,
		contradizendo adr-139 e gravando em pedra um stack que troca de lider em
		~18-24 meses; (b) adia sem ganho com o def-039 ja disparado.

		P10 (gate deterministico): Approval-as-Confirmation e P10 na superficie --
		acao financeira termina em confirmacao estruturada, nunca em chat livre.
		P11 (dinheiro so move com prova): a proveniencia nasce verificada na
		captura via ingestao local network-independent (BD11 do DLV), com o
		EvidencePort (adr-141) como custodia -- a prova e verificada na borda, nao
		"alimentada" a um Port; o contrato de dado fica em def-061 (linha de
		evidencia, junto de def-045/def-058). P2 (vendor atras de fronteira): as
		fronteiras de isolamento da camada AI + o deferimento do stack sao P2
		aplicado ao cliente -- exit de vendor e troca de adapter, nao reescrita.
		P1 (codigo gerado, fonte unica): os calculos compartilhados
		cliente/servidor rodam de uma fonte Rust unica (paridade FF-FE-05) sob
		Ion-4 (adr-140); dependem da capacidade de codegen CUE->Rust que o adr-147
		(proposed) governa -- referencia como direcao, sem reivindicar o co-alvo
		de modulos criticos de backend do item (5b). P12 (governanca e codigo):
		FF-FE-01..08 entram como obrigacoes de fitness function que o CI do
		frontend-runtime cumpre.

		Autonomia da fonte: este ADR e a fonte canonica desta decisao e NAO
		referencia o arco de arquitetura anterior -- aqueles artefatos saem da
		governanca (delecao planejada) e um ponteiro nasceria condenado a danglar;
		nao-citar evita compor a divida que a faxina do adr-147 (cujo ponteiro
		"ADR-C4-01" quebra na mesma delecao) ja vai pagar.

		Tensao com axiomas: nenhuma.
		"""
}
