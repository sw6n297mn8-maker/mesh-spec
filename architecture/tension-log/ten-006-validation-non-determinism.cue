package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten006: artifact_schemas.#TensionEntry & {
	id:    "ten-006"
	date:  "2026-04-07"
	title: "Validação semântica baseada em LLM apresenta variância entre execuções, incompatível com papel de gate determinístico"

	kind:          "cross-artifact-friction"
	tensionTarget: "governance/build-time/quality-gate.cue"
	manifestsIn:   "contexts/idc/canvas.cue"

	description: """
		O protocolo de validação descrito em CLAUDE.md seção
		Validação e formalizado em governance/build-time/quality-gate.cue
		atribui ao mecanismo de validation-prompts o papel de
		gate semântico após commit: findings com severity fail
		bloqueiam o fluxo até resolução ou aceitação explícita
		de tensão. A implementação concreta desse mecanismo é
		um prompt LLM (vp-canvas, vp-glossary, etc.) executado
		em contexto isolado sobre o artefato commitado. O
		mecanismo concreto observado nesta tensão foi
		architecture/validation-prompts/validate-canvas.cue,
		executado sobre o canvas IDC.

		Durante a validação do canvas IDC (commit acddea6),
		duas propriedades observáveis do mecanismo entraram em
		atrito com o papel atribuído:

		Propriedade 1 — variância entre execuções. Em rodadas
		sucessivas de validação semântica do canvas IDC, a
		variância nos findings (quais checks falharam, qual
		linha de raciocínio sustentou cada finding) excedeu o
		que seria aceitável para um gate determinístico.

		Propriedade 2 — falso positivo por leitura instável.
		Na segunda rodada, o check vc-cv-03 reportou ausência
		do bloco communication no canvas IDC. O bloco existia
		no artefato commitado e podia ser literalmente citado.
		O validador operou sobre uma interpretação do artefato,
		não sobre o artefato — e essa interpretação foi
		factualmente incorreta.

		Impacto sobre o papel de gate: um mecanismo cujo output
		varia entre execuções sobre o mesmo input não satisfaz
		os requisitos mínimos de um gate determinístico —
		reprodutibilidade, auditabilidade, e ausência de
		falsos positivos sobre fatos decidíveis. Findings
		variantes não podem ser tratados como veredito; falsos
		positivos sobre presença de blocos contaminam o pipeline
		com bloqueios espúrios.

		Consequência arquitetural: a Mesh distingue
		categoricamente verificação determinística de julgamento
		interpretativo (P10, dp-10, autonomy envelopes operam
		sobre essa distinção). O mecanismo atual de validação
		colapsa as duas categorias num único artefato cujo
		motor de execução (LLM) tem propriedades incompatíveis
		com a primeira categoria. A tensão não está em qualquer
		validation-prompt individual — está na atribuição do
		papel de gate a um mecanismo cuja natureza é
		interpretativa.
		"""

	resolution: """
		Resolvida estruturalmente por adr-040 (validation split:
		structural verification deterministic vs design review
		advisory). LLM removido categoricamente do papel de gate:
		nenhum finding produzido por validation prompt pode
		bloquear fluxo nem ser tratado como veredito factual.
		Validation prompts permanecem como mecanismo de design
		review advisory — output é recomendação para decisão do
		founder, nunca veredito vinculante de gate nem evidência
		factual autoautenticada.

		Gate determinístico pós-commit pertence exclusivamente ao
		mecanismo structural-check, formalizado por adr-041 e
		materializado pelo schema architecture/artifact-schemas/structural-check.cue
		e por instâncias em architecture/structural-checks/.
		Regras estruturais são declarativas, reproduzíveis e
		auditáveis — propriedades incompatíveis com motor LLM.

		Conclusão irrevogável: qualquer uso futuro de LLM como
		mecanismo de gate viola P10 (agentes estocásticos
		recomendam, gates determinísticos validam) e reabre
		exatamente esta tensão. A categoria 'design review
		interpretativo' e a categoria 'verificação estrutural
		determinística' são distintas por natureza do motor de
		execução, não por convenção — não podem ser colapsadas
		em um único mecanismo sem reincidir em ten-006.
		"""

	status: "resolved"

	relatedADR: "adr-040"

	rationale: """
		Tensão registrada antes da ADR de reposicionamento
		porque o fato arquitetural (variância de LLM como
		propriedade do mecanismo, não bug local) precisa
		existir como input rastreável da ADR. Sem este
		registro, a ADR pareceria opinião solta; com ele,
		a ADR responde a uma tensão documentada. A entry
		intencionalmente não propõe a solução — descreve
		apenas a observação, o impacto sobre o papel de
		gate e a consequência arquitetural. O desenho da
		resolução pertence à ADR e será referenciado aqui
		via relatedADR quando aprovada, momento em que o
		status desta tensão pode ser revisto.
		"""
}
