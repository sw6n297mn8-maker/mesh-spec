package mesh_spec

#EnforcementLevel: "blocking" | "warning-only"
#ScopeMode: "changed-only" | "full-catalog"
#BootstrapMode: "strict" | "grace-period"
#FitnessId: string & =~"^ff-sd-[0-9]{2}$"

#ChangedPathTrigger: {
	pathRegex: string & !=""
	rationale: string & !=""
}

#FitnessEnforcementRule: {
	fitnessId:   #FitnessId
	enforcement: #EnforcementLevel
	rationale:   string & !=""
}

#BootstrapException: {
	fitnessId:  #FitnessId
	untilWave?: #Wave
	untilDate?: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
	rationale:  string & !=""
}

subdomainCIPolicy: {
	execution: {
		scope: #ScopeMode
		rationale: string & !=""
	}

	triggers?: [...#ChangedPathTrigger]

	defaultEnforcement: #EnforcementLevel
	rules?: [...#FitnessEnforcementRule]

	bootstrap: {
		mode: #BootstrapMode
		exceptions?: [...#BootstrapException]
		rationale: string & !=""
	}

	reporting: {
		emitSummary:      bool | *true
		emitPerFinding:   bool | *true
		failBuildOnError: bool | *true
		rationale:        string & !=""
	}

	rationale: string & !=""
}

subdomainCIPolicy: {
	execution: {
		scope: "changed-only"
		rationale: "Rodar apenas quando houver mudanças relevantes."
	}

	triggers: [{
		pathRegex: "^strategic/subdomains/.*\\.cue$"
		rationale: "Mudança direta em instâncias."
	}, {
		pathRegex: "^strategic/subdomain-fitness-functions\\.cue$"
		rationale: "Mudança nas FFs."
	}, {
		pathRegex: "^strategic/subdomain-ci-policy\\.cue$"
		rationale: "Mudança de policy."
	}, {
		pathRegex: "^domain/domain-definition\\.cue$"
		rationale: "Muda mechanismRefs."
	}, {
		pathRegex: "^contexts/.*/canvas\\.cue$"
		rationale: "Pode afetar coerência BC↔subdomínio."
	}]

	defaultEnforcement: "blocking"

	rules: [{
		fitnessId:   "ff-sd-09"
		enforcement: "warning-only"
		rationale:   "Autorreferência em participants não quebra invariantes centrais."
	}, {
		fitnessId:   "ff-sd-11"
		enforcement: "warning-only"
		rationale:   "Subdomínio ativo sem BC pode ser aceitável em bootstrap."
	}]

	bootstrap: {
		mode: "grace-period"
		exceptions: [{
			fitnessId: "ff-sd-02"
			untilWave: 2
			rationale: "Unicidade BC→subdomínio pode oscilar nas primeiras waves."
		}]
		rationale: "Exceções temporárias só para invariantes em churn inicial."
	}

	reporting: {
		emitSummary:      true
		emitPerFinding:   true
		failBuildOnError: true
		rationale:        "Sempre emitir findings e falhar em erro do runner."
	}

	rationale: "Policy canônica para enforcement de ff-sd-*."
}
