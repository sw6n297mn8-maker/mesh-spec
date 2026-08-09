package artifact_schemas

import "list"

// verifier-types.cue — Verifier Registry: identidade, capacidade,
// autoridade e lifecycle de adjudicadores governados (D8, adr-009).
//
// #VerifierRegistry é instanciável (singleton do portfólio, home
// allocator/verifier-registry.cue). Type-library sem _schema.location
// próprio por decisão de packaging do adr-009 — a instância é validada
// por cue vet ./allocator/. Isenção "backlog" em _exemptions.cue.
//
// TRUST ROOT — event-sourced (D8). O estado canônico do registry NÃO é um
// snapshot mutável de lifecycle/grants: é a história append-only de eventos
// (#VerifierRegistryEvent). lifecycle e grants efetivos são PROJEÇÃO dessa
// história. Duas camadas de enforcement:
//  - estrutural (cue vet, este arquivo): register-once, referência válida,
//    grant-coverage, forward-only por construção (sem evento de reativação);
//  - temporal (CI, scripts/ci/check-verifier-append-only.sh): base.events é
//    prefixo de candidate.events — apagar/editar/reordenar história é
//    rejeitado. cue só vê o snapshot; a propriedade append-only vive no gate.
// O contrato (identidade por digest, #VerifierContract) é imutável; só
// eventos governados modificam o registry, sob #AuthorityDomain
// "verifier-governance".
//
// Régua (adr-009): capability ≠ authority. Identidade imutável por digest;
// capacidade declarada no contrato; autoridade concedida por grant (evento).
// Adjudicador read-only.

// #VerifierId — identidade estável do verifier (nome, estável entre versões).
#VerifierId: string & =~"^vrf-[a-z][a-z0-9-]*$"

// #VerifierRef — referência pinada: identidade + versão + revisão (digest
// imutável). É o load-bearing das provas (evidence-types.cue).
#VerifierRef: {
	id!:       #VerifierId
	version!:  int & >=1
	revision!: string & =~"^[0-9a-f]{7,64}$"
}

// #VerifierVersionRef — referência à VERSÃO pinada (id, version). É a chave
// de governança do registry (lifecycle e grants operam nesta granularidade,
// não em id). O digest (revision) da versão é fixado no verifier-registered
// e imutável; (id, version) mapeia unicamente para ele.
#VerifierVersionRef: {
	id!:      #VerifierId
	version!: int & >=1
}

// #EvidenceIntegrity — postura de integridade da evidência. Vive no
// CONTRATO do verifier, não no TaskSpec (D3).
#EvidenceIntegrity: "reproducible" | "captured" | "attested"

// #VerifierLifecycle — estado projetado da história (NÃO campo editável).
// forward-only: active → deprecated → revoked, terminal (sem reativação).
#VerifierLifecycle: "active" | "deprecated" | "revoked"

// #AssertionSchemaRef — referência ao schema do assertionPayload que o
// verifier consome. NUNCA requirementClass nem string livre (seria
// proofKind disfarçado — condição travada do adr-009).
#AssertionSchemaRef: string & =~"^asch-[a-z][a-z0-9-]*$"

// #VerifierContract — contrato IMUTÁVEL de uma VERSÃO (identidade por digest
// + capacidade). Não carrega lifecycle: lifecycle é projeção da história.
#VerifierContract: {
	ref!:                #VerifierRef
	assertionSchemaRef!: #AssertionSchemaRef
	evidenceIntegrity!:  #EvidenceIntegrity
	resultSemantics!:    string & !=""
	readOnly!:           true
	rationale!:          string & !=""
}

// #VerifierGrant — concessão de autoridade a uma VERSÃO para um assertion
// schema. capability (contract) ≠ authority (grant).
#VerifierGrant: {
	verifierRef!:        #VerifierVersionRef
	assertionSchemaRef!: #AssertionSchemaRef
	rationale!:          string & !=""
}

// #MandatoryVerifier — verifier exigido por um #TaskTemplate (aditivo em
// task-template.cue). Exige por id (nome); a task escolhe a versão.
#MandatoryVerifier: {
	verifierId!: #VerifierId
	rationale!:  string & !=""
}

// ── Eventos de governança do registry (D8) ──
// Append-only. A ÚNICA forma normativa de modificar o registry. Não há
// evento de reativação (por construção): lifecycle é forward-only. Eventos
// não-register operam na granularidade (id, version) — #VerifierVersionRef.
#VerifierRegistryEvent:
	#VerifierRegisteredEvent |
	#VerifierDeprecatedEvent |
	#VerifierRevokedEvent |
	#VerifierGrantedEvent |
	#VerifierGrantRevokedEvent

