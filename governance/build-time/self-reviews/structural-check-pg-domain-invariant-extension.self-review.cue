package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheckPgDomainInvariantExtension: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check-pg-domain-invariant-extension"

	artifactPath:       "architecture/production-guides/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/production-guide.cue"
	artifactType:       "production-guide"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-11"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			PG structural-check.cue patch como plannedOutput de ADR-086
			Domain-Invariant Structural Check Authoring Protocol.

			**Origem**: ADR-086 (commit 19b0712) canonizou protocolo;
			plannedOutputs listavam patch ao PG existente. Esta SRR
			documenta autoria do patch.

			**Approach**: estender as 3 sections existentes do PG
			(context-and-rule-identification + rule-composition +
			validation-and-meta) com sub-blocos específicos para
			kind=domain-invariant, em vez de criar 4ª section paralela.
			Preserva fluxo canônico identificar→compor→validar; trata
			domain-invariant como kind novo (5º) integrado no mesmo
			ciclo de authoring.

			**6 blocos de patch aplicados**:

			(B1) _qualityCriteria — adicionados 5 critérios:
			    - tq-scg-04 (layer-applicability-declared, FAIL)
			    - tq-scg-05 (coverage-flags-declared, FAIL)
			    - tq-scg-06 (runtimegap-mandatory, FAIL)
			    - tq-scg-07 (war-game-derivation-evidenced, WARN)
			    - tq-scg-08 (behavioral-non-applicability-explicit, WARN)
			    Rationale do conjunto atualizado: 8 critérios totais
			    (3 base + 5 protocol).

			(B2) prerequisites.gapPolicy — atualizado de '4 kinds
			    existentes' para '5 kinds operacionais (4 originais +
			    domain-invariant per adr-080 + Domain-Invariant
			    Structural Check Authoring Protocol per adr-086)'.
			    Adicionada cláusula war-game admissibility:
			    'rules DEVEM emergir de concrete production-break case
			    OR credible pre-production failure mode'.

			(B3) Section 1 (context-and-rule-identification) — 4
			    heuristics novas:
			    - domain-invariant case identification (não bulk-copy)
			    - War-game admissibility (production-break OR
			      pre-production failure mode com cenário)
			    - Anti-pattern template-copy proibido
			    - Behavioral non-applicability identification durante
			      context phase

			(B4) Section 2 (rule-composition) — process step novo
			    'Para kind=domain-invariant: aplicar Domain-Invariant
			    Structural Check Authoring Protocol' cobrindo D2..D6
			    do ADR-086. Sources expandidas com adr-080 + adr-086 +
			    sc-inv-* (pre-DISCAP marker) + sc-rew-* (canonical
			    reference). 5 heuristics novas para kind=domain-invariant
			    (layer ladder; coverage flags; runtimeGap; war-game;
			    behavioral non-applicability).

			(B5) Section 2 heuristic atualizada: 'Se candidate rule não
			    cabe nos 5 kinds operacionais'... (era '4 kinds').

			(B6) finalValidation — 5 steps novos para domain-invariant:
			    tq-scg-04..08 verifications com severidades corretas
			    (fail/fail/fail/warn/warn).
			    enforcement owner step atualizado: 'build-time validation
			    tooling (e runner futuro per WI-068)' em vez de 'runner'.

			**3 founder ajustes pre-write incorporados**:
			(1) tq-scg-06 enforcedBy examples: 'aggregate lifecycle /
			    runtime governance layer / external system' (NÃO
			    'build-time tooling' — contradiz runtimeGap semantics
			    quando runtimeRequired=true).
			(2) RE-VAL separation: tratado como flag SEPARADA dos 7
			    layers (NÃO 'L7 + RE-VAL' como pseudo-layer). Preserva
			    progressive ladder integrity (L1..L7 são layers; RE-VAL
			    é additional flag para temporal/contextual re-validation).
			(3) Sources INV marker: 'pre-DISCAP; referência histórica,
			    não exemplar completo' (vs REW 'referência canônica
			    forte; genesis do Domain-Invariant Structural Check
			    Authoring Protocol').

			**Tamanho**: PG 204 linhas → ~375 linhas (+~170 linhas;
			estimativa atingida).

			**Schema satisfaction**:
			- 5 novos criteria com id regex + description + test +
			  severity + rationale
			- gapPolicy ≥50 runes (atendido; expandido)
			- finalValidation steps ≥1 (5 adicionados)
			- Backward compat: tq-scg-01..03 inalterados; 4 kinds
			  originais authoring guidance inalterada

			cue vet ./... EXIT=0; cue vet -c ./... EXIT=0 (limpo, sem
			incomplete instances).
			"""
	}]

	findings: {}

	summary: """
		PG structural-check.cue patch implementa plannedOutputs do
		ADR-086 (Domain-Invariant Structural Check Authoring Protocol).
		Approach: estender 3 sections existentes (não criar 4ª) com
		sub-blocos kind=domain-invariant; preserva fluxo identificar→
		compor→validar; trata domain-invariant como 5º kind operacional
		integrado no ciclo canônico.

		6 blocos de patch: _qualityCriteria (+5 critérios tq-scg-04..08,
		3 fail + 2 warn); gapPolicy (5 kinds operacionais + war-game
		admissibility); Section 1 heuristics (+4 para domain-invariant);
		Section 2 process step novo (5 disciplinas D2..D6 ADR-086) +
		sources expandidas (adr-080/adr-086 + sc-inv-* pre-DISCAP +
		sc-rew-* canonical) + 5 heuristics; finalValidation (+5 steps
		tq-scg-04..08 + enforcement owner update).

		3 founder ajustes pre-write incorporados (runtimeGap.enforcedBy
		examples sem build-time tooling contradiction; RE-VAL como flag
		separada dos 7 layers; INV pre-DISCAP marker vs REW canonical
		reference).

		PG 204 → ~375 linhas (+170L). cue vet ./... EXIT=0 (com -c
		clean). Backward compat preserved (tq-scg-01..03 inalterados;
		4 kinds originais authoring guidance inalterada).

		Sequence next: cascade ordering complete — ADR-086 + PG patch
		commited → bulk authoring 8 BCs structural-checks pode proceder
		PG-guided (WIs separados per BC) → retroactive audit INV/REW
		pode proceder (WIs separados).
		"""

	singleRoundRationale: """
		PG patch é implementação direta de plannedOutputs declarados
		em ADR-086 (commit prior 19b0712). Decisão arquitetural foi
		consumida no ADR; patch é derivation respeitando essa decisão.

		Founder review pré-write produziu 3 ajustes substantivos
		(runtimeGap.enforcedBy examples; RE-VAL separation; INV/REW
		sources marker discipline) incorporados antes do write —
		equivalent functional a round de revisão consolidado em
		pre-write phase.

		Pattern paralelo a srr-adr-086 (also single-round): decisão
		canonical foi consumida em phase anterior (ADR dialectic);
		artifact downstream é instanciação, não nova dialectic.
		"""
}
