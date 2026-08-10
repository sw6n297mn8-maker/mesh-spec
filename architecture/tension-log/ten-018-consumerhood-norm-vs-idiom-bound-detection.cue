package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten018: artifact_schemas.#TensionEntry & {
	id:    "ten-018"
	date:  "2026-08-10"
	title: "Norma de consumerhood é semântica; a cobertura automática alcança só o idioma conhecido"

	kind: "axiom-tension"

	tensionTarget: "P12"
	manifestsIn:   "architecture/adrs/adr-190-verifier-identity-resolution-for-completion-v2.cue"

	description: """
		P12 exige que toda regra que importa seja imposta automaticamente. adr-190
		item 11 institui uma regra que importa: todo consumidor governado da
		resolução de verifier DECLARA consumerhood na forma canônica
		(_verifierResolutionConsumer:). Essa declaração é o que torna sólido o sensor
		de def-085 — sem ela, o deferimento nunca dispara e apodrece em silêncio.
		Três propriedades distintas estavam sendo confundidas e precisam ficar
		separadas: (1) consumerhood REAL — uma implementação de fato resolve
		verifier; (2) DECLARAÇÃO canônica dessa consumerhood; (3) o TRIGGER que
		observa as declarações. O gate determinístico criado
		(scripts/ci/check-verifier-resolution-consumer-declaration.sh, required via
		verifier-registry-check.yml) fecha (1)→(2) SOMENTE para o idioma atualmente
		canônico de re-derivação — a comprehension que filtra eventos
		"verifier-registered". Derivar (1) em geral não é possível: uma implementação
		futura que resolva verifier por outra construção é consumerhood real que
		nenhum detector sintático enxerga. Logo a norma é universal, mas a cobertura
		automática é idiom-bound.
		"""

	resolution: """
		Aceito conviver com a tensão sob cobertura PARCIAL e explícita, não
		silenciosa. O gate é deliberadamente estreito e verdadeiro: promete detectar
		OMISSÃO no caminho conhecido, e não prova a norma universal — o contrato está
		escrito no cabeçalho do próprio script e na suite adversarial, cujo teste
		test_idioma_ausente_nao_exige_declaracao documenta a fronteira em vez de
		escondê-la. A formulação correta e permanente é: o gate enforça a declaração
		PARA IMPLEMENTAÇÕES RECONHECIDAS PELO IDIOMA DETECTÁVEL ATUAL; não identifica
		consumerhood semanticamente. Ignorar linhas comentadas reduz falso-positivo e
		falso-verde, sem eliminá-los — o detector permanece textual/híbrido e pode
		coincidir com formas não-consumidoras, que então seriam compelidas a declarar
		consumerhood falsa (canal registrado em def-085 limitação vi). Rejeitada a alternativa de fingir enforcement universal: um gate
		que alegasse provar (1) seria falso. Rejeitada também a alternativa de deixar
		a regra como convenção pura sem gate: fecharia zero do caminho dominante.
		Enforcement completo ("cada consumidor declara exatamente uma vez") é
		INCONSTRUÍVEL por contagem: distinguir "dois consumidores num arquivo" de "um
		consumidor com duas menções" exige justamente o conhecimento semântico de (1)
		que não temos — e a propriedade de permitir dois consumidores no mesmo arquivo
		foi decisão deliberada (adr-190 item 11), para que a topologia do código não
		seja ditada pelo detector.
		"""

	status: "open"

	structuralResolutionPath: """
		Fechar a lacuna exige tornar consumerhood estruturalmente derivável em vez de
		declarada: por exemplo, se a resolução passar a viver numa abstração
		compartilhada única (a decisão deferida em def-085), consumidor passa a ser
		"quem importa a abstração" — fato derivável do grafo de imports, não de
		disciplina. Enquanto a resolução for re-derivada em cada consumidor, a norma
		permanece semântica e o detector permanece idiom-bound.
		"""

	relatedADR: "adr-190"

	rationale: """
		Sem registro, a diferença entre "a norma vale para todo consumidor" e "o gate
		enxerga só o idioma conhecido" desaparece na leitura do CI verde — o mesmo
		modo de falha que ten-017 registrou para blocking declarado sem caminho até
		required check. Externalizar a fronteira impede que agentes stateless leiam o
		gate como prova universal.
		"""
}
