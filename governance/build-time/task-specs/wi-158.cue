package task_specs

taskSpecs: "WI-158": {
	version:     1
	title:       "ADR de identidade e ator — usuário, papel intra-org, tenant e identidade de agente; fixa o que todo evento grava sobre quem agiu; resolve def-024 (o 'ADR de auth' da borda) e decide o desfecho de def-080 (campo de ator estruturado)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue — a postura sem security/servers dos api.yaml aguarda ESTE ADR; resolved com resolvedBy na execução; a implementação (servidor de identidade, verificação de borda) permanece fora do mesh-spec.",
		"architecture/deferred-decisions/def-080-structure-command-actor-and-invariant-enforcement.cue — insumo: o ADR fixa a semântica do ator; mecanizar o campo per def-080 (resolver ou re-adiar com gatilho novo) é desfecho da execução, não pré-decisão.",
		"domain/stakeholder-map.cue — re-autorado pelo WI-157 (dependência dura em work-graph): os papéis intra-org que o modelo de identidade referencia.",
		"architecture/shared-schemas/envelope.cue — a localização canônica onde 'o que o evento grava do ator' aterrissa; o event log é imutável: evento sem identidade de autor não a ganha retroativamente — a razão de o ADR preceder as telas restantes.",
		"contexts/idc/domain-model.cue + contexts/bdg/glossary.cue — o modelo já reserva o lar: permissão-de-acesso é território do idc; Alçada (bdg) decide teto de valor, não permissão. O ADR confirma ou re-decide o lar explicitamente.",
		"contexts/p2p/agents/p2p-primary-agent.cue — agentes também são atores: identidade de agente (quem age, em nome de qual organização) entra no mesmo desenho, não em desenho separado.",
		"O número WI-158 deve ser re-derivado pelo freshness gate (G2 --assert WI=N) no ato da escrita; o número do ADR produzido (família adr) é re-derivado na EXECUÇÃO, não reservável ex-ante (adr-168).",
	]
	outputs: [{
		artifact: "architecture/adrs/adr-NNN-identity-and-actor-model.cue — NNN re-derivado pelo gate G2 no ato da escrita da execução (família sequencial-global não reservável ex-ante per adr-168)"
		type:     "create"
	}, {
		artifact: "architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue"
		type:     "update"
	}]
	affects: [
		"architecture/shared-schemas/envelope.cue",
		"contexts/p2p/api.yaml",
		"architecture/deferred-decisions/def-080-structure-command-actor-and-invariant-enforcement.cue",
	]
	rationale: """
		Decisão cara de retrofit tomada cedo, implementação commodity tarde:
		o event log é imutável — o que o evento grava sobre quem agiu precisa
		ser decidido ANTES das telas restantes do arco, enquanto servidor de
		login e verificação de borda ficam na trilha de produção (fora deste
		repo). O ADR desenha: usuário, papel intra-org (sobre o stakeholder-map
		do WI-157), tenant, identidade de agente, e o slot de ator no envelope.
		Resolve def-024; def-080 é decidido (resolver ou re-adiar) na execução.
		Alçada permanece teto de valor (bdg); permissão-de-acesso aterrissa no
		lar que o modelo reserva (idc), salvo decisão contrária do ADR.
		Toca critério de irreversibilidade (estrutura de isolamento entre
		tenants) — escalações do protocolo de decisões irreversíveis aplicam na
		execução. CLASSIFICAÇÃO: create de instância de #ADR (schema existente)
		→ tmpl-create-instance@v1; a execução segue o PG de ADR com section
		gates próprios.
		"""
}
