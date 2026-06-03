package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr142: artifact_schemas.#ADR & {
	id:    "adr-142"
	title: "Aceite bilateral do CMT: contrato e integridade criptográfica de termos"

	date: "2026-06-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		O CMT é o ponto de formalização do commitment lifecycle, e a businessDecision
		bd-mutual-acceptance ("aceite mútuo bilateral é invariante inviolável") é seu núcleo.
		Até aqui, porém, o invariante inv-mutual-bilateral-acceptance vivia apenas em prosa —
		"ambas as partes sobre termos idênticos" — SEM mecanismo verificável: o tipo
		AcceptanceConfirmation, referenciado por ConfirmCommitmentAcceptance, não tinha shape
		canônica em CUE (só uma shape provisória {acceptedAt, acceptedBy} marcada TODO no
		api.yaml, que NÃO carregava os termos), de modo que "termos idênticos" não era
		computável. O structural-check sc-cmt-01 já assertava termsRef coherence entre proposer
		e counterparty, mas sem o contrato que o sustentasse.

		O probe isolado do CMT (Ciclo 4, adr-134), registrado em
		architecture/agent-probes/records/cmt.cue (PR #108), surfou pf-cmt-1 (high) — a
		semântica "ambas as partes" ambígua — como achado prioritário, justamente porque o
		golden-example bd-mutual-acceptance (pré-requisito do walking skeleton de adr-138 e do
		adr-140 codegen a autorar) gera o guard desse invariante a partir do CUE (P1: CUE é SoT,
		código é gerado). Sem predicado verificável, o golden-example "passaria" gerando um guard
		que não implementa a metade "termos idênticos" — exatamente o risco que ele deveria
		expor. Análise estática complementar surfou SA-1 (AcceptanceConfirmation sem shape), SA-2
		(CommitmentScope inline) e SA-3 (catálogo de eventos incompleto: 11 definidos vs 10 wired).

		A decisão da campanha foi corrigir completamente; este ADR materializa a Fatia A+C
		(contrato + integridade + fail-closed + housekeeping), deixando a Fatia B (orquestração
		de disputa) para sessão própria. A separação não é estética: a Fatia B exige decisões
		cross-BC com upstream inexistente (DRC sem domain-model), portanto carrega scaffold de
		DRC ou ACL local no CMT como pré-requisito próprio — qualquer dos caminhos amplia o
		escopo além do que o golden-example pede agora.

		Alternativas avaliadas:
		(a) verificação de "termos idênticos" — [escolhida] hash criptográfico de {termsRef,
		    scope}; comparação campo-a-campo no gate — rejeitada: exige a contraparte reenviar
		    todos os termos, acopla o gate à estrutura interna deles e não produz evidência
		    compacta auditável para mech-evidence; confiar só no commitmentId — rejeitada: não
		    prova QUAIS termos a contraparte viu/aceitou, reabrindo o vetor "aceitei outra coisa"
		    e falhando dp-10.
		(b) semântica bilateral — [escolhida] proponente implícito; exigir confirmação explícita
		    também do proponente (dois comandos) — rejeitada: round-trip e comando extra sem
		    ganho de integridade (o proponente já autorou os termos no ProposeCommitment),
		    piorando commitment-formalization-time.
		(c) CTR indisponível — [escolhida] fail-closed em propose-time; fail-open com snapshot
		    stale — rejeitada: cria compromisso sem lastro, violando bd-terms-validation e dp-10;
		    enfileirar/retry async — rejeitada no walking skeleton: complica o gate sem ganho para
		    validar o pipeline spec→código; deferida: pode ser revisitada se telemetria de
		    produção mostrar que fail-closed gera fricção excessiva — não vira def separado agora
		    porque def-046 (SLA numérico) é o checkpoint natural.
		(d) idempotência — [escolhida] no-op; rejeitar como erro — rejeitada: viola P6; retries de
		    rede legítimos virariam erro espúrio.
		(e) zero-drift — [escolhida] atualizar sc-cmt-01/02 na mesma Fatia; deferir o alinhamento
		    do check — rejeitada: drift observável invariante↔check viola P0.
		(f) publicação no aceite — [escolhida] só CommitmentAccepted; publicar ambos — rejeitada:
		    duplicação semântica; DRC/TCM receberiam dois sinais para o mesmo fato.
		"""

	decision: """
		(1) ESCOPO Fatia A+C. Materializar agora o contrato de aceite bilateral, sua integridade
		    criptográfica, a resiliência CTR e o housekeeping correlato (pf-cmt-1, pf-cmt-2,
		    pf-cmt-3, pf-cmt-5, SA-1/2/3). A orquestração de disputa (pf-cmt-4/6/7) fica FORA, na
		    Fatia B, por ser cross-BC com o DRC (hoje canvas-only). pf-cmt-8 (oq-cmt-1) permanece
		    deferred-by-design; pf-cmt-9/10 são already-specified.

		(2) ACEITE BILATERAL ASSIMÉTRICO. O aceite materializa-se como duas confirmações: o
		    proponente confirma IMPLICITAMENTE ao emitir ProposeCommitment (ato que fixa os termos
		    e gera o termsHash de referência); a contraparte confirma EXPLICITAMENTE via
		    ConfirmCommitmentAcceptance. Não há segundo comando de confirmação do proponente.

		(3) AcceptanceConfirmation COM INTEGRIDADE CRIPTOGRÁFICA + ZERO-DRIFT. Criar o contrato
		    canônico em CUE — value object no domain-model.cue + #AcceptanceConfirmation em
		    events.cue — com campos {commitmentId, confirmedBy, confirmedAt, termsHash},
		    substituindo a shape provisória TODO do api.yaml. termsHash = sha256 hex da
		    serialização canônica (JCS/RFC 8785) de {contractTermsRef, scope}; EXCLUI parties
		    deliberadamente: o hash mede identidade dos termos econômicos, não quem está
		    acordando — assim, dois compromissos com partes distintas mas mesmos termos produzem o
		    mesmo hash, permitindo comparação cruzada que parties-no-hash impediria. O predicado
		    "termos idênticos" = AcceptanceConfirmation.termsHash == termsHash fixado no
		    ProposeCommitment. Reescrever inv-mutual-bilateral-acceptance para esse predicado E
		    atualizar sc-cmt-01 (cmt-domain-model.cue) na mesma Fatia — zero-drift
		    invariante↔structural-check. Como parte da canonicalização: promover CommitmentScope a
		    value object (SA-2) e completar emitsEvents com evt-contract-terms-cancelled-received
		    como informativo (SA-3, 11/11).

		(4) CommitmentAccepted: PUBLICAÇÃO ÚNICA + EVIDÊNCIA ADITIVA. A transição
		    proposed→accepted publica SOMENTE CommitmentAccepted (não CommitmentStateChanged, que
		    cobre as demais transições) — elimina a sobreposição pf-cmt-2. O payload publicado
		    ganha termsHash + confirmedBy (ADITIVO, backward-compatible; consumidores BDG/DLV/INV
		    atuais não quebram), fortalecendo a cadeia mech-evidence.

		(5) VALIDAÇÃO CTR EM PROPOSE-TIME, FAIL-CLOSED. Os termos são validados sync via
		    QueryContractTerms no ProposeCommitment; se o CTR não responde, ProposeCommitment é
		    REJEITADO (sem lastro verificável → sem compromisso). sc-cmt-02 é ajustado de
		    acceptance-time para propose-time. O SLA numérico (limite para "indisponível") é
		    deferido a def-046, pendente de telemetria de produção.

		(6) IDEMPOTÊNCIA NO-OP. ConfirmCommitmentAcceptance repetido sobre compromisso já accepted
		    é no-op idempotente (P6): retorna o CommitmentAccepted existente — não erro, não
		    segundo evento.
		"""

	consequences: """
		Positivas:
		(P1) o golden-example bd-mutual-acceptance passa a gerar um guard que implementa de fato a
		     metade "termos idênticos" (igualdade de hash) — o walking skeleton (adr-138/adr-140)
		     valida o pipeline spec→código sobre um invariante REAL, não um placeholder.
		(P2) inv-mutual-bilateral-acceptance ganha predicado verificável e determinístico
		     (sha256), fechando pf-cmt-1 (high) e o gap invariante↔sc-cmt-01.
		(P3) termsHash + confirmedBy entram na cadeia mech-evidence (P11) — "quais termos a
		     contraparte aceitou" torna-se criptograficamente reconstituível (reforça dp-10; eleva
		     custo de manipulação dp-08: forjar aceite exige forjar hash).
		(P4) fail-closed em propose-time elimina a classe de compromissos sem lastro contratual
		     verificável (pf-cmt-3); comportamento sob indisponibilidade do CTR deixa de ser
		     indefinido.
		(P5) idempotência no-op (P6) torna ConfirmCommitmentAcceptance seguro sob retry
		     at-least-once, sem erros espúrios.
		(P6) contratos do CMT ficam canônicos em CUE (AcceptanceConfirmation, CommitmentScope);
		     api.yaml larga a shape provisória TODO; catálogo de eventos consistente (11/11).

		Negativas / limitações:
		(N1) CommitmentAccepted muda de contrato publicado (aditivo, backward-compatible) — mas é
		     mudança de baixa reversibilidade que vincula consumidores BDG/DLV/INV ao novo shape;
		     reverter depois exige coordenação cross-BC.
		(N2) o hash exige canonicalização determinística (JCS/RFC 8785) acordada entre produtor
		     (ProposeCommitment) e verificador (gate); divergência de serialização gera
		     falso-negativo de "termos idênticos" — dívida de implementação que o runtime honra
		     (não resolvida aqui).
		(N3) fail-closed acopla a disponibilidade do ProposeCommitment à do CTR; sem o SLA numérico
		     (deferido a def-046), o limite operacional fica indefinido — risco de fricção até
		     calibração.
		(N4) a Fatia B (pf-cmt-4/6/7) fica explicitamente aberta — orquestração de disputa
		     não-canonizada até sessão própria; custo registrado, não eliminado.
		(N5) atualizar sc-cmt-01/02 junto amplia o blast da Fatia para o structural-check (+ SRR
		     refresh), aumentando a superfície de revisão deste PR.
		"""

	reversibility: "low"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Esta decisão estará errada SE o hash de {contractTermsRef, scope} for insuficiente
			para "termos idênticos" — i.e., se um termo economicamente material ficar FORA de
			contractTermsRef+scope (em parties ou em campo não-hasheado), de modo que dois aceites
			com o mesmo termsHash divirjam em termo material.
			"""
		observableSignal: """
			Disputa em DRC (ou alerta REW) sobre compromisso accepted cujo termsHash bateu mas
			cujas partes divergem sobre o acordado — commitment-dispute-rate acima do target (<5%)
			com causa-raiz "termo material fora do hash".
			"""
	}

	affectedArtifacts: [
		"contexts/cmt/domain-model.cue",
		"contexts/cmt/canvas.cue",
		"contexts/cmt/schemas/events.cue",
		"contexts/cmt/api.yaml",
		"architecture/structural-checks/cmt-domain-model.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-046-ctr-availability-sla.cue",
	]

	defersTo: ["def-046"]

	principlesApplied: ["P0", "P1", "P6", "P7", "P10", "P11", "dp-08", "dp-10"]

	supersedes: []

	rationale: """
		A opção é ditada pelo keystone P1: se o golden-example deve provar CUE→código, o
		invariante central precisa de predicado COMPUTÁVEL — daí o hash, e não comparação
		campo-a-campo (acopla o gate à estrutura dos termos) nem confiança no commitmentId (não
		prova quais termos foram vistos). O termsHash não é só verificação: é evidência
		criptográfica alinhada a P11 (cadeia tamper-evident), o que justifica carregá-lo no
		payload publicado de CommitmentAccepted (decisão 4). parties fica fora do hash porque o
		hash mede identidade dos termos econômicos, não das partes — dois compromissos com partes
		distintas e mesmos termos produzem o mesmo hash, habilitando comparação cruzada. Atualizar
		sc-cmt-01/02 na mesma Fatia é exigência de P0 (localização canônica única): invariante e
		structural-check são duas representações da mesma regra e não podem divergir. P6 torna o
		no-op idempotente o default obrigatório. P7: AcceptanceConfirmation e CommitmentScope são
		value classes que cruzam a fronteira do contrato — coerente com a direção dos Port
		contracts do (futuro) adr-141, sem depender dele. P10: a transição para accepted é gate
		determinístico (ProposeCommitment + termsHash válido → ConfirmCommitmentAcceptance com
		mesmo hash → CommitmentAccepted); o agente recomenda, o gate valida. dp-08/dp-10
		fundamentam a integridade: forjar aceite exige forjar hash, e a prova ancora
		responsabilidade jurídica.

		Sobre risco: o par reversibility=low + blastRadius=cross-cutting dispara o alerta de
		decisão irreversível com blast alto — esperado, pois CommitmentAccepted é contrato
		publicado. A escalação exigida pelo reversibilityThreshold do CLAUDE.md está SATISFEITA
		pela aprovação explícita das 6 decisões + 4 sub-decisões pelo founder antes desta autoria.

		Tensão com axiomas: nenhuma. Fail-closed prioriza lastro contratual (dp-10, constraint
		inviolável) sobre velocidade — e constraints invioláveis estão acima de velocidade na
		ordem de precedência, logo não é tensão a registrar.

		Linhagem: surfado pelo probe de adr-134 (record em PR #108); desbloqueia o golden-example
		de adr-138; adr-142 é pré-requisito de adr-140 (golden-example codegen a autorar —
		inversão id↔dependência intencional). adr-141 (kernel/Ports do adr-139) é trabalho
		adjacente que formaliza P7 no nível do runtime, não dependência deste ADR. adr-139 (stack)
		é contexto adjacente.
		"""
}
