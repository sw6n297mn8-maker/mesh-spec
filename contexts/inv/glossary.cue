package inv

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// glossary.cue — Ubiquitous Language: Invoicing.
// Instância de #Glossary (architecture/artifact-schemas/glossary.cue).
//
// Glossário do BC INV (Invoicing) — 9º BC bootstrap pós WI-042 DLV
// closure; único BC em interseção Wave 0 + adjacência DLV no
// context-map. Materializa Ubiquitous Language pos-canvas Phase 1
// (commits 6412f85..e377a1e): 10 BDs + 4 autonomousDecisions + 1
// supervisedDecision + 7 escalationCriteria + 6 verificationMetrics.
//
// Phase 2 incremental por Layer per founder orientation (escreve +
// valida + escala). Layer 1 (CORE — este commit): 6 termos
// fundacionais cobrindo identidade + processos + inputs canônicos.
// Layers 2-4 (FLOW events + GOVERNANCE + EDGE) em commits
// subsequentes pos-validation.
//
// Glossary = sistema de controle semântico, NÃO dicionário. Cada
// termo defende boundary específico que emergiu em BDs:
//   anti-mini-FCE (instrução pagamento; cobrança ativa)
//   anti-mini-SCF (instrumento negociável; pricing/elegibilidade)
//   anti-mini-ATO (lógica fiscal interpretativa; estorno; regra)
//   anti-mini-REW (score; risco)
//   anti-orchestrator (coordenação de downstream)
//   anti-runtime-coupling (sync query; snapshot histórico)
//
// Frase canônica do BC: 'INV aplica regras fiscais, não interpreta —
// transforma DeliveryVerified em obrigação fiscal e direito creditório
// determinísticamente'.

