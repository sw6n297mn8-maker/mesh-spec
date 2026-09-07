package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

def094CrossRepoContractStaging: build_time.#SelfReviewReport & {
	reportId: "srr-def-094-cross-repo-contract-staging"

	artifactPath:       "architecture/deferred-decisions/def-094-cross-repo-contract-staging.cue"
	artifactSchemaPath: "architecture/artifact-schemas/deferred-decision.cue"
	artifactType:       "deferred-decision"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-09-07"

	roundsExecuted: 3
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido: a primeira redação descrevia o ciclo por
			DEDUÇÃO ('o gate provavelmente lê a main'), que é exatamente o
			erro que a travessia cometeu duas vezes antes de medir. Reescrito
			citando a mecânica lida no código — copyHandAuthored(runtimeDir,
			ws) do mesh-codegen pipeline e o checkout sem `ref:` de cada
			workflow — para que a próxima sessão herde a medição, não a
			inferência.
			"""
	}, {
		round:     2
		failCount: 1
		warnCount: 0
		infoCount: 0
		summary: """
			1 fail corrigido: o def registrava o precedente sem registrar o
			que o TESTARIA. Acrescentada a condição de falsificação — a
			hipótese era que o vermelho do codegen-validation se dissolveria
			ao chegarem as slices, e falharia no passo [2/5] até lá; se ele
			tivesse seguido vermelho após o merge do mesh-runtime #50 o
			diagnóstico estaria errado e o precedente não valeria. Sem isso o
			def registraria opinião com aparência de evidência.
			"""
	}, {
		round:     3
		failCount: 0
		warnCount: 1
		infoCount: 0
		summary: """
			Zero fails. Acrescentada a JANELA VERMELHA MEDIDA (2min42s,
			54333422 → 3706938) como ponto de comparação: o precedente é
			aceitável porque a janela é curta e fecha sozinha, e sem o número
			a próxima travessia não teria como saber se ainda é. Registrada
			também a recusa do override de `ref:` como RECUSA, não pendência
			— recusa registrada some do histórico com mais facilidade que
			decisão tomada. Warn tq-def-03 mantido e articulado.
			#TriggerStrict ✓; cue vet ✓.
			"""
	}]

	findings: {
		warn: [{
			criterionId: "tq-def-03"
			severity:    "warn"
			message:     "Nenhum trigger non-manual capaz de detectar o sinal real: 'a segunda travessia de contrato cross-repo' se manifesta como par de PRs vermelhos em dois repositórios, e o runner não lê CI nem o outro repo."
			rationale:   "Warn aceito com mitigação: temporal maxAgeDays 90 acompanha o manual-review para que o adiamento não fique invisível entre travessias. Um predicado sobre os workflows (procurar `ref:` em codegen-validation.yml) foi considerado e recusado — cravaria a grafia da solução que este def registra como RECUSADA."
		}]
	}

	summary: """
		def-094 dá morada a um ciclo ESTRUTURAL (não acidente do adr-198):
		os dois gates cross-repo leem a default branch um do outro, e nenhum
		é consertável dentro do próprio repo. Deferido é o mecanismo de
		staging, não a escolha entre suas formas — n=1 não sustenta
		protocolo. O def carrega três coisas que costumam se perder: o
		precedente executado (mergeia o lado que CUMPRE, não o que IMPÕE), a
		condição que o falsificaria, e a janela vermelha medida como ponto de
		comparação. adr-198.defersTo NÃO foi alterado: def-094 não nasce da
		decisão do ADR e sim da materialização dela — a prosa do próprio ADR
		afirma que def-093 é o único def que aquela decisão cria, e a relação
		correta viaja por originatingArtifacts.
		"""
}
