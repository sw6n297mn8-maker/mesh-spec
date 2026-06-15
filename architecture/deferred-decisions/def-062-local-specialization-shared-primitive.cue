package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// def-062 -- Defere a Forma B.2 (especialização local de primitivo
// compartilhado: campos specializes/localConstraint) do adr-151. Originado da
// sessão de pilotos first-class: a varredura achou n=1 forma de narrowing
// (bkr/vo-settlement-value, Money excluindo zero); a regra de corte é formas
// distintas, não cabeças, então 1 forma não justifica a maquinaria.

def062: artifact_schemas.#DeferredDecision & {
	id:     "def-062"
	title:  "Especialização local de primitivo compartilhado (Forma B.2) — campos specializes/localConstraint"
	date:   "2026-06-15"
	status: "open"

	description: """
		Defere a adoção dos campos specializes + localConstraint que
		distinguiriam, no domain-model, uma especialização local LEGÍTIMA de um
		primitivo compartilhado (um VO que re-declara o primitivo com narrowing
		de tipo próprio) de um masquerade ilegítimo. O adr-151 estabelece
		firstClass Formas A (owned) e B (shared), mas NÃO adota a Forma B.2 — só
		o caso conhecido (bkr/vo-settlement-value, que narrowa #Money excluindo
		zero, amount > 0) existe hoje.
		"""

	deferralRationale: """
		Adotar specializes/localConstraint agora é over-engineering sobre n=1:
		existe exatamente UMA forma de narrowing no repositório
		(bkr/vo-settlement-value, exclui-zero). A regra de corte é formas
		DISTINTAS de narrowing, não número de cabeças — duas especializações da
		mesma forma não justificam a maquinaria; uma 2ª forma distinta (currency
		fixa, enum restrito) justifica. Construir o mecanismo de distinção
		especialização-legítima-vs-masquerade sobre um único exemplar produz
		abstração prematura que a 2ª instância provavelmente invalidaria. Custo
		evitado: complexidade de schema + gate para um padrão de 1 forma. Custo
		de continuar deferindo: baixo — o caso bkr já é coberto pela Forma B, com
		o mismatch de coreNoun encaminhado à fila de revisão obrigatória.
		"""

	triggerCalibrationRationale: """
		Ambos os gatilhos são manual-review por necessidade, não preguiça. A
		condição-massa é ≥2 formas DISTINTAS de narrowing — e um trigger de
		recurrence contaria CABEÇAS (arquivos com o mesmo padrão), disparando
		numa 2ª ocorrência da MESMA forma (ex.: dois VOs exclui-zero),
		exatamente o que a regra de corte exclui. Recurrence aqui não é só
		impreciso: é incorreto. Distinguir forma-distinta de forma-repetida, e
		narrowing genuíno de restatement redundante (p2p amount>=0) / regra de
		agregado (bdg currency-uniforme), é semântico — a classe que o non-goal
		do adr-151 declara indecidível por gate (P10). A condição-risco
		(masquerade nome+shape) é o próprio limite 4e, indetectável por
		construção. Logo manual-review é a escolha CORRETA, não a fraca.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-151-first-class-semantic-traceability.cue",
		"session:first-class-traceability-pilots",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			Enquanto deferido, uma especialização local (como bkr) é
			representada pela Forma B com coreNoun DIVERGENTE — e por ser
			divergente o mismatch dispara e vai à fila de revisão; falta apenas o
			campo dedicado que tornaria a legitimidade declarável. (O gatilho-risco
			abaixo é manual-review por motivo distinto: o masquerade de nome
			IDÊNTICO não gera mismatch, logo nenhum flag estrutural o expõe — só
			revisão humana periódica.)
			Cobertura existe via revisão; o que falta é precisão de tipo. A
			revisita ancora em MECANISMOS VIVOS, não na memória: a condição-massa
			(2ª forma distinta) é DETECTÁVEL pela varredura periódica de
			value-objects que já rodou (a detecção de candidatos é re-rodável; só
			o CORTE de forma-distinta é manual/P10), e a condição-risco
			(masquerade) é EXPOSTA pela fila de revisão obrigatória. Por isso este
			deferimento não caduca em silêncio como os rationales stale que o
			adr-151 corrige — o gatilho tem âncora operacional, não só intenção.
			"""
	}

	triggers: [
		{
			kind: "manual-review"
			reason: """
				Gatilho-massa: revisar quando uma 2ª forma DISTINTA de narrowing
				de primitivo compartilhado for detectada (≠ exclui-zero do bkr) —
				então a Forma B.2 ganha massa de 2 formas e
				specializes/localConstraint volta à mesa via ADR. A detecção de
				candidatos re-roda a varredura de value-objects; o corte
				forma-distinta-vs-repetida é semântico (P10).
				"""
		},
		{
			kind: "manual-review"
			reason: """
				Gatilho-risco: revisar com urgência quando o 1º masquerade
				(conceito idêntico a um primitivo shared em nome E shape, mas
				semanticamente distinto) for reportado pela fila de revisão
				obrigatória — o limite 4e do adr-151, indetectável por gate por
				construção. Um masquerade não-pego cria elo rastreável falso.
				"""
		},
	]
}
