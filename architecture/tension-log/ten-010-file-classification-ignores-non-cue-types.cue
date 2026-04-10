package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten010: artifact_schemas.#TensionEntry & {
	id:    "ten-010"
	date:  "2026-04-09"
	title: "File classification ignora artifact types declarados com canonicalPathRegex não-.cue"
	kind:  "cross-artifact-friction"

	tensionTarget: "governance/repo-structure.cue"

	manifestsIn: "architecture/artifact-schemas/api-spec.cue"

	description: """
		O mecanismo de file classification em repo-structure.cue
		processa apenas arquivos .cue — arquivos .yaml, .json e
		outros formatos não participam do fluxo de classificação
		automática. Os schemas #OpenAPISpec e #AsyncAPISpec em
		api-spec.cue declaram canonicalPathRegex apontando para
		.yaml (api.yaml, async-api.yaml em contexts/<bc>/). Estes
		tipos são invisíveis para a classificação automática:
		não aparecem no inventário de artefatos reconhecidos
		pelo CI, nem são cobertos pelo mecanismo de
		unmatched-file warning.

		O gap não é defeito de nenhum dos dois artefatos
		individualmente — repo-structure.cue cobre todos os
		artefatos autorais .cue, e api-spec.cue declara
		corretamente os paths .yaml dos specs externos.
		A fricção está na interface entre eles: o mecanismo
		de classificação não foi desenhado para alcançar
		tipos cujo formato autoral não é .cue.
		"""

	resolution: """
		Cobertura de presença para os tipos .yaml foi delegada
		ao structural-check da convenção api-spec (WI-027 B.2,
		adr-049). Instâncias sc-cv-02 e sc-cv-03 em
		architecture/structural-checks/canvas.cue ancoram nas
		flags canvas.hasSyncSurface/hasAsyncSurface para
		enforçar presença/ausência de api.yaml e async-api.yaml.

		Isto resolve o enforcement de presença/ausência. Não
		resolve o gap de inventário/classificação automática:
		tipos .yaml continuam fora do fluxo genérico de file
		classification e do unmatched-file warning enquanto
		repo-structure.cue permanecer .cue-only.

		Trade-off aceito: presença é enforçada por
		structural-check especializado; inventário automático
		de tipos não-.cue fica fora do mecanismo genérico até
		extensão explícita do file classification — decisão
		arquitetural separada e de blast radius mais amplo.
		"""

	status: "accepted"

	structuralResolutionPath: "governance/repo-structure.cue"

	rationale: "Tensão entre mecanismo de classificação (.cue-only) e schema que declara tipos .yaml é cross-artifact-friction real, não defeito de nenhum lado. Registrar formalmente permite que agentes futuros encontrem o gap sem precisar reler self-reviews de api-spec, e ancora a decisão de que o workaround (structural-check) cobre presença mas não inventário — a extensão do mecanismo genérico de classification para formatos não-.cue é decisão separada com blast radius broader, deferida até haver segundo caso concreto ou demanda de inventário automatizado."
}
