package lenses

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

platformEvolutionAndBackwardsCompatibility: artifact_schemas.#AnalyticalLens & {
id:     "lens-platform-evolution-and-backwards-compatibility"
name:   "Evolução de Plataforma e Backwards Compatibility"

purpose: "Orientar decisões sobre como evoluir a plataforma sem quebrar consumidores — API versioning, deprecation ceremony, feature flags e backward compatibility."
status: "draft"

trigger: {
	conditions: [
		"a decisão envolve como evoluir API, event schemas ou data model sem quebrar integrações existentes de participantes",
		"a decisão envolve como deprecar funcionalidade antiga dando tempo e path de migração para consumidores",
		"a decisão envolve como versionar APIs, eventos e contratos para coexistência de múltiplas versões",
		"a decisão envolve como projetar migration paths assistidos para que participantes migrem de versão antiga para nova com mínimo esforço",
		"a decisão envolve como usar feature flags para lançar funcionalidade gradualmente sem forçar adoção simultânea",
		"a decisão envolve como garantir que schema evolution em event sourcing preserva leitura de eventos históricos",
		"a decisão envolve como a plataforma pode mudar internamente (refactoring, otimização, nova tecnologia) sem que interfaces externas mudem",
		"a decisão envolve trade-offs entre velocidade de evolução (lançar rápido) e estabilidade para participantes (não quebrar)",
		"a decisão envolve como comunicar mudanças futuras (roadmap, deprecation notices) para que participantes se preparem",
	]
	keywords: [
		"backwards compatibility", "compatibilidade", "breaking change",
		"versioning", "versionamento", "v1", "v2", "semver",
		"deprecation", "deprecação", "sunset", "end of life", "EOL",
		"migration", "migração", "upgrade", "upgrade path",
		"feature flag", "feature toggle", "gradual rollout",
		"schema evolution", "event versioning", "upcasting",
		"API versioning", "URL versioning", "header versioning",
		"changelog", "release notes", "breaking notice",
		"contract", "interface stability", "SLA de API",
		"strangler fig", "parallel run", "blue-green",
		"additive change", "non-breaking", "optional field",
	]
	excludeWhen: [
		"a decisão é sobre dívida técnica interna — usar technical-debt-as-strategic-instrument",
		"a decisão é sobre design inicial de API — usar api-design-as-product",
		"a decisão é sobre event catalog e event sourcing patterns — usar event-driven-architecture-patterns",
		"a decisão é sobre contract testing entre BCs — usar testing-and-validation-for-financial-systems",
		"a decisão é sobre design de schemas CUE — usar documentation-as-product",
	]
	rationale: "Infraestrutura financeira que pretende ser inevitável não pode quebrar quem depende dela. Cada participante da Mesh (fornecedor, construtora, FIDC) constrói processos, integrações e sistemas internos que dependem de APIs, eventos e data models da plataforma. Uma breaking change na API da Mesh quebra: o ERP da construtora que integrou, o sistema do FIDC que consome relatórios, a automação do fornecedor que submete operações. Cada break: horas de retrabalho para o participante + erosão de confiança na plataforma + risco de churn. TD cobre dívida técnica interna (como evoluir código internamente). API cobre design inicial (como projetar boas interfaces). EDA cobre schemas de eventos. TV cobre contract testing. Esta lens cobre o problema sistêmico de longo prazo: como a Mesh evolui por 20 anos sem forçar participantes a reconstruir integrações — versionamento, deprecation paths, migration assistida, backwards-compatible schema evolution, feature flags, e comunicação de mudanças. A Bloomberg Terminal pode mudar internamente o que quiser, mas o Terminal nunca quebra o workflow do trader."
}

