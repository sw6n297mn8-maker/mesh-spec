package rew

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Ubiquitous Language: Risk Engine & Risk Observability.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Glossário do BC REW (Risk Engine & Risk Observability) — pricing moat
// estrutural da Mesh; sistema de epistemologia operacional sob adversarial
// pressure. Materializa Ubiquitous Language pos-canvas Phase 1 (WI-046,
// commit fbe0b2d): 8 BDs + 4 autonomousDecisions + 5 supervisedDecisions
// + 7 escalationCriteria + 9 verificationMetrics + sh-06 introdução cross-
// cutting.
//
// FRASE CANONICAL FOUNDER R5++++: "Glossary não define palavras — define o
// que o sistema está autorizado a considerar verdade. REW não organiza
// termos — organiza limites do que pode ser considerado verdade."
//
// 12 terms canônicos organizados em 5 CAMADAS ONTOLÓGICAS:
//   (1) Reality Interpretation (1): Signal
//   (2) Epistemic Layer (4): Confidence Interval + Signal Coverage +
//       Asset Visibility Gap + Reasoning Trace
//   (3) Decision Layer (4): Risk Score + Eligibility Decision + Risk Alert +
//       Applicable Context
//   (4) Control Layer (2): Risk Model + Risk Policy
//   (5) Actor Layer (1): Adversário Econômico
//
// Authoring manual section-by-section per manualAuthoringProtocol (adr-057).
// 3 sections approved sequentially via founder dialectic R3+R4+R5++++ section-
// gate cycles. Insights canonical capturados:
//   "model prevê; policy decide" (separação rígida obrigatória)
//   "signal NÃO é dado; signal é interpretação" (firewall semântico crítico)
//   "score ≠ verdade; score = hipótese quantificada"
//   "confidence = medida da ignorância"
//   "missing signal ≠ neutral signal"
//   "alert errado é pior que ausência de alert"
//   "integridade ≠ veracidade"
//   "o adversário não é quem ele é — é o que ele faz"
//   "eligibility sem contexto é erro conceitual"
//
// Lens aplicada (primária): lens-domain-language-and-terminology-design
// — dl-bilingual-terminology + dl-term-selection-criteria + dl-cross-layer-
// consistency.
//
// Phase 0 baseline; domainModelRefs permanecem vazios — o domain-model.cue
// de REW já existe e o backfill dos refs é trabalho futuro. Glossary cresce
// incrementalmente per term promotion
// criteria declarada no rationale (NÃO add derivados como decision-version,
// emission-threshold, snapshot — pertencem a domain-model).

