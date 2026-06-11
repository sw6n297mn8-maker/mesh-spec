package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: codegen-contract e artefato declarativo em zona schema-exempt
// (sem #Type proprio, precedente subagent-execution-log); create-instance e a
// aproximacao backfill factualmente menos errada do vocabulario existente —
// nenhum template de 'contrato declarativo' existia (nem existe).
taskSpecs: "WI-134": {
	version:     1
	title:       "Definir contrato de codegen lado-spec (#Assertion + domain-model + domain-invariant → tipos/skeleton/Ports/testes)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"adr-080 aceito (domain-invariant é a camada de governança da assertion)",
	]
	outputs: [{
		artifact: "governance/build-time/codegen-contract.cue"
		type:     "create"
	}]
	affects: [
		"architecture/shared-schemas/assertion-schema.cue",
		"contexts/cmt/domain-model.cue",
		"architecture/structural-checks/cmt-domain-model.cue",
	]
	rationale: """
		Contrato spec→runtime: como #Assertion (fonte estruturada) + domain-model (building blocks) + domain-invariant (governança: coverage/runtimeGap/forbidden) viram tipos, aggregate-skeleton, contratos de Port e testes de runtime deriváveis. Zona schema-exempt governance/build-time (precedente subagent-execution-log) — sem artifact-schema first-class agora. Condição de promoção: se o contrato passar a ser referenciado por >1 wave OU governar múltiplas famílias de BC, promover a architecture/artifact-schemas/codegen-contract.cue via ADR. Depende das ADRs de stack de W005 (WI-102 toolchain, WI-103 compute) — consome, não possui. Os artefatos do CMT em affects são consumidos como fonte (leitura), não editados por este WI.
		"""
}