concepts: [
	{
		id:         "pe-compatibility-classification"
		name:       "Classificação de Compatibilidade: Que Mudança Quebra o Quê"
		nature:     "theoretical"
		role:       "framework"
		definition: "Nem toda mudança é breaking. Classificação: **(1) Additive (non-breaking):** adiciona sem alterar o existente. Novo campo opcional em response. Novo endpoint. Novo evento no catálogo. Novo valor em enum (se consumer trata unknown values gracefully). Impacto: zero para consumers existentes — eles ignoram o novo. **(2) Behavioral (potentially breaking):** muda semântica sem mudar schema. Endpoint retorna mesmos fields mas com cálculo diferente (score v2.4 vs v2.3 — mesmo schema, valores diferentes). Response time muda significativamente. Rate limit muda. Validation rule muda (antes aceitava valor X, agora rejeita). Impacto: consumer não quebra tecnicamente mas pode quebrar logicamente (esperava behavior A, recebe behavior B). **(3) Breaking (definitely breaking):** remove campo required. Renomeia campo. Muda tipo de campo. Remove endpoint. Muda authentication scheme. Muda error code meaning. Impacto: consumer quebra — código que lê campo removido: NullPointerException ou equivalente. Conceito de 'Hyrum's Law' (Hyrum Wright, Google): 'with a sufficient number of users of an API, all observable behaviors of your system will be depended on by somebody.' Implicação: QUALQUER mudança que altera behavior observable é potencialmente breaking para alguém. Exemplo: ordenação de results (não especificada no contrato, mas consumer depende da ordem 'acidental'). Conceito contemporâneo de 'compatibility as trust' (2024+): backwards compatibility é trust signal. Se API nunca quebra: integrador confia e investe mais na integração. Se API quebra regularmente: integrador investe minimamente (prepare to rewrite) ou desiste. For infrastructure that aspires to be 'rails that others build on': compatibility IS the product."
		meshManifestation: "Na Mesh, mudanças classificadas: **Additive (safe, do freely):** novo campo em OperationApproved event (e.g., add approval_notes: optional string). Novo endpoint GET /operations/{id}/timeline. Novo filtro em GET /operations (e.g., ?score_min=60). Novo status value (e.g., 'em_mediação'). **Behavioral (caution, communicate):** scoring model update (v2.3→v2.4): mesmo schema, scores podem mudar. Score threshold change: 60→65 means previously-approved operations would now be rejected. Rate limit tightened: 100→50 req/min. Pagination default changed: 20→10 items per page. **Breaking (never without migration path):** remove campo from event (approved_at → removed). Rename campo (approved_at → approval_timestamp). Change tipo (score: int → float). Remove endpoint. Change auth (API key → OAuth2). Rename enum value ('aprovada' → 'approved')."
		meshImplication: "Classification-driven process: (1) **every change classified** — PR description includes: change type (additive/behavioral/breaking). If additive: deploy freely. If behavioral: communication + advance notice. If breaking: migration path + deprecation period + advance notice. (2) **CI classification** — automated: schema diff detects: field removed (breaking), field added optional (additive), field type changed (breaking), endpoint removed (breaking). PR automatically labeled. Breaking change without migration plan: merge blocked. (3) **Hyrum's Law mitigation** — document ALL observable behaviors in contract: 'results are returned in creation order (ascending).' 'Pagination default is 20.' 'Score is integer 0-100.' If behavior is documented: changing it is breaking. If undocumented: changing it is behavioral (communicate but less formal). Over time: document more behaviors → fewer surprises. (4) **compatibility budget** — per year: zero breaking changes without migration path is the target. Behavioral changes: ≤4 per year with 30-day advance notice. Additive: unlimited. Budget forces discipline: 'is this change important enough to spend compatibility budget on?' Anti-pattern: 'small breaking change, nobody will notice' — Hyrum's Law says somebody depends on it. What seems small to platform: hours of debugging for integrator."
		rationale: "Hyrum's Law (Google). Compatibility as trust 2024+. Na Mesh, compatibility is the product for B2B infrastructure. API that breaks quarterly: integradores invest minimally. API that never breaks: integradores build deep integrations. Deep integration = switching cost = retention."
	},
	{
		id:         "pe-api-versioning-strategy"
		name:       "Estratégia de Versionamento de API: Coexistência de Múltiplas Versões"
		nature:     "operational"
		role:       "method"
		reviewCadence: "annual"
		definition: "When breaking change is unavoidable: new API version. Versioning strategies: **(1) URL path versioning** — /v1/operations, /v2/operations. Most explicit. Easy to route. Consumer: changes URL. Downside: N versions = N route sets to maintain. **(2) header versioning** — Accept: application/vnd.mesh.v2+json. Consumer: changes header. URL unchanged. Less explicit but cleaner URLs. **(3) query parameter** — /operations?version=2. Rarely used, least clean. For Mesh B2B: **URL path versioning recommended** — most explicit, easiest for integradores to understand and implement. Financial integrations value clarity over elegance. Conceito de 'version lifecycle' (2023+): each API version has lifecycle: **preview** (beta, may change, no SLA) → **stable** (production, full SLA, no breaking changes within version) → **deprecated** (still functional, notice to migrate, deadline communicated) → **sunset** (removed, returns 410 Gone). Timelines: preview → stable: when ready. Stable → deprecated: when v(N+1) is stable. Deprecated → sunset: minimum 12 months for B2B financial (integradores need time to budget and execute migration). Conceito de 'version coexistence' (2024+): multiple versions run simultaneously. v1 and v2 both serve requests. v1 reads same data as v2 (shared backend), but API response shape differs. Internal: adapter layer translates internal model → v1 response and internal model → v2 response. Adding v3: add adapter. Removing v1: remove adapter."
		meshManifestation: "Na Mesh, API versioning: (1) **URL path:** /v1/operations, /v2/operations. (2) **initial:** only v1 exists. No versioning overhead. (3) **when v2 needed:** v1 continues serving existing integradores. v2 serves new or migrating integradores. Both: backed by same internal services. Adapter layer: translates internal Operation model → v1 OperationResponse (with approved_at field) and → v2 OperationResponse (with approval_timestamp field + new fields). (4) **deprecation:** when v2 is stable (3+ months, all new integradores on v2): v1 enters deprecation. Notice: 'v1 is deprecated. Migration guide: [link]. Sunset date: [12 months from now]. After sunset: v1 returns 410 Gone.' (5) **sunset:** v1 adapter removed. Endpoints return 410 with message: 'API v1 has been sunset. Please migrate to v2. Guide: [link].' (6) **lifecycle tracking:** API version status in mesh-spec: {v1: deprecated, sunset: 2027-06-01, migration_guide: /docs/migrate-v1-v2}."
		meshImplication: "Versioning implementation: (1) **router:** /v1/* → v1 adapter → internal service. /v2/* → v2 adapter → same internal service. (2) **adapter pattern:** each version has adapter that: transforms internal model → version-specific response. Validates version-specific request → transforms to internal model. Adapter is thin: field mapping + optional field inclusion/exclusion. (3) **shared backend:** v1 and v2 share: database, business logic, events. Only API shape differs. Avoids: maintaining 2 codebases. (4) **deprecation header:** when v1 is deprecated: every v1 response includes header: Deprecation: true, Sunset: 2027-06-01, Link: <migration_guide_url>. Consumer can detect programmatically and alert their team. (5) **usage tracking:** per API version: request count per day. When v1 usage → 0: safe to sunset early (no one using). When v1 usage: 500 req/day with 3 consumers: contact those 3, assist migration, then sunset. (6) **maximum simultaneous versions:** 2 (current + previous). Never 3. If v3 needed: v1 must be sunset first. 2 versions: manageable. 3+: maintenance nightmare. (7) **migration guide:** for each version transition: dedicated document. 'v1 → v2: field approved_at renamed to approval_timestamp. New fields: approval_notes (optional), approver_role (optional). Removed fields: none. Action required: update field name in your integration. Estimated effort: 1-2 hours.' (8) **migration assistance:** for top integradores (by volume): direct outreach, dedicated support channel, review of their migration plan. For self-serve: guide + FAQ + sandbox with v2. Anti-pattern: 3 active API versions simultaneously — each requires adapter, testing, documentation, support. Maintenance cost scales linearly with version count. Max 2: discipline to sunset."
		dependsOn: ["pe-compatibility-classification"]
		crossDependsOn: [{
			lensId:    "lens-api-design-as-product"
			conceptId: "api-versioning-evolution"
			context:   "API lens defines initial API design including versioning strategy. PE lens covers the ongoing evolution: when to create new version, how long to maintain old, how to migrate consumers, when to sunset. API lens says 'design v1 well'; PE lens says 'when v2 is needed: here's how to transition without breaking v1 consumers.' API is design; PE is lifecycle management."
		}]
		rationale: "Version lifecycle 2023+. Version coexistence 2024+. Na Mesh, URL path versioning: explicit, clear for B2B. 12-month deprecation period: financial integradores need time. Max 2 simultaneous versions: maintenance discipline. Migration guides per transition: reduce integrador effort."
	},
	{
		id:         "pe-event-schema-evolution"
		name:       "Evolução de Schema de Eventos: Histórico Legível para Sempre"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Em event sourcing: eventos são imutáveis e persistidos forever. Schema do evento PODE evoluir (add fields, change structure), mas eventos antigos escritos com schema antigo DEVEM continuar legíveis. Conceito de 'schema compatibility modes' (Confluent 2020+): **(1) backward compatible:** new schema can read old data. Consumer using new schema: reads events written with old schema. Achieved by: only adding optional fields, never removing or changing required fields. **(2) forward compatible:** old schema can read new data. Consumer using old schema: reads events written with new schema (ignores unknown fields). Achieved by: consumers ignore unknown fields. **(3) full compatible:** both backward AND forward. Most restrictive. Best for long-lived event stores. Conceito de 'upcasting' (Axon Framework, Greg Young 2015+): when reading old event with new schema: runtime transformation. Event v1 {approved_at: datetime} read by system expecting v2 {approval_timestamp: datetime}: upcaster transforms v1 → v2 at read time. Old event unchanged in store. New code works with new field name. Transformation: transparent. Concepto de 'event versioning' (2024+): events have explicit version. OperationApproved.v1, OperationApproved.v2. Event store: stores event with version metadata. Consumer: handles multiple versions (via upcasters or multi-version handlers)."
		meshManifestation: "Na Mesh, event schema evolution: (1) **backward compatibility as default:** new fields in events: always optional with default value or nullable. Old events (without new field): readable by new consumers (field is null/default). (2) **upcasting for structural changes:** if field must be renamed (approved_at → approval_timestamp): upcaster at read time: read v1 event, transform to v2 representation. Old events: unchanged in event store. New code: receives v2 format. (3) **event versioning:** OperationApproved has header: {event_type: 'OperationApproved', version: 2, ...}. Consumer: switch on version → apply appropriate handler or upcaster. (4) **never delete old events:** event store is append-only. Old events with old schema: preserved forever. Upcasters: bridge old→new at read time. (5) **schema registry for events:** every event version registered in schema registry (CUE or JSON Schema). New version: compatibility check against previous. Backward-incompatible: rejected by registry."
		meshImplication: "Event evolution implementation: (1) **schema registry in mesh-spec:** /schemas/events/OperationApproved/v1.cue, /schemas/events/OperationApproved/v2.cue. Each version: complete schema. Compatibility: v2 is backward-compatible with v1 (all v1 fields present, new fields optional). (2) **CI compatibility check:** PR that modifies event schema: automated check — new version backward compatible with previous? If not: blocked. Tool: CUE constraints, JSON Schema compatibility checker, or custom script. (3) **upcaster registry:** code: map of (event_type, old_version) → upcaster function. When reading event: if event.version < current: apply upcaster chain (v1→v2→v3 if needed). Upcasters: pure functions, no side effects, deterministic. Tested: unit test per upcaster with sample old events. (4) **consumer resilience:** consumers MUST handle unknown fields (ignore, not error). If new field appears in event v2 that consumer doesn't know: skip field, continue processing. JSON: standard (ignore unknown). Protocol buffers: standard. CUE: configurable. (5) **event store migration (avoid):** prefer upcasting (transform at read time) over event store migration (rewrite old events with new schema). Migration: risky (modifying immutable data), slow (millions of events), and loses original representation. Upcasting: zero risk (original preserved), lazy (only when read), reversible (change upcaster). Exception: if old schema has security vulnerability (PII that shouldn't have been stored): migration to redact. (6) **deprecation of event versions:** old event versions never removed from store. But: upcaster for very old versions can be promoted to automated migration (batch rewrite) if performance of on-read upcasting is insufficient for very old events with many version hops. Anti-pattern: changing event schema in place ('just update the CUE file') without versioning — old events in store become unreadable by new code. Or: rewriting entire event store to match new schema — massive, risky, and destroys historical record."
		dependsOn: ["pe-compatibility-classification"]
		crossDependsOn: [{
			lensId:    "lens-event-driven-architecture-patterns"
			conceptId: "eda-event-sourcing"
			context:   "EDA defines event sourcing: events as source of truth, append-only, immutable. PE event schema evolution is the long-term consequence: how do immutable events evolve as business evolves? EDA says 'events are immutable truth'; PE says 'schema changes via versioning + upcasting, never by modifying stored events.' EDA is the pattern; PE is the evolution strategy that makes the pattern sustainable over years."
		}]
		rationale: "Schema compatibility Confluent 2020+. Upcasting Greg Young 2015+. Event versioning 2024+. Na Mesh with event sourcing, eventos de 2025 devem ser legíveis em 2035. Upcasting: v1→v2→v3 chain transforms at read time. Original event: preserved. New code: works. Historical replay: works."
	},
	{
		id:         "pe-deprecation-and-sunset"
		name:       "Deprecation e Sunset: Remover Funcionalidade Sem Surpresa"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Deprecation é o processo de sinalizar que funcionalidade será removida. Sunset é a remoção efetiva. Conceito de 'deprecation ceremony' (2023+): deprecation é decisão formal com comunicação proativa: (1) **announcement** — communicate to all consumers: what is deprecated, why, when it will be removed, what replaces it, how to migrate. (2) **deprecation period** — functionality still works but marked. Headers, docs, dashboard: all indicate deprecated status. Length: proportional to impact. API endpoint used by 50 integradores: 12 months minimum. Internal tool used by 2 people: 1 month. B2B financial: always generous (12+ months). (3) **migration support** — guide, tooling, sandbox, direct assistance for top consumers. (4) **usage monitoring** — track deprecated endpoint usage. When → 0: safe to sunset. When still used: contact remaining users, assist, extend if needed. (5) **sunset** — functionality removed. Returns 410 Gone with message pointing to replacement. Conceito de 'API sunset policy' (Stripe, 2019+): published policy that consumers can rely on: 'we will never remove an API version with less than 12 months notice. Deprecated versions: list on our status page with sunset dates.' Policy is contract: consumers plan around it."
		meshManifestation: "Na Mesh, deprecation process: (1) **API version deprecation:** ADR: 'deprecate v1 in favor of v2.' Communication: email to all API consumers, dashboard notice, docs update. Deprecation header in v1 responses: {Deprecation: true, Sunset: 2027-06-01, Link: /docs/migrate-v1-v2}. Migration guide published. (2) **endpoint deprecation within version:** rarely needed (version handles this). But if single endpoint must be replaced: new endpoint + deprecation notice on old + dual operation during transition. (3) **event version deprecation:** old event versions never sunset (they exist in store forever). But: producer stops emitting v1, only emits v2. Consumers: upcaster handles v1 reads. Effectively: v1 is frozen, v2 is active. (4) **feature deprecation:** feature removed from platform (e.g., old report type replaced by new). Communication: 30-day notice in dashboard. Feature: disabled on sunset date. Data: preserved (accessible via new feature)."
		meshImplication: "Deprecation implementation: (1) **deprecation registry** — mesh-spec document: list of all deprecated items with: item (endpoint, field, event version, feature), reason, replacement, deprecated_since, sunset_date, migration_guide, usage_count, consumers_contacted. Reviewed quarterly. (2) **automated communication** — when item enters deprecation: automated email to all consumers who have used it in last 90 days. Monthly reminder during deprecation period. 30 days before sunset: final notice. (3) **deprecation header middleware** — API middleware: if request hits deprecated endpoint/version: add Deprecation + Sunset + Link headers to response. Consumer can detect programmatically. (4) **usage dashboard** — per deprecated item: daily request count. Trend: declining? Who's still using? Contact list for outreach. Graph: usage over deprecation period. Target: zero at sunset date. (5) **sunset enforcement** — on sunset date: item returns 410 Gone with: 'This endpoint/version has been sunset. Replacement: [URL]. Migration guide: [URL].' Not 404 (which suggests 'never existed'). 410 is specific: 'existed, now gone.' (6) **sunset policy** — published in docs and API terms: 'Mesh API Sunset Policy: minimum 12 months notice for API version sunset. Minimum 3 months for individual endpoint deprecation within stable version. Current deprecations: [list with dates].' Policy is platform commitment. Violation: erodes trust. (7) **grace period** — if consumer still using at sunset date: option to extend by 30 days (once) with direct communication: 'we've extended your access by 30 days. Please prioritize migration. Support: [contact].' Not indefinite extension — that defeats purpose. Anti-pattern: sunset without notice — endpoint returns 404 one morning. Consumer: production failure, emergency debugging, angry support ticket. Trust: destroyed. Or: deprecation announced but never sunset — 'deprecated since 2023' still running in 2030. Maintenance cost: ongoing. Consumers: never migrate because 'it still works.'"
		dependsOn: ["pe-compatibility-classification", "pe-api-versioning-strategy"]
		rationale: "Deprecation ceremony 2023+. API sunset policy Stripe 2019+. Na Mesh, 12-month deprecation for API versions: generous but necessary for B2B financial. Migration guide + direct outreach + usage monitoring + automated headers: consumer never surprised. Sunset policy: published commitment that consumers trust."
	},
	{
		id:         "pe-feature-flags-and-gradual-rollout"
		name:       "Feature Flags e Rollout Gradual: Lançar sem Forçar Adoção"
		nature:     "operational"
		role:       "method"
		reviewCadence: "quarterly"
		definition: "Feature flags decouple deployment from release: code is deployed but feature is off by default. Turned on per-tenant, per-user, or per-percentage. Conceito de 'flag-driven evolution' (2023+): new feature deployed behind flag → enabled for internal testing → enabled for beta tenants → enabled for all tenants gradually → flag removed (feature is default). Benefits: (1) safe rollout — if issue: disable flag (instant rollback, no redeploy). (2) per-tenant adoption — construtora A gets feature now, construtora B gets next week (based on readiness). (3) A/B testing — 50% with feature, 50% without, compare outcomes. (4) migration enablement — new API behavior behind flag. Tenant migrates integration, enables flag, validates, confirms. At their pace, not platform's pace. Conceito de 'flag lifecycle' (2024+): flags are not permanent. Flag is born (feature development) → lives (gradual rollout) → dies (feature is universal → flag removed from code). Permanent flags: maintenance burden. Each flag: doubles code paths. 10 permanent flags: 1024 potential code path combinations. Flag cleanup: as important as flag creation."
		meshManifestation: "Na Mesh, feature flags usage: (1) **new scoring model:** flag 'scoring_v2.4'. Deploy: code for v2.3 and v2.4 coexist. Flag off: all tenants use v2.3. Enable for construtora X (early adopter): construtora X uses v2.4, all others v2.3. Shadow mode: compare results. Enable for all: v2.4 is default. Remove flag: v2.3 code removed. (2) **new API behavior:** flag 'api_v2_operations_response'. When on: /v1/operations returns v2-style response (gradual migration path). Tenant enables flag when ready for new format. (3) **new feature:** flag 'batch_operations'. Deploy: batch approval code exists. Enable for construtora X (beta). Feedback. Fix issues. Enable for all. Remove flag. (4) **regulatory change:** flag 'new_fidc_reporting_format'. Enable when regulation takes effect. All FIDCs: switch simultaneously on regulation date."
		meshImplication: "Feature flag implementation: (1) **flag types:** boolean (on/off), percentage (0-100% of requests), tenant-specific (list of org_ids), user-specific (list of user_ids). (2) **flag evaluation:** per-request: check flag value for requesting tenant/user. Cached: flag values cached locally with TTL (30s-5min). Not: database query per request. (3) **flag management:** admin dashboard or config file. Create flag, set rollout (percentage, tenant list), monitor, remove. (4) **flag in code:** if (featureFlags.isEnabled('batch_operations', tenant_id)) { // new behavior } else { // old behavior }. Clean: both paths well-tested. Ugly: nested flags (if A and B and C) — limit nesting. (5) **flag lifecycle enforcement:** every flag: created with planned removal date. 'batch_operations: created 2026-03-01, expected removal: 2026-06-01.' Quarterly review: flags past expected removal: clean up or justify extension. Target: <10 active flags at any time. (6) **flag for migration:** when breaking API change is needed: (a) deploy new behavior behind flag. (b) notify consumers: 'new behavior available via flag X. Enable at your pace. Guide: [link].' (c) consumer enables flag, tests, confirms. (d) after all consumers on new behavior: flag becomes default. (e) after deprecation period: old behavior removed, flag removed. Migration is consumer-driven, not platform-imposed. (7) **testing with flags:** both code paths (flag on, flag off) are tested in CI. Every flag: at least 2 test scenarios (on and off). If only testing one path: other path may break silently. (8) **for agents:** CLAUDE.md: 'when implementing feature that changes existing behavior: use feature flag. Deploy behind flag. Never change existing behavior for all tenants simultaneously without flag.' Anti-pattern: 100 feature flags accumulated over 2 years, none removed — 2^100 theoretical code path combinations. Flag debt is real. Lifecycle enforcement: flags are temporary by design."
		dependsOn: ["pe-compatibility-classification"]
		crossDependsOn: [{
			lensId:    "lens-cold-start-and-network-bootstrapping"
			conceptId: "cs-sequencing-expansion"
			context:   "CS defines sequencing — rolling out to segments sequentially. PE feature flags enable sequencing at feature level: new capability launched to segment A (early adopter construtoras), validated, then segment B. CS is the strategy ('which segment first'); PE provides the mechanism (feature flags per tenant). CS says 'bowling pin strategy: first pin is construtora segment A'; PE says 'batch_operations flag enabled for segment A first.'"
		}]
		rationale: "Flag-driven evolution 2023+. Flag lifecycle 2024+. Na Mesh, feature flags: decouple deploy from release. Safe rollout: instant rollback via flag. Consumer-paced migration: enable flag when ready. Lifecycle: flags are temporary, cleaned up quarterly. <10 active flags at any time."
	},
	{
		id:         "pe-data-model-evolution"
		name:       "Evolução de Data Model: Schema de Database que Cresce sem Quebrar"
		nature:     "operational"
		role:       "method"
		reviewCadence: "semi-annual"
		definition: "Database schema evolution must be backward compatible with running application (zero-downtime migrations). Conceito de 'expand-and-contract migration' (2023+): breaking schema change split into 3 safe steps: (1) **expand:** add new column/table alongside old. Both exist. Application writes to both, reads from old. (2) **migrate:** backfill new column from old data. Verify consistency. Application switches to read from new. (3) **contract:** remove old column after all application versions read from new. Each step: independently deployable, independently rollbackable. Never: rename column in 1 step (breaks running application that reads old name). Conceito de 'online schema migration' (GitHub gh-ost 2016, pt-online-schema-change): tools that modify schema without locking table. For financial databases with 24/7 operation: table lock = downtime = unacceptable. Online migration: creates shadow table, syncs writes, swaps atomically. Conceito de 'immutable schemas for audit' (2024+): audit-relevant schemas (ledger, operations) should avoid destructive changes. Add columns: yes. Remove columns: archive data first, then remove. Rename: expand-and-contract. Audit trail must be interpretable retroactively."
		meshManifestation: "Na Mesh, data model evolution examples: (1) **add field to operation:** add column approval_notes TEXT NULL. Migration: ALTER TABLE operations ADD COLUMN approval_notes TEXT. Non-breaking: old code ignores new column (doesn't read it). New code: reads if present. (2) **rename field:** approved_at → approval_timestamp. Expand: ADD approval_timestamp TIMESTAMP. Backfill: UPDATE SET approval_timestamp = approved_at. Application: write to both, read from approval_timestamp. Contract (after all code updated): DROP approved_at. 3 PRs, 3 deploys, zero downtime. (3) **change type:** score INT → score DECIMAL(5,2). Expand: ADD score_decimal DECIMAL(5,2). Backfill: UPDATE SET score_decimal = score. Application: switch to score_decimal. Contract: DROP score, RENAME score_decimal TO score. (4) **split table:** operations table → operations + operation_timeline. Expand: create operation_timeline table, write events to both. Migrate: backfill operation_timeline from operations. Contract: remove event columns from operations."
		meshImplication: "Data model evolution rules: (1) **additive changes only in single deploy:** ADD COLUMN (nullable or with default), ADD TABLE, ADD INDEX. These: non-breaking, applied instantly. (2) **breaking changes via expand-and-contract:** rename, type change, split, remove: always 3-step. Each step: separate PR, separate deploy, verified independently. (3) **zero-downtime migrations:** use online migration tools for large tables. Operations table with millions of rows: ALTER ADD COLUMN locks table briefly (PostgreSQL is good at this for nullable). ALTER SET NOT NULL or ADD INDEX on large table: use concurrent index creation or online migration tool. (4) **migration testing:** every migration: tested on copy of production data (schema + representative data volume). Verify: migration completes in <5 minutes (acceptable maintenance window) or runs online. Verify: application works with schema pre-migration AND post-migration (rolling deploy: both old and new app versions may run simultaneously). (5) **rollback plan:** every migration: documented rollback. Expand step: rollback = drop new column. Migrate step: rollback = revert application to read old. Contract step: rollback = re-add old column (data may need re-backfill). Rollback tested. (6) **audit schema protection:** ledger and operation tables: never destructively modify columns that contain historical data. If column must be changed: expand-and-contract with data preservation. Audit queries from 2025 must work in 2035. (7) **for agents:** CLAUDE.md: 'database schema changes: additive only in single deploy (ADD COLUMN nullable). For rename/type change/remove: use expand-and-contract (3 PRs). Never: DROP COLUMN in same deploy as code that stops writing to it.' Anti-pattern: ALTER TABLE operations RENAME COLUMN approved_at TO approval_timestamp deployed simultaneously with code change — 30-second window during rolling deploy where old code reads approved_at (column no longer exists) → production errors."
		dependsOn: ["pe-compatibility-classification"]
		rationale: "Expand-and-contract 2023+. Online migration GitHub 2016. Immutable audit schemas 2024+. Na Mesh, zero-downtime migration: expand-and-contract for breaking changes, additive-only for non-breaking. Financial database with 24/7 operation: table lock is not acceptable. Each step: independently deployable, independently rollbackable."
	},
	{
		id:         "pe-changelog-and-communication"
		name:       "Changelog e Comunicação: Participantes Sempre Sabem o que Muda e Quando"
		nature:     "operational"
		role:       "method"
		reviewCadence: "monthly"
		definition: "For infrastructure that others build on: changes must be communicated proactively, clearly, and with adequate lead time. Conceito de 'developer-facing changelog' (2023+): structured record of all changes visible to consumers: (a) **changelog per release:** date, version, changes categorized (added, changed, deprecated, removed, fixed, security). Format: Keep a Changelog standard. (b) **breaking change notice:** dedicated communication for breaking changes: what changed, why, impact, migration guide, timeline. Sent: email + dashboard notice + API header. (c) **roadmap communication:** upcoming changes shared in advance. Not commitment — direction. 'We plan to add batch operations in Q2 and deprecate v1 in Q3.' Consumers: can plan. Concepto de 'status page for API' (2024+): real-time page showing: API status (operational, degraded, outage), current versions and their status (stable, deprecated, sunset date), upcoming changes with dates, historical uptime."
		meshManifestation: "Na Mesh, communication channels: (1) **changelog:** published with every release. Format: date, version, categorized changes. Available: in docs (/changelog), via API (GET /changelog), via RSS feed. (2) **breaking change notice:** for behavioral and breaking changes: email 30 days in advance. Dashboard banner for 30 days. API deprecation headers. Migration guide published simultaneously. (3) **roadmap:** quarterly update: planned features, planned deprecations, planned breaking changes. Published in developer portal. Caveat: 'subject to change.' (4) **status page:** real-time: API operational status, version status, next planned maintenance, deprecation timeline."
		meshImplication: "Communication implementation: (1) **changelog discipline:** every PR merged to main: developer writes changelog entry. Format: '### Added\n- New field `approval_notes` on OperationApproved event (optional)\n### Deprecated\n- v1 endpoint /operations: use v2. Sunset: 2027-06-01.' CI: PR without changelog entry for user-visible change: warning. (2) **automated release notes:** changelog entries aggregated per release. Published automatically to: docs, developer portal, RSS. (3) **email communication:** for deprecation and breaking: automated email to consumers who used affected functionality in last 90 days. Template: what changed, why, impact, migration guide, deadline, support contact. (4) **dashboard notices:** for deprecation: banner in consumer's dashboard (construtora, FIDC): 'API v1 será descontinuada em 01/06/2027. Migre para v2. [Guia de migração].' Dismissable but reappears monthly. (5) **API status endpoint:** GET /api/status → {status: 'operational', versions: [{version: 'v1', status: 'deprecated', sunset: '2027-06-01'}, {version: 'v2', status: 'stable'}], upcoming_changes: [...]}. Consumer: can check programmatically. (6) **developer portal:** central hub: documentation, changelog, roadmap, deprecation timeline, migration guides, sandbox, API status. Not scattered across email/docs/dashboard — one place for everything. (7) **SLA for communication:** minimum: 12 months notice for version sunset. 30 days notice for behavioral change. 0 days for additive (changelog only). SLA published in API terms. Anti-pattern: breaking change deployed Monday morning, changelog entry added Thursday afternoon, consumers discover via production failure — trust destroyed."
		dependsOn: ["pe-deprecation-and-sunset"]
		crossDependsOn: [{
			lensId:    "lens-developer-and-integrator-experience"
			conceptId: "dx-changelog-migration"
			context:   "DX defines developer experience including changelog and migration support. PE extends to long-term evolution: DX covers how to communicate changes well; PE covers the multi-year strategy of when and how to evolve while preserving compatibility. DX is 'great changelog format'; PE is 'changelog as part of 12-month deprecation ceremony with automated notices and usage tracking.'"
		}]
		rationale: "Developer-facing changelog 2023+. Status page 2024+. Na Mesh, comunicação de mudanças é tão importante quanto a mudança: consumer that learns via production failure loses trust. Consumer that learns 12 months in advance via email + dashboard + API header: plans and migrates smoothly."
	},
	{
		id:         "pe-internal-evolution-freedom"
		name:       "Liberdade de Evolução Interna: Mudar Tudo por Dentro sem Mudar Nada por Fora"
		nature:     "theoretical"
		role:       "heuristic"
		definition: "O objetivo de backwards compatibility não é nunca mudar — é isolar mudanças internas de interfaces externas. Conceito de 'interface stability with internal freedom' (2024+): as long as external interfaces (API responses, event schemas, webhook payloads) are stable: internal architecture can change freely. Refactor code, change database, migrate cloud provider, rewrite service — consumer never knows. This is the architectural goal: maximum internal velocity with maximum external stability. Conceito de 'hexagonal architecture for evolution' (Cockburn 2005, applied to evolution 2024+): ports (external interfaces) are stable contracts. Adapters translate between stable ports and evolving internal domain. Internal domain changes: adapter is updated. Port: unchanged. Consumer: unaffected. Na prática: API response schema is the port. Adapter maps internal model → API response. Internal model changes: adapter changes. API response: unchanged."
		meshManifestation: "Na Mesh, internal evolution protected by interface stability: (1) **scoring engine rewrite:** internal scoring engine migrated from rule-based to ML model. API: /operations/{id}/score still returns {score: int, zona: string, model_version: string}. Same schema. Different internals. Consumer: unaffected. (2) **database migration:** PostgreSQL + Marten migrated to EventStoreDB. Internal: completely different storage. API and events: identical schemas. Consumer: unaffected. (3) **language migration:** Kotlin service rewritten in Rust for performance. API: identical. Events: identical. Consumer: unaffected. (4) **architecture change:** monolith split into microservices. API: identical (gateway routes to services). Events: identical (produced by whichever service owns the BC). Consumer: unaffected. All these changes: zero breaking for consumers because interfaces are stable contracts."
		meshImplication: "Implementation: (1) **adapter layer as evolution buffer:** every external-facing interface: adapter between internal model and external contract. Change internal: update adapter. External: unchanged. (2) **interface tests as invariant:** for each external interface: tests that verify contract is preserved. These tests: NEVER change when internals change. If internal change requires interface test change: it's a breaking change (trigger compatibility classification). (3) **canary for internal changes:** after internal change: deploy to canary (1% of traffic). Monitor: API responses match expected schema? Events match expected schema? Error rate unchanged? If yes: roll out. If no: rollback. (4) **internal and external change separation:** PR that changes internals: does NOT change external contract (adapter absorbs). PR that changes external: goes through compatibility classification (additive/behavioral/breaking). Separation: enforced by code review + CI. (5) **documentation of interface contracts:** external contracts documented in mesh-spec as the stable surface. Internal architecture documented separately as the evolving surface. Consumer reads: external docs (stable). Platform engineers read: internal docs (current architecture). (6) **freedom budget:** with stable interfaces, platform has freedom to: re-architect for performance, migrate infrastructure for cost, refactor for maintainability, experiment with new technology — all without coordinating with consumers. This freedom is the payoff of investing in interface stability. Anti-pattern: internal and external tightly coupled — changing internal database column name changes API field name changes event field name. Every internal refactor: breaking change. Freedom: zero."
		dependsOn: ["pe-compatibility-classification", "pe-api-versioning-strategy", "pe-event-schema-evolution"]
		rationale: "Interface stability with internal freedom 2024+. Hexagonal architecture Cockburn 2005. Na Mesh, adapter layer between internal domain and external interfaces: internal changes freely, external remains stable. This is the architectural North Star: Bloomberg changes everything internally; Terminal interface is stable for decades."
	},
	{
		id:            "pe-evolution-review"
		name:          "Revisão de Evolução: Inventário Periódico de Compatibilidade e Lifecycle"
		nature:        "operational"
		role:          "method"
		reviewCadence: "quarterly"
		definition:    "Inventário periódico: (1) compatibility — any breaking changes in quarter? Classified and handled per process? (2) API versions — current versions and their lifecycle status? Deprecated versions: migration progress? Sunset dates approaching? (3) event schemas — any schema changes? Compatible? Upcasters tested? (4) deprecation — items in deprecation: usage trending to zero? Consumers contacted? Sunset dates on track? (5) feature flags — active flags: <10? Any past expected removal date? Cleanup needed? (6) data model — any expand-and-contract in progress? All steps completed? (7) communication — changelog up-to-date? Deprecation notices sent? Roadmap published? (8) internal freedom — any internal change that inadvertently changed external interface? Tests caught it?"
		meshManifestation: "Na Mesh: revisão trimestral. Deprecation tracker + flag inventory + schema compatibility status."
		meshImplication: "Quarterly (1h): (a) deprecation tracker — all deprecated items: status, usage, sunset date. Items approaching sunset with usage >0: contact consumers, assist. (b) flag inventory — list active flags. Count: <10? Flags past expected removal: clean up this quarter. (c) schema compatibility — any event schema changes this quarter: all backward compatible? Schema registry: no violations? (d) API versions — v1 (if deprecated): usage declining? Migration guide available? (e) changelog — reviewed: every user-visible change has changelog entry? Breaking changes have 30-day advance notice? (f) internal changes — any refactoring this quarter: external tests still passing? Adapter layer absorbed changes? (g) roadmap — next quarter: planned deprecations? Planned breaking changes? Communicate in advance."
		dependsOn: ["pe-compatibility-classification", "pe-api-versioning-strategy", "pe-event-schema-evolution", "pe-deprecation-and-sunset", "pe-feature-flags-and-gradual-rollout", "pe-data-model-evolution", "pe-changelog-and-communication", "pe-internal-evolution-freedom"]
		rationale: "Platform evolution is continuous. Without review: deprecated items linger forever, flags accumulate, schema compatibility degrades, changelog falls behind, consumers are surprised. Quarterly review: maintains evolution discipline."
	},
]

