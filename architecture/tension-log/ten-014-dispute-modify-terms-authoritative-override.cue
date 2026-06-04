package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten014: artifact_schemas.#TensionEntry & {
	id:    "ten-014"
	date:  "2026-06-03"
	title: "Carve-out autoritativo de inv-mutual-bilateral-acceptance para modify_terms via DRC"

	kind:          "axiom-tension"
	tensionTarget: "contexts/cmt/domain-model.cue#inv-mutual-bilateral-acceptance"
	manifestsIn:   "contexts/cmt/domain-model.cue"

	description: """
		O invariante inv-mutual-bilateral-acceptance ("compromisso só transiciona para accepted com
		confirmação bilateral sobre termos idênticos") colide com o caminho modify_terms de
		cmd-handle-dispute-resolution, que altera os termos de um compromisso JÁ accepted sem novo
		AcceptanceConfirmation. Aplicado literalmente a este caminho, o invariante seria violado: a
		contraparte não reconfirma os termos modificados.
		"""

	resolution: """
		Alternativa escolhida (SD1 da Fatia B, adr-143): o invariante passa a valer para a FORMAÇÃO
		INICIAL (proposed→accepted). A modificação por resolução de disputa é override autoritativo do
		DRC, validado sync contra o CTR (preserva lastro; fail-closed se CTR indisponível), e recomputa o
		termsHash — sem novo aceite bilateral.

		Alternativa rejeitada: exigir re-aceite bilateral em modify_terms (ambas as partes reconfirmam os
		termos modificados). Rejeitada porque disputa existe precisamente quando o consenso bilateral
		falhou — exigir re-aceite torna a resolução circular (uma parte sempre pode recusar, e a disputa
		nunca resolve).

		Limite inviolável preservado: a disputa NÃO pode criar termo material fora do CTR — daí a
		revalidação CTR fail-closed em modify_terms (inv-dispute-modify-terms-revalidates-ctr, sc-cmt-09).
		"""

	status: "accepted"

	relatedADR: "adr-143"

	rationale: """
		Disputa existe quando o consenso bilateral falhou; exigir re-aceite torna a resolução circular.
		Limite inviolável: disputa não pode criar termo material fora do CTR — daí revalidação CTR
		fail-closed em modify_terms.

		status=accepted (não resolved): o carve-out é convivência consciente, não eliminação da tensão —
		o invariante continua "blanket" na leitura ingênua, e este registro é o que torna a exceção
		explícita para leitores futuros. Sem structuralResolutionPath: o carve-out é aceito como
		permanente até prova em contrário; a falsificationCondition do adr-143 nomeia a condição que
		exigiria ADR próprio (disputa impondo termos judiciais/arbitrais fora do CTR).
		"""
}
