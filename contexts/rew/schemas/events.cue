package rew

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"

// schemas/events.cue — Payload schemas do RECORTE do caminho da
// elegibilidade do REW (fatia REW, PR #139, Etapa 2).
//
// RECORTE (5 eventos): signal-received → computed → emitted +
// supersession/stale. Shapes VERBATIM do domain-model Phase 3
// (contexts/rew/domain-model.cue) — 4ª instância do pattern de schemas
// (DLV → CMT → FCE → REW): #Envelope consolidado (shared-schemas,
// def-022), eventos como #Envelope & {type, data}, source
// mesh://contexts/rew, types mesh.rew.<event>.v1, #RFC3339Timestamp nos
// timestamps de domínio (padrão FCE/CMT).
//
// FORA DO RECORTE (declarado): alerts (raised/acknowledged/resolved),
// models/policies (activated/deprecated), eventos de exceção
// (signal-rejected, signal-corruption-detected, emit-failed,
// emit-superseded-by-newer — fluxos de exceção sem emissor na fatia),
// commands (vivem no domain-model/am).
//
// PAYLOAD OPACITY (mod-rew-acl + inv-rew-payload-opacity): #Signal
// referencia payload por CÓDIGO + REFERÊNCIA (payloadVoCode +
// payloadInstance) — os 4 payload VOs (vo-signal-payload-*) NUNCA
// entram no contrato de evento; REW não interpreta payload bruto
// upstream. Opacidade é por construção, não por disciplina.
//
// GRAFIA DO ENUM DE ELIGIBILITY: underscore (conditionally_eligible),
// VERBATIM do Phase 3 (vo-eligibility-decision). Esta é a grafia canônica:
// o FCE consome a faceta eligibility deste fato via contrato-de-consumo
// #EligibilityConsumption (enum underscore inline), reconciliado na Etapa 3
// da fatia (def-057 resolvido por adr-149; a fixture #EligibilityEmitted e o
// enum hifenizado #EligibilityDecisionKind do FCE foram removidos). Este
// arquivo materializa o CONTRATO REAL do produtor; foi o trigger file-exists
// do def-057 (disparo registrado na Etapa 2).
//
// ENVELOPE: eventId/eventTimestamp do domain-model vivem no #Envelope
// (id/time); correlationId/causationId NÃO entram em data (disciplina
// anti-stealth-extension do envelope). EXCEÇÃO semântica: causationKind/
// causationRef do signal-received ficam em data por serem causalidade
// DISCRIMINADA de domínio (batch/polling/backfill/manual — 'forçar
// causalidade inexistente cria mentira estrutural').

// ── Aliases para shared_schemas ──
//
// ATENÇÃO: aliases são renomeio local — NÃO são ponto de extensão.
// Overrides locais produzem drift silencioso cross-BC; divergência local
// exige tension-entry + revisita (disciplina de
// architecture/shared-schemas/envelope.cue).

#Envelope:         shared_schemas.#Envelope
#RFC3339Timestamp: shared_schemas.#RFC3339Timestamp

// ── Helpers locais ──

// SHA-256 hex (sc-rew-hash-format).
#Sha256Hex: string & =~"^[a-f0-9]{64}$"

// Estado do RiskEvaluation — disjunção FECHADA: o gerador REUSA este
// enum (schemas-preference, rtd-013) e valida contra lifecycle.states
// do am-risk-evaluation (idênticos por construção: status do
// agg-risk-evaluation, domain-model).
#RiskEvaluationState: "emitted" | "stale" | "superseded"

// Decisão de elegibilidade — disjunção fechada, grafia UNDERSCORE
// verbatim do Phase 3 (vo-eligibility-decision; ver header).
#EligibilityDecisionKind: "eligible" | "conditionally_eligible" | "ineligible"

// ════════════════════════════════════════════════════════════════════
// VALUE OBJECTS (12) — verbatim do domain-model Phase 3
// (fechamento transitivo dos 5 eventos do recorte)
// ════════════════════════════════════════════════════════════════════

// vo-version-stamp — versioning metadata reusável (regex + compatibility).
#VersionStamp: {
	version:            string & =~"^v[0-9]+$"
	backwardCompatible: bool
	requiresMigration:  bool // backwardCompatible=false implica true (sc-rew-version-coherence)
}

// vo-external-ref — referência tipada cross-BC com sourceContext
// explícito ('referência sem origem = acoplamento invisível').
#ExternalRef: {
	externalRef:   string & !=""
	sourceContext: string & =~"^(inv|fce|scf|cmt|dlv|nim|npm|ext-[a-z][a-z0-9-]*|rew)$"
}

// vo-integrity-proof — proof de integridade do signal upstream. REW NÃO
// valida proof semanticamente — verifica existência + proofType
// reconhecido; re-verificação é runtime concern (ver def-058).
#IntegrityProof: {
	proofType: string & =~"^(signature|hash-chain|attestation|notarized)$"
	proofRef:  string & !="" // identifier opaco do proof artifact em storage upstream
}

