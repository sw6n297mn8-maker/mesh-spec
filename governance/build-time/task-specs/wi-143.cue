package task_specs

taskSpecs: "WI-143": {
	version:     1
	title:       "Autorar a superfície de leitura do FCE (contexts/fce/api.yaml, query-only) + reconciliar o enum da query-surface do canvas com o lifecycle materializado (adr-155)"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"contexts/fce/domain-model.cue — agg-payment com lifecycle materializado de 6 estados (guarded/escalated/authorized/dispatched/settled/refused): fonte canônica do enum de status do view de leitura.",
		"contexts/fce/schemas/events.cue — JÁ EXISTE; declara #PaymentState (6 estados), #PaymentId, #CommitmentRef e #RailReferenceId que o api.yaml referencia via x-mesh-cue-ref (não recriar, não duplicar).",
		"architecture/adrs/adr-155-human-override-prepayment-guard-fce.cue (accepted) — adicionou escalated + refused à state machine; contexts/fce/canvas.cue consta em affectedArtifacts e teve a query-surface deixada para trás (materialização pendente que este WI completa).",
		"contexts/fce/canvas.cue — hasSyncSurface=true declara que a superfície síncrona deve existir (sc-cv-02); communication.inbound é event/query-only (sem command-handler), logo a query é a única superfície sync exposta pelo FCE.",
		"architecture/conventions/api-spec-convention.cue — presença bicondicional a hasSyncSurface; materialização pure-authored (OpenAPI 3.x escrito à mão); governa presença, não conteúdo.",
		"architecture/shared-schemas/ — Problem (RFC7807) e tipos shared referenciados pelo api.yaml, nunca duplicados.",
	]
	outputs: [{
		artifact: "contexts/fce/canvas.cue"
		type:     "update"
	}, {
		artifact: "contexts/fce/api.yaml"
		type:     "create"
	}]
	affects: [
		"architecture/structural-checks/canvas.cue",
	]
	rationale: """
		Recorte de leitura do oq-fce-1 (NÃO o fecha): autora a única superfície
		síncrona que o FCE expõe — a query QueryPaymentSettlementStatus (GET) —,
		incluindo o estado escalated que a tela de override (frontend-runtime)
		precisa ler. Dois toques: (1) canvas — reconcilia o enum do returnType da
		query-surface com o lifecycle materializado (adr-155: adiciona escalated e
		refused, remove failed/indeterminate/cancelled — estados T2 ainda não
		materializados no lifecycle); instanciação sob ADR aceito (canvas já em
		adr-155.affectedArtifacts), sem novo ADR. (2) api.yaml query-only, molde
		cmt/dlv, referenciando #PaymentState/#PaymentId/#CommitmentRef/
		#RailReferenceId de schemas/events.cue (já existente — output é só o api.yaml).

		PRINCÍPIO (registrado): canvas pode mencionar intenção futura; o contrato de
		API só expõe estado materializado. O enum da query é o lifecycle vivo, não o
		roadmap — estados T2 (failed/indeterminate/cancelled) ficam fora do contrato
		até serem materializados no lifecycle, com nota explícita no canvas (não
		silenciado).

		Ordem contrato-primeiro (oq-fce-1 rationale; precedente: WI produz o contrato,
		runtime consome downstream): o contrato de leitura não espera o escalated
		estar vivo no backend — declara a capacidade que o runtime materializa depois.

		FORA DESTE WI (registrado em nota no header do api.yaml; oq-fce-1 permanece
		aberta): o endpoint de resolve-guard-escalation (exige primeiro um command
		surface na communication.inbound do canvas + def-024/auth para o supervisorId
		na borda); os comandos do caminho autônomo (canvas declara inbound
		event-driven, sem command surface); e async-api.yaml (sc-cv-03 segue
		insatisfeito — meio-termo é foto, sem real-time FF-FE-06).

		Criticality medium (default tmpl-create-instance@v1). Reversível por remoção
		do api.yaml e reversão do returnType. Standalone task-spec — não entra no
		wave-plan (precedente WI-129/130/131). FCE é BC regulado: a convenção governa
		presença, não conteúdo; obrigações regulatórias do conteúdo seguem
		responsabilidade do BC (api-spec-convention regulatoryBoundary).
		"""
}
