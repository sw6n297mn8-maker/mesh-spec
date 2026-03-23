package mesh_spec

#SubdomainType: "core" | "supporting" | "generic"
#SubdomainStatus: "active" | "deprecated"

#SubdomainRef: string & =~"^[A-Z]{2,5}$"
#BoundedContextRef: string & =~"^[a-z][a-z0-9-]*$"

#StrategicLayer: "L0" | "L1" | "L2" | "L3" | "L4"
#GraphRole: "hub" | "downstream-dominant" | "flywheel" | "gateway" | "terminal" | "standard"

#MoatType: "data" | "ai" | "ecosystem" | "pricing" | "regulatory"
#BusinessOutcome: "cheaper-credit" | "automatic-governance" | "self-organizing-chains" | "integrated-execution"

#Volatility: "low" | "moderate" | "high"
#ComplexityProfile: "simple" | "complicated" | "complex"
#Differentiation: "high" | "moderate" | "low"

#Wave: uint & >=0

#StrategicProfile: {
	volatility:      #Volatility
	complexity:      #ComplexityProfile
	differentiation: #Differentiation
	volatilityDriver?: string
}

#NegativeBoundary: {
	capability:  string & !=""
	delegatedTo: #SubdomainRef
}

#ParticipantRole: "event-consumer" | "rule-contributor" | "data-enricher" | "validator" | "observer" | "other"

#Participant: {
	ref:      #SubdomainRef
	roleType: #ParticipantRole
	roleDescription?: string
	if roleType == "other" {
		roleDescription: string & !=""
	}
}

#DeprecationInfo: {
	absorbedBy: [...#SubdomainRef] & [_, ...]
	reason:     string & !=""
	reversalCriteria?: string
}

#WaveCoverage: {
	wave:         #Wave
	scope:        string & !=""
	limitations?: string
	legacyCode?:  string
}

#ExternalAdapter: {
	capability:              string & !=""
	currentAdapter:          string & !=""
	applicableWave:          #Wave
	protectingPort:          string & =~"^[A-Z][a-zA-Z]*Port$"
	hostingContext:          #BoundedContextRef
	internalizationCriteria: string & !=""
}

#DeferredCapability: {
	capability:       string & !=""
	targetWave:       #Wave
	reason:           string & !=""
	wave0Preparation?: string
}

#DistributedOwnership: {
	mechanism:      string & !=""
	responsibility: string & !=""
	sharedWith:     [...#SubdomainRef] & [_, ...]
}

#BoundedContextMapping: {
	ref:       #BoundedContextRef
	formality: "formal" | "provisional"
	aggregates?: [...string & !=""]
}

#Subdomain: {
	code:   #SubdomainRef
	name:   string & !=""
	type:   #SubdomainType
	status: #SubdomainStatus

	aliases?: [...string & !=""]

	definition: string & !=""
	purpose:    string & !=""

	negativeBoundaries?:   [...#NegativeBoundary]
	participants?:         [...#Participant]
	distributedOwnership?: [...#DistributedOwnership]

	strategicLayer: #StrategicLayer
	crossCutting:             bool | *false
	crossCuttingDescription?: string
	crossCuttingLayers?:      [...#StrategicLayer]
	graphRole:                #GraphRole | *"standard"

	strategicProfile?: #StrategicProfile
	mechanismRefs?:    [...string & =~"^mech-[a-z][a-z0-9-]*$"]
	moatTypes?:        [...#MoatType]
	businessOutcomes?: [...#BusinessOutcome]

	boundedContexts?:      [...#BoundedContextMapping]
	waveCoverage?:         [...#WaveCoverage]
	externalAdapters?:     [...#ExternalAdapter]
	deferredCapabilities?: [...#DeferredCapability]

	deprecation?: #DeprecationInfo

	if status == "deprecated" {
		deprecation: #DeprecationInfo
	}
	if status == "active" {
		deprecation?: _|_
	}
	if crossCutting == true {
		crossCuttingDescription: string & !=""
		crossCuttingLayers: [...#StrategicLayer] & [_, ...]
	}
	if status == "active" if type != "generic" {
		businessOutcomes: [...#BusinessOutcome] & [_, ...]
		strategicProfile: #StrategicProfile
	}
	if status == "active" if type == "core" {
		moatTypes: [...#MoatType] & [_, ...]
		strategicProfile: volatilityDriver: string & !=""
	}
	if status == "active" if type != "generic" {
		mechanismRefs: [...string & =~"^mech-[a-z][a-z0-9-]*$"] & [_, ...]
	}
}
