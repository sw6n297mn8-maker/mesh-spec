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
		description:  "Todo building block referenciado pelo agent (operationalScope.{aggregates,commands,events,invariants,projections,domainServices}, actions[].domainModelRefs E scopeExclusions[].{ref,refs[]}) existe como code no contexts/{boundedContextRef}/domain-model.cue do PRÓPRIO BC. Escopo per-instância (least-privilege): a ref tem de resolver no domain-model do BC do agente, não na união global. cue vet valida o formato do ref (prefixo), não a existência cross-file no BC. domainServices e os paths de scopeExclusions incluídos com o adr-175 — exclusão dangling (typo ou building block removido) é violação, não silêncio: fecha a versão mecânica do cenário 'exclusão-como-válvula-de-escape' da falsificationCondition do adr-175."
		kind:         "instance-scoped-cross-file-id-exists"
		rule: {
			referencePaths: [
				"operationalScope.aggregates[]",
				"operationalScope.commands[]",
				"operationalScope.events[]",
				"operationalScope.invariants[]",
				"operationalScope.projections[]",
				"operationalScope.domainServices[]",
				"actions[].domainModelRefs[]",
				"scopeExclusions[].ref",
				"scopeExclusions[].refs[]",
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

	"sc-ag-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-ag-02"
		title:        "Catálogo operável do domain-model coberto pelo(s) agent-spec(s) do BC"
		artifactType: "agent-spec"
		description:  "DIREÇÃO INVERSA do sc-ag-01 (adr-175): todo id das 6 famílias operáveis do domain-model do BC (aggregates, commands, events, invariants, projections, domainServices) está na união de operationalScope/actions[].domainModelRefs (coberto) OU em scopeExclusions por id/por classe (excluído com rationale) do(s) agent-spec(s) daquele BC. União por escopo: múltiplos agentes de um BC cobrem o catálogo em conjunto. Famílias fora do gate per doutrina adr-175: vo-/ent-/qry- (cobertos via parent aggregate/projection), mod- (agrupamento organizacional), pol- (automação determinística de runtime, P10). BC sem agent-spec não é visitado por este check — ownership de agente é assunto do canvas (tq-ag-03)."
		kind:         "instance-scoped-cross-file-coverage"
		rule: {
			referencePaths: [
				"operationalScope.aggregates[]",
				"operationalScope.commands[]",
				"operationalScope.events[]",
				"operationalScope.invariants[]",
				"operationalScope.projections[]",
				"operationalScope.domainServices[]",
				"actions[].domainModelRefs[]",
			]
			exclusionPaths: [
				"scopeExclusions[].ref",
				"scopeExclusions[].refs[]",
			]
			scopeField:         "boundedContextRef"
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths: [
				"aggregates[].code",
				"commands[].code",
				"events[].code",
				"invariants[].code",
				"projections[].code",
				"domainServices[].code",
			]
		}
		errorMessage: "agent-spec: building block '{id}' do domain-model do BC '{scope}' não está coberto pelo(s) agente(s) do BC nem excluído em scopeExclusions. Coevolua o agent-spec (operationalScope/actions) ou declare a exclusão consciente com rationale (critério de legitimidade: adr-175)."
		rationale:    "adr-175: as fatias WI-151/152/153 materializaram building blocks sem coevoluir os agent-specs — drift silencioso agente↔modelo que o sc-ag-01 não vê (ele valida a direção agente→modelo). Um agente que ignora building blocks que existem opera com mapa desatualizado do próprio BC — risco operacional numa infra onde agentes operam sob governança. Born-warn (adr-097; precedente adr-117→123): promove a reject quando as higienes WI-154/WI-155 zerarem o baseline."
		enforcement: "warn"
	}
}
