package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr135: artifact_schemas.#ADR & {
	id:    "adr-135"
	title: "Classificação de relação cross-BC já é gate-enforçada por schema + sc-cm-07 (resolve def-033)"

	date: "2026-06-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-033 (Ciclo 2 de feedback) registrou um gap: a classificação de relação
		cross-BC exigida por P13 (cada aresta tem pattern/kind, não só direção) seria
		"apenas advisory — verificada no founder-gate", e "uma aresta acíclica
		mal-classificada (sem pattern declarado) passa silenciosa pelo CI". A proposta
		era criar um structural-check que FALHA sem classificação.

		Auditoria desta sessão (pré-flight de fechamento) verificou que a premissa não
		se sustenta:

		(1) #Relationship (architecture/artifact-schemas/context-map.cue) é UNIÃO
		    DISCRIMINADA por direction: direction "upstream-downstream" exige
		    upstreamPattern + downstreamPattern; direction "mutual-dependency" exige
		    par #SymmetricPattern. Logo cue vet JÁ FALHA se uma aresta não tem pattern
		    classificado — não "passa silenciosa".

		(2) Ciclo sem kind tipado é pego por sc-cm-07 (directed-acyclicity, reject):
		    uma aresta cíclica não-excluída por kind/feedbackLoop tipado falha o build.

		(3) Cobertura atual verificada: 47/47 arestas reais classificadas, cue vet
		    EXIT=0. (A "48ª" da contagem ingênua era o code: do external-system target
		    ext-insurers, não uma aresta.)

		Alternativas:
		(a) Construir o structural-check proposto por def-033. REJEITADA: redundante —
		    a presença de classificação já é enforçada por (1)+(2); um check novo
		    duplicaria o que cue vet faz, e adicionaria superfície de manutenção
		    (kind/handler — gotcha adr-099) sem ganho determinístico.
		(b) Documentar que o gate já existe e resolver def-033. ESCOLHIDA.
		"""

	decision: """
		(1) NÃO criar structural-check de classificação de relação — seria redundante.
		    A PRESENÇA de classificação já é gate determinístico: pattern via
		    #Relationship (união discriminada por direction → cue vet reject) + kind de
		    ciclo via sc-cm-07 (reject).

		(2) A dimensão que NÃO é gate-able — pattern SEMANTICAMENTE correto (não só
		    presente e enum-válido) — é interpretativa (P10/adr-040) e permanece em
		    def-029 (validation-prompt advisory de derivação de BC), independente e
		    ainda diferido.

		(3) RESOLVER def-033 (status → resolved, resolvedBy = este ADR). O acoplamento
		    de materialização entre def-033 e def-029 (que existia para "co-construir o
		    gate sem fragmentar o protocolo de derivação") dissolve-se: não há gate a
		    construir, logo não há fragmentação. def-029 segue seu próprio horizonte
		    (revisita N≥4-5 OU 2026-09-30).
		"""

	consequences: """
		Positivas:
		(P1) Zero artefato novo de enforcement: o gate determinístico de classificação
		     já está no schema + sc-cm-07; o repo evita um check redundante e o gotcha
		     kind/handler (adr-099).
		(P2) Fronteira P10/adr-040 explícita: presença = determinístico (schema);
		     correção semântica = advisory (def-029). Sem confusão de camadas.
		(P3) def-033 sai do backlog de feedback com custo mínimo (documentação), sem
		     bloquear def-029.

		Negativas:
		(N1) A resolução depende do schema PERMANECER união-discriminada-por-direction
		     com pattern obrigatório. Se um refactor futuro afrouxar pattern para
		     opcional (ou adicionar uma direction sem pattern), o gate sumiria
		     silenciosamente. Mitigação: a falsificationCondition deste ADR observa
		     exatamente esse sinal (aresta sem classificação passando verde).
		"""

	reversibility: "high"
	blastRadius:   "local"

	falsificationCondition: {
		condition: """
			Esta decisão (classificação já é gate-enforçada; sem check novo) estará
			errada SE surgir um caminho de criar uma aresta no context-map sem
			classificação (pattern por direction OU kind de ciclo) que o cue vet + o
			sc-cm-07 NÃO peguem — por exemplo, o schema #Relationship afrouxar pattern
			para opcional, ou introduzir uma direction nova sem par de pattern
			obrigatório.
			"""
		observableSignal: """
			Uma aresta em strategic/context-map.cue sem upstreamPattern/downstreamPattern
			(ou, em ciclo, sem kind tipado) com cue vet EXIT=0 e sc-cm-07 verde — ou
			seja, classificação ausente passando o build. Monitorável a cada PR que
			toca o schema #Relationship ou o context-map.
			"""
	}

	affectedArtifacts: [
		"architecture/deferred-decisions/def-033-relation-classification-gate.cue",
		"architecture/artifact-schemas/context-map.cue",
		"architecture/structural-checks/context-map.cue",
	]

	principlesApplied: ["P10", "P12"]

	supersedes: []

	rationale: """
		P10 (gates determinísticos validam; agentes recomendam): a separação é o cerne.
		A PRESENÇA de classificação é determinística e já gateada (schema união
		discriminada + sc-cm-07). A CORREÇÃO da classificação (é o pattern certo?) é
		interpretativa — não gate-able sem reincidir em ten-006 — e vive em def-029
		(advisory). adr-135 não cria gate; documenta que o gate da metade determinística
		já existe.

		P12 (governança como código): a regra de classificação obrigatória já é fitness
		function versionada — no SCHEMA (#Relationship), não num check separado. Duplicá-la
		em structural-check violaria P0 (duas fontes da mesma regra) e adicionaria drift.

		Por que documentar (não construir): a auditoria provou 47/47 classificadas + cue
		vet reject sem pattern + sc-cm-07 reject sem kind de ciclo. Um check novo seria
		redundante por construção. Resolver def-033 por ADR de documentação é o
		caminho de menor blast radius coerente com o que já existe.

		def-033 vs def-029: independentes (gate determinístico já existe vs advisory
		interpretativo pendente). Este ADR resolve só def-033; def-029 não é tocado.

		Tensão com axiomas: nenhuma.
		"""
}
