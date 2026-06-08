package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

wavePlanWi135Reconciliation: build_time.#SelfReviewReport & {
	reportId: "srr-wave-plan-wi-135-portmanifest-reconciliation"

	artifactPath:       "governance/wave-plan.cue"
	artifactSchemaPath: "architecture/artifact-schemas/wave-plan.cue"
	artifactType:       "wave-plan"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-06-08"

	roundsExecuted: 1
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review da emenda C1 ao wave-plan: reconciliacao de WI-135 (texto #ServiceContract stale,
			escrito pre-adr-141) para #PortManifest. adr-141 item 4 tornou PortManifest a SoT exclusiva de
			superficie de Port; EventLogPort e Port de infra (P7), nao API externa de BC -- #ServiceContract
			seria miscategorizacao (refs de #ServiceContract resolvem no domain-model; ops de Port nao sao
			cmd/evt/qry de dominio). 6 edicoes de reclassificacao: output WI-135 (service-contract.cue ->
			port-manifest.cue), titulo + rationale WI-135, WI-137.affects, nota de fronteira em WI-140
			(fan-out exclui o CMT; arquivo per-BC unico), e rationale da sub-wave (L2086). Verificado:
			dependsOn WI-137<-WI-135 INTACTO (real-options preservado -- golden-example depende so da fatia
			CMT, nao do fan-out WI-140); _depsCheck/_allTaskIDs do #WavePlan continuam resolvendo (cue vet
			pass); varredura de eco confirmou zero residuo de #ServiceContract descritivo do CMT-Port (so a
			nota de obsolescencia intencional sobrevive). Emenda de PLANO, nao de instancia (a instancia e
			WI-135 C2, separado).
			"""
	}]

	findings: {}

	summary: """
		Emenda C1 do wave-plan: reconciliacao WI-135 #ServiceContract -> #PortManifest per adr-141 item 4.
		Self-review LIMPO (0 fail/warn/info): 6 edicoes coerentes, dependsOn WI-137<-WI-135 intacto, zero
		residuo de eco, cue vet pass. Reclassificacao de plano; nao materializa a instancia (C2). NOTA: o
		gate check-self-review nao exigia SRR fresco (chaveia artifactPath >= 1 SRR; ha 6 SRRs de wave-plan);
		este SRR e per-change por disciplina/transparencia, consistente com os 6 existentes.
		"""

	singleRoundRationale: """
		1 round: a emenda e reconciliacao de texto do plano (reclassificar o artefato de WI-135 de
		#ServiceContract para #PortManifest per adr-141 item 4) sem alterar topologia de dependencias --
		dependsOn intacto, _depsCheck resolve, cue vet pass, eco zero. Nada a iterar.
		"""
}
