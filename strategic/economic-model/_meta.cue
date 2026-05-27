package economic_model

meta: "strategic/economic-model": {
	canonicalPath: "strategic/economic-model"
	purpose:       "Layer -1 (Economic Reality, ri-*) + Layer 1 (Economic Mechanisms, mech-*): foundation econômica (adr-082/083). Layer -1 declara realidades adversariais; Layer 1, mecanismos que reduzem exploitability."
	conventions: [
		"Singleton instances: mesh-economic-assumptions.cue (Layer -1) + mesh-economic-mechanisms.cue (Layer 1).",
		"Prefix discipline Layer -1: ri-* reality invariants (DISTINCT de inv-* domain invariants); cap-adv-* capabilities; imp-* implications.",
		"Prefix discipline Layer 1: mech-* economic mechanisms (DISTINCT de mech-* subdomain mechanisms via #EconomicMechanismRef alias); rr-* residual risks.",
		"Reality invariants são propriedades do mundo NÃO tensionáveis (sistema sobrevive apesar de). Economic mechanisms reduzem exploitability — não eliminate, não solve.",
		"Honesty enforcement: cada mechanism MUST declare failure surface (falsePositiveRisks OR underspecifications OR residualRisks) per tq-emm-03 — hidden risk inválido por discipline.",
	]
	rationale: "2 layers canonicamente declarados: 'truths that constrain design but are not design decisions' (Layer -1 ri-*) + 'mechanisms reduce exploitability' (Layer 1 mech-*). Layer 1 protege Layer -1 realities. v1 sistema observa fraude → v2 sistema desincentiva fraude. Mechanism layer aguarda NIM bootstrap para Phase B cross-cutting refs + structural enforcement."
}
