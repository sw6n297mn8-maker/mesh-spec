package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr177RequisitionQuotationLinkAndPriceProvenanceGate: build_time.#SelfReviewReport & {
	reportId: "srr-adr-177-requisition-quotation-link-and-price-provenance-gate"

	artifactPath:       "architecture/adrs/adr-177-requisition-quotation-link-and-price-provenance-gate.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-13"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 2
		warnCount: 3
		infoCount: 3
		summary: """
			Round 1 — review por SUB-AGENTE ISOLADO (rollout adr →
			isolated-subagent), sem o histórico da sessão de autoria, sobre o
			adr-177 + a materialização integral da fatia, verificação factual
			contra o disco. NÚCLEO PASSA: decisão materializada = decisão
			declarada em todos os pontos verificáveis — sourcingDecisionRef +
			quantity nos 3 lugares; invariante nova com os 4 checks +
			dependsOnAggregateState → ssc via QueryQuotationMap; guard na
			transição triaged→approved com exatamente 2 braços;
			protectsInvariants e agent-spec coevoluídos; context-map hybrid
			com os 3 events INALTERADOS e sc-cm-07 confirmadamente cego a
			communication.type (edgeFilters verificados); NENHUMA relação
			p2p-to-ssc; runner 31/0 com sc-ag-01/02 em reject verdes;
			def-079 resolved com filename exato (shape do precedente
			def-028→adr-123 verificado nos dois arquivos); fato
			categoria-escopado confirmado; alternativas genuínas;
			falsificação observável; affectedArtifacts = exatamente os 5
			modified do git status.

			2 FAILS: F1 — o rationale citava 'ax-02 (evidência antes de
			dinheiro)': ax-02 real é agent-first (humans-in-the-loop); a tese
			'dinheiro só se move quando a operação comprova' vive em
			mech-evidence (foundingPrinciples) — ilusão de rastreabilidade
			(uq-03); o precedente adr-174 cita sem id de axioma. F2 —
			derivedArtifacts declarava structure-index cuja regeneração ainda
			não havia rodado no working tree (o reviewer executou o --check
			ANTES do passo de regeneração do batch; drift gate do CI
			falharia). 3 WARNS: W1 — coevolução de canvas ausente E não
			declarada (canvas p2p enumera 3 query-deps sem QueryQuotationMap;
			surface do ssc não nomeia p2p; adr-055 itens 5/8). W2 — prosa
			stale pré-existente no outer rationale do p2p domain-model ('1
			invariant declara dependsOnAggregateState') que a fatia tornou
			MAIS falsa ao adicionar o 2º invariante → ssc — arquivo tocado,
			varredura classe-2 não a pegou. W3 — 'cap-04' é alias informal;
			o id canônico é cc-04 (a amarração Lei 12.846 vive na capability
			do canvas p2p). 3 INFOS: I1 — o elo nomeado 'requisição↔cotação'
			aponta a DECISÃO (ref transitivo à cotação via vencedor) —
			imprecisão herdada do título do próprio def-079; I2 —
			supersedes: [] explícito (cosmético); I3 — description do
			qry-quotation-map não nomeia o gate do p2p como consumer (o
			rationale atualizado nesta fatia cobre).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 2
		summary: """
			Round 2 — correções aplicadas: F1 RESOLVIDO — apontamento trocado
			para mech-evidence/foundingPrinciples com o texto real da tese e
			nota do paralelo adr-174 (sem id de axioma fantasma). F2
			RESOLVIDO — scripts/ci/regenerate-derived.sh executado com GUARD
			(só structure-index mudou: +adr-177 na lista de ADRs;
			tree-generated e README regenerados idênticos). W1 RESOLVIDO por
			DECLARAÇÃO — (N4) nova nos consequences declara a janela de
			coevolução de canvas explicitamente (molde da janela do adr-174
			fechada no WI-153), com a nota de que o acoplamento operacional
			está declarado nos 3 lugares vivos; o fechamento (tocar canvas
			p2p/ssc) é decisão do founder no checkpoint. W2 RESOLVIDO — o
			parágrafo do outer rationale reescrito para a verdade atual (4
			invariants com dependsOnAggregateState: 2→ssc, 1→bdg, 1
			intra-BC) — arquivo em escopo, regra da fatia é reescrever prosa
			falsa, e a fatia a tornara mais falsa. W3 RESOLVIDO — cc-04 com
			a amarração correta. I1/I3 permanecem como infos aceitos (I1 é
			herança do def-079; I3 coberto pelo rationale atualizado). cue
			vet EXIT=0 pós-correções; runner re-executado 31/0 bloqueantes.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 3 — DECISÃO DO FOUNDER sobre o W1 (emenda pré-commit): NÃO
			declarar janela — fechar a coevolução de canvas NESTA fatia. A
			resolução por declaração do round 2 foi substituída pela
			resolução SUBSTANTIVA: canvas p2p ganhou a query-dependency
			QueryQuotationMap → ssc (4ª entry, shape idêntico ao braço bdg;
			rationale do canvas atualizado 3→4 query-dependencies); a
			surface QueryQuotationMap do canvas ssc nomeia P2P como
			consumidor do gate na description (forma do precedente
			QuerySourcingDecision — o shape query-surface não tem campo
			estruturado de consumer; nenhum campo inventado), preservando a
			cláusula de confidencialidade (consumo sistema-a-sistema, nunca
			superfície de fornecedor). No ADR: N4 (janela) SAIU — virou P6
			(coevolução completa das três faces, com a razão do founder:
			diferente da janela do WI-153 que dependia do def-076 pendente,
			o conteúdo estava disponível no ato; janela aqui seria evasão);
			decisão (6) e affectedArtifacts (+2 canvases) atualizados.
			Validação re-executada integral: cue vet EXIT=0; runner 31/0
			bloqueantes (catraca sc-ag-01/02/03 verde; sc-cm-06/07 sem
			violação/ciclo novo — canvas não é aresta de grafo);
			check-self-review PASSED; structure-index em sync.
			"""
	}]

	findings: {}

	summary: """
		adr-177 (accepted) resolve o def-079: elo requisição↔cotação
		carregado pelo p2p (sourcingDecisionRef + quantity firme) + 2º braço
		do portão de aprovação (invariante-gate determinístico de procedência
		de preço contra a cotação vencedora do ssc, espelhando o braço bdg) +
		context-map ssc-to-p2p hybrid sem aresta nova (sc-cm-07 verde por
		construção). Review isolado: núcleo PASSA em verificação factual
		integral; 2 fails corrigidos (apontamento de axioma → mech-evidence;
		structure-index regenerado), 2 warns corrigidos (prosa stale do outer
		rationale; cc-04), e o W1 (coevolução de canvas) fechado
		SUBSTANTIVAMENTE por decisão do founder no round 3: os dois canvases
		coevoluídos na fatia (query-dependency no p2p + consumer nomeado na
		surface do ssc), sem janela declarada — as três faces do acoplamento
		fecham juntas. 1ª fatia de domínio sob a catraca adr-176: sc-ag-02
		em reject permaneceu 0 com a coevolução. VEREDITO: stable, 0 fail
		residual, 0 warn residual.
		"""
}
