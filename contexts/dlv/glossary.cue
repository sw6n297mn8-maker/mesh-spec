package dlv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Ubiquitous Language: Delivery & Verification.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Glossário do BC DLV (Delivery & Verification) — quinto BC do
// macrofluxo Mesh (SSC → {P2P, CTR} → CMT → BDG → DLV → INV → FCE).
// Materializa Ubiquitous Language pos-canvas Phase 1 (commits
// bb6c4ee..2421810): 14 BDs + 7 autonomousDecisions + 6
// supervisedDecisions + 7 escalationCriteria + 8 verificationMetrics.
//
// 22 terms canônicos em 5 categorias:
//   Core Domain (8): Verificação + Evidência + Registro de Evidência +
//     Critério Versionado + Prova de Integridade + Função de
//     Verificação Determinística + Código de Motivo + Caminho de
//     Retentativa
//   Identity & Structure (4): Referência de Compromisso + Referência
//     de Evidência + Offset do Log de Eventos + Identidade de
//     Idempotência
//   Lifecycle & State (3): Supersessão + Janela de Finalidade
//     Econômica + Estado de Exceção
//   Operational Process (4): Ingestão + Replay Determinístico + Emit
//     Atômico + Histórico de Exceção
//   Defense & Governance (3): Defesa em Profundidade + Canal de
//     Override + Tripwire Invariante
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). 3 ciclos red team aplicados pre-write detectaram: (R1)
// 3 termos sem pt-BR (corrigidos: EvidenceRecord/ReasonCode/RetryPath/
// Defense in Depth localizados); 1 redundância term 6+14 collapsed
// em "Função de Verificação Determinística"; (R2) eventLogOffset
// missing — adicionado como termo canônico Identity & Structure;
// canonical-current subsumido em definition de Supersessão; (R3)
// reorganização para 5 categorias com Identity & Structure como
// micro-grupo dedicado a identifiers. 2 ajustes founder pre-write:
// (a) "Offset do Log de Eventos" (vs "Posição") por precisão técnica
// canônica em sistemas event-driven; (b) Histórico de Exceção em
// Operational Process (não Identity) — temporal mutável append-only
// derivado de eventos, NÃO eixo de identidade.
//
// Boundary preservation transversal via antiTerms: Evidence vs
// Registro de Evidência (LOG ↔ DLV); Critério Versionado vs criteria
// definition (CMT ↔ DLV); Caminho de Override vs supervisedDecision
// (governanceScope ↔ glossary); Tripwire Invariante vs operational
// metric (BD10 boundary). Anti-mini-NIM enforcement em definitions
// + antiTerms.

