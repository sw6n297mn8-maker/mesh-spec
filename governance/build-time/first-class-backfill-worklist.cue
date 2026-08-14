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
// DRENAGEM (onda p2p, 5a onda): os 12 conceitos do kit adr-178 ganharam Forma A
// (firstClass/reason/coreNoun no domain-model) + cobertura de glossario (11 termos
// novos; o agg reusa term-requisicao, decisao do founder) -> removidos.
// Worklist VAZIA novamente; gate reject permanece.
//
// RE-POPULADA CONSCIENTEMENTE (WI-159): o am-sourcing-process do kit de
// superficie do ssc traz 18 conceitos NOVOS para dentro do sc-fct-01 (1 agg
// + 8 commands + 9 events) -- o ssc nao passou pelas 5 ondas porque nao
// tinha manifest (Forma A: zero firstClass no domain-model do ssc).
// Entries pending reconhecidas per falsificacao 4 do adr-151 (pendente-
// reconhecido != verde-falso; o gate segue reject e visivel). DRENAGEM:
// onda ssc (6a onda da campanha, molde das 5 anteriores) -- fatia de
// higiene propria com as 18 decisoes de Forma A (firstClass/reason/
// coreNoun + termos de glossario), que sao modelagem de dominio e NAO
// foram tomadas nesta fatia de superficie.
//
// ESTENDIDA (WI-161): a negociacao adiciona 6 conceitos ao
// am-sourcing-process (3 commands + 3 events internal) -- entram como
// pendencias reconhecidas no MESMO regime da onda ssc (24 entries; a
// decisao de Forma A dos 6 pertence a mesma fatia de higiene futura).
//
// ESTENDIDA (missao M1/adr-193, fatia do fecho): o am-purchase-order traz
// 8 conceitos NOVOS ao sc-fct-01 (1 agg + 2 commands + 2 events published
// + 3 events ACL -received) -- o fecho da ds-buyer-procurement-journey
// abre a superficie do PO; as decisoes de Forma A (firstClass/reason/
// coreNoun + termos) sao modelagem de dominio e pertencem a onda p2p-po
// de higiene propria, MESMO regime das ondas anteriores (adr-178/WI-159:
// pendente-reconhecido != verde-falso; o gate segue reject e visivel).
//
// ESTENDIDA (missao M7/adr-193, Frente S): a superficie do npm (schemas
// + port-manifest + api.yaml) traz 15 conceitos NOVOS ao sc-fct-01 (1 agg
// + 7 commands + 5 events published + 1 event internal + 1 event ACL
// -received) -- o npm nao passou pelas ondas anteriores porque nao tinha
// superficie (Forma A: zero firstClass no domain-model do npm). O
// am-participant NAO entrou nesta fatia: o estagio aggregate-skeleton do
// codegen exige `fields` declarados nos commands do domain-model, que o
// npm (era WI-055) nao declara -- o manifest entra JUNTO com a onda npm
// de Forma A (mesma fatia que declara os fields). npm segue types-only
// (molde inv) ate la. Entries pending reconhecidas per falsificacao 4
// do adr-151 (pendente-reconhecido != verde-falso; o gate segue reject e
// visivel). DRENAGEM: onda npm (molde das ondas anteriores) -- fatia de
// higiene propria com as 15 decisoes de Forma A (firstClass/reason/
// coreNoun + termos de glossario), que sao modelagem de dominio e NAO
// foram tomadas nesta fatia de superficie.


firstClassBackfillWorklist: {
	entries: [
		{conceptCode: "agg-sourcing-process", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-open-rfq", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-submit-quotation", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-withdraw-quotation", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-make-one-shot-sourcing-decision", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-designate-preferred-supplier", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-complete-strategic-award", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-cancel-rfq", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-revalidate-rfq-pool", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-sourcing-decision-made", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-preferred-supplier-designated", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-strategic-award-completed", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-rfq-opened", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-rfq-concluded", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-rfq-cancelled", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-quotation-submitted", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-quotation-withdrawn", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "evt-network-participant-status-changed-received", bc: "ssc", reason: "1o manifest do ssc (WI-159) traz o conceito ao sc-fct-01; Forma A pendente -- onda ssc", status: "pending"},
		{conceptCode: "cmd-propose-counter-terms", bc: "ssc", reason: "negociacao (WI-161) entra no am-sourcing-process; Forma A pendente -- onda ssc (mesmo regime do WI-159)", status: "pending"},
		{conceptCode: "cmd-revise-quotation", bc: "ssc", reason: "negociacao (WI-161) entra no am-sourcing-process; Forma A pendente -- onda ssc (mesmo regime do WI-159)", status: "pending"},
		{conceptCode: "cmd-decline-counter-terms", bc: "ssc", reason: "negociacao (WI-161) entra no am-sourcing-process; Forma A pendente -- onda ssc (mesmo regime do WI-159)", status: "pending"},
		{conceptCode: "evt-counter-terms-proposed", bc: "ssc", reason: "negociacao (WI-161) entra no am-sourcing-process; Forma A pendente -- onda ssc (mesmo regime do WI-159)", status: "pending"},
		{conceptCode: "evt-quotation-revised", bc: "ssc", reason: "negociacao (WI-161) entra no am-sourcing-process; Forma A pendente -- onda ssc (mesmo regime do WI-159)", status: "pending"},
		{conceptCode: "evt-counter-terms-declined", bc: "ssc", reason: "negociacao (WI-161) entra no am-sourcing-process; Forma A pendente -- onda ssc (mesmo regime do WI-159)", status: "pending"},
		{conceptCode: "agg-purchase-order", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "cmd-emit-purchase-order", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "cmd-cancel-purchase-order", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "evt-purchase-order-emitted", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "evt-purchase-order-cancelled", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "evt-sourcing-decision-made-received", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "evt-preferred-supplier-designated-received", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "evt-strategic-award-completed-received", bc: "p2p", reason: "am-purchase-order (fatia do fecho, missao M1/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda p2p-po", status: "pending"},
		{conceptCode: "agg-participant", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "cmd-register-participant", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "cmd-submit-qualification-documents", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "cmd-approve-qualification", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "cmd-suspend-participant", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "cmd-reactivate-participant", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "cmd-terminate-participant", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "cmd-record-identity-verification", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "evt-participant-registered", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "evt-participant-qualified", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "evt-participant-suspended", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "evt-participant-terminated", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "evt-participant-reactivated", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "evt-qualification-documents-received", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
		{conceptCode: "evt-identity-verification-received", bc: "npm", reason: "1o manifest do npm (missao M7/adr-193) traz o conceito ao sc-fct-01; Forma A pendente -- onda npm", status: "pending"},
	]
}
