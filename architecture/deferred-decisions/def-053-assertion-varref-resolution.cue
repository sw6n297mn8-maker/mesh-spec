package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def053: artifact_schemas.#DeferredDecision & {
	id:     "def-053"
	title:  "Enforcement de resolucao #VarRef.var -> #Variable.name no #Assertion (kind recursivo ausente)"
	date:   "2026-06-07"
	status: "open"

	description: """
		A gramatica #Assertion (architecture/shared-schemas/assertion-schema.cue) exige que cada
		#VarRef.var resolva a um #Variable.name declarado no MESMO #Assertion. cue vet garante o SHAPE
		do VarRef, mas NAO a resolucao: os VarRef vivem numa arvore recursiva de predicados
		(predicate -> operands[] -> ... -> leaf.left/right -> var) e o kind
		local-field-reference-integrity (adr-100) so percorre 1 nivel (_resolve_multi: 'x[]' itera um
		nivel, sem descida recursiva), logo nao coleta todos os VarRef. Fica deferida a cobertura
		deterministica ate existir kind recursivo. DISTINTO de def-054 (gap de GRAMATICA:
		aritmetica/quantificacao) e de def-049 (mecanismo assertion-to-test); este e gap de
		ENFORCEMENT (resolucao de referencia), nao de poder de expressao nem de geracao de teste.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: review-trusted enquanto o volume de assertions e revisavel a mao -- o
		golden-example (WI-137) tem UMA assertion, conferivel por inspecao direta. Custo evitado:
		fabricar um kind recursive-field-reference-integrity (novo evaluator no runner + extensao do
		schema de structural-check) sob pressao de UM unico artefato -- o mesmo anti-pattern recusado
		no adr-144 C5 (nao criar kind por causa de uma instancia). Alternativa rejeitada: achatar com
		um campo declarado usesVariables: [...] -- a lista duplicaria a arvore de predicados (viola
		Zero Duplicacao) e poderia MENTIR sobre ela (declarar um var que a arvore nao usa, ou omitir um
		que usa), trocando um gap de enforcement por um risco de drift. Custo de continuar deferindo:
		uma assertion com VarRef pendente (var sem #Variable correspondente) passaria no cue vet ate a
		review humana pega-la -- aceitavel enquanto o numero de assertions e baixo. CASO CONCRETO: asrt-mutual-bilateral-acceptance (golden-example CMT, WI-137) e essa 1a assertion -- o binding ator/tipo-de-evento dos seus #VarRef (proposer-proposed vs counterparty-accepted) e a correlacao state+evidencias por mesmo-commitmentId vivem em filter-prosa, casos concretos desta resolucao deferida; o hand-encoded (def-049) os cobre ate o kind recursivo existir.
		"""

	triggerCalibrationRationale: """
		manual-review porque os gatilhos de revisita nao sao machine-evaluable de forma confiavel pelo
		runner hoje: 'existe kind recursivo no runner' exigiria o proprio kind que ainda nao existe, e
		'o numero de assertions tornou a review manual inviavel' nao tem limiar numerico obvio. Ambos
		dependem de julgamento. Ate la a resolucao var->variables permanece review-trusted.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-140-codegen-contracts.cue",
		"architecture/shared-schemas/assertion-schema.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			low porque so existira 1 assertion (golden-example) ate W006.3+, conferivel a mao -- sem
			volume, o gap de resolucao nao gera falso-negativo material. local porque a resolucao
			var->variables e interna a cada #Assertion (nao cross-artifact). Exit: adicionar kind
			recursive-field-reference-integrity ao runner quando o volume justificar e materializar o
			sc-check correspondente.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Revisitar quando (i) o kind recursive-field-reference-integrity for adicionado ao runner (entao materializar o sc-check de resolucao var->variables) OU (ii) o numero de assertions tornar a review manual da resolucao inviavel. Ate la, resolucao #VarRef.var -> #Variable.name e review-trusted."
	}]
}
