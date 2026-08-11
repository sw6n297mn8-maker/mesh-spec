package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr192TaskAdmissionBornReject: build_time.#SelfReviewReport & {
	reportId:           "srr-adr-192"
	artifactPath:       "architecture/adrs/adr-192-establish-task-admission-v2-born-reject.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"
	executionMode:      "isolated-subagent"
	generatedAt:        "2026-08-11"
	roundsExecuted:     1
	maxRounds:          4
	status:             "stable"
	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 2
		infoCount: 1
		summary: "Round único sobre proposta prototipada com prova completa antes da autoria (padrão C3a). 2 warns, ambos dispostos pelo founder na revisão da proposta: (a) _templateMatches era adição do agente além das duas relações aprovadas — founder APROVOU como load-bearing (sem ela, cobertura/resolvability seriam prováveis contra template arbitrário; formato de serialização confirmado como o canônico vigente de templateRef, não invenção do ADR); (b) o receipt do gate de consumerhood dizia 'N consumidor(es)' contando ARQUIVOS — over-claim observável em log de CI usado como evidência; founder mandou corrigir NO MESMO pacote para redação file-granular factual (aplicado; suite acompanhou). Info: dec 9/N1 verificados como suficientes para a distinção contrato-compilável ≠ executor-operacional exigida pelo founder ('born-reject' não pode ser lido como interceptação de toda criação real de tarefa — enforcement executor→admission é fronteira seguinte). Provas do pacote: suite admission 7/7 com o trio adversarial do founder nominal; mutation limpa por relação (1/2/1 FAIL); compat das 5 instâncias por vet; def-085 SKIP(resolved) verificado com contagem 2; detector verde com 2ª consumerhood."
	}]
	findings: {}
	summary: "adr-192 (admission born-reject V2: coerência de identidade ∧ cobertura de mandatoryVerifiers ∧ resolvability via #VerifierResolution) estabilizou em round único: a proposta foi prototipada e provada antes da autoria, os dois warns foram dispostos pelo founder na própria revisão (adição aprovada como load-bearing; receipt do gate corrigido no pacote), e o contrato é explícito sobre não ser executor — born-reject é predicado compilável; obrigar o caminho operacional a passar por ele é a fronteira seguinte."
	singleRoundRationale: "Round único deliberado, mesmo regime aprovado pelo founder em adr-191; lastreado em prototipagem prova-primeiro (suite 7/7 + mutation por relação + verificações empíricas de def-085 e do detector) e na disposição explícita dos warns pelo founder antes da materialização."
}
