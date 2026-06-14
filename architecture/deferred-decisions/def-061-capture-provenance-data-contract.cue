package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def061: artifact_schemas.#DeferredDecision & {
	id:     "def-061"
	title:  "Contrato de dado de proveniência de captura deferido à linha de evidência"
	date:   "2026-06-14"
	status: "open"

	description: """
		O contrato de dado da proveniencia de captura -- o tipo/shape que uma
		captura verificada por C2PA (foto do inspetor de campo) contribui ao
		registro de evidencia -- fica deferido. O adr-150 (item 4) ancora a
		costura captura-local -> custodia: a verificacao de integridade nasce na
		ingestao local network-independent (BD11 do DLV) e o EvidencePort
		(adr-141) custodia; mas o adr-150 NAO fixa o tipo de proveniencia. Sua
		formalizacao pertence a linha de evidencia (par de def-045 EvidencePort
		vendor e def-058 re-verificacao de integrity proofs), nao a camada de
		cliente.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: fixar o tipo de proveniencia antes de a linha de
		evidencia materializar seria especular o shape de um dado cujo consumidor
		(ingestao DLV + custodia EvidencePort) ainda nao exercita proveniencia --
		o EvidencePort em pm-dlv hoje fala EvidenceAddress / IntegrityProof /
		VerificationReceipt, nao proveniencia de captura, e a rota C2PA detalhada
		vive na ratificacao-irma do Evidence Store ainda nao trazida a governanca.
		Custo evitado: cravar campos do manifesto C2PA e o vinculo ao
		IntegrityProof antes de o design de evidencia decidir se proveniencia e
		faceta do IntegrityProof, campo separado, ou DerivedArtifact -- retrabalho
		garantido. Custo de continuar deferindo: a costura do adr-150 existe
		declarada sem o tipo formalizado (N4 do adr-150); mitigado porque nenhuma
		captura e processada antes de o pipeline de evidencia existir, e a ancora
		(verificacao local BD11, EvidencePort custodia) ja fixa ONDE a
		proveniencia vive, faltando so o QUE. Categoria distinta de def-060
		(vendor de cliente): proveniencia e dominio de evidencia, outro relogio
		(F2 do adr-150).
		"""

	triggerCalibrationRationale: """
		Diferente do def-060 (cuja resolucao nasce no frontend-runtime, repo
		futuro invisivel ao runner do mesh-spec), a proveniencia de captura e
		dominio de evidencia que materializa DENTRO do mesh-spec -- logo e
		grep-able, e a categoria permite um trigger nao-manual de verdade. (1)
		adjacent-need file-contains em contexts/dlv/domain-model.cue (o DLV e dono
		da ingestao de evidencia de inspecao, BD11 -- landing spot mais provavel
		do tipo de proveniencia da foto do inspetor) com pattern de
		proveniencia/C2PA: hoje esse arquivo nao contem o pattern (grep zero),
		entao o trigger so dispara na materializacao real; ancorar no arquivo
		ESPECIFICO do DLV (nao recurrence repo-wide) evita o falso-positivo do
		confidenceProvenance que ja existe no domain-model do REW. (2)
		manual-review backstop: o tipo pode aterrissar num schema de evidencia
		compartilhado (nao no domain-model do DLV) ou ser gated pela
		ratificacao-irma do Evidence Store, cujo path nao existe hoje -- decisao
		de design de evidencia que so o founder afere. temporal NAO se aplica: nao
		ha watchpoint datado; a proveniencia espera a linha de evidencia, nao um
		calendario de ecossistema.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-150-frontend-ai-first-invariants.cue",
		"contexts/dlv/port-manifest.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque nenhuma captura e processada antes de o pipeline de
			evidencia existir -- deferir o tipo de proveniencia nao bloqueia o
			caminho critico nem o caminho-B ja provado (que usa IntegrityProof, nao
			proveniencia de captura). cross-artifact porque o impacto se concentra
			no registro de evidencia e na ingestao do DLV + superficie do
			EvidencePort, nao no runtime inteiro nem em todos os BCs. Reversivel:
			formalizar o tipo depois e adicao, nao migracao de dado persistido (nao
			ha captura custodiada ainda).
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "contexts/dlv/domain-model.cue"
			pattern: "C2PA|[Pp]rovenan|[Pp]roveni"
		}
	}, {
		kind: "manual-review"
		reason: """
			O tipo de proveniencia pode aterrissar num schema de evidencia
			compartilhado (nao no domain-model do DLV) ou ser gated pela
			ratificacao-irma do Evidence Store, cujo path nao existe hoje na
			governanca -- decisao de design de evidencia que so o founder afere; o
			anchor file-contains cobre o caso DLV, o manual-review cobre os demais.
			"""
	}]
}
