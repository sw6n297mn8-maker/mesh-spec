package artifact_schemas

// frontend-codegen-contract.cue — Schema first-class do contrato de
// codegen spec→frontend-runtime (adr-180; gatilho adr-178 D3; conteúdo
// obrigatório per mandato adr-179).
//
// O CORAÇÃO DO MANDATO: famílias de superfície como união discriminada
// por CAPACIDADE com exclusão mútua POR SHAPE — defs CUE fecham structs
// por default e a extensão é por EMBEDDING: (a) #ReadOnlyFamily NÃO
// possui o campo actions — a presença de qualquer capacidade de command
// num ramo read-only é REJEITADA pelo cue vet; (b) #ActionBearingFamily
// EXIGE actions ≥1, e cada #Action carrega os 3 slots do adr-179 POR
// CONSTRUÇÃO (os slots vivem NA definição da action — Action-as-Tool
// literal: uma definição). Command sem slots e action-surface sem
// command são ambos impossíveis por shape. Zero nomes concretos de
// famílias neste schema: tudo deriva de capacidade tipada
// (falsificationCondition do adr-179).

#ViewRegime: "generated" | "hand-grandfathered"

#GenerativeFormOrigin: "system" | "net-new"

#ReadSurface: #QueryBackedReadSurface | #CanvasBackedReadSurface

// Leitura ancorada em query capability formal do domain-model —
// obrigatória para TODA view no regime generated.
#QueryBackedReadSurface: {
	queryRef:   string & =~"^qry-[a-z][a-z0-9-]*$"
	view:       string & !=""
	viewRegime: #ViewRegime
	rationale:  string & !=""
}

// Leitura ancorada em canvas query-surface (sem qry-* formal no
// domain-model) — EXCLUSIVA do legado hand-grandfathered (a fila
// escalada da 1ª família): o shape FORÇA o regime, tornando view
// GERADA sem query capability formal impossível por construção.
#CanvasBackedReadSurface: {
	canvasSurfaceRef: string & !=""
	view:             string & !=""
	viewRegime:       "hand-grandfathered"
	rationale:        string & !=""
}

// Uma AÇÃO da família — a unidade que carrega os 3 slots do mandato
// adr-179 por construção.
#Action: {
	commandRef: #CommandRef

	// Slot (a) — Action-as-Tool (adr-150 dec 2a).
	actionPairing: {
		description: string & !=""
		rationale:   string & !=""
	}

	// Slot (b) — confirmação estruturada (adr-150 dec 2c); quando
	// dinheiro move, Approval-as-Confirmation por CONSTRAINT.
	// returnsEvents é lista ≥1: commands com desfechos alternativos
	// devolvem oneOf de eventos (o resolve da 1ª família devolve 2 —
	// fidelidade FCE que o singular perderia).
	confirmation: {
		returnsEvents: [#EventRef, ...#EventRef]
		movesMoney:             bool
		approvalAsConfirmation: bool
		rationale:              string & !=""
	}
	if confirmation.movesMoney {
		confirmation: approvalAsConfirmation: true
	}

	// Slot (c) — Generative Form (adr-150 dec 2b); net-new exige
	// justificativa + migração (adr-178; classe def-081).
	generativeForm: {
		origin:               #GenerativeFormOrigin
		prefillNote:          string & !=""
		netNewJustification?: string & !=""
		migrationRef?:        string & =~"^def-[0-9]{3}$"
		rationale:            string & !=""
	}
	if generativeForm.origin == "net-new" {
		generativeForm: netNewJustification: string & !=""
		generativeForm: migrationRef:        string & =~"^def-[0-9]{3}$"
	}

	rationale: string & !=""
}

#SurfaceFamilyBase: {
	boundedContextRef: #BoundedContextRef
	sourceModel:       string & !=""
	rationale:         string & !=""
}

