package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr130: artifact_schemas.#ADR & {
	id:    "adr-130"
	title: "Reconciliação de naming + shape do context-map com o canvas REW (rew-to-scf)"
	date:  "2026-05-30"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Durante o scaffold do BC SCF (adr-131), a autoria da section
		communication expôs divergência entre os nomes "candidatos canônicos
		estratégicos" do context-map (strategic/context-map.cue) e os nomes já
		refinados no canvas REW (mergeado). O próprio context-map declara em
		knownLimitations que os nomes são candidatos cuja validação definitiva
		depende dos canvas de cada BC — logo o canvas REW é a autoridade quando
		diverge.

		Uma aresta divergia (rew-to-scf): o context-map declarava events
		CounterpartyRiskScoreUpdated/CreditEligibilityDecided e
		communication.type async. O canvas REW publica RiskScoreEmitted/
		EligibilityEmitted com consumers incluindo scf (rew canvas:332-339) E
		expõe as query-surfaces QueryRiskScore/QueryEligibility nomeando SCF
		explicitamente ("Consumed primarily by SCF (anticipation eligibility)",
		rew:316,321). Reconciliar exige, além do naming, mudar
		communication.type de async para hybrid e adicionar o campo queries —
		shape change, não só renomeação.

		As outras 5 arestas do SCF (inv-to-scf, fce-to-scf, ctr-to-scf,
		ins-to-scf, scf-to-ato) NÃO divergem: inv/fce/ctr publicam os nomes
		idênticos ao context-map (verificado nos canvases mergeados); ins/ato
		não estão scaffolded (context-map é autoridade, sem reconciliação). Logo
		apenas 1 aresta muda — menos que o adr-126 (que reconciliou 2:
		bkr-to-fce + rew-to-fce).

		Este ADR é espelho fiel do adr-126 (mesma mecânica naming+shape, canvas
		adjacente como autoridade). Decisão de escopo (founder): o canvas vence
		(aplicação completa do princípio, não cherry-pick) e o context-map é
		reconciliado no mesmo PR do scaffold SCF.

		Alternativa considerada e rejeitada: manter só o naming e deixar o shape
		change em openQuestion. REJEITADA: dividir naming de shape é aplicação
		parcial que cria dívida cuja resolução exigiria outro ADR futuro — pior
		trade que +1 campo (queries) no diff agora (mesma lógica Q1=A do FCE).

		Observação (não-acionável neste ADR): REW é fonte recorrente de naming
		reconciliation — rew-to-fce no scaffold FCE (adr-126), rew-to-scf agora.
		Se o próximo scaffold consumidor de REW redescobrir o mesmo drift,
		considerar PR de varredura reconciliando todas as arestas rew-* de uma
		vez contra o canvas REW. Não agora; observar.
		"""

	decision: """
		Reconciliar a aresta rew-to-scf em strategic/context-map.cue alinhando
		ao canvas REW (autoridade):

		rew-to-scf:
		    events: [CounterpartyRiskScoreUpdated, CreditEligibilityDecided] →
		      [RiskScoreEmitted, EligibilityEmitted]
		    communication.type: async → hybrid
		    queries: (ausente) → [QueryRiskScore, QueryEligibility]
		    upstreamPattern/downstreamPattern (OHS-PL/ACL) e publishedLanguage
		    ('Risk score and eligibility model') PRESERVADOS.

		Nenhum pattern DDD muda; nenhuma direção muda; nenhuma aresta nova é
		criada. rew-to-scf é unidirecional (0 ciclos antes e depois) — sc-cm-07
		mantém 0 ciclos (catraca adr-097/123).
		"""

	consequences: """
		Positivas:
		(P1) A section communication do canvas SCF passa tq-cv-02 (toda relation
		cross-checked com context-map) sem relations divergentes em
		openQuestions — integração fechada na materialização do BC.
		(P2) Context-map deixa de carregar nomes provisórios que contradiziam o
		canvas REW já mergeado — elimina drift estrutural existente.
		(P3) O shape de rew-to-scf passa a refletir a dependência real do gate de
		originação (sync query de elegibilidade) que o canvas REW já modelava.

		Negativas:
		(N1) Nenhuma material. O shape change adiciona o campo queries a uma
		aresta que já tinha events; cue vet confirma conformidade. Reversível
		trivialmente (high) se canvas futuro revelar nome diferente.

		Fronteira regulatória: nenhuma. Reconciliação de vocabulário de
		integração entre artefatos de spec. Sem efeito em Bacen/SCD/LGPD.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"strategic/context-map.cue",
	]

	principlesApplied: ["P0"]

	supersedes: []

	rationale: """
		P0 (uma localização canônica): o nome canônico de cada evento/query de um
		BC vive no canvas/domain-model desse BC (autoridade per knownLimitations
		do context-map); o context-map referencia, não define concorrentemente.
		Reconciliar elimina a cópia divergente — o context-map vira ponteiro
		consistente.

		Aplicação completa (não cherry-pick): o shape change (async→hybrid +
		queries) entra junto do naming, pela mesma razão do adr-126 — separá-los
		seria incoerente com a própria reconciliação.

		Acyclicity preservada por construção: nenhuma aresta nova, nenhuma
		direção alterada; rew-to-scf é unidirecional. A catraca sc-cm-07 (reject,
		adr-123) permanece verde.

		Espelho do adr-126: mesma mecânica (canvas adjacente como autoridade,
		naming+shape), menor escopo (1 edge vs 2). A recorrência REW
		(adr-126 + adr-130) sinaliza candidato a PR de varredura rew-* futuro.

		Tensão com axiomas: nenhuma.
		"""
}
