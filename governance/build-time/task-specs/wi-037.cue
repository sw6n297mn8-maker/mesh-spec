package task_specs

taskSpecs: "WI-037": {
	version:               1
	title:                 "Expandir catálogo estratégico de subdomínios — novos BCs e revisão dos existentes"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"domain-definition.cue corrigido (WI-036)",
	]
	outputs: [{
		artifact: "strategic/subdomains/p2p.cue"
		type:     "create"
	}, {
		artifact: "strategic/subdomains/ssc.cue"
		type:     "create"
	}, {
		artifact: "strategic/subdomains/itc.cue"
		type:     "create"
	}, {
		artifact: "strategic/subdomains/tcm.cue"
		type:     "create"
	}, {
		artifact: "strategic/subdomains/ins.cue"
		type:     "create"
	}, {
		artifact: "strategic/subdomains/idc.cue"
		type:     "create"
	}]
	affects: [
		"strategic/subdomains/npm.cue",
		"strategic/subdomains/scf.cue",
		"strategic/subdomains/nim.cue",
		"strategic/subdomains/log.cue",
		"strategic/subdomains/ato.cue",
		"strategic/subdomains/fce.cue",
		"strategic/subdomains/ctr.cue",
		"strategic/subdomains/cmt.cue",
		"strategic/subdomains/bdg.cue",
		"strategic/subdomains/idn.cue",
		"strategic/subdomains/dgv.cue",
		"strategic/context-map.cue",
	]
	rationale: """
		Ontologia expandida (WI-036) desloca o início do ciclo econômico
		para antes do compromisso — demanda interna, sourcing,
		qualificação — e adiciona camadas de proteção, tesouraria e
		comércio exterior ausentes. Sem esses subdomínios, o context map
		não pode representar o macrofluxo real
		(P2P→SSC→NPM→CTR→CMT→...→ATO/TCM). Subdomínios existentes
		precisam revisão de escopo para refletir a definição expandida.
		Lista de novos BCs é candidata — decisões de fusão (IDN+DGV→IDC
		é nome candidato, não canônico), renomeação e reagrupamento serão
		tomadas durante a execução com aprovação do founder.
		"""
}
