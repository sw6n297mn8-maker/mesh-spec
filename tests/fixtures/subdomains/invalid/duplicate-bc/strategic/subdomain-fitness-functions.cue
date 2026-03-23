package mesh_spec

#FitnessSeverity: "fail" | "warn"

// Campo canônico renomeado de `algorithm` para `algorithmDescription`
// para explicitar que se trata de descrição normativa, não de executor.
#FitnessFunction: {
	id:                   string & =~"^ff-sd-[0-9]{2}$"
	description:          string & !=""
	severity:             #FitnessSeverity
	rationale:            string & !=""
	algorithmDescription: string & !=""
}

subdomainFitnessFunctions: {
	functions: [#FitnessFunction, ...#FitnessFunction]
	rationale: string & !=""
}

subdomainFitnessFunctions: {
	functions: [{
		id:                   "ff-sd-01"
		description:          "Toda referência a subdomínio aponta para código existente"
		severity:             "fail"
		rationale:            "Referência quebrada torna o catálogo semanticamente inválido."
		algorithmDescription: "Validar delegatedTo, participants.ref e deprecation.absorbedBy contra subdomainCatalog.subdomains."
	}, {
		id:                   "ff-sd-02"
		description:          "Bounded Context não pertence a mais de um subdomínio"
		severity:             "fail"
		rationale:            "Ownership ambíguo destrói a decomposição estratégica."
		algorithmDescription: "Construir índice invertido de boundedContexts.ref e falhar se houver múltiplos owners ativos."
	}, {
		id:                   "ff-sd-03"
		description:          "crossCuttingLayers não repete strategicLayer"
		severity:             "fail"
		rationale:            "Repetir a home layer em crossCuttingLayers é redundância ou erro conceitual."
		algorithmDescription: "Falhar se strategicLayer estiver contida em crossCuttingLayers."
	}, {
		id:                   "ff-sd-04"
		description:          "Core ativo não pode ficar sem mechanismRefs"
		severity:             "fail"
		rationale:            "Core sem mechanismRefs perde rastreabilidade à tese."
		algorithmDescription: "Falhar se status=active, type=core e mechanismRefs vazio."
	}, {
		id:                   "ff-sd-05"
		description:          "Supporting ativo não deve ficar sem mechanismRefs"
		severity:             "warn"
		rationale:            "Supporting desconectado do domínio costuma indicar classificação ruim."
		algorithmDescription: "Emitir warn se status=active, type=supporting e mechanismRefs vazio."
	}, {
		id:                   "ff-sd-06"
		description:          "Core ativo deve contribuir para pelo menos um moat"
		severity:             "fail"
		rationale:            "Core sem moat é provavelmente classificação errada."
		algorithmDescription: "Falhar se status=active, type=core e moatTypes vazio."
	}, {
		id:                   "ff-sd-07"
		description:          "Core e supporting ativos devem produzir outcome explícito"
		severity:             "fail"
		rationale:            "Subdomínio não genérico sem outcome perde justificativa de negócio."
		algorithmDescription: "Falhar se status=active, type!=generic e businessOutcomes vazio."
	}, {
		id:                   "ff-sd-08"
		description:          "Deprecated deve ter absorção e motivo explícitos"
		severity:             "fail"
		rationale:            "Deprecated sem destino ou sem justificativa vira lixo conceitual."
		algorithmDescription: "Falhar se status=deprecated e deprecation.absorbedBy vazio ou deprecation.reason vazio."
	}, {
		id:                   "ff-sd-09"
		description:          "Participants não podem referenciar o próprio subdomínio"
		severity:             "warn"
		rationale:            "Autorreferência costuma ser redundância semântica."
		algorithmDescription: "Emitir warn se participants.ref == code."
	}, {
		id:                   "ff-sd-10"
		description:          "Negative boundary não pode delegar para si mesmo"
		severity:             "fail"
		rationale:            "Self-delegation é contradição lógica."
		algorithmDescription: "Falhar se negativeBoundaries.delegatedTo == code."
	}, {
		id:                   "ff-sd-11"
		description:          "Subdomínio ativo sem BC mapeado é suspeito"
		severity:             "warn"
		rationale:            "Pode ser aceitável em bootstrap, mas deve ser transitório."
		algorithmDescription: "Emitir warn se status=active e boundedContexts vazio."
	}, {
		id:                   "ff-sd-12"
		description:          "Aliases não podem colidir com codes ativos"
		severity:             "fail"
		rationale:            "Colisão de alias cria ambiguidade de referência."
		algorithmDescription: "Falhar se alias de um subdomínio colidir com code ativo de outro."
	}]
	rationale: "Catálogo canônico das fitness functions de subdomínio."
}