reasoningProtocol: [
	{
		question:  "A mudança proposta é additive, behavioral, ou breaking? Está classificada e o processo correto está sendo seguido?"
		reveals:   "Se evolução é disciplinada — ou se mudanças são deployadas sem classificar impacto em consumers."
		rationale: "Hyrum's Law: all observable behaviors are depended on. Classification: first step of responsible evolution."
	},
	{
		question:  "API versioning usa URL path com max 2 versões simultâneas? Deprecated version tem sunset date e migration guide?"
		reveals:   "Se consumers têm clarity sobre lifecycle — ou se versões acumulam indefinidamente sem plano de sunset."
		rationale: "Version lifecycle 2023+. Max 2 simultaneous: manageable. Migration guide: consumer knows how to transition."
	},
	{
		question:  "Event schema evolution é backward compatible? Upcasters existem para versões antigas? Schema registry valida compatibility?"
		reveals:   "Se eventos históricos são legíveis forever — ou se schema change quebra replay de eventos antigos."
		rationale: "Confluent 2020+. Upcasting 2015+. Event sourcing: events are forever. Schema must evolve without breaking history."
	},
	{
		question:  "Deprecation tem 12+ meses de notice para B2B financial? Usage monitoring mostra quem ainda usa? Migration assistance oferecida?"
		reveals:   "Se consumers são respeitados no processo — ou se sunset é surpresa."
		rationale: "Stripe sunset policy. 12 months: B2B financial integrations need time to budget and execute migration."
	},
	{
		question:  "Feature flags são usados para rollout gradual? Lifecycle enforced (<10 active, cleanup quarterly)?"
		reveals:   "Se releases são safe e consumer-paced — ou se big-bang deploy forces simultaneous adoption."
		rationale: "Flag-driven evolution 2023+. Flags: decouple deploy from release. Lifecycle: prevent flag debt."
	},
	{
		question:  "Data model changes usam expand-and-contract para breaking changes? Zero-downtime migrations?"
		reveals:   "Se database evolui safely — ou se ALTER TABLE em single deploy causa downtime ou application errors."
		rationale: "Expand-and-contract 2023+. Financial database: 24/7. Table lock = unacceptable."
	},
	{
		question:  "Interfaces externas são estáveis enquanto internals mudam livremente? Adapter layer absorve mudanças internas?"
		reveals:   "Se plataforma tem freedom para evoluir internamente — ou se cada refactoring é breaking change."
		rationale: "Hexagonal architecture + interface stability = internal velocity + external trust."
	},
]

