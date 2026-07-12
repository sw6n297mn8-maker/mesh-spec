package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def077: artifact_schemas.#DeferredDecision & {
	id:     "def-077"
	title:  "Agregação de múltiplos identificadores legais na mesma organização (ex.: CNPJ + LEI simultâneos)"
	date:   "2026-07-12"
	status: "open"

	description: """
		O adr-173 generalizou a identidade legal para o par (esquema, valor) com
		o mínimo definitivo: cada (esquema, valor) tem exatamente UMA Identidade
		Organizacional — e nenhum vínculo entre identidades da mesma organização
		é modelado. Fica deferida a decisão de AGREGAÇÃO: quando uma organização
		real carregar 2+ identificadores simultâneos (ex.: empresa brasileira
		com br-cnpj e LEI para operar mercado financeiro internacional), o
		modelo precisa decidir (a) se as identidades permanecem desvinculadas,
		(b) se a Identidade Organizacional agrega um conjunto de identificadores
		com um primário por jurisdição, ou (c) se um vínculo leve
		(same-organization link) basta. A decisão toca unicidade, verificação
		multi-fonte e a projeção de identidade para consumidores (npm profile).
		"""

	deferralRationale: """
		MOTIVO de deferir agora: zero organizações reais registradas e zero
		casos de identificador duplo — decidir agregação sem caso especularia
		sobre qual das 3 formas o uso real pede (o mesmo erro que o adr-173
		desfez: forma decidida sem registro/caso). Custo evitado: modelar
		agregação de identidades (estrutura + invariantes + projeção) sem
		evidência. Custo de continuar deferindo: uma organização
		dual-identificador existiria como duas identidades desvinculadas até a
		decisão — aceitável porque a chave neutra (vo-participant-id) mantém a
		correlação operacional no npm, e o caso só surge com internacionalização
		ativa.
		"""

	triggerCalibrationRationale: """
		Adjacent-need file-exists sobre contexts/itc/canvas.cue: a derivação do
		BC de comércio internacional é o sinal machine-evaluable de que a
		internacionalização saiu de hipótese — o primeiro cenário em que
		identificador duplo (fiscal local + LEI) vira plausível operacionalmente.
		Manual-review porque o gatilho REAL (primeira organização com 2
		identificadores pedindo registro) é fato de negócio que só o founder
		observa — não há condição de disco para 'empresa real apareceu com LEI'.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-173-scheme-qualified-legal-identity.cue",
		"contexts/idc/domain-model.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			low porque o mínimo definitivo do adr-173 é correto para 100% dos
			casos atuais (um identificador por organização) e a correlação
			operacional vive na chave neutra do npm — nenhum fluxo quebra sem a
			agregação; local porque o escopo é o aggregate de identidade do idc
			+ a projeção de perfil do npm. Exit: decidir (a)/(b)/(c) quando o
			primeiro caso real de identificador duplo existir.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "contexts/itc/canvas.cue"
		}
	}, {
		kind:   "manual-review"
		reason: "O gatilho real é fato de negócio fora do disco (primeira organização com identificador duplo no registro); o adjacent-need acima cobre apenas o proxy de internacionalização ativa (derivação do BC itc). A forma da agregação toca invariantes de identidade — decisão de modelo do founder."
	}]
}
