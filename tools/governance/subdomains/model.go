package main

type NegativeBoundary struct {
	Capability  string `json:"capability"`
	DelegatedTo string `json:"delegatedTo"`
}

type Participant struct {
	Ref             string `json:"ref"`
	RoleType        string `json:"roleType"`
	RoleDescription string `json:"roleDescription,omitempty"`
}

type DeprecationInfo struct {
	AbsorbedBy       []string `json:"absorbedBy"`
	Reason           string   `json:"reason"`
	ReversalCriteria string   `json:"reversalCriteria,omitempty"`
}

type StrategicProfile struct {
	Volatility       string `json:"volatility"`
	Complexity       string `json:"complexity"`
	Differentiation  string `json:"differentiation"`
	VolatilityDriver string `json:"volatilityDriver,omitempty"`
}

type WaveCoverage struct {
	Wave        uint   `json:"wave"`
	Scope       string `json:"scope"`
	Limitations string `json:"limitations,omitempty"`
	LegacyCode  string `json:"legacyCode,omitempty"`
}

type ExternalAdapter struct {
	Capability              string `json:"capability"`
	CurrentAdapter          string `json:"currentAdapter"`
	ApplicableWave          uint   `json:"applicableWave"`
	ProtectingPort          string `json:"protectingPort"`
	HostingContext          string `json:"hostingContext"`
	InternalizationCriteria string `json:"internalizationCriteria"`
}

type DeferredCapability struct {
	Capability       string `json:"capability"`
	TargetWave       uint   `json:"targetWave"`
	Reason           string `json:"reason"`
	Wave0Preparation string `json:"wave0Preparation,omitempty"`
}

type DistributedOwnership struct {
	Mechanism      string   `json:"mechanism"`
	Responsibility string   `json:"responsibility"`
	SharedWith     []string `json:"sharedWith"`
}

type BoundedContextMapping struct {
	Ref        string   `json:"ref"`
	Formality  string   `json:"formality"`
	Aggregates []string `json:"aggregates,omitempty"`
}

type Subdomain struct {
	Code                    string                  `json:"code"`
	Name                    string                  `json:"name"`
	Type                    string                  `json:"type"`
	Status                  string                  `json:"status"`
	Aliases                 []string                `json:"aliases,omitempty"`
	Definition              string                  `json:"definition"`
	Purpose                 string                  `json:"purpose"`
	NegativeBoundaries      []NegativeBoundary      `json:"negativeBoundaries,omitempty"`
	Participants            []Participant            `json:"participants,omitempty"`
	DistributedOwnership    []DistributedOwnership   `json:"distributedOwnership,omitempty"`
	StrategicLayer          string                  `json:"strategicLayer"`
	CrossCutting            bool                    `json:"crossCutting"`
	CrossCuttingDescription string                  `json:"crossCuttingDescription,omitempty"`
	CrossCuttingLayers      []string                `json:"crossCuttingLayers,omitempty"`
	GraphRole               string                  `json:"graphRole,omitempty"`
	StrategicProfile        *StrategicProfile       `json:"strategicProfile,omitempty"`
	MechanismRefs           []string                `json:"mechanismRefs,omitempty"`
	MoatTypes               []string                `json:"moatTypes,omitempty"`
	BusinessOutcomes        []string                `json:"businessOutcomes,omitempty"`
	BoundedContexts         []BoundedContextMapping `json:"boundedContexts,omitempty"`
	WaveCoverage            []WaveCoverage          `json:"waveCoverage,omitempty"`
	ExternalAdapters        []ExternalAdapter       `json:"externalAdapters,omitempty"`
	DeferredCapabilities    []DeferredCapability    `json:"deferredCapabilities,omitempty"`
	Deprecation             *DeprecationInfo        `json:"deprecation,omitempty"`
}

type FitnessFunction struct {
	ID                   string `json:"id"`
	Description          string `json:"description"`
	Severity             string `json:"severity"`
	Rationale            string `json:"rationale"`
	AlgorithmDescription string `json:"algorithmDescription"`
}

type ChangedPathTrigger struct {
	PathRegex string `json:"pathRegex"`
	Rationale string `json:"rationale"`
}

type FitnessEnforcementRule struct {
	FitnessID   string `json:"fitnessId"`
	Enforcement string `json:"enforcement"`
	Rationale   string `json:"rationale"`
}

type BootstrapException struct {
	FitnessID string `json:"fitnessId"`
	UntilWave *uint  `json:"untilWave,omitempty"`
	UntilDate string `json:"untilDate,omitempty"`
	Rationale string `json:"rationale"`
}

type ExecutionPolicy struct {
	Scope     string `json:"scope"`
	Rationale string `json:"rationale"`
}

type BootstrapPolicy struct {
	Mode       string               `json:"mode"`
	Exceptions []BootstrapException `json:"exceptions,omitempty"`
	Rationale  string               `json:"rationale"`
}

type ReportingPolicy struct {
	EmitSummary      bool   `json:"emitSummary"`
	EmitPerFinding   bool   `json:"emitPerFinding"`
	FailBuildOnError bool   `json:"failBuildOnError"`
	Rationale        string `json:"rationale"`
}

type CIPolicy struct {
	Execution          ExecutionPolicy          `json:"execution"`
	Triggers           []ChangedPathTrigger     `json:"triggers,omitempty"`
	DefaultEnforcement string                   `json:"defaultEnforcement"`
	Rules              []FitnessEnforcementRule `json:"rules,omitempty"`
	Bootstrap          BootstrapPolicy          `json:"bootstrap"`
	Reporting          ReportingPolicy          `json:"reporting"`
	Rationale          string                   `json:"rationale"`
}

type Catalog struct {
	Subdomains map[string]Subdomain `json:"subdomains"`
}

type FitnessFunctions struct {
	Functions []FitnessFunction `json:"functions"`
	Rationale string            `json:"rationale"`
}

type SubdomainSuite struct {
	Catalog          Catalog          `json:"catalog"`
	FitnessFunctions FitnessFunctions `json:"fitnessFunctions"`
	CIPolicy         CIPolicy        `json:"ciPolicy"`
}

type RawFinding struct {
	FF        string
	Subdomain string
	Message   string
}

type Finding struct {
	FF          string
	Severity    string
	Subdomain   string
	Message     string
	Enforcement string
}
