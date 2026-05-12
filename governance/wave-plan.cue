package governance

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

wavePlan: artifact_schemas.#WavePlan & {
	id:    "W001"
	title: "Plan — Foundation, DDD strategic, cross-context workflows, C4, Stack"
	rationale: """
		Plano de execução abrangente cobrindo cinco grupos sequenciados:
		W001 (foundation), W002 (DDD strategic & meta gaps), W003
		(cross-context workflows expansion), W004 (C4 architecture
		CUE-derived Structurizr), W005 (stack definition).

		W001 estabelece foundation: identidade do domínio, schemas
		de validação para tipos de artefato mais usados, subdomínios,
		context-map e o primeiro BC canvas (CMT).

		W002 fecha gaps DDD strategic identificados em Red Team
		analysis: método repetível de descoberta de BCs, análise de
		volatilidade de boundaries, governança de splits/merges, event
		storming canonical, classificação de tier de ADRs strategic,
		atribuição canônica de domain expert per BC, alinhamento
		Conway/Team Topology, estabilidade de identidade de aggregate,
		refactoring strategic discipline, e drift detection operational
		de ubiquitous language.

		W003 expande cross-context-workflows além de commitment-lifecycle
		(único existente) com inventário formal + instâncias per saga
		(settlement, refund, dispute, onboarding, taxes, insurance).

		W004 instancia arquitetura C4 greenfield via CUE-derived
		Structurizr: ADR de generation strategy, schemas C4, ADR de
		container topology, L1 (system context), L2 (containers), L3
		per BC (10 BCs existentes), codegen script + CI drift detection.

		W005 define stack via ADRs em 7 dimensões (codegen toolchain,
		compute, persistence, eventing, boundaries, operability,
		frontend) + quality criteria família tq-stack-NN.

		Ordenação por dependência estrutural mantida: schemas antes de
		instâncias; domain antes de strategic; strategic antes de
		tactical; strategic completion (W002 + Conway) antes de stack
		(W005); stack antes de C4 L2/L3 (container topology depende de
		decisões de stack).
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
				title:      "Criar architecture/agent-governance.cue"
				tshirtSize: "M"
				dependsOn: ["WI-022"]
				outputs: [{
					artifact: "architecture/agent-governance.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/agents/*.cue",
				]
				rationale: "Políticas transversais de governança de agentes. Canvas referencia via globalGovernanceRef. Depende do schema #AgentSpec (WI-022) para alinhar vocabulário de governance."
			}, {
				id:         "WI-029"
				title:      "Criar schema #StakeholderMap"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/stakeholder-map.cue"
					type:     "create"
				}]
				affects: [
					"domain/stakeholder-map.cue",
				]
				rationale: "Schema para catálogo de stakeholders. Canvas referencia stakeholders via sh-*. Sem schema, refs são unverified pointers."
			}, {
				id:         "WI-030"
				title:      "Criar schema #ArchitectureCommunicationCanvas"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/architecture-communication-canvas.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/architecture-communication-canvas.cue",
				]
				rationale: "Schema para documentação técnica estruturada por BC: infrastructure transversals, tecnologia de implementação, SLA/availability, conformance tests, decisões técnicas. Complementa o canvas de negócio com perspectiva de implementação."
			}, {
				id:         "WI-031"
				title:      "Criar domain/stakeholder-map.cue"
				tshirtSize: "M"
				dependsOn: ["WI-029"]
				outputs: [{
					artifact: "domain/stakeholder-map.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/canvas.cue",
				]
				rationale: "Instância do catálogo de stakeholders. Desbloqueia refs sh-* no canvas. Depende do schema #StakeholderMap (WI-029)."
			}, {
				id:         "WI-032"
				title:      "Criar runner de validação cross-artifact"
				tshirtSize: "L"
				dependsOn: ["WI-020", "WI-021", "WI-022", "WI-011"]
				outputs: [{
					artifact: "governance/build-time/runners/cross-artifact-runner.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/canvas.cue",
					"contexts/*/domain-model.cue",
					"contexts/*/glossary.cue",
					"contexts/*/agents/*.cue",
					"strategic/context-map.cue",
				]
				rationale: "Runner generalizado que enforça quality criteria cross-artifact além do escopo do context-map runner (WI-014). Cobre integridade referencial canvas↔domain-model (tq-cv-02, tq-cv-04, tq-cv-10, tq-cv-11, tq-cv-12), domain-model↔glossary (tq-dm-11, tq-dm-12), glossary↔canvas (tq-gl-03, tq-gl-04, tq-gl-07), agent-spec↔domain-model (tq-ag-01, tq-ag-02, tq-ag-03). Complementa WI-014 que cobre apenas tq-cm-02."
			}, {
				id:         "WI-033"
				title:      "Criar shared-types.cue para tipos utilitários do package artifact_schemas"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/artifact-schemas/shared-types.cue"
					type:     "create"
				}]
				affects: [
					"architecture/artifact-schemas/agent-spec.cue",
					"architecture/artifact-schemas/canvas.cue",
					"architecture/artifact-schemas/architecture-communication-canvas.cue",
				]
				rationale: "Tipos utilitários compartilhados (#NonEmptyString, #ChannelCode, refs canônicos) estão espalhados nos arquivos que os introduziram. Centralizar em shared-types.cue elimina dependências conceituais implícitas e facilita descoberta. Migração: mover definições dos arquivos originais, que passam a consumir do shared-types. Candidatos de rollout subsequente: agent-governance.cue, glossary.cue, domain-model.cue, stakeholder-map.cue."
			}, {
				id:         "WI-034"
				title:      "Adicionar vetor de colusão e operador plataforma à incentive analysis do CMT canvas"
				tshirtSize: "M"
				dependsOn: ["WI-009"]
				outputs: [{
					artifact: "contexts/cmt/canvas.cue"
					type:     "update"
				}]
				affects: [
					"contexts/cmt/canvas.cue",
				]
				rationale: "Validação semântica vc-cv-02 detectou dois gaps: (1) colusão entre proponente e contraparte para criar compromissos fictícios que alimentam SCF — bypassa gate bilateral por design; (2) operador plataforma (sh-05, agente IA) não analisado como participante com poder assimétrico. Ambos são vetores materiais para um sistema onde CommitmentAccepted origina recebíveis financeiros."
			}, {
				id:         "WI-035"
				title:      "Criar agent-governance envelope para CMT primary agent"
				tshirtSize: "M"
				dependsOn: ["WI-024", "WI-028"]
				outputs: [{
					artifact: "contexts/cmt/agents/cmt-primary-agent.governance.cue"
					type:     "create"
				}]
				affects: [
					"contexts/cmt/canvas.cue",
					"contexts/cmt/agents/cmt-primary-agent.cue",
				]
				rationale: "Agent spec referencia governanceRef 'cmt-primary-agent' mas envelope não existe (tq-ag-09 falharia). Canvas governance scope não referencia envelope explicitamente (vc-cv-05 warn). Envelope define thresholds, blast radius caps e calibração operacional do agente."
			}]
		}

		"W001-build-tooling": {
			id:    "W001-build-tooling"
			title: "Build Tooling — infraestrutura transversal de governança do próprio sistema"
			rationale: """
				W001-build-tooling cobre infraestrutura de build e derivação
				de artefatos normativos do próprio sistema Mesh. Diferente
				de tooling de produto, estes scripts sustentam propriedades
				estruturais do sistema: determinismo, ausência de drift e
				auditabilidade de artefatos derivados.

				Sub-wave transversal às demais de W001. W001-foundation
				define o sistema; W001-bc-completeness instancia o
				sistema; W001-build-tooling garante que o sistema não
				degrade com o tempo — que foundation e BC completeness
				permaneçam consistentes com suas fontes canônicas ao
				longo da operação.

				Política de admissão (ref adr-042): scripts que alteram,
				derivam ou validam artefato versionado com papel normativo
				no sistema entram nesta sub-wave; scripts experimentais
				ou descartáveis permanecem fora do work-graph até
				promoção explícita.
				"""

			tasks: [{
				id:         "WI-065"
				title:      "Criar scripts/build/generate-claude-md.sh para regenerar CLAUDE.md a partir do CUE fonte"
				tshirtSize: "M"
				dependsOn: []
				semanticPrerequisites: [
					"adr-042 aceito — template tmpl-create-script@v1 existe e está registrado em task-governance",
					"architecture/artifact-schemas/task-template.cue com kind estendido para incluir 'create-script'",
					"governance/claude/config.cue e governance/claude/output.cue presentes e validados por cue vet",
					"Script deve usar cue export sobre o package claude (governance/claude/) como fonte única de geração",
				]
				outputs: [{
					artifact: "scripts/build/generate-claude-md.sh"
					type:     "create"
				}, {
					artifact: "CLAUDE.md"
					type:     "update"
				}]
				affects: [
					"governance/claude/config.cue",
					"governance/claude/output.cue",
				]
				rationale: "CLAUDE.md é artefato derivado de governance/claude/config.cue + governance/claude/output.cue, mas hoje é regenerado manualmente. Drift entre source CUE e derivado é risco operacional — o agente opera a partir do renderizado. Escopo mínimo: regenerar via cue export sobre o package claude, checar idempotência empírica (byte-a-byte), falhar explicitamente quando geração não reproduz conteúdo esperado. Fora de escopo (WIs futuras desta sub-wave): integração com pre-commit hook, drift detection, enforcement no CI."
			}]
		}

		// ════════════════════════════════════════════════════════════
		// W001 backfill — phases pg1, pg2, p4, p5, p0 emergent
		// (sync com work-graph.cue post-hoc — drift cleanup)
		// ════════════════════════════════════════════════════════════

		"W001-governance-ci": {
			id:    "W001-governance-ci"
			title: "Governance CI — event-validation + projeções complementares"
			rationale: "CI validation de work-events (state machines, command authority, idempotency) + projeções complementares à ready-queue (blocked-items, in-progress). Phase pg1 do work-graph; independente de phases de domínio."

			tasks: [{
				id:         "WI-015"
				title:      "Criar CI validation de work-events"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "governance/build-time/event-validation.cue"
					type:     "create"
				}]
				affects: [
					"governance/build-time/work-events/*.cue",
				]
				rationale: "Sem CI validation, regras de state machine, autoridade e idempotência existem apenas como especificação — enforcement é manual e falível. Bootstrap exception: eventos deste WI não são validados pelo CI que ele próprio cria."
			}, {
				id:         "WI-016"
				title:      "Criar projeções blocked-items e in-progress"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "governance/build-time/projections/blocked-items.cue"
					type:     "create"
				}, {
					artifact: "governance/build-time/projections/in-progress.cue"
					type:     "create"
				}]
				rationale: "Projeções complementares à ready-queue completam visibilidade do estado do sistema. Sem elas, itens bloqueados e em progresso requerem inspeção manual de event streams."
			}]
		}

		"W001-governance-robustness": {
			id:    "W001-governance-robustness"
			title: "Governance Robustness — claim expiration, completion gates, drift detection, rebuild scripts"
			rationale: "Extensões de robustez sobre infraestrutura CI criada em W001-governance-ci. Phase pg2 do work-graph; depende de pg1."

			tasks: [{
				id:         "WI-017"
				title:      "Implementar validação CI de claim expiration"
				tshirtSize: "S"
				dependsOn: ["WI-015"]
				outputs: [{
					artifact: "governance/build-time/claim-expiration-validation.cue"
					type:     "create"
				}]
				affects: [
					"governance/build-time/event-validation.cue",
				]
				rationale: "Validação de task-claim-expired como extensão do CI. Garante que eventos de expiração são válidos (commandId determinístico, referência a claim original) sem depender de scheduling central."
			}, {
				id:         "WI-018"
				title:      "Criar completion-gates e enforcement CI"
				tshirtSize: "S"
				dependsOn: ["WI-015"]
				outputs: [{
					artifact: "governance/build-time/completion-gates.cue"
					type:     "create"
				}]
				affects: [
					"governance/build-time/event-validation.cue",
				]
				rationale: "Define gates obrigatórios por tipo de artefato e estende CI para validar gatesPassed em task-completed. Sem definição formal, completionValidation aceita qualquer lista — sem enforcement real."
			}, {
				id:         "WI-019"
				title:      "Drift detection de projeções"
				tshirtSize: "S"
				dependsOn: ["WI-016"]
				outputs: [{
					artifact: "governance/build-time/projection-drift.cue"
					type:     "create"
				}]
				affects: [
					"governance/build-time/projections/*.cue",
				]
				rationale: "CI detecta divergência entre projeções commitadas e estado computado das fontes de verdade. Falha se drift > 0 — agente/humano atualiza. Alternativa rejeitada: auto-rebuild com commit automático, que viola o modelo proposta-antes-de-implementar."
			}, {
				id:         "WI-071"
				title:      "Criar script automático de rebuild para projections (in-progress + ready-queue + blocked-items)"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "scripts/ci/rebuild-projections.sh"
					type:     "create"
				}]
				affects: [
					"governance/build-time/projections/in-progress.cue",
					"governance/build-time/projections/ready-queue.cue",
					"governance/build-time/projections/blocked-items.cue",
				]
				rationale: """
					Gap identificado: projections (in-progress.cue + ready-queue.cue + blocked-items.cue)
					são reconstruídas MANUALMENTE via scan visual de work-events/. Manual rebuild custoso +
					error-prone + escala mal conforme repo cresce.

					Script proposto: input work-events + task-specs + work-graph; algorithm replay events
					per stream + compute admission/execution state + readyQueueAlgorithm; output substitui
					projections (overwrite determinístico). Idempotent + determinístico (P10).

					Criticality medium — automatiza P8 derivation; NÃO modifica source-of-truth (work-events
					permanecem canonical); reversível.
					"""
			}]
		}

		"W001-ontology-correction": {
			id:    "W001-ontology-correction"
			title: "Ontology Correction — domain-definition, subdomains expandidos, context-map v2, canvas revisões, Policy Registry ADR"
			rationale: """
				Cadeia linear de correção de ontologia raiz (WI-036→037→038→039) +
				avaliação de necessidade de Policy Registry (WI-040 derivada de WI-037).
				Phase p4 do work-graph; independente de phases de governança — correção
				de domínio pode avançar em paralelo.
				"""

			tasks: [{
				id:         "WI-036"
				title:      "Corrigir domain-definition.cue — ontologia raiz incompleta"
				tshirtSize: "L"
				dependsOn: []
				outputs: [{
					artifact: "domain/domain-definition.cue"
					type:     "update"
				}]
				affects: [
					"strategic/subdomains/",
					"strategic/context-map.cue",
					"contexts/cmt/canvas.cue",
					"contexts/ctr/canvas.cue",
					"domain/stakeholder-map.cue",
				]
				rationale: """
					domain-definition.cue ensina o sistema a pensar o domínio. O artefato atual
					exclui de outOfScope atividades que são in-scope (P2P, SSC, logística como
					atividade fim, ITC, TCM, INS, IDC) e posiciona a Mesh como 'infraestrutura
					financeira' quando a definição correta é 'sistema operacional do ciclo de
					compromissos econômicos'. Erro de ontologia raiz: tudo que deriva deste
					artefato herda o viés de escopo. Sem esta correção, expansão de subdomínios
					e reconstrução do context map operam sobre premissa estratégica incorreta.
					"""
			}, {
				id:         "WI-037"
				title:      "Expandir catálogo estratégico de subdomínios — novos BCs e revisão dos existentes"
				tshirtSize: "L"
				dependsOn: ["WI-036"]
				outputs: [{
					artifact: "strategic/subdomains/p2p.cue"
					type:     "create"
				}, {
					artifact: "strategic/subdomains/ssc.cue"
					type:     "create"
				}, {
					artifact: "strategic/subdomains/itc.cue"
					type:     "create"
				}, {
					artifact: "strategic/subdomains/tcm.cue"
					type:     "create"
				}, {
					artifact: "strategic/subdomains/ins.cue"
					type:     "create"
				}, {
					artifact: "strategic/subdomains/idc.cue"
					type:     "create"
				}]
				affects: [
					"strategic/subdomains/npm.cue",
					"strategic/subdomains/scf.cue",
					"strategic/subdomains/nim.cue",
					"strategic/subdomains/log.cue",
					"strategic/subdomains/ato.cue",
					"strategic/subdomains/fce.cue",
					"strategic/subdomains/ctr.cue",
					"strategic/subdomains/cmt.cue",
					"strategic/subdomains/bdg.cue",
					"strategic/subdomains/plt.cue",
					"strategic/subdomains/str.cue",
					"strategic/context-map.cue",
				]
				rationale: """
					Ontologia expandida (WI-036) desloca o início do ciclo econômico para antes
					do compromisso — demanda interna, sourcing, qualificação — e adiciona
					camadas de proteção, tesouraria e comércio exterior ausentes. Sem esses
					subdomínios, o context map não pode representar o macrofluxo real
					(P2P→SSC→NPM→CTR→CMT→...→ATO/TCM). Subdomínios existentes precisam
					revisão de escopo para refletir a definição expandida. Lista de novos BCs é
					candidata — decisões de fusão (IDN+DGV→IDC é nome candidato), renomeação e
					reagrupamento serão tomadas durante a execução com aprovação do founder.
					"""
			}, {
				id:         "WI-038"
				title:      "Reconstruir context-map v2 sobre ontologia expandida"
				tshirtSize: "L"
				dependsOn: ["WI-037"]
				outputs: [{
					artifact: "strategic/context-map.cue"
					type:     "update"
				}]
				affects: [
					"contexts/cmt/canvas.cue",
					"contexts/ctr/canvas.cue",
				]
				rationale: """
					Patch incremental do context map v1 não é viável porque a expansão ontológica
					desloca onde o ciclo econômico começa e quem é upstream de quem. O spine
					atual (CMT→BDG→DLV→INV→FCE) começa no meio do filme — o macrofluxo real
					inicia em P2P→SSC. Reclassificação core/supporting/generic, novos padrões
					de integração (P2P↔SSC, SSC↔NPM, INS↔CMT/SCF, TCM↔FCE) e documentação do
					macrofluxo canônico completo exigem reconstrução estruturada, não adição de
					nós a topologia existente. O context map v1 será base — não descartado.
					"""
			}, {
				id:         "WI-039"
				title:      "Revisar canvas e domain models existentes pós-expansão ontológica"
				tshirtSize: "L"
				dependsOn: ["WI-038"]
				outputs: [{
					artifact: "contexts/cmt/canvas.cue"
					type:     "update"
				}, {
					artifact: "contexts/ctr/canvas.cue"
					type:     "update"
				}]
				affects: [
					"contexts/cmt/domain-model.cue",
					"contexts/cmt/glossary.cue",
				]
				rationale: """
					Canvas CMT e CTR foram modelados com a Mesh posicionada como infraestrutura
					financeira. Com a ontologia expandida, CTR deixa de ser entrada do sistema e
					vira estágio pós-sourcing; CMT recebe novos upstream dependencies (P2P, SSC
					via CTR). Ambos precisam revisão de posicionamento no macrofluxo,
					upstream/downstream dependencies, stakeholders e commands de entrada. Domain
					model e glossary do CMT podem precisar ajustes derivados. O conteúdo
					existente é preservável — a revisão é de posicionamento e fronteiras, não
					de reescrita.
					"""
			}, {
				id:         "WI-040"
				title:      "Avaliar necessidade de Policy Registry como subdomínio supporting"
				tshirtSize: "L"
				dependsOn: ["WI-037"]
				outputs: [{
					artifact: "architecture/adrs/adr-policy-registry-decision.cue"
					type:     "create"
				}]
				affects: [
					"architecture/artifact-schemas/domain-model.cue",
					"architecture/artifact-schemas/agent-governance.cue",
					"architecture/artifact-schemas/cross-context-flow.cue",
					"strategic/subdomains/",
				]
				rationale: """
					Problema: arquitetura atual distribui políticas em 4 camadas desconectadas —
					#Policy no domain model (por BC), #AgentGovernanceEnvelope (por agente),
					policyRefs em cross-context-flows e quality gates no build-time — sem
					mecanismo formalizado de registro, versionamento e avaliação cross-BC.

					Gaps críticos: (1) avaliação cross-BC sem ponto definido; (2) enforcement
					regulatório (Bacen/LGPD/KYC/AML) sem garantia consistente; (3) sem
					versionamento unificado; (4) consistência de dados sob eventual consistency.

					Trade-off central: centralização (PLR) melhora consistência/auditabilidade
					mas introduz acoplamento sistêmico; distribuição (atual) preserva autonomia
					mas aumenta drift/inconsistência.

					Decisão: (a) criar subdomínio PLR como supporting; (b) extensões dos
					mecanismos existentes; ou (c) aceitar gaps como risco gerenciável. Output é
					ADR documentando decisão.
					"""
			}]
		}

		"W001-bc-bootstrap-core": {
			id:    "W001-bc-bootstrap-core"
			title: "BC bootstrap — 5 core BCs (DLV, FCE, NGR, NIM, REW)"
			rationale: "Bootstrap completo de artefatos de domínio (canvas + glossary + domain-model + agent-spec + agent-governance) para 5 BCs core: DLV (verificação), FCE (liquidação financeira), NGR (network growth), NIM (mechanism design), REW (risk engine). Phase p5 do work-graph; dependências comuns de schemas + golden examples WI-009/011/020/021/022/028."

			tasks: [{
				id:         "WI-042"
				title:      "Criar artefatos de domínio para Delivery & Verification (DLV)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/dlv/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/dlv/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/dlv/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/dlv/agents/dlv-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/dlv/agents/dlv-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: """
					Bootstrap completo do BC core DLV. Ordem de produção:
					canvas → glossary → domain-model → agent-spec → governance.

					Core domain — verifica execução de compromissos contra critérios acordados.
					Consome evidência operacional de LOG com integridade garantida por IDC;
					publica verificação para INV (faturamento), REW (risco), NIM (mecanismos)
					e DRC (disputas). Ponto de convergência entre evidência física e
					compromisso econômico.

					Criticality medium (default template) — não controla decisão sobre dinheiro
					nem boundary regulatório direto. Verificação é gate operacional, não
					financeiro.
					"""
			}, {
				id:         "WI-043"
				title:      "Criar artefatos de domínio para Financial Commitment Execution (FCE)"
				tshirtSize: "L"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028", "WI-046", "WI-053", "WI-062"]
				outputs: [{
					artifact: "contexts/fce/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/fce/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/fce/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/fce/agents/fce-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/fce/agents/fce-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: """
					Bootstrap completo do BC core FCE. Ordem de produção:
					canvas → glossary → domain-model → agent-spec → governance.

					Core domain — executa liquidação financeira condicionada a gates de risco
					(REW) e fatura válida (INV), com disponibilidade informada por TCM e
					settlement físico via BKR. Publica sinais de pagamento para REW, ATO e TCM.
					Ponto de convergência financeira: onde decisões de compromisso se tornam
					movimentos de dinheiro.

					Criticality high — controla decisão e movimento de dinheiro. Liquidação
					financeira regulada por Bacen/SCD. Especificação incorreta de gates ou
					condições de settlement pode gerar pagamento indevido ou bloqueio de
					operação legítima.
					"""
			}, {
				id:         "WI-044"
				title:      "Criar artefatos de domínio para Network Growth & Reach (NGR)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028", "WI-045"]
				outputs: [{
					artifact: "contexts/ngr/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/ngr/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/ngr/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/ngr/agents/ngr-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/ngr/agents/ngr-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: """
					Bootstrap completo do BC core NGR. Core domain — direciona crescimento da
					rede usando insights de NIM (inteligência de rede) e opera em parceria com
					NPM (gestão de participantes) para onboarding. Wardley evolution genesis
					— linguagem e mecanismos ainda em formação.

					Criticality medium (default template) — não controla decisão sobre dinheiro
					nem boundary regulatório. Estratégia de growth é operacional.
					"""
			}, {
				id:         "WI-045"
				title:      "Criar artefatos de domínio para Network Intelligence & Mechanism Design (NIM)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/nim/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/nim/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/nim/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/nim/agents/nim-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/nim/agents/nim-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: """
					Bootstrap completo do BC core NIM. Core domain — modela topologia e
					comportamento de rede para calibrar mecanismos de incentivo. Consome dados
					de NPM e DLV; publica ontologia de mecanismos para REW (risco) e insights
					para NGR (growth). Wardley evolution genesis — domínio experimental de
					mechanism design.

					Criticality medium (default template) — mecanismos de incentivo têm impacto
					econômico indireto via REW, mas NIM não controla decisão sobre dinheiro
					diretamente.
					"""
			}, {
				id:         "WI-046"
				title:      "Criar artefatos de domínio para Risk Engine & Risk Observability (REW)"
				tshirtSize: "L"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/rew/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/rew/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/rew/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/rew/agents/rew-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/rew/agents/rew-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: """
					Bootstrap completo do BC core REW. Core domain — hub de risco da rede.
					Avalia risco contínuo de participantes e operações; publica scores e
					elegibilidade consumidos por CMT (gates de compromisso), FCE (liquidação),
					SCF (antecipação) e DLV (verificação). Recebe sinais de múltiplos BCs —
					posição topológica de convergência.

					Criticality high — controla decisão sobre dinheiro. Scoring incorreto pode
					liberar liquidação para operação inelegível ou bloquear operação legítima.
					Decisões de elegibilidade condicionam diretamente FCE e SCF.
					"""
			}]
		}

		"W001-bc-bootstrap-supporting": {
			id:    "W001-bc-bootstrap-supporting"
			title: "BC bootstrap — 15 supporting BCs"
			rationale: "Bootstrap completo de artefatos de domínio (canvas + glossary + domain-model + agent-spec + agent-governance) para 15 BCs supporting: ATO, BDG, DRC, IDC, INS, ITC, INV, LOG, NPM, OBS, P2P, PLT, SCF, SSC, TCM. Phase p5 do work-graph; executáveis em paralelo após schemas disponíveis."

			tasks: [{
				id:         "WI-047"
				title:      "Criar artefatos de domínio para Accounting & Tax Operations (ATO)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/ato/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/ato/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/ato/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/ato/agents/ato-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/ato/agents/ato-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — registra lançamentos fiscais e contábeis derivados de INV, FCE, SCF e ITC. Conformist em relação a todos os upstream. Criticality high — boundary regulatório e obrigação acessória. Regulação tributária brasileira impõe constraints invioláveis. ATO materializa obrigações legais derivadas das decisões financeiras."
			}, {
				id:         "WI-048"
				title:      "Criar artefatos de domínio para Budget & Approval (BDG)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/bdg/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/bdg/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/bdg/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/bdg/agents/bdg-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/bdg/agents/bdg-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — aprova ou rejeita cobertura orçamentária para compromissos. Consome CommitmentAccepted de CMT; publica BudgetApproved para DLV. Gate orçamentário entre compromisso e execução. Criticality medium — gate operacional interno, sem boundary regulatório direto."
			}, {
				id:         "WI-049"
				title:      "Criar artefatos de domínio para Disputes, Reversals & Corrections (DRC)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/drc/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/drc/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/drc/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/drc/agents/drc-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/drc/agents/drc-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — avalia e resolve disputas referenciando compromissos (CMT), evidência (DLV) e termos (CTR). Publica decisões de resolução para FCE (reversão financeira) e CMT (ajuste). Criticality medium — processo de resolução é operacional; impacto financeiro indireto via FCE."
			}, {
				id:         "WI-050"
				title:      "Criar artefatos de domínio para Identity & Data Governance (IDC)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/idc/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/idc/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/idc/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/idc/agents/idc-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/idc/agents/idc-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — gestão de identidade, autenticação, autorização, governança de dados e integridade criptográfica (CAS, DSSE, Merkle proofs). Unifica identidade e primitivas de verificação sob único owner. Criticality high — LGPD e KYC/AML impõem constraints invioláveis. Identidade incorreta compromete cadeia de custódia e autorização de operações financeiras."
			}, {
				id:         "WI-051"
				title:      "Criar artefatos de domínio para Insurance & Risk Transfer (INS)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028", "WI-046", "WI-059"]
				outputs: [{
					artifact: "contexts/ins/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/ins/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/ins/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/ins/agents/ins-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/ins/agents/ins-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — governa instrumentos de proteção e transferência de risco: seguro garantia, seguro de carga, performance bonds. INS intermedia — não subscreve. Consome precificação de REW e termos de CTR; publica estado de cobertura para SCF. Criticality high — regime SUSEP/IRB impõe constraints de compliance securitário."
			}, {
				id:         "WI-052"
				title:      "Criar artefatos de domínio para International Trade & Customs (ITC)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028", "WI-047"]
				outputs: [{
					artifact: "contexts/itc/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/itc/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/itc/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/itc/agents/itc-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/itc/agents/itc-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — governa operações de comércio exterior: freight forwarding, desembaraço aduaneiro, documentação comex e compliance aduaneiro. Consome de LOG e CTR; publica para ATO (obrigações fiscais aduaneiras). Criticality high — Siscomex, câmbio e legislação aduaneira impõem constraints."
			}, {
				id:         "WI-053"
				title:      "Criar artefatos de domínio para Invoicing (INV)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/inv/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/inv/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/inv/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/inv/agents/inv-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/inv/agents/inv-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — emite faturas vinculadas a entrega verificada (DLV); publica InvoiceIssued consumido por FCE (liquidação), SCF (antecipação de recebíveis) e ATO (obrigações fiscais). Ponto de materialização de recebíveis na cadeia operacional. Criticality medium — regras de NF-e são invariantes no domain-model."
			}, {
				id:         "WI-054"
				title:      "Criar artefatos de domínio para Logistics & Operational Evidence (LOG)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/log/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/log/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/log/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/log/agents/log-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/log/agents/log-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — captura, registro e gestão de evidência operacional: rastreamento de carga, inspeção de qualidade, medição de obra, atividades de campo. Produz cadeia de custódia que DLV consome para verificação. Consome integridade criptográfica de IDC. Criticality medium — evidência operacional é input para verificação, não decisão financeira direta."
			}, {
				id:         "WI-055"
				title:      "Criar artefatos de domínio para Network Participant Management (NPM)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/npm/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/npm/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/npm/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/npm/agents/npm-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/npm/agents/npm-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — gerencia ciclo de vida de participantes da rede: onboarding, qualificação, suspensão. Publica eventos para REW (risco), NIM (inteligência), CTR (contratos) e SSC (sourcing). Opera em parceria com NGR (growth). Criticality medium — KYC/AML é responsabilidade de IDC, não de NPM."
			}, {
				id:         "WI-056"
				title:      "Criar artefatos de domínio para Observability & Operational Intelligence (OBS)"
				tshirtSize: "S"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/obs/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/obs/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/obs/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/obs/agents/obs-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/obs/agents/obs-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — fornece observabilidade e inteligência operacional. Capability transversal consumida por todos os BCs de domínio. Wardley evolution commodity. Criticality medium — infraestrutura de observabilidade, sem decisão financeira ou regulatória."
			}, {
				id:         "WI-057"
				title:      "Criar artefatos de domínio para Procure-to-Pay (P2P)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/p2p/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/p2p/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/p2p/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/p2p/agents/p2p-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/p2p/agents/p2p-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — governa ciclo interno de demanda-compra: requisição, aprovação, emissão de pedido de compra. Publica pedidos para CMT (compromisso econômico); consome decisões de SSC (sourcing estratégico). Criticality medium — procurement operacional."
			}, {
				id:         "WI-058"
				title:      "Criar artefatos de domínio para Platform & Infrastructure Services (PLT)"
				tshirtSize: "S"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/plt/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/plt/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/plt/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/plt/agents/plt-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/plt/agents/plt-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — fornece serviços de plataforma e infraestrutura. Capability transversal consumida por todos os BCs de domínio. Wardley evolution commodity. Criticality medium — infraestrutura de plataforma, sem decisão financeira ou regulatória."
			}, {
				id:         "WI-059"
				title:      "Criar artefatos de domínio para Supply Chain Finance (SCF)"
				tshirtSize: "L"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028", "WI-046"]
				outputs: [{
					artifact: "contexts/scf/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/scf/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/scf/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/scf/agents/scf-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/scf/agents/scf-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — estrutura e oferta de produtos financeiros sobre recebíveis operacionais: antecipação, reverse factoring, dynamic discounting, preparação de portfólios de securitização. Opera como SCD. Consome recebíveis de INV, compromissos de CMT, elegibilidade de REW, termos de CTR e cobertura de INS. Criticality high — cessão de recebíveis, operação de FIDC e regras de SCD exigem precisão regulatória."
			}, {
				id:         "WI-060"
				title:      "Criar artefatos de domínio para Strategic Sourcing & Category (SSC)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/ssc/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/ssc/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/ssc/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/ssc/agents/ssc-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/ssc/agents/ssc-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — governa seleção estratégica de fornecedores e gestão de categorias: cotação, equalização TCO, spend analysis. Publica decisões para P2P (procurement) e CTR (contratos); consome qualificação de NPM. Criticality medium — sourcing estratégico é operacional."
			}, {
				id:         "WI-061"
				title:      "Criar artefatos de domínio para Treasury & Cash Management (TCM)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/tcm/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/tcm/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/tcm/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/tcm/agents/tcm-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/tcm/agents/tcm-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Supporting domain — governa visão de tesouraria corporativa: posição de caixa, projeção de fluxo, estratégia de liquidez e exposição cambial. Consome sinais de FCE e CMT; informa disponibilidade de caixa para FCE. Criticality medium — tesouraria informa decisões mas não controla movimento de dinheiro (FCE controla)."
			}]
		}

		"W001-bc-bootstrap-generic": {
			id:    "W001-bc-bootstrap-generic"
			title: "BC bootstrap — 3 generic BCs (BKR, NTF, STR)"
			rationale: "Bootstrap completo de artefatos de domínio (canvas + glossary + domain-model + agent-spec + agent-governance) para 3 BCs generic: BKR (banking rails), NTF (notifications), STR (storage). Capabilities transversais consumidas por todos os BCs. Phase p5 do work-graph; menor prioridade — shape mais estável."

			tasks: [{
				id:         "WI-062"
				title:      "Criar artefatos de domínio para Banking Rails & Settlement (BKR)"
				tshirtSize: "M"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/bkr/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/bkr/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/bkr/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/bkr/agents/bkr-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/bkr/agents/bkr-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Generic domain — capability transversal de integração com rails bancários e sistemas de liquidação externos (SPB, PIX, câmaras de liquidação). Define boundary entre Mesh e sistema financeiro regulado. Consumido por FCE para execução física de settlement. Criticality high — controla movimento de dinheiro na camada de execução física."
			}, {
				id:         "WI-063"
				title:      "Criar artefatos de domínio para Notifications & Communications (NTF)"
				tshirtSize: "S"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/ntf/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/ntf/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/ntf/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/ntf/agents/ntf-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/ntf/agents/ntf-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Generic domain — fornece notificações e comunicações. Capability transversal consumida por todos os BCs de domínio. Wardley evolution commodity. Criticality medium — infraestrutura de comunicação, sem decisão financeira ou regulatória."
			}, {
				id:         "WI-064"
				title:      "Criar artefatos de domínio para Storage & Document Management (STR)"
				tshirtSize: "S"
				dependsOn: ["WI-009", "WI-011", "WI-020", "WI-021", "WI-022", "WI-028"]
				outputs: [{
					artifact: "contexts/str/canvas.cue"
					type:     "create"
				}, {
					artifact: "contexts/str/glossary.cue"
					type:     "create"
				}, {
					artifact: "contexts/str/domain-model.cue"
					type:     "create"
				}, {
					artifact: "contexts/str/agents/str-primary-agent.cue"
					type:     "create"
				}, {
					artifact: "contexts/str/agents/str-primary-agent.governance.cue"
					type:     "create"
				}]
				rationale: "Generic domain — fornece armazenamento e gestão documental. Capability transversal consumida por todos os BCs de domínio. Wardley evolution commodity. Criticality medium — infraestrutura de storage, sem decisão financeira ou regulatória."
			}]
		}

		"W001-economic-foundation": {
			id:    "W001-economic-foundation"
			title: "Economic Foundation Layers — emergent from WI-053"
			rationale: """
				Layer -1 (Economic Reality) + Layer 1 (Economic Mechanisms) + Layer 2
				(NIM bootstrap value function) — emergent durante WI-053 INV Phase 4 R3
				cross-BC adversarial review (5 system-level gaps X1-X5 não resolúveis em
				INV isoladamente). 3 layers ontológicos canonical materializam ADRs 082,
				083, 084. Phase p0 emergent; depende de WI-053.
				"""

			tasks: [{
				id:         "WI-070"
				title:      "Bootstrap Economic Foundation Layers (Layer -1 / Layer 1 / Layer 2 NIM)"
				tshirtSize: "L"
				dependsOn: ["WI-053"]
				outputs: [{
					artifact: "architecture/artifact-schemas/economic-assumption-model.cue"
					type:     "create"
				}, {
					artifact: "strategic/economic-model/mesh-economic-assumptions.cue"
					type:     "create"
				}, {
					artifact: "architecture/adrs/adr-082-economic-assumption-model-layer.cue"
					type:     "create"
				}, {
					artifact: "architecture/artifact-schemas/economic-mechanism-model.cue"
					type:     "create"
				}, {
					artifact: "strategic/economic-model/mesh-economic-mechanisms.cue"
					type:     "create"
				}, {
					artifact: "architecture/adrs/adr-083-economic-mechanism-model-layer.cue"
					type:     "create"
				}, {
					artifact: "architecture/artifact-schemas/value-function-model.cue"
					type:     "create"
				}, {
					artifact: "strategic/nim/mesh-value-function-v0.cue"
					type:     "create"
				}, {
					artifact: "architecture/adrs/adr-084-nim-bootstrap-layer-2.cue"
					type:     "create"
				}]
				affects: [
					"architecture/artifact-schemas/quality-criteria.cue",
					"governance/readme/config.cue",
				]
				rationale: """
					TAREFA EMERGENT-FROM-WI-053 (regra canônica founder estabelecida 2026-05-08):
					'Se trabalho novo surge durante uma WI: NÃO estenda a WI original; NÃO ignore;
					CRIE nova WI conectada.'

					Surgiu durante WI-053 Phase 4 R3 cross-BC adversarial review: 5 system-level
					gaps X1-X5 identificados — não resolúveis em INV isoladamente; necessitam
					camada arquitetural superior (cross-BC composition + reality layer + mechanism
					design).

					3 layers ontológicos canonical:
					- Layer -1 (Economic Reality, ri-* — ADR-082): realidades adversariais do
					  ambiente que sistema sobrevive APESAR de.
					- Layer 1 (Economic Mechanisms, mech-* — ADR-083): mecanismos que REDUZEM
					  exploitability; NÃO eliminate, NÃO solve.
					- Layer 2 (NIM bootstrap, vfm-* — ADR-084): sistema de medição de valor real;
					  trajectory-based v0; revela 3 NIM subproblemas (separação fluxos / identidade
					  econômica / trajetória).

					Status outputs (delivered/pending tracked em def-015 como tensão estrutural
					captured): 6/9 delivered (Layers -1 e 1); 3/9 pending (Layer 2 NIM). Overall
					progress 67%.

					FRASE CANONICAL FOUNDER R5++: 'Governança não é só organizar trabalho; é
					preservar a verdade sobre o que aconteceu.' Esta WI registra a emergência
					retroativamente — não como dívida invisível, mas como trabalho rastreável +
					auditável + conectado a WI-053 origem.
					"""
			}]
		}

		// ════════════════════════════════════════════════════════════
		// W002 — DDD strategic & meta completion
		// ════════════════════════════════════════════════════════════

		"W002-discovery-and-method": {
			id:    "W002-discovery-and-method"
			title: "DDD strategic — BC discovery method, volatility, splits/merges, domain stories"
			rationale: """
				Fecha meta-DDD gaps identificados em Red Team analysis:
				método repetível de BC discovery (não há ADR documentando
				como subdomínios e BCs atuais foram derivados), framework
				de análise de volatilidade per boundary, governança de
				splits/merges, e schema + primeira instância de event
				storming canonical (#DomainStory). Fundacional para
				evolução sã da ontologia de BCs.
				"""

			tasks: [{
				id:         "WI-110"
				title:      "Criar ADR — BC discovery method (event storming / domain storytelling / business capability mapping)"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "architecture/adrs/adr-088-bounded-context-discovery-method.cue"
					type:     "create"
				}]
				rationale: "Não há ADR documentando o método pelo qual os 27 subdomínios e 10 BCs atuais foram derivados. Sem método repetível, futuros BCs ou splits/merges serão improvisação. ADR formaliza event storming + domain storytelling + business capability mapping como métodos canônicos."
			}, {
				id:         "WI-111"
				title:      "Criar ADR — BC boundary volatility analysis framework + classificação per BC"
				tshirtSize: "M"
				dependsOn: ["WI-110"]
				outputs: [{
					artifact: "architecture/adrs/adr-089-bc-boundary-volatility-analysis.cue"
					type:     "create"
				}]
				rationale: "Boundaries têm volatility distinta (core domains tipicamente mais volatile; generic estáveis). Sem análise, refactor cost descoberto runtime. ADR define framework de classificação per boundary + classificação inicial dos BCs existentes."
			}, {
				id:         "WI-112"
				title:      "Criar ADR — BC splits/merges governance process"
				tshirtSize: "M"
				dependsOn: ["WI-111"]
				outputs: [{
					artifact: "architecture/adrs/adr-090-bc-splits-merges-governance.cue"
					type:     "create"
				}]
				rationale: "Não há governança documentada sobre quando um BC deve ser dividido (cresceu demais) ou fundido (acoplamento excessivo). Sem processo, fracture ou sclerosis é destino default. ADR define gatilhos quantitativos + qualitativos, approval chain, e migration path."
			}, {
				id:         "WI-113"
				title:      "Criar schema #DomainStory + primeira instância para CMT (event storming canonical)"
				tshirtSize: "L"
				dependsOn: ["WI-110"]
				outputs: [{
					artifact: "architecture/artifact-schemas/domain-story.cue"
					type:     "create"
				}, {
					artifact: "strategic/domain-stories/cmt-commitment-formation.cue"
					type:     "create"
				}]
				affects: [
					"strategic/domain-stories/*.cue",
				]
				rationale: "strategic/domain-stories/ existe vazia. domain-model schema referencia eventStormingRef mas não há schema #DomainStory nem instâncias. WI cria schema canonical (commands/events/policies/actors/read-models per Brandolini) + primeira instância CMT como golden example. Subsequent BCs backfilados em wave futura."
			}]
		}

		"W002-tier-and-ownership": {
			id:    "W002-tier-and-ownership"
			title: "DDD strategic — ADR tier classification, Domain Expert per BC, Team Topology/Conway"
			rationale: """
				Fecha gaps de ownership e classificação strategic: 87 ADRs
				existentes sem tier formal (strategic vs structural vs
				tactical); stakeholder-map sem 'domain expert canonical'
				explicit per BC; sem alinhamento Conway/Team Topology
				informando arquitetura sustentável.
				"""

			tasks: [{
				id:         "WI-114"
				title:      "Criar ADR — Strategic ADR tier classification (strategic vs structural vs tactical)"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "architecture/adrs/adr-091-strategic-adr-tier-classification.cue"
					type:     "create"
				}]
				affects: [
					"architecture/adrs/*.cue",
				]
				rationale: "87 ADRs existentes não têm tier classification. ADR define taxonomia (strategic = domain vision/subdomain map/context map/canvas; structural = schemas/templates/governance; tactical = building blocks/conventions/checks) + backfill discipline. Critério crucial para priorização de ADRs strategic em decisões downstream (stack, container topology)."
			}, {
				id:         "WI-115"
				title:      "Criar ADR — Domain Expert canonical per BC (extends stakeholder-map semantics)"
				tshirtSize: "S"
				dependsOn: []
				outputs: [{
					artifact: "architecture/adrs/adr-092-domain-expert-canonical-per-bc.cue"
					type:     "create"
				}]
				affects: [
					"domain/stakeholder-map.cue",
					"contexts/*/canvas.cue",
				]
				rationale: "Stakeholder-map (adr-009) tem catálogo mas sem campo 'domain expert canonical' explicit per BC. DDD requer human anchor para ratificar ubiquitous language + modelagem. ADR formaliza atribuição (mesmo que single-person hoje, é onde futuras decisões de ownership começam)."
			}, {
				id:         "WI-116"
				title:      "Criar ADR + lens — Team Topology/Conway alignment + atribuição inicial per BC"
				tshirtSize: "L"
				dependsOn: ["WI-115"]
				outputs: [{
					artifact: "architecture/adrs/adr-093-team-topology-conway-alignment.cue"
					type:     "create"
				}, {
					artifact: "architecture/lenses/lens-team-topologies-and-conway-alignment.cue"
					type:     "create"
				}]
				rationale: "BCs assumem team topology mas não há ADR ou lens documentando. Sem alinhamento Conway (Skelton/Pais), stack ADRs Fase W005 podem entregar arquitetura tecnicamente coerente mas operacionalmente impossível. Lens cobre stream-aligned/platform/enabling/complicated-subsystem teams; ADR atribui topology inicial per BC."
			}]
		}

		"W002-stability-and-evolution": {
			id:    "W002-stability-and-evolution"
			title: "DDD strategic — Aggregate identity stability, UL drift detection, refactoring discipline"
			rationale: """
				Fecha gaps de estabilidade e evolução: política de
				estabilidade de identidade de aggregate (crítico em
				event-sourced quando boundary muda), check operacional
				de drift de ubiquitous language (lens existe; check
				ausente), e discipline de strategic refactoring (Core ↔
				Supporting ↔ Generic promotion/demotion).
				"""

			tasks: [{
				id:         "WI-117"
				title:      "Criar ADR — Aggregate identity stability policy"
				tshirtSize: "M"
				dependsOn: ["WI-112"]
				outputs: [{
					artifact: "architecture/adrs/adr-094-aggregate-identity-stability.cue"
					type:     "create"
				}]
				rationale: "Quando aggregate boundary muda (refactor / split / merge), como event history migra? Identity stable? Renomear é breaking? Sem policy, event-sourced runner futuro fica refém. ADR define convenções (identity types vs aggregate codes; immutable identity vs migration path)."
			}, {
				id:         "WI-118"
				title:      "Criar build-time check — UL drift detection"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "governance/build-time/ul-drift.cue"
					type:     "create"
				}]
				affects: [
					"contexts/*/glossary.cue",
					"contexts/*/domain-model.cue",
					"contexts/*/canvas.cue",
				]
				rationale: "lens-domain-language-and-terminology-design (78KB) existe mas check operacional não. Sem mecanismo, drift de UL é invisível: mesmo termo significando coisas distintas cross-BC. Check valida term consistency entre glossário, domain-model e canvas per BC + cross-BC clash detection."
			}, {
				id:         "WI-119"
				title:      "Criar ADR — Strategic refactoring discipline (subdomain Core/Supporting/Generic promotion)"
				tshirtSize: "M"
				dependsOn: ["WI-114"]
				outputs: [{
					artifact: "architecture/adrs/adr-095-strategic-refactoring-discipline.cue"
					type:     "create"
				}]
				rationale: "Quando promote subdomain Supporting→Core (ou reverso)? Quando absorb Generic em-house? Sem discipline, decisões investment-shifting são reativas. ADR define triggers + criteria + governance chain. Lens-technical-debt-as-strategic-instrument existe como suporte teórico mas falta protocolo operacional."
			}]
		}

		// ════════════════════════════════════════════════════════════
		// W003 — Cross-context-workflows expansion
		// ════════════════════════════════════════════════════════════

		"W003-inventory": {
			id:    "W003-inventory"
			title: "Cross-context-workflows — formal inventory & roadmap"
			rationale: """
				Architecture/cross-context-workflows/ tem schema (adr-032)
				e apenas 1 instância (commitment-lifecycle). Sem inventário
				formal dos flows cross-BC restantes, gaps cross-context são
				invisíveis. Inventory ADR identifica + prioriza flows
				candidatos antes de instanciar.
				"""

			tasks: [{
				id:         "WI-120"
				title:      "Criar ADR — Cross-context-flows inventory & roadmap"
				tshirtSize: "L"
				dependsOn: []
				outputs: [{
					artifact: "architecture/adrs/adr-096-cross-context-flows-inventory.cue"
					type:     "create"
				}]
				rationale: "ADR inventaria todos os flows cross-BC candidatos (settlement, refund, dispute resolution, onboarding, taxes/accounting, insurance coverage) + prioriza por blast radius e regulatory criticality. Roadmap aponta para WI-121..126 como instâncias derivadas."
			}]
		}

		"W003-instances": {
			id:    "W003-instances"
			title: "Cross-context-workflows — instâncias per saga"
			rationale: "Instancia os 6 flows cross-context priorizados em WI-120. Cada WI cria um arquivo em architecture/cross-context-workflows/ conformante a #CrossContextFlow (adr-032). Nomes finais podem evoluir do inventory; placeholders aqui marcam escopo + ownership."

			tasks: [{
				id:         "WI-121"
				title:      "Criar cross-context-flow — settlement (FCE-led)"
				tshirtSize: "L"
				dependsOn: ["WI-120"]
				outputs: [{
					artifact: "architecture/cross-context-workflows/settlement.cue"
					type:     "create"
				}]
				rationale: "Settlement atravessa REW (eligibility) → FCE (liquidação) → BKR (execução PIX/SPB) → CMT (commitment closure). Critical financial flow; sem documentação cross-BC, fronteira é descoberta runtime."
			}, {
				id:         "WI-122"
				title:      "Criar cross-context-flow — refund-and-reward (REW-led)"
				tshirtSize: "L"
				dependsOn: ["WI-120"]
				outputs: [{
					artifact: "architecture/cross-context-workflows/refund-and-reward.cue"
					type:     "create"
				}]
				rationale: "Refund processing tocando CMT (commitment reversal) → REW (score impact) → FCE (reversão financeira) → NTF (participante notificado). Failure modes em cada fase determinam SLA cross-BC."
			}, {
				id:         "WI-123"
				title:      "Criar cross-context-flow — dispute-resolution (DRC-led)"
				tshirtSize: "L"
				dependsOn: ["WI-120"]
				outputs: [{
					artifact: "architecture/cross-context-workflows/dispute-resolution.cue"
					type:     "create"
				}]
				rationale: "Dispute lifecycle DRC (orchestrator) ↔ CMT (commitment freeze) ↔ FCE (escrow) ↔ NPM (participant management). Authority + audit trail cross-BC."
			}, {
				id:         "WI-124"
				title:      "Criar cross-context-flow — onboarding-and-credit (NPM+REW-led)"
				tshirtSize: "L"
				dependsOn: ["WI-120"]
				outputs: [{
					artifact: "architecture/cross-context-workflows/onboarding-and-credit.cue"
					type:     "create"
				}]
				rationale: "Onboarding NPM (KYC) → IDC (identity verification) → REW (credit scoring) → CMT (first commitment eligibility). Boundary regulatório (LGPD/Bacen)."
			}, {
				id:         "WI-125"
				title:      "Criar cross-context-flow — tax-and-accounting (ATO-led)"
				tshirtSize: "L"
				dependsOn: ["WI-120"]
				outputs: [{
					artifact: "architecture/cross-context-workflows/tax-and-accounting.cue"
					type:     "create"
				}]
				rationale: "FCE (movimentação) → ATO (fiscal/tax derivation) → external (Receita Federal). Obrigação acessória regulada; non-compliance tem consequência legal direta."
			}, {
				id:         "WI-126"
				title:      "Criar cross-context-flow — insurance-coverage (INS-led)"
				tshirtSize: "L"
				dependsOn: ["WI-120"]
				outputs: [{
					artifact: "architecture/cross-context-workflows/insurance-coverage.cue"
					type:     "create"
				}]
				rationale: "INS (coverage decision) ↔ REW (risk score input) ↔ FCE (premium charge) ↔ external (SUSEP/seguradora). Boundary regulatório securitário."
			}]
		}

		// ════════════════════════════════════════════════════════════
		// W004 — C4 architecture (CUE-derived Structurizr)
		// ════════════════════════════════════════════════════════════

		"W004-foundation": {
			id:    "W004-foundation"
			title: "C4 — generation strategy ADR, schemas, container topology ADR"
			rationale: """
				architecture/c4/ existe vazio (apenas views/). Greenfield
				C4. Foundation cria ADR de generation strategy (CUE-derived
				Structurizr DSL), schemas para Workspace/View/Element/
				Relationship, e ADR de container topology (decisão que
				informa L2 e depende de decisões de stack W005).
				"""

			tasks: [{
				id:         "WI-127"
				title:      "Criar ADR — C4 generation strategy (CUE-derived Structurizr DSL)"
				tshirtSize: "M"
				dependsOn: []
				outputs: [{
					artifact: "architecture/adrs/adr-097-c4-generation-strategy.cue"
					type:     "create"
				}]
				rationale: "Decisão crítica: CUE-derived (codegen para Structurizr DSL, single source of truth, no drift) vs manual Structurizr workspace + sync rules vs híbrido. ADR documenta escolha (CUE-derived alinhado com P1) + path de codegen."
			}, {
				id:         "WI-086"
				title:      "Criar schemas C4 — #C4Workspace, #C4View, #C4Element, #C4Relationship"
				tshirtSize: "L"
				dependsOn: ["WI-127"]
				outputs: [{
					artifact: "architecture/artifact-schemas/c4-workspace.cue"
					type:     "create"
				}]
				affects: [
					"architecture/c4/*.cue",
				]
				rationale: "Schema canonical para C4 artifacts. Estruturalmente alinhado com Structurizr DSL model (people, software systems, containers, components, relationships, views). Habilita codegen + drift detection."
			}, {
				id:         "WI-087"
				title:      "Criar ADR — Container topology (1:1 BC↔container vs agrupamento vs polyglot)"
				tshirtSize: "L"
				dependsOn: ["WI-127", "WI-102", "WI-103"]
				outputs: [{
					artifact: "architecture/adrs/adr-098-container-topology.cue"
					type:     "create"
				}]
				rationale: "Container topology informa C4 L2 + deploy. Decisão depende de codegen choice (WI-102) e compute platform (WI-103) — k8s pods vs serverless functions vs VMs têm granularidades naturais distintas. ADR formaliza decisão + impactos."
			}]
		}

		"W004-instances": {
			id:    "W004-instances"
			title: "C4 instances — L1 System Context, L2 Containers, L3 per BC"
			rationale: "Instâncias C4 derivadas dos schemas (WI-086) e topology (WI-087). L1 stack-agnóstico; L2 reflete stack + topology; L3 per BC reflete aggregates/services do domain-model. 10 L3 instances (1 per BC existente)."

			tasks: [{
				id:         "WI-088"
				title:      "Criar C4 L1 — System Context (atores + sistemas externos + sistema Mesh)"
				tshirtSize: "M"
				dependsOn: ["WI-086"]
				outputs: [{
					artifact: "architecture/c4/system-context.cue"
					type:     "create"
				}]
				rationale: "L1 stack-agnóstico. Referencia stakeholder-map (atores humanos) + external systems do context-map (financial-institution, government-authority, saas-provider). Não depende de stack — pode ser instanciado antes de WI-087."
			}, {
				id:         "WI-089"
				title:      "Criar C4 L2 — Containers (per topology decision)"
				tshirtSize: "L"
				dependsOn: ["WI-087", "WI-088"]
				outputs: [{
					artifact: "architecture/c4/containers.cue"
					type:     "create"
				}]
				rationale: "L2 reflete topology decision (WI-087) + stack choices (WI-103 compute, WI-104 persistence, WI-105 eventing). Containers incluem deployable units + data stores + event bus + API gateway."
			}, {
				id:         "WI-090"
				title:      "Criar C4 L3 — Components para BDG"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-bdg.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/bdg/domain-model.cue: aggregates, domain services, projections, repositories. Codegen-friendly."
			}, {
				id:         "WI-091"
				title:      "Criar C4 L3 — Components para CMT"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-cmt.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/cmt/domain-model.cue."
			}, {
				id:         "WI-092"
				title:      "Criar C4 L3 — Components para CTR"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-ctr.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/ctr/domain-model.cue."
			}, {
				id:         "WI-093"
				title:      "Criar C4 L3 — Components para DLV"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-dlv.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/dlv/domain-model.cue."
			}, {
				id:         "WI-094"
				title:      "Criar C4 L3 — Components para IDC"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-idc.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/idc/domain-model.cue."
			}, {
				id:         "WI-095"
				title:      "Criar C4 L3 — Components para INV"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-inv.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/inv/domain-model.cue."
			}, {
				id:         "WI-096"
				title:      "Criar C4 L3 — Components para NPM"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-npm.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/npm/domain-model.cue."
			}, {
				id:         "WI-097"
				title:      "Criar C4 L3 — Components para P2P"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-p2p.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/p2p/domain-model.cue."
			}, {
				id:         "WI-098"
				title:      "Criar C4 L3 — Components para REW"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-rew.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/rew/domain-model.cue."
			}, {
				id:         "WI-099"
				title:      "Criar C4 L3 — Components para SSC"
				tshirtSize: "M"
				dependsOn: ["WI-089"]
				outputs: [{
					artifact: "architecture/c4/components-ssc.cue"
					type:     "create"
				}]
				rationale: "L3 derivado de contexts/ssc/domain-model.cue."
			}]
		}

		"W004-tooling": {
			id:    "W004-tooling"
			title: "C4 — codegen script + CI drift detection"
			rationale: "Operacionaliza CUE-derived strategy (WI-127): codegen CUE → Structurizr DSL + CI check de drift entre fonte CUE e DSL gerado."

			tasks: [{
				id:         "WI-100"
				title:      "Criar scripts/build/generate-c4-dsl.sh — codegen CUE → Structurizr DSL"
				tshirtSize: "M"
				dependsOn: ["WI-086"]
				outputs: [{
					artifact: "scripts/build/generate-c4-dsl.sh"
					type:     "create"
				}]
				rationale: "Codegen script segue pattern de WI-065 (generate-claude-md.sh). cue export sobre package c4 → Structurizr DSL. Idempotência byte-a-byte enforcement."
			}, {
				id:         "WI-101"
				title:      "Criar build-time check — C4 drift detection"
				tshirtSize: "M"
				dependsOn: ["WI-100"]
				outputs: [{
					artifact: "governance/build-time/c4-drift.cue"
					type:     "create"
				}]
				rationale: "Drift detection entre fonte CUE e DSL gerado, similar a projection-drift (adr-027). Spec change → diagram regenerated → diff visible. CI integration garante diagrams nunca ficam stale."
			}]
		}

		// ════════════════════════════════════════════════════════════
		// W005 — Stack definition
		// ════════════════════════════════════════════════════════════

		"W005-stack-definition": {
			id:    "W005-stack-definition"
			title: "Stack — 7 ADRs dimensão-a-dimensão + quality criteria família"
			rationale: """
				Stack definition prerequisite hard antes de runtime.
				7 ADRs cobrem dimensões: codegen toolchain (decisão mais
				singular do projeto; informa todas as outras), compute &
				runtime, persistence (per-BC vs shared, polyglot rules),
				async/eventing (event bus + delivery semantics),
				boundaries (API style + IdP), operability (observability +
				CI/CD + IaC), frontend/clients. Quality criteria família
				tq-stack-NN valida coherence cross-ADR.

				Ordenação intra-wave: codegen primeiro (mais singular,
				informa compute language). Compute em seguida (informa
				persistence + eventing + boundaries + operability +
				frontend). Quality criteria última (depende de todos).
				"""

			tasks: [{
				id:         "WI-102"
				title:      "Criar ADR — Codegen toolchain (CUE → linguagem-alvo)"
				tshirtSize: "L"
				dependsOn: []
				outputs: [{
					artifact: "architecture/adrs/adr-099-codegen-toolchain.cue"
					type:     "create"
				}]
				rationale: "Decisão mais singular do projeto. CUE-first stipulates codegen path. ADR avalia Go (CUE-native), TypeScript, Rust, Python como targets; escolhe linguagem + toolchain (cue go gen, custom transformer). Condiciona compute language em WI-103."
			}, {
				id:         "WI-103"
				title:      "Criar ADR — Compute & runtime (lang + platform + deploy target)"
				tshirtSize: "L"
				dependsOn: ["WI-102"]
				outputs: [{
					artifact: "architecture/adrs/adr-100-compute-and-runtime.cue"
					type:     "create"
				}]
				rationale: "Linguagem(s) (monoglot vs polyglot), platform (k8s vs serverless vs VMs vs edge), deploy target (cloud-managed vs self-hosted vs hybrid). Decisão de container topology (WI-087) deriva desta."
			}, {
				id:         "WI-104"
				title:      "Criar ADR — Persistence architecture (per-BC vs shared, polyglot rules)"
				tshirtSize: "L"
				dependsOn: ["WI-103"]
				outputs: [{
					artifact: "architecture/adrs/adr-101-persistence-architecture.cue"
					type:     "create"
				}]
				rationale: "DDD orthodoxy: per-BC database. SQL vs document vs event store. Read model storage (CQRS implications). Transactional boundaries cross-aggregate. Decisão informa C4 L2 data stores."
			}, {
				id:         "WI-105"
				title:      "Criar ADR — Async / eventing (event bus, delivery semantics)"
				tshirtSize: "L"
				dependsOn: ["WI-103"]
				outputs: [{
					artifact: "architecture/adrs/adr-102-async-eventing.cue"
					type:     "create"
				}]
				rationale: "Event bus (Kafka, NATS, RabbitMQ, etc.), delivery semantics (at-least-once / exactly-once / at-most-once), cross-BC integration pattern (event sourcing vs event-carried state transfer vs notification-only). Suporta domain-model schema (eventos published)."
			}, {
				id:         "WI-106"
				title:      "Criar ADR — Boundaries (API style + IdP)"
				tshirtSize: "M"
				dependsOn: ["WI-103"]
				outputs: [{
					artifact: "architecture/adrs/adr-103-boundaries-api-identity.cue"
					type:     "create"
				}]
				rationale: "API style (REST, GraphQL, gRPC, hybrid), API gateway / BFF pattern, IdP (external Auth0/Clerk/Ory vs self-hosted Keycloak vs custom), service mesh (Istio/Linkerd vs none). Suporta IDC + boundary cross-BC decisions."
			}, {
				id:         "WI-107"
				title:      "Criar ADR — Operability (observability + CI/CD + IaC)"
				tshirtSize: "M"
				dependsOn: ["WI-103"]
				outputs: [{
					artifact: "architecture/adrs/adr-104-operability.cue"
					type:     "create"
				}]
				rationale: "Observability stack (OpenTelemetry default + backend Grafana/Datadog/Honeycomb), CI/CD platform (GitHub Actions / GitLab / Buildkite / Dagger), IaC (Terraform / Pulumi / CDK / Crossplane), secret management, feature flags. Suporta lens-observability-operational-intelligence."
			}, {
				id:         "WI-108"
				title:      "Criar ADR — Frontend / clients (web + mobile + design system)"
				tshirtSize: "M"
				dependsOn: ["WI-103"]
				outputs: [{
					artifact: "architecture/adrs/adr-105-frontend-clients.cue"
					type:     "create"
				}]
				rationale: "Frontend(s): web SPA/SSR/MPA, mobile native/cross-platform, multiple frontends (admin / customer / operator), shared design system. Suporta lens-design-tokens + lens-interaction-patterns."
			}, {
				id:         "WI-109"
				title:      "Criar quality criteria família tq-stack-NN (cross-ADR coherence)"
				tshirtSize: "M"
				dependsOn: ["WI-102", "WI-103", "WI-104", "WI-105", "WI-106", "WI-107", "WI-108"]
				outputs: [{
					artifact: "architecture/structural-checks/stack-coherence.cue"
					type:     "create"
				}]
				rationale: "Stack ADRs decidem em isolamento mas devem ser coerentes: CUE-first codegen path exists + envelope dispatch runnable + bounded-wait queue primitives + audit trail persistence + cross-BC integration pattern matches eventing choice + per-BC isolation respected. Quality criteria família valida coherence."
			}]
		}
	}
}
