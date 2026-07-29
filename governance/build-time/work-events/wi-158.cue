package work_events

// wi-158.cue — Lifecycle event-sourced de WI-158 (ADR de identidade e
// ator; resolve def-024, decide def-080). Proposto pelo spec-writer na
// sessão 2026-07-28 do arco jornada→produção; aprovado pelo founder na
// mesma sessão (aprovação explícita em mensagem própria, precedendo esta
// escrita). Timestamps na granularidade da sessão.
//
// Claimado e completado na execução da própria fatia (2026-07-29,
// molde WI-156/157/159/160/161). 3 section gates do adr-182 confirmados
// pelo founder + ESCALAÇÃO FORMAL de irreversibilidade do tenant no
// Gate 2 (critério "estrutura de isolamento entre tenants" do
// reversibilityThreshold): Opção B escolhida — tenant = organização
// participante, log único da rede, isolamento como propriedade de
// LEITURA — sob a condição de o ADR declarar escopo-por-organização
// como invariante de toda query capability nova (mecanizável; lacuna
// nomeada: nenhum kind do runner expressa hoje) e a N1 de primeira
// classe (bug de escopo é O modo de falha). Verificação pedida no
// Gate 3 e executada na fonte ANTES da consolidada: os governance
// envelopes TÊM conceito de versão identificável — #AgentGovernanceGlobal
// (architecture/artifact-schemas/agent-governance.cue) declara `version`
// com docstring "Rastreada no audit trail de toda decisão de agente
// (governance-version)"; cada envelope per-agente declara
// governanceGlobalVersion validado contra o singleton por tq-gv-12
// (instâncias vivas: "0.1" em p2p e ssc). É esse par que o
// underGovernance do #AgentActor referencia. Grep confirmatório pedido
// no OK da escrita: dp-10 vive em domain/domain-definition.cue:417 (NÃO
// em design-principles.cue) — o principlesApplied do adr-182 anota a
// casa correta.
//
// MECANIZAÇÃO DO #Actor — 3 tentativas, decidida pelo disco: a forma
// aprovada (veto de executedVia por shape sob kind=agent) foi
// materializada primeiro por comprehension (`if kind == "agent"`),
// depois por literal bottom (`_|_`), e ambas foram recusadas pelo
// classificador do gerador de codegen; a 3ª forma — disjunção de dois
// ramos FECHADOS (#HumanActor | #AgentActor, molde #SurfaceFamily do
// adr-180) — passou e mecaniza MAIS que as anteriores (roleRef sob
// agent e underGovernance sob human caem por fechamento). A lacuna era
// do classificador, não do spec: resolvida na fatia runtime-local
// rtd-037 (mesh-runtime PR #35, sealed interface + ramos), que PRECEDE
// este pacote — sem ela o codegen fica em exit 75 (PIVOTAR). Sondas da
// mecanização: 9/9 (4 positivas — humano completo, humano mínimo sem
// roleRef, humano+executedVia, agente completo; 5 negativas rejeitando
// pelo motivo exato — agente sem underGovernance incompleto, agente+
// roleRef, agente+executedVia "field not allowed", humano+
// underGovernance, roleRef fora do regex sh-NN).
//
// Runner: 32 warns / 0 bloqueantes (idêntico ao baseline pós-WI-157).
// Codegen local com o toolchain rtd-037: exit 0, gate CONTINUAR,
// 86/100 — os mesmos números do baseline verde pré-WI-158.
// artifactSnapshotHash = git blob hash de
// architecture/adrs/adr-182-identity-and-actor-model.cue materializado.
streams: "WI-158": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-158"
	taskVersion: 1
	commandId:   "WI-158-propose-identity-actor-adr"
	timestamp:   "2026-07-28T16:34:00Z"
	actor:       "spec-writer"
}, {
	eventType:   "task-approved"
	taskId:      "WI-158"
	taskVersion: 1
	commandId:   "WI-158-approve-identity-actor-adr"
	timestamp:   "2026-07-28T17:01:00Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-158"
	taskVersion:    1
	commandId:      "WI-158-claim-identity-actor-adr"
	timestamp:      "2026-07-29T03:10:00Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-07-29T11:10:00Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-158"
	taskVersion: 1
	commandId:   "WI-158-complete-identity-actor-adr"
	timestamp:   "2026-07-29T04:05:00Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-158-completion-20260729"
		artifactSnapshotHash: "3dc414c4b77551e091556982e074ae8706576cac"
		gatesPassed: ["cue-vet", "actor-shape-probes", "governance-version-source-verification", "codegen-pipeline", "structural-runner", "freshness-gate", "check-self-review"]
	}
}]
