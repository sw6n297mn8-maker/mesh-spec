package rew

meta: "contexts/rew": {
	canonicalPath: "contexts/rew"
	purpose:       "Bounded Context Risk Engine & Risk Observability: avaliação de risco e elegibilidade como camada derivada da operação verificada da rede, consolidando sinais para BCs consumidores (SCF, CMT e outros)."
	conventions: [
		"canvas.cue é a porta de entrada do BC; leitura obrigatória antes de alterar artefato interno.",
		"Eventos deste BC são consumidos por contratos declarados em strategic/context-map.cue.",
	]
	rationale: "Centralizar risco evita que cada BC consumidor implemente lógica local e gere score fragmentado; REW existe como função dos dados operacionais verificados, não como motor independente."
}
