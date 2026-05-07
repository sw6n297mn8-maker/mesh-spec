package inv

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-types:shared_types"
)

// inv-canvas — Bounded Context Canvas para Invoicing.
// Instância de #Canvas (architecture/artifact-schemas/canvas.cue).
//
// INV materializa Wave 0 commitment-lifecycle Phase Invoicing —
// ponto onde execução verificada é formalizada como obrigação de
// faturamento e direito creditório transferível. Boundary core
// anti-mini-ATO: INV aplica regras fiscais, não as interpreta.
//
// Phases incrementais por section per manualAuthoringProtocol
// (adr-057). Phase 1.1 (commit anterior): identity-and-purpose.
// Phase 1.2 (este commit): strategic-classification + correção
// convenção package/variable.

canvas: artifact_schemas.#Canvas & {

	code: "inv"
	name: "Invoicing"

	purpose: """
		Materializar obrigação de faturamento (InvoiceIssued) e o
		direito creditório associado (ReceivableMaterialized) a partir
		de DeliveryVerified (DLV terminal=approved), aplicando regime
		fiscal regulado de forma determinística.

		Existe como BC SEPARADO de DLV, FCE, ATO e SCF porque a
		linguagem fiscal de faturamento (NF-e, CFOP, alíquotas,
		retenções) tem regulação tributária própria, cadência distinta
		e profissionais distintos da verificação operacional (DLV),
		execução financeira (FCE), contabilidade fiscal (ATO) e
		originação de produtos sobre recebíveis (SCF). Sem INV como
		unidade canônica, o momento em que a execução verificada é
		formalizada como obrigação de faturamento e direito creditório
		ficaria entre DLV (que verifica mas não fatura) e ATO (que
		contabiliza mas não materializa) — sem owner explícito.

		INV é estritamente projeção determinística: aplica regras
		fiscais sobre commitment terms verificados, sem decisão
		econômica, sem interpretação operacional e sem qualquer forma
		de otimização ou priorização de fluxo financeiro. Boundary
		core anti-mini-ATO: INV aplica, não interpreta — regime fiscal
		e enquadramento tributário são resolvidos fora do INV e
		consumidos como input read-only.
		"""

	ubiquitousLanguageRef: "contexts/inv/glossary.cue"

	classification: {
		subdomainType:    "supporting"
		businessRole:     "operational-enabler"
		wardleyEvolution: "product"
		rationale: """
			Supporting porque faturamento e materialização do recebível
			são regulados por regime fiscal externo (legislação tributária,
			tabelas CFOP, regras de retenção) — aplicação determinística
			de regras públicas, sem espaço para diferenciação competitiva
			da Mesh. A vantagem competitiva está em DLV (provar execução)
			e em SCF/REW (transformar recebível verificado em produtos
			financeiros); INV é o passo regulado e necessário entre os
			dois, não onde a tese ganha. operational-enabler porque INV
			viabiliza a transição de execução verificada para fluxo
			financeiro (alimentando FCE, ATO, SCF) — não é gate de
			bloqueio (compliance-enforcer) nem fonte direta de receita
			(revenue-generator). Wardley product: faturamento eletrônico
			é prática estabelecida no Brasil há ~15 anos (NF-e v1.0 em
			2006), evolui por mudança regulatória externa, não por
			inovação interna.
			"""
	}

	verticalApplicability: shared_types.#VerticalApplicability & {
		mode: "vertical-agnostic"
		rationale: """
			Boundary INV é horizontal por natureza — regime fiscal é
			input jurisdicional vertical, não estrutura do BC. O engine
			(aplicar regime + materializar InvoiceIssued +
			ReceivableMaterialized) opera sobre primitivas universais
			(commitment terms, verification outcome, regime config);
			regimes concretos (NF-e Brasil, VAT EU, GST APAC) entram
			como configuração read-only sem alterar a estrutura do BC.
			Regime fiscal é tratado como configuração declarativa
			externa, não como lógica interna do BC — proteção crítica
			contra config-virando-lógica que transformaria INV em
			mini-ATO. Paralelo P2P/SSC/DLV: mecanismos do BC são
			genéricos, regimes/critérios são externos.
			"""
	}

	domainRoles: {
		primary: "gateway"
		secondary: ["execution"]
		rationale: """
			Primary gateway: INV é a transição canônica entre operação
			verificada (DLV terminal=approved) e materialização fiscal
			e projeção em obrigação de faturamento (InvoiceIssued para
			FCE/ATO) e direito creditório (ReceivableMaterialized para
			SCF) — paralelo BDG (gateway approval), DLV (gateway
			verification), NPM/P2P/SSC (gateway de suas respectivas
			fases). Secondary execution: INV executa cômputo fiscal
			determinístico (apply-only), sem interpretar regime, sem
			decidir enquadramento e sem alterar valor — CFOP +
			alíquotas + retenções resolvidos por regime read-only; não
			é analysis (não interpreta), não é draft (não propõe), não
			é specification (não define regras).
			"""
	}

	capabilities: {
		operational: [{
			capabilityRef: "cc-03"
			description: """
				Operação 24/7 via gate determinístico de emissão:
				InvoiceIssued + ReceivableMaterialized atomic emit
				triggered por consumo de DeliveryVerified (DLV
				terminal=approved); sem janelas de aprovação humana no
				caminho normal. Gate é função categórica (verification
				approved sim/não → fatura nasce sim/não), não
				julgamento. Cancelamento dentro de janela fiscal segue
				mesmo padrão: gate categórico (within-window sim/não),
				sem interpretação.
				"""
			rationale: """
				Capability matches cc-03 do domain-definition (24/7
				disponibilidade); INV-specific aspect: emission gate é
				deterministic (verification approved sim/não), não
				exige reasoning sobre payload. Paralelo P2P (authority
				gate deterministic) e DLV (criteria match function
				pura). Cancelamento fora-da-janela é supervisedDecision
				separado, não orchestration.
				"""
		}, {
			capabilityRef: "cc-04"
			description: """
				Auditoria contínua e regulatory-grade de invoices
				emitidas: cada InvoiceIssued carrega imutavelmente
				(commitmentRef, evidenceRef, criteriaVersion,
				regimeVersion, taxBreakdown, fiscalDocRef, issuedAt) +
				trace completo dos inputs e outputs fiscais aplicados,
				sem interpretação ou justificativa do regime; trail
				satisfaz exigência fiscal regulatória (retenção legal
				NF-e ≥5 anos). InvoiceCancelled preserva trail completo
				do invoice cancelado (fiscalCancellationRef +
				reasonCode categórico).
				"""
			rationale: """
				Capability matches cc-04 do domain-definition (audit
				contínuo); INV-specific aspect: audit trail é
				fiscal-grade (regulação tributária exige
				rastreabilidade documento + inputs + outputs, sem
				justificativa de regime que invadiria domínio ATO).
				Imutabilidade pós-emit é invariante estrutural —
				soft-delete proibido (G3 guardrail).
				"""
		}, {
			description: """
				Cômputo fiscal apply-only deterministic: dado regime
				fiscal resolvido (read-only input), commitment terms
				verificados (read-only via CMT projection cache) e
				verification outcome categórico (approved), INV calcula
				taxBreakdown aplicando tabelas declarativas (CFOP +
				alíquotas + retenções) — sem interpretar regime, sem
				decidir enquadramento, sem alterar amount. Função pura:
				input idêntico → output idêntico reproduzível em replay
				(paralelo BD2 DLV idempotency).
				"""
			rationale: """
				Sem capability própria de domain-definition — emerge da
				análise dos businessDecisions: apply-only é o RECTOR
				estrutural anti-mini-ATO. Sem isso, INV vira
				interpretador fiscal e absorve responsabilidade ATO.
				Determinismo é precondition de cc-03 (24/7) e cc-04
				(audit reproducible).
				"""
		}, {
			description: """
				Emissão atômica com lifecycle público mínimo:
				InvoiceIssued + ReceivableMaterialized emitidos
				atomicamente via primitive de infraestrutura que
				garante consistência entre estado e publicação de
				eventos; InvoiceCancelled emitido como evento explícito
				dentro de janela fiscal. Conservação de valor:
				ReceivableMaterialized.amount == InvoiceIssued.amount
				sempre (mesma fonte computacional). Idempotência: tupla
				(commitmentRef, evidenceRef) gera no máximo um
				InvoiceIssued (replay-safe). Sem eventos intermediários
				ou de ajuste — ajustes pós-issued vivem em DRC/ATO,
				não em INV.
				"""
			rationale: """
				Sem capability própria de domain-definition —
				capability core do INV. Sustenta G1 (idempotência
				operacional), G2 (receivable.amount == invoice.amount
				sempre) e G3 (cancelamento sempre evento explícito,
				não soft-delete). Lifecycle público mínimo (3 events
				cobrindo nascimento atomic + morte dentro da janela
				fiscal) previne INV virar workflow engine; correções
				fora dessa janela são DRC (disputa) ou ATO (ajuste
				contábil), não mutações INV. Atomic emit é
				responsabilidade da infrastructure (declarado como
				contract, não mecanismo).
				"""
		}]
		hasSyncSurface:  false
		hasAsyncSurface: true
	}

	communication: {
		inbound: [{
			type:          "event-consumer"
			sourceContext: "dlv"
			event:         "DeliveryVerified"
			reaction: """
				INV consome via ACL (dlv-to-inv operacional Phase 0)
				e materializa Invoice aggregate per (commitmentRef,
				evidenceRef) identity. ACL filtra payload categórico:
				preserva (commitmentRef, evidenceRef, criteriaVersion,
				status=approved); descarta reasonCode (interpretação),
				retryPath (DLV-internal), verificationMetrics (BD10
				anti-mini-NIM). INV consome APENAS DeliveryVerified
				com status=approved e ignora explicitamente todos os
				demais eventos DLV (DeliveryRejected, supersession
				events, internal lifecycle events). Trigger:
				status=approved ⇒ atomic emit InvoiceIssued +
				ReceivableMaterialized; status≠approved ⇒ no-op.
				"""
			description: """
				Ingestion path principal cross-BC. INV consome apenas
				eventos DLV terminal-approved; naming 'Verified' indica
				fato consumível pós-DLV-finality. INV NÃO consome
				supersession events de DLV diretamente — supersession
				reabre DLV; nova verificação aprovada gera nova invoice
				via tupla (commitmentRef, evidenceRef-N+1) distinta.
				Correção da invoice antiga: cancelamento INV dentro da
				janela fiscal OU DRC/ATO fora dela.
				"""
		}, {
			type:          "event-consumer"
			sourceContext: "cmt"
			event:         "CommitmentAccepted"
			reaction: """
				INV consome via ACL (cmt-to-inv operacional Phase 0)
				e materializa projection cache local read-only de
				commitment terms (commitmentRef, amount, currency,
				dueDate, parties, taxRegimeRef) — input determinístico
				para cômputo fiscal apply-only no momento subsequente
				de InvoiceIssued. Cache é write-once per commitmentRef:
				CommitmentAccepted carrega terms canônicos pós-aceite
				bilateral; INV NÃO consome CommitmentStateChanged
				(state changes pós-formalização — cancel, suspend —
				não alteram terms originais; correção pós-issued é
				DRC/ATO scope, não mutação INV).
				"""
			description: """
				Read-side dependency estrutural para cômputo de amount.
				INV depende de commitment terms para materializar
				fatura: amount = f(commitmentTerms,
				verificationOutcome=approved). Projection cache async
				preserva replay determinístico e elimina sync coupling
				com CMT. Paralelo cmt-to-tcm (TCM consome mesmo
				CommitmentAccepted para projetar obrigação futura na
				posição de caixa) — pattern read-side via projection.
				"""
		}]

		outbound: [{
			type: "event-publisher"
			trigger: """
				DeliveryVerified consumed (status=approved) +
				commitment terms disponíveis no projection cache local
				⇒ atomic emit Invoice aggregate state + InvoiceIssued
				event publication AS-ONE via primitive de
				infraestrutura que garante consistência entre estado e
				publicação de eventos. Idempotência operacional:
				identidade (commitmentRef, evidenceRef) garante no
				máximo um InvoiceIssued por tupla (G1 guardrail).
				Conservação de valor: amount derivado de
				f(commitmentTerms, verificationOutcome=approved) —
				função fechada e determinística.
				"""
			event: "InvoiceIssued"
			consumers: ["fce", "ato"]
			description: """
				Hard binding cross-BC para 2 consumidores formalizados:
				FCE (settle pagamento contra invoice + commitmentRef) e
				ATO (registrar lançamento fiscal — pattern conformist
				per context-map: ATO conforma com linguagem fiscal INV
				sem tradução). Payload categórico: invoice identity +
				commitment lineage + fiscal doc reference + amount +
				currency + dueDate + taxBreakdown(informational) +
				regimeVersion + issuedAt. NÃO inclui paymentMethod,
				paymentSchedule, accountRef (FCE concerns); NÃO inclui
				riskScore, eligibilityFlag (REW/SCF concerns); NÃO
				inclui rationale fiscal interpretativo (ATO domain).
				"""
		}, {
			type: "event-publisher"
			trigger: """
				InvoiceIssued emit ⇒ atomic emit ReceivableMaterialized
				no MESMO commit transacional (G2 guardrail:
				ReceivableMaterialized.amount == InvoiceIssued.amount
				sempre, mesma fonte computacional). Trigger acoplado
				estruturalmente — ReceivableMaterialized não pode emit
				sem InvoiceIssued precedente válido.
				"""
			event: "ReceivableMaterialized"
			consumers: ["scf"]
			description: """
				Hard binding cross-BC para SCF (originar produtos
				financeiros sobre lastro de recebível verificado).
				Evento separado de InvoiceIssued para preservar contract
				independente: SCF liga em ReceivableMaterialized (ativo
				financeiro transferível) sem acoplar-se em
				fiscalDocRef/regimeVersion (concerns INV/ATO). Payload
				categórico mínimo: receivableId + invoiceId +
				commitmentRef + amount + currency + dueDate +
				materializedAt. NÃO inclui eligibilityScore,
				productCategory, anticipationRate (SCF concerns); NÃO
				inclui riskAssessment (REW concern); INV emite SEMPRE
				que invoice é issued — filtragem por elegibilidade é
				decisão SCF/REW.
				"""
		}, {
			type: "event-publisher"
			trigger: """
				Comando CancelInvoice processado dentro da janela fiscal
				(janela definida por regime jurisdicional; e.g. SEFAZ
				≤24h pós-emit no regime brasileiro). Gate categórico:
				within-window sim/não (sem interpretação). G3 guardrail:
				cancelamento sempre evento explícito — sem soft-delete,
				sem overwrite, sem re-emissão silenciosa. Cancelamento
				fora-da-janela é supervisedDecision separado
				(escalation), NÃO mutação INV.
				"""
			event: "InvoiceCancelled"
			consumers: ["fce", "ato"]
			description: """
				Cancelamento dentro da janela fiscal — único path
				INV-owned de mutação pós-issued. Consumers downstream:
				FCE (cancelar pending settlement se pre-settle; no-op
				pós-settle — correção financeira é DRC) e ATO (estornar
				lançamento fiscal). Payload categórico: invoiceId +
				fiscalCancellationRef + reasonCode (categórico definido
				no domain-model) + cancelledAt. NÃO inclui
				replacementInvoiceId (orchestration); NÃO inclui
				refundDetails ou restitutionPath (DRC/ATO concerns).
				"""
		}]

		rationale: """
			Communication minimalista por design: 2 inbound (dlv-to-inv
			operacional + cmt-to-inv operacional, ambos formalizados em
			context-map Phase 0) + 3 outbound (InvoiceIssued para
			FCE/ATO, ReceivableMaterialized para SCF, InvoiceCancelled
			para FCE/ATO — todos formalizados em context-map Phase 0).
			hasSyncSurface=false ⇒ sem inbound query-surfaces; consumers
			mantêm próprias projections via event consumption — preserva
			replay independence e previne INV virar read-model central.
			ACL inbound filtra rigorosamente payloads upstream: DLV
			descarta reasonCode/retryPath/metrics; CMT consome apenas
			CommitmentAccepted (terms canônicos), ignora
			CommitmentStateChanged. Payload outbound mínimo categórico
			— sem campos de pagamento (FCE), sem campos de
			risco/elegibilidade (REW/SCF), sem rationale fiscal
			interpretativo (ATO). Idempotência garantida pela identidade
			(commitmentRef, evidenceRef); detalhes de dedup canonical
			vs fallback são responsabilidade da infrastructure (atomic
			emit primitive), não contract de comunicação.
			"""
	}

	businessDecisions: [
		// =============================================
		// LOTE 1 — NÚCLEO DETERMINÍSTICO (4 BDs)
		// =============================================
		{
			id: "bd-issuance-requires-verification"
			decision: """
				Toda InvoiceIssued emitida AUTONOMAMENTE por INV EXIGE
				DeliveryVerified terminal=approved precedente sob a
				mesma (commitmentRef, evidenceRef). Sem verificação
				de execução, no fatura. INV consome APENAS
				DeliveryVerified status=approved e ignora
				explicitamente todos os demais eventos DLV
				(DeliveryRejected, supersession events, lifecycle
				internos). Cancelamento de DLV (rejected) ou
				superseded NÃO triggera fatura.
				"""
			rationale: """
				RECTOR herdado da invariante central Mesh ('dinheiro
				só move quando operação comprova') aplicada à camada
				fiscal: 'fatura só nasce quando entrega é
				verificada'. Sem este gate, INV emit faturas sem
				lastro operacional, quebrando spine commitment-
				lifecycle e habilitando classe inteira de fraude
				(faturamento sem entrega).
				"""
			consequences: """
				Gate determinístico pré-emit; nenhuma fatura autônoma
				sem DeliveryVerified canônico. Rejection/supersession
				events DLV NÃO disparam mutação INV. Identidade da
				fatura (commitmentRef, evidenceRef) é diretamente
				derivada do terminal event canônico — sem ambiguidade
				de origem.
				"""
		},
		{
			id: "bd-deterministic-fiscal-projection"
			decision: """
				amount = f(commitmentTerms, verificationOutcome=
				approved) — função pura, fechada, determinística.
				Cômputo fiscal é aplicação de tabelas declarativas
				read-only (CFOP + alíquotas + retenções) sob
				regimeVersion explícito; INV NÃO interpreta regime,
				NÃO decide enquadramento, NÃO altera valor. Regime
				fiscal é input externo (resolvido fora do INV);
				regimeVersion bump é exigência explícita para
				qualquer mutação de regra.
				"""
			rationale: """
				A1 + A4 guardrails consolidados; previne INV virar
				mini-ATO (interpretador fiscal) ou mini-FCE
				(negociador de valor). Determinismo é precondition
				de cc-03 (24/7) e cc-04 (audit reproducible). Função
				pura = replay bit-a-bit reconstrutível para forensic
				+ dispute.
				"""
			consequences: """
				Silent regime mutation proibida; mudança de regra
				fiscal exige regimeVersion explícito. Fatura emitida
				sob regimeVersion-N permanece reproduzível para
				audit indefinidamente. INV não tem decisão econômica;
				divergência commercial-vs-fiscal é DRC/ATO scope.
				"""
		},
		{
			id: "bd-issuance-idempotent"
			decision: """
				Tupla (commitmentRef, evidenceRef) gera no máximo um
				InvoiceIssued. Replay-safe: mesma tupla consumida
				múltiplas vezes (replay, partição, multi-log
				ingestion) produz exatamente um evento publicado.
				Identidade NÃO inclui criteriaVersion nem
				regimeVersion — versions são attributes do evento,
				não componentes de identity. Re-emissão sob
				regimeVersion distinto NÃO ocorre via mutação de
				invoice existente; mudança de regime aplica somente
				a verificações FUTURAS (nova evidenceRef ou nova
				verificação aprovada gera nova invoice sob regime
				corrente).
				"""
			rationale: """
				G1 guardrail; previne duplicação de fatura que
				quebraria lastro SCF (recebível duplicado),
				contabilidade ATO (lançamento duplicado) e
				settlement FCE (pagamento duplicado). Identity sem
				criteriaVersion/regimeVersion preserva idempotência
				cross-version; isolamento entre identity (quem é a
				invoice) e attributes (sob qual regra foi emitida)
				evita re-emissão silenciosa que violaria BD2
				imutabilidade fiscal.
				"""
			consequences: """
				Aggregate identity check pré-emit via atomic
				primitive; tentativa de emit duplicado é no-op
				observável. Nova evidenceRef (post-supersession)
				gera nova invoice válida (tupla distinta). Cross-BC
				consumers (FCE, ATO, SCF) observam at-most-once via
				dedup ancorado em identity. Mudança de regime fiscal
				(regimeVersion bump) NÃO regenera invoices
				históricas — aplica somente a verificações
				subsequentes; audit trail preserva regimeVersion no
				momento da emissão para reproducibilidade indefinida.
				"""
		},
		{
			id: "bd-requires-local-commitment-projection"
			decision: """
				INV exige disponibilidade local, completa E
				consistente dos commitmentTerms necessários para
				cálculo de amount via projection cache derivado de
				eventos CMT (CommitmentAccepted). Emissão é BLOQUEADA
				quando projection: (a) não está disponível, (b) está
				incompleta — campos obrigatórios para fiscal projection
				(amount, currency, dueDate, taxRegimeRef, parties)
				ausentes —, OU (c) está stale relativo ao estado
				mais recente conhecido do commitmentRef. Uso de
				projection stale é tratado como ausência (emit
				bloqueado, mesmo path de retry). INV NÃO faz fallback
				sync query a CMT no caminho crítico (viola
				hasSyncSurface=false).
				"""
			rationale: """
				Garante determinismo + replay independence: INV não
				depende de queries síncronas ao CMT no caminho de
				emissão. Race condition cross-BC (DeliveryVerified
				arriving antes de CommitmentAccepted devido a
				partições/atrasos infra-level) é tratada como
				ausência temporária de input — emit é gate-blocked
				até projection consistente. Staleness protection
				previne bug clássico de produção: emitir invoice com
				terms antigos enquanto CMT já publicou
				CommitmentStateChanged que projection ainda não
				processou — divergência fiscal sutil + race silencioso
				difícil de detectar.
				"""
			consequences: """
				Emission gate inclui verificação de projection local
				pré-emit (presença + completude + freshness);
				ausência ou staleness resulta em no-op + retry via
				event replay (Phase 0). Eventual consistency esperada
				em operação normal (commitmentRef precede causalmente
				evidenceRef). Phase 0 limitação: timeout de espera por
				projection consistente é runner-level (TBD via ADR
				Phase 1+ se escalation pattern emergir). INV permanece
				isolado de dependência runtime sync com CMT.
				"""
		},

		// =============================================
		// LOTE 2 — LIFECYCLE E CANCELAMENTO (2 BDs)
		// =============================================
		{
			id: "bd-lifecycle-issued-cancelled-only"
			decision: """
				Estados de domínio Invoice ∈ {issued, cancelled}.
				Não há estado draft, partial, pending, ou amended
				no domínio — draft é integration concern (transiente
				em adapter de emissão fiscal Phase 1+, fora do
				boundary canônico INV). Transição única permitida:
				issued → cancelled (sob condições BD5).
				"""
			rationale: """
				A2 guardrail; state machine mínima previne retry
				logic surface, estado não-determinístico, ambiguidade
				lifecycle. Cada estado adicional é vetor de
				complexidade operacional + audit + invariante; INV
				não precisa de nenhum (cômputo fiscal é instantâneo;
				cancelamento é binário).
				"""
			consequences: """
				Nenhum command INV produz draft; falha de emissão é
				error externo (escalation), não estado salvo. State
				representation simples = audit trail simples = schema
				CUE simples. Amend de fatura emitida NÃO existe —
				correção via cancelamento + re-emissão sob nova
				evidenceRef ou via DRC/ATO.
				"""
		},
		{
			id: "bd-cancellation-bounded-and-explicit"
			decision: """
				Cancelamento INV-owned APENAS dentro de janela
				fiscal regulada (e.g. SEFAZ ≤24h regime brasileiro;
				janela generaliza por regime jurisdicional). Fora
				da janela: NÃO há mutação INV — escalation
				supervisedDecision direcionando correção para DRC
				(disputa) ou ATO (ajuste contábil). Cancelamento
				sempre evento InvoiceCancelled explícito — sem
				soft-delete, sem overwrite, sem re-emissão silenciosa.
				"""
			rationale: """
				A3 (parcial) + G3 guardrails consolidados. Janela
				fiscal respeita regulação tributária externa (mutar
				fora da janela viola legislação). Cancelamento
				explícito preserva auditabilidade cross-BC: FCE/ATO
				sempre reconstroem lifecycle via event log canônico,
				sem inferência sobre estado interno INV.
				"""
			consequences: """
				Gate categórico within-window sim/não pré-cancel;
				tentativa fora-janela bloqueada + escalation. FCE
				consume InvoiceCancelled para cancelar pending
				settlement pré-settle (no-op pós-settle — correção
				é DRC). ATO estorna lançamento. Imutabilidade
				pós-issued garantida fora da janela.
				"""
		},

		// =============================================
		// LOTE 3 — BOUNDARIES ANTI-MINI (4 BDs)
		// =============================================
		{
			id: "bd-atomic-dual-emission"
			decision: """
				InvoiceIssued + ReceivableMaterialized emitidos
				atomicamente via primitive de infraestrutura que
				garante consistência entre estado e publicação de
				eventos — mesmo commit transacional, jamais
				cálculos separados. Conservação de valor:
				ReceivableMaterialized.amount == InvoiceIssued.amount
				sempre, derivado da mesma fonte computacional (BD2
				amount function).
				"""
			rationale: """
				G2 guardrail; previne divergência fatura↔recebível
				que quebraria lastro SCF (recebível materializado
				sem fatura válida ou amount divergente) e
				contabilidade ATO. Atomic emit é responsabilidade
				da infrastructure (declarado como contract, não
				mecanismo) — paralelo BD14 DLV transactional outbox
				pattern.
				"""
			consequences: """
				Falha de emissão impede ambos eventos (no half-
				emission); SCF + FCE/ATO sempre observam estado
				consistente. Reconciliação de divergências
				fatura↔recebível NÃO existe (divergência é
				impossível por construção, não detectada ex-post).
				"""
		},
		{
			id: "bd-no-supersession-reaction"
			decision: """
				INV NÃO consome supersession events de DLV. Quando
				DLV supersession produz nova verificação aprovada
				(nova evidenceRef), nova invoice emerge
				automaticamente via tupla (commitmentRef,
				evidenceRef-N+1) distinta — NÃO é mutação da invoice
				antiga. Correção da invoice antiga: cancelamento INV
				(se dentro janela fiscal) OU sinal para DRC/ATO
				(fora janela).
				"""
			rationale: """
				A3 (parcial) guardrail; supersession reabre DLV
				scope, não INV scope. Manter INV reativo a
				supersession criaria acoplamento bidirecional
				DLV↔INV + mutação implícita de invoice antiga
				(violando G3). BD3 (idempotent identity sobre
				evidenceRef) garante que nova evidenceRef → nova
				invoice naturalmente.
				"""
			consequences: """
				Lineage de invoices por commitmentRef via
				eventLogOffset ordering canonical; múltiplas invoices
				válidas por commitmentRef quando há supersession
				(cada uma com evidenceRef distinta). Cancelamento
				da invoice antiga é decisão separada — INV não
				automatiza correção retroativa.
				"""
		},
		{
			id: "bd-no-metrics-feedback"
			decision: """
				INV NÃO reage a métricas operacionais (taxa de
				cancelamento, taxa de DLV-rejected, latência média
				de emissão, distribuição de regimeVersion, etc.).
				Métricas são observability-only; mudanças de
				comportamento INV ocorrem via design evolution
				(ADR/founder review), NUNCA via auto-tuning, self-
				adaptation ou feedback loop interno.
				"""
			rationale: """
				BD10 anti-mini-NIM transversal Mesh (paralelo DLV
				bd-no-scoring-by-dlv). INV reagindo a métricas
				viraria decisor econômico/risco (REW/NIM scope).
				Métricas alimentam observability OBS + escalation
				founder, não loops de tuning interno.
				"""
			consequences: """
				Dashboards OBS expõem métricas INV para sh-04
				founder review; thresholds de alarm geram escalation
				explícita, não auto-modification. INV permanece
				projeção determinística sob política externa (regime
				+ criteria), nunca adaptativa internamente.
				"""
		},
		{
			id: "bd-no-downstream-coordination"
			decision: """
				INV NÃO coordena AUTONOMAMENTE com nem reage a
				estados ou decisões de contextos downstream (FCE,
				SCF, ATO, DRC). Emissão e cancelamento são funções
				exclusivamente dos inputs upstream (DLV terminal
				events, CMT projection cache, regime fiscal). Eventos
				downstream NÃO entram em projection cache INV; INV
				não os consome no caminho normal. Dados downstream
				NÃO são utilizados como input de decisão nem direta
				nem indiretamente no fluxo de emissão (sem flags
				derivadas, sem caching silencioso, sem influência
				implícita). Path supervised (e.g., DRC força
				cancellation via human-in-loop governance) permanece
				disponível como escalation explícita, distinto de
				auto-reaction.
				"""
			rationale: """
				Previne INV evoluir para orchestrator ou decision
				engine financeiro. Mantém separação clara:
				materialização (INV) ≠ execução (FCE) ≠ originação
				(SCF) ≠ contabilidade (ATO) ≠ resolução de disputa
				(DRC). Anti-drift estrutural — sem este BD, futura
				tentação de 'INV reage a PaymentSettled para flag
				invoice paid' violaria BD4 (lifecycle 2 states) mas
				só por inferência composta; BD explícito bloqueia
				por construção. Bloqueio de uso indireto fecha
				loophole semântico ('ok, não reajo… mas posso ler e
				usar implicitamente').
				"""
			consequences: """
				Nenhum evento downstream altera comportamento autônomo
				INV. INV permanece puramente reativo a fatos upstream.
				Correções downstream (FCE pagamento estornado, ATO
				ajuste contábil, DRC dispute resolution) NÃO mutam
				invoice histórica — correção via cancelamento INV
				(dentro janela) ou via DRC/ATO (fora janela).
				Supervised intervention é caminho separado, registrada
				como supervisedDecision com audit trail completo.
				"""
		},
	]

	stakeholders: [{
		stakeholderRef: "sh-02"
		roleInContext:  "Beneficiário direto da materialização do recebível"
		impactDescription: """
			Fornecedor é beneficiário canônico do INV: ReceivableMaterialized
			emitido por INV é o ativo financeiro que SCF utiliza para
			operação de antecipação. Sem materialização determinística pelo
			INV, fornecedor permanece preso ao ciclo tradicional de
			recebimento (60-120 dias). InvoiceIssued representa o crédito
			fiscal que sh-02 detém perante sh-01.
			"""
		rationale: "sh-02 é quem mais sofre assimetria informacional — INV materializa o lastro que destrava antecipação. Sem INV operando deterministicamente, ce-06 (custo de alongamento do ciclo) não é eliminável."
	}, {
		stakeholderRef: "sh-01"
		roleInContext:  "Devedor da obrigação de faturamento materializada"
		impactDescription: """
			Construtora é a parte que paga a fatura emitida (via FCE).
			InvoiceIssued representa obrigação de pagamento sob commitment
			bilateral previamente aceito. Construtora consome implicitamente
			via FCE settlement; cancelamento dentro da janela fiscal
			(InvoiceCancelled) protege contra obrigações faturadas
			erroneamente.
			"""
		rationale: "sh-01 carrega impacto direto via fatura → settlement; previsibilidade de quando fatura nasce (DLV verified → INV issued) é precondição para sua gestão de fluxo de caixa."
	}, {
		stakeholderRef: "sh-03"
		roleInContext:  "Consumidor do recebível materializado como lastro de funding"
		impactDescription: """
			IF parceira consome ReceivableMaterialized via SCF como lastro
			para operação de antecipação. Verificabilidade programática do
			lastro (commitmentRef + evidenceRef + fiscalDocRef ancorados em
			audit trail INV cc-04) substitui due diligence manual sobre
			recebíveis (ce-07). Determinismo do INV (BD2 fiscal projection)
			é precondition para confiança no lastro.
			"""
		rationale: "sh-03 fornece funding apenas se lastro é verificável; INV é o BC que produz a cadeia auditável recebível → fatura → entrega → commitment."
	}, {
		stakeholderRef: "sh-04"
		roleInContext:  "Regulador prudencial do operador SCD (Mesh)"
		impactDescription: """
			Bacen exige rastreabilidade completa da cadeia operacional da
			SCD. INV materializa o documento fiscal canônico (NF-e) com
			audit trail regulatory-grade (cc-04) — InvoiceIssued e
			InvoiceCancelled imutáveis pós-emit, retenção legal ≥5 anos,
			trace inputs/outputs fiscais sem interpretação. Compliance
			prudencial é constraint inviolável (nível 1
			conflictResolution).
			"""
		rationale: "Operação SCD sem audit trail fiscal regulatory-grade é ilegal; INV é o BC que produz esse trail no domínio fiscal."
	}, {
		stakeholderRef: "sh-05"
		roleInContext:  "Operador autônomo da emissão fiscal determinística"
		impactDescription: """
			Agente IA Mesh executa autonomamente a emissão (cc-03 24/7) sob
			os 10 BDs do INV — gates determinísticos (BD1
			issuance-requires-verification, BD4 requires-local-commitment-
			projection) bloqueiam ações fora do envelope. Falhas estruturais
			(projection stale, regime ausente, race cross-BC) escalam como
			supervisedDecision para sh-04 founder review, jamais
			auto-resolvidas via heurística.
			"""
		rationale: "Sem sh-05 como stakeholder explícito, decisões de design tratam o agente como ferramenta — perdendo coerência com ax-01/ax-02; gates explícitos preservam clareza dos limites de autonomia (concern primária do agente)."
	}]

	costsEliminated: [{
		costRef:      "ce-02"
		contribution: "INV emite NF-e regulatória + audit trail completo de inputs/outputs fiscais (cc-04) substituindo compliance documental manual; trace categórico sem interpretação preserva auditabilidade sem invadir ATO."
		rationale:    "Compliance documental fiscal é overhead substancial (procedimento manual de emissão + arquivamento + retenção 5 anos); INV automatiza via aplicação determinística de regras + audit trail estrutural."
	}, {
		costRef:      "ce-03"
		contribution: "INV emite InvoiceIssued + ReceivableMaterialized atomicamente (BD7 atomic-dual-emission); ATO conforma sem tradução (pattern conformist context-map). Divergência estrutural fatura↔recebível é impossível dentro do INV (BD7 conservation amount); divergências externas (timing FCE, latência SCF, erros ATO) permanecem possíveis mas detectáveis sem reconciliação manual via audit trail cross-BC."
		rationale:    "Atomic emit + conformist downstream = eliminação estrutural de uma classe específica de divergências (intra-INV); divergências cross-BC remanescentes têm custo de reconciliação reduzido por audit trail estrutural, não eliminado integralmente."
	}, {
		costRef:      "ce-06"
		contribution: "INV materializa recebível (ReceivableMaterialized) imediatamente após DLV terminal=approved (atomic via BD7); SCF antecipa lastreado em recebível verificável, eliminando ciclo tradicional 60-120 dias do fornecedor."
		rationale:    "ce-06 é eliminável apenas se recebível existe deterministicamente vinculado a evidência verificada — INV é o BC que produz essa materialização canônica."
	}, {
		costRef:      "ce-07"
		contribution: "INV ancora ReceivableMaterialized em cadeia auditável commitmentRef → evidenceRef → fiscalDocRef → regimeVersion (cc-04 audit trail); IF parceira verifica lastro programaticamente sem due diligence manual sobre cada recebível individual."
		rationale:    "ce-07 elimina-se via verificabilidade programática do lastro — INV produz a cadeia de referências canônicas que torna verificação programática viável."
	}]

	incentiveAnalysis: {
		participants: [{
			stakeholderRef:            "sh-02"
			participantType:           "fornecedor (cedente do recebível)"
			desiredBehavior:           "submeter evidência operacional legítima e aceitar fatura emitida sob commitmentTerms canônicos"
			correctOperationIncentive: "Recebível materializado é antecipável via SCF imediatamente após DLV verified → INV issued (vs ciclo 60-120 dias tradicional); ce-06 eliminado direto."
			manipulationVector: """
				Tentar inflar valor faturado modificando commitmentTerms
				via canal indireto (e.g., após CommitmentAccepted, sugerir
				amendment terms favoráveis sob pretexto operacional).
				"""
			manipulationCost: """
				Commitment é bilateral acordado em CMT (BD CMT
				aceite-mútuo-bilateral); amendment exige nova
				ConfirmCommitmentAcceptance bilateral. INV emite fatura
				sob commitmentTerms read-only do projection cache
				(BD2 deterministic-fiscal-projection + BD4
				requires-local-commitment-projection); fatura sob terms
				diferentes do commitment canônico viola função pura. Audit
				trail cross-BC (CMT events + INV events) torna fraude
				detectável programaticamente.
				"""
			vsBenefit: "Ganho temporário de overpayment é detectado em audit cross-BC + ATO reconciliação fiscal; risco regulatório alto (Bacen audit) + perda de credibilidade no funding sh-03 = inviável estruturalmente."
			designResponse: "BD2 deterministic-fiscal-projection (função pura sobre commitmentTerms read-only) + BD4 requires-local-commitment-projection (projection cache canônica única source) + bilateralism CMT (amendment requer ConfirmCommitmentAcceptance bilateral) + audit trail cross-BC reproduzível (cc-04)."
			rationale: "sh-02 é beneficiário direto do INV; vetor mais provável é tentar inflar valor — bloqueado por bilateralism CMT + função pura INV + audit cross-BC."
		}, {
			stakeholderRef:            "sh-01"
			participantType:           "construtora (devedor da obrigação)"
			desiredBehavior:           "honrar fatura emitida sob commitment bilateral aceito + DLV verified"
			correctOperationIncentive: "Previsibilidade de quando fatura nasce (gate determinístico DLV verified → INV issued) viabiliza gestão de fluxo de caixa; cancelamento INV dentro da janela fiscal protege contra fatura emitida erroneamente."
			manipulationVector: """
				Tentar negar fatura legítima alegando 'verificação não
				ocorreu' apesar de DLV ter emitido DeliveryVerified
				canônico, ou tentar disputar fatura via canal informal
				fora do path DRC.
				"""
			manipulationCost: """
				DLV terminal events são imutáveis em event log canônico
				com integridade criptográfica DSSE; INV emite invoice
				ancorada em evidenceRef DSSE-anchored. Tentativa de
				falsificar evento DLV requer comprometer event log =
				vetor estruturalmente inviável. Disputa via canal informal
				não bloqueia settlement (FCE consume InvoiceIssued
				canônico); única correção legítima é DRC dispute
				resolution com audit trail.
				"""
			vsBenefit: "Negar pagamento de fatura válida sem path DRC quebra trust com sh-03 funding partner (que vê padrão de defaults injustificados) = perda de acesso a crédito futuro Mesh; benefício de não pagar uma fatura única < custo de fechamento de pipeline de crédito."
			designResponse: "Imutabilidade de DLV terminal events (event log canônico DSSE-anchored) + invoice ancorada em evidenceRef criptograficamente verificável + path DRC formalizado como única correção legítima pós-issued; settlement FCE não é gated por disputa informal."
			rationale: "sh-01 é devedor; vetor é negação infundada — bloqueado pela imutabilidade DLV + canal DRC formalizado para disputas legítimas."
		}, {
			stakeholderRef:            "sh-03"
			participantType:           "instituição financeira parceira (consumidor de lastro)"
			desiredBehavior:           "consumir ReceivableMaterialized representativamente da rede; financiar operações lastreadas em verificação programática sem cherry-picking que degrade função sistêmica"
			correctOperationIncentive: "ce-07 eliminado: due diligence sobre lastro substituída por verificação programática da cadeia INV→DLV→CMT; portfolio quality verificável continuously; participação balanceada na rede preserva deal flow futuro."
			manipulationVector: """
				Seleção adversa de recebíveis (cherry-picking): selecionar
				apenas recebíveis mais seguros (commitments com sh-01
				premium, evidências de baixa contestabilidade, regimes
				fiscais simples) e rejeitar sistematicamente recebíveis
				de maior risco, degradando a função de funding da rede e
				externalizando risco para Mesh ou outros financiadores.
				"""
			manipulationCost: """
				Comportamento de cherry-picking é detectável via padrão
				de consumo observável (ratio consumed/available por
				risk-tier ou commitment-profile); SCF/REW podem ajustar
				pricing/eligibility ao consumidor com seleção adversa
				comprovada. Mesh como rede antifrágil opera via
				comportamento observável: padrões de seleção adversa
				prolongados degradam acesso a deal flow futuro
				(elegibilidade revogável). INV produz refs canônicas
				suficientes para SCF/REW computarem indicadores de
				seleção sem necessidade de auditoria manual sobre
				sh-03.
				"""
			vsBenefit: "Ganho de curto prazo via seleção de menor risco < custo de longo prazo via perda de deal flow + degradação de relacionamento com a rede; comportamento observável + ajuste sistêmico pelos pares (SCF/REW) tornam vetor não-sustentável."
			designResponse: "INV produz refs canônicas suficientes (commitmentRef, evidenceRef, fiscalDocRef, regimeVersion) para SCF/REW computarem indicadores de seleção observáveis; eligibility revogável pelos peers em resposta a padrão adversarial detectado; rede antifrágil via comportamento observável (não policing manual)."
			rationale: "sh-03 é consumidor; vetor real é seleção adversa que degrada função sistêmica — bloqueado por observabilidade do padrão de consumo + capacidade de ajuste pelos peers REW/SCF; alinhamento estrutural com tese Mesh de rede antifrágil via comportamento observável."
		}, {
			stakeholderRef:            "sh-05"
			participantType:           "agente IA Mesh (operador autônomo da emissão)"
			desiredBehavior:           "emitir fatura apenas dentro do envelope BDs (BD1-BD10); escalar como supervisedDecision toda situação fora do envelope"
			correctOperationIncentive: "Operação dentro de gates é audit-clean (cc-04); cada decisão tem trace reproduzível; agente não carrega responsabilidade por decisões fora do envelope (escalation transfere para sh-04 founder)."
			manipulationVector: """
				Vetores típicos de erro/drift do agente: (a) tentar emitir
				fatura via path autônomo em situação que deveria escalar
				(e.g., DeliveryVerified de versão DLV anterior à
				canonization current); (b) uso de projection cache
				desatualizada (stale) como se fosse válida — interpretar
				dados antigos como consistentes para 'completar' a
				operação sob pressão operacional; (c) tentar 'completar'
				operações via heurística vs aguardar consistência
				cross-BC.
				"""
			manipulationCost: """
				BD1 RECTOR bloqueia emit sem DeliveryVerified canônico;
				BD3 idempotency previne duplicação; BD4
				requires-local-commitment-projection trata projection
				stale como ausência → emit bloqueado (não há shortcut
				heurístico legítimo para 'projection é provavelmente
				ainda válida'). Agente operando fora de gates triggera
				audit alarm estrutural (cc-04 audit trail registra
				divergência); supervisedDecision separada com
				human-in-loop + justificativa documentada é caminho
				legítimo para situações fora do envelope.
				"""
			vsBenefit: "Bypass dos gates não habilita ganho — fatura sem lastro DLV não é consumida por FCE/SCF/ATO (cross-BC validation rejeita); audit trail expõe tentativa imediatamente; reputational cost para envelope Phase 1+ calibration."
			designResponse: "Gates determinísticos hierárquicos BD1 (RECTOR verification required) + BD3 (idempotency) + BD4 (projection availability + completeness + freshness — stale tratado como ausência sem heurística de fallback) bloqueiam todos os shortcuts; cross-BC validation downstream (FCE/SCF/ATO) rejeita emit fora do envelope como segunda barreira; cc-04 audit trail expõe tentativa estruturalmente."
			rationale: "sh-05 é operador; risco é shortcuts heurísticos sob pressão operacional (incluindo uso de cache stale como se fosse válido — vetor real Phase 1+) — bloqueado por gates determinísticos BD1+BD3+BD4 + cross-BC validation downstream + audit estrutural cc-04."
		}, {
			stakeholderRef:            "sh-04"
			participantType:           "regulador (Bacen + autoridade fiscal)"
			desiredBehavior:           "fiscalizar conformidade prudencial e fiscal via audit trail regulatory-grade"
			correctOperationIncentive: "INV expõe audit trail estrutural cc-04 (immutable post-emit, retention legal ≥5 anos, trace categórico de inputs/outputs); fiscalização programática viável sem auditoria manual periódica."
			manipulationVector: """
				(Inverso — Bacen é stakeholder cuja 'manipulação' é
				incompliance pelo operador Mesh, não pelo regulador.)
				Mesh operando INV poderia tentar omitir dados do trail
				ou modificar audit pós-emit para evitar fiscalização
				adversa.
				"""
			manipulationCost: """
				Imutabilidade pós-emit (BD2 + BD7 + cc-04) é invariante
				estrutural inviolável do INV — soft-delete proibido
				(G3); modificação pós-emit quebra constraint CUE schema
				de audit trail. Tentativa de omissão = violação
				regulatória direta + criminalização (sh-04 tem poder de
				suspensão da SCD).
				"""
			vsBenefit: "Compliance prudencial é nível 1 conflictResolution (inviolável); custo de violação = perda da licença SCD = morte da Mesh; benefício de qualquer omissão é zero comparado."
			designResponse: "Imutabilidade pós-emit invariante estrutural (BD2 + BD7 + cc-04 + G3 sem soft-delete) + audit trail constraint hard no schema CUE INV (não-modificável programaticamente) + retenção legal ≥5 anos garantida; impossibilidade técnica de modificação retroativa elimina superfície de tentação."
			rationale: "Bacen é stakeholder cujo incentivo correto é estrutural (audit programática) e cuja 'manipulação' analisada é o operador tentando burlar fiscalização — bloqueado por imutabilidade + criminalização."
		}]
		rationale: """
			5 vetores cobrem participantes principais do INV: 4 sh
			econômicos (sh-01 devedor, sh-02 cedente, sh-03 funding,
			sh-05 operador) + 1 sh regulatório (sh-04 Bacen, analisado
			em sentido inverso — manipulação seria do operador contra
			o regulador, não vice-versa). Defesa estrutural primária:
			audit trail cross-BC (DLV+INV+CMT+ATO) torna manipulação
			isolada inviável; necessidade de cooperação cross-BC para
			manipulação efetiva eleva custo coordenacional adversarial
			acima do benefício individual. Vetor sh-03 (cherry-picking)
			adicionalmente alinha com tese Mesh de rede antifrágil via
			comportamento observável + ajuste sistêmico pelos peers
			(SCF/REW), não dependência de policing manual.
			"""
	}
}
