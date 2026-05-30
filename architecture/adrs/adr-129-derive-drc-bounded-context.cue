package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr129: artifact_schemas.#ADR & {
	id:    "adr-129"
	title: "Derivação do bounded context DRC (Disputes, Reversals & Corrections) — segunda aplicação de P13, primeira em batch"
	date:  "2026-05-30"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Segunda aplicação de P13 (architecture/design-principles.cue, adr-125)
		após o scaffold do FCE (adr-127). DRC é a primeira derivação em modo
		BATCH (9 sections do PG canvas autoradas integradas, sem section-by-
		section gate) — escolha justificada por pre-flight: DRC é supporting e
		enxuto (subdomain sem strategicProfile/mech/cost/capability refs), 0
		divergências de naming com adjacentes, e seu único ciclo (cmt↔drc) já é
		tipado canonicamente. Menor blast radius que o FCE.

		A derivação aplica o protocolo da section boundary-derivation do PG de
		canvas (adr-125 decision item 2). O resultado NÃO materializa campo no
		canvas (schema #Canvas é struct fechada — Opção i); a derivação vive
		canonicamente neste ADR e alimenta a section communication do canvas.

		Alternativas consideradas e rejeitadas:

		(a) Merge do DRC em CMT (não criar BC dedicado; disputa como parte do
		    lifecycle do compromisso). REJEITADA: o DRC passa nos 3 testes de
		    separação — sua linguagem de exceção (alegação→evidência→resolução→
		    impacto) é disjunta da linguagem de progressão normal do compromisso.
		    O próprio subdomain articula o anti-padrão: "sem DRC, CMT absorveria
		    toda a complexidade de reversões — inflando o core com lógica que é
		    inerentemente excepcional e regulatoriamente pesada" (drc.cue:24-27).

		(b) Criar ce-08 ("custo de resolução de disputa/litígio") no
		    domain-definition para ancorar costsEliminated. REJEITADA neste PR:
		    seria mudança semântica no domain-definition (catálogo de custos) →
		    ADR adicional + scope creep no scaffold. Usa-se ce-02+ce-03 (espelho
		    bdg) com nota explícita de que o encaixe é defensável mas não
		    dispute-specific; ce-08 fica como candidato futuro se o padrão
		    recorrer em outros BCs supporting.

		(c) ADR próprio para a invariante bd-resolution-requires-evidence (como
		    o FCE teve adr-128 para P11). REJEITADA: diferente do P11 (princípio
		    cross-cutting), resolução-requer-evidência é INSTÂNCIA de mech-evidence
		    (domain-definition:48), já existente — não é princípio novo. Não há
		    invariante cross-cutting no DRC que justifique ponteiro estável próprio.
		"""

	decision: """
		Derivar o DRC como bounded context SUPPORTING dedicado, materializando
		contexts/drc/canvas.cue (9 sections do PG canvas, modo batch).

		(1) Três testes de separação — todos PASSED:
		    (a) Linguagem ubíqua distinta: disputa, contestação, alegação,
		        evidência, resolução, impacto, reversão, estorno, penalidade —
		        disjunta de compromisso (CMT), execução financeira (FCE) e
		        cláusulas (CTR), per os 3 negativeBoundaries do subdomain.
		    (b) Invariante própria que só ele garante: resolução de disputa é
		        ancorada em evidência verificável (mech-evidence) — alegação sem
		        lastro não progride para resolução favorável
		        (bd-resolution-requires-evidence).
		    (c) Ownership canônico: estado do Dispute (open→under-evaluation→
		        resolved) + o fato DisputeResolved como sinal canônico consumido
		        por CMT e FCE.

		(2) Teste de remoção — PASSED: remover o DRC para o TRATAMENTO DE
		    EXCEÇÕES por perda de função, não por acoplamento. Discriminante: o
		    fluxo normal do compromisso (CMT) opera SEM disputas (disputas são
		    excepcionais); o que morre é a capacidade de processar contestações/
		    reversões. Fronteira artificial faria CMT parar de funcionar — mas
		    CMT progride normalmente no caso comum sem DRC.

		(3) Classificação das 5 arestas cross-BC (ordem de preferência P13):
		    - cmt↔drc (cmt-to-drc + drc-to-cmt): ciclo tipado
		      bidirectional-orchestration (adr-122 W1). DRC CONFORMA ao kind já
		      canônico — não deriva kind novo. Resolução de disputa altera estado
		      do compromisso; compromisso contextualiza disputa.
		    - dlv-to-drc: OHS/ACL acíclica (DeliveryRejected entry point imediato
		      + DeliveryVerified post-verification-dispute) (preferência 1).
		    - ctr-to-drc: OHS-PL/ACL hybrid (eventos de supersessão/cancelamento
		      + queries de termos/cláusulas) (preferência 1).
		    - drc-to-fce: OHS/ACL acíclica (DisputeResolved,
		      FinancialCompensationOrdered) (preferência 1).
		    Nenhum kind novo; nenhum ciclo não-classificado.

		(4) Decisões de escopo: costsEliminated ce-02+ce-03 (espelho bdg;
		    subdomain drc não declara costRefs — encaixe defensável não
		    dispute-specific, ce-08 candidato futuro); cc-04 como ref local
		    (subdomain sem capabilityRefs, pattern INV/BDG); governança com
		    INVERSÃO vs FCE — resolução material é supervised por default (P10,
		    julgamento não-categórico), threshold de materialidade como input
		    upstream (anti escalation-bypass).

		Sem ADR adicional (≠ FCE/adr-128): o DRC não tem invariante cross-cutting
		própria de princípio. A aresta drc-to-fce é formalizada no context-map,
		mas o consumo no canvas FCE é forward-ref (oq-drc-4, WI de reconciliação,
		mesmo padrão WI-043 do FCE).
		"""

	consequences: """
		Positivas:
		(P1) A fronteira do DRC é auditável e P13-derivada. Segunda aplicação de
		P13 valida o protocolo em modo BATCH (vs section-by-section do FCE) —
		exercita a calibragem de modo por complexidade (pre-flight scoring).
		(P2) As 5 arestas ficam classificadas; o ciclo cmt↔drc conforma ao kind
		já canônico (adr-122) sem nova decisão de kind — acyclicity preservada
		(sc-cm-07 0 ciclos, edgeFilter exclui o par).
		(P3) DRC supporting enxuto absorve a complexidade de reversões, mantendo
		o core do CMT livre de lógica excepcional (drc.cue:24-27 realizado).

		Negativas:
		(N1) Forward-refs conscientes pendentes (openQuestions do canvas):
		glossary (oq-drc-1), agent-spec (oq-drc-2), api-specs (oq-drc-3, flags
		true/true), e consumo drc-to-fce no canvas FCE (oq-drc-4, WI futuro).
		(N2) costsEliminated ce-02+ce-03 é encaixe defensável mas não
		dispute-specific (nenhum ce do catálogo é de disputa/litígio); ce-08 é
		candidato futuro registrado na contribution. Sem tensão formal — o
		encaixe espelha o precedente bdg.
		(N3) def-029 (validation-prompt advisory de derivação) DISPARA neste
		scaffold: DRC é o 13º canvas, atingindo a recurrence threshold 13 do
		trigger. É decisão do founder materializar o validation-prompt ou
		continuar deferindo — reportado como advisory, não atuado unilateralmente.

		Fronteira regulatória: nenhuma diretamente. Disputas/reversões têm
		dimensão regulatória (prazos, trail), mas este ADR é a derivação de
		fronteira (método de design), não uma decisão operacional sobre uma
		disputa concreta. O canvas declara o escalation regulatory-deadline-at-risk
		como constraint nível 1.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: []

	plannedOutputs: [
		"contexts/drc/canvas.cue",
	]

	principlesApplied: ["P13", "P10", "P0"]

	supersedes: []

	rationale: """
		P13 aplicado integralmente: 3 testes de separação + teste de remoção +
		classificação obrigatória de toda relação cross-BC + ônus invertido sobre
		ciclos (o único ciclo, cmt↔drc, já tem kind nomeado + ADR — adr-122;
		DRC apenas conforma). A decisão de fronteira não-trivial (criação de BC)
		exige este ADR per P13.

		P0 (uma localização canônica): a derivação vive só aqui (não vira campo
		do canvas — Opção i); a classificação das relações e o kind do ciclo
		vivem no context-map; o canvas referencia, não duplica.

		P10: a razão de o DRC ter governança invertida vs FCE — resolução de
		disputa material não é categórica (envolve julgamento sobre suficiência
		de evidência e equidade), então o default é supervisão, não autonomia.
		O threshold de materialidade como input upstream (não interpretação do
		DRC) materializa o critério P10 sem dar ao agente o poder de rebaixar
		disputas materiais por mis-classification.

		Modo batch (primeira vez): justificado por pre-flight scoring — DRC
		supporting enxuto, 0 divergências de naming (vs 2 do FCE que exigiram
		adr-126), ciclo já tipado (vs descoberta empírica do fce↔rew). O batch
		exercita a calibragem de esforço por complexidade que o FCE
		(section-by-section, BC core mais constrangido) estabeleceu como o
		extremo oposto.

		Ancoragem: generaliza adr-065 (teste de remoção) e adr-085
		(decisionAuthorityModel). O ciclo cmt↔drc reusa bidirectional-orchestration
		(adr-118/122), demonstrando que a taxonomia aberta de P13 também serve
		para CONFORMAR a kinds existentes, não só criar novos.

		Tensão com axiomas: nenhuma. ax-05 (cenário de falha é perda monetária
		real) reforça a invariante de evidência: resolução de disputa sem lastro
		seria vetor de fraude com impacto financeiro direto via estorno indevido.
		"""
}
