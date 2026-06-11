package task_specs

// Task-spec materializado retroativamente (2026-06-11); o contrato original
// viveu no wave-plan + PR aprovado; fluxo founder<->agente sem task-spec a
// epoca. TRANSCRICAO do wave-plan (title/outputs/rationale verbatim), nao
// autoria nova. Par exigido por sc-wg-01 para o stream de work-events
// homonimo (backfill do ledger).
// templateRef: ge-cmt e instancia de #GoldenExample; harness script e evidence
// sao outputs acessorios do mesmo pacote (wave-plan verbatim).
taskSpecs: "WI-137": {
	version:     1
	title:       "Autorar golden-example CMT (bd-mutual-acceptance) + instância #Assertion + harness de codegen-validation + evidência"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"inv-mutual-bilateral-acceptance existe em architecture/structural-checks/cmt-domain-model.cue com assertion+forbidden+coverage.runtimeRequired",
	]
	outputs: [{
		artifact: "contexts/cmt/golden-examples/bd-mutual-acceptance.cue"
		type:     "create"
	}, {
		artifact: "scripts/ci/validate-codegen.sh"
		type:     "create"
	}, {
		artifact: "governance/build-time/codegen-validation-evidence.cue"
		type:     "create"
	}]
	affects: [
		"contexts/cmt/domain-model.cue",
		"contexts/cmt/port-manifest.cue",
	]
	rationale: """
		Golden-example microscópico de adr-138: consome o invariante já formalizado, materializa a instância #Assertion (subject/variables/predicate) do aceite bilateral + casos concretos válido/inválido. O harness gera APENAS para diretório de scratch/build ignorado e valida compile+testes; artefatos de runtime gerados NÃO são commitados no mesh-spec e o mesh-runtime NÃO é tocado (P1 estrito). Outputs versionados: golden-example CUE + script de validação + evidência CUE (CONTINUAR/PIVOTAR/ABANDONAR) — nunca o código gerado. [Escopo B+C] WI-137 entrega o LADO-SPEC: declaração (golden-example) + #Assertion + harness-script + evidence-pending; a EXECUÇÃO VIVA (gerar+compilar+testar → gate real) é downstream, bloqueada por toolchain (adr-139 deferiu vendor/runtime; def-040 open) + mesh-runtime ausente do escopo, rastreada por def-055 + gates adr-138. Sem split formal 137a/137b — nota de escopo.
		"""
}
