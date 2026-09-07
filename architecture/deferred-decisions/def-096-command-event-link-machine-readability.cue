package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def096: artifact_schemas.#DeferredDecision & {
	id:     "def-096"
	title:  "Elo comando→evento ilegível por máquina no #Command — o teto de toda cobertura derivada de domain story"
	date:   "2026-09-07"
	status: "open"

	description: """
		O #Command do domain-model NÃO tem campo de evento emitido. As chaves
		são [code, name, description, rationale, fields] — verificado por
		cue export em 2026-09-07. O elo comando→evento existe em apenas dois
		lugares, e nenhum deles é universal:
		(1) dentro de aggregates[].lifecycle.transitions[].emitsEvents, e SÓ
		para comandos que causam transição de estado;
		(2) em PROSA, no rationale do próprio comando — o
		cmd-submit-quotation declara ali que 'emite evt-quotation-submitted
		(internal)', e essa é a única morada da relação.

		MEDIÇÃO no corpus vivo (fatia 0, cobertura derivada sobre as duas
		domain stories, 22 passos, 14 commandRefs):
		- 4 de 14 comandos (29%) têm transição de lifecycle e são visíveis à
		derivação;
		- a ds-supplier-network-journey inteira é 0 de 6 — a derivação por
		transição é CEGA à story do fornecedor;
		- invisíveis por natureza: entry-points que criam agregado
		(cmd-register-participant, cmd-open-rfq, cmd-submit-purchase-
		requisition, cmd-record-evidence) e mutações intra-state
		(cmd-submit-quotation, cmd-propose-counter-terms, cmd-revise-
		quotation, cmd-decline-counter-terms).

		Fica deferida a decisão de tornar o elo legível por máquina. As
		formas identificadas: (a) campo emitsEvents no #Command, opcional;
		(b) campo obrigatório com backfill dos comandos existentes;
		(c) manter em prosa e aceitar o teto da verificação derivada.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: emendar o #Command é mexer no schema mais
		consumido do repositório — 15 BCs derivados, todos os comandos de
		todos eles, além do contrato de codegen que o mesh-runtime e o
		mesh-frontend-runtime consomem. E a forma (a), campo opcional,
		traria meia-verdade estrutural: uma derivação não conseguiria
		distinguir 'este comando não emite evento' de 'este comando emite e
		ninguém declarou' — o mesmo defeito de vazio ambíguo que a auditoria
		do #DomainStory encontrou, transplantado para o domain-model. Custo
		evitado: emenda no núcleo do repo para servir um instrumento que
		hoje audita duas stories.

		CUSTO DE CONTINUAR DEFERINDO: toda verificação DERIVADA de cobertura
		fica com teto de ~29% dos comandos, e o lado vendedor da jornada
		segue inauditável por completo. Mais fundo que o instrumento: a
		relação comando→evento é SEMÂNTICA DE DOMÍNIO — quem provoca o quê —
		e enquanto vive em prosa, nenhum gate a lê e nada impede que
		apodreça exatamente como as refs da ds-buyer-procurement-journey
		apodreceram por quatro camadas de evolução do modelo com o CI verde
		o tempo todo.

		O QUE ESTE DEF NÃO FAZ: não emenda o #Command, não escolhe entre
		(a)/(b)/(c), e não trata a prosa como erro — hoje ela é a morada
		legítima da relação, e a questão é se deve continuar sendo.
		"""

	triggerCalibrationRationale: """
		O manual-review carrega o sinal real: emendar o schema mais central
		do repo é decisão do founder sobre custo de mudança, e nenhum
		predicado antecipa quando vale pagá-lo. O recurrence sobre
		commandRefs no diretório das stories é o sinal MECÂNICO de que o
		ponto cego ficou mais caro: a terceira story aumenta em 50% o corpus
		que a derivação não alcança, e é aí que a conta vale ser refeita.
		Threshold 3 e não 2 porque 2 é o estado presente — o gatilho pega o
		crescimento, não o que já está medido aqui.
		"""

	originatingArtifacts: [
		"architecture/artifact-schemas/domain-model.cue",
		"strategic/domain-stories/supplier-network-journey.cue",
		"session:fatia-0-cobertura-derivada",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			medium, e a calibração é deliberada contra a do def-095: aqui
			nada quebra e nenhum produto para — o custo é de ALCANCE DE
			VERIFICAÇÃO, não de funcionamento. No def-095 a rede sem
			fornecedores É o produto não funcionando; aqui o sistema opera
			igual, e o que se perde é a capacidade de provar que a narrativa
			ainda corresponde ao modelo. cross-cutting porque resolver toca
			o domain-model de todos os BCs derivados e o contrato de codegen
			que os dois runtimes consomem. Exit: a decisão do founder entre
			(a) campo opcional, (b) campo obrigatório com backfill, ou (c)
			manter em prosa aceitando o teto — seguida, nas duas primeiras,
			da emenda de schema com ADR próprio.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Emendar o #Command é decisão do founder sobre custo de mudança no schema mais consumido do repo (15 BCs + contrato de codegen dos dois runtimes); nenhum predicado antecipa quando o benefício de verificação supera esse custo."
	}, {
		kind:      "recurrence"
		pattern:   "commandRefs:"
		scope:     "file-content"
		pathScope: "^strategic/domain-stories/"
		threshold: 3
	}]
}
