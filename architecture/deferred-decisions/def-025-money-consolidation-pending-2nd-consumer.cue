package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// ── RESOLUÇÃO (2026-05-28) ──
//
// Trigger primário disparou: contexts/inv/schemas/events.cue materializado por
// WI-131 (PR #77 mergeado em 2026-05-28). Crucialmente, INV não trouxe apenas
// um 2º consumidor — trouxe um SHAPE DIVERGENTE do que CMT havia escolhido
// inline. Sinal empírico mais rico que o trigger projetava:
//   - CMT: amount: int & >=0 (centavos integer, escala 2-decimal hard-coded)
//   - INV: amount: string regex `^[0-9]+(\.[0-9]+)?$` (decimal-string não-
//          negativo, audit-grade fiscal, currency-agnostic)
//
// Decisão (founder, pós-3-ciclos de red team): adotar lado INV (decimal-
// string) como Money canônico. Justificativa hierárquica:
//   1. Audit fiscal NÃO TOLERA precision loss — restrição mais forte que
//      "aritmética nativa mais simples" do lado int.
//   2. Currency-agnostic minor-units — int centavos quebra para JPY
//      (0-decimal), BHD/JOD (3-decimal), cripto (até 18+). decimal-string
//      é regime-independent.
//   3. CMT migration é mecânica + lossless: events ainda não shippedaram
//      em produção real (Phase 0); zero consumer externo afetado.
//   4. Aritmética CUE-nativa do lado int NÃO é loss real — operações Money
//      são em adapter/handler code, não em schema.
//
// Sub-decisões aplicadas na resolução:
//   - S1 (escala): NÃO normalizada por design. "0" e "0.00" ambos válidos.
//     Producer's choice; canonical form NÃO é parte do contrato Money.
//   - S2 (regex strict): leading zeros proibidos no integer part
//     (`^(0|[1-9][0-9]*)(\.[0-9]+)?$`). Reduz divergência cross-producer.
//   - S3 (Currency helper): #Currency: =~"^[A-Z]{3}$" isolado em money.cue
//     para reuso futuro (FX rates, regime defaults, etc.) sem refactor.
//   - S4 (CommitmentScope): NÃO promovida; é decisão CMT-domain, fora do
//     escopo desta resolução Money-shape.
//   - S5 (negativos): proibidos; credit note/refund/adjustment via eventos
//     próprios, não Money negativo silencioso.
//   - S6 (anti-stealth-extension): comentário forte em money.cue contra
//     scale/unitOfMeasure/exchangeRate locais — mesmo regime do envelope.
//
// resolvedBy aponta para money.cue (canônica per #OriginRef singular);
// refactors em CMT/INV (events.cue + async-api.yaml) são CONSEQUÊNCIA da
// resolução, não o resolvedBy canônico.

def025: artifact_schemas.#DeferredDecision & {
	id:     "def-025"
	title:  "Consolidar Money inline em architecture/shared-schemas/ quando 2º BC do slice usar"
	date:   "2026-05-28"
	status: "resolved"

	triggeredAt: "2026-05-28"
	triggeredCondition: """
		contexts/inv/schemas/events.cue criado por WI-131 (PR #77 mergeado em
		2026-05-28) — materialização do 2º consumidor real de Money, condição
		machine-evaluable do trigger primário adjacent-need (file-exists).
		Sinal empírico foi mais rico que o trigger projetava: INV não só consumiu
		Money mas declarou shape DIVERGENTE de CMT (int centavos vs decimal-
		string). Resolução escolheu lado INV (decimal-string) como canônico per
		audit-grade fiscal + currency-agnostic minor-units; CMT migrou.
		"""
	resolvedBy: "architecture/shared-schemas/money.cue"

	description: """
		Recorte do def-022: a consolidação cross-BC só executou #Envelope porque DLV
		(2º consumidor do envelope) NÃO usa Money — timestamps de DOMÍNIO em DLV são
		integer (epoch ms), valores monetários inexistem no modelo de delivery. Money
		(amount int em centavos + currency ISO 4217) permanece inline em
		contexts/cmt/schemas/events.cue, com 1 consumidor real (CMT). A consolidação
		para architecture/shared-schemas/money.cue só ganha justificativa quando um
		2º BC do slice materializar uso de Money — provavelmente INV (inventário/
		valoração), mas pode emergir antes em BDG (budget) ou BKR (broker/marketplace
		pricing). Adiar até o 2º consumidor real preserva o princípio aplicado a
		def-022: sem 2 usos concretos, generalização é prematura.
		"""

	deferralRationale: """
		MOTIVO: def-022 estabeleceu que 1 consumidor sozinho não justifica abstração
		em shared-schemas — risco de shape generalizado prematuramente sem validação
		por uso real. Money em CMT (#Money: { amount: int & >=0; currency: string &
		=~"^[A-Z]{3}$" }) é simples e local; extrair agora forçaria decisões prematuras
		(precisão decimal? minor units por moeda? negative amounts? unit-of-measure
		para non-currency value?) sem 2º consumidor para validar. RISCO de gatear
		agora: shape pode não servir INV/BDG/BKR (e.g., INV pode precisar quantity +
		unit-of-measure ao invés de amount + currency; BDG pode precisar period
		semantics). Custo de deferir: ~5 linhas duplicadas em 1 BC (CMT) enquanto não
		há 2º consumidor — reversível mecanicamente. Não-cumulativo enquanto for 1 BC
		só; cumulatividade só começa quando 2º BC materializar (que é exatamente o
		trigger). O comentário "// Money inline per def-022" no events.cue do CMT
		será atualizado para apontar para def-025 quando este PR for mergeado.
		"""

	triggerCalibrationRationale: """
		Trigger primário adjacent-need com file-exists em contexts/inv/schemas/events.cue
		por ser o candidato mais provável (canvas INV de inventário/valoração de
		commitments deve manipular Money). Runner determinístico (evaluate-deferred-
		triggers.sh) dispara annotation no PR quando o arquivo materializar. Trigger
		secundário manual-review porque Money pode emergir ANTES de INV em outro BC
		do slice (BDG/budget tem valor monetário per definição; BKR/broker pode ter
		pricing); founder precisa revisitar periodicamente caso surja um 2º consumidor
		fora do path projetado — o gate file-exists em INV não captura esse caminho.
		reason MinRunes(40)+ articula por que manual-review é apropriado neste caso
		específico (uncertainty sobre qual será o 2º consumidor real).
		"""

	originatingArtifacts: [
		"architecture/deferred-decisions/def-022-consolidate-event-envelope-money.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Money (~5 linhas: amount int >=0 + currency ISO 4217) duplicado em até 1 BC
			(CMT) enquanto não há 2º consumidor. Reversível mecanicamente: extrair pra
			architecture/shared-schemas/money.cue + trocar #Money inline por
			shared_schemas.#Money via alias (mesmo pattern do def-022 resolution).
			Não-cumulativo enquanto for 1 BC só; cumulatividade só começa quando 2º BC
			materializar (que é exatamente o trigger de revisita).
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "contexts/inv/schemas/events.cue"
		}
	}, {
		kind: "manual-review"
		reason: """
			Money pode emergir antes de INV em outro BC do slice — BDG (budget) tem
			valor monetário por definição, BKR (broker) pode ter pricing semantics.
			Founder revisita periodicamente caso 2º consumidor de Money apareça fora
			do path INV projetado; gate file-exists não captura esse caminho
			alternativo. Não é decisão estratégica permanente, é hedge contra
			incerteza sobre qual será o 2º consumidor real.
			"""
	}]
}
