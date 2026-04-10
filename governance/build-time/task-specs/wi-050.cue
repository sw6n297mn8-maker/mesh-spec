package task_specs

taskSpecs: "WI-050": {
	version:               1
	title:                 "Criar artefatos de domínio para Identity & Data Governance (IDC)"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"strategic/context-map.cue — IDC é transversal: identidade, autenticação, autorização, governança de dados e integridade criptográfica consumidos por todos os BCs",
	]
	outputs: [{
		artifact: "contexts/idc/canvas.cue"
		type:     "create"
	}, {
		artifact: "contexts/idc/glossary.cue"
		type:     "create"
	}, {
		artifact: "contexts/idc/domain-model.cue"
		type:     "create"
	}, {
		artifact: "contexts/idc/agents/idc-primary-agent.cue"
		type:     "create"
	}, {
		artifact: "contexts/idc/agents/idc-primary-agent.governance.cue"
		type:     "create"
	}]
	affects: []
	rationale: """
		Bootstrap completo do BC supporting IDC. Ordem de produção:
		canvas → glossary → domain-model → agent-spec → governance.

		Supporting domain — gestão de identidade, autenticação,
		autorização, governança de dados e integridade criptográfica
		(CAS, DSSE, Merkle proofs). Unifica identidade e primitivas
		de verificação sob único owner. Consumido como transversal
		por LOG, DLV, NPM e demais BCs.

		Criticality high — controla decisão sobre acesso e integridade.
		LGPD e KYC/AML impõem constraints invioláveis. Identidade
		incorreta compromete cadeia de custódia (LOG→DLV) e
		autorização de operações financeiras (FCE, SCF).
		"""
}