meshExamples: [
	{
		id:       "ex-event-schema-rename-safe"
		scenario: "Product team wants to rename OperationApproved event field 'approved_at' to 'approval_timestamp' for naming consistency across all events."
		analysis: "Field rename in event: BREAKING for consumers (NGR reads approved_at). In event sourcing: old events in store have approved_at — new code expecting approval_timestamp can't read them. Double break: consumers AND historical replay."
		recommendation: "(1) DO NOT rename in place. (2) Event schema v2: add approval_timestamp (optional). Keep approved_at (populated from same value). Both fields: present in v2 events. Backward compatible: v1 consumers read approved_at (still there). Forward: v2 consumers read approval_timestamp (new). (3) Upcaster for v1 events: when reading v1 event (has approved_at, no approval_timestamp): upcaster adds approval_timestamp = approved_at. New code: always reads approval_timestamp. (4) Deprecate approved_at in v2 schema: marked @deprecated in schema. Consumers: migrate to approval_timestamp at their pace. (5) v3 (future, 12+ months): remove approved_at. Only approval_timestamp. V1 events: upcaster v1→v2 adds approval_timestamp, upcaster v2→v3 removes approved_at (or v1→v3 direct upcaster). (6) Timeline: v2 released now. v1 deprecated. v3 in 12+ months (after all consumers migrated from approved_at). (7) Total effort: 4 hours (add field + upcaster + consumer notification). vs rename in place: 30 minutes + hours of production debugging + consumer trust damage."
		principlesApplied: ["ax-01", "ax-06"]
		assumptions: ["consumers can handle unknown fields (ignore approval_timestamp if not expecting it) — standard JSON behavior", "12 months is sufficient for all consumers to migrate — B2B financial: yes with proactive communication"]
		rationale: "Schema evolution: additive is safe. Rename is breaking. Safe rename: add new + keep old + upcaster + deprecation + eventual removal. 4 hours of discipline prevents hours of consumer breakage."
	},
	{
		id:       "ex-feature-flag-migration"
		scenario: "Mesh v2 API changes operations response format (flattened structure → nested). Cannot maintain backward compatibility in same endpoint. Need consumers to migrate at their own pace."
		analysis: "Breaking response format change. Option A: deploy v2, break all v1 consumers simultaneously. Option B: v2 endpoint alongside v1 (versioning). Option C: feature flag within v1 that returns v2 format (consumer opts in). Options B and C both work. C is lighter (no new URL, consumer controls timing)."
		recommendation: "(1) Feature flag approach: flag 'v2_operations_response'. Default: off (v1 format). Consumer enables: v2 format from same endpoint. (2) Implementation: middleware checks flag for requesting tenant. Off: v1 adapter renders response. On: v2 adapter renders response. Same internal data, different serialization. (3) Communication: 'New operations response format available. Enable via setting or API flag. Guide: [link]. Current format: supported for 12 more months.' (4) Migration timeline: Month 1: flag available. Top consumers: direct outreach. Month 3: 60% migrated. Month 6: 90% migrated. Month 9: final outreach to remaining 10%. Month 12: flag default=on. Old format: 3-month grace period. Month 15: old format removed. Flag removed. (5) Monitoring: per-tenant: which format are they using? Dashboard: migration progress percentage. Consumers still on old: contacted monthly. (6) Advantage over URL versioning: no new URL to communicate. Consumer: changes 1 setting (or API header). Same endpoint, same authentication, same rate limits. Lighter migration."
		principlesApplied: ["ax-01", "ax-04"]
		assumptions: ["feature flag per tenant is implementable — yes, standard flag infrastructure", "15-month total timeline is acceptable — generous for response format change", "monitoring migration progress is feasible — track flag value per tenant"]
		rationale: "Flag-driven evolution 2023+. Feature flag for migration: consumer controls timing. Platform provides timeline. Migration is collaborative, not forced. 15-month timeline: generous for B2B financial. Result: zero consumers broken, zero surprise, 100% migrated."
	},
	{
		id:       "ex-database-rename-expand-contract"
		scenario: "Technical debt: operations table has column 'dt_aprovacao' (Portuguese) that should be 'approved_at' (English, matching codebase convention). Temptation: ALTER TABLE RENAME COLUMN."
		analysis: "Single ALTER RENAME: during rolling deploy, old application instances read dt_aprovacao (exists), new instances read approved_at (not yet renamed). Window: 30 seconds to 5 minutes of errors. For financial system: 30 seconds of errors = failed operations, potential data inconsistency."
		recommendation: "**Expand-and-contract (3 deploys, zero downtime):** Deploy 1 (expand): ALTER TABLE operations ADD COLUMN approved_at TIMESTAMP. Backfill: UPDATE operations SET approved_at = dt_aprovacao WHERE approved_at IS NULL. Application: writes to BOTH columns. Reads from dt_aprovacao (still primary). Add trigger: BEFORE INSERT OR UPDATE → approved_at = dt_aprovacao (keeps sync). All done: deploy, verify, no breakage. Deploy 2 (switch): application reads from approved_at instead of dt_aprovacao. Writes: still both. All done: deploy, verify, no breakage. If issues: rollback to reading dt_aprovacao (still populated). Deploy 3 (contract): DROP trigger. ALTER TABLE DROP COLUMN dt_aprovacao. Application: reads and writes only approved_at. If issues: cannot easily rollback (column gone). But: deploy 2 verified everything works with approved_at. Total time: 3 deploys over 1-2 weeks. Zero downtime. Zero errors. vs single ALTER RENAME: 30 seconds of errors in financial system."
		principlesApplied: ["ax-01", "ax-06"]
		assumptions: ["trigger-based sync works for PostgreSQL — yes, standard approach", "3 deploys is acceptable overhead — for financial system: absolutely", "backfill of existing rows is fast — depends on table size; for millions: run in batches"]
		rationale: "Expand-and-contract: 3 safe steps instead of 1 risky step. Each step: independently deployable, independently rollbackable. Financial system: 30 seconds of errors is unacceptable. Zero-downtime rename: worth 3 deploys."
	},
	{
		id:       "ex-deprecation-ceremony-api-v1"
		scenario: "Mesh API v2 has been stable for 6 months. 40 consumers on v2, 12 consumers still on v1. Decision: deprecate v1 with 12-month sunset."
		analysis: "12 consumers on v1: each has integration that depends on v1 response format. Migration effort per consumer: 2-10 hours depending on integration complexity. Total: 24-120 person-hours across consumers. Timeline: 12 months is generous. But: consumers won't migrate until deadline approaches (human nature). Proactive: assist early, track progress, escalate late."
		recommendation: "**Deprecation ceremony:** Month 0 — Announcement: (a) email to all 12 v1 consumers: 'API v1 será descontinuada em [date, 12 months from now]. v2 é a versão estável. Guia de migração: [link]. Principais mudanças: [summary]. Suporte: [contact].' (b) changelog entry: 'v1 deprecated.' (c) API responses: Deprecation: true, Sunset: [date] headers on all v1 responses. (d) dashboard banner for v1 consumers: 'Sua integração usa API v1 (deprecated). Migre para v2. [Guia].' (e) deprecation registry in mesh-spec updated. Month 1-3 — Direct outreach to top 5 consumers (by volume): 'podemos agendar sessão de suporte para migração?' Offer: sandbox access for v2 testing, migration review, priority support. Month 3 — Progress check: 6 of 12 migrated (target: 50%). Month 6 — Progress check: 9 of 12 migrated (target: 75%). Remaining 3: direct contact. 'v1 sunset em 6 meses. Como podemos ajudar?' Month 9 — Progress check: 11 of 12 migrated (target: 92%). Remaining 1: escalate. Monthly reminders. Offer: dedicated migration support session. Month 11 — Final notice: 'v1 will be sunset in 30 days. All requests will return 410 after [date].' Month 12 — Sunset: v1 returns 410 Gone with: 'API v1 has been sunset. Please use v2. Migration guide: [link]. Support: [contact].' If last consumer still on v1: 30-day grace extension (once, with direct agreement to migrate within 30 days). Month 13 — Final sunset: no more extensions. v1 code removed. **Total effort:** 20-30 hours platform-side (communication, support, monitoring). **Result:** 12 consumers migrated without production failure. Trust: maintained ('Mesh gives ample notice and helps us migrate')."
		principlesApplied: ["ax-01", "ax-04", "ax-06"]
		assumptions: ["12 months is sufficient — for B2B financial: yes, generous", "consumers will migrate with proactive outreach — most will; 1-2 may need escalation", "30-day grace extension is appropriate — once only, prevents indefinite extension", "20-30 hours platform effort is feasible — spread over 12 months, manageable"]
		rationale: "Stripe sunset policy. Deprecation ceremony 2023+. 12-month ceremony: announcement → outreach → progress tracking → final notice → sunset → grace if needed. No consumer surprised. Every consumer assisted. Trust preserved. vs: sunset without notice → 12 production failures → 12 angry consumers → trust destroyed."
	},
]

