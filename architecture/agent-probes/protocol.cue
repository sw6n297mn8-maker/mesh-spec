package agent_probes

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// protocol.cue — Instância singleton do protocolo agent-probe (Ciclo 4, adr-134).
// Conforma a #AgentProbeProtocol (architecture/artifact-schemas/agent-probe-protocol.cue).

protocol: artifact_schemas.#AgentProbeProtocol & {
	id:      "agent-probe-protocol"
	version: "1"

	purpose: """
		Ciclo 4 dos feedback-cycles de build-time: falsificar a spec de um BC
		dando o canvas fechado a um agente limpo e tratando cada ambiguidade,
		alucinação ou pergunta como buraco na spec. É validação semântica advisory
		(camada P10, adr-040) — recomenda buracos ao founder, não gateia. Complementa
		os Ciclos 1-3 (structural-checks determinísticos) com a dimensão que estrutura
		não alcança: a spec consegue expressar o domínio sem furo para um leitor que
		só tem o canvas?
		"""

	isolation: {
		cleanSession:       true
		allowedInputs:      ["canvas"]
		excludedInputs:     ["domain-model", "ADRs", "glossary", "context-map"]
		promptNonRevealing: true
		rationale: """
			O valor do probe vem de NEGAR contexto. Se o agente vê o domain-model,
			os ADRs ou o glossary, ele ratifica o design existente em vez de
			falsificá-lo (viés de confirmação). Inversão deliberada do modelo de
			references do validation-prompt — lá se FORNECE contexto; aqui se RETIRA.
			O prompt não revela as respostas esperadas: pede reconstrução, não
			conferência contra gabarito.
			"""
	}

	probeTask: """
		Gere os testes de aceitação (Given/When/Then) derivados EXCLUSIVAMENTE deste
		canvas. Onde o canvas não der informação suficiente, marque a assunção
		explicitamente. Não consulte nenhuma outra fonte.
		"""

	promptTemplate: {
		version: "1"
		template: """
			Você é um agente limpo, sem histórico. Recebe um único artefato: o canvas
			de um bounded context. Sua tarefa: produzir os testes de aceitação
			(Given/When/Then) que derivam do canvas — capabilities, eventos, comandos,
			queries, invariantes, governança. Regras: (1) use SÓ o canvas; (2) onde o
			canvas for insuficiente para escrever o teste, declare a assunção como
			[S#] e enuncie-a por extenso; (3) não pergunte — assuma e marque. Entregue
			os testes + a lista consolidada de assunções.
			"""
	}

	findingTaxonomy: [
		"spec-incompleteness",
		"spec-ambiguity",
		"spec-miscommunication",
		"probe-noise",
	]

	closingDoD: """
		Um probe está completo quando: (a) o agente entregou os testes + assunções;
		(b) cada assunção foi triada numa das 4 categorias de findingTaxonomy; (c)
		todo finding não-noise recebeu disposition (linkedTo um tracker OU
		acceptedAsResidual). O protocolo NÃO corrige a spec — só registra os buracos
		no probe-record; a correção é trabalho separado do BC alvo (ADR/oq/WI próprios,
		sessão própria). Triagem por agente é advisory (P10): o founder decide o que
		é defeito real vs ruído.
		"""

	rationale: """
		Self-contained (estilo validation-prompt): isolamento + taxonomia + prompt
		versionado vivem aqui, sem ref cross-file — por isso exempt de structural-check
		próprio (sc-meta-02). O record (#AgentProbeRecord) é que carrega a cross-ref
		(targetCanvas) e o gate referencial (sc-apr-01). A cobertura "todo canvas
		probado" é sc-apr-02 (born-warn). promptTemplate versionado garante
		reprodutibilidade do probe ao longo do tempo (o record cita protocolVersion).
		"""
}
