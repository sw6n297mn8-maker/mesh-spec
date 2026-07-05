package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def075: artifact_schemas.#DeferredDecision & {
	id:     "def-075"
	title:  "Resolução canônica de termos em domain stories cross-BC: glossário-de-story vs glossário-do-BC-do-work-item"
	date:   "2026-07-05"
	status: "open"

	description: """
		O #DomainStory (adr-170) carrega termRefs opcionais por work-item, com
		resolução POR CONVENÇÃO no glossário do BC daquele passo — elo FROUXO,
		sem gate de existência. Fica deferida a decisão do modelo canônico de
		resolução de termos quando a story cruza BCs: (a) resolver cada termRef
		no glossário do BC do work-item que o carrega (convenção atual, sem
		gate); (b) glossário próprio da story (novo artefato — colide com a
		arquitetura por-BC dos glossários); (c) usar o glossário-kernel
		compartilhado (adr-151) como lar dos termos que a jornada inteira
		atravessa. Glossários hoje são por-BC e refs cross-glossário são
		explicitamente não-suportadas (tq-gl-02) — qualquer gate de termo em
		story exige antes esta decisão.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: zero domain stories existem no disco — não há
		amostra de como termos se distribuem numa jornada real (quantos são
		locais do BC do passo, quantos atravessam a story inteira). Decidir o
		modelo de resolução sem instância seria especular contra tq-gl-02 e
		contra a arquitetura por-BC vigente. Custo evitado: gate de termo
		nascido errado (apontando para o lar errado) + possível artefato novo
		(glossário-de-story) sem evidência de necessidade. Custo de continuar
		deferindo: termRefs preenchidos ficam sem verificação de existência —
		typo em termo passa silencioso até a decisão; mitigado por serem
		opcionais e pela 1ª story nascer com founder review integral.
		"""

	triggerCalibrationRationale: """
		Recurrence file-content 'termRefs:' com pathScope ancorado no diretório
		das stories, threshold 2: quando >=2 stories usarem termRefs de fato, há
		amostra real de distribuição de termos para decidir (a)/(b)/(c) — o
		threshold pega o USO do elo, não a mera existência de stories.
		Manual-review adicional porque a decisão toca a arquitetura de
		glossários (por-BC + kernel adr-151), que é julgamento do founder.
		"""

	originatingArtifacts: [
		"architecture/artifact-schemas/domain-story.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			low porque termRefs são opcionais e sem gate — ausência de decisão
			não corrompe nada, apenas deixa um elo declaradamente frouxo; local
			porque o escopo é o subsistema domain-story + glossários (nenhum
			outro tipo consome termRefs). Exit: decidir (a)/(b)/(c) quando
			houver >=2 stories com termRefs reais.
			"""
	}

	triggers: [{
		kind:      "recurrence"
		pattern:   "termRefs:"
		scope:     "file-content"
		pathScope: "^strategic/domain-stories/"
		threshold: 2
	}, {
		kind:   "manual-review"
		reason: "A resolução canônica de termos cross-BC toca a arquitetura de glossários (por-BC, tq-gl-02, kernel adr-151) — decisão de modelo que pertence ao founder; o trigger automático acima só sinaliza quando a amostra real existir."
	}]
}
