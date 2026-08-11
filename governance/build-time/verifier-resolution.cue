package build_time

import (
	"list"

	as "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
)

#VerifierResolution: {
	registry!: as.#VerifierRegistry

	_#refKey: {
		ref!: as.#VerifierRef
		out:  "\(ref.id)::\(ref.version)::\(ref.revision)"
	}

	_resolvableRefKeys: [
		for e in registry.events
		if e.event == "verifier-registered"
		if registry.projection.lifecycle["\(e.contract.ref.id)::\(e.contract.ref.version)"] == "active"
		if list.Contains(registry.projection.effectiveGrantKeys, "\(e.contract.ref.id)::\(e.contract.ref.version)::\(e.contract.assertionSchemaRef)")
		{"\(e.contract.ref.id)::\(e.contract.ref.version)::\(e.contract.ref.revision)"},
	]

	resolve: {
		refs!: [...as.#VerifierRef]
		out: [for r in refs {true & list.Contains(_resolvableRefKeys, (_#refKey & {ref: r}).out)}]
	}
}
