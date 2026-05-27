package strategic

meta: "strategic": {
	canonicalPath: "strategic"
	purpose:       "Layer 1 da espec: design estratégico (subdomínios, context map, flywheel informacional, domain stories)."
	conventions: [
		"context-map.cue é SoT de relações entre BCs; manifestos em contexts/{bc}/context-dependencies.cue são derivados.",
		"informational-flywheel.cue mapeia eventos que alimentam modelos cross-BC.",
	]
	rationale: "Decomposição estratégica vive entre identidade do domínio (Layer 0) e BCs táticos (Layer 2); separação permite evoluir fronteiras sem mexer no tático."
}
