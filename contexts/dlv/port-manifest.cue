package dlv

// port-manifest.cue -- PortManifest do DLV (WI-140 fatia-2 / caminho N5(a) do adr-141).
//
// Instancia de #PortManifest (architecture/artifact-schemas/port-manifest.cue,
// adr-144). Segunda instancia do tipo no disco (precedente de forma: pm-cmt).
// EventLogPort + EvidencePort modelados per adr-141 item 4 (PortManifest = SoT
// exclusiva da superficie de Port; interface Kotlin e projecao verificada em
// mesh-runtime, def-050).
//
// SEGUNDO PORT (EvidencePort): este manifest e o no spec-side da fatia-2 do
// WI-140 -- o caminho N5(a) da condicao de migracao do adr-141 (>=2 Ports
// exercitados por contract-tests reais). A materializacao runtime (canon,
// interface gerada, reference adapter, Tier-1/2) e pacote separado no
// mesh-runtime, ordem spec->runtime.
//
// RESSALVA BD9 (explicita per decisao do founder): o uso do EvidencePort pelo
// DLV e o deep semantic check evaluation-time (BD9, Layer 1 evaluation-time) --
// OPCIONAL em Phase 0, com fail-safe fallback. A ingestao (cmd-record-evidence)
// valida integridade LOCALMENTE (BD11, network-independent) e NAO atravessa o
// EvidencePort. Declarar o Port aqui registra a superficie real do deep check,
// nao um consumo de ingestao que o DLV deliberadamente nao tem.
//
// CANON: as operations do EventLogPort usam a grafia JA CANONICA do runtime
// (platform/canon, mesh-runtime docs/decisions.md rtd-004 -- resolvida pos
// pm-cmt). As operations do EvidencePort usam a grafia CANONICA confirmada:
// o canon do EvidencePort nasceu no pacote-runtime da fatia-2 (mesh-runtime
// platform/canon/EvidenceCanon.kt, rtd-012) com os nomes deste manifest
// adotados VERBATIM (precedente: pm-cmt -> rtd-004).

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

