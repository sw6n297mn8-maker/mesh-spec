package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def041: artifact_schemas.#DeferredDecision & {
	id:     "def-041"
	title:  "Vendor-of-record do EventLogPort deferido até o golden-example (decisão JIT)"
	date:   "2026-06-28"
	status: "open"

	description: """
		adr-141 fixa o contrato do EventLogPort — o Port da SoT dos fatos (categoria: event store
		append-only): operações, PortResult<T>, value classes na fronteira, obrigações de
		contract-test. Fica deferida a seleção do vendor de event store que IMPLEMENTA esse Port como
		adapter em platform/adapters/ — categoria de runtime atrás do Port (P2), não contrato de
		domínio.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o contrato do Port é spec (adr-141 o fixa); QUAL vendor de runtime o
		serve é seleção de runtime, exercida pelo mesh-runtime. O reference adapter in-memory (adr-141
		item 6) é a spec executável da semântica do Port e o stub do golden-example — logo o
		golden-example sobe e prova o contrato SEM nenhum vendor real. Selecionar o vendor antes de o
		harness WI-137 exercitar o Port comprometeria a escolha antes de existir evidência que a
		valide — o lock-in prematuro que P2 (zero vendor no domínio) e real-options (adr-138) mandam
		evitar. Custo evitado: especular um vendor de runtime antes do golden-example. Custo de
		continuar deferindo: a spec não nomeia o vendor — mitigado porque o reference adapter destrava
		o golden-example e o Port abstrato é a opção preservada.
		"""

	triggerCalibrationRationale: """
		Re-deferimento pós-triagem do backlog de defs disparados (adr-162, Camada 3). O trigger
		original (adjacent-need file-exists em scripts/ci/validate-codegen.sh) ERA proxy-prematuro:
		disparou quando o harness de codegen-validation materializou, mas a decisão real — 1º adapter
		persistente (não-in-memory) do EventLogPort a entrar em construção — só fica devida em evento
		de runtime que vive no mesh-runtime (convenção platform/adapters/eventlog-<vendor>/) e NÃO tem
		sensor honesto no runner repo-local de mesh-spec: o nome do vendor É a própria decisão (sem
		file-exists exato possível) e recurrence colidiria com o eventlog-inmemory já existente.
		Substituído por manual-review (o evento real, founder revisita) + temporal 180d (backstop
		gateável; único kind além de file-exists que o gate V1 de adr-162 enforça; impede limbo, mesmo
		desenho do def-070). Data refrescada para 2026-06-28 para o backstop contar a partir de agora
		(idade 0, não re-dispara na hora); deferido ORIGINALMENTE em 2026-06-04 — proveniência
		preservada aqui porque #DeferredDecision tem campo `date` único, sem slot estruturado para
		"última revisão" (triggeredAt é proibido em status open).
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-141-runtime-kernel-port-contracts.cue",
		"governance/wave-plan.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-cutting"
		description: """
			low porque o reference adapter in-memory (adr-141 item 6) destrava o golden-example sem
			nenhum vendor — deferir a seleção não bloqueia o caminho crítico nem o codegen (P1).
			cross-cutting porque o Port é consumido por todos os BCs quando o runtime materializar.
			Exit: swap de adapter atrás do mesmo Port, com os mesmos contract-tests, sem mudar o
			contrato de domínio.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "1º adapter persistente (não-in-memory) do EventLogPort a entrar em construção. A convenção platform/adapters/eventlog-<vendor>/ vive no mesh-runtime e o vendor É a decisão; recurrence colidiria com o eventlog-inmemory já existente — sem file-exists honesto a partir do mesh-spec."
	}, {
		kind:       "temporal"
		maxAgeDays: 180
	}]
}
