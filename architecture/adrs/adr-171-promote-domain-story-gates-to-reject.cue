package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr171: artifact_schemas.#ADR & {
	id:    "adr-171"
	title: "Catraca: promover a reject os 8 gates de domain story (sc-ds-01..08) junto da 1ª story real"
	date:  "2026-07-08"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "high"
	blastRadius:   "cross-cutting"

	context: """
		adr-170 criou os 8 gates referenciais das domain stories born-warn per
		adr-097, com a promoção explicitamente deferida para 'junto da 1ª story
		real'. A 1ª story existe agora: ds-buyer-procurement-journey (jornada de
		compras do comprador da construtora, fonte real per tq-dsg-03 — entrevistas
		+ vídeos de referência), materializada no mesmo commit-arc desta decisão.
		Condição de catraca verificada no ato: o runner avaliou os 8 gates contra
		a instância real e o baseline permaneceu 31/0 — TODAS as refs preenchidas
		da story resolvem no domain-model do BC do próprio passo (sc-ds-04/05/07/08
		exercitados com refs reais em ssc/npm/p2p; sc-ds-01/02/03 com atores/BCs/
		subdomínio reais). Único gate vacuamente verde: sc-ds-06 (policyRefs — a
		story não preenche nenhum), cujo evaluator é o mesmo kind provado por
		fixture determinística no self-test (adr-169).
		"""

	decision: """
		Promover enforcement de warn para reject nos 8 checks sc-ds-01..08 em
		architecture/structural-checks/domain-story.cue, no mesmo commit-arc que
		materializa a 1ª instância. A partir daqui: (1) story nova com ref
		quebrada (ator, BC, subdomínio ou building block inexistente no BC do
		passo) BLOQUEIA o CI; (2) evolução de domain-model que renomeie/remova
		elemento referenciado por story committada BLOQUEIA o CI — o gate passa a
		proteger a cobertura nas duas direções (story→modelo e modelo→story), que
		é o valor de teste de cobertura declarado no adr-170. sc-ds-06 promove
		junto, vacuamente verde e declarado: manter 1 gate da família em warn
		criaria assimetria de enforcement sem ganho (o kind é o mesmo, provado em
		fixture), e a catraca cobre a família inteira quando a família está verde.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) algum sc-ds-* rejeitar ref legítima que EXISTE no domain-model do BC do passo (falso positivo do gate em reject — agora bloqueante); OU (b) o gate bidirecional travar evolução legítima de domain-model com frequência tal que o custo de coordenação story↔modelo supere o valor de cobertura (sinal de promoção prematura com 1 instância)."
		observableSignal: "(a) é observável em qualquer falha de CI sc-ds-*: ref presente no modelo do BC + violação reportada = bug do gate, tratado como bug (não como catraca correta); o self-test do runner é a prova de regressão. (b) é observável na razão entre PRs de domain-model bloqueados por sc-ds vs stories protegidas — se recorrente antes da 2ª story existir, reavaliar via ADR (reversão é 1 linha por check, per precedente adr-114/123)."
	}

	consequences: """
		Positivas: as refs da 1ª story ficam protegidas contra drift do modelo
		(renomear cmd-open-rfq sem atualizar a story vira CI vermelho — cobertura
		deixa de ser alegação e vira invariante); stories futuras nascem sob gate
		pleno; o ciclo story-acha-lacuna → fatia-constrói → story-re-testa passa
		a ter a etapa de re-teste bloqueante, não advisory.

		Negativas/custos: evolução de domain-model nos BCs referenciados (ssc,
		npm, p2p) ganha um acoplamento novo — mudanças em elementos referenciados
		exigem atualizar a story no mesmo commit; com 1 instância o custo é
		baixo, mas cresce com o corpus de stories (falsificationCondition (b)
		vigia a razão custo/valor).
		"""

	affectedArtifacts: [
		"architecture/structural-checks/domain-story.cue",
	]

	principlesApplied: [
		"adr-097 — a catraca: born-warn promove a reject quando verde sobre instância real; esta é exatamente a condição verificada (31/0 com a story no disco).",
		"P10 — o gate promovido continua determinístico (mesmo evaluator, mesma fixture); a promoção muda enforcement, não mecanismo.",
		"adr-170 — executa a decisão deferida ali ('promoção junto da 1ª story real'); a 1ª instância e a promoção entram no mesmo arc.",
		"adr-169 — o kind item-scoped passa a morder com bloqueio: o falso-verde cross-BC morto em warn agora morre em reject.",
	]

	supersedes: []

	rationale: """
		Promover agora — e a família inteira — porque a condição da catraca foi
		verificada no ato (gates verdes sobre instância real com refs exercitadas
		em 7 dos 8) e porque o valor central da story como teste de cobertura só
		existe com gate bloqueante nas duas direções: em warn, o drift
		modelo→story passaria silencioso no CI, exatamente o silêncio que o
		instrumento existe para matar. A alternativa de promover só os 7
		exercitados foi rejeitada: assimetria dentro da mesma família/kind sem
		caso de falso-positivo que a justifique.
		"""
}
