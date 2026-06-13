package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def059: artifact_schemas.#DeferredDecision & {
	id:     "def-059"
	title:  "Remover #EligibilityEmitted phantom + 2 entries de catalogo + unificar enum apos runtime migrar para #EligibilityConsumption"
	date:   "2026-06-13"
	status: "open"

	description: """
		A Etapa 3 da fatia REW reconcilia o consumo de eligibility do FCE: o fixture #EligibilityEmitted (evento
		que o REW NAO emite) e substituido pelo contrato-de-consumo #EligibilityConsumption (projecao da faceta
		eligibility de RiskEvaluationEmitted, def-057 opcao d). O rename e BREAKING: os modulos HAND do runtime
		(contexts/fce/src: PaymentSlice.kt, CompositionFixtures.kt) referenciam o tipo gerado antigo
		EligibilityEmitted, e o codegen-validation compila gerado+hand juntos no scratch (pipeline.go step 2) —
		remover o fantasma de uma vez quebraria o compile (exit 70 ABANDONAR observado no #140 head 43767f4).
		A migracao e feita ADITIVA em 3 passos (zero merge vermelho): passo 1 (este — spec) ADICIONA
		#EligibilityConsumption mantendo #EligibilityEmitted DEPRECATED + #EligibilityDecisionKind hifenizado;
		passo 2 (runtime) migra o hand para #EligibilityConsumption; passo 3 (spec) REMOVE o fantasma + as 2
		entries de catalogo (evt-eligibility-emitted, evt-risk-score-emitted) + unifica o enum (so underscore) +
		reconcilia canvas inbound + golden-example + resolve formalmente o def-057. Este DD rastreia o passo 3
		para o fantasma NAO virar permanente por esquecimento.
		"""

	deferralRationale: """
		MOTIVO de deferir a remocao: a mesma regua do split do number-support — required vermelho nao se
		mergeia; custo temporario reversivel ganha de dano permanente. Custo evitado: um merge com
		codegen-validation vermelho (exit 70, breaking) OU um override de required check. Custo de continuar
		deferindo: duplicacao temporaria no schema (#EligibilityEmitted fantasma + #EligibilityConsumption real
		coexistem; 2 entries de catalogo orfas permanecem) e um enum hifenizado morto — tudo marcado DEPRECATED
		e rastreado aqui; reversivel e auditavel por grep. A coexistencia e a unica forma de manter ambos os
		repos (spec + runtime) verdes durante a migracao cross-repo.
		"""

	triggerCalibrationRationale: """
		Trigger unico manual-review: a condicao de remocao e 'o runtime hand (PaymentSlice.kt/
		CompositionFixtures.kt) migrou para #EligibilityConsumption e nao referencia mais o fantasma' — um fato
		em OUTRO repo (mesh-runtime, passo 2), nao machine-evaluable por path ou conteudo no mesh-spec. O runner
		de triggers do mesh-spec nao ve o estado do runtime. O founder reconhece o passo 2 mergeado e dispara o
		passo 3 (remocao). file-exists/adjacent-need nao discriminam um fato cross-repo.
		"""

	originatingArtifacts: [
		"contexts/fce/schemas/events.cue",
		"contexts/fce/domain-model.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque a coexistencia e explicitamente marcada (DEPRECATED + este DD), reversivel e auditavel
			por grep; nenhum fluxo bloqueado e nenhum consumidor novo permitido no fantasma. cross-artifact
			porque a remocao (passo 3) incide sobre schema + domain-model (2 entries) + canvas inbound +
			golden-example + a resolucao do def-057, e depende do passo 2 no runtime. Exit: passo 3 apos o
			passo 2 mergeado.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "A condicao de remocao (runtime hand migrado para #EligibilityConsumption no passo 2) e um fato em mesh-runtime, fora do alcance do runner de triggers do mesh-spec; nao e machine-evaluable por path/conteudo local. Founder dispara o passo 3 ao reconhecer o passo 2 mergeado."
	}]
}
