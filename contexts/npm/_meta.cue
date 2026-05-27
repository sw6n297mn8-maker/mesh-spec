package npm

meta: "contexts/npm": {
	canonicalPath: "contexts/npm"
	purpose:       "Bounded Context Network Participant Management: cadastro e lifecycle de participantes da rede Mesh."
	conventions: [
		"Participante é entidade cross-BC; idc governa identidade, npm governa papel na rede.",
		"Onboarding e offboarding são workflows próprios deste BC.",
	]
	rationale: "Separar participante como entidade da rede do seu registro de identidade permite lifecycle de network-membership sem misturar com governança de dados pessoais."
}
