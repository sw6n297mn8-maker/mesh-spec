package build_time

// session-log-adr-151.cue — Meta-aprendizados de processo da campanha adr-151
// (rastreabilidade semântica first-class). Registro V1-simples no schemaExemptZone
// governance/build-time/ — precedente subagent-execution-log/worklist ("V1 simples sem
// schema quando o volume não justifica; formalizar como tipo só quando recorrência
// justifique"). NÃO é tipo governado: sem schema, sem ADR, sem SRR.
//
// Propósito: reuso em frentes futuras (scaffold de novo BC; backfill/flip de outros
// gates). Cada learning carrega lição + evidência + aplicabilidade.

sessionLogAdr151: {
	campaign: "adr-151 — first-class semantic traceability"
	date:     "2026-06-17"
	arc:      "schema delta (3a/3b) + gate adr-153 (born-warn) + 4 ondas de backfill (cmt/dlv/fce/rew) + flip warn->reject + varredura de coerência + boundary-fix"

	learnings: [{
		id:            "ln-01"
		title:         "Source-anchoring antes da aprovação"
		lesson:        "Quando o lote contém afirmações sobre o domínio (definições, invariantes), a proposta JÁ cita a linha-fonte de cada uma — a verificação definição-vs-fonte é parte da proposta, não passo posterior."
		evidence:      "fce pegou 2 erros pós-proposta (as 3 condições do PrePaymentGuard = fatura-válida + elegibilidade-de-risco + cadeia-de-evidência-íntegra per inv-money-moves-only-on-proof, NÃO 'orçamento' [deferido]; materialize cria-em-guarded, não aciona-o-guard). rew nasceu source-anchored e saiu limpa. A varredura final dos 33 termos confirmou: fce (pré-disciplina) concentrou os deslizes; rew (madura) limpo."
		applicability: "Qualquer authoring com afirmações de domínio: scaffold de BC, schema, ADR, glossário."
	}, {
		id:            "ln-02"
		title:         "SRR qualificado por evento (append-only)"
		lesson:        "Nome <artefato>-<evento>.self-review.cue quando o artefato pode ter SRR prévio. 1 SRR por evento, nunca mutado. A pré-leitura checa a existência de SRR de authoring ANTES de nomear."
		evidence:      "cmt assumiu nome livre (ok — sem SRR prévio). dlv colidiu com o SRR de authoring de maio (dlv-glossary.self-review.cue): o Write guard barrou o clobber -> resolvido com dlv-glossary-firstclass-backfill. fce/rew/flip/boundary-fix já nasceram qualificados."
		applicability: "Qualquer re-edição de artefato governado que possa ter SRR prévio."
	}, {
		id:            "ln-03"
		title:         "Gate auto-demonstrado no flip para blocking"
		lesson:        "Todo flip de gate determinístico para blocking inclui a demonstração end-to-end: quebra um caso -> confirma que barra (exit não-zero) -> reverte -> verde. Report-vazio só prova 'nada a barrar hoje', NÃO 'o gate barra quando deve'."
		evidence:      "O flip do sc-fct-01 (warn->reject) quebrou agg-commitment->firstClass:false e confirmou runner exit 1 / 2 bloqueante (FILA + G4), depois reverteu -> exit 0. Precedente: derived-drift-gate (adr-152)."
		applicability: "Qualquer promoção de structural-check de warn para reject."
	}, {
		id:            "ln-04"
		title:         "Reason específico > guarda-chuva"
		lesson:        "O reason descreve o que o conceito É, não como é consumido nem que tipo de operação é. Específico quando a razão é específica; guarda-chuva (cross-artifact-contract, ou reason-do-domínio) só quando não há mais específico. TESTE governance-vs-domínio: intervenção-de-supervisão = governance; parte-do-ciclo-de-vida-normal = reason-do-domínio."
		evidence:      "counterparty-risk->risk (cmt). evaluate-verification->qualification, não delivery (dlv). authorize-payment=financial, não compliance (guard = integridade econômica, não conformidade regulatória) (fce). emit=risk não eligibility (eligibility é campo); supersede/stale=risk não governance (ciclo de vida, não supervisão) (rew). Contraste: exceção-dlv=governance (supervisão humana) vs supersede/stale-rew=risk (ciclo normal)."
		applicability: "Classificação de firstClassReason (Forma A) em BC novo ou backfill."
	}]

	campaignInNumbers: {
		prs:              "#155-#163 (9 PRs: 3a + 3b + adr-153 + 4 ondas + flip + boundary-fix)"
		crossContract:    48
		bcs:              "cmt 20 + dlv 11 + fce 8 + rew 9"
		newGlossaryTerms: 33 // cmt 6 + dlv 10 + fce 8 + rew 9
		coherenceSweep:   "33 verificados term-vs-fonte: 31 limpos + 2 corrigidos (dispatch do fce, rail->BKR)"
		gate:             "sc-fct-01 promovido a reject e auto-demonstrado; worklist zerada"
	}
}
