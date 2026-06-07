package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// aggregate-manifest.cue — Production guide para AggregateManifest (adr-144).
//
// Schema alvo: #AggregateManifest (architecture/artifact-schemas/aggregate-manifest.cue).
// Cardinality collection — um AggregateManifest por aggregate, em
// contexts/{bc}/aggregate-manifests/am-<slug>.cue. Cascade ordering
// (adr-054 dec 13 / sc-pg-01): este PG existe ANTES de qualquer instancia (WI-140).
//
// c-puro (adr-144): commands/events/invariants sao IDS (cmd-*/evt-*/inv-*). A
// existencia dos ids no domain-model do BC e sc-check buildavel DEFERIDO a
// def-052 (decisao plain-vs-instance-scoped pendente), NAO unificacao CUE — o
// autor declara os ids e confere na origem; nao tenta enforcar no manifest. O
// subset-do-canon runtime (canon/command, canon/event) e conceito distinto,
// cross-repo, NAO CUE-referenciavel (adr-144 C1).

aggregateManifestGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/aggregate-manifest\\.cue$"
			fileNameRegex:      "^aggregate-manifest\\.cue$"
			description:        "Production guide para autoria de AggregateManifest (per-aggregate) em mesh-spec."
			rationale:          "#AggregateManifest e instanciavel (cardinality collection); sc-pg-01 exige PG antes de instancia. Cascade ordering (adr-054 dec 13): PG precede as instancias de WI-140."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-amg-01"
			description: "Guide forca aggregateRef e ids (cmd/evt/inv) verificados no domain-model; portsRequired subconjunto dos 5"
			test:        "Process exige: aggregateRef aponta para aggregate existente no domain-model do BC; commandsAccepted/eventsEmitted/invariants verificados existentes no domain-model do BC ANTES de incluir; portsRequired entre os 5 #PortRef. Hardening de tq-am-01/tq-am-02 do schema pelo lado de processo."
			severity:    "fail"
			rationale:   "O agente tende a inventar ou aproximar ids de command/event/invariant para fechar o manifest; id que nao existe no domain-model e contrato fantasma (capturado por def-052 quando materializado, mas o PG previne na origem)."
		}, {
			id:          "tq-amg-02"
			description: "Guide ancora o boundary c-puro: ids, nao unificacao com canon"
			test:        "gapPolicy declara que commands/events sao IDS declarados (cmd-*/evt-*); a existencia no domain-model e cross-file, sc-check buildavel DEFERIDO a def-052, NAO unificacao CUE no manifest; o subset-do-canon runtime e conceito distinto (o canon e codegen/runtime, nao CUE-referenciavel global per adr-144 C1). O autor nao tenta enforcar nenhum dos dois no manifest."
			severity:    "fail"
			rationale:   "adr-144 c-puro / C1: separar shape (schema, agora) de existencia cross-file (def-052, deferida) evita re-introduzir a tentativa de unificar com um canon runtime que nao existe como artefato CUE."
		}]
		rationale: "2 criterios cobrem as disciplinas centrais de autoria de AggregateManifest: ancoragem dos ids no domain-model real (hardening de tq-am-01/02) e respeito ao boundary c-puro (existencia e def-052/cross-file deferida; subset-do-canon runtime e cross-repo; nenhum se unifica no manifest). tq-am-01/02 do schema cobrem a instancia; tq-amg-XX cobrem o processo de autoria."
	}

	prerequisites: {
		description: "Antes de autorar um AggregateManifest, o agente le o schema #AggregateManifest, o adr-141 (item 5: o que o manifest declara), e o domain-model do BC (aggregate, commands, events, invariants reais). AggregateManifest documenta a superficie de um aggregate como SoT spec-side da qual o codegen deriva o aggregate base."
		collectFromFounder: [
			"aggregateRef: o aggregate (agg-*) no domain-model do BC que este manifest descreve — verificar existencia ANTES de incluir.",
			"name: nome legivel do aggregate.",
			"commandsAccepted: ids cmd-* aceitos pelo aggregate — verificar que existem no domain-model do BC (o gate automatico da existencia e def-052, deferido, mas verifique na origem).",
			"eventsEmitted: ids evt-* emitidos pelo aggregate — idem verificacao.",
			"invariants: ids inv-* relevantes — idem verificacao.",
			"portsRequired: quais dos 5 Ports o aggregate requer (subconjunto, pode ser vazio).",
			"generatedArtifacts: o que o codegen produz a partir deste manifest (ex.: aggregate base).",
		]
		gapPolicy:     "NAO invente ids de command/event/invariant — verifique existencia no domain-model do BC (contexts/{bc}/domain-model.cue) ANTES de incluir; id inexistente e contrato fantasma (def-052 reprova quando materializado, mas o PG previne na origem). NAO invente aggregateRef — o aggregate deve existir no domain-model. NAO tente enforcar 'subset do canon' por unificacao CUE no manifest: o canon (canon/command, canon/event) e conceito de codegen/runtime, nao artefato CUE-referenciavel global (adr-144 C1) — commands/events sao IDS; a existencia no domain-model e gate buildavel deferido a def-052 (distinto do subset-do-canon runtime). NAO inclua Port fora dos 5 #PortRef em portsRequired. Um AggregateManifest sem command nem event nao tem superficie (tq-am-01 fail) — nao autore manifest vazio. Quando duvida, pergunte ao founder; nunca preencha por inferencia."
		validatorNote: "Em Phase 0: (a) cue vet para shape (#CommandRef/#EventRef/#InvariantRef/#PortRef regexes, #AggregateRef, UniqueItems); (b) founder review semantico; (c) pos-C5: manifest-ref-integrity (aggregateRef aponta para aggregate existente, via cross-file-id-exists). A existencia de commands/events/invariants no domain-model e gate buildavel DEFERIDO a def-052 (nao entra nos 5 checks do C5); a true-coverage (todo aggregate tem AggregateManifest) e deferida a def-051; o subset-do-canon runtime e cross-repo, distinto."
		outputNote:    "Output e contexts/{bc}/aggregate-manifests/am-<slug>.cue conformante a #AggregateManifest. Um por aggregate (fileNameRegex am-<slug>.cue). Tamanho tipico: 30-80 linhas."
	}

	workOrder: [
		"identity-and-aggregate",
		"commands-and-events",
		"invariants-and-ports",
		"generated-artifacts",
		"rationale-and-validation",
	]

	sections: {
		"identity-and-aggregate": {
			target:    "#AggregateManifest"
			objective: "Declarar identity (id am-<slug>, name) e aggregateRef (elo verificado ao aggregate no domain-model do BC)."
			process: [{
				action: "Determinar id am-<slug> e name"
				detail: "slug tipicamente o code do aggregate. Regex id: ^am-[a-z0-9-]+$. name e o nome legivel do aggregate."
			}, {
				action: "Declarar aggregateRef verificando o aggregate"
				detail: "aggregateRef (agg-*) deve existir no domain-model do BC; verificar ANTES de incluir. aggregateRef para aggregate inexistente reprova manifest-ref-integrity (cross-file-id-exists)."
			}]
			sources: [
				"architecture/artifact-schemas/aggregate-manifest.cue (#AggregateManifest, #AggregateRef)",
				"contexts/{bc}/domain-model.cue (aggregates agg-* reais)",
			]
			heuristics: [
				"aggregateRef e o elo verificavel ao domain-model — id aproximado quebra a rastreabilidade.",
				"id do manifest (am-*) e distinto do aggregateRef (agg-*).",
			]
			doneCriteria: "id am-<slug> valido; name preenchido; aggregateRef de aggregate existente no domain-model."
			ifGap:        "Se o aggregate nao existe no domain-model, NAO autore o manifest — primeiro o aggregate precisa existir."
		}
		"commands-and-events": {
			target:    "#AggregateManifest"
			objective: "Declarar commandsAccepted (cmd-*) e eventsEmitted (evt-*) como ids verificados no domain-model do BC."
			process: [{
				action: "Listar commandsAccepted como ids cmd-*"
				detail: "Cada id verificado existente no domain-model do BC. O gate automatico da existencia e def-052 (deferido), mas verifique na origem; nao invente."
			}, {
				action: "Listar eventsEmitted como ids evt-*"
				detail: "Idem: ids evt-* verificados no domain-model. Existencia no domain-model e def-052 (deferida), nao unificacao CUE; subset-do-canon runtime e cross-repo (adr-144 C1)."
			}]
			sources: [
				"architecture/artifact-schemas/aggregate-manifest.cue (#CommandRef, #EventRef)",
				"contexts/{bc}/domain-model.cue + schemas/events.cue (commands/events reais)",
			]
			heuristics: [
				"commands/events sao IDS, nao unificacao com canon — o canon vive no codegen/runtime.",
				"Manifest sem command nem event nao tem superficie (tq-am-01 fail).",
			]
			doneCriteria: "commandsAccepted/eventsEmitted sao ids cmd-*/evt-* verificados no domain-model; ao menos um command ou event presente."
			ifGap:        "Se um id nao existe no domain-model, NAO inclua — corrija o domain-model primeiro ou remova o id."
		}
		"invariants-and-ports": {
			target:    "#AggregateManifest"
			objective: "Declarar invariants (inv-*) relevantes e portsRequired (subconjunto dos 5 Ports)."
			process: [{
				action: "Listar invariants como ids inv-*"
				detail: "ids inv-* relevantes ao aggregate, verificados no domain-model do BC."
			}, {
				action: "Listar portsRequired entre os 5 Ports"
				detail: "Subconjunto de #PortRef; pode ser vazio (aggregate sem dependencia de Port); sem duplicatas."
			}]
			sources: [
				"architecture/artifact-schemas/aggregate-manifest.cue (#InvariantRef, #PortRef)",
				"contexts/{bc}/domain-model.cue (invariants inv-* reais)",
			]
			heuristics: [
				"portsRequired reflete dependencia real do aggregate; vazio e valido.",
				"invariants verificados no domain-model; nao inventar inv-*.",
			]
			doneCriteria: "invariants sao ids inv-* verificados; portsRequired subconjunto dos 5 Ports (ou vazio)."
			ifGap:        "Se nao ha clareza sobre quais Ports o aggregate requer, derivar do domain-model; vazio se nenhum."
		}
		"generated-artifacts": {
			target:    "#AggregateManifest"
			objective: "Declarar generatedArtifacts — o que o codegen produz a partir deste manifest (ex.: aggregate base)."
			process: [{
				action: "Listar generatedArtifacts esperados"
				detail: "Cada um: kind + description. 'o aggregate base gerado deriva do AggregateManifest' (adr-141 item 5 conformance). A geracao vive downstream (codegen, adr-140); aqui se declara o esperado."
			}]
			sources: [
				"architecture/artifact-schemas/aggregate-manifest.cue (#GeneratedArtifact)",
				"architecture/adrs/adr-140-codegen-contracts.cue (pipeline de codegen)",
			]
			heuristics: [
				"generatedArtifacts descreve o output esperado spec-side; a geracao em si e runtime/codegen.",
			]
			doneCriteria: "generatedArtifacts lista os outputs esperados do codegen com kind + description."
			ifGap:        "Se o conjunto de outputs nao e claro, derivar de adr-140 (o que o codegen produz de um aggregate); nao inventar artefatos."
		}
		"rationale-and-validation": {
			target:    "#AggregateManifest"
			objective: "Compor o rationale do manifest e revisar a coerencia spec-side antes de submeter."
			process: [{
				action: "Compor rationale do manifest"
				detail: "Por que este aggregate aceita estes commands, emite estes events, requer estes Ports — ancorado no domain-model, nao generico."
			}, {
				action: "Revisar o boundary c-puro"
				detail: "Confirmar que commands/events sao ids (existencia no domain-model = def-052, deferida) e que nenhum campo tenta unificar com um canon global."
			}]
			sources: [
				"architecture/adrs/adr-144-manifest-artifact-governance.cue (c-puro; C1 commands/events: existencia via def-052)",
			]
			heuristics: [
				"rationale explica a superficie do aggregate, nao repete os ids.",
				"Existencia no domain-model nao se enforca aqui — e def-052 (deferida); subset-do-canon runtime e cross-repo.",
			]
			doneCriteria: "rationale substantivo ancorado no domain-model; ids tratados como ids (nao unificacao)."
			ifGap:        "Se o rationale fica generico, ancorar na semantica concreta do aggregate no domain-model."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instancia valida contra #AggregateManifest (regexes de #CommandRef/#EventRef/#InvariantRef/#PortRef/#AggregateRef, UniqueItems, campos required presentes).",
			"Verificar tq-pg-01: workOrder e permutacao exata das chaves de sections (5 sections).",
			"Verificar tq-pg-02: cada section.target = #AggregateManifest (existe no schema).",
			"Verificar tq-amg-01: aggregateRef + commands/events/invariants verificados no domain-model do BC; portsRequired subconjunto dos 5.",
			"Verificar tq-amg-02 (c-puro): commands/events tratados como ids; existencia no domain-model deixada para def-052 (deferida) e subset-do-canon runtime cross-repo, nao unificacao CUE.",
			"Submeter ao founder para aprovacao explicita antes de commit (gate humano, adr-057).",
		]
	}
}