// verifier-registered — introduz o contrato imutável de uma (id, version).
// Uma nova versão é uma nova (id, version) com novo digest, registrada por
// seu próprio verifier-registered (não há evento verifier-versioned).
#VerifierRegisteredEvent: {
	event!:     "verifier-registered"
	contract!:  #VerifierContract
	rationale!: string & !=""
}
#VerifierDeprecatedEvent: {
	event!:       "verifier-deprecated"
	verifierRef!: #VerifierVersionRef
	rationale!:   string & !=""
}
#VerifierRevokedEvent: {
	event!:       "verifier-revoked"
	verifierRef!: #VerifierVersionRef
	rationale!:   string & !=""
}
#VerifierGrantedEvent: {
	event!:              "verifier-granted"
	verifierRef!:        #VerifierVersionRef
	assertionSchemaRef!: #AssertionSchemaRef
	rationale!:          string & !=""
}
#VerifierGrantRevokedEvent: {
	event!:              "verifier-grant-revoked"
	verifierRef!:        #VerifierVersionRef
	assertionSchemaRef!: #AssertionSchemaRef
	rationale!:          string & !=""
}

// #VerifierRegistry — singleton do portfólio. Estado canônico = events
// (append-only vs história Git — enforçado por scripts/ci/
// check-verifier-append-only.sh; ver D8). lifecycle/grants efetivos =
// projeção, granularidade (id, version). Invariantes estruturais (bitem em
// cue vet):
//  U — re-registrar (id, version) já registrada é rejeitado (register-once);
//      com a ausência de evento de reativação, torna revoked/deprecated →
//      active irrepresentável pelo caminho canônico;
//  R — todo evento não-register referencia (id, version) registrada;
//  C — toda VERSÃO não-revogada deve ter grant efetivo para o
//      assertionSchemaRef que seu contrato declara (capability exige
//      authority; capability sem grant não é vacuamente aceita).
// Terminalidade: grant-revoke de (id, version, assertionSchemaRef) é
// terminal — presença histórica em grant-revoked vence qualquer grant.
// Reconceder exige uma nova VERSÃO do verifier (nova (id, version)).
#VerifierRegistry: {
	events!: [...#VerifierRegistryEvent]

	// contratos registrados, indexados por (id, version) — "id::version".
	_contracts: {for e in events if e.event == "verifier-registered" {"\(e.contract.ref.id)::\(e.contract.ref.version)": e.contract}}

	// (U) register-once por (id, version).
	_regKeys: [for e in events if e.event == "verifier-registered" {"\(e.contract.ref.id)::\(e.contract.ref.version)"}]
	_uniqueRegister: true & (len(_regKeys) == len(_contracts))

	// (R) todo evento não-register referencia (id, version) registrada.
	_refsValid: [for e in events if e.event != "verifier-registered" {
		true & list.Contains(_regKeys, "\(e.verifierRef.id)::\(e.verifierRef.version)")
	}]

	// projeção de lifecycle por versão.
	_revoked: {for e in events if e.event == "verifier-revoked" {"\(e.verifierRef.id)::\(e.verifierRef.version)": true}}
	_deprecated: {for e in events if e.event == "verifier-deprecated" {"\(e.verifierRef.id)::\(e.verifierRef.version)": true}}

	// projeção de grants efetivos por (versão, asch): granted ∧ ¬grant-revoked.
	_granted: {for e in events if e.event == "verifier-granted" {"\(e.verifierRef.id)::\(e.verifierRef.version)::\(e.assertionSchemaRef)": true}}
	_grantRevoked: {for e in events if e.event == "verifier-grant-revoked" {"\(e.verifierRef.id)::\(e.verifierRef.version)::\(e.assertionSchemaRef)": true}}

	// projection — estado efetivo derivado (read-only, materialização).
	projection: {
		lifecycle: {
			for key, _ in _contracts {
				"\(key)": [
					if (_revoked[key] != _|_) {"revoked"},
					if (_revoked[key] == _|_) if (_deprecated[key] != _|_) {"deprecated"},
					if (_revoked[key] == _|_) if (_deprecated[key] == _|_) {"active"},
				][0]
			}
		}
		effectiveGrantKeys: [for k, _ in _granted if _grantRevoked[k] == _|_ {k}]
	}

	// (C) grant-coverage: versão não-revogada deve ter grant efetivo para o
	// assertionSchemaRef declarado no seu contrato.
	_capabilityCovered: [for key, c in _contracts if projection.lifecycle[key] != "revoked" {
		true & list.Contains(projection.effectiveGrantKeys, "\(key)::\(c.assertionSchemaRef)")
	}]
}
