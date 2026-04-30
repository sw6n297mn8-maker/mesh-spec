package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten011: artifact_schemas.#TensionEntry & {
	id:    "ten-011"
	date:  "2026-04-29"
	title: "ProductionGuide schema verbatim herda paths e constraints upstream não-aplicáveis a mesh"
	kind:  "schema-limitation"

	tensionTarget: "architecture/artifact-schemas/production-guide.cue"
	manifestsIn:   "architecture/artifact-schemas/production-guide.cue"

	description: """
		Schema #ProductionGuide foi adotado verbatim de tekton-spec/portfolio
		(sourceVersion 0.3.0, sourceCommit 919f3e886e76ce4b57c951cae2a5a53e5bce7d03)
		via ADR-053. Adoção verbatim significa zero modificação local —
		modificar quebra adoptionMode "verbatim" em adopted-artifacts.cue.

		Validação semântica advisory pós-commit (vp-artifact-schema, sessão
		2026-04-29) identificou 5 findings não-acionáveis em mesh:

		(1) [fail] canonicalPathRegex aceita alternativa "portfolio/production-guides/"
		que referencia diretório inexistente em mesh-spec (originário do
		upstream tekton-spec/portfolio onde faz sentido). Cria falso-positivo
		potencial caso arquivo seja criado nesse path.

		(2) [warn] Prerequisites.collectFromFounder com MinItems(1)
		obrigatório pode ser artificialmente forçado para schemas extremamente
		simples ou meta-utility.

		(3) [warn] SectionSpec.target usa regex ^#[A-Z][A-Za-z]+$
		que não verifica se o tipo pertence ao schema alvo do guide
		(under-specification cross-schema; endereçável apenas via
		structural check, não via shape — limitação inerente de CUE).

		(4) [warn] Mesmo regex de target seria breaking change se
		futuras instâncias adotarem targets qualificados por namespace
		(ex.: artifact_schemas.#ProductionGuide).

		(5) [warn] QualityCriterion.id (transitivo via quality-criteria.cue)
		com regex ^(uq|tq-[a-z]{2,3})-[0-9]{2}$ limita abreviações a 2-3
		caracteres e IDs a 99 critérios — rigidez para schemas com abreviação
		canônica de 4+ caracteres.

		Tensão: mesh herdou design decisions feitas para o contexto upstream
		(portfólio-wide) que não se aplicam ao contexto local. Não pode
		modificar localmente sem supersessão da adoção verbatim.
		"""

	resolution: """
		Aceitar a tensão. Mesh mantém adoção verbatim e registra findings
		como input para potencial promoção FP-XX upstream em tekton-spec/
		portfolio quando trabalho de melhoria upstream for priorizado.
		Custo de divergência local (supersessão da adoção verbatim) excede
		o valor dos findings — todos são improvements de qualidade, nenhum
		é bloqueante operacional. Risco em mesh é zero por construção:
		finding (1) tem mitigação por convenção (ninguém cria portfolio/
		em mesh); findings (2)-(5) são observações sobre evolução futura,
		não problemas atuais.

		Alternativa rejeitada: supersessão local da adoção (adoptionMode
		fork ou modificada). Custo: perde alinhamento portfolio-wide,
		duplica responsabilidade de manutenção do schema, viola precedente
		de adr-050 e adr-052. Ganho: zero — nenhum finding bloqueia
		operação.
		"""

	status: "accepted"

	structuralResolutionPath: "Promoção FP-XX para tekton-spec/portfolio (corrige #ProductionGuide upstream; mesh re-adota com novo sourceCommit)"

	relatedADR: "adr-053"

	rationale: """
		Tensão registrada para preservar memória organizacional do trade-off:
		mesh aceitou adoção verbatim consciente de que findings advisory
		seriam herdados sem capacidade de correção local. Sem este registro,
		futuro autor que reler vp-artifact-schema findings poderia
		erroneamente concluir que mesh deveria modificar o schema localmente.
		"""
}
