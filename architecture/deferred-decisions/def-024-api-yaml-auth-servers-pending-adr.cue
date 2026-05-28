package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def024: artifact_schemas.#DeferredDecision & {
	id:     "def-024"
	title:  "OpenAPI security + servers nos api.yaml dos BCs, deferidos até existirem ADRs de auth e deploy"
	date:   "2026-05-28"
	status: "open"

	description: """
		OpenAPI 3.0.3 permite declarar securitySchemes + security global (auth) e
		servers[] (URLs base por ambiente). Sem ADR de auth (OAuth2/OIDC/JWT/mTLS) e
		sem ADR de deploy/transport com URLs definidas, os api.yaml dos BCs do slice
		(CMT, e futuro DLV) são autorados SEM security e SEM servers. A omissão é
		registrada como deferimento consciente (paralelo ao def-023 pra async-api).
		"""

	deferralRationale: """
		MOTIVO: nem auth nem deploy têm ADR no repo. Per tq-api-05 do PG api-spec,
		ambos inventados sem ADR falham — auth sem ADR é exposição não-decidida,
		URL sem ADR é contrato escondido. Declarar agora fixaria scheme/host
		escondidos cross-BC.
		RISCO de gatear agora: escolha aleatória de auth (Bearer vs OAuth flow vs
		mTLS) e de URL contamina os api.yaml de todos os BCs do slice; refactor
		cross-BC quando os ADRs chegarem. Custo de deferir: api.yaml não declara
		nível de segurança nem endpoint; consumidor descobre por documentação fora
		do arquivo até os ADRs existirem.
		"""

	triggerCalibrationRationale: """
		Trigger MANUAL-REVIEW pela mesma limitação técnica do def-023: as 6 kinds do
		schema #Trigger não expressam cleanly 'qualquer ADR futuro de auth/deploy
		menciona scheme/URL'. Aceito o warn de tq-def-03 deliberadamente — limitação
		técnica, não preguiça. Founder revisita api.yaml dos BCs do slice quando
		ADR de auth E/OU ADR de deploy forem mergeados (são 2 condições
		independentes; o trigger é único pelo padrão revisita-em-marco).
		"""

	originatingArtifacts: [
		"architecture/production-guides/api-spec.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			Api.yaml dos BCs com hasSyncSurface ficam sem security e sem servers até
			ADRs chegarem. Cross-cutting porque afeta todos os BCs com sync surface;
			baixo porque OpenAPI sem security/servers ainda é válido — declara
			contrato lógico de paths/operations/schemas/errors, só não fixa auth nem
			endpoint. Reversível mecanicamente quando ADRs existirem (adicionar
			securitySchemes + servers sem mudar paths nem payloads).
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "Trigger automático requer path conhecido ou pattern com >=2 ocorrências; ADRs de auth e deploy têm número e momento estratégicos imprevisíveis, e a primeira ocorrência não é capturável pelas kinds do schema #Trigger. Founder revisita os api.yaml quando autorar quaisquer um dos dois ADRs — limitação técnica documentada (paralelo ao def-023)."
	}]
}
