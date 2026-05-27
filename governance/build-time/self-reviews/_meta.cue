package self_reviews

meta: "governance/build-time/self-reviews": {
	canonicalPath: "governance/build-time/self-reviews"
	purpose:       "Instâncias de self-review dos artefatos submetidos a quality gate."
	conventions: [
		"Um arquivo por artefato revisado; nome no formato {artifact-slug}.self-review.cue.",
		"Conforma com governance/build-time/self-review-report.cue.",
		"CI enforça presença via scripts/ci/check-self-review.sh.",
	]
	rationale: "Container de instâncias: self-reviews são evidência operacional do quality gate e devem permanecer agrupadas sem competir com os protocolos que as governam."
}
