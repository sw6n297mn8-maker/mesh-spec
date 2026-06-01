package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr134: artifact_schemas.#ADR & {
	id:    "adr-134"
	title: "Instituir o protocolo agent-probe (Ciclo 4 dos feedback-cycles de build-time)"

	date: "2026-05-31"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Ciclo 4 da sequência de feedback-cycles de build-time. Os Ciclos 1-3
		entregaram gates DETERMINÍSTICOS (acyclicity sc-cm-07, falsificationCondition
		adr-132, flow-event-closure sc-ccf-03). Falta a dimensão que estrutura não
		alcança (P10/adr-040): a spec de um BC consegue expressar o domínio sem furo
		para um leitor que só tem o canvas? O agent-probe responde isso — dá o canvas
		fechado a um agente limpo, pede testes de aceitação, e trata cada
		ambiguidade/alucinação como buraco na spec. É validação semântica ADVISORY.

		Estado verificado: o precedente mais próximo é validation-prompt (advisory,
		isento de structural-check por self-containment, não por advisory-ness — o
		gêmeo self-review-report TEM check referencial sc-srr-01 porque carrega
		cross-ref). O agent-probe tem as duas faces: o PROTOCOLO é self-contained
		(como validation-prompt); o RECORD carrega targetCanvas (cross-ref, como
		self-review-report).

		Alternativas avaliadas para a COBERTURA ("todo canvas foi probado?"):
		(C) métrica de dd-status, sem gate — REJEITADA: menos visível; o founder opera
		    por gatilho externo (def-034), e métrica num relatório à parte some.
		(B) nada — REJEITADA: "nada garante" deixa canvas não-probado invisível.
		(reject) gate born-reject — REJEITADO: born-red afoga sinal (14 canvases
		    não-probados hoje), anti-pattern dos Ciclos anteriores.
		"""

	decision: """
		(1) CRIAR 2 schemas: #AgentProbeProtocol (self-contained — isolation contract,
		    probeTask, promptTemplate versionado, findingTaxonomy, closingDoD) e
		    #AgentProbeRecord (targetCanvas cross-ref; runs[] append-only; #ProbeFinding
		    como UNIÃO DISCRIMINADA por #ProbeFindingCategory — 7 categorias: 3 de defeito
		    deste canvas + cross-bc-gap [gaps reais], deferred-by-design + already-specified
		    [não-defeitos], e probe-noise [alucinação]. GAP REAL exige disposition;
		    não-defeito e probe-noise não). A união é o DoD-completeness que neutraliza
		    Goodhart: gap real sem disposition falha cue vet. probe-noise reservado a
		    alucinação genuína mantém honesto o ratio spec-finding/probe-noise da
		    falsificationCondition — rotular não-defeito como noise faria o record mentir.

		(2) ESTENDER #ArtifactType com agent-probe-protocol + agent-probe-record (aditivo).

		(3) CRIAR sc-apr-01 (referencial — todo probe-record aponta a canvas existente):
		    reusa filesystem-path-exists (gêmeo de sc-srr-01); born-green. E sc-apr-02
		    (cobertura A — todo canvas tem >=1 record): reusa directory-pair-coverage
		    (gêmeo de sc-dp-01); enforcement "warn" (catraca adr-097), born-warn = 13
		    (14 canvases - fce). SEM kind novo, SEM handler novo.

		(4) sc-meta-02 exemptTypes += agent-probe-protocol (self-contained, cue vet
		    basta); agent-probe-record NÃO é exempt (coberto por sc-apr-01).

		(5) MATERIALIZAR o protocolo singleton (architecture/agent-probes/protocol.cue) +
		    o 1º probe-record (records/fce.cue — a triagem F1-F21 do canvas FCE feita
		    nesta sessão: 16 findings — 5 gaps reais com disposition (4 deste canvas
		    S6/S7/S9/P0 + 1 cross-bc-gap S3) + 11 não-defeitos (4 deferred-by-design +
		    7 already-specified) + 0 probe-noise).

		(6) NÃO corrigir os defeitos do FCE aqui. Os findings reais (S6/S7/S9/P0) são
		    BACKLOG DE CORREÇÃO do FCE (adr-135+, sessão própria); o record os REGISTRA.

		(7) O residual (promover cobertura warn->reject quando os 14 forem probados;
		    automação do dispatch; wiring no painel def-034; PGs dos 2 tipos) vive em
		    def-035 — nenhuma prose 'Known gaps' aqui.
		"""

	consequences: """
		Positivas:
		(P1) A spec de cada BC ganha um falsificador semântico advisory — pega o erro
		     de modelagem que só aparece quando um agente constrói em cima.
		(P2) Cobertura A torna canvas não-probado VISÍVEL no gate principal (13 warns),
		     alinhado ao perfil 'gatilho externo' do founder.
		(P3) Reuso total de mecânica (filesystem-path-exists + directory-pair-coverage):
		     sem kind/handler novo — evita o gotcha evaluator-coverage do adr-099.
		(P4) DoD-completeness via união discriminada neutraliza Goodhart estruturalmente.

		Negativas:
		(N1) Born-warn pode virar zombie (warn que ninguém promove a reject). Mitigação:
		     def-035 + dd-status rastreiam; a falsificationCondition observa a catraca.
		(N2) Goodhart residual: o DoD exige disposition, mas um agente sob pressão pode
		     classificar defeito real como probe-noise para evitar disposition. Mitigação:
		     founder tria (triaged); o ratio sinal/ruído é observável.
		(N3) A taxonomia de FailureClass (S6) é cross-BC (BKR) — o probe a surfou mas a
		     correção atravessa BCs; registrada como residual, não resolvida aqui.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta decisão (agent-probe como Ciclo 4, cobertura A born-warn) estará errada
			SE o probe nunca achar buraco real (conluio — o agente probador sai sempre
			limpo, ratificando em vez de falsificar) OU a cobertura born-warn nunca for
			promovida a reject (zombie — ninguém proba os canvases nem fecha o gate) OU
			def-035 disparar repetidamente após estabilização (DoD insuficiente — records
			passam o cue vet mas não capturam buraco genuíno).
			"""
		observableSignal: """
			Ratio spec-finding/probe-noise nos records (baixo demais = conluio; o probe
			não falsifica); estado da catraca de cobertura (eternamente warn = zombie);
			e frequência de disparo de def-035 após a primeira estabilização (recorrente
			= o DoD não está forçando probe genuíno).
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/agent-probe-protocol.cue",
		"architecture/artifact-schemas/agent-probe-record.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/structural-checks/agent-probe-record.cue",
		"architecture/structural-checks/meta-coverage.cue",
		"architecture/agent-probes/protocol.cue",
		"architecture/agent-probes/records/fce.cue",
		"architecture/agent-probes/_meta.cue",
		"architecture/deferred-decisions/def-035-agent-probe-coverage-residual.cue",
	]

	principlesApplied: ["P0", "P10", "P12"]

	supersedes: []

	rationale: """
		P10 (gates determinísticos validam; agentes recomendam): o agent-probe é
		EXPLICITAMENTE advisory — o probe recomenda buracos, o founder tria, nada gateia
		o merge pela opinião do agente. A cobertura (sc-apr-02) e a referência (sc-apr-01)
		são determinísticas (existência de arquivo/path), P10-limpas — gateiam o
		PROCESSO ter rodado, não a ADEQUAÇÃO do finding (que é interpretativa).
		P0 (localização canônica): protocolo + records têm lar único em
		architecture/agent-probes/; o promptTemplate é campo versionado, não .md duplicado.
		P12 (governança como código): a cobertura vira fitness function versionada no CI.

		Por que cobertura A (não C/B): rejeitado 'nada garante'; o born-warn torna o gap
		visível sem afogar (Goodhart neutralizado pelo DoD-completeness — record vazio
		falha cue vet). Por que reuso (não kind novo): closure referencial e pareamento
		de cobertura já têm kinds (filesystem-path-exists, directory-pair-coverage) +
		handlers — kind novo seria evitável (lição adr-133/adr-099).

		def-031..034 não cobrem Ciclo 4 (031=flow, 032=falsificação, 033=Ciclo2, 034=painel);
		def-035 é o lar do residual (promoção da catraca, automação, PGs). Colisão de id:
		o earmark def-035 do audit WI-132 cede — quem materializa primeiro fica com 035
		(Ciclo 4); o output de wi-132 vira def-036 na execução do audit.

		Tensão com axiomas: nenhuma.
		"""
}
