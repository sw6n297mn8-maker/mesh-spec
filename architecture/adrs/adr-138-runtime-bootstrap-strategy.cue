package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr138: artifact_schemas.#ADR & {
	id:    "adr-138"
	title: "Estratégia de runtime bootstrap (lado-spec): vertical, core-first, atrás dos Ports, golden-example CMT"

	date: "2026-06-02"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		A spec chegou a 14 canvases + 11 domain-models, mas a hipótese central P1 — "a spec gera
		código que funciona, sem escrita manual" — nunca foi validada. O wave-plan para em W005
		(stack); não há wave de runtime nem golden-example (0). Pergunta: como começar o código
		segundo o DDD?

		Restrição operante de escopo: o código é GERADO (P1) e vive no mesh-runtime — repo
		SEPARADO, subordinado, cadência de agente, FORA do escopo deste repo. Logo mesh-spec não
		executa runtime; só governa a prontidão do lado-spec + o contrato de codegen que o runtime
		consome. Nenhuma decisão aqui modifica o mesh-runtime nem executa deploy.

		Diagnóstico (não acusação): os BCs ainda NÃO têm camada de contratos compiláveis suficiente
		para codegen de runtime (events/commands/schemas + invariants em assertion-schema como
		contratos próprios). Não é pré-requisito completar os 14 BCs — começa-se pelo subconjunto
		mínimo de UM BC.

		Lentes aplicadas (architecture/lenses/): organizational-resource-allocation (o constraint é
		a banda de revisão do founder, não compute; WSJF manda validar o pipeline numa fatia fina
		antes de exploitation); real-options (encenar o build irreversível com gates; testar a
		premissa mais arriscada — o pipeline de codegen — primeiro; stack como hipótese falsificável);
		theory-of-firm (core=build, generic=buy, codegen-toolchain=buy, 3 SoTs=build); developer-and-
		integrator-experience (o "developer" é o agente que gera código; golden-example = quickstart);
		testing-and-validation-for-financial-systems (o golden-example prova testes de invariante
		gerados das assertions). complex-adaptive-systems descartada (meta — lentes-componente bastam);
		distributed-systems-design / eventing governam o substrato (são W005), não o sequenciamento.

		Alternativas rejeitadas: (a) horizontal (todos os events, depois todos os aggregates) — viola
		a organização vertical do repo + atrasa a validação do pipeline; (b) big-bang 14 BCs — nega
		real-options (commit irreversível sem gate); (c) FCE como golden-example inicial — o invariante
		do FCE (PrePaymentGuard / money-on-proof) é cross-BC por construção (REW + DLV + INV + BKR),
		logo o MAIS acoplado, não o teste mais barato do pipeline.
		"""

	decision: """
		(1) SEQUENCIAMENTO — vertical walking skeleton, core-first, atrás dos 5 Ports (P7); não
		    horizontal, não big-bang. Dois eixos ORTOGONAIS: PROFUNDIDADE (modelagem custom funda só
		    nos core — cmt/dlv/fce/rew) × LARGURA (walking skeleton fino atravessa os supporting do
		    caminho — bdg/inv — só no happy-path). Não conflitam: são eixos distintos (profundidade
		    nos core vs largura-fina no caminho).

		(2) GOLDEN-EXAMPLE = CMT, escopo MICROSCÓPICO (não "CMT inteiro"): UM aggregate em torno do
		    aceite bilateral. CMT vence o critério "menor superfície externa para provar
		    spec→contratos→aggregate→invariants→testes executáveis": bd-mutual-acceptance é core,
		    cabeça do spine, auto-contido (testável com dependência cross-BC mínima/zero), e exercita
		    commands + events + estado de aggregate + invariant.
		    INCLUÍDO: os commands/events do aceite bilateral conforme a spec real do CMT
		    (ProposeCommitment + ConfirmCommitmentAcceptance; CommitmentProposed/CommitmentAccepted +
		    a transição para o estado ativo); a transição de estado do aggregate; o invariant (um
		    compromisso só fica ativo após aceite bilateral); os testes gerados do assertion-schema; o
		    contrato do EventLogPort + adapter-stub.
		    EXCLUÍDO: propagação cross-BC para BDG; travessia completa do context-map; runtime de
		    produção; deploy; integrações externas.

		(3) FCE = VALIDAÇÃO TERMINAL do walking skeleton (W006.3), não golden-example — seu valor é
		    justamente provar a COMPOSIÇÃO cross-BC (DLV/INV/REW/BKR/FCE).

		(4) STACK — W006 NÃO entrega a decisão de stack. W006.0 declara DEPENDÊNCIA BLOQUEANTE dos
		    ADRs mínimos de W005 (codegen-toolchain + compute/runtime); W006 consome essas decisões,
		    não as possui. A stack mínima deve ser decidida ANTES do golden-example (senão o
		    experimento fica amorfo), mas é tratada como HIPÓTESE FALSIFICÁVEL: o golden-example CMT é
		    o teste de realidade que valida/pivota/abandona a stack pelos gates de (7).

		(5) BUILD/BUY (theory-of-firm): core=build custom; supporting=build padrão/hybrid; generic
		    (bkr, rails PIX/SPB)=buy + adapter fino atrás de Port; 3 SoTs (Event Log/Ledger/Workflow)=
		    build; codegen-toolchain=buy (tooling CUE estabelecido, não codegen do zero).

		(6) O PIPELINE A PROVAR em W006.2 (estreito — NÃO "runtime em produção"; prova que a spec é
		    fonte suficiente para produzir runtime governável):
		    businessDecision/invariant → assertion formal (assertion-schema) → contratos compiláveis
		    (commands/events/schemas/estado de aggregate) → codegen (tipos + skeleton de aggregate +
		    contratos de Port) → testes gerados/deriváveis das assertions → execução LOCAL do
		    golden-example → evidência de que a stack é adequada ou precisa pivotar.

		(7) GATES do golden-example (real-options — definidos ANTES):
		    CONTINUAR sse: os contratos gerados COMPILAM E os testes de invariante (≥1 caso inválido +
		    ≥1 válido) gerados das assertions PASSAM E o EventLogPort é gerado + usado por adapter-stub
		    SEM depender de runtime real.
		    PIVOTAR (revisar spec/toolchain) se: a spec não tem informação para gerar o aggregate OU
		    invariants não viram testes executáveis sem preenchimento manual.
		    ABANDONAR/RE-ESCOLHER toolchain se: o output gerado exige EDIÇÃO SEMÂNTICA MANUAL para
		    ficar correto. Edições no output gerado são PROIBIDAS, exceto: headers de arquivo gerado,
		    configuração de formatação, ou scaffolding de adapter temporário explicitamente documentado
		    FORA do código gerado (P1 estrito).
		"""

	consequences: """
		Positivas:
		(P1c) Valida a hipótese central P1 (spec→código sem edição semântica manual) no MENOR
		      experimento possível antes de comprometer 14 BCs (real-options).
		(P2c) Substrato atrás dos Ports preserva a opção de troca de vendor (P2/P7); stack como
		      hipótese falsificável evita lock-in prematuro.
		(P3c) O golden-example CMT vira o template (P7) que torna o fan-out rápido e consistente.

		Negativas / limitações:
		(N1) W006.2 exige primeiro materializar o subconjunto mínimo de contratos compiláveis do CMT
		     (hoje os BCs ainda não têm essa camada suficiente para codegen) — trabalho de spec
		     founder-gated antes do 1º código.
		(N2) Depende de uma decisão de stack mínima (W005) que ainda não existe e cujos ids de ADR
		     planejados no wave-plan (099–105) já foram consumidos por ADRs de governança — a
		     reconciliação do wave-plan é trabalho SEPARADO, fora deste ADR.
		(N3) A estratégia assume que o padrão do golden-example generaliza para os demais BCs; se o
		     fan-out revelar que a fatia vertical não generaliza, a estratégia revisita.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta estratégia estará errada SE o pipeline spec→código exigir EDIÇÃO SEMÂNTICA MANUAL do
			output gerado mesmo após a escolha de toolchain (viola P1 — o golden-example não prova
			governabilidade), OU se o padrão validado no golden-example CMT NÃO generalizar no fan-out
			(cada BC exigindo re-desenho da fatia vertical em vez de replicar o template).
			"""
		observableSignal: """
			(1) No golden-example: qualquer arquivo gerado editado SEMANTICAMENTE para passar (vs
			apenas header/formatação/scaffolding documentado fora do gerado). (2) No fan-out: nº de BCs
			cuja implementação diverge estruturalmente do template do golden-example > 0 sem ADR
			justificando — sinal de que a vertical-slice não generaliza.
			"""
	}

	affectedArtifacts: [
		"governance/wave-plan.cue",
	]

	defersTo: []

	principlesApplied: ["P1", "P7", "P2", "P13"]

	supersedes: []

	rationale: """
		P1 (código gerado, nunca escrito): o coração da estratégia é validar P1 — o golden-example
		prova que a spec é fonte suficiente para gerar contratos + aggregate + testes SEM edição
		semântica manual. O gate de abandono (edição semântica proibida, exceto header/formatação/
		scaffolding fora do gerado) é P1 enforçado operacionalmente.

		P7 (5 Ports canônicos) + P2 (vendors atrás de adapters): o substrato sobe atrás dos Ports
		(EventLogPort primeiro); o golden-example usa adapter-stub. Preserva a opção de troca de vendor
		(real-options) e a fronteira anti-lock-in (P2). Por isso "atrás dos Ports" é parte da decisão,
		não detalhe.

		P13 (derivação de BC) + classificação core/supporting/generic: a ordem core-first deriva da
		classificação de subdomínio (cmt/dlv/fce/rew core); o spine vem do context-map (CMT→BDG→DLV→
		INV→FCE); o mapa build/buy vem de theory-of-firm aplicada a essa classificação.

		Lentes: organizational-resource-allocation (WSJF — validar o pipeline numa fatia fina; o
		constraint é a banda do founder, então minimiza-se a superfície de revisão por unidade de
		aprendizado); real-options (gates continuar/pivotar/abandonar definidos ANTES; stack como
		hipótese falsificável; a premissa mais arriscada — o pipeline de codegen — testada primeiro num
		aggregate auto-contido, não no FCE cross-BC); theory-of-firm (build/buy map; assimetria de erro
		— terceirizar o core destrói o moat, construir o generic desperdiça); developer-and-integrator-
		experience (golden-example = quickstart do agente que gera código); testing-and-validation-for-
		financial-systems (testes de invariante gerados das assertions são o critério de sucesso do
		W006.2).

		Por que CMT e não FCE: o objetivo de W006.2 é provar o PIPELINE (risco de codegen), não modelar
		o domínio mais complexo. CMT bd-mutual-acceptance é o aggregate auto-contido de menor superfície
		externa; FCE PrePaymentGuard é cross-BC por construção e prova COMPOSIÇÃO — logo é a validação
		TERMINAL (W006.3), não o teste isolado.

		Escopo (mesh-spec only): este ADR governa a prontidão do lado-spec + o contrato de codegen.
		"Execução local do golden-example" = validar o output gerado na branch, NÃO deploy de runtime;
		nada aqui toca o mesh-runtime (repo subordinado, fora de escopo — CLAUDE.md). A decomposição
		operacional (wave W006: W006.0–W006.4) vem em artefato separado (wave-plan, PR próprio),
		referenciando este ADR — a estratégia (este ADR, toolchain-independente) fica separada do plano
		de execução.

		Tensão com axiomas: nenhuma.
		"""
}
