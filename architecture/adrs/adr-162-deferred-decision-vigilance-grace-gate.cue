package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-162 — Vigilância de deferred-decisions em camadas: gate de carência
// (instalado-mas-advisory neste arco) + briefing de abertura de sessão. Filho
// de adr-062 (NÃO emenda, NÃO supersede; adr-062 segue accepted): estende a
// postura advisory do runner para advisory-com-carência-que-bloqueia, como
// evolução-pela-experiência. Camada 2 (canal externo) fica deferida em def-070.

adr162: artifact_schemas.#ADR & {
	id:    "adr-162"
	title: "Vigilância de deferred-decisions: gate de carência + briefing (nascimento desligado)"
	date:  "2026-06-28"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		POSTURA HERDADA. O adr-062 bootstrapou #DeferredDecision + o runner
		determinístico (scripts/ci/evaluate-deferred-triggers.sh) + o workflow
		(deferred-trigger-check.yml), com a postura DELIBERADA: o runner avalia
		triggers, emite ::warning:: annotations, NÃO muta instâncias, e sai
		SEMPRE com exit 0 (advisory, não-bloqueia CI). Essa escolha fazia sentido
		no início: não engessar o fluxo enquanto o vocabulário de triggers era
		novo e o volume de defs pequeno.

		EXPERIÊNCIA MEDIDA. A postura advisory-pura deixou disparos APODRECEREM.
		Medição no disco (2026-06-28): 8 deferred-decisions de produção
		(def-037, def-038, def-040, def-041, def-042, def-043, def-044, def-045)
		têm trigger adjacent-need DISPARADO desde 2026-06-10 (commit de
		adr-141 + scripts/ci/validate-codegen.sh) — 18 dias disparados-e-não-
		agidos. O motivo não é descuido do founder: o ::warning:: do runner não
		é lido (vira ruído no log de CI verde), e o reporter (dd-status.sh) é
		sob-demanda. Sem fricção, o sinal não vira ação.

		POR QUE AGORA / POR QUE ESTRUTURAL. O critério de disparo dos defs já é
		concreto e já disparou; o que falta é o sistema PARAR DE DEIXAR adiar
		indefinidamente. Isso muda a postura de enforcement do adr-062 (advisory
		→ bloqueante após carência) e adiciona uma regra ao contrato do agente
		(briefing de abertura) — não é ajuste local, atravessa runner + workflow
		+ governance/claude. É decisão de protocolo de governança.

		Alternativas avaliadas: (a) manter advisory e confiar em hábito/disciplina
		do founder — REJEITADA: é exatamente o que a experiência falsificou (8
		defs apodreceram). (b) gate IMEDIATO no disparo (sem carência) — REJEITADA:
		tirania — travaria o CI no instante em que um trigger dispara, no meio de
		um arco em curso, sem janela para fechar. (c) gate com CARÊNCIA (a decisão
		abaixo): dá uma janela curta para agir antes de travar — equilibra
		"não-apodrecer" com "não-engessar". Sobre o NASCIMENTO: como os 8 já estão
		18 dias além de qualquer carência de 7 dias, ligar o gate AGORA tornaria o
		próprio PR deste ADR vermelho (auto-reprovação) e a main nasceria vermelha
		— uma peça de governança não deve nascer sendo violada. Daí o gate nasce
		INSTALADO-MAS-DESLIGADO (advisory), e a ligação é arco futuro consciente
		após a triagem do backlog.
		"""

	decision: """
		(1) TRÊS CAMADAS de vigilância. Camada 1 = gate de carência no runner
		(decisão abaixo). Camada 3 = briefing de abertura de sessão (regra no
		contrato do agente). Camada 2 = canal de notificação externa — DEFERIDA
		em def-070 (não se escolhe ferramenta agora).

		(2) MÁQUINA DE ESTADO do def (o que o gate distingue), avaliada pelo
		runner sobre cada def status=open:
		- open, NÃO-disparado → verde (exit 0).
		- open, disparado, DENTRO da carência → WARN (::warning::, exit 0) — a
		  janela; comportamento de hoje.
		- open, disparado, ALÉM da carência → GATE (::error::, exit≠0, trava o
		  merge).
		- triggered | resolved | withdrawn → SKIP (o founder agiu; gate
		  silencioso). O runner já pula status≠open.

		(3) RELÓGIO GIT-DERIVADO, não armazenado (preserva a invariante de
		não-mutação do runner, adr-062). Para os kinds gateáveis:
		- adjacent-need file-exists: fireDate = data do 1º commit que adicionou o
		  path-gatilho (git log --diff-filter=A --format=%cs -1 -- <path>).
		- temporal: fireDate = def.date + maxAgeDays.
		NÃO se adiciona campo firedAt ao schema #DeferredDecision: o relógio é
		recomputado a cada run, determinístico, sem persistir estado nem mutar a
		instância.

		(4) CARÊNCIA = 7 dias, DIAS-SÓ. "Além da carência" = idade-do-disparo
		> 7 dias. NÃO se conta PRs/merge-commits (proxy frágil a squash);
		dias-corridos é robusto e suficiente. Constante global no runner (V1; um
		override per-def é refinamento futuro, fora deste arco).

		(5) ESCOPO V1: gateáveis APENAS triggers cujo fireDate é git-derivável
		sem ambiguidade — file-exists e temporal. Os 8 defs de produção são todos
		adjacent-need file-exists → 100% cobertos. Os kinds recurrence,
		volume-threshold e file-content-occurrence-count seguem WARN-ONLY no V1
		(a data da N-ésima ocorrência não é cleanly datável); declarado como
		limitação honesta, não como cobertura silenciosa.

		(6) CAMADA 3 — BRIEFING DE ABERTURA. Regra no contrato do agente
		(governance/claude/config.cue → regen CLAUDE.md): antes de trabalho
		substantivo em QUALQUER sessão, o agente roda o runner + o reporter e
		lista, como primeira coisa: (1) open-disparado-além-da-carência (gate
		ativo), (2) open-disparado-dentro-da-carência (janela aberta), (3)
		triggered-stale (reconhecido mas parado — visibilidade, não trava).
		Operações triviais (status report, leitura) dispensam.

		(7) NASCIMENTO INSTALADO-MAS-DESLIGADO. Neste arco o código do modo-gate
		ENTRA no runner e é PROVADO (dry-run mostra que travaria os 8 se ligado),
		mas é acionado por flag/env (DD_GATE_ENABLED) que o workflow NÃO seta —
		o workflow segue advisory (exit 0). Razão: os 8 já estão além de 7 dias;
		ligar agora auto-reprovaria este PR e nasceria a main vermelha. Uma peça
		de governança não deve nascer sendo violada. O comportamento default do
		runner (sem a flag) permanece idêntico ao de hoje.

		(8) ATIVAÇÃO É ARCO FUTURO CONSCIENTE. Virar o workflow para o modo-gate
		(setar DD_GATE_ENABLED) é mudança mínima e deliberada, a ser feita DEPOIS
		da triagem dos 8 defs de produção já disparados (resolver / reconhecer
		via triggered / withdraw / re-adiar). Registrada como pendência explícita;
		o ponto de ligação fica comentado no workflow apontando este ADR.

		(9) V1 GATEIA SÓ open-disparado-além. triggered-stale fica em
		VISIBILIDADE (briefing Camada 3 + flag do dd-status), NÃO trava — a
		escotilha "flipar para triggered para silenciar o gate sem resolver" é
		coberta por visibilidade, não por gate, neste arco. Fechar a escotilha
		(gatear triggered-stale) é revisável em arco futuro se for abusada.
		"""

	consequences: """
		Positivas.
		(P1c) Disparos param de apodrecer por falta de leitura: a carência
		converte o sinal advisory (ignorável) em fricção dura (CI vermelho) após
		uma janela — quando ligado. O adiamento deixa de ser infinito por
		omissão.
		(P2c) Carência preserva o fluxo: a janela de 7 dias não trava no instante
		do disparo; um arco em curso pode fechar sem o gate interromper.
		(P3c) Invariante de não-mutação do adr-062 preservada: o relógio é
		git-derivado, o runner continua só-leitura; nenhum campo novo no schema.
		(P4c) Nascimento limpo: o gate instalado-mas-advisory não auto-reprova o
		próprio PR nem deixa a main vermelha; a postura de enforcement muda sem a
		peça nascer em violação.
		(P5c) Visibilidade redundante: a Camada 3 (briefing) cobre TODOS os defs
		open (inclusive os manual-review que o gate nunca pega) + os
		triggered-stale; o gate (Camada 1) cobre os file-exists/temporal além da
		carência. As duas redes se complementam.

		Negativas (limites intrínsecos).
		(N1c) Cobertura parcial do gate no V1: recurrence/volume/
		file-content-occurrence-count ficam warn-only (não gateados). Defs com
		esses triggers dependem só da Camada 3 até um arco futuro datar a
		N-ésima ocorrência.
		(N2c) Dívida de ativação declarada: enquanto o gate está desligado, a
		fricção dura não existe — a vigilância depende da Camada 3 (briefing) até
		a ligação. Janela consciente, fechada pelo arco futuro de ativação.
		(N3c) Escotilha do triggered: flipar open→triggered silencia o gate sem
		resolver; coberto por visibilidade (briefing + dd-status-stale), não por
		gate, no V1. Risco de limbo-de-triggered mitigado, não eliminado.

		Compliance / fitness. A prova deste arco (em vez de um gate ligado) é o
		DRY-RUN de duas faces: com DD_GATE_ENABLED, o runner sai exit≠0
		identificando os 8 open-disparado-além (gate correto); SEM a flag (como o
		workflow o invoca), sai exit 0 (advisory, nascimento limpo). A ligação
		futura é a mudança que seta a flag no workflow.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se: (carência-mal-calibrada) 7 dias
			provarem-se curtos demais (gate trava arcos legítimos em curso
			repetidamente) ou longos demais (defs ainda apodrecem dentro da
			janela); ou (relógio-insuficiente) o fireDate git-derivado divergir
			do disparo real para os kinds gateáveis (ex. rename do path-gatilho
			reseta a data e mascara um disparo antigo); ou (nascimento-eterno) a
			ativação ficar permanentemente adiada, de modo que o gate instalado-
			mas-desligado nunca passe a bloquear e a vigilância dependa para
			sempre só do briefing.
			"""
		observableSignal: """
			(calibração) frequência de re-adiamentos só-para-resetar-o-relógio,
			ou defs resolvidos tarde apesar de dentro-da-carência. (relógio) um
			def cujo path-gatilho foi renomeado aparecendo como recém-disparado.
			(nascimento-eterno) DD_GATE_ENABLED ainda OFF no workflow N meses após
			este ADR, com os 8 ainda open.
			"""
	}

	affectedArtifacts: [
		"scripts/ci/evaluate-deferred-triggers.sh",
		".github/workflows/deferred-trigger-check.yml",
		"governance/claude/config.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-070-external-notification-channel.cue",
	]

	derivedArtifacts: [
		"CLAUDE.md",
		"governance/readme/structure-index.cue",
	]

	defersTo: ["def-070"]

	principlesApplied: [
		"P12 — governança executável: o critério de revisita do def deixa de ser prosa advisory e passa a gate determinístico após carência; a vigilância vira mecanismo, não disciplina. É a especialização direta deste princípio para o lifecycle de deferred-decisions.",
		"P10 — gate determinístico sobre recomendação estocástica: o gate é puramente determinístico (git date math + carência fixa); nenhum LLM decide travar. O agente (Camada 3) apenas RECOMENDA/reporta; o gate (Camada 1) valida. Mantém a fronteira de adr-040.",
		"P0 — localização canônica: a semântica da vigilância vive aqui (ADR); o relógio é git-derivado (não duplica estado no schema); a regra do briefing aponta para o reporter, não copia sua lógica. Zero duplicação de estado.",
		"adr-062 — parent: estende a postura advisory/exit-0/não-muta do runner para advisory-com-carência-que-bloqueia. NÃO emenda nem supersede (adr-062 segue accepted); é evolução-pela-experiência — o adr-062 escolheu advisory por boa razão (início fluido), a experiência mostrou que advisory-puro deixa apodrecer, e advisory-com-carência o corrige honrando a invariante de não-mutação que o 062 fixou.",
	]

	rationale: """
		A reversão da postura advisory NÃO é "o adr-062 estava errado" — é
		evolução-pela-experiência. O adr-062 escolheu advisory/exit-0/não-bloqueia
		deliberadamente, para não engessar o fluxo quando o vocabulário de
		triggers era novo. Essa escolha foi correta para aquele momento. A
		experiência subsequente (8 defs disparados-e-não-agidos por 18 dias,
		porque o ::warning:: não é lido) falsificou a suficiência do advisory-puro
		em regime de volume. advisory-com-carência SUBSTITUI advisory-puro pela
		mesma razão que o 062 invocou (não engessar): a carência É a janela que
		preserva o fluxo, e o gate só morde quando o adiamento vira omissão. O 062
		é honrado e corrigido, não revogado — por isso filho, não emenda nem
		supersede, e a invariante de não-mutação do runner é preservada
		(relógio git-derivado, sem firedAt no schema).

		O nascimento instalado-mas-desligado é o ponto mais delicado e é
		deliberado: como os 8 já estão 18 dias além de 7, ligar o gate no mesmo
		arco tornaria este PR vermelho no próprio check que ele introduz
		(auto-reprovação) e nasceria a main vermelha. Uma peça de governança que
		nasce sendo violada é incoerente e erode a confiança no mecanismo. Separar
		INSTALAR (código provado, advisory) de LIGAR (workflow seta a flag, após
		triagem do backlog) deixa o mecanismo nascer limpo e torna a ativação um
		ato consciente, não um efeito colateral. A prova de que o gate funciona é
		o dry-run de duas faces, não o gate ligado.

		Carência dias-só (7) sobre PRs/merge-commits: a contagem de PRs exigiria
		ou GH API (acoplamento) ou um proxy de merge-commits frágil a squash;
		dias-corridos é git-derivável, robusto e suficiente para o propósito
		(janela curta antes de travar). V1 gateia só file-exists/temporal porque
		são os únicos com fireDate inequívoco; cobre 100% do backlog atual de
		produção e declara o resto warn-only em vez de fingir cobertura.

		decisionClass structural: muda a postura de enforcement de um protocolo de
		governança (adr-062) e adiciona regra ao contrato do agente — atravessa
		runner + workflow + governance/claude, não é contido num artefato. status
		proposed: a aprovação do founder promove proposed→accepted; a ativação do
		gate é arco posterior. reversibility medium: reverter = remover o modo-gate
		do runner + a seção do config + def-070 — esforço moderado, nada
		persistido travado (o relógio é git-derivado, não há migração de dados).
		blastRadius cross-cutting: CI + governança do agente + protocolo de
		deferred-decisions — múltiplos domínios, mas não repo-wide. Coerente com o
		pai adr-062.

		Tensão com axiomas: nenhuma. Cumpre P10 (gate determinístico; o agente
		recomenda no briefing, o CI valida) e P12 (governança executável), e
		preserva a não-mutação do adr-062.
		"""
}