principleIds: ["ax-01", "ax-04", "ax-06", "dp-01"]

relatedLenses: [
	{
		lensId:   "lens-api-design-as-product"
		relation: "complementsWith"
		context:  "API lens covers initial design (good endpoints, good naming, versioning strategy). PE covers ongoing evolution: how to transition between versions, deprecate old, migrate consumers. API is birth; PE is lifecycle. Together: well-designed APIs that evolve gracefully."
	},
	{
		lensId:   "lens-event-driven-architecture-patterns"
		relation: "complementsWith"
		context:  "EDA defines event sourcing and event catalog. PE defines how events evolve: schema versioning, upcasting, backward compatibility. EDA says 'events are immutable source of truth'; PE says 'here's how schema changes without breaking that truth.'"
	},
	{
		lensId:   "lens-testing-and-validation-for-financial-systems"
		relation: "complementsWith"
		context:  "TV defines contract testing between BCs. PE defines what compatibility means and when contracts should evolve. TV verifies compatibility; PE defines the compatibility rules. TV catches breaks; PE prevents them by design."
	},
	{
		lensId:   "lens-developer-and-integrator-experience"
		relation: "complementsWith"
		context:  "DX covers developer experience including changelog and migration support. PE covers the multi-year lifecycle: deprecation ceremonies, sunset policies, migration assistance. DX is experience quality; PE is lifecycle management."
	},
	{
		lensId:   "lens-technical-debt-as-strategic-instrument"
		relation: "complementsWith"
		context:  "TD covers internal technical debt. PE covers external compatibility debt: maintaining old API versions, old event schemas, old database columns during migration. PE compatibility debt is intentional (maintaining old for consumers) unlike TD's inadvertent debt. PE debt has sunset date (planned removal); TD debt may linger."
	},
	{
		lensId:   "lens-trust-and-credibility-design"
		relation: "complementsWith"
		context:  "TC builds trust. PE backwards compatibility IS trust: platform that never breaks consumers' integrations is trustworthy. Breaking changes erode trust. 12-month deprecation ceremonies build trust. Published sunset policy: trust signal."
	},
	{
		lensId:   "lens-cold-start-and-network-bootstrapping"
		relation: "complementsWith"
		context:  "CS defines sequencing and gradual expansion. PE feature flags enable: new capability rolled out to early adopters first (CS bowling pin) via feature flag per tenant. CS is strategy; PE is mechanism."
	},
]

