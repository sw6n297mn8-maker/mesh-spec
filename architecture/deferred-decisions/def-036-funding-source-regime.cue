package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def036: artifact_schemas.#DeferredDecision & {
	id:     "def-036"
	title:  "Regime de fonte de funding do advance — escolha próprio/parceiro, risco por modo, impacto no PrePaymentGuard (escopo amplo de pf-scf-1)"
	date:   "2026-06-01"
	status: "open"

	description: """
		adr-137 abriu o canal de execução do disbursement (aresta scf→fce, ciclo tipado
		bidirectional-orchestration) e fixou que o canal é SEMPRE o FCE, com a FONTE de
		capital variável (próprio quando houver receita + autorização BC; parceiro para
		diluir risco). Fica deferido, conscientemente, o REGIME da fonte: (1) como a
		fonte de funding (próprio vs parceiro) é escolhida por operação/carteira; (2) o
		regime de risco por modo (quem absorve o risco em cada fonte; limites; capital
		próprio sob licença SCD vs capital de terceiros); (3) o impacto da fonte no
		PrePaymentGuard do FCE — se/como o gate de pré-pagamento difere por fonte de
		capital. Este DD cobre o escopo amplo que adr-137 separou do escopo mínimo.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: os detalhes de cada modo dependem de condições que ainda
		NÃO existem — receita do Mesh + autorização do Banco Central para operar capital
		próprio; e parceiros de funding concretos para o modo parceiro. Modelar o regime
		agora seria especular sobre regime regulatório não-controlado (quem pode fondar o
		quê, sob qual licença, com qual absorção de risco) — exatamente o tipo de resposta
		inventada que o probe (pf-scf-1) e a disciplina de fronteira mandam evitar. Custo
		evitado: inventar o regime de fonte + a semântica do guard por modo antes de haver
		um modo real, arriscando guides/gates mal-calibrados (mesma lógica de def-029/def-035).
		Custo de continuar: o canal de disbursement existe (escopo mínimo, adr-137) mas o
		regime de fonte fica em aberto — mitigado por o canal estar modelado e a pendência
		rastreada aqui; nenhum disbursement real ocorre antes do regime existir.
		"""

	triggerCalibrationRationale: """
		Trigger manual-review (não há proxy machine-evaluable): o gatilho é um evento de
		negócio/ops — o primeiro parceiro de funding real OU a autorização BC encaminhada
		para capital próprio. Nenhum estado de arquivo no repo detecta "surgiu um parceiro"
		ou "o BC autorizou"; é decisão que só o founder revisita quando uma das condições
		se concretizar. Por isso manual-only é apropriado aqui (não preguiça): automatizar
		exigiria um sinal que o sistema não tem. Quando o trigger disparar, a resolução
		materializa o regime de fonte + a semântica do guard por modo (provável adr próprio).
		"""

	originatingArtifacts: [
		"architecture/agent-probes/records/scf.cue",
		"architecture/adrs/adr-137-scf-fce-disbursement-channel.cue",
		"contexts/scf/canvas.cue",
		"contexts/fce/canvas.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			O canal de execução existe (escopo mínimo, adr-137), mas implementar o
			disbursement real sem o regime de fonte definido arriscaria inventar a resposta
			(quem fonda, sob qual risco, como o guard reage). medium porque nenhum
			disbursement real ocorre antes do regime existir (a pendência não bloqueia o
			que já está modelado); cross-cutting porque o regime toca SCF (originação),
			FCE (guard/execução) e a governança de capital (licença SCD / parceiros).
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: """
			Gatilho é evento de negócio/ops não machine-evaluable — primeiro parceiro de
			funding real OU autorização BC encaminhada para capital próprio. Só o founder
			revisita quando uma das condições se concretizar; não há sinal de arquivo que
			o runner possa avaliar.
			"""
	}]
}
