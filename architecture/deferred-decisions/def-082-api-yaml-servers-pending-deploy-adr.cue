package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def082: artifact_schemas.#DeferredDecision & {
	id:     "def-082"
	title:  "OpenAPI servers nos api.yaml dos BCs, deferido até o ADR de deploy — a metade que sobrevive ao split do def-024"
	date:   "2026-07-29"
	status: "open"

	description: """
		O def-024 deferia DUAS metades independentes: security (aguardando
		ADR de auth) e servers[] (aguardando ADR de deploy com URLs
		definidas). O adr-182 resolveu a metade auth (modelo de identidade
		e ator + postura de borda: securitySchemes bearer abstrato
		declarável por fatia mecânica). Esta entry carrega a metade
		RESTANTE com escopo limpo: os api.yaml dos BCs seguem SEM servers[]
		até existir ADR de deploy/transport com URLs decididas — URL sem
		ADR é contrato escondido (per tq-api-05 do PG api-spec, o mesmo
		fundamento do def-024).
		"""

	deferralRationale: """
		MOTIVO: o ADR de deploy não existe; declarar servers agora fixaria
		host/ambiente escondidos cross-BC — a mesma classe de risco que o
		def-024 registrou (escolha aleatória contamina os api.yaml de todos
		os BCs com sync surface; refactor cross-BC quando o ADR chegar).
		Custo de deferir: api.yaml não declara endpoint; consumidor
		descobre por documentação fora do arquivo até o ADR existir —
		herdado do def-024 sem mudança de posto. O SPLIT em def novo (em
		vez de manter o def-024 aberto com escopo amputado) mantém o
		lifecycle limpo: def-024 resolve com resolvedBy rastreável ao
		adr-182; esta entry nasce com escopo exato do que resta.
		"""

	triggerCalibrationRationale: """
		Manual-review pela MESMA limitação técnica documentada no def-024 e
		no def-023: as kinds do schema #Trigger não expressam 'qualquer ADR
		futuro de deploy menciona URLs' — número e momento do ADR de deploy
		são estratégicos e imprevisíveis; a primeira ocorrência não é
		capturável por predicado livre de falso-positivo. Founder revisita
		os api.yaml quando autorar o ADR de deploy — limitação técnica, não
		preguiça (tq-def-03 warn aceito deliberadamente, herança do
		def-024).
		"""

	originatingArtifacts: [
		"architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue",
		"architecture/adrs/adr-182-identity-and-actor-model.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			Herdado do def-024 sem mudança de posto: low porque OpenAPI sem
			servers é válido — o contrato lógico (paths/operations/schemas/
			errors, e agora security bearer per adr-182) está declarado; só o
			endpoint não está fixado. Cross-cutting porque afeta todos os BCs
			com sync surface. Reversível mecanicamente quando o ADR de deploy
			existir (adicionar servers[] sem mudar paths nem payloads). Exit:
			ADR de deploy decidido → fatia mecânica adiciona servers[] aos
			api.yaml e esta entry resolve com resolvedBy.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Trigger automático exigiria capturar 'o primeiro ADR de deploy' — número e momento imprevisíveis, sem path conhecido nem pattern com ≥2 ocorrências; mesma limitação documentada em def-023/def-024. Founder revisita os api.yaml ao autorar o ADR de deploy."
	}]
}
