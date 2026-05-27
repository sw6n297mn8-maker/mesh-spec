package structural_checks

meta: "architecture/structural-checks": {
	canonicalPath: "architecture/structural-checks"
	purpose:       "Checks estruturais determinísticos executados pós-commit como gate (P10)."
	conventions: [
		"Um arquivo por tipo de artefato coberto; nome casa o tipo (canvas.cue cobre #Canvas).",
		"4 kinds suportados: required-block, reference-exists, same-artifact-consistency, conditional-file-presence.",
		"Apenas structural-checks podem bloquear o fluxo; validation-prompts são advisory.",
	]
	rationale: "Gate determinístico separado de revisão semântica é consequência de P10 — LLM recomenda, regra bloqueia."
}
