package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr131: artifact_schemas.#ADR & {
	id:    "adr-131"
	title: "Derivação do bounded context SCF (Supply Chain Finance) — terceira aplicação de P13"
	date:  "2026-05-30"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Terceira aplicação de P13 (architecture/design-principles.cue, adr-125),
		após FCE (adr-127, core, section-by-section) e DRC (adr-129, supporting,
		batch). SCF é a segunda derivação em section-by-section — escolha
		justificada por pre-flight scoring (3 sinais section-by-section / 1 batch:
		6 arestas borderline + 1 divergência de naming + 4 forward-refs), com
		risco concentrado na section communication (reconciliação rew-to-scf +
		forward-refs + fronteira externa).

		A derivação aplica o protocolo da section boundary-derivation do PG de
		canvas (adr-125 decision item 2). O resultado NÃO materializa campo no
		canvas (schema #Canvas é struct fechada — Opção i); a derivação vive
		canonicamente neste ADR e alimenta a section communication.

		Alternativas consideradas e rejeitadas:

		(a) Merge do SCF em CMT/INV/REW/FCE (não criar BC dedicado; lógica de
		    produto financeiro como parte dos BCs que o viabilizam). REJEITADA: o
		    SCF passa nos 3 testes de separação — sua linguagem de produto
		    financeiro (antecipação, reverse factoring, dynamic discounting,
		    elegibilidade de carteira, securitização) é disjunta de materialização
		    (INV), risco (REW), execução (FCE), lifecycle (CMT), termos (CTR) e
		    cobertura (INS), per os 7 negativeBoundaries do subdomain. O próprio
		    subdomain articula o anti-padrão: "sem SCF, a lógica de produto
		    financeiro e de elegibilidade ficaria distribuída entre CMT+DLV+INV,
		    REW e FCE sem owner canônico" (scf.cue:36-39).

		(b) ADR próprio para a invariante bd-advance-requires-verified-receivable
		    (como o FCE teve adr-128 para P11). REJEITADA: diferente do P11
		    (princípio cross-cutting), "antecipação requer recebível verificado" é
		    INSTÂNCIA de P11/mech-evidence já existente — não princípio novo. SCF
		    consome o lastro verificado ancorado por INV/DLV; não origina uma
		    invariante de princípio. Mesma decisão do DRC (sem 2º ADR).
		"""

	decision: """
		Derivar o SCF como bounded context SUPPORTING dedicado, materializando
		contexts/scf/canvas.cue (9 sections do PG canvas, section-by-section).

		(1) Três testes de separação — todos PASSED:
		    (a) Linguagem ubíqua distinta: antecipação de recebíveis, reverse
		        factoring, dynamic discounting, capital de giro, preparação de
		        portfólio para securitização (FIDC), originação de produto
		        financeiro, elegibilidade de carteira.
		    (b) Invariante própria que só ele garante: a composição multi-fonte
		        de elegibilidade (combina lastro INV + risco REW + termos CTR +
		        cobertura INS numa decisão de produto que nenhum BC isolado
		        detém — bd-eligibility-multi-source-composition) + a invariante de
		        honestidade "estruturação não garante funding nem securitização"
		        (scf.cue:22-23).
		    (c) Ownership canônico: estado da operação de antecipação
		        (AdvanceOperation) + os fatos ReceivableAdvanceOriginated/
		        ReceivableAdvanceSettled (consumidos por ATO) + os critérios de
		        elegibilidade de carteira.

		(2) Teste de remoção — PASSED: remover o SCF para a OFERTA DE PRODUTO por
		    perda de função, não por acoplamento. Discriminante: INV/REW/FCE
		    continuam funcionando (materializam recebível, precificam risco,
		    executam pagamento) — só perdem o consumidor downstream que converte
		    recebível verificado em produto ativável. Fronteira artificial faria
		    INV/REW/FCE pararem; eles operam sem SCF (recebível existe mas não é
		    antecipado). O que morre é a ativação de volume em produto (dp-02).

		(3) Classificação das 6 arestas cross-BC (ordem de preferência P13):
		    TODAS Tier 1 unidirecionais acíclicas — SCF é folha downstream do
		    grafo financeiro (consome 5 upstreams, publica para 1):
		    - inv-to-scf: OHS/ACL (ReceivableMaterialized, lastro).
		    - rew-to-scf: OHS-PL/ACL (RiskScoreEmitted/EligibilityEmitted +
		      queries; reconciliado naming+shape em adr-130).
		    - fce-to-scf: OHS/ACL hybrid (PaymentSettled + QueryPaymentSettlementStatus).
		    - ctr-to-scf: OHS-PL/ACL hybrid (termos + QueryContractTerms).
		    - ins-to-scf: OHS/ACL (Coverage*/ClaimFiled; INS forward-ref).
		    - scf-to-ato: OHS/conformist (ReceivableAdvance*; ATO forward-ref).
		    Nenhum kind; nenhum ciclo (0 ciclos — sc-cm-07 inalterado).

		(4) Decisões de escopo: businessRole revenue-generator (primeiro BC
		    revenue surface da Mesh — captura o spread da ativação, dp-02;
		    ortogonal a supporting: produto commodity + moat upstream + SCF revenue
		    surface); archetype specification primary (SCF especifica produto, FCE
		    executa); costsEliminated ce-06+ce-07 (encaixe DIRETO, não espelho:
		    ce-07 bearer=sh-03 descreve literalmente a capability cc-05);
		    ext-securitization-admin como openQuestion (oq-scf-1, fronteira externa
		    declarada no subdomain mas não modelada no context-map — pattern
		    uniforme via precedente ins-to-ext-insurers, WI futuro).

		Naming/shape de rew-to-scf reconciliado em adr-130 (mesmo PR). Sem ADR de
		invariante (P11 instância).
		"""

	consequences: """
		Positivas:
		(P1) A fronteira do SCF é auditável e P13-derivada. Terceira aplicação de
		P13 valida o protocolo num BC revenue-generator (primeiro da Mesh) e
		exercita a ortogonalidade subdomainType↔businessRole (supporting que gera
		receita).
		(P2) As 6 arestas ficam classificadas; todas Tier 1 unidirecionais — SCF é
		folha downstream acíclica, 0 ciclos (sc-cm-07 inalterado, catraca
		adr-097/123 verde).
		(P3) A coerência econômica fica explícita: produto commodity + moat
		upstream (lastro mech-evidence + pricing mech-network) + SCF revenue
		surface; o spread comprime porque o lastro é verificável, não porque o
		produto é único.

		Negativas:
		(N1) Forward-refs conscientes pendentes (openQuestions do canvas): ext-
		securitization-admin edge (oq-scf-1), canvas INS (oq-scf-2), canvas ATO
		(oq-scf-3), glossary (oq-scf-4), agent-spec + api-specs (oq-scf-5).
		(N2) A fronteira externa scf→ext-securitization-admin é declarada no
		subdomain mas não modelada no context-map — openQuestion (não one-off
		ad-hoc; aguarda pattern uniforme de external-system, precedente
		ins-to-ext-insurers).
		(N3) REW é fonte recorrente de naming reconciliation (rew-to-fce em
		adr-126, rew-to-scf em adr-130) — candidato a PR de varredura rew-* futuro
		(registrado em adr-130, não acionado).

		Fronteira regulatória: a preparação de carteira para securitização toca a
		fronteira CVM (FIDC), enforçada por bd-prepares-portfolio-not-administers-
		fund (SCF prepara, não administra; constraint nível 1). Este ADR é a
		derivação de fronteira (método de design), não uma decisão operacional
		sobre um produto concreto.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	affectedArtifacts: []

	plannedOutputs: [
		"contexts/scf/canvas.cue",
	]

	principlesApplied: ["P13", "P11", "P10", "P0"]

	supersedes: []

	rationale: """
		P13 aplicado integralmente: 3 testes de separação + teste de remoção +
		classificação obrigatória de toda relação cross-BC + ônus invertido sobre
		ciclos (0 ciclos — SCF é folha downstream, nenhuma aresta reversa). A
		decisão de fronteira não-trivial (criação de BC) exige este ADR per P13.

		P0 (uma localização canônica): a derivação vive só aqui (não vira campo do
		canvas — Opção i); a classificação das relações vive no context-map; o
		canvas referencia, não duplica.

		P11/P10: a invariante crítica (advance-requires-verified-receivable) é
		instância de P11 ancorada por INV/DLV (não princípio novo — sem 2º ADR); a
		governança intermediária (originação determinística autônoma, override/
		securitização/funding supervised) materializa P10 (autonomia onde
		determinístico, supervisão onde julgamento).

		businessRole revenue-generator (primeiro da Mesh): a ortogonalidade com
		supporting é a estrutura econômica da tese — produto commodity (supporting,
		o produto não é o moat) + moat upstream (lastro DLV/INV + pricing REW) +
		SCF como revenue surface (captura o spread, dp-02). O spread comprime vs
		mercado porque o lastro é VERIFICÁVEL, não porque o produto é único;
		bd-structuring-not-funding-guarantee cristaliza a distinção (receita do
		produto vs funding de balanço).

		Ancoragem: generaliza adr-065 (teste de remoção) e adr-085
		(decisionAuthorityModel). SCF demonstra que P13 cobre BC folha downstream
		acíclico (todas Tier 1) tão bem quanto o ciclo (DRC) ou o hub constrangido
		(FCE).

		Tensão com axiomas: nenhuma. dp-02 (volume sob governança + ativação)
		confirmado: SCF é o ponto de ativação do volume em receita, o que a tese
		persegue como proxy do custo de transação reduzido.
		"""
}
