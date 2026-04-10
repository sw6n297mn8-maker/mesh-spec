package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

structuralCheck: build_time.#SelfReviewReport & {
	reportId: "srr-structural-check"

	artifactPath:       "architecture/artifact-schemas/structural-check.cue"
	artifactSchemaPath: "architecture/artifact-schemas/artifact-schema.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-04-07"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Avaliação executada por sub-agente isolado conforme
			executionPolicy.rollout em quality-gate.cue (artifact-schema
			usa modo isolated-subagent). Sub-agente recebeu o conteúdo
			completo do artefato proposto (criação de
			architecture/artifact-schemas/structural-check.cue) e da
			edição complementar em
			architecture/artifact-schemas/quality-criteria.cue
			(adicionar "structural-check" ao enum #ArtifactType e
			"sc" às abreviações canônicas), além de paths para
			leitura do meta-schema artifact-schema.cue, do
			quality-gate.cue (universalCriteria), e de
			design-principles.cue (P10, P12) como referências
			obrigatórias.

			Avaliação contra 11 critérios (8 universais + 3 type-specific
			de #ArtifactSchema):

			uq-01 (rationale=WHY): rationales no _schema.location, em
			cada criterion (tq-sc-01/02/03), e no conjunto _qualityCriteria
			explicam por que existem, não o que fazem. tq-sc-01 rationale:
			"mensagem genérica derrota o propósito do gate determinístico".
			Pass.

			uq-02 (Mesh-specific): substitution test "Mesh → qualquer
			fintech" falha porque o artefato é infraestrutura específica
			do regime de governança Mesh — referencia adr-040/041, vc-cv-03,
			os três kinds desenhados para o pipeline de validação Mesh,
			e a fronteira P10 entre estocástico e determinístico. Pass.

			uq-03 (referências cruzadas existem): adr-040 e adr-041
			existem em paths declarados nos comentários; quality-criteria.cue
			(que define #ArtifactType e #QualityCriteria) existe e o
			schema o consome via package; a edição complementar adiciona
			"structural-check" ao enum, fechando a referência usada em
			artifactType: #ArtifactType. vc-cv-03 está apenas no rationale
			como caso histórico, não como id de artefato — uso legítimo.
			Pass.

			uq-04 (consistência com princípios): coerente com P10 (gate
			determinístico separado de recomendação estocástica — schema
			declarativo proíbe rule como snippet executável, mantendo a
			fronteira) e P12 (governança como código — regras vivem em
			CUE versionado). Coerente com P0 (canonicalPathRegex declara
			localização única). Pass.

			uq-05 (limitações declaradas): comentário de cabeçalho declara
			explicitamente "Cross-artifact reference checking, cardinalidade
			genérica, regex matching e demais checks estão explicitamente
			fora da v1; serão adicionados organicamente quando casos
			concretos justificarem". Comentários do #ReferenceExistsRule
			e #SameArtifactConsistencyRule reforçam o escopo. Pass.

			uq-06 (ubiquitous language): termos consistentes — kind,
			rule, blockName, sourcePath, refNamespace, gate, structural,
			determinístico. Coerente com mech-agent-gate de
			domain-definition.cue e P10. Sem mistura de sinônimos. Pass.

			uq-07 (zero placeholder): nenhum TODO/TBD/a-definir. Cada
			campo elaborado. Pass.

			uq-08 (conforma com schema): o artefato é um artifact-schema
			e tem _schema.location preenchido com canonicalPathRegex,
			fileNameRegex, description, rationale, cardinality e
			allowNested. _qualityCriteria está aninhado dentro de
			_#StructuralCheckBase (mesmo padrão de adr.cue, evitando
			colisão top-level entre arquivos do package). #QualityCriterion
			ids "tq-sc-01/02/03" satisfazem o regex
			^(uq|tq-[a-z]{2,3})-[0-9]{2}$ (sc tem 2 letras). Pass.

			tq-as-01 (declara localização canônica): _schema.location
			declara canonicalPathRegex
			(^architecture/structural-checks/[a-z0-9-]+\\.cue$),
			fileNameRegex, description, rationale e cardinality
			(collection). allowNested: false presente. Pass.

			tq-as-02 (critérios type-specific acionáveis): cada criterion
			test é concreto. tq-sc-01 dá exemplos negativos ("regra
			falhou", "check falhou") e exige referência a elemento
			específico (blockName, sourcePath, refNamespace). tq-sc-02
			testa shape de união discriminada com critério verificável.
			tq-sc-03 exige referência a caso ou princípio e exclui
			tautologia. Pass.

			tq-as-03 (rationale do conjunto explica cobertura): o
			rationale de _qualityCriteria explica que os três critérios
			cobrem três aspectos do contrato v1 (acionabilidade do erro,
			conformidade da união discriminada por kind, justificabilidade
			da regra) e ancora a cobertura em adr-041. Não é repetição
			dos rationales individuais. Pass.

			Cinco observações adicionais reportadas pelo sub-agente
			(todas confirmando intencionalidade, nenhuma é finding):
			(1) id-regex permite ids longos como sc-canvas-01 — flexibilidade
			explicada no comentário, coerente com instrução do founder
			de não acoplar a abreviações curtas para sempre; (2)
			_qualityCriteria aninhado em _#StructuralCheckBase (definição
			privada) é o padrão coerente com adr.cue; (3) campo kind
			aparece declarado e re-restringido na união — padrão CUE de
			discriminated union, comentário sinaliza intenção; (4) edição
			em quality-criteria.cue é mecânica e coerente; (5) diretório
			architecture/structural-checks/ ainda não existe e isso é
			esperado — instâncias serão criadas em commits subsequentes.
			"""
	}]

	findings: {}

	summary: """
		structural-check.cue cria o tipo #StructuralCheck conforme
		shape decidido em adr-041 (v1) e estendido por adr-049:
		8 campos no base, união discriminada por kind com 4 shapes
		de rule (#RequiredBlockRule, #ReferenceExistsRule restrito a
		referências internas, #SameArtifactConsistencyRule,
		#ConditionalFilePresenceRule adicionado por adr-049), sem
		campo severity (sempre fail), _schema.location declarando
		architecture/structural-checks/ como path canônico das
		instâncias, e _qualityCriteria próprio (tq-sc-01/02/03)
		cobrindo acionabilidade de errorMessage, conformidade da
		união discriminada e justificabilidade do rationale.
		Acompanhada de edição em quality-criteria.cue que adiciona
		"structural-check" ao enum #ArtifactType e "sc" às
		abreviações canônicas. Estável em 1 round — todos os 11
		critérios passam, zero findings, cinco observações de design
		confirmando intencionalidade. Nota: este self-review cobre
		a criação v1; a extensão adr-049 é coberta pelo self-review
		de adr-049.
		"""

	singleRoundRationale: """
		Schema foi moldado por diálogo iterativo com founder antes
		do drafting. Founder revisou o conteúdo proposto e aplicou
		3 ajustes específicos antes desta avaliação: (1) id-regex
		mudado de ^sc-[a-z]{2,3}-[0-9]{2}$ para
		^sc-[a-z0-9-]+-[0-9]{2}$ para não acoplar a abreviações
		curtas para sempre; (2) tq-sc-02 reescrito de "campos extras
		espúrios" para "rule usa exclusivamente o shape permitido
		para o kind declarado, sem campos incompatíveis com a rule
		correspondente"; (3) comentário explícito sobre a convenção
		de _schema.location descrever onde vivem instâncias, não a
		definição do tipo. Sub-agente isolado avaliou o conteúdo
		corrigido sem acesso ao histórico de diálogo, leu o
		meta-schema artifact-schema.cue, quality-gate.cue,
		design-principles.cue e quality-criteria.cue diretamente,
		e produziu veredito ESTÁVEL com zero findings. Critérios
		são objetivamente verificáveis por inspection direta —
		conformance ao meta-schema é estrutural; acionabilidade
		dos critérios type-specific é verificável pelos testes
		concretos; cobertura do rationale é verificável pelo texto.
		Não houve ambiguidade pendente que justificasse round
		adicional.
		"""
}
