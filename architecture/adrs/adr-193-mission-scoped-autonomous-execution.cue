package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr193: artifact_schemas.#ADR & {
	id:    "adr-193"
	title: "Estabelecer a execução autônoma escopada a missão autorizada"
	date:  "2026-08-13"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "high"
	blastRadius:   "repo-wide"

	context: """
		Estado precedente. Os três repos que constroem a Mesh carregam regimes de
		escrita gated e independentes: no mesh-spec, "Proposta Antes de
		Implementar" proíbe qualquer escrita sem aprovação explícita do founder;
		no mesh-runtime, o contrato de nascimento (adr-148) fixa dois OKs por
		fatia — um para o commit, outro para o push; no mesh-frontend-runtime,
		adr-157 herda o mesmo regime na variante gated-tight. Os três nasceram do
		arranjo um-agente-um-founder, onde a aprovação por degrau era barata
		porque o degrau era raro e o agente não conseguia coordenar-se com outro.
		Nenhum deles distingue a classe da mudança na hora de cobrar o OK: uma
		decisão de domínio e um handler que implementa decisão já tomada pagam o
		mesmo pedágio.

		Trigger. Sessão de 2026-08-13: a ds-buyer-procurement-journey — a jornada
		do canteiro ao pedido, a dor que a cunha da Mesh ataca — foi cruzada passo
		a passo contra as quatro camadas que a tornam executável (modelo,
		contrato, runtime, tela). Dos 10 passos, 1 fecha ponta a ponta (a
		requisição); a triagem roda por HTTP sem tela; os demais existem como
		modelo ou contrato sem runtime. O que falta é majoritariamente
		IMPLEMENTAÇÃO de semântica JÁ DECIDIDA: adr-174/WI-151 materializou
		requisição e triagem, WI-152 o mapa de cotações e o fato de submissão,
		WI-161 as rodadas de negociação, adr-177 o preço final na cotação
		vencedora, adr-182 o modelo de identidade e ator (resolvendo a metade auth
		de def-024). Simultaneamente, a execução multi-agente coordenada tornou-se
		operacionalmente disponível para construir sobre esses repos. O gargalo
		deixou de ser capacidade de execução e passou a ser o founder como
		componente serial: quem roteia entre agentes, aprova cada arquivo e
		autoriza cada push.

		A distinção que a decisão instrumenta. Semântica ausente não é a mesma
		coisa que implementação ausente. A primeira exige o founder por
		construção — a autoridade semântica é do mesh-spec e decisões caras de
		reverter não se delegam. A segunda não exige: escrever o handler de um
		command já modelado, ligar um módulo gerado ao build ou materializar uma
		tela sobre um endpoint vivo são passos reversíveis, validados por gates
		determinísticos que já existem e não melhoram com um OK humano no meio. O
		regime atual trata as duas classes como uma só. Esta decisão as separa, e
		só a segunda sai do caminho crítico do founder.

		Alternativas avaliadas: (a) manter o regime e delegar apenas fatias
		mecânicas isoladas — rejeitada: preserva o founder como roteador serial
		e não produz a evidência buscada (um time de agentes fechando uma
		travessia de story ponta a ponta); trata o sintoma, não o gargalo. (b)
		Decidir antecipadamente tudo que ainda está aberto — identidade
		operacional, vendor de orquestração, forma da superfície do fornecedor —
		e só então liberar a execução: rejeitada porque inverte a ordem de valor
		(decisão antes de evidência) e porque o próprio def-067 declara custo de
		deferir baixo e condiciona a escolha do vendor à existência de uma tela
		que exercite orquestração; escolher agora é infraestrutura antes da
		necessidade concreta. (c) Suspender o regime gated globalmente —
		rejeitada: remove o gate onde ele é barato e necessário (semântica,
		contratos públicos, persistência, constraints legais) e não tem
		encerramento natural; autonomia sem escopo não é delegação, é abdicação.
		(d) Instanciar o aparato de autonomy envelope existente
		(#AgentGovernance) — rejeitada: aquele schema governa agentes de DOMÍNIO
		dentro do produto Mesh, amarrado a agent-spec e lifecycle stages, e o
		tq-gv-14 proíbe execute-and-log para mutations por P10; reusá-lo para os
		agentes que CONSTROEM o repo confundiria as duas populações e enfraqueceria
		a fronteira que P10 protege. (e) Criar schema, registry ou runner de
		missões — rejeitada: aparato desproporcional ao gargalo observado; a
		missão é nomeada em conversa, o branch e o PR são o registro, e o receipt
		final é a prestação de contas.
		"""

	decision: """
		(1) ESCOPO. Esta decisão estabelece exclusivamente o modo de execução
		autônoma escopada a missão e os ponteiros mínimos que o tornam
		reconhecível pelos agentes dos repos participantes. Nada além: nenhum
		schema, runner, gate, registry ou framework de governança novo.

		(2) ESTABELECER o modo "execução autônoma escopada a missão" como exceção
		nomeada ao regime de escrita vigente no mesh-spec e, por herança dos
		contratos de nascimento, no mesh-runtime (adr-148) e no
		mesh-frontend-runtime (adr-157). Fora de missão autorizada, o regime
		padrão continua valendo integralmente e sem alteração.

		(3) ATIVAÇÃO. O modo só entra em vigor pela conjunção de dois atos: uma
		missão explicitamente NOMEADA, com escopo declarado, e autorização
		explícita do founder para aquela missão. Não existe autonomia implícita,
		herdada de missão anterior, nem inferida de autorização passada.

		(4) CONCESSÃO. Dentro de missão autorizada, agentes podem autonomamente:
		escrever, testar e regenerar artefatos derivados; criar branches e
		worktrees; coordenar subagentes; tomar decisões técnicas reversíveis;
		criar módulos HAND, handlers, adapters, projections, routes, fixtures,
		stubs, harnesses, testes e wiring; registrar decisões runtime-locais
		válidas; commitar; fazer push; abrir PRs; e integrar o trabalho entre os
		repos participantes. Correlativamente, o founder NÃO atua como roteador
		entre agentes, aprovador por arquivo, por commit ou por push, nem como
		revisor serial de passos reversíveis.

		(5) STOP OBRIGATÓRIO. O time interrompe a missão e escala ao founder
		somente quando não for possível continuar corretamente sem uma decisão
		envolvendo: (a) semântica ou capacidade nova ou alterada; (b) contrato
		público incompatível; (c) schema ou evento persistido com mudança
		incompatível; (d) fronteira de bounded context; (e) isolamento entre
		tenants; (f) constraint legal ou regulatória; (g) responsabilidade
		jurídica; (h) outra decisão comprovadamente cara de reverter e não
		resolvida pelo spec. Decisão técnica local e reversível NÃO é STOP.

		(6) CONTORNOS TEMPORÁRIOS. Fixtures, stubs, harnesses e hardcodes
		escopados à missão são permitidos quando preservam a semântica já
		aprovada, e o registro é proporcional à durabilidade: contorno que existe
		só para a missão vai no receipt final; contorno que vira decisão
		runtime-local durável vira rtd no repo de runtime; contorno que
		representa deferimento consciente sobrevivendo à missão vira def. Contorno
		silencioso é violação do modo.

		(7) INVARIANTES PRESERVADOS. O modo não relaxa P0, P1, P10, P14, o
		codegen-contract, cue vet, os structural-checks, o gate de freshness de
		materialização, o FF-CG-03 regenerate-and-diff, o build, os testes, os
		contratos de nascimento dos runtimes, o critério rtd-vs-ADR, as
		constraints legais e regulatórias, nem a autoridade canônica do
		mesh-spec. Código gerado nunca recebe edição semântica manual: divergência
		se resolve no gerador.

		(8) ENCERRAMENTO. A autonomia termina automaticamente em DONE, em BLOCKED
		ou por revogação do founder. O encerramento produz um receipt que declara
		o que foi feito, quais contornos foram usados e quais STOPs foram
		encontrados.

		(9) MATERIALIZAÇÃO POR PONTEIRO. governance/claude/config.cue ganha uma
		seção curta que aponta para este ADR como norma canônica do modo, e o
		CLAUDE.md regenera a partir dela. Os repos subordinados espelham o
		ponteiro sob seus contratos de nascimento, cada um no seu veículo. Em
		nenhum caso a norma é copiada: apenas referenciada (P0).

		(10) NÃO-OBJETIVOS. Esta decisão não redesenha a governança de agentes,
		não cria autonomy schema, não instancia #AgentGovernance, não altera a
		governança de tarefas, não resolve def-067 nem def-082, e não generaliza
		para além do caso escopado a missão.
		"""

	consequences: """
		Positivas.
		P1 — O founder sai do caminho crítico da execução: por missão, a
		intervenção cai de N aprovações por degrau para uma autorização de entrada
		mais uma revisão do resultado.
		P2 — A fronteira semântica/implementação vira operacional em vez de
		interpretativa: a lista de STOP do item (5) é a definição executável de
		"esta decisão é do founder", consultável pelo agente sem julgamento caso a
		caso.
		P3 — Pegada mínima verificável: um ADR e três ponteiros. Nenhuma
		superfície nova para o CI conhecer, nenhum artefato novo para manter,
		nenhum registry para sincronizar.
		P4 — P10 permanece intacto por construção: o modo remove aprovação humana
		por degrau, não substitui gate determinístico por juízo de agente — o que
		valida continua sendo cue vet, structural-check, build e teste.
		P5 — Reversão barata e imediata: revogar é remover a seção de ponteiro;
		nada persistido, nenhum contrato público, nenhuma instância a migrar.

		Negativas.
		N1 — O resultado passa a depender da fronteira estar bem traçada: uma
		lista de STOP mal calibrada produz escalação excessiva (o gargalo volta) ou
		avanço indevido sobre semântica (dano real e caro). O risco desloca-se do
		volume de aprovações para a qualidade de uma única definição.
		N2 — A revisão do founder desloca-se de incremental para terminal: erros
		aparecem no fim da missão, não no degrau em que nasceram, e o blast radius
		de um erro cresce dentro da missão. Mitigado por branch isolada, PR e
		gates determinísticos a jusante — não eliminado.
		N3 — Contorno escopado à missão registrado apenas no receipt é menos
		durável que rtd ou def: numa missão longa, um contorno relevante pode
		escapar da memória do repo. Aceito deliberadamente — exigir rtd ou def
		para todo contorno recriaria o aparato que o item (1) recusa.
		N4 — O modo não tem enforcement determinístico próprio: nada impede
		mecanicamente um agente de exceder a concessão do item (4); o que existe
		são os gates a jusante e a revisão do PR. Aceito porque o gargalo
		observado é aprovação, não violação — criar enforcement agora seria
		infraestrutura antes da evidência.
		"""

	falsificationCondition: {
		condition: """
			A decisão estará errada se a autonomia escopada a missão não reduzir a
			intervenção do founder — isto é, se fechar uma missão exigir tantas
			escalações quanto o regime gated exigiria aprovações para o mesmo escopo.
			"""
		observableSignal: """
			Contagem de STOPs no receipt da primeira missão comparada à contagem de
			degraus de aprovação que o regime gated exigiria para o mesmo escopo.
			STOPs maior ou igual a degraus evidencia fronteira semântica/implementação
			mal traçada: o modo cobrou o custo da mudança sem entregar a autonomia.
			"""
	}

	affectedArtifacts: [
		"governance/claude/config.cue",
	]

	plannedOutputs: []

	derivedArtifacts: [
		"CLAUDE.md",
	]

	defersTo: []

	supersedes: []

	principlesApplied: ["P0", "P1", "P10", "P14"]

	rationale: """
		Por que esta opção entre as alternativas. O gargalo observado é o founder
		como componente serial da execução, não a ausência de governança. As
		alternativas (b) e (c) erram em direções opostas — uma decide antes de ter
		evidência, a outra remove o gate onde ele é barato — e ambas custam mais
		que o problema. A opção escolhida é a única que ataca exatamente o degrau
		que dói (aprovação por passo reversível) sem tocar no degrau que protege
		(decisão semântica cara de reverter).

		P0 governa a forma da materialização: a norma vive uma vez, neste ADR, e os
		três agent contracts a referenciam por ponteiro — copiá-la para os três
		repos seria drift por construção no exato artefato que define como os
		agentes se comportam. P10 é o invariante que a decisão mais poderia
		ameaçar e o item (7) o preserva explicitamente: o que a decisão remove é
		aprovação humana por degrau, não gate determinístico — nenhum juízo
		estocástico passa a validar o que cue vet, structural-check ou build
		validavam. P1 e P14 entram como fronteira inegociável do que a autonomia
		alcança: gerado nunca recebe edição semântica manual e a forma
		compile-time-verificável continua descendo da spec, mesmo quando o agente
		trabalha sem supervisão por degrau — autonomia de execução não é licença
		para contornar o gerador.

		A recusa de (d) merece registro porque é a alternativa que parecia mais
		barata: já existe aparato de autonomy envelope no repo. Mas #AgentGovernance
		governa os agentes de domínio DENTRO do produto — agt-ssc-primary e
		congêneres — com lifecycle stages e a proibição tq-gv-14 de conceder
		execute-and-log a mutations. Os agentes que constroem o repo são outra
		população, sob outro contrato (adr-148, adr-157). Instanciar o envelope
		para eles borraria justamente a fronteira que P10 existe para manter
		nítida, e o custo de desfazer essa confusão depois seria maior que o de
		escrever este ADR.

		Trade-offs. N1 e N2 são o preço estrutural de trocar revisão incremental
		por revisão terminal, e são aceitos com mitigação parcial declarada
		(branch, PR, gates a jusante). N4 é aceito por disciplina de valor: o
		modo não ganha enforcement próprio porque o problema observado é
		aprovação, não violação — construir o enforcement agora repetiria o
		padrão que a alternativa (b) foi rejeitada por cometer. N3 é a única
		concessão deliberada de durabilidade, e existe para que o registro de
		contorno permaneça proporcional em vez de virar aparato.

		Metadata. reversibility high: revogar é remover a seção de ponteiro —
		nada persistido, nenhum contrato público consumido por terceiros, nenhuma
		instância a migrar; o custo de desfazer é o de um commit. blastRadius
		repo-wide: a decisão altera o contrato comportamental do agente, que
		governa toda escrita em todos os repos participantes — "cross-cutting"
		subdimensionaria pela taxonomia, já que o alcance é a governança do
		repositório inteiro e não um conjunto de domínios. A combinação
		reversibility high com blastRadius repo-wide é coerente e deliberada:
		alcance largo, custo de erro baixo — que é precisamente a condição sob a
		qual vale experimentar em vez de deliberar mais.
		"""
}
