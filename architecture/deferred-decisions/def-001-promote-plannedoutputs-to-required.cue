package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-001": artifact_schemas.#DeferredDecision & {
	id:    "def-001"
	title: "Promote plannedOutputs from optional to required em #ADR schema (C3 Part 4)"
	date:  "2026-05-03"

	description: """
		Promover field plannedOutputs de optional para required (allowing
		empty list []) no schema #ADR; backfill de 22 ADRs sem o field
		(15 do range Part 3 unchanged + 7 do range Part 2 unchanged); ADR
		final closure da série C3.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-059-add-planned-outputs-optional-field-to-adr.cue",
		"session:resume-mesh-work-jv2mc",
	]

	deferralRationale: """
		Sessão 2026-05-03 (claude/resume-mesh-work-jv2MC) propôs Part 4
		ao founder. Founder rejeitou: tornar plannedOutputs required (mas
		permitindo []) aumenta ceremony sem garantir traceability — ADR
		pode ter affectedArtifacts: [], plannedOutputs: [], derivedArtifacts:
		[] e ainda passar shape. Custo (52 arquivos: 22 backfills + 27
		SRRs + schema + PG + ADR final) NÃO justifica enforcement parcial.
		Founder explicit: "Eu só faria Part 4 junto com (1) constraint real
		'at least one path across affected/planned/derived'; ou (2)
		structural-check específico para ADR traceability." Sem isso, a
		promoção é cerimônia que não fecha o gap real.
		Trade-off escolhido na sessão: pausar Part 4 e construir máquina
		automática de cobrança de dívida (adr-062 + def-001 + commit 2)
		ANTES de revisitar a decisão. Custo evitado: cerimônia sem
		enforcement. Custo de continuar deferindo: drift baixo enquanto
		regime atual estabiliza.
		
		RE-DEFERIMENTO (2026-07-03, janela de housekeeping — decisão do
		founder; triggers adjacent-need fired warn-only há 61d): mantido
		deferido COM a nota explícita de custo — promover plannedOutputs a
		required QUEBRA os ADRs antigos que não carregam o campo; a
		resolução exige BACKFILL da base de ADRs, não é mudança de 1 linha
		no schema. Revisitar quando uma janela de backfill for aberta por
		decisão do founder.

		AMENDMENT (2026-07-03, migração adr-166 — decisão do founder): os
		2 triggers adjacent-need foram REMOVIDOS como EXAURIDOS — a
		condição que vigiavam tornou-se permanentemente verdadeira desde
		adr-076 (sc-adr-01 existe; adr.cue menciona os tokens em prosa de
		quality-criteria): o sensor virou alarme perpétuo, e com o fix do
		gate multi-trigger (adr-166 item 4) o file-exists além da carência
		passaria a travar o CI por um deferimento que o founder JÁ
		re-deferiu conscientemente acima. O que resta vigiar não tem
		condição detectável: é decisão de PRIORIDADE do founder (abrir a
		janela de backfill) — manual-review é a forma final.
		"""

	triggerCalibrationRationale: """
		Os 2 triggers refletem exatamente as 2 condições articuladas pelo
		founder na decisão de pausa. Trigger 1 usa adjacent-need.file-
		contains com pattern '(at-least-one|MinItems\\(1\\)|disjunction)'
		— captura 3 formas plausíveis de constraint at-least-one ser
		expressa no schema (CUE disjunction explícita, list.MinItems, ou
		comment 'at-least-one' que sinalizaria intenção). Pattern
		conservador: false-positive risk baixo (nenhum desses tokens
		aparece em adr.cue atualmente; matching futuro só com edição
		semântica). Trigger 2 é file-exists puro sobre architecture/
		structural-checks/adr.cue — existência do arquivo indica que ADR
		traceability tem structural-check (independente de qual rule
		exato). Ambos triggers são adjacent-need (machine-evaluable);
		nenhum manual-review necessário porque condições são claras.
		Threshold N/A para adjacent-need.
		"""

	costOfDeferral: {
		severity: "low"
		blastRadius: "local"
		description: """
			ADRs novas continuam usando plannedOutputs por convenção
			voluntária — adr-059..062 todos aplicaram. Drift baixo enquanto
			regime atual estabilizar; nenhum BC ou sistema externo afetado.
			Single-artifact escope (adr.cue schema + 22 ADRs antigas).
			"""
	}

	// AMENDMENT 2026-07-03 (migração adr-166, decisão do founder): os 2
	// adjacent-need foram REMOVIDOS como EXAURIDOS — condição permanentemente
	// verdadeira desde adr-076; sensor virou alarme perpétuo (ver
	// deferralRationale). manual-review é a forma final.
	triggers: [{
		kind:   "manual-review"
		reason: "Forma FINAL per amendment 2026-07-03 (adr-166): as 2 condições que os triggers vigiavam JÁ aconteceram (sc-adr-01 existe; constraint at-least-one expressa via structural-check) e o founder re-deferiu mesmo assim pelo custo de backfill — o que resta não tem condição detectável: é decisão de PRIORIDADE do founder abrir a janela de backfill da base de ADRs. Founder revisita quando decidir abrir essa janela."
	}]

	status: "open"
}
