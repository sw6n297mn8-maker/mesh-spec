package task_specs

taskSpecs: "WI-041": {
	version:               1
	title:                 "Expandir incentive analysis de CMT e CTR com vetores adversariais ausentes"
	templateRef:           "tmpl-validate-artifact@v1"
	semanticPrerequisites: [
		"Canvas CMT e CTR alinhados com context map v2 (WI-039)",
	]
	outputs: [{
		artifact: "contexts/cmt/canvas.cue"
		type:     "update"
	}, {
		artifact: "contexts/ctr/canvas.cue"
		type:     "update"
	}]
	affects: [
		"contexts/cmt/canvas.cue",
		"contexts/ctr/canvas.cue",
	]
	rationale: """
		Validação semântica pós-WI-039 (vc-cv-02) identificou gaps
		pré-existentes na incentive analysis de ambos os canvas:
		1. Ausência de sh-05 (agente IA) como participante com poder
		   assimétrico — operador que processa propostas, valida termos
		   e gerencia lifecycle tem vetores de manipulação por omissão
		   ou favoritismo não analisados.
		2. Vetor de conluio proponente-contraparte (CMT): aceite bilateral
		   não detecta inflação coordenada para obter antecipação via SCF.
		3. Vetor de front-running de threshold de escalação (CMT): propostas
		   calibradas logo abaixo do threshold evitam supervisão humana.
		4. Vetor de timing de ativação (CTR): registrante manipula timing
		   para criar janela de oportunidade antes de revisão pela
		   contraparte.

		Cada vetor deve ser mapeado como entrada formal na incentive
		analysis com estrutura explícita: actor, mechanism, preconditions,
		expectedGain, detectionSurface, mitigation e residualRisk. Vetores
		que não têm mitigação por mecanismos existentes devem gerar
		requirement explícito de mitigação.

		Três classes de vetor emergem: (a) economic manipulation (conluio,
		inflação), (b) governance bypass (threshold gaming, timing),
		(c) agent misalignment (IA como operador imperfeito). Formalizar
		como taxonomia é candidato a WI futuro; esta task resolve os
		gaps concretos identificados.
		"""
}
