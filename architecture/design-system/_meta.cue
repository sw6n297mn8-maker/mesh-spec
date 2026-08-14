package design_system

meta: "architecture/design-system": {
	canonicalPath: "architecture/design-system"
	purpose:       "Constituição do Design System Mesh: a lei da expressão — identidade, camadas, contrato de tokens e regime de mudança (adr-194)."
	conventions: [
		"Instância única composta por merge de structs CUE: constitution.cue + canonical-cases.cue + token-contract.cue compõem UM designSystemConstitution.",
		"Camadas congeladas: emenda exige ADR apontando o elo superior mudado (cláusula IX); token calibratable recalibra por commit no frontend-runtime dentro da moldura; token constitution-bound exige emenda.",
		"Casos canônicos novos são candidatos — nunca entram sem decisão do founder.",
		"Preservação é lei: o texto promulgado pelo founder não é resumido, parafraseado nem 'melhorado'.",
	]
	rationale: "A lei da expressão vive no spec (autoridade semântica); os valores promulgados vivem no mesh-frontend-runtime sob o token-contract — separação declarada em adr-194."
}
