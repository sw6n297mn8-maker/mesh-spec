package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten016: artifact_schemas.#TensionEntry & {
	id:    "ten-016"
	date:  "2026-07-29"
	title: "Envelope intentionally-minimal vs necessidade cross-BC do slot estruturado de ator"

	kind: "schema-limitation"

	tensionTarget: "architecture/shared-schemas/envelope.cue"
	manifestsIn:   "architecture/shared-schemas/envelope.cue"

	description: """
		O #Envelope consolidado (def-022) é INTENTIONALLY MINIMAL, com
		disciplina anti-stealth-extension explícita no header: nenhuma
		expansão cross-BC sem (1) tension-entry articulando a necessidade
		real, (2) revisita dos consumidores existentes, (3) decisão
		explícita do founder. A NECESSIDADE REAL que esta entry articula:
		todo ato do sistema grava o ator como string nominal não-verificada
		(18 ocorrências da postura def-024 nos BCs) e o event log é
		imutável — sem um slot ESTRUTURADO e UNIFORME de ator (quem, em
		nome de quem, em que papel, sob que governança), a identidade de
		autor não é reconstituível de fato algum, e cada fatia nova acumula
		mais fatos sob o regime provisório. A alternativa sem expansão
		(ator em data por-evento) re-declararia o shape por BC e devolveria
		a uniformidade à disciplina-por-autor — o modo de falha que as 18
		strings provam. Não é conveniência: é a decisão cara-de-retrofit do
		WI-158, com dp-10 (responsabilidade jurídica identificável) no
		cerne.
		"""

	resolution: """
		Expansão APROVADA pela rota formal da própria disciplina: esta
		entry é o passo (1); a revisita cross-BC é o passo (2), registrada
		no adr-182 dec 3 — o campo actor? nasce OPCIONAL no shape, nenhum
		evento legado ou consumidor existente quebra (grandfathering
		declarado; obrigação por norma de handler para atos novos); a
		decisão explícita do founder é o adr-182 (Gate 2, 2026-07-29 — lar
		do ator confirmado com a rota ten-016 nomeada). A disciplina foi
		PERCORRIDA, não contornada — e permanece em vigor para qualquer
		expansão futura; o header do envelope registra esta como a expansão
		formal única até aqui.
		"""

	status: "resolved"

	relatedADR: "adr-182"

	rationale: "A disciplina do envelope existe para impedir stealth-extension — e só cumpre esse papel se as expansões LEGÍTIMAS passarem pela rota formal em vez de contorná-la: esta entry é a prova de percurso (necessidade articulada → revisita → decisão), e o precedente de como a próxima expansão deve entrar. Ganho: slot uniforme de ator com dp-10 reconstituível; perda aceita: o envelope deixa de ser mínimo-absoluto (1 campo opcional a mais), com a disciplina intacta para o resto."
}
