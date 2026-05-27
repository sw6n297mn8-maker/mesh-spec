package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr110: artifact_schemas.#ADR & {
	id:    "adr-110"
	title: "Liveness do gate (M3): invariante de invocação do runner + guard independente; raiz de confiança externa"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		Toda a camada de fiscalização determinística (structural-check runner, ~17
		checks em reject, meta-cobertura) depende de UM fato não-garantido: que o
		validate.yml de fato invoca o runner em modo bloqueante. Se esse passo for
		removido ou neutralizado (--mode warn, || true, exit não-propagado), os gates
		somem silenciosamente — o último ponto cego (M3).

		Paradoxo da raiz de confiança: um check que roda DENTRO do runner não pode
		garantir a própria invocação — se o runner não é chamado, o check não executa;
		se é chamado em warn, o check não bloqueia. O runner não prova que é invocado.
		Logo M3 NÃO pode ser um structural-check in-runner (seria autoengano).

		Alternativa REJEITADA: M3 como structural-check no próprio runner. Reprovada
		pelo paradoxo acima. A raiz de confiança da liveness é necessariamente
		EXTERNA ao runner.
		"""

	decision: """
		(1) Invariante governado: validate.yml DEVE invocar
		scripts/ci/structural-check-runner.py em modo DEFAULT (arg '.', sem --mode
		warn), com o exit propagado (PIPESTATUS + exit $rc), sem engolir o código
		(sem '|| true'). Este ADR é a localização canônica do invariante.

		(2) Guard INDEPENDENTE (.github/workflows/ci-liveness.yml): workflow SEPARADO
		do validate.yml que faz grep do validate.yml e falha se a invocação do runner
		drift-ar da forma bloqueante (removida, --mode warn, || true, exit não
		propagado). Quebra PARCIALMENTE o paradoxo — o guarda vive fora do guardado:
		para neutralizar silenciosamente seria preciso adulterar OS DOIS workflows.

		(3) Raiz de confiança FINAL é externa e fora do código: o founder deve marcar
		os checks (cue-validate + ci-liveness) como REQUIRED status checks no
		branch-protection do repo — assim não há merge contornando nem remoção sem
		admin. Recomendação operacional registrada aqui (ação de config no GitHub, não
		automatizável no repo).

		FORA DE ESCOPO: tornar o guard 100% à prova de remoção (impossível in-repo — a
		recursão "quem guarda o guarda" termina no branch-protection); refinamentos do
		grep (e.g., detectar reordenação que separe PIPESTATUS da invocação).
		"""

	consequences: """
		Positivas: (1) o invariante de liveness do gate fica explícito e governado
		(antes era implícito); (2) o guard independente pega os dois drifts realistas
		— neutralização (--mode warn / || true / exit mascarado) E remoção do passo —
		porque roda em workflow separado (verificado: passa no validate.yml atual,
		falha em ambas as adulterações); (3) eleva a barra: neutralizar silenciosamente
		exige adulterar dois workflows.

		Negativas: (1) NÃO é absoluto — o próprio ci-liveness.yml pode ser removido; a
		trava final é branch-protection (config de admin, fora do repo), honestamente
		declarada; (2) o guard é grep-based (heurístico) — uma reescrita exótica do
		validate.yml poderia enganá-lo sem neutralizar, ou vice-versa; mitigado por
		PR-review do diff de workflow; (3) depende de uma ação de config do founder
		(required checks) para ser à prova de bypass.
		"""

	reversibility: "high"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		".github/workflows/ci-liveness.yml",
		".github/workflows/validate.yml",
	]

	principlesApplied: [
		"P10 — gates determinísticos validam: M3 protege a INVOCAÇÃO do gate, e declara honestamente que a raiz de confiança da liveness é externa (não auto-hospedável)",
		"adr-096/097 — guarda a liveness do orchestrator/enforcement que esses ADRs estabeleceram",
		"adr-099 — completa a meta-cobertura: M1 (regra→robô), M2 (tipo→check), M3 (gate→invocado)",
		"dp-07 — sem big-bang: guard independente + invariante documentado + recomendação de branch-protection",
	]

	defersTo: []

	rationale: """
		decisionClass structural: estabelece um invariante de CI + um guard workflow —
		governa a liveness da camada de gate; aplica P10/adr-097/adr-099 sem redefinir
		princípios. reversibility high (remover o guard reverte); blastRadius repo-wide
		(protege todo o gate). Sem SRR para os .yml (.github/ é zona de plataforma,
		fora do regime de artifact-schema); este ADR + seu SRR cobrem a decisão.

		Verificado antes da proposta: a lógica do guard testada localmente — passa no
		validate.yml atual (forma bloqueante), falha em '--mode warn' e em 'runner
		removido'. cue vet ./... EXIT 0; runner --self-test PASS; runner default exit 0.
		Honestidade central: M3 não pode ser um gate in-runner (paradoxo); é invariante
		governado + guard independente + raiz externa (branch-protection).
		"""
}
