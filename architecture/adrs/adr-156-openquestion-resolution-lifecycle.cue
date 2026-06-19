package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-156 — Lifecycle de resolução (open→resolved) para o #OpenQuestion. O schema
// sabia ABRIR perguntas mas não FECHÁ-LAS ({id, question, impact, deadline?,
// rationale}, sem status). Este ADR adiciona o lifecycle binário (default "open",
// additive/backward-compatible) e materializa o 1º uso flipando os 2 oq do FCE
// (glossary + agente, ambos autorados). Irmão magro do #DeferredDecision (adr-062):
// mesma semântica de lifecycle discriminado, sem triggered/triggers/recurrence/runner
// — oq é respondido por um humano autorando o artefato, não disparado por condição
// automática; a natureza difere, logo a forma difere.

adr156: artifact_schemas.#ADR & {
	id:    "adr-156"
	title: "Adicionar lifecycle de resolução (open→resolved) ao schema #OpenQuestion"
	date:  "2026-06-19"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "repo-wide"

	context: """
		LACUNA — abrir sem fechar. O #OpenQuestion (artifact-schemas/canvas.cue)
		modela {id, question, impact, deadline?, rationale} — sabe ABRIR uma pergunta
		mas não tem como FECHÁ-LA: sem status, sem campo de resolução. São 77 oq em 14
		canvas, nenhum jamais resolvido — não por falta de respostas, mas por falta de
		MECANISMO. Uma pergunta respondida tem dois destinos ruins: fica eternamente
		"aberta" (o canvas afirma falso) ou é removida (orfanando a provenance que a
		referencia por id). Os 2 oq do FCE são o caso vivo: oq-fce-2 (glossary) e
		oq-fce-3 (agent-spec) perguntavam "quando autorar X?"; X foi autorado (glossary
		19 termos; par do agente em #170), e não há como marcar a pergunta respondida.

		PARALELO — o irmão já tem lifecycle. O #DeferredDecision (deferred-decision.cue,
		adr-062) JÁ carrega lifecycle (open → triggered → resolved | withdrawn). O
		#OpenQuestion nunca ganhou — assimetria a corrigir. Mas o oq lifecycle é
		DELIBERADAMENTE mais magro: binário open → resolved, SEM triggered, triggers[],
		recurrence ou runner. A razão é categórica: um deferimento é revisitado por uma
		CONDIÇÃO automática (o runner evaluate-deferred-triggers.sh avalia triggers a
		cada commit); um open-question é respondido por um HUMANO autorando o artefato
		que a pergunta antecipava. A natureza do fechamento difere (automático vs
		humano), logo a forma difere — o oq não importa a maquinaria de trigger.

		RETROCOMPAT como requisito de design. A mudança DEVE ser additive: os 77 oq
		existentes não declaram status e não podem ser tocados em massa por uma higiene
		de schema. O default "open" garante isso — oq sem status resolve para "open" e
		permanece válido sem edição. Verificado por teste isolado: cue vet exit 0 com o
		oq legado defaultando "open", e resolved-sem-resolvedBy corretamente rejeitado.
		A forma CUE é if-conditional (status default + blocos `if status == ...`), NÃO a
		disjunção-de-structs do #DeferredDecision — esta quebra com default ("unresolved
		disjunction": o branch resolved fica incompleto, não eliminado). Mesma semântica
		de lifecycle, mecanismo CUE diferente, porque o oq precisa de default (retrocompat)
		e o def não (todo deferimento declara status explícito desde a criação).

		AMARRAÇÃO — schema + 1º uso no mesmo commit. Diferente do adr-154/155 (cuja
		materialização era frente separada, daí proposed), este ADR leva o schema E o
		1º uso (flip dos 2 oq do FCE) no MESMO commit: decisão completa e materializada
		atomicamente, sem frente downstream a ratificar. Daí accepted desde o commit
		inicial (precedente adr-132).
		"""

	decision: """
		(1) LIFECYCLE if-conditional no #OpenQuestion (artifact-schemas/canvas.cue):
		- status: *"open" | "resolved" — default "open" (retrocompat: os 77 oq existentes
		  resolvem para "open" sem edição).
		- if status == "resolved": resolvedBy: #OriginRef (reusado de deferred-decision.cue,
		  mesmo package artifact_schemas — zero duplicação P0) + resolvedCondition: string
		  substantiva (O QUE cumpriu a resolução — análogo ao triggeredCondition do def).
		- if status == "open": resolvedBy / resolvedCondition proibidos (_|_).
		GARANTIA estrutural por cue vet: marcar resolved sem resolvedBy/resolvedCondition é
		incompleto (rejeitado); a auditabilidade de "o que resolveu" é forçada pela forma.

		(2) MATERIALIZAÇÃO (1º uso) — flip dos 2 oq do FCE em contexts/fce/canvas.cue, no
		MESMO commit:
		- oq-fce-2 → resolved, resolvedBy "contexts/fce/glossary.cue", resolvedCondition:
		  glossary de 19 termos autorado.
		- oq-fce-3 → resolved, resolvedBy "contexts/fce/agents/fce-primary-agent.cue",
		  resolvedCondition: par do agente autorado (#170) + adr-155 accepted (#171).
		As 5 refs de provenance (agent-spec ×2, domain-model ×2, adr-127) que citam estes
		oq por id permanecem válidas — o flip marca in-place, o id é intacto.

		(3) QUALITY CRITERION tq-cv-15 (severity warn) no _qualityCriteria do canvas
		(artifact-schemas/canvas.cue): resolvedCondition deve dizer O QUE resolveu — não
		"feito"/"resolvido"/vazio. Análogo a tq-def-01 (que protege deferralRationale de
		procrastinação travestida); tq-cv-15 protege resolvedCondition de resolução
		travestida. warn (não fail) porque substância é interpretativa — sinaliza sem
		bloquear, consistente com os tq-cv advisory. A divisão é deliberada: o fail é o que
		a ESTRUTURA garante (resolvedBy presente, via cue vet incomplete); o warn é o que
		exige JULGAMENTO (resolvedCondition substantivo).

		ALTERNATIVAS CONSIDERADAS:
		(a) Deferir — deixar os oq abertos. REJEITADA: o canvas afirma falso o que está
		    respondido; a lacuna persiste para todos os 77.
		(b) Remover as entries resolvidas. REJEITADA: órfã 5 refs de provenance governadas
		    e apaga a memória da pergunta — o problema que invalidou a opção na análise prévia.
		(c) Espelhar a forma EXATA do #DeferredDecision (disjunção de structs). REJEITADA:
		    quebra com o default da retrocompat ("unresolved disjunction" — testado). A
		    semântica transplanta; a forma CUE não.
		"""

	consequences: """
		Positivas.
		(P1c) O #OpenQuestion ganha FECHAMENTO auditável: uma pergunta respondida deixa de
		ter os dois destinos ruins (afirmar-falso-aberta ou remoção-que-orfana) — é marcada
		resolved in-place, com resolvedBy (quem) + resolvedCondition (o quê), preservando a
		memória da RESPOSTA, não só da pergunta.
		(P2c) A assimetria com o #DeferredDecision (irmão com lifecycle desde adr-062) é
		corrigida — os dois tipos de meta-state agora fecham.
		(P3c) Retrocompat total: os 77 oq em 14 canvas não são tocados (default "open"),
		verificado por cue vet (o gate, P1). Higiene de schema sem churn de massa.

		Negativas (limites intrínsecos).
		(N1c) Mais campos no schema compartilhado #OpenQuestion a manter (status + resolvedBy
		+ resolvedCondition) — custo aceito: o fechamento auditável é o ativo que os justifica;
		o default open contém o custo a zero para o legado.
		(N2c) O tq-cv-15 é warn, não fail: "feito"/genérico em resolvedCondition SINALIZA mas
		não bloqueia — a substância fica no julgamento humano. Aceito porque substância é
		interpretativa (estrutura garante o garantível — resolvedBy presente é fail; o resto
		é advisory).
		(N3c) O oq lifecycle (magro, if-conditional) DIVERGE da forma do def (disjunção de
		structs) — dois mecanismos de lifecycle no repo. Intencional (a natureza do fechamento
		difere; o default exige if-conditional), mas a divergência existe e o rationale a
		registra para o leitor futuro.
		"""

	falsificationCondition: {
		condition: """
			O design estará errado em um de dois lados: (falso-permissivo) um oq é marcado
			resolved sem ter sido genuinamente respondido — o lifecycle vira teatro; ou
			(falso-restritivo) a retrocompat falha — a adição quebra oq legados, e a "higiene
			sem churn" se revela ilusória.
			"""
		observableSignal: """
			(falso-permissivo) resolvedCondition vago/"feito" passando em oqs resolved — o
			tq-cv-15 (warn) sinaliza, mas warn não bloqueia, então o sinal é a recorrência de
			warns tq-cv-15 ignorados. (falso-restritivo) algum dos 77 oq legados quebrando cue
			vet após o merge — não deveria (default open, testado); se quebrar, o default não
			funcionou como previsto.
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/canvas.cue",
		"contexts/fce/canvas.cue",
	]
	plannedOutputs:   []
	derivedArtifacts: []
	defersTo:         []

	principlesApplied: [
		"P0 — localização canônica única: resolvedBy reusa #OriginRef de deferred-decision.cue (mesmo package), ponteiro não cópia; zero duplicação.",
		"P1 — schema CUE como SoT + backward-compat como gate de CI: o lifecycle entra no schema (SoT dos contratos) e a retrocompat (default open) é provada pelo cue vet (o gate), não por inspeção manual.",
	]

	rationale: """
		O lifecycle MAGRO é deliberado: o fechamento de um open-question é um ato HUMANO
		(alguém autora o artefato que a pergunta antecipava), não condição automática de
		runner — por isso o oq não herda triggered/triggers/recurrence do #DeferredDecision.
		A natureza do fechamento determina a forma: binário open→resolved.

		A forma CUE diverge do def por NECESSIDADE, não preferência: a retrocompat exige
		default "open", e a disjunção-de-structs do def quebra com default ("unresolved
		disjunction" — testado). O if-conditional dá a MESMA semântica com default funcional.
		P1 é satisfeito pelo cue vet que prova a retrocompat; P0 é honrado reusando #OriginRef.

		status accepted (não proposed): o schema E o 1º uso vão no MESMO commit — decisão
		completa e materializada atomicamente (precedente adr-132). O 1º uso valida o próprio
		tq-cv-15 (resolvedCondition dos 2 oq são substantivos).

		Tensão com axiomas: nenhuma. A mudança é additive, honra P0/P1, e a divergência de
		forma com o def é registrada (N3c), não silenciada.
		"""
}
