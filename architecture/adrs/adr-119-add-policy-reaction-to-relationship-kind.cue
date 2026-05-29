package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr119: artifact_schemas.#ADR & {
	id:    "adr-119"
	title: "Adicionar policy-reaction ao #RelationshipKind (schema extension do context-map, PR-1 de plano cycle-resolution)"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-027 (registrado em PR #83 mergeado em 2026-05-29) articulou a
		decisão DDD para resolver W2 (cmt → rew → dlv → bdg → cmt, 4-BC)
		do sc-cm-07 (directed-acyclicity, adr-117): a aresta anômala
		rew-to-cmt é policy reaction (notification de signal), NÃO
		dependência estrutural de dados. As outras 3 arestas do ciclo
		(cmt-to-bdg, bdg-to-dlv, dlv-to-rew) são spine linear do
		commitment-lifecycle.cue, que declara explicitamente "Precificação
		de risco — transversal ao flow, não fase sequencial" em outOfScope.

		Evidência categórica do canvas REW: "REW publica decisões (score,
		eligibility, alerts) mas NUNCA enforça diretamente. Execução de
		gates é responsabilidade de consumers (CMT, SCF, FCE). Não enviado
		a FCE — FCE consome decisões (eligibility), não sinais (alerts);
		separação preserva decisão ≠ execução." Canvas CMT confirma: a
		reaction de RiskAlertRaised é "Sinaliza compromissos ativos com
		contraparte sob risco elevado. Pode suspender formalização em
		andamento" — é policy decision (CMT escolhe ação), não data sync.

		Schema atual do context-map carrega #BaseRelationshipWithCommunication
		e #BaseRelationshipWithoutCommunication com fields code/source/
		target/direction/communication/etc. NÃO existe campo para
		categorizar a NATUREZA do acoplamento (dependência estrutural vs
		notification vs orchestration). Para que o sc-cm-07 possa filtrar
		arestas notification-driven (excluindo-as do grafo de dependência
		direcionada), precisa de uma dimensão categorical typed.

		Este ADR é o passo 1 (paralelo a adr-118) do plano de PRs
		registrado em def-027.triggerCalibrationRationale:
		- PR-1 (adr-118 + este ADR): schema extensions (enums novos +
		  fields opcionais)
		- PR-2 (adr-120): filter no sc-cm-07 para def-028 família B
		- PR-3: aplicação dos kinds nas arestas concretas + scan
		  complementar para detectar outras arestas policy-reaction
		  candidatas + promoção sc-cm-07 warn → reject. PR-3 resolverá
		  def-027 ao marcá-lo status open → resolved.

		Este ADR NÃO resolve def-027 — só prepara vocabulário. Resolução
		ocorre em PR-3 quando rew-to-cmt for editada para incluir
		kind: "policy-reaction" E o sc-cm-07 ganhar edgeFilter que exclui
		o kind. defersTo schema field NÃO usado porque def-027 não foi
		CRIADO por este ADR (precondition do field per schema
		#ADR.defersTo description: "Deferimentos conscientes governados
		criados por esta decisão").

		Alternativas consideradas e rejeitadas:

		(a) Estender #UpstreamPattern com "policy-reaction" (ou
		#DownstreamPattern). REJEITADA: patterns existentes (OHS, ACL,
		conformist, etc.) descrevem QUEM define o contrato (publisher
		vs consumer); kind é dimensão ortogonal sobre NATUREZA do
		acoplamento (data dependency vs notification). Misturar as
		duas dimensões num só enum dilui semântica de ambas.

		(b) Adicionar valores especulativos no enum agora (e.g.,
		"data-dependency", "shared-state-sync"). REJEITADA: minimalismo
		per adr-041 — kinds devem ser narrow e específicos. Expansão
		on-demand. policy-reaction é o único caso concreto identificado
		hoje (rew-to-cmt).

		(c) Adicionar kind obrigatório (sem ?). REJEITADA: forçaria
		cascade update em TODAS as instances de relationships no
		strategic/context-map.cue (47 entries). Optional permite
		migração progressiva; PR-3 aplica nas arestas que precisarem
		(rew-to-cmt + scan complementar).

		(d) Modelar policy-reaction como nova variante de
		#InternalRelationship discriminated union (paralelo às 11
		existentes como #InternalOHSACLRelationship). REJEITADA: variants
		discriminam por combinação upstreamPattern × downstreamPattern
		(ortogonal a kind); criar variant para cada (pattern × kind)
		causaria explosão combinatória (11 × N_kinds). Field kind
		ortogonal é DRY.
		"""

	decision: """
		Estender architecture/artifact-schemas/context-map.cue com 3
		mudanças (mesma forma de adr-118 paralelo):

		(1) [enum-creation] Criar #RelationshipKind enum no fim do
		arquivo (seção KINDS junto com #FeedbackLoopKind do adr-118)
		com 1 valor inicial:
		  #RelationshipKind: "policy-reaction"

		(2) [struct-extension-without-communication] Adicionar field
		opcional kind ao #BaseRelationshipWithoutCommunication:
		  #BaseRelationshipWithoutCommunication: #_RelationshipCore & {
		      events?:   _|_
		      commands?: _|_
		      queries?:  _|_
		      kind?:     #RelationshipKind   // ← novo
		  }

		(3) [struct-extension-with-communication] Adicionar field
		opcional kind ao #BaseRelationshipWithCommunication:
		  #BaseRelationshipWithCommunication: #_RelationshipCore & {
		      communication: #CommunicationPattern
		      #FlowPayload
		      kind?: #RelationshipKind   // ← novo
		  }

		Decisão de adicionar em AMBAS variantes (em vez de em
		#_RelationshipCore que ambas estendem) preserva visibilidade
		explícita em cada variante — futuro autor lê a variante e vê
		todos fields aplicáveis sem precisar rastrear a hierarquia de
		extensão. Custo: 1 linha duplicada; benefício: legibilidade.

		Valor inicial documentado em comentário do enum: categoria
		policy-reaction = relação onde upstream PUBLICA decisão/sinal
		(notification) e downstream REAGE via policy interna, distinto
		de dependência estrutural de dados. Primeiro consumidor
		planejado: rew-to-cmt (sc-cm-07 W2, em PR-3).

		Este ADR é apenas schema extension. NÃO toca:
		- architecture/structural-checks/context-map.cue (sc-cm-07
		  edgeFilters vêm em PR-3)
		- strategic/context-map.cue (arestas concretas; aplicação em PR-3)
		- def-027 instance (resolução em PR-3 via resolvedBy →
		  adr-resolver-em-pr-3)

		Field opcional (kind?) preserva validade de todas instances
		existentes do context-map (47 relationships) sem cascade update
		— alinha com pattern de minimalismo + migração progressiva.
		"""

	consequences: """
		Positivas:
		(P1) Machine-evaluable categorization da NATUREZA do acoplamento
		complementa direction (upstream-downstream | mutual-dependency)
		e patterns (OHS/ACL/etc., que cobrem QUEM define contrato) com
		dimensão typed sobre se a aresta é dependência estrutural ou
		policy reaction. Habilita sc-cm-07 (PR-3) a filtrar arestas
		notification-driven via edgeFilter declarativo.

		(P2) Vocabulário DDD novo nomeado: "policy-reaction" formaliza
		classe distinta de data dependency. Cobre pattern publisher →
		consumer onde consumer escolhe se age sobre o signal — comum em
		sistemas event-driven (REW publica sinal; CMT decide reagir).
		Reduz ambiguidade quando outros publishers de signals surgirem.

		(P3) Extensibilidade preservada via discriminated enum: futuros
		ADRs follow-on adicionam valores quando padrões concretos
		emergirem (e.g., "data-dependency" explícito; "shared-state-sync"
		para event-sourcing patterns). Pattern paralelo a structural-
		check extensions (adr-049/056/063/076/080/117).

		(P4) Field opcional permite migração progressiva — 47 instances
		existentes continuam válidas; aplicação progressiva em PR-3 e além.

		(P5) Field kind ortogonal a patterns existentes preserva
		separação semântica: patterns = "QUEM define contrato"; kind =
		"natureza do acoplamento". Confusão entre as duas dimensões
		seria failure mode de modelagem.

		Negativas:
		(N1) Schemas #BaseRelationshipWithoutCommunication e
		#BaseRelationshipWithCommunication crescem 1 field cada (kind?).
		Duplicação intencional (não consolidada em #_RelationshipCore)
		por escolha de legibilidade; custo de manutenção marginal.

		(N2) v1 do enum tem só 1 valor. Pode parecer subdimensionado —
		mas é deliberado (minimalismo per adr-041).

		(N3) Risco de scope creep em PR-3: a hipótese "policy-reaction
		como categoria DDD" tem aplicação além de rew-to-cmt; scan
		complementar em PR-3 deve identificar outras candidatas (FCE
		quando WI-043 scaffolda canvas e publica signals). Sem scan, há
		risco de hidden coupling. Documentado em def-027.deferralRationale
		como risco categórico.

		Known gaps declarados:
		- sc-cm-07 edgeFilter para excluir arestas com
		  kind=="policy-reaction" NÃO está aqui. Vem em PR-3.
		- Edição de instances (rew-to-cmt em strategic/context-map.cue)
		  NÃO é parte deste PR. Vem em PR-3.
		- Scan complementar para outras candidatas policy-reaction NÃO
		  é parte deste PR (não há arestas para examinar até PR-3
		  começar). Documentado como ação obrigatória em PR-3 via
		  def-027.triggerCalibrationRationale.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural sobre
		framework de modelagem de relationships internas. Sem efeito em
		Bacen/SCD/LGPD/KYC/AML.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/context-map.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/context-map.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0 (uma localização canônica + zero duplicação): #RelationshipKind
		vive em architecture/artifact-schemas/context-map.cue como SoT
		única do vocabulário. Decisão de adicionar field em ambas
		variantes (vs em #_RelationshipCore) é trade-off de legibilidade
		explícita — não viola P0 porque cada uso é apenas reference
		ao enum.

		P1 (CUE como SoT de contratos): enum + fields opcionais
		declarativos em CUE; cue vet enforce shape; runner do sc-cm-07
		(PR-3) consome shape via edgeFilter.

		P12 (governança como código): categorização machine-evaluable
		da natureza do acoplamento (estrutural vs notification)
		substitui distinção implícita. sc-cm-07 passa a poder filtrar
		arestas notification-driven via filter declarativo, refletindo
		que notification ≠ dependência arquitetural.

		Failure mode evitado: gap entre intent (canvas REW declara
		"decisão ≠ execução"; canvas CMT trata RiskAlerts como policy
		decision) e enforcement (nenhum mecanismo distingue dependency
		de notification — todas viram aresta direcional no sc-cm-07).
		Sem este enum, sc-cm-07 reporta loops onde semanticamente não
		há acoplamento estrutural.

		Tensão com axiomas: nenhuma tensão substantiva. ax-04 (decidir
		hoje o que decidiríamos em 5–10 anos) confirma: categoria
		policy-reaction como cidadão de primeira classe escala melhor
		que workarounds heurísticos.

		Lenses consultadas:

		lens-event-driven-architecture-patterns: notification-driven
		publish-subscribe é pattern bem documentado distinto de data-
		flow synchronization; confirma legitimidade de nomear a classe.

		lens-distributed-systems-design: separar dependência de
		notification é princípio de design distribuído; confirma decisão.

		Relacionamento com def-027 (registrado em PR #83, status open):
		def-027 articulou a decisão DDD; este ADR materializa o passo 1
		do plano de PRs (schema extension; paralelo a adr-118). PR-3
		aplicará nas instances concretas + executará scan complementar +
		marcará def-027 resolved via resolvedBy apontando para o ADR de
		PR-3. defersTo NÃO usado aqui porque def-027 não foi CRIADO por
		este ADR (semântica estrita do field per schema).
		"""
}
