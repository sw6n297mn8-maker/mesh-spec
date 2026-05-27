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
		enforcement: "reject"
	}
	"sc-meta-02": artifact_schemas.#StructuralCheck & {
		id:           "sc-meta-02"
		title:        "Todo tipo governado tem structural-check ou isenção registrada"
		artifactType: "structural-check"
		description:  "M2: o conjunto de tipos governados é DERIVADO dos _schema.location (basenames dos schemas que governam instâncias), não autorado. Cada tipo tem ≥1 structural-check com artifactType correspondente OU consta em exemptTypes com rationale. Born-warn: surface os tipos cobertos só por cue vet + gate de órfão como inventário, sem bloquear."
		kind:         "structural-check-coverage"
		rule: {
			// Triagem adr-101: cada tipo governado sem check comportamental vira
			// isenção registrada com rationale, em 3 categorias:
			//  (P)  shape via cue vet adequado / maquinaria engine (zona adr-098) —
			//       sem refs cross-artifact a verificar, ou já coberto por outro gate;
			//  (def-002) bucket cross-file: o kind cross-file-id-exists JÁ existe
			//       (adr-102 resolveu def-002); o check específico de cada tipo é
			//       autorado incrementalmente — a isenção vale até o check existir;
			//  (follow-on) check expressável agora (intra-arquivo via adr-100, ou
			//       path-existence) mas adiado para este pass focar em zerar+promover.
			exemptTypes: [
				{type: "authoring-policy", rationale: "(P) Config singleton da engine de authoring (build-time, zona adr-098); cue vet cobre o shape, sem refs cross-artifact a verificar."},
				{type: "quality-gate", rationale: "(P) Config singleton do protocolo de self-review (build-time, zona adr-098); shape via cue vet."},
				{type: "self-review-bootstrap-policy", rationale: "(P) Policy de bootstrap de self-review (build-time, zona adr-098); shape via cue vet."},
				{type: "self-review-ci-policy", rationale: "(P) Policy de CI de self-review (build-time, zona adr-098); shape via cue vet."},
				{type: "subagent-execution-log", rationale: "(P) Log append-only de dispatches (build-time, zona adr-098); dado declarativo, sem integridade referencial."},
				{type: "validation-findings-w001", rationale: "(P) Registro de findings de uma wave (build-time, zona adr-098); dado declarativo, shape via cue vet."},
				{type: "quality-criteria", rationale: "(P) Fragmento de meta-schema (critérios tq-*) embutido em outros schemas; sem instâncias com refs próprias."},
				{type: "readme-config", rationale: "(P) Config do README; consistência já guardada por check-readme-coevolution.sh (tree.entries↔disco↔README), não por structural-check."},
				{type: "repo-structure", rationale: "(P) Config singleton de escopo/derivados; drift de scope/derived aparece nos próprios gates (órfão, coevolution), não exige check próprio."},
				{type: "design-principles", rationale: "(P) Princípios P0–P12 em prosa declarativa; sem refs cross-artifact verificáveis; shape via cue vet."},
				{type: "shared-types", rationale: "(P) Biblioteca de tipos compartilhados; é definição consumida por outros schemas, sem instâncias a referenciar."},
				{type: "task-template", rationale: "(P) Templates de tarefa; conteúdo declarativo, shape via cue vet."},
				{type: "lens", rationale: "(P) Lenses analíticas; critérios de ativação self-contained; shape via cue vet."},
				{type: "validation-prompt", rationale: "(P) Prompts advisory (camada P10); matchPatterns self-contained; shape via cue vet."},
				{type: "economic-assumption-model", rationale: "(P) Modelo de premissas econômicas; declarativo, refs intra-shape; shape via cue vet."},
				{type: "glossary", rationale: "(P) Glossário por BC; termos auto-contidos; shape via cue vet."},
				{type: "api-spec", rationale: "(P) Presença de api.yaml já coberta por sc-cv-02 (conditional-file-presence); o schema em si é shape via cue vet."},
				{type: "agent-governance", rationale: "(P) Envelope de governança de agente; limites/autoridade declarativos (shape via cue vet); refs a artefatos do BC seriam cross-file (def-002)."},
				{type: "subdomain", rationale: "(P) Sem ref cross-file: campos são code/definition/name/type, auto-contidos; shape via cue vet adequado. (Categoria def-002 anterior estava incorreta — não há ref a verificar.)"},
				{type: "stakeholder-map", rationale: "(P) Sem ref cross-file: stakeholders[] são auto-contidos (code/name/type/description/role); shape via cue vet. (Categoria def-002 anterior estava incorreta.)"},
				{type: "policy", rationale: "(sem instâncias) Nenhuma instância domain/policies/pol-*.cue existe ainda — sem o que checar. Quando materializar (trigger refs a events), autorar cross-file-id-exists contra o vocabulário de events canonizado (adr-104)."},
				{type: "wave-plan", rationale: "(follow-on) Integridade de dependsOn (WI→WI) é expressável intra-arquivo via local-field-reference-integrity (adr-100); autoria adiada para focar este pass em zerar+promover."},
				{type: "deferred-decision", rationale: "(follow-on) originatingArtifacts/resolvedBy são #OriginRef (path .cue OU session:); verificação de path exige filesystem-path-exists com discriminação de session: — enhancement futuro."},
				{type: "adopted-artifacts", rationale: "(follow-on) artifacts[].artifact são paths em lista-de-structs; exige iteração nested em filesystem-path-exists (não suportada em V1) — enhancement futuro."},
			]
		}
		errorMessage: "tipo governado '{nome}' não tem nenhum structural-check (artifactType correspondente) e não consta em exemptTypes. Adicione um check comportamental OU registre a isenção em exemptTypes com rationale (cobertura só de cue vet + gate de órfão é decisão, não acidente)."
		rationale:    "adr-099 M2: gêmeo do sc-pg-01, mas derivando o conjunto de tipos em vez de autorá-lo (a whitelist coveredSchemas do sc-pg-01 é ela própria superfície de drift). Surface a lacuna real de cobertura comportamental — ~23 de 31 tipos hoje — como backlog explícito."
		enforcement: "reject"
	}
}
