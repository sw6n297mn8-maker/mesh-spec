package task_specs

taskSpecs: "WI-142": {
	version:     1
	title:       "Avaliar promoção de gates de qualidade de artefatos de decisão (ADR/DeferredDecision) de warn/disciplina para gate determinístico"
	templateRef: "tmpl-validate-artifact@v1"
	semanticPrerequisites: [
		"adr-040 (separação categórica gate determinístico vs advisory; P10) vigente",
		"framework de structural-checks + runner (adr-090/096/097, enforcement por-check warn|reject) vigente",
		"governance/build-time/quality-gate.cue + scripts/ci/check-self-review.sh vigentes",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-decision-quality-gate-promotion.cue"
		type:     "create"
	}]
	affects: [
		"architecture/structural-checks/adr.cue",
		"architecture/structural-checks/deferred-decision.cue",
		"architecture/artifact-schemas/structural-check.cue",
		"governance/build-time/quality-gate.cue",
		".github/workflows/validate.yml",
	]
	rationale: """
		Avaliar quais dimensões de qualidade de ADR/DeferredDecision devem subir de
		warn/disciplina para GATE determinístico, ao nível de qualidade que o founder
		exige do repo.

		LACUNA (mapa de enforcement): só cue vet (forma) e check-self-review.sh (SRR
		existe) bloqueiam. tq-adr-01/02/03 vivem no _qualityCriteria do schema #ADR mas
		NÃO são executados por máquina; sc-adr-01 (materializa tq-adr-04, at-least-one-
		block) é warn — não bloqueia (enforcement default do runner); structural-checks/
		deferred-decision.cue é placeholder vazio (sc-def-01/02/03 deferidos). Um ADR/DD
		de baixa qualidade de conteúdo passa o CI.

		FRONTEIRA P10 (adr-040): só o que é machine-decidable pode virar gate. Promovível:
		existência de paths via kind filesystem-path-exists (já presente no runner) para
		affectedArtifacts/plannedOutputs do #ADR e originatingArtifacts/resolvedBy do
		#DeferredDecision; promoção de sc-adr-01 de warn para reject; materialização de
		sc-def-01/02/03. NÃO promovível (permanece advisory por construção): genuinidade
		de alternativas (tq-adr-01), honestidade da metadata de risco (tq-adr-02) — usar
		LLM como gate viola P10.

		TRADE-OFF central: mais gates determinísticos = menos drift de qualidade + menos
		dependência de founder review, MAS risco de fricção/falsos-positivos e de gates
		cerimoniais que o agente 'passa' sem substância.

		DECISÃO (output ADR): (a) promover o subconjunto machine-decidable a reject;
		(b) reforçar só a camada advisory (validation-prompts + self-review) sem novos
		gates; ou (c) aceitar o gap como risco gerenciável (founder review é o gate). O ADR
		escolhe e justifica, com a fronteira determinístico/interpretativo explícita.
		"""
}
