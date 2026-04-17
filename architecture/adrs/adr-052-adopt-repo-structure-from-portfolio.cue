package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr052: artifact_schemas.#ADR & {
	id:    "adr-052"
	title: "Adopt #RepoStructure from tekton-spec v0.3.0 — replace local schema"
	date:  "2026-04-17"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		Mesh-spec governance/repo-structure.cue mantém schema #RepoStructure
		local desde a criação — predates qualquer promotion formal. Esse
		schema foi base do trabalho de ADR-008 em tekton-spec, que promoveu
		#RepoStructure para portfolio-wide em v0.3.0 (portfolio/artifact-schemas/
		repo-structure.cue). A promoção generaliza #PathSegments de campos
		fixos (bcRoot, domainRoot, etc.) para struct aberta — permitindo cada
		repo declarar seus próprios segmentos sem forçar vocabulário mesh-specific.

		Com #RepoStructure agora disponível portfolio-wide, manter schema local
		em mesh-spec cria duas fontes de verdade que podem divergir silenciosamente.
		Primeira cliente real (auster-spec) já adotou via governance/repo-structure.cue;
		mesh-spec adotar fecha o ciclo de promoção e estabelece consistência cross-repo.

		Alternativas consideradas:
		- Manter schema local em mesh-spec: rejeitado. Dupla fonte de verdade
		  viola P0 (única localização canônica). Qualquer evolução do schema
		  (ex.: novo sub-tipo, enforcement adicional) teria que ser sincronizada
		  manualmente entre mesh-spec e tekton.
		- Adotar em modo extended para preservar os nomes fixos atuais de
		  pathSegments: rejeitado. Schema portfolio já é superset semântico —
		  struct aberta aceita os mesmos nomes (bcRoot, domainRoot, etc.) sem
		  perder validação. Extended introduziria drift cosmético sem valor.
		- Adiar adoção até próxima wave: rejeitado. Custo da adoção cresce com
		  cada instância nova criada; melhor adotar agora que a instância
		  existente tem 315 linhas estáveis.
		"""

	decision: """
		Adotar #RepoStructure e sub-tipos (#Scope, #PathSegments, #ResponsibilityBoundary,
		#DerivedArtifact, #DerivedArtifacts, #FileClassificationCategory,
		#FileClassificationPolicy, #FileClassification, #ValidationPhase,
		#ImplementationGuidance, #Validation, #Tooling) verbatim de tekton-spec v0.3.0
		para architecture/artifact-schemas/repo-structure.cue.

		Padrão idêntico a ADR-050 (#ReadmeConfig):
		- architecture/artifact-schemas/repo-structure.cue: cópia verbatim com
		  hash registrado em adopted-artifacts.cue.
		- governance/repo-structure.cue: instância autoral preservada; schema
		  local removido, import do schema adotado adicionado.

		A instância atual (315 linhas em governance/repo-structure.cue) permanece
		intacta em conteúdo — apenas o schema muda de fonte. #PathSegments passa
		de struct com campos fixos (bcRoot, bcCodePattern, domainRoot, strategicRoot,
		archRoot, governanceRoot, aiRoot) para struct aberta aceitando os mesmos
		nomes como keys de {[string]: string} + rationale.

		Sequenciamento em tasks M-01..M-05 do adoption-plan de tekton:
		(M-01) Copiar schema verbatim para architecture/artifact-schemas/
		(M-02) Esta ADR
		(M-03) Entry em adopted-artifacts.cue
		(M-04) Migrar governance/repo-structure.cue — remover schema local,
		       importar portfolio; instância (valores) permanece
		(M-05) Validar cue vet + check-readme-coevolution.sh + check-self-review.sh
		"""

	consequences: """
		Positivas:
		(1) P0 honrado: única fonte de verdade para #RepoStructure no portfolio.
		(2) Fechamento do ciclo de promoção iniciado por ADR-008 de tekton —
		    mesh-spec, autor original do schema, passa a ser consumer.
		(3) Consistência cross-repo: mesh-spec e auster-spec validam instâncias
		    de #RepoStructure contra o mesmo shape portfolio-wide.
		(4) Futuras evoluções do schema (adicionar #Tooling fields, novos
		    sub-tipos) beneficiam mesh-spec automaticamente via nova adoção.

		Negativas:
		(1) Primeira mudança em tipo estrutural amplamente referenciado — 6+
		    schemas referenciam sub-tipos diretamente. Mitigado: schema adotado
		    é equivalente semântico; nomes dos sub-tipos preservados.
		(2) #PathSegments de campos fixos → struct aberta perde documentação
		    inline dos campos esperados. Mitigado: production guide e instância
		    atual servem de referência.
		(3) Cria dependência formal mesh→tekton em #RepoStructure. Semver de
		    tekton-spec passa a afetar mesh-spec nesta dimensão adicional.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"architecture/artifact-schemas/repo-structure.cue",
		"governance/adopted-artifacts.cue",
		"governance/repo-structure.cue",
	]

	principlesApplied: [
		"P0",
		"P1",
	]

	rationale: """
		P0 (uma localização canônica) é o driver central — dupla fonte de
		verdade entre schema local e portfolio-wide é drift por construção.
		P1 (schemas CUE como SoT) cobre a adoção formal com hash rastreado em
		adopted-artifacts.cue. Reversibility medium: reverter exige restaurar
		schema local (arquivo preservado no git) e remover import — mecanicamente
		simples, mas regressivo. Blast radius repo-wide porque #RepoStructure
		governa escopo de todo CI do repo. Padrão idêntico a ADR-050 (primeira
		adoção cross-repo de mesh-spec) — reusa o pattern já validado.
		"""
}
