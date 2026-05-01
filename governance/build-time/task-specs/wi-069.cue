package task_specs

taskSpecs: "WI-069": {
	version:     1
	title:       "Validar e ativar infraestrutura operacional para authoring subagent-drafted (Phase 1 de adr-054)"
	templateRef: "tmpl-validate-artifact@v1"
	semanticPrerequisites: [
		"adr-054 vigente — authoring policy declarativa estabelecida",
		"governance/build-time/authoring-policy.cue materializada com entry production-guide subagent-drafted (commit 9561cea)",
		"governance/build-time/quality-gate.cue executionPolicy.rollout estendido com production-guide isolated-subagent (commit b53d661)",
		"CLAUDE.md seção 'Authoring Declarativo' regenerada per governance/claude/config.cue (commit 2764333)",
		"Meta-guide architecture/production-guides/production-guide.cue como protocol SoT canônico",
		"Infraestrutura de dispatch já validada para review subagent (artifact-schema/adr modes); production-guide review pendente primeira execução",
	]
	outputs: []
	affects: [
		"architecture/production-guides/ (futuras instâncias de PG criadas via dispatch após esta WI)",
	]
	rationale: """
		Phase 1 de adr-054. Schema #AuthoringPolicy + instância
		materializadas em Phase 0. Esta WI valida que o pipeline
		operacional de subagent-drafted authoring funciona end-to-end:
		dispatch authoring subagent → recebe draft + reasoning report →
		cue vet local → dispatch review subagent (per quality-gate.cue
		executionPolicy.rollout) → consolida findings → submete a
		founder.

		Trabalho concreto:
		(a) Validar dispatch authoring subagent: agente principal envia
		    inputContract per authoring-policy.cue (meta-guide + schema
		    + 1-3 instances + glossary BC + lens domain-specific) e
		    recebe draft conformante a outputContract.
		(b) Validar cue vet local sobre draft retornado.
		(c) Validar dispatch review subagent (separação de contexto vs
		    authoring subagent) per quality-gate.cue rollout production-
		    guide.
		(d) Validar consolidação de findings do review pelo agente
		    principal.
		(e) Validar submissão a founder com transparência completa
		    (dispatch + reasoning report + review findings).
		(f) Validar fallback policy: forçar falha cue vet ou findings
		    fail no review e confirmar retry mecanismo + manual takeover
		    path.
		(g) Estabelecer execution log para métrica de failure rate per
		    CLAUDE.md "Authoring Declarativo" transparency requirement.

		Critério de done: pipeline executa end-to-end com sucesso em
		primeira aplicação real (sugestão: domain-model production-
		guide per phasing adr-053). Failure rate observable em
		execution log.

		Sem outputs criados explicitamente (esta WI valida pipeline,
		não produz artefatos novos por si — pipeline produz). affects
		lista architecture/production-guides/ porque produção futura
		dependerá do pipeline ativado.

		Out-of-wave: WI-069 não pertence ao W001 work-graph (padrão
		WI-065/066/067/068). Sem prazo. criticality medium (default).
		Reversível por desativação do rollout entry em
		authoring-policy.cue.

		Sucesso desta WI ativa Phase 1 de adr-054 e desbloqueia primeira
		aplicação real (domain-model PG) per todo list atual.
		"""
}
