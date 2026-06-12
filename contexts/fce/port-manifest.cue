package fce

// port-manifest.cue -- PortManifest do FCE (WI-140 fatia FCE / pos-N5(a)).
//
// Instancia de #PortManifest (architecture/artifact-schemas/port-manifest.cue,
// adr-144). Terceira instancia do tipo (precedentes: pm-cmt, pm-dlv).
// EventLogPort + EvidencePort modelados per adr-141 item 4 (PortManifest = SoT
// exclusiva da superficie de Port; interface Kotlin e projecao verificada em
// mesh-runtime, def-050).
//
// ESCOLHA verify-SEM-retrieve (decisao founder, pacote 2 do Caminho B): a
// condicao (c) do PrePaymentGuard e INTEGRIDADE da cadeia de evidencia --
// verify() emite receipt deterministico e re-verificavel (rtd-012). Inspecao
// de CONTEUDO (retrieve) e o deep check BD9 do DLV, nao funcao do gate do FCE:
// integridade != verdade (glossario term-cadeia-de-evidencia) -- a verdade
// material e responsabilidade das camadas upstream (DLV/INV). Se o cenario
// terminal do WI-138 demandar retrieve, expansao via deferred-decision.
//
// WorkflowPort FORA desta fatia (decisao founder): a orquestracao da
// financialization no walking skeleton e exercida pelo proprio aggregate +
// cenario; DD se a execucao do WI-138 pedir.
//
// CANON: todas as operations usam a grafia JA CANONICA do runtime --
// EventLogPort per rtd-004, EvidencePort per rtd-012 (mesh-runtime
// docs/decisions.md; canons nascidos no bootstrap e na fatia-2).
//
// NOTA DE FATIA: fatia FCE do WI-140 (claim WI-140-claim-fatia-fce) -- NAO
// conclui o WI.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

portManifest: artifact_schemas.#PortManifest & {
	id:                "pm-fce"
	boundedContextRef: "fce"

	// EventLogPort: uso-forte (persistencia/replay do agg-payment).
	// EvidencePort: verify-only (condicao (c) do PrePaymentGuard).
	portsConsumed: ["EventLogPort", "EvidencePort"]

	operations: [{
		port: "EventLogPort"
		name: "append"
		inputs: ["StreamId", "EventBatch", "ExpectedVersion"] // grafia canonica (rtd-004)
		output:                                               "AppendResult"
		rationale:                                            "FCE appenda os 3 eventos do caminho do guard (PaymentAuthorized, PaymentInstructionDispatched, PaymentSettled) com optimistic concurrency -- a unicidade por (commitmentRef, invoice) de inv-at-most-once-dispatch e protegida por OCC no primeiro append do stream do Payment."
	}, {
		port: "EventLogPort"
		name: "readStream"
		inputs: ["StreamId", "FromVersion"] // grafia canonica (rtd-004)
		output:                             "EventStream"
		rationale:                          "FCE le o stream para (a) rehydration do agg-payment; (b) replay deterministico do guard (inv-guard-deterministic: replay reproduz a mesma decisao, dp-04); (c) versao corrente para o ExpectedVersion do append (OCC read-then-write)."
	}, {
		port: "EvidencePort"
		name: "verify"
		inputs: ["EvidenceAddress", "IntegrityProof"] // grafia canonica rtd-012 (mesh-runtime)
		output:                                       "VerificationReceipt" // grafia canonica rtd-012 (mesh-runtime)
		rationale:                                    "Condicao (c) do PrePaymentGuard: integridade da cadeia de evidencia que lastreia o pagamento -- verify emite receipt deterministico e re-verificavel para o par address/proof (rtd-012; adr-141 item 6: content-addressability + receipt). retrieve FORA por decisao (ver header): o gate compoe INTEGRIDADE, nao re-inspeciona conteudo (BD9 e do DLV; integridade != verdade)."
	}]

	adaptersForGoldenExample: [{
		port:        "EventLogPort"
		description: "Stub in-memory do EventLogPort (append/readStream) -- mesmo reference adapter de pm-cmt/pm-dlv, ja materializado no mesh-runtime (eventlog-inmemory). O cenario terminal do WI-138 o reusa."
		rationale:   "adr-141 item 6: reference adapter universal por Port; reuso declarado, zero codigo novo."
	}, {
		port:        "EvidencePort"
		description: "Stub in-memory content-addressed do EvidencePort -- reference adapter ja materializado no mesh-runtime (evidence-inmemory, pacote-runtime da fatia-2). O cenario do WI-138 o reusa para a condicao (c) do guard."
		rationale:   "adr-141 item 6: o reference adapter e a spec executavel do Port; ja existe e ja e oracle das suites Tier-1/2 (N5(a) satisfeita pre-este-manifest)."
	}]

	contractTestsRequired: [{
		port:        "EventLogPort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations append/readStream."
		rationale:   "adr-141 item 6: kit por-Port JA EXISTENTE no mesh-runtime (gerado dos manifests; pm-fce adiciona o 3o consumidor ao Port sem mudar a superficie -- dedupe por assinatura identica)."
	}, {
		port:        "EvidencePort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class da operation verify."
		rationale:   "adr-141 item 6: kit por-Port JA EXISTENTE (fatia-2). pm-fce consome subconjunto da superficie (verify-only); assinatura identica a do pm-dlv -- dedupe, kit inalterado."
	}, {
		port:        "EvidencePort"
		tier:        2
		description: "Tier-2 (comportamental): receipt deterministico e re-verificavel para o par address/proof -- REUSO DECLARADO da suite existente do evidence-inmemory (content-addressability + receipt, pacote-runtime da fatia-2); nenhuma suite nova."
		rationale:   "O invariante comportamental que o guard consome (receipt deterministico) ja e coberto pela suite Tier-2 existente do Port. Invariantes comportamentais PROPRIOS do FCE (guard categorico, at-most-once por tupla) sao de DOMINIO -- pertencem aos assertion-tests do cenario terminal do WI-138, nao a contract-tests de Port (precedente pm-dlv: propriedades genericas pertencem a suite do proprio Port)."
	}]

	referenceAdapterRequired: true // ambos os adapters ja existem no mesh-runtime; flag explicita por legibilidade (precedente pm-cmt/pm-dlv).

	rationale: "FCE consome EventLogPort (uso-forte: persistencia OCC + replay do agg-payment -- inv-guard-deterministic exige replay que reproduz a decisao do guard) e EvidencePort em modo verify-only (condicao (c) do PrePaymentGuard: integridade da cadeia, receipt deterministico; retrieve fora por decisao -- integridade != verdade, BD9 e do DLV; WorkflowPort fora -- DD se o WI-138 pedir). Terceira instancia de #PortManifest (precedentes pm-cmt, pm-dlv); com ela o discovery do gerador (rtd-013) passa a pegar o FCE: FceTypes + PaymentAggregateSkeleton gerados, headers Source dos Ports ganham o 3o consumidor (dedupe por assinatura identica -- interfaces inalteradas). Adapters e suites Tier-1/2: REUSO declarado do ja materializado (N5(a) do adr-141 satisfeita antes deste manifest). Ativa sc-pmc-01/02/03 e sc-mri-01 para o terceiro BC. Nenhum campo modela conformance interface<->manifest (def-050, c-puro). Fatia FCE de WI-140 -- NAO conclui o WI."
}
