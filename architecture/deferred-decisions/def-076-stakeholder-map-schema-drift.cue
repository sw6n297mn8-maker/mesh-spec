package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def076: artifact_schemas.#DeferredDecision & {
	id:     "def-076"
	title:  "Crack do stakeholder-map: instância não unifica com o schema evoluído; re-autoria na forma nova é decisão de conteúdo do founder"
	date:   "2026-07-05"
	status:     "resolved" // decisão do founder 2026-07-29: re-autoria consumada no WI-157 (exit completo num movimento só: instância re-unificada + sc-sm-01..03 + isenção do meta-coverage removida; categoria do sh-06 per adr-181)
	resolvedBy: "architecture/adrs/adr-181-extend-stakeholder-category-adversarial-actor-class.cue"

	description: """
		domain/stakeholder-map.cue (6 stakeholders sh-01..sh-06) usa a shape
		ANTIGA (type/role/influence/concerns/interactsWith) e NÃO importa nem
		unifica com o #StakeholderMap atual (category/platformRelationships/
		interests/painPoints/incentiveProfile) — passa cue vet sem ser validada.
		O silêncio tem três camadas: (1) a instância não aplica o schema;
		(2) os 7 tq-sm-* do schema dizem 'Validação por runner' e NENHUM
		structural-check os implementa; (3) a isenção do meta-coverage para
		stakeholder-map está duplamente stale — cita os campos da shape antiga
		('code/name/type/description/role') e alega proteção 'shape via cue
		vet' que não existe. A migração NÃO é mecânica (veredito do Tempo 1,
		2026-07-05): 4 campos antigos sem destino (role/meshInteraction/
		influence/interactsWith), 18 concerns exigindo decisão interests-vs-
		painPoints + costRef, campos novos obrigatórios a inventar
		(manipulationVectors, platformRelationships), e sh-06 (adversário,
		actor-class) NÃO cabe em nenhuma das 6 categorias do enum novo.
		Fica deferida a RE-AUTORIA do stakeholder-map na forma nova — decisão
		de conteúdo de negócio (dores→custos ce-*, vetores de manipulação,
		categoria do adversário) que pertence ao founder.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: a re-autoria exige conteúdo semântico novo que
		o agente não pode inventar (dp-08: vetores de manipulação por
		stakeholder; mapeamento concerns→ce-01..07; categoria de sh-06 —
		possivelmente extensão do enum via ADR). Forçar a migração mecânica
		descartaria 4 campos de informação ou fabricaria semântica — os dois
		proibidos. O elo ator↔story NÃO fica bloqueado: sc-ds-01 lê
		stakeholders[].code via export, campo presente nas duas shapes (a ponte
		verificada no Tempo 1). Custo evitado: stakeholder-map fabricado por
		agente. Custo de continuar: a instância segue não-validada contra o
		schema (drift silencioso conhecido e agora REGISTRADO), e a isenção
		stale do meta-coverage segue alegando proteção fictícia até a
		re-autoria corrigir as três camadas.
		"""

	triggerCalibrationRationale: """
		Adjacent-need file-exists sobre architecture/structural-checks/
		stakeholder-map.cue: quando alguém materializar os checks tq-sm-* como
		structural-checks (a camada 2 do silêncio fechando), este def DEVE ser
		revisitado no mesmo movimento — checks contra a shape nova exigem a
		instância migrada. Manual-review porque a re-autoria em si é decisão de
		conteúdo do founder, não condição machine-evaluable.
		"""

	originatingArtifacts: [
		"domain/stakeholder-map.cue",
		"architecture/artifact-schemas/stakeholder-map.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "local"
		description: """
			medium porque um artefato canônico de domain/ está fora de
			validação contra o próprio schema — precedente ruim, ainda que o
			conteúdo esteja estável desde a criação; local porque os
			consumidores do mapa (canvas stakeholderRef, sc-ds-01) leem
			stakeholders[].code, presente nas duas shapes — nenhum elo
			downstream quebra enquanto o drift persistir. Exit: re-autoria na
			forma nova (com decisão sh-06) + checks tq-sm-* + isenção do
			meta-coverage corrigida, num movimento só.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "architecture/structural-checks/stakeholder-map.cue"
		}
	}, {
		kind:   "manual-review"
		reason: "A re-autoria exige conteúdo de negócio que só o founder decide (manipulationVectors per dp-08, concerns→ce-*, categoria do sh-06 possivelmente via extensão de enum em ADR) — não há condição machine-evaluable para 'o founder decidiu o conteúdo'."
	}]
}
