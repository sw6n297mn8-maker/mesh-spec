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
// DRENAGEM (passo vi): ondas cmt+dlv+fce+rew cobriram os 48 conceitos cross-contract (Forma A + termos) -> removidos.
// Worklist zerada em 4 ondas; gate promovido a reject (ato final do adr-151).
//
// RE-POPULADA CONSCIENTEMENTE (adr-178): o am-purchase-requisition do kit de
// superficie do p2p trouxe 12 conceitos NOVOS para dentro do sc-fct-01 -- o
// p2p nao passou pelas 4 ondas porque nao tinha manifest. Entries pending
// reconhecidas per falsificacao 4 do adr-151 (pendente-reconhecido != verde-
// falso; o gate segue reject e visivel). DRENAGEM: onda p2p (5a onda da
// campanha, molde das 4 anteriores) -- fatia de higiene propria com as 12
// decisoes de Forma A (firstClass/reason/coreNoun + termos de glossario),
// que sao modelagem de dominio e NAO foram tomadas na fatia de superficie.


firstClassBackfillWorklist: {
	entries: [
		{conceptCode: "agg-purchase-requisition", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-approve-purchase", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-cancel-purchase-requisition", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-convert-requisition", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-submit-purchase-requisition", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "cmd-triage-requisition", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-purchase-approval-rejected", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-purchase-approved", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-purchase-requisition-cancelled", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-purchase-requisition-converted", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-purchase-requisition-submitted", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
		{conceptCode: "evt-purchase-requisition-triaged", bc: "p2p", reason: "cruza contrato via am-purchase-requisition (kit adr-178); backfill Forma A pendente (onda p2p, 5a onda da campanha pos-adr-153)", status: "pending"},
	]
}
