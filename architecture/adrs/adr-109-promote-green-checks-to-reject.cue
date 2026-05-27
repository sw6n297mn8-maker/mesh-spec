package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr109: artifact_schemas.#ADR & {
	id:    "adr-109"
	title: "Catraca: promover a reject os 10 structural-checks born-green de context-map/tension-entry/domain-definition/service-contract"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Os passes adr-100/102/103/105/106 autoraram structural-checks born-warn que
		provaram verde por vários ciclos: integridade intra-arquivo do context-map
		(sc-cm-01..04), disco→map (sc-cm-05), events↔BC built↔built (sc-cm-06),
		relatedADR cross-file (sc-te-02), refs por path do domain-definition
		(sc-dd-01/02) e boundedContextRef do service-contract (sc-sv-01). Todos com
		zero findings consistentemente.

		Per a catraca do adr-097 (born-warn → reject quando comprovadamente verde e de
		valor), é hora de converter essa cobertura nominal em gate real (P10): um
		check que só reporta em warn não impede o drift, apenas o torna visível.

		Alternativa REJEITADA: manter em warn. Reprovada — o valor de gate (impedir
		por construção) só se realiza com reject; os 10 estão verdes há ciclos e
		guardam drift concreto (referências internas quebradas, BC no disco sem
		declaração, event indefinido, ref cross-file fictícia).
		"""

	decision: """
		Promover enforcement "warn" → "reject" nos 10 checks born-green:
		- context-map.cue: sc-cm-01, sc-cm-02 (endpoints source/target → contexts),
		  sc-cm-03 (reverseRelationshipId → relationship code), sc-cm-04
		  (ownerContext → contexts), sc-cm-05 (disco→map), sc-cm-06 (events↔BC
		  built↔built).
		- tension-entry.cue: sc-te-02 (relatedADR → ADR id). sc-te-01 (manifestsIn)
		  permanece como está (fora desta promoção).
		- domain-definition.cue: sc-dd-01 (designPrinciplesRef), sc-dd-02
		  (stakeholderMapRef).
		- service-contract.cue: sc-sv-01 (boundedContextRef → contexts).

		Verificado zero findings nos 10 antes da promoção → nascem verdes como gate;
		runner default segue exit 0. Um drift novo em qualquer uma dessas dimensões
		passa a falhar o CI.

		FORA DE ESCOPO: sc-cv-02/03 (têm findings — decisão de produto api/async,
		permanecem warn); domain-invariant checks e demais (avaliar promoção
		separadamente); sc-te-01.
		"""

	consequences: """
		Positivas: (1) 10 dimensões de integridade do context-map/tension-entry/
		domain-definition/service-contract passam a IMPEDIR drift por construção, não
		só reportar; (2) a catraca avança — cobertura comprovada vira gate; (3)
		nenhum custo de falso-positivo (todos verdes, verificado).

		Negativas: (1) um PR futuro que introduza drift numa dessas dimensões agora
		FALHA o CI (intenção, não defeito); (2) se um desses checks tiver um caso de
		borda não-coberto pelo estado atual, a primeira manifestação será uma falha de
		CI — mitigado: os checks são determinísticos e foram exercitados verdes por
		ciclos; (3) reverter uma promoção individual é baixar enforcement (reversível).
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/structural-checks/context-map.cue",
		"architecture/structural-checks/tension-entry.cue",
		"architecture/structural-checks/domain-definition.cue",
		"architecture/structural-checks/service-contract.cue",
	]

	principlesApplied: [
		"P10 — gates determinísticos validam: converte cobertura nominal (warn) em gate real (reject)",
		"adr-097 — catraca: promoção por-check após comprovação de verde, sem big-bang",
		"adr-100/102/103/105/106 — promove os checks que esses passes autoraram born-warn",
		"dp-07 — evolução incremental: promove só os verdes; sc-cv-02/03 e outros ficam",
	]

	defersTo: []

	rationale: """
		decisionClass structural: muda o enforcement (warn→reject) de 10 checks — o
		que bloqueia o CI muda, efeito repo-wide; aplica P10/adr-097 sem redefinir
		princípios. reversibility high (baixar enforcement reverte trivialmente);
		blastRadius repo-wide (gate de CI).

		Verificado antes da proposta: os 10 com zero findings (medido); cue vet ./...
		EXIT 0; runner --self-test PASS; runner default → 10 checks reject com 0
		bloqueantes, exit 0 (os 21 findings remanescentes são sc-cv-02/03, ainda warn).
		A promoção não quebra o CI.
		"""
}
