package dlv

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// canvas.cue — Bounded Context Canvas: Delivery & Verification.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// DLV é o quinto BC do macrofluxo Mesh (SSC → {P2P, CTR} → CMT →
// BDG → DLV → INV → FCE). É o gate verificável que materializa a
// invariante central da tese Mesh: no evidence → no economic
// progression. DLV consome evidência (LOG via contract estruturado),
// valida integridade a partir de provas IDC (validação local — sem
// confiança implícita), aplica critérios versionados (CMT
// criteriaVersion snapshot) e produz decisões determinísticas,
// idempotentes, atômicas e replay-able, materializadas como eventos
// econômicos consumidos por INV (faturamento), REW (risco), NIM
// (mecanismos de rede) e DRC (disputas).
//
// Frase canônica do papel: DLV é o juiz; LOG é a câmera; CMT é o
// contrato. DLV NÃO captura evidência (LOG), NÃO formaliza
// compromisso (CMT), NÃO fatura (INV), NÃO paga (FCE), NÃO modela
// risco (REW), NÃO contesta verificação (DRC).
//
// Compliance-enforcer thesis-level: DLV impõe a invariante "nenhum
// compromisso progride para faturamento sem evidência verificada"
// — compliance interna da tese (anti-fraude estrutural que torna
// recebíveis Mesh mais confiáveis que tradicionais), NÃO compliance
// regulatória externa (esta vive em IDC/REG por delegação). Esta
// distinção é articulada na rationale de classification.
//
// Authoring manual section-by-section per manualAuthoringProtocol
// (adr-057). 5 ciclos de red team aplicados pre-write + V1→V6
// founder iterations endureceram (a) RECTOR
// bd-evidence-criteria-match-deterministic; (b) defense in depth
// integridade ≠ verdade (3 camadas IDC + cross-evidence + REW/NIM);
// (c) idempotency identity (commitmentRef, evidenceRef) com
// criteriaVersion attribute, NÃO identity component; (d)
// supersession total ordering (timestamp + evidenceRef hash
// tie-breaker); (e) economic finality window single-source DLV
// clock (NÃO FCE); (f) exception state transitivity 14-day mandatory.
//
// Materializado em 7 commits incrementais (ordering aprovado pelo
// founder com businessDecisions ANTES de communication):
//   1.1 — skeleton: identity + classification + roles + ownership
//         (este commit)
//   1.2 — capabilities (4)
//   1.3 — businessDecisions (14) + stakeholders (3) + costsEliminated (2)
//   1.4 — communication (5 inbound + 2 outbound + 2 query-deps + 2
//         commands + 2 query-surfaces)
//   1.5 — incentiveAnalysis (4 vetores) + governanceScope finalize
//         (5 autonomous + 3 supervised + 5 escalation)
//   1.6 — assumptions (4) + openQuestions (7+) + verificationMetrics
//         (4) + outer rationale completo
//   1.7 — SRR srr-dlv-canvas
//
// Cada commit deixa o canvas em shape válido (cue vet ./...) com
// conteúdo placeholder explícito nas seções pendentes — substituído
// por conteúdo substantivo no commit subsequente.