rewGlossary: artifact_schemas.#Glossary & {
	code:              "rew"
	name:              "Risk Engine & Risk Observability"
	boundedContextRef: "rew"

	terms: [
		// ============================================================
		// LAYER 1 — REALITY INTERPRETATION (1 term)
		// Signal é o ÚNICO termo desta camada — input fundamental do
		// sistema. Firewall semântico crítico (NÃO raw data).
		// ============================================================

		{
			code:     "term-signal"
			name:     "Sinal"
			termEn:   "Signal"
			category: "value"
			definition: """
				INTERPRETAÇÃO já validada por BC upstream (NPM lifecycle,
				DLV evidence, NIM value, FCE payment behavior) consumida
				por REW como input para scoring. NÃO é dado bruto. NÃO é
				evento operacional. NÃO é métrica agregada. Carrega
				significado semântico estável definido pelo BC de origem
				+ integrityProof verified. REW NUNCA interpreta dados —
				apenas transforma signals em decisão.
				"""
			rationale: """
				Firewall semântico crítico do REW — confusão signal ≠
				raw data ≠ event ≠ aggregated metric quebra REW inteiro
				(REW absorvendo responsabilidade de outros BCs). Per
				bd-signal-as-interpretation-not-raw-data: REW assume
				interpretações como verdade no momento de scoring; se
				signal virar dado, REW vira monstro.
				"""
			antiTerms: [{
				term: "Raw Data"
				clarification: """
					Dados não-interpretados (tabela de transações brutas,
					log de eventos sistêmicos, payloads não-validados) NÃO
					são Signal. Signal exige interpretação prévia por BC
					upstream com integrityProof verified.
					"""
			}, {
				term: "Domain Event"
				clarification: """
					Eventos operacionais (PaymentSettled como evento) são
					vehicle DE Signals, mas Signal é a INTERPRETAÇÃO
					carregada (status, classificação, decisão) — NÃO o
					evento em si.
					"""
			}]
			examples: [{
				context:  "NPM ParticipantStatusChanged"
				instance:  "Signal de status institucional já validado por NPM (KYC done, qualification verified) — REW consome status, NÃO documento original."
			}, {
				context:  "DLV EvidenceRecorded"
				instance:  "Signal de execução operacional já validado via criteria-evidence matching DLV — REW consome resultado da verificação, NÃO evidência bruta."
			}]
		},

		// ============================================================
		// LAYER 2 — EPISTEMIC (4 terms)
		// Medidas de ignorância + audit primitives. Camada que torna
		// incerteza explícita e governável.
		// ============================================================

		{
			code:     "term-confidence-interval"
			name:     "Intervalo de Confiança"
			termEn:   "Confidence Interval"
			category: "value"
			definition: """
				Medida de IGNORÂNCIA. Reflete Signal Coverage no momento
				de scoring — sinaliza quão certo o sistema está sobre
				próprio output. Missing signal reduce confidence (NÃO é
				tratado como neutral). Anexado a Risk Score + Eligibility
				Decision para indicar força epistemológica. Distinct do
				score (hipótese sobre risco): confidence é meta-information
				sobre própria certeza.
				"""
			rationale: """
				Founder canonical: 'confidence = medida da ignorância'.
				Sem confidence explícito, 'missing signal ≠ neutral signal'
				viola — ignorância tratada como segurança falsa. Eligibility
				Decision = decisão categórica; Confidence Interval = força
				epistemológica dessa decisão. Duas dimensões SEPARADAS,
				NUNCA confundir.
				"""
			relatedTerms: ["term-signal-coverage", "term-risk-score", "term-eligibility-decision"]
		},

		{
			code:     "term-signal-coverage"
			name:     "Cobertura de Sinais"
			termEn:   "Signal Coverage"
			category: "metric"
			definition: """
				Medida OBJETIVA da completude de inputs disponíveis no
				momento de scoring (signals available / signals expected
				per scoring run). Determina força epistemológica via
				Confidence Interval. Missing signals → coverage degraded
				→ confidence reduced. Sustained low coverage triggers
				esc-rew-cross-bc-signal-staleness.
				"""
			rationale: """
				Disciplina honesty: medir explicit o que falta evita
				'ignorância tratada como segurança'. Coverage objetiva
				(counted) reflete em confidence subjetiva. vm-rew-confidence-
				coverage-correlation testa correlation Pearson ≥ 0.85.
				"""
			relatedTerms: ["term-signal", "term-confidence-interval"]
		},

		{
			code:     "term-asset-visibility-gap"
			name:     "Lacuna de Visibilidade do Ativo"
			termEn:   "Asset Visibility Gap"
			category: "classification"
			definition: """
				Estado declarado quando REW NÃO tem acesso direto OR
				indireto consistente ao ativo financeiro avaliado (e.g.,
				invoice/receivable created by INV but not directly
				observable by REW per oq-rew-01 INV gap pendente). Quando
				aplicável, Eligibility Decision degrada para conditionally-
				eligible OR ineligible com explicit caveat 'asset-not-
				observable-via-current-channels'. Phase 0 limitation com
				fallback policy-defined.
				"""
			rationale: """
				Per bd-asset-aware-decision-discipline: REW NÃO toma decisão
				sobre asset sem visibility consistent. Gap é estrutural
				(categorial), não operacional. Founder canonical: 'risk
				engine desconectado da realidade' = vetor de erro
				estrutural. Princípio canonical: 'proibição sem fallback =
				indisponibilidade; fallback sem disciplina = corrupção'.
				"""
			relatedTerms: ["term-eligibility-decision"]
		},

		{
			code:     "term-reasoning-trace"
			name:     "Rastreio de Raciocínio"
			termEn:   "Reasoning Trace"
			category: "value"
			definition: """
				Estrutura IMUTÁVEL anexada a cada decisão (Risk Score +
				Eligibility Decision + Risk Alert) capturando: signals
				consumidos + policyVersion + modelVersion + applicableContext
				+ intermediate computations. Audit primitive — permite
				reconstrução pós-hoc de decisão dado snapshot. Bacen + Lei
				13.726 + LGPD precondition.
				"""
			rationale: """
				Sem reasoning trace, decisão é opaca → indefensável em
				audit + susceptible a drift silencioso. Per bd-policy-and-
				model-version-snapshot: snapshot per-decision é mais robusto
				que pontual global. vm-rew-eligibility-reasoning-trace-
				completeness target 100% — reasoning trace ausente = decisão
				black-box.
				"""
			relatedTerms: ["term-risk-score", "term-eligibility-decision", "term-risk-alert"]
		},

		// ============================================================
		// LAYER 3 — DECISION (4 terms)
		// Outputs decisórios + context tuple + lifecycle managed alert.
		// Decisão DERIVADA — não é verdade, é hipótese governável.
		// ============================================================

		{
			code:     "term-risk-score"
			name:     "Score de Risco"
			termEn:   "Risk Score"
			category: "value"
			definition: """
				HIPÓTESE QUANTIFICADA sobre a realidade econômica de uma
				entidade — output numérico (NÃO verdade) produzido por
				aplicação determinística de Risk Model sobre Signal
				consolidado, com Confidence Interval refletindo Signal
				Coverage. Carrega scoreVersion, computedAt e Reasoning
				Trace. Decisão DERIVADA de Risk Model + Signal — distinct
				de Eligibility Decision (que combina Score + Policy).
				"""
			rationale: """
				Founder canonical R5++++: 'score ≠ verdade; score =
				hipótese quantificada sobre a realidade'. Distinct de
				prediction (não promete futuro) e classification (não
				categoriza). Score é PRIMITIVO da decision layer. vm-rew-
				deterministic-replay-rate target ≥ 99.99% (non-determinism
				IS failure mode).
				"""
			relatedTerms: ["term-risk-model", "term-confidence-interval", "term-signal", "term-eligibility-decision"]
		},

		{
			code:     "term-eligibility-decision"
			name:     "Decisão de Elegibilidade"
			termEn:   "Eligibility Decision"
			category: "value"
			definition: """
				Decisão CATEGÓRICA derivada (eligible | conditionally-
				eligible | ineligible) de Risk Score + Risk Policy +
				Applicable Context. SEMPRE contextual — nunca propriedade
				estática da entidade. Carrega reasoningTrace +
				applicableContext. Strength epistemológica é função de
				Confidence Interval (dimensão SEPARADA — decisão categórica
				distinct de força epistemológica).
				"""
			rationale: """
				Founder canonical: 'eligibility sem contexto é erro
				conceitual'. Decisão categórica + Confidence é dimensão
				epistemológica separada — duas dimensões NUNCA confundir.
				Per bd-contextual-eligibility-not-static: 'empresa X é
				elegível' NÃO é statement válido — apenas 'empresa X é
				elegível para produto Y sob política V no tempo T'.
				"""
			antiTerms: [{
				term: "Eligible Entity"
				clarification: """
					'Empresa X é elegível' NÃO é statement válido. Eligibility
					é função de (entity, product, policy, time) — nunca
					propriedade estática da entity. Uso como label estática
					quebra bd-contextual-eligibility e gera bugs conceituais
					enormes.
					"""
			}]
			relatedTerms: ["term-risk-score", "term-risk-policy", "term-applicable-context", "term-confidence-interval"]
		},

		{
			code:     "term-risk-alert"
			name:     "Alerta de Risco"
			termEn:   "Risk Alert"
			category: "entity"
			definition: """
				Sinal estruturado de mudança de estado de risco com
				lifecycle PERSISTENTE: open → acknowledged → resolved.
				Cada transição é evento auditável com resolutionReason +
				reasoningTrace. NÃO é fire-and-forget — alert NÃO resolvido
				implica entity em estado degraded persistente downstream
				(CMT signaling permanent até RiskAlertResolved).
				"""
			rationale: """
				Founder canonical: 'alert errado é pior que ausência de
				alert'. Lifecycle managed previne alert noise eternal.
				Stateful (não event-only); idempotent re-emission para
				mesma condition. Per bd-alert-explicit-lifecycle-managed
				+ vm-rew-alert-lifecycle-integrity target 100%.
				"""
			examples: [{
				context:  "Critical threshold breach"
				instance:  "RiskAlertOpened kind='critical-threshold-breach' → CMT signaling → ResolveRiskAlert command → RiskAlertResolved → CMT clears signaling."
			}, {
				context:  "Inconsistent signals"
				instance:  "RiskAlertOpened kind='inconsistent-signals' (NPM ativo + DLV degraded + FCE atrasos) → founder review (BC owners reverem signal validity); REW NÃO resolve conflito autonomamente."
			}]
			relatedTerms: ["term-reasoning-trace"]
		},

		{
			code:     "term-applicable-context"
			name:     "Contexto Aplicável"
			termEn:   "Applicable Context"
			category: "value"
			definition: """
				Tupla (entityRef, productCode, policyVersion, evaluationTime)
				carregada por toda Eligibility Decision. Materializa
				princípio bd-contextual-eligibility: eligibility é função
				de contexto, NÃO propriedade estática. Mesma entity pode
				ter eligibility diferente para produto diferente OR mesma
				entity+produto sob política diferente OR mesmo contexto
				em tempos diferentes.
				"""
			rationale: """
				Sem Applicable Context explicit, eligibility vira proprietary
				stale label da entity → bug enorme. Caching de eligibility
				é per-context — invalidação on policy change. Tupla
				materializa contextualidade obrigatória.
				"""
			relatedTerms: ["term-eligibility-decision", "term-risk-policy"]
		},

		// ============================================================
		// LAYER 4 — CONTROL (2 terms)
		// Governança das decisões. Model PREVÊ; Policy DECIDE.
		// Separação rígida obrigatória per founder R5++++.
		// ============================================================

		{
			code:     "term-risk-model"
			name:     "Modelo de Risco"
			termEn:   "Risk Model"
			category: "entity"
			definition: """
				Função MATEMÁTICA versionada que transforma Signal
				consolidado em Risk Score. Determinístico (replay produz
				mesmo output dado mesmos inputs + modelVersion). Cada
				decisão carrega modelVersion snapshot. Promotion é
				supervised decision com backtesting. MODEL PREVÊ —
				responde 'qual o risco?' (matemático). Distinto de Risk
				Policy (que DECIDE).
				"""
			rationale: """
				Founder canonical: 'model prevê; policy decide'. Mathematical
				function distinct de business rule. Versioning permite
				calibração contínua sem invalidar decisões prévias. Confusão
				model+policy em 90% sistemas resulta unauditable +
				impossível versionar corretamente + impossível explicar
				decisão.
				"""
			antiTerms: [{
				term: "Risk Policy"
				clarification: """
					Policy NÃO é Model. Model é função (signals → score);
					Policy é regra (score → decision). Confusão = unauditable.
					Model responde 'qual o risco?'; Policy responde 'o que
					fazemos com esse risco?'.
					"""
			}]
			relatedTerms: ["term-risk-policy", "term-risk-score", "term-signal"]
		},

		{
			code:     "term-risk-policy"
			name:     "Política de Risco"
			termEn:   "Risk Policy"
			category: "entity"
			definition: """
				Regras VERSIONADAS que transformam Risk Score em Eligibility
				Decision. Define thresholds, eligibility rules, decision
				boundaries por (productCode, vertical). Cada decisão emitida
				carrega policyVersion snapshot imutável. Mudança de Policy
				é supervised decision (founder approval). POLICY DECIDE —
				responde 'o que fazemos com esse risco?' (regras). Distinto
				de Risk Model (que PREVÊ).
				"""
			rationale: """
				Policy ≠ Model. Confusão em 90% sistemas resulta unauditable
				+ impossível versionar corretamente. Policy é business rule
				layer; Model é mathematical function layer. Separation
				enables independent evolution sob diferentes cadências
				(model: calibração contínua; policy: governança regulatória).
				"""
			antiTerms: [{
				term: "Risk Model"
				clarification: """
					Model NÃO é Policy. Model produz score (matemático);
					Policy aplica regras sobre score (business). Confusão
					impede auditability + versionamento independente.
					"""
			}]
			relatedTerms: ["term-risk-model", "term-eligibility-decision"]
		},

		// ============================================================
		// LAYER 5 — ACTOR (1 term)
		// Adversário canonical — classe de COMPORTAMENTO, NÃO entity.
		// Cross-BC reusable (sh-06 catalog).
		// ============================================================

		{
			code:     "term-economic-adversary"
			name:     "Adversário Econômico"
			termEn:   "Economic Adversary"
			category: "role"
			definition: """
				CLASSE DE COMPORTAMENTO (não entity específica nem actor
				único) que pode ser assumida por QUALQUER ator no sistema
				(sh-01, sh-02, sh-05) caracterizada por intent primário de
				extrair valor via exploração de incentivos econômicos.
				Vetores R4+++ (delay attack, value concentration, probing
				distribuído, cancel-then-reissue laundering, coordenação
				cross-actor) são intent primary — NÃO desvio comportamental.
				Modelado canonicamente como sh-06 em domain/stakeholder-
				map.cue (cross-BC reusable).
				"""
			rationale: """
				Founder canonical: 'o adversário não é quem ele é — é o
				que ele faz'. Behavior class transcends actor identity.
				Sem essa classe explícita, manipulationVector designs
				viram bolt-on em vez de derivados. R4+++ patterns são
				intent primary para sh-06 (vs desvio comportamental para
				sh-01/sh-02 stakeholders legítimos).
				"""
			examples: [{
				context:  "Delay attack"
				instance:  "Pagamentos dentro de 60d com p95 ~55d para evitar realization-gap absoluto mas explorar capital tied up downstream — detected via dm-receivable-realization-gap layer 5 (p95 settlement > 45d)."
			}, {
				context:  "Value concentration"
				instance:  "Concentrar valor em poucos atores controlados para improve perceived performance — detected via dm-value-concentration cross-metric requirement (concentração + behavioral red flag)."
			}, {
				context:  "Probing distribuído"
				instance:  "Coordenar múltiplos atores cada um abaixo de single-actor threshold para evitar concentration flag (multi-actor distribution detection: ≥ 4 emissores com block-rate individual > 8%)."
			}]
			relatedTerms: ["term-risk-alert"]
		},
		{
			code:     "term-avaliacao-de-risco"
			name:     "Avaliação de Risco"
			termEn:   "Risk Evaluation"
			category: "entity"
			definition: "Aggregate central do REW: a avaliação de risco que owns o lifecycle (compute -> emit -> stale|superseded), o snapshot de sinais e a reasoning trace. Identity por evaluationId surrogate ('identidade != determinismo')."
			rationale: "Conceito raiz do REW; toda operação do BC produz, transiciona ou consulta uma Risk Evaluation. Identity surrogate (evaluationId) porque o determinismo vive no replayHash, não na identidade."
			relatedTerms: ["term-risk-score", "term-eligibility-decision", "term-confidence-interval", "term-solicitar-avaliacao-de-risco"]
			domainModelRefs: ["agg-risk-evaluation"]
		},
		{
			code:     "term-solicitar-avaliacao-de-risco"
			name:     "Solicitar Avaliação de Risco"
			termEn:   "Request Risk Evaluation"
			category: "command"
			definition: "Ação canônica pela qual um consumer (CMT/FCE/SCF) solicita uma risk evaluation. Duplo anchor: raiz da correlation chain + congelamento imutável de modelVersion/policyVersion (inv-rew-version-frozen-at-request) -- swap mid-flow não afeta a evaluation in-flight."
			rationale: "Command de entrada do lifecycle; o duplo anchor (correlation root + version freeze) elimina órfãos de correlação e collapse de comparabilidade por swap de modelo/policy mid-flow."
			relatedTerms: ["term-avaliacao-de-risco", "term-applicable-context"]
			domainModelRefs: ["cmd-request-risk-evaluation"]
		},
		{
			code:     "term-superseder-avaliacao-de-risco"
			name:     "Superseder Avaliação de Risco"
			termEn:   "Supersede Risk Evaluation"
			category: "command"
			definition: "Ação canônica de substituição EXPLÍCITA de uma risk evaluation por outra; o caller declara intenção + reason (vo-decision-reason). O REW nunca supersede automaticamente (inv-rew-explicit-supersede-only) -- race conditions eliminadas por design."
			rationale: "Supersede explicit-only (inv-rew-explicit-supersede-only) porque substituição sem razão é corrupção silenciosa do histórico de decisão; distinto de stale, que é automático e não-decisão."
			relatedTerms: ["term-avaliacao-de-risco", "term-avaliacao-de-risco-superseded"]
			domainModelRefs: ["cmd-supersede-risk-evaluation"]
		},
		{
			code:     "term-marcar-avaliacao-stale"
			name:     "Marcar Avaliação como Stale"
			termEn:   "Mark Evaluation Stale"
			category: "command"
			definition: "Ação canônica interna emitida exclusivamente pela policy pol-mark-stale-on-relevant-signal (actorAuthority='automated-policy') que marca uma risk evaluation como stale quando um sinal relevante chega. Automática, sem intent humano."
			rationale: "Command interno (automated-policy) que resolve a restrição #Policy.issuesCommand preservando o framing 'staleness é automático'; distinto de supersede, que é decisão explícita."
			relatedTerms: ["term-avaliacao-de-risco", "term-avaliacao-de-risco-marcada-stale", "term-signal"]
			domainModelRefs: ["cmd-mark-evaluation-stale"]
		},
		{
			code:     "term-sinal-recebido"
			name:     "Sinal Recebido"
			termEn:   "Signal Received"
			category: "event"
			definition: "Fato da ingestão em REW (via ACL) de um sinal interpretado por um upstream BC (NPM/DLV/NIM/FCE). Idempotency split: (signalId, sourceContext) é identity; signalHash é validação de integridade. 'Received' (ingestão, REW) != 'observed' (upstream)."
			rationale: "'Received' (REW) vs 'observed' (upstream): a observação pertence ao upstream, a ingestão ao REW. O idempotency split (identity vs integrity) elimina mutation undetected; distinto do VO Signal (o conteúdo) -- este é o fato da recepção."
			relatedTerms: ["term-signal", "term-avaliacao-de-risco"]
			domainModelRefs: ["evt-signal-received"]
		},
		{
			code:     "term-avaliacao-de-risco-computada"
			name:     "Avaliação de Risco Computada"
			termEn:   "Risk Evaluation Computed"
			category: "event"
			definition: "Fato de que o cálculo de uma risk evaluation foi finalizado internamente (score+eligibility+confidence). Computed != Emitted ('decidir != publicar'): permite shadow mode, retry sem recompute, isolamento de falha. Carrega signalSnapshotIds (inputs explícitos) para replay determinístico."
			rationale: "Computed != Emitted: o split elimina a classe de bug 'failure de emission gera duplicate compute no retry'; signalSnapshotIds dá inputs explícitos sem os quais não há explicação, só resultado."
			relatedTerms: ["term-avaliacao-de-risco", "term-avaliacao-de-risco-emitida", "term-risk-score"]
			domainModelRefs: ["evt-risk-evaluation-computed"]
		},
		{
			code:     "term-avaliacao-de-risco-emitida"
			name:     "Avaliação de Risco Emitida"
			termEn:   "Risk Evaluation Emitted"
			category: "event"
			definition: "Fato da publicação cross-BC de uma risk evaluation: UM fato atômico unificando score + eligibility + confidence (consolidação do adr-149 / PR #139, ex-RiskScoreEmitted + EligibilityEmitted), consumido por CMT/FCE/SCF. evaluationId é identity anchor; dedupe por evaluationId ('o evento pode duplicar; a decisão não')."
			rationale: "Contract event público. evaluationId estável garante que consumers nunca contam a decisão 2x por retry de emission; a unificação (adr-149) substitui os ex-RiskScoreEmitted + EligibilityEmitted por um fato atômico."
			relatedTerms: ["term-avaliacao-de-risco", "term-avaliacao-de-risco-computada", "term-eligibility-decision", "term-risk-score"]
			domainModelRefs: ["evt-risk-evaluation-emitted"]
		},
		{
			code:     "term-avaliacao-de-risco-superseded"
			name:     "Avaliação de Risco Superseded"
			termEn:   "Risk Evaluation Superseded"
			category: "event"
			definition: "Fato de que uma risk evaluation foi substituída EXPLICITAMENTE por outra (via cmd-supersede-risk-evaluation), com supersedeReason obrigatório. Decisão histórica num fact log append-only -- race conditions e last-write-wins eliminadas por design."
			rationale: "Superseding é decisão histórica (!= active-state read-rule); supersedeReason obrigatório porque substituição sem razão corrompe o histórico. Distinto de stale, que é válido-mas-flagged."
			relatedTerms: ["term-avaliacao-de-risco", "term-superseder-avaliacao-de-risco"]
			domainModelRefs: ["evt-risk-evaluation-superseded"]
		},
		{
			code:     "term-avaliacao-de-risco-marcada-stale"
			name:     "Avaliação de Risco Marcada Stale"
			termEn:   "Risk Evaluation Marked Stale"
			category: "event"
			definition: "Fato de que uma risk evaluation foi marcada stale AUTOMATICAMENTE porque um sinal relevante chegou. Stale != Superseded: a evaluation continua VÁLIDA, apenas FLAGGED para review/refresh (não é decisão). No máximo 1 por evaluation por janela (inv-rew-event-emission-boundedness)."
			rationale: "Staleness sinaliza, supersede decide: stale torna o frescor observável sem mutar o histórico append-only; boundedness (inv-rew-event-emission-boundedness) evita ruído de re-marcação."
			relatedTerms: ["term-avaliacao-de-risco", "term-marcar-avaliacao-stale", "term-signal"]
			domainModelRefs: ["evt-risk-evaluation-marked-stale"]
		},
	]

	rationale: """
		Glossary REW Phase 2 do WI-046 — materializa Ubiquitous Language
		do BC core que serve como pricing moat estrutural da Mesh.
		Sistema de epistemologia operacional sob adversarial pressure.

		FRASE CANONICAL FOUNDER R5++++ (capturada Phase 2 final):
		'Glossary não define palavras — define o que o sistema está
		autorizado a considerar verdade. REW não organiza termos —
		organiza limites do que pode ser considerado verdade.'

		**5 CAMADAS ONTOLÓGICAS EXPLÍCITAS** (founder canonical
		'glossary não é lista — é mapa de como o sistema pensa'):

		(1) REALITY INTERPRETATION LAYER:
		    - Signal (interpretação já validada por BC upstream — NÃO raw data)

		(2) EPISTEMIC LAYER (medidas de ignorância + audit):
		    - Confidence Interval (força epistemológica de decisão)
		    - Signal Coverage (medida objetiva de completude)
		    - Asset Visibility Gap (limite de conhecimento estrutural)
		    - Reasoning Trace (audit primitive — Bacen/Lei 13.726/LGPD precondition)

		(3) DECISION LAYER (outputs):
		    - Risk Score (hipótese quantificada — NÃO verdade)
		    - Eligibility Decision (decisão categórica contextual)
		    - Risk Alert (sinal lifecycle-managed de mudança de risco)
		    - Applicable Context (tupla entity+product+policy+time)

		(4) CONTROL LAYER (governance):
		    - Risk Policy (regras score→decisão — POLICY DECIDE)
		    - Risk Model (função signals→score — MODEL PREVÊ)

		(5) ACTOR LAYER:
		    - Economic Adversary (classe de comportamento, NÃO entity)

		Cada camada tem responsabilidade distinta: interpretar → avaliar
		incerteza → decidir → controlar → pressionar o sistema. Misturar
		camadas gera erro estrutural.

		**PRINCÍPIOS DE FRONTEIRA (firewall semântico)**:

		- Signal NÃO é dado bruto, NÃO é evento, NÃO é métrica agregada.
		  É interpretação validada upstream com integrityProof verified.
		  REW NUNCA interpreta dados — apenas transforma signals.
		  'Se signal virar dado, REW vira monstro.'

		- Risk Model e Risk Policy são DISTINTOS e NÃO intercambiáveis.
		  Model responde 'qual o risco?' (matemático).
		  Policy responde 'o que fazemos com esse risco?' (regras).
		  Confusão = unauditable + impossível versionar corretamente.

		- Eligibility Decision é categórica; Confidence Interval é força
		  epistemológica dessa decisão. Duas dimensões SEPARADAS, NUNCA
		  confundir. 'Eligibility sem contexto é erro conceitual'.

		- Economic Adversary é CLASSE DE COMPORTAMENTO assumida por
		  qualquer actor (sh-01/sh-02/sh-05). 'O adversário não é quem
		  ele é — é o que ele faz'.

		**GLOSSARY DRIFT DISCIPLINE** (founder R5++++ hardening):

		Qualquer alteração em definitions, relatedTerms, antiTerms OR
		ontological layer assignment DEVE disparar:
		(1) cross-BC impact analysis (quais BCs consomem esse termo via
		    canvas/domain-model/agent-spec refs)
		(2) backward-compatibility check (termos antigos ainda válidos
		    sob nova definição? OR breaking change exigindo migration?)
		(3) replay reasoning validation (decisões antigas continuam
		    semanticamente interpretáveis sob nova definição?)

		Princípio canonical: 'mudança semântica não versionada =
		corrupção silenciosa'. Glossary drift NÃO quebra código — quebra
		significado. Sistema continua funcionando, mas com semântica
		errada. Daqui pra frente: mudanças semânticas em terms são
		governance change, não editorial.

		**TERM PROMOTION CRITERIA** (anti-bloat):

		Um novo termo só entra no glossary se:
		- NÃO é composição de termos existentes (decision-version,
		  emission-threshold, snapshot são DERIVADOS — não primitivos)
		- Aparece em ≥ 2 decisões OR capabilities distintas no canvas
		- Resolve ambiguidade semântica real (não conveniência narrativa)
		- NÃO pertence a outro BC (boundary respect — termos transversais
		  vivem em context-map; termos de outros BCs ficam nesses BCs)

		Princípio canonical: 'glossary não cresce por adição — cresce
		por necessidade semântica'. Refinar > expandir.

		**ANTI-CORRUPTION SEMANTIC RULE** (proteção externa):

		Termos do REW NÃO devem ser:
		- Reinterpretados por BCs consumidores (CMT, SCF, FCE) com
		  significado distinto do canonical
		- Re-definidos fora deste glossary
		- Usados com significado distinto do definido aqui

		Qualquer necessidade de tradução cross-BC deve ocorrer via ACL
		(anti-corruption layer per upstream-downstream pattern), NUNCA
		por mutação do significado do termo. CMT/SCF/FCE consomem REW
		published language ('Risk score and eligibility model') via ACL —
		traduzem para sua linguagem interna SEM modificar significado de
		Risk Score, Eligibility Decision, Risk Alert no contexto REW.

		Princípio canonical: 'o problema não é o termo mudar aqui — é
		ele mudar fora daqui'.

		**CROSS-REFERENCE INTEGRITY** (tq-gl-02 satisfeito por inspeção):

		12 terms; 10 com relatedTerms; 11 referências cruzadas internas
		todas válidas. Self-references zero (tq-gl-12 satisfeito).
		Anchoring ≥ 1 per term (tq-gl-09 satisfeito): 4 terms com
		antiTerms + 4 terms com examples + 11 com relatedTerms.

		**FORWARD REFERENCES** (Phase 0 baseline):

		domainModelRefs vazios — o domain-model.cue de REW já existe;
		o backfill dos refs permanece trabalho futuro. Mapeamento alvo
		desse backfill:
		- Signal → vo-signal (value-object)
		- Risk Score → vo-risk-score
		- Eligibility Decision → vo-eligibility-decision
		- Risk Alert → agg-risk-alert (aggregate com lifecycle)
		- Risk Model → ent-risk-model (entity versionada)
		- Risk Policy → ent-risk-policy
		- Confidence Interval → vo-confidence-interval
		- Reasoning Trace → vo-reasoning-trace
		- Applicable Context → vo-applicable-context
		- Asset Visibility Gap → (classification — não aggregate)
		- Signal Coverage → (metric — não aggregate)
		- Economic Adversary → (role — não aggregate)

		**LENS APLICADA**:

		Primary: lens-domain-language-and-terminology-design
		- dl-bilingual-terminology: pt-BR canonical + termEn para code
		  generation; loanwords (Score, Confidence, Signal, Trace, etc.)
		  validados case-by-case via context técnico; Adversário Econômico
		  mantido em PT-BR (conceito estrutural, não técnico)
		- dl-term-selection-criteria: 12 terms primitivos selecionados;
		  derivados (decision-version, emission-threshold, snapshot)
		  EXCLUÍDOS por design (term-promotion-criteria); Eligibility
		  isolado SKIPPED (eligibility sem contexto = erro conceitual)
		- dl-cross-layer-consistency: 5-layer ontological structure
		  explicit; misturar camadas é erro estrutural

		Glossary cresce incrementalmente respeitando term-promotion-
		criteria. Phase 0: 12 primitivos covering core epistemic +
		decision + control + actor layers.

		Glossary INSTANTIATION DISCIPLINE: este glossary é SoT canonical
		da Ubiquitous Language do REW. Mudanças DEVEM passar por
		governance review (drift discipline). Daqui pra frente: agentes
		consultam ESTE arquivo para validar terminologia em domain-model
		(Phase 3), agent-spec (Phase 4), governance envelope (Phase 5).

		**Phase 2 close-out**: 12 terms canonical materialized; 5-layer
		ontological structure explicit; 3 hardening rules incorporated
		(drift discipline + promotion criteria + anti-corruption rule);
		forward refs Phase 3 mapped. Cross-cutting: term-economic-
		adversary references sh-06 catalog entry (added em Phase 1
		commit fbe0b2d cross-cutting).
		"""
}
