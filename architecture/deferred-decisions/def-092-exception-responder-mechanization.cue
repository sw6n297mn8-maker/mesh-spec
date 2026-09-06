package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def092: artifact_schemas.#DeferredDecision & {
	id:     "def-092"
	title:  "Mecanização da obrigação 'toda exceção declarada nomeia quem responde' (adr-197 dec 4)"
	date:   "2026-09-06"
	status: "open"

	description: """
		A obrigação do adr-197 é lei na main; sua MECANIZAÇÃO foi
		encomendada pela decisão (4) do próprio ADR como fatia própria e
		ficou sem morada — promessa interna ao texto. Fica deferido
		exatamente o que a decisão (4) encomendou: extensão de schema
		(tipar #EscalationRoute.recipient e o decider da supervisedDecision
		sob o vocabulário de ator do adr-182 + a forma placeholder marcada,
		visível e contável) + structural check novo nascendo born-warn per
		adr-097, com critério de promoção declarado no ADR: promove a
		reject quando o retrofit das rotas existentes estiver completo e o
		dd-gate de placeholders estiver reportando. Até a fatia, vigora a
		postura transitória da decisão (5): aparições atuais permanecem
		terminais pendentes declarados.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a decisão (4) do adr-197 deliberadamente
		separou a obrigação (lei imediata, por marcas declaradas) da
		mecanização (fatia própria) — acoplar as duas forçaria retrofit
		repo-wide das rotas existentes no mesmo commit da lei, o custo que
		o ADR explicitamente evitou. Custo evitado: retrofit big-bang +
		desenho do check antes da forma placeholder ter instâncias para
		contar. Custo de continuar deferindo: a obrigação vale por
		disciplina de leitura, não por tipo — placeholder Phase 0 segue
		indistinguível de destinatário real até o schema tipar a forma, e
		a falsificação do adr-197 (contagem de placeholders
		não-decrescente em 3 fatias) não tem instrumento que a meça. Este
		def é a morada da pendência que o texto do ADR declarou; o
		defersTo do adr-197 aponta para cá.
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito): a forma literal do placeholder
		— que um trigger de conteúdo contaria — só nasce NA fatia de
		mecanização (extensão de schema); antes dela, qualquer predicado
		cravaria a grafia de um tipo não-desenhado. A âncora de revisita
		está no ponto de uso: o defersTo do adr-197 (mesmo desenho do
		def-079, ancorado no rationale do amount).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-197-exception-declares-responder.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			medium porque a obrigação já vale como lei e a forma placeholder
			está DECLARADA (dívida visível, não silêncio) — o que falta é o
			dente determinístico; cross-cutting espelhando o blastRadius do
			próprio adr-197: a obrigação incide sobre toda #EscalationRoute
			e toda supervisedDecision, em múltiplos BCs. Exit: a fatia de
			mecanização (schema + check born-warn + retrofit + dd-gate de
			placeholders), com promoção a reject pelo critério do ADR.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "A forma literal do placeholder que um predicado contaria só nasce na própria fatia de mecanização — antes dela, trigger de conteúdo cravaria grafia de tipo não-desenhado e trigger de existência cravaria path de fatia futura; a revisita fica ancorada no ponto de uso via defersTo do adr-197."
	}]
}
