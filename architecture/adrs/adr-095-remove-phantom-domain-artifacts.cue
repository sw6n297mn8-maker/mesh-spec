package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr095: artifact_schemas.#ADR & {
	id:    "adr-095"
	title: "Remover phantoms universal-glossary e business-model do config (D2/D3) — passo ii do cutover adr-090"
	date:  "2026-05-25"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		adr-090 componente (8) — D2/D3: universal-glossary.cue e business-model.cue
		são declarados-e-ausentes (phantoms) na árvore autoral do
		governance/readme/config.cue; o default decidido é tratá-los como MORTOS
		(removidos do config autoral), salvo evidência explícita no wave-plan de
		que estão planejados.

		Verificação factual: domain/ contém apenas domain-definition.cue,
		stakeholder-map.cue e .gitkeep — nenhum dos dois phantoms existe. O
		wave-plan.cue (2006 linhas) tem ZERO ocorrências de ambos: nenhum WI os
		cria (outputs[type=create]). Logo, aplica-se o default dead-by-default.

		As referências phantom aparecem em 5 pontos do config.cue: 1 nas
		conventions do nó tree de domain/ (+ 1 menção em prosa no purpose) e 4 em
		sections (tabela de níveis N1/N5, prosa de nomenclatura, ordem de bootstrap).
		Todas se materializam no README.md derivado.
		"""

	decision: """
		Remover as referências autorais a universal-glossary.cue e
		business-model.cue do governance/readme/config.cue (6 edições cirúrgicas:
		purpose + convention do nó domain/; tabela N1; tabela N5; prosa de
		nomenclatura; ordem de bootstrap) e REGENERAR o README.md derivado no mesmo
		commit (cue export ./governance/readme -e output --out text), para que o
		derivado não minta enquanto a fonte é corrigida.

		Escopo estrito aos DOIS phantoms nomeados em D2/D3. O drift adjacente de
		ubiquitous-language.cue (referenciado no config, mas o arquivo real por BC
		é glossary.cue) é drift de NAMING, fora do D2/D3, e fica preservado aqui —
		será tratado em achado/decisão separada.
		"""

	consequences: """
		Positivas: (1) o config para de afirmar 2 artefatos inexistentes — P0 puro,
		remove duplicação/afirmação falsa na fonte; (2) o README derivado fica
		sincronizado (sem phantom) no mesmo commit; (3) pré-requisito do passo (iii)
		cumprido: o gerador do índice derivado não ressuscitará phantoms removidos.

		Negativas / limites: (1) não altera contagem de unmatched (phantoms não são
		arquivos; nunca foram classificados); (2) readme-coevolution não é gate
		wired — a sincronização README↔config aqui é feita por disciplina, não
		imposta por CI; (3) ubiquitous-language permanece como drift conhecido
		(decisão separada).
		"""

	reversibility: "high"
	blastRadius:   "local"

	affectedArtifacts: [
		"governance/readme/config.cue",
		"README.md",
	]

	defersTo: []
	principlesApplied: ["P0 — zero duplicação; uma localização canônica, sem afirmar artefato inexistente", "P12 — governança como código"]

	rationale: """
		Materializa o passo (ii) / D2/D3 do cutover adr-090. O default
		dead-by-default foi confirmado factualmente (arquivos ausentes + zero WI no
		wave-plan), então removo sem marcar plannedIn. Regenerar o README no mesmo
		commit é exigência de coerência: corrigir o config e deixar o derivado
		mentindo seria recriar o exato drift que estamos eliminando. reversibility
		high (edições de texto reversíveis, sem dados persistidos); blastRadius
		local (config + seu derivado). decisionClass structural porque ajusta o
		mapa estrutural autoral do repositório.
		"""
}
