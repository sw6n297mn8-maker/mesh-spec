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
	}]

	// =============================================
	// COMMUNICATION — placeholder; conteúdo em commit 1.4
	// =============================================

	communication: {
		rationale: "Placeholder — communication completa (5 inbound: EvidenceRecorded LOG + CommitmentAccepted CMT + criteria activation CMT + EvidenceSuperseded LOG + verification dispute DRC; 2 outbound: DeliveryVerified + DeliveryRejected; 2 query-deps: QueryCommitmentCriteria CMT + QueryEvidenceProof IDC; 2 commands: RecordEvidence sync + EvaluateVerification sync; 2 query-surfaces: QueryVerificationStatus + QueryEvidenceLedger) entra em commit 1.4. Naming Delivery* events alinhado com bd-evidence-criteria-match-deterministic + cap-delivery-lifecycle-public-events Phase 1.2."
	}

	// =============================================
	// STAKEHOLDERS — placeholder; conteúdo em commit 1.3
	// =============================================

	stakeholders: [{
		stakeholderRef:    "sh-01"
		roleInContext:     "Placeholder — completado em commit 1.3."
		impactDescription: "Placeholder — completado em commit 1.3."
		rationale:         "Skeleton stakeholder; 3 stakeholders substantivos (sh-01 originadora consumindo verified status para coordenar fluxo; sh-02 fornecedor consumindo verification outcome com retry path; sh-05 operador agente DLV) em commit 1.3."
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
