package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-161 — Conduta de fato ausente no PrePaymentGuard: ausência de invoice/
// eligibility fica guarded (waiting-for-information), não escala. Filho de
// adr-160 (refina a semântica do residual not-clean do item 4/6 para o caso
// de ausência; NÃO emenda, NÃO supersede — adr-160 permanece proposed). Irmão
// de contexto adr-155 (dono do escalated + piso). Fronteira spec-only.

adr161: artifact_schemas.#ADR & {
	id:    "adr-161"
	title: "Conduta de fato ausente no PrePaymentGuard: guarded-waiting, não escalated"
	date:  "2026-06-28"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		LACUNA DE CONDUTA EXPOSTA PELA MATERIALIZAÇÃO. adr-160 estabeleceu o
		outcome-split (selector roteia, guard termina) e o item 4 declarou que o
		selector da exceção roteia o "residual amplo, INCLUSIVE breach" ao
		candidato escalated. A materialização avançou: fatia 1 preencheu os 4
		selectors do FCE (contexts/fce/domain-model.cue); fatia 2 materializou o
		decide() em duas fases (mesh-runtime). Ao mapear a fatia 3 (corpos reais
		do FCE), read-only, emergiu um caso que a spec resolve de forma
		CONTRADITÓRIA: a AUSÊNCIA de invoice ou eligibility no ponto de authorize.

		A AUSÊNCIA PODE OCORRER. eligibility é consumida no gate via sync query
		ao REW (canvas fce communication inbound rew, QueryEligibility) que pode
		voltar vazia se o REW ainda não avaliou a entidade; e o tipo de runtime
		modela null=absent=fail-closed como input de primeira classe (não é
		impossível por construção). invoice é causalmente presente no caminho
		feliz (InvoiceIssued é o trigger que materializa o Payment), mas o
		contrato não a garante no ponto de authorize.

		A CONTRADIÇÃO. Quando invoice/eligibility está ausente: (lado selector
		design) adr-160 item 4 + o rationale de sel-prepayment-not-clean mandam
		rotear "todo caso não-limpo" ao escalated — e como o guard terminal do
		piso (inv-breach-bypasses-escalation) só barra evidência, a ausência de
		invoice/eligibility ESCALARIA, marcando uma flag stale do
		vo-overridden-guard-conditions para um fato que nem está presente; (lado
		evento/VO/piso) evt-payment-guard-escalated descreve a escalada como
		condição "stale, incompleta ou ambígua-mas-PRESENTE", o VO só tem flags
		de staleness (sem campo de ausência) e inv-breach-bypasses-escalation
		fixa o piso como evidência-específico — ou seja, só PRESENTE escala. Os
		dois lados não podem ser ambos verdade na ausência: um manda escalar
		(com flag mentirosa), o outro diz que não escala.

		POR QUE ESTRUTURAL E POR QUE AGORA. Resolver isto refina o significado
		do residual de adr-160 (itens 4 e 6) e fixa a conduta de um caso
		adjacente ao piso P11 — não é escolha de implementação local. Tem de
		ser decidido ANTES da fatia 3 escrever os corpos: sem a conduta fixada,
		a fatia 3 ou produz audit falso (opção a) ou cristaliza no runtime uma
		decisão de contrato (proibido a um repo subordinado).

		Alternativas avaliadas: (a) ESCALAR a ausência tratando-a como
		"incompleta" (canvas override-prepayment-guard) e reinterpretar as flags
		do VO de "stale" para "needs-override" — REJEITADA: produz registro de
		auditoria falso (flag "stale" para fato ausente), contradiz a descrição
		"ambígua-mas-PRESENTE" do evento, e troca o fail-closed de hoje
		(null→guarded) por escalada — escalar sem substância é pedir julgamento
		humano no vazio, enfraquecendo a governança. (b) Tratar a ausência como
		BREACH (freeze) — REJEITADA: ausência de invoice/eligibility não é
		violação de integridade; P11 é money-on-PROOF (evidência), e informação
		ainda-não-materializada não é evidência forjada/ausente. Disparar o
		freeze fail-safe (p11-invariant-breach-detected) para informação faltante
		é desproporcional e confunde "esperando" com "ataque". (c) a TÉTRADE
		abaixo — única que mantém os três artefatos-verdade simultaneamente
		verdadeiros e não move o piso.
		"""

	decision: """
		(1) TÉTRADE de conduta no PrePaymentGuard sobre (guarded,
		cmd-authorize-payment). O espaço parte em quatro condutas ontologicamente
		distintas, não duas:
		- CLEAN (invoice + eligibility + evidência presentes, válidas e frescas)
		  → authorized.
		- STALE-PRESENTE (alguma das 3 condições presente-e-válida mas
		  velha/ambígua) → escalated (julgamento humano — há substância).
		- BREACH (evidência AUSENTE ou integridade cripto FALHA) → roteado ao
		  candidato escalated e BARRADO no guard terminal
		  inv-breach-bypasses-escalation → fica guarded, NoApplicableTransition
		  com failedGuard: inv-breach-bypasses-escalation → freeze
		  (p11-invariant-breach-detected). [adr-160 piso INTACTO]
		- AUSENTE-DE-FATO (invoice OU eligibility não materializada — fact null)
		  → casa NENHUM selector → NoApplicableTransition → fica guarded
		  (waiting-for-information). NÃO escala (sem substância para julgar) e NÃO
		  é breach (não é violação de integridade).

		(2) ESTREITAMENTO de sel-prepayment-not-clean: de "residual amplo" para
		"residual NÃO-LIMPO com invoice e eligibility PRESENTES" — toda condição
		presente-stale/ambígua MAIS o breach de evidência (que segue roteado e
		barrado no guard). A ausência de invoice/eligibility é carve-out: não
		casa nem sel-prepayment-clean nem sel-prepayment-not-clean.

		(3) {clean, not-clean} deixa de ser EXAUSTIVO (refina adr-160 item 6
		"complementares, exatamente um casa"): permanecem mutuamente exclusivos,
		mas a ausência de invoice/eligibility casa NENHUM → NoApplicableTransition
		→ guarded. Zero selector casando é desfecho legítimo desta tétrade, não
		defeito.

		(4) ASSIMETRIA INTENCIONAL breach vs ausência-de-fato (é o que preserva o
		piso de adr-160). O breach de evidência continua ROTEADO-E-BARRADO →
		NoApplicableTransition carrega failedGuard: inv-breach-bypasses-escalation
		(sinal de freeze recuperável, exigido por adr-160 item 9). A
		ausência-de-fato de invoice/eligibility cai por "nenhum selector casou" →
		NoApplicableTransition carrega failedSelector (waiting, SEM sinal de
		freeze — porque não é violação de piso). As duas absências são tratadas
		diferente porque são ontologicamente diferentes: evidência-ausente é
		evento de piso P11; invoice/eligibility-ausente é estado operacional de
		espera.

		(5) MOTOR E SCHEMA INTACTOS. Nenhuma mudança em
		architecture/artifact-schemas/domain-model.cue (#TransitionSelector de
		adr-160 basta), no gerador (skeleton.go) nem no decide() de duas fases. A
		conduta "nenhum selector casa → NoApplicableTransition → guarded" JÁ é
		suportada pelo decide() materializado na fatia 2. Esta decisão torna essa
		conduta INTENCIONAL e documentada para a ausência de invoice/eligibility
		— não adiciona mecanismo.

		(6) EMENDA em contexts/fce/domain-model.cue (mesmo commit): reescrever o
		rationale de sel-prepayment-not-clean (residual PRESENTE, não "amplo");
		ajustar o rationale de sel-prepayment-clean (remover "exaustivo /
		exatamente um casa"; acrescentar o carve-out da ausência); acrescentar à
		descrição de evt-payment-guard-escalated a cláusula de que a ausência de
		invoice/eligibility fica guarded-waiting (distinta de breach-freeze e
		stale-escalate). inv-breach-bypasses-escalation e
		vo-overridden-guard-conditions NÃO mudam.

		(7) FRONTEIRA spec-only. Este ADR decide SEMÂNTICA (a tétrade + o
		estreitamento + a assimetria). NÃO toca skeleton.go, NÃO toca os corpos
		de selector/guard do runtime (fatia 3 — em especial o predicado que
		distingue PRESENÇA de FRESCOR), NÃO toca o handler resolve nem
		auth/def-024 (Stage 2). A materialização é fatia posterior governada por
		este contrato.

		(8) DEFERIMENTO. A conduta de ausência PROLONGADA (se deve virar
		escalation por timeout / fail-safe operacional) fica deferida em def-069
		— exige política operacional (janela de tempo, qual informação,
		severidade, SLA, responsável, consequência) inexistente na fatia do guard
		e sem fluxo de produção que a materialize.
		"""

	consequences: """
		Positivas.
		(P1c) A contradição da spec (selector-design vs evento/VO/piso) fica
		resolvida: os três artefatos-verdade — sel-prepayment-not-clean, o
		evt-payment-guard-escalated/VO, e inv-breach-bypasses-escalation — ficam
		coerentes sob a tétrade. A ausência deixa de ter dois destinos
		conflitantes.
		(P2c) Zero audit falso: a flag *StaleOverridden do
		vo-overridden-guard-conditions só dispara para staleness real
		(presente-stale); a ausência nunca produz flag mentirosa porque nunca
		escala.
		(P3c) O piso de adr-160 não se move: o breach de evidência continua
		roteado-e-barrado pelo MESMO guard terminal, com failedGuard recuperável;
		só a ausência de invoice/eligibility é carve-out — e ela não é piso.
		(P4c) Preserva o fail-closed de hoje (null=absent → guarded): a ausência
		segue sem mover dinheiro, agora conduta INTENCIONAL e documentada, não
		efeito colateral de firstOrNull/stub.

		Negativas (limites intrínsecos).
		(N1c) {clean, not-clean} deixa de ser exaustivo — o leitor do domain-model
		precisa internalizar que a ausência casa nenhum selector
		(NoApplicableTransition→guarded). Documentado nos rationales emendados,
		mas é um caso a mais a carregar (refina a leitura de adr-160 item 6).
		(N2c) A assimetria breach-vs-ausência (failedGuard vs failedSelector no
		mesmo NoApplicableTransition) é sutil: o consumidor downstream que queira
		o sinal de freeze tem de distinguir os dois. Mitigado pela forma
		{to, failedGuard?, failedSelector?} de adr-160, que já carrega ambos.
		(N3c) A distinção PRESENÇA vs FRESCOR é hand-authored no runtime (fatia
		3): divergência entre "presente" (não-null) e "fresco" é possível até a
		obrigação de teste da fatia 3 cobrir o caso ausente (fica guarded,
		failedSelector) ao lado do controle positivo de adr-160 item 9.

		Compliance / fitness (fronteira spec→materialização). A fatia 3 que
		materializar este contrato DEVE provar, além do gate adversarial do piso
		de adr-160 item 9: (c) ausência de invoice OU eligibility (fact null,
		demais condições OK) resulta em guarded (NoApplicableTransition,
		failedSelector), NÃO em escalated e NÃO em freeze. Sem (c), a tétrade
		colapsa de volta na contradição que este ADR resolve.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se a tétrade não particionar
			deterministicamente o não-clean: ou (devida-governança-negada) algum
			caso de ausência de invoice/eligibility LEGITIMAMENTE precisa de
			julgamento humano — há substância para o supervisor decidir mesmo sem
			o fato materializado —, provando que "ausência = waiting" nega
			governança devida; ou (vazamento do piso) o carve-out da ausência faz
			o sinal de freeze do breach de EVIDÊNCIA se perder (evidência-ausente
			caindo em failedSelector em vez de failedGuard), de modo que o gate
			adversarial do piso de adr-160 item 9 falhe; ou (predicado
			insuficiente) distinguir PRESENÇA de FRESCOR exige ler fonte fora de
			(state, command, context) na fatia 3.
			"""
		observableSignal: """
			(devida-governança-negada) um caso de produção em que ausência de
			invoice/eligibility é roteada a supervisão E o supervisor tem matéria
			real para um override coerente — sinal de que waiting era escalation.
			(vazamento) o gate adversarial do piso (adr-160 item 9) falha o caso
			breach-de-evidência quando invoice/eligibility também está ausente.
			(predicado) o selector de presença da fatia 3 precisa de fonte além de
			(state, command, context).
			"""
	}

	affectedArtifacts: [
		"contexts/fce/domain-model.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-069-absent-fact-prolonged-conduct.cue",
	]

	derivedArtifacts: []

	defersTo: ["def-069"]

	principlesApplied: [
		"P11 — money-on-proof preservado: o piso inoverridável de adr-128/adr-155 não se move. Breach de evidência continua roteado-e-barrado pelo MESMO guard terminal (failedGuard recuperável); a ausência de invoice/eligibility é carve-out porque NÃO é violação de integridade — é informação não-materializada, não evidência forjada/ausente. Tratar ausência como breach (alt b) diluiria o piso a 'qualquer input faltante'.",
		"P10 — gate determinístico sobre recomendação estocástica: a conduta de ausência (guarded waiting) é determinística e NÃO move dinheiro nem escala autonomamente; escalar no vazio (alt a) pediria julgamento humano sem matéria, degradando o gate em ruído.",
		"P14 — fidelidade de forma compile-time: os três desfechos de decide() de adr-160 já carregam o caso ausente via Rejected.NoApplicableTransition (failedSelector) — nenhum tipo novo; a tétrade é absorvida pelo sum-type fechado existente, sem caminho ilegal compilável.",
		"P0 — localização canônica: a semântica da tétrade vive aqui (ADR) e a forma vive no #StateTransition/selector via emenda no domain-model do FCE; o runtime aponta para este contrato, não o redecide (mesh-runtime subordinado).",
		"adr-160 — parent: refina a semântica do residual not-clean (itens 4 e 6) — 'residual amplo, exatamente um casa' passa a 'residual PRESENTE, par não-exaustivo, ausência casa nenhum'. NÃO emenda nem supersede adr-160 (permanece proposed). Parentesco análogo a adr-160→adr-141.",
		"adr-155 — irmão de contexto: adr-155 desenhou o escalated + o piso + o vo-overridden-guard-conditions; a leitura 'só PRESENTE escala' deste ADR alinha-se à descrição do evt-payment-guard-escalated e ao VO de adr-155. Não reaberto nem re-ratificado.",
	]

	rationale: """
		A tétrade é escolhida contra (a) e (b) porque é a única leitura que mantém
		os três artefatos-verdade simultaneamente verdadeiros: o
		evt-payment-guard-escalated/VO ("PRESENTE escala"), o piso evidência-
		específico (inv-breach-bypasses-escalation → freeze), e o contrato de
		runtime documentado (null=absent=fail-closed→guarded). (a) escalar a
		ausência quebra a fidelidade do audit (flag "stale" para fato ausente) e a
		palavra "PRESENTE" do evento; (b) tratar ausência como breach
		misclassifica informação-não-materializada como violação de integridade —
		P11 é sobre PROVA (evidência), não sobre informação que ainda não chegou.

		A assimetria breach-vs-ausência é o cerne, não detalhe. Evidência-ausente
		é evento de piso P11 (precisa do sinal de freeze, failedGuard); invoice/
		eligibility-ausente é estado operacional de espera (sem sinal,
		failedSelector). Colapsar as duas absências num só tratamento ou
		super-congelaria (tratar espera como breach) ou sub-protegeria (perder o
		sinal de freeze da evidência). A forma {to, failedGuard?, failedSelector?}
		de adr-160 já distingue as duas no retorno — este ADR só nomeia a
		distinção semântica.

		Especificidade Mesh: ancorado no gate de 3 condições do PrePaymentGuard
		(P11 na execução), no consumo da eligibility do REW por sync query
		(QueryEligibility, que pode voltar vazia), e no piso inoverridável de
		adr-128/adr-155 — não é regra genérica de "input faltante".

		decisionClass structural: refina a relação domain-model↔código-gerado
		(o significado do residual de adr-160) e a conduta de um caso adjacente ao
		piso — atravessa o ADR pai e o domain-model do FCE, não contido num
		artefato. status proposed: a fatia 3 (materialização + obrigação de teste
		c) ratifica; a aprovação do founder promove proposed→accepted.
		reversibility medium: reverter = desfazer a emenda + o predicado de
		presença do runtime — esforço moderado, nada persistido travado.
		blastRadius cross-artifact: o impacto comportamental é FCE-local (a tétrade
		da ausência é FCE-específica — DLV não tem fato-ausente-waiting, seu
		residual é veredito), tocando o domain-model do FCE + a leitura FCE de
		adr-160 + def-069; não toca engine/schema/DLV/CMT/REW.

		Tensão com axiomas: nenhuma. Cumpre P11 (piso intacto) e P10 (sem money
		move autônomo; ausência é espera determinística), e absorve-se em P14/
		adr-160 sem novo tipo.
		"""
}
