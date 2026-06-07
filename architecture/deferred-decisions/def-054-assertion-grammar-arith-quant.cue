package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def054: artifact_schemas.#DeferredDecision & {
	id:     "def-054"
	title:  "Expressividade da gramatica #Assertion: aritmetica multi-termo + quantificacao sobre colecao"
	date:   "2026-06-07"
	status: "open"

	description: """
		A gramatica #Assertion (architecture/shared-schemas/assertion-schema.cue) hoje tem
		#Term = #VarRef | #Literal e predicados booleanos (leaf + and/or/implies/not). Faltam dois
		construtos: (a) #ArithExpr -- aritmetica multi-termo (sum/sub/mul/div) para invariants como
		conservation (valor_face = liquido + desagio + taxa) e double-entry do ledger
		(sum(debitos) = sum(creditos)); (b) quantificacao sobre colecao (forall/exists com predicado
		interno sobre os elementos). Ambas as extensoes sao ADITIVAS: somar #ArithExpr ao disjunto
		#Term, ou um novo no de predicado quantificado, nao quebra instancias existentes. DISTINTO de
		def-053 (gap de ENFORCEMENT: resolucao var->variables) e de def-049 (mecanismo
		assertion-to-test); este e gap de GRAMATICA (poder de expressao).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: real-options / menor-experimento. O golden-example (WI-137, aceite
		bilateral) e PURAMENTE booleano -- exists + exists + eq de hashes -- nao usa aritmetica nem
		quantificacao sobre colecao. Conservation e double-entry so aparecem com FCE/ledger (W006.3+).
		Desenhar uma gramatica recursiva de expressoes aritmeticas e quantificadores SEM uma instancia
		que a exercite e design contra a hipotese: superficie nao validada, risco de modelar a
		abstracao errada antes do caso concreto. Custo evitado: complexidade de gramatica (arvore
		aritmetica + binders de quantificacao + a geracao de teste correspondente) antes de ter um
		invariant que a use. Custo de continuar deferindo: invariants que precisem de
		aritmetica/quantificacao nao podem ser expressos estruturadamente -- voltariam a texto livre --
		ate a extensao chegar; aceitavel porque nenhum invariant ASSIM esta na fila ate FCE/ledger.
		"""

	triggerCalibrationRationale: """
		manual-review porque o gatilho -- 'o primeiro invariant que exija comparacao aritmetica
		multi-termo OU quantificacao sobre colecao' -- depende de julgamento de modelagem ao autorar o
		invariant, nao de um sinal machine-evaluable no repo. A
		lens-testing-and-validation-for-financial-systems ja flagou conservation/double-entry como
		invariants fundamentais; eles serao o gatilho natural quando FCE/ledger forem modelados.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-140-codegen-contracts.cue",
		"architecture/shared-schemas/assertion-schema.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			low porque nenhum invariant na fila ate FCE/ledger (W006.3+) precisa de aritmetica ou
			quantificacao -- a ausencia nao bloqueia o golden-example nem qualquer assertion atual.
			cross-cutting porque a gramatica #Assertion e compartilhada: quando a extensao chegar,
			habilita invariants aritmeticos/quantificados de varios BCs (FCE, ledger, ATO). Exit: somar
			#ArithExpr / no quantificado (aditivo) no primeiro invariant que exija.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Revisitar no primeiro invariant que exija (i) comparacao aritmetica multi-termo (conservation, double-entry) OU (ii) quantificacao sobre colecao com predicado interno -- entao estender #Term com #ArithExpr e/ou adicionar o no de predicado quantificado (mudanca aditiva)."
	}]
}
