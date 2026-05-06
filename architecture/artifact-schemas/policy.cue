package artifact_schemas

// policy.cue — Schema para Policy Registry instances.
//
// Per adr-065: PLR é registro canônico de identidade. NÃO engine.
// Schema é deliberadamente MINIMAL — só identidade, escopo, classe,
// definição, ownership, version. Enforcement permanece distribuído nos
// mecanismos existentes (#Policy domain-model, #AgentGovernanceEnvelope,
// policyRefs flows, quality-gate). 5 evolução paths deferidos via
// def-005..009.
//
// Sanity test invariante: se PLR for removido amanhã, BCs continuam
// funcionando. Schema preserva esse invariante via enforcement:
// 'external' literal-locked — qualquer tentativa futura de PLR virar
// engine quebra cue vet (shape gate determinístico contra drift).

import (
	"strings"
)

// Renomeado de #Policy → #PolicyRegistryEntry (per amendment adr-065
// 2026-05-06) para resolver colisão homônima no package artifact_schemas
// com #Policy de domain-model.cue (event → command automation, com
// fields code/triggeredByEvent/issuesCommand/guards). Unificação
// implícita das duas definições exigia campos de AMBAS em todas as
// instâncias domainModel.policies, quebrando cue vet --concrete em
// todos os domain-models pré-existentes (SSC/CMT/BDG). Rename é
// semanticamente apropriado: "#PolicyRegistryEntry" reforça intent
// registry-only de PLR per adr-065 (não engine; identidade canônica
// por entry) e separa do conceito legacy domain-model. Sem instâncias
// existentes em domain/policies/ — rename mecânico sem impacto
// downstream. Schema fields/constraints/_schema.location idênticos
// pré-rename — apenas o identifier muda.
#PolicyRegistryEntry: {
	// Código canônico estável. Convenção: pol-<slug-curto>.
	id: string & =~"^pol-[a-z][a-z0-9-]*$"

	// Escopo da policy — fronteira de aplicação.
	//   bc-local: escopo de 1 BC (appliesTo deve listar exatamente 1).
	//   cross-bc: cruza fronteira de BC (appliesTo deve listar 2+).
	scope: "bc-local" | "cross-bc"

	// Classe da policy — natureza/criticality.
	//   regulatory: L1 invioláveis (Bacen, LGPD, KYC/AML); rationale
	//     deve referenciar regulação concreta; enforcement obrigatório.
	//   business: regra de negócio (limites, condições comerciais);
	//     rationale tem fundamentação econômica.
	//   operational: regra operacional (workflow, throttling, retry);
	//     rationale tem fundamentação de processo.
	class: "regulatory" | "business" | "operational"

	// LOCKED: enforcement sempre é externo ao PLR.
	// Per adr-065: PLR é registry-only. Schema gate determinístico
	// contra drift futuro de PLR virar engine via ambiguidade —
	// qualquer tentativa de mudar este field para outro valor falha
	// cue vet. Sanity test invariante materializado em shape.
	enforcement: "external"

	// BCs ou flows aos quais a policy se aplica.
	// Mínimo 1 entry — policy sem aplicação é abstrata.
	// tq-pol-01 valida coerência com scope.
	appliesTo: [string & !="", ...string & !=""]

	// Definição da regra. Estrutura aberta no v1 — instâncias declaram
	// conforme natureza da regra. Evolução para shape tipado é objeto
	// de def-005..009 quando concrete cases materializarem.
	definition: {...}

	// Owner — humano ou role responsável pela policy.
	owner: string & !=""

	// Versão. Increment quando policy muda materialmente.
	// Lifecycle/versioning sofisticado (rollout, compatibility,
	// deprecation, upgrade) deferido via def-009.
	version: int & >=1

	// Por que esta policy existe + critério de avaliação.
	// MinRunes(50) força articulação substantiva.
	rationale: string & strings.MinRunes(50)

	_schema: {
		location: {
			canonicalPathRegex: "^domain/policies/pol-[a-z0-9-]+\\.cue$"
			fileNameRegex:      "^pol-[a-z0-9-]+\\.cue$"
			description:        "Policy Registry instances — registro canônico de identidade de policies per adr-065."
			rationale:          "Vivem em domain/policies/ porque identidade de policy é dimensão de domínio (cross-cutting), análoga a domain/stakeholder-map.cue. PLR (subdomain em strategic/subdomains/plr.cue) declara o conceito; instances vivem em domain/. Cardinality collection."
			cardinality:        "collection"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-pol-01"
			description: "scope alinhado com appliesTo"
			test:        "Para scope='bc-local': appliesTo contém exatamente 1 entry (1 BC). Para scope='cross-bc': appliesTo contém 2+ entries (2+ BCs ou flows que cruzam BCs). Mismatch indica scope misclassificado, contamina critérios de criticality + processo de revisão."
			severity:    "fail"
			rationale:   "Misclassificação de scope quebra discipline de coordenação cross-BC vs autonomia BC. cross-bc requer coordenação explícita; bc-local pode usar legacy #Policy do domain-model. Schema permite ambos format mas semantics divergem materialmente — fail enforce alignment."
		}, {
			id:          "tq-pol-02"
			description: "class é calibrada e justificada no rationale"
			test:        "Para class='regulatory': rationale referencia regulação concreta (e.g., 'Bacen Resolução X', 'LGPD Art. Y', 'KYC requirement Z'). Para class='business': rationale tem fundamentação econômica (limite financeiro, condição comercial, restrição de mercado). Para class='operational': rationale tem fundamentação de processo (workflow, throttling, retry semantics). Genérico ('é importante', 'preserva integridade') falha."
			severity:    "fail"
			rationale:   "Classificação preguiçosa contamina criticality + governance proporcional. regulatory exige enforcement obrigatório; business é negociável; operational é tunable. Schema permite todas três; rationale prova a classificação."
		}, {
			id:          "tq-pol-03"
			description: "definition é avaliável, não aspiracional"
			test:        "definition descreve regra concretamente — entrada (eventos/states inputs), condição (predicate), saída/effect (state transition, alert, blocking). Não é prose narrativa genérica ('preserva integridade do compromisso', 'mantém consistência operacional')."
			severity:    "fail"
			rationale:   "Policy não-avaliável é declaração, não regra. Impede review humano substantivo + impede automação futura quando engine materializar. Schema mantém definition aberta (evolução tipada via def-005..009) mas substantividade é fail level."
		}, {
			id:          "tq-pol-04"
			description: "owner identificável + version increment material"
			test:        "owner referencia humano ou role current (NÃO genérico 'team', 'whoever'). version increment acompanha mudança em definition, scope, ou class — mudanças editoriais (rationale clarification) NÃO requerem increment. Mudança material sem increment = silent drift."
			severity:    "warn"
			rationale:   "Ownership + versioning são discipline. Owner órfão acumula drift sem responsável; version sem discipline impede consumers detectarem mudança. Warn porque ambos podem mudar legitimamente em janela de tolerância. Lifecycle sofisticado deferido via def-009."
		}]
		rationale: "4 critérios cobrem alinhamento de scope (tq-pol-01), classificação calibrada (tq-pol-02), substantividade da definition (tq-pol-03), accountability + versioning (tq-pol-04). 3 fail + 1 warn. enforcement: 'external' literal-locked é o 5º gate (schema-shape) que previne PLR drift de virar engine — não precisa de critério porque é shape constraint."
	}
}
