package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

fceGlossaryBoundaryFix: build_time.#SelfReviewReport & {
	reportId: "srr-fce-glossary-boundary-fix"

	artifactPath:       "contexts/fce/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-17"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 1 -- self-review self-reported de uma CORRECAO DE BOUNDARY (editorial, prosa)
			em 2 termos do glossario fce, achada pela varredura de coerencia dos 33 termos da
			campanha adr-151 (term-vs-fonte cross-BC). SRR sob nome -boundary-fix (NAO -firstclass-
			backfill: nao e backfill; NAO round do SRR de backfill existente: evento distinto
			pos-merge, append-only). O ACHADO: term-despachar-instrucao-de-pagamento e
			term-instrucao-de-pagamento-despachada diziam "despacha a PaymentInstruction ao rail
			bancario" / "ao rail" -- mas o domain-model diz "ao BKR" (cmd-dispatch L284, evt L146) e
			o boundary nomeado bd-economic-authority-not-rails diz EXPLICITAMENTE "FCE nunca toca
			rails" (o FCE despacha ao BKR; o BKR executa no rail). Termo canonico contradizendo
			boundary nomeado e exatamente o drift glossario-vs-uso que o adr-151 existe para
			prevenir -- e com o gate agora em REJECT, o glossario e fonte-de-verdade ENFORCADA, entao
			vale te-lo correto. FIX: 4 edicoes (definition + rationale dos 2 termos), "rail
			bancario"/"dispatch ao rail"/"o rail executa" -> "ao BKR"/"dispatch ao BKR"/"o BKR
			executa no rail". Escopo confirmado por grep: as outras 6 ocorrencias de "rail" sao
			legitimas (nome do BD bd-economic-authority-not-rails; "reconciliacao do rail" =
			BKR reconcilia; "liquidacao fisica do rail" = liquidacao confirmada via SettlementFinalized,
			linguagem do proprio domain-model; o enunciado "FCE nunca toca rails") e NAO foram
			tocadas. Mudanca e 100% prosa: codes/termEn/coreNoun/domainModelRefs/relatedTerms
			intocados -> G1/G3 inalterados. cue vet EXIT=0; evaluator first-class-traceability
			report VAZIO; o gate AGORA EM REJECT passa com 0 bloqueante (1a correcao sob o regime
			reject, confirmada). 0 fail, 0 warn.
			"""
	}]

	findings: {}

	summary: """
		Correcao de boundary (editorial) em 2 termos do glossario fce, achada pela varredura de
		coerencia dos 33 termos da campanha adr-151: os termos de dispatch diziam "ao rail
		bancario", contradizendo bd-economic-authority-not-rails ("FCE nunca toca rails") -- o FCE
		despacha ao BKR. Fix rail->BKR em 4 lugares (def+rationale dos 2 termos); as outras 6
		ocorrencias de "rail" sao legitimas e intocadas. Prosa pura (estrutura intocada). SRR sob
		nome -boundary-fix (append-only, evento distinto). cue vet EXIT=0; evaluator VAZIO; gate em
		reject 0 bloqueante. Estavel em 1 round.
		"""

	singleRoundRationale: """
		1 round: correcao editorial de 4 frases conformando ao #Glossary (cue vet EXIT=0), sem tocar
		estrutura (codes/termEn/coreNoun/refs intocados, G1/G3 inalterados); o achado foi verificado
		contra a fonte (domain-model cmd-dispatch + bd-economic-authority-not-rails) na varredura que
		o originou; o gate em reject foi confirmado 0 bloqueante. Nenhuma decisao nova a deliberar --
		so a correcao verificada de um drift glossario-vs-boundary.
		"""
}
