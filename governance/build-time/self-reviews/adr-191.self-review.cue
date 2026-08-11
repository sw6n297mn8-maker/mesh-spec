package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr191CentralizeVerifierResolution: build_time.#SelfReviewReport & {
	reportId:           "srr-adr-191"
	artifactPath:       "architecture/adrs/adr-191-centralize-verifier-resolution-mesh-local.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"
	executionMode:      "isolated-subagent"
	generatedAt:        "2026-08-11"
	roundsExecuted:     1
	maxRounds:          4
	status:             "stable"
	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 8
		infoCount: 6
		summary: "Round único via verificação adversarial isolada em 5 dimensões paralelas (referencial, PG-section-2, PG-section-3, cobertura das decisões do founder, claims de execução) DURANTE a autoria. 1 fail: blastRadius 'local' violava tq-adr-02 pela definição do próprio schema (a decisão toca 2 schemas) — recalibrado para cross-artifact. Warns materiais, todos corrigidos: âncora fantasma ('condição 4 do contrato de nascimento' não resolve para artefato — reescrita como verificação própria, família adr-062 N5); fronteira de API era convenção fingindo mecanismo (hidden é package-scoped, provado por probe — dec 4 honesta + R3 criada); dec6 'integralmente em vigor' falso quanto ao enforcement do adr-190 item 11 (precisado); R2 integrada como já-decidida em dec9/P2/rationale (flagrada; founder aprovou R2/R3); delta do upstream inflado ('sem grant' — grant é entailed por active nos dois lados; precisado para revision); yml ausente de affectedArtifacts (incluído); decs 7-9 sem prova de execução (rationale reescrito para EXIGIR a suite antes do commit — entregue: 12/12 + mutation 3/3). Pós-round, founder aplicou 3 correções finais (P1 limitada a consumidores conformes; observableSignal admite divergência com gates verdes como evidência de detector incompleto; 'importa'→'referencia/instancia')."
	}]
	findings: {}
	summary: "adr-191 (centralizar a resolução de identidade de verifier em #VerifierResolution, Mesh-local) estabilizou em 1 round: a verificação isolada rodou em paralelo à autoria, com 1 fail e 8 warns dispostos ANTES da proposta integrada, e as correções finais do founder aplicadas sobre o texto verificado. Todas as claims de execução do texto final têm prova reproduzida (ContractGate 8/8 pré/pós-migração; detector R1/R2/R3 12/12 com mutation-proof por regra; probe de package-scope; inversão do gate antigo)."
	singleRoundRationale: "Round único deliberado por instrução do founder ('não perca tempo escrevendo um self-review longo'), lastreado em verificação adversarial isolada de 5 dimensões executada durante a autoria — cobertura equivalente a múltiplos rounds, com disposição integral dos findings antes da proposta."
}