limitations: [
	{
		description: "Maintaining 2 simultaneous API versions doubles adapter code and testing effort."
		alternative: "Limit to max 2 versions. Minimize version differences (most changes are additive within version, not new version). Shared backend: only adapter layer differs. Adapter testing: automated (contract tests from TV lens). Total overhead: ~20% of API development effort during dual-version period."
		rationale: "20% overhead for 12 months is the cost of not breaking consumers. Cheaper than: losing consumers from breaking change."
	},
	{
		description: "Upcasting chains for event schema evolution can become long over many years (v1→v2→v3→v4→v5)."
		alternative: "Periodic 'snapshot migration': after 3+ version hops: batch rewrite old events to latest version (preserving original in archive). Upcaster chain: reset. Every 2-3 years: consolidate. Keeps read performance acceptable while preserving historical record."
		rationale: "Upcasting 5 versions per read: performance cost. Periodic consolidation: amortizes cost."
	},
	{
		description: "12-month deprecation period is long for fast-moving startup — slows evolution pace."
		alternative: "12 months for major versions (API v1→v2). 3-6 months for individual endpoint deprecation within version. 1 month for additive changes that change default behavior. Scale notice to impact. Early stage with few consumers: shorter periods acceptable (3-6 months) with direct communication."
		rationale: "Scale notice to impact and stage. Pre-product-market-fit with 5 consumers: 3 months + direct outreach. Post-PMF with 500 consumers: 12 months."
	},
	{
		description: "Feature flags add code complexity (if/else branches) and can accumulate if not cleaned up."
		alternative: "Flag lifecycle enforcement: every flag has removal date. Quarterly cleanup. <10 active flags. CI: warn if flag is past expected removal date. Remove: explicit task in backlog."
		rationale: "Flags are powerful but temporary. Discipline: creation is easy, cleanup is enforced."
	},
	{
		description: "Expand-and-contract for database changes requires 3 deploys for a simple rename — overhead for small changes."
		alternative: "For genuinely simple changes (add nullable column, add index): single deploy is safe. Expand-and-contract: only for changes that would break running application (rename, type change, remove). Classify first: is single-deploy safe? If yes: do it. If no: expand-and-contract."
		rationale: "Expand-and-contract for everything: over-engineering. Only for changes that would break concurrent application versions during rolling deploy."
	},
]

