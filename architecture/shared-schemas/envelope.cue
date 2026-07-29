package shared_schemas

// envelope.cue — Envelope CloudEvents-like subset compartilhado cross-BC.
// Consolidação per def-022 (resolved): 2 consumidores reais (CMT, DLV)
// validaram o shape; extração do inline duplicado. NÃO é conformidade
// formal CloudEvents 1.0 — é subset Mesh-local.
//
// Money NÃO é consolidado aqui (DLV não usa); ver def-025 para deferimento
// do Money até 2º consumidor real materializar.
//
// ── DISCIPLINA DE FRONTEIRA (anti-stealth-extension) ──
//
// #Envelope é INTENTIONALLY MINIMAL. Campos adicionais do CloudEvents 1.0
// (subject, datacontenttype, etc.) ou metadata-de-mercado (traceparent,
// partitionKey, correlationId, etc.) NÃO devem ser adicionados localmente
// por BCs ao alias #Envelope nem ao shape compartilhado aqui. Qualquer
// expansão do envelope cross-BC exige:
//   1. tension-entry articulando a necessidade real (não conveniência);
//   2. revisita cross-BC dos consumidores existentes;
//   3. decisão explícita do founder antes da edição deste arquivo.
//
// Por quê isso importa: o maior risco operacional não é mesh-2 (versão);
// é um BC futuro "melhorar" o envelope sozinho adicionando subject ou
// traceparent e silenciosamente forkar a semântica cross-BC. Hoje o gate
// é cultural/documental (não há check estrutural pra isso ainda).
//
// EXPANSÃO FORMAL ÚNICA ATÉ AQUI — o slot de ator (adr-182, WI-158):
// a rota acima foi PERCORRIDA, não contornada: ten-016 articula a
// necessidade (identidade estruturada de ator cross-BC vs 18 atribuições
// nominais em string), a revisita dos consumidores está registrada no
// adr-182 (o campo é OPCIONAL — nenhum evento legado quebra), e a
// decisão do founder é o próprio adr-182. NORMA DE HANDLER: todo ato
// novo pós-adr-182 (command processado → evento) PREENCHE actor; o
// shape opcional existe para o legado (grandfathering declarado), não
// como válvula para ato novo sem ator.

// #EnvelopeVersion: constante da versão atual.
//
// Pattern de coexistência futura: NÃO abrir disjunção aqui ("mesh-1" |
// "mesh-2") — isso afrouxaria o envelope e abriria porta pra drift. Quando
// mesh-2 surgir, criar #EnvelopeV2 num arquivo separado (envelope-v2.cue)
// com `envelopeVersion: "mesh-2"`; eventos legacy continuam usando
// #Envelope (mesh-1), novos usam #EnvelopeV2 — coexistência sem stealth-
// override do shape compartilhado.
#EnvelopeVersion: "mesh-1"

// #RFC3339Timestamp: helper reutilizável para timestamps RFC3339 (fração
// opcional + offset/Z). Usado em #Envelope.time e em campos de domínio
// CMT que também são RFC3339 (validatedAt, acceptedAt, etc.). DLV usa
// integer epoch pra timestamps de DOMÍNIO; este helper é só pra campos
// RFC3339 string.
#RFC3339Timestamp: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$"

// ── ATOR ESTRUTURADO (adr-182; expansão formal per ten-016) ──
//
// As 4 dimensões de todo ato: QUEM (kind + actorId), EM NOME DE QUEM
// (onBehalfOfOrg — o tenant da Opção B do adr-182: organização
// participante; isolamento é propriedade de LEITURA sobre log único da
// rede), EM QUE PAPEL (roleRef — archetype sh-* do stakeholder-map;
// critério tríplice de não-aplicação no adr-182 dec 1: não aplica a
// kind=agent, a contraparte em posição de participante per adr-172,
// nem a eventos ACL -received), SOB QUE GOVERNANÇA (underGovernance —
// obrigatório POR SHAPE quando kind=agent: o par governanceRef +
// governance-version que tq-gv-12 valida; é o que torna o
// humano-de-autoridade derivável para qualquer fato passado, lens
// ai-agent-governance Q4). executedVia cobre a direção inversa
// (humano decide, agente executa) — decide-vs-execute como dado (P10).

