package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten002: artifact_schemas.#TensionEntry & {
	id:    "ten-002"
	date:  "2026-04-07"
	title: "IDC usa gateway/operational-enabler para papel conceitual de authority"

	kind:          "schema-limitation"
	tensionTarget: "architecture/artifact-schemas/canvas.cue"
	manifestsIn:   "contexts/idc/canvas.cue"

	description: """
		IDC é conceptualmente a autoridade sobre identidade e
		integridade criptográfica da Mesh — define e enforça
		padrões que consumers adotam como conformist. O schema
		#Canvas oferece businessRole enum (revenue-generator,
		engagement-creator, compliance-enforcer, operational-enabler)
		e #Archetype enum (analysis, draft, execution, gateway,
		specification, engagement), nenhum dos quais captura
		"authority" ou "trust-root". Canvas usa gateway como
		archetype primário e operational-enabler como businessRole
		— os mais próximos semanticamente, mas nenhum captura
		completamente o papel de IDC como fonte de verdade sobre
		verificação de identidade e integridade.
		"""

	resolution: """
		Alternativa escolhida: usar gateway (archetype) e
		operational-enabler (businessRole) com tensão documentada.
		Gateway captura o aspecto de controle de acesso — IDC é
		ponto de passagem obrigatório para confiança. Operational-enabler
		captura o aspecto de habilitação — sem IDC, BCs não operam
		com confiança verificável. Alternativa rejeitada: estender
		o enum agora — prematura com apenas um caso. Se o padrão
		se repetir em outros BCs de infraestrutura de confiança,
		considerar extensão do enum via ADR dedicado.
		"""

	status: "accepted"

	structuralResolutionPath: "Extensão de #Archetype para incluir 'authority' e/ou extensão de businessRole para incluir 'trust-provider'. Reavaliável quando segundo BC de infraestrutura de confiança enfrentar o mesmo gap."

	rationale: "Tensão registrada porque a limitação afeta a legibilidade do canvas — leitores podem interpretar 'gateway' como roteador e 'operational-enabler' como utilitário, quando IDC é conceitualmente mais forte que ambos. Registro previne que futuros agentes interpretem o archetype literalmente."
}
