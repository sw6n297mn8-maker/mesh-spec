package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def042: artifact_schemas.#DeferredDecision & {
	id:     "def-042"
	title:  "Vendor-of-record do LedgerPort deferido até o golden-example (decisão JIT)"
	date:   "2026-06-04"
	status: "open"

	description: """
		adr-141 fixa o contrato do LedgerPort — o Port da SoT do valor (categoria: ledger engine
		double-entry, imutável): operações, PortResult<T>, value classes na fronteira, obrigações de
		contract-test. Fica deferida a seleção do vendor de ledger que IMPLEMENTA esse Port como
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
		Trigger adjacent-need file-exists no harness de codegen-validation (output de WI-137): a
		existência do harness é o sinal exato de que o Port deixou de ser contrato no papel e passou a
		ser EXERCITADO de verdade — momento em que a seleção do vendor vira decidível com evidência,
		não especulação. Ancorar no harness que EXECUTA (não no schema #GoldenExample de WI-136 nem na
		instância) evita o erro-gêmeo já corrigido na falsificationCondition de adr-141. Mesmo padrão
		de def-040/def-049 (file-exists no artefato que destrava a decisão), machine-evaluable; melhor
		que manual-review e que um anchor em artefato de mesh-runtime (invisível ao runner de
		mesh-spec).
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
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "scripts/ci/validate-codegen.sh"
		}
	}]
}
