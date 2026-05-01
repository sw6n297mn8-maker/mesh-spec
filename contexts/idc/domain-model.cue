package idc

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// domain-model.cue — Domain Model do BC Identity & Data Governance.
// Instância de #DomainModel (architecture/artifact-schemas/domain-model.cue).
//
// Aplicação manual do production-guide architecture/production-guides/
// domain-model.cue (Phase 0 de adr-054; pre-WI-069). Cascade ordering
// per adr-054 decision item 13: PG existe (commit 48362a0).
//
// Modela 2 aggregates: agg-organizational-identity (verificação +
// revogação de identidade organizacional) e agg-evidence-cryptography
// (assinatura DSSE + geração de Merkle proofs). Authorization
// (terceiro pilar do canvas IDC) deferida per oq-idc-2 — modelo
// (binário/RBAC/ABAC) ainda não fixado; seguir heuristic do PG
// "lifecycle especulativo é pior que sem lifecycle".
//
// Behavior-first ordering aplicado: events identificados primeiro do
// canvas (publishers + resultingEvents + audit trail interno),
// commands identificados por intenções, invariants protegidos
// derivados de businessDecisions, value-objects emergentes dos
// payloads. Aggregates wirando catalog.
//
// Glossary alignment: events/commands/aggregates names reconciliados
// com terms canônicos do glossary IDC (commit 7641262). Divergência
// terminológica esperada com canvas seria registrada como tension —
// nenhuma divergência identificada nesta autoria.

