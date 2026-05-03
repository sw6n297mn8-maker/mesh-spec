package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr061: artifact_schemas.#ADR & {
	id:    "adr-061"
	title: "Estender #ArtifactType com adopted-artifacts e readme-config — fechar gap ontológico"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		WI-067 (criar 4 validation-prompts ausentes: production-guide,
		tension-entry, adopted-artifacts, readme-config) revelou
		bloqueador estrutural análogo ao detectado em adr-047:
		#ValidationPrompt.appliesTo referencia #ValidationTargetType
		que une #ArtifactType + "self-review-report"; o enum
		#ArtifactType (declarado em quality-criteria.cue linhas 20-43)
		NÃO contém os valores "adopted-artifacts" nem "readme-config".

		Inspeção dos schemas afetados expõe gap mais profundo que a
		mecânica do prompt: ambos os schemas
		(architecture/artifact-schemas/adopted-artifacts.cue e
		architecture/artifact-schemas/readme-config.cue) já declaram
		_qualityCriteria com critérios usando as abreviações canônicas
		'aa' (tq-aa-01..07) e 'rc' (tq-rc-01..05). A infraestrutura de
		quality criteria já trata esses tipos como first-class — apenas
		o enum #ArtifactType não os reconhece. Adicionalmente, a lista
		canônica de abreviações no comment block (quality-criteria.cue
		linhas 47-54) não inclui 'aa' nem 'rc'.

		A inconsistência foi invisível enquanto não havia consumidor de
		#ArtifactType referenciando esses dois tipos. WI-067 é o
		primeiro consumidor (#ValidationPrompt.appliesTo) que força
		coerência: validation-prompt para tipo X exige X ∈
		#ArtifactType (ou na união #ValidationTargetType).

		Alternativas consideradas e rejeitadas:

		- (a) Estender apenas #ValidationTargetType (precedente:
		  "self-review-report" foi adicionado lá sem entrar em
		  #ArtifactType). Rejeitada: conserta o sintoma local mas
		  preserva a inconsistência estrutural — schemas com
		  _qualityCriteria reais cujos tipos não são reconhecidos pelo
		  enum central. Self-review-report é caso legítimo de exceção
		  (não tem _qualityCriteria próprio; herda dos universais);
		  adopted-artifacts e readme-config têm criteria type-specific
		  com abreviações já em uso. Extensão local do prompt deixaria
		  qualquer futuro consumidor de #ArtifactType (structural-check,
		  CI mapping per adr-060) repetir o mesmo bug.

		- (b) Reduzir escopo do WI-067 para os 2 prompts não-bloqueados
		  (production-guide, tension-entry) e diferir os outros 2.
		  Rejeitada: não resolve a inconsistência ontológica; deferimento
		  apenas atrasa a descoberta do mesmo bloqueador em outro
		  consumidor. Custo de extensão é mecânico baixo; custo de
		  carregar gap não-resolvido é cumulativo.

		- (c) Manter os 2 tipos fora do enum e aceitar que validation-
		  prompts para eles nunca existam. Rejeitada: viola P12
		  (governança como código) — tipos com schemas governados e
		  quality criteria type-specific são primeira-classe por
		  construção; excluí-los da enum onde a infraestrutura nasce
		  é ficção arbitrária. Também viola P0: dois lugares declaram
		  o conjunto de tipos governados (schemas existentes vs enum
		  fechado), em desacordo silencioso.

		- (d) Fork da enum em duas (#ArtifactTypeWithCriteria vs
		  #ArtifactTypeAll). Rejeitada: complexidade artificial sem
		  benefício real. O comment do enum já admite expansão
		  ('expandir quando novos tipos entrarem no regime de self-
		  review'); adopted-artifacts e readme-config já estão nesse
		  regime de fato.

		Discoverabilidade tardia do gap: ambos os schemas foram criados
		em waves anteriores (adr-050 para readme-config, primeira
		adoção cross-repo; adopted-artifacts criado no mesmo movimento)
		sem extensão concomitante de #ArtifactType. Adr-053 (production-
		guide) e adr-038 (tension-entry) seguiram pattern correto
		(extensão do enum). A diferença é arqueológica: schemas
		introduzidos via adoção cross-repo (adr-050) não passaram pela
		mesma checklist mental de schemas locais.
		"""

	decision: """
		Duas mudanças acopladas em
		architecture/artifact-schemas/quality-criteria.cue, aplicadas
		no mesmo commit que esta ADR e os 4 validation-prompts do
		WI-067:

		(1) [enum-extension] Estender #ArtifactType para incluir dois
		novos valores: 'adopted-artifacts' e 'readme-config'. Inseridos
		ao final do enum, preservando a propriedade de fechamento. Sem
		ordenação semanticamente significativa (consistente com pattern
		de adr-047).

		(2) [abbrev-extension] Estender a lista canônica de abreviações
		no comment block (linhas 47-54) para incluir 'aa (adopted-
		artifacts)' e 'rc (readme-config)'. Ambas com 2 caracteres,
		dentro do range [a-z]{2,3} permitido pelo regex de
		#QualityCriterion.id. Abreviações já em uso em
		_qualityCriteria dos schemas correspondentes — esta mudança
		registra-as canonicamente.

		Esta decisão NÃO altera shape dos schemas adopted-artifacts.cue
		ou readme-config.cue. Apenas reconhece formalmente que esses
		tipos pertencem ao enum central — fechando o gap entre
		quality-criteria type-specific (já existente) e a fonte de
		verdade do conjunto de artifact types governados.

		Esta decisão desbloqueia WI-067 para os 2 prompts dependentes
		(validate-adopted-artifacts.cue, validate-readme-config.cue)
		e qualquer consumidor futuro de #ArtifactType
		(#StructuralCheck.artifactType, CI artifact_type_for_path).
		"""

	consequences: """
		Positivas:
		- Inconsistência ontológica fechada: enum #ArtifactType passa
		  a refletir a realidade dos schemas governados.
		- WI-067 desbloqueado para os 2 prompts dependentes.
		- Pattern consistente: schemas com _qualityCriteria type-
		  specific implicam membership na enum #ArtifactType.
		- Abreviações 'aa' e 'rc' formalmente registradas no comment
		  block — fonte única de verdade para abreviações restaurada.
		- Reduz risco de descobrir o mesmo gap em consumidores futuros
		  (#StructuralCheck, CI mapping) sob pressão de scope.

		Negativas:
		- #ArtifactType cresce 24 → 26 valores. Cada novo valor amplia
		  a superfície de consistência entre quality-criteria.cue,
		  validation-prompt.cue, structural-check.cue e CI mapping
		  (artifact_type_for_path em check-self-review.sh).
		- O comment block que cataloga abreviações é texto livre — não
		  há enforcement automático de que toda abreviação usada em
		  IDs (uq|tq-XX-NN) esteja registrada. Esta ADR mantém o
		  pattern existente; gap separado para enforcement futuro
		  (eligível para tension-log se padrão de drift recorrer).
		- Consumidores existentes de #ArtifactType (structural-check
		  instances, CI mapping) NÃO recebem entradas novas
		  automaticamente. Pertinência de cobertura para adopted-
		  artifacts / readme-config é decidida caso-a-caso conforme
		  criticality + volume (per adr-060 framing forward-looking).

		Known gaps declarados (não omitidos):
		- Ausência de #StructuralCheck instances para adopted-artifacts
		  e readme-config após este commit é estado esperado, não
		  defeito. CI script artifact_type_for_path também não recebe
		  entradas novas — consistente com adr-060 (cobertura caso-a-
		  caso baseada em criticality).
		- adopted-artifacts é singleton (governance/adopted-artifacts.cue);
		  readme-config é singleton (governance/readme/config.cue).
		  Cardinality singleton não muda; apenas o reconhecimento do
		  tipo no enum.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural sobre
		nomenclatura interna de artifact types governados.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	principlesApplied: ["P0", "P1", "P12"]

	supersedes: []

	rationale: "Gap ontológico revelado por WI-067: schemas adopted-artifacts.cue e readme-config.cue declaram _qualityCriteria com abreviações canônicas (aa, rc) já em uso, mas os tipos não são membros de #ArtifactType. Inconsistência foi invisível enquanto não havia consumidor de #ArtifactType referenciando esses tipos; WI-067 (#ValidationPrompt.appliesTo) é o primeiro consumidor que força coerência. Extensão é fix do gap, não workaround local — opção (a) de estender só #ValidationTargetType foi explicitamente rejeitada pelo founder por preservar a inconsistência. Pattern consistente com adr-047 (extensão para api-specs). reversibility=high porque consumidores existentes não recebem entradas novas automaticamente; remoção é trivial enquanto não houver structural-check ou CI mapping consumindo. blastRadius=cross-artifact: toca quality-criteria.cue diretamente e desbloqueia 2 validation-prompts no mesmo commit; não propaga para BCs."
}
