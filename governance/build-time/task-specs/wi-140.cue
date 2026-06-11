package task_specs

// Task-spec de WI-140 materializado em 2026-06-11 para TRABALHO VIVO (fatia-2,
// DLV) -- nao e backfill: o claim no stream wi-140 e desta data. TRANSCRICAO
// do wave-plan (title/outputs/prereqs/affects/rationale verbatim).
// NOTA DE REGISTRO: a fatia-1 (contexts/cmt/aggregate-manifests/am-commitment.cue,
// commit ec0aadf / PR #124) foi executada ANTES do registro deste task-spec e
// do stream -- pre-registro declarado no rationale do proprio artefato e no
// stream wi-140. Este task-spec passa a governar as fatias subsequentes.
taskSpecs: "WI-140": {
	version:     1
	title:       "Materializar instâncias de PortManifest/AggregateManifest por BC/aggregate"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"adr-144 vigente (PortManifest/AggregateManifest como ArtifactTypes governados: schemas, production-guides, structural-checks materializados)",
	]
	outputs: [{
		artifact: "contexts/{bc}/port-manifest.cue"
		type:     "create"
	}, {
		artifact: "contexts/{bc}/aggregate-manifests/am-*.cue"
		type:     "create"
	}]
	affects: [
		"architecture/structural-checks/manifest-conformance.cue",
		"architecture/structural-checks/manifest-ref-integrity.cue",
	]
	rationale: """
		Downstream de adr-144 (cria os tipos) + WI-103 (kernel/Ports). Materializa um PortManifest por BC que consome Port e um AggregateManifest por aggregate; ativa os 5 structural-checks (saem de verde-vácuo). Não crava quais BCs/aggregates — descoberta de autoria. dependsOn WI-103 (a superfície de Port precisa do kernel); a existência dos tipos vem de adr-144 (semanticPrerequisite, pois adr-144 não é WI). FRONTEIRA com WI-135: o fan-out EXCLUI o CMT EventLogPort PortManifest (já materializado por WI-135); WI-140 cobre os DEMAIS BCs. Arquivo per-BC único (contexts/{bc}/port-manifest.cue) impede coexistência no CMT.
		"""
}
