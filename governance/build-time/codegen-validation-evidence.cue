package build_time

// codegen-validation-evidence.cue -- Evidencia de execucao do golden-example
// CMT (WI-137 / W006). Schema-exempt (V1 simples em governance/build-time,
// mesmo padrao de codegen-contract): registra o RESULTADO de rodar o pipeline
// do harness validate-codegen.sh contra o golden-example. Direcao
// evidencia->declaracao (padrao agent-probe-record -> targetCanvas): este
// artefato REFERENCIA o golden-example, nunca o inverso.
//
// ESTADO: executed (run-001, 2026-06-11). A toolchain materializou no
// mesh-runtime (executavel mesh-codegen, adr-148 item 3) e os 5 passos do
// harness rodaram ate o fim a partir do checkout deste repo, com scratch
// gitignored fora da arvore (MESH_CODEGEN_SCRATCH). Gate CONTINUAR atingido
// (exit 0; 17/17 testes; zero edicao semantica do output gerado) e confirmado
// pelo founder por revisao de causa-raiz em 2026-06-11 -- nenhum dos sinais
// (a)-(e) do adr-148 disparou. Write-back aprovado pelo founder (adr-148
// item 8, handoff).

codegenValidationEvidence: {
	goldenExampleRef: "ge-cmt-mutual-acceptance"
	harnessRef:       "scripts/ci/validate-codegen.sh"

	status: "executed"

	gates: {
		continuar: "reached"
		pivotar:   "not-reached"
		abandonar: "not-reached"
	}

	execution: {
		date:          "2026-06-11T14:17:55Z"
		toolchain:     "mesh-codegen 86aef75 (mesh-runtime tools/codegen; gerador cue.Value->Kotlin per adr-146/147)"
		specCommit:    "123b83651124"
		runtimeCommit: "86aef755f30c"
		generatedKinds: ["types", "aggregate-skeleton", "port-contracts", "stubs (reference adapter hand-authored per adr-141 item 6)", "contract-tests (Tier-1 gerado + Tier-2 hand)", "assertion-tests (hand-encoded provisorio per def-049 open)"]
		generated:       true
		compiled:        true
		testsPassed:     17
		testsTotal:      17
		exitCode:        0
		rootCauseReview: "CONTINUAR -- confirmado pelo founder em 2026-06-11; revisao de causa-raiz: nenhum dos sinais (a)-(e) do adr-148 disparou; gates do adr-138 item 7 satisfeitos verbatim"
	}

	blockedBy: []

	rationale: "Resultado do primeiro run real do pipeline gerar+compilar+testar do golden-example CMT, executado pela toolchain distribuida do mesh-runtime a partir do checkout do mesh-spec, com scratch gitignored fora da arvore do spec. Gates de adr-138 item 7 avaliados mecanicamente pelo exit-map pre-fixado do harness; desfecho CONTINUAR confirmado pelo founder por causa-raiz."
}
