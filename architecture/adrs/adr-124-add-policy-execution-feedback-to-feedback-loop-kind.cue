package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr124: artifact_schemas.#ADR & {
	id:    "adr-124"
	title: "Adicionar policy-execution-feedback ao #FeedbackLoopKind (PR-3 cycle-resolution, descoberta empírica via Ajuste 1)"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Durante a materialização do PR-3 (aplicação Família A em
		adr-122), o Ajuste 1 da Fase 3 (ordem de validação interna:
		aplicar Família A com enforcement ainda warn ANTES de promover
		warn→reject) capturou um ciclo NÃO PREVISTO no plano original
		do cycle-resolution.

		Estado esperado após adr-122 (aplicação Família A): sc-cm-07
		reportaria 0 ciclos. W1 (drc↔cmt) e W2 (cmt→rew→dlv→bdg→cmt)
		seriam quebrados pelos kinds typed; W3 (fce→drc→cmt→rew→fce)
		quebraria por cascata.

		Estado factual após adr-122 (validado): sc-cm-07 reportou
		1 ciclo remanescente: fce → rew → fce (2 arestas, rew-to-fce
		+ fce-to-rew). Causa empírica: antes do PR-3, o algoritmo
		Tarjan identificava o SCC grande de W3 (4 arestas) que
		agregava o sub-ciclo menor fce↔rew. Quando cmt-to-drc +
		rew-to-cmt foram excluídos, o SCC grande de W3 dissolveu, e
		o ciclo menor fce↔rew (ambas arestas com events publicados
		e feedbackLoop declarado) emergiu como detectado
		independentemente.

		Caracterização semântica de fce↔rew (ambas arestas têm
		feedbackLoop declarado):
		- rew-to-fce: events CreditEligibilityDecided; rationale
		  "dinheiro não move sem avaliação de risco" — REW publica
		  decisão/policy.
		- fce-to-rew: events PaymentSettled,
		  PaymentObligationDefaulted; description "padrões de
		  pagamento... são sinais de risco" — FCE publica state
		  events de execução que REW consome para recalibrar modelo
		  de risco.
		- loopSemantics em ambas: "loop de aprendizado contínuo".

		Análise vs categorias Família A existentes:
		- bidirectional-orchestration (adr-118, primeiro consumidor
		  drc↔cmt): "orquestração sequencial publish-react bilateral".
		  Para fce↔rew: CONCEITUALMENTE IMPRÓPRIO — não é
		  orquestração; é assimetria policy-side (decisão pontual)
		  ↔ execution-side (stream de state events). Cadência
		  desigual.
		- policy-reaction (adr-119, primeiro consumidor rew-to-cmt):
		  "upstream publica decisão; downstream reage via policy
		  interna com agência". Scan complementar do PR-3 (Fase 1)
		  explicitamente rejeitou:
		  - rew-to-fce: invariante "dinheiro não move sem avaliação
		    de risco" — FCE sem agência (enforcement).
		  - fce-to-rew: PaymentSettled é state event de execução,
		    não signal de decisão.

		fce↔rew exige nomeação própria. Pattern paralelo a adr-118
		(extensão orgânica do enum com 1 valor adicional quando
		caso concreto emerge — pattern adr-049/056/063 de
		minimalismo).

		Naming candidates avaliados:
		- "continuous-learning-feedback" — REJEITADO: "continuous
		  learning" é nome de mecanismo ML (online learning vs batch);
		  expressa COMO o feedback é processado, não a estrutura
		  arquitetural DDD. Categoria estrutural deve nomear a
		  ESTRUTURA, não a implementação.
		- "policy-execution-feedback" — ESCOLHIDO: nome captura a
		  estrutura canônica policy-side (upstream publica policy/
		  decisão) ↔ execution-side (downstream publica state events
		  de execução) com feedback contínuo. Complementar a
		  policy-reaction (que captura signal+agency unidirecional)
		  adicionando a dimensão de loop bidirecional execution→policy.

		Este ADR adiciona "policy-execution-feedback" ao
		#FeedbackLoopKind enum (que tinha 1 valor "bidirectional-
		orchestration" desde adr-118 PR #84). Aplicação concreta em
		rew-to-fce + fce-to-rew é parte do adr-122 (mesmo PR-3); a
		7ª entrada no edgeFilters de sc-cm-07 também é parte do
		adr-122. Este ADR é apenas a extensão do enum
		(infraestrutura).

		Pré-condição: adr-118 (PR #84) introduziu o enum
		#FeedbackLoopKind + field opcional kind em
		#ActiveFeedbackLoop. adr-124 é extensão non-breaking (adiciona
		variant à união discriminada do tipo enum).

		Ajuste 1 funcionou como projetado: o ciclo emergente foi
		capturado ANTES da promoção warn→reject. Sem Ajuste 1, a
		promoção teria FALHADO em CI ou (pior) teria sido feita com
		ciclo presente, requerendo PR de reversão. Pattern de
		ordem-de-materialização "aplicar com warn → validar → só então
		promover" demonstrado como mecanismo de safety net empírico.

		Alternativas consideradas e rejeitadas:

		(a) Forçar fce↔rew a usar bidirectional-orchestration
		(estender semantic do conceito original). REJEITADA: drift
		semântico do conceito; primeiro consumidor (drc↔cmt) e
		fce↔rew são estruturalmente diferentes — uniformidade falsa.
		Viola P0 (vocabulário canônico).

		(b) Aceitar fce↔rew como ciclo legítimo de design e NÃO
		promover sc-cm-07 a reject (manter warn perpétuo ou
		tension-entry). REJEITADA: catraca adr-097 não cumprida;
		PR-3 entregaria apenas aplicação parcial; warn perpétuo é
		tag inútil per pattern adr-097.

		(c) Refactor de modelagem: remover uma das arestas (e.g.,
		fce-to-rew via policy interna de REW subscrevendo event log
		sem cruzar fronteira BC explícita). REJEITADA: viola def-019
		+ adr-104 "events cross-BC são linguagem ubíqua que merece
		estar no context-map"; esconde aresta real do mapa.

		(d) Naming "continuous-learning-feedback" em vez de
		"policy-execution-feedback". REJEITADA: nome de mecanismo
		ML não descreve estrutura DDD; "policy-execution-feedback"
		captura ESTRUTURA canônica policy-side ↔ execution-side com
		feedback, alinha com vocabulário policy-reaction de adr-119.
		"""

	decision: """
		Estender architecture/artifact-schemas/context-map.cue:

		#FeedbackLoopKind:
		    "bidirectional-orchestration" |
		    "policy-execution-feedback"

		(Era enum singleton com 1 valor; vira união discriminada com
		2 valores.)

		Atualizar comentário inline documentando o 2º valor com
		semântica canônica + primeiro consumidor (fce↔rew) +
		linkagem com adr-124 + Ajuste 1.

		Aplicação concreta nas arestas (feedbackLoop.kind:
		"policy-execution-feedback" em rew-to-fce + fce-to-rew) +
		7ª entrada nos edgeFilters do sc-cm-07
		({path: "feedbackLoop.kind", notEquals:
		"policy-execution-feedback"}) NÃO são parte deste ADR —
		são parte de adr-122 (aplicação Família A do PR-3),
		atualizado para incluir esta categoria após descoberta via
		Ajuste 1.

		Este ADR NÃO toca:
		- strategic/context-map.cue (aplicação é adr-122)
		- architecture/structural-checks/context-map.cue (filter é
		  adr-122)
		- enforcement do sc-cm-07 (promoção é adr-123)
		- def-XXX (nenhum def-XXX foi CRIADO para fce↔rew —
		  descoberta foi empírica durante PR-3, não deferida)
		"""

	consequences: """
		Positivas:
		(P1) Vocabulário DDD enriquecido: policy-execution-feedback
		nomeia estrutura canônica em sistemas com policy engines +
		execution layers (e.g., risk-and-payment, compliance-and-
		settlement). Generaliza além de fce↔rew para futuros pares
		similares (e.g., adoption-of-policy-decision em outros BCs
		que materialize PolicyEngine + ExecutionEngine separados).

		(P2) Complementaridade com policy-reaction (adr-119):
		- policy-reaction: signal unidirecional + downstream agency.
		  REW publica → CMT escolhe ação (per policy local).
		- policy-execution-feedback: bidirecional policy↔execution
		  loop com feedback contínuo. REW publica decisão → FCE
		  executa per invariante → FCE publica state → REW
		  recalibra modelo.
		Vocabulário cobre o espaço structural completo de "publish
		decision/signal" cross-BC.

		(P3) Confirma valor do Ajuste 1 (ordem de materialização
		warn-first + validate). Mecanismo empírico de safety net
		capturou ciclo emergente ANTES da promoção, evitando PR de
		reversão. Pattern repetível para futuras born-warn → reject
		transitions.

		(P4) Custo marginal: 1 enum variant + 2 linhas em strategic/
		context-map.cue (kind em rew-to-fce + fce-to-rew) + 1
		edgeFilter em sc-cm-07. Pattern paralelo a adr-118 (1 enum
		value adicionado).

		(P5) Resolve sub-ciclo fce↔rew preservando rastreabilidade
		das arestas no context-map (vs alternativa γ que removeria
		aresta).

		Negativas:
		(N1) Schema #FeedbackLoopKind cresce de 1 para 2 valores.
		Custo marginal em cue vet. Pattern de extensão orgânica
		estabelecido (adr-118 + este).

		(N2) Hipótese estrutural ("policy-execution-feedback" como
		categoria DDD) tem aplicação potencial além de fce↔rew. Risco
		residual: outros loops policy↔execution emergentes (e.g.,
		rew↔scf após canvas SCF materializar; rew↔ins quando canvas
		INS materializar) podem requerer aplicação subsequente.
		Mitigação: catraca adr-097 + reject enforcement + safety net
		Ajuste 1 capturam regressões.

		(N3) Ajuste 1 demonstrou eficácia mas é convenção
		operacional do agente (não codificada em workflow CI).
		Risco: futuras transições warn→reject podem esquecer o
		passo de validação intermediária. Mitigação: pattern
		documentado neste ADR + adr-097 nota; pattern repetível em
		commits futuros. Codificação formal (e.g., workflow gate
		"validate-before-promote") fica para ADR follow-on se padrão
		recorrer.

		Known gaps declarados:
		- Outros candidatos para policy-execution-feedback (rew↔scf,
		  rew↔ins) NÃO aplicados — não estão em ciclo atual; aplicação
		  ontológica futura quando canvas materialize event flows
		  bidirecionais. Não bloqueia adr-124.
		- Enum #FeedbackLoopKind cresce orgânicamente; 3º valor
		  futuro emergirá com mesmo pattern (adr-049/056/063
		  minimalismo).

		Fronteira regulatória: nenhuma. Decisão meta-estrutural sobre
		vocabulário do context-map. Sem efeito em Bacen/SCD/LGPD/
		KYC/AML.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/context-map.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/context-map.cue",
	]

	principlesApplied: ["P0", "P1", "P12"]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0 (uma localização canônica): policy-execution-feedback é
		vocabulário cross-BC com SoT única em
		architecture/artifact-schemas/context-map.cue. Nenhuma
		duplicação; instâncias referenciam o enum.

		P1 (CUE como SoT de contratos): enum declarativo no schema;
		cue vet enforce shape; valores válidos são as 2 strings
		declaradas; futuras additions requerem ADR.

		P12 (governança como código): categoria estrutural expressa
		via vocabulário typed, não via convenção lexical em
		loopSemantics (prose).

		Failure mode evitado: ciclo fce↔rew como WARN crônico
		(catraca adr-097 nunca cumprida) OU forçar bidirectional-
		orchestration (drift semântico) OU remover aresta (esconde
		realidade arquitetural cross-BC).

		Tensão com axiomas: nenhuma. ax-03 (pagar custo de
		complexidade cedo) confirmado: nomear policy-execution-feedback
		agora vs descobrir later quando outros loops policy↔execution
		emergirem em outros BCs.

		Lenses consultadas:
		- lens-event-driven-architecture-patterns: distinção entre
		  command-publishing (policy-reaction signal), state-feedback
		  (policy-execution-feedback execution stream), e orchestration
		  (bidirectional-orchestration sequential) é canônica em EDA.
		- lens-control-theory-fundamentals: closed-loop feedback
		  systems com policy controller + execution actuator são
		  primitivos em control theory; nomear estrutura
		  policy↔execution alinha com convenção.

		Relacionamento com adr-118 (PR #84): este ADR estende o enum
		introduzido em adr-118 com 2º valor. Não substitui nem
		altera adr-118; complementa.

		Relacionamento com adr-122 (mesmo PR): este ADR é precondição
		para a 7ª entrada do edgeFilters + aplicação em rew-to-fce/
		fce-to-rew em adr-122. Sequência merge no PR-3 garante
		coexistência atomica.

		Relacionamento com adr-097 + Ajuste 1 (convenção operacional):
		este ADR é evidência factual da eficácia do safety net "warn
		first → validate → promote". Pattern repetível para futuras
		transições.

		defersTo NÃO usado: nenhum def-XXX foi criado para fce↔rew —
		descoberta foi empírica durante PR-3, não decisão deferida.
		Não há registro pré-existente a apontar.
		"""
}
