package structural_checks

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// meta-coverage.cue — Camada de meta-cobertura (adr-099): fiscais que
// fiscalizam a folha de pagamento dos fiscais. Garante COBERTURA (existe um
// robô?), não ADEQUAÇÃO (o robô fiscaliza a coisa certa? — isso é P10/ten-006,
// coberto por validation-prompts + review do founder). Born-warn: ambos nascem
// não-bloqueantes; promoção a reject é decisão por-check (catraca, adr-097).

structuralChecks: {
	"sc-meta-01": artifact_schemas.#StructuralCheck & {
		id:           "sc-meta-01"
		title:        "Todo kind de structural-check tem evaluator no runner"
		artifactType: "structural-check"
		description:  "M1: todo kind declarado no enum #StructuralCheckKind e todo kind usado por algum check tem evaluator registrado em EVAL (scripts/ci/structural-check-runner.py). Fecha o elo rule→robô: declarar uma regra sem construir o fiscal passa a ser finding (born-warn; promover a reject depois)."
		kind:         "evaluator-coverage"
		rule: {
			checkSchemaPath: "architecture/artifact-schemas/structural-check.cue"
		}
		errorMessage: "kind '{nome}' está declarado no enum #StructuralCheckKind (ou é usado por um check) mas não tem evaluator em EVAL no runner — cartaz sem fiscal. Implemente o evaluator e registre-o em EVAL no mesmo commit, ou remova o kind do enum."
		rationale:    "adr-099 M1: a descoberta original foi que regras existem como cartaz na parede sem funcionário que as execute. Este check torna a ausência de evaluator uma falha barulhenta e determinística, não silêncio."
		enforcement: "warn"
	}
	"sc-meta-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-meta-02"
		title:        "Todo tipo governado tem structural-check ou isenção registrada"
		artifactType: "structural-check"
		description:  "M2: o conjunto de tipos governados é DERIVADO dos _schema.location (basenames dos schemas que governam instâncias), não autorado. Cada tipo tem ≥1 structural-check com artifactType correspondente OU consta em exemptTypes com rationale. Born-warn: surface os tipos cobertos só por cue vet + gate de órfão como inventário, sem bloquear."
		kind:         "structural-check-coverage"
		rule: {
			// Born-warn nasce com isenções VAZIAS de propósito: o inventário em
			// warn mostra todos os tipos sem check comportamental para triagem do
			// founder. Antes de promover a reject, cada tipo vira check ou ganha
			// uma isenção registrada aqui (com rationale).
			exemptTypes: []
		}
		errorMessage: "tipo governado '{nome}' não tem nenhum structural-check (artifactType correspondente) e não consta em exemptTypes. Adicione um check comportamental OU registre a isenção em exemptTypes com rationale (cobertura só de cue vet + gate de órfão é decisão, não acidente)."
		rationale:    "adr-099 M2: gêmeo do sc-pg-01, mas derivando o conjunto de tipos em vez de autorá-lo (a whitelist coveredSchemas do sc-pg-01 é ela própria superfície de drift). Surface a lacuna real de cobertura comportamental — ~23 de 31 tipos hoje — como backlog explícito."
		enforcement: "warn"
	}
}
