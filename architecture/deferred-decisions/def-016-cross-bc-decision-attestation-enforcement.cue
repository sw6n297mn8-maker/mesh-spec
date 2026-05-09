package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-016": artifact_schemas.#DeferredDecision & {
	id:    "def-016"
	title: "Cross-BC technical enforcement de decisionAuthorityModel.authoritativeScope (signature/blocking/attestation infrastructure) — diferido até evidência empírica multi-BC violation pattern"
	date:  "2026-05-09"

	description: """
		Phase 3 Part 2 do WI-046 REW bootstrap (commit em progresso)
		identificou gap critical de production-safety entre
		decisionAuthorityModel='authoritative' (declarado per adr-081
		+ adr-084) e enforcement runtime de cross-BC compliance.

		Estado atual (Phase 3):
		- REW publica evt-risk-evaluation-emitted como contract
		  authoritative para Risk Assessment domain
		- Consumers (CMT, FCE, SCF) DEVEM tratar evaluation como
		  source of truth (decisionAuthorityModel.authoritativeScope)
		- consumerProtocol declarado em systemConsistencyModel
		  (status check, validity check, tolerance window, dedupe
		  by evaluationId, handling supersede/emit-failed/expired)
		- Override formal cross-BC requires explicit ADR documenting
		  rationale

		Gap identificado (founder Phase 3 final pressure test):
		'governança organizacional ≠ garantia de sistema'.
		Consumer pode violar protocolo silently no runtime — usar
		evaluation expirada, ignorar staleness flag, processar
		evaluation post-supersede, OR simplesmente não consumir
		evaluation when authoritative — sem detection runtime.
		Detectável apenas via:
		(a) post-hoc audit periódica de consumer behavior
		(b) compliance review case-by-case
		(c) runtime attestation infrastructure (signature/blocking/
		    attestation — heavy infra)

		Quando threshold trigger fire, decidir:

		(a) Promote technical attestation infrastructure:
		    REW assina evaluation events com cryptographic signature;
		    consumers downstream verificam signature antes de
		    processing; mismatch → reject + alert. Custo: signature
		    library + key management infra + verification overhead
		    runtime per consumer.

		(b) Promote blocking pipeline:
		    REW publishes evaluation via dedicated authoritative
		    channel; consumers subscribe via attested gateway;
		    gateway enforces consumerProtocol compliance via
		    runtime checks. Custo: gateway infrastructure + per-
		    consumer attestation registration + operational complexity.

		(c) Promote runtime attestation protocol:
		    Each consumer decision publishes attestation event
		    declaring 'consumed evaluation X with status Y at time
		    Z'; attestation chain audited cross-BC via dedicated
		    audit subsystem. Custo: attestation event volume +
		    audit subsystem + cross-BC schema for attestation.

		Phase 3 acknowledged limitation: governance via ADR override
		é PRAGMATICAMENTE aceitável when 1 BC consumes (Phase 3 REW
		first; future Phase 3 outros BCs adicionarão consumers);
		torna-se INACEITÁVEL operacionalmente quando ≥3 consumers
		declaram authoritative dependency E violation pattern emerge
		em audit. Heavy infra (signature/blocking/attestation) é
		justificável apenas com evidence empírica.
		"""

	deferralRationale: """
		Cross-BC technical enforcement infrastructure é decisão
		arquitetural com cascade impact massivo (signature library
		cross-BC + key management + gateway + attestation events) —
		exige evidence empírica de recurrence violation justificar
		custo. Phase 3 REW single BC + governance via ADR override
		é blast radius mínimo: substância preservada via consumer-
		Protocol prose + decisionAuthorityModel.authoritativeScope
		declared; technical enforcement segue quando padrão de
		violation emerge.

		Trade-off temporal: aceitar governança organizacional
		Phase 3 (custo: review manual + audit periódica + risk de
		silent violation) → promover technical enforcement quando
		evidence de violation pattern (custo: heavy infra +
		multi-BC coordination + new schema). Phase 3 é correto
		porque evidence de recurrence violation ainda não existe
		(zero consumers Phase 3); aguardar 2-3 consumers
		declarando authoritative dependency + 1+ violation event
		em audit fornece signal suficiente justify promotion.

		Alinhamento com princípios canônicos: blast radius pequeno
		por padrão (technical enforcement infrastructure cross-BC
		exige cascade — 4+ BCs consumers + gateway/audit subsystem
		+ ADR coordination); governança nasce junto (technical
		enforcement prematura sem evidence cria infra underused);
		preferir explicitude à conveniência (consumerProtocol +
		decisionAuthorityModel.authoritativeScope declarations
		são explícitas Phase 3, embora governance-only enforced).

		LIMITATION declarada explicitly em adr-081 + adr-084 +
		systemFailureModes (REW Phase 3 Part 2 commit): 'consumer
		ignoring REW authoritative decision (cross-BC contract
		violation) — UNDETECTABLE at runtime in Phase 3'. Founder
		ratified durante S5 production-safety pressure test:
		'governança organizacional ≠ garantia de sistema'.
		"""

	triggerCalibrationRationale: """
		Trigger 1 (recurrence kind) detecta canvas declarations
		em consumer BCs com pattern indicando override/ignore de
		REW evaluation (e.g., 'rew.*override', 'ignore.*risk-
		evaluation', 'bypass.*risk'). Pattern conservador: matches
		EXPLICIT declarations only — não match em prose conceitual.
		Threshold=2 (recurrence schema mínimo) significa fire
		quando ≥2 consumer BCs declarem override pattern — single
		BC pode ser transient (peer review pode resolver); ≥2 BCs
		é signal de recurrence padrão indicating governance via
		ADR sozinha não é mais suficiente. Baseline Phase 3 = 0
		(zero canvases consumers ainda; REW first BC com
		authoritative declaration).

		Trigger 2 (manual-review) escape para founder revisita
		quando arquitetura cross-BC madura suficientemente para
		formalizar attestation infrastructure como camada dedicada
		(e.g., 3+ BCs consumers declarando authoritative
		dependency + audit evidence de violation cases).
		Maturação arquitetural é judgment founder (signal:
		violation cases recorrentes + compliance pressure +
		regulatory requirement), não condição machine-evaluable
		exclusivamente — trigger manual-review preserva opção de
		promotion antecipada se outras razões emergirem (e.g.,
		Bacen requirement para technical attestation; security
		audit identifica risk em governance-only enforcement).

		Pattern self-match check: este def-016 description usa
		'override', 'ignore' em prose argumentativa — não em
		canvas communication declarations. Triggers procuram
		patterns em contexts/*/canvas.cue scope file-content
		(NÃO em architecture/deferred-decisions/). Verified por
		inspeção: pattern 'rew.*override|ignore.*risk-evaluation'
		em def-016 description é discussão sobre o trigger, não
		instance dele.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-081-domain-model-interpretation-contracts-layer.cue",
		"architecture/adrs/adr-084-production-safety-hardening-system-consistency-model.cue",
		"contexts/rew/domain-model.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			Severity medium porque governance via ADR override
			Phase 3 preserva COMPLIANCE INTENTIONAL via review
			process — substantive cases de override são caught em
			ADR review; gap é em DETECTION RUNTIME de UNINTENTIONAL
			violations (consumer não sabe que está violando
			protocolo; bug em consumer code; partial implementation
			of consumerProtocol). Audit periódica + compliance
			review absorvem cost Phase 3 com 1 BC declaring
			authoritative scope.

			BlastRadius cross-cutting porque promotion Phase N+1
			afeta TODOS BCs consumers de REW (CMT, FCE, SCF +
			future BCs) + cria nova categoria de infrastructure
			(attestation gateway + signature/key management +
			audit subsystem). Schema additions cascade: #Decision
			AuthorityModel pode ganhar attestationProtocol field;
			canvas communication pode ganhar attestation
			declarations; structural-checks ganham attestation
			validation rules. Coordenação multi-team + ADR cross-
			BC é tier-1 effort.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "rew.*override|ignore.*risk-evaluation|bypass.*risk-eval"
		scope:     "file-content"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "Founder revisita quando ≥3 consumers declarando authoritative dependency + audit evidence de violation cases recorrentes + compliance pressure (Bacen, security audit) emergir. Maturação arquitetural é judgment founder não machine-evaluable em isolamento — combinação de signals (volume + violation evidence + external pressure) requires human assessment. Trigger manual-review preserva opção de promotion antecipada se Bacen/regulator requer technical attestation OR security audit identifica risk em governance-only enforcement."
	}]

	status: "open"
}
