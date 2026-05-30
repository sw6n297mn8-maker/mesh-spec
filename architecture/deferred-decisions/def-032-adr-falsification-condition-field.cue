package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def032: artifact_schemas.#DeferredDecision & {
	id:     "def-032"
	title:  "Campo falsificationCondition no #ADR — hipótese falsificável por decisão (Camada 2 de feedback de médio prazo)"
	date:   "2026-05-30"
	status: "open"

	description: """
		Adicionar o campo falsificationCondition ao schema #ADR: o critério
		OBSERVÁVEL que tornaria a decisão errada no futuro — transformando cada
		ADR (em especial os de derivação de BC) num teste de hipótese com
		condição de falsificação explícita, revisitável sem reabrir tudo. Mais
		um structural-check exigindo o campo preenchido para decisionClass
		structural (faseado: opcional no rollout, depois obrigatório). É
		distinto de defersTo (aponta deferimento, não falsificação), de
		reversibility (custo de reverter, não gatilho que invalida) e de
		supersededBy (sucessão, não condição). Hoje o #ADR não tem onde
		registrar 'esta decisão estará errada SE X' — o campo fecha o ciclo de
		feedback de médio prazo que a auditoria de ciclos identificou como
		ausente.
		"""

	deferralRationale: """
		HORIZONTE DE RESOLUÇÃO: IMINENTE — PR-#1, o próximo PR da sequência de
		feedback-cycles. A decisão de fazer este campo já foi tomada na
		auditoria com o founder; este DD registra o gap por completude e
		rastreabilidade, NÃO por incerteza sobre fazer. O trigger primário
		manual-review reflete que a revisita é iminente e founder-conduzida, não
		condicionada a um sinal automático distante. O backstop recurrence
		(5º ADR derive-*) é REDE DE SEGURANÇA contra esquecimento, NÃO o
		horizonte esperado de resolução.

		MOTIVO de não materializar AGORA (neste PR de registro de gaps): manter
		o PR de registro leve e de classe única (4 DDs); a evolução do schema
		#ADR + structural-check + migração dos ADRs existentes (127/129/131
		ganham o campo) é mudança semântica que merece seu próprio PR-#1 focado,
		imediatamente subsequente. Custo evitado: misturar registro leve com
		evolução de schema base. Custo de continuar além do PR-#1: cada nova
		derivação nasce sem hipótese falsificável — perde-se o feedback de
		médio prazo justamente nos ADRs que mais se beneficiam (derivação de
		fronteira).
		"""

	triggerCalibrationRationale: """
		Trigger primário manual-review: a evolução do schema base #ADR é
		decisão founder-only de alto blast radius (afeta todos os ADRs
		futuros), e a revisita é IMINENTE e já agendada (PR-#1) — não há sinal
		automático que represente melhor 'fazer no próximo PR' do que o
		compromisso explícito do founder. Backstop recurrence filename
		threshold 5 contando ADRs derive-*-bounded-context: hoje N=3 (fce/drc/
		scf); dispara no 5º caso a resolução iminente escape — alinhado ao
		horizonte N≥4-5 de def-029. tq-def-03 (preferência por trigger
		non-manual-review) satisfeito pelo backstop recurrence.
		"""

	originatingArtifacts: [
		"session:feedback-cycles-audit",
		"architecture/artifact-schemas/adr.cue",
	]

	costOfDeferral: {
		severity:    "high"
		blastRadius: "repo-wide"
		description: """
			Sem falsificationCondition, ADRs registram a decisão mas não a
			condição que a invalida — não há ciclo de feedback de médio prazo
			sobre se a modelagem ainda está certa. repo-wide porque o campo é do
			schema base #ADR (afeta todo ADR presente e futuro). high porque é
			barato de adicionar e destrava tanto a revisita disciplinada quanto
			a métrica 2 do painel (def-034).
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: """
			Evolução do schema base #ADR é decisão founder-only; revisita
			iminente já agendada para o PR-#1 imediatamente subsequente à
			auditoria de ciclos de feedback. Manual-only é apropriado porque o
			horizonte é compromisso explícito, não sinal emergente.
			"""
	}, {
		kind:      "recurrence"
		pattern:   "architecture/adrs/adr-[0-9]+-derive-[a-z0-9-]+-bounded-context\\.cue$"
		scope:     "filename"
		threshold: 5
	}]
}
