package build_time

// first-class-backfill-worklist.cue -- Worklist/allowlist de pendencias RECONHECIDAS da
// campanha de backfill Forma A (adr-153 decisao 4; materializa adr-151 D2 passo iv).
//
// V1 CUE livre, SEM #-schema first-class (governance/build-time e schemaExemptZone;
// precedente subagent-execution-log "V1 simples sem schema; formalizar quando volume
// justifique"). Shape inline: entries[].{conceptCode, bc, reason, status}.
//
// O evaluator first-class-traceability (sc-fct-01) consulta entries[].conceptCode: um
// conceito que cruza contrato sem firstClass e ACEITO se esta aqui (pendencia conhecida),
// ACUSADO se esta fora (gap nao-reconhecido) -- resolve a falsificationCondition 4 do
// adr-151 (pendente-reconhecido != verde-falso).
//
// SEED: os 48 conceitos cross-contract (agg/cmd/evt nos aggregate-manifests dos 4 BCs com
// manifest: cmt/dlv/fce/rew) que ainda nao declaram firstClass. DIVIDA reconhecida, nao gap.
// DRENAGEM (campanha pos-adr-153): remover a entry quando o conceito ganhar firstClass +
// coreNoun + termo dedicado (Forma A). Quando entries esvaziar (todo cross-contract
// declarado-OU-aqui), o gate promove warn->reject (passo vi do adr-151).
// Gerado deterministicamente dos aggregate-manifests (mesma fonte do evaluator).
// DRENAGEM (passo vi): ondas cmt+dlv cobriram 31 conceitos (Forma A + termos) -> removidos.
// Restantes: 17 (fce 8, rew 9). Quando entries esvaziar, gate promove warn->reject.


firstClassBackfillWorklist: {
	entries: [
		{conceptCode: "agg-payment", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-authorize-payment", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-dispatch-payment-instruction", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-materialize-payment", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-settle-payment", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-payment-authorized", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-payment-instruction-dispatched", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-payment-settled", bc: "fce", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "agg-risk-evaluation", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-mark-evaluation-stale", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-request-risk-evaluation", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-supersede-risk-evaluation", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-risk-evaluation-computed", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-risk-evaluation-emitted", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-risk-evaluation-marked-stale", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-risk-evaluation-superseded", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-signal-received", bc: "rew", reason: "backfill Forma A pendente (campanha pos-adr-153)", status: "pending"},
	]
}
