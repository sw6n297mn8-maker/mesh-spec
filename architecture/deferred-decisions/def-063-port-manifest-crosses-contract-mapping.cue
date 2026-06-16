package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// def-063 -- Defere o trigger port-manifest do G2 (cruza-contrato) do gate
// first-class-traceability (adr-153). Gêmeo do deferimento de assertion (def-049):
// ambos são triggers de "cruza contrato" (adr-151 §1) cuja cobertura depende de algo
// ainda não-materializado de forma determinística. Governar a assertion (def-049) e
// deixar a port-manifest em prose seria assimetria/drift; def-063 iguala o tratamento.

def063: artifact_schemas.#DeferredDecision & {
	id:     "def-063"
	title:  "Trigger port-manifest do G2 (first-class-traceability) deferido até mapeamento determinístico value-class→vo"
	date:   "2026-06-16"
	status: "open"

	description: """
		O adr-151 (§1) define "cruza contrato" por membership em port-manifest, assertion
		ou aggregate-manifest. A V1 do gate first-class-traceability (adr-153) cobre só
		aggregate-manifest. O trigger port-manifest fica FORA da V1: o port-manifest lista
		value-class CANÔNICAS (StreamId, AppendResult — grafia mesh-runtime, rtd-004), não
		vo- codes do domain-model. Não há mapeamento determinístico value-class-canônica →
		vo-code; o evaluator não pode incluir port-manifest sem inventar correspondência.
		"""

	deferralRationale: """
		Cobrir port-manifest agora exigiria mapear value-class canônicas a vo- codes por
		APROXIMAÇÃO de nome — fuzzy, frágil, gerador de falso-positivo/negativo. Isso
		violaria P10/norm()-exato (o gate é determinístico: igualdade exata + pertinência
		de conjunto, zero heurística) e introduziria exatamente a categoria de erro que a
		falsificationCondition do adr-153 condena (o gate dando falsa confiança). Custo
		evitado: um vetor de erro no próprio gate. Custo de continuar deferindo: baixo — o
		aggregate-manifest já cobre a fronteira de commands/events/aggregates dos 4 BCs com
		manifest; o port-manifest adiciona a superfície de Port, hoje canon-namespace, não
		domain-concept. Deferir preserva o determinismo do gate até existir ponte real
		value-class→concept.
		"""

	triggerCalibrationRationale: """
		Manual-review por necessidade, não preguiça: o mecanismo de mapeamento
		determinístico (um campo de correspondência explícito value-class→vo, no
		#PortManifest ou no domain-model) ainda NÃO existe — sua forma (nome/localização do
		campo) é indefinida. Um trigger automático (file-contains) teria de adivinhar o
		pattern do campo futuro e erraria se a forma divergisse. A revisita ancora no
		MECANISMO, não em data solta. Mesma forma de def-049 (assertion) e def-062
		(forma-distinta), cujas condições também são não-auto-detectáveis até o mecanismo
		existir.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-153-add-first-class-traceability-kind.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			Enquanto deferido, o G2 cobre a fronteira via aggregate-manifest (commands/
			events/aggregates dos 4 BCs com manifest), mas não a superfície de Port. Um
			conceito que cruzasse contrato SÓ via port-manifest (sem aparecer em
			aggregate-manifest) escaparia ao G2 — hoje improvável (a superfície de Port é
			value-class canon, não domain-concept), por isso severity low; cross-artifact
			porque toca gate + port-manifest + domain-model.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Revisar quando uma ponte determinística value-class-canônica→vo-code for
			desenhada (campo de correspondência explícito em #PortManifest ou #DomainModel)
			— então o trigger port-manifest do G2 entra no evaluator. Manual porque a forma
			do mecanismo é indefinida hoje; nenhum pattern auto-detectável existe sem
			adivinhar o campo futuro.
			"""
	}]
}
