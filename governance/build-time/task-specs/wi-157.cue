package task_specs

taskSpecs: "WI-157": {
	version:     1
	title:       "Re-autoria do stakeholder-map (resolve def-076) — instância re-unificada com o schema evoluído; separa os papéis intra-organização do lado-comprador (engenheiro requisitante, comprador, gestor aprovador) hoje absorvidos em sh-01"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/deferred-decisions/def-076-stakeholder-map-schema-drift.cue — o deferimento que esta fatia resolve (status → resolved com resolvedBy na execução): a instância não unifica com o schema evoluído.",
		"domain/stakeholder-map.cue — a instância com drift; sh-01/sh-02 são os actorRefs consumidos pela domain story: a re-autoria preserva os ids consumidos ou registra a migração das refs no mesmo commit.",
		"architecture/artifact-schemas/stakeholder-map.cue — o schema evoluído contra o qual a instância re-unifica; stakeholder-map é governedType do self-review CI (report pareado obrigatório na execução).",
		"architecture/adrs/adr-172-participant-roles-are-positional.cue — item 5: papéis intra-org 'Phase 0 absorbed em sh-01'; esta fatia encerra a absorção; papéis inter-participante permanecem posicionais (não re-decidir).",
		"strategic/domain-stories/buyer-procurement-journey.cue — o passo 9 (gestor revisa e aprova) exige a separação preparador×aprovador que hoje não existe no mapa.",
		"O número WI-157 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; se divergir, STOP.",
	]
	outputs: [{
		artifact: "domain/stakeholder-map.cue"
		type:     "update"
	}, {
		artifact: "architecture/deferred-decisions/def-076-stakeholder-map-schema-drift.cue"
		type:     "update"
	}]
	affects: [
		"strategic/domain-stories/buyer-procurement-journey.cue",
		"contexts/p2p/agents/p2p-primary-agent.cue",
	]
	rationale: """
		Fundação do braço de identidade do arco jornada→produção: o passo 9 da
		story (aprovação do gestor) está bloqueado no modelo porque preparador
		(comprador) e aprovador (gestor) são o mesmo sh-01 — absorção Phase 0
		declarada pelo adr-172 item 5, apontada pelo rationale do passo 9 da
		story e pelo agent-spec do p2p. A re-autoria re-unifica a instância com
		o schema (fim do drift do def-076) E materializa os papéis intra-org do
		lado-comprador — pré-requisito semântico duro do ADR de identidade
		(WI-158, dependência em work-graph). Affects: story e agent-spec citam
		sh-01/def-076 e podem exigir retoque de refs (impacto indireto, não
		output garantido). CLASSIFICAÇÃO: update de instância de schema
		existente → tmpl-create-instance@v1.
		"""
}
