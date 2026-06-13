package rew

// port-manifest.cue -- PortManifest do REW (fatia REW, caminho da
// elegibilidade, PR #139 Etapa 2).
//
// Instancia de #PortManifest (architecture/artifact-schemas/port-manifest.cue,
// adr-144). Quarta instancia do tipo (precedentes: pm-cmt, pm-dlv, pm-fce).
// EventLogPort modelado per adr-141 item 4 (PortManifest = SoT exclusiva da
// superficie de Port; interface Kotlin e projecao verificada em mesh-runtime,
// def-050).
//
// ESCOLHA EvidencePort NAO-CONSUMIDO nesta fatia (decisao founder, Etapa 2 da
// fatia REW). Criterio — "integridade != veracidade" decide:
// (1) a integridade de signal que o RECORTE materializa e o idempotency split
//     do evt-signal-received: (signalId, sourceContext) = identity; signalHash
//     = integrity — comparacao deterministica de hash computada pelo proprio
//     REW na ingestao (dado contra dado), nao operacao de custodia;
// (2) o vo-integrity-proof upstream e proofRef OPACO para storage do BC de
//     origem (signature|hash-chain|attestation|notarized) e o domain-model
//     declara: "REW NAO valida proof semanticamente — runtime usa proofRef
//     para re-verificacao se necessario". Forcar verify(EvidenceAddress,
//     IntegrityProof) (rtd-012 — CAS sha256 da custodia Mesh) sobre proofRef
//     opaco upstream fabricaria contrato que o domain-model nao declara;
// (3) o fluxo que CONSOME a falha de integridade (evt-signal-corruption-
//     detected → alert critico → review humano) esta FORA do recorte.
// Caminho de expansao: def-058 (deferred-decision desta fatia).
//
// WorkflowPort FORA desta fatia (paralelo pm-fce): staleness e policy interna
// (pol-mark-stale-on-relevant-signal → cmd interno); sem orquestracao externa
// no caminho da elegibilidade.
//
// CANON: operations usam a grafia JA CANONICA do runtime — EventLogPort per
// rtd-004 (mesh-runtime docs/decisions.md).
//
// NOTA DE FATIA: manifests dos demais aggregates do REW (alert/model/policy)
// pendentes — esta fatia cobre o caminho da elegibilidade, nao o BC inteiro.

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

portManifest: artifact_schemas.#PortManifest & {
	id:                "pm-rew"
	boundedContextRef: "rew"

	// EventLogPort: uso-forte (persistencia/replay/read-rule do
	// agg-risk-evaluation, lifecycle rico com supersession/stale).
	portsConsumed: ["EventLogPort"]

	operations: [{
		port: "EventLogPort"
		name: "append"
		inputs: ["StreamId", "EventBatch", "ExpectedVersion"] // grafia canonica (rtd-004)
		output:                                               "AppendResult"
		rationale:                                            "REW appenda os 5 eventos do recorte no stream da evaluation com optimistic concurrency: o CAS do single-successor no supersede (inv-rew-single-successor-per-evaluation) e a boundedness do marked-stale (inv-rew-event-emission-boundedness) sao protegidos por OCC; compute→emit ordering (inv-rew-compute-emit-ordering) e propriedade do stream append-only."
	}, {
		port: "EventLogPort"
		name: "readStream"
		inputs: ["StreamId", "FromVersion"] // grafia canonica (rtd-004)
		output:                             "EventStream"
		rationale:                          "REW le o stream para (a) rehydration do agg-risk-evaluation; (b) read-rule da evaluation ATIVA (inv-rew-active-evaluation-rule: active = unica latest emitted NOT superseded — prj-active-risk-evaluations deriva do stream); (c) replay deterministico via replayHash (inv-rew-deterministic-replay); (d) versao corrente para o ExpectedVersion do append (OCC read-then-write)."
	}]

	adaptersForGoldenExample: [{
		port:        "EventLogPort"
		description: "Stub in-memory do EventLogPort (append/readStream) -- mesmo reference adapter de pm-cmt/pm-dlv/pm-fce, ja materializado no mesh-runtime (eventlog-inmemory)."
		rationale:   "adr-141 item 6: reference adapter universal por Port; reuso declarado, zero codigo novo. REW e o 4o consumidor da mesma superficie."
	}]

	contractTestsRequired: [{
		port:        "EventLogPort"
		tier:        1
		description: "Tier-1 (gerado): error-code coverage + conformidade PortResult/no-exception + boundary de value-class das operations append/readStream."
		rationale:   "adr-141 item 6: kit por-Port JA EXISTENTE no mesh-runtime (gerado dos manifests; pm-rew adiciona o 4o consumidor ao Port sem mudar a superficie -- dedupe por assinatura identica)."
	}, {
		port:        "EventLogPort"
		tier:        2
		description: "Tier-2 (comportamental): replay deterministico + OCC do stream -- REUSO DECLARADO das suites existentes do eventlog-inmemory (pm-cmt/pm-dlv tier-2); nenhuma suite nova."
		rationale:   "As propriedades de stream que o REW consome (replay que reproduz o estado, OCC read-then-write) ja sao cobertas pelas suites Tier-2 existentes do Port. Invariantes comportamentais PROPRIOS do REW (active-rule, single-successor, boundedness, temporal validity) sao de DOMINIO -- pertencem aos assertion-tests do futuro golden-example do REW (fora desta fatia), nao a contract-tests de Port (precedente pm-dlv/pm-fce)."
	}]

	referenceAdapterRequired: true // adapter ja existe no mesh-runtime; flag explicita por legibilidade (precedente pm-cmt/pm-dlv/pm-fce).

	rationale: "REW consome EventLogPort em uso-forte: persistencia OCC + replay + read-rule da evaluation ativa do agg-risk-evaluation -- o lifecycle rico (compute → emit + supersession/stale) vive inteiro no stream append-only. EvidencePort NAO consumido nesta fatia por criterio (header): a integridade de signal do recorte e o idempotency split (signalHash, comparacao in-process), nao operacao de custodia; re-verificacao de proof upstream e runtime-deferred (def-058, trigger manual-review — o gatilho e a materializacao do fluxo de corruption/alerts nos schemas, padrao de conteudo nao machine-evaluable por path). WorkflowPort fora (staleness e policy interna). Quarta instancia de #PortManifest; com ela o discovery do gerador (rtd-013) passa a pegar o REW: RewTypes + RiskEvaluationAggregateSkeleton gerados em scratch, headers Source dos Ports ganham o 4o consumidor (dedupe por assinatura identica -- interfaces inalteradas); baseline rew-generated no mesh-runtime e downstream do proximo pacote-runtime (precedente FCE). Adapters e suites Tier-1/2: REUSO declarado do ja materializado. Ativa sc-pmc-01/02/03 e sc-mri-01 para o quarto BC. Nenhum campo modela conformance interface<->manifest (def-050, c-puro)."
}
