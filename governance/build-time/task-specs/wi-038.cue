package task_specs

taskSpecs: "WI-038": {
	version:               1
	title:                 "Reconstruir context-map v2 sobre ontologia expandida"
	templateRef:           "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"Catálogo de subdomínios expandido (WI-037)",
		"domain-definition.cue corrigido (WI-036)",
	]
	outputs: [{
		artifact: "strategic/context-map.cue"
		type:     "update"
	}]
	affects: [
		"contexts/cmt/canvas.cue",
		"contexts/ctr/canvas.cue",
	]
	rationale: """
		Patch incremental do context map v1 não é viável porque a
		expansão ontológica desloca onde o ciclo econômico começa e
		quem é upstream de quem. O spine atual (CMT→BDG→DLV→INV→FCE)
		começa no meio do filme — o macrofluxo real inicia em P2P→SSC.
		Reclassificação core/supporting/generic, novos padrões de
		integração (P2P↔SSC, SSC↔NPM, INS↔CMT/SCF, TCM↔FCE) e
		documentação do macrofluxo canônico completo exigem reconstrução
		estruturada, não adição de nós a topologia existente. O context
		map v1 será base — não descartado.
		"""
}
