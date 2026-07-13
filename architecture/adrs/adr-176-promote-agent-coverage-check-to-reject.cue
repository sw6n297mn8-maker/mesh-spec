package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr176: artifact_schemas.#ADR & {
	id:    "adr-176"
	title: "Promover sc-ag-02 enforcement de warn para reject (catraca do gate agente↔modelo) + sc-ag-03 fecha a janela do BC sem agente"
	date:  "2026-07-13"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "high"
	blastRadius:   "local"

	context: """
		sc-ag-02 (instance-scoped-cross-file-coverage, adr-175) nasceu
		born-warn per catraca adr-097 — 61 itens sem cobertura no anúncio
		de ativação (2026-07-13). O arco de resolução foi executado em 3
		PRs no mesmo dia:
		- PR #210 (adr-175): o gate nasce e ANUNCIA o baseline — 61 itens
		  (bdg 3, cmt 2, p2p 16, rew 35, ssc 5). ✓ merged.
		- PR #211 (WI-154, higiene A): coevolução de bdg/ssc/p2p — 21
		  coberturas + 3 exclusões padrão C; 10 correções de prosa
		  classe-2 no bdg. Baseline 61→37. ✓ merged.
		- PR #212 (WI-155, higiene B): coevolução de cmt/rew — 6 coberturas
		  + 31 exclusões (3 classes com frase-marca literal por membro + 1
		  por-id honesty). Baseline 37→0. ✓ merged.

		Estado pré-promoção (verificado no ato desta escrita, main @
		f36457d): sc-ag-02 = 0 violações; o runner resolve os 12
		agent-specs dos 12 BCs com domain-model — o zero é cobertura
		completa do que existe, não medição parcial. Todo building block
		operável das 6 famílias em todos os 12 BCs está em
		operationalScope/actions OU em scopeExclusions com rationale de
		marca literal.

		Catraca adr-097 (born-warn + irreversibilidade unidirecional)
		permite promoção warn→reject quando a contagem de violações zera.
		O rationale do próprio sc-ag-02 registrou a promessa desde o
		nascimento: 'promove a reject quando as higienes WI-154/WI-155
		zerarem o baseline'. Condição cumprida — promoção é o passo
		terminal do born-warn lifecycle.

		JANELA REVELADA pelo read-only desta fatia: o sc-ag-02 itera
		INSTÂNCIAS de agent-spec (files_for_at). drc e scf são canvas-only
		(sem domain-model, sem agente — forward-refs declarados nos
		canvases): hoje não há o que medir. Mas se um BC futuro ganhar
		domain-model SEM agente algum, o sc-ag-02 não o visitaria — o
		catálogo operável nasceria fora da lei sem gate que acuse. A
		catraca não deve nascer com um furo que só o processo (tq-dmg-12,
		cascade PG-A) cobre — a completude da própria catraca é parte
		desta fatia.

		Alternativas consideradas e rejeitadas:

		(a) Manter sc-ag-02 como warn. REJEITADA: catraca adr-097 exige
		promoção quando count zera — warn perpétuo após resolução é tag
		inútil e drift de política; drift futuro agente↔modelo não
		bloquearia CI, perdendo o ponto de ter o gate.

		(b) Promover em PR separado após soak time. REJEITADA: a catraca
		não exige observação empírica; atrasar separa decisão de evidência
		(precedente adr-123: 'adr-122 fecha; adr-123 finaliza — coesão
		temporal'). O arco de 3 PRs no mesmo dia É a evidência.

		(c) Rebaixar a info em vez de reject. REJEITADA: info é
		signal-only que CI ignora — perda completa de gate; não é estado
		válido per adr-097.

		(d) Fechar a janela do BC-sem-agente só com rede de processo
		(tq-dmg-12 no PG + founder review). REJEITADA: P10 — gate
		determinístico onde gate determinístico alcança; o kind
		directory-pair-coverage JÁ existe (zero motor novo), o par é
		verificável por construção e nasce green 12/12. Deixar em processo
		seria furo conhecido na lei recém-promovida.

		(e) Subir o modo default do runner junto. REJEITADA: scope creep —
		envelope separado; esta fatia promove um check e adiciona um par.
		"""

	decision: """
		Duas mudanças no MESMO arquivo
		(architecture/structural-checks/agent-spec.cue):

		(1) FLIP atômico do enforcement:
		  sc-ag-02.enforcement: "warn"  →  sc-ag-02.enforcement: "reject"
		O rationale do sc-ag-02 ganha a frase de fecho no mesmo padrão do
		irmão sc-ag-01 ('Born-green; promovido a reject (adr-114)'):
		'Promovido a reject em adr-176; baseline zerado pelas higienes
		WI-154/WI-155 (61→37→0, 2026-07-13)'.

		(2) sc-ag-03 NOVO (kind EXISTENTE directory-pair-coverage — zero
		motor, zero schema): para cada contexts/<bc>/domain-model.cue deve
		existir contexts/<bc>/agents/_meta.cue (o marcador do diretório de
		agentes; pareamento por wildcard <bc>, mesmo mecanismo do
		sc-apr-02). Nasce enforcement: "reject" DIRETO — born-green
		(12/12 pares verificados no ato). TRANSPARÊNCIA NORMATIVA: este é
		o PRIMEIRO check do repo a nascer reject no ADR de criação — o
		precedente mais próximo (sc-ag-01) nasceu warn-default no adr-113
		e foi promovido em ADR separado imediato (adr-114). É EXTENSÃO
		consciente do precedente, não aplicação: o adr-097 declara warn
		como default de nascimento sem proibir born-reject, e a razão de
		ser do born-warn (anunciar baseline sujo sem bloquear) não existe
		aqui — 12/12 verificado, zero dívida, zero janela de anúncio
		necessária. O founder aprova sabendo da novidade. Fecha por
		construção o cenário 'domain-model novo sem
		agente' que a iteração por instância do sc-ag-02 estruturalmente
		não vê. BCs canvas-only (drc, scf) ficam fora por construção — sem
		domain-model, sem source para parear.

		Este ADR NÃO toca:
		- architecture/adrs/adr-175-*.cue (precedente adr-123: o flip não
		  edita o ADR do born-warn; o forward-pointer já vivia no rationale
		  do check e ganha o fecho ali mesmo)
		- scripts/ci/structural-check-runner.py (kinds existentes; motor
		  intocado; sc-meta-01 segue verde)
		- agent-specs e domain-models (zerados nas higienes; nada a
		  coevoluir aqui)
		- def-079/def-080 (ortogonais; def-080 segue open — a mecanização
		  de ator/enforcement é fatia futura)
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE o gate em reject bloquear fatias legítimas de domain-model em volume que force exclusão-carimbo rotineira (scopeExclusions usado para destravar merge em vez de declarar não-operação real) OU reversões de emergência do enforcement — sinal de que a granularidade fatia-a-fatia da coevolução está mais cara que o drift que a lei evita (a falsificação (b) do adr-175, agora com dente)."
		observableSignal: "Observável em review de PRs futuros: exclusões novas cujo rationale não satisfaz o critério do adr-175 aparecendo junto de mudanças de domain-model (contáveis por diff de scopeExclusions); ou um ADR de reversão warn←reject (que per catraca adr-097 teria de aceitar o drift explicitamente). Zero ocorrências até aqui — o arco 61→0 foi fechado em 3 PRs sem carimbo."
	}

	consequences: """
		Positivas:
		(P1) Catraca adr-097 cumprida NO MESMO DIA do nascimento do gate
		(born-warn 2026-07-13 → reject 2026-07-13, com as duas higienes
		entre os dois) — o ciclo warn-first → validate → promote mais
		curto do repo, evidência de que anunciar baseline + higienes
		dirigidas convergem rápido.

		(P2) Gate determinístico nas DUAS direções do contrato
		agente↔modelo: sc-ag-01 (reject desde adr-114) mata ref fantasma
		(agente→modelo); sc-ag-02 (reject agora) mata mapa desatualizado
		(modelo→agente). Todo PR futuro que editar domain-model sem
		coevoluir o agent-spec do BC BLOQUEIA — 'o agente viaja com o
		modelo' deixa de ser recomendação e vira lei, integrada ao
		required-status-check do branch-protection per adr-110.

		(P3) A janela do BC-sem-agente fecha por construção (sc-ag-03):
		quando drc/scf (ou qualquer BC futuro) ganharem domain-model, o
		par agents/ é exigido no mesmo PR — a lei não tem porta lateral.

		(P4) Sem dupla-violação: sc-ag-01 e sc-ag-02 têm condições
		disjuntas (ref inexistente vs id não-coberto); o único caso em que
		ambos disparam (rename sem coevolução) aponta dois consertos reais
		distintos, não dupla-contagem.

		Negativas:
		(N1) One-way per catraca adr-097: reversão para warn exige ADR
		explícito aceitando drift. Custo: agility; ganho: integridade.

		(N2) Toda fatia futura de domain-model paga a coevolução (ou a
		justificação de exclusão) NO MESMO PR — o custo que a
		falsificação deste ADR e a (b) do adr-175 vigiam. Mitigação: as
		higienes provaram o custo baixo (WI-154: 3 BCs num PR; WI-155:
		2 BCs incl. a triagem de 35 itens do rew).

		(N3) O pivô do sc-ag-03 é o _meta.cue do diretório agents/ —
		convenção existente nos 12. Um BC futuro que crie agents/ sem
		_meta.cue falharia o par apesar de ter agente. Aceitável: _meta.cue
		é a convenção de diretório do repo (12/12 hoje) e o errorMessage
		nomeia o conserto exato.

		Fronteira regulatória: nenhuma. Decisão de gate interno.
		"""

	affectedArtifacts: [
		"architecture/structural-checks/agent-spec.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: [
		"P10 — a janela do BC-sem-agente sai da rede de processo e entra em gate determinístico (sc-ag-03, kind existente); a promoção converte signal advisory em gate, nunca o inverso.",
		"P0 — enforcement: 'reject' é estado canônico declarado no próprio check; o fecho da promoção vive no rationale do check (uma localização), não duplicado no adr-175.",
		"adr-097 — este ADR é instância da catraca born-warn→reject quando count zera; não altera a política, instancia (mesma relação que adr-123 declarou).",
		"adr-113/adr-114 — o irmão sc-ag-01 (born-green, promovido a reject em ADR separado imediato) é o precedente que o sc-ag-03 ESTENDE ao nascer reject no ADR de criação — primeira ocorrência no repo, novidade declarada na decisão; adr-117→123 é o precedente exato da transição warn→reject do sc-ag-02 com evidência de baseline zero.",
		"P12 — a catraca formaliza a progressão warn→reject como governance-as-code (política adr-097 instanciada), não decisão ad-hoc — mesma invocação do adr-123.",
	]

	supersedes: []

	rationale: """
		Princípios aplicados: P0 (estado canônico no check), P12/P10 (gate
		determinístico substitui vigilância humana para a dimensão
		'cobertura agente↔modelo'; a catraca adr-097 formaliza a
		progressão como governance-as-code, não decisão ad-hoc).

		Failure mode evitado: warn perpétuo após resolução (tag inútil) ou
		drift silencioso de agente (regressão sem bloqueio) — exatamente o
		que as fatias WI-151/152/153 sofreram ANTES do gate existir.

		Relacionamento com adr-175: este ADR é o passo terminal do
		lifecycle que o adr-175 declarou (decisão 4: 'Promoção a REJECT só
		após as higienes zerarem o baseline — catraca em ADR próprio, como
		adr-123 fez para sc-cm-07'). adr-175 NÃO é editado — precedente
		adr-123/adr-117.

		Relacionamento com WI-154/WI-155: são a evidência substantiva —
		61→37→0 com partição auditável através dos 5 BCs sujos: 27
		coberturas reais + 34 exclusões conscientes (3 padrão-C por chave
		estrutural issuesCommand + 30 por-classe com frase-marca literal +
		1 por-id honesty; 27+34=61). Sem elas, a promoção bloquearia o CI
		no próprio PR.

		Relacionamento com sc-ag-03: não é scope creep — é a completude da
		própria catraca. Promover o sc-ag-02 com a janela aberta seria
		promover uma lei com porta lateral conhecida; o read-only revelou,
		o founder decidiu fechar na mesma fatia, o kind existente torna o
		custo ~uma entry declarativa.

		Tensão com axiomas: nenhuma.

		Lenses consultadas: lens-ai-agent-governance, conceito
		aag-governance-as-code (born-warn → reject lifecycle é pattern
		canônico de adoption gradual). Nota: o adr-123 cita este conceito
		pelo nome informal 'lens-governance-as-code' — arquivo com esse
		nome não existe; o ponteiro correto é o conceito dentro de
		lens-ai-agent-governance (imprecisão do adr-123 grandfathered lá,
		não repetida aqui).
		"""
}
