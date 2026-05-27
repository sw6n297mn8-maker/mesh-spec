package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr111: artifact_schemas.#ADR & {
	id:    "adr-111"
	title: "Check cross-file economic-mechanism → economic-assumption (enforces/protectsAgainst); reduz bucket M2 para 2"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Investigar a relação negócio↔domínio surfaceou que os mecanismos econômicos
		(mesh-economic-mechanisms.cue) declaram enforces (imperativos imp-*) e
		protectsAgainst (riscos ri-*) que vivem no economic-assumption-model
		(mesh-economic-assumptions.cue: systemImplications[].id e
		realityInvariants[].id). Era uma das 3 isenções cross-file restantes do M2
		(adr-106), antes marcada como "investigar"; a investigação mostrou que é ref
		id-direta, born-green, autorável com o cross-file-id-exists (adr-102).

		cue vet valida o formato (imp-NN/ri-NN), não a existência cross-file do
		imperativo/risco referenciado.
		"""

	decision: """
		(1) Autorar 2 checks (architecture/structural-checks/economic-mechanism-model.cue),
		born-warn, kind cross-file-id-exists:
		    - sc-em-01: mechanisms[].enforces → systemImplications[].id (imp-*).
		    - sc-em-02: mechanisms[].protectsAgainst → realityInvariants[].id (ri-*).
		    Ambos verificados born-green (9 refs, todas resolvem entre 18 ids).

		(2) Remover economic-mechanism-model do sc-meta-02.exemptTypes (agora coberto).
		Bucket cross-file do M2: 3 → 2 (restam agent-spec e cross-context-flow).

		Escopo: guarda a integridade referencial INTERNA do modelo econômico
		(mecanismo↔assumptions). NÃO é a ponte negócio↔domínio (essa é estrutural —
		classificação no canvas + subdomainOwnership — já coberta por cue vet de shape),
		nem valida que o mecanismo de fato cumpre o imperativo (adequação = P10/advisory).

		FORA DE ESCOPO: promoção a reject (born-warn por ora); cobertura reversa (todo
		imperativo/risco tem mecanismo); os 2 cross-file restantes.
		"""

	consequences: """
		Positivas: (1) os refs enforces/protectsAgainst dos mecanismos não podem mais
		apontar para imperativo/risco fantasma — trava regressão referencial do modelo
		econômico; (2) reusa kind existente (sem inflar ontologia); (3) reduz o bucket
		cross-file do M2 de 3 para 2, com cobertura real.

		Negativas: (1) born-warn — não bloqueia até promoção; (2) guarda só a camada
		econômica interna, não a ponte negócio↔domínio (declarado — essa ponte não é
		gap de cross-ref); (3) não cobre a direção reversa (imperativo sem mecanismo).
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/structural-checks/economic-mechanism-model.cue",
		"architecture/structural-checks/meta-coverage.cue",
	]

	principlesApplied: [
		"P10 — gate determinístico: existência cross-file de imperativo/risco é decidível e vira trava",
		"P0 — localização canônica: imp-*/ri-* vivem no economic-assumption-model; o mecanismo referencia, não duplica",
		"adr-102 — instância do cross-file-id-exists; adr-106 — reduz o bucket de isenções do M2 com cobertura real",
		"dp-07 — sem big-bang: born-warn, born-green",
	]

	defersTo: []

	rationale: """
		decisionClass structural: 2 instâncias de check + remoção de 1 isenção do M2 —
		aplica P0/P10/adr-102/adr-106 sem redefinir princípios. reversibility high
		(aditivo, born-warn); blastRadius repo-wide.

		Verificado antes da proposta: protótipo → 9 refs (enforces+protectsAgainst)
		todas resolvem entre 18 ids (imp-*/ri-*); cue vet ./... EXIT 0; runner
		--self-test PASS; runner default → sc-em-01/02 verdes, M2 descobertos = 0, 0
		bloqueantes, exit 0.
		"""
}
