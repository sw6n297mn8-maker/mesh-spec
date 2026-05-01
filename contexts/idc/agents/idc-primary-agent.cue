package idc

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// idc-primary-agent.cue — Agent Spec do BC Identity & Data Governance.
// Instância de #AgentSpec (architecture/artifact-schemas/agent-spec.cue).
//
// Aplicação manual do production-guide architecture/production-guides/
// agent-spec.cue (commit 7d3adee). Cascade ordering per adr-054 dec 13:
// PG existe; canvas.ownership.domainAgentSpec aponta para este path
// (post-commit 825b260).
//
// Primeira instância pós-cascade-ordering (per adr-054). Phase 0 de
// adr-054 (pre-WI-069). PG-A iteração pós-founder-review aplicada
// (tq-agg-05..10): impact classification declarada per action,
// enforcementLevel + derivedFromInvariant per constraint, decide-vs-
// execute audit, canonical removal test no rationale.
//
// Princípio operacional canônico (per founder review 2026-05-01):
// Spec declara CAPACIDADE; governance envelope declara AUTONOMIA atual
// via promotion criteria + autonomyOverrides intermediários (sem
// violar P10 / tq-gv-14). Phase 0: TODAS mutations baseline propose-
// and-wait, independente de canvas declarar autonomousDecision.
// "autonomousDecision" no canvas significa "não exige julgamento
// humano (gate determinístico)", NÃO "execução sem governança".
// Promotion para execute-and-log das 3 mutations deterministic-gated
// (act-execute-identity-verification, act-sign-evidence,
// act-generate-integrity-proof) é decisão do envelope.governance, não
// do spec — preserva P10 (gates determinísticos validam, agentes
// recomendam) e habilita rollback automático per failureHandling.