// vo-signal-ref — snapshot reference imutável: triple {ref, hash,
// capturedAt} garante replay determinístico + detecção de mutação.
#SignalRef: {
	signalRef:  #ExternalRef
	signalHash: #Sha256Hex
	capturedAt: #RFC3339Timestamp
}

// vo-signal — interpretação validada upstream (Layer 1 Reality
// Interpretation). Discriminated union por signalType; payload por
// REFERÊNCIA (payloadVoCode + payloadInstance — opacidade, ver header).
// Binding signalType ⟺ payloadVoCode e mapping signalType↔sourceContext
// são structural-check level (sc-rew-signal-payload-binding,
// sc-rew-signalType-source-binding).
#Signal: {
	signalId:        string & !=""
	signalType:      string & =~"^(kyc|device|behavioral|fiscal)$"
	sourceContext:   string & =~"^(npm|dlv|nim|fce)$"
	observedAt:      #RFC3339Timestamp // quando o fato aconteceu no mundo
	recordedAt:      #RFC3339Timestamp // quando o upstream registrou
	integrityProof:  #IntegrityProof
	versionStamp:    #VersionStamp
	payloadVoCode:   string & =~"^vo-signal-payload-(kyc|device|behavioral|fiscal)$"
	payloadInstance: #ExternalRef // payload armazenado no BC de origem — opaco para REW
}

// vo-scale-metadata — bounds de escala custom. PRESENTE APENAS quando
// scale=='custom' (coerência é sc-rew-score-custom-coherence).
#ScaleMetadata: {
	min:  number
	max:  number // min < max (sc-rew-scale-metadata-bounds-ordering)
	unit: string // vazio quando dimensionless
}

// vo-risk-score — output principal: 'score = hipótese quantificada'.
// Range depende da semântica (scale), não do tipo.
#RiskScore: {
	scale:                    string & =~"^(probability|normalized|custom)$"
	value:                    number // range por scale (sc-rew-score-scale-range)
	calibrationProfile:       string & =~"^(default-v[0-9]+|construction-v[0-9]+|high-risk-adjusted-v[0-9]+|custom-[a-z0-9-]+)$"
	computedFromModelVersion: string & !=""
	computedAt:               #RFC3339Timestamp
	scaleMetadata?:           #ScaleMetadata // presente ⟺ scale=='custom'
}

// vo-coverage-stats — cobertura ponderada de signals ('cobertura não é
// quantidade — é relevância'). Fórmula de weighting é runtime concern.
#CoverageStats: {
	weightedRatio:  number & >=0 & <=1
	missingSignals: string // comma-separated signalIds ausentes (ordered ascending); operacional
	totalExpected:  int & >=0
	totalObserved:  int & >=0 // ≤ totalExpected (sc-rew-coverage-counts-coherence)
}

// vo-confidence-interval — 'confidence = medida da ignorância'.
// uncertaintyDrivers: comma-separated driverCodes (catálogo
// vo-uncertainty-driver — TYPE catalog, validação de elementos é
// structural-check level; ≥1 quando coverage < 1.0).
#ConfidenceInterval: {
	lowerBound:         number
	upperBound:         number // ≥ lowerBound (sc-rew-ci-bounds-ordering)
	confidenceLevel:    number & >0 & <1
	coverage:           #CoverageStats
	methodology:        string & =~"^(bayesian|heuristic|conservative)$"
	uncertaintyDrivers: string
	computedAt:         #RFC3339Timestamp
}

// vo-decision-reason — reason code estruturado (TYPE catalog): razão é
// razão; o consumer difere por field (constraints/blockingReasons/
// supersedeReason/resolutionReason). Coerência severity↔field é
// structural-check level.
#DecisionReason: {
	reasonCode: string & =~"^(reduced-limit|short-term|collateral-required|enhanced-monitoring|fiscal-non-compliant|asset-visibility-gap|score-below-threshold|kyc-pending|kyc-rejected|sanctioned|stale-evidence|adversarial-pattern-detected|policy-not-applicable|insufficient-confidence|policy-version-changed|model-version-changed|manual-override|false-positive|escalated|supersession-by-newer-evaluation|model-deprecated|policy-deprecated|model-recalibration|policy-update-required)$"
	severity:   string & =~"^(soft|hard|blocking)$"
	category:   string & =~"^(risk|compliance|operational|epistemic|lifecycle)$"
}

// vo-eligibility-decision — output categórico CONTEXTUAL. Decision puro
// + reasons estruturadas; basedOnScore/basedOnPolicyVersion preservam
// binding ao raciocínio. constraints/blockingReasons: comma-separated
// reasonCodes (coerências decision↔reasons são structural-check level).
#EligibilityDecision: {
	decision:             #EligibilityDecisionKind
	constraints:          string // non-empty ⟺ conditionally_eligible
	blockingReasons:      string // non-empty ⟺ ineligible
	basedOnScore:         #RiskScore
	basedOnPolicyVersion: string & !=""
	evaluatedAt:          #RFC3339Timestamp
}

