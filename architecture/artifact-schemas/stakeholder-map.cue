package artifact_schemas

#StakeholderMap: {
	description: string & !=""

	stakeholders: [#Stakeholder, ...#Stakeholder]

	_schema: {
		location: {
			canonicalPathRegex: "^domain/stakeholder-map\\.cue$"
			fileNameRegex:      "^stakeholder-map\\.cue$"
			description:        "Mapa de atores do ecossistema: quem são, que papel exercem, como interagem com a Mesh."
			rationale:          "Stakeholders são referência para decisões de escopo, priorização e design de interações."
			cardinality:        "singleton"
			allowNested:        false
		}
	}
}

#StakeholderType: "person" | "organization" | "system" | "agent" | "regulator"
// person:       indivíduo humano com papel direto no ecossistema
// organization: entidade jurídica (empresa, fundo, associação)
// system:       sistema técnico convencional (ERP, banco de dados, API externa)
// agent:        agente autônomo de IA que atua como operador primário (ax-01, ax-02)
// regulator:    entidade regulatória com poder normativo sobre a operação

#Stakeholder: {
	id:              string & =~"^sh-[0-9]{2}$"
	name:            string & !=""
	type:            #StakeholderType
	description:     string & !=""
	role:            string & !="" // papel funcional no ecossistema
	meshInteraction: string & !="" // como interage concretamente com a Mesh
	influence:       "high" | "medium" | "low" // poder de decisão sobre o ecossistema
	concerns: [string & !="", ...string & !=""] // preocupações/interesses primários
	interactsWith?: [...string & !=""] // IDs de outros stakeholders com relação direta
	rationale:       string & !=""
}
