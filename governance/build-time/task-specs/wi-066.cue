package task_specs

taskSpecs: "WI-066": {
	version:     1
	title:       "Backfill verticalApplicability nos 74 artefatos restantes cobertos por adr-043"
	templateRef: "tmpl-create-instance@v1"
	semanticPrerequisites: [
		"adr-043 vigente — tipo #VerticalApplicability disponível em architecture/shared-types/vertical-applicability.cue",
		"adr-045 vigente — declara cobertura completa dos 83 artefatos elegíveis como meta, com pausa em 9 como deferimento pragmático",
		"Heurística calibrada de classificação registrada em ten-007 e nos rationales dos 9 artefatos do piloto: 'adaptable exige identificar pontos de variação concretos no artefato; ausência de pontos de variação concretos com núcleo universal indica agnostic'",
		"Escopo limitado a artefatos que ainda não declaram verticalApplicability — os 9 já classificados (6 lenses, 2 subdomains, 1 canvas) estão fora do escopo",
		"Cada artefato tocado também recebe edição em modo on-touch quando a oportunidade aparecer fora desta WI — wi-066 e on-touch são complementares, não exclusivos",
	]
	outputs: [{
		artifact: "architecture/lenses/*.cue"
		type:     "update"
	}, {
		artifact: "strategic/subdomains/*.cue"
		type:     "update"
	}, {
		artifact: "contexts/*/canvas.cue"
		type:     "update"
	}]
	affects: []
	rationale: """
		Trabalho de backfill criado pela inversão registrada em
		adr-045. A intenção original do piloto adr-043 era cobrir
		todos os 83 artefatos elegíveis (54 lenses, 25 subdomains,
		4 canvases); a sessão inicial classificou 9 e foi
		interrompida por restrição de tempo, não por suficiência
		principial. wi-066 captura o trabalho restante como
		obrigação aberta para evitar drift entre intenção e
		registro.

		Escopo concreto (74 artefatos):
		- 48 lenses em architecture/lenses/ (54 totais menos 6
		  já classificadas no piloto)
		- 23 subdomains em strategic/subdomains/ (25 totais
		  menos 2 já classificados)
		- 3 canvases em contexts/{bc}/canvas.cue (4 totais menos
		  1 já classificado)

		Os globs em outputs representam a classe de artefato
		afetada; o escopo real é apenas as instâncias sem
		verticalApplicability declarada. Esta limitação é
		registrada explicitamente em semanticPrerequisites.

		Nota sobre templateRef: tmpl-create-instance@v1 é
		aproximação. O template foi pensado para criar uma
		instância nova de schema, não para adicionar campo
		opcional a 74 instâncias existentes. Não há template
		dedicado a backfill incremental no catálogo atual
		(tmpl-validate-artifact@v1, tmpl-create-script@v1 e
		tmpl-create-schema@v1 também não cabem). create-instance
		é o que mais se aproxima estruturalmente: cada commit
		do backfill cria uma nova instância do tipo
		#VerticalApplicability dentro do artefato hospedeiro.
		Decisão deliberada de não criar tmpl-update-instance@v1
		neste momento — esperar por massa de casos antes de
		formalizar template novo, pelo mesmo princípio de
		retorno marginal aplicado em ten-007.

		Modo de execução pretendido: lotes em sessões dedicadas,
		preservando proposta-aprovação-commit por artefato. A
		ordem entre tipos (lenses, subdomains, canvases) pode
		ser definida por prioridade de aprendizado ou oportunidade
		operacional em cada sessão — não há sequência fixa
		imposta por esta WI. O que permanece invariante é o
		formato: sessões dedicadas, sem batch agressivo, sem
		automação, uma proposta por artefato.

		Esta WI não tem prazo. Não deve ser iniciada sem
		aprovação explícita por sessão. on-touch continua
		ativo como mecanismo complementar entre sessões de
		wi-066.

		Criticality medium (default): edição de governança
		semântica em artefatos arquiteturais. Sem movimento
		financeiro ou decisão regulatória. Reversível por
		nova edição manual caso a heurística produza
		classificação errada.
		"""
}
