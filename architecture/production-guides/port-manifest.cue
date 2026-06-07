package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// port-manifest.cue — Production guide para PortManifest (adr-144).
//
// Schema alvo: #PortManifest (architecture/artifact-schemas/port-manifest.cue).
// Cardinality collection — um PortManifest por BC que consome Port, em
// contexts/{bc}/port-manifest.cue. Cascade ordering (adr-054 dec 13 / sc-pg-01):
// este PG existe ANTES de qualquer instancia de PortManifest (WI-140).
//
// c-puro (adr-144): o autor preenche a SUPERFICIE spec-side (Ports consumidos,
// operations, obrigacoes de test/adapter). A conformance interface-Kotlin <->
// manifest NAO e autorada aqui (vive em mesh-runtime, def-050).

portManifestGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/port-manifest\\.cue$"
			fileNameRegex:      "^port-manifest\\.cue$"
			description:        "Production guide para autoria de PortManifest (per-BC) em mesh-spec."
			rationale:          "#PortManifest e instanciavel (cardinality collection); sc-pg-01 exige PG antes de instancia. Cascade ordering (adr-054 dec 13): PG precede as instancias de WI-140."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-pmg-01"
			description: "Guide forca portsConsumed subconjunto dos 5 Ports, operations ligadas a Port consumido, e boundedContextRef verificado"
			test:        "Process exige: portsConsumed entre os 5 #PortRef; cada operation.port pertence a portsConsumed; boundedContextRef aponta para BC existente (verificado por filesystem). Hardening de tq-pm-01/tq-pm-02 do schema pelo lado de processo."
			severity:    "fail"
			rationale:   "Operation sobre Port nao-consumido ou BC inexistente e contrato fantasma; o agente tende a preencher Ports/operations por inferencia sem verificar consumo real."
		}, {
			id:          "tq-pmg-02"
			description: "Guide proibe modelar conformance interface<->manifest (c-puro / def-050)"
			test:        "gapPolicy declara que a verificacao interface-Kotlin <-> PortManifest NAO e autorada no manifest spec-side (vive em mesh-runtime, def-050). O autor preenche so a superficie spec-side; nao inventa campos de interface Kotlin."
			severity:    "fail"
			rationale:   "adr-144 c-puro: o manifest e SoT spec-side, a interface e projecao verificada em runtime. Misturar a conformance runtime no manifest re-introduziria o overclaim que adr-144 corrigiu."
		}]
		rationale: "2 criterios cobrem as disciplinas centrais de autoria de PortManifest: coerencia spec-side (portsConsumed/operations/BC, hardening de tq-pm-01/02) e respeito ao boundary c-puro (conformance runtime fica em def-050). tq-pm-01/02 do schema cobrem a instancia; tq-pmg-XX cobrem o processo de autoria."
	}

	prerequisites: {
		description: "Antes de autorar um PortManifest, o agente le o schema #PortManifest, o adr-141 (item 5/6: superficie de Port, contract-tests, reference adapter), e o canvas/domain-model do BC para saber quais Ports ele consome. PortManifest documenta a superficie spec-side de Port consumida pelo BC — nao a interface Kotlin (runtime, def-050)."
		collectFromFounder: [
			"boundedContextRef: code do BC que consome os Ports — verificar que o BC existe (canvas/domain-model em contexts/{bc}/). Agente NAO inventa BC.",
			"portsConsumed: quais dos 5 Ports canonicos (EventLogPort/LedgerPort/WorkflowPort/DeliveryPort/EvidencePort) o BC consome — subconjunto, >=1.",
			"operations por Port: nome (camelCase) + tipos-canon de entrada/saida (nomes de value class). Sao nomes spec-side; PortResult<T> envelopa a saida no runtime, nao se modela aqui.",
			"adaptersForGoldenExample: quais stubs/adapters o golden-example precisa para subir atras de cada Port (adr-141 item 6).",
			"contractTestsRequired: contract-tests obrigatorios por Port — Tier 1 (gerado) e/ou Tier 2 (comportamental), per adr-141 item 6.",
			"referenceAdapterRequired: obrigacao de reference adapter (default true; adr-141 item 6 — cada Port tem reference adapter in-memory).",
		]
		gapPolicy:     "Se o founder nao consegue dizer quais Ports o BC consome, NAO autore — o BC pode nao consumir Port (entao nao tem PortManifest). NAO inclua Port fora dos 5 #PortRef. NAO declare operation sobre Port que nao esta em portsConsumed (tq-pm-01 fail). NAO invente boundedContextRef — verifique que o BC existe. NAO modele a conformance interface-Kotlin <-> manifest aqui: ela vive em mesh-runtime (def-050); o manifest spec-side so declara a superficie. NAO confunda operations de Port (infra: append, readStream) com commands/queries de dominio (esses vivem no service-contract). Quando duvida, pergunte ao founder; nunca preencha por inferencia."
		validatorNote: "Em Phase 0: (a) cue vet para shape (#PortRef membership, regex de id, list.UniqueItems); (b) founder review semantico; (c) pos-C5: manifest-conformance (well-formedness: operations/test/adapter[].port subset de portsConsumed) + manifest-ref-integrity (boundedContextRef aponta para BC existente, via cross-file-id-exists). A true-coverage (todo BC-que-consome-Port tem PortManifest) e deferida a def-051; a conformance interface<->manifest e gate de mesh-runtime (def-050), nao spec-side."
		outputNote:    "Output e contexts/{bc}/port-manifest.cue conformante a #PortManifest. Um por BC (fileNameRegex port-manifest.cue). Tamanho tipico: 40-100 linhas dependendo do numero de Ports/operations."
	}

	workOrder: [
		"ports-and-bc",
		"operations",
		"test-and-adapter-obligations",
		"reference-adapter",
		"rationale-and-validation",
	]

	sections: {
		"ports-and-bc": {
			target:    "#PortManifest"
			objective: "Declarar identity (id pm-<bc>), boundedContextRef (BC consumidor) e portsConsumed (subconjunto dos 5 Ports canonicos)."
			process: [{
				action: "Determinar id pm-<slug>"
				detail: "slug tipicamente o code do BC. Regex: ^pm-[a-z0-9-]+$."
			}, {
				action: "Declarar boundedContextRef verificando o BC"
				detail: "boundedContextRef e o code do BC; verificar que contexts/{bc}/ existe. BC inexistente quebra manifest-ref-integrity."
			}, {
				action: "Listar portsConsumed entre os 5 Ports"
				detail: "Subconjunto de EventLogPort/LedgerPort/WorkflowPort/DeliveryPort/EvidencePort; >=1; sem duplicatas."
			}]
			sources: [
				"architecture/artifact-schemas/port-manifest.cue (#PortManifest, #PortRef)",
				"contexts/{bc}/canvas.cue + domain-model.cue (quais Ports o BC consome)",
				"architecture/adrs/adr-141-runtime-kernel-port-contracts.cue (item 2: os 5 Ports)",
			]
			heuristics: [
				"Um BC que nao consome nenhum Port NAO tem PortManifest — nao force.",
				"portsConsumed reflete consumo real do BC, nao a lista dos 5 por completude.",
			]
			doneCriteria: "id pm-<bc> valido; boundedContextRef de BC existente; portsConsumed nao-vazio e subconjunto dos 5 Ports."
			ifGap:        "Se nao se sabe quais Ports o BC consome, parar e perguntar; nao adivinhar a partir dos 5."
		}
		"operations": {
			target:    "#PortManifest"
			objective: "Declarar as operations necessarias por Port — nome + tipos-canon de entrada/saida — como superficie spec-side bem-formada."
			process: [{
				action: "Para cada Port consumido, listar operations necessarias"
				detail: "Cada operation: port (em portsConsumed), name (camelCase), inputs (nomes de value class), output (nome de value class). PortResult<T> e envelope de runtime, nao modelado."
			}, {
				action: "Verificar que cada operation.port esta em portsConsumed"
				detail: "Operation sobre Port nao-consumido falha tq-pm-01 (well-formedness spec-side)."
			}]
			sources: [
				"architecture/artifact-schemas/port-manifest.cue (#PortOperation)",
				"architecture/adrs/adr-141-runtime-kernel-port-contracts.cue (item 5: operations necessarias)",
			]
			heuristics: [
				"operations sao da superficie de Port (infra), nao commands/queries de dominio (service-contract).",
				"inputs/output sao nomes de value class (canon), nao tipos CUE unificados — o canon vive no runtime.",
			]
			doneCriteria: "cada operation tem port em portsConsumed, name camelCase, inputs e output preenchidos."
			ifGap:        "Se a operation necessaria nao e clara, derivar do uso real do Port pelo BC; nao inventar superficie generica."
		}
		"test-and-adapter-obligations": {
			target:    "#PortManifest"
			objective: "Declarar adaptersForGoldenExample (stubs que o golden-example precisa) e contractTestsRequired (Tier 1/2 por Port)."
			process: [{
				action: "Listar adaptersForGoldenExample por Port"
				detail: "Quais stubs/adapters o golden-example precisa para subir atras de cada Port consumido (adr-141 item 6)."
			}, {
				action: "Listar contractTestsRequired por Port com tier"
				detail: "tier 1 (gerado, derivado do manifest + taxonomia de erro) e/ou tier 2 (comportamental hand-authored: concurrency, atomicidade, lease/ack, content-addressability, durable execution) per adr-141 item 6."
			}]
			sources: [
				"architecture/artifact-schemas/port-manifest.cue (#AdapterStubRequirement, #ContractTestRequirement)",
				"architecture/adrs/adr-141-runtime-kernel-port-contracts.cue (item 6: contract-tests dois tiers)",
			]
			heuristics: [
				"Tier 2 e comportamental (invariante temporal que o schema nao captura), por isso hand-authored.",
				"adapter/test sobre Port nao-consumido e incoerente (tq-pm-02).",
			]
			doneCriteria: "adaptersForGoldenExample e contractTestsRequired referenciam apenas Ports em portsConsumed; tiers declarados."
			ifGap:        "Se nao se sabe quais contract-tests sao obrigatorios, derivar da semantica do Port (adr-141 item 6); nao omitir Tier 2 comportamental por conveniencia."
		}
		"reference-adapter": {
			target:    "#PortManifest"
			objective: "Declarar referenceAdapterRequired — a obrigacao in-spec de reference adapter (adr-141 item 6)."
			process: [{
				action: "Declarar referenceAdapterRequired"
				detail: "Default true (cada Port tem reference adapter in-memory vendor-agnostico — spec executavel + stub do golden-example + oracle, adr-141 item 6). A implementacao do adapter vive em mesh-runtime, fora do manifest."
			}]
			sources: [
				"architecture/adrs/adr-141-runtime-kernel-port-contracts.cue (item 6: reference adapter)",
			]
			heuristics: [
				"A obrigacao e declarada in-spec; a implementacao e runtime — nao modelar a implementacao aqui.",
			]
			doneCriteria: "referenceAdapterRequired declarado (tipicamente true) coerente com adr-141 item 6."
			ifGap:        "Se ha duvida sobre dispensar reference adapter para algum Port, escalar — adr-141 item 6 trata como universal."
		}
		"rationale-and-validation": {
			target:    "#PortManifest"
			objective: "Compor o rationale do manifest e revisar a coerencia spec-side antes de submeter."
			process: [{
				action: "Compor rationale do manifest"
				detail: "Por que este BC consome estes Ports com estas operations — ancorado no uso real do BC, nao generico."
			}, {
				action: "Revisar o boundary c-puro"
				detail: "Confirmar que nenhum campo modela a conformance interface-Kotlin <-> manifest (def-050); o manifest e so a superficie spec-side."
			}]
			sources: [
				"architecture/adrs/adr-144-manifest-artifact-governance.cue (c-puro; N4; def-050)",
			]
			heuristics: [
				"rationale explica o consumo, nao repete os campos.",
				"Se aparece 'interface conforma ao manifest' no rationale, e overclaim — remover (def-050).",
			]
			doneCriteria: "rationale substantivo; zero referencia a conformance interface<->manifest como gate spec-side."
			ifGap:        "Se o rationale fica generico, ancorar no uso concreto do Port pelo BC."
		}
	}

	finalValidation: {
		steps: [
			"Verificar shape: instancia valida contra #PortManifest (id/regex, #PortRef membership em portsConsumed, UniqueItems, campos required presentes).",
			"Verificar tq-pg-01: workOrder e permutacao exata das chaves de sections (5 sections).",
			"Verificar tq-pg-02: cada section.target = #PortManifest (existe no schema).",
			"Verificar tq-pmg-01: portsConsumed subconjunto dos 5 Ports; cada operation/test/adapter.port em portsConsumed; boundedContextRef de BC existente.",
			"Verificar tq-pmg-02 (c-puro): nenhum campo modela conformance interface-Kotlin <-> manifest (fica em def-050).",
			"Submeter ao founder para aprovacao explicita antes de commit (gate humano, adr-057).",
		]
	}
}
