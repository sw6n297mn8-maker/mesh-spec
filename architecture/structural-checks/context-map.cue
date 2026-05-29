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
	"sc-cm-07": artifact_schemas.#StructuralCheck & {
		id:           "sc-cm-07"
		title:        "Grafo de dependência cross-BC é acíclico"
		artifactType: "context-map"
		description:  "Para o subgrafo de relationships com direction='upstream-downstream' entre dois bounded-contexts E que publicam events E não são tipadas como policy-reaction (rew-to-cmt, rew-to-ins) ou bidirectional-orchestration (cmt-to-drc, drc-to-cmt) ou policy-execution-feedback (rew-to-fce, fce-to-rew), o grafo dirigido de dependência (downstream → upstream) deve ser acíclico. Excluídas por design: (a) relações 'mutual-dependency' (partnership, shared-kernel — simétricas); (b) relações com external-systems (não-nós do grafo BC↔BC); (c) query-surfaces — arestas sem events declarados (sync queries são call-site operacional, não dependência arquitetural cross-BC, per adr-120); (d) policy-reaction kinds (notification + downstream agency per def-027 + adr-119) — aresta exclude via filter notEquals; (e) bidirectional-orchestration kinds (loop bilateral entre BCs distintos per def-026 + adr-118) — feedbackLoop.kind exclude via filter notEquals; (f) policy-execution-feedback kinds (estrutura policy↔execution com feedback contínuo per adr-124, descoberta empírica via Ajuste 1 do PR-3) — feedbackLoop.kind exclude via filter notEquals. Primeiro consumidor do kind directed-acyclicity (adr-117); primeiro consumidor do operator notEquals (adr-121)."
		kind:         "directed-acyclicity"
		rule: {
			nodesPath:  "contexts[].context"
			edgesPath:  "relationships[]"
			edgeSource: "target.context"
			edgeTarget: "source.context"
			edgeFilters: [
				{path: "direction", equals:   "upstream-downstream"},
				{path: "source.kind", equals: "bounded-context"},
				{path: "target.kind", equals: "bounded-context"},
				{path: "events", exists: true},
				{path: "kind", notEquals: "policy-reaction"},
				{path: "feedbackLoop.kind", notEquals: "bidirectional-orchestration"},
				{path: "feedbackLoop.kind", notEquals: "policy-execution-feedback"},
			]
		}
		errorMessage: "context-map: ciclo de dependência entre bounded-contexts detectado. Cada nó do caminho depende do próximo (downstream → upstream). Avaliar se a aresta deveria ser direction='mutual-dependency' (partnership/shared-kernel), se uma policy reaction está sendo modelada como dependência direta, ou se há acoplamento circular genuíno a resolver via redesenho de fronteira."
		rationale:    "DDD orthodoxy + dp-03 (blast radius): bounded contexts são unidades de isolamento; dependência circular cross-BC quebra o isolamento e torna o grafo de deploy não-topologicamente-ordenável. Os sc-cm-01..06 garantem integridade referencial das relações; nenhum enxerga o fechamento transitivo. Born-warn (catraca adr-097) cumprida: 4 ciclos no grafo original (2026-05-28; adr-117 documenta) → 0 ciclos após plano cycle-resolution completo. adr-120 (PR-2) filter events:exists → W4 (fce↔tcm via tcm-to-fce query-surface) resolvido + internalização de 3 query-surfaces benignas (idc-to-log, idc-to-dlv, npm-to-ctr). adr-121 (PR-3) capability notEquals. adr-122 (PR-3) aplicação Família A em 4 arestas (cmt-to-drc, drc-to-cmt → bidirectional-orchestration; rew-to-cmt, rew-to-ins → policy-reaction) + 2 edgeFilters notEquals → W1/W2/W3 resolvidos. adr-124 (PR-3) adiciona policy-execution-feedback ao #FeedbackLoopKind após descoberta empírica de ciclo fce↔rew via Ajuste 1 + aplicação em rew-to-fce/fce-to-rew + 7ª edgeFilter notEquals. adr-123 (PR-3) promove enforcement warn → reject."
		enforcement: "reject"
	}
}
