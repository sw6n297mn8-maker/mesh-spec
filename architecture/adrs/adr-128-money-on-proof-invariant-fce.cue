package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr128: artifact_schemas.#ADR & {
	id:    "adr-128"
	title: "Invariante money-on-proof (P11) no FCE + mecanismo criptográfico de evidência"
	date:  "2026-05-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		P11 (architecture/design-principles.cue) declara: "Dinheiro só se
		move quando a operação comprova. Toda transição financeira exige
		evidência vinculada com integridade criptográfica". O FCE é o BC que
		instancia P11 na camada de execução financeira — é a invariante que o
		torna core e proprietário (adr-127). Este ADR formaliza essa
		instanciação como decisão própria, separada da derivação de fronteira
		(adr-127), porque P11 é cross-cutting (governa a integração
		FCE↔INV↔REW↔BKR) e merece um ponteiro estável que as businessDecisions
		do canvas e os demais BCs possam referenciar.

		Motivação adicional (founder): o manipulationCost de sh-06 no canvas e
		a assumption as-fce-1 afirmam que "forjar evidência criptográfica é
		inviável". Sem explicitar o mecanismo, "inviável" é hand-wave. Este
		ADR detalha o mecanismo.

		Alternativas consideradas e rejeitadas:

		(a) Dobrar a invariante P11 dentro do ADR de criação (adr-127), sem
		    ADR próprio. REJEITADA: P11 é cross-cutting e referenciado por
		    múltiplas businessDecisions e por outros BCs; um ponteiro estável
		    (ADR dedicado) é mais útil que prose embutida na derivação.

		(b) Declarar a invariante sem detalhar o mecanismo criptográfico.
		    REJEITADA: "evidência forjada é inviável" sem mecanismo é
		    afirmação não-verificável; o detalhe é a diferença entre defesa
		    real e suposição.
		"""

	decision: """
		(1) Designar o FCE como enforcer canônico de P11 na camada de
		    execução financeira: nenhuma PaymentInstruction é despachada sem
		    as 3 condições do PrePaymentGuard — (a) fatura válida (InvoiceIssued
		    de INV), (b) elegibilidade de risco satisfeita (REW), (c) cadeia de
		    evidência íntegra. As 3 são compostas por um gate determinístico
		    (P10: agente recomenda, gate valida).

		(2) Mecanismo criptográfico que torna a falsificação de evidência
		    inviável (sustenta as-fce-1 e o manipulationCost de sh-06):
		    - Assinatura digital: cada evento de evidência é assinado pela
		      origem; a autoria é verificável e não-repudiável.
		    - Hash chain / encadeamento: eventos encadeados por hash de
		      conteúdo (tamper-evident); alterar um evento invalida a cadeia.
		    - Notarização de eventos: âncora externa periódica que torna a
		      cadeia tamper-evident em camadas (do hash de conteúdo ao anchor),
		      conforme P11 ("6 camadas, do hash de conteúdo ao anchor externo").
		    Forjar evidência exigiria comprometer simultaneamente assinatura +
		    cadeia + anchor — estruturalmente inviável.

		(3) As businessDecisions do canvas que operacionalizam P11 —
		    bd-money-moves-only-on-proof, bd-prepayment-guard-deterministic,
		    bd-conditional-retention-release — derivam deste ADR.

		Este ADR NÃO altera P11 (princípio) nem cria schema/structural-check
		novo; é o registro da instanciação no FCE.
		"""

	consequences: """
		Positivas:
		(P1) A invariante crítica do FCE tem registro canônico estável,
		referenciável pelas businessDecisions e por BCs adjacentes.
		(P2) O mecanismo criptográfico fica explícito — "inviável" deixa de
		ser hand-wave e vira propriedade verificável (assinatura + hash chain
		+ notarização), sustentando a análise adversarial de sh-06.
		(P3) A separação agente-recomenda/gate-valida (P10) fica ancorada no
		ponto onde dinheiro se move — o gate determinístico do FCE.

		Negativas:
		(N1) O detalhamento criptográfico aqui é de nível arquitetural
		(esquema), não de implementação (algoritmos/curvas/parâmetros
		concretos) — estes ficam para o Architecture Communication Canvas /
		domain-model do FCE (WI futuro). Mitigação: o nível arquitetural é
		suficiente para sustentar a invariante e a análise de incentivos.

		Fronteira regulatória: P11 ancora integridade legal (SCD/Bacen,
		constraint nível 1). Este ADR formaliza o invariante de design que
		sustenta essa integridade; não é decisão operacional sobre um
		pagamento concreto.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"contexts/fce/canvas.cue",
	]

	principlesApplied: ["P11", "P10", "P0"]

	supersedes: []

	rationale: """
		P11 (money-on-proof) é o princípio; este ADR é sua instanciação no
		FCE; as businessDecisions são as invariantes operacionais. A cadeia
		de referência: P11 (design-principles) ← adr-128 (instanciação + cita
		as BDs) ← BDs (rationale referencia P11). Como o canvas materializa
		antes deste ADR no PR mas ambos coexistem no merge, não há forward-ref
		quebrado: o canvas referencia P11 (existente) e este ADR; este ADR
		referencia o canvas (criado em adr-127).

		P10 (gate determinístico): a invariante só é segura porque o
		PrePaymentGuard é determinístico — agente recomenda, gate valida.
		Misturar recomendação estocástica e execução criaria um sistema onde
		ninguém sabe se um pagamento foi decisão ou alucinação.

		P0: o mecanismo criptográfico vive aqui (nível arquitetural) e o
		detalhe de implementação viverá no domain-model/ACC do FCE — sem
		duplicação; o canvas e as assumptions apenas referenciam.

		Separado de adr-127 deliberadamente: derivação de fronteira (adr-127)
		e invariante cross-cutting (adr-128) são decisões distintas; o ponteiro
		estável de P11 não deve ficar enterrado na prose da derivação.

		Tensão com axiomas: nenhuma. ax-05 (cenário de falha é perda monetária
		real) reforça: a invariante money-on-proof existe exatamente para
		fechar o gap "trabalho reivindicado vs realizado" onde a fraude vive.
		"""
}
