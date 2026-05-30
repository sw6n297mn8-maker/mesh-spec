package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten013: artifact_schemas.#TensionEntry & {
	id:    "ten-013"
	date:  "2026-05-29"
	title: "Definition do subdomínio FCE usa 'budget allocation', imprecisa vs fronteira BDG-compromete/FCE-realiza"

	kind:          "cross-artifact-friction"
	tensionTarget: "strategic/subdomains/fce.cue"
	manifestsIn:   "contexts/fce/canvas.cue"

	description: """
		A definition do subdomínio FCE (strategic/subdomains/fce.cue:11)
		lista "budget allocation" entre as responsabilidades do FCE. A
		derivação do BC (adr-127, decisão Opção B) estabeleceu fronteira
		oposta: o FCE NÃO aloca orçamento — ele REALIZA o envelope aprovado
		pelo BDG via Payment.commitmentRef → BudgetApproved (committed→
		realizado). A alocação estratégica entre centros de custo é decisão
		externa (bdg bd-allocation-not-treasury) e o comprometimento
		prospectivo é do BDG (bd-commitment-not-payment).

		O canvas FCE materializa a fronteira correta em
		bd-realizes-not-allocates-budget e bd-execution-not-treasury. A
		friction é entre dois artefatos: a definition do subdomain (wording
		"budget allocation", anterior à clarificação de fronteira BDG/FCE) e o
		canvas (que afirma explicitamente que o FCE realiza, não aloca). Um
		leitor do subdomain isolado poderia inferir que o FCE aloca orçamento,
		contradizendo a fronteira derivada.

		Não é axiom-tension (nenhuma divergência de axioma) nem
		schema-limitation (o schema #Subdomain expressa bem o que se precisa);
		é friction de vocabulário entre subdomain e canvas, ambos
		individualmente coerentes em sua própria perspectiva.
		"""

	resolution: """
		Resolvido neste PR (polish-canvas-pg-drifts): wording corrigido em
		strategic/subdomains/fce.cue:11 de "budget allocation" para "budget
		realization", alinhando a definition com bd-realizes-not-allocates-budget
		do canvas FCE (adr-127, Opção B — FCE realiza o envelope BDG-aprovado,
		não aloca). manifestsIn (contexts/fce/canvas.cue) e relatedADR (adr-127)
		inalterados.

		Histórico do deferimento (scaffold FCE) — trade-off aceito à época:
		Trade-off aceito: NÃO editar strategic/subdomains/fce.cue durante o
		scaffold do FCE.

		Alternativa escolhida: documentar a fronteira correta no canvas
		(bd-realizes-not-allocates-budget) e no ADR de derivação (adr-127), e
		corrigir o wording "budget allocation" da definition do subdomain em
		PR separado e pequeno após o merge do scaffold.

		Alternativa rejeitada: corrigir a definition do subdomain neste mesmo
		PR. Rejeitada para evitar scope creep — editar artefato estratégico
		(subdomain) dentro do PR de scaffold misturaria duas mudanças de
		classe semântica distinta e ampliaria o blast radius da revisão.

		Ganho de não editar agora: o PR de scaffold permanece focado em
		canvas + ADRs + reconciliação de context-map; a correção do subdomain
		é mecânica e isolável. Mantém integridade referencial (canvas + adr-127
		+ esta tensão no mesmo PR).

		Perda aceita: a definition do subdomain carrega wording impreciso
		("budget allocation") até o PR de correção. A imprecisão é localizada e
		textualmente recuperável — o canvas e adr-127 documentam a fronteira
		canônica (FCE realiza, não aloca); apenas a leitura do subdomain em
		isolamento é exposta.
		"""

	status: "resolved"

	structuralResolutionPath: "strategic/subdomains/fce.cue"

	relatedADR: "adr-127"

	rationale: """
		Registro feito no mesmo PR que a derivação (adr-127) que expôs a
		imprecisão, preservando integridade referencial: adr-127 referencia
		ten-013 e ten-013 referencia adr-127. A separação entre o ADR (que
		governa a derivação de fronteira) e a tensão (que registra a
		imprecisão de wording do subdomain) é deliberada — misturá-las
		confundiria leitores futuros sobre se o problema era a derivação ou o
		texto do subdomain.

		kind=cross-artifact-friction (não axiom-tension nem schema-limitation):
		o atrito é entre dois artefatos de spec, não com um axioma nem com uma
		limitação de schema. A resolução estrutural é trivial (editar o wording
		da definition) e fica em structuralResolutionPath; o status permanece
		open até este PR (polish-canvas-pg-drifts), que aplicou a resolução estrutural; o status passou a resolved.
		"""
}
