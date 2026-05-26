package readme

// structure-index.cue — DERIVADO. Gerado por scripts/ci/generate-structure-index.py a partir de _schema.location
// (artifact-schemas + build-time) + scan do filesystem. NÃO editar à mão; regenerar. (adr-090)

structureIndex: {
	"ambiguous": [],
	"collections": [
		{
			"canonicalPathRegex": "^architecture/adrs/adr-[0-9]{3}-[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/adrs/adr-001-type-centric-governance.cue",
				"architecture/adrs/adr-002-conditional-bc-completeness.cue",
				"architecture/adrs/adr-003-typed-adrs-with-ci-enforcement.cue",
				"architecture/adrs/adr-004-claude-md-derived-artifact.cue",
				"architecture/adrs/adr-005-work-governance-architecture.cue",
				"architecture/adrs/adr-006-wave-plan-artifact.cue",
				"architecture/adrs/adr-007-task-templates.cue",
				"architecture/adrs/adr-008-work-graph-phase-topology.cue",
				"architecture/adrs/adr-009-stakeholder-map-schema.cue",
				"architecture/adrs/adr-010-quality-criteria-colocation.cue",
				"architecture/adrs/adr-011-quality-criteria-types-ownership.cue",
				"architecture/adrs/adr-012-analytical-lens-schema.cue",
				"architecture/adrs/adr-013-self-review-report-evidence.cue",
				"architecture/adrs/adr-014-self-review-ci-enforcement.cue",
				"architecture/adrs/adr-015-self-review-bootstrap-exception.cue",
				"architecture/adrs/adr-016-readme-coevolution.cue",
				"architecture/adrs/adr-017-readme-blocks-as-derived-artifacts.cue",
				"architecture/adrs/adr-018-self-review-hardening.cue",
				"architecture/adrs/adr-019-validation-prompts-auto-hook.cue",
				"architecture/adrs/adr-020-automated-semantic-validation-after-commit.cue",
				"architecture/adrs/adr-021-self-review-evidence-hardening.cue",
				"architecture/adrs/adr-022-subagent-review-model.cue",
				"architecture/adrs/adr-023-subagent-controlled-rollout.cue",
				"architecture/adrs/adr-024-activate-work-governance-phase1.cue",
				"architecture/adrs/adr-025-dependsonphases-and-governance-ci.cue",
				"architecture/adrs/adr-026-completion-gates.cue",
				"architecture/adrs/adr-027-projection-drift.cue",
				"architecture/adrs/adr-028-canvas-artifact-schema.cue",
				"architecture/adrs/adr-029-subdomain-artifact-schema.cue",
				"architecture/adrs/adr-030-shared-strategic-classification.cue",
				"architecture/adrs/adr-031-remove-subdomain-deprecation.cue",
				"architecture/adrs/adr-032-cross-context-flow-schema.cue",
				"architecture/adrs/adr-033-context-map-schema-evolution.cue",
				"architecture/adrs/adr-034-canvas-schema-evolution.cue",
				"architecture/adrs/adr-035-domain-model-schema.cue",
				"architecture/adrs/adr-036-glossary-schema.cue",
				"architecture/adrs/adr-037-agent-spec-governance-two-levels.cue",
				"architecture/adrs/adr-038-tension-entry-schema.cue",
				"architecture/adrs/adr-039-domain-agent-spec-canonical-path.cue",
				"architecture/adrs/adr-040-validation-split-structural-vs-design-review.cue",
				"architecture/adrs/adr-041-structural-check-v1-schema-shape.cue",
				"architecture/adrs/adr-042-tmpl-create-script-and-script-wi-tracking.cue",
				"architecture/adrs/adr-043-vertical-applicability-governance-surface.cue",
				"architecture/adrs/adr-044-close-adr-043-phase-1-backfill.cue",
				"architecture/adrs/adr-045-resume-adr-043-phase-1-deferred-backfill.cue",
				"architecture/adrs/adr-046-conventions-category-and-tmpl-create-convention.cue",
				"architecture/adrs/adr-047-extend-artifact-type-for-api-specs.cue",
				"architecture/adrs/adr-048-api-spec-convention-conditional-presence.cue",
				"architecture/adrs/adr-049-extend-structural-check-conditional-file-presence.cue",
				"architecture/adrs/adr-050-adopt-readme-config-from-portfolio.cue",
				"architecture/adrs/adr-051-deprecate-readme-blocks.cue",
				"architecture/adrs/adr-052-adopt-repo-structure-from-portfolio.cue",
				"architecture/adrs/adr-053-adopt-production-guide-with-universal-coverage-rule-and-phased-rollout.cue",
				"architecture/adrs/adr-054-declarative-authoring-policy.cue",
				"architecture/adrs/adr-055-cross-aggregate-state-dependency.cue",
				"architecture/adrs/adr-056-add-production-guide-coverage-kind.cue",
				"architecture/adrs/adr-057-add-manual-authoring-protocol-section-gates.cue",
				"architecture/adrs/adr-058-add-failure-handling-to-agent-governance-envelope.cue",
				"architecture/adrs/adr-059-add-planned-outputs-optional-field-to-adr.cue",
				"architecture/adrs/adr-060-extend-artifact-type-for-path-coverage.cue",
				"architecture/adrs/adr-061-extend-artifact-type-for-adopted-artifacts-and-readme-config.cue",
				"architecture/adrs/adr-062-introduce-deferred-decision-artifact.cue",
				"architecture/adrs/adr-063-add-filesystem-path-exists-kind-to-structural-check.cue",
				"architecture/adrs/adr-064-add-directory-pair-coverage-kind-and-work-governance-type.cue",
				"architecture/adrs/adr-065-establish-policy-registry-as-supporting-subdomain.cue",
				"architecture/adrs/adr-066-extend-artifact-type-for-deferred-decision.cue",
				"architecture/adrs/adr-067-extend-artifact-type-for-production-guide.cue",
				"architecture/adrs/adr-068-extend-artifact-type-for-structural-check.cue",
				"architecture/adrs/adr-069-extend-artifact-type-for-validation-prompt.cue",
				"architecture/adrs/adr-070-promote-bootstrap-exception-to-firstclass-schema.cue",
				"architecture/adrs/adr-071-add-file-content-occurrence-count-trigger-kind.cue",
				"architecture/adrs/adr-072-extend-artifact-type-for-canvas.cue",
				"architecture/adrs/adr-073-extend-artifact-type-for-glossary.cue",
				"architecture/adrs/adr-074-extend-authoring-rollout-for-wi-048-bc-bootstrap-types.cue",
				"architecture/adrs/adr-075-envelope-governance-schema-additions-d-prime.cue",
				"architecture/adrs/adr-076-harden-adr-schema-and-extend-structural-check-with-at-least-one-block-present.cue",
				"architecture/adrs/adr-077-add-canvas-metric-onbreach-field.cue",
				"architecture/adrs/adr-078-pg-canvas-metric-classification-hardening.cue",
				"architecture/adrs/adr-079-refine-canvas-metric-classification-direct-action-vs-escalation.cue",
				"architecture/adrs/adr-080-extend-structural-check-domain-invariants.cue",
				"architecture/adrs/adr-081-domain-model-interpretation-contracts-layer.cue",
				"architecture/adrs/adr-082-economic-assumption-model-layer.cue",
				"architecture/adrs/adr-083-economic-mechanism-model-layer.cue",
				"architecture/adrs/adr-084-production-safety-hardening-system-consistency-model.cue",
				"architecture/adrs/adr-085-pattern-extraction-decision-systems-with-truth-boundaries.cue",
				"architecture/adrs/adr-086-domain-invariant-authoring-protocol.cue",
				"architecture/adrs/adr-087-rename-bdg-commitment-uniqueness-invariant-global.cue",
				"architecture/adrs/adr-088-formalize-mcm-execution-class.cue",
				"architecture/adrs/adr-089-add-observation-action-category.cue",
				"architecture/adrs/adr-090-derived-structure.cue",
				"architecture/adrs/adr-093-schematize-design-principles.cue",
				"architecture/adrs/adr-094-schematize-shared-types.cue",
				"architecture/adrs/adr-095-remove-phantom-domain-artifacts.cue",
				"architecture/adrs/adr-096-build-time-structural-check-orchestrator.cue",
				"architecture/adrs/adr-097-per-check-enforcement-and-promote-sc-wg-01.cue"
			],
			"schema": "#ADRBase"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/agents/[a-z][a-z0-9-]*\\.governance\\.cue$",
			"files": [
				"contexts/bdg/agents/bdg-primary-agent.governance.cue",
				"contexts/bkr/agents/bkr-primary-agent.governance.cue",
				"contexts/cmt/agents/cmt-primary-agent.governance.cue",
				"contexts/ctr/agents/ctr-primary-agent.governance.cue",
				"contexts/dlv/agents/dlv-primary-agent.governance.cue",
				"contexts/idc/agents/idc-primary-agent.governance.cue",
				"contexts/inv/agents/inv-primary-agent.governance.cue",
				"contexts/npm/agents/npm-primary-agent.governance.cue",
				"contexts/p2p/agents/p2p-primary-agent.governance.cue",
				"contexts/rew/agents/rew-primary-agent.governance.cue",
				"contexts/ssc/agents/ssc-primary-agent.governance.cue"
			],
			"schema": "#AgentGovernanceEnvelope"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/agents/[a-z][a-z0-9-]*\\.cue$",
			"files": [
				"contexts/bdg/agents/bdg-primary-agent.cue",
				"contexts/bkr/agents/bkr-primary-agent.cue",
				"contexts/cmt/agents/cmt-primary-agent.cue",
				"contexts/ctr/agents/ctr-primary-agent.cue",
				"contexts/dlv/agents/dlv-primary-agent.cue",
				"contexts/idc/agents/idc-primary-agent.cue",
				"contexts/inv/agents/inv-primary-agent.cue",
				"contexts/npm/agents/npm-primary-agent.cue",
				"contexts/p2p/agents/p2p-primary-agent.cue",
				"contexts/rew/agents/rew-primary-agent.cue",
				"contexts/ssc/agents/ssc-primary-agent.cue"
			],
			"schema": "#AgentSpec"
		},
		{
			"canonicalPathRegex": "^architecture/lenses/[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/lenses/lens-ai-agent-governance.cue",
				"architecture/lenses/lens-api-design-as-product.cue",
				"architecture/lenses/lens-behavioral-economics.cue",
				"architecture/lenses/lens-cold-start-and-network-bootstrapping.cue",
				"architecture/lenses/lens-color-as-functional-language.cue",
				"architecture/lenses/lens-commons-collective-action.cue",
				"architecture/lenses/lens-complex-adaptive-systems.cue",
				"architecture/lenses/lens-contract-theory.cue",
				"architecture/lenses/lens-contractual-and-legal-architecture.cue",
				"architecture/lenses/lens-credit-risk.cue",
				"architecture/lenses/lens-cross-cutting-concern-integration.cue",
				"architecture/lenses/lens-data-modeling-for-analytical-power.cue",
				"architecture/lenses/lens-data-quality-as-competitive-moat.cue",
				"architecture/lenses/lens-data-visualization-semiotics.cue",
				"architecture/lenses/lens-decision-systems-with-truth-boundaries.cue",
				"architecture/lenses/lens-design-tokens-and-systematic-composition.cue",
				"architecture/lenses/lens-developer-and-integrator-experience.cue",
				"architecture/lenses/lens-distributed-systems-design.cue",
				"architecture/lenses/lens-documentation-as-product.cue",
				"architecture/lenses/lens-domain-language-and-terminology-design.cue",
				"architecture/lenses/lens-event-driven-architecture-patterns.cue",
				"architecture/lenses/lens-financial-intermediation.cue",
				"architecture/lenses/lens-game-theory-applied.cue",
				"architecture/lenses/lens-incentive-alignment.cue",
				"architecture/lenses/lens-information-density-design.cue",
				"architecture/lenses/lens-information-economics.cue",
				"architecture/lenses/lens-infrastructure-cost-economics.cue",
				"architecture/lenses/lens-interaction-patterns-for-professional-tools.cue",
				"architecture/lenses/lens-internationalization-and-localization-architecture.cue",
				"architecture/lenses/lens-jobs-to-be-done-and-workflow-design.cue",
				"architecture/lenses/lens-knowledge-management.cue",
				"architecture/lenses/lens-market-design.cue",
				"architecture/lenses/lens-mechanism-design.cue",
				"architecture/lenses/lens-ml-ai-systems-design.cue",
				"architecture/lenses/lens-multi-sided-platform-ux.cue",
				"architecture/lenses/lens-multi-tenancy-and-identity-architecture.cue",
				"architecture/lenses/lens-network-theory.cue",
				"architecture/lenses/lens-observability-operational-intelligence.cue",
				"architecture/lenses/lens-organizational-economics.cue",
				"architecture/lenses/lens-organizational-resource-allocation.cue",
				"architecture/lenses/lens-platform-dynamics.cue",
				"architecture/lenses/lens-platform-evolution-and-backwards-compatibility.cue",
				"architecture/lenses/lens-pricing-and-monetization-architecture.cue",
				"architecture/lenses/lens-progressive-disclosure-and-information-architecture.cue",
				"architecture/lenses/lens-real-options.cue",
				"architecture/lenses/lens-regulatory-compliance-as-architecture.cue",
				"architecture/lenses/lens-regulatory-strategy.cue",
				"architecture/lenses/lens-security-trust-infrastructure.cue",
				"architecture/lenses/lens-stakeholder-communication.cue",
				"architecture/lenses/lens-supply-chain-theory.cue",
				"architecture/lenses/lens-technical-debt-as-strategic-instrument.cue",
				"architecture/lenses/lens-temporal-modeling-for-financial-systems.cue",
				"architecture/lenses/lens-testing-and-validation-for-financial-systems.cue",
				"architecture/lenses/lens-theory-of-firm.cue",
				"architecture/lenses/lens-trust-and-credibility-design.cue",
				"architecture/lenses/lens-typographic-systems-for-dense-interfaces.cue"
			],
			"schema": "#AnalyticalLens"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/async-api\\.yaml$",
			"files": [],
			"schema": "#AsyncAPISpec"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/canvas\\.cue$",
			"files": [
				"contexts/bdg/canvas.cue",
				"contexts/bkr/canvas.cue",
				"contexts/cmt/canvas.cue",
				"contexts/ctr/canvas.cue",
				"contexts/dlv/canvas.cue",
				"contexts/idc/canvas.cue",
				"contexts/inv/canvas.cue",
				"contexts/npm/canvas.cue",
				"contexts/p2p/canvas.cue",
				"contexts/rew/canvas.cue",
				"contexts/ssc/canvas.cue"
			],
			"schema": "#Canvas"
		},
		{
			"canonicalPathRegex": "^architecture/cross-context-workflows/[a-z][a-z0-9-]*\\.cue$",
			"files": [
				"architecture/cross-context-workflows/commitment-lifecycle.cue"
			],
			"schema": "#CrossContextFlow"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/domain-model\\.cue$",
			"files": [
				"contexts/bdg/domain-model.cue",
				"contexts/bkr/domain-model.cue",
				"contexts/cmt/domain-model.cue",
				"contexts/ctr/domain-model.cue",
				"contexts/dlv/domain-model.cue",
				"contexts/idc/domain-model.cue",
				"contexts/inv/domain-model.cue",
				"contexts/npm/domain-model.cue",
				"contexts/p2p/domain-model.cue",
				"contexts/rew/domain-model.cue",
				"contexts/ssc/domain-model.cue"
			],
			"schema": "#DomainModel"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/glossary\\.cue$",
			"files": [
				"contexts/bdg/glossary.cue",
				"contexts/bkr/glossary.cue",
				"contexts/cmt/glossary.cue",
				"contexts/ctr/glossary.cue",
				"contexts/dlv/glossary.cue",
				"contexts/idc/glossary.cue",
				"contexts/inv/glossary.cue",
				"contexts/npm/glossary.cue",
				"contexts/p2p/glossary.cue",
				"contexts/rew/glossary.cue",
				"contexts/ssc/glossary.cue"
			],
			"schema": "#Glossary"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/api\\.yaml$",
			"files": [],
			"schema": "#OpenAPISpec"
		},
		{
			"canonicalPathRegex": "^domain/policies/pol-[a-z0-9-]+\\.cue$",
			"files": [],
			"schema": "#PolicyRegistryEntry"
		},
		{
			"canonicalPathRegex": "^contexts/[a-z][a-z0-9-]*/service-contract\\.cue$",
			"files": [
				"contexts/ctr/service-contract.cue"
			],
			"schema": "#ServiceContract"
		},
		{
			"canonicalPathRegex": "^architecture/shared-types/[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/shared-types/strategic-classification.cue",
				"architecture/shared-types/vertical-applicability.cue"
			],
			"schema": "#SharedTypes"
		},
		{
			"canonicalPathRegex": "^strategic/subdomains/[a-z][a-z0-9-]*\\.cue$",
			"files": [
				"strategic/subdomains/ato.cue",
				"strategic/subdomains/bdg.cue",
				"strategic/subdomains/bkr.cue",
				"strategic/subdomains/cmt.cue",
				"strategic/subdomains/ctr.cue",
				"strategic/subdomains/dlv.cue",
				"strategic/subdomains/drc.cue",
				"strategic/subdomains/fce.cue",
				"strategic/subdomains/idc.cue",
				"strategic/subdomains/ins.cue",
				"strategic/subdomains/inv.cue",
				"strategic/subdomains/itc.cue",
				"strategic/subdomains/log.cue",
				"strategic/subdomains/ngr.cue",
				"strategic/subdomains/nim.cue",
				"strategic/subdomains/npm.cue",
				"strategic/subdomains/ntf.cue",
				"strategic/subdomains/obs.cue",
				"strategic/subdomains/p2p.cue",
				"strategic/subdomains/plr.cue",
				"strategic/subdomains/plt.cue",
				"strategic/subdomains/rew.cue",
				"strategic/subdomains/scf.cue",
				"strategic/subdomains/ssc.cue",
				"strategic/subdomains/str.cue",
				"strategic/subdomains/tcm.cue"
			],
			"schema": "#Subdomain"
		},
		{
			"canonicalPathRegex": "^architecture/tension-log/ten-[0-9]{3}-[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/tension-log/ten-001-domain-field-optionality.cue",
				"architecture/tension-log/ten-002-idc-authority-archetype-missing.cue",
				"architecture/tension-log/ten-003-revocation-protocol-not-formalized.cue",
				"architecture/tension-log/ten-004-evidence-taxonomy-not-formalized.cue",
				"architecture/tension-log/ten-005-platform-operator-not-modeled.cue",
				"architecture/tension-log/ten-006-validation-non-determinism.cue",
				"architecture/tension-log/ten-007-vertical-adaptable-vs-not-yet-validated.cue",
				"architecture/tension-log/ten-008-platform-dynamics-lens-authoring-abstraction-level.cue",
				"architecture/tension-log/ten-009-decision-class-enum-lacks-governance-value.cue",
				"architecture/tension-log/ten-010-file-classification-ignores-non-cue-types.cue",
				"architecture/tension-log/ten-011-production-guide-verbatim-inherits-upstream-constraints.cue",
				"architecture/tension-log/ten-012-escalation-channel-sla-runtime-semantic-leak.cue"
			],
			"schema": "#TensionEntry"
		},
		{
			"canonicalPathRegex": "^architecture/validation-prompts/validate-[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/validation-prompts/validate-adopted-artifacts.cue",
				"architecture/validation-prompts/validate-adr.cue",
				"architecture/validation-prompts/validate-agent-governance.cue",
				"architecture/validation-prompts/validate-agent-spec.cue",
				"architecture/validation-prompts/validate-artifact-schema.cue",
				"architecture/validation-prompts/validate-canvas.cue",
				"architecture/validation-prompts/validate-deferred-decision.cue",
				"architecture/validation-prompts/validate-domain-definition.cue",
				"architecture/validation-prompts/validate-domain-model.cue",
				"architecture/validation-prompts/validate-glossary.cue",
				"architecture/validation-prompts/validate-production-guide.cue",
				"architecture/validation-prompts/validate-readme-config.cue",
				"architecture/validation-prompts/validate-self-review-report.cue",
				"architecture/validation-prompts/validate-tension-entry.cue"
			],
			"schema": "#ValidationPrompt"
		},
		{
			"canonicalPathRegex": "^architecture/deferred-decisions/def-[0-9]{3}-[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/deferred-decisions/def-001-promote-plannedoutputs-to-required.cue",
				"architecture/deferred-decisions/def-002-add-cross-file-id-exists-kind.cue",
				"architecture/deferred-decisions/def-003-add-regex-pattern-match-kind.cue",
				"architecture/deferred-decisions/def-004-formalize-tq-as-05-or-convert-references.cue",
				"architecture/deferred-decisions/def-005-policy-cross-bc-execution.cue",
				"architecture/deferred-decisions/def-006-policy-cross-bc-sync.cue",
				"architecture/deferred-decisions/def-007-policy-data-consistency.cue",
				"architecture/deferred-decisions/def-008-policy-distributed-evaluation.cue",
				"architecture/deferred-decisions/def-009-policy-lifecycle-versioning.cue",
				"architecture/deferred-decisions/def-010-convention-central-schema-centralization.cue",
				"architecture/deferred-decisions/def-011-bootstrap-exception-schema-firstclass.cue",
				"architecture/deferred-decisions/def-012-bootstrap-exception-stale-detection-sc.cue",
				"architecture/deferred-decisions/def-013-envelope-governance-typing-maturity.cue",
				"architecture/deferred-decisions/def-014-communication-schema-enrichment.cue",
				"architecture/deferred-decisions/def-015-task-output-temporality-metadata.cue",
				"architecture/deferred-decisions/def-016-cross-bc-decision-attestation-enforcement.cue",
				"architecture/deferred-decisions/def-017-deletion-srr-script-handling.cue",
				"architecture/deferred-decisions/def-018-promote-orphan-detection-to-reject.cue"
			],
			"schema": "_#DeferredDecisionBase"
		},
		{
			"canonicalPathRegex": "^architecture/structural-checks/[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/structural-checks/adr.cue",
				"architecture/structural-checks/bdg-domain-model.cue",
				"architecture/structural-checks/canvas.cue",
				"architecture/structural-checks/cmt-domain-model.cue",
				"architecture/structural-checks/ctr-domain-model.cue",
				"architecture/structural-checks/deferred-decision.cue",
				"architecture/structural-checks/dlv-domain-model.cue",
				"architecture/structural-checks/inv-domain-model.cue",
				"architecture/structural-checks/p2p-domain-model.cue",
				"architecture/structural-checks/production-guide.cue",
				"architecture/structural-checks/rew-domain-model.cue",
				"architecture/structural-checks/self-review-report.cue",
				"architecture/structural-checks/singleton-coverage.cue",
				"architecture/structural-checks/ssc-domain-model.cue",
				"architecture/structural-checks/tension-entry.cue",
				"architecture/structural-checks/work-governance.cue"
			],
			"schema": "_#StructuralCheckBase"
		},
		{
			"canonicalPathRegex": "^architecture/artifact-schemas/[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/artifact-schemas/adopted-artifacts.cue",
				"architecture/artifact-schemas/adr.cue",
				"architecture/artifact-schemas/agent-governance.cue",
				"architecture/artifact-schemas/agent-spec.cue",
				"architecture/artifact-schemas/api-spec.cue",
				"architecture/artifact-schemas/artifact-schema.cue",
				"architecture/artifact-schemas/canvas.cue",
				"architecture/artifact-schemas/context-map.cue",
				"architecture/artifact-schemas/cross-context-flow.cue",
				"architecture/artifact-schemas/deferred-decision.cue",
				"architecture/artifact-schemas/design-principles.cue",
				"architecture/artifact-schemas/domain-definition.cue",
				"architecture/artifact-schemas/domain-model.cue",
				"architecture/artifact-schemas/economic-assumption-model.cue",
				"architecture/artifact-schemas/economic-mechanism-model.cue",
				"architecture/artifact-schemas/glossary.cue",
				"architecture/artifact-schemas/lens.cue",
				"architecture/artifact-schemas/policy.cue",
				"architecture/artifact-schemas/production-guide.cue",
				"architecture/artifact-schemas/quality-criteria.cue",
				"architecture/artifact-schemas/readme-config.cue",
				"architecture/artifact-schemas/repo-structure.cue",
				"architecture/artifact-schemas/service-contract.cue",
				"architecture/artifact-schemas/shared-types.cue",
				"architecture/artifact-schemas/stakeholder-map.cue",
				"architecture/artifact-schemas/structural-check.cue",
				"architecture/artifact-schemas/subdomain.cue",
				"architecture/artifact-schemas/task-template.cue",
				"architecture/artifact-schemas/tension-entry.cue",
				"architecture/artifact-schemas/validation-prompt.cue",
				"architecture/artifact-schemas/wave-plan.cue"
			],
			"schema": "_artifactSchemaMeta"
		},
		{
			"canonicalPathRegex": "^(portfolio/production-guides|architecture/production-guides)/[a-z0-9-]+\\.cue$",
			"files": [
				"architecture/production-guides/adr.cue",
				"architecture/production-guides/agent-governance.cue",
				"architecture/production-guides/agent-spec.cue",
				"architecture/production-guides/canvas.cue",
				"architecture/production-guides/deferred-decision.cue",
				"architecture/production-guides/domain-model.cue",
				"architecture/production-guides/glossary.cue",
				"architecture/production-guides/lens.cue",
				"architecture/production-guides/production-guide.cue",
				"architecture/production-guides/structural-check.cue",
				"architecture/production-guides/task-spec.cue",
				"architecture/production-guides/tension-entry.cue"
			],
			"schema": "_productionGuideMeta"
		}
	],
	"generator": "scripts/ci/generate-structure-index.py",
	"missingSingletons": [],
	"phantomCandidates": [
		"ai-orchestration/agent-lifecycle.cue",
		"architecture/compensation-patterns.cue",
		"architecture/event-evolution.cue",
		"architecture/infrastructure.cue",
		"architecture/observability-strategy.cue",
		"architecture/testing-strategy.cue",
		"governance/red-team-protocol.cue",
		"governance/spec-gap-protocol.cue",
		"governance/validation-protocol.cue",
		"strategic/informational-flywheel.cue"
	],
	"singletons": [
		{
			"canonicalPath": "ai-orchestration/agent-instructions/task-templates.cue",
			"present": true,
			"schema": "#TaskTemplate"
		},
		{
			"canonicalPath": "architecture/agent-governance.cue",
			"present": true,
			"schema": "#AgentGovernanceGlobal"
		},
		{
			"canonicalPath": "architecture/design-principles.cue",
			"present": true,
			"schema": "#DesignPrinciples"
		},
		{
			"canonicalPath": "domain/domain-definition.cue",
			"present": true,
			"schema": "#DomainDefinition"
		},
		{
			"canonicalPath": "domain/stakeholder-map.cue",
			"present": true,
			"schema": "#StakeholderMap"
		},
		{
			"canonicalPath": "governance/adopted-artifacts.cue",
			"present": true,
			"schema": "#AdoptedArtifactsManifest"
		},
		{
			"canonicalPath": "governance/build-time/self-review-bootstrap-policy.cue",
			"present": true,
			"schema": "#SelfReviewBootstrapPolicy"
		},
		{
			"canonicalPath": "governance/build-time/self-review-ci-policy.cue",
			"present": true,
			"schema": "#SelfReviewCIPolicy"
		},
		{
			"canonicalPath": "governance/readme/config.cue",
			"present": true,
			"schema": "#ReadmeConfig"
		},
		{
			"canonicalPath": "governance/repo-structure.cue",
			"present": true,
			"schema": "#RepoStructure"
		},
		{
			"canonicalPath": "governance/wave-plan.cue",
			"present": true,
			"schema": "#WavePlan"
		},
		{
			"canonicalPath": "strategic/context-map.cue",
			"present": true,
			"schema": "#ContextMap"
		},
		{
			"canonicalPath": "strategic/economic-model/mesh-economic-assumptions.cue",
			"present": true,
			"schema": "#EconomicAssumptionModel"
		},
		{
			"canonicalPath": "strategic/economic-model/mesh-economic-mechanisms.cue",
			"present": true,
			"schema": "#EconomicMechanismModel"
		}
	],
	"source": "_schema.location (artifact-schemas + build-time) + filesystem scan (scope.validated)",
	"unmatched": [
		"architecture/conventions/api-spec-convention.cue",
		"governance/bounded-context-completeness.cue",
		"governance/build-time/authoring-policy.cue",
		"governance/build-time/claim-expiration-validation.cue",
		"governance/build-time/command-rights.cue",
		"governance/build-time/completion-gates.cue",
		"governance/build-time/event-validation.cue",
		"governance/build-time/projection-drift.cue",
		"governance/build-time/quality-gate.cue",
		"governance/build-time/self-review-report.cue",
		"governance/build-time/subagent-execution-log.cue",
		"governance/build-time/task-governance.cue",
		"governance/build-time/validation-findings-w001.cue",
		"governance/build-time/work-governance.cue",
		"governance/build-time/work-graph.cue",
		"governance/claude/config.cue",
		"governance/claude/output.cue",
		"governance/claude/schema.cue",
		"governance/readme/output.cue",
		"governance/repo-principles.cue"
	]
}
