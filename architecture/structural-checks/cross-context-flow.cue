package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// cross-context-flow.cue — Integridade referencial cross-file dos cross-context
// workflows (adr-112, kind cross-file-id-exists). Cada phase declara
// ownerContext (BC) e ownerSubdomain (subdomínio) que devem existir nos
// registros canônicos. Born-green; promovido a reject (adr-114). A dimensão integrationEvents
// (eventos trocados) NÃO é coberta aqui — 3 refs não resolvem (built-BC
// incompleto + BC planejado); deferida em def-021.

structuralChecks: {
	"sc-ccf-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-ccf-01"
		title:        "phase.ownerContext referencia context declarado"
		artifactType: "cross-context-flow"
		description:  "Todo phases[].ownerContext existe em strategic/context-map.cue contexts[].context. cue vet valida o formato, não a existência do BC no mapa global."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "phases[].ownerContext"
			targetGlob:    "strategic/context-map.cue"
			targetIdPath:  "contexts[].context"
		}
		errorMessage: "cross-context-flow: phase.ownerContext '{ref}' não está declarado em context-map.contexts[].context. Declare o BC ou corrija o owner."
		rationale:    "adr-112: uma phase de workflow cross-context atribuída a um BC inexistente no mapa é drift referencial — o dono não existe na topologia."
		enforcement: "reject"
	}
	"sc-ccf-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-ccf-02"
		title:        "phase.ownerSubdomain referencia subdomínio declarado"
		artifactType: "cross-context-flow"
		description:  "Todo phases[].ownerSubdomain existe como code em strategic/subdomains/*.cue."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "phases[].ownerSubdomain"
			targetGlob:    "strategic/subdomains/*.cue"
			targetIdPath:  "code"
		}
		errorMessage: "cross-context-flow: phase.ownerSubdomain '{ref}' não corresponde a nenhum subdomínio (strategic/subdomains/*.cue code). Corrija o id ou crie o subdomínio."
		rationale:    "adr-112: a phase ancora a responsabilidade num subdomínio estratégico; um subdomínio fantasma quebra o elo flow→estratégia."
		enforcement: "reject"
	}
	"sc-ccf-03": artifact_schemas.#StructuralCheck & {
		id:           "sc-ccf-03"
		title:        "cross-context-flow: cadeia de eventos fecha (sem evento órfão)"
		artifactType: "cross-context-flow"
		description:  "Closure topológica do flow (def-031): todo evento produzido por uma phase (completionSignal + integrationEvents) tem >=1 consumidor em consumedBy[].consumes (phase OU contexto externo ao conjunto de phases); todo consumes referencia evento produzido pela própria phase; consumedBy.phase (quando presente) existe em phases[].name. O completionSignal da phase terminal é emissão de fim-de-fluxo isenta. Promove tq-xf-02 (advisory) a gate determinístico per adr-040/P10 — event-storming-reverso. NÃO duplica def-021 (integrationEvents↔domain-model, dimensão events): aqui é a closure do GRAFO."
		kind:         "flow-event-closure"
		rule: {}
		errorMessage: "cross-context-flow: cadeia de eventos não fecha — evento produzido sem consumidor (órfão), consumes sem produtor na phase, ou consumedBy.phase inexistente. Declare o consumidor faltante, corrija o consumes, OU registre em consumedBy o consumidor downstream (inclusive contexto fora do conjunto de phases)."
		rationale:    "def-031: o oráculo de closure pega o erro de modelagem mais caro (evento órfão num flow cross-BC) como gate determinístico, não só design-review (tq-xf-02 advisory). Born-warn (catraca adr-097): o flow commitment-lifecycle tem 2 emissões roadmap sem consumidor materializado (BudgetCommitted, CommitmentClosed); promove a reject quando o flow fechar."
		enforcement: "warn"
	}
}
