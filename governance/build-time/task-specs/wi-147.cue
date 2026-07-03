package task_specs

taskSpecs: "WI-147": {
	version:     1
	title:       "async-api.yaml do FCE — superfície assíncrona publicada (2 channels), o degrau async do oq-fce-1 (item c, gatilho browser-live)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/fce/canvas.cue communication.outbound — os 2 event-publishers cross-BC (PaymentSettled → rew/scf/ato/tcm; PaymentObligationDefaulted → rew) + oq-fce-1 item (c) com gatilho real 'autorar JUNTO da fatia browser-live do frontend-runtime' — arco aberto, gatilho disparado.",
		"contexts/fce/schemas/events.cue — #PaymentSettled e #PaymentObligationDefaulted (fatia FCE do WI-140): payloads canônicos que o mirror JSON Schema espelha via x-mesh-cue-ref; em discrepância, o CUE vence (tq-async-02).",
		"strategic/context-map.cue fce-to-rew/fce-to-scf/fce-to-ato/fce-to-tcm — coverage tq-async-01: união dos events das 4 relationships = exatamente os 2 channels; nenhum evento publicado fora do spec, nenhum canal sem relationship.",
		"contexts/cmt/async-api.yaml + contexts/dlv/async-api.yaml + contexts/inv/async-api.yaml — o MOLDE 2.6.0 vigente (channels publish-only mesh.{bc}.{evento-kebab}.v1, envelope mesh-1, x-mesh-cue-ref, nota de escopo internal-only per precedente DLV): herança, não precedente novo. Delta da auditoria Mesh-Old: molde vivo 2.6.0 (3 BCs) mantido; Mesh-Old documentava 3.0 — divergência consciente, coerência interna > novidade; migração futura = fatia própria dos 4 arquivos.",
		"architecture/deferred-decisions/def-023-transport-bindings-pending-stack-adr.cue — bindings/servers ausentes por design; permanece open (não tocar; referenciado no info.description como nos 3 specs existentes; SEM amendment de enumeração — precedente def-024, que não foi emendado quando FCE entrou sob ele em WI-143/144: amendment é cost-driven, e publish-only não eleva o custo do deferimento).",
		"architecture/production-guides/asyncapi-spec.cue — PG aplicado section-by-section (manualAuthoringProtocol; asyncapi-spec fora do rollout da authoring-policy).",
	]
	outputs: [{
		artifact: "contexts/fce/async-api.yaml"
		type:     "create"
	}, {
		artifact: "contexts/fce/canvas.cue"
		type:     "update"
	}, {
		artifact: "contexts/fce/api.yaml"
		type:     "update"
	}]
	affects: [
		"architecture/structural-checks/canvas.cue",
	]
	rationale: """
		Degrau ASYNC do oq-fce-1 (item c; não fecha a oq: item b segue
		aberto): o gatilho re-datado no housekeeping 2026-07-03 — autorar
		junto da fatia browser-live do frontend-runtime (consumidor real
		FF-FE-06/adr-150) — disparou. EVIDÊNCIA do disparo: decisão do
		founder no comando desta sessão (S1, 2026-07-03: 'gatilho do
		oq-fce-1(c) disparado: arco browser-live aberto'); o arco vive no
		frontend-runtime (repo separado per adr-157) — a autoridade da
		abertura é o founder, não artefato in-repo.

		Três toques: (1) contexts/fce/async-api.yaml novo no molde 2.6.0
		dos 3 specs existentes — 2 channels publish-only (payment-settled;
		payment-obligation-defaulted), payloads mirror de schemas/events.cue
		com x-mesh-cue-ref, nota de escopo explicitando os 5 eventos
		internal-only (precedente DLV), SEM bindings/servers (def-023
		intocado — publish-only não eleva o custo do deferimento; contraste
		com o amendment cost-driven do def-024 em WI-146); (2) canvas —
		impact do oq-fce-1 atualizado (item c materializado; sc-cv-03 do
		FCE passa a satisfeito — flags true/true já corretas, nenhuma
		mudança de flag); (3) api.yaml — info.description atualizado no
		trecho 'Deferidos' (o item c saiu do rol; sem toque em paths/
		schemas), eliminando a contradição cross-artefato com o canvas
		sobre sc-cv-03.

		NOTA de fidelidade: canal payment-obligation-defaulted declarado
		mesmo com o FLUXO de default fora da fatia (T2 — nenhuma transição
		o emite ainda): o catálogo events.cue + context-map fce-to-rew o
		declaram (integridade sc-cm-06); o spec espelha o contrato, não o
		runtime. Forward-ref REW (WI-043 / oq-fce-4) registrada na
		description do canal.

		CLASSIFICAÇÃO: instanciação sob schema #AsyncAPISpec + PG
		asyncapi-spec existentes (adr-048/convenção api-spec) — SEM ADR
		novo (precedente: async-api do CMT/DLV/INV; WI-143/144/146 para
		superfícies FCE). Standalone task-spec. Reversível por remoção do
		arquivo + reversão dos impacts.
		"""
}
