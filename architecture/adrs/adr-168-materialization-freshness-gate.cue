package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr168: artifact_schemas.#ADR & {
	id:    "adr-168"
	title: "Gate de frescura de materialização — o disco decide no ato da escrita (G1 tip + G2 renumeração + G3 eco)"
	date:  "2026-07-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		Incidente desta sessão (classe WI-147-stale): a fatia FCE
		async-api foi proposta e aprovada citando WI-147 como número
		do work-item. Entre a proposta e a escrita, origin/main
		avançou 4 PRs (#196–#199) e passou a carregar seu PRÓPRIO
		WI-147 e WI-148 (adr-166/167). A materialização citava um
		número já consumido pelo disco — colisão add/add só descoberta
		no git fetch pré-commit. Renumerado para WI-149 manualmente.

		ACHADO DECISIVO do pre-flight (registrado verbatim): a regra
		de sincronização com o remoto NÃO existia escrita em lugar
		nenhum — nem em governance/claude/config.cue, nem no CLAUDE.md
		derivado. A frescura da árvore era ACIDENTE de infraestrutura:
		o container efêmero clona fresco no session-start e essa
		frescura DECAI silenciosamente pela vida da sessão. Esta
		sessão é a prova — clone no início, materialização horas
		depois, 4 PRs mergeados no intervalo. O hábito de rodar
		dd-status/evaluate-triggers na abertura existe, mas é briefing
		de ABERTURA, não gate de ESCRITA: a regra existia como hábito,
		não alcançava o ato que precisava governar.

		A causa é a mesma do adr-167 (bootstrap staleness): uma
		condição declarada/assumida sem enforcement no PONTO DE USO
		depende de memória humana, que falha empiricamente. adr-167
		resolveu para exceções de bootstrap; esta é a mesma classe
		para números sequenciais-globais (WI/adr/def/ten) e para a
		base da branch.

		Alternativas avaliadas:
		(a) Disciplina documentada ("lembre de fetch antes de
		    materializar") — rejeitada: é exatamente o que faltava e
		    falhou; hábito não é gate (a lição transversal do adr-167).
		(b) Renumeração automática silenciosa (o script escolhe o
		    próximo-livre e reescreve) — rejeitada: mascara a
		    divergência entre proposta aprovada e disco; o founder
		    aprovou WI-N, a renumeração para WI-M é decisão dele (G2
		    PÁRA e reporta, não conserta sozinho).
		(c) Só gate de CI (pós-push) — rejeitada como ÚNICA camada:
		    pega tarde (após materializar e pushar); o custo do
		    incidente é o retrabalho de materialização. CI entra como
		    rede durável COMPLEMENTAR (--ci), não substituta do gate
		    local no ato da escrita.
		(d) Bloquear o número no início da sessão (reservar WI-N) —
		    rejeitada: reserva cross-sessão exige estado compartilhado
		    que não existe; o disco (origin/main) já é o SoT — basta
		    re-derivar no ato da escrita, não reservar antes.
		"""

	decision: """
		Materialização passa a ter um GATE de frescura no ato da
		escrita — scripts/ci/materialization-freshness.sh — com três
		regras, enforcement no ponto de uso (padrão adr-167), zero
		memória humana:

		(G1) TIP: antes de qualquer commit de materialização, a branch
		DEVE partir do tip de origin/main. O gate faz git fetch +
		compara; divergência (branch atrás) → exit 1 NOMEANDO os
		commits novos ("parta do tip"). Enforcement por script, não
		por disciplina.

		(G2) RENUMERAÇÃO: os números das famílias sequenciais-globais
		(WI/adr/def/ten) citados na proposta aprovada são RE-DERIVADOS
		do REMOTO no ato da escrita (--assert FAM=N). Divergência do
		número citado vs próximo-livre → STOP e reporte de renumeração;
		a confirmação da renumeração é do arquiteto (1 linha). O gate
		PÁRA e reporta — não renumera sozinho (alternativa (b)
		rejeitada). Deriva o próximo-livre do tree de origin/main
		(git ls-tree + glob por diretório), nunca do working tree
		local (não conta o próprio arquivo sendo escrito).

		(G3) ECO: todo reporte de proposta ao founder abre com um eco
		de estado ("assumo main @ hash; últimos consumidos: WI-n,
		adr-n, def-n, ten-n") — regra no contrato do agente
		(config.cue). O eco torna a base da proposta VISÍVEL e
		auditável antes de qualquer escrita.

		Modos do script: default (G1+G2+G3, gate local de escrita);
		--echo (só G3); --ci (invariante durável, barato: nenhum
		arquivo numerado ADICIONADO por um diff pode reusar número já
		vivo na base — pega o add/add antes do merge-surpresa). O --ci
		roda como step do workflow validate.yml além do uso local.

		FAMÍLIAS cobertas por G2/--ci: WI (task-specs ∪ work-events),
		adr, def, ten — todas sequenciais-globais com corrida
		cross-sessão. FORA: escopadas locais (oq-{bc}-N, sc-*, tq-*,
		ddp-*) não têm corrida global; PRs são do GitHub.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) o gate não detectar a classe do incidente que o motiva — branch stale OU número citado já consumido — deixando a materialização prosseguir; OU (b) produzir falsos positivos que travem materialização legítima (número livre reportado como colidido, tip fresco reportado como atrasado); OU (c) o custo de rodá-lo no ato da escrita for alto o bastante para ser rotineiramente pulado, revertendo à memória humana que falhou."
		observableSignal: "Fixtures em scripts/ci/tests/test_materialization_freshness.py reproduzem o incidente real desta sessão deterministicamente (G1 nomeia commits; G2 pára na colisão WI-147; exit 0 pós-rebase com WI-149; --ci pega o add/add) e rodam em todo CI. Prova viva orgânica (decisão do founder, sem fabricar): na próxima sessão em que origin/main avançar entre proposta e escrita, o gate deve PARAR a materialização e reportar a renumeração — reportar como confirmação."
	}

	consequences: """
		Positivas:

		(P1) A classe WI-147-stale morre: número consumido pelo disco
		entre proposta e escrita é detectado no ato da escrita, não no
		merge-conflict. A frescura deixa de ser acidente do container
		e passa a ser condição verificada.

		(P2) A base da proposta fica visível (G3) — o founder vê
		"assumo main @ hash; últimos consumidos …" antes de aprovar,
		e a divergência é detectável por leitura.

		(P3) Enforcement no ponto de uso substitui disciplina: a regra
		que NÃO existia escrita passa a existir E a ser executada pelo
		script — não depende de o agente lembrar de fazer fetch.

		(P4) Rede dupla: gate local (custo do incidente evitado antes
		de materializar) + --ci durável (pega o que escapar do local,
		antes do merge).

		Negativas:

		(N1) Todo commit de materialização paga um git fetch + a
		derivação (sub-segundo). Aceito: é o custo de não materializar
		sobre base stale.

		(N2) O gate depende de rede (fetch de origin/main). Falha de
		fetch → exit 2 ("sem base fresca, não materialize") em vez de
		prosseguir cego. Aceito: recusar-se a materializar sem base
		fresca é o comportamento correto.

		(N3) Superfície de script nova (~200 linhas bash + suite).
		Mitigação: 7 fixtures git determinísticas cobrindo as 3 regras
		+ o incidente real; rodam no mesmo job da suite adr-166.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre o ato de escrita no repo.
		"""

	affectedArtifacts: [
		"governance/claude/config.cue",
		".github/workflows/validate.yml",
	]

	plannedOutputs: [
		"scripts/ci/materialization-freshness.sh",
		"scripts/ci/tests/test_materialization_freshness.py",
		"governance/build-time/task-specs/wi-150.cue",
		"governance/build-time/work-events/wi-150.cue",
		"governance/build-time/self-reviews/adr-168-materialization-freshness-gate.self-review.cue",
	]

	derivedArtifacts: [
		"CLAUDE.md",
	]

	principlesApplied: [
		"P0 — a regra de frescura vive no ÚNICO ponto onde importa (o ato da escrita), não como hábito difuso de abertura de sessão.",
		"P10 — gate determinístico substitui memória humana: a condição declarada/assumida vira invariante verificado no ponto de uso (mesma forma do adr-167).",
	]

	supersedes: []

	rationale: """
		P10 (gates determinísticos validam): a frescura da árvore era
		condição assumida sem gate — dependia de o clone efêmero não
		ter decaído e de o agente lembrar de fetch. G1/G2 a tornam
		invariante verificado no ato da escrita; G3 torna a base
		visível. Enforcement substitui disciplina — exatamente a lição
		do adr-167 aplicada à corrida de números sequenciais e à base
		da branch.

		P0 (localização canônica única): o disco (origin/main) É o SoT
		dos números consumidos e da base — o gate RE-DERIVA dele no ato
		da escrita em vez de manter um segundo registro (reserva,
		cache) que poderia divergir. Por isso G2 deriva do tree remoto,
		não do working tree.

		NON-GOAL registrado (Modo 2 — ordem perdida no relay): quando
		duas ordens do arquiteto chegam fora de ordem pelo relay da
		sessão, o gate NÃO resolve — é resíduo do desenho de relay, não
		da frescura do disco. Mitigado por ordens consolidadas (o
		arquiteto agrupa) + G3 (o eco de estado expõe a base assumida,
		permitindo detectar a inversão por leitura). Fora do escopo
		desta fatia por construção: o gate governa o disco, não a
		ordem de mensagens.

		DIREÇÃO FUTURA (registrada, NÃO executada): os repos irmãos do
		ecossistema (mesh-runtime, frontend-runtime) têm famílias
		sequenciais equivalentes (rtd-NNN e outras) com a mesma corrida
		cross-sessão. O padrão G1/G2/G3 é portável; portar QUANDO um
		incidente equivalente ocorrer lá (mesma disciplina de não
		generalizar sem caso — expand-when-needed). Nesta fatia, rtd
		permanece ECHO-ONLY via relay: o gate não deriva rtd (vive no
		mesh-runtime, invisível ao ls-tree deste repo); o arquiteto
		informa o rtd e o eco G3 o repassa.

		Sem axiomas tensionados. Sem lente: decisão deriva de um
		incidente comprovado nesta sessão + o princípio explícito do
		arquiteto ("o disco decide no ato da escrita").

		Relação com outras ADRs: DESCENDS adr-167 (mesma forma —
		enforcement no ponto de uso, zero memória humana — aplicada a
		outra condição). PRESERVA adr-166 (runner de deferred-triggers
		intacto; a suite nova roda no mesmo job). SEM supersession.

		Justificativa de risk metadata: reversibility 'medium' — o
		gate é revertível (remover script + step + regra), mas a
		reversão re-abre a classe WI-147-stale (custo de decisão, não
		de mecânica). blastRadius 'cross-cutting' — governa o ato de
		materialização de QUALQUER artefato numerado e o contrato do
		agente, sem tocar schemas de domínio.
		"""
}
