package build_time

// codegen-contract.cue -- Contrato declarativo de codegen spec->runtime (WI-134).
//
// STATUS: V1 ACCEPTED (adr-140 promovido 2026-06-11 -- golden-example resolveu
// a hipotese P1/codegen com gate CONTINUAR; ver codegen-validation-evidence).
// adr-141 ACCEPTED (2026-06-12 -- condicao N5(a): >=2 Ports exercitados por
// contract-tests reais, EventLog + Evidence; ver N5 no adr-141).
//
// AUTORIZADO POR: adr-140 (pipeline de codegen; ContractGate; #Assertion
// first-order) + adr-141 (5 Ports, PortResult, manifests, aggregate skeleton)
// + adr-146 (P14: domain-types gerados do cue.Value direto; .proto/Ion/JSON
// para compat/wire/exit, nao para tipos). Sem ADR proprio (instanciacao dessas decisoes) e sem
// #Type/_schema.location (schema-exempt; precedente subagent-execution-log).
// Promocao a architecture/artifact-schemas/codegen-contract.cue via ADR so
// quando referenciado por >1 wave OU governar multiplas familias de BC.
//
// ESCOPO: contrato DECLARATIVO (mapa inputs->outputs), NAO engine de codegen.
// Output vive no mesh-runtime, nunca committado aqui (P1 estrito).
//
// LENTES: testing-and-validation-for-financial-systems (convergencia de testes
// Tier-1 + assertion) + technical-debt-as-strategic-instrument (override budget
// como divida deliberada-prudente).
//
// FRONTEIRA ATIVA: o mecanismo concreto assertion->test continua deferido a
// def-049; criar este arquivo DISPARA o trigger file-exists de def-049
// (anotacao no runner), mas NAO o resolve -- a resolucao e decisao do founder.

codegenContract: {
	version: "v1"

	// Tipado para tornar a transicao verificavel: status migra quando o
	// golden-example (WI-137) resolve a hipotese; resolvida em run-001
	// (gate CONTINUAR, ver codegen-validation-evidence).
	status: "accepted"

	authorizedBy: ["adr-140", "adr-141", "adr-146", "adr-148"] // proveniencia; sem ADR proprio (instanciacao); adr-148 autoriza a secao (2b) toolchain

	// (2) INPUTS -- consumidos read-only; localizacao canonica de cada um.
	inputs: {
		assertion: {ref: "#Assertion", source: "architecture/shared-schemas/assertion-schema.cue"} // regras estruturadas -> testes
		domainModel: {source: "contexts/{bc}/domain-model.cue", provides: ["command", "event", "aggregate", "valueObject"]}
		domainInvariant: {source: "architecture/structural-checks/{bc}-domain-model.cue", provides: ["assertion", "coverage", "runtimeGap", "forbidden"]}
		portManifest: {ref: "#PortManifest", source: "contexts/{bc}/port-manifest.cue"} // adr-144
		aggregateManifest: {ref: "#AggregateManifest", source: "contexts/{bc}/aggregate-manifests/am-*.cue"} // adr-144
		portModel: {authority: "adr-141", provides: ["5 Ports", "PortResult<T>", "value classes"]}
	}

	// (2) TRANSFORM -- estagios declarativos (o que -> o que + ADR que autoriza); NAO engine.
	transform: [
		{stage: "contracts", from: "CUE SoT", via: "cue.Value direto p/ domain-types (P14, adr-146); .proto/Ion/JSON servem compat/wire/exit, nao geram tipos", to: "tipos + validadores + stubs", authority: "adr-140 1-2; adr-146 2-3"},
		{stage: "aggregate-skeleton", from: "AggregateManifest", to: "aggregate base/skeleton", authority: "adr-141 5"},
		{stage: "port-contracts", from: "PortManifest", to: "Port contracts + Tier-1 contract-tests", authority: "adr-141 4,6"},
		{stage: "runtime-tests", from: "#Assertion + domain-invariant", to: "property-based runtime tests", authority: "adr-140 6; mecanismo -> def-049"},
	]

	// (2) OUTPUT -- onde vive (nunca aqui).
	output: {
		artifacts: ["tipos", "validadores", "stubs", "aggregate skeleton", "Port contracts", "contract-tests"]
		livesIn:       "mesh-runtime" // repo subordinado, fora de escopo
		committedHere: false          // P1 estrito: gerado NUNCA committado no mesh-spec
		goldenExample: "WI-137 gera para scratch/build ignorado; so evidencia + harness versionados"
	}

	// (2b) TOOLCHAIN -- morada e distribuicao (adr-148). A implementacao e a
	// distribuicao da toolchain de geracao pertencem ao mesh-runtime. O
	// mesh-runtime deve disponibiliza-la como executavel versionado e
	// reproduzivel. No ambiente de validacao do mesh-spec,
	// MESH_CODEGEN_TOOLCHAIN localiza esse executavel; o harness deve falhar
	// deterministicamente quando a variavel estiver ausente, nao resolver para
	// um executavel, ou quando a identidade/versao da ferramenta nao puder ser
	// registrada na evidencia. A localizacao do source da ferramenta nao faz
	// parte do contrato de invocacao. Ver adr-148.

	// (3) CONVERGENCIA DE TESTES -- Tier-1 + assertion num unico mecanismo (adr-141 6).
	testDerivation: {
		convergence:     "Tier-1 (Port contract-tests) + assertion-tests (PBT de #Assertion/domain-invariant) derivam de UM mecanismo unico"
		tier1Source:     "PortManifest obligations + taxonomia de erro"
		assertionSource: "#Assertion + domain-invariant (coverage.runtimeRequired)"
		// file-exists dispara o trigger de def-049; NAO resolve; resolucao = founder.
		concreteMechanism: {deferredTo: "def-049", boundary: "ativa"}
		provisional: "golden-example pode usar teste hand-encoded da assertion do CMT (def-049 deferralRationale) sem fixar a generalizacao"
	}

	// (4) OVERRIDE BUDGET -- divida deliberada-prudente (lens technical-debt).
	overrideBudget:          int & >=0 | *0 // teto de overrides hand-maintained (override:gerado)
	overrideBudgetRationale: "juros altos (tocado a cada codegen) + sistemica (mina P0) -> 0 agora; exceder dispara falsificationCondition adr-140; afrouxar exige ADR/def, nunca edicao local."

	// (5) break-on-schema-change -- gate determinista (P10).
	contractGate: {
		authority: "adr-140 5"
		validates: ["shape (cue vet)", "compatibility 3-camadas por familia", "consistencia dos derivados", "integridade referencial cross-family", "ownership"]
		breakOnSchemaChange: "schema incompativel com a direcao declarada por familia = build failure" // adr-140 4
		runsIn:              "mesh-runtime CI"
	}

	// def-040 (HTTP runtime) e def-041..045 (vendor-of-record) pertencem a
	// adr-140/adr-141; referenciados, nao duplicados aqui (Zero Duplicacao / P0).
	activeBoundaries: ["def-049"]

	rationale: "Autorizado por adr-140 (pipeline de codegen) + adr-141 (Port contracts); materializa P1 (codigo gerado, nunca escrito a mao, nunca committado aqui). status proposed = hipotese falsificavel validada/pivotada pelo golden-example CMT (WI-137). Lentes: testing-and-validation-for-financial-systems (convergencia Tier-1 + assertion) + technical-debt-as-strategic-instrument (override budget = divida deliberada-prudente)."
}
