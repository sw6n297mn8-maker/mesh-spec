package readme

meta: "governance/readme": {
	canonicalPath: "governance/readme"
	purpose:       "Source of truth da estrutura do README.md (README.md é artefato derivado)."
	conventions: [
		"config.cue contém a instância; output.cue o template; schema é portfolio-wide.",
		"README.md nunca editado diretamente — regenerado por cue export.",
		"Schema conforma com portfolio-wide #ReadmeConfig adotado em governance/adopted-artifacts.cue.",
	]
	rationale: "README governado como CUE elimina drift entre landing page e filesystem; toda mudança de estrutura passa pelo mesmo gate dos demais artefatos."
}
