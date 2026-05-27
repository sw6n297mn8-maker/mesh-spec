package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// context-map.cue — Integridade referencial INTRA-arquivo do context-map
// (adr-100, kind local-field-reference-integrity). O context-map foi o tipo do
// drift original do audit; estes checks travam a regressão de referências
// internas que o cue vet não alcança (refs em posições aninhadas de listas).
// Nascem verdes (verificado: 0 drift hoje) e born-warn (catraca adr-097).
// Refs CROSS-FILE (context↔diretório de BC no disco, events↔BC) ficam para o
// cross-file-id-exists (def-002), não cobertas aqui.

structuralChecks: {
	"sc-cm-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-cm-01"
		title:        "Endpoint source de relationship referencia context declarado"
		artifactType: "context-map"
		description:  "Toda relationships[].source.context existe em contexts[].context no mesmo context-map. Trava regressão de relationship apontando para BC não-declarado."
		kind:         "local-field-reference-integrity"
		rule: {
			referencePath: "relationships[].source.context"
			namespacePath: "contexts[].context"
		}
		errorMessage: "context-map: relationship cujo source.context '{ref}' não está declarado em contexts[].context. Declare o context ou corrija o endpoint."
		rationale:    "adr-100: o context-map foi o drift original do audit. Relationship com endpoint para BC inexistente é inconsistência referencial silenciosa que o cue vet (shape) não pega."
		enforcement: "reject"
	}
	"sc-cm-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-cm-02"
		title:        "Endpoint target de relationship referencia context declarado"
		artifactType: "context-map"
		description:  "Toda relationships[].target.context existe em contexts[].context no mesmo context-map. Gêmeo de sc-cm-01 para o lado target."
		kind:         "local-field-reference-integrity"
		rule: {
			referencePath: "relationships[].target.context"
			namespacePath: "contexts[].context"
		}
		errorMessage: "context-map: relationship cujo target.context '{ref}' não está declarado em contexts[].context. Declare o context ou corrija o endpoint."
		rationale:    "adr-100: gêmeo de sc-cm-01 — integridade do endpoint downstream da relationship."
		enforcement: "reject"
	}
	"sc-cm-03": artifact_schemas.#StructuralCheck & {
		id:           "sc-cm-03"
		title:        "reverseRelationshipId referencia relationship existente"
		artifactType: "context-map"
		description:  "Toda relationships[].reverseRelationshipId existe em relationships[].code no mesmo context-map. Trava regressão de ponteiro de bidirecionalidade quebrado."
		kind:         "local-field-reference-integrity"
		rule: {
			referencePath: "relationships[].reverseRelationshipId"
			namespacePath: "relationships[].code"
		}
		errorMessage: "context-map: reverseRelationshipId '{ref}' não corresponde a nenhum relationships[].code. O ponteiro de relação reversa está quebrado."
		rationale:    "adr-100: bidirecionalidade declarada via reverseRelationshipId só é coerente se o code referenciado existir — cue vet valida o formato, não a existência."
		enforcement: "reject"
	}
	"sc-cm-04": artifact_schemas.#StructuralCheck & {
		id:           "sc-cm-04"
		title:        "ownerContext de subdomainOwnership referencia context declarado"
		artifactType: "context-map"
		description:  "Todo subdomainOwnership[].ownerContext existe em contexts[].context no mesmo context-map. Trava regressão de ownership de subdomínio apontando para BC não-declarado."
		kind:         "local-field-reference-integrity"
		rule: {
			referencePath: "subdomainOwnership[].ownerContext"
			namespacePath: "contexts[].context"
		}
		errorMessage: "context-map: subdomainOwnership cujo ownerContext '{ref}' não está declarado em contexts[].context. Declare o context ou corrija o owner."
		rationale:    "adr-100: ownership de subdomínio atribuída a um BC inexistente é drift referencial — o subdomínio ficaria sem dono real."
		enforcement: "reject"
	}
	"sc-cm-05": artifact_schemas.#StructuralCheck & {
		id:           "sc-cm-05"
		title:        "Todo diretório de BC no disco está declarado no context-map"
		artifactType: "context-map"
		description:  "Todo diretório contexts/{bc}/ no filesystem está declarado em context-map.contexts[].context. Pega o drift 'BC criado no disco sem declaração no mapa'. Direção segura (disco→map): NÃO exige o inverso — o context-map declara a topologia-alvo (25 BCs) e pode estar à frente do disco (BCs planejados), o que é roadmap e não drift."
		kind:         "filesystem-declared-coverage"
		rule: {
			pathGlob:     "contexts/*/"
			targetGlob:   "strategic/context-map.cue"
			targetIdPath: "contexts[].context"
		}
		errorMessage: "context-map: diretório de BC '{id}' existe no disco (contexts/{id}/) mas não está declarado em contexts[].context. Declare o BC no context-map ou remova o diretório."
		rationale:    "adr-103: fecha o 'mapas discordam com o disco' do audit na direção real e born-green (disco→map). adr-098 garante que os .cue do BC casem schema; este check garante que o BC seja reconhecido pelo mapa global."
		enforcement: "reject"
	}
	"sc-cm-06": artifact_schemas.#StructuralCheck & {
		id:           "sc-cm-06"
		title:        "Events de relationship built↔built existem no domain-model do produtor"
		artifactType: "context-map"
		description:  "Para cada relationship cujos source.context E target.context têm domain-model no disco (BC construído), todo event em events[] existe em algum contexts/*/domain-model.cue events[].name. Relationship tocando BC planejado é forward-declaration e fica fora (allowance). Resolve def-019 sobre a base canônica do adr-104."
		kind:         "scoped-cross-file-id-exists"
		rule: {
			itemsPath:         "relationships"
			guardFields: ["source.context", "target.context"]
			guardPresenceGlob: "contexts/*/domain-model.cue"
			refField:          "events"
			targetGlob:        "contexts/*/domain-model.cue"
			targetIdPath:      "events[].name"
		}
		errorMessage: "context-map: relationship built↔built referencia event '{ref}' que não existe em nenhum contexts/*/domain-model.cue events[].name. Corrija o nome (vocabulário canônico per adr-104) ou defina o event no domain-model do BC produtor."
		rationale:    "def-019 (adr-105): events são linguagem ubíqua entre BCs; um event trocado entre BCs construídos que não existe no domain-model do produtor é drift de contrato. Allowance built↔built evita falso-positivo de BC planejado (forward-declaration). cue vet valida formato de string, não existência cross-file."
		enforcement: "reject"
	}
}