#ActionBearingFamily: {
	#SurfaceFamilyBase
	kind: "action-bearing"
	actions: [#Action, ...#Action]
	aggregateRef: #AggregateRef
	lifecycleStates: [...string]
	valueObjects: [...#ValueObjectRef]
	events: [...#EventRef]
	readSurfaces?: [#ReadSurface, ...#ReadSurface]
}

#ReadOnlyFamily: {
	#SurfaceFamilyBase
	kind: "read-only"
	readSurfaces: [#ReadSurface, ...#ReadSurface]
}

#SurfaceFamily: #ActionBearingFamily | #ReadOnlyFamily

#FrontendCodegenContract: {
	version: string & !=""
	status: "proposed" | "accepted"
	authorizedBy: [string & =~"^adr-[0-9]{3}$", ...string & =~"^adr-[0-9]{3}$"]
	uxSemantics: {
		source: string & !=""
		provides: [string & !="", ...string & !=""]
		rationale: string & !=""
	}
	families: [ID=string]: #SurfaceFamily
	contractGate: {
		authority: string & !=""
		binding:   string & !=""
		validates: [string & !="", ...string & !=""]
		mechanism:           string & !=""
		breakOnSchemaChange: string & !=""
		runsIn:              string & !=""
		scope:               string & !=""
	}
	output: {
		artifacts: [string & !="", ...string & !=""]
		livesIn:       string & !=""
		committedHere: false
		goldenExample: string & !=""
	}
	activeBoundaries: [...string & =~"^def-[0-9]{3}$"]
	rationale: string & !=""

	_schema: {
		location: {
			canonicalPathRegex: "^governance/build-time/frontend-codegen-contract\\.cue$"
			fileNameRegex:      "^frontend-codegen-contract\\.cue$"
			description:        "Contrato declarativo de codegen spec→frontend-runtime: famílias de superfície com aplicabilidade tipada do action-surface (mandato adr-179)."
			rationale:          "A instância vive no lar histórico em governance/build-time (P0: zero movimentação na promoção, adr-180); singleton."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: #QualityCriteria & {
		criteria: [{
			id:          "tq-fcc-01"
			description: "Família action-bearing carrega os 3 slots substantivos por action"
			test:        "Para cada families[*] com kind action-bearing: cada actions[] tem actionPairing.description, confirmation.rationale e generativeForm.prefillNote SUBSTANTIVOS (específicos ao command), e returnsEvents/commandRef apontam ids reais do sourceModel."
			severity:    "fail"
			rationale:   "O shape garante presença; este critério guarda a SUBSTÂNCIA — slot com placeholder derrota o mandato adr-179 tanto quanto slot ausente."
		}, {
			id:          "tq-fcc-02"
			description: "Origem net-new demonstra fonte-fora-do-sistema e ancora migração"
			test:        "Para cada action com generativeForm.origin=='net-new': netNewJustification DEMONSTRA que a informação não existe no sistema até o ato (critério adr-178, não alegação), e migrationRef aponta def existente cujo tema é a migração dessa origem."
			severity:    "fail"
			rationale:   "O não-padrão net-new é precedente poderoso (adr-178 N3) — a demonstração e a âncora de revisita o separam de digitação-por-preguiça."
		}, {
			id:          "tq-fcc-03"
			description: "Classificação movesMoney fiel ao domínio"
			test:        "Para cada action: movesMoney reflete o domínio do command (autoriza/move/reserva valor financeiro ⇒ true), verificado contra o domain-model do sourceModel."
			severity:    "fail"
			rationale:   "A constraint movesMoney⇒approvalAsConfirmation só protege se a classificação for verdadeira — P10 em pixel depende deste julgamento."
		}, {
			id:          "tq-fcc-04"
			description: "hand-grandfathered restrito ao legado pré-adr-180"
			test:        "Toda readSurface hand-grandfathered corresponde a view hand existente ANTES do adr-180 (fila escalada da 1ª família, canvas-backed; fila da 2ª, query-backed). Família/view NOVA com regime hand viola adr-180 dec 3; canvas-backed fora de hand-grandfathered é impossível por shape."
			severity:    "warn"
			rationale:   "O grandfathering ilumina dívida, não a cria — regime hand em superfície nova reabriria o buraco que a promoção fechou."
		}]
		rationale: "4 critérios guardam o que o shape não alcança: substância dos slots, demonstração do net-new, fidelidade do movesMoney, contenção do grandfathering."
	}
}
