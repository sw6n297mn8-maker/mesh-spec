package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-165 — Trajetória do EventLogPort: contrato MÍNIMO (2 ops) agora, ops ricas
// SOB GATE quando a 1ª projeção real (Phase 1+) exigir; ORDEM-GLOBAL-LATENTE
// gap-free como obrigação-de-adapter (enforcement de P3); Postgres como PRIMEIRO
// vendor, com gatilho de troca por escala rastreado em def-072. Resolve def-041
// (o JIT dele chegou: o 1º adapter persistente — eventlog-postgres — entra em
// construção). O grafo causal (2ª obrigação latente de P3, envelope-locus) NÃO é
// descarregado aqui — rastreado em def-073. FRONTEIRA: este ADR DECIDE (trajetória
// + obrigação-de-adapter + vendor); a IMPLEMENTAÇÃO (eventlog-postgres) é RUNTIME.

adr165: artifact_schemas.#ADR & {
	id:    "adr-165"
	title: "EventLogPort: trajetória mínima-com-ordem-global-latente; Postgres como primeiro vendor"
	date:  "2026-07-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		def-041 deferiu o vendor-of-record do EventLogPort até o golden-example
		(decisão JIT), com gatilho "1º adapter persistente entrar em construção".
		Esse momento chegou: a fatia 2 do organismo persistente (mesh-runtime)
		constrói o eventlog-postgres — o 1º adapter persistente real. A decisão é
		devida AGORA, no ponto JIT que o próprio def-041 especificou.

		CRITÉRIO. A escolha foi por USO×REQUISITOS, não por carga: o que o
		EventLogPort é consumido para fazer HOJE vs o que o contrato rico exigiria.

		3 MATERIAIS (do read-only anterior). (i) O Mesh-Old desenhou o EventLogPort
		RICO — 5 ops (append/readStream/readAll/readAllGlobal/verifyIntegrity) +
		idempotência-por-eventId + GlobalPosition gap-free — e escolheu FoundationDB
		para servi-lo. (ii) O mesh-spec ATUAL não tem query-side global: o contrato é
		2 ops (append/readStream por agregado, adr-141/pm-dlv); os read-models
		existentes são por-agregado (fce/api.yaml, bkr/canvas) e o consumo cross-BC é
		per-fact por ponteiro (adr-149), não subscription a um fluxo global. (iii) O
		domínio (banco originador de recebíveis + FIDC) pede projeções cross-agregado
		— carteira de recebíveis (scf), análise composicional cross-BC
		(mesh-economic-assumptions), reconciliação — mas o spec as coloca em Phase 1+
		(NIM).

		DESCOBERTA. Os 3 contras do Postgres que o derrubaram no Mesh-Old (gaps em
		GlobalPosition, VACUUM em tabela append-only, ausência de change-feed durável)
		eram TODOS sobre o contrato RICO. No contrato mínimo (append/readStream por
		stream, com OCC), nenhum morde — o change-feed é papel do DeliveryPort na
		arquitetura atual, não do EventLogPort.

		SUPERVISIONABILIDADE. Num sistema AI-first operado por founder solo, a
		transparência de diagnóstico é requisito: Postgres é inspecionável (EXPLAIN,
		estado consultável); FoundationDB é robusto e excelente em escala horizontal
		de escrita, mas opaco no diagnóstico e de curva operacional íngreme (cluster
		sem managed service). A pesquisa corrigiu "FDB é frágil" → "FDB é robusto,
		mas de curva íngreme e opaco no diagnóstico, excelente numa escala que ainda
		não temos".

		ALTERNATIVAS. (a) contrato rico + FDB agora — REJEITADA: paga curva/opacidade/
		ops de cluster por capability cujo 1º consumidor real é Phase 1+; o custo é
		majoritariamente fundo-perdido até existir leitor global. (b) mínimo puro (sem
		gravar ordem global no write-time) — REJEITADA: perde a opção rica de forma
		irreversível (ver decisão (b)). (c) mínima-com-ordem-global-latente + Postgres
		— ESCOLHIDA abaixo.
		"""

	decision: """
		TRÊS partes.

		(a) TRAJETÓRIA. O contrato do EventLogPort permanece MÍNIMO agora — 2 ops
		(append, readStream por agregado), como adr-141/pm-dlv fixam. As 3 ops ricas
		(readAll, readAllGlobal, verifyIntegrity) e a idempotência-por-eventId são
		adicionadas SOB GATE quando a 1ª projeção/leitura global real (Phase 1+ — NIM,
		carteira FIDC, reconciliação cross-tenant) as exigir. Adicionar ops depois é
		mecânico: o port-manifest ganha a operação, o gerador regenera a interface, e
		o compile-break força cada adapter a implementá-la — detectado, não silencioso
		(P7 + o gate de codegen). Deferir readAll não perde nada porque as projeções
		que o consomem são materializações rebuildáveis (P8).

		(b) OBRIGAÇÃO DE ORDEM-GLOBAL-LATENTE (a peça irreversível). Todo adapter
		PERSISTENTE do EventLogPort DEVE gravar uma ordem global gap-free no
		write-time, na MESMA transação do append, desde o 1º evento — MESMO sem
		expô-la via readAll. É obrigação de contrato de ADAPTER (mesma natureza que a
		durabilidade-através-de-restart de adr-164), não detalhe de implementação, e é
		o ENFORCEMENT de P3 (que já declara "global_position gap-free" como invariante
		estrutural do Event Log). Razão: a ordem global no write-time é a única coisa
		que NÃO se reconstrói depois — capturá-la latente preserva a opção rica (a) de
		graça. EXIGÊNCIA NOMEADA (anti-erro-silencioso): gap-free exige um CONTADOR
		TRANSACIONAL (incrementado na transação do append), NÃO um BIGSERIAL/sequence
		solto — que produz buracos sob concorrência (o contra (a) do Mesh-Old). O
		adapter que nascer com sequence solto viola esta obrigação.

		(c) PRIMEIRO VENDOR = Postgres. Racional: (1) a ordem-global-latente (b) e a
		idempotência-por-eventId saem quase de graça (contador transacional + índice
		único); (2) supervisionabilidade por transparência (EXPLAIN, estado
		inspecionável) — requisito de diagnóstico AI-first; (3) curva operacional leve
		e transferível para o regime atual (sem escala). GATILHO DE TROCA nomeado:
		escala horizontal de escrita que colida com o contador global único (o ponto
		onde o gap-free serializado vira gargalo) — a condição em que o FoundationDB
		(escala horizontal nativa) passa a se justificar. A troca é cega via Port (P7)
		+ o gate de durabilidade (adr-164); rastreada em def-072.

		P3 TEM DUAS OBRIGAÇÕES LATENTES; ESTE ADR DESCARREGA UMA. P3 manda
		"global_position gap-free" E "grafo causal obrigatório". A parte (b) descarrega
		a PRIMEIRA como obrigação-de-adapter (locus: o adapter, o único que pode
		atribuir uma ordem global cross-stream). A SEGUNDA — o grafo causal
		(causationId/correlationId no envelope do evento) — NÃO é descarregada aqui:
		seu locus é o CONTRATO DO EVENTO + o produtor (o adapter só persiste fielmente
		o que o evento carrega; não pode fabricar causalidade que o produtor não deu),
		e o envelope atual (mesh-runtime CanonEvent) ainda não a carrega — é evolução
		do contrato de evento, da mesma família do eventId/idempotência deferido em
		(a). É igualmente irreversível (intrínseca-ao-append) e está rastreada em
		def-073. Nomeada aqui para que o leitor não conclua que P3 está fechado.
		"""

	consequences: """
		POSITIVAS. (1) O caminho rico fica preservado de graça: a ordem-global-latente
		(b) garante que, quando a 1ª projeção Phase 1+ chegar, readAll é adicionável
		sem migração de dados. (2) O custo do FoundationDB (ops de cluster, curva,
		opacidade) não é pago por capability dormente — só quando a escala o exigir.
		(3) def-041 sai do backlog disparado (resolved, não re-adiado) no ponto JIT
		que ele mesmo especificou.

		NEGATIVAS / RESÍDUO. (1) A ordem-global-latente é obrigação de contrato de
		adapter cujo ENFORCEMENT determinístico (um teste de concorrência que prove
		gap-free) é trabalho de RUNTIME — até existir, vale a obrigação declarada +
		review. (2) O grafo causal (2ª obrigação P3, envelope-locus) fica latente e
		irreversível, rastreado em def-073 — não descarregado aqui. (3) A troca de
		vendor por escala é decisão futura rastreada em def-072, não fechada.

		Fronteira regulatória: nenhuma diretamente. A ordem gap-free e a
		supervisionabilidade sustentam auditoria/reconciliação futuras, mas este ADR é
		decisão de trajetória/vendor/obrigação-de-adapter, não movimento de dinheiro.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE a ordem-global-latente no Postgres não puder ser gap-free sob concorrência real (o contador transacional vira gargalo OU produz buracos), OU se o custo de supervisionar/operar o Postgres no regime atual se provar maior que o previsto — invertendo o trade-off vs FoundationDB ANTES de a escala justificar a troca."
		observableSignal: "No harness do mesh-runtime: um teste de concorrência sobre o eventlog-postgres em que a ordem global apresenta buracos OU o append serializado pelo contador vira gargalo mensurável sob carga sintética; OU custo/incidentes operacionais do Postgres registrados acima do previsto antes do gatilho de escala de def-072."
	}

	affectedArtifacts: [
		"architecture/deferred-decisions/def-041-eventlogport-vendor-of-record.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-072-eventlog-vendor-scale-revisit.cue",
		"architecture/deferred-decisions/def-073-causal-graph-envelope-materialization.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo: ["def-072", "def-073"]

	principlesApplied: [
		"P3 — Event Log append-only com global_position gap-free e grafo causal obrigatório: a obrigação de ordem-global-latente (decisão b) é o enforcement da 1ª metade; a 2ª (grafo causal) fica rastreada em def-073, não descarregada aqui.",
		"P6 — idempotência por chave única (event_id): a idempotência-por-eventId é deferida sob gate junto com as ops ricas (envelope-locus, mesma família do grafo causal).",
		"P7 — 5 Ports canônicos, vendors atrás de adapters: a troca de vendor (Postgres→FDB) é migração de adapter atrás do Port, não reescrita.",
		"P8 — materializações são projeções rebuildáveis: deferir readAll não perde nada porque as projeções que o consomem são reconstruíveis (Phase 1+).",
		"P10 — gate determinístico valida: a expansão do contrato (ops ricas) entra sob gate, não por convenção.",
		"adr-164 — durabilidade como obrigação-de-adapter: precedente da forma 'obrigação de contrato de adapter, impl no runtime' que a ordem-global-latente segue.",
		"adr-139 — reconciliação spec×runtime do wave-plan de stack: as decisões de stack do Mesh-Old (incl. FDB) entram como candidatas a reconciliar, não como vínculo.",
	]

	rationale: "Resolve def-041 no ponto JIT que ele especificou (1º adapter persistente em construção), escolhendo a trajetória mínima-com-ordem-global-latente + Postgres como 1º vendor por USO×REQUISITOS: o contrato mínimo não sofre os contras que o rico sofreria, a ordem-global-latente (contador transacional, NÃO BIGSERIAL) preserva a opção rica de graça enforçando P3, e Postgres dá supervisionabilidade e leveza para o regime atual sem escala. FDB fica reservado ao gatilho de escala (def-072). O grafo causal (2ª obrigação P3, envelope-locus, irreversível) é nomeado e rastreado em def-073, não descarregado aqui — o adapter não pode fabricar causalidade que o produtor não deu."
}
