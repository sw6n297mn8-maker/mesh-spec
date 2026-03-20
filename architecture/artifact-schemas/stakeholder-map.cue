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

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-sm-01"
			description: "Interações concretas, não genéricas"
			test:        "Cada stakeholder.meshInteraction descreve ações específicas que o ator executa na Mesh (e.g., 'submete medições via app', 'aprova antecipação no portal'). Se a descrição se aplica a qualquer plataforma financeira genérica (e.g., 'usa o sistema', 'interage com a plataforma'), está abstrata demais."
			severity:    "fail"
			rationale:   "meshInteraction alimenta decisões de design de interface e priorização de BCs. Descrições genéricas não informam essas decisões."
		}, {
			id:          "tq-sm-02"
			description: "Concerns rastreáveis a decisões de design"
			test:        "Cada concern de cada stakeholder é rastreável a pelo menos uma decisão de design, axioma ou mecanismo do sistema. Se um concern não é endereçado por nenhum artefato existente, o rationale do stakeholder deve declarar o gap explicitamente (e.g., 'concern X será endereçado quando BC Y existir'). O critério valida que gaps são explícitos, não que são zero — a ausência de rastreabilidade só é finding quando também é ausência de declaração."
			severity:    "warn"
			rationale:   "Concerns não endereçados são riscos silenciosos. Warn porque gaps legítimos existem em fases iniciais, mas devem ser visíveis."
		}]
		rationale: "Stakeholder map é entrada para priorização e design de interações. Critérios garantem que cada entrada é operacionalmente útil, não decorativa."
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
