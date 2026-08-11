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

		ATUALIZAÇÃO (adr-191, C3a): a resolução foi CENTRALIZADA em
		#VerifierResolution (governance/build-time/verifier-resolution.cue) e o
		detector foi re-apontado — consumidor reconhecível passou a ser "quem
		referencia/instancia a abstração canônica" (R1), com os dois bypasses
		conhecidos virando violação: re-derivação pelo idioma cru (R2) e acesso
		direto a _resolvableRefKeys (R3 — hidden em CUE é package-scoped; o
		compilador não impede o acesso dentro do package, verificado por
		execução). Isso REDUZ a tensão sem resolvê-la: instanciar um tipo nomeado
		é difícil de reproduzir por acidente, e os bypasses conhecidos agora têm
		observador — mas o detector permanece TEXTUAL. Uma implementação futura
		da MESMA semântica por construção sintaticamente nova escapa das três
		regras (a suite documenta a fronteira em
		test_semantica_reimplementada_sem_tokens_escapa). A natureza da tensão
		mudou: de "reconhecemos consumidores por uma comprehension incidental"
		para "reconhecemos consumidores por uso textual da abstração canônica".
		"""

	status: "open"

	structuralResolutionPath: """
		Fechar a lacuna exige tornar consumerhood estruturalmente derivável em vez
		de declarada. O primeiro degrau foi dado (adr-191): a resolução vive numa
		abstração compartilhada única e consumidor passou a ser "quem
		referencia/instancia a abstração canônica" — que é o que R1 observa. O
		degrau imaginado originalmente ("quem importa a abstração", derivável do
		grafo de imports) não se aplica na topologia atual: definição e
		consumidores vivem no MESMO package build_time, onde não há import a
		derivar. O fechamento real exige derivação SEMÂNTICA de consumerhood do
		grafo de tipos — analisar quem unifica com #VerifierResolution no valor
		avaliado, não no texto. Enquanto isso não existir, a norma permanece
		semântica e o detector permanece textual.
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