// vo-applicable-context — contexto obrigatório de toda RiskEvaluation
// (inv-rew-contextual-completeness). assetVisibility=='gap' reconhece
// ignorância sistêmica formalmente; assetRef presente ⟺
// evaluationScope=='asset_level' (sc-rew-context-*-scope-coherence).
#ApplicableContext: {
	entityRef:           #ExternalRef
	productCode:         string & !=""
	policyVersion:       string & !=""
	decisionContextTime: #RFC3339Timestamp
	assetRef?:           #ExternalRef
	assetVisibility:     string & =~"^(visible|indirect|gap)$"
	evaluationScope:     string & =~"^(entity_level|asset_level)$"
	versionStamp:        #VersionStamp
}

// ════════════════════════════════════════════════════════════════════
// EVENTOS DO RECORTE (5)
// ════════════════════════════════════════════════════════════════════

// evt-signal-received — signal interpretado upstream INGESTADO via ACL
// (interno). Idempotency split: (signalId, sourceContext) = IDENTITY;
// signalHash = INTEGRITY (mesma identity + hash diferente → corruption
// path, FORA do recorte). causationKind/causationRef discriminados em
// data (causalidade de domínio — ver header).
#SignalReceivedFromUpstreamBC: #Envelope & {
	type: "mesh.rew.signal-received.v1"
	data: {
		causationKind: string & =~"^(upstream-event|ingestion-job|backfill-job|manual-import|none)$"
		causationRef:  string // vazio quando causationKind=='none'
		signal:        #Signal
		signalRef:     #SignalRef // idempotency anchor (snapshot triple)
	}
}

// evt-risk-evaluation-computed — calculation finalizada internamente.
// Computed ≠ Emitted ('decidir ≠ publicar'): shadow mode, retry sem
// recompute, failure isolation. replayHash = SHA-256 da serialização
// canônica de (signalSnapshotIds + modelVersion + policyVersion +
// decisionContextTime).
#RiskEvaluationComputed: #Envelope & {
	type: "mesh.rew.risk-evaluation-computed.v1"
	data: {
		evaluationId:       string & !=""
		parentEvaluationId: string // vazio quando root (lineage)
		signalSnapshotIds:  string & !="" // comma-separated, ordered ascending, ≥1
		score:              #RiskScore
		eligibility:        #EligibilityDecision
		confidence:         #ConfidenceInterval
		context:            #ApplicableContext
		modelVersion:       string & !=""
		policyVersion:      string & !=""
		replayHash:         #Sha256Hex
		computedAt:         #RFC3339Timestamp
	}
}

// evt-risk-evaluation-emitted — DECISÃO ATÔMICA publicada cross-BC
// (consumers CMT/FCE/SCF): score + eligibility + confidence + context
// num fato único. evaluationId é IDENTITY anchor ('evento pode duplicar;
// decisão não pode') — consumer dedupe via evaluationId, nunca eventId.
#RiskEvaluationEmitted: #Envelope & {
	type: "mesh.rew.risk-evaluation-emitted.v1"
	data: {
		evaluationId:       string & !=""
		score:              #RiskScore
		eligibility:        #EligibilityDecision
		confidence:         #ConfidenceInterval
		context:            #ApplicableContext
		emittedAt:          #RFC3339Timestamp
		validUntilTimestamp: #RFC3339Timestamp // = emittedAt + validity window (inv-rew-evaluation-temporal-validity)
	}
}

// evt-risk-evaluation-superseded — substituição EXPLÍCITA (published).
// REW NUNCA supersede automaticamente (inv-rew-explicit-supersede-only);
// supersedeReason obrigatório ('substituição sem razão = corrupção
// silenciosa').
#RiskEvaluationSuperseded: #Envelope & {
	type: "mesh.rew.risk-evaluation-superseded.v1"
	data: {
		supersededEvaluationId: string & !=""
		newEvaluationId:        string & !=""
		supersedeReason:        #DecisionReason
		supersededAt:           #RFC3339Timestamp
	}
}

// evt-risk-evaluation-marked-stale — staleness AUTOMÁTICA policy-driven
// (published). Stale ≠ Superseded: 'supersede decide; staleness
// sinaliza' — evaluation continua VÁLIDA mas flagged. Máx. 1 por
// evaluation por window (inv-rew-event-emission-boundedness).
#RiskEvaluationMarkedStale: #Envelope & {
	type: "mesh.rew.risk-evaluation-marked-stale.v1"
	data: {
		evaluationId:        string & !=""
		triggeringSignalRef: #SignalRef
		stalenessReason:     string & =~"^(new-signal-same-entity|new-signal-same-asset|policy-version-changed|model-version-changed)$"
		markedStaleAt:       #RFC3339Timestamp
	}
}
