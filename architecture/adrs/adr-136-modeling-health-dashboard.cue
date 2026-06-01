package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr136: artifact_schemas.#ADR & {
	id:    "adr-136"
	title: "Painel de saúde de modelagem materializado como tooling resolve def-034 (Camada 3 de feedback)"

	date: "2026-06-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-034 (Camada 3 de feedback) registrou um painel de saúde de modelagem de
		build-time com métricas North-Star, DEFERIDO por dependência dura: 2 das 3
		métricas originais (falsificação acionada; flows verdes) não tinham o que
		medir até os campos/checks subjacentes existirem — a métrica de falsificação
		dependia do campo falsificationCondition (def-032) e a de flows do oráculo de
		closure de flow (def-031). Materializar antes produziria um painel com colunas
		vazias (painel zumbi que treina o founder a ignorá-lo).

		Auditoria desta sessão (pré-flight de fechamento) verificou que a razão
		OPERANTE do deferimento caiu — as FONTES de dados existem agora:

		(1) O campo falsificationCondition já existe no #ADR (materializado por
		    adr-132); 7 ADRs já o declaram — a métrica de PRESENÇA tem base de dados.
		(2) O oráculo de closure de flow já existe como gate determinístico: sc-ccf-03
		    (kind flow-event-closure, adr-133) produz violações parseáveis. A métrica
		    de flows verdes tem fonte.
		(3) A métrica de fronteira-volatility sempre teve fonte (git log sobre
		    contexts/*/canvas.cue).

		Distinção importante: def-031 e def-032 permanecem OPEN — eles rastreiam o
		trabalho de GATE (def-031: promover a closure a gate pleno; def-032: o
		structural-check condicional por decisionClass). O painel consome as FONTES
		que esses DDs deixaram materializadas (o campo, o check), sem fechá-los e sem
		depender de que estejam fechados. O que NÃO existe ainda é detecção de
		falsificação ACIONADA (vs declarada) — dimensão a mais, não o painel inteiro.

		Alternativas:
		(a) Manter def-034 aberto até existir detecção de falsificação acionada.
		    REJEITADA: ata a entrega do instrumento inteiro a uma única sub-métrica;
		    as 4 métricas materializáveis hoje já dão o instrumento de revisão
		    periódica que o deferimento prometia.
		(b) Materializar o painel como tooling (scripts/, fora do regime de
		    artifact-schema) reportando 4 métricas — fronteira-volatility, flows
		    verdes, cobertura probe + falsificação como PRESENÇA (não acionada) — e
		    resolver def-034 (status-A: a razão operante do deferimento foi
		    satisfeita). ESCOLHIDA.
		"""

	decision: """
		(1) Materializar scripts/ci/modeling-health.sh — reporter read-only,
		    standalone (fora de qualquer workflow CI), exit 0 sempre (observabilidade
		    sob demanda, não gate). Tooling: vive em scripts/ (zona excluída da
		    classificação por artifact-schema, governance/repo-structure.cue
		    scope.excluded), sem ADR/SRR próprios do script (precedente dd-status.sh).

		(2) O painel reporta 4 métricas: (1) fronteira-volatility (git log
		    contexts/*/canvas.cue, janela 30d); (2) falsificação DECLARADA (presença):
		    contagem de ADRs com o campo falsificationCondition — label literal
		    'declarada (presença): N ADRs', NÃO 'acionada'; (3) flows verdes
		    (cross-context-flows sem evento órfão, derivado do parse de sc-ccf-03);
		    (4) cobertura probe (canvases com >=1 agent-probe-record, derivado do
		    parse de sc-apr-02).

		(3) As métricas 3 e 4 DERIVAM do structural-check-runner (parse de
		    sc-ccf-03 / sc-apr-02), não recomputam a regra — o painel é projeção dos
		    gates, não uma segunda fonte da regra (P0).

		(4) RESOLVER def-034 (status → resolved, resolvedBy = este ADR) por status-A:
		    a razão OPERANTE do deferimento (as fontes de dados não existiam) foi
		    satisfeita — o campo falsificationCondition (adr-132) e o check sc-ccf-03
		    (adr-133) existem agora. O painel é OBSERVABILIDADE para acompanhar
		    def-031/def-032 ao longo do tempo, não a coroação deles: não depende de
		    031/032 estarem fechados para ser útil.
		"""

	consequences: """
		Positivas:
		(P1) Camada 3 de feedback (revisão periódica de saúde de modelagem) ganha
		     instrumento concreto — substitui vigilância contínua por gatilho externo,
		     o desenho certo para o perfil do founder (def-034 description).
		(P2) Zero duplicação de regra: flows verdes e cobertura probe vêm do parse do
		     runner, não de uma reimplementação da closure/coverage (P0). Se a regra
		     mudar no check, o painel reflete sem edição do painel.
		(P3) Tooling fora do regime de artifact-schema: o script pode evoluir sem
		     ciclo de ADR/SRR (precedente dd-status.sh), proporcional ao seu papel
		     (reporter advisory, não gate).

		Negativas / limitações conhecidas (residual):
		(N1) Métrica 2 mede PRESENÇA do campo falsificationCondition, não falsificação
		     ACIONADA. Medir disparo exige um campo novo (e.g., falsificationActioned)
		     no #ADR + detecção — trabalho próprio, não coberto por este painel. Fica
		     registrado aqui como limitação; promover a 'acionada' é evolução futura,
		     não regressão.
		(N2) Métrica 1 (volatility) é proxy GROSSO: conta qualquer edição em
		     contexts/*/canvas.cue (inclusive refactor mecânico), não só mudança
		     semântica de fronteira. Refinar exige diff semântico — fora de escopo.
		(N3) As métricas 3-4 dependem do formato de stdout do runner para o parse. Se
		     o runner mudar o formato de linha de violação, o parse quebra — coberto
		     pela falsificationCondition deste ADR.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Esta decisão (painel materializado como tooling fecha def-034) estará
			errada SE o painel divergir do estado real — o parse de sc-ccf-03/sc-apr-02
			quebrar e as métricas pararem de bater com o runner/git — OU se o painel
			virar observabilidade morta (ninguém o roda na cadência de revisão), caso
			em que o instrumento prometido por def-034 não foi de fato entregue.
			"""
		observableSignal: """
			(1) Divergência: rodar scripts/ci/modeling-health.sh e comparar com o
			runner/git — flows verdes != (flows - violações sc-ccf-03), cobertura
			probe != (canvases - violações sc-apr-02), ou contagem de falsificação !=
			ADRs com o campo. Qualquer divergência = parse quebrado. (2) Morte:
			ausência de referência ao painel nas revisões periódicas (sem uso
			registrado) ao longo de N revisitas.
			"""
	}

	affectedArtifacts: [
		"scripts/ci/modeling-health.sh",
		"architecture/deferred-decisions/def-034-modeling-health-dashboard.cue",
	]

	principlesApplied: ["P0", "P8", "P12"]

	supersedes: []

	rationale: """
		P12 (governança como código; observabilidade causal): o painel é a camada de
		observabilidade de build-time da governança — 'Observabilidade é causal, não
		apenas baseada em métricas' (P12). Materializar como código (script versionado,
		determinístico) em vez de inspeção manual ad-hoc é exatamente o que P12 pede.

		P0 (uma localização canônica; ponteiros, não cópias): as métricas 3 e 4 são
		PONTEIROS para o resultado do structural-check-runner (parse de sc-ccf-03 /
		sc-apr-02), não uma segunda implementação da regra de closure/cobertura.
		Reimplementar a regra no painel criaria duas fontes da mesma verdade — drift
		por construção. Por isso o painel parseia o runner em vez de reabrir os .cue.

		P8 (projeções derivadas dos SoTs, reconstruíveis, nunca source of truth): o
		painel é uma projeção descartável do estado de modelagem — pode ser deletado e
		reconstruído rodando o script; nunca é autoridade. É observabilidade para
		ACOMPANHAR def-031/def-032, não para coroá-los: a fonte canônica continua sendo
		os .cue + git + os structural-checks. 'não coroá-los' = nunca é source of truth
		para qualquer decisão (P8).

		Por que resolver def-034 agora (status-A, não esperar 031/032 fecharem): o
		deferimento era por dependência de DADOS (as fontes não existiam). Essa razão
		caiu — o campo falsificationCondition (adr-132) e o check sc-ccf-03 (adr-133)
		existem. O painel entrega o instrumento de revisão periódica com as fontes que
		há hoje; esperar 'falsificação acionada' ataria a entrega inteira a uma
		sub-métrica (N1), o que o próprio def-034 alertava como anti-padrão (painel
		parcial vs instrumento).

		def-034 vs def-031/def-032: independentes e desacoplados pelo fechamento. def-031
		(flow oracle) e def-032 (falsificationCondition gate) seguem OPEN com seu próprio
		horizonte — o painel CONSOME o que eles já materializaram (o check sc-ccf-03, o
		campo), não os fecha nem é por eles bloqueado.

		Tensão com axiomas: nenhuma.
		"""
}