portManifest: artifact_schemas.#PortManifest & {
	id:                "pm-dlv"
	boundedContextRef: "dlv"

	// EventLogPort: uso-forte (persistencia/replay do agg-verification).
	// EvidencePort: deep check BD9 (opcional Phase 0, fail-safe fallback).
	portsConsumed: ["EventLogPort", "EvidencePort"]

	operations: [{
		port: "EventLogPort"
		name: "append"
		inputs: ["StreamId", "EventBatch", "ExpectedVersion"] // grafia canonica (rtd-004)
		output:                                               "AppendResult"
		rationale:                                            "DLV appenda os 7 eventos do agg-verification (EvidenceRecorded, DeliveryVerified/Rejected, Exception*, SupersessionApplied) com optimistic concurrency -- atomicidade emit unica por decisao (canvas) e unicidade da IdempotencyIdentity (inv-identity-uniqueness) protegidas por OCC no primeiro append do stream."
	}, {
		port: "EventLogPort"
		name: "readStream"
		inputs: ["StreamId", "FromVersion"] // grafia canonica (rtd-004)
		output:                             "EventStream"
		rationale:                          "DLV le o stream para (a) rehydration do agg-verification; (b) replay determinism (inv-replay-determinism, BD3) -- vo-event-log-offset e a fonte canonica de ordering (supersessao BD5, finality timers); (c) versao corrente para o ExpectedVersion do append (OCC read-then-write)."
	}, {
		port: "EvidencePort"
		name: "retrieve"
		inputs: ["EvidenceAddress"] // CANON: EvidenceAddress -- grafia canonica rtd-012 (mesh-runtime)
		output:                     "EvidenceContent" // CANON: EvidenceContent -- grafia canonica rtd-012 (mesh-runtime)
		rationale:                  "Deep semantic check BD9 (evaluation-time, Layer 1 deep): recuperar o conteudo custodiado content-addressed para inspecao semantica alem da proof sintatica. OPCIONAL Phase 0 com fail-safe fallback (domain-model cmd-evaluate-verification); a superficie e declarada porque o uso e real quando ativado."
	}, {
		port: "EvidencePort"
		name: "verify"
		inputs: ["EvidenceAddress", "IntegrityProof"] // CANON: EvidenceAddress/IntegrityProof -- grafia canonica rtd-012 (mesh-runtime)
		output:                                       "VerificationReceipt" // CANON: VerificationReceipt -- grafia canonica rtd-012 (mesh-runtime)
		rationale:                                    "Verificacao de custodia content-addressed: o conteudo no address confere com a proof DSSE-anchored (vo-integrity-proof-ref) e a custodia emite receipt (adr-141 item 6: content-addressability + receipt). Complementa -- nao substitui -- a validacao local de ingestao (BD11): integridade != verdade (BD9 defense in depth)."
	}]

	adaptersForGoldenExample: [{
		port:        "EventLogPort"
		description: "Stub in-memory do EventLogPort (append/readStream) -- mesmo reference adapter do pm-cmt; o golden-example futuro do DLV (fan-out, fora da fatia-2) sobe sem vendor."
		rationale:   "adr-141 item 6: reference adapter universal por Port. Ja materializado no mesh-runtime (fatia-1); o ge-dlv futuro o reusa."
	}, {
		port:        "EvidencePort"
		description: "Stub in-memory content-addressed do EvidencePort (retrieve/verify) para o golden-example futuro do DLV subir sem vendor. DECLARACAO spec-side; o codigo vive no mesh-runtime (pacote-runtime da fatia-2)."
		rationale:   "adr-141 item 6: o reference adapter in-memory e a spec executavel da semantica do Port e o oracle dos contract-tests Tier-1/2 -- e o no runtime da condicao N5(a) do adr-141."
	}]

	contractTestsRequired: [{
		port:        "EventLogPort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations append/readStream."
		rationale:   "adr-141 item 6: Tier-1 derivado das obrigacoes do manifest + taxonomia de erro. Mesma forma do pm-cmt; o kit e por-Port e ja existe no mesh-runtime."
	}, {
		port:        "EventLogPort"
		tier:        2
		description: "Tier-2 (comportamental): ordering monotonico de offsets + replay determinism -- readStream do inicio reproduz a mesma sequencia em qualquer re-leitura (append-only)."
		rationale:   "O invariante comportamental relevante ao DLV e o ordering deterministico (vo-event-log-offset e a espinha de BD3/BD5: replay determinism + supersession total ordering). OCC ja e coberto pelo Tier-2 do pm-cmt; propriedades genericas do Port pertencem a suite do proprio Port (mesh-runtime)."
	}, {
		port:        "EvidencePort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations retrieve/verify."
		rationale:   "adr-141 item 6: Tier-1 derivado das obrigacoes do manifest + taxonomia de erro do canon do EvidencePort (a nascer no pacote-runtime, precedente rtd-004)."
	}, {
		port:        "EvidencePort"
		tier:        2
		description: "Tier-2 (comportamental): content-addressability (retrieve(address) devolve conteudo cujo content-address recomputado == address; address inexistente falha fechado) + receipt (verify emite receipt deterministico e re-verificavel para o par address/proof)."
		rationale:   "adr-141 item 6 nomeia verbatim o invariante comportamental do EvidencePort: content-addressability + receipt. E o exercicio real do segundo Port que a condicao N5(a) do adr-141 exige."
	}]

	referenceAdapterRequired: true // explicito: nos do caminho N5(a); legibilidade > default implicito (precedente pm-cmt).

	rationale: "DLV consome EventLogPort (uso-forte: persistencia OCC + replay do agg-verification -- vo-event-log-offset e a fonte canonica de ordering do BC) e EvidencePort (deep semantic check BD9, evaluation-time, OPCIONAL Phase 0 com fail-safe fallback -- ressalva explicita; a ingestao BD11 e local-first e nao atravessa Port). Segunda instancia de #PortManifest (precedente pm-cmt) e no spec-side da fatia-2 do WI-140: o EvidencePort e o segundo Port real do caminho N5(a) da condicao de migracao do adr-141 -- exercitado por contract-tests Tier-1/2 contra reference adapter in-memory no mesh-runtime (pacote-runtime separado, ordem spec->runtime). Operations do EventLogPort em grafia ja canonica (rtd-004); operations do EvidencePort em grafia canonica confirmada (rtd-012, canon nascido no pacote-runtime da fatia-2). Ativa sc-pmc-01/02/03 e sc-mri-01 para o segundo BC. Nenhum campo modela conformance interface<->manifest (def-050, c-puro)."
}
