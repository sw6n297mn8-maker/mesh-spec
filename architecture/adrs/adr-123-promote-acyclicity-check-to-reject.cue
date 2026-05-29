package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr123: artifact_schemas.#ADR & {
	id:    "adr-123"
	title: "Promover sc-cm-07 enforcement de warn para reject (PR-3 cycle-resolution, promoção)"
	date:  "2026-05-29"

	decisionClass: "foundational"
	decider:       "founder"
	status:        "accepted"

	context: """
		sc-cm-07 (directed-acyclicity, adr-117) nasceu born-warn per
		catraca adr-097 — 4 ciclos no grafo original (2026-05-28). O
		plano cycle-resolution registrado em def-026/027/028
		.triggerCalibrationRationale previa 3 PRs:
		- PR-1 (adr-118 + adr-119): schema extensions Família A — PR #84
		  ✓ merged.
		- PR-2 (adr-120): capability exists + filter events-required
		  Família B → W4 resolvido — PR #85 ✓ merged.
		- PR-3 (adr-121 + adr-122 + adr-124 + este ADR): capability
		  notEquals + aplicação Família A (com descoberta empírica de
		  policy-execution-feedback via Ajuste 1) + promoção warn→reject.

		Estado pré-promoção (após adr-122 + adr-124 do mesmo PR-3):
		- adr-120 (PR-2) materializou filter events-required → W4
		  (fce↔tcm via tcm-to-fce query-surface) excluída do grafo.
		- adr-122 (mesmo PR-3) aplicou bidirectional-orchestration em
		  cmt-to-drc + drc-to-cmt → W1 quebra.
		- adr-122 aplicou policy-reaction em rew-to-cmt + rew-to-ins
		  → W2 quebra; rew-to-ins é generalização proativa (não-cycle).
		- adr-122 aplicou policy-execution-feedback em rew-to-fce +
		  fce-to-rew → sub-ciclo fce↔rew quebra (descoberta empírica
		  via Ajuste 1; adr-124 introduziu enum value para nomeá-lo).
		- W3 (fce→drc→cmt→rew→fce) quebra por cascata (cmt-to-drc +
		  rew-to-cmt ambas excluídas via Família A).
		- Total: 0 ciclos detectados pelo sc-cm-07.

		Catraca adr-097 (born-warn + irreversibilidade unidirecional)
		permite promoção warn→reject quando contagem de violações
		zera. Promoção é o passo terminal do born-warn lifecycle —
		converte o check de signal advisory em gate determinístico.

		Resolução de def-028: o ciclo W4 (fce↔tcm) foi resolvido por
		adr-120 (PR-2). Mas o trigger calibration explicitamente
		articulou que def-028 só seria marcado resolved no PR-3,
		quando o plano completo de cycle-resolution se conclui —
		"adr-120 NÃO resolve def-028 — só materializa o filter
		(infraestrutura). Resolução ocorre em PR-3 quando founder
		marcar def-028.status = resolved com resolvedBy apontando
		para o ADR de PR-3" (adr-120 prose). O ADR terminal do plano
		é este — adr-123 (promoção) é a evidência que o arco de
		cycle-resolution fechou; resolvedBy aponta aqui.

		Pré-condições satisfeitas:
		- adr-121 (capability notEquals) — precondição infra para
		  adr-122. Merge no mesmo PR-3.
		- adr-124 (policy-execution-feedback enum value) — precondição
		  para aplicação em rew-to-fce/fce-to-rew em adr-122. Merge no
		  mesmo PR-3. Descoberta via Ajuste 1.
		- adr-122 (aplicação Família A + edgeFilters novos) —
		  precondição substantiva para 0 ciclos. Merge no mesmo PR-3.
		- adr-117 (kind directed-acyclicity + sc-cm-07 inicial) — PR
		  histórico ✓.
		- adr-097 (catraca born-warn → reject quando count zera) —
		  política governance histórica ✓.

		Alternativas consideradas e rejeitadas:

		(a) Manter sc-cm-07 como warn. REJEITADA: catraca adr-097
		exige promoção quando count zera — manter warn seria drift de
		política (warn perpétuo após resolução é tag inútil; gate
		determinístico é o estado-alvo). Plus: futura introdução de
		ciclo não bloquearia CI, perdendo o ponto de ter o check.

		(b) Promover em PR separado (PR-4) após observação de
		estabilidade. REJEITADA: catraca adr-097 não exige soak time;
		promoção é decisão DDD/governance, não risk mitigation que
		precise de observação empírica. Atrasar separa decisão de
		evidência (adr-122 fecha; adr-123 finaliza — coesão temporal).
		Ajuste 1 já forneceu a evidência empírica intermediária no
		mesmo PR.

		(c) Promover sc-cm-07 a "info" (advisory mais leve que warn)
		em vez de "reject". REJEITADA: info é signal-only que CI
		ignora — perda completa de gate. Catraca adr-097 vai de warn
		para reject (one-way) ou permanece warn; "info" não é estado
		valido per política.

		(d) Promover sc-cm-07 a reject neste ADR + também subir o
		mode default do runner para enforce stricter (e.g., FAIL on
		WARN). REJEITADA: scope creep — runner mode é decisão
		separada (envelope diferente); este ADR promove um único
		structural-check.
		"""

	decision: """
		Mudança atômica única:

		architecture/structural-checks/context-map.cue:
		  sc-cm-07.enforcement: "warn"  →  sc-cm-07.enforcement: "reject"

		O rationale do sc-cm-07 já reflete plano completo (registrado
		em adr-122) — este ADR apenas flipa o enforcement.

		Marcação de def-028 como resolved (no mesmo commit do PR-3
		governado por este ADR):
		  def-028.status: "resolved"
		  def-028.resolvedBy: "architecture/adrs/adr-123-promote-acyclicity-check-to-reject.cue"

		Este ADR NÃO toca:
		- strategic/context-map.cue (já editado em adr-122)
		- schemas (já editados em adr-121 + adr-124)
		- runner (já editado em adr-121)
		- def-026/027 (já resolvidos em adr-122)
		"""

	consequences: """
		Positivas:
		(P1) Catraca adr-097 cumprida em prazo definido (29 dias
		após introdução do sc-cm-07 em 2026-04-30; resolução completa
		em 2026-05-29). Pattern de built-in cycle-resolution
		demonstrável.

		(P2) Gate determinístico: futura introdução de ciclo no
		grafo (regression) bloqueia CI imediatamente. Não há janela
		de drift entre intent (sem ciclos) e enforcement.

		(P3) Plano cycle-resolution conclui o arco completo. Os 4
		ciclos do estado original + 1 sub-ciclo emergente (fce↔rew)
		foram resolvidos por mecanismos distintos (filter
		events-required para W4 sync-only-query; typed kinds para
		W1/W2/W3 bidirectional/policy; novo enum value
		policy-execution-feedback para fce↔rew descoberto via
		Ajuste 1). Vocabulário Família A + Família B disponível para
		futuras necessidades.

		(P4) Reject enforcement integra-se com required-status-check
		do branch-protection (per adr-110 raiz de confiança).
		Mudanças futuras que introduzam ciclo via aresta nova ou
		alteração de kind enfrentam gate técnico, não apenas review
		humano.

		(P5) Validação empírica do Ajuste 1 (warn-first → validate
		→ promote) demonstrou eficácia: sub-ciclo fce↔rew capturado
		ANTES da promoção; adr-124 introduzido atomicamente; arco
		fecha sem PR de reversão. Pattern repetível para futuras
		born-warn → reject transitions.

		Negativas:
		(N1) Mudança one-way: catraca adr-097 não permite reversão
		para warn sem ADR explícito de reversão (que mostraria
		racional aceitando drift). Custo: agility perdida; ganho:
		integridade do gate. Trade-off explicit per adr-097.

		(N2) Hipotético futuro caso onde ciclo emerge legitimamente
		(e.g., novo padrão DDD que justifique loop) terá custo de:
		(a) ADR introduzindo novo kind; (b) edgeFilter notEquals
		novo no sc-cm-07; (c) merge bloqueado até filter ser
		adicionado. Mitigação: pattern adr-118/119/120/121/124 mostra
		que extensões de framework são organicamente baratas. Custo
		aceitável para a integridade.

		(N3) Risco residual: se algum BC criar dependência via tag
		semântica ainda não tipada (e.g., uses queries para enforce
		policy decision), o filter events-required (PR-2) já cobre.
		Se BC usar events mas semantic for policy-reaction (sem
		marcar kind), gate falha — autor é forçado a marcar kind
		conscientemente. Boundary de safety net.

		Known gaps declarados:
		- Promoção é de UM structural-check (sc-cm-07). Outros
		  born-warn checks permanecem em seus respectivos lifecycles
		  governados por suas próprias catracas. NÃO há cascade
		  effect.
		- Runner default mode permanece como configurado em adr-110
		  (bloqueante por design); promoção sc-cm-07 apenas explicita
		  que este check específico contribui agora como FAIL em vez
		  de WARN.
		- Ajuste 1 (warn-first → validate → promote) é convenção
		  operacional documentada em adr-124 + adr-122 prose.
		  Codificação formal em workflow CI fica para ADR follow-on
		  se padrão recorrer.

		Fronteira regulatória: nenhuma. Decisão de gate interno.
		Sem efeito em Bacen/SCD/LGPD/KYC/AML.
		"""

	reversibility: "high"
	blastRadius:   "local"

	affectedArtifacts: [
		"architecture/structural-checks/context-map.cue",
		"architecture/deferred-decisions/def-028-fce-tcm-sync-query-filter.cue",
	]

	plannedOutputs: [
		"architecture/structural-checks/context-map.cue",
		"architecture/deferred-decisions/def-028-fce-tcm-sync-query-filter.cue",
	]

	principlesApplied: ["P0", "P12"]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P0: enforcement: "reject" é estado canônico declarado no
		structural-check; runner consume sem duplicar policy.

		P12: gate determinístico substitui review humano para a
		dimensão "grafo de dependência acíclico". Catraca adr-097
		formaliza progressão warn→reject como política de
		governance-as-code (não decisão ad-hoc per founder mood).

		Failure mode evitado: warn perpétuo após cycle resolution
		(tag inútil) ou drift silencioso (regression de ciclo sem
		bloqueio).

		Tensão com axiomas: nenhuma. ax-03 confirmado: complexidade
		paga em cycle-resolution agora vs reviewer fatigue infinito.

		Lenses consultadas:
		- lens-governance-as-code: born-warn → reject lifecycle é
		  pattern canônico em validation frameworks com adoption
		  gradual.

		Relacionamento com def-028 (criado em PR #83 anterior): este
		ADR resolve def-028 substantivamente como passo terminal do
		arco cycle-resolution. resolvedBy aponta aqui. defersTo NÃO
		usado (def-028 criado em PR anterior; este ADR só finaliza
		o arco).

		Relacionamento com adr-121/122/124 (mesmo PR): este ADR
		depende factualmente da aplicação de adr-122 (sem ela,
		sc-cm-07 reportaria 4 WARN e promoção bloqueia CI), que por
		sua vez depende de adr-121 (notEquals capability) e adr-124
		(policy-execution-feedback enum value). Sequência merge no
		commit do PR-3 é coerente: adr-121 (cap) + adr-124 (cap) →
		adr-122 (apply) → adr-123 (promote). Atomicidade do PR
		garante coexistência.

		Relacionamento com adr-097 (política catraca): este ADR é
		instância de aplicação do princípio "born-warn → reject
		quando count zera". Não substitui nem altera adr-097 —
		instancia. Adicionalmente registra eficácia empírica do
		Ajuste 1 (warn-first → validate → promote) como complement
		operacional da catraca.
		"""
}
