package npm

// port-manifest.cue -- PortManifest do NPM (fatia M7/adr-193: a superfície
// do participante que a ds-buyer-procurement-journey exige; molde pm-ssc,
// classe instanciação -- precedente eea3c4d/PR #247).
//
// Instancia de #PortManifest (adr-144). Sexta instancia do tipo
// (precedentes: pm-cmt, pm-dlv, pm-fce, pm-p2p, pm-ssc). EventLogPort per
// adr-141 item 4 (PortManifest = SoT exclusiva da superficie de Port).
//
// A consulta a IDC (QueryIdentityVerificationStatus -- pré-condição de
// ApproveQualification, inv-approval-requires-identity-verification) é
// interação sync de canvas query-dependency (adr-055) -- NÃO travessia de
// Port; fora por construção. EvidencePort FORA nesta fatia: a custódia da
// documentação KYC/AML não é decidida pelo domain-model (o agregado não
// armazena documentos) -- entra por fatia própria se/quando o domínio a
// declarar.
//
// CANON: operations usam a grafia JA CANONICA do runtime -- EventLogPort
// per rtd-004 (mesh-runtime docs/decisions.md).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

portManifest: artifact_schemas.#PortManifest & {
	id:                "pm-npm"
	boundedContextRef: "npm"

	// EventLogPort: uso-forte (persistencia/replay do agg-participant).
	portsConsumed: ["EventLogPort"]

	operations: [{
		port: "EventLogPort"
		name: "append"
		inputs: ["StreamId", "EventBatch", "ExpectedVersion"] // grafia canonica (rtd-004)
		output:                                               "AppendResult"
		rationale:                                            "NPM appenda os 7 eventos do participant (5 lifecycle/registro published + workflow interno + ACL-received de IDC) com optimistic concurrency -- transições supervisionadas concorrentes (suspend/terminate/reactivate sobre o mesmo participante) exigem OCC read-then-write no stream do participante."
	}, {
		port: "EventLogPort"
		name: "readStream"
		inputs: ["StreamId", "FromVersion"] // grafia canonica (rtd-004)
		output:                             "EventStream"
		rationale:                          "NPM le o stream para (a) rehydration do agg-participant (status + flag de verificação + último resultado de qualificação); (b) as projections do BC (status view, profile view); (c) versao corrente para o ExpectedVersion do append (OCC read-then-write)."
	}]

	adaptersForGoldenExample: [{
		port:        "EventLogPort"
		description: "Stub in-memory do EventLogPort (append/readStream) -- mesmo reference adapter de pm-cmt/pm-dlv/pm-fce/pm-p2p/pm-ssc, ja materializado no mesh-runtime (eventlog-inmemory)."
		rationale:   "adr-141 item 6: reference adapter universal por Port; reuso declarado, zero codigo novo."
	}]

	contractTestsRequired: [{
		port:        "EventLogPort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations append/readStream."
		rationale:   "adr-141 item 6: kit por-Port JA EXISTENTE no mesh-runtime (gerado dos manifests; pm-npm adiciona o 6o consumidor ao Port sem mudar a superficie -- dedupe por assinatura identica aos precedentes)."
	}]

	referenceAdapterRequired: true // o adapter ja existe no mesh-runtime; flag explicita por legibilidade (precedente pm-cmt..pm-ssc).

	rationale: "NPM consome EventLogPort (uso-forte: persistencia OCC + replay do agg-participant -- transições supervisionadas concorrentes exigem read-then-write). Sexta instancia de #PortManifest; com ela o discovery do gerador (rtd-013) passa a pegar o NPM -- o degrau runtime da fatia do participante (M7): o fornecedor qualificado que sustenta o pool do ssc (svc-supplier-pool-builder via QueryParticipantStatus). Consulta IDC e canvas query-dependency per adr-055, não Port -- fora por construção; EvidencePort fora (o agregado não custodia documentos). Adapter e suite Tier-1: REUSO declarado (dedupe por assinatura identica). Ativa sc-pmc-01/02/03 e sc-mri-01 para o sexto BC."
}