domainModel: artifact_schemas.#DomainModel & {
	code:              "idc"
	name:              "Identity & Data Governance"
	boundedContextRef: "idc"

	// =============================================
	// EVENTS (catalog top-level)
	// =============================================

	events: [{
		code:        "evt-identity-verification-completed"
		name:        "IdentityVerificationCompleted"
		description: "Verificação de identidade organizacional concluída com resultado (verificada ou não); inclui metadata de fontes consultadas e timestamp."
		rationale:   "Event publisher declarado em canvas.communication.outbound[]. Consumido por NPM como trigger de avanço em qualificação. Query QueryIdentityVerificationStatus é SoT no momento da decisão (per canvas — query prevalece sobre evento previamente recebido)."
		visibility:  "published"
	}, {
		code:        "evt-identity-revoked"
		name:        "IdentityRevoked"
		description: "Identidade organizacional previamente verificada foi marcada como não-vigente após perda de elegibilidade (baixa de CNPJ, decisão regulatória, comprometimento detectado)."
		rationale:   "Cobertura de oq-idc-1 (protocolo de revogação). Antecipa propagação ativa para minimizar Janela de Inconsistência (ten-003); consumed por NPM/LOG/DLV para invalidação de cache. Em Phase 0 sem protocolo formalizado, evento serve como anchor para futura ativação."
		visibility:  "published"
	}, {
		code:        "evt-evidence-signed"
		name:        "EvidenceSigned"
		description: "Evidência operacional assinada criptograficamente via DSSE vinculando a Identidade Organizacional verificada que originou a assinatura."
		rationale:   "Event interno declarado em canvas.communication.inbound[1].resultingEvents (audit trail). Não publicado externamente per canvas — operação sync retorna assinatura na resposta a LOG. Evento serve audit trail criptográfico (capability cc-04)."
		visibility:  "internal"
	}, {
		code:        "evt-integrity-proof-generated"
		name:        "IntegrityProofGenerated"
		description: "Merkle proof de integridade gerada para conjunto de evidências armazenadas via CAS, vinculando Assinatura DSSE e identidade verificada."
		rationale:   "Event interno declarado em canvas.communication.inbound[2].resultingEvents (audit trail). Não publicado externamente — operação sync retorna proof na resposta a DLV. Evento serve audit trail (capability cc-04)."
		visibility:  "internal"
	}]

	// =============================================
	// COMMANDS (intenções de mudança de estado)
	// =============================================

	commands: [{
		code:        "cmd-verify-organization-identity"
		name:        "VerifyOrganizationIdentity"
		description: "Iniciar processo de verificação de identidade organizacional via cruzamento com fontes oficiais (Receita Federal, Junta Comercial, bureaus). Async; resultado persistente."
		rationale:   "Command-handler async declarado em canvas.communication.inbound[0]. Pré-condição de onboarding via NPM. Async porque latência de fontes externas é variável."
	}, {
		code:        "cmd-revoke-identity"
		name:        "RevokeIdentity"
		description: "Marcar Identidade Organizacional verificada como não-vigente após perda de elegibilidade ou comprometimento detectado."
		rationale:   "Cobertura de oq-idc-1. Em Phase 0, command modelado para anchor; protocolo concreto de execução depende de decisão futura sobre TTL/propagação ativa (ten-003)."
	}, {
		code:        "cmd-sign-evidence"
		name:        "SignEvidence"
		description: "Assinar evidência via DSSE (Dead Simple Signing Envelope) vinculando payload a Identidade Organizacional verificada. Sync; gates determinísticos (4 invariants per canvas autonomousDecisions sign-evidence)."
		rationale:   "Command-handler sync declarado em canvas.communication.inbound[1]. LOG é consumer primário. Operação idempotente (mesma tupla content+class+BC retorna assinatura previamente emitida)."
	}, {
		code:        "cmd-generate-integrity-proof"
		name:        "GenerateIntegrityProof"
		description: "Gerar Merkle proof de inclusão para evidência armazenada via CAS, combinando proof de integridade de armazenamento + assinatura DSSE para verificação end-to-end."
		rationale:   "Command-handler sync declarado em canvas.communication.inbound[2]. DLV é consumer primário. Operação determinística — proof é função pura do conteúdo CAS."
	}]

	// =============================================
	// INVARIANTS (regras protegidas)
	// =============================================

	invariants: [{
		code: "inv-source-authority-required"
		name: "Source Authority Required"
		rule: "Verificação de identidade organizacional NUNCA opera apenas com self-attestation; SEMPRE cruza dados com ≥1 fonte oficial autoritativa (Receita Federal, Junta Comercial, bureaus)."
		rationale: "Constraint regulatório (sh-04 regulador) e de design (bd-verify-not-interpret). Self-attestation isolada não satisfaz diligência regulatória SCD/Bacen. Fontes externas são as-idc-1."
	}, {
		code: "inv-revocation-preserves-trail"
		name: "Revocation Preserves Audit Trail"
		rule: "Revogação de identidade marca como não-vigente preservando histórico criptográfico verificável; NUNCA exclui registros que invalidem auditoria retrospectiva."
		rationale: "Capability cc-04 (auditoria contínua) exige reconstituição regulatória. Distinção fundamental entre revogação (estado) e exclusão (apagamento) — confundir cria risco regulatório."
	}, {
		code: "inv-signature-requires-vigent-identity"
		name: "Signature Requires Vigent Identity"
		rule: "Assinatura DSSE NUNCA é emitida com identidade revogada ou suspensa; identidade signatária deve estar em estado vigente no momento da emissão."
		rationale: "Gate determinístico (2) per canvas autonomousDecisions sign-evidence. Em Phase 0 antes de oq-idc-1 resolver, sustentado por configuração operacional + escalation sign-evidence-gap. Pós-oq-idc-1 vira gate por construção."
	}, {
		code: "inv-cas-content-immutability"
		name: "CAS Content Immutability"
		rule: "Endereço CAS de qualquer conteúdo armazenado é o hash criptográfico do próprio conteúdo; modificação do conteúdo muda o endereço por construção, tornando adulteração detectável."
		rationale: "Propriedade fundamental de CAS Addressing per bd-crypto-single-owner. Não é regra de negócio em sentido estrito — é invariante físico do esquema de armazenamento que IDC owns."
	}, {
		code: "inv-signature-idempotency"
		name: "Signature Idempotency"
		rule: "Mesma tupla (hash do conteúdo, classe de evidência, BC solicitante) NUNCA produz duas assinaturas distintas; reexecução retorna a assinatura previamente emitida."
		rationale: "Gate determinístico (4) per canvas autonomousDecisions sign-evidence. Idempotência é pré-condição para retry seguro por consumers (LOG) sem proliferação de assinaturas."
	}, {
		code: "inv-evidence-class-conforms-taxonomy"
		name: "Evidence Class Conforms Taxonomy"
		rule: "Evidência submetida para assinatura conforma com schema da classe declarada na taxonomia canônica de evidência."
		rationale: "Gate determinístico (3) per canvas autonomousDecisions sign-evidence. Em Phase 0 antes de ten-004 resolver, sustentado por whitelist + escalation sign-evidence-gap. Pós-ten-004 vira gate por construção."
	}]

	// =============================================
	// VALUE OBJECTS (catalog top-level)
	// =============================================

	valueObjects: [{
		code:        "vo-cnpj-identifier"
		name:        "CnpjIdentifier"
		description: "Identificador de pessoa jurídica brasileira (CNPJ); formato canônico XX.XXX.XXX/XXXX-XX validado contra dígitos verificadores."
		fields: [{
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Identidade externa de Identidade Organizacional. CNPJ é identifier regulatório SCD/Bacen — validação de formato é pré-condição de qualquer verificação contra fontes oficiais."
	}, {
		code:        "vo-identity-verification-result"
		name:        "IdentityVerificationResult"
		description: "Resultado estruturado de verificação de identidade organizacional retornado por QueryIdentityVerificationStatus; inclui status, timestamp, fontes consultadas, divergências detectadas."
		fields: [{
			kind: "primitive"
			name: "status"
			type: "string"
		}, {
			kind: "primitive"
			name: "verifiedAt"
			type: "datetime"
		}, {
			kind: "domain-type"
			name: "sourcesConsulted"
			type: "VerificationSourceList"
		}]
		rationale: "Estrutura consumida por NPM como SoT de verificação no momento de qualificação. Distinta de Identidade Organizacional (entity) — result é snapshot temporal."
	}, {
		code:        "vo-verification-source-reference"
		name:        "VerificationSourceReference"
		description: "Referência a fonte oficial autoritativa consultada durante verificação (RF, JC, bureaus); inclui identificação da fonte, timestamp da consulta, hash do response."
		fields: [{
			kind: "primitive"
			name: "sourceName"
			type: "string"
		}, {
			kind: "primitive"
			name: "consultedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "responseHash"
			type: "string"
		}]
		rationale: "Composabilidade de IdentityVerificationResult; reutilizado em audit trail (Trilha de Auditoria Criptográfica) para reconstituição regulatória."
	}, {
		code:        "vo-content-hash"
		name:        "ContentHash"
		description: "Hash criptográfico de conteúdo arbitrário usado como endereço CAS; algoritmo declarado (SHA-256 default). Identidade do conteúdo no esquema CAS."
		fields: [{
			kind: "primitive"
			name: "algorithm"
			type: "string"
		}, {
			kind: "primitive"
			name: "value"
			type: "string"
		}]
		rationale: "Tipo fundamental do esquema CAS Addressing. Reutilizado por DsseEnvelope, MerkleProof e IntegrityProof; centralizá-lo evita drift de algoritmo entre primitivas."
	}, {
		code:        "vo-dsse-envelope"
		name:        "DsseEnvelope"
		description: "Envelope de assinatura no padrão Dead Simple Signing Envelope; inclui payloadType, payload (base64), signatures (lista de signature blocks com keyid + sig)."
		fields: [{
			kind: "primitive"
			name: "payloadType"
			type: "string"
		}, {
			kind: "primitive"
			name: "payloadBase64"
			type: "string"
		}, {
			kind: "domain-type"
			name: "signatures"
			type: "DsseSignatureList"
		}]
		rationale: "Formato canônico de assinatura per bd-crypto-single-owner. payloadType identifica classe de evidência (vincula a inv-evidence-class-conforms-taxonomy). signatures permite multi-key future."
	}, {
		code:        "vo-merkle-proof"
		name:        "MerkleProof"
		description: "Sequência de hashes criptográficos provando inclusão de uma evidência em conjunto sem expor o conjunto inteiro; permite verificação independente."
		fields: [{
			kind:           "value-object-ref"
			name:           "leaf"
			valueObjectRef: "vo-content-hash"
		}, {
			kind: "domain-type"
			name: "path"
			type: "ContentHashList"
		}, {
			kind:           "value-object-ref"
			name:           "root"
			valueObjectRef: "vo-content-hash"
		}]
		rationale: "Privacy-preserving verification para sh-03 (instituição financeira parceira). Estrutura imutável — proof gerado é determinístico função do conjunto."
	}, {
		code:        "vo-integrity-proof"
		name:        "IntegrityProof"
		description: "Artefato composto retornado por GenerateIntegrityProof; combina Merkle Proof + DSSE Signature + ref a Identidade signatária para verificação criptográfica end-to-end."
		fields: [{
			kind:           "value-object-ref"
			name:           "merkleProof"
			valueObjectRef: "vo-merkle-proof"
		}, {
			kind:           "value-object-ref"
			name:           "dsseEnvelope"
			valueObjectRef: "vo-dsse-envelope"
		}, {
			kind:           "value-object-ref"
			name:           "signerIdentity"
			valueObjectRef: "vo-cnpj-identifier"
		}]
		rationale: "Output composto de cmd-generate-integrity-proof. Consumed por DLV para verificação de lastro independente de confiança institucional em Mesh."
	}]

	// =============================================
	// AGGREGATES (consistency boundaries)
	// =============================================

	aggregates: [{
		code:        "agg-organizational-identity"
		name:        "OrganizationalIdentity"
		description: "Aggregate root da Identidade Organizacional. Consistency boundary para verificação inicial, manutenção de estado de elegibilidade, e revogação. Cada CNPJ tem exatamente uma Identidade Organizacional em IDC; mutações de estado (verificação concluída, suspensão, revogação) são atômicas no escopo deste aggregate."
		rootIdentity: {
			field: "cnpj"
			type: {
				kind:           "value-object-ref"
				valueObjectRef: "vo-cnpj-identifier"
			}
		}
		fields: [{
			kind: "primitive"
			name: "status"
			type: "string"
		}, {
			kind: "primitive"
			name: "verifiedAt"
			type: "datetime"
		}, {
			kind: "primitive"
			name: "revokedAt"
			type: "datetime"
		}]
		handlesCommands: [
			"cmd-verify-organization-identity",
			"cmd-revoke-identity",
		]
		emitsEvents: [
			"evt-identity-verification-completed",
			"evt-identity-revoked",
		]
		protectsInvariants: [
			"inv-source-authority-required",
			"inv-revocation-preserves-trail",
		]
		usesValueObjects: [
			"vo-cnpj-identifier",
			"vo-identity-verification-result",
			"vo-verification-source-reference",
		]
		lifecycle: {
			initialState: "unverified"
			states: [
				"unverified",
				"verified",
				"suspended",
				"revoked",
			]
			transitions: [{
				from:               "unverified"
				to:                 "verified"
				triggeredByCommand: "cmd-verify-organization-identity"
				emitsEvents:        ["evt-identity-verification-completed"]
				guards:             ["inv-source-authority-required"]
				description:        "Verificação concluída com sucesso contra fontes oficiais; identidade torna-se base de confiança para operações downstream."
			}, {
				from:               "verified"
				to:                 "revoked"
				triggeredByCommand: "cmd-revoke-identity"
				emitsEvents:        ["evt-identity-revoked"]
				guards:             ["inv-revocation-preserves-trail"]
				description:        "Revogação após perda de elegibilidade; trail preservado per inv-revocation-preserves-trail."
			}, {
				from:               "suspended"
				to:                 "revoked"
				triggeredByCommand: "cmd-revoke-identity"
				emitsEvents:        ["evt-identity-revoked"]
				guards:             ["inv-revocation-preserves-trail"]
				description:        "Revogação direta de estado suspenso quando comprometimento é confirmado."
			}]
		}
		rationale: "Consistency boundary natural — cada CNPJ tem exactly um Identidade Organizacional; transições de estado (verificação, revogação) devem ser atômicas para evitar identidades em estado inconsistente. Lifecycle explícito porque states são canonicalmente declarados em ten-003 e canvas incentiveAnalysis cache stale vector."
	}, {
		code:        "agg-evidence-cryptography"
		name:        "EvidenceCryptography"
		description: "Aggregate de operações criptográficas (assinatura DSSE + geração de Merkle proof). Cada operação é uma transação atômica identificada por signingOperationId; idempotente por construção (mesma tupla retorna mesma assinatura). Aggregate é stateless em sentido tradicional — não tem state machine — mas agrupa commands que compartilham invariants criptográficas e dependem de Identidade Organizacional vigente."
		rootIdentity: {
			field: "signingOperationId"
			type: {
				kind: "primitive"
				type: "string"
			}
		}
		handlesCommands: [
			"cmd-sign-evidence",
			"cmd-generate-integrity-proof",
		]
		emitsEvents: [
			"evt-evidence-signed",
			"evt-integrity-proof-generated",
		]
		protectsInvariants: [
			"inv-signature-requires-vigent-identity",
			"inv-cas-content-immutability",
			"inv-signature-idempotency",
			"inv-evidence-class-conforms-taxonomy",
		]
		usesValueObjects: [
			"vo-content-hash",
			"vo-dsse-envelope",
			"vo-merkle-proof",
			"vo-integrity-proof",
			"vo-cnpj-identifier",
		]
		rationale: "Consistency boundary separado de OrganizationalIdentity por: (1) operações criptográficas dependem de identidade vigente mas não mutam identidade (referência cross-aggregate via inv-signature-requires-vigent-identity); (2) idempotência de assinatura (inv-signature-idempotency) é invariante exclusivo deste aggregate; (3) escala operacional distinta — assinaturas/proofs são alta-frequência, verificação de identidade é baixa-frequência. Sem lifecycle — operações são atômicas e immutáveis após emissão; lifecycle especulativo violaria heuristic do PG."
	}]

	// =============================================
	// PROJECTIONS (read models)
	// =============================================

	projections: [{
		code:        "prj-identity-verification-status"
		name:        "IdentityVerificationStatusProjection"
		description: "Read model que materializa estado vigente de verificação de identidade por CNPJ; consumido por NPM via QueryIdentityVerificationStatus como SoT no momento da qualificação."
		consumesEvents: [
			"evt-identity-verification-completed",
			"evt-identity-revoked",
		]
		queryCapabilities: [{
			code:        "qry-identity-verification-status"
			description: "Retorna IdentityVerificationResult vigente para um CNPJ específico, ou not-found se identidade não foi verificada."
			rationale:   "SoT no momento de qualificação por NPM; query determinística que prevalece sobre eventos previamente recebidos em caso de divergência (per canvas)."
		}]
		rationale: "Per canvas query-surface QueryIdentityVerificationStatus consumida por NPM. Projection mantém estado vigente sintético derivado de events; query prevalece sobre eventos previamente recebidos em caso de divergência (per canvas)."
	}, {
		code:        "prj-evidence-integrity"
		name:        "EvidenceIntegrityProjection"
		description: "Read model que materializa estado de integridade de armazenamento (CAS) para evidências assinadas; consumido por LOG via QueryEvidenceIntegrity."
		consumesEvents: [
			"evt-evidence-signed",
		]
		queryCapabilities: [{
			code:        "qry-evidence-integrity"
			description: "Verifica que conteúdo armazenado via CAS está íntegro — hash do conteúdo coincide com endereço CAS; conformist com LOG (sem tradução)."
			rationale:   "LOG consumer primário precisa confirmar integridade de armazenamento antes de fornecer evidência a downstream; verificação determinística por hash compare."
		}]
		rationale: "Per canvas query-surface QueryEvidenceIntegrity consumida por LOG. Projection materializa lookup CAS otimizado para integrity verification de armazenamento."
	}, {
		code:        "prj-cryptographic-integrity"
		name:        "CryptographicIntegrityProjection"
		description: "Read model que materializa cadeia de verificação end-to-end (assinatura DSSE + Merkle proof + identidade verificada); consumido por DLV via QueryCryptographicIntegrity."
		consumesEvents: [
			"evt-evidence-signed",
			"evt-integrity-proof-generated",
			"evt-identity-revoked",
		]
		queryCapabilities: [{
			code:        "qry-cryptographic-integrity"
			description: "Verifica end-to-end: assinatura DSSE válida contra identidade reconhecida e vigente em IDC; Merkle proof consistente com árvore; conteúdo não adulterado desde origem."
			rationale:   "DLV consumer primário precisa de verificação composta (signature + merkle + identity vigente) para liberar entrega; query única evita N round-trips entre verificações parciais."
		}]
		rationale: "Per canvas query-surface QueryCryptographicIntegrity consumida por DLV. Projection consome evt-identity-revoked para invalidar provas vinculadas a identidades não-vigentes (cobertura parcial de Janela de Inconsistência ten-003)."
	}]

	rationale: """
		Domain model do BC Identity & Data Governance modela 2
		aggregates centrais cobrindo 2 dos 3 pilares declarados em
		canvas (verificação de identidade organizacional + integridade
		criptográfica). Authorization (terceiro pilar per cap-4)
		deferida — modelo binário/RBAC/ABAC ainda em definição em
		oq-idc-2; aggregate especulativo violaria heuristic do PG
		"lifecycle especulativo é pior que sem lifecycle".

		Behavior-first ordering aplicado: events emergem do canvas
		(2 published em outbound + 2 internal em audit trail);
		commands derivam de intenções (canvas inbound + revocation
		anchor); invariants protegidos derivados de gates determinísticos
		da autonomousDecisions e businessDecisions; value-objects
		emergentes dos payloads (CnpjIdentifier, IdentityVerificationResult,
		ContentHash, DsseEnvelope, MerkleProof, IntegrityProof,
		VerificationSourceReference).

		Aggregate split rationale: OrganizationalIdentity vs
		EvidenceCryptography são separadas por (a) consistency
		boundary distinta — operações criptográficas dependem de
		identidade vigente (referência cross-aggregate via inv-
		signature-requires-vigent-identity) mas não mutam identidade;
		(b) escala operacional distinta — assinaturas são alta-
		frequência, verificação de identidade é baixa-frequência;
		(c) idempotência criptográfica é invariante exclusivo de
		EvidenceCryptography.

		Lifecycle apenas em OrganizationalIdentity — states
		(unverified→verified→suspended→revoked) são canonicalmente
		declarados em canvas incentiveAnalysis cache stale vector e
		ten-003. EvidenceCryptography é stateless por construção
		(operações atômicas idempotentes).

		Projections cobrem 3 query-surfaces declaradas no canvas
		(QueryIdentityVerificationStatus, QueryEvidenceIntegrity,
		QueryCryptographicIntegrity) — query prevalece sobre eventos
		em caso de divergência per canvas.

		Phase 0 caveats:
		- inv-signature-requires-vigent-identity sustentada por
		  configuração operacional + escalation sign-evidence-gap
		  até oq-idc-1 (revocation protocol) resolver — pós-resolução,
		  vira gate por construção.
		- inv-evidence-class-conforms-taxonomy sustentada por
		  whitelist + escalation até ten-004 (taxonomia canônica)
		  resolver.
		- evt-identity-revoked modelado mas protocolo de propagação
		  ativa não formalizado (oq-idc-1); Janela de Inconsistência
		  permanece com cobertura parcial até resolução estrutural.
		- Authorization (3º pilar) ausente do modelo — registrar como
		  gap conhecido em ten-XXX se evolução futura requerer
		  decisão estrutural.

		Glossary alignment: nomes de events/commands/aggregates/
		value-objects reconciliados com terms canônicos do glossary
		IDC (commit 7641262). Sem divergências terminológicas
		identificadas nesta autoria.
		"""
}
