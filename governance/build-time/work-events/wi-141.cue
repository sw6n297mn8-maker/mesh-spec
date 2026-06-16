package work_events

// wi-141.cue -- Backfill do lifecycle de WI-141 (executado via fluxo direto
// founder<->agente em PRs; sem stream de work-events vivo a epoca -- precedente
// wi-137/wi-131). Timestamps REAIS (dados granulares existem: WI recente):
// proposed/approved = registro no wave-plan (#149, 4e029d9); claimed = inicio
// da execucao (acao a, #150, 427cb7b); completed = merge do #152 (5b34b58).
//
// Arco WI-141 (3 acoes): (a) re-materializar os derivados stale (#150);
// (b) diagnosticar a causa-raiz -- auto-commit pos-merge rejeitado por GH013
// (main-exige-PR), com 'git push || echo' engolindo a falha; (c) consertar +
// tornar a falha audivel via adr-152 -- decisao #151 (gate de drift substitui
// o auto-commit) + materializacao #152 (regenerate-derived.sh + 3 steps no
// validate.yml; remocao dos 2 materialize-*).
//
// DIVERGENCIA outputs declarados vs realidade: o wave-plan WI-141 declara os 5
// outputs como type "update". Realidade: structure-index/tree/README atualizados
// (#150 + #152); MAS os 2 .github/workflows/materialize-*.yml foram REMOVIDOS
// (#152), nao atualizados -- substituidos pelo gate de drift per adr-152. A
// verdade do RESULTADO vive aqui (event = fonte canonica de resultado); o
// wave-plan permanece como declaracao de PLANO, intacto.
//
// RECONCILIACAO do campo outputs no wave-plan = trabalho futuro NAO-bloqueante:
// nao ha check-de-realidade lendo outputs vs disco (generate-structure-index.py
// le so type=create, degradavel; nenhum structural-check valida existencia de
// output), logo nenhum gate falha; sem def-XXX (peso desproporcional para campo
// sem gate). Precedente wi-103: divergencia analoga (path-drift) foi registrada
// no event e o plano reconciliado depois (correcao factual N2, 2026-06-11) --
// deferir a reconciliacao provou confiavel.
//
// artifactSnapshotHash = git blob de scripts/ci/regenerate-derived.sh em
// 5b34b58 (centro do deliverable "tornar a falha audivel"). gatesPassed =
// checks verdes no #152, incl. derived-drift-gate -- o proprio deliverable do
// WI-141 validou a conclusao do WI-141 (dogfooding).
streams: "WI-141": events: [{
	eventType:   "task-proposed"
	taskId:      "WI-141"
	taskVersion: 1
	commandId:   "WI-141-propose-derived-materialization-health-backfill"
	timestamp:   "2026-06-15T22:52:44Z"
	actor:       "founder"
}, {
	eventType:   "task-approved"
	taskId:      "WI-141"
	taskVersion: 1
	commandId:   "WI-141-approve-derived-materialization-health-backfill"
	timestamp:   "2026-06-15T22:52:44Z"
	actor:       "founder"
}, {
	eventType:      "task-claimed"
	taskId:         "WI-141"
	taskVersion:    1
	commandId:      "WI-141-claim-derived-materialization-health-backfill"
	timestamp:      "2026-06-15T23:24:27Z"
	actor:          "spec-writer"
	claimExpiresAt: "2026-06-16T07:24:27Z"
}, {
	eventType:   "task-completed"
	taskId:      "WI-141"
	taskVersion: 1
	commandId:   "WI-141-complete-derived-materialization-health-backfill"
	timestamp:   "2026-06-16T11:48:21Z"
	actor:       "spec-writer"
	completionValidation: {
		validationRunId:      "WI-141-completion-backfill-20260616"
		artifactSnapshotHash: "88800e07e3ef33333edf2cc4cc5b54ef34237454"
		gatesPassed: ["cue-vet", "structural-check", "self-review-enforcement", "phantom-gate", "derived-drift-gate"]
	}
}]
