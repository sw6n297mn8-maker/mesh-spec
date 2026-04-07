package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

cmtSubdomain: build_time.#SelfReviewReport & {
	reportId: "srr-subdomain-cmt"

	artifactPath:       "strategic/subdomains/cmt.cue"
	artifactSchemaPath: "architecture/artifact-schemas/subdomain.cue"
	artifactType:       "subdomain"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-04-07"

	roundsExecuted: 3
	maxRounds:      4
	status:         "stable"

	roundDetails: [{
		round:     1
		failCount: 4
		warnCount: 1
		infoCount: 0
		summary: """
			Round 1 avaliou CMT contra 8 critérios universais e 7 type-specific.
			Findings: (1) fail — costRefs ce-01 incorreto: ce-01 é custo de
			verificação de execução (DLV), não de formalização. (2) fail —
			capabilityRefs cc-01 incorreto: cc-01 é liberação financeira
			vinculada a evidência (DLV/FCE), não formalização. (3) fail —
			falta negativeBoundary para REW. (4) fail — falta negativeBoundary
			para DRC. (5) warn — mech-evidence rationale impreciso sobre qual
			aspecto se aplica a CMT. Lenses aplicadas: theory-of-firm,
			domain-language, supply-chain-theory, information-economics,
			mechanism-design. 4 rounds de red team executados.
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Correções aplicadas: ce-01 → ce-02, cc-01 → cc-04,
			negativeBoundaries para REW e DRC adicionados, rationale de
			mech-evidence ajustado para explicitar que CMT registra aceite
			bilateral como fato com integridade criptográfica. Verificação
			de regressão: demais critérios continuam passando. Zero findings.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 3 (adr-043 Fase 1 backfill — primeiro cross-plane test
			deliberado do piloto): adicionado campo verticalApplicability
			ao subdomain CMT. Classificação: vertical-agnostic.

			Análise estrutural: definition, purpose, negativeBoundaries
			(8 delegações para subdomains pares: CTR, DLV, INV, FCE, BDG,
			REW, DRC, P2P), mechanismRefs, costRefs, capabilityRefs e
			rationale são todos definidos em vocabulário canônico do
			domain-definition, sem invocar vocabulário ou premissa
			setorial. Zero menção a stakeholders construção (subdomain
			não tem stakeholders field).

			Único trecho com material relacionado a vertical:
			strategicProfile.rationale menciona "regras de formalização
			que variam por vertical (construção vs logística vs energia)"
			como descrição meta do landscape cross-vertical, e "medição
			por milestone, aceite parcial, entregas programadas" como
			exemplos de tipos de compromisso que industry packs absorvem.

			Smoking gun para agnostic: a frase "cada industry pack expande
			tipos de compromisso e padrões de formalização" declara
			explicitamente que a estratégia de variação é via extensão
			externa por industry packs, não via embedding no núcleo. O
			frame "industry pack expande" desqualifica a menção a
			"medição por milestone" como anchoring — é exemplo de
			extensão, não premissa embebida.

			Calibração da heurística de ten-007: o caso confirma a versão
			estrita do critério — "pontos de variação concretos" devem
			estar embutidos em fields estruturais (definition, purpose,
			negativeBoundaries), não em rationale meta-descritivo. Visão
			ampla (qualquer menção conta como variation point) seria
			permissiva demais e tornaria adaptable a categoria default,
			perdendo poder discriminativo.

			Cross-plane finding (primeira observação do piloto): este é
			o primeiro par subdomain/canvas do mesmo BC analisado. cmt-
			canvas (commit 717644f) foi classificado como vertical-
			adaptable/construction com pontos de variação enumerados
			(as-cmt-1, as-cmt-3, oq-cmt-2) e stakeholder primário
			construtora (sh-01). cmt-subdomain é vertical-agnostic com
			núcleo abstrato e variação externalizada para industry packs.

			Estrutura emergente: a variação por vertical aparece no plano
			operacional (canvas), não no plano de fronteira estratégica
			(subdomain). Hipótese de pesquisa falsificável para pares
			subsequentes (ctr, idc, npm, p2p — todos os BCs com canvas
			têm subdomain). Massa empírica = 1 par. Não registrado como
			tensão; apenas hipótese de pesquisa para validar/refutar com
			pares adicionais. Critério de promoção a tensão estrutural:
			3+ pares confirmando ou 1+ par contradizendo de forma clara.

			tq-sd-08 pass: campo presente, mode coerente com evidência
			estrutural, rationale explícito sobre por que CMT subdomain
			é universal (núcleo abstrato + variação delegada a industry
			packs) e sobre a divergência cross-plane com cmt-canvas.
			cue vet pass.
			"""
	}]

	findings: {}

	summary: """
		CMT estável no round 2. Round 1 identificou 4 fail (costRef e
		capabilityRef incorretos, 2 negativeBoundaries ausentes) e 1 warn
		(rationale de mech-evidence). Todos corrigidos. Design informado
		por 5 lenses analíticas e 4 rounds de red team.
		"""
}
