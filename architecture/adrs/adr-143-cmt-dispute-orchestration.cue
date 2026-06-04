package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr143: artifact_schemas.#ADR & {
	id:    "adr-143"
	title: "Orquestração de disputa no CMT: enum local + revalidação CTR + supervisão"

	date: "2026-06-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		O CMT consome resoluções de disputa do DRC como evento ACL inbound
		(evt-dispute-resolved-received), roteado a cmd-handle-dispute-resolution, que inspeciona o
		tipo de resolução. Mas esse tipo — #DisputeResolution — era OPACO (string, "owned by DRC"),
		e os três comportamentos que ele implica (cancel, modify_terms, maintain) não tinham contrato
		verificável: modify_terms não declarava se termos modificados exigem lastro em CTR, e maintain
		sobre um compromisso suspended tinha semântica de reativação ambígua. O probe do Ciclo 4
		(adr-134, record mergeado) surfou isso como pf-cmt-4/6/7.

		A correção Fatia A+C (adr-142) acabou de fechar o contrato do aceite bilateral — termsHash,
		CTR fail-closed em propose-time, idempotência — destravando o golden-example
		bd-mutual-acceptance. Esta Fatia B fecha o RESTANTE do contrato do CMT (a orquestração de
		disputa) ANTES do adr-140 (codegen), para que o codegen opere sobre um CMT completo.

		O DRC, contraparte da orquestração, é hoje canvas-only (sem domain-model). Canonizar o payload
		de DisputeResolution no DRC exigiria scaffoldar o domain-model do DRC — escopo além do que esta
		fatia precisa. Daí o Caminho B: o CMT modela um enum local fechado como ACL consumer (a
		fronteira que ele controla), e a canonicalização no DRC fica deferida (def-047) para quando o
		DRC ganhar domain-model.

		A decisão mais sensível é o modify_terms: uma resolução que altera termos de um compromisso já
		accepted. Como disputa só existe quando o consenso bilateral falhou, exigir novo aceite
		bilateral seria circular; a resolução é tratada como override autoritativo do DRC (SD1), o que
		cria uma tensão com inv-mutual-bilateral-acceptance — resolvida escopando o invariante à
		formação inicial e registrando o carve-out em ten-014. O limite inviolável permanece: a disputa
		NÃO pode criar termo material fora do CTR (modify_terms revalida CTR, fail-closed).

		Alternativas avaliadas:
		(a) re-aceite bilateral em modify_terms — rejeitada: disputa existe quando o consenso falhou;
		    exigir re-aceite torna a resolução circular (uma parte sempre pode recusar).
		(b) DRC autoritativo SEM revalidar CTR — rejeitada: "Disputa não deve virar canal lateral para
		    criar termo material fora do CTR".
		(c) reativação automática em maintain — rejeitada: contradiz inv-reactivation-requires-supervision
		    e silencia uma mudança de estado de risco (o compromisso fora suspended por risco/disputa).
		(d) scaffold do DRC junto — rejeitada: inflação de escopo (mesmo critério que separou A de B).
		(e) evento publicado CommitmentTermsModified agora — rejeitada: amplificaria a fatia para
		    cross-BC sem necessidade imediata (def-048 rastreia).
		(f) reusar CommitmentStateChanged com causeType — rejeitada: previousState=newState (modify_terms
		    não muda estado) é torto semanticamente.
		(g) estender sc-cmt-02 — rejeitada: misturaria semânticas propose-time e dispute-time; sc-cmt-09
		    dedicado é mais claro.
		"""

	decision: """
		(1) DisputeResolution LOCAL. Fechar o enum {cancel | modify_terms | maintain} em events.cue; o
		    CMT é ACL consumer dessa taxonomia. def-047 registra a canonicalização futura no DRC
		    (trigger adjacent-need file-exists contexts/drc/domain-model.cue).

		(2) modify_terms REVALIDA CTR. Uma resolução modify_terms só altera o compromisso se os novos
		    termos validam sync no CTR; fail-closed se o CTR estiver indisponível — modificação
		    REJEITADA, estado PRESERVADO. Materializado por nova invariante
		    inv-dispute-modify-terms-revalidates-ctr + structural-check sc-cmt-09. O termsHash
		    recomputado é estado interno do aggregate (consistência com a invariante de lastro); a
		    notificação a consumidores que fizeram snapshot fica deferida (def-048).

		(3) maintain SOBRE suspended EXIGE REATIVAÇÃO SUPERVISIONADA. maintain NÃO auto-reativa um
		    compromisso suspended; a reativação permanece no caminho existente cmd-reactivate-commitment
		    (guard inv-reactivation-requires-supervision). Sobre accepted, maintain é no-op (compromisso
		    segue ativo). Sobre at-risk (marcação de risco em compromisso accepted), maintain mantém a
		    marcação como está. Sobre cancelled (terminal), maintain é inválido — disputa não pode ser
		    resolvida com maintain se o compromisso foi terminado.

		(4) CARVE-OUT AUTORITATIVO (SD1). modify_terms é override autoritativo do DRC:
		    inv-mutual-bilateral-acceptance passa a valer para a formação inicial (proposed→accepted); a
		    modificação por disputa NÃO exige novo AcceptanceConfirmation. ten-014 documenta o carve-out.

		(5) NOTIFICAÇÃO DOWNSTREAM DEFERIDA (SD2). A notificação de modify_terms a consumidores que
		    fizeram snapshot de termos (BDG/INV) é deferida a def-048.

		(6) SEM SCAFFOLD DO DRC NESTA SESSÃO. A canonicalização de DisputeResolution/DisputeRef no DRC é
		    trabalho próprio (def-047).
		"""

	consequences: """
		Positivas:
		(P1) contrato de disputa do CMT fechado → o codegen (adr-140) opera sobre um CMT COMPLETO, não
		     parcial.
		(P2) padrão ACL consumer (DRC→CMT, enum fechado local) aplicado consistentemente — CMT AUTÔNOMO
		     até o DRC ganhar domain-model.
		(P3) o carve-out de inv-mutual-bilateral-acceptance fica REGISTRADO em ten-014 (tension-log) —
		     evita drift silencioso (leitor futuro vê a exceção, não infere).
		(P4) modify_terms preserva lastro CTR (fail-closed) E a cadeia mech-evidence (termsHash
		     recomputado) — disputa não vira canal lateral.
		(P5) maintain sobre suspended não silencia estado de risco (reativação supervisionada preservada).

		Negativas / limitações:
		(N1) dívida explícita criada — def-047 (canonicalização DRC) + def-048 (notificação downstream);
		     o CMT opera com taxonomia local e sem notificação até a revisita.
		(N2) o carve-out torna inv-mutual-bilateral-acceptance não-"blanket" — revisões futuras exigem
		     cuidado; quem lê o invariante isolado precisa ver ten-014.
		(N3) sc-cmt-09 adiciona um structural-check ao runner (impacto mínimo — domain-invariant
		     validation-time, não bloqueante).
		(N4) notificação deferida (def-048) → até lá, consumidores que fizeram snapshot de termos
		     (BDG/INV) podem operar sobre termos pré-modificação após modify_terms — janela conhecida,
		     rastreada.
		"""

	reversibility: "low"
	blastRadius:   "cross-artifact"

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se o domínio exigir que disputa imponha termos
			judiciais/arbitrais fora do CTR — caso em que a hierarquia DRC/CTR/CMT muda e merece ADR
			próprio.
			"""
		observableSignal: """
			Uma decisão de resolução de disputa real (judicial, arbitral, ou contratualmente legítima
			por outra via) bloqueada pelo gate fail-closed do modify_terms porque o CTR não tem template
			para o termo imposto pela autoridade externa — sinal de que a hierarquia "CTR é guardião
			único de termos" não comporta a realidade do domínio.
			"""
	}

	affectedArtifacts: [
		"contexts/cmt/schemas/events.cue",
		"contexts/cmt/domain-model.cue",
		"contexts/cmt/canvas.cue",
		"architecture/structural-checks/cmt-domain-model.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-047-drc-dispute-resolution-canonicalization.cue",
		"architecture/deferred-decisions/def-048-cmt-modify-terms-downstream-notification.cue",
		"architecture/tension-log/ten-014-dispute-modify-terms-authoritative-override.cue",
	]

	defersTo: ["def-047", "def-048"]

	principlesApplied: ["P0", "P1", "P7", "P10", "P11", "P13", "dp-08", "dp-10"]

	supersedes: []

	rationale: """
		P0: zero-drift entre inv-dispute-modify-terms-revalidates-ctr (domain-model) e sc-cmt-09
		(structural-check) — duas representações da mesma regra, localização canônica única. P1: a fatia
		fecha o contrato de disputa antes do adr-140 para o codegen operar sobre CMT completo. P7:
		#DisputeResolution deixa de ser raw string e vira value class (enum fechado). P13: a relação
		cross-BC DRC→CMT é classificada como ACL consumer (downstream translation); o Caminho B modela a
		taxonomia local e defere a canonicalização no DRC (def-047) — coerente com o ônus invertido sobre
		o ciclo CMT↔DRC já tratado em def-026/adr-122. P10: o gate modify_terms↔CTR e a reativação
		supervisionada são gates determinísticos. P11: modify_terms recomputa o termsHash, preservando a
		cadeia mech-evidence. dp-08/dp-10: a revalidação CTR + o carve-out preservam incentive
		compatibility (sem termo fora do CTR) e responsabilidade jurídica (DRC como autoridade
		identificável). "Disputa não deve virar canal lateral para criar termo material fora do CTR."

		Escalação: o carve-out autoritativo de inv-mutual-bilateral-acceptance toca semântica de
		obrigação contratual (disputa modifica termos) → classe-irreversível por CLAUDE.md; a escalação
		está satisfeita pela aprovação explícita da SD1 + a falsificationCondition (guarda para termos
		judiciais/arbitrais fora do CTR → ADR próprio).

		Tensão: registrada em ten-014 (há tensão real — o carve-out — documentada; não "nenhuma").
		Linhagem: surfado pelo probe de adr-134; relaciona-se a adr-142 (Fatia A+C — referência, NÃO
		supersede); destrava adr-140 (codegen, downstream). P6 (idempotência) não se aplica — a Fatia B
		não adiciona semântica de idempotência load-bearing.
		"""
}
