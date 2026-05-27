package dlv

meta: "contexts/dlv": {
	canonicalPath: "contexts/dlv"
	purpose:       "Bounded Context Delivery & Verification: verifica execução operacional contra critérios versionados acordados em CMT e decide deterministicamente a suficiência de evidência para progressão econômica."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "Verificação determinística de evidência é responsabilidade distinta da formalização (CMT) e da execução; BC próprio mantém critérios versionados e decisões idempotentes/replay-able auditáveis."
}
