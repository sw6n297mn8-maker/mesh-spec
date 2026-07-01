package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def072: artifact_schemas.#DeferredDecision & {
	id:     "def-072"
	title:  "Troca de vendor do EventLogPort por escala horizontal de escrita"
	date:   "2026-07-01"
	status: "open"

	description: """
		adr-165 escolheu Postgres como PRIMEIRO vendor do EventLogPort, com a ordem
		global gap-free servida por um contador transacional único. Fica deferida a
		revisita da escolha de vendor para o cenário em que a escala horizontal de
		escrita colida com esse contador global — o ponto em que FoundationDB (escala
		horizontal nativa via sharding) passa a se justificar. Não é "vendor
		indeciso": o vendor-of-record do regime atual É Postgres (adr-165 resolveu
		def-041); este def rastreia a CONDIÇÃO DE REABERTURA por escala.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a escala que justificaria FoundationDB — throughput
		de escrita que sature um contador global serializado num único Postgres — NÃO
		existe no regime atual (organismo sintético, sem produção, sem carga). Decidir
		o vendor de escala agora seria o lock-in prematuro que P2/real-options mandam
		evitar, pagando curva/opacidade/ops de cluster por capability dormente. Custo
		evitado: operar FoundationDB antes de a escala existir. Custo de continuar
		deferindo: baixo — a troca é cega via Port (P7) + o gate de durabilidade
		(adr-164) garante que o vendor novo prove restart antes de entrar, e a
		ordem-global-latente de adr-165 preserva a opção rica. O que este def impede é
		o esquecimento silencioso da condição de troca.
		"""

	triggerCalibrationRationale: """
		O evento real de revisita — throughput de escrita colidindo com o contador
		global — vive no runtime/produção (métrica de carga), sem sensor honesto no
		runner repo-local do mesh-spec (não há arquivo que "exista" quando a escala
		chega). Por isso manual-review (founder revisita quando a métrica de escala
		aparecer) + temporal 180d como backstop contra limbo — mesmo desenho de
		def-041/def-071. Não forçar file-exists artificial aqui seria proxy-falso.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-165-eventlogport-trajectory-postgres-vendor.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque a troca de vendor é cega via Port (P7) + o gate de durabilidade
			(adr-164), e a ordem-global-latente de adr-165 preserva a opção rica — nada
			bloqueia enquanto a escala não chega. cross-artifact porque o EventLogPort é
			consumido por todos os BCs quando o runtime materializar.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Throughput de escrita colidindo com o contador global único do Postgres (o gap-free serializado vira gargalo) — métrica de carga que vive no runtime/produção, sem sensor honesto no mesh-spec e sem escala hoje. Founder revisita quando a métrica aparecer."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
