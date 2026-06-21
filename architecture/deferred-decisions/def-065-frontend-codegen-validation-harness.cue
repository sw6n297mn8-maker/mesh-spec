package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def065: artifact_schemas.#DeferredDecision & {
	id:     "def-065"
	title:  "Codegen-validation harness e write-back de evidência do frontend-runtime"
	date:   "2026-06-21"
	status: "open"

	description: """
		Fica deferido ESTABELECER o harness de codegen-validation + o write-back de evidência
		spec-side do frontend-runtime — o mecanismo pelo qual o 1º golden-example do frontend
		produz a evidência (análoga a governance/build-time/codegen-validation-evidence.cue) que
		CARREGA o flip proposed→accepted do adr-158 e do frontend-codegen-contract.cue. Inclui o
		harness que roda o pipeline gerar+compilar+testar da superfície FCE, e o write-back gated
		da evidência ao mesh-spec (precedente: o do mesh-runtime, adr-148 item 8 + WI-137).
		"""

	deferralRationale: """
		NÃO há decisão de design a tomar — o padrão é PROVADO: o codegen-validation-evidence.cue
		do mesh-runtime emergiu do WI-137 (trabalho de golden-example) e foi escrito de volta gated
		(adr-148 item 8), carregando o flip proposed→accepted do adr-140/codegen-contract no run-001.
		Há TRABALHO a registrar com dono e trigger. O adr-157 (handoff do frontend) ficou SILENCIOSO
		sobre harness/validation/write-back — porque o adr-158 (o contrato de codegen) não existia
		quando o adr-157 foi escrito; o mesh-runtime ganhou esse mecanismo do adr-148 item 8 + WI-137,
		e o frontend não tem o análogo. Custo evitado por deferir agora: construir o harness antes de
		o frontend-runtime existir é trabalho contra um repo inexistente — emerge no bootstrap do
		frontend, como o do mesh-runtime emergiu do seu. Custo de continuar deferindo: baixo, EXCETO o
		risco de INVISIBILIDADE — sem este def, o flip do adr-158 dependeria de um artefato de evidência
		que ninguém registrou criar (dependência sem dono). Este def a torna rastreável: dono (o bootstrap
		do frontend-runtime autorizado pelo adr-157) + trigger (o nascimento do runtime).
		"""

	triggerCalibrationRationale: """
		O harness é PREREQUISITE do flip e materializa no MESMO momento — o bootstrap/1º golden-example
		do frontend-runtime —, mas ANTES do flip (o harness PRODUZ a evidência que o flip consome). Por
		isso o trigger NÃO é o flip do contrato (sinal de def-064, que dispara tarde demais, quando o
		contrato já flipou): é o nascimento do frontend-runtime, evento de repo FUTURO E EXTERNO,
		invisível ao runner determinístico do mesh-spec (mesma lição de def-060/def-043 — âncora no
		nascimento de outro repo não é grep-ável). Daí manual-review: o founder revisita quando o
		frontend-runtime bootstrar, para estabelecer o harness + write-back (como o adr-148 item 8 +
		WI-137 fizeram para o mesh-runtime). Não há sinal mesh-spec-local mais cedo que o flip.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-158-frontend-codegen-contract.cue",
		"architecture/adrs/adr-157-frontend-runtime-bootstrap-handoff.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque o flip do adr-158 é downstream (o frontend-runtime não existe) e o harness emerge
			no bootstrap do runtime, como o do mesh-runtime emergiu do WI-137 — deferir não bloqueia
			caminho crítico; o único risco é a INVISIBILIDADE da dependência, que ESTE def remove ao
			registrá-la. cross-artifact porque o harness + a evidência + o flip se concentram na relação
			de codegen do frontend (o contrato + adr-158 + o CI do frontend-runtime), um conjunto
			delimitado num domínio, não múltiplos domínios. Reversível: estabelecer o harness depois não
			muda contrato nem dado persistido.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O nascimento/bootstrap do frontend-runtime — quando o harness é necessário — é evento de repo futuro e externo, invisível ao runner do mesh-spec (mesma lição de def-060/def-043). O founder revisita ao bootstrar o frontend-runtime para estabelecer o harness + write-back gated; não há sinal mesh-spec-local mais cedo que o flip (e o flip seria tarde demais, pois o harness o precede)."
	}]
}
