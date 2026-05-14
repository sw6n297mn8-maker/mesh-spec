package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr088: artifact_schemas.#ADR & {
	id:    "adr-088"
	title: "Formalize Mechanically-Compelled Mutation execution class em #AgentAction"
	date:  "2026-05-14"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Durante WI-063 NTF agent-spec Phase 4.2 actions catalog
		authoring, founder identificou risco de "execute-and-log creep":
		ao longo do tempo, mutations originalmente propose-and-wait
		podem ser informalmente reclassificadas como "mechanically
		compelled" (e portanto execute-and-log) sem schema enforcement
		— transformando exception class em default informal por
		acumulação.

		Phase 4.0 charter (founder direction): "Mutation actions
		affecting replay-forbidden executions, certification revocation,
		OR admissibility refusal-class transitions may become
		execute-and-log ONLY when mutation semantics are mechanically
		derivable from invariant-protected conditions."

		Phase 4.2 catalog identificou 4 NTF actions canónicos qualificando
		como MCM:
		- act-emit-admissibility-refusal-mechanical (gate verdict)
		- act-emit-admissibility-conservatism-mechanical (C11 trigger)
		- act-execute-replay-forbidden-isolation-containment (C9
		  constitutional integrity preservation)
		- act-execute-strong-negative-evidence-revocation (Section C
		  cascade)

		Founder direction Phase 4.2 review (literal): "Sem classe formal,
		daqui 18 meses qualquer mutation 'óbvia' vira MCM informalmente."

		Schema atual #AgentAction não discrimina mutation execution
		class — autonomyLevel é o único discriminador, e MCM como
		conceito narrativo não tem schema anchor para validation
		runner OR governance metric.

		Risk vectors sem formalização:
		(R1) Drift gradual: nova mutation criada como execute-and-log
		     justificando-se "this is just like MCM" sem 5 predicates
		     verificáveis.
		(R2) Reverse drift: standard mutation reclassificada como MCM
		     post-hoc para evitar propose-and-wait friction.
		(R3) Governance blind spot: governance envelope (Phase 5)
		     não consegue medir MCM-vs-standard mutation ratio
		     deterministicamente.
		(R4) Schema-anchor absence: structural-check post-commit não
		     pode validar 5-predicate completeness sem field discriminante.
		"""

	decision: """
		ADOPT 3 schema additions coordenadas:

		(D1) ADD field discriminante #AgentAction.mutationExecutionClass:
		- Optional field.
		- Aplicável apenas a actions com category="mutation". Demais
		  categorias devem omitir (semântica indefinida fora de mutation).
		- Enumerable: "standard" | "mechanically-compelled".
		- "standard" significa: mutation SEM MCM exception class.
		  Autonomia (autonomyLevel) e governance posture (envelope)
		  governam o nível operacional. "standard" NÃO força propose-
		  and-wait universalmente — é discriminador de classe, NÃO
		  prescrição de autonomy level.
		- "mechanically-compelled" significa: mutation eligible para
		  execute-and-log per 5-predicate exception, declared via
		  mechanicallyCompelledPredicates struct obrigatório.

		(D2) ADD nested type #MechanicallyCompelledPredicates declarando
		5 predicates obrigatórios:
		- invariantTriggerRef (P1): invariant guard que dispara mutation.
		- mechanicallyDerivableFrom (P2): input contract from which
		  semantics são computable sem judgment.
		- blastRadiusScope (P3): enum
		  "single-dispatch" | "single-certification-entity" |
		  "single-claim-entity".
		- auditSignalEmitted (P4): observability signal ref.
		- noSemanticDiscretionRationale (P5): rationale concreto why
		  mutation é mechanical-only.

		Quando mutationExecutionClass="mechanically-compelled",
		mechanicallyCompelledPredicates é OBRIGATÓRIO (validated via
		tq-ag-14). Quando ausente OR "standard", predicates struct
		é proibido (semântica indefinida).

		(D3) ADD 2 quality criteria:
		- tq-ag-14 (severity: fail): MCM actions declare all 5
		  predicates com refs válidas (invariantTriggerRef ∈
		  invariants[], auditSignalEmitted ∈ observability.signals[],
		  scope ∈ enumerable, derivableFrom + rationale non-empty).
		- tq-ag-15 (severity: fail): MCM actions devem ter
		  autonomyLevel="execute-and-log". Direção única — NÃO o
		  inverso. Nem todo execute-and-log mutation é MCM; outras
		  pathways formais para execute-and-log mutation podem
		  existir (governadas via autonomyLevel + envelope), e
		  tq-ag-15 NÃO impede tais pathways. tq-ag-15 enforça apenas
		  coerência ONE-WAY: MCM declaration ⇒ execute-and-log.
		"""

	consequences: """
		Positivas:
		(C1) MCM exception class agora tem schema anchor — runner
		     post-commit (advisory via tq-ag-14/15) detecta missing
		     predicates OR incoherent autonomy. Governance envelope
		     Phase 5 pode medir MCM-vs-standard ratio deterministicamente.
		(C2) Anti-drift defense: nova action proposta como MCM exige
		     5-predicate declaration explicit — execute-and-log creep
		     bloqueado por construção.
		(C3) "Standard" classe permite future formal pathways para
		     execute-and-log mutation sem coupling com MCM exception
		     (e.g., trusted-internal mutations under explicit governance
		     envelope clause).
		(C4) FCE primary agent retroactive assessment SRR-tracked:
		     existem actions em fce-primary-agent.cue que se qualificam
		     como MCM? Avaliação dedicada em Phase 4.6 NTF SRR + futuro
		     FCE agent-spec amendment cycle se aplicável.

		Negativas/custos:
		(N1) Schema complexity incrementa: 2 novos fields opcionais +
		     1 nested type + 2 quality criteria. Trade-off aceito —
		     custo schema é one-time; custo de execute-and-log creep
		     é compounding.
		(N2) Governance envelope Phase 5 deve materializar:
		     - vm-ntf-mcm-vs-standard-mutation-ratio (observed metric)
		     - vm-ntf-mcm-expansion-rate-quarterly (alerta se nova
		       MCM action adicionada sem ADR explicit)
		     - gate: MCM class expansion requires ADR + parallel SRR
		     Deferred to Phase 5 governance envelope authoring; este
		     ADR documenta a obrigação mas NÃO formaliza envelope
		     fields (Phase 5 responsibility).
		(N3) Naming "standard" pode sugerir "default" — clarificação
		     explícita em rationale: "standard" = "mutation sem MCM
		     exception", NÃO "default behavior".

		Mitigações:
		(M1) Field mutationExecutionClass é optional — Phase 4.2 NTF
		     actions 13-16 declare MCM explicit; demais mutations (8-12)
		     podem omitir OR declarar "standard" para explicitness.
		     Recomendação: declarar explicit para minimizar ambiguidade.
		(M2) Quality criteria iniciam como advisory (warn/fail) sob
		     #AgentSpec._qualityCriteria. Promoção a structural-check
		     post-commit gate em architecture/structural-checks/
		     agent-spec.cue é deferred — atualmente não existe
		     structural-check para agent-spec artifactType (gap
		     conhecido, separate WI).
		"""

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/agent-spec.cue",
		"contexts/ntf/agents/ntf-primary-agent.cue",
		"contexts/fce/agents/fce-primary-agent.cue",
	]

	plannedOutputs: [
		"Schema delta #AgentAction: 2 optional fields (mutationExecutionClass + mechanicallyCompelledPredicates)",
		"Schema addition: #MechanicallyCompelledPredicates struct definition",
		"Schema addition: tq-ag-14 (5-predicate completeness) + tq-ag-15 (MCM ⇒ execute-and-log direction)",
		"Schema update: _qualityCriteria.rationale ampliada para cobrir tq-ag-14/15",
		"NTF agent-spec Phase 4.6 first instance: 4 MCM actions declared per new schema",
		"FCE agent-spec retroactive assessment: tracked em NTF Phase 4.6 SRR (se houver MCM-eligible actions, separate amendment WI)",
		"Governance envelope Phase 5 obligation: vm-ntf-mcm-vs-standard-mutation-ratio + vm-ntf-mcm-expansion-rate-quarterly + ADR-gate clause",
	]

	principlesApplied: [
		"P0-zero-duplication",
		"adr-040-structural-vs-semantic-validation-separation",
		"adr-054-authoring-policy-subagent-dispatch",
	]

	rationale: """
		Reversibility medium: schema addition adiciona fields opcionais
		(non-breaking para instances pre-existentes). Revert requires
		schema field removal + instance updates onde declared. Quality
		criteria additions (tq-ag-14/15) são advisory layer — não
		bloqueiam pre-existing instances.

		BlastRadius cross-artifact: afeta agent-spec.cue schema + 1
		new instance (NTF Phase 4.6) + 1 retroactive assessment target
		(FCE primary agent). Não cross-cutting: tools, structural-
		checks, e CI workflows não requerem changes neste commit
		(post-commit advisory via runner para tq-ag-14/15 é mecanismo
		existente).

		Decisão prioriza **ANTI-DRIFT FORMALIZATION OVER NARRATIVE
		CONVENTION**:
		- Founder Phase 4.2 ajuste explicit: MCM "precisa virar tipo
		  formal, não apenas conceito narrativo".
		- 5 predicates já estabelecidos em charter (invariant-triggered
		  + mechanically derivable + blast-radius bounded + audit-
		  emitting + no semantic discretion) — schema formaliza estes
		  predicates como mandatory structure.
		- "Standard" classe semanticamente significa "sem MCM exception"
		  per founder ajuste #1 explicit — preserva future formal
		  pathways para execute-and-log mutation sem cementar coupling
		  inválido.
		- tq-ag-15 one-way direction (MCM ⇒ execute-and-log) per
		  founder ajuste #2 explicit — não restringe outras pathways
		  formais para execute-and-log mutation.

		Pattern paralelo adr-040 + adr-054:
		- adr-040 estabeleceu structural-vs-semantic validation
		  separation (deterministic gates vs LLM advisory).
		- adr-088 aplica mesmo pattern: 5 predicates como structural
		  contract (tq-ag-14 schema check) + semantic merit (genuine
		  triggering, true mechanical-only) como advisory layer
		  (governance envelope + future validation prompt).

		Family Mesh anti-drift discipline:
		FCE WI-043 estabeleceu refusal-as-success canonical posture
		via state machine + integrity guardian services. NTF WI-063
		estabelece admissibility-as-sovereignty via certification
		gate + bipartite state machine. ADR-088 extends anti-drift
		discipline a agent layer: mutation execution class é
		structural property, NÃO operational convention. Pattern
		canonical: "executar mecanicamente OR refusar OR escalar —
		jamais discricionário sob convenção informal".

		Governance envelope Phase 5 dependency:
		- vm-mcm-vs-standard-ratio: tracking metric para detectar
		  imbalance estrutural (e.g., se MCM class começa a inchar
		  além de constitutional anchor expectations).
		- vm-mcm-expansion-rate-quarterly: rate-of-growth alert para
		  detectar gradual creep (new MCM action sem ADR explicit).
		- gate clause: "MCM class expansion requires ADR + parallel
		  SRR" — formaliza governance hierarchy.
		Estes três items são canonical obligations declared aqui mas
		materializadas em ntf-primary-agent.governance.cue Phase 5.

		Cascade ordering preservado:
		Schema delta (este commit) → Phase 4.6 first instance (NTF
		actions 13-16) → Phase 5 governance envelope materializa
		MCM metrics + ADR-gate clause → future FCE amendment cycle
		se backfill aplicável.
		"""
}
