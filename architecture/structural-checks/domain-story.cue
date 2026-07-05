package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-story.cue — Gates referenciais das domain stories (adr-170).
//
// Todos born-warn per adr-097 (catraca): zero instâncias no disco hoje —
// promoção a reject é decisão junto da 1ª story real. sc-ds-01..03 são
// cross-file PLAIN (alvo singleton ou união é o próprio universo válido).
// sc-ds-04..08 usam o kind item-scoped-cross-file-id-exists (adr-169): a ref
// de building block do passo resolve contra o domain-model DO BC DAQUELE
// passo (scopeField workItem.boundedContextRef) — a união global daria
// falso-verde via cópias consumidas (sourceContext).
//
// Regra única (adr-170): ref preenchida → morde; ref vazia → lacuna honesta
// (a story testa a cobertura do modelo, nunca inventa para preencher).

structuralChecks: {
	"sc-ds-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-01"
		title:        "actorRef da story existe no stakeholder-map"
		artifactType: "domain-story"
		description:  "Todo steps[].actorRef resolve para stakeholders[].code em domain/stakeholder-map.cue — ator de story rastreia a stakeholder canônico."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "steps[].actorRef"
			targetGlob:    "domain/stakeholder-map.cue"
			targetIdPath:  "stakeholders[].code"
		}
		errorMessage: "domain-story: actorRef não existe em domain/stakeholder-map.cue. Corrija o ref ou registre o stakeholder no mapa (ator inventado não entra em story)."
		rationale:    "O elo ator↔stakeholder é o que impede a story de virar ilha narrativa: todo ator é um sh-* canônico, com incentivos e dores mapeados."
		enforcement:  "warn"
	}

	"sc-ds-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-02"
		title:        "boundedContextRef do work-item existe como canvas"
		artifactType: "domain-story"
		description:  "Todo steps[].workItem.boundedContextRef resolve para um canvas.code em contexts/*/canvas.cue — o BC que implementa o passo existe."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "steps[].workItem.boundedContextRef"
			targetGlob:    "contexts/*/canvas.cue"
			targetIdPath:  "code"
		}
		errorMessage: "domain-story: workItem.boundedContextRef não corresponde a nenhum canvas. Corrija o ref ou derive o BC antes de narrá-lo como implementador."
		rationale:    "Work-item apontando BC inexistente é implementação fantasma — quebra o elo story→BC que dá à narrativa valor de teste de cobertura."
		enforcement:  "warn"
	}

	"sc-ds-03": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-03"
		title:        "subdomainRef da story existe em strategic/subdomains"
		artifactType: "domain-story"
		description:  "O subdomainRef da story resolve para um code em strategic/subdomains/*.cue — o dono estratégico da jornada existe."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "subdomainRef"
			targetGlob:    "strategic/subdomains/*.cue"
			targetIdPath:  "code"
		}
		errorMessage: "domain-story: subdomainRef não corresponde a nenhum subdomínio declarado. Corrija o ref ou declare o subdomínio."
		rationale:    "A story cruza BCs; o escopo que a possui é o subdomínio — dono fantasma deixaria a jornada sem lar estratégico (finding do review isolado, WARN 6)."
		enforcement:  "warn"
	}

	"sc-ds-04": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-04"
		title:        "commandRefs do passo existem no domain-model do BC do passo"
		artifactType: "domain-story"
		description:  "Cada workItem.commandRefs[] resolve para commands[].code no domain-model DO BC daquele passo (item-scoped, adr-169)."
		kind:         "item-scoped-cross-file-id-exists"
		rule: {
			itemsPath:          "steps[]"
			scopeField:         "workItem.boundedContextRef"
			refFields:          ["workItem.commandRefs[]"]
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths:      ["commands[].code"]
		}
		errorMessage: "domain-story: commandRef não existe no domain-model do BC do passo. A story referencia o que existe — se o comando falta no modelo, o vazio é o achado (não invente)."
		rationale:    "Escopo por-item (adr-169): o comando tem de existir no BC que implementa o passo; a união global daria falso-verde."
		enforcement:  "warn"
	}

	"sc-ds-05": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-05"
		title:        "eventRefs do passo existem no domain-model do BC do passo"
		artifactType: "domain-story"
		description:  "Cada workItem.eventRefs[] resolve para events[].code no domain-model DO BC daquele passo (item-scoped, adr-169)."
		kind:         "item-scoped-cross-file-id-exists"
		rule: {
			itemsPath:          "steps[]"
			scopeField:         "workItem.boundedContextRef"
			refFields:          ["workItem.eventRefs[]"]
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths:      ["events[].code"]
		}
		errorMessage: "domain-story: eventRef não existe no domain-model do BC do passo (cópia consumida de outro BC não vale como dono — o gate olha o modelo DESTE BC)."
		rationale:    "O cenário provado no self-test do runner: evt-invoice-issued em passo cmt FALHA (o modelo do cmt não o tem); a união global passaria via cópia consumida do fce — o falso-verde que o adr-169 mata."
		enforcement:  "warn"
	}

	"sc-ds-06": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-06"
		title:        "policyRefs do passo existem no domain-model do BC do passo"
		artifactType: "domain-story"
		description:  "Cada workItem.policyRefs[] resolve para policies[].code no domain-model DO BC daquele passo (item-scoped, adr-169)."
		kind:         "item-scoped-cross-file-id-exists"
		rule: {
			itemsPath:          "steps[]"
			scopeField:         "workItem.boundedContextRef"
			refFields:          ["workItem.policyRefs[]"]
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths:      ["policies[].code"]
		}
		errorMessage: "domain-story: policyRef não existe no domain-model do BC do passo. Ref vazia = lacuna honesta; ref inventada = violação."
		rationale:    "Mesma regra única do adr-170 aplicada a políticas: a story cobre o modelo, não o substitui."
		enforcement:  "warn"
	}

	"sc-ds-07": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-07"
		title:        "readModelRefs do passo existem no domain-model do BC do passo"
		artifactType: "domain-story"
		description:  "Cada workItem.readModelRefs[] resolve para projections[].code no domain-model DO BC daquele passo (item-scoped, adr-169). No disco, read models são projections."
		kind:         "item-scoped-cross-file-id-exists"
		rule: {
			itemsPath:          "steps[]"
			scopeField:         "workItem.boundedContextRef"
			refFields:          ["workItem.readModelRefs[]"]
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths:      ["projections[].code"]
		}
		errorMessage: "domain-story: readModelRef (prj-*) não existe nas projections do domain-model do BC do passo."
		rationale:    "O que o usuário VÊ num passo é uma projection do BC; ref fantasma quebraria o valor da story como teste de cobertura de leitura."
		enforcement:  "warn"
	}

	"sc-ds-08": artifact_schemas.#StructuralCheck & {
		id:           "sc-ds-08"
		title:        "queryRefs do passo existem no domain-model do BC do passo"
		artifactType: "domain-story"
		description:  "Cada workItem.queryRefs[] resolve para projections[].queryCapabilities[].code no domain-model DO BC daquele passo (item-scoped, adr-169; path aninhado provado no sc-ag-01)."
		kind:         "item-scoped-cross-file-id-exists"
		rule: {
			itemsPath:          "steps[]"
			scopeField:         "workItem.boundedContextRef"
			refFields:          ["workItem.queryRefs[]"]
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths:      ["projections[].queryCapabilities[].code"]
		}
		errorMessage: "domain-story: queryRef (qry-*) não existe nas queryCapabilities do domain-model do BC do passo."
		rationale:    "Jornadas de compras consultam muito (status, cotações); o gate garante que cada consulta narrada existe como capacidade real do BC."
		enforcement:  "warn"
	}
}
