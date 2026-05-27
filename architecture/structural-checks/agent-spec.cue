package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// agent-spec.cue — Integridade referencial cross-file dos agent-specs
// (adr-113, kind instance-scoped-cross-file-id-exists). Cada agent opera sobre
// o domain-model do SEU PRÓPRIO BoundedContext (boundedContextRef); todo
// building block referenciado em operationalScope/actions[].domainModelRefs
// deve existir como code no domain-model daquele BC — escopo least-privilege
// (tq-ag-01/tq-ag-02). Born-green; promovido a reject (adr-114). (verificado: 309 refs nos 12
// agentes, 0 não-resolvidas). Resolve def-002 para agent-spec: a premissa de
// risco de vocabulário/materialização (como events/def-019) NÃO se aplica —
// são codes internos (agg-/cmd-/evt-/inv-/prj-/vo-/ent-/svc-/mod-/pol-/qry-)
// no domain-model próprio e completo do BC, não nomes canônicos cross-BC.

structuralChecks: {
	"sc-ag-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-ag-01"
		title:        "Refs de domain model do agent existem no domain-model do seu BC"
		artifactType: "agent-spec"
		description:  "Todo building block referenciado pelo agent (operationalScope.{aggregates,commands,events,invariants,projections} e actions[].domainModelRefs) existe como code no contexts/{boundedContextRef}/domain-model.cue do PRÓPRIO BC. Escopo per-instância (least-privilege): a ref tem de resolver no domain-model do BC do agente, não na união global. cue vet valida o formato do ref (prefixo), não a existência cross-file no BC."
		kind:         "instance-scoped-cross-file-id-exists"
		rule: {
			referencePaths: [
				"operationalScope.aggregates[]",
				"operationalScope.commands[]",
				"operationalScope.events[]",
				"operationalScope.invariants[]",
				"operationalScope.projections[]",
				"actions[].domainModelRefs[]",
			]
			scopeField:         "boundedContextRef"
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths: [
				"aggregates[].code",
				"aggregates[].entities[].code",
				"commands[].code",
				"domainServices[].code",
				"events[].code",
				"invariants[].code",
				"modules[].code",
				"policies[].code",
				"projections[].code",
				"projections[].queryCapabilities[].code",
				"valueObjects[].code",
			]
		}
		errorMessage: "agent-spec: ref de domain model '{ref}' não existe no domain-model do BC '{scope}' (contexts/{scope}/domain-model.cue). Corrija o ref, declare o building block no domain-model, ou ajuste o boundedContextRef do agente."
		rationale:    "adr-113: o agent declara responsabilidade sobre building blocks do seu BC (tq-ag-01/tq-ag-02 least-privilege); um ref a um building block inexistente no domain-model do próprio BC é responsabilidade fantasma ou vazamento cross-BC. Escopo per-instância (não união global) impõe que a ref pertença ao BC do agente — distinto do cross-file-id-exists global."
		enforcement: "reject"
	}
}