glossary: artifact_schemas.#Glossary & {
	code:              "inv"
	name:              "Invoicing"
	boundedContextRef: "inv"

	terms: [
		// ============================================================
		// LAYER 1 — CORE (6 termos fundacionais)
		// ============================================================

		{
			code:   "term-invoice"
			name:   "Fatura"
			termEn: "Invoice"
			category: "entity"
			definition: """
				Documento fiscal canônico que materializa obrigação de
				faturamento de uma DeliveryVerified status=approved sob
				identity (commitmentRef, evidenceRef). Não existe invoice
				válida fora desta tupla — identity é canônica e única.
				Lifecycle determinístico de 2 estados (issued |
				cancelled); imutável pós-emit exceto via cancellation
				explícita dentro de janela fiscal regulada.
				"""
			antiTerms: [{
				term: "instrução de pagamento"
				clarification: "Invoice é documento fiscal vinculado a entrega verificada; instrução de pagamento (when/how/to-whom-pay) é decisão FCE separada"
			}, {
				term: "ativo financeiro negociável"
				clarification: "Invoice estabelece obrigação fiscal; ativo financeiro transferível para antecipação é Receivable (term-receivable separate). SCF opera sobre Receivable, não diretamente sobre Invoice"
			}]
			relatedTerms: ["term-receivable", "term-invoice-issuance-process", "term-invoice-cancellation-process"]
			rationale: "Termo canônico central INV. Identity (commitmentRef, evidenceRef) é declarada explicitamente para proteger contra duplicação semântica e variações de identidade (anti-pattern clássico: agente usar invoiceId como primário). Disambiguação anti-mini-FCE e anti-mini-SCF: invoice é registro fiscal, não instrução financeira nem instrumento negociável. Invariante operacional: invoice nasce ATOMIC com ReceivableMaterialized via primitive infra (BD7)."
		},

		{
			code:   "term-receivable"
			name:   "Recebível"
			termEn: "Receivable"
			category: "entity"
			definition: """
				Direito creditório passível de transferência, materializado
				atomicamente com Invoice via primitive de infraestrutura.
				amount idêntico ao Invoice por construção (BD7 conservation
				amount). Identity (receivableId, invoiceId, commitmentRef)
				permite SCF originar produtos financeiros sobre lastro
				verificado.
				"""
			antiTerms: [{
				term: "instrumento financeiro com pricing"
				clarification: "Receivable em INV é lastro verificável; pricing/score/eligibility para antecipação é decisão SCF/REW. INV não atribui valor financeiro — atribui amount = invoice.amount"
			}, {
				term: "ativo de tesouraria"
				clarification: "Receivable é direito creditório no momento de emit; gestão de tesouraria (TCM) projeta cashflow sobre Receivables, não os origina"
			}]
			relatedTerms: ["term-invoice", "term-invoice-issuance-process"]
			rationale: "Materializa direito creditório como evento separado de Invoice para preservar contract independence: SCF consome ReceivableMaterialized sem acoplar-se a fiscalDocRef/regimeVersion (concerns INV/ATO). INV não determina transferibilidade nem condições de cessão; apenas materializa o direito creditório. SCF decide se, como e sob quais condições ocorre a transferência. Conservação amount via mesma fonte computacional impede divergência fatura↔recebível."
		},

		{
			code:   "term-invoice-issuance-process"
			name:   "Emissão"
			termEn: "Issuance"
			category: "process"
			definition: """
				Operação determinística que produz InvoiceIssued +
				ReceivableMaterialized atomic-emit, triggered por consumo
				de DeliveryVerified status=approved + commitmentTerms
				projection consistente. Função pura: amount =
				f(commitmentTerms, verificationOutcome=approved).
				Replay-safe via identity (commitmentRef, evidenceRef).
				"""
			antiTerms: [{
				term: "preparação de documento"
				clarification: "Issuance é evento atômico (commit + publish AS-ONE), não preparação/draft. Estado draft NÃO existe no domínio (BD5)"
			}, {
				term: "coordenação de downstream"
				clarification: "Issuance NÃO coordena ações em FCE, SCF ou ATO. Eventos emitidos são consumidos independentemente. Qualquer coordenação seria responsabilidade de outro BC (anti-orchestrator BD10)"
			}]
			relatedTerms: ["term-invoice", "term-receivable", "term-commitment-terms-projection", "term-fiscal-regime"]
			rationale: "Evento canônico que materializa transformação 'execução verificada → obrigação fiscal'. Determinismo é precondition de cc-03 24/7 + cc-04 audit reproducible. Sem issuance canônica, todo o downstream (FCE settle, SCF originate, ATO book) perde lastro. Anti-orchestrator antiTerm reflete BD10 semanticamente — emit não é coordenação."
		},

		{
			code:   "term-invoice-cancellation-process"
			name:   "Cancelamento"
			termEn: "Cancellation"
			category: "process"
			definition: """
				Operação determinística que emite InvoiceCancelled APENAS
				dentro de janela fiscal regulada (e.g., SEFAZ ≤24h regime
				brasileiro). Gate categórico within-window sim/não.
				Sempre evento explícito — sem soft-delete, sem overwrite,
				sem re-emissão silenciosa (G3).
				"""
			antiTerms: [{
				term: "estorno"
				clarification: "Estorno é operação contábil ATO posterior; cancellation INV é mutação fiscal dentro de janela regulada (não compensa contabilmente)"
			}, {
				term: "anulação retroativa"
				clarification: "Cancellation INV opera apenas within-window; retroatividade fora janela é DRC scope. INV não muta invoices históricas (BD2 imutabilidade)"
			}]
			relatedTerms: ["term-invoice"]
			rationale: "Único path INV-owned de mutação pós-issued, com escopo regulamentado (janela fiscal). Fora-da-janela escala para DRC/ATO via supervisedDecision. Cancellation é evento separado de issuance — preserva audit trail explícito + contract claro para FCE (cancel pre-settle) e ATO (estornar)."
		},

		{
			code:   "term-fiscal-regime"
			name:   "Regime Fiscal"
			termEn: "Fiscal Regime"
			category: "value"
			definition: """
				Conjunto de regras tributárias jurisdicionais (e.g., NF-e
				+ ICMS + ISS + retenções no regime brasileiro; VAT no
				regime EU) versionadas via regimeVersion explícito. Input
				read-only consumido pelo INV durante issuance — INV aplica
				regras declarativas (CFOP + alíquotas + retenções) sem
				interpretação.
				"""
			antiTerms: [{
				term: "lógica fiscal customizada"
				clarification: "Regime é INPUT externo (legislação tributária); lógica customizada de aplicação seria mini-ATO. INV NÃO interpreta regime — aplica tabela declarativa"
			}, {
				term: "decisão de enquadramento tributário"
				clarification: "Decisão de enquadramento (qual regime se aplica a este commitment) é resolved fora do INV (CTR ou external). INV consome regimeVersion já resolvido"
			}]
			relatedTerms: ["term-invoice-issuance-process"]
			rationale: "Boundary protector anti-mini-ATO. Regime fiscal é input declarativo externo, não lógica interna do BC — protege contra config-virando-lógica que transformaria INV em interpretador fiscal. Imutabilidade pós-emit per regimeVersion garante audit reproducibility indefinida."
		},

		{
			code:   "term-commitment-terms-projection"
			name:   "Projeção de Termos do Compromisso"
			termEn: "Commitment Terms Projection"
			category: "value"
			definition: """
				Representação local derivada de eventos CommitmentAccepted
				consumidos do CMT via cmt-to-inv, esperada ser consistente
				com o estado canônico CMT mas sujeita a atraso (eventual
				consistency). Contém commitmentTerms (amount, currency,
				dueDate, parties, taxRegimeRef) read-only. Ausência,
				incompletude OU staleness bloqueiam emissão (BD4 freshness
				gate).
				"""
			antiTerms: [{
				term: "estimativa"
				clarification: "Projection é representação derivada de fatos consumidos (CommitmentAccepted), não inferência ou aproximação. Ausência ou staleness bloqueiam emit (no fallback heurístico)"
			}, {
				term: "query síncrona ao CMT"
				clarification: "INV NÃO faz sync query no caminho crítico (hasSyncSurface=false); projection é cache async via event-consumer. Sync coupling violaria replay independence"
			}]
			relatedTerms: ["term-invoice-issuance-process"]
			rationale: "Mecanismo canônico que viabiliza determinismo + replay independence sem sync coupling cross-BC. Eventual consistency é propriedade aceita do sistema (não negada); BD4 trata atraso como ausência (emit blocked) e staleness como inconsistência ativa (HARD escalation). Diferenciação operacional crítica missing-vs-stale: missing triggera retry-first (esc-projection-missing) vs stale triggera HARD escalation (esc-projection-stale)."
		},

		// ============================================================
		// LAYER 2 — INTERFACE (3 events: contratos semânticos públicos
		// da rede consumidos cross-BC)
		// ============================================================

		{
			code:   "term-invoice-issued"
			name:   "Fatura Emitida"
			termEn: "InvoiceIssued"
			category: "event"
			definition: """
				Evento canônico que declara o nascimento de uma Invoice
				com identidade (commitmentRef, evidenceRef) e atributos
				fiscais mínimos necessários para consumo downstream.
				Estrutura exata do payload é definida em contracts/event
				schemas (Phase 3 domain-model + AsyncAPI Phase 1+), não
				neste glossary. Evento é APPEND-ONLY no event log;
				INV não muta nem re-emite. Contrato semântico público da
				rede consumido por FCE (settle) e ATO (book — pattern
				conformist).
				"""
			antiTerms: [{
				term: "comando de emissão"
				clarification: "InvoiceIssued é fact-record passivo (passou); não é trigger ativo de comando para downstream. Consumers reagem ao fato per próprias políticas, não recebem ordem"
			}, {
				term: "instrução de pagamento"
				clarification: "Event declara que fatura nasceu; quando/como/quanto-pagar é decisão FCE separada. InvoiceIssued NÃO carrega paymentMethod, paymentSchedule, accountRef"
			}]
			relatedTerms: ["term-invoice", "term-invoice-issuance-process", "term-receivable-materialized"]
			rationale: "Contrato semântico público da rede Mesh — INV declara obrigação fiscal nascida; FCE/ATO consomem independentemente per próprias políticas. Glossary define SIGNIFICADO do evento (fact-record passivo, contrato fiscal); shape do payload é responsabilidade de schemas separados (separação de concerns: glossary = semantic contract; schemas = wire-level structure). Append-only é invariante operacional: cancellation gera evento separado (term-invoice-cancelled), nunca mutação retroativa."
		},

		{
			code:   "term-receivable-materialized"
			name:   "Recebível Materializado"
			termEn: "ReceivableMaterialized"
			category: "event"
			definition: """
				Evento canônico que declara o nascimento de um Receivable
				atomicamente com InvoiceIssued (mesma transação, primitive
				infra). Materialização ocorre SEMPRE que Invoice é emitida —
				não depende de elegibilidade, scoring ou decisão financeira
				externa. Identity (receivableId, invoiceId, commitmentRef)
				com amount idêntico ao Invoice (BD7 conservation). Contrato
				semântico público da rede consumido por SCF para originar
				produtos financeiros sobre lastro verificado.
				"""
			antiTerms: [{
				term: "ativo financeiro disponível para cessão"
				clarification: "Event materializa o DIREITO creditório como fato; transferibilidade real, condições de cessão e pricing são decisões SCF/REW posteriores e independentes"
			}, {
				term: "garantia de antecipação"
				clarification: "Event NÃO promete que antecipação acontecerá; SCF decide elegibilidade autonomamente per próprias políticas. INV emite SEMPRE que invoice é issued (sem filtro de elegibilidade)"
			}]
			relatedTerms: ["term-receivable", "term-invoice-issuance-process", "term-invoice-issued"]
			rationale: "Contrato semântico público para SCF. Separação de InvoiceIssued (BD7 dual emission atomic) preserva contract independence — SCF liga em ReceivableMaterialized sem acoplar-se a fiscalDocRef/regimeVersion (concerns INV/ATO). Conservação amount via mesma fonte computacional impede divergência fatura↔recebível por construção. 'SEMPRE materializa' explícito na definição reforça anti-acoplamento com SCF/REW: filtragem por elegibilidade é decisão SCF posterior, nunca gate em INV."
		},

		{
			code:   "term-invoice-cancelled"
			name:   "Fatura Cancelada"
			termEn: "InvoiceCancelled"
			category: "event"
			definition: """
				Evento canônico explícito de cancellation INV-owned dentro
				de janela fiscal regulada. Identity invoiceId +
				fiscalCancellationRef + reasonCode + cancelledAt.
				APPEND-ONLY no event log. Contrato semântico público da
				rede; consumo downstream é contextual:
				- FCE: pode ignorar pós-settle (correção é DRC scope)
				- ATO: sempre relevante (estornar lançamento fiscal)
				- Outros BCs: decidem conforme própria responsabilidade
				"""
			antiTerms: [{
				term: "estorno contábil"
				clarification: "Event é cancellation FISCAL (mutação documento dentro de janela regulada); estorno contábil é operação ATO posterior, triggered pelo consumo deste event mas executada autonomamente em ATO scope"
			}, {
				term: "soft delete da fatura"
				clarification: "Event é fato explícito append-only no event log (G3); InvoiceIssued original PERMANECE no log com lineage completo apontando para InvoiceCancelled. Nada é apagado — tudo é fact-record"
			}]
			relatedTerms: ["term-invoice", "term-invoice-cancellation-process", "term-invoice-issued"]
			rationale: "G3 cancellation explicit-event-only materializado como contrato semântico público. Downstream BCs reconstroem lifecycle completo via event log canônico (InvoiceIssued + InvoiceCancelled paired); sem inferência sobre estado interno INV. Consumo contextual reflete realidade operacional: FCE ignora pós-settle por design (correção é DRC), MAS ATO sempre processa (estorno fiscal independente de timing settlement). Event NÃO é 'irrelevante pós-settle' globalmente — é irrelevante apenas para FCE specific; outros BCs mantêm relevância."
		},

		// ============================================================
		// LAYER 3 — MECHANISMS (4 termos: invariantes estruturais +
		// boundary protectors)
		// ============================================================

		{
			code:   "term-atomic-dual-emission"
			name:   "Emissão Dupla Atômica"
			termEn: "Atomic Dual Emission"
			category: "rule"
			definition: """
				Garantia estrutural de que InvoiceIssued e
				ReceivableMaterialized são tratados como uma única unidade
				indivisível: ambos existem ou nenhum existe. Não há estado
				observável onde apenas um dos dois foi gerado. Violação
				seria qualquer inconsistência observável entre os dois
				eventos — invoice sem receivable correspondente, receivable
				sem invoice precedente, OR amount divergente entre ambos.
				"""
			antiTerms: [{
				term: "saga pattern"
				clarification: "Saga é coordenação multi-step com compensation posterior; atomic-dual-emission garante AUSÊNCIA de estado intermediário observável — não há step parcial nem compensation step"
			}, {
				term: "best-effort emission"
				clarification: "Best-effort permite estado parcial observável (um evento agora, outro depois); atomic-dual-emission proíbe esse estado por construção — resultado é binário (ambos OR nenhum)"
			}]
			relatedTerms: ["term-invoice-issued", "term-receivable-materialized", "term-invoice-issuance-process"]
			rationale: "Materializa BD7 atomic-dual-emission como invariante estrutural de domínio. Protege contra divergência fatura↔recebível que quebraria lastro SCF (recebível materializado sem fatura válida) + contabilidade ATO (lançamento incompleto). Indivisibilidade lógica é propriedade do domínio (declared como contract); mecanismo de garantia é responsabilidade da infraestrutura (fora do escopo do domínio)."
		},

		{
			code:   "term-idempotency-identity"
			name:   "Identidade de Idempotência"
			termEn: "Idempotency Identity"
			category: "rule"
			definition: """
				Tupla (commitmentRef, evidenceRef) que define unicidade
				canônica de Invoice no domínio INV — mesma realidade fiscal
				verificada gera uma e só uma invoice. Identity independe
				de tempo, ordem de processamento ou número de tentativas:
				múltiplas observações da tupla (replay, partição, multi-log
				ingestion, reorder) são reconhecidas como repetição da
				MESMA realidade, NÃO criação de nova invoice. Identity
				NÃO inclui criteriaVersion nem regimeVersion (são
				attributes do fato, não componentes de unicidade). Violação
				seria duas invoices distintas sob mesma tupla, OR identity
				dependendo de versions (quebraria replay safety
				pós-version-bump).
				"""
			antiTerms: [{
				term: "chave técnica de banco de dados"
				clarification: "Identity é condição semântica de unicidade do fato no domínio (mesma realidade fiscal verificada); chave de banco é detalhe de persistência. Identity sobrevive a mudança de tecnologia"
			}, {
				term: "retry-key"
				clarification: "Retry-key é mecanismo de implementação client-side; idempotency-identity é propriedade do domínio (mesma tupla = mesmo fato), independente de quem tenta emit ou quantas vezes"
			}]
			relatedTerms: ["term-invoice", "term-invoice-issuance-process"]
			rationale: "Materializa BD3 issuance-idempotent como invariante estrutural. Identity como condição de unicidade do fato (não chave técnica) + independência de tempo/ordem/tentativas é precondition de replay determinístico + cross-BC dedup at-most-once + tolerância a reorder/concorrência. Exclusão de criteriaVersion/regimeVersion preserva replay safety: mesma tupla sob nova versão de regra é repetição do mesmo fato (não nova invoice); mudança de regra aplica a verifications futuras via nova evidenceRef."
		},

		{
			code:   "term-regime-version"
			name:   "Versão de Regime Fiscal"
			termEn: "Regime Version"
			category: "value"
			definition: """
				Identificador imutável de versão das regras fiscais
				externas (CFOP, alíquotas, retenções jurisdicionais)
				aplicadas no momento da issuance. Atributo do Invoice
				declarando QUAL versão de regime estava vigente; INV
				consome o identifier resolvido externamente, NÃO o resolve
				nem o interpreta. Bump de version é evento upstream
				(publication regulatória + ADR); aplica-se a invoices
				geradas após sua ativação upstream, nunca a invoices
				históricas. Violação seria silent regime mutation (mudar
				versão sem novo identifier), aplicar versão diferente da
				declarada, OR INV calculando/inferindo regime.
				"""
			antiTerms: [{
				term: "regra fiscal interpretada"
				clarification: "RegimeVersion é apenas IDENTIFICADOR; interpretação fiscal é mini-ATO proibido (BD2). INV consome regime resolvido como input read-only; mudança requer ADR + bump explícito"
			}, {
				term: "versão de schema fiscal interno INV"
				clarification: "RegimeVersion refere-se a regras EXTERNAS jurisdicionais (legislação tributária); não é versão de schema do INV — é dependência externa cuja autoridade é regulação fiscal vigente"
			}]
			relatedTerms: ["term-fiscal-regime", "term-invoice"]
			rationale: "Materializa BD2 deterministic-fiscal-projection como boundary protector explícito anti-mini-ATO. RegimeVersion é IDENTIFIER, não logic — protege contra config-virando-lógica que transformaria INV em interpretador fiscal. Imutabilidade pós-emit per regimeVersion garante audit reproducibility indefinida (forensic fiscal Phase 5+ pode reproduzir bit-a-bit qualquer invoice sob regimeVersion declarada)."
		},

		{
			code:   "term-fiscal-document-reference"
			name:   "Referência de Documento Fiscal"
			termEn: "Fiscal Document Reference"
			category: "value"
			definition: """
				Referência canônica para identificador de documento fiscal
				externo (e.g., NF-e number + chave de acesso no regime
				brasileiro; equivalentes em outros regimes jurisdicionais).
				Liga o Invoice INV ao documento fiscal autoritativo na
				jurisdição correspondente. É reference (ponte semântica),
				NÃO integração — INV declara o identifier; emissão técnica
				do documento na autoridade fiscal é responsabilidade de
				adapter externo (Phase 1+ forward-ref, fora do boundary
				INV). Uma vez associado a uma invoice, nunca é alterado
				nem substituído. Violação seria tratar reference como
				pipeline de integração, assumir INV emite documento na
				autoridade, OR alterar/substituir reference pós-association.
				"""
			antiTerms: [{
				term: "integração SEFAZ"
				clarification: "fiscal-document-reference é ponte semântica (identifier canônico); integração técnica com autoridade fiscal (SEFAZ no BR) é adapter externo Phase 1+ — fora do boundary INV. INV declara o reference, adapter materializa o documento"
			}, {
				term: "URL de download"
				clarification: "Reference é identifier no formato canônico do regime (e.g., chave de acesso NF-e 44 dígitos); NÃO endpoint técnico. Resolução de URL ou download são concerns de infraestrutura"
			}]
			relatedTerms: ["term-invoice", "term-fiscal-regime"]
			rationale: "Materializa cc-04 audit trail regulatory-grade como ponte canônica entre Invoice INV e documento fiscal autoritativo externo. Reference (não integração) protege contra escopo creep — emissão técnica é adapter Phase 1+, INV permanece focado em declaração canônica. Imutabilidade absoluta pós-association (nunca alterado nem substituído) garante audit reproducibility e satisfaz retention legal regulatória (≥5 anos NF-e)."
		},
	]

	rationale: """
		Glossary materializa 13 termos canônicos em 3 layers (Phase 2
		incremental per founder orientation 'escreve + valida + escala').
		Firewall semântico contra drift de agente, drift humano, e drift
		cross-BC. Cada termo cobre boundary específica emergente em BDs.

		**Layer 1 — CORE (6 termos fundacionais)**:

		*Identidade canônica* (term-invoice + term-receivable): BD7 atomic
		dual emission + BD3 idempotency identity (commitmentRef,
		evidenceRef). Identity declarada explicitamente em term-invoice
		protege contra anti-pattern clássico (usar invoiceId como
		primário). Receivable como entity separate de Invoice protege
		anti-mini-SCF (transferibilidade decidida por SCF, não INV).

		*Processos canônicos* (term-invoice-issuance-process +
		term-invoice-cancellation-process): BD2 + BD5 + BD10 + G3.
		Naming explícito '-process' distingue da Layer 2 events — process
		é operação INV-internal; event é fact-record público pós-process.

		*Inputs canônicos* (term-fiscal-regime + term-commitment-terms-
		projection): BD2 apply-only + BD4 freshness gate. Boundary
		anti-mini-ATO + anti-runtime-coupling.

		**Layer 2 — INTERFACE (3 events: contratos semânticos públicos
		da rede)**:

		Per founder orientation 'INV está no centro do fluxo econômico
		— eventos são linguagem pública da rede'. 3 events declarados
		como termos canônicos por serem consumidos cross-BC (regra: se
		outro BC consome → glossary term): term-invoice-issued (FCE+ATO),
		term-receivable-materialized (SCF), term-invoice-cancelled
		(FCE+ATO contextual consumption). Glossary define SIGNIFICADO;
		shape do payload é responsabilidade de schemas separados (Phase
		3 domain-model + AsyncAPI Phase 1+).

		**Layer 3 — MECHANISMS (4 termos: invariantes estruturais +
		boundary protectors)**:

		*Bloco 1 — Consistência interna* (term-atomic-dual-emission +
		term-idempotency-identity): garantem que o sistema não se
		contradiz. Atomic-dual-emission garante indivisibilidade lógica
		entre Invoice e Receivable (BD7); Idempotency-identity garante
		unicidade do fato no domínio independente de tempo/ordem/
		tentativas (BD3). Ambos declarados como propriedades do
		domínio; mecanismos de garantia são responsabilidade da
		infraestrutura (fora do escopo do glossary).

		*Bloco 2 — Boundary externo* (term-regime-version +
		term-fiscal-document-reference): garantem que o sistema não
		invade outros domínios. Regime-version protege anti-mini-ATO
		(IDENTIFIER, não logic — INV não interpreta regime; BD2);
		Fiscal-document-reference protege anti-escopo-creep
		(ponte semântica, não integração; cc-04 audit trail).

		**Insight arquitetural** (cumulativo Layers 1-3):
		(1) Fiscal contract (InvoiceIssued + InvoiceCancelled →
		    ATO consumption);
		(2) Financial substrate contract (ReceivableMaterialized →
		    SCF consumption);
		(3) Consistência interna (atomic + idempotent);
		(4) Boundary externo (regime-version + fiscal-doc-reference).

		**Layer 4 (PENDENTE Phase 2 incremental)**: edge concepts
		(staleness, freshness, replay window) — conceitos que NÃO são
		regras operacionais (per founder warning Layer 4 = conceitos
		edge, NÃO escalation/halt/observability/monitoring). Próximo
		commit aguarda founder Layer 4 anti-pattern map antes de
		propose para evitar mistura glossary com governance.

		Glossário não evolui sem causa real per founder orientation
		(over-refinement risk): próxima evolução só acontece se surgir
		ambiguidade operacional, conflito semântico cross-BC, OR termo
		impossível de usar operacionalmente.
		"""
}
