package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def064: artifact_schemas.#DeferredDecision & {
	id:     "def-064"
	title:  "Ladder de automação da propagação spec→runtime deferida até 2º runtime real"
	date:   "2026-06-20"
	status: "open"

	description: """
		Fica deferida a LADDER DE AUTOMAÇÃO da propagação spec→runtime — os níveis
		crescentes de automação do bump quando a spec-main avança: (1) detectar/preparar
		automático com adoção deliberada (re-pin + regen + build + PR de bump pronto, merge
		humano); (2) auto-merge de bump verde sob critérios codificados (invariantes
		cobertos por teste + histórico sem surpresa + volume que dói); (3) live sem pin para
		superfícies de baixo risco. O adr-158 fixa no contractGate a CAPACIDADE de
		revalidação no avanço da spec (capability c); o que se defere aqui é só a POLÍTICA de
		quão automático é o merge do bump — não a capacidade de detectar.
		"""

	deferralRationale: """
		Desenhar uma política de auto-merge multi-runtime com N=1 runtime real (só o
		mesh-runtime existe; o frontend-runtime está autorizado por adr-157 mas não nasceu)
		seria governança especulativa: os critérios de promoção 2→3→4 (quantos bumps verdes
		sem surpresa, qual volume dói, quais superfícies são baixo-risco) só calibram contra
		evidência de propagação real em mais de um runtime. Custo evitado por deferir agora:
		uma ladder cravada sobre um único runtime fixaria thresholds sem dado e exigiria
		retrabalho quando o 2º runtime revelasse o padrão real. Custo de continuar deferindo:
		baixo — o bump manual/deliberado (ponto de partida do adr-158) funciona e move dinheiro
		sob olho humano; a ladder é otimização de ergonomia de CI, não gap que bloqueia caminho
		crítico. Espelha a promoção-por-evidência do adr-154 (regra mesh-local só universaliza
		com 2+ provando).
		"""

	triggerCalibrationRationale: """
		O sinal de que o motivo de deferir não vale mais é "o 2º runtime real materializou".
		Proxy machine-evaluable em mesh-spec: o frontend-codegen-contract.cue flipa status para
		accepted EXCLUSIVAMENTE no 1º golden-example do frontend (adr-158) — o que exige o
		frontend-runtime existir e gerar a superfície FCE compilando, i.e., ser o 2º runtime
		real (após o mesh-runtime). adjacent-need file-contains nesse arquivo é sinal forte e
		preciso: enquanto o contrato está proposed o trigger não dispara; ao flipar, dispara a
		anotação que pede ao founder revisitar a ladder com 2 runtimes de evidência. Pattern é o
		valor literal do campo (status: "accepted"), que só casa o campo flipado — prosa que
		menciona "accepted" sem o prefixo do campo não casa, e o contrato tem um único campo
		status:. Diferença vs def-060 (sibling, manual-review): def-060 não tinha sinal
		mesh-spec-local (seleção de vendor vive no runtime, invisível ao grep); def-064 TEM (o
		flip do status do contrato), então usa trigger automático em vez de manual-review.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-158-frontend-codegen-contract.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			low porque o bump manual/deliberado já funciona e supre a função — deferir a automação
			não bloqueia caminho crítico nem acumula dano; é otimização de ergonomia de CI.
			cross-cutting porque a política de propagação atravessa a fronteira spec↔runtimes (o
			trigger no CI da spec + o regen/pin no CI de cada runtime), não um único contexto.
			Reversível: adotar a ladder depois não muda contrato nem dado persistido.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind:    "file-contains"
			path:    "governance/build-time/frontend-codegen-contract.cue"
			pattern: "status: \"accepted\""
		}
	}]
}
