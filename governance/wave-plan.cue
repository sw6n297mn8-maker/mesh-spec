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
			}, {
				id:         "WI-014"
				title:      "Criar runner de validação para context-map"
				tshirtSize: "M"
				dependsOn: ["WI-008", "WI-009", "WI-011"]
				outputs: [{
					artifact: "governance/build-time/runners/context-map-runner.cue"
					type:     "create"
				}]
				affects: [
					"strategic/context-map.cue",
				]
				rationale: "Runner valida critérios cross-collection do context-map (unicidade de codes, cobertura de ownership, BCs isolados) que não são enforceáveis pelo type system. Depende de context-map (WI-008), canvas schema (WI-011) e primeiro BC (WI-009) para ter dados reais contra os quais validar."
			}]
		}

		"W001-bc-completeness": {
			id:    "W001-bc-completeness"
			title: "BC Completeness — schemas e instâncias para completar o primeiro BC"
			rationale: "Desbloqueia os artefatos referenciados pelo canvas CMT (glossary, agent-spec, domain-model) e convenções derivadas (API specs, agent governance). Schemas antes de instâncias; domain-model primeiro por ser o mais complexo e estruturante."

			tasks: [{
				id:         "WI-020"
				title:      "Criar schema #DomainModel"
				tshirtSize: "L"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/domain-model.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/domain-model.cue",
				]
				rationale: "Schema para building blocks táticos: events, commands, invariants, VOs, aggregates, entities, policies, domain services, projections, lifecycle. Estruturante para todos os BCs."
			}, {
				id:         "WI-021"
				title:      "Criar schema #Glossary"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/glossary.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/glossary.cue",
				]
				rationale: "Schema para Ubiquitous Language local de cada BC. Canvas aponta via ubiquitousLanguageRef. Mais simples dos schemas, desbloqueia preenchimento do canvas."
			}, {
				id:         "WI-022"
				title:      "Criar schema #AgentSpec"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/agent-spec.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/agents/*.cue",
				]
				rationale: "Schema para agent specs. Canvas aponta via ownership.domainAgentSpec. Depende de saber o que o domain model expõe para definir capabilities do agente, mas o schema pode ser criado independentemente."
			}, {
				id:         "WI-023"
				title:      "Criar contexts/cmt/glossary.cue"
				tshirtSize: "S"
				dependsOn: ["WI-021"]
				outputs: [{
					artifact: "contexts/cmt/glossary.cue"
					type:     "create"
				}]
				rationale: "Primeira instância de glossary. Desbloqueia ubiquitousLanguageRef do canvas CMT. Depende do schema #Glossary (WI-021)."
			}, {
				id:         "WI-024"
				title:      "Criar contexts/cmt/agents/cmt-primary-agent.cue"
				tshirtSize: "M"
				dependsOn: ["WI-022"]
				outputs: [{
					artifact: "contexts/cmt/agents/cmt-primary-agent.cue"
					type:     "create"
				}]
				rationale: "Primeira instância de agent spec. Desbloqueia ownership.domainAgentSpec do canvas CMT. Depende do schema #AgentSpec (WI-022)."
			}, {
				id:         "WI-025"
				title:      "Criar contexts/cmt/domain-model.cue"
				tshirtSize: "L"
				dependsOn: ["WI-020", "WI-023"]
				outputs: [{
					artifact: "contexts/cmt/domain-model.cue"
					type:     "create"
				}]
				rationale: "Primeira instância de domain model. Define building blocks táticos do CMT. Depende do schema #DomainModel (WI-020) e glossary CMT (WI-023) para termos canônicos."
			}, {
				id:         "WI-026"
				title:      "Atualizar context-map domainAgentSpec para path canônico"
				tshirtSize: "S"
				dependsOn: ["WI-024"]
				outputs: [{
					artifact: "strategic/context-map.cue"
					type:     "update"
				}]
				rationale: "Canvas CMT estabeleceu convenção de domainAgentSpec por path canônico (contexts/{bc}/agents/{agent}.cue). Context-map usa ID lógico curto. Alinhar para consistência e verificabilidade por runner."
			}, {
				id:         "WI-027"
				title:      "Definir convenção OpenAPI/AsyncAPI por capability flags"
				tshirtSize: "M"
				dependsOn: ["WI-009"]
				outputs: [{
					artifact: "architecture/conventions/api-spec-convention.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/api.yaml",
					"contexts/*/async-api.yaml",
				]
				rationale: "Canvas declara hasSyncSurface e hasAsyncSurface. Convenção define como e quando gerar OpenAPI/AsyncAPI specs condicionalmente. Depende de pelo menos um canvas existir (WI-009)."
			}, {
				id:         "WI-028"
				title:      "Criar architecture/agent-governance.md"
				tshirtSize: "M"
				dependsOn: ["WI-022"]
				outputs: [{
					artifact: "architecture/agent-governance.md"
					type:     "create"
				}]
				affects: [
					"contexts/*/agents/*.cue",
				]
				rationale: "Políticas transversais de governança de agentes. Canvas referencia via globalGovernanceRef. Depende do schema #AgentSpec (WI-022) para alinhar vocabulário de governance."
			}]
		}
	}
}