canvas: artifact_schemas.#Canvas & {
	code: "dlv"
	name: "Delivery & Verification"

	purpose: """
		Verificar execução operacional contra critérios versionados
		acordados em CMT, decidindo deterministicamente suficiência
		de evidência para progressão econômica. DLV consome
		evidência (LOG via contract
		estruturado), valida integridade a partir de provas IDC
		(validação local — sem confiança implícita), aplica critérios
		versionados (CMT criteriaVersion snapshot) e produz decisões
		determinísticas, idempotentes, atômicas e replay-able. DLV é
		o gate verificável que materializa a invariante central da
		tese Mesh: no evidence → no economic progression — sem este
		gate, a decisão de 'evidência suficiente para pagar' ficaria
		distribuída entre LOG (que captura mas não julga) e FCE (que
		paga mas não verifica), e a invariante degrada de gate
		verificável a acordo informal.
		DLV NÃO captura evidência (LOG), NÃO formaliza compromisso
		(CMT), NÃO fatura (INV), NÃO paga (FCE), NÃO modela risco
		(REW), NÃO contesta verificação (DRC). Anti-mini-NIM: DLV
		não computa scoring nem políticas de risco — apenas DECIDE
		suficiência por critério estruturado, e produz sinais de
		qualidade que REW/NIM consomem.
		"""

	ubiquitousLanguageRef: "contexts/dlv/glossary.cue"

	classification: {
		subdomainType:    "core"
		businessRole:     "compliance-enforcer"
		wardleyEvolution: "custom"
		rationale: """
			Core porque a decisão de suficiência de evidência é o
			diferencial central da tese Mesh (per dlv subdomain
			rationale) — é o que torna recebíveis da Mesh mais
			confiáveis que recebíveis tradicionais. Não terceirizável
			porque os critérios de verificação são proprietários e
			evoluem com dados acumulados pela rede.
			Compliance-enforcer thesis-level (NÃO regulatório):
			DLV enforça a invariante 'nenhum compromisso progride
			para faturamento sem evidência verificada' — esta é
			compliance interna da tese (anti-fraude estrutural,
			mech-evidence + mech-agent-gate), NÃO compliance
			regulatória externa (que vive em IDC/REG por delegação).
			Distinção semântica explícita: dois tipos de compliance
			no sistema — externa (leis, reguladores) em IDC/REG;
			interna (invariantes econômicas que tornam o sistema
			confiável) em DLV. Operational-enabler dilui este papel
			(reduziria DLV a infra de suporte); revenue-generator
			não cabe (CMT formaliza receita; DLV verifica execução);
			engagement-creator irrelevante.
			Custom (Wardley) porque criteria-evidence matching
			determinístico com criteriaVersion snapshot + defense in
			depth integridade ≠ verdade exige construção específica
			— não há solução de mercado que integre verificação
			determinística de evidência operacional com integridade
			criptográfica e supersession total ordering. Não é
			genesis (problema compreendido — verificação operacional
			existe há décadas em construção/logística/energia); não
			é product (soluções de mercado cobrem domínios isolados,
			não a integração com macrofluxo financeiro Mesh); não é
			commodity (proprietário e evolutivo).
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			DLV é horizontal por natureza — critérios são verticais.
			Os mecanismos do BC (criteria match deterministic,
			defense in depth integridade ≠ verdade, idempotency com
			identity (commitmentRef, evidenceRef), atomicity emit-
			ou-rollback, supersession total ordering, lifecycle
			público mínimo, economic finality window) operam sobre
			primitivas universais e NÃO dependem da vertical de
			aplicação. Os critérios concretos (medição de obra em
			construção civil ≠ confirmação de entrega em logística
			≠ inspeção de equipamento em energia) materializam-se
			via CMT criteriaVersion snapshot (versioning explícito)
			+ industry packs (Phase 1+ per oq-dlv-6) — externalizados,
			não cozidos no DLV. Esta separação é estrutural: DLV
			permanece estável enquanto verticais expandem; expansão
			vertical adiciona criteria definitions sem alterar
			engine de matching.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["analysis"]
		rationale: """
			Gateway como primário: DLV é gate verificável de
			progressão financeira do macrofluxo — sem decisão DLV
			'verified', INV não fatura, REW não scored, FCE não
			paga. Frase canônica: DLV é o juiz; LOG é a câmera;
			CMT é o contrato. Gate é função numérica determinística
			(criteria match sim/não), NÃO julgamento — habilita
			automation 24/7 e replay deterministic.
			Analysis como secundário: DLV ANALISA evidência contra
			critérios versionados para decidir suficiência —
			separação ingestion/evaluation (bd-ingestion-evaluation-
			separation) materializa este archetype. Paralelo a SSC
			(analysis secondary — analisa fitness signals); aqui DLV
			analisa evidence sufficiency. NÃO 'execution' (que
			conflitaria com P2P emit + CMT formalize); NÃO
			'specification' (CMT especifica critérios; DLV consome
			versionados); NÃO 'engagement' (NPM domain).
			"""
	}

	// =============================================
	// CAPABILITIES (4)
	// =============================================

	capabilities: {
		operational: [{
			description: """
				Avaliação determinística de evidência operacional contra
				critérios versionados (CMT criteriaVersion snapshot):
				match function pura sem julgamento — input (evidence +
				criteria + integrityProof) → output (verified | rejected)
				reproduzível bit-a-bit em replay. Insuficiência de
				evidência é tratada como rejected + reasonCode (não
				terceiro estado); excepções operacionais (e.g.,
				regulatory edge) flagged via escalation, fora do output
				da função.
				"""
			rationale: """
				Sem capability própria de domain-definition — emerge
				da análise dos businessDecisions: criteria-evidence
				matching deterministic é o RECTOR estrutural do BC e
				o thesis-invariant central da Mesh. Determinismo é
				precondition de cc-03 (24/7), idempotency e replay;
				sem isso, gate vira julgamento e degrade para acordo
				informal. Identity de avaliação + criteriaVersion
				attribute pertencem ao layer de businessDecisions
				(1.3), NÃO ao shape da capability.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua e regulatory-grade de verificações:
				cada verificação carrega imutavelmente evidenceRef
				(DSSE-anchored via IDC) + criteriaVersion +
				commitmentRef + decisionOutcome + decidedAt; trail de
				cadeia de evidência satisfaz audit Lei 12.846/SCD/CVM
				(5 anos retention) e habilita forensic replay
				(qualquer decisão DLV reconstruível bit-a-bit a partir
				de inputs imutáveis).
				"""
			rationale: """
				Capability matches cc-04 do domain-definition
				(auditoria contínua); DLV-specific aspect: cadeia de
				evidência DSSE-anchored (validação local de prova IDC,
				sem confiança implícita) torna trail criptograficamente
				verificável end-to-end — diferencial vs auditoria
				tradicional baseada em logs interpretativos.
				"""
		}, {
			capabilityRef: "cc-03"
			description: """
				Operação 24/7 via deterministic gate: EvaluateVerification
				consome evidence + criteria sync, retorna outcome
				immediate sem janela de aprovação humana no caminho
				normal. Determinismo (capability anterior) habilita
				automation: gate é função numérica reproduzível, não
				julgamento. Supervised paths (override-rejection +
				manual-reconciliation + criteria-version-override)
				materializados como escalation com humano-in-the-loop
				separados, sem bloquear caminho autônomo.
				"""
			rationale: """
				Capability matches cc-03 do domain-definition (24/7);
				DLV-specific aspect: deterministic gate é precondition
				operacional — sem determinismo, 24/7 vira hand-off
				humano sustentado e o gate degrade. Anti-mini-NIM
				enforced: DLV decide suficiência, NÃO scoring nem
				políticas (REW/NIM territory).
				"""
		}, {
			description: """
				Lifecycle público mínimo via 2 events pareados
				(DeliveryVerified + DeliveryRejected) consumidos por
				INV (faturamento gate), REW (qualidade-de-execução
				signal), NIM (mecanismos de rede signal), DRC (entry
				point de contestação) — single source of truth para
				decisão de suficiência de evidência downstream do
				macrofluxo. Events carregam (commitmentRef, evidenceRef,
				criteriaVersion, decisionOutcome, decidedAt) imutáveis;
				rationale de match completo permanece intra-DLV (audit
				query-surface QueryEvidenceLedger), preservando
				confidencialidade competitiva de critérios sob
				criteriaVersion proprietário. DRC consome ambos events
				com semântica diferenciada: DeliveryRejected como
				entry point imediato de disputa; DeliveryVerified
				como contexto para disputa posterior dentro da
				economic finality window (post-verification-dispute
				path).
				"""
			rationale: """
				Sem capability própria de domain-definition — emerge
				dos businessDecisions: lifecycle público mínimo é
				decisão estrutural (precondition do macrofluxo entre
				verification gate e progressão econômica). 2 events
				suficientes; DRC owns dispute lifecycle (sem event
				próprio DLV→DRC). Naming Delivery* (não Verification*)
				preserva vínculo econômico com macrofluxo (delivery →
				invoicing → settlement) e alinhamento cross-BC.
				"""
		}]
		hasSyncSurface:  true
		hasAsyncSurface: true
	}

	// =============================================
	// BUSINESS DECISIONS — Lote 1/4 (núcleo determinístico)
	// Lote 2 (lifecycle/estados) + Lote 3 (economia/fronteiras) +
	// Lote 4 (BDs restantes) appended em commits subsequentes.
	// Ordering aprovado pelo founder: businessDecisions (1.3) ANTES
	// de communication (1.4) tanto em commit order quanto em source
	// order — BDs governam o que communication materializa.
	// =============================================

	businessDecisions: [{
		id: "bd-evidence-criteria-match-deterministic"
		decision: """
			Toda decisão DLV de verificação é função pura sobre tripla
			de inputs estruturados — (evidence, criteria,
			integrityProof) — produzindo output binário verified |
			rejected reproduzível bit-a-bit em replay. NÃO há terceiro
			estado: insuficiência de evidência é tratada como rejected
			+ reasonCode estruturado (e.g., insufficient-evidence,
			integrity-failure, criteria-mismatch, ...) — taxonomy
			específica fechada em domain-model (Phase 3) ou BD
			dedicado posterior; aqui declarada como categoria aberta
			para acomodar reasonCodes derivados de businessDecisions
			de outros lotes (e.g., evidence-withheld via incentive
			Analysis Lote 1.5; exception-unresolved-timeout via
			bd-exception-state-transitive Lote 2). Excepções
			operacionais (regulatory edge, criteria-version-override,
			manual-reconciliation) são flagged via escalation
			supervisedDecision separada, fora do output da função.
			Avaliação NÃO consulta estado externo mutável durante a
			função (cache de criteria é snapshot imutável referenciado
			por criteriaVersion; integrityProof é verificada localmente
			sobre evidenceRef DSSE-anchored).
			"""
		rationale: """
			RECTOR estrutural do BC e thesis-invariant central da Mesh:
			é a propriedade que torna recebíveis Mesh mais confiáveis
			que tradicionais (per dlv subdomain rationale).
			Determinismo é precondition de (a) cc-03 24/7 sem
			aprovação humana no caminho normal — gate é função
			numérica, não julgamento; (b) bd-verification-idempotent —
			mesmo input produz mesmo output; (c) bd-replay-
			deterministic-criteria-versioned — decisão histórica
			reconstruível bit-a-bit. Sem determinismo, gate degrade
			para acordo informal e a invariante 'no evidence → no
			economic progression' colapsa. Output binário (V6) é
			decisão consciente: terceiro estado 'insufficient' cria
			ambiguidade operacional (downstream INV/REW/FCE precisam
			decidir ou esperar?) que viola single-source-of-truth do
			macrofluxo — V5→V6 endurecimento.
			"""
		consequences: """
			(a) Criteria evolution exige version bump explícito (CMT
			owns criteriaVersion lifecycle); silent criteria mutation
			é proibido por construção. (b) Insuficiência de evidência
			materializa-se como DeliveryRejected + reasonCode —
			downstream taxonomy clara permite retry path (sh-02
			fornecedor pode submeter evidência adicional sob
			commitmentRef original; novo evidenceRef triggers nova
			avaliação per bd-verification-idempotent). (c) Excepções
			operacionais NÃO contornam determinismo do caminho
			autônomo — supervisedDecision separada com humano-in-
			loop + audit trail. (d) Replay engine (forensic + dispute)
			opera sobre inputs imutáveis sem necessidade de estado
			externo — habilita audit Lei 12.846/SCD/CVM e DRC dispute
			resolution com integridade temporal.
			"""
	}, {
		id: "bd-verification-idempotent"
		decision: """
			Identidade canônica de avaliação DLV é a tupla
			(commitmentRef, evidenceRef). Mesma identidade produz o
			MESMO outcome (verified | rejected) com o MESMO reasonCode
			SOB OS MESMOS INPUTS E VERSÃO DE LÓGICA DE AVALIAÇÃO —
			propriedade condicional, não garantia absoluta: bug fix em
			parsing OU evolução de engine de matching pode produzir
			outcomes legitimamente distintos para a mesma identidade
			histórica (ver bd-replay-deterministic-criteria-versioned
			para tratamento). Em operação normal sob versão de lógica
			vigente, retries, replays e duplicatas de RecordEvidence/
			EvaluateVerification por at-least-once delivery convergem
			para o MESMO outcome. criteriaVersion é ATTRIBUTE imutável
			da decisão emitida, NÃO componente da identidade —
			deliberado: criteria upgrade downstream (CMT publica
			criteriaVersion N+1) NÃO re-triggera avaliação de
			verifications existentes sob versão N. Reavaliação
			operacional padrão (que produz NOVO DeliveryVerified |
			DeliveryRejected event) ocorre APENAS com novo evidenceRef
			registrado (e.g., supersession via EvidenceSuperseded LOG
			— ver bd-evidence-supersession-not-choice em Lote 2).
			Reavaliações excepcionais — replay forensic, audit
			reconstruction, DRC dispute investigation — NÃO produzem
			novo outcome operacional: são leituras determinísticas do
			passado sob inputs imutáveis, não ato decisório novo
			(separação articulada em bd-replay-deterministic-criteria-
			versioned).
			"""
		rationale: """
			Idempotency é precondition operacional de at-least-once
			delivery em sistemas event-driven (default semantics da
			Mesh): sem idempotency, retry de RecordEvidence ou
			re-publication de EvidenceRecorded LOG poderia gerar
			verifications duplicadas com outcomes inconsistentes
			(race condition entre cache de criteria e evidence
			propagation), violando determinismo (bd-evidence-criteria-
			match-deterministic) na camada operacional. Identity
			(commitmentRef, evidenceRef) — NÃO incluindo
			criteriaVersion — é decisão crítica V6: incluir
			criteriaVersion na identidade significaria que upgrade de
			criteria invalidaria verifications passadas (forçando
			re-evaluation), quebrando economic finality (bd-economic-
			finality-window em Lote 3) e replay determinism
			(bd-replay-deterministic-criteria-versioned).
			criteriaVersion como attribute permite coexistência de
			verifications sob versões distintas no Event Log —
			propriedade essencial para auditabilidade histórica e
			dispute resolution sob critérios vigentes à época.
			Garantia condicional (vs absoluta) à versão de lógica de
			avaliação reconhece que motor pode evoluir (bug fix,
			parser hardening) sem comprometer audit: replay sob
			versão de lógica histórica reproduz outcome original
			(bd-replay-deterministic-criteria-versioned), enquanto
			operação corrente usa versão atual.
			"""
		consequences: """
			(a) Storage layer DLV exige unique constraint em
			(commitmentRef, evidenceRef) sobre o aggregate de
			Verification — duplicatas detectadas no insert path,
			retornando outcome existente (idempotent emit). (b)
			Criteria evolution NÃO invalida verifications históricas
			— versão N permanece válida indefinidamente para decisões
			emitidas sob ela; versão N+1 aplica apenas a novo
			evidenceRef pós-criteria activation. (c) Supersession
			(evidência substituída por nova evidenceRef sob mesmo
			commitmentRef) NÃO viola idempotency: nova identidade
			(commitmentRef, evidenceRef-N+1) é distinta — produz nova
			verification, com total ordering (timestamp + evidenceRef
			hash tie-breaker per bd-evidence-supersession-not-choice
			Lote 2). (d) DRC dispute lifecycle opera sobre
			verifications imutáveis — contestação produz dispute
			artifact em DRC consumindo a verification DLV existente
			como evidência da decisão original; NÃO muta verification
			DLV nem trigger nova avaliação operacional. Replay/audit
			por DRC é leitura determinística (per bd-replay-
			deterministic-criteria-versioned), não re-decisão.
			(e) Versão de lógica de avaliação é versionada como
			engine artifact (Phase 3 domain-model); decisões DLV
			carregam reference imutável à versão de lógica vigente à
			época para suportar replay condicional.
			"""
	}, {
		id: "bd-replay-deterministic-criteria-versioned"
		decision: """
			Qualquer decisão DLV histórica é reconstruível bit-a-bit
			por replay engine consumindo a tripla imutável CAUSAL
			(evidenceRef, criteriaVersion, integrityProofSnapshot) —
			sem necessidade de estado mutável externo. Metadata da
			decisão original (decidedAt, decisionOutcome, reasonCode,
			decidedBy) é OUTPUT do replay quando reconstruído, NÃO
			input causal — inputs causais são apenas (evidenceRef,
			criteriaVersion, integrityProofSnapshot). A identidade do
			replay diverge da identidade da decisão original (que é
			(commitmentRef, evidenceRef) per bd-verification-
			idempotent): replay reconstrói o ato decisório sob
			critérios vigentes à época, NÃO re-decide sob critérios
			atuais. criteriaVersion é snapshot criptograficamente
			endereçado (CMT owns lifecycle de criteriaVersion como
			artifact imutável; criteriaVersionRef em decisão DLV é
			hash-anchored para version do CMT snapshot, não um
			símbolo mutável).
			"""
		rationale: """
			Replay determinism é precondition de (a) forensic audit
			Lei 12.846/SCD/CVM (5 anos retention) — auditor precisa
			reconstruir decisão histórica sem ambiguidade; (b) DRC
			dispute resolution — disputas pós-verificação dentro da
			economic finality window exigem evidência da decisão
			original sob critérios da época, não re-decisão sob
			critérios atuais; (c) regulatory trail — Bacen/SCD podem
			solicitar reconstrução de decisão específica anos depois.
			criteriaVersion como snapshot imutável (não símbolo) é
			crítico: se criteriaVersion fosse referência mutável (e.g.,
			'latest construction-civil v3'), criteria evolution
			invalidaria silenciosamente histórico — replay produziria
			outcomes diferentes da decisão original. Snapshot-by-hash
			força CMT a publicar nova criteriaVersion para qualquer
			mudança, e DLV preserva referência hash original
			independente de evolução downstream.
			"""
		consequences: """
			(a) CMT owns criteriaVersion lifecycle como artifact
			imutável append-only com hash content-addressing; mutation
			in-place é proibida por construção. (b) DLV decision
			events (DeliveryVerified | DeliveryRejected) carregam
			criteriaVersionRef hash-anchored — consumidores downstream
			(INV/REW/NIM/DRC) podem resolver ao snapshot exato. (c)
			Replay engine é projeção determinística do Event Log —
			replay corretude validada por property-based tests (mesmo
			Event Log + mesma versão de lógica → mesmo resultado em
			qualquer execução). (d) Criteria evolution path (CMT
			publica criteriaVersion N+1) é evento explícito; cache
			invalidation em DLV é controlada (Phase 1+ via
			criteriaActivation event consumido — ver Lote 4
			communication). (e) Versionamento explícito habilita
			progressive rollout de critérios (e.g., shadow evaluation
			sob versão nova antes de ativar para produção) sem afetar
			decisões em vôo. (f) integrityProofSnapshot deve ser
			conteúdo-suficiente (não depende de lookup externo
			mutável) — refinamento operacional Phase 3 domain-model
			validará shape; aqui declarado como input causal estável.
			"""
	}, {
		id: "bd-ingestion-evaluation-separation"
		decision: """
			DLV separa estruturalmente duas operações distintas: (1)
			INGESTION via RecordEvidence command — append-only de
			(commitmentRef, evidenceRef, integrityProofRef,
			recordedAt) sem julgamento, sem avaliação, sem efeito
			downstream; produz evento de domínio EvidenceRecorded
			interno e nada mais. (2) EVALUATION via
			EvaluateVerification command — função pura sobre
			(evidence ingestada, criteria via criteriaVersion
			snapshot, integrityProof) que emite DeliveryVerified |
			DeliveryRejected. As duas operações têm aggregates
			distintos: ingestion materializa EvidenceRecord;
			evaluation materializa Verification. Trigger de
			evaluation pode ser síncrono (EvaluateVerification
			explícito chamado por agente upstream) OU eventual
			(timer/policy quando criteria + evidence + commitment
			estão todos disponíveis); Phase 0 prioriza síncrono
			explícito, Phase 1+ pode adicionar trigger eventual
			policy-driven. Ingestion NÃO valida critérios — apenas
			integridade local da prova IDC; evidence pode ser
			ingestada antes, durante ou depois de criteria
			activation sem afetar correctness.
			"""
		rationale: """
			Separação previne 4 problemas operacionais que
			apareceriam em design coupled (ingestion + evaluation
			no mesmo command): (a) Race condition criteria-vs-
			evidence — se evaluation executasse no momento da
			ingestion, evidence chegando antes de criteria ativada
			produziria rejeição falsa (criteria não disponível ≠
			criteria não atendida); separação permite re-evaluation
			determinística quando criteria ativam sem mutar
			EvidenceRecord ingestado. (b) Atomicity blast radius —
			ingestion (append imutável, operação leve) tem perfil
			operacional diferente de evaluation (função sobre
			snapshots, pode ser custosa em criteria complexos);
			fusão acoplaria latency budgets. (c) Replay determinism
			— replay precisa reconstruir decisão sem re-ingestar
			evidência (ingestion já é fato registrado); separação
			faz replay = re-execução pura da função evaluation
			sobre EvidenceRecord imutável. (d) Anti-mini-NIM
			enforcement — ingestion sem julgamento força evaluation
			a ser função sobre inputs já-comprometidos (não pode
			escolher quais evidências considerar; só avalia sob
			critérios versionados). Análoga a SSC ingestion
			(RFQOpened) vs decision (SourcingDecisionMade) —
			separação canônica do macrofluxo Mesh entre captura
			de fato e ato decisório.
			"""
		consequences: """
			(a) Aggregate model Phase 3: EvidenceRecord (ingestion-
			time identity (commitmentRef, evidenceRef),
			integrityProofRef, recordedAt — imutável) distinto de
			Verification (evaluation-time identity (commitmentRef,
			evidenceRef), outcome, reasonCode, criteriaVersion
			attribute, decidedAt). (b) EvidenceRecorded é evento
			interno DLV (NÃO publicado cross-BC); apenas
			Verification events são públicos (DeliveryVerified |
			DeliveryRejected). (c) Evaluation pode ser disparada
			múltiplas vezes para mesmo (commitmentRef, evidenceRef)
			— convergem para mesmo outcome sob mesmos inputs e
			versão de lógica per bd-verification-idempotent
			(operações repetidas idempotentes; primeiro emit é
			canonical). (d) Trigger eventual Phase 1+ exige policy
			explícita: 'avaliar quando criteriaVersion(commitmentRef)
			está ativo E evidenceRecord existe E commitment está em
			estado evaluable' — codificada como projection-driven
			worker, não como side effect de ingestion. (e) Ingestion
			path tem SLA latência inferior a evaluation path
			(ingestion é write-thru ao Event Log; evaluation pode
			ser criteria-bound).
			"""
	}, {
		id: "bd-evidence-supersession-not-choice"
		decision: """
			Quando múltiplas evidências chegam para o mesmo
			commitmentRef, DLV NÃO ESCOLHE entre elas — aplica
			SUPERSESSION linear determinística. Total ordering
			canônica sobre conjunto de evidenceRefs por
			commitmentRef ANCORA EM POSIÇÃO NO EVENT LOG
			(eventLogOffset monotônico globalmente determinístico),
			preservando replay-safety por construção. Tie-breaker
			secundário evidenceRef hash (SHA-256 lexicographic
			ordering) absorve qualquer empate teórico de offset
			(improvável dado single-writer Event Log Phase 0;
			preservado como safety net). recordedAt timestamp
			permanece como ATTRIBUTE da EvidenceRecord (audit +
			observability), NÃO como fonte de ordering — clock skew
			cross-ingestion-paths não afeta correctness.

			Trigger de supersession tem caminho primário e fallback
			determinístico:
			(a) PRIMÁRIO: EvidenceSuperseded LOG event consumido
			    por DLV — LOG declara explicitamente que
			    evidenceRef-N+1 substitui evidenceRef-N (LOG owns
			    supersession lineage como source of truth quando
			    disponível).
			(b) FALLBACK: na AUSÊNCIA de EvidenceSuperseded
			    explícito (LOG pode atrasar, falhar OU ainda não
			    modelar lineage para certos fluxos Phase 0), DLV
			    aplica ordering canônica (eventLogOffset + hash)
			    sobre o conjunto de evidenceRefs registradas para
			    commitmentRef e trata o latest sob ordering como
			    canonical-current. Fallback NÃO viola boundary
			    (LOG owns lineage quando declarada); apenas evita
			    travar DLV quando upstream falha — robust-against-
			    failure-of-adjacent-BC. Quando EvidenceSuperseded
			    LOG event chega tardio para fluxo já no fallback,
			    DLV reconcilia: se ordering LOG-declared diverge
			    de ordering DLV-fallback, diferença é flagged como
			    anomaly OBS metric (sig-supersession-lineage-drift)
			    — não corrupção de state (ambas convergem para
			    latest sob ordering canônica), mas signal para
			    revisar lineage declaration upstream.

			A evidência mais recente sob esta ordering é canonical-
			current; evidências anteriores sob mesmo commitmentRef
			tornam-se superseded e produzem Verification events com
			reasonCode=evidence-superseded apontando para
			evidenceRef-novo via supersededByRef attribute.
			Verifications históricas NÃO são mutadas (immutability
			per bd-verification-idempotent + bd-replay-deterministic-
			criteria-versioned); supersession produz NOVA
			verification sob nova identidade (commitmentRef,
			evidenceRef-N+1) — não re-decisão da verification
			anterior.
			"""
		rationale: """
			Supersession linear é decisão estrutural de anti-mini-
			NIM: DLV ESCOLHENDO entre evidências competing seria
			julgamento (qual evidência é melhor?), violando o
			boundary 'DLV decide suficiência por critério, não
			qualidade entre evidências'. Linear ordering força LOG
			(que ingere) a declarar lineage explícita — desloca
			decisão para o domínio onde lineage de evidência é
			primary concern. Total ordering ancorada em
			eventLogOffset (não recordedAt) é necessária para 3
			propriedades: (a) replay determinism — qualquer
			execução de replay produz mesma ordering em qualquer
			máquina, qualquer momento, sem dependência de relógio
			local; (b) idempotency — múltiplas chegadas concurrent
			de EvidenceSuperseded com mesmo (commitmentRef,
			evidenceRef-novo) convergem para mesmo state; (c) clock
			skew safety — Phase 0 não assume sincronização perfeita
			de clocks cross-BC; eventLogOffset é fonte canônica
			global determinística, eliminando classe inteira de
			race conditions cross-ingestion-paths (múltiplos
			workers, retries, reordering temporal).

			Verifications históricas immutable preservam audit
			trail completo (qual decisão foi tomada sob qual
			evidência em qual momento) — supersession adiciona
			lineage forward, não reescreve passado.
			EvidenceSuperseded LOG event como trigger primário
			respeita boundary: LOG owns evidence lifecycle
			(incluindo replacement), DLV reage. Fallback DLV em
			ausência de LOG event evita brittle dependency:
			robust-against-failure-of-adjacent-BC é princípio
			estrutural Mesh — DLV não pode travar porque LOG
			atrasou. sig-supersession-lineage-drift OBS metric
			cria observabilidade real para divergence rate primário-
			vs-fallback, fechando feedback loop estrutural sobre
			saúde do upstream LOG.
			"""
		consequences: """
			(a) Aggregate Phase 3: Verification carrega
			supersededByRef attribute (opcional, hash-anchored);
			evidence-superseded reasonCode é categoria estrutural
			da taxonomy aberta (bd-evidence-criteria-match-
			deterministic Lote 1).
			(b) Supersession produz NOVA evaluation sob nova
			identidade (commitmentRef, evidenceRef-N+1) — emit
			DeliveryVerified ou DeliveryRejected sob novo
			evidenceRef + criteriaVersion vigente à época da nova
			evaluation (NÃO da anterior).
			(c) Downstream INV/REW/NIM consumem Verification events
			e devem manter projeção de canonical-current
			Verification por commitmentRef (latest sob ordering) —
			projection logic é responsabilidade do consumidor, não
			de DLV.
			(d) Race condition concurrent EvidenceSuperseded events
			com diferentes evidenceRef-N+1 candidatos para mesmo
			commitmentRef: resolved deterministicamente por ordering
			canônica (eventLogOffset + hash); converge para mesmo
			final state.
			(e) Janela entre supersession trigger e nova evaluation
			completion é finita mas non-zero; downstream consumers
			podem observar Verifications stale transitoriamente
			(eventual consistency) — economic finality window
			(bd-economic-finality-window Lote 3) bounds tolerância.
			(f) DRC dispute pós-supersession: contestação opera
			sobre Verification HISTÓRICA específica (audit trail
			completo); supersession não invalida path de dispute
			para verification anterior dentro de finality window.
			(g) Edge case clock skew sustentado entre ingestion
			paths: NÃO afeta correctness (eventLogOffset é fonte
			canônica); recordedAt monotonicity per ingestion path
			pode ser monitorada como OBS metric secundária para
			diagnóstico operacional.
			(h) Event Log offset é fonte canônica de ordering
			globalmente — elimina classe inteira de race
			conditions cross-ingestion-paths (múltiplos workers de
			ingestion, retries, reordering temporal); recordedAt
			vira metadata audit-friendly, não input causal de
			correctness.
			(i) Fallback path tem cobertura limitada Phase 0 (LOG
			event ausente apenas em scenarios degraded); operação
			normal usa LOG-declared lineage. sig-supersession-
			lineage-drift OBS metric mede divergence rate primário-
			vs-fallback como sinal de saúde do upstream LOG.
			"""
	}, {
		id: "bd-exception-state-transitive"
		decision: """
			Toda evaluation que entra em estado de exceção
			(escalation pending por insufficient-authority,
			criteria-version-override, manual-reconciliation,
			regulatory-fiscal-ambiguity) tem JANELA MANDATÓRIA DE
			TRANSIÇÃO de 14 dias (Phase 0 hard-coded; Phase 1+
			pode parameterizar per criteria type via openQuestion
			oq-dlv-7). Timer baseado em DLV system time (não
			wall-clock externo) — replay-safe: replay determinístico
			reconstrói transição sob mesma timeline de events
			ingerida.

			Estado de exceção é único por (commitmentRef,
			evidenceRef): apenas UMA exception ativa por evaluation,
			NÃO consolidação em composite reasonCode. Quando nova
			condição de exception surge enquanto exception anterior
			está pending, escalação opera sobre estado vigente
			único (último entry da história); histórico de
			exceptions é PRESERVADO append-only via exceptionHistory
			attribute na Verification aggregate:

			    exceptionHistory: [
			        {reason, timestamp, triggeredBy,
			         resolvedAt?, resolution?},
			        ...
			    ]

			Cada entry preserva ordering temporal, causalidade
			(triggeredBy: actor humano OR system), e evolução do
			incidente. Estado vigente da exception (último entry
			sem resolvedAt) é projeção determinística do histórico.

			Timer 14 dias NÃO reseta com nova entry — preserva
			blast radius temporal a partir do PRIMEIRO entry da
			history (granularidade de auditabilidade preservada;
			estado controlado).

			Founder OR designated approver pode estender janela via
			supervisedDecision extend-exception-window com
			justificativa documentada e novo deadline; extensions
			são CUMULATIVAS (adicionam tempo ao timer existente;
			NÃO reiniciam o relógio do primeiro entry); Phase 0 max
			30 dias TOTAL desde primeiro entry per exception (cap
			absoluto, não cap-por-extensão).

			No T+timer-final do entry da exception, transição
			automática para terminal state ocorre — humano resolveu
			(terminal: verified OR rejected com reasonCode=
			exception-resolved-{outcome}; exceptionHistory entry
			final marca resolvedAt + resolution) OU ausência de
			resolução triggers terminal forçado (terminal: rejected
			com reasonCode=exception-unresolved-timeout). Estado de
			exceção NÃO é estado terminal: lifecycle DLV é
			{pending-evaluation → {evaluating → {verified |
			rejected | exception-pending}} → exception-pending
			{dentro do timer} → terminal {verified | rejected}}.
			exception-during-exception é proibido por construção
			no NÍVEL DE ESTADO (uma única exception ativa) mas
			PRESERVADO no nível de histórico (todas as condições
			que dispararam exception ficam em exceptionHistory).
			"""
		rationale: """
			Estados de exceção sem terminal mandatório são vetor
			clássico de stuck workflow: escalação esquecida, manual
			reconciliation indefinida, regulatory edge ambígua sem
			decisão — consequência é commitment lifecycle bloqueado,
			downstream INV/REW/FCE bloqueados, fornecedor sem
			feedback. Em B2B financeiro, stuck state vira
			reclamação regulatória (Bacen exige resolução de
			pendências em prazos definidos). Janela mandatória
			força resolução: ou humano resolve com audit trail, ou
			sistema resolve por timeout com audit trail.

			14 dias Phase 0 é compromisso operacional: tempo
			suficiente para founder revisar backlog semanal de
			escalations sem ser tão longo que bloqueie commitment
			lifecycle (CMT formalization timeline tipicamente < 30
			dias). Auto-rejection no T+timer é fail-safe (não
			fail-open): se humano não responde, sistema rejeita
			com reasonCode auditável — preserva invariante 'no
			evidence verified → no economic progression' mesmo sob
			falha humana.

			Estado único + exceptionHistory append-only preserva
			granularidade temporal + causalidade + actor sem
			permitir explosão de estado: estado é simples
			(projeção determinística do último entry sem
			resolvedAt), histórico é rico (auditor pode reconstruir
			sequência completa, identificar causalidade entry-N
			triggered-by-system vs entry-M triggered-by-actor,
			diagnosticar patterns sustainados). Timer baseado em
			primeiro entry preserva blast radius temporal —
			múltiplos triggers de exception não estendem janela
			implicitamente.

			Extension supervised cumulativa (não reset) com cap
			absoluto preserva propriedade de bounded blast radius:
			founder pode justificar mais tempo, mas não
			indefinidamente; cap-por-cumulativo (vs cap-por-
			extensão) evita escape via múltiplas extensions
			pequenas. Timer DLV system time (não wall-clock)
			preserva replay determinism — replay sob mesma
			timeline de events produz mesmas transições.

			Phase 1+ parametrização per criteria type reconhece
			que critérios complexos (e.g., obras plurianuais)
			podem requerer windows distintas — explicitamente
			deferred para oq-dlv-7.
			"""
		consequences: """
			(a) Lifecycle público mínimo (cap-delivery-lifecycle-
			public-events Lote 1.2) inclui terminal events apenas:
			DeliveryVerified, DeliveryRejected — exception states
			são internos a DLV (não publicados cross-BC); INV/REW/
			NIM observam apenas terminal outcomes.
			(b) DRC NÃO observa exception states publicamente
			Phase 0 — exception é internal a DLV para evitar ruído
			operacional (stuckness transitória, false alerts antes
			de timer fire); public lifecycle expõe apenas terminal
			events. Phase 1+ DRC pode ganhar query-surface para
			exception lineage (oq-dlv-1) quando DRC tooling
			justifique acesso (e.g., dispute investigation post-
			exception-unresolved-timeout em pattern sustained).
			(c) Timer 14 dias é deterministic worker (projection-
			driven Phase 1+; Phase 0 manual founder review
			semanal); cron-like scheduling fora de DLV core (PLT
			infrastructure) baseado em DLV system time.
			(d) reasonCode taxonomy aberta (bd-evidence-criteria-
			match-deterministic Lote 1) inclui exception-resolved-
			verified, exception-resolved-rejected, exception-
			unresolved-timeout como categorias estruturais.
			(e) exceptionHistory attribute na Verification
			aggregate carrega lista append-only de entries (cada
			um com reason, timestamp, triggeredBy, resolvedAt?,
			resolution?); single active exception é último entry
			sem resolvedAt — projeção determinística.
			(f) Audit trail Lei 12.846/SCD/CVM preserva exception
			lineage completa (entry → escalations → resolution OR
			timeout) — extends regulatory traceability; sustained
			exception-unresolved-timeout rate é OBS metric (Lote
			1.6 verificationMetrics) sinalizando capacidade humana
			insuficiente vs criteria complexity.
			(g) Idempotency preserved (bd-verification-idempotent
			Lote 1): exception retry / replay produz mesmo final
			terminal state sob mesma timeline de eventos; 14-dia
			clock é monotônico per (commitmentRef, evidenceRef),
			não wall-clock global.
			(h) Edge case extension durante última hora antes de
			timeout: deterministic ordering preserva —
			supervisedDecision extend-exception-window timestamped
			antes do timeout prevalece (cumulativo); após timeout,
			supervisedDecision torna-se revert-auto-rejection
			(caminho separado, supervisedDecision distinta).
			(i) Granularidade temporal preservada: auditor pode
			reconstruir sequência de exceptions, identificar
			causalidade (entry-N triggered-by-system vs entry-M
			triggered-by-actor), e diagnosticar patterns
			sustainados (e.g., recorrência de regulatory-edge em
			mesma vertical sinaliza criteria evolution needed).
			(j) Cap absoluto 30 dias TOTAL Phase 0 é compromisso
			estruturalmente bounded — extensions múltiplas pequenas
			NÃO podem agregar acima do cap; founder DEVE justificar
			cada extension individual mas o sistema enforça hard
			cap.
			"""
	}, {
		id: "bd-no-evidence-no-verified"
		decision: """
			DLV NÃO emite DeliveryVerified sem evidência ingestada
			e avaliada explicitamente. Verified NUNCA é estado
			default, timeout, ou inferência: ausência de evidência
			NÃO produz verified silencioso por nenhum caminho —
			autônomo, supervised normal, exception, replay,
			fallback. Estados possíveis para commitment sem
			evidence ingestada: pending-evaluation (aguardando
			RecordEvidence) — terminal forçado em rejected somente
			se commitment timeout policy materializar Phase 1+
			(oq-dlv-3); NÃO em verified. Estados possíveis para
			commitment com evidence ingestada mas avaliação
			pendente: evaluating → terminal {verified, rejected,
			exception-pending → terminal} per
			bd-exception-state-transitive Lote 2.
			supervisedDecision approve-without-evidence NÃO
			existe como path normal. Override de rejected
			(override-rejection supervisedDecision) ainda exige
			evidence ingestada como precondition.

			EMERGENCY OVERRIDE PATH (canal supervised distinto,
			NÃO bypass de hardline anti-default): Existe canal
			supervised específico para situações de DEADLOCK
			OPERACIONAL — erro de integração ingestion path,
			evidência fisicamente disponível mas tecnicamente
			indisponível temporariamente, operação manual em
			região offline. Path: supervisedDecision approve-
			with-emergency-override emite DeliveryVerified com
			reasonCode=exception-emergency-override + attribute
			evidence-out-of-band-ref (apontando para evidência
			externa: documento físico, sistema alternativo,
			atestado manual). Mandatory audit attached: founder
			OR designated approver justifica out-of-band evidence
			existence; flagged para audit obrigatório Lei 12.846/
			SCD/CVM. Reconciliação recomendada: quando evidence
			ingestion path normaliza, evidence ingested formal
			triggers nova evaluation que substitui (via
			supersession Lote 2) a verificação emergency-override
			— preserva audit trail completo (verification original
			com exception-emergency-override permanece imutável;
			supersession adiciona forward lineage para verification
			post-normalização).

			Distinção crítica: emergency override path NÃO viola
			BD7 hard line. BD7 prohibe verified por DEFAULT/
			TIMEOUT/INFERENCE (silent verified emergente de
			omissão); BD7 PERMITE verified EXPLÍCITO por humano-
			with-audit (loud, justified, observable, reversível
			via supersession). Hard line é anti-silencioso, NÃO
			anti-override.

			Cap-evidence-criteria-match-deterministic (Lote 1)
			torna função pura SOBRE evidência; bd-ingestion-
			evaluation-separation (Lote 2) torna evidence
			ingestada precondition estrutural de evaluation;
			este BD fecha o loop: NENHUM caminho silencioso
			produz verified.
			"""
		rationale: """
			Anti-fraude estrutural — RECTOR-adjacent ao
			bd-evidence-criteria-match-deterministic. Se verified
			pudesse emergir por default/timeout/inferência, a
			invariante central da tese Mesh ('no evidence → no
			economic progression') colapsaria silenciosamente:
			bug de timer + estado pendente produziria verified-
			by-omission; race condition + missing evidence
			produziria verified-by-confusion; ataque adversarial
			(sh-01 induz timeout suprimindo evidence) produziria
			verified-by-collusion. Bloqueio explícito elimina
			classe de bugs por construção: NENHUM caminho de
			código produz verified silencioso sem evidence —
			verificável formalmente em domain-model invariants
			Phase 3 (Verification aggregate constraint:
			outcome=verified IMPLIES exists EvidenceRecord with
			same (commitmentRef, evidenceRef) ingestada antes de
			evaluation OR exists supervisedDecision approve-with-
			emergency-override com evidence-out-of-band-ref).

			Distinção semântica de bd-evidence-criteria-match-
			deterministic: BD1 é sobre função pura SOBRE inputs;
			BD7 é sobre PRECONDITION dos inputs (evidence é
			causal, não default). Distinção de bd-exception-
			state-transitive Lote 2: BD6 garante exception
			transitiona em 14 dias (auto-rejection fail-safe);
			BD7 garante que mesmo com exception PROIBE-SE rota
			verified silenciosa sem evidence. Compreensivamente:
			timeout SEMPRE produz rejected (via BD6 fail-safe),
			nunca verified (via BD7 anti-default).

			Emergency override path resolve tensão entre hard
			line anti-default e realidade operacional: ingestion
			path pode falhar temporariamente (PLT outage,
			integração externa quebrada, operação manual em região
			offline) — bloquear absolutely verified produziria
			deadlock operacional onde commitment fica
			indefinidamente pending-evaluation apesar de evidência
			física existir. Solução: canal supervised explícito
			mantém spirit (verified amarrado a claim de evidência)
			sem amarração técnica (evidence ingestada via path
			normal). Audit + flagging garante abuso é detectável;
			reconciliação automática Phase 1+ converge estado
			para evidence-ingested canonical quando ingestion
			normaliza.
			"""
		consequences: """
			(a) Domain-model invariant Phase 3: aggregate
			Verification carries hard constraint outcome=verified
			⟹ (∃ EvidenceRecord (commitmentRef, evidenceRef)
			ingestada antes de decidedAt) OR (∃ supervisedDecision
			approve-with-emergency-override com evidence-out-of-
			band-ref); runtime check no emit path bloqueia estado
			inválido por construção.
			(b) supervisedDecision approve-without-evidence NÃO
			existe; override-rejection (Phase 1.5 governanceScope)
			opera apenas sobre evaluations EXISTENTES com evidence
			ingestada (e.g., founder pode revogar rejected emitido
			sob criteria-version-mismatch e re-trigger evaluation
			sob nova criteriaVersion — mas evidence ingestada é
			precondition).
			(c) Commitment lifecycle external (CMT) com NENHUM
			evidence registered NÃO progride para verification —
			permanece em pending-evaluation até timeout policy
			Phase 1+ (oq-dlv-3); INV/REW/FCE NÃO recebem signal
			de verified, automaticamente preservando invariante
			downstream.
			(d) Replay determinism preservado: replay sob mesma
			timeline de events nunca produz verified em commitment
			sem EvidenceRecord OR supervisedDecision approve-with-
			emergency-override — propriedade verificável via
			property-based test.
			(e) Fail-safe alignment com bd-exception-state-
			transitive Lote 2: timeout em exception-pending
			sempre rejected, nunca verified — preserva invariante
			mesmo sob falha humana.
			(f) Anti-fraude observable Phase 0: verificationMetrics
			Lote 1.6 inclui verified-without-evidence-or-override-
			attempts (esperado sempre 0; non-zero indica bug
			crítico de implementação, não condição operacional).
			(g) supervisedDecision approve-with-emergency-override
			é EXPLICITAMENTE DECLARADA em governanceScope Phase
			1.5 com constraint de uso (emergency real, não
			conveniência); breach rate sustained é OBS metric
			(verificationMetrics Lote 1.6: emergency-override-
			rate sustained > threshold sinaliza ingestion path
			failure ou abuso operacional).
			(h) Reconciliação automática Phase 1+: quando
			ingestion path normaliza para commitment com
			verification emergency-override ativa, trigger
			eventual policy disparar nova evaluation; supersession
			lineage normal preserva verified-by-emergency como
			histórico immutable + verified-by-evidence como
			canonical-current pós-normalization.
			"""
	}, {
		id: "bd-economic-finality-window"
		decision: """
			Toda DeliveryVerified ou DeliveryRejected terminal
			entra em ECONOMIC FINALITY WINDOW de duração finita
			iniciada no decidedAt da decisão (timestamp emitido
			pelo DLV system time, NÃO wall-clock externo nem
			clock FCE). Phase 0 Window hard-coded: 30 dias
			corridos pós-decidedAt (alinhado a V6 finality
			contract; parameterização per criteria type Phase 1+
			via oq-dlv-2). DLV clock é SINGLE SOURCE de finality
			temporal — NÃO herda timing de FCE (settlement) nem
			de INV (invoicing); finality é propriedade de
			verificação, NÃO de pagamento.

			Janela tem duas zonas operacionais distintas:

			(1) DENTRO da window (decidedAt ≤ now < decidedAt+30d):
			DLV pode emitir superseding verification AUTONOMAMENTE
			via bd-evidence-supersession-not-choice Lote 2
			(LOG-driven trigger + fallback DLV em ausência) —
			caminho operacional normal. Verifications históricas
			permanecem immutable (per bd-verification-idempotent
			Lote 1); nova verification torna-se canonical-current.
			INV/REW/FCE devem manter projeção canonical-current
			e tolerar transitória inconsistency (eventual
			consistency dentro da window é compromisso operacional
			aceitável).

			(2) FORA da window (now ≥ decidedAt+30d): verification
			atinge ECONOMIC FINALITY na perspectiva de DLV — DLV
			NÃO emite superseding AUTÔNOMA pós-finality.
			Superseding pós-finality requer caminho controlado:

			(a) supervisedDecision explícita: founder OR
			    designated approver pode autorizar superseding
			    pós-finality via supervisedDecision approve-post-
			    finality-supersession com justificativa
			    documentada (e.g., erro operacional grave
			    descoberto depois, evidência fraudulenta
			    detectada posteriormente, correção regulatória
			    obrigatória); emit nova Verification com
			    reasonCode=post-finality-correction + attribute
			    supervisedOverrideRef apontando para approval.

			(b) DRC-driven trigger: DRC dispute resolution
			    materializa signal estruturado (DRC publishes
			    ResolutionRequiresVerificationUpdate event
			    consumido por DLV) instruindo DLV a emitir nova
			    Verification refletindo dispute resolution (e.g.,
			    verification original era fraud — DRC determinou;
			    nova verification reflete corrected outcome).
			    Consumo via ACL explícita; DLV emite reasonCode=
			    drc-driven-correction + attribute
			    drcResolutionRef.

			LOG-driven supersession (EvidenceSuperseded LOG event)
			que chega pós-finality é registrada em DLV como audit
			trail mas NÃO triggera nova evaluation autônoma —
			flagged como post-finality-supersession-log-event para
			investigation operacional opcional (e.g., anomaly OBS
			metric sinalizando padrão sustained → criteria
			evolution candidate). Não é caminho operacional
			autônomo Phase 0.

			Hard line: pós-finality, nenhum caminho AUTÔNOMO emite
			superseding verification — todos paths exigem humano-
			in-loop OR cross-BC explicit signal (DRC). Preserva
			finality como contrato econômico estável para
			downstream INV/REW/FCE/DRC sem cegueira sistêmica
			diante de fatos novos.
			"""
		rationale: """
			Economic finality é o gate que torna verification
			commitment econômico — sem finality finita, downstream
			INV/REW/FCE não podem materializar irreversibilidade
			(faturamento + pagamento + scoring) confiavelmente, e
			a invariante 'no evidence verified → no economic
			progression' degrade para 'verified pode reverter
			silenciosamente, downstream nunca sabe quando agir'.
			Janela finita resolve trade-off entre correctness
			(permitir supersession para correção legítima) e
			liveness (downstream eventualmente age sobre verified
			estável).

			DLV clock como single source de finality (vs FCE
			clock) é decisão estrutural crítica V6: FCE clock
			criaria coupling perigoso — payment timing dictaria
			verification stability, invertendo causalidade do
			macrofluxo (verified é precondition de pagamento, não
			consequência); DLV não poderia replay determinístico
			se finality dependesse de clock FCE volátil; e
			ambiguidade 'qual clock é authoritative' apareceria
			em edge cases (FCE atrasa settlement, finality
			estende? FCE acelera, finality encurta?). DLV clock é
			local à semântica de verification, independente de
			infraestrutura de pagamento — replay-safe e single-
			purpose.

			Window 30 dias Phase 0 alinha com V6 finality
			contract: 30 dias é compromisso baseline coerente com
			CMT formalization typical timeline (< 30 dias em
			padrão B2B brasileiro), tempo suficiente para LOG
			declarar supersessions legítimas (corrections de
			evidence pós-ingestion) E para descoberta operacional
			de inconsistências pós-verification. INV typical
			invoicing window (2-5 dias) opera DENTRO da DLV
			finality — sem conflito porque INV invoice é
			reversível (cancelar nota) até FCE settlement; DLV
			finality bound é mais conservador propositalmente,
			absorvendo dispute path para DRC quando finality já
			materializou downstream irreversibilidade. Calibração
			per criteria type Phase 1+ — critérios complexos
			plurianuais podem exigir window maior; critérios
			commodity simples podem reduzir. Deferimento explícito
			em oq-dlv-2 com trigger: operational data sustainada
			Phase 0 → calibração baseada em distribution real de
			supersession arrival times.

			Caminho controlado pós-finality (supervisedDecision OU
			DRC-driven) preserva finality como contrato econômico
			estável SEM cegueira sistêmica diante de fatos novos
			descobertos depois (e.g., fraud detectada via Layer 3
			REW/NIM + DRC dispute investigation sustentada). Hard
			line é anti-AUTÔNOMA pós-finality, NÃO absoluta —
			paralela ao princípio BD7 (anti-default, não anti-
			override). Audit obrigatório em ambos paths preserva
			auditabilidade Lei 12.846/SCD/CVM.

			DRC como path exclusivo pós-finality (com
			supervisedDecision como path alternativo) respeita
			boundary: DLV é função verificação determinística com
			janela bounded; DRC é dispute lifecycle com lifecycle
			próprio (prazos, evidência adicional, resolução).
			Misturar compensação pós-finality em DLV acoplaria
			duas responsabilidades distintas e violaria separation
			of concerns que o subdomain mapping estabelece.
			"""
		consequences: """
			(a) Aggregate Phase 3: Verification carrega
			finalityAt = decidedAt + windowDuration attribute
			(computed); state transition pós-finalityAt impede
			emit de superseding verification autônoma via DLV
			core — bloqueio aggregate-level constraint; emit
			supervised OU DRC-driven é caminho explícito com
			audit trail.
			(b) DRC dispute path Phase 0: stakeholder afetado
			abre DRC dispute apontando para Verification
			específica (audit trail completo via bd-verification-
			idempotent immutability); DRC tem query-surface para
			DLV (Phase 0 query-surfaces Lote 1.4) para context
			investigation. DRC pode emitir signal estruturado
			ResolutionRequiresVerificationUpdate consumido por
			DLV via ACL para triggerar nova Verification post-
			finality reflecting dispute resolution.
			(c) Caminhos pós-finality são auditáveis e bounded:
			supervisedDecision approve-post-finality-supersession
			requer founder/approver explicit + justificativa;
			DRC-driven trigger requer DRC native flow + audit.
			Nenhum caminho autônomo emite superseding pós-
			finality.
			(d) post-finality-supersession-log-event (LOG-driven
			trigger chegando pós-finality) é registrado em DLV
			como audit-trail-only — NÃO triggera nova Verification
			autônoma. Anomaly OBS metric (sig-post-finality-
			supersession-rate) sustainada sinaliza window
			calibration inadequada (rate alta → window muito
			curto) candidato para Phase 1+ promotion via
			oq-dlv-2.
			(e) DLV system time como single source: implementação
			Phase 1+ usa monotonic clock per Verification
			aggregate (não system clock global mutável) — replay-
			safe, immune a NTP drift / leap second / wall-clock
			manipulation. PLT infrastructure provê monotonic
			clock primitive; DLV consume.
			(f) verificationMetrics Lote 1.6 inclui:
			- supersession-arrival-distribution (within window
			  vs post-finality) — sinal para calibração window
			  Phase 1+
			- post-finality-dispute-rate (taxa de DRC disputes
			  abertas pós-finality) — sinal de window calibration
			  inadequada (rate alta indica window curto demais)
			- post-finality-supervised-override-rate — sinal de
			  health do canal supervised
			(g) Window hard-coded Phase 0 é tension-entry
			candidate se calibração empírica revelar mismatch
			sustained — então promoção formal para criteria-type-
			specific via oq-dlv-2 materialização.
			(h) Replay determinism: finality computation é função
			determinística (decidedAt + windowDuration) sobre
			Event Log — replay reconstrói finality boundaries
			identicamente.
			"""
	}, {
		id: "bd-truth-vs-integrity-defense-in-depth"
		decision: """
			DLV opera sob princípio EXPLÍCITO de integridade ≠
			verdade: integridade criptográfica (Layer 1) é
			precondition mas NÃO suficiente para verdade
			operacional. DLV materializa defense in depth com 3
			camadas de checagem, sendo Layer 1 e 2 INTERNAS a
			DLV (escopo de evaluation), Layer 3 EXTERNA
			(consumidores downstream):

			Layer 1 — INTEGRITY VALIDATION (DLV scope):
			Verificação local da prova IDC sobre evidenceRef
			(DSSE-anchored). DLV NÃO confia em LOG sobre
			integridade — valida cryptographic proof localmente
			per request. Falha em Layer 1 → DeliveryRejected com
			reasonCode=integrity-failure. Layer 1 garante
			'evidência foi submetida pelo signatário declarado'
			— NÃO garante que conteúdo é verdadeiro.

			Layer 2 — CROSS-EVIDENCE CONSISTENCY (DLV scope):
			Verificação de coerência entre múltiplas evidências
			ingestadas para mesmo commitmentRef sob criteria que
			exigem múltiplas evidências (e.g., 'delivery requires
			photo + GPS + receipt'). 3 classes iniciais (lista
			aberta, extensível via criteriaVersion declarations
			Phase 1+):
			(a) consistency: refs cruzados internamente coerentes
			    (e.g., GPS coordinates dentro de bounded box do
			    commitment delivery location);
			(b) range: valores numéricos dentro de bounds
			    esperados (e.g., quantity ≤ commitment.maxQuantity;
			    weight ≥ minimum threshold);
			(c) temporal: timestamps coerentes (e.g., photo
			    timestamp ≤ delivery timestamp ≤ receipt
			    timestamp).

			Classes adicionais (semantic checks, cross-entity
			validation, document-level validation) podem ser
			adicionadas via criteriaVersion declaration explícita
			em CMT — cada criteria version declara required Layer
			2 check classes; DLV aplica deterministicamente. Phase
			0 cobre consistency/range/temporal como baseline
			universal; verticals adicionando packs Phase 1+
			(oq-dlv-6) podem registrar classes específicas (e.g.,
			vertical-construction declara structural-integrity
			check class; vertical-logistics declara chain-of-
			custody check class). Falha em qualquer Layer 2
			class → DeliveryRejected com reasonCode=cross-
			evidence-inconsistency-{class-name} (taxonomy aberta
			extensível).

			Layer 3 — PATTERN ANOMALY (REW/NIM scope, NÃO DLV):
			Detection pós-verification de anomalias agregadas via
			signals que DLV publica (Verification events com
			reasonCode rico, exceptionHistory, supersession
			lineage). REW/NIM consomem signals e materializam
			scoring/anomaly detection em projection própria —
			DLV NÃO computa, NÃO agrega, NÃO scoring (per
			bd-no-scoring-by-dlv). Detecções Layer 3: collusion
			patterns (todos signers de evidence colluded), fraud
			patterns (forgery sustained), operational anomalies
			(sustained sub-threshold gaming).

			Defense in depth significa que NENHUMA camada SOZINHA
			é suficiente: Layer 1 catches forgery individual;
			Layer 2 catches inconsistency intra-commitment; Layer
			3 catches pattern adversarial cross-commitment. DLV
			honesto sobre limites: Layer 1+2 são deterministic;
			Layer 3 é statistical/probabilistic (REW/NIM
			territory). Verified DLV emit significa 'integridade
			+ consistência atendidas sob criteria versionados' —
			NÃO 'verdade absoluta'.
			"""
		rationale: """
			Integridade ≠ verdade é distinção crítica que muitos
			sistemas financeiros falham em internalizar — assumem
			que cryptographic signature é proof-of-truth e expõem-
			se a fraude colluded (todos signers conspiram para
			evidência false-but-signed). Defense in depth é a
			resposta estrutural: layers múltiplas com escopos
			disjuntos, cada uma cobrindo classe de adversário
			diferente. DLV materializa Layer 1+2 internamente
			(deterministic check); Layer 3 é statistical e
			pertence a REW/NIM por domain mapping (anti-mini-NIM
			enforced via bd-no-scoring-by-dlv).

			Layer 1 (integrity) é precondition por boundary com
			IDC: DLV não confia LOG implicitamente sobre
			integridade cryptographic — valida localmente cada
			prova. Isso é defense-in-depth de primeira camada:
			corrupção em LOG (intencional ou bug) não compromete
			DLV se Layer 1 falha-fechado.

			Layer 2 (cross-evidence consistency) é onde DLV
			adiciona valor sobre integridade pura: 3 classes
			iniciais cobrem casos universais (consistency/range/
			temporal); extensibilidade via criteriaVersion
			declaration permite verticals e domínios específicos
			adicionar checks especializados sem modificar DLV
			core engine. Naming explícito '3 classes iniciais'
			(vs 'as 3 classes') sinaliza abertura para evolução
			— closed list seria constraint desnecessária que
			limitaria capacidade do sistema de capturar nuances
			domain-specific. Phase 0 baseline universal + Phase
			1+ extension via criteria version é pattern Mesh
			para evolutividade controlada: criteria version owns
			extensibility contract; DLV engine permanece estável.

			Layer 3 (pattern anomaly) explicitamente fora de DLV
			respeita anti-mini-NIM hard line: scoring/anomaly
			detection statistical pertence a REW/NIM. DLV produz
			signal-rich events; REW/NIM aggregam, scoram, modelam.
			Misturar Layer 3 em DLV criaria mini-REW dentro de
			DLV, violando boundary e introduzindo dependência
			circular (DLV verifica usando scoring; scoring
			depende de verifications historicas).

			Honestidade sobre limites é decisão de design
			importante: DLV NÃO pretende ser 'truth oracle'.
			Verified emit significa exatamente 'criteria match
			deterministic + integridade Layer 1 + consistência
			Layer 2'. Truth operacional emerge da composição das
			3 layers — sistema Mesh como todo, não DLV sozinho.
			"""
		consequences: """
			(a) Domain-model Phase 3: criteria definition
			explicit sobre quais checks aplicam Layer 1+2 (cada
			criteria version declara required checks). DLV
			applies em ordem Layer 1 → Layer 2 → criteria match
			per BD1 — short-circuit em primeiro fail (e.g., Layer
			1 fail produz rejected sem executar Layer 2;
			preserves replay determinism).
			(b) reasonCode taxonomy aberta (bd-evidence-criteria-
			match-deterministic Lote 1) inclui categorias
			estruturais: integrity-failure, cross-evidence-
			inconsistency-{consistency, range, temporal,
			...class-name extensível} — uma reasonCode per fail
			path Layer 1+2.
			(c) Layer 3 signals para REW/NIM são VERIFICATION
			EVENTS DLV (DeliveryVerified | DeliveryRejected) com
			payload rich (criteriaVersion, integrityProofRef,
			reasonCode, exceptionHistory, supersededByRef,
			finalityAt). REW/NIM consume e processam — DLV NÃO
			compute sobre signals, NÃO publica scoring derivado.
			(d) Layer 3 anomaly detection pode emitir DRC dispute
			signals (REW detecta fraud pattern → REW solicita
			DRC dispute investigation), mas via DRC native flow
			— NÃO muta DLV verifications.
			(e) verificationMetrics Lote 1.6 inclui breakdown per
			Layer fail rates (Layer 1 fail rate, Layer 2 fail
			rate per class) — observabilidade real de defense in
			depth coverage.
			(f) DLV agent-spec Phase 4 explicitly declares 'no
			Layer 3 scoring' como negative-action constraint —
			guardrail cognitivo durante execution.
			(g) Limit honest no purpose + outer rationale Lote
			1.6: verified DLV NÃO é claim de verdade absoluta —
			composição de 3 layers como sistema é o claim de
			truth operacional Mesh.
			(h) Layer 2 extensibility Phase 1+ via criteriaVersion
			declaration: criteria version owns 'this version
			requires check classes [a, b, c]'; DLV engine consume
			declaration deterministicamente sem modificação core.
			"""
	}, {
		id: "bd-no-scoring-by-dlv"
		decision: """
			DLV NÃO computa scoring de NENHUMA natureza —
			supplier reliability score, fraud score, quality
			index, trust weight, anomaly probability, statistical
			aggregation sobre verifications. Boundary hard: DLV
			decide SUFICIÊNCIA por critério estruturado (binary
			verified | rejected per bd-evidence-criteria-match-
			deterministic); scoring/aggregation/probabilistic-
			modeling pertence EXCLUSIVAMENTE a REW (scoring de
			risco) e NIM (mecanismos de rede + design de
			incentivos), que consomem signals DLV e materializam
			scoring em projeções próprias.

			Lista NÃO-EXAUSTIVA de operações PROIBIDAS em DLV:
			- reliability score per supplier baseado em
			  verification history
			- fraud probability score
			- quality index numérico per commitment ou per
			  supplier
			- trust weight para uso em decision-making downstream
			- anomaly probability statistical
			- aggregate statistics em payload de Verification
			  events (events carregam fatos categóricos, não
			  estatísticas)
			- inferência probabilística sobre evidence beyond
			  deterministic Layer 1+2 checks (per bd-truth-vs-
			  integrity-defense-in-depth)

			Operações PERMITIDAS em DLV (não conflitam com BD):
			- reasonCode estruturado em rejected events
			  (categórico, não score)
			- exceptionHistory tracking (sequência de fatos, não
			  aggregation)
			- supersession lineage (estrutural, não
			  probabilístico)
			- count basic em verificationMetrics (e.g., Layer 1
			  fail rate; este é metric agregada DE OBSERVABILIDADE
			  OPERACIONAL, não signal consumido por outros BCs
			  para decision-making — distinção crítica)
			"""
		rationale: """
			Anti-mini-NIM hard line: scoring é território REW/NIM
			por subdomain mapping; misturar scoring em DLV criaria
			responsabilidade dual (verification gate + scoring
			engine) que violaria 5 propriedades estruturais:

			(a) Determinismo: scoring é statistical/probabilístico
			por natureza; misturar com gate determinístico
			(bd-evidence-criteria-match-deterministic) introduz
			non-determinism em path crítico.

			(b) Replay safety: scoring depende de aggregation
			history (verifications passadas + signals diversos);
			replay sob timeline parcial produziria scoring
			diferente — quebra bd-replay-deterministic-criteria-
			versioned.

			(c) Single-source authoritativeness: REW owns risk
			scoring per dlv subdomain mapping (mech-evidence
			downstream consumer); DLV computando scoring criaria
			dual source de truth para 'qual o score deste
			supplier' — drift garantido em escala.

			(d) Anti-mini-NIM enforcement em outros lotes
			(bd-evidence-supersession-not-choice 'não escolhe
			entre evidências'; bd-truth-vs-integrity-defense-in-
			depth 'Layer 3 é REW/NIM') depende de DLV permanecer
			função verificação, não engine de inferência.

			(e) Boundary clarity para consumidores: INV/REW/NIM/
			DRC consomem signals DLV (categóricos, factuais) sob
			contract estável; se DLV emitisse scoring, contract
			ficaria volátil (scoring evolui com data; categórico
			não) e downstream coupling cresceria.

			Distinção operacional crítica entre scoring e
			verificationMetrics: scoring é signal consumido por
			outros BCs para decision-making (e.g., REW ajusta
			crédito baseado em score); verificationMetrics são
			metrics DE OBSERVABILIDADE OPERACIONAL consumidas
			por OBS para health monitoring (e.g., Layer 1 fail
			rate sustained > threshold = alerta operacional).
			Mesma agregação numérica, semânticas opostas.

			Lista PROIBIDAS explícita evita drift: sem documentar
			explicitamente, agentes futuros podem racionalizar
			adicionar 'apenas um pequeno trust weight' que parece
			local mas viola boundary. Hard line documentada é
			guardrail cognitivo + auditável.
			"""
		consequences: """
			(a) Verification events DLV (DeliveryVerified |
			DeliveryRejected) carregam payload categórico
			estável: commitmentRef, evidenceRef, criteriaVersion,
			outcome, reasonCode (categórico aberto), decidedAt,
			finalityAt, decidedBy, supersededByRef?,
			exceptionHistory?, integrityProofRef. NENHUM campo
			numérico-statistical.
			(b) REW/NIM materializam scoring em projeções
			próprias consumindo Verification events DLV — domain-
			model próprio, contract próprio com consumidores.
			DLV NÃO tem opinião sobre como scoring é computed.
			(c) DLV agent-spec Phase 4 declara 'no scoring' como
			negative-action constraint explícita; supervisedDecision
			approve-with-scoring-override NÃO existe (caminho
			impossível por design).
			(d) Drift detection: se Verification event payload
			tentar adicionar campo numérico-statistical,
			structural-check Phase 3+ rejeita (schema constraint
			sobre payload events DLV).
			(e) Edge case 'mas REW precisa de baseline rate de
			rejection per supplier': REW computa baseline a
			partir de Verification events (DLV produz events;
			REW agrega). DLV NÃO pré-computa para conveniência
			de REW — responsabilidade limpa.
			(f) Anti-mini-NIM transversal articulado: combinado
			com bd-evidence-supersession-not-choice (não escolhe
			entre evidências) + bd-truth-vs-integrity-defense-in-
			depth (Layer 3 é REW/NIM) + bd-no-scoring-by-dlv (no
			scoring period) = 3 boundaries hard que protegem DLV
			de virar mini-REW.
			(g) Phase 1+ tension: se REW signaling demand crescer
			(e.g., REW solicita DLV pre-aggregate certain stats
			por eficiência), tension-entry materializa decision:
			separar em projection compartilhada (PLT
			infrastructure) OU manter hard line e REW absorve
			aggregation cost. Default: hard line (preserve
			boundary).
			"""
	}, {
		id: "bd-evidence-integrity-mandatory"
		decision: """
			DLV REJEITA ingestion via RecordEvidence sem
			integrityProofRef attached — operação ingestion-time
			é comando estruturado com integrityProofRef como
			CAMPO OBRIGATÓRIO, não opcional. RecordEvidence sem
			integrityProofRef → command rejected NO PARSING/
			VALIDATION layer ANTES de qualquer side effect;
			nenhum EvidenceRecord é criado, nenhum evento interno
			emitido, ingestion path retorna erro estruturado ao
			caller. Distinção crítica: este BD é sobre INGESTION-
			TIME mandate (boundary input contract); bd-truth-vs-
			integrity-defense-in-depth Layer 1 Lote 3 é sobre
			EVALUATION-TIME validation (mesma prova revalidada
			durante function); bd-ingestion-evaluation-separation
			Lote 2 estabelece a separação de concerns mas não
			especifica que integrityProofRef é mandatory
			ingestion-time. BD11 fecha o loop: integrity é hard
			requirement no boundary, não compromisso para mais
			tarde.

			Validação ingestion-time inclui:
			(a) integrityProofRef field PRESENTE e não-vazio no
			    comando RecordEvidence;
			(b) integrityProofRef format compliance (estrutura
			    DSSE-anchored; hash format válido);
			(c) integrityProofRef referencia material verificável
			    LOCALMENTE via payload DSSE completo OU snapshot
			    suficiente para validação offline; ausência de
			    material local verificável → command rejected
			    (reasonCode=integrity-proof-unverifiable-local).
			    DLV NUNCA depende de rede para aceitar ingestion
			    — local-first é precondition de cc-03 (24/7
			    determinístico).
			(d) integrity proof verification syntática (DSSE
			    envelope bem-formado; signing/payload structure).

			Validação semântica completa (full proof verification,
			signer authority, etc.) ocorre EVALUATION-TIME per
			BD9 Layer 1 — ingestion-time é parser/syntax check;
			eval-time é semantic validation.

			Sem este BD, ingestion poderia aceitar evidence sem
			proof (com promessa implícita de "validar depois") —
			cria janela onde DLV tem EvidenceRecord ingestados
			sem integrity, expostos a corruption/tampering pré-
			evaluation, e quebra anti-mini-NIM (DLV não confia
			em LOG implicitamente — exigir prova é demonstração
			operacional de não-confiança).
			"""
		rationale: """
			Anti-mini-NIM hard line no ingestion boundary: DLV
			não confia em LOG sobre integridade implícita —
			exigir integrityProofRef ingestion-time é
			demonstração operacional de "verificação local
			sempre, sem confiança implícita". Boundary contract
			explícito: LOG produz evidence com proof DSSE-
			anchored (IDC owns proof primitive); DLV ingere
			apenas evidence com proof attached. Inverter (DLV
			aceita evidence "limpa" e valida proof depois)
			inverteria boundary: DLV confiaria implicitamente
			em LOG durante a janela ingestion-to-evaluation,
			criando window de inconsistência e ataque (adversário
			injetaria evidence sem proof, DLV ingere, depois
			falha eval — mas EvidenceRecord state já existe,
			race conditions cross-aggregate possíveis).

			Distinção ingestion-time vs evaluation-time check é
			deliberada: ingestion-time é boundary input contract
			(parser/syntax), eval-time é semantic validation
			(full cryptographic verification). Separação reflete
			custo operacional: parser check é leve (campo
			presente + format); semantic check pode ser custoso
			(signer authority resolution, certificate chain).
			Ingestion path tem SLA latência inferior per BD4 —
			parser check cabe; full semantic check pertence a
			evaluation onde latência tolerada.

			Local verifiability sem network dependency é
			precondition de cc-03 24/7: se ingestion dependesse
			de IDC online resolution, network partition
			degradaria DLV; local DSSE payload completo OR
			offline-verifiable snapshot é hard contract — DLV
			ingestion path é network-independent por construção.

			Boundary clarity para LOG: LOG sabe exatamente o
			contract — evidence sem proof é unsupported em DLV
			boundary; LOG implementação não pode degradar
			silenciosamente (e.g., 'enviar agora, attach proof
			depois'). Hard contract elimina classe de
			ambiguidade operacional.
			"""
		consequences: """
			(a) Domain-model Phase 3: aggregate EvidenceRecord
			carries integrityProofRef como required field
			(constraint =~"^proof-[a-f0-9]+$" hash-anchored ou
			equivalente); aggregate cannot be constructed sem
			proof.
			(b) RecordEvidence command schema Phase 3 carries
			integrityProofRef como required field; CUE schema
			rejeita comandos sem este field por construção.
			(c) Ingestion path latency budget: parser check +
			format validation < 100ms p99 (Phase 0 baseline);
			full semantic validation moved to evaluation path
			(latency budget separado per BD4).
			(d) Boundary contract LOG↔DLV explicit: LOG events
			EvidenceRecorded carry integrityProofRef obligatório
			(Phase 0 communication Lote 1.4 schema); cross-BC
			ACL valida shape antes de DLV ingestion.
			(e) Anti-mini-NIM transversal: BD11 reforça boundary
			no ingestion-side; BD9 Layer 1 reforça boundary no
			evaluation-side; BD4 estabelece separação. Triad
			garante DLV verifica localmente em ambos pontos
			operacionais.
			(f) Failure mode operacional: RecordEvidence
			rejected retorna erro estruturado (e.g.,
			MissingIntegrityProof + retryable=true se LOG pode
			resubmeter com proof); upstream LOG pode reagir
			(retry com proof, escalation se proof não
			disponível).
			(g) Edge case audit: se RecordEvidence rejected
			sustained (rate alta), OBS metric sinaliza LOG-side
			bug ou ataque (alguém tentando bypass integrity);
			integrity-failure-at-ingestion-rate é
			verificationMetrics Lote 1.6 candidate.
			(h) Network independence Phase 0: ingestion path
			NÃO faz network calls a IDC durante RecordEvidence
			parsing; toda verificação local-first via DSSE
			payload completo no command OR offline snapshot
			cached. Network dependency Phase 1+ apenas em
			evaluation path (full semantic check), nunca em
			ingestion.
			"""
	}, {
		id: "bd-criteria-declared-upfront"
		decision: """
			Avaliação de evidência sob commitmentRef requer que
			criteria estejam DECLARADOS E ATIVOS em CMT ANTES
			da evaluation pode proceder — criteria é precondition
			TEMPORAL+ESTRUTURAL, não default nem implícito.
			Quando RecordEvidence ingerido para commitmentRef
			sem criteria active: evidence é registrada (ingestion
			succeeds per BD4 separation), mas evaluation NÃO
			pode proceder — commitment fica em estado evaluating-
			pending-criteria até criteria activation event
			materializar para o commitmentRef. Quando
			RecordEvidence ingerido após criteria activation:
			evaluation pode proceder imediatamente (sync command)
			OR via eventual policy Phase 1+ (per BD4).

			Estado evaluating-pending-criteria é INTERNO a DLV
			e NÃO publicado via events cross-BC — preserva
			contract público limpo (cap-delivery-lifecycle-
			public-events Lote 1.2 expõe apenas terminal events
			DeliveryVerified | DeliveryRejected). Exposição via
			query-surface QueryVerificationStatus apenas (Phase
			1.4) para debugging/coordenação operacional sh-01/
			sh-02 quando necessário. Downstream INV/REW/NIM/DRC
			NÃO observam estado intermediário — paralelo a
			exception-pending per BD6 (mesma política: estados
			intermediários internos; só terminal events
			públicos).

			Cache invalidation EXPLÍCITA: criteria activation é
			evento cross-BC consumed por DLV (criteriaActivation
			event de CMT — Phase 1.4 communication). DLV mantém
			prj-active-criteria projection derivada do event
			stream; evaluation consulta projection para resolver
			criteriaVersion vigente para commitmentRef. Cache
			invalidation é trigger de event explicit, NÃO timer
			implícito nem polling — preserva replay determinism
			(cache state em qualquer momento histórico é
			reconstruível via Event Log replay).

			Distinção operacional crítica:
			- bd-no-evidence-no-verified Lote 3: evidence é
			  precondition causal de verified (anti-default
			  evidence-side);
			- bd-criteria-declared-upfront: criteria é
			  precondition temporal+estrutural de evaluation
			  (anti-implicit criteria-side);
			- bd-replay-deterministic-criteria-versioned Lote 1:
			  criteria é hash-anchored snapshot imutável (CMT
			  owns lifecycle).
			Triad cobre 3 ângulos: evidence presence, criteria
			existence, criteria immutability.

			Sem criteria active, evaluation NÃO pode proceder
			via nenhum path autônomo — supervisedDecision
			approve-without-criteria NÃO existe (paralelo a BD7
			anti-default). Override via supervisedDecision
			(criteria-version-override Phase 1.5) opera apenas
			sobre criteria existentes (e.g., founder pode
			autorizar evaluation sob criteriaVersion N+1 antes
			de activation formal por urgência operacional, mas
			criteria N+1 DEVE existir em CMT).
			"""
		rationale: """
			Anti-implicit criteria — evita classe de bug onde
			evaluation procede sob 'criteria default' ou
			'criteria herdada de outro commitment' por
			inferência. Criteria declarado upfront é
			demonstração operacional de intencionalidade: cada
			commitment carrega criteria explícito que CMT
			formaliza ANTES de DLV evaluation ser possível. Sem
			este invariante, evaluation poderia proceder sob
			criteria implícito (e.g., 'criteria mais comum da
			vertical', 'criteria do commitment anterior'),
			criando ambiguidade operacional e quebrando audit
			trail (auditor não pode reconstruir 'sob qual
			criteria foi avaliado' sem inferência arbitrária).

			Cache invalidation explícita via event é decisão
			crítica: alternativa (cache TTL, polling)
			introduziria non-determinism em path crítico
			(replay sob mesma timeline produziria states
			diferentes dependendo de timing); event-driven
			cache é function determinística sobre Event Log —
			cada commit no Event Log avança cache state
			previsivelmente. Replay engine reconstrói cache
			exatamente para qualquer ponto histórico per BD3.

			Estado intermediário evaluating-pending-criteria
			INTERNO (não público cross-BC) preserva limpeza do
			contract: paralelo a exception-pending per BD6 —
			estados intermediários são detalhe operacional
			interno; só terminal events vazam para downstream.
			Esta política consistente cross-BD reduz cognitive
			load para consumers (INV/REW/NIM/DRC podem assumir
			que events recebidos são SEMPRE terminal — nunca
			intermediate).

			Boundary clarity CMT↔DLV: CMT owns criteria
			lifecycle (declaration, activation, version
			evolution); DLV consume criteria activation events
			ACL. Inverter (DLV computa criteria local)
			introduziria mini-CMT em DLV — anti-mini-NIM
			violation análoga a bd-no-scoring-by-dlv (DLV não
			computa REW domain). DLV é consumer de criteria,
			não autor.
			"""
		consequences: """
			(a) prj-active-criteria projection Phase 3: derived
			de CMT criteriaActivation events ACL; query
			interface (commitmentRef → criteriaVersion vigente
			OR null se not-yet-activated). Projection rebuild
			via Event Log replay determinístico per BD3.
			(b) Lifecycle DLV per commitmentRef Phase 0:
			{pending-evaluation (no evidence)} → {evaluating-
			pending-criteria (evidence ingested, criteria not
			active)} → {evaluating (evidence + criteria
			active)} → {verified | rejected | exception-
			pending → terminal}. evaluating-pending-criteria
			é estado intermediário operacional INTERNO; expõe
			via QueryVerificationStatus Phase 1.4 mas NÃO via
			events públicos.
			(c) supervisedDecision criteria-version-override
			Phase 1.5: opera apenas sobre criteria EXISTENTES
			em CMT; founder pode override 'criteria N+1' antes
			de activation formal mas N+1 deve existir; bd-
			criteria-declared-upfront preserved (criteria
			existe; activation timing é o que é overridden).
			(d) Race condition criteria activation late:
			evidence ingerida antes de criteria activation
			aguarda em evaluating-pending-criteria; quando
			criteriaActivation event chega, eventual policy
			Phase 1+ trigger evaluation OR sync command upstream
			pode triggerar explicitamente. Race resolved via
			cache state determinístico (event ordering canônica
			per BD5).
			(e) Anti-mini-NIM transversal: BD12 reforça boundary
			criteria-side (CMT owns); BD10 reforça boundary
			scoring-side (REW/NIM owns); BD7 reforça boundary
			evidence-side (LOG owns). 3 boundaries protege DLV
			de absorver responsabilidades adjacentes.
			(f) Replay determinism: criteria cache state em
			qualquer momento histórico = projection
			determinística sobre Event Log até offset; replay
			engine reconstrói cache identicamente.
			(g) Forensic audit: auditor pode reconstruir 'qual
			criteriaVersion era ativa para commitmentRef em
			decidedAt T' via projection replay até offset
			correspondente — propriedade verificável property-
			based test.
			(h) Public contract clean: events cross-BC nunca
			carregam evaluating-pending-criteria status —
			downstream simplifica logic (terminal events only;
			intermediate states queryable on-demand).
			"""
	}, {
		id: "bd-rejection-with-rationale"
		decision: """
			Toda DeliveryRejected emit DEVE carregar reasonCode
			estruturado (taxonomy aberta per BD1) + retryPath
			signal estrutural que orienta downstream consumer
			sobre qual ação é apropriada.

			retryPath é FUNÇÃO DETERMINÍSTICA de (reasonCode,
			criteriaVersion-context, finality-state) — NÃO
			atribuído arbitrariamente pelo executor. Mapping
			reasonCode → retryPath é tabela determinística parte
			do schema Phase 3 domain-model: cada reasonCode da
			taxonomy aberta tem retryPath canonical determinable
			bit-a-bit em qualquer replay. Exemplos:
			- reasonCode=insufficient-evidence → retryable
			  (deterministic: insufficient implica resubmissão
			  pode resolver)
			- reasonCode=integrity-failure → retryable
			  (deterministic: corrupted proof pode ser corrigida
			  via novo evidenceRef)
			- reasonCode=cross-evidence-inconsistency-{class}
			  → retryable (deterministic: inconsistency pode
			  resolver via evidence completion/correction)
			- reasonCode=post-finality-correction → non-
			  retryable (deterministic: pós-finality fecha
			  retry path normal)
			- reasonCode=drc-driven-correction → non-retryable
			  (deterministic: DRC owns dispute path)
			- reasonCode=exception-unresolved-timeout → non-
			  retryable (deterministic: timeout fail-safe é
			  terminal forçado)
			- reasonCode=exception-emergency-override (em
			  DeliveryVerified, não rejected — but listed for
			  completeness) → não aplicável (verified path)
			Nova reasonCode classes (Phase 1+ extension via
			criteria version) DEVEM declarar retryPath canonical
			no schema extension — extensibility com determinism
			preservado.

			3 valores Phase 0 (lista pode ser estendida Phase 1+
			via schema extension, additive enum):
			(a) retryable: sh-02 fornecedor pode submeter
			    evidência adicional/corrigida sob mesmo
			    commitmentRef (novo evidenceRef triggers nova
			    avaliação per BD2).
			(b) non-retryable: commitment está em estado
			    terminal irrecuperável via path normal — sh-02
			    NÃO pode simply resubmit; resolução requer
			    caminho distinto (DRC dispute; founder
			    supervisedDecision; aceitação).
			(c) exception: estado intermediário pending
			    resolução humano-in-loop OR cross-BC trigger;
			    sh-02 deve aguardar terminal transition (BD6
			    14-day timer OR escalation resolution).

			DeliveryRejected SEM reasonCode é estruturalmente
			proibido: schema rejeita event payload sem
			reasonCode (closed struct constraint Phase 3
			domain-model). DeliveryRejected SEM retryPath é
			igualmente proibido. Silent rejection (rejected sem
			rationale auditável) é anti-pattern adversarial:
			oculta diagnostic information de sh-02, REW, DRC,
			audit — quebra accountability.

			Distinção de bd-evidence-criteria-match-deterministic
			Lote 1: BD1 estabelece que reasonCode EXISTE como
			categoria estrutural; BD13 estabelece que reasonCode
			+ retryPath são MANDATORY + DETERMINISTIC +
			ACTIONABLE (semanticamente útil para downstream).
			Não é redundância — BD1 é sobre presença; BD13 é
			sobre qualidade do contract.
			"""
		rationale: """
			Anti-silent-rejection é estrutural anti-fraude
			operacional: silent rejection (rejected sem
			rationale) é vetor adversarial onde sistema age sem
			accountability — sh-02 fornecedor não sabe se
			rejeição é correção legítima OR bias adversarial OR
			bug operacional. Rationale obrigatório força
			transparência accountable: cada rejeição é
			justificada categórica e auditable.

			retryPath determinístico (não arbitrário) é
			precondition de replay-safety per BD3: replay sob
			mesma timeline DEVE produzir mesmo retryPath signal
			— se retryPath fosse atribuído arbitrariamente,
			replay produziria signals divergentes para mesma
			decisão histórica, quebrando consumer contract.
			Mapping table parte do schema é hard guarantee:
			função (reasonCode, criteriaVersion, finality-state)
			→ retryPath é pura, determinística, replay-safe.

			retryPath signal estrutural é decisão de design
			para actionable contract: alternativa (sh-02 inferir
			retry path do reasonCode) introduziria coupling
			forte entre sh-02 logic e DLV taxonomy interna;
			explicit signal desacopla — DLV publica intent
			('isto é retryable', 'não tente novamente'); sh-02
			age sem precisar decoder. Análoga a HTTP status
			code (200/400/500 carries actionable semantic além
			de message body).

			3 valores Phase 0 (retryable/non-retryable/exception)
			cobrem casos identificados; extensão Phase 1+
			possível via semantic categories adicionais (e.g.,
			'retryable-with-cooldown', 'retryable-with-evidence-
			replacement-only') sem quebrar contract existente —
			extensibility pattern análogo a Layer 2 check
			classes BD9. Adições Phase 1+ DEVEM preservar
			determinism: nova retryPath value declara mapping
			canonical de reasonCode classes que mappam a ela.

			Distinção scoring-vs-rationale: rationale é
			categorical (qual classe de fail); scoring seria
			numérica (quão grave). DLV produz rationale
			(categorical) per BD10 hard line; scoring é REW/NIM
			territory. retryPath é categorical (3 valores
			discretos), não score — preserva BD10 boundary.

			Audit Lei 12.846/SCD/CVM benefit: cada rejeição
			registrada com rationale categorical + retryPath
			determinístico + decidedAt + decidedBy é auditable
			end-to-end. Sem rationale, audit teria que inferir
			motivos — regulatorily inadequate.
			"""
		consequences: """
			(a) Verification event schema Phase 3:
			DeliveryRejected payload includes required fields
			reasonCode (string, taxonomy aberta) + retryPath
			(enum: retryable | non-retryable | exception).
			Closed struct constraint rejeita events sem ambos.
			Schema também declara mapping reasonCode →
			retryPath como tabela determinística (constraint
			cross-field).
			(b) sh-02 fornecedor consumer logic: query
			DeliveryRejected event → switch on retryPath
			(retryable → corrigir + resubmit RecordEvidence;
			non-retryable → escalation/dispute path;
			exception → await terminal transition). Logic
			explícito, não inferido.
			(c) DRC consumer logic: DeliveryRejected events com
			retryPath=non-retryable são candidate dispute
			artifacts (sh-02 contesta classification);
			retryPath=exception não disparam dispute
			imediatamente (await terminal); retryPath=retryable
			expectation é resubmission, não dispute.
			(d) verificationMetrics Lote 1.6 inclui distribution
			retryPath rate (retryable% vs non-retryable% vs
			exception%) — sustained anomaly em ratio sinaliza
			operational issue (e.g., high non-retryable rate
			sinaliza criteria evolution needed; high exception
			rate sinaliza humano capacity issue).
			(e) Phase 1+ extensibility retryPath: novos valores
			registráveis via schema extension (e.g., retryable-
			with-cooldown carries cooldownDuration); contract
			compatibility via additive enum extension (semver-
			compatible). Determinism preservado: nova value
			declara mapping canonical via schema.
			(f) Anti-fraude observable: silent-rejection rate
			sustained (esperado 0; non-zero indica bug crítico
			de schema enforcement) é verificationMetrics Lote
			1.6 candidate (paralelo a verified-without-evidence-
			or-override-attempts BD7).
			(g) Boundary preservation: DLV publica rationale +
			retryPath (categorical, factual, determinístico);
			REW/NIM aggrega/scora se aplicável (suas
			projeções, contratos próprios). DLV NÃO compute
			aggregate retry rates como signal —
			verificationMetrics são OBS metrics operacionais,
			não signals consumed downstream para decision-
			making per BD10 distinção.
			(h) Replay property-based test: ∀ replay execution
			com mesma timeline, retryPath emitted é idêntico
			— verificável via property test sobre Event Log
			replay.
			"""
	}, {
		id: "bd-atomic-emit"
		decision: """
			Emit de DLV decision (terminal verification:
			verified OR rejected) é OPERAÇÃO ATÔMICA: aggregate
			Verification state change + DeliveryVerified|
			DeliveryRejected event publication ocorrem AS-ONE
			— ambos succeed OR ambos rollback. NÃO existe
			estado parcial publicly observável onde Verification
			aggregate registrado mas event não publicado, nem
			event publicado sem aggregate registrado.

			Garantia tem três aspectos operacionais:

			(a) NO-PARTIAL-STATE: crash entre aggregate write e
			    event publish NÃO produz estado inconsistente
			    permanentemente — recovery path determinístico
			    (transactional outbox pattern OR equivalent;
			    implementação details Phase 3 domain-model)
			    converge para either ambos succeed OR ambos
			    rollback.

			(b) IDEMPOTENT-RECOVERY: recovery por crash/retry
			    preserva BD2 idempotency — atomic emit retry
			    para mesma identidade (commitmentRef,
			    evidenceRef) converge para mesmo event final
			    published, sem duplicate events visible cross-
			    BC.

			(c) NO-DUPLICATE-PUBLISH cross-BC: event publication
			    é IDEMPOTENTE do ponto de vista cross-BC: cada
			    (commitmentRef, evidenceRef) produz NO MÁXIMO
			    UM DeliveryVerified OU DeliveryRejected visível
			    externamente — retries de publish (recovery por
			    crash, outbox processor re-execution, ACL
			    retransmission) NÃO geram eventos duplicados
			    observáveis cross-BC. Cross-BC ACL deduplica
			    via eventLogOffset hash-anchored; consumers
			    (INV/REW/NIM/DRC) podem assumir at-most-once
			    observability sem implementar deduplication
			    defensivo.

			Atomicity é commitment ESTRUTURAL público:
			consumidores downstream (INV, REW, NIM, DRC) podem
			assumir que DeliveryVerified ou DeliveryRejected
			event observado IMPLICA Verification aggregate
			registrada em DLV (e portanto state queryable via
			QueryVerificationStatus / QueryEvidenceLedger Phase
			1.4). Inverso também: Verification aggregate
			registrada IMPLICA event eventually published
			(eventual consistency bounded por event delivery
			SLA Phase 0 — typically segundos, max minutos em
			retries).

			Distinção dos níveis de idempotency:
			- BD2 logical: mesma identidade (commitmentRef,
			  evidenceRef) → mesmo outcome (verified vs
			  rejected)
			- BD14 (a)+(b) operational atomic: commit + publish
			  AS-ONE; recovery determinístico
			- BD14 (c) cross-BC observability: at-most-once
			  event visible externally (deduplication via
			  eventLogOffset)
			3 propriedades distintas, complementares; juntas
			eliminam classe inteira de cross-BC consistency
			complexity.
			"""
		rationale: """
			Atomic emit é precondition do contract público com
			downstream consumers: sem atomicity, consumers
			observariam states inconsistentes (event sem
			aggregate, aggregate sem event) e teriam que
			implementar reconciliation logic complexa para
			detectar/recover — coupling forte e propenso a
			bugs. Atomic guarantee elimina classe inteira de
			cross-BC consistency complexity: consumers tratam
			events como signals confiáveis sem necessidade de
			cross-check com DLV state.

			At-most-once observability cross-BC fecha o
			contract externo: consumers não precisam
			implementar deduplication defensivo (e.g., 'já vi
			este eventLogOffset?' lookup para cada event
			recebido) — DLV+ACL garante at-most-once. Reduz
			coupling complexity downstream e elimina classe
			de bug (consumers re-processando duplicate events
			com side effects inadvertidos).

			Implementação Phase 3 typically usa transactional
			outbox pattern (aggregate write + event-to-publish
			em mesma transaction local; outbox processor
			publica eventually) OR equivalent (event sourcing
			native atomicity, saga compensation).
			Implementação details DOMAIN-MODEL territory;
			canvas estabelece o contract (atomic + at-most-
			once cross-BC), domain-model materializa o
			pattern.

			Crash recovery determinismo é crítico: recovery
			path DEVE convergir para terminal state estável
			sem decisão arbitrária runtime (ambiguidade durante
			recovery introduziria non-determinism em path
			crítico, quebrando replay). Outbox pattern resolve:
			recovery sempre processa pending outbox entries até
			completion OR explicit rollback flag.

			Eventual consistency window bounded é compromisso
			operacional aceito: alternativa (synchronous cross-
			BC commit, e.g., 2PC) introduziria coupling
			temporal forte cross-BC e degradaria liveness sob
			falha de outro BC. Eventual consistency com bounded
			SLA (segundos típicos, minutos sob retry) é trade-
			off adequado para B2B financial workflow (vs
			microsegundos required em high-frequency trading).

			Distinção idempotency vs atomicity vs cross-BC dedup:
			- BD2 cobre adversário retry: 'múltiplas chegadas
			  de mesmo comando convergem para mesmo outcome';
			- BD14 (a)+(b) cobre adversário failure: 'crash
			  mid-emit não produz estado inconsistente';
			- BD14 (c) cobre adversário publish-retry: 'cross-
			  BC observers nunca veem duplicates'.
			3 propriedades; sistema com BD2 mas sem BD14 (a)+(b)
			ainda teria estados parcial-publicly-observáveis
			durante crashes; sistema com BD14 (a)+(b) mas sem
			(c) ainda exporia consumers a duplicate events.
			"""
		consequences: """
			(a) Domain-model Phase 3 implementa atomic emit via
			transactional outbox pattern (recommended) OR
			equivalente: aggregate write + event-to-publish
			atomically commit em local transaction; outbox
			processor (background worker) publica events para
			cross-BC distribution eventually.
			(b) Recovery path determinismo: outbox processor
			retomba pending entries em ordem (FIFO ou priority-
			based per Phase 3); idempotent publish (cross-BC
			ACL deduplica via eventLogOffset). Recovery NUNCA
			cria duplicate Verification aggregates ou divergent
			events.
			(c) Cross-BC contract Phase 1.4: consumers (INV/REW/
			NIM/DRC) podem assumir 'event observed → aggregate
			queryable em DLV' sem cross-check defensivo.
			Reduz coupling complexity downstream.
			(d) Eventual consistency SLA Phase 0: target p95
			< 5s entre commit aggregate e event published cross-
			BC; p99 < 60s sob retry; sustained breach é OBS
			metric (event-publish-latency-p99) sinalizando
			operational issue.
			(e) Failure mode operacional: crash entre commit e
			publish → outbox processor recovery converge para
			publish completion; nenhum manual intervention
			required no caminho normal. Sustained outbox
			backlog sinaliza infra issue (PLT outage, network
			partition); escalation operacional separada (não
			DLV domain).
			(f) Replay determinism: replay reconstrói Event Log
			determinístico (commit aggregate + publish event
			AS-ONE means Event Log contém pares atomic);
			replay engine processa events identicamente.
			(g) Cross-BC reconciliation Phase 1+: se downstream
			consumer observa aggregate state divergente de event
			stream (improbable mas possível em edge cases),
			cross-BC reconciliation tooling (PLT
			infrastructure) detecta + alerts; DLV state é
			authoritative (consumers reconciliam para DLV).
			(h) Distinção operacional clara para consumers:
			BD2 (idempotency) tells consumers retries are safe;
			BD14 (atomicity) tells consumers events are
			reliable signals; BD14 (no-dup-publish) tells
			consumers events are at-most-once. Juntas:
			consumers não precisam de defensive cross-checking
			ou complex reconciliation logic.
			(i) Cross-BC ACL Phase 0+ implementa deduplication
			via eventLogOffset hash-anchored como idempotency
			key — at-most-once delivery semantics observável
			publicamente. Consumers não implementam dedup
			defensivo; reduz coupling complexity downstream.
			Sustained duplicate-event-rate cross-BC > 0 é OBS
			metric crítica sinalizando ACL bug ou outbox
			processor issue (Phase 0 baseline target: 0).
			"""
	}]

	// =============================================
	// COMMUNICATION — placeholder; conteúdo em commit 1.4
	// =============================================

	communication: {
		rationale: "Placeholder — communication completa (5 inbound: EvidenceRecorded LOG + CommitmentAccepted CMT + criteria activation CMT + EvidenceSuperseded LOG + verification dispute DRC; 2 outbound: DeliveryVerified + DeliveryRejected; 2 query-deps: QueryCommitmentCriteria CMT + QueryEvidenceProof IDC; 2 commands: RecordEvidence sync + EvaluateVerification sync; 2 query-surfaces: QueryVerificationStatus + QueryEvidenceLedger) entra em commit 1.4. Naming Delivery* events alinhado com bd-evidence-criteria-match-deterministic + cap-delivery-lifecycle-public-events Phase 1.2."
	}

	// =============================================
	// STAKEHOLDERS (3)
	// =============================================

	stakeholders: [{
		stakeholderRef: "sh-01"
		roleInContext: """
			Originadora consumindo verified status DLV para
			coordenar fluxo macroeconômico — orquestra
			commitment progression entre upstream BCs (P2P PO
			emission, CMT formalization) e downstream BCs (INV
			invoicing, FCE settlement) baseado em DLV terminal
			events (DeliveryVerified | DeliveryRejected). Em
			pre-PMF, sh-01 é founder ou função interna
			designada; pós-PMF, originadoras podem ser
			distribuídas por área operacional. Phase 0 modela
			como entidade única sem diferenciação interna.
			"""
		impactDescription: """
			Originadora ganha (a) gate verificável determinístico
			— verified DLV é signal canônico para INV faturar +
			FCE pagar, eliminando ambiguidade 'evidência foi
			suficiente?'; (b) audit trail Lei 12.846/SCD/CVM
			completo em cada decisão, com criteriaVersion
			snapshot + integrityProofRef + decidedAt +
			reasonCode — defensible em auditoria regulatória;
			(c) economic finality 30 dias bounded — downstream
			pode agir (INV invoice, FCE settlement) com
			confiança temporal; (d) emergency override path
			supervised para deadlock operacional sem compromisso
			anti-fraude. Risco: complexidade de governança
			(multiple override paths) requer disciplina de uso
			(per founder alerta) — abuso degradaria invariante.
			"""
		rationale: """
			sh-01 é stakeholder primário operacional —
			orquestrador do macrofluxo. DLV verified status é
			signal canônico para sh-01 coordenar progressão
			downstream; rejected/exception status é signal para
			sh-01 retry path coordination com sh-02.
			"""
	}, {
		stakeholderRef: "sh-02"
		roleInContext: """
			Fornecedor respondente cuja execução operacional é
			verificada por DLV — recebe DeliveryVerified
			(commitment progride para faturamento downstream)
			OU DeliveryRejected com reasonCode + retryPath
			signal (sh-02 conhece exatamente qual ação tomar).
			retryPath retryable: sh-02 corrige evidence e
			resubmit; non-retryable: sh-02 escala via dispute
			(DRC) ou aceita closure; exception: sh-02 aguarda
			terminal transition. Phase 0 supplier API NOT
			modeled (per oq-p2p-4 paralelo); sh-02 interaction
			reduzida a notification via NTF transversal +
			manual response.
			"""
		impactDescription: """
			Fornecedor ganha (a) determinismo no gate — função
			pura sobre evidência + criteria, sem julgamento
			arbitrário; (b) actionable rejection — retryPath
			signal indica próxima ação clara, eliminando
			ambiguidade adversarial 'por que rejeitado e o que
			fazer?'; (c) integridade ≠ verdade honest claim —
			verified emit não é claim de truth absoluta; sh-02
			sabe que Layer 1+2 deterministic + Layer 3 REW/NIM
			provê defense in depth sistêmica; (d) emergency
			override path acessível via originadora (sh-01) em
			caso de ingestion path failure sustentado, evitando
			deadlock por dependência técnica. Risco: rejected
			sustained (especialmente non-retryable) impacta
			cash flow do fornecedor — DRC dispute path é safety
			net, mas processo tem prazos próprios.
			"""
		rationale: """
			sh-02 é stakeholder secundário operacional — target
			da decisão de verification. DLV outcome afeta
			diretamente cash flow do fornecedor; actionable
			rejection (retryPath) é design crítico de UX. Phase
			0 manual; supplier API formalized Phase 1+ via
			cross-BC coordination com NPM.
			"""
	}, {
		stakeholderRef: "sh-05"
		roleInContext: """
			Operador agente DLV (agt-dlv-primary): valida
			integridade Layer 1 + Layer 2 cross-evidence
			consistency; aplica criteria match deterministic
			per criteriaVersion snapshot; emit terminal
			verifications atomicamente; gerencia exception
			states transitivos com timer 14-day; aplica
			supersession ordering canônica via eventLogOffset;
			registra exceptionHistory append-only para audit.
			Anti-mini-NIM enforced rigidamente: NÃO computa
			scoring (REW/NIM territory), NÃO escolhe entre
			evidências (LOG owns lineage), NÃO infere criteria
			(CMT owns), NÃO gera Layer 3 anomaly detection
			(REW/NIM territory). Múltiplos canais supervised
			(emergency override BD7, post-finality supersession
			BD8, criteria-version-override BD12, exception
			extension BD6) requerem disciplina de uso para
			evitar abuso de override.
			"""
		impactDescription: """
			Operador agente ganha (a) gate determinístico claro
			— Layer 1 + Layer 2 + criteria match são funções
			numéricas reproduzíveis, não julgamentos; (b)
			anti-mini-NIM hard line documentada (BD9 + BD10) —
			guardrail cognitivo durante execution, evita drift
			para responsabilidades adjacentes; (c) audit trail
			regulatory-grade end-to-end — cada decisão com
			criteriaVersion + integrityProofRef + reasonCode +
			retryPath + exceptionHistory imutáveis; (d) replay-
			safe via eventLogOffset + DLV system time —
			decisões reconstruíveis bit-a-bit em qualquer
			momento. Risco: complexidade de governança alta
			com 4 canais supervised (emergency override BD7 +
			post-finality supersession BD8 + criteria-version-
			override BD12 + exception extension BD6) exige
			envelope agent-governance Phase 5 muito bem
			amarrado para evitar abuso de canais supervised
			OR travamento operacional por medo de usar.
			Founder alerta explícito (forward-ref Phase 1.5):
			governanceScope finalize precisa materializar
			design antifrágil de uso de override.
			"""
		rationale: """
			sh-05 é stakeholder operacional crítico — executor
			das decisões DLV. Anti-mini-NIM enforcement em
			capability rationale + agent-spec (Phase 4) +
			envelope (Phase 5) é defesa em camadas contra
			drift cognitivo do agente. Múltiplos canais
			supervised exigem disciplina; founder alerta sobre
			complexidade de governança é forward-ref para
			cuidado em Phase 1.5 governanceScope finalize
			como sistema antifrágil (não só permissões, mas
			controle real de uso).
			"""
	}]

	// =============================================
	// COSTS ELIMINATED (2)
	// =============================================

	costsEliminated: [{
		costRef: "ce-01"
		contribution: """
			DLV elimina custo de transação 'verificação
			presencial repetitiva' substituindo inspeção física
			in-loco por evidência criptograficamente verificável
			(Layer 1 IDC proof + Layer 2 cross-evidence
			consistency deterministic). Auditor regulatório/
			dispute resolution DRC pode reconstruir decisão
			histórica bit-a-bit via replay determinístico (BD3)
			sem necessidade de re-inspeção física — tripla
			causal (evidenceRef, criteriaVersion,
			integrityProofSnapshot) é suficiente para reproduzir
			outcome sob critérios da época. cc-04 capability
			formaliza este atributo como audit regulatory-grade
			Lei 12.846/SCD/CVM com 5-year retention. Ce-01
			elimination é diferencial central da tese Mesh per
			dlv subdomain rationale.
			"""
		rationale: """
			Per dlv subdomain rationale: 'verificação presencial
			repetitiva substituída por evidência
			criptograficamente verificável'. DLV é o BC que
			materializa esta substituição — sem DLV como gate
			verificável, evidência cryptographic ficaria sem
			consumer determinístico, e verificação degradaria
			para julgamento manual repetitivo per commitment.
			"""
	}, {
		costRef: "ce-04"
		contribution: """
			DLV contribui para eliminação de 'custo de risco
			com dados incompletos' produzindo dados completos
			de execução verificada (Verification events com
			payload rich: criteriaVersion, integrityProofRef,
			reasonCode, retryPath, exceptionHistory,
			supersededByRef, finalityAt) que REW consome para
			scoring de risco mais preciso. Defense in depth 3
			layers (BD9) com Layer 1+2 deterministic em DLV +
			Layer 3 statistical em REW/NIM produz dataset
			complete: integridade verificada localmente,
			consistency cross-evidence, padrões anomaly
			detectáveis post-hoc. REW pode modelar credit risk
			com data completeness inalcançável em sistemas
			tradicionais (verificação manual produz dados
			sparse). cc-04 capability + cap-delivery-lifecycle-
			public-events formalizam o pipeline de signal-
			production.
			"""
		rationale: """
			Per dlv subdomain rationale: 'DLV produz dados
			completos de execução verificada que REW consome
			para scoring mais preciso'. Boundary clean (BD10
			anti-mini-NIM): DLV produz signals categóricos
			rich; REW agrega + scora. ce-04 elimination
			depende desta separação clean — REW com dados
			completos (não inferidos) produz scoring superior
			a credit bureaus tradicionais.
			"""
	}]

	// =============================================
	// INCENTIVE ANALYSIS — placeholder; conteúdo em commit 1.5
	// =============================================

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-01"
			participantType:           "Placeholder — preenchido em commit 1.5."
			desiredBehavior:           "Placeholder."
			correctOperationIncentive: "Placeholder."
			manipulationVector:        "Placeholder."
			manipulationCost:          "Placeholder."
			vsBenefit:                 "Placeholder."
			designResponse:            "Placeholder."
			rationale:                 "Skeleton; 4 vetores adversariais substantivos (forgery de evidência; premature approval por gaming critérios; withholding de evidência válida; multi-actor coordinated attack) em commit 1.5."
		}]
		rationale: "Placeholder — incentive analysis completo (4 vetores cobrindo forgery + premature approval + withholding + coordinated multi-actor) entra em commit 1.5."
	}

	// =============================================
	// OWNERSHIP — domainAgentSpec real; governanceScope em commit 1.5
	// =============================================

	ownership: {
		domainAgentSpec: "contexts/dlv/agents/dlv-primary-agent.cue"
		governanceScope: {}
		rationale:       "Skeleton commit 1.1 estabelece domainAgentSpec canônico (forward reference — agent-spec será autorado em Phase 4 do bootstrap WI-042). governanceScope completo (5 autonomousDecisions cobrindo evidence ingestion + integrity validation + criteria evaluation + verification emit + supersession; 3 supervisedDecisions cobrindo override de rejection + manual reconciliation + criteria version override; 5 escalationCriteria cobrindo integrity proof failure + criteria version mismatch + supersession contention + economic finality breach + regulatory edge) entra em commit 1.5."
	}

	// =============================================
	// RATIONALE OUTER — placeholder; conteúdo em commit 1.6
	// =============================================

	rationale: "Placeholder — rationale outer (síntese de identity + 14 businessDecisions com bd-evidence-criteria-match-deterministic RECTOR + defense in depth 3 camadas + idempotency + atomicity + supersession total ordering + economic finality window single-source + exception state transitivity 14-day; 4 lenses; Phase 0 caveats incluindo industry packs Phase 1+ + cross-BC dispute coordination DRC) entra em commit 1.6."
}
