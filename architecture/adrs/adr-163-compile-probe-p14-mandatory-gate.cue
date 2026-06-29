package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-163 — O compile-probe da forma P14 (check-(a) de adr-146) é gate
// determinístico MANDATÓRIO sobre os domain-types gerados. Resolve def-056:
// a premissa do deferimento ("não há geração viva a auditar") CADUCOU — o loop
// de codegen está vivo e committado no mesh-runtime e no mesh-frontend-runtime.
// FRONTEIRA: este ADR fixa o CONTRATO do check (o que provar + pass/fail +
// mandatoriedade); a IMPLEMENTAÇÃO do probe é trabalho de RUNTIME (mesh-runtime),
// deferida em def-071. NÃO se implementa o probe aqui.

adr163: artifact_schemas.#ADR & {
	id:    "adr-163"
	title: "Compile-probe da forma P14 é gate determinístico mandatório sobre os domain-types gerados"
	date:  "2026-06-28"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		PREMISSA CADUCADA. O def-056 deferiu o check-(a) de adr-146 — a prova POR
		COMPILAÇÃO de que a forma P14 sobrevive ao codegen — com o motivo explícito
		"só há o que verificar quando houver GERAÇÃO VIVA: tipos efetivamente gerados
		e compiláveis a auditar". Naquele momento (2026-06-10) não havia: o harness
		validate-codegen.sh saía EX_CONFIG (78) e o mesh-runtime não existia.

		EVIDÊNCIA DE DISCO (2026-06-28) de que a premissa mudou. O loop de codegen
		está VIVO e committado: no mesh-runtime, a superfície FCE gerada
		(contexts/fce-generated/, 3 estágios com header DO-NOT-EDIT) emitida por
		tools/codegen/, com FF-CG-03 (regeneração-e-diff via scripts/regenerate.sh)
		como baseline; no mesh-frontend-runtime, idem (contexts/fce-generated/).
		Há tipos gerados reais sobre os quais raciocinar.

		POR QUE ISSO O TORNA RESOLVÍVEL AGORA, E DISTINTO DOS 9 RE-ADIADOS. O que o
		def-056 defere é um CONTRATO DE SPEC — o que P14 exige que o probe prove — e
		contrato é resolvível no mesh-spec assim que existe geração viva a referenciar.
		Os outros 9 defs disparados na mesma triagem (def-037/038/040/041-045/049)
		deferem SELEÇÃO DE VENDOR/RUNTIME, cuja decisão vive no mesh-runtime/infra
		(premature-proxy: sem evento-sensor honesto no mesh-spec) — por isso foram
		re-adiados, não resolvidos. A linha é categórica: def-056 defere contrato
		(spec-resolvível); os 9 deferem construção de runtime (runtime-resolvível).

		ALTERNATIVAS CONSIDERADAS. (i) Seguir deferindo o check-(a) — rejeitada: a
		premissa que justificava o deferimento (ausência de geração viva) caducou;
		manter o deferimento seria deferral sem trade-off, o failure-mode que o
		próprio adr-062 combate. (ii) Fixar o check-(a) como advisory (não-bloqueante)
		— rejeitada: P14 é invariante forte (adr-146); enforcement advisory de um
		invariante compile-time-verificável viola P10 (gate determinístico valida;
		estocástico/humano recomenda) e desperdiça a prova mais forte disponível
		(compilação real). (iii) Implementar o probe AQUI, no mesh-spec — rejeitada
		pela fronteira spec×runtime (adr-138/139): o gerador e o output vivem no
		mesh-runtime; o probe roda no CI de lá.
		"""

	decision: """
		Fixa-se o CONTRATO do check-(a) — NÃO a sua implementação:

		(a) O QUE PROVA. Que a forma P14 sobrevive ao codegen: os domain-types
		gerados COMPILAM de modo que os invariantes compile-time-verificáveis sejam
		FORÇADOS pelo compilador. Operacionalmente, os probes de violação — estado
		não-tratado, campo obrigatório ausente, wrapper-bypass (os 16 medidos no
		spike 4 de adr-146) — DEVEM FALHAR a compilação. É enforcement determinístico,
		não revisão humana nem inspeção estocástica.

		(b) QUANDO RODA. Em CI, sobre os tipos gerados, no runtime que os gera
		(hoje mesh-runtime; qualquer runtime subordinado que materialize geração).

		(c) SEMÂNTICA DE FALHA. Um probe de violação que DEVERIA não-compilar passa
		a compilar ⇒ a forma gerada não força o invariante ⇒ gate VERMELHO (build
		falha). Verde exige que todo o corpus de probes de violação falhe compilar.

		(d) FRONTEIRA EXPLÍCITA (o limite deste ADR). Este ADR fixa o CONTRATO: o que
		o probe deve provar, a semântica pass/fail, e que o check é MANDATÓRIO (não
		advisory). A IMPLEMENTAÇÃO do probe — linguagem-alvo, test-runner, a fiação
		concreta do corpus de 16 no pipeline — é trabalho de RUNTIME (mesh-runtime),
		um arco futuro governado por este contrato, deferido em def-071. Este ADR
		PARA no contrato: não decide nem descreve COMO o probe é codificado.

		RELAÇÃO COM FF-CG-03. Complementar, não substituto: FF-CG-03 (regeneração-e-
		diff) prova proveniência e ausência-de-drift do output gerado; o check-(a)
		prova que a forma gerada FORÇA. As duas fitness functions cobrem eixos
		distintos do mesmo P14.
		"""

	consequences: """
		POSITIVAS. P14 ganha sua validação mais forte (prova por compilação) como
		gate determinístico mandatório, fechando o gap N1/N3 de adr-146 no nível de
		contrato. A fronteira spec(contrato)/runtime(implementação) permanece limpa.
		O def-056 sai do backlog disparado-e-apodrecido (resolvido, não re-adiado).

		NEGATIVAS / RESÍDUO. O enforcement só fica ATIVO quando o mesh-runtime cabear
		o probe; até lá, P14 segue coberto por FF-CG-03 (proveniência/drift) + review
		(P10) — não pela prova-de-força. Esse resíduo de IMPLEMENTAÇÃO é deferido e
		rastreado em def-071 (gatilho manual-review = check-(a) cabeado no CI do
		mesh-runtime + temporal 180d de backstop), preservando o tracking que o
		manual-review do def-056 dava — sem ele, resolver def-056 silenciaria a
		pergunta "o probe já foi implementado?".
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE a forma gerada não puder ser provada por compilação — p.ex. se a linguagem-alvo escolhida pelo runtime não tiver enforcement compile-time suficiente para os 16 probes, tornando o check-(a) vacuamente verde (passa sem nunca poder reprovar)."
		observableSignal: "No harness do mesh-runtime: probes do corpus de 16 que DEVERIAM não-compilar passam a compilar, OU o check-(a) é instalado e jamais reprova nenhum probe do corpus (verde estrutural sem poder de reprovação)."
	}

	affectedArtifacts: [
		"architecture/deferred-decisions/def-056-codegen-form-compile-probes.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-071-compile-probe-runtime-implementation.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo: ["def-071"]

	principlesApplied: [
		"P14 — fidelidade de forma do codegen: a forma gerada deve FORÇAR os invariantes compile-time-verificáveis (adr-146); o check-(a) é a sua prova por compilação.",
		"P10 — gate determinístico valida, estocástico recomenda: o enforcement de P14 é compilação (determinística), não revisão; paralelo direto com adr-162 (enforcement determinístico em vez de vigilância manual).",
		"adr-138 — fronteira spec×runtime: o CONTRATO do check vive no spec; a IMPLEMENTAÇÃO do probe vive no runtime (def-071).",
	]

	rationale: "Resolve def-056 fixando o contrato do enforcement P14 por compilação — agora que há geração viva a auditar (mesh-runtime/mesh-frontend-runtime) — sem invadir a implementação, que permanece trabalho de runtime deferido em def-071."
}
