package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// frontend-codegen-contract.cue — Gates do contrato de codegen de
// frontend (adr-180 dec 5). Os DOIS CASOS ADVERSARIAIS do mandato
// adr-179 como 2ª camada determinística pós-commit (cue vet é a 1ª,
// por shape) + refs cross-file. Born-reject com a condição da catraca
// verificada no ato (instância única verde por construção —
// precedentes adr-171 + sc-ag-03/adr-176).
//
// NOTA HONESTA DE EXPRESSIVIDADE (padrão "rule latente" do sc-pg-01):
// nenhum kind do runner expressa hoje predicado CONDICIONAL por item
// ("se kind==action-bearing então actions≥1 com os 3 slots"; "se
// kind==read-only então actions proibido") — esses predicados são
// fechados INTEGRALMENTE pela 1ª camada (cue vet: união discriminada
// com structs fechados). sc-fcc-01/02 nascem com o kind mais próximo
// (regex-pattern-match) cobrindo o resíduo avaliável hoje; a lacuna
// do runner (predicado condicional por item) é dívida nomeada aqui.
// sc-fcc-03/04 declaram a semântica item-scoped EXATA (adr-169), mas o
// evaluator V1 itera apenas itemsPath-LISTA — families é struct-keyed
// (dict), então os dois checks ficam LATENTES até o runner iterar
// dict-values (lacuna nomeada; 1 caso: nscache já é por escopo).
// sc-fcc-05/06 (cross-file-id-exists) avaliam DE VERDADE hoje —
// _resolve_multi itera dict-values.

