package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr101: artifact_schemas.#ADR & {
	id:    "adr-101"
	title: "Triagem de cobertura: isenções registradas dos tipos restantes + promoção de M1/M2 a reject"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-099 criou a meta-cobertura (M1 evaluator-coverage, M2
		structural-check-coverage) born-warn, expondo ~30 tipos governados sem
		structural-check comportamental. adr-100 autorou o context-map (kind
		local-field-reference-integrity), tirando-o da lista (29 restantes). Para
		fechar o item — zerar os descobertos e promover M1/M2 a gate bloqueante — os
		29 restantes precisam virar, cada um, check ou isenção registrada com
		rationale (anti-dumping-ground per adr-062).

		A tentativa de autorar (adr-100) já estabeleceu que os checks referenciais
		mais valiosos ou exigem cross-file-id-exists (def-002), ou enhancements de
		kind ainda não feitos. Logo a maioria dos 29 vira isenção HONESTA (não
		silêncio): permanente para maquinaria engine/config e tipos shape-adequados;
		ou deferida com pointer explícito (def-002 para cross-file; follow-on para os
		expressáveis agora mas adiados). Promover sem registrar seria reabrir o
		buraco que a meta-cobertura fecha; registrar é a forma de tornar cada
		ausência de check uma decisão revisável.

		Alternativa REJEITADA: deixar M1/M2 em warn indefinidamente. Reprovada — warn
		dá visibilidade mas não impede um tipo novo nascer descoberto; o valor
		forward-looking da meta-cobertura só se realiza com reject. Segunda
		REJEITADA: autorar agora checks para os 29. Reprovada — os de alto valor estão
		bloqueados em def-002/enhancements; forçar checks rasos seria cerimônia.
		"""

	decision: """
		(1) Registrar em sc-meta-02.exemptTypes os 29 tipos restantes, cada um com
		rationale categorizada:
		    - (P) permanente: maquinaria engine/config (zona adr-098) e tipos
		      shape-adequados sem ref cross-artifact, ou já cobertos por outro gate
		      (readme-config pelo coevolution; api-spec pelo sc-cv-02). 18 tipos.
		    - (def-002): check referencial cross-file justificado, deferido ao
		      cross-file-id-exists. 8 tipos (cross-context-flow, subdomain,
		      domain-definition, stakeholder-map, agent-spec, service-contract,
		      economic-mechanism-model, policy).
		    - (follow-on): expressável agora (wave-plan via adr-100; deferred-decision
		      e adopted-artifacts via enhancement de filesystem-path-exists) mas
		      adiado para focar este pass em zerar+promover. 3 tipos.

		(2) Promover sc-meta-01 (M1) e sc-meta-02 (M2) de enforcement "warn" para
		"reject". Com os 29 isentos e os 9 cobertos, M2 reporta zero descobertos →
		nasce verde como gate. M1 já era verde (todos os kinds com evaluator).

		(3) A partir daqui, introduzir um tipo governado novo (schema com
		_schema.location) sem check nem isenção FALHA o CI (verificado por teste
		adversarial: tipo-probe sem cobertura → sc-meta-02 reject, exit 1). O futuro
		nasce coberto por construção.

		FORA DE ESCOPO: M3 (asserção de que o runner é invocado no validate.yml);
		resolução de def-002 e remoção das isenções correspondentes; autoria dos
		checks follow-on (wave-plan/deferred-decision/adopted-artifacts).
		"""

	consequences: """
		Positivas: (1) a meta-cobertura passa de inventário (warn) a gate (reject) —
		cobertura da camada de fiscalização agora é garantida, não só observada; (2)
		cada uma das 29 ausências de check é decisão registrada e auditável, com
		pointer (def-002 / follow-on) quando o check é desejável mas adiado; (3) tipo
		novo descoberto é impossível por construção (teste adversarial confirma).

		Negativas: (1) exemptTypes é uma lista que precisa ser mantida — mas o próprio
		M2 a guarda: remover um tipo coberto (sem readicionar isenção) re-dispara o
		gate; adicionar tipo novo exige decisão explícita; (2) as isenções (P) são um
		juízo de 'shape-adequado' que pode envelhecer (um tipo hoje declarativo pode
		ganhar refs cross-artifact) — mitigado: o rationale registra a premissa, e
		revisitar é change-on-touch; (3) cobertura ≠ adequação permanece (P10): M2
		garante que existe check/decisão, não que o check é suficiente.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/structural-checks/meta-coverage.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: M1/M2 viram gate real (reject); adequação permanece na camada advisory",
		"P0 — localização canônica: as isenções vivem no próprio check (exemptTypes), com rationale; não em config externa",
		"adr-099/adr-100 — fecha o arco da meta-cobertura: triagem → zero descobertos → promoção",
		"adr-097 — catraca: promoção warn→reject por evidência (M2 zerado, M1 verde, teste adversarial)",
		"adr-062 — anti-dumping-ground: cada isenção é decisão com rationale e, quando adiada, pointer (def-002/follow-on)",
	]

	defersTo: ["def-002"]

	rationale: """
		decisionClass structural: promove dois gates a bloqueantes e registra 29
		decisões de cobertura — aplica P0/P10/adr-099/adr-100/adr-097 sem redefinir
		princípios. reversibility medium (reverter = baixar enforcement + esvaziar
		exemptTypes, mas é decisão de gate repo-wide); blastRadius repo-wide.
		defersTo def-002 (8 isenções aguardam o cross-file-id-exists).

		Verificado antes da proposta: cue vet ./... EXIT 0; com as 29 isenções, M2
		reporta zero descobertos (sc-meta-02 não dispara); promovido a reject, runner
		default exit 0 (os 21 findings remanescentes são sc-cv-02/03 em warn). Teste
		adversarial: schema-probe de tipo governado sem cobertura → sc-meta-02 FAIL,
		exit 1; pós-revert exit 0 — a promoção tem dentes.
		"""
}