idcPrimaryAgent: artifact_schemas.#AgentSpec & {
	code:              "agt-idc-primary"
	name:              "IDC Primary Agent"
	description:       "Agente operador único do BC Identity & Data Governance. Executa protocolo de verificação de identidade organizacional contra fontes autoritativas (RF, JC, bureaus), executa operações criptográficas (assinatura DSSE, geração de Merkle proof) sob gate determinístico de invariantes, propõe (sob supervisão) decisões de revogação que afetam acesso à rede de organizações inteiras."
	boundedContextRef: "idc"
	role:              "domain-agent"
	governanceRef:     "idc-primary-agent"

	// =============================================
	// OPERATIONAL SCOPE
	// =============================================

	operationalScope: {
		aggregates: [
			"agg-organizational-identity",
			"agg-evidence-cryptography",
		]
		commands: [
			"cmd-verify-organization-identity",
			"cmd-revoke-identity",
			"cmd-sign-evidence",
			"cmd-generate-integrity-proof",
		]
		events: [
			"evt-identity-verified",
			"evt-identity-verification-rejected",
			"evt-identity-revoked",
			"evt-evidence-signed",
			"evt-integrity-proof-generated",
		]
		invariants: [
			"inv-source-authority-required",
			"inv-revocation-preserves-trail",
			"inv-signature-requires-active-identity",
			"inv-cas-content-immutability",
			"inv-signature-idempotency",
			"inv-evidence-class-conforms-taxonomy",
		]
		projections: [
			"prj-identity-verification-status",
			"prj-evidence-integrity",
			"prj-cryptographic-integrity",
		]
	}

	// =============================================
	// ACTIONS (operações executáveis)
	// =============================================

	actions: [{
		code:        "act-validate-cnpj-format"
		name:        "Validate CNPJ Format"
		description: "Validar formato canônico de CNPJ (XX.XXX.XXX/XXXX-XX) e dígitos verificadores antes de qualquer chamada externa. Gate técnico determinístico. Impact: read-only (transformação de input, sem state change). Pré-condição de cmd-verify-organization-identity."
		category:        "validation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"vo-cnpj-identifier",
			"cmd-verify-organization-identity",
		]
		preconditions: ["CNPJ string fornecida em formato candidato"]
		postconditions: ["CNPJ normalizado OR erro de formato emitido sem state change"]
	}, {
		code:        "act-normalize-identity-data"
		name:        "Normalize Identity Data"
		description: "Normalizar dados de identidade organizacional (nome, endereço, atividade econômica) para formato canônico antes de cruzamento com fontes oficiais. Impact: read-only (geração de form normalizado; sem mutação de aggregate). Per canvas autonomousDecisions.normalize-identity-data — operação determinística sobre input."
		category:        "generation"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"cmd-verify-organization-identity",
			"agg-organizational-identity",
		]
		preconditions: ["Input contém dados de identidade em formato candidato"]
		postconditions: ["Dados normalizados disponíveis para act-execute-identity-verification"]
	}, {
		code:        "act-execute-identity-verification"
		name:        "Execute Identity Verification"
		description: "Executar protocolo de verificação contra fontes autoritativas (RF, JC, bureaus). Materializa outcome do protocolo: (a) verified — fontes confirmam ⇒ lifecycle unverified→verified, emit evt-identity-verified; (b) rejected — fontes negam definitivamente (CNPJ baixado, dados não conferem) ⇒ lifecycle unverified→rejected, emit evt-identity-verification-rejected; (c) ambiguous — fontes indisponíveis ou divergem ⇒ escalate (insufficient-context | conflicting-signals | ambiguous-case). Impact: state-change + cross-bc (NPM consome events). Decide-vs-execute audit (tq-agg-09): NÃO monolítico — outcome é função do protocolo, não de julgamento; rejeição definitiva NÃO é decisão separada do agente. AutonomyLevel: propose-and-wait Phase 0 — deterministic-gated mas governance-promotion candidate via envelope (não execute-and-log no spec; preserva P10)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "external-structured"
		domainModelRefs: [
			"cmd-verify-organization-identity",
			"agg-organizational-identity",
			"evt-identity-verified",
			"evt-identity-verification-rejected",
			"inv-source-authority-required",
		]
		preconditions: [
			"CNPJ validado por act-validate-cnpj-format",
			"Dados normalizados por act-normalize-identity-data",
			"≥1 fonte autoritativa disponível",
		]
		postconditions: [
			"Outcome positivo: lifecycle agg-organizational-identity transition unverified→verified + evt-identity-verified emitido + audit trail registrado com source-references-consulted",
			"Outcome negativo definitivo: lifecycle transition unverified→rejected + evt-identity-verification-rejected emitido",
			"Outcome ambíguo: nenhuma transition; escalation triggered",
		]
	}, {
		code:        "act-propose-identity-revocation"
		name:        "Propose Identity Revocation"
		description: "Propor revogação de Identidade Organizacional verificada após perda de elegibilidade ou comprometimento detectado. Impact: state-change + cross-bc (NPM/LOG/DLV invalidam cache). Operacionalmente irreversível — afeta cadeia downstream. Phase 0: propose-and-wait obrigatório enquanto oq-idc-1 (protocolo de revogação) não resolve. Decide-vs-execute split correto: propor é decisão do agente; executar (materializar lifecycle transition + emit event) requer aprovação humana. Per canvas supervisedDecisions revoke-identity."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-revoke-identity",
			"inv-revocation-preserves-trail",
			"evt-identity-revoked",
			"agg-organizational-identity",
		]
		preconditions: [
			"Identidade alvo está em lifecycle state 'verified'",
			"Sinal observável de perda de elegibilidade (CNPJ baixado, decisão regulatória, comprometimento)",
		]
		postconditions: [
			"Recommendation gerada com rationale + sinais observados + impact estimate",
			"Aguarda human gate; após aprovação: lifecycle transition verified→revoked + evt-identity-revoked emitido + trail preservado per inv-revocation-preserves-trail",
		]
	}, {
		code:        "act-sign-evidence"
		name:        "Sign Evidence (DSSE)"
		description: "Assinar evidência via DSSE vinculando payload a Identidade Organizacional verificada. Operação síncrona; LOG é consumer primário. Impact: state-change + cross-bc (LOG → DLV → INV → FCE downstream). Gate determinístico de 4 invariants (canvas autonomousDecisions sign-evidence): inv-signature-requires-active-identity + inv-cas-content-immutability + inv-signature-idempotency + inv-evidence-class-conforms-taxonomy. Idempotente por construção. AutonomyLevel: propose-and-wait Phase 0 — deterministic-gated mas governance-promotion candidate via envelope. Per founder principle: 'execução autônoma é governança, não spec'. Override Phase 0 documentado: out-of-scope (canvas sign-evidence-gap) é mandatory na escalation enquanto ten-004 não resolve."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-sign-evidence",
			"agg-evidence-cryptography",
			"evt-evidence-signed",
			"inv-signature-requires-active-identity",
			"inv-signature-idempotency",
			"inv-evidence-class-conforms-taxonomy",
			"prj-identity-verification-status",
		]
		preconditions: [
			"Identidade signatária em state 'verified' (consulta sync prj-identity-verification-status; per inv-signature-requires-active-identity)",
			"Conteúdo via CAS endereço-hash íntegro (per inv-cas-content-immutability)",
			"Classe de evidência conforma taxonomia (whitelist Phase 0; per inv-evidence-class-conforms-taxonomy)",
			"Tupla (contentHash, evidenceClass, requestingBoundedContext) ledger-checked (idempotência per inv-signature-idempotency)",
		]
		postconditions: [
			"Recommendation com DSSE envelope + signingOperationId + audit trail com snapshot identity status",
			"Aguarda gate; após aprovação: ledger persistente + evt-evidence-signed emitido (internal audit trail)",
		]
	}, {
		code:        "act-generate-integrity-proof"
		name:        "Generate Integrity Proof"
		description: "Gerar Merkle proof de inclusão para evidência armazenada via CAS, combinando proof CAS + assinatura DSSE para verificação end-to-end. DLV é consumer primário. Impact: state-change + cross-bc (DLV usa para liberação de entrega). Função pura do conteúdo CAS (determinística). AutonomyLevel: propose-and-wait Phase 0 — deterministic-gated mas governance-promotion candidate via envelope (per founder principle)."
		category:        "mutation"
		autonomyLevel:   "propose-and-wait"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"cmd-generate-integrity-proof",
			"agg-evidence-cryptography",
			"evt-integrity-proof-generated",
			"inv-cas-content-immutability",
		]
		preconditions: [
			"Conteúdo presente em CAS (endereço-hash íntegro)",
			"Assinatura DSSE associada existe no ledger",
		]
		postconditions: [
			"Recommendation com IntegrityProof composto (Merkle proof + DSSE + ref a Identidade signatária)",
			"Aguarda gate; após aprovação: evt-integrity-proof-generated emitido (internal audit trail)",
		]
	}, {
		code:        "act-query-identity-verification-status"
		name:        "Query Identity Verification Status"
		description: "Atender query QueryIdentityVerificationStatus consumida por NPM. Retorna IdentityVerificationResult vigente para CNPJ específico. Impact: read-only (consulta a prj-identity-verification-status). Query prevalece sobre eventos previamente recebidos em caso de divergência (per canvas)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-identity-verification-status",
			"qry-identity-verification-status",
		]
		preconditions: ["CNPJ alvo fornecido em formato canônico"]
		postconditions: ["IdentityVerificationResult retornado OR not-found se nenhuma verificação foi tentada"]
	}, {
		code:        "act-query-evidence-integrity"
		name:        "Query Evidence Integrity"
		description: "Atender query QueryEvidenceIntegrity consumida por LOG. Verifica integridade de armazenamento via CAS (hash do conteúdo coincide com endereço). Impact: read-only. Conformist com LOG (sem tradução)."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-evidence-integrity",
			"qry-evidence-integrity",
		]
		preconditions: ["Endereço CAS de evidência fornecido"]
		postconditions: ["Booleano de integridade + hash verificado retornado"]
	}, {
		code:        "act-query-cryptographic-integrity"
		name:        "Query Cryptographic Integrity"
		description: "Atender query QueryCryptographicIntegrity consumida por DLV. Verifica end-to-end: assinatura DSSE válida contra identidade reconhecida e vigente em IDC; Merkle proof consistente; conteúdo não adulterado. Impact: read-only. Query única evita N round-trips entre verificações parciais."
		category:        "query"
		autonomyLevel:   "execute-and-log"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"prj-cryptographic-integrity",
			"qry-cryptographic-integrity",
		]
		preconditions: ["Referência a evidência + identidade signatária fornecida"]
		postconditions: ["Resultado de verificação composta (signature + merkle + identity vigente) retornado"]
	}, {
		code:        "act-detect-signature-pattern-anomaly"
		name:        "Detect Signature Pattern Anomaly"
		description: "Self-monitoring estatístico de padrões de assinatura. Detecta desvios de baseline (volume, classes de evidência, BCs solicitantes) que sugerem identity-compromise-suspected ou drift-detected-in-verification-pattern (canvas escalations). Impact: read-only. Mecanismo SECUNDÁRIO de defesa per canvas — defesa primária estrutural depende de PLT (substrato comum, ainda não formalizado)."
		category:        "escalation"
		autonomyLevel:   "collect-and-report"
		inputTrustLevel: "trusted-internal"
		domainModelRefs: [
			"agg-evidence-cryptography",
			"evt-evidence-signed",
		]
		preconditions: ["Histórico recente de operações criptográficas disponível"]
		postconditions: ["Anomaly report + recommendation; nenhum state change"]
	}]

	// =============================================
	// CONSTRAINTS (regras enforced pelo agente)
	// =============================================
	//
	// Cada constraint declara em rationale: enforcementLevel
	// (agent / runner / domain / external) per tq-agg-05 e
	// derivedFromInvariant per tq-agg-06. Schema não modela esses
	// campos como first-class hoje (heuristic-level).

	constraints: [{
		code:         "cst-source-authority-mandatory"
		name:         "Source Authority Mandatory"
		description:  "act-execute-identity-verification NUNCA emite evt-identity-verified sem ≥1 VerificationSourceReference auditada."
		verification: "Runner verifica que para cada evt-identity-verified emitido, audit trail contém ≥1 source-references-consulted não-vazio. Self-attestation isolada (zero fontes externas) bloqueia emissão."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-source-authority-required. enforcementLevel: agent (gate pré-emissão) + external (RF/JC/bureaus são fontes autoritativas). Constraint regulatório (sh-04 regulador SCD/Bacen). Self-attestation viola diligência regulatória."
	}, {
		code:         "cst-revocation-preserves-trail"
		name:         "Revocation Preserves Trail"
		description:  "act-propose-identity-revocation NUNCA recomenda exclusão de registros que invalidem audit retrospectivo; revogação muda STATE, não APAGA registros."
		verification: "Runner verifica que recommendation de revogação propõe state transition (verified→revoked) e NÃO operação de delete em ledger/CAS. Audit trail preserva todos eventos e assinaturas anteriores à revogação."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-revocation-preserves-trail. enforcementLevel: domain (lifecycle do agg-organizational-identity proíbe transição revoked→deleted; storage append-only protege por construção). Agente apenas propõe; protection real vive no aggregate. Capability cc-04 (auditoria contínua) exige reconstituição regulatória."
	}, {
		code:         "cst-signature-requires-active-identity"
		name:         "Signature Requires Active Identity"
		description:  "act-sign-evidence NUNCA emite assinatura sem identidade signatária em state 'verified' no momento da emissão."
		verification: "Runner verifica que para cada act-sign-evidence, audit trail contém snapshot de prj-identity-verification-status retornando status='verified' (≠ unverified, rejected, revoked) ANTES de emitir DSSE envelope. Lookup é sync via projection."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-signature-requires-active-identity. enforcementLevel: agent (gate Phase 0 via consulta a prj-identity-verification-status pré-assinatura). Pós-resolução de oq-idc-1 (protocolo de propagação ativa de revogação), enforcement vira domain por construção. Phase 0 caveat: agente é único enforcer parcial (canonical removal test red flag declarado)."
	}, {
		code:         "cst-cas-content-immutability"
		name:         "CAS Content Immutability"
		description:  "act-sign-evidence e act-generate-integrity-proof operam exclusivamente sobre conteúdo via endereço CAS (hash do próprio conteúdo)."
		verification: "Runner verifica que content references em audit trail são endereços CAS (formato hash + algoritmo declarado), não paths mutáveis. Modificação de conteúdo muda endereço por construção, tornando adulteração detectável."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-cas-content-immutability. enforcementLevel: domain (propriedade física do esquema CAS — endereço é hash; modificação muda endereço). Agente apenas consome endereço; protection vive no esquema de armazenamento. Cap-1 do canvas (CAS Addressing) é capability declarada."
	}, {
		code:         "cst-signature-idempotency"
		name:         "Signature Idempotency"
		description:  "act-sign-evidence NUNCA emite duas assinaturas distintas para mesma tupla (contentHash, evidenceClass, requestingBoundedContext)."
		verification: "Runner verifica que act-sign-evidence consulta ledger por tupla ANTES de emitir; se hit, retorna assinatura previamente emitida sem regenerar. signingOperationId é root identity persistente em agg-evidence-cryptography."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-signature-idempotency. enforcementLevel: agent (lookup pré-emissão) + domain (signingOperationId persistente em agg-evidence-cryptography deduplica via tupla). Aggregate persiste estado; agente consulta. Idempotência é pré-condição para retry seguro por consumers (LOG)."
	}, {
		code:         "cst-evidence-class-conforms-taxonomy"
		name:         "Evidence Class Conforms Taxonomy"
		description:  "act-sign-evidence NUNCA assina evidência cuja classe declarada está fora da taxonomia canônica."
		verification: "Runner verifica que evidenceClass do request está em whitelist de classes conhecidas (Phase 0). Pós-ten-004: validação contra taxonomia formal canônica."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: inv-evidence-class-conforms-taxonomy. enforcementLevel: agent (whitelist Phase 0). Pós-resolução de ten-004 (taxonomia canônica), enforcement vira domain por construção (taxonomia formal). Phase 0 caveat: agente é único enforcer (canonical removal test red flag declarado)."
	}, {
		code:         "cst-rejection-and-revocation-require-supervision"
		name:         "Rejection and Revocation Require Supervision"
		description:  "act-execute-identity-verification (outcome rejected) e act-propose-identity-revocation NUNCA materializam state change sem aprovação humana em Phase 0."
		verification: "Runner verifica que para cada outcome rejected ou revocation recommendation, audit trail contém approval timestamp + approver-id ANTES de emitir event correspondente. autonomyLevel propose-and-wait é hard gate."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: (operacional, não derivado de invariant formal — sustenta canvas supervisedDecisions reject-identity-* e revoke-identity). enforcementLevel: agent (autonomyLevel propose-and-wait declarada no spec). Falso-negativo bloqueia organização legítima; revogação invalida cadeia downstream — irreversíveis operacionalmente exigem human gate Phase 0."
	}, {
		code:         "cst-cnpj-format-valid"
		name:         "CNPJ Format Valid"
		description:  "act-execute-identity-verification NUNCA chama fontes externas com CNPJ que falha validação de dígitos verificadores."
		verification: "Runner verifica que act-validate-cnpj-format precede act-execute-identity-verification em audit trail; CNPJ inválido bloqueia chamada externa (gate técnico)."
		onViolation:  "block-and-escalate"
		rationale:    "derivedFromInvariant: (técnico, gate pré-protocolo — não derivado de invariant formal). enforcementLevel: agent (validação dígitos verificadores in-line). Pré-condição de qualquer chamada externa: CNPJ malformado é desperdício de quota de fonte externa + log poluído."
	}]

	// =============================================
	// ESCALATION CONDITIONS (when to halt and escalate)
	// =============================================
	//
	// Default global. Per-action override Phase 0 documentado em
	// rationale de actions críticas (e.g., act-sign-evidence: out-of-
	// scope mandatory enquanto ten-004 não resolve).

	escalationConditions: [{
		category:    "conflicting-signals"
		description: "Fontes externas autoritativas divergem entre si sobre o mesmo CNPJ (ex.: RF confirma identidade, JC retorna baixa). Outcome do protocolo não é derivável."
		rationale:   "Cobertura tq-ag-10 para mutations (act-execute-identity-verification, act-sign-evidence). Sem escalation, agente operaria com autonomia implícita ilimitada em divergência de fontes — viola P10."
	}, {
		category:    "insufficient-context"
		description: "Fonte autoritativa indisponível ou retorna dados ambíguos durante verificação; canvas escalation 'verification-source-systematic-failure' (>X% falhas em janela)."
		rationale:   "Cobertura tq-ag-10 para mutations. Indisponibilidade sistemática de fonte exige fallback humano ou postergação — não é caso para outcome rejected automático."
	}, {
		category:    "suspicious-input"
		description: "Padrão anômalo em requisições de assinatura (canvas 'signature-pattern-anomaly') OR requisição de BC fora da whitelist Phase 0 (canvas 'sign-evidence-gap')."
		rationale:   "Cobertura tq-ag-10 para validations + integração externa intensa. IDC integra com fontes externas (RF/JC/bureaus) e processa requests de múltiplos BCs — suspicious-input é vetor real."
	}, {
		category:    "ambiguous-case"
		description: "CNPJ com dígitos válidos mas ausente em todas as fontes consultadas (não confirma fraude, não confirma não-existência)."
		rationale:   "Cobertura tq-ag-10. Caso intermediário entre verified e rejected — ambiguidade de domínio que protocolo não resolve sozinho."
	}, {
		category:    "out-of-scope"
		description: "Requisição de classe de evidência fora da taxonomia interna (Phase 0 antes de ten-004 resolver) — canvas escalation 'sign-evidence-gap'."
		rationale:   "Phase 0 caveat: até taxonomia formal existir, requests fora de whitelist exigem supervisão. Per-action override em act-sign-evidence: out-of-scope é mandatory escalation."
	}, {
		category:    "unclassifiable-anomaly"
		description: "Canvas escalation 'identity-compromise-suspected' — assinaturas anômalas (volume, classes, padrões) sugerem comprometimento de identidade. Contenção imediata."
	rationale:   "Comprometimento compromete TODA evidência assinada com identidade afetada — escalation prioritária sobre throughput operacional."
	}, {
		category:    "unclassifiable-anomaly"
		description: "Canvas escalation 'drift-detected-in-verification-pattern' — desvio estatístico no self-monitoring (act-detect-signature-pattern-anomaly). Investigação humana antes que padrão se consolide."
		rationale:   "Drift latente vira padrão consolidado se não interceptado cedo. Self-monitoring é mecanismo secundário per canvas — escalation humana é o gate."
	}]

	// =============================================
	// CONTEXT REQUIREMENTS
	// =============================================

	contextRequirements: {
		artifacts: [{
			artifactType: "canvas"
			rationale:    "Canvas IDC declara purpose, capabilities (cap-1 CAS, cap-2 verificação, cap-3 assinatura), business decisions (autonomousDecisions/supervisedDecisions/escalatedDecisions), communication (inbound commands + outbound events), incentive analysis (janela de inconsistência cache stale), governance scope. Slices necessários para operar todas as actions."
			requiredSlices: [
				"ownership",
				"governanceScope",
				"incentiveAnalysis",
				"communication",
				"capabilities",
			]
		}, {
			artifactType: "domain-model"
			rationale:    "Source of truth para operationalScope refs (aggregates, commands, events, invariants, projections). Necessário para cada action validar domainModelRefs ⊆ operationalScope per tq-ag-02."
		}, {
			artifactType: "glossary"
			rationale:    "Terminologia canônica do BC IDC (CnpjIdentifier, IdentityVerificationResult, DSSE, Merkle proof, CAS, Trilha de Auditoria Criptográfica). Action names + audit trail field semantics alinham com glossary."
			requiredSlices: ["terms"]
		}, {
			artifactType: "agent-governance"
			rationale:    "Envelope idc-primary-agent.governance.cue declara autonomyOverrides atuais, escalationRouting (channel + SLA + recipient por category), blastRadiusCaps, calibration (promotion/regression criteria), driftDetection. Agent consulta envelope para resolver QUANDO escalar (do spec) → COMO escalar (do envelope)."
		}, {
			artifactType: "context-map"
			rationale:    "IDC integra cross-BC: NPM (consume QueryIdentityVerificationStatus), LOG (consume act-sign-evidence), DLV (consume QueryCryptographicIntegrity), e fontes externas (RF/JC/bureaus). Context map slice de relationships com IDC como upstream/downstream informa contracts."
			requiredSlices: ["relationships"]
		}]
		estimatedBudget: "heavy"
	}

	// =============================================
	// OBSERVABILITY
	// =============================================

	observability: {
		signals: [{
			code:           "sig-mutation-executed"
			name:           "Mutation Executed"
			description:    "Sinal emitido após command processado (post-approval em propose-and-wait). Cobertura: act-execute-identity-verification, act-propose-identity-revocation, act-sign-evidence, act-generate-integrity-proof."
			coversCategory: "mutation"
			trigger:        "Imediatamente após state transition no aggregate + emit event"
			level:          "info"
		}, {
			code:           "sig-validation-result"
			name:           "Validation Result"
			description:    "Sinal emitido após act-validate-cnpj-format e act-normalize-identity-data. Reporta outcome (success/failure) + rationale técnico."
			coversCategory: "validation"
			trigger:        "Após validação técnica concluída"
			level:          "info"
		}, {
			code:           "sig-escalation-triggered"
			name:           "Escalation Triggered"
			description:    "Sinal emitido quando qualquer escalationCondition dispara. Captura category + rationale + action que disparou + recommendation se aplicável."
			coversCategory: "escalation"
			trigger:        "EscalationCondition disparada (any category)"
			level:          "warn"
		}, {
			code:           "sig-query-served"
			name:           "Query Served"
			description:    "Sinal emitido após cada query atendida. Cobertura: act-query-identity-verification-status, act-query-evidence-integrity, act-query-cryptographic-integrity."
			coversCategory: "query"
			trigger:        "Após retorno de query consumida por NPM/LOG/DLV"
			level:          "info"
		}, {
			code:           "sig-supervision-requested"
			name:           "Supervision Requested"
			description:    "Sinal emitido quando autonomyLevel propose-and-wait gera recommendation aguardando aprovação humana. Cobertura: todas mutations Phase 0 + escalation actions."
			coversCategory: "mutation"
			trigger:        "Recommendation criada, aguardando aprovação"
			level:          "info"
		}, {
			code:           "sig-constraint-violation"
			name:           "Constraint Violation"
			description:    "Sinal emitido quando onViolation block-and-escalate ativada em qualquer constraint. Captura constraint code + invariant origem + violation context."
			coversCategory: "mutation"
			trigger:        "Constraint violation detectada"
			level:          "error"
		}, {
			code:           "sig-cryptographic-operation-emitted"
			name:           "Cryptographic Operation Emitted"
			description:    "Sinal IDC-specific emitido após act-sign-evidence ou act-generate-integrity-proof. Captura signingOperationId, evidenceClass, requestingBoundedContext, contentHash. Permite reconstrução do trail criptográfico independente do agent log."
			coversCategory: "mutation"
			trigger:        "Operação criptográfica concluída e materializada no ledger"
			level:          "info"
		}]
		auditTrail: {
			requiredFields: [
				"timestamp",
				"agent-id",
				"action-code",
				"input-summary",
				"output-summary",
				"decision-rationale",
				"governance-version",
				"cnpj-subject",
				"signing-operation-id",
				"evidence-class",
				"source-references-consulted",
			]
			storageHint: "Event Log imutável do IDC + Trilha de Auditoria Criptográfica (per term-trilha-de-auditoria-criptografica do glossary IDC). Audit trail do agente em partição dedicada com retention regulatory-grade (mínimo 5 anos per Bacen)."
			rationale:   "7 mínimos cobrem reconstituição genérica (timestamp/agent-id/action-code/input-summary/output-summary/decision-rationale/governance-version). 4 IDC-specific (cnpj-subject/signing-operation-id/evidence-class/source-references-consulted) cobrem reconstituição de contexto específica do BC: cnpj-subject vincula audit a Identidade Organizacional; signing-operation-id é root identity de agg-evidence-cryptography (null para operações não-criptográficas); evidence-class sustenta inv-evidence-class-conforms-taxonomy auditável; source-references-consulted sustenta inv-source-authority-required + reconstituição regulatória sh-04. Audit reconstrutível (teste canônico): dado o registro, é possível reconstituir inputs + decisão + rationale + outcome."
		}
	}

	rationale: """
		IDC é a raiz de confiança da Mesh — único BC que verifica
		identidade organizacional contra fontes autoritativas,
		assina evidência via DSSE e gera Merkle proofs. agt-idc-
		primary é o operador único deste BC: executa protocolo de
		verificação, executa operações criptográficas sob gate
		determinístico de invariantes, e propõe (sob supervisão)
		decisões irreversíveis (revogação) que afetam acesso à
		rede de organizações inteiras.

		Spec ↔ Governance separation per ADR-037: este spec declara
		CAPACIDADE operacional + QUANDO escalar; envelope (idc-
		primary-agent.governance.cue, par sequencial) declara
		AUTONOMIA atual via promotion criteria + autonomyOverrides
		intermediários + COMO escalar (channel/SLA/recipient).

		Princípio canônico (post-founder review 2026-05-01):
		Phase 0 baseline TODAS mutations propose-and-wait, mesmo
		actions deterministic-gated (act-execute-identity-
		verification, act-sign-evidence, act-generate-integrity-
		proof). Canvas autonomousDecisions significa "não exige
		julgamento humano (gate determinístico)", NÃO "execução
		sem governança". Promotion para execute-and-log dessas
		3 mutations é decisão do envelope.governance via promotion
		criteria + métricas + rollback automático per failure-
		Handling — preserva P10 (gates determinísticos validam,
		agentes recomendam dentro do envelope de autonomia
		governado). tq-gv-14 bloqueia override execute-and-log
		direto; envelope poderá declarar promotion path com
		intermediários (collect-and-report, propose-and-wait com
		fast-track) sem violar P10.

		Canonical removal test (tq-agg-10): SE remover agt-idc-
		primary, 3 das 6 invariantes ficam totalmente protegidas
		(inv-revocation-preserves-trail via lifecycle do aggregate;
		inv-cas-content-immutability via propriedade física do
		esquema CAS; inv-signature-idempotency via signingOperationId
		persistente em agg-evidence-cryptography). 3 das 6 ficam
		com cobertura parcial Phase 0 (inv-source-authority-
		required, inv-signature-requires-active-identity, inv-
		evidence-class-conforms-taxonomy) — agente é único enforcer
		operacional até resolução estrutural via ten-003 (protocolo
		de revogação ativa) e ten-004 (taxonomia canônica de
		evidência). NÃO é red flag oculto — é red flag conhecido,
		declarado em canvas, com caminho de resolução documentado
		em tension entries. Pós-resolução, enforcement migra para
		domain (lifecycle / projection / aggregate), agente vira
		operador puro (observa + recomenda).

		Phase 0 caveats explícitos:
		- act-propose-identity-revocation modela protocolo ainda
		  não formalizado (oq-idc-1) — anchor para evolução; gate
		  humano hard-required.
		- inv-signature-requires-active-identity sustentada por
		  configuração operacional + escalation 'sign-evidence-gap'
		  + per-action override out-of-scope mandatory em act-sign-
		  evidence até oq-idc-1 resolver.
		- inv-evidence-class-conforms-taxonomy sustentada por
		  whitelist Phase 0 + escalation até ten-004 resolver.
		- evt-identity-revoked modelado mas protocolo de propagação
		  ativa não formalizado (oq-idc-1); janela de inconsistência
		  cache stale tem cobertura parcial via TTL passivo +
		  reconciliação externa até propagação ativa existir.
		- self-monitoring (act-detect-signature-pattern-anomaly) é
		  mecanismo SECUNDÁRIO per canvas — defesa primária
		  estrutural depende de PLT (substrato comum, ainda não
		  formalizado).

		Volume catalog: 10 actions (3 mutations + 3 queries + 1
		validation + 1 generation + 1 escalation + 1 supplementary
		mutation propose-revocation), 8 constraints (6 derivadas
		1:1 de invariantes + 2 operacionais), 7 escalation
		conditions (cobertura tq-ag-10 + categorias canvas), 7
		signals (6 canônicos + sig-cryptographic-operation-emitted
		IDC-specific), 11 audit fields (7 mínimos + 4 IDC-specific
		para reconstituição regulatória). Tamanho ~430 linhas
		alinhado com exemplares (cmt 370, ctr 340, npm 381) +
		incremento por inputTrustLevel external-structured em 2
		actions de input externo + rationale de Phase 0 caveats.

		Glossary alignment: action names + signal codes + audit
		field names alinhados com glossary IDC. Sem divergências
		terminológicas identificadas nesta autoria.
		"""
}