#ActorKind: "human" | "agent"

// União discriminada por kind, DOIS RAMOS FECHADOS (molde #SurfaceFamily
// do adr-180): cada ramo declara SÓ o que lhe cabe — presença indevida é
// rejeitada pelo fechamento do struct. A forma NÃO é estética: os três
// mecanismos CUE de condicionalidade cross-field — comprehension
// (`if kind == "agent"`), literal bottom (`_|_`) e disjunção — eram
// TODOS inalcançáveis pelo classificador do gerador de codegen na
// materialização desta fatia; a disjunção de ramos fechados foi a forma
// que o mesh-runtime ensinou ao classificador (rtd-037: sealed interface
// + ramos implementando), e ela mecaniza MAIS que as outras duas (roleRef
// sob agent e underGovernance sob human caem por fechamento, não por
// norma).
//
// #HumanActor: roleRef aplica (critério do adr-182 dec 1); executedVia
// cobre a direção inversa (humano decidiu, agente executou);
// underGovernance NÃO existe no ramo (a decisão humana não é sob
// envelope de agente — presença rejeitada por shape).
#HumanActor: {
	kind: "human"

	// Identidade de usuário emitida sob o lar do idc (a modelagem do
	// aggregate de usuário é fatia futura do idc — o adr-182 fixa o
	// CONTRATO).
	actorId: string & !=""

	// A organização participante em cujo nome o ato ocorre (língua npm,
	// term-participante; NPM é SoT do participante — adr-172: papéis de
	// participante seguem posicionais).
	onBehalfOfOrg: string & !=""

	// Papel intra-org (archetype do stakeholder-map, sh-07/08/09 e
	// sucessores). Opcional — critério tríplice de não-aplicação:
	// adr-182 dec 1.
	roleRef?: string & =~"^sh-[0-9]{2}$"

	// Direção inversa do decide-vs-execute: humano decidiu, agente
	// executou (adr-182 dec 2).
	executedVia?: string & =~"^agt-[a-z][a-z0-9-]*$"
}

// #AgentActor: actorId é o code agt-* do agent-spec; underGovernance
// OBRIGATÓRIO (o par que tq-gv-12 valida — humano-de-autoridade
// derivável de qualquer fato passado, lens ai-agent-governance Q4);
// roleRef NÃO existe no ramo (o agent-spec É o papel — dec 1 critério
// (a) mecanizado por shape); executedVia NÃO existe no ramo (o
// agente-decisor não tem direção inversa — veto do dec 2 por shape).
#AgentActor: {
	kind: "agent"

	actorId: string & =~"^agt-[a-z][a-z0-9-]*$"

	onBehalfOfOrg: string & !=""

	// governanceRef = envelope de governança do agente;
	// governanceVersion = governance-version vigente no ato (validado
	// por tq-gv-12 contra architecture/agent-governance.cue).
	underGovernance: {
		governanceRef:     string & !=""
		governanceVersion: string & =~"^[0-9]+\\.[0-9]+$"
	}
}

#Actor: #HumanActor | #AgentActor

// #Envelope: shape compartilhado cross-BC.
// - data NÃO está no base; cada evento adiciona data concretamente tipado.
// - `...` permite extensão por evento (data + campos específicos do tipo
//   do evento — NÃO permite override dos campos declarados aqui).
// - dataschema? permanece opcional: schema reference é hint discoverável;
//   obrigatoriedade é escolha per-evento (`dataschema: "..."` literal).
// - actor? OPCIONAL no shape (legado convive — grandfathering declarado);
//   OBRIGATÓRIO por norma de handler para todo ato novo pós-adr-182.
#Envelope: {
	id:              string & !=""
	source:          string & =~"^mesh://contexts/[a-z][a-z0-9-]*$"
	type:            string & !=""
	envelopeVersion: #EnvelopeVersion
	time:            #RFC3339Timestamp
	dataschema?:     string
	actor?:          #Actor
	...
}
