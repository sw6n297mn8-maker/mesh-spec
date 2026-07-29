package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-182 -- Estabelece o modelo de identidade e ator: as 4 dimensões de
// todo ato (quem, em nome de quem, em que papel, sob que governança), o
// slot estruturado no #Envelope (rota formal ten-016), a semântica de
// tenant (Opção B: organização participante; isolamento de visibilidade
// sobre log único da rede) e a postura de borda (resolve def-024 metade
// auth; servers re-adiado em def-082; def-080 re-adiado com base nova).

adr182: artifact_schemas.#ADR & {
	id:    "adr-182"
	title: "Estabelecer o modelo de identidade e ator — usuário, papel, tenant e agente"

	date: "2026-07-29"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	reversibility: "low"
	blastRadius:   "cross-cutting"

	context: """
		Todo ato no sistema hoje grava o ator como STRING nominal
		não-verificada: requestedBy, decidedBy, triagedBy, proposedBy,
		supervisorId — 18 ocorrências da postura "atribuição nominal
		NÃO-verificada nesta borda até o ADR de auth" (def-024) espalhadas
		pelos BCs. A postura foi honesta e deliberada — mas o event log é
		imutável: evento gravado sem identidade estruturada de autor não a
		ganha retroativamente, e cada fatia de superfície nova acumula mais
		fatos sob o regime provisório. O def-080 registra o irmão do
		problema no gate agente↔modelo: o padrão de ATOR dos commands vive
		em prosa, não em campo.

		O terreno para decidir agora existe e não existia antes: o WI-157
		entregou o vocabulário de papéis (sh-07 engenheiro requisitante,
		sh-08 comprador, sh-09 gestor aprovador — personas intra-org; sh-05
		o agente-operador; adr-172 fixou que papéis de PARTICIPANTE são
		posicionais, nunca cadastrais). O idc reserva o lar de identidade:
		agg-organizational-identity (root = legalIdentifier, lifecycle de
		verificação) e inv-signature-requires-active-identity — identidade
		ORGANIZACIONAL; identidade de PESSOA (usuário dentro da org) não
		existe em nenhum artefato. O bdg fixa Alçada como TETO DE VALOR por
		operador — não permissão de acesso. NENHUM artefato define a
		SEMÂNTICA de tenant — as menções existentes a pressupõem sem
		defini-la (domain-definition: multi-tenancy como premissa de
		isolamento e 'isolamento entre tenants' como critério do PRÓPRIO
		reversibilityThreshold que esta escalação satisfaz; P9:
		tenant_id): a semântica é cunhada AQUI. A governança de
		agente JÁ carrega versão rastreável: o schema #AgentGovernanceGlobal
		(architecture/artifact-schemas/agent-governance.cue) declara o
		campo version com a docstring "Rastreada no audit trail de toda
		decisão de agente (governance-version)"; o singleton
		architecture/agent-governance.cue declara version "0.1"; e cada
		envelope per-agente declara governanceGlobalVersion validado
		contra o singleton (tq-gv-12) — verificado na fonte nesta fatia.

		O envelope compartilhado (#Envelope, def-022) é INTENTIONALLY
		MINIMAL com disciplina anti-stealth-extension: qualquer expansão
		cross-BC exige tension-entry + revisita dos consumidores + decisão
		explícita do founder — a rota formal que esta fatia percorre
		(ten-016).

		Trigger: WI-158, último item do arco jornada→produção — a decisão
		cara-de-retrofit que precede as telas restantes; def-024 aguarda o
		"ADR de auth" da borda desde 2026-05-28; servidor de login e
		verificação de borda permanecem na trilha de produção, FORA do
		mesh-spec (o ADR fixa o QUE se grava e a postura da borda, não a
		implementação).

		ESCALAÇÃO DE IRREVERSIBILIDADE (tenant) — apresentada formalmente
		ao founder com critérios por opção; decisão em 2026-07-29:
		(A) Tenant = organização com isolamento por PARTIÇÃO (cada fato
		    pertence a 1 tenant). REJEITADA: a Mesh é REDE — os fatos
		    centrais são BILATERAIS (PO envolve originadora E fornecedor;
		    commitment é de duas partes; RFQ convida N) — partição
		    por-fato-único força dono artificial ou duplicação. Critérios
		    de irreversibilidade que satisfazia: isolamento entre tenants
		    (estrutura inteira) + schema persistido (chaveamento do log) +
		    contratos públicos.
		(B) Tenant = organização participante; isolamento de VISIBILIDADE
		    sobre log único da rede. ESCOLHIDA pelo founder, com condição:
		    escopo-por-organização declarado como INVARIANTE de toda query
		    capability e superfície nova, e a negativa de primeira classe
		    carregada nas consequences (N1). Critérios satisfeitos:
		    isolamento entre tenants (semântica cunhada) + schema
		    persistido (slot no envelope) + contratos públicos (eventos
		    ganham o slot).
		(C) Adiar a semântica de tenant. REJEITADA: ator sem
		    organização-de-atuação é meio-modelo (o "em nome de quem" é
		    metade da responsabilidade jurídica dp-10); o retrofit voltaria
		    na primeira tela multi-org.

		Alternativas avaliadas (lar do slot de ator):
		(a) Slot estruturado no #Envelope (rota ten-016). ESCOLHIDA — UMA
		    declaração, uniforme por construção; o custo (expansão do
		    envelope + campo opcional-no-shape com obrigação por handler)
		    é pago pela rota formal da disciplina.
		(b) Ator em data por-evento. REJEITADA com o custo DECLARADO: o
		    shape do ator seria re-declarado POR BC (12+ domain-models ×
		    N eventos) e a uniformidade viraria disciplina-por-autor —
		    exatamente a classe de gap que o adr-179 mandou mecanizar no
		    frontend e que os 18 strings nominais provam que degrada; o
		    envelope ficaria intocado mas o problema não ficaria menor,
		    ficaria espalhado.
		(c) #EnvelopeV2 com ator. REJEITADA: bifurca o universo de eventos
		    (coexistência mesh-1/mesh-2) por causa de UM campo opcional —
		    o pattern de versão do envelope existe para mudanças
		    INCOMPATÍVEIS, não para extensão aditiva.
		"""

	decision: """
		(1) O MODELO DE ATOR — todo ato (command processado → evento) tem
		ator estruturado de 4 dimensões: kind ("human" | "agent"); actorId
		(humano: identidade de usuário emitida sob o lar do idc — a
		modelagem do aggregate de usuário é fatia futura do idc, este ADR
		fixa o CONTRATO; agente: o code agt-* do agent-spec, formato
		forçado por shape); onBehalfOfOrg (a organização
		participante em cujo nome o ato ocorre — língua npm,
		term-participante; NPM é SoT do participante); roleRef (archetype sh-* do
		stakeholder-map). CRITÉRIO DE NÃO-APLICAÇÃO do roleRef (tríplice):
		(a) kind=agent — o agent-spec É o papel do agente (roleRef seria
		duplicação); (b) humano de contraparte agindo em POSIÇÃO de
		participante (fornecedor submetendo cotação: onBehalfOfOrg = org
		fornecedora; a posição vive na relação/command per adr-172 —
		roleRef aqui re-introduziria papel cadastral pela porta dos
		fundos); (c) eventos ACL -received (fatos de tradução — actor não
		aplica; o shape opcional cobre).

		(2) DECIDE-VS-EXECUTE GRAVADO — actor = quem DECIDIU (humano nos
		propose-and-wait; agente nos execute-and-log dentro de envelope);
		executedVia opcional (agt-*) quando um agente executa decisão
		humana. Quando o AGENTE decide (kind=agent), a responsabilidade
		humana identificável (dp-10) NÃO é campo por-evento — deriva do
		governance envelope VIGENTE do agente; para a derivação ser
		reconstituível em qualquer fato passado, o actor block grava
		underGovernance {governanceRef, governanceVersion} — o par que o
		tq-gv-12 valida (governanceGlobalVersion ↔ version do singleton
		architecture/agent-governance.cue; a docstring do campo no schema:
		"Rastreada no audit trail de toda decisão de agente"), OBRIGATÓRIO
		POR SHAPE quando kind=agent. executedVia é VETADO por shape quando
		kind=agent — o agente-decisor não tem direção inversa (caso
		semanticamente vazio fechado; sonda provada na fatia).
		[Aplicação da lens-ai-agent-governance, Q4: observabilidade =
		reconstituição de qualquer decisão passada — sem a versão,
		envelopes que evoluem quebram a trilha.]

		(3) ONDE GRAVA — campo actor?: #Actor no #Envelope compartilhado
		(architecture/shared-schemas/envelope.cue), pela ROTA FORMAL da
		disciplina do def-022: ten-016 articula a necessidade real; a
		revisita cross-BC está neste ADR (o campo é OPCIONAL no shape —
		nenhum evento legado quebra; consumidores existentes seguem
		válidos sem edição); a decisão explícita do founder é este ADR.
		OBRIGATÓRIO por norma de handler para todo ato pós-adr-182; os
		*By strings existentes seguem como legado declarado até migração
		por fatia (grandfathering, molde viewRegime do adr-180).

		(4) TENANT (Opção B da escalação, decisão do founder) — tenant =
		organização participante; log ÚNICO da rede; fatos bilaterais
		referenciam as organizações envolvidas; o isolamento é de
		VISIBILIDADE: ESCOPO-POR-ORGANIZAÇÃO é INVARIANTE de toda query
		capability e superfície nova pós-adr-182 — toda leitura declara a
		que organização(ões) o resultado é visível. Norma deste ADR,
		MECANIZÁVEL como structural-check futuro (lacuna do runner
		NOMEADA: nenhum kind expressa hoje 'toda queryCapability declara
		org-scope'; nasce como norma + candidato a check, padrão
		rule-latente). Partição física é decisão de runtime
		(QUE=spec/COMO=runtime), não deste ADR.

		(5) LARES CONFIRMADOS — permissão-de-acesso e identidade (org E
		pessoa) = idc; o glossário do npm JÁ traça a linha verbatim:
		"Usuário é pessoa física que opera em nome de um participante. NPM
		gerencia organizações, não pessoas. Gestão de identidade de
		pessoas vive em IDC." (o aggregate de usuário é fatia futura de
		domínio do idc; inv-signature-requires-active-identity é o
		precedente do gate de vigência); Alçada = bdg, teto de valor por operador — NÃO
		permissão. Nenhum re-desenho dos dois BCs aqui.

		(6) POSTURA DE BORDA (resolve def-024, metade auth) — os api.yaml
		com sync surface passam a poder declarar securitySchemes bearer
		(portador de identidade emitida sob o modelo deste ADR) — scheme
		ABSTRATO, sem fixar protocolo/vendor (implementação na trilha de
		produção); a metade servers é RE-ADIADA em def-082 (aguardando o
		ADR de deploy). def-024 → resolved (resolvedBy este ADR), sem
		pendência escondida.

		(7) def-080 RE-ADIADO com base nova — o modelo de ator deste ADR
		vira a BASE canônica que faltava ao enum; a mecanização (campo no
		#Command + enforcement no #Invariant) segue esperando a medição de
		volume das higienes (gatilho inalterado; amendment no próprio def).

		(8) VEÍCULO — WI-158: este ADR + ten-016 + def-082 novo + def-024
		resolved + def-080 amendado + o edit do #Envelope, no MESMO commit;
		api.yaml NÃO são tocados aqui (a declaração de security por BC é
		fatia mecânica posterior, agora desbloqueada).
		"""

	consequences: """
		Positivas:
		(P1) Fim do regime ator-string para atos novos: as 4 dimensões
		estruturadas no envelope — o audit reconstrói QUEM, EM NOME DE
		QUEM, EM QUE PAPEL e SOB QUE GOVERNANÇA de todo fato pós-adr-182;
		dp-10 vira dado do log, não prosa (as 18 atribuições nominais
		ganham caminho de saída declarado).
		(P2) def-024 (metade auth) resolve: api.yaml desbloqueados para
		declarar security bearer abstrato por fatia mecânica; servers
		re-adiado LIMPO em def-082 — zero pendência escondida.
		(P3) Tenant cunhado sem partição prematura: o domínio-de-rede é
		respeitado (fatos bilaterais nativos), o isolamento converge com a
		confidencialidade que ssc/p2p já praticam, e o COMO físico fica no
		runtime (QUE=spec/COMO=runtime).
		(P4) def-080 re-adiado com base nova: o enum de ator agora existe
		canonicamente — a mecanização futura parte de contrato, não de
		rascunho.
		(P5) Decide-vs-execute como dado (actor + executedVia +
		underGovernance versionado) — P10 auditável por construção; a Q4
		da lens-ai-agent-governance satisfeita no shape, plugada no
		mecanismo de governance-version que já existia.

		Negativas:
		(N1 — A NEGATIVA DE PRIMEIRA CLASSE, condição da escolha B): o
		isolamento entre organizações é PROPRIEDADE DE LEITURA, não de
		partição — o modo de falha canônico do desenho passa a ser BUG DE
		ESCOPO em query/superfície: uma leitura sem filtro de organização
		vaza dado de outra org. Mitigação NOMEADA: (a) autorização de
		acesso no território do idc (vigência de identidade como gate,
		molde inv-signature-requires-active-identity); (b) o invariante de
		escopo-por-organização do dec 4 — norma mecanizável, lacuna do
		runner nomeada; (c) a confidencialidade competitiva já estrutural
		(ssc/p2p) como precedente de disciplina. Sinal a vigiar:
		superfície nova mergeada sem escopo declarado.
		(N2) O slot opcional-no-shape convive com legado sem ator —
		uniformidade plena é assíntota por migração; dois regimes
		coexistem DECLARADOS (grandfathering, molde viewRegime).
		(N3) Obrigação-por-handler, não por shape, para a PRESENÇA do
		actor em atos novos — a mesma classe de honestidade do def-024: a
		norma + review + checks futuros forçam; o shape força apenas a
		ESTRUTURA quando presente (e o par de governança quando o agente
		decide).
		(N4) O modelo de usuário no idc é CONTRATO sem aggregate ainda —
		actorId humano referencia identidade cuja modelagem interna é
		fatia futura do idc (fronteira declarada, não lacuna esquecida).
		"""

	falsificationCondition: {
		condition:        "Este modelo estará ERRADO SE (a) o primeiro caso real multi-org exigir isolamento que a propriedade-de-leitura não acomode (partição física como requisito de DOMÍNIO, não de runtime — a Opção B subestimou); OU (b) um ato real recorrente não couber nas 4 dimensões (ex.: ato genuinamente em-nome-de-múltiplas-orgs — consórcio — forçando onBehalfOfOrg plural); OU (c) a obrigação-por-handler degradar em adoção — atos novos mergeando sem actor em volume, repetindo sob o modelo novo o modo de falha dos 18 strings nominais."
		observableSignal: "(a) fatia de runtime/tela escalando partição como requisito de domínio; (b) PR com ato que só entra no slot com gambiarra semântica; (c) contagem de eventos pós-adr-182 sem actor, visível em review/audit — todos observáveis em PR e no log."
	}

	affectedArtifacts: [
		"architecture/shared-schemas/envelope.cue",
		"architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue",
		"architecture/deferred-decisions/def-080-structure-command-actor-and-invariant-enforcement.cue",
	]

	plannedOutputs: [
		"architecture/tension-log/ten-016-envelope-actor-slot-expansion.cue",
		"architecture/deferred-decisions/def-082-api-yaml-servers-pending-deploy-adr.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo: ["def-082"]

	principlesApplied: [
		"P0 — uma casa por informação: o ator vive no envelope (nunca re-declarado por BC); as línguas são as canônicas (npm para organização, idc para identidade, stakeholder-map para papel, agent-spec/governance para agente).",
		"P10 — decide-vs-execute como dado do fato; vigência de identidade como gate determinístico (molde idc); o humano decide, o agente executa ou decide sob envelope versionado.",
		"P12 — governança executável: o invariante de escopo-por-organização nasce como norma mecanizável (candidato a structural-check; lacuna do runner nomeada), não prosa.",
		"dp-10 (domain/domain-definition.cue — casa verificada por grep nesta fatia; P0/P10/P12 vivem em design-principles) — responsabilidade jurídica identificável é o cerne do slot: quem agiu, em nome de quem, sob que governança — reconstituível de qualquer fato.",
	]

	supersedes: []

	rationale: """
		Por que B + (a): a Mesh é rede — fatos bilaterais tornam partição
		por-fato uma mentira de domínio; o slot no envelope é a única
		forma de UMA declaração uniforme (a alternativa data-por-evento
		re-declara o shape por BC e devolve a uniformidade à
		disciplina-por-autor — o modo de falha que os 18 strings provam).
		Trade-offs aceitos de frente: N1 como negativa de primeira classe
		(condição da própria escolha B do founder), N4 como fronteira
		declarada.

		Relações: honra a disciplina do def-022 pela rota formal (ten-016
		+ revisita + decisão do founder — a primeira expansão do envelope
		desde a consolidação); PRESERVA adr-172 (roleRef com critério
		tríplice — posições de participante NÃO viram papel cadastral);
		consome o vocabulário do WI-157 (sh-07/08/09); pluga no mecanismo
		de governance-version JÁ existente (agent-governance version +
		governanceGlobalVersion, tq-gv-12 — verificado na fonte); def-074
		(organismo sintético) mantém a verificação de borda na trilha de
		produção — este ADR fixa o QUE se grava.

		Lens aplicada: lens-ai-agent-governance (match pela condição
		'projetar trilha de auditoria para ações de agentes'; a Q4 do
		reasoningProtocol — reconstituição de qualquer decisão passada —
		moldou o underGovernance versionado). Demais lenses sem match
		direto (lens-trust-and-credibility-design cobre percepção/UX de
		confiança, não estrutura de identidade).

		Tensão com axiomas: nenhuma — a tese (operação por agente com
		responsabilidade identificável) é REFORÇADA: o ato do agente
		carrega a governança sob a qual decidiu.
		"""
}