glossary: artifact_schemas.#Glossary & {
	code:              "dlv"
	name:              "Delivery & Verification"
	boundedContextRef: "dlv"

	terms: [
		// ============================================================
		// CATEGORY 1 — CORE DOMAIN (8 termos)
		// ============================================================

		{
			code:       "term-verificacao"
			name:       "Verificação"
			termEn:     "Verification"
			category:   "entity"
			domainModelRefs: ["agg-verification"]
			definition: """
				Aggregate raiz DLV materializando decisão emitida sobre
				suficiência de evidência contra critério versionado.
				Carrega outcome (verified | rejected) + reasonCode +
				criteriaVersion (attribute) + supersededByRef? +
				exceptionHistory? + finalityAt + decidedAt + decidedBy.
				Imutável após emit (BD2 idempotency); supersedida via
				supersededByRef (BD5) sem mutação. Identidade canônica:
				Identidade de Idempotência (commitmentRef, evidenceRef).
				"""
			rationale: """
				Conceito raiz do BC; toda operação DLV produz, modifica
				atributos de, ou consulta Verificação. Distinct de
				"decisão" genérica porque carries audit trail completo
				+ replay determinism + finality semantics específicos
				ao contexto Mesh.
				"""
			antiTerms: [{
				term: "Decisão"
				clarification: """
					Decisão genérica é abstração ampla. Verificação é
					decisão DLV específica com contract de imutabilidade
					+ supersession lineage + 30d finality window.
					"""
			}]
		},
		{
			code:       "term-evidencia"
			name:       "Evidência"
			termEn:     "Evidence"
			category:   "entity"
			definition: """
				Fato operacional capturado fisicamente por LOG (sensor
				data, photo, GPS coordinates, receipt, attestation).
				Externa a DLV — DLV consome via EvidenceCommitted event
				cross-BC. Boundary marker: Evidence é mundo real owned
				por LOG; DLV opera sobre representação ingerida (Registro
				de Evidência).
				"""
			rationale: """
				Conceito existe em LOG e consume DLV; nomear explicitamente
				preserva boundary. Sem este termo, ambiguidade entre
				"evidência físic" (LOG) e "evidence record" (DLV)
				colapsaria — anti-mini-NIM violation potencial.
				"""
			antiTerms: [{
				term: "Registro de Evidência"
				clarification: """
					Evidence é o fato no mundo real (LOG owns); Registro
					de Evidência é a representação local DLV pós-Layer 1
					integrity check ingestion-time. Confundir leva a
					DLV virar mini-LOG.
					"""
			}]
		},
		{
			code:       "term-registro-de-evidencia"
			name:       "Registro de Evidência"
			termEn:     "Evidence Record"
			category:   "entity"
			definition: """
				Aggregate DLV-internal materializando ingestão local de
				Evidência: tupla (commitmentRef, evidenceRef,
				integrityProofRef, recordedAt). Append-only sem julgamento
				per BD4 ingestion-evaluation-separation. Distinto de
				Evidence (LOG concept) — Evidence Record é representação
				DLV pós-Layer 1 integrity check ingestion-time per BD11.
				"""
			rationale: """
				Boundary marker crítico: separa concept LOG (Evidence)
				de representação DLV (Evidence Record). Permite ingestion
				operar como append-only sem confusão com captura física.
				Distinct vital para BD4 separation + BD11 mandatory
				integrity check.
				"""
			antiTerms: [{
				term: "Evidência"
				clarification: """
					Evidence Record é DLV-internal aggregate; Evidence
					é LOG concept externo. Mistura quebra boundary
					LOG↔DLV.
					"""
			}]
		},
		{
			code:       "term-criterio-versionado"
			name:       "Critério Versionado"
			termEn:     "Versioned Criteria"
			category:   "value"
			definition: """
				Snapshot imutável hash-anchored de regras de match owned
				por CMT que definem o que constitui evidência suficiente
				para um commitmentRef. DLV consume via criteriaVersion
				attribute (NÃO identity component per BD2). Mutation
				in-place proibida por construção — criteria evolution
				exige nova version. Habilita replay determinism (BD3)
				sob critérios vigentes à época da decisão.
				"""
			rationale: """
				Versioning explícito é precondition de replay determinism
				+ economic finality. Sem hash-anchored snapshot, criteria
				drift retroativamente invalidaria histórico — quebra
				audit Lei 12.846/SCD/CVM.
				"""
			antiTerms: [{
				term: "Critério"
				clarification: """
					Critério (sem version) sugere conceito mutável OR
					"latest", incompatível com replay safety. Versionado
					força hash-anchoring imutável.
					"""
			}, {
				term: "Definição de Critério"
				clarification: """
					CMT owns criteria definition + lifecycle. DLV consume
					snapshot via criteriaVersion. Confundir leva a DLV
					virar mini-CMT.
					"""
			}]
		},
		{
			code:       "term-prova-de-integridade"
			name:       "Prova de Integridade"
			termEn:     "Integrity Proof"
			category:   "value"
			definition: """
				Cryptographic proof DSSE-anchored gerada por IDC
				verificável LOCALMENTE por DLV (sem network dependency
				per BD11). Verificação dual: (a) Layer 1 ingestion-time
				syntax check (parser + format compliance + DSSE envelope
				well-formed) per BD11; (b) Layer 1 evaluation-time deep
				semantic check (signer authority resolution, certificate
				chain) per BD9 — opcional, fail-safe se IDC indisponível.
				"""
			rationale: """
				Distinção integridade vs verdade (BD9): cryptographic
				proof prova "submetido pelo signatário declarado", NÃO
				"conteúdo é verdadeiro". Integrity Proof é Layer 1 de
				Defesa em Profundidade — necessário mas não suficiente.
				"""
			antiTerms: [{
				term: "Verdade"
				clarification: """
					Integrity Proof não é claim de verdade absoluta —
					só de autenticidade do signatário. Truth operacional
					emerge de composição 3 camadas (Defesa em
					Profundidade), não de Layer 1 sozinha.
					"""
			}]
		},
		{
			code:       "term-funcao-de-verificacao-deterministica"
			name:       "Função de Verificação Determinística"
			termEn:     "Deterministic Verification Function"
			category:   "process"
			definition: """
				Função pura sobre tripla causal (evidence ingerida,
				criteriaVersion snapshot, integrityProof) que produz
				outcome binário verified | rejected reproduzível bit-a-bit
				em replay sob mesmos inputs + versão de lógica de
				avaliação. Garantia condicional aos inputs e versão de
				lógica (não absoluta — bug fix em parser produz outcomes
				legitimamente distintos sob nova versão). Sem estado
				externo, sem julgamento, sem inferência probabilística.
				RECTOR thesis-invariant per BD1. Insuficiência de
				evidência tratada como rejected + reasonCode estruturado
				(NÃO terceiro estado).
				"""
			rationale: """
				Determinismo é RECTOR estrutural do BC + thesis-invariant
				central da Mesh — propriedade que torna recebíveis Mesh
				mais confiáveis que tradicionais. Precondition de
				idempotency (BD2), replay (BD3), atomicity (BD14), 24/7
				operation (cc-03).
				"""
			antiTerms: [{
				term: "Avaliação Subjetiva"
				clarification: """
					Função determinística é antítese de julgamento —
					inputs idênticos → output idêntico. Subjetivo
					introduziria non-determinism em path crítico,
					quebrando replay e audit.
					"""
			}, {
				term: "Scoring"
				clarification: """
					Output é binário categórico (verified|rejected),
					NÃO score probabilístico. Scoring vive em REW/NIM
					per BD10 anti-mini-NIM hard line.
					"""
			}]
		},
		{
			code:       "term-codigo-de-motivo"
			name:       "Código de Motivo"
			termEn:     "Reason Code"
			category:   "classification"
			definition: """
				Categoria estrutural taxonomy aberta anexada a toda
				decisão emitida (Verificação) explicando o outcome.
				Categorias canônicas Phase 0: integrity-proof-unverifiable-
				local, integrity-failure, cross-evidence-inconsistency-
				{class}, insufficient-evidence, criteria-mismatch,
				evidence-superseded, exception-emergency-override,
				post-finality-correction, drc-driven-correction,
				criteria-version-override-applied, exception-resolved-
				{outcome}, exception-unresolved-timeout. Extensions Phase
				1+ via criteriaVersion declaration. Mandatory por BD13
				(silent rejection proibido).
				"""
			rationale: """
				Anti-silent-rejection estrutural: cada decisão DLV é
				auditável via reasonCode categórico. Distinct de scoring
				(numérico-statistical) per BD10 — categórico permite
				downstream consumer logic determinístico (sh-02 retry
				path; DRC dispute classification).
				"""
		},
		{
			code:       "term-caminho-de-retentativa"
			name:       "Caminho de Retentativa"
			termEn:     "Retry Path"
			category:   "classification"
			definition: """
				Signal estrutural categórico anexado a DeliveryRejected
				events: retryable | non-retryable | exception. Função
				DETERMINÍSTICA de (reasonCode, criteriaVersion-context,
				finality-state) via schema mapping table per BD13 — NÃO
				atribuído arbitrariamente. Orienta sh-02 fornecedor:
				retryable → corrigir + resubmit; non-retryable → DRC
				dispute path; exception → await terminal transition.
				"""
			rationale: """
				Actionable contract com sh-02 + DRC. Determinismo
				preserva replay (BD3): replay sob mesma timeline produz
				mesmo retryPath signal. Distinct de reasonCode: reason
				é "por que rejected"; retryPath é "qual ação tomar".
				"""
		},

		// ============================================================
		// CATEGORY 2 — IDENTITY & STRUCTURE (4 termos)
		// ============================================================

		{
			code:       "term-referencia-de-compromisso"
			name:       "Referência de Compromisso"
			termEn:     "Commitment Reference"
			category:   "value"
			definition: """
				Identificador único do compromisso econômico (owned por
				CMT) que delimita o escopo de avaliação DLV: eixo de
				agregação de evidências + escopo de supersession lineage
				+ contexto de decisão. Componente da Identidade de
				Idempotência (commitmentRef, evidenceRef). Cross-BC
				reference: commitments existem em CMT; DLV consume.
				"""
			rationale: """
				Sem termo canônico, commitmentRef vira variável implícita
				em código + audit trail. Explicitar como termo permite
				agentes navegarem boundary CMT↔DLV sem ambiguidade +
				habilita validação cross-BC em replay/audit.
				"""
		},
		{
			code:       "term-referencia-de-evidencia"
			name:       "Referência de Evidência"
			termEn:     "Evidence Reference"
			category:   "value"
			definition: """
				Identificador único de uma Evidência dentro do contexto
				de uma Referência de Compromisso. Componente da Identidade
				de Idempotência. Distinct evidenceRefs sob mesmo
				commitmentRef ordenam-se via Supersessão (BD5: ordering
				canonical via Offset do Log de Eventos + hash tie-breaker).
				"""
			rationale: """
				Permite multiple evidências sob mesmo commitment (e.g.,
				correção de evidence original via supersession) sem
				ambiguidade. Sem termo canônico, evidenceRef permanece
				detalhe de implementação; explicitar habilita audit +
				replay determinístico.
				"""
		},
		{
			code:       "term-offset-do-log-de-eventos"
			name:       "Offset do Log de Eventos"
			termEn:     "Event Log Offset"
			category:   "value"
			definition: """
				Posição canônica monotônica globalmente determinística
				de um evento no Event Log. Fonte canonical de ordering
				em Supersessão (BD5: total ordering primary key + hash
				tie-breaker secondary), de at-most-once cross-BC
				observability (BD14c: dedup canonical key), e de Replay
				Determinístico (BD3: reconstruí state em qualquer offset
				histórico). Independente de wall-clock externo —
				replay-safe por construção.
				"""
			rationale: """
				Eixo determinístico mais crítico do BC. Sem termo
				canônico, ordering vira detalhe técnico — perde clareza
				formal em audit/replay/dedup. Termo "Offset" canônico
				em sistemas event-driven (vs "posição" semântico).
				Distinct de timestamp: monotônico, não wall-clock.
				"""
			antiTerms: [{
				term: "Timestamp"
				clarification: """
					Timestamp é wall-clock (sujeito a skew/drift); Offset
					é monotônico determinístico do Event Log. Confundir
					quebra ordering canonical em ambientes distribuídos.
					"""
			}]
		},
		{
			code:       "term-identidade-de-idempotencia"
			name:       "Identidade de Idempotência"
			termEn:     "Idempotency Identity"
			category:   "value"
			definition: """
				Tupla canônica (commitmentRef, evidenceRef) que define
				unicidade de avaliação em DLV. Mesma identidade produz
				mesmo outcome sob mesmos inputs + versão de lógica per
				BD2. criteriaVersion é ATTRIBUTE da decisão emitida, NÃO
				componente da identidade — deliberado: criteria upgrade
				NÃO invalida verifications históricas (preserva economic
				finality + replay determinism). Storage layer DLV exige
				unique constraint sobre esta tupla.
				"""
			rationale: """
				Idempotency é precondition operacional de at-least-once
				delivery em sistemas event-driven. Sem identidade
				canônica explícita, retry semantics ambíguas. Distinct
				de "identidade da Verificação" porque exclui
				criteriaVersion (deliberado per BD2).
				"""
			antiTerms: [{
				term: "Identidade da Verificação"
				clarification: """
					Identidade da Verificação inclui criteriaVersion como
					attribute imutável; Identidade de Idempotência exclui
					criteriaVersion (apenas commitmentRef + evidenceRef).
					Distinção crítica per BD2: criteria upgrade não
					invalida histórico.
					"""
			}]
		},

		// ============================================================
		// CATEGORY 3 — LIFECYCLE & STATE (3 termos)
		// ============================================================

		{
			code:       "term-supersessao"
			name:       "Supersessão"
			termEn:     "Supersession"
			category:   "process"
			definition: """
				Linear deterministic ordering sobre evidenceRefs por
				commitmentRef ancorado em Offset do Log de Eventos
				(primary key) + hash tie-breaker (secondary). Verificações
				históricas IMUTÁVEIS — supersession produz NOVA
				Verificação sob nova Identidade de Idempotência
				(commitmentRef, evidenceRef-N+1) referenciando anterior
				via supersededByRef attribute. canonical-current = latest
				sob ordering; histórico íntegro acessível via
				QueryEvidenceLedger. NÃO escolha entre evidências (anti-
				mini-NIM BD5) — LOG declara lineage (path primário) ou
				DLV ordena via fallback determinístico em ausência.
				"""
			rationale: """
				Anti-mini-NIM hard line: DLV escolhendo entre evidências
				seria julgamento (qual é melhor?). Linear ordering força
				LOG (que ingere) a declarar lineage; DLV reage. Imutável
				preserva audit trail + replay; new identity preserves
				idempotency BD2.
				"""
			antiTerms: [{
				term: "Substituição"
				clarification: """
					Supersession NÃO substitui — REFERENCIA. Verificação
					anterior permanece imutável; nova é canonical-current
					sob ordering. Substituir quebraria audit trail + replay.
					"""
			}, {
				term: "Escolha"
				clarification: """
					DLV NÃO escolhe entre evidências competing —
					determina ordering canonical via Offset do Log de
					Eventos. Escolha implicaria julgamento (qual evidência
					é melhor?), violando anti-mini-NIM.
					"""
			}]
		},
		{
			code:       "term-janela-de-finalidade-economica"
			name:       "Janela de Finalidade Econômica"
			termEn:     "Economic Finality Window"
			category:   "rule"
			definition: """
				Período de 30 dias corridos pós-decidedAt durante o qual
				DLV pode emitir superseding Verificação AUTONOMAMENTE
				per BD8. Pós-finality, superseding requer caminho
				controlado: supervisedDecision approve-post-finality-
				supersession (path A) OR DRC-driven correction (path B
				Phase 1+). DLV system time como single source — NÃO
				herda timing de FCE (settlement) nem de INV (invoicing);
				finality é propriedade de verificação, NÃO de pagamento.
				Replay-safe via Offset do Log de Eventos. Calibração per
				criteria type Phase 1+ via oq-dlv-2.
				"""
			rationale: """
				Finality finita resolve trade-off correctness (permitir
				supersession para correção legítima) vs liveness
				(downstream eventualmente age sobre verified estável).
				DLV clock single source elimina coupling perigoso com
				FCE. Hard line anti-AUTÔNOMA pós-finality preserva
				finality forte sem cegueira sistêmica.
				"""
			antiTerms: [{
				term: "Finalidade de Pagamento"
				clarification: """
					Janela DLV é sobre verification stability; settlement
					finality é FCE concern. DLV clock NÃO herda timing
					de FCE — invertendo causalidade do macrofluxo.
					"""
			}]
		},
		{
			code:       "term-estado-de-excecao"
			name:       "Estado de Exceção"
			termEn:     "Exception State"
			category:   "value"
			definition: """
				Estado intermediário INTERNO (não publicado cross-BC) de
				Verificação per BD6. Único por Identidade de Idempotência
				(commitmentRef, evidenceRef) — exception-during-exception
				proibido por construção; histórico via Histórico de
				Exceção. Timer 14 dias mandatory transition para terminal
				(verified | rejected); cap absoluto 30 dias cumulativo
				via extensions supervised. Auto-rejection forçada com
				reasonCode=exception-unresolved-timeout no fail-safe
				forward motion (P5 anti-paralysis governanceScope).
				Estados típicos: insufficient-authority, criteria-
				version-override pending, manual-reconciliation,
				regulatory-fiscal-ambiguity.
				"""
			rationale: """
				Estados sem terminal mandatório são vetor clássico de
				stuck workflow. Janela mandatória + fail-safe auto-
				rejection preserva forward motion sob indecisão humana.
				Cap absoluto cumulativo bounded por construção evita
				abuso de extension.
				"""
			antiTerms: [{
				term: "Estado Terminal"
				clarification: """
					Exception é INTERMEDIÁRIO; terminal states são
					verified | rejected. Confundir leva a stuck state.
					"""
			}]
		},

		// ============================================================
		// CATEGORY 4 — OPERATIONAL PROCESS (4 termos)
		// ============================================================

		{
			code:       "term-ingestao"
			name:       "Ingestão"
			termEn:     "Ingestion"
			category:   "process"
			definition: """
				Append-only registro de Evidência via RecordEvidence
				command (sync, alternativa direct) OR EvidenceCommitted
				event consumption (cross-BC, primary path). Layer 1
				integrity check parser-time per BD11 (local-first;
				network-independent — DLV NUNCA depende de rede para
				aceitar ingestion). Distinta de Avaliação per BD4
				separation: ingestion materializa Registro de Evidência
				sem julgamento; evaluation é Função de Verificação
				Determinística subsequent.
				"""
			rationale: """
				Separação ingestion-evaluation é precondition de race
				condition prevention (criteria-vs-evidence) + replay
				determinism. Local-first network-independent é precondition
				de cc-03 24/7. BD4 + BD11 transversal.
				"""
			antiTerms: [{
				term: "Avaliação"
				clarification: """
					Ingestion materializa fato (Registro de Evidência);
					Avaliação é função pura subsequent. Fusão acoplaria
					latency budgets + criaria race condition.
					"""
			}]
		},
		{
			code:       "term-replay-deterministico"
			name:       "Replay Determinístico"
			termEn:     "Deterministic Replay"
			category:   "process"
			definition: """
				Reconstrução bit-a-bit de decisão histórica via tripla
				causal imutável (evidenceRef, criteriaVersion,
				integrityProofSnapshot) + versão de lógica de avaliação
				vigente à época. NÃO re-decisão sob critérios atuais;
				leitura determinística do passado per BD3. Identidade
				do replay diverge da Identidade de Idempotência da
				decisão original — replay reconstrói ato decisório, NÃO
				produz nova Verificação operacional. Property-based
				test garante: ∀ replay execution sob mesma timeline →
				mesmo outcome.
				"""
			rationale: """
				Precondition de forensic audit Lei 12.846/SCD/CVM (5
				anos retention) + DRC dispute resolution + regulatory
				trail Bacen/SCD. criteriaVersion como hash-anchored
				snapshot é crítico — referência mutável invalidaria
				histórico.
				"""
			antiTerms: [{
				term: "Re-avaliação"
				clarification: """
					Re-avaliação produz NOVO outcome operacional sob
					critérios atuais; Replay reconstrói outcome ORIGINAL
					sob critérios da época. Confundir leva a perda de
					audit fidelity.
					"""
			}]
		},
		{
			code:       "term-emit-atomico"
			name:       "Emit Atômico"
			termEn:     "Atomic Emit"
			category:   "process"
			definition: """
				Aggregate Verificação state transition + DeliveryVerified
				| DeliveryRejected event publication AS-ONE per BD14a-b.
				Recovery determinístico via transactional outbox pattern
				(Phase 3 implementação): ambos succeed OR ambos rollback.
				Cross-BC ACL deduplica via Offset do Log de Eventos com
				fallback identidade lógica (commitmentRef, evidenceRef,
				eventType) per BD14c — at-most-once observability.
				Consumers downstream (INV/REW/NIM/DRC) podem assumir
				'event observed → aggregate queryable' sem cross-check
				defensivo.
				"""
			rationale: """
				Atomicity é commitment estrutural público com downstream
				consumers — elimina classe inteira de cross-BC consistency
				complexity. Distinct de idempotency (BD2 logical) e
				at-most-once cross-BC (BD14c observability) — 3
				propriedades complementares.
				"""
		},
		{
			code:       "term-historico-de-excecao"
			name:       "Histórico de Exceção"
			termEn:     "Exception History"
			category:   "value"
			definition: """
				Registro append-only imutável de todas transições e
				extensões do Estado de Exceção associadas a uma
				Verificação per BD6. Cada entry: (reason, timestamp,
				triggeredBy, resolvedAt?, resolution?). Estado vigente
				da exception é projeção determinística do último entry
				sem resolvedAt. Preserva granularidade temporal +
				causalidade + actor para audit + diagnostic operacional.
				Re-entries após resolução contam como nova exception
				instance via Identidade de Idempotência (commitmentRef,
				evidenceRef) com new exception_instance_id.
				"""
			rationale: """
				Sem termo canônico, exceptionHistory permanece detalhe
				de aggregate. Explicitar como termo habilita audit
				navigation + metrics computation + replay reconstruction
				determinística. Estado único + history rico evita
				explosão de estados sem perder causality.
				"""
		},

		// ============================================================
		// CATEGORY 5 — DEFENSE & GOVERNANCE (3 termos)
		// ============================================================

		{
			code:       "term-defesa-em-profundidade"
			name:       "Defesa em Profundidade"
			termEn:     "Defense In Depth"
			category:   "rule"
			definition: """
				Padrão arquitetural de 3 camadas per BD9 garantindo que
				NENHUMA camada SOZINHA é suficiente para verdade
				operacional: Layer 1 cryptographic integrity (DLV scope;
				Prova de Integridade local validation per BD11); Layer 2
				cross-evidence consistency (DLV scope; 3 classes iniciais
				consistency/range/temporal extensíveis via criteriaVersion);
				Layer 3 pattern anomaly (REW/NIM scope, NÃO DLV — anti-
				mini-NIM BD10). Verified DLV NÃO é claim de verdade
				absoluta — composição das 3 camadas como sistema. DLV
				honesto sobre limites: Layer 1+2 deterministic;
				Layer 3 statistical (REW/NIM territory).
				"""
			rationale: """
				Distinção integridade ≠ verdade é crítica em sistemas
				financeiros. Defense in depth respeita boundary com
				REW/NIM (anti-mini-NIM BD10) + provê coverage real
				contra adversários com escopos disjuntos.
				"""
			antiTerms: [{
				term: "Truth Oracle"
				clarification: """
					DLV NÃO pretende ser oráculo de verdade — apenas
					verifica integridade + consistência sob critérios
					versionados. Truth emerge de composição sistêmica
					Mesh, não de DLV sozinho.
					"""
			}]
		},
		{
			code:       "term-canal-de-override"
			name:       "Canal de Override"
			termEn:     "Override Channel"
			category:   "process"
			definition: """
				Caminho supervised distinto bounded por design para
				situações específicas, com mandatory audit +
				reconciliationStatus tracking. 4 canais Phase 0:
				emergency-override (BD7 deadlock recovery via
				supervisedDecision approve-with-emergency-override);
				post-finality-supersession (BD8 path A via
				approve-post-finality-supersession); criteria-version-
				override (BD12 urgência operacional);
				exception-extension (BD6 timer extension cumulativo cap
				30d). Antifragility: rate sustained > threshold dispara
				design feedback obrigatório (tension-entry → deferred-
				decision → ADR per artifact ordering).
				"""
			rationale: """
				Conceito agregado preserva nível de abstração correto
				do glossário (linguagem do domínio) sem duplicar
				governanceScope (artefato operacional). Permite agentes
				falarem sobre "uso de override" sem precisar enumerar
				canais específicos.
				"""
			antiTerms: [{
				term: "Bypass Silencioso"
				clarification: """
					Override é LOUD por design (P1): mandatory audit +
					categorical reasonCode + actor identification.
					Bypass silencioso violaria invariante anti-default.
					"""
			}]
		},
		{
			code:       "term-tripwire-invariante"
			name:       "Tripwire Invariante"
			termEn:     "Invariant Tripwire"
			category:   "rule"
			definition: """
				Validador estrutural verifying property formal sobre o
				sistema: ∀ DeliveryVerified ∃ Registro de Evidência
				precedente OR supervisedDecision approve-with-emergency-
				override. Distinct de operational metrics — classification
				invariant-check; binding NONE explicit; priority CRITICAL.
				Non-zero count = critical implementation bug, NÃO pattern
				signal — action: ADR obrigatório + structural investigation
				+ freeze de emit autônomo até cleared. Materializado em
				verificationMetric "verified-without-evidence-or-override-
				attempts" (Phase 1.6) com scope_enforcement: blocks
				autonomous emit pipeline until cleared.
				"""
			rationale: """
				Tripwire é distinct de rate-based escalation: single
				violation = sistema quebrado, não pattern. Resposta é
				freeze + ADR, não calibration. Isolated por design para
				evitar 'agregação/suavização' inadvertida no futuro.
				"""
			antiTerms: [{
				term: "Operational Metric"
				clarification: """
					Operational metrics medem rate sobre janela com
					threshold; Tripwire valida property formal com
					threshold zero — single violation = bug crítico.
					Confundir leva a 'normalização' de invariant
					violation via aggregation.
					"""
			}]
		},
		{
			code:       "term-registrar-evidencia"
			name:       "Registrar Evidência"
			termEn:     "Record Evidence"
			definition: "Ação canônica que ingere evidência e cria o aggregate Verification (EvidenceRecord embedded) em estado evaluating; checagem de integridade Layer 1 em parser-time, síncrona."
			category:   "command"
			rationale:  "Command de entrada do caminho de ingestão (BD4 separação ingestão-avaliação); distinto do fato resultante (Evidência Registrada) e da entidade (Registro de Evidência)."
			domainModelRefs: ["cmd-record-evidence"]
			relatedTerms: ["term-verificacao", "term-evidencia-registrada", "term-ingestao"]
		},
		{
			code:       "term-avaliar-verificacao"
			name:       "Avaliar Verificação"
			termEn:     "Evaluate Verification"
			definition: "Ação canônica que avalia a evidência ingerida contra o critério versionado vigente (função pura), emitindo outcome binário verified|rejected ou transicionando para exception-pending."
			category:   "command"
			rationale:  "Command do gate determinístico (função pura sobre evidência e critério, BD1); distingue o ato de avaliar do resultado terminal (Entrega Verificada ou Rejeitada)."
			domainModelRefs: ["cmd-evaluate-verification"]
			relatedTerms: ["term-verificacao", "term-criterio-versionado", "term-funcao-de-verificacao-deterministica"]
		},
		{
			code:       "term-transicionar-estado-de-excecao"
			name:       "Transicionar Estado de Exceção"
			termEn:     "Transition Exception State"
			definition: "Ação canônica timer-driven que força a saída de exception-pending para terminal ao expirar o timer de 14d (resolução humana ou auto-rejeição fail-safe per BD6)."
			category:   "command"
			rationale:  "Command timer-driven que materializa o anti-paralisia P5 (forward motion sob indecisão humana via fail-safe, não fail-open)."
			domainModelRefs: ["cmd-transition-exception-state"]
			relatedTerms: ["term-verificacao", "term-estado-de-excecao", "term-excecao-resolvida"]
		},
		{
			code:       "term-entrega-verificada"
			name:       "Entrega Verificada"
			termEn:     "Delivery Verified"
			definition: "Fato de que a Verification atingiu o terminal verified; evento published cross-BC, gate de faturamento (INV) e sinal para REW/NIM/DRC."
			category:   "event"
			rationale:  "Evento terminal canônico do happy path; binding cross-BC (gate de faturamento INV); distinto do marcador interno Exceção Resolvida."
			domainModelRefs: ["evt-delivery-verified"]
			relatedTerms: ["term-verificacao", "term-entrega-rejeitada"]
		},
		{
			code:       "term-entrega-rejeitada"
			name:       "Entrega Rejeitada"
			termEn:     "Delivery Rejected"
			definition: "Fato de que a Verification atingiu o terminal rejected, com reasonCode e retryPath mandatórios (anti-rejeição-silenciosa, BD13); published cross-BC."
			category:   "event"
			rationale:  "Evento terminal canônico do rejection path; reasonCode e retryPath mandatórios dão accountability e contrato acionável (BD13), distinguindo rejeição legítima de bias."
			domainModelRefs: ["evt-delivery-rejected"]
			relatedTerms: ["term-verificacao", "term-entrega-verificada", "term-codigo-de-motivo", "term-caminho-de-retentativa"]
		},
		{
			code:       "term-evidencia-registrada"
			name:       "Evidência Registrada"
			termEn:     "Evidence Recorded"
			definition: "Fato de que um EvidenceRecord foi criado (via cmd-record-evidence ou ACL do LOG), marcando a criação do aggregate Verification; interno (BD4)."
			category:   "event"
			rationale:  "Fato (evento) da criação do EvidenceRecord; distinto do comando que o dispara (Registrar Evidência) e da entidade criada (Registro de Evidência) — coisa, ato e fato."
			domainModelRefs: ["evt-evidence-recorded"]
			relatedTerms: ["term-verificacao", "term-registrar-evidencia", "term-registro-de-evidencia"]
		},
		{
			code:       "term-supersessao-aplicada"
			name:       "Supersessão Aplicada"
			termEn:     "Supersession Applied"
			definition: "Fato de que uma linhagem de supersessão foi aplicada (evidência N+1 supersede N para o mesmo commitmentRef), disparando nova Verification; interno."
			category:   "event"
			rationale:  "Fato da aplicação de linhagem de supersessão (ordering canônico por eventLogOffset, BD5); distinto do conceito-processo Supersessão."
			domainModelRefs: ["evt-supersession-applied"]
			relatedTerms: ["term-verificacao", "term-supersessao"]
		},
		{
			code:       "term-excecao-iniciada"
			name:       "Exceção Iniciada"
			termEn:     "Exception Entered"
			definition: "Fato de que a Verification transicionou de evaluating para exception-pending, iniciando o timer mandatório de 14d e o primeiro entry do exceptionHistory; interno."
			category:   "event"
			rationale:  "Fato da entrada em exception-pending; inicia o timer mandatório de 14d (BD6), distinguindo o início do estado das suas extensões e resolução."
			domainModelRefs: ["evt-exception-entered"]
			relatedTerms: ["term-verificacao", "term-estado-de-excecao", "term-excecao-estendida", "term-excecao-resolvida"]
		},
		{
			code:       "term-excecao-estendida"
			name:       "Exceção Estendida"
			termEn:     "Exception Extended"
			definition: "Fato de que uma extensão de timer foi aplicada por decisão supervisionada, dentro do cap cumulativo absoluto de 30d (BD6); interno."
			category:   "event"
			rationale:  "Fato de extensão supervisionada do timer dentro do cap cumulativo absoluto de 30d (BD6 — cap por cumulativo evita escape por extensões pequenas)."
			domainModelRefs: ["evt-exception-extended"]
			relatedTerms: ["term-verificacao", "term-excecao-iniciada", "term-excecao-resolvida"]
		},
		{
			code:       "term-excecao-resolvida"
			name:       "Exceção Resolvida"
			termEn:     "Exception Resolved"
			definition: "Fato de que a Verification saiu de exception-pending para terminal (verified|rejected), por resolução humana ou auto-rejeição por timeout; interno."
			category:   "event"
			rationale:  "Fato do fechamento do lifecycle de exceção (humano ou timeout); marcador interno paralelo ao evento público terminal correspondente."
			domainModelRefs: ["evt-exception-resolved"]
			relatedTerms: ["term-verificacao", "term-excecao-iniciada", "term-historico-de-excecao"]
		},
	]

	rationale: """
		Glossário DLV materializa Ubiquitous Language do BC quinto
		do macrofluxo Mesh (SSC → {P2P, CTR} → CMT → BDG → DLV →
		INV → FCE), gate verificável que materializa a invariante
		central da tese: no evidence → no economic progression.

		22 termos canônicos em 5 categorias cobrindo:
		(1) Core Domain (8) — conceitos fundamentais com Verificação
		    como aggregate raiz + Função de Verificação Determinística
		    como RECTOR thesis-invariant (BD1)
		(2) Identity & Structure (4) — átomos de referência
		    (commitmentRef, evidenceRef, eventLogOffset) +
		    Identidade de Idempotência composta
		(3) Lifecycle & State (3) — Supersessão linear deterministic
		    + Janela de Finalidade Econômica 30d + Estado de Exceção
		    com timer mandatory
		(4) Operational Process (4) — Ingestão append-only +
		    Replay Determinístico forensic + Emit Atômico atomic +
		    Histórico de Exceção append-only
		(5) Defense & Governance (3) — Defesa em Profundidade 3
		    layers + Canal de Override antifragility + Tripwire
		    Invariante structural validator

		Boundary preservation transversal via antiTerms protege:
		- LOG ↔ DLV: Evidência (LOG concept) vs Registro de Evidência
		  (DLV-internal aggregate)
		- CMT ↔ DLV: Critério Versionado (DLV consume) vs Definição
		  de Critério (CMT owns)
		- REW/NIM ↔ DLV: Função de Verificação Determinística vs
		  Scoring (BD10 hard line); Defesa em Profundidade vs Truth
		  Oracle
		- governanceScope ↔ glossary: Canal de Override (linguagem
		  do domínio) vs supervisedDecision specifics (artefato
		  operacional)

		Anti-mini-NIM enforcement em definitions + antiTerms:
		Verificação NÃO é decisão genérica; Supersessão NÃO é escolha
		entre evidências; Função Determinística NÃO é avaliação
		subjetiva nem scoring; Defesa em Profundidade NÃO é Truth
		Oracle; Tripwire Invariante NÃO é operational metric.

		3 ciclos red team aplicados pre-write detectaram + corrigiram:
		(R1) localização pt-BR consistency + 1 redundância term 6+14
		collapsed; (R2) eventLogOffset missing → adicionado como
		termo canônico Identity & Structure; canonical-current
		subsumido em Supersessão; (R3) categorização 5 grupos com
		Identity & Structure micro-grupo dedicado; cross-BC concept
		reuse articulado via DLV-specific aspect em cada definition.

		2 ajustes founder pre-write incorporados: (a) 'Offset do Log
		de Eventos' (vs 'Posição') por precisão técnica canônica em
		sistemas event-driven; (b) Histórico de Exceção em
		Operational Process (não Identity) — temporal mutável
		append-only derivado de eventos, NÃO eixo de identidade
		estática.

		Frase canônica do BC preservada transversalmente: 'DLV é o
		juiz; LOG é a câmera; CMT é o contrato.' Anti-mini-NIM
		transversal: 3 boundaries hard (BD7 evidence-side + BD12
		criteria-side + BD10 scoring-side) protegem agente DLV de
		drift cognitivo para responsabilidades adjacentes.

		Glossário não evolui sem causa real per founder orientation
		(over-refinement risk): próxima evolução só acontece se
		surgir ambiguidade real em uso operacional, conflito
		semântico cross-BC, OR termo impossível de usar
		operacionalmente. Glossário bom não é o mais completo — é
		o mais estável sob uso.
		"""
}
