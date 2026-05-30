package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr127: artifact_schemas.#ADR & {
	id:    "adr-127"
	title: "Derivação do bounded context FCE (Financial Commitment Execution) — primeira aplicação de P13"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		P13 (architecture/design-principles.cue, adr-125) tornou a derivação
		de bounded context decisão explícita e auditável. O FCE é a primeira
		aplicação REAL de P13 — e sob pressão estrutural: é o BC mais
		constrangido pelo arco cycle-resolution (#84/#85/#86), que já fixou
		suas 6 relações cross-BC (fce↔rew, fce↔tcm, inv→fce, bkr→fce, fce→scf,
		fce→ato). P11 (dinheiro só se move quando a operação comprova) ancora
		sua invariante crítica.

		A derivação aplica o protocolo da section boundary-derivation do PG
		de canvas (adr-125 decision item 2). O resultado da derivação NÃO
		materializa campo no canvas: o schema #Canvas é struct fechada sem
		campo de derivação (Opção i, founder decision); a derivação vive
		canonicamente neste ADR e alimenta a section communication do canvas.

		Alternativas consideradas e rejeitadas:

		(a) Merge do FCE em CMT, INV ou BKR (não criar BC dedicado).
		    REJEITADA: o FCE passa nos 3 testes de separação (linguagem
		    ubíqua distinta, invariante própria, ownership canônico) — sua
		    linguagem de liquidação é disjunta de compromisso (CMT),
		    faturamento (INV) e rails (BKR), per os 6 negativeBoundaries do
		    subdomain.

		(b) Aggregate BudgetAllocation/BudgetDrawdown no FCE (Opção A).
		    REJEITADA em favor da Opção B: o Payment carrega commitmentRef
		    apontando para BudgetApproved do BDG; a liquidação realiza o
		    envelope (committed→realizado), sem aggregate de budget no FCE.
		    Evita aggregate anêmico e drift de linguagem — "alocação" é
		    decisão estratégica externa (bdg bd-allocation-not-treasury) e
		    "comprometimento" é do BDG (bd-commitment-not-payment); o FCE
		    REALIZA, não aloca.

		(c) Tratar o par fce↔tcm como ciclo a tipar com kind novo.
		    REJEITADA: a aresta reversa tcm→fce é sync query-only (zero
		    eventos), isenta pelo events-required filter (adr-120) — o par é
		    gate-acíclico em sc-cm-07, não exige kind nem ADR de ciclo.
		"""

	decision: """
		Derivar o FCE como bounded context CORE dedicado, materializando
		contexts/fce/canvas.cue (9 sections do PG canvas).

		(1) Três testes de separação — todos PASSED:
		    (a) Linguagem ubíqua distinta: settlement, financialization
		        (all-or-nothing), PrePaymentGuard, conditional retention
		        release, authorization proof, Payment state machine.
		    (b) Invariante própria que só ele garante: P11 na camada
		        financeira — dinheiro só se move quando a operação comprova
		        (gate PrePaymentGuard compondo elegibilidade REW + fatura INV
		        + integridade de evidência). Formalizada em adr-128.
		    (c) Ownership canônico: estado do Payment (11 invariantes),
		        authorization proof emitida ao BKR, e PaymentSettled como SoT
		        único do fato "dinheiro moveu".

		(2) Teste de remoção — PASSED: remover o FCE para a EXECUÇÃO por perda
		    de função, não por acoplamento. Discriminante "TCM projeta; FCE
		    executa": removido o FCE, a projeção (TCM) sobrevive degradada-mas-
		    funcional, enquanto a execução morre. Fronteira artificial faria
		    TCM parar de funcionar, não apenas perder um input.

		(3) Classificação das 6 relações cross-BC (ordem de preferência P13):
		    - fce↔rew: ciclo tipado policy-execution-feedback (adr-124/122),
		      ×2 arestas (preferência 3, legítimo).
		    - fce↔tcm: par gate-acíclico via events-required filter (adr-120);
		      tcm→fce query-only para otimização (não autorização);
		      fce→tcm async PaymentSettled (preferência 1).
		    - inv→fce, bkr→fce: OHS/ACL unidirecional acíclica (preferência 1).
		    - fce→scf: OHS/ACL; fce→ato: OHS/conformist (preferência 1).
		    Nenhum kind novo; nenhum ciclo não-classificado.

		(4) Decisão de budget: Opção B (sem aggregate; Payment.commitmentRef →
		    BudgetApproved). A imprecisão "budget allocation" na definition do
		    subdomain (strategic/subdomains/fce.cue:11) é registrada como
		    tensão em ten-013 (cross-artifact-friction); correção do subdomain
		    fica para PR separado (evitar scope creep no scaffold).

		Naming/shape das relações no context-map reconciliado em adr-126
		(mesmo PR). A invariante P11 formalizada em adr-128.
		"""

	consequences: """
		Positivas:
		(P1) A fronteira do FCE — o BC core mais constrangido do grafo — é
		auditável e P13-derivada, não tácita. Primeiro caso de uso real de
		P13 valida o protocolo boundary-derivation sob pressão estrutural.
		(P2) As 6 relações cross-BC ficam classificadas (não só direcionadas)
		na ordem de preferência; o único ciclo (fce↔rew) é tipado e o par
		fce↔tcm é isento por filtro — acyclicity gate-verificável (sc-cm-07).
		(P3) Opção B mantém o FCE enxuto (sem aggregate anêmico) e a linguagem
		ubíqua limpa (comprometimento=BDG, realização=FCE).

		Negativas:
		(N1) Forward-refs conscientes pendentes (rastreados em openQuestions do
		canvas): glossary (oq-fce-2), api-specs (oq-fce-1, flags true/true
		espelhando bdg), agent-spec (oq-fce-3), consumo de
		PaymentObligationDefaulted no REW (oq-fce-4, WI-043).
		(N2) A definition do subdomain mantém wording impreciso ("budget
		allocation") até PR de correção — mitigado: ten-013 + bd-realizes-not-
		allocates-budget documentam a fronteira correta; reader do subdomain
		isolado é o único exposto.
		(N3) 3 drifts PG↔schema (businessRole/archetype/derivedFrom catalog vs
		enums) surfacados durante authoring — mini-PR de polish mecânico
		pós-merge, fora do escopo deste PR.

		Fronteira regulatória: nenhuma diretamente. O FCE governa execução
		financeira sob SCD (P11 ancora integridade legal); este ADR é a
		derivação de fronteira (método de design), não uma decisão operacional
		de movimento de dinheiro.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Esta derivação estará errada SE o discriminante "TCM projeta; FCE
			executa" colapsar — i.e., se o TCM passar a depender do FCE para
			FUNCIONAR (parar sem ele), não apenas para receber input — OU se o
			ciclo fce↔rew deixar de ser a forma canônica do acoplamento (a aresta
			reversa rew→fce desaparece e o ciclo se torna redutível a
			unidirecional).
			"""
		observableSignal: """
			Reaplicação do teste de remoção quando o canvas do TCM ou as arestas
			fce↔rew mudarem; sc-cm-07 (acyclicity, catraca adr-123) sobre as 6
			arestas do FCE — surgimento ou sumiço de aresta no par fce↔rew é o
			gatilho observável.
			"""
	}

	affectedArtifacts: []

	plannedOutputs: [
		"contexts/fce/canvas.cue",
		"architecture/tension-log/ten-013-fce-subdomain-budget-allocation-imprecision.cue",
	]

	principlesApplied: ["P13", "P11", "P10", "P0"]

	supersedes: []

	rationale: """
		P13 aplicado integralmente: 3 testes de separação + teste de remoção
		+ classificação obrigatória de toda relação cross-BC + ônus invertido
		sobre ciclos (o único ciclo, fce↔rew, tem kind nomeado + ADR; o par
		fce↔tcm é isento por filtro determinístico, não por convenção). A
		decisão de fronteira não-trivial (criação de BC) exige este ADR per
		P13 — registrando a aplicação dos testes e a classificação adotada.

		P0 (uma localização canônica): a derivação vive só aqui (não vira
		campo do canvas, struct fechada — Opção i); a classificação das
		relações vive no context-map; o canvas referencia, não duplica.

		P11/P10: a invariante crítica (money-on-proof) e a separação agente-
		recomenda/gate-valida são as razões de o FCE ser core e proprietário;
		formalizadas operacionalmente nas businessDecisions do canvas e
		canonicamente em adr-128.

		Ancoragem: generaliza adr-065 (teste de remoção, registry-não-engine)
		e adr-085 (decisionAuthorityModel como discriminante de fronteira; FCE
		nomeado como alvo replicável). O par fce↔tcm exercita o discriminante
		signal-vs-state de P13: a query síncrona cruza um fato de estado
		(disponibilidade) para otimização, não uma decisão de autorização —
		por isso não é acoplamento de policy que justificaria kind de ciclo.

		Tensão com axiomas: nenhuma. ax-03 (pagar custo de complexidade cedo)
		confirmado: derivar a fronteira do BC mais constrangido com rigor
		agora é mais barato que descobrir fronteira errada sob escala.

		Lenses consultadas: lens-domain-language-and-terminology-design
		(linguagem ubíqua distinta) e lens-distributed-systems-design
		(acyclicity; query-read vs state-coupling no par fce↔tcm).
		"""
}
