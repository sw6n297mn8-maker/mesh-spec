package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr169: artifact_schemas.#ADR & {
	id:    "adr-169"
	title: "Kind item-scoped-cross-file-id-exists: escopo POR-ITEM no motor de structural-checks (cada item de lista valida refs contra o escopo declarado NELE)"
	date:  "2026-07-05"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		A pergunta de escopo em checks cross-file tem tres manifestacoes no
		disco: (1) def-052 — manifests com checks plain (uniao global), aperto
		same-BC deferido; (2) def-013 — check referencial do envelope bloqueado
		por lacunas proprias de engine; (3) as refs de building block do
		#DomainStory (adr-170), onde CADA PASSO declara seu proprio BC.

		O read-only do Tempo 1 (2026-07-05) estabeleceu com evidencia: as tres
		manifestacoes NAO sao a mesma lacuna. def-052 se resolve com o kind
		instance-scoped que JA EXISTE (adr-113 — manifests tem escopo unico na
		raiz: port-manifest.boundedContextRef, aggregate-manifest.aggregateRef);
		def-013 nao e destravado por kind nenhum (bloqueios: resolucao de
		fileset first-definition-wins + envelope sem campo de escopo); apenas
		a domain story e caso genuinamente POR-ITEM — um artefato com N passos,
		um BC por passo — inexpressavel no engine: o instance-scoped le o
		scopeField UMA vez na raiz e o _resolve_multi ACHATA as refs de todos
		os itens, destruindo o pareamento (escopo-do-item ↔ refs-do-item); o
		scoped-cross-file itera itens mas so como guarda de presenca, resolvendo
		contra a uniao global.

		O falso-verde que a uniao global produz e real e verificado: os
		domain-models listam eventos CONSUMIDOS de outros BCs (o modelo do fce
		contem evt-invoice-issued com sourceContext "inv") — uma ref no passo
		errado resolve pela copia consumida.

		As tres manifestacoes estavam dormindo (nenhuma travava trabalho
		ativo); a reconciliacao foi reportada ao founder, que DECIDIU construir
		o motor agora, com o desenho validado no read-only.
		"""

	decision: """
		(1) Kind novo ADITIVO no motor de structural-checks:
		item-scoped-cross-file-id-exists. Rule:
		#ItemScopedCrossFileIdExistsRule {itemsPath; scopeField RELATIVO AO
		ITEM; refFields relativos ao item; targetGlobTemplate com {scope};
		targetIdPaths}. Evaluator: para cada item de itemsPath → scope =
		dotget(item, scopeField) → alvo derivado do template (escopo ausente
		no disco = violacao 'escopo fantasma', herdando a semantica do
		adr-113) → namespace CACHEADO por escopo → refs do item contra o
		namespace DAQUELE escopo. Violacao nomeia arquivo + indice do item +
		escopo.

		(2) ADITIVIDADE como contrato: nenhuma funcao/evaluator existente e
		tocada; nenhum check existente migra nesta introducao. Prova executada
		no ato: baseline do runner IDENTICO pre/pos (31 violacoes / 0
		bloqueantes, diff vazio das linhas de violacao).

		(3) Primeiro consumidor: sc-ds-04..08 do domain-story (adr-170) —
		itemsPath steps[], scopeField workItem.boundedContextRef, alvo
		contexts/{scope}/domain-model.cue. As refs do work-item ficam LIMPAS
		(cmd-*/evt-*/...) — o motor le o BC do campo do passo; sem chave
		composta.

		(4) Fixture no self-test do runner replicando o cenario real: passo
		cmt referenciando evt-invoice-issued FALHA (o modelo do cmt nao o tem;
		a copia consumida do fce nao e alvo do escopo cmt); passo fce com
		evt-payment-settled PASSA; escopo inexistente acusa fantasma. O gate
		evaluator-coverage e satisfeito no mesmo commit (par kind↔evaluator
		entra junto).

		(5) NAO-MIGRACAO explicita: sc-mri-01/02 (def-052) seguem plain —
		o aperto deles continua aguardando evidencia de falso-positivo real e
		usara o instance-scoped (adr-113), nao este kind; def-013 permanece
		com seus bloqueios proprios. Registrado em nota datada no def-052.
		"""

	falsificationCondition: {
		condition:        "Esta decisao estara errada SE (a) o kind nao detectar o falso-verde que o motiva (ref resolvendo por copia consumida de outro BC) ou acusar falso-positivo em ref legitima do proprio escopo; OU (b) a introducao alterar o comportamento de qualquer check existente (nao-aditiva); OU (c) nenhuma segunda consumidora por-item aparecer e o custo de manutencao do kind superar o valor do unico consumidor (domain-story) — sinal de que a opcao 1 (sem motor) teria bastado."
		observableSignal: "Fixture no self-test do runner (--self-test) prova (a) deterministicamente: cmt+evt-invoice-issued FALHA com mensagem exata, fce+evt-payment-settled PASSA, escopo zz acusa fantasma. (b) e provada pelo diff vazio do baseline 31/0 pre/pos, re-executavel a qualquer momento. (c) e observavel na propria lista de checks: consumidores do kind alem de sc-ds-04..08."
	}

	consequences: """
		Positivas: o engine passa a expressar escopo por-item — a classe de
		validacao que jornadas (N escopos por artefato) exigem; o falso-verde
		por copia consumida morre para as stories; def-052 ganha nota honesta
		separando as tres manifestacoes (a capacidade existe; migracao de cada
		uma e decisao propria).

		Negativas/custos: um kind a mais no vocabulario do engine (21→22) uma
		semana apos a reforma adr-166 — mais superficie de manutencao; o unico
		consumidor hoje e o domain-story (a reconciliacao mostrou as outras
		manifestacoes dormindo ou servidas por kinds existentes) — o valor do
		motor depende da story materializar; a falsificationCondition (c)
		vigia exatamente isso.
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/deferred-decisions/def-052-manifest-cross-file-scoping.cue",
	]

	principlesApplied: [
		"P10 — o kind é gate determinístico (reproduzível, sem variância); a camada estocástica só recomenda — o motor valida.",
		"P0 — refs LIMPAS no work-item (o BC vem do scopeField do passo): chave composta duplicaria o escopo dentro de cada ref, drift por construção.",
		"adr-113 — herda a semântica instance-scoped (escopo fantasma = violação; least-privilege) estendendo-a ao grão por-item.",
		"adr-097 — consumidores nascem warn (catraca); a introdução do kind não promove nada.",
	]

	supersedes: []

	rationale: """
		O founder decidiu construir o motor AGORA sobre o desenho validado no
		read-only — com a reconciliacao honesta na mesa (tres manifestacoes
		dormindo; uma so e por-item). A alternativa (opcao 1: refs com chave
		composta, sem tocar o motor) foi rejeitada pelo founder porque
		duplicaria o BC do passo dentro de cada ref (drift por construcao,
		contra P0) e porque o desenho por-item ja estava provado barato e
		aditivo. A alternativa de esperar segunda consumidora foi rejeitada
		conscientemente: o custo do kind e pequeno, o desenho estava validado,
		e a story — primeiro consumidor — e a proxima fatia do arco.
		"""
}
