package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def070: artifact_schemas.#DeferredDecision & {
	id:     "def-070"
	title:  "Canal/superfície de notificação externa de deferred-decisions (Fibery vs GitHub vs outro)"
	date:   "2026-06-28"
	status: "open"

	description: """
		Fica deferida a ESCOLHA do canal externo (Fibery / GitHub Issues / outro)
		que notifica defs disparados-e-não-agidos FORA do loop do Claude Code —
		uma superfície compartilhada e passiva, que não depende de alguém abrir
		uma sessão do agente nem ler o CI. As Camadas 1 (gate de carência no CI,
		adr-162) e 3 (briefing de abertura de sessão, adr-162) cobrem o caso
		founder+CC; a Camada 2 só agrega quando há mais de um par de olhos que
		não entra pela sessão do CC.
		"""

	deferralRationale: """
		Enquanto o sistema é founder+CC, a Camada 3 (briefing automático na
		abertura de toda sessão) + a Camada 1 (gate vermelho no CI, quando ligado)
		já garantem que nenhum disparo passa despercebido — toda sessão e todo PR
		esbarram neles. Um canal externo (Fibery/GitHub) só agrega valor quando há
		atores que NÃO abrem sessão do CC nem leem o CI (ex.: um humano contratado,
		um stakeholder). Cravar a ferramenta agora seria escolher vendor antes de
		o usuário existir; o custo evitado é uma integração que provavelmente seria
		refeita. O custo de continuar deferindo é baixo: as duas outras camadas
		seguram a vigilância no regime atual.
		"""

	triggerCalibrationRationale: """
		O gatilho primário (primeiro humano além do founder operando o sistema) é
		evento de organização/negócio NÃO machine-evaluable — não há sinal de
		arquivo que o runner avalie; founder revisita quando contratar/onboardar.
		O temporal de 180d é BACKSTOP honesto e git-derivável: se ninguém
		revisitar em 6 meses, o trigger temporal dispara e — uma vez o gate da
		Camada 1 ligado — força um olhar. Assim o próprio def é pego pelo mecanismo
		que ele integra (não vira limbo): o briefing da Camada 3 sempre o lista
		como open; o backstop temporal o torna gateável pela Camada 1.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-162-deferred-decision-vigilance-grace-gate.cue",
		"session:dd-vigilance-3-camadas",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			Baixo enquanto founder+CC: as Camadas 1 (gate) e 3 (briefing) garantem
			detecção a cada PR e a cada sessão. O custo sobe quando entra um humano
			que não opera pela sessão do CC — aí falta uma superfície passiva
			compartilhada; até lá, é zero dano operacional.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Gatilho primário é evento de organização/negócio — primeiro humano além
			do founder operando o sistema, que muda a necessidade de uma superfície
			compartilhada. Não há sinal de arquivo que o runner avalie; founder
			revisita ao contratar/onboardar.
			"""
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
