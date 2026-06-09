package build_time

// codegen-validation-evidence.cue -- Evidencia de execucao do golden-example CMT
// (WI-137 / W006). Schema-exempt (V1 simples em governance/build-time, mesmo
// padrao de codegen-contract): registra o RESULTADO de rodar o harness
// validate-codegen.sh contra o golden-example. Direcao evidencia->declaracao
// (padrao agent-probe-record -> targetCanvas): este artefato REFERENCIA o
// golden-example, nunca o inverso.
//
// ESTADO: pending. A execucao viva (gerar+compilar+testar -> gate real de adr-138
// item 7) esta DEFERIDA -- toolchain indecisa (adr-139; def-040 open) +
// mesh-runtime ausente do escopo. Os gates CONTINUAR/PIVOTAR/ABANDONAR ainda NAO
// foram avaliados. def-055 governa a revisita: seu trigger adjacent-need
// file-exists dispara quando validate-codegen.sh existe (anota o PR), mas a
// EXECUCAO e SEPARADA -- este artefato so carrega um gate real quando a toolchain
// materializar e o harness rodar ate o fim.

codegenValidationEvidence: {
	goldenExampleRef: "ge-cmt-mutual-acceptance"
	harnessRef:       "scripts/ci/validate-codegen.sh"

	status: "pending"

	gates: {
		continuar: "not-evaluated"
		pivotar:   "not-evaluated"
		abandonar: "not-evaluated"
	}

	blockedBy: [
		"toolchain de codegen indecisa: adr-139 deferiu vendor/runtime; def-040 (runtime HTTP) open; linguagem-alvo + gerador CUE->codigo + test runner nao fixados.",
		"mesh-runtime ausente do escopo desta sessao -- nao ha onde rodar gerar+compilar+testar.",
	]

	rationale: "Registra o ESTADO da prova P1 do golden-example CMT, nao o resultado (que exige execucao viva). status pending + gates not-evaluated sao honestos: o experimento esta montado (lado-spec) mas nao executado. def-055 rastreia a revisita; os gates de adr-138 item 7 governam o desfecho (CONTINUAR/PIVOTAR/ABANDONAR) quando a toolchain existir. evidencia->declaracao: referencia ge-cmt-mutual-acceptance."
}