rationale: "Infraestrutura financeira que pretende ser inevitável não pode quebrar quem depende dela. Na Mesh com fornecedores, construtoras e FIDC construindo integrações e processos sobre a plataforma, esta lens operacionaliza: classificação de compatibilidade com Hyrum's Law (additive/behavioral/breaking, Hyrum's Law Google, compatibility as trust 2024+), API versioning com URL path e max 2 versões simultâneas (version lifecycle 2023+, version coexistence 2024+), event schema evolution com backward compatibility e upcasting (Confluent 2020+, Greg Young 2015+, event versioning 2024+), deprecation e sunset com ceremony de 12 meses para B2B financial (deprecation ceremony 2023+, Stripe sunset policy 2019+), feature flags para rollout gradual e migration consumer-paced (flag-driven evolution 2023+, flag lifecycle 2024+), data model evolution com expand-and-contract para zero-downtime (expand-and-contract 2023+, GitHub gh-ost 2016, immutable audit schemas 2024+), changelog e comunicação proativa com 30-day advance notice (developer-facing changelog 2023+, status page 2024+), e liberdade de evolução interna via adapter layer e interface stability (hexagonal architecture Cockburn 2005, interface stability 2024+). A Bloomberg Terminal pode mudar internamente o que quiser, mas nunca quebra o workflow do trader. Este é o modelo: maximum internal freedom, maximum external stability."

}
