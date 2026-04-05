package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten001: artifact_schemas.#TensionEntry & {
	id:    "ten-001"
	date:  "2026-04-03"
	title: "#DomainField não suporta optionalidade intra-value-object"

	kind:          "schema-limitation"
	tensionTarget: "architecture/artifact-schemas/domain-model.cue"
	manifestsIn:   "contexts/ctr/domain-model.cue"

	description: """
		vo-lineage no CTR domain model usa discriminador chainOrigin
		(boolean) para distinguir v1 (origem da cadeia) de v2+ (referência
		à versão anterior). O campo previousVersion só é semanticamente
		válido quando chainOrigin é false. Porém #DomainField no schema
		domain-model.cue não suporta optionalidade condicional — todos os
		fields declarados existem no shape. Resultado: previousVersion
		está presente no shape para v1, mas é semanticamente ausente
		(nulo por convenção de implementação).
		"""

	resolution: """
		Alternativa escolhida: manter os dois campos no mesmo VO com
		discriminador chainOrigin e convenção de nullability por
		implementação. Ganho: linearidade conceitual da cadeia preservada
		em um único VO, discriminador torna a distinção representável no
		shape. Alternativa rejeitada: dois VOs distintos (vo-chain-origin
		e vo-chain-continuation) — quebraria a linearidade conceitual da
		cadeia e complicaria inv-lineage-integrity, que teria de validar
		dois tipos em vez de um. Trade-off aceito: optionalidade semântica,
		não estrutural.
		"""

	status: "accepted"

	structuralResolutionPath: "Evolução de #DomainField para suportar optionalidade condicional (e.g., campo optional: boolean ou união discriminada por kind). Reavaliável quando mais VOs enfrentarem o mesmo padrão."

	rationale: "Primeiro caso concreto de tensão entre expressividade de #DomainField e necessidade de modelagem tática. Registro formaliza trade-off para que agentes de outros BCs que encontrem o mesmo padrão consultem esta decisão em vez de redescobri-la."
}
