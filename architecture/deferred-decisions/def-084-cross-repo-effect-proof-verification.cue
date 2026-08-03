package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// def-084 -- A prova de efeito cross-repo do adr-184 e APRESENTADA, nunca
// VERIFICADA: o mesh-spec registra (repo, commit, gate, conclusao) e nao
// confere que o commit existe no alvo nem que o gate concluiu como alegado.
// Deferimento consciente do verificador, com o custo evitado nomeado e
// gatilhos codificados sobre volume de uso.

deferredDecisions: "def-084": artifact_schemas.#DeferredDecision & {
	id:    "def-084"
	title: "Verificacao automatica da prova de efeito cross-repo"
	date:  "2026-08-03"

	description: """
		O adr-184 dec 4 instala #EffectProof {repo, commit, gate, conclusion}
		dentro do #CompletionValidation. Nenhum mecanismo deste repositorio
		confere que o commit citado existe no repositorio-alvo, que o gate
		nomeado rodou naquele commit, ou que a conclusao registrada e a
		conclusao real. O que fica deferido e o VERIFICADOR: o leitor
		determinístico que fecha a distancia entre prova apresentada e prova
		verificada. O adr-184 declara o estatuto em voz alta (N1) e o
		falsificationCondition depende de amostragem manual cross-repo.
		"""

	deferralRationale: """
		Verificar exige capacidade que este repositorio ainda nao tem sob
		contrato: ler o CI de um repositorio subordinado a partir daqui, por
		repo e por tarefa. O unico precedente de leitura cross-repo spec-side
		e o .github/workflows/codegen-validation.yml, harness sob medida para
		o pipeline de codegen -- cinco passos, exit-map pre-fixado, um alvo
		unico -- e generaliza-lo por repositorio e por tarefa faria o
		mesh-spec EXECUTAR o CI dos subordinados, invertendo a divisao
		QUE=spec / COMO=runtime que o adr-157 e o adr-148 instituem e que a
		alternativa (c) do adr-184 foi rejeitada para preservar. O custo
		evitado agora e construir e manter esse leitor antes de existir
		volume que o justifique: hoje o mecanismo tem ZERO usos no disco. O
		custo de continuar deferindo cresce com o numero de provas
		declaradas -- enquanto forem poucas, a amostragem manual do
		falsificationCondition cobre; quando forem muitas, ela deixa de
		escalar e a prova vira carimbo. O trade-off e portanto temporal, e os
		gatilhos medem exatamente essa passagem.
		"""

	triggerCalibrationRationale: """
		O gatilho e VOLUME DE USO, nao tempo, porque o custo do deferimento e
		funcao do numero de provas nao-verificadas e nao da idade da decisao.
		Limiar 3 em task-specs que declaram effectExpectedIn: com uma ou duas,
		a conferencia manual e trivial e o verificador seria over-engineering;
		com tres ou mais, a amostragem deixa de ser exaustiva e passa a ser
		amostragem de verdade -- o ponto em que a ausencia de verificador
		muda de natureza. O temporal de 180 dias e rede duravel, nao gatilho
		primario: se o mecanismo ficar meio ano no disco sem uso nenhum, a
		revisita deve perguntar se ele deveria existir, e nao so se deveria
		ser verificado. Nenhum dos dois dispara hoje: o disco tem zero
		ocorrencias de effectExpectedIn.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-184-cross-repo-effect-as-completion-condition.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			Enquanto o verificador nao existe, toda prova de efeito e
			afirmacao do declarante. Um commit inexistente, um gate que nao
			rodou ou uma conclusao invertida passam em cue vet e em todo gate
			deste repositorio. O dano nao e imediato -- e a erosao da
			propriedade que o adr-184 compra: se a prova nao corresponde ao
			que o alvo fez, a conclusao da tarefa volta a ser verdadeira pela
			letra e vazia pelo proposito, que e exatamente o estado que a
			decisao existe para corrigir. medium porque o dano e cumulativo e
			nao bloqueia caminho critico; cross-cutting porque alcanca a
			governanca de trabalho deste repositorio mais a fronteira
			declarada de dois repositorios subordinados.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		scope:     "file-content"
		pattern:   "effectExpectedIn"
		pathScope: "^governance/build-time/task-specs/"
		threshold: 3
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]

	status: "open"
}
