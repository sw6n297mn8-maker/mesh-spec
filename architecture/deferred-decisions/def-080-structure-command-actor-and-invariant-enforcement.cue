package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def080: artifact_schemas.#DeferredDecision & {
	id:     "def-080"
	title:  "Estruturar campo de ator no #Command e campo de enforcement no #Invariant — mecanizar os padrões A/B de exclusão legítima do gate agente↔modelo (adr-175)"
	date:   "2026-07-13"
	status: "open"

	description: """
		O gate sc-ag-02 (adr-175) aceita exclusões conscientes de cobertura
		cuja legitimidade é verificada por LEITURA guiada pelo critério do
		ADR — porque dois dos padrões de exclusão legítima só existem em
		prosa: padrão A (command cujo ator é externo ao agente do BC, ex.:
		cmd-submit-quotation é do fornecedor) vive em description/rationale
		do #Command; padrão B (invariant enforçada por runtime/estrutura,
		não pelo agente, ex.: 'enforcement EXTERNAL TO REW', replayHash
		mecânico) vive na rule/rationale do #Invariant. Fica deferida a
		decisão de estruturar um campo de ator no #Command e um campo de
		enforcement no #Invariant (shape dos enums, semântica de híbridos,
		retrofit), tornando esses dois padrões MECÂNICOS no gate — exclusão
		derivável de campo, como o padrão C já é derivável de
		policies[].issuesCommand.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: estruturar os campos é fatia própria e
		maior — toca o schema do domain-model (blast repo-wide), exige
		retrofit de ator/enforcement nos catálogos dos 12+ BCs, e a
		modelagem de atoria tem híbridos não-triviais (cmd-record-evidence
		é ACL+stakeholder; cmd-cancel-purchase-order tem cenário
		originadora E cenário supplier-withdraw — um enum ator ingênuo
		cristalizaria a resposta errada). AMENDMENT (2026-07-29, adr-182/
		WI-158): RE-ADIADO COM BASE NOVA — o modelo canônico de ator agora
		existe (adr-182 decs 1-2: kind/actorId/onBehalfOfOrg/roleRef com
		critério tríplice + underGovernance versionado; slot #Actor no
		envelope): a mecanização futura do campo no #Command parte de
		CONTRATO, não de rascunho, e os híbridos acima ganham vocabulário
		para serem modelados (kind + posição per adr-172). O gatilho
		permanece INALTERADO: a medição de volume/ambiguidade das higienes
		(WI-154/WI-155) segue sendo o julgamento que dispara a fatia de
		mecanização. O gate nasce FUNCIONAL com
		exclusão semântica: a mecanização é melhoria de precisão, não
		condição de existência. Custo evitado: desenhar enums de
		ator/enforcement sob pressão da fatia do gate, sem o volume real
		de exclusões medido. Custo de continuar deferindo: a legitimidade
		dos padrões A/B permanece verificada por leitura em review (humano
		aplica o critério do adr-175), com o risco de exclusão-carimbo que
		a falsificationCondition (a) do adr-175 vigia. Volume atual baixo
		o bastante para leitura-guiada: ~2 padrão-A claros + ~20 padrão-B
		no repo, concentrados no rew. AMENDMENT (2026-09-03, revisão da
		ds-buyer-procurement-journey): TERCEIRA MOTIVAÇÃO INDEPENDENTE, sem
		mudança de gatilho — o decidedBy de
		cmd-make-one-shot-sourcing-decision é string nominal e não distingue
		'ratificou a proposta do agente' de 'escolheu por conta própria';
		quando der errado, a auditoria não responde quem errou (registrado no
		rationale do passo 10 da story, na main). Dependência nos dois
		sentidos com adr-196: a materialização da proposta dá a distinção POR
		POSIÇÃO no stream antes da mecanização do campo — controle
		compensatório, não substituto; a mecanização deste def segue
		necessária para os demais commands e, quando vier, consome o
		vocabulário do fato proposto. O gatilho permanece INALTERADO
		(manual-review nas higienes WI-154/WI-155).
		"""

	triggerCalibrationRationale: """
		Manual-only (tq-def-03 warn aceito, não fail): o gatilho real é o
		VOLUME/AMBIGUIDADE de exclusões por prosa medido nas higienes A/B
		(WI-154/WI-155) tornar a leitura-guiada custosa — julgamento do
		founder sobre a experiência das higienes, não fato de disco
		machine-evaluable. Não há predicado livre de falso-positivo:
		contar entries de scopeExclusions não distingue exclusão legítima
		bem-fundamentada de carimbo (a distinção É o problema que este def
		adia mecanizar); trigger de conteúdo sobre 'ator'/'enforcement'
		dispararia em prosa que já usa os termos (inclusive este def). A
		revisita está ancorada no ponto de uso: o adr-175 (decisão 3)
		aponta este def via defersTo, e as higienes WI-154/WI-155 são o
		momento natural de medição.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-175-agent-model-coverage-gate.cue",
		"architecture/artifact-schemas/domain-model.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-artifact"
		description: """
			medium porque o gate FUNCIONA com exclusão semântica (o sc-ag-02
			acusa mecanicamente o id nem-coberto-nem-excluído; só a
			LEGITIMIDADE da exclusão depende de leitura) — o dano potencial é
			exclusão-carimbo passar em review, e o volume atual (~2 padrão-A
			+ ~20 padrão-B) mantém a leitura barata; cross-artifact porque a
			mecanização acopla o schema do domain-model (onde os campos
			nasceriam) aos agent-specs/scopeExclusions (onde o gate os
			consumiria), atravessando os catálogos dos BCs no retrofit. Exit:
			desenhar os campos (fatia própria com ADR) quando as higienes
			WI-154/WI-155 medirem o volume real — se a triagem do rew
			produzir dezenas de exclusões cuja legitimidade exigiu debate, a
			mecanização paga o retrofit; se a leitura-guiada fluir, o def
			pode ser re-adiado com o dado em mãos.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho real é o volume/ambiguidade de exclusões por prosa nas higienes A/B (WI-154/WI-155) tornar a leitura-guiada custosa — julgamento do founder sobre a experiência das higienes, não fato de disco. Sem predicado livre de falso-positivo: contagem de scopeExclusions não distingue exclusão legítima de carimbo (a distinção é o que este def adia mecanizar). Revisita ancorada no ponto de uso: adr-175 defersTo cita def-080; as higienes são o momento de medição."
	}]
}
