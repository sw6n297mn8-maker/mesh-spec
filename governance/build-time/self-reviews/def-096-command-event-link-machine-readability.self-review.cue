package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def096CommandEventLinkMachineReadability: build_time.#SelfReviewReport & {
	reportId: "srr-def-096-command-event-link-machine-readability"

	artifactPath:       "architecture/deferred-decisions/def-096-command-event-link-machine-readability.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-07"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido no CRITÉRIO DE PERTINÊNCIA (anti-catch-all): o
			rascunho juntava neste def o achado da leitura da RFQ pelo
			fornecedor, porque os dois saíram da mesma medição. São naturezas
			distintas — este é campo de schema e alcance de verificação;
			aquele é lacuna de modelo com consequência de produto e
			severidade outra. Fundi-los faria do def-096 o dumping ground que
			o próprio schema nomeia como risco do tipo. Separado em def-097,
			com a medição própria.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Zero fails. Correção mecânica de sintaxe no caminho: o trigger
			recurrence usa campos PLANOS (pattern/scope/pathScope/threshold),
			não o objeto condition aninhado do adjacent-need — cue vet pegou,
			molde conferido no def-075, não exigiu novo ciclo. Trigger
			verificado POR EXECUÇÃO no runner: 'recurrence count 2 < threshold
			3' — não dispara hoje e dispara na terceira story, que é o
			desenho. Calibração medium RATIFICADA pelo founder com o
			contraste explícito ao def-095: lá a rede sem fornecedores é o
			produto não funcionando; aqui nada quebra e o custo é de alcance
			de verificação. cue vet ✓.
			"""
	}]

	findings: {}

	summary: """
		def-096 registra que o #Command não tem campo de evento emitido — as
		chaves são [code, name, description, rationale, fields] — e que o elo
		comando→evento vive em apenas dois lugares: dentro de
		lifecycle.transitions[].emitsEvents, só para comandos que
		transicionam, e em PROSA no rationale do comando.

		A medição que o motiva não é leitura: é a fatia 0 de cobertura
		derivada rodada sobre o corpus vivo. 4 de 14 commandRefs (29%) têm
		transição; a ds-supplier-network-journey inteira é 0 de 6. Entry-
		points e mutações intra-state são invisíveis por natureza.

		O argumento que sustenta o deferimento e não é de conveniência: a
		forma óbvia — campo opcional — traria meia-verdade estrutural, sem
		distinguir 'não emite' de 'não declarado'. É o mesmo vazio ambíguo
		que a auditoria do #DomainStory encontrou, e propor a emenda com esse
		defeito embutido seria transplantá-lo para o domain-model.

		Três formas nomeadas, nenhuma escolhida. O def defere a DECISÃO, não
		a modelagem.
		"""
}
