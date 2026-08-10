package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten017: artifact_schemas.#TensionEntry & {
	id:    "ten-017"
	date:  "2026-08-10"
	title: "Gate declarado blocking sem caminho verificável até um required check é apenas advisory"

	kind: "axiom-tension"

	tensionTarget: "P12"
	manifestsIn:   "architecture/adrs/adr-189-activate-verifier-registry-governed-mutation.cue"

	description: """
		P12 exige que toda regra que importa seja imposta automaticamente —
		fitness functions/gates no CI, não documentação. adr-189 decisão 5
		declara os dentes causais do Verifier Registry "blocking no caminho
		obrigatório". Ao materializar CI-1 descobriu-se empiricamente que
		"blocking-for-merge" no repo é governado EXCLUSIVAMENTE pela lista
		FIXA required_status_checks do ruleset main-protection — antes de CI-1,
		apenas {cue-validate, ci-liveness}. Um workflow dedicado (verifier-
		registry-check e, do mesmo modo, os pré-existentes self-review-check,
		deferred-trigger-check, phantom-gate) RODA e fica vermelho em violação,
		mas NÃO bloqueia merge enquanto seu context não estiver nessa lista.
		Logo "declarar um gate blocking" (nome do workflow, intenção do ADR,
		header de artefato) NÃO o torna bloqueante: sem vínculo verificável até
		um required check, o gate é advisory, independentemente do nome ou da
		intenção. A regra geral: um gate declarado blocking precisa possuir
		caminho verificável até um required check de merge.
		"""

	resolution: """
		Aceito conviver com a tensão sob resolução PARCIAL e explícita, não
		silenciosa. Para verifier-registry-check: decisão A do founder — seu
		context observado (verifier-registry-check, o nome do job como aparece
		no PR) foi adicionado ao required_status_checks do main-protection;
		VERIFICADO via API (ruleset updated_at 2026-08-10T17:15Z; lista agora
		{cue-validate, ci-liveness, verifier-registry-check}), então o dente é
		required-for-merge de fato e adr-189 decisão 5 fica satisfeita para
		este slice. Para os gates de enforcement PRÉ-EXISTENTES (self-review-
		check, deferred-trigger-check, phantom-gate): NÃO alterados dentro de
		CI-1 — mudar a política global de required-checks ali inflaria o blast
		radius de "materializar adr-189" para "reformular o enforcement do
		repo". Ficam para avaliação um-a-um, decidindo quais devem de fato ser
		blocking e wired ao ruleset. Por isso status open.
		"""

	status: "open"

	structuralResolutionPath: """
		Cada gate declarado blocking tem seu context adicionado ao
		required_status_checks do ruleset de branch-protection (main-
		protection), com verificação por leitura de que entrou. Mecanismo
		candidato futuro: um check determinístico que valide a correspondência
		"workflow declarado blocking ⇒ context na lista required" — fechando o
		gap por construção em vez de por disciplina.
		"""

	relatedADR: "adr-189"

	rationale: """
		Sem registro, o gap "enforcement declarado ≠ enforçado" fica disperso
		em intenções de workflow e some entre sessões; agentes stateless
		reassumem "workflow existe = blocking", que é falso sob o ruleset
		atual. A entry externaliza a regra e a fila de avaliação por-gate.
		"""
}
