package governance

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

wavePlan: artifact_schemas.#WavePlan & {
	id:    "W001"
	title: "Foundation — habilitar especificação do primeiro BC"
	rationale: """
		Wave fundacional. Cria os artefatos mínimos para que o sistema
		de especificação funcione: identidade do domínio, schemas de
		validação para os tipos de artefato mais usados, subdomínios,
		context-map e o primeiro BC canvas (CMT). Ordenação por
		dependência estrutural: schemas antes de instâncias,
		domínio antes de estratégico, estratégico antes de tático.
		"""

	waves: {
		"W001-foundation": {
			id:    "W001-foundation"
			title: "Foundation — artefatos fundacionais e primeiro BC"
			rationale: "Todos os artefatos desta wave são pré-requisitos para especificar qualquer BC."

			tasks: [{
				id:         "WI-001"
				title:      "Criar domain/domain-definition.cue"
				tshirtSize: "L"
				dependsOn: []
				outputs: [{
					artifact: "domain/domain-definition.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/canvas.cue",
					"strategic/context-map.cue",
				]
				rationale: "Identidade do domínio é pré-requisito de tudo. Instância de #DomainDefinition. Define tese central, mecanismos, axiomas, flywheel, escopo."
			}, {
				id:         "WI-002"
				title:      "Validar architecture/design-principles.cue contra schema"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/design-principles.cue"
					type:     "validate"
				}]
				rationale: "design-principles.cue já existe. Validar conformidade e completude antes de ser consumido por outros artefatos."
			}, {
				id:         "WI-003"
				title:      "Validar governance/repo-structure.cue"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "governance/repo-structure.cue"
					type:     "validate"
				}]
				rationale: "repo-structure.cue já existe. Validar que cobre todos os paths necessários para W001."
			}, {
				id:         "WI-004"
				title:      "Criar schema #WavePlan"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/wave-plan.cue"
					type:     "create"
				}]
				affects: [
					"governance/wave-plan.cue",
				]
				rationale: "Schema de validação para este próprio artefato. Bootstrapping: instância é criada antes do schema, schema retrovalida a instância."
			}, {
				id:         "WI-005"
				title:      "Validar schema #ADR existente"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/adr.cue"
					type:     "validate"
				}]
				rationale: "adr.cue já existe. Validar que todos os ADRs existentes passam cue vet contra o schema."
			}, {
				id:         "WI-006"
				title:      "Validar schema #DomainDefinition existente"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/domain-definition.cue"
					type:     "validate"
				}]
				rationale: "domain-definition.cue schema já existe. Validar completude antes de WI-001 criar a instância."
			}, {
				id:         "WI-007"
				title:      "Criar instâncias de subdomínios"
				tshirtSize: "M"
				dependsOn: ["WI-012"]
				outputs: [{
					artifact: "strategic/subdomains/"
					type:     "create"
				}]
				rationale: "Subdomínios posicionam os BCs. Dependem do schema #Subdomain (WI-012)."
			}, {
				id:         "WI-008"
				title:      "Criar strategic/context-map.cue"
				tshirtSize: "M"
				dependsOn: ["WI-007"]
				outputs: [{
					artifact: "strategic/context-map.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/context-dependencies.cue",
				]
				rationale: "Context-map define topologia de integração entre BCs. Depende de subdomínios para saber quais BCs existem."
			}, {
				id:         "WI-009"
				title:      "Criar contexts/cmt/canvas.cue — primeiro BC"
				tshirtSize: "L"
				dependsOn: ["WI-001", "WI-007", "WI-011"]
				outputs: [{
					artifact: "contexts/cmt/canvas.cue"
					type:     "create"
				}]
				rationale: "Primeiro BC. CMT (Commitment Management) é o entry point do commitment lifecycle e o minimum economic loop. Depende de domain-definition (WI-001), subdomínios (WI-007) e canvas schema (WI-011)."
			}, {
				id:         "WI-010"
				title:      "Criar validation prompts fundacionais"
				tshirtSize: "M"
				dependsOn: ["WI-001", "WI-009", "WI-013"]
				outputs: [{
					artifact: "architecture/validation-prompts/validate-domain-definition.cue"
					type:     "create"
				}, {
					artifact: "architecture/validation-prompts/validate-canvas.cue"
					type:     "create"
				}]
				rationale: "Validation prompts para os dois artefatos mais críticos. Depende de domain-definition (WI-001), canvas (WI-009) e validation-prompt schema (WI-013)."
			}, {
				id:         "WI-011"
				title:      "Criar schema #Canvas"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/canvas.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/canvas.cue",
					"governance/bounded-context-completeness.cue",
				]
				rationale: "Schema de validação para BC canvas. Afeta todas as futuras instâncias e regras de completude que dependem da estrutura do canvas."
			}, {
				id:         "WI-012"
				title:      "Criar schema #Subdomain"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/subdomain.cue"
					type:     "create"
				}]
				affects: [
					"strategic/subdomains/*.cue",
				]
				rationale: "Schema de validação para subdomínios. Afeta todas as futuras instâncias."
			}, {
				id:         "WI-013"
				title:      "Criar schema #ValidationPrompt"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/validation-prompt.cue"
					type:     "create"
				}]
				affects: [
					"architecture/validation-prompts/*.cue",
				]
				rationale: "Schema de validação para validation prompts. Afeta todas as futuras instâncias."
			}]
		}
	}
}
