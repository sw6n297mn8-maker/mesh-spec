package mesh_spec

subdomainCatalog: {
	subdomains: {
		"NIM": #Subdomain & {
			code:   "NIM"
			name:   "Network Integration Management"
			type:   "core"
			status: "active"

			definition: "Gestão de integrações de rede."
			purpose:    "Centralizar integrações com parceiros externos."

			strategicLayer: "L2"
			graphRole:      "gateway"

			strategicProfile: {
				volatility:       "moderate"
				complexity:       "complicated"
				differentiation:  "high"
				volatilityDriver: "Mudanças em parceiros e protocolos."
			}

			mechanismRefs:    ["mech-network-integration"]
			moatTypes:        ["ecosystem"]
			businessOutcomes: ["integrated-execution"]

			// Mesmo BC que ECL para disparar ff-sd-02
			boundedContexts: [{
				ref:       "economic-commitment-lifecycle"
				formality: "formal"
			}]
		}
	}
}
