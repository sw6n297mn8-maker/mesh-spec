package mesh_spec

subdomainCatalog: {
	subdomains: {
		"ECL": #Subdomain & {
			code:   "ECL"
			name:   "Economic Commitment Lifecycle"
			type:   "core"
			status: "active"

			definition: "Owner canônico do compromisso econômico."
			purpose:    "Separar formalização e evolução do compromisso econômico."

			strategicLayer: "L2"
			graphRole:      "hub"

			strategicProfile: {
				volatility:       "high"
				complexity:       "complex"
				differentiation:  "high"
				volatilityDriver: "Mudanças contratuais e efeitos downstream."
			}

			mechanismRefs:    ["mech-economic-commitment"]
			moatTypes:        ["data", "ecosystem"]
			businessOutcomes: ["integrated-execution", "cheaper-credit"]

			boundedContexts: [{
				ref:       "economic-commitment-lifecycle"
				formality: "formal"
			}]
		}
	}
}
