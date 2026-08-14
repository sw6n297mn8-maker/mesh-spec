package npm

// am-participant.cue -- AggregateManifest do agg-participant (fatia
// M7/adr-193: a superfície do npm que a ds-buyer-procurement-journey
// exige; molde am-sourcing-process, classe instanciação -- precedente
// eea3c4d/PR #247).
//
// Instancia de #AggregateManifest (adr-144). Per adr-141 item 5: declara a
// SUPERFICIE do aggregate. Sexta+ instancia do tipo (precedentes:
// am-commitment, am-verification, am-payment, am-purchase-requisition,
// am-sourcing-process, am-purchase-order).
//
// Listas commandsAccepted/eventsEmitted/invariants copiadas VERBATIM de
// contexts/npm/domain-model.cue agg-participant (handlesCommands/
// emitsEvents/protectsInvariants) -- diff programatico no checkpoint
// (zero-drift). COBERTURA COMPLETA: o npm tem 1 aggregate central; o
// manifest nasce inteiro (molde ssc, diferente da fatia parcial original
// do p2p).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

aggregateManifest: artifact_schemas.#AggregateManifest & {
	id:           "am-participant"
	name:         "Participant"
	aggregateRef: "agg-participant"

	// 7 commands verbatim de agg-participant.handlesCommands (6 de
	// fronteira do canvas + 1 interno para policy ACL).
	commandsAccepted: [
		"cmd-register-participant",
		"cmd-submit-qualification-documents",
		"cmd-approve-qualification",
		"cmd-suspend-participant",
		"cmd-reactivate-participant",
		"cmd-terminate-participant",
		"cmd-record-identity-verification",
	]

	// 7 events verbatim de agg-participant.emitsEvents (5 published de
	// lifecycle/registro + 1 internal workflow + 1 internal ACL -received
	// de IDC -- listado per tq-dm-02, semanticamente produzido pelo ACL
	// adapter, convenção mantida do domain-model).
	eventsEmitted: [
		"evt-participant-registered",
		"evt-participant-qualified",
		"evt-participant-suspended",
		"evt-participant-terminated",
		"evt-participant-reactivated",
		"evt-qualification-documents-received",
		"evt-identity-verification-received",
	]

	// 6 invariants verbatim de agg-participant.protectsInvariants (gate
	// binário de qualificação; verificação IDC como pré-condição;
	// terminação irreversível; supervisão para decisões materiais;
	// completude cadastral; unicidade de identidade ativa).
	invariants: [
		"inv-qualification-gate",
		"inv-approval-requires-identity-verification",
		"inv-termination-irreversible",
		"inv-supervision-required-for-material-decisions",
		"inv-registration-completeness",
		"inv-single-active-identity",
	]

	// Coerente com pm-npm: EventLogPort (persistencia OCC + replay do
	// agg-participant; uso-forte). A consulta a IDC
	// (QueryIdentityVerificationStatus, pré-condição de aprovação) é
	// interação sync de canvas query-dependency (adr-055), não Port --
	// fora deste manifest.
	portsRequired: ["EventLogPort"]

	generatedArtifacts: [{
		kind:        "aggregate-skeleton"
		description: "Aggregate base/skeleton do Participant derivado deste manifest (adr-141 item 5): estados do lifecycle (pending, qualified, suspended, terminated -- #ParticipantState reusado dos schemas, disjuncao fechada com fidelidade a constraint do vo-participant-status), handlers dos 7 commands, emissao dos 7 events declarados, guards das 6 invariants nas 6 transicoes. Criacao via initialState=pending (cmd-register-participant e nascimento-com-evento; #Lifecycle nao tem create transition -- mesmo padrao do submit p2p / open-rfq ssc)."
		rationale:   "Nome do kind = stage aggregate-skeleton do codegen-contract (transform: from AggregateManifest). Com esta fatia o discovery do gerador (rtd-013) passa a pegar o NPM (schemas + manifests presentes) -- o degrau runtime da fatia do participante (M7)."
	}]

	rationale: "SoT spec-side da SUPERFICIE do agg-participant (per-aggregate, adr-141 item 5): 7 commands, 7 events e 6 invariants verbatim do domain-model do NPM (extracao com diff verificado no checkpoint). portsRequired coerente com pm-npm (EventLogPort uso-forte; consulta IDC e canvas query-dependency per adr-055, nao Port). Cobertura COMPLETA do BC (1 aggregate central) -- sem fatia parcial a expandir. Classe INSTANCIACAO (missao M7/adr-193): semantica do participant ja decidida no domain-model; este manifest apenas abre a superficie de codegen -- o fornecedor qualificado que sustenta o pool do ssc na ds-buyer-procurement-journey. Ativa sc-mri-02 para o NPM."
}
