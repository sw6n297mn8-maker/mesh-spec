package task_specs

taskSpecs: "WI-040": {
	version:               1
	title:                 "Avaliar necessidade de Policy Registry como subdomínio supporting"
	templateRef:           "tmpl-validate-artifact@v1"
	semanticPrerequisites: [
		"Catálogo de subdomínios expandido (WI-037)",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-policy-registry-decision.cue"
		type:     "create"
	}]
	affects: [
		"architecture/artifact-schemas/domain-model.cue",
		"architecture/artifact-schemas/agent-governance.cue",
		"architecture/artifact-schemas/cross-context-flow.cue",
		"strategic/subdomains/",
	]
	rationale: """
		Problema: a arquitetura atual distribui políticas em 4 camadas
		desconectadas — #Policy no domain model (por BC), #AgentGovernanceEnvelope
		(por agente), policyRefs em cross-context-flows e quality gates no
		build-time — sem mecanismo formalizado e governado de registro,
		versionamento e avaliação cross-BC, com garantias explícitas de
		enforcement, consistência e auditabilidade.

		Gaps críticos identificados:
		1. Avaliação cross-BC: políticas que dependem de estado de múltiplos
		   BCs (ex: limite de exposição que cruza SCF+REW+CMT) não têm ponto
		   de avaliação definido. Cada BC só enxerga seu próprio estado.
		2. Enforcement regulatório: políticas mandatórias (Bacen, LGPD, KYC/AML)
		   — invioláveis por conflictResolution L1 — não têm garantia de
		   enforcement consistente. Compliance advisory não é suficiente
		   para obrigações regulatórias.
		3. Versionamento de políticas: sem lifecycle unificado, políticas
		   podem divergir entre BCs ou ficar stale sem detecção.
		4. Consistência de dados: políticas financeiras que dependem de
		   projeções eventually consistent podem tomar decisões sobre
		   estado desatualizado.

		Trade-off central da decisão:
		- Centralização (PLR) melhora consistência, auditabilidade e
		  governança, mas introduz risco de acoplamento sistêmico e
		  dependência indireta entre BCs.
		- Distribuição (estado atual) preserva autonomia dos BCs, mas
		  aumenta risco de drift, inconsistência e enforcement desigual.
		A decisão deve balancear governança vs autonomia, considerando
		criticidade regulatória e estágio evolutivo do sistema.

		Decisão a tomar: (a) criar subdomínio PLR (Policy Registry) como
		supporting, com registro centralizado + enforcement distribuído;
		(b) resolver os gaps com extensões dos mecanismos existentes; ou
		(c) aceitar os gaps como risco gerenciável no estágio atual.
		Output é ADR documentando a decisão e justificativa.
		"""
}