structuralChecks: {
	"sc-fcc-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-fcc-01"
		title:        "Capacidade de command vive como commandRef bem-formado em action"
		artifactType: "frontend-codegen-contract"
		description:  "O caso adversarial 'capacidade de command sem action surface' (adr-180 dec 5) é fechado pela 1ª camada (shape: actions≥1 com os 3 slots por construção no ramo action-bearing; commandRef só existe DENTRO de #Action). Resíduo avaliável pós-commit com os kinds atuais: todo families[].actions[].commandRef é id cmd-* bem-formado — capacidade de command declarada fora do formato acusa. O predicado condicional por item (kind==action-bearing ⇒ actions≥1) é lacuna nomeada do runner."
		kind:         "regex-pattern-match"
		rule: {
			valuePath: "families[].actions[].commandRef"
			pattern:   "^cmd-[a-z][a-z0-9-]*$"
		}
		errorMessage: "frontend-codegen-contract: commandRef fora do formato cmd-* em families[].actions[]. Capacidade de command só existe como action com os 3 slots (mandato adr-179) — cue vet é a 1ª camada; este gate acusa o resíduo de formato pós-commit."
		rationale:    "Camada redundante deliberada sobre o shape (defesa-em-profundidade do mandato adr-179): o kind mais próximo disponível cobre o resíduo avaliável; a lacuna do runner (predicado condicional por item) fica nomeada — padrão rule-latente do sc-pg-01."
		enforcement:  "reject"
	}

	"sc-fcc-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-fcc-02"
		title:        "Discriminador de capacidade das famílias pertence ao enum fechado"
		artifactType: "frontend-codegen-contract"
		description:  "O caso adversarial 'action surface sem capacidade de command' e seu inverso residual (read-only com actions — adr-180 dec 5) são fechados pela 1ª camada (shape: o campo actions NÃO EXISTE no ramo read-only; struct fechado rejeita). Resíduo avaliável pós-commit com os kinds atuais: todo families[].kind pertence ao enum fechado action-bearing|read-only — classe de capacidade inventada (a mentira de capacidade) acusa. O predicado 'forbids actions em kind==read-only' é lacuna nomeada do runner."
		kind:         "regex-pattern-match"
		rule: {
			valuePath: "families[].kind"
			pattern:   "^(action-bearing|read-only)$"
		}
		errorMessage: "frontend-codegen-contract: families[].kind fora do enum action-bearing|read-only. A não-aplicabilidade do action-surface é POR SHAPE (adr-179); capacidade fora do enum é furo grave — cue vet é a 1ª camada, este gate acusa o discriminador pós-commit."
		rationale:    "O segundo adversarial do mandato como gate nomeado: com a exclusão mútua fechada por shape, a mentira de capacidade (discriminador inventado) é o bypass residual que o kind disponível consegue acusar."
		enforcement:  "reject"
	}

	"sc-fcc-03": artifact_schemas.#StructuralCheck & {
		id:           "sc-fcc-03"
		title:        "Refs de domínio da família existem no domain-model do BC"
		artifactType: "frontend-codegen-contract"
		description:  "commandRef, returnsEvents, aggregateRef, valueObjects e events de cada família resolvem para ids no domain-model do BC daquela família (item-scoped per adr-169). LATENTE: o evaluator V1 do runner itera apenas itemsPath-lista; families é struct-keyed — o check declara a semântica exata e ativa quando o runner iterar dict-values (lacuna nomeada, padrão rule-latente do sc-pg-01)."
		kind:         "item-scoped-cross-file-id-exists"
		rule: {
			itemsPath:          "families[]"
			scopeField:         "boundedContextRef"
			refFields:          ["actions[].commandRef", "actions[].confirmation.returnsEvents[]", "aggregateRef", "valueObjects[]", "events[]"]
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths:      ["commands[].code", "events[].code", "aggregates[].code", "valueObjects[].code"]
		}
		errorMessage: "frontend-codegen-contract: ref de domínio não existe no domain-model do BC da família. A superfície não inventa domínio — corrija o ref ou a fatia de domínio precede."
		rationale:    "Derived→source 1:1 (tq-mg-06): contrato apontando id fantasma é geração a partir do nada. Escopo por-item (adr-169): a união global daria falso-verde via ids homônimos de outro BC."
		enforcement:  "reject"
	}

	"sc-fcc-04": artifact_schemas.#StructuralCheck & {
		id:           "sc-fcc-04"
		title:        "queryRef das read surfaces existe no domain-model do BC"
		artifactType: "frontend-codegen-contract"
		description:  "Todo readSurfaces[].queryRef (ramo query-backed) resolve para queryCapabilities[].code no domain-model do BC da família. LATENTE: mesma lacuna do sc-fcc-03 (evaluator V1 itera apenas itemsPath-lista; families é struct-keyed); ativa quando o runner iterar dict-values."
		kind:         "item-scoped-cross-file-id-exists"
		rule: {
			itemsPath:          "families[]"
			scopeField:         "boundedContextRef"
			refFields:          ["readSurfaces[].queryRef"]
			targetGlobTemplate: "contexts/{scope}/domain-model.cue"
			targetIdPaths:      ["projections[].queryCapabilities[].code"]
		}
		errorMessage: "frontend-codegen-contract: queryRef não existe como query capability no domain-model do BC. View gerada exige leitura formal — a fatia de domínio precede."
		rationale:    "O regime generated (adr-180 dec 3) só se sustenta com a query capability real por trás da view."
		enforcement:  "reject"
	}

	"sc-fcc-05": artifact_schemas.#StructuralCheck & {
		id:           "sc-fcc-05"
		title:        "migrationRef das actions net-new resolve em deferred-decisions"
		artifactType: "frontend-codegen-contract"
		description:  "Todo generativeForm.migrationRef resolve para um def existente em architecture/deferred-decisions/ (a VIVACIDADE — open/triggered — é verificação do PG/reconciliation, não deste gate de existência). activeBoundaries[] tem gate próprio: sc-fcc-06 (o shape do kind tem referencePath singular)."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "families[].actions[].generativeForm.migrationRef"
			targetGlob:    "architecture/deferred-decisions/def-*.cue"
			targetIdPath:  "id"
		}
		errorMessage: "frontend-codegen-contract: migrationRef aponta def inexistente. Âncora de migração dangling desarma a revisita do não-padrão net-new (adr-178/def-081-class)."
		rationale:    "A âncora de revisita é o que separa net-new de digitação-por-preguiça — dangling é o pior estado possível dela."
		enforcement:  "reject"
	}

	"sc-fcc-06": artifact_schemas.#StructuralCheck & {
		id:           "sc-fcc-06"
		title:        "activeBoundaries resolvem em deferred-decisions"
		artifactType: "frontend-codegen-contract"
		description:  "Todo activeBoundaries[] resolve para um def existente em architecture/deferred-decisions/ (a VIVACIDADE — open/triggered — é verificação do PG/reconciliation, não deste gate de existência). Par do sc-fcc-05: o kind cross-file-id-exists tem referencePath singular, então a cobertura prometida divide em dois checks."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "activeBoundaries[]"
			targetGlob:    "architecture/deferred-decisions/def-*.cue"
			targetIdPath:  "id"
		}
		errorMessage: "frontend-codegen-contract: activeBoundaries aponta def inexistente. Fronteira ativa dangling é pressuposto fantasma — o contrato pressupõe deferral que não existe no disco."
		rationale:    "activeBoundaries é a lista viva dos deferrals que o contrato pressupõe (def-064/def-065/def-081 na v3) — id fantasma quebraria o elo contrato↔deferimento governado (adr-062)."
		enforcement:  "reject"
	}
}
