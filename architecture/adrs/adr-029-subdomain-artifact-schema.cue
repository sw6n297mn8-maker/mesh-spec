package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr029: artifact_schemas.#ADR & {
	id:    "adr-029"
	title: "Subdomain artifact schema — estrutura formal de declaração de subdomínios"
	date:  "2026-03-24"

	decisionClass: "structural"
	decider:       "founder"
	status:        "superseded"
	supersededBy:  "adr-030"

	context: """
		Subdomínios são referenciados implicitamente via classification no
		canvas.cue de cada BC, mas não existe artefato próprio para declarar
		um subdomínio como entidade de modelagem estratégica. Sem schema
		formal, a decomposição do domínio em subdomínios é convenção — não
		há validação CI de contorno, delegação entre subdomínios, nem
		rastreabilidade de classificação. A alternativa — manter classificação
		apenas no canvas — foi rejeitada porque canvas é artefato de Bounded
		Context, não de subdomínio: mistura níveis de abstração e impede
		governança independente da decomposição estratégica.
		"""

	decision: """
		Criar architecture/artifact-schemas/subdomain.cue com #Subdomain
		definindo: code (lowercase, match com filename), name, type
		(reutiliza #BCClassification de canvas.cue para vocabulário
		unificado), purpose, negativeBoundaries ([#NegativeBoundary] com
		responsibility + delegatedTo + rationale para delegação rastreável),
		lifecycle (união discriminada active/deprecated com supersededBy
		obrigatório em deprecated), strategicProfile (opcional por default,
		exigido para core-subdomain via critério tq-sd-03). Adicionar
		"subdomain" a #ArtifactType em quality-criteria.cue. Quality
		criteria com prefixo tq-sd-NN cobrindo identidade (code ↔ filename),
		contorno (purpose, negativeBoundaries), classificação
		(strategicProfile condicional) e coerência cross-artifact (canvas).
		"""

	consequences: """
		Positivas: CI pode validar conformidade de declarações de subdomínio;
		negativeBoundaries com delegatário concreto permitem verificação
		cross-subdomain de fronteiras; lifecycle com união discriminada
		garante rastreabilidade de deprecação; reutilização de
		#BCClassification unifica vocabulário estratégico entre subdomain
		e canvas. Negativas: novo tipo de artefato a ser instanciado ao
		declarar subdomínios — custo aceitável dado que nenhum subdomínio
		foi formalmente declarado ainda.
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/subdomain.cue",
		"architecture/artifact-schemas/quality-criteria.cue",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: """
		Subdomínios são o nível de decomposição estratégica do domínio —
		governam decisões de investimento, classificação competitiva e
		delegação de responsabilidades entre contextos. Schema formal
		estende P0 (single source of truth para contorno e classificação)
		e P12 (validação por CI, não por memória). negativeBoundaries com
		#NegativeBoundary (responsibility + delegatedTo + rationale)
		garante que fronteiras negativas sejam rastreáveis e verificáveis,
		não apenas declarativas. Reutilização de #BCClassification evita
		divergência semântica entre subdomain.type e canvas.classification.
		"""
}
