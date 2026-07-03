package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-014": artifact_schemas.#DeferredDecision & {
	id:    "def-014"
	title: "Maturação de tipagem para canvas communication: visibility / dedupKey / fallback como fields tipados em #InboundCommandHandler + #InboundQuerySurface + #OutboundEventPublication + #OutboundQueryDependency quando description-text source-of-truth tornar-se ambígua em scale"
	date:  "2026-05-06"

	description: """
		Phase 1.4 do WI-042 DLV bootstrap (commit c2fdcbb)
		identificou 3 semantics operacionais críticas que schema
		atual de canvas communication não suporta como fields
		tipados:

		(1) visibility: distinção entre events/commands/queries
		    cross-BC public vs internal-consumers-only vs DLV-
		    internal. Materializada em DLV via:
		    - RecordEvidence.resultingEvents [EvidenceRecorded]
		      com visibility=internal-only (DLV-internal per
		      BD4); listed em resultingEvents para satisfazer
		      schema MinItems(1), NÃO advertised como public
		      contract
		    - QueryVerificationStatus com visibility=internal-
		      consumers-only (sh-01/sh-02/DRC/audit; downstream
		      INV/REW/NIM operam apenas sobre terminal events)
		    Schema #InboundCommandHandler / #InboundQuerySurface
		    são closed structs sem visibility field — semantic
		    documentado em description text Phase 0.

		(2) dedupKey: chave de deduplicação cross-BC para
		    at-most-once observability semantics. Materializada
		    em DLV via:
		    - DeliveryVerified + DeliveryRejected outbound
		      events com dedup canonical=eventLogOffset +
		      FALLBACK identidade lógica (commitmentRef,
		      evidenceRef, eventType) cobrindo scenarios com
		      partições múltiplas / replay parcial / multi-log
		      ingestion (BD14c)
		    Schema #OutboundEventPublication é closed sem
		    dedupKey field — fallback documentado em trigger
		    description Phase 0.

		(3) fallback: comportamento de degradação graceful sob
		    falha de dependency externa. Materializado em DLV
		    via:
		    - QueryEvidenceProof (IDC dependency) OPCIONAL com
		      fail-safe fallback (integrity-unverifiable-remote
		      → DeliveryRejected, NÃO fail-open) preservando
		      invariante BD7 anti-default sob falha de IDC
		    Schema #OutboundQueryDependency é closed sem
		    fallback field — comportamento documentado em
		    purpose text Phase 0.

		Phase 0 acknowledged limitation: description-text source-
		of-truth para semantics críticas é PRAGMATICAMENTE
		aceitável quando 1 canvas declara (DLV); torna-se
		AMBÍGUO operacionalmente quando ≥3 canvases dependem
		(drift entre prosaic descriptions; readers não podem
		programatically queryar visibility/dedup/fallback;
		structural-checks não podem validar semantics).

		Quando threshold trigger fire, decidir:

		(a) Promote visibility para typed field em
		    #InboundCommandHandler.visibility + #InboundQuery
		    Surface.visibility (enum: public | internal-
		    consumers-only | internal-only). Migrar canvases
		    existentes + adicionar tq-cv-XX validating semantics
		    consistent cross-canvas.

		(b) Promote dedupKey para typed field em
		    #OutboundEventPublication.dedupKey (struct: canonical
		    + fallback strings). Permite structural-check verify
		    fallback sempre presente quando canonical é
		    eventLogOffset-based.

		(c) Promote fallback para typed field em
		    #OutboundQueryDependency.fallback (struct: behavior
		    enum + reasonCode). Permite typed expression de
		    fail-safe vs fail-open semantics; structural-check
		    pode validar fail-safe é default Phase 0 hard line.
		"""

	deferralRationale: """
		Schema enrichment é decisão arquitetural com cascade
		refactor cross-canvas — exige evidência de recurrence
		para justificar custo. Phase 0 single canvas (DLV) com
		semantics declarados em description text é blast radius
		mínimo: substância preservada via prose; tipagem segue
		quando segundo+terceiro canvases declaram patterns
		similares. Promover prematuramente cria fields tipados
		que canvases existentes (P2P/SSC/CMT/IDC) não usam —
		drift entre 'declared but unused' vs 'declared and
		used' é seu próprio problema.

		Trade-off temporal: aceitar description text source-
		of-truth Phase 0 (custo: validação manual; ambiguidade
		em scale) → promover quando evidence de scale (custo:
		cascade refactor + ADR + tooling). Phase 0 é correto
		porque evidence de recurrence ainda não existe (1
		canvas declara visibility/dedup/fallback explícitamente
		em description); aguardar 2-3 canvases adicionais
		fornece signal suficiente para justificar promotion.

		Alinhamento com princípios canônicos: blast radius
		pequeno por padrão (cascade refactor 4+ canvases
		existentes — P2P, SSC, CMT, IDC, DLV — exige ADR +
		coordenação); governança nasce junto (typing prematura
		sem evidence de recurrence cria fields underused/
		misused); preferir explicitude à conveniência
		(description text Phase 0 é explícito, embora não
		tipado).
		
		NOTA DE TRIAGEM (2026-07-03, housekeeping — decisão do founder):
		candidato PRIMEIRO da futura fatia de spec-hygiene (pressão
		crescente: recurrence visibility= atingiu 11 ocorrências em prosa,
		threshold 3). Nada agendado agora; a fatia abre por ordem do
		founder, com def-012 e def-010 na mesma janela se couberem.
		
		AMENDMENT (2026-07-03, correção de registro — decisão do founder,
		sobre pre-flight verificado em disco @ d6c5032):
		(i) O DISPARO FOI ARTEFATO DE CONTAGEM: o runner avalia recurrence
		scope=file-content como `git grep -l` REPO-WIDE
		(scripts/ci/evaluate-deferred-triggers.sh:192-198), contando
		arquivos de qualquer path — incluindo ESTE def e seus self-reviews
		(self-match). A premissa de filtro-por-path registrada no
		self-review deste def estava ERRADA. Fato: ZERO ocorrências de
		'visibility=' em qualquer contexts/*/canvas.cue (grep
		arquivo-a-arquivo, exit 1 em todos os 14); os 11 arquivos contados
		são domain-models (ecoando o campo TIPADO adjacente), ADR, PG e
		este próprio def.
		(ii) O item (a)/visibility foi RESOLVIDO POR EVOLUÇÃO em outra
		morada: o domain-model tipou visibility: "internal" | "published"
		(92 usos) com a regra cross-artifact tq-dm-11/12 (evento published
		⇔ event-publisher no canvas.communication.outbound) e o
		consumerProtocol do REW (adr-081/084). O vocabulário que este def
		propunha (public | internal-consumers-only | internal-only)
		DIVERGE do estabelecido — NÃO adotar. O def ESTREITA para os itens
		(b) dedupKey e (c) fallback.
		(iii) Sinais reais dos 2 restantes: 'dedup canonical' = 1 canvas
		(contexts/inv/canvas.cue:371); 'fail-safe fallback' = 1 canvas
		(contexts/dlv/canvas.cue, 4 ocorrências) — abaixo do critério ≥3
		canvases do próprio def. Permanecem open, sub-limiar.
		(iv) TRIGGERS: os 3 recurrence foram REMOVIDOS. manual-review é a
		forma FINAL deste def, não interina: o sinal aqui é prosa informal
		não-estruturável — sinal de prosa não se conta, se REVISA
		(fundamento da correção do runner, fatia própria).
		A NOTA DE TRIAGEM acima (housekeeping) fica CORRIGIDA por este
		amendment: a ordem 'def-014 primeiro' foi decidida sobre contagem
		defeituosa e CAI; def-012 segue como único sinal genuíno da janela.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence kind) detecta menções a 'visibility='
		em canvas communication descriptions cross-canvas.
		Threshold=3 fires quando ≥3 canvases declaram visibility
		patterns explícitos — signal claro de recurrence
		justificando typed promotion. Pattern força match em
		'visibility=' (literal assignment-style notation em
		description text), NÃO match em prose conceitual.
		Baseline pós-c2fdcbb = 1 (DLV único canvas com pattern).

		Trigger 2 (recurrence kind) detecta menções a 'dedupKey'
		ou 'dedup canonical' em descriptions cross-canvas.
		Threshold=3 mesmo critério. Baseline = 1 (DLV).

		Trigger 3 (recurrence kind) detecta menções a 'fail-safe
		fallback' em descriptions de query-dependencies cross-
		canvas. Threshold=3 mesmo critério. Baseline = 1 (DLV).

		Trigger 4 (manual-review) escape para founder revisita
		quando arquitetura cross-BC madura suficientemente para
		formalizar communication contract typing como camada
		dedicada (e.g., separate ADR + structural-checks
		dedicados a integration semantics). Trigger automático
		não cabe aqui porque maturação arquitetural é judgment
		founder, não condição machine-evaluable.

		Pattern self-match check: este def-014 description usa
		'visibility', 'dedupKey', 'fallback' em prose conceitual
		(menções argumentativas) — não em assignment-style
		notation 'visibility=...' que triggers procuram. Verified
		por inspeção: triggers procuram literal 'visibility='
		(equals sign), não 'visibility' (palavra solta). 'dedup
		canonical' aparece em def-014 description mas escopo do
		trigger é 'file-content' que conta arquivos com matches
		— def-014 não é canvas communication; runner pattern
		match em scope file-content de canvas paths apenas
		filtra por path matching (canvases vivem em contexts/*/
		canvas.cue, não em architecture/deferred-decisions/).
		"""

	originatingArtifacts: ["contexts/dlv/canvas.cue"]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Severity low porque description text Phase 0 preserva
			SUBSTÂNCIA semântica completamente — visibility/dedup/
			fallback semantics são lidas e respeitadas por
			implementadores; gap é em VALIDATION ESTRUTURAL (cue
			vet não pode enforce visibility consistent cross-
			canvas). Manual review + code review absorvem cost
			Phase 0 com 1 canvas declarando.

			BlastRadius local porque escopo é canvas communication
			subsystem (architecture/artifact-schemas/canvas.cue +
			canvas instances em contexts/*/canvas.cue); outros
			artifact types não afetados. Promotion Phase 1+ é
			cascade refactor moderado (4-7 canvases existentes
			até lá) mas bounded — não atinge schemas
			transversais ou tooling core.
			"""
	}

	// AMENDMENT 2026-07-03 (decisão do founder): os 3 triggers recurrence
	// foram REMOVIDOS — dispararam por artefato de contagem (runner
	// repo-wide + self-match; ver deferralRationale). manual-review é a
	// forma FINAL deste def, não interina: o sinal remanescente (dedupKey/
	// fallback em prosa de canvas) é prosa informal não-estruturável —
	// sinal de prosa não se conta, se REVISA.
	triggers: [{
		kind:   "manual-review"
		reason: "Forma FINAL (não interina) per amendment 2026-07-03: o sinal deste def é prosa informal de canvas — não-estruturável, logo não-contável; sinal de prosa se revisa, não se conta. Founder revisita quando arquitetura cross-BC madura suficientemente para formalizar canvas communication contract typing como camada dedicada (escopo pós-amendment: dedupKey + fallback; visibility resolvido por evolução no domain-model) — e.g., separate ADR sobre integration contract semantics + structural-checks dedicados + tooling para queries programáticas. Sinal humano: ≥3 canvases declarando os patterns em prosa (hoje: 1 cada), ou compliance/security exigindo typed contracts."
	}]

	status: "open"
}
