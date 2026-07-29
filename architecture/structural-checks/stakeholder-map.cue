package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// stakeholder-map.cue — Gates do stakeholder-map (WI-157; exit do
// def-076 "num movimento só": re-autoria + checks + isenção do
// meta-coverage removida). Materializa como structural-checks os
// tq-sm-* que os kinds atuais do runner EXPRESSAM; lacunas nomeadas
// abaixo (padrão rule-latente do sc-pg-01/sc-fcc).
//
// NOTA HONESTA DE EXPRESSIVIDADE:
// - tq-sm-01/06/07 (unicidade de codes e de platformRelationships):
//   NENHUM kind do runner verifica unicidade — lacuna do runner
//   nomeada; a 1ª camada é review (cue vet não acusa duplicata em
//   lista). Check nasce quando o kind existir.
// - tq-sm-04 (obrigação condicional por categoria): predicado
//   condicional por item não existe no runner (mesma lacuna do
//   sc-fcc-01/02); o resíduo avaliável é o enum do discriminador
//   (sc-sm-03). A 1ª camada da obrigação é o review + a definição
//   da classe no schema.
// - tq-sm-05 (distinção semântica de interests): interpretativo —
//   dimensão de review advisory, não de gate determinístico (P10);
//   deliberadamente NÃO vira check.
//
// Born-reject com a catraca verificada no ato para sc-sm-01/03
// (instância única re-autorada verde por construção); sc-sm-02 nasce
// WARN per severity do próprio tq-sm-03 (cobertura por canvas pode
// legitimamente atrasar — as personas sh-07/08/09 nascem nesta fatia
// SEM ref de canvas, esperadas no warn até a operacionalização).

structuralChecks: {
	"sc-sm-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-sm-01"
		title:        "costRef dos painPoints existe em domain-definition costsEliminated"
		artifactType: "stakeholder-map"
		description:  "Todo stakeholders[].painPoints[].costRef resolve para value.costsEliminated[].id em domain/domain-definition.cue — materializa tq-sm-02 (rastreabilidade econômica das dores)."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "stakeholders[].painPoints[].costRef"
			targetGlob:    "domain/domain-definition.cue"
			targetIdPath:  "value.costsEliminated[].id"
		}
		errorMessage: "stakeholder-map: painPoints[].costRef aponta ce-* inexistente em domain/domain-definition.cue value.costsEliminated. Corrija o ref ou proponha o custo canônico novo (decisão de domain-definition, não do mapa)."
		rationale:    "Materializa tq-sm-02 ('Validação por runner' que nunca teve runner — a 2ª camada de silêncio do def-076). Dor sem custo canônico quebra a rastreabilidade econômica que o schema v1 instituiu."
		enforcement:  "reject"
	}

	"sc-sm-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-sm-02"
		title:        "Todo stakeholder é referenciado por ao menos um canvas"
		artifactType: "stakeholder-map"
		description:  "Cada stakeholders[].code aparece como stakeholders[].stakeholderRef em ao menos um canvas — materializa tq-sm-03. WARN deliberado (severity do próprio critério): stakeholder sem vínculo pode ser legítimo (futuro) — as personas sh-07/08/09 nascem nesta fatia sem ref de canvas (operacionalização é WI-158+), esperadas neste warn."
		kind:         "cross-file-id-exists"
		rule: {
			referencePath: "stakeholders[].code"
			targetGlob:    "contexts/*/canvas.cue"
			targetIdPath:  "stakeholders[].stakeholderRef"
		}
		errorMessage: "stakeholder-map: code sem nenhuma referência stakeholderRef em canvas — mapa possivelmente incompleto OU stakeholder aguardando operacionalização (legítimo; ver tq-sm-03)."
		rationale:    "Materializa tq-sm-03 como sinal (warn, nunca trava): o valor é a visibilidade do descolamento mapa↔canvases, não o bloqueio — o próprio critério declara o caso legítimo."
		enforcement:  "warn"
	}

	"sc-sm-03": artifact_schemas.#StructuralCheck & {
		id:           "sc-sm-03"
		title:        "category pertence ao enum fechado de #StakeholderCategory"
		artifactType: "stakeholder-map"
		description:  "Todo stakeholders[].category pertence ao enum (7 valores pós-adr-181, incluindo adversarial-actor-class). Resíduo avaliável do tq-sm-04: o predicado condicional (categoria obrigada ⇒ manipulationVectors ≥1) não é expressável nos kinds atuais — lacuna nomeada no header; o discriminador correto é a base de qualquer enforcement futuro."
		kind:         "regex-pattern-match"
		rule: {
			valuePath: "stakeholders[].category"
			pattern:   "^(network-participant|financial-institution|government-authority|platform-operator|industry-association|technology-provider|adversarial-actor-class)$"
		}
		errorMessage: "stakeholder-map: category fora do enum #StakeholderCategory (7 valores; adversarial-actor-class per adr-181). Corrija a categoria ou proponha extensão do enum via ADR próprio."
		rationale:    "2ª camada sobre o cue vet (que já fecha o enum por unificação): o gate pós-commit acusa o discriminador mesmo se a instância escapar da unificação — exatamente o modo de falha que o def-076 registrou (instância que não unificava passava vet em silêncio)."
		enforcement:  "reject"
	}
}
