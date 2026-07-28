package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-180 -- Executa a promoção do frontend-codegen-contract a schema
// first-class: o gatilho do adr-178 D3 dispara com a chegada da 3ª
// família (o mapa de cotações do ssc) e o conteúdo obrigatório segue o
// mandato do adr-179. Cadeia causal: adr-150 define a lei; adr-178
// define quando a promoção deixa de ser opcional; adr-179 define o que
// ela é obrigada a conter; adr-180 a executa.

adr180: artifact_schemas.#ADR & {
	id:    "adr-180"
	title: "Promover o frontend-codegen-contract a schema first-class — a 3ª família chega"

	date: "2026-07-28"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		A cadeia causal está completa e citável: o adr-150 define a lei de
		frontend AI-first (Action-as-Tool, Generative Form,
		Approval-as-Confirmation + FF-FE); o adr-158 estabelece a relação de
		codegen spec→frontend-runtime materializada em
		governance/build-time/frontend-codegen-contract.cue; o adr-178 D3
		nomeia o gatilho da promoção a schema — verbatim do próprio contrato
		v1: "Promoção a schema só se >1 família de frontend o exigir" —
		fixando a chegada da 3ª família (o mapa de cotações do ssc) como o
		momento; o adr-179 fixa o conteúdo obrigatório da promoção
		(aplicabilidade tipada do action-surface por família;
		não-aplicabilidade declarada por shape para famílias read-only) e a
		falsificação que a vigia (a distinção action-bearing vs read-only
		DEVE derivar de shape tipado — sem nomes concretos de famílias, sem
		exceções ad hoc).

		O estado do contrato no disco: schema-exempt (precedente
		subagent-execution-log), v2.1, carregando DUAS famílias como structs
		livres — fceSurface (override, 1 command, dinheiro move) e p2pSurface
		(submissão origem net-new/def-081 + triagem via WI-156, 2 commands) —
		e SETE transform stages como texto. A view de query segue em regime
		hand-espelho não-contrato (escalated-queue da 1ª família; fila da
		2ª), com a entrada da view no codegen explicitamente marcada no
		contrato como "decisão da promoção a schema — não antecipada aqui".
		A continuidade da lei depende de repetição disciplinada por autor —
		o gap que o adr-179 nomeou e deixou armado.

		Trigger concreto: o WI-160 do arco jornada→produção (registrado no
		PR #218) traz a 3ª família — o mapa de cotações, a comparação
		consolidada que o comprador usa para escolher (prj/qry-quotation-map,
		WI-152; kit de superfície do ssc mergeado no WI-159/PR #220). A
		chegada executa o gatilho: a promoção deixa de ser opcional. Este ADR
		não re-decide nem o gatilho (adr-178) nem o mandato (adr-179) —
		executa ambos e toma as decisões de DESENHO que o adr-179
		deliberadamente reservou para este momento ("o shape concreto da
		declaração é desenho da promoção").

		Alternativas avaliadas:
		(a) Promoção fina — schema que apenas valida os campos v2 como estão
		    (inputs/transform/output como texto livre). REJEITADA: não cumpre
		    o mandato — a aplicabilidade do action-surface não deriva de
		    shape tipado quando os patterns vivem em strings de transform; a
		    omissão silenciosa continuaria possível; falha a
		    falsificationCondition do adr-179 por construção (promoção
		    cosmética).
		(b) Views todas hand — promover só os action-surfaces e manter a 3ª
		    família no regime hand-espelho. REJEITADA: o adr-178 nomeou a
		    entrada da view-de-query no codegen como parte DESTA revisita; o
		    mapa é a view mais rica do arco (equalização TCO derivada +
		    carimbo de decisão com ranking e tradeoffs) — exatamente onde
		    espelho-hand divergiria do contrato mais caro. Recusar a geração
		    aqui perpetua o regime que a promoção encerra.
		(c) Migração total imediata — mover também as 2 views hand
		    existentes para o regime gerado nesta fatia. REJEITADA: acopla
		    retrabalho do frontend-runtime (escalated-queue + fila) a uma
		    fatia de spec — blast radius desnecessário; o grandfathering
		    TIPADO torna a dívida visível no próprio contrato e migrável por
		    fatia própria.
		(d) ESCOLHIDA: schema estruturado por famílias com união discriminada
		    por capacidade E EXCLUSÃO MÚTUA POR SHAPE (structs fechados —
		    cue vet REJEITA capacidade residual no ramo errado) + 3ª família
		    read-only com view GERADA + grandfathering tipado das 2 views
		    existentes.
		"""

	decision: """
		(1) CRIAR o schema first-class #FrontendCodegenContract em
		architecture/artifact-schemas/frontend-codegen-contract.cue,
		estruturado por FAMÍLIAS DE SUPERFÍCIE first-class (families), cada
		uma #SurfaceFamily com união discriminada por CAPACIDADE e exclusão
		mútua POR SHAPE (structs FECHADOS — defs CUE sem elipse; a extensão
		da base comum realizada por EMBEDDING, a forma com que o CUE estende
		def fechado): o ramo #ActionBearingFamily (kind "action-bearing")
		EXIGE actions com ≥1 #Action, e cada #Action carrega os 3 slots do
		mandato adr-179 por construção — (a) actionPairing: par
		botão-humano+tool-de-agente de UMA definição (Action-as-Tool,
		adr-150 dec 2a); (b) confirmation: terminação em confirmação
		estruturada devolvendo o(s) evento(s), com movesMoney: bool e
		constraint movesMoney==true ⇒ approvalAsConfirmation==true (adr-150
		dec 2c; P10 em pixel); (c) generativeForm: prefill por campo com
		origin "system" | "net-new" e constraint origin=="net-new" ⇒
		netNewJustification não-vazia + migrationRef def-XXX (o critério do
		adr-178 e a âncora def-081-class, mecanizados). O ramo
		#ReadOnlyFamily (kind "read-only") NÃO POSSUI o campo actions — o
		fechamento do struct faz o cue vet REJEITAR qualquer capacidade de
		command residual — e EXIGE readSurfaces ≥1. As leituras usam
		#ReadSurface como união query-backed | canvas-backed: o ramo
		canvas-backed (leitura ancorada em canvas query-surface, sem qry-*
		formal no domain-model) FORÇA viewRegime "hand-grandfathered" por
		shape — resolve a view legada do FCE sem qry formal E mecaniza
		"view GERADA exige query capability formal". Zero nomes concretos de
		famílias no schema: tudo deriva de capacidade tipada (honra a
		falsificationCondition do adr-179). Um command sem os 3 slots é
		impossível por construção (os slots vivem NA definição da action);
		um action-surface sem command idem (os slots só existem dentro de
		actions).

		(2) MIGRAR o contrato para v3 como INSTÂNCIA do schema, sem perda das
		decisões vigentes: família FCE action-bearing (movesMoney: true →
		Approval-as-Confirmation obrigatória por shape); família P2P
		action-bearing com 2 actions (submissão origin "net-new" com
		netNewJustification + migrationRef "def-081"; triagem origin
		"system"); status/evidência preservados (o flip proposed→accepted
		segue gated pelo harness def-065 — a promoção não o antecipa). O
		campo schemaPromotionMandate é REMOVIDO na migração: o mandato foi
		cumprido; o registro canônico do cumprimento é este ADR.

		(3) DECIDIR a view-de-query no codegen (a revisita que o adr-178
		deixou nomeada): a partir da 3ª família, readSurface com viewRegime
		"generated" é o regime — fim do hand-espelho para famílias novas. As
		2 views hand existentes ficam GRANDFATHERED com marcação tipada
		(viewRegime: "hand-grandfathered") — dívida visível no contrato,
		migrável por fatia própria, sem forçar retrabalho no frontend-runtime
		nesta fatia.

		(4) NASCER a 3ª família — o mapa de cotações: família do ssc,
		#ReadOnlyFamily, qry-quotation-map, view QuotationMapView com
		viewRegime "generated"; superfície HTTP GET
		/v1/ssc/queries/quotation-map/{rfqId} no api.yaml do ssc (molde by-id
		do FCE). LEITURA INTERPRETATIVA REGISTRADA da prosa da query
		capability ("Retorna o QuotationMap por rfqId (com filtro por
		categoryRef)"): o GET é by-rfqId e o categoryRef viaja NO PAYLOAD —
		o "filtro por categoria" pertence a uma LISTAGEM de mapas que não
		existe como projection, mesma família da lacuna "RFQs abertas" já
		sinalizada no PR #220; a listagem não é inventada aqui. ALTERNATIVA
		DESCARTADA: query param categoryRef opcional no GET by-id (filtro ou
		validação cruzada) — descartada porque rfqId já identifica
		unicamente o mapa e sua categoria; validação cruzada seria contrato
		sem função e filtro sem listagem é vazio.

		(5) COMPLETAR o pacote do tipo novo (cascade adr-053/sc-pg-01, molde
		adr-170): production-guide
		architecture/production-guides/frontend-codegen-contract.cue (tipo
		production-guide em rollout subagent-drafted; autoria via dispatch
		real disp-010 per authoring-policy Phase 1) + structural-check
		architecture/structural-checks/frontend-codegen-contract.cue com os
		DOIS CASOS ADVERSARIAIS DECLARADOS como gates: família com capacidade
		de command sem action surface → reject; action surface sem capacidade
		de command → reject (cue vet é a 1ª camada por shape; o sc é a 2ª
		camada determinística pós-commit, com refs cross-file: commandRef/
		queryRef resolvem no domain-model do BC da família; migrationRef e
		activeBoundaries resolvem em architecture/deferred-decisions/). O
		enum #ArtifactType em
		architecture/artifact-schemas/quality-criteria.cue ganha
		"frontend-codegen-contract". O sc-pg-01
		(architecture/structural-checks/production-guide.cue) ganha
		coveredSchemas += "frontend-codegen-contract" no MESMO commit — a
		expansão change-on-touch que o próprio check declara (molde adr-170
		dec 6: "sc-pg-01 coveredSchemas += domain-story").
		_schema.location do schema aponta o lar EXISTENTE da instância
		(governance/build-time/frontend-codegen-contract.cue) — zero
		movimentação de arquivo.

		(6) VEÍCULO: WI-160 do arco (stream claimed/completed no padrão das
		fatias); a catraca agente↔modelo não move (nenhum id das famílias
		operáveis de domínio nasce — isto é meta-superfície); os
		warns/baselines não mudam além do que o structural-check novo
		declarar (born-reject com a condição da catraca verificada no ato —
		instância única verde por construção, precedentes adr-171 (catraca
		verificada no ato da promoção) + sc-ag-03/adr-176 (born-reject)).
		"""

	consequences: """
		Positivas:
		(P1c) A lei do adr-150 migra de disciplina-por-autor para estrutura
		validável: família com command sem os 3 slots, read-only com action
		residual, net-new sem justificativa+migrationRef, dinheiro movendo
		sem Approval-as-Confirmation — nenhum valida (cue vet, structs
		fechados), e o sc adversarial cobre a 2ª camada pós-commit. A janela
		de mecanização que o adr-179 fechou por mandato fecha agora no
		consumidor.
		(P2c) A 3ª família nasce read-only com view GERADA — a view mais
		rica do arco (equalização TCO derivada + carimbo de decisão com
		ranking e tradeoffs) entra no regime de contrato; fim do
		hand-espelho para famílias novas.
		(P3c) Grandfathering TIPADO (viewRegime): a dívida das 2 views hand
		existentes fica visível no próprio contrato e migrável por fatia
		própria — dívida iluminada, não escondida (uq-05 estrutural).
		(P4c) O tipo entra no regime universal de governança na origem:
		schema + PG + structural-check + quality criteria (tq-fcc-NN) no
		mesmo commit — cascade adr-053/sc-pg-01 satisfeito sem janela.
		(P5c) Os qualificadores da lei viram constraints: origin=="net-new"
		⇒ netNewJustification+migrationRef (adr-178/def-081 mecanizados) e
		movesMoney ⇒ approvalAsConfirmation (P10 em pixel, agora em cue
		vet).

		Negativas:
		(N1) Custo de migração pago agora: o contrato re-expresso por
		famílias — risco de erro de transcrição das decisões vigentes
		(net-new, regime hand, evidência/status). Mitigação: diff semântico
		lado a lado na proposta consolidada + self-review isolated-subagent
		+ founder review.
		(N2) Mudança estrutural é breaking para o tooling downstream: o
		gerador do frontend-runtime passa a ler instância tipada — a 1ª
		fatia de lá pós-promoção absorve a mudança (janela declarada,
		análoga à N1 do adr-178).
		(N3) As views grandfathered permanecem FORA do regime gerado até
		migração própria — a dívida continua real, apenas visível e marcada;
		parada prolongada com famílias novas avançando é o sinal a vigiar.
		(N4) Um tipo a mais no universo (trio schema+PG+sc a manter) — o
		custo permanente da mecanização.
		"""

	falsificationCondition: {
		condition:        "Esta promoção estará ERRADA SE (a) a exclusão mútua por shape furar na prática — instância com capacidade de command sem action surface, ou action surface sem capacidade de command, VALIDANDO no cue vet; OU (b) a 4ª família exigir exceção ad hoc ou nome concreto de família no schema (a falsificação herdada do adr-179 disparando na instância); OU (c) o regime gerado da view provar-se inimplementável ou mais caro que o hand-espelho para famílias novas, forçando regressão."
		observableSignal: "(a) PR com instância violando a exclusão e passando o CI — o sc adversarial existe exatamente para acusar isto como 2ª camada. (b) diff do schema numa 4ª família contendo bypass não derivado de capacidade tipada — visível em review. (c) a fatia da 3ª família no frontend-runtime escalando que a view gerada não sai do contrato — visível como falha do teste de suficiência (cláusula anti-inferência da linhagem adr-157/adr-178)."
	}

	affectedArtifacts: [
		"governance/build-time/frontend-codegen-contract.cue",
		"contexts/ssc/api.yaml",
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/structural-checks/production-guide.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/frontend-codegen-contract.cue",
		"architecture/production-guides/frontend-codegen-contract.cue",
		"architecture/structural-checks/frontend-codegen-contract.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: ["P0", "P1", "P10", "P12", "P14"]

	supersedes: []

	rationale: """
		Por que (d) entre (a)-(d): a promoção fina (a) falharia a
		falsificação do adr-179 por construção; adiar a view (b) perpetuaria
		o regime que a revisita nomeada existe para encerrar; a migração
		total (c) acoplaria retrabalho de outro repo a uma fatia de spec. A
		união discriminada por capacidade com structs fechados é o único
		desenho dos quatro em que a omissão silenciosa dos patterns é
		impossível POR SHAPE — a exigência literal do mandato.

		P0: o schema aponta o lar existente da instância (zero
		movimentação); o campo-âncora schemaPromotionMandate é removido
		porque o mandato foi cumprido e o registro canônico do cumprimento é
		este ADR (âncora que sobrevivesse ao cumprimento viraria
		duplicação). P1: o contrato segue SoT da geração, agora tipado; nada
		gerado é committado no spec. P10: a continuidade dos patterns sai do
		review interpretativo e entra em dois gates determinísticos (cue vet
		+ sc adversarial); Approval-as-Confirmation por constraint é P10 em
		pixel, mecanizado. P12: governança executável — lei comportamental →
		estrutura validável. P14: as distinções compile-time preservadas na
		própria meta-superfície (disjunção fechada action-bearing/read-only
		é o análogo meta do enum fechado de lifecycle).

		Relações: EXECUTA adr-178 D3 e adr-179 sem alterá-los; PRESERVA
		adr-158 (a relação de codegen é a mesma — muda o rigor do artefato
		que a declara) e def-065 (o flip proposed→accepted do contrato segue
		gated por evidência — a promoção estrutural NÃO antecipa a validação
		empírica); def-081 intocado no critério, mecanizado no shape. Views
		grandfathered: dívida declarada com marcação tipada, não deferimento
		consciente novo (a migração é trabalho rotineiro futuro — WI quando
		chegar, não def, per anti-catch-all do adr-062).

		Tensão com axiomas: nenhuma. Lenses: nenhuma com match — resolvido
		por princípios + precedentes internos (adr-170 molde do trio de tipo
		novo; adr-179 mandato; adr-178 gatilho).
		"""
}
