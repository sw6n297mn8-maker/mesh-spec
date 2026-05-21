package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

deferredDecisions: "def-017-deletion-srr-script-handling": artifact_schemas.#DeferredDecision & {
	id:    "def-017"
	title: "self-review-check trata artifacts deletados como modificados — diferido até próximo episódio de delete ou hardening governance"
	date:  "2026-05-21"

	description: """
		Durante reset Phase desta sessão (commit que apaga contexts/fce/,
		contexts/ntf/, contexts/nim/ + 13 SRRs correspondentes) o script
		scripts/ci/check-self-review.sh falhou em CI exigindo SRR para
		os 10 artifacts deletados (4 FCE + 4 NTF + 2 NIM).

		Causa raiz identificada: script usa `git diff --name-only
		origin/main...HEAD` para listar arquivos alterados (linha 121).
		Diff inclui arquivos DELETADOS. Script não distingue delete de
		modify e exige SRR para ambos os casos. Resultado: cada delete
		operation produz overhead burocrático de criar SRR para
		documentar a deleção.

		Esta deferred-decision registra a observação como follow-up
		explícito para evitar que o issue seja perdido ao longo do
		tempo. Conforme founder direction durante esta sessão:
		"Deferred issue: self-review-check treats deleted governed
		artifacts as modified artifacts and requires SRR. Evaluate
		whether delete-only diffs should require deletion SRR or be
		excluded via diff-filter in future governance hardening."

		Workaround aplicado agora (reset Phase): 10 SRRs de deleção
		minimal criadas seguindo template uniforme, deixando explícito
		que cada SRR documenta apenas a operação DELETE, não revisa
		conteúdo deletado. Decisão de design vive no commit message,
		não nas SRRs.
		"""

	deferralRationale: """
		Trade-off explícito durante reset Phase: PR #43 é reset
		corretivo, NÃO o momento certo para refatorar o motor de
		governance. Objetivo do PR é limpar estado com menor blast
		radius possível. Modificar check-self-review.sh agora
		introduziria:
		(a) mudança em governance script exige ADR explícito (per
		    CLAUDE.md);
		(b) cascade de ADR + change + SRR para o ADR aumenta scope
		    do reset PR;
		(c) risco de bloquear cleanup atrás de discussão de fix de
		    script.

		Resolução: aplicar Opção A (10 SRRs minimal de deleção) agora
		+ registrar este deferimento para hardening posterior. Custo
		evitado: ~45-60 min de ADR + script change durante momento
		em que founder priorizou caminho mais curto para restart.
		Custo aceito: 10 SRRs ruidosos no governance/build-time/
		self-reviews/ + precedente de "SRR para delete" que pode
		escalar se mais resets acontecerem.

		Custo de continuar deferindo: medium-cumulative. Cada delete
		futuro de artifact governado acumula mais SRRs ruidosos. Mas
		deleções de artifacts governados são eventos raros (reset
		PR #43 é o primeiro neste repo), então custo cumulativo é
		baixo na prática. Hardening pode esperar até trigger fire.
		"""

	triggerCalibrationRationale: """
		Trigger kind 'manual-review' apropriado aqui porque:
		(a) condição não é machine-evaluable como pattern em files —
		    é "founder decidiu que vale corrigir script";
		(b) recurrence de deleções de artifacts governados é evento
		    estratégico (segundo reset ou acumulação de SRRs de
		    deleção), não pattern textual matchable;
		(c) automatizar por contagem de SRR files com "deletion" no
		    nome seria gameable e frágil (e.g., normal-named SRR
		    para artifact que por acaso foi renomeado);
		(d) decisão de "fix script" é design decision que precisa
		    análise estratégica (ADR + change + SRR), não acionável
		    automaticamente.

		Pattern alternativo considerado e rejeitado: trigger
		recurrence em arquivo "-deletion.self-review.cue" com
		threshold 15 (dobro do número atual 10) seria machine-
		evaluable. Mas isso codifica suposição de que mais deleções
		virão, que é exatamente o oposto do que queremos (deleções
		são raras por design).
		"""

	originatingArtifacts: [
		"governance/build-time/self-reviews/fce-canvas-deletion.self-review.cue",
		"governance/build-time/self-reviews/fce-glossary-deletion.self-review.cue",
		"governance/build-time/self-reviews/fce-primary-agent-deletion.self-review.cue",
		"governance/build-time/self-reviews/fce-primary-agent-governance-deletion.self-review.cue",
		"governance/build-time/self-reviews/nim-canvas-deletion.self-review.cue",
		"governance/build-time/self-reviews/nim-glossary-deletion.self-review.cue",
		"governance/build-time/self-reviews/ntf-canvas-deletion.self-review.cue",
		"governance/build-time/self-reviews/ntf-glossary-deletion.self-review.cue",
		"governance/build-time/self-reviews/ntf-primary-agent-deletion.self-review.cue",
		"governance/build-time/self-reviews/ntf-primary-agent-governance-deletion.self-review.cue",
		"session:bc-governance-layer-reset-2026-05-21",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "local"
		description: """
			Custo é localizado em governance/build-time/self-reviews/:
			cada delete operation de artifact governado produz N SRRs
			ruidosos (N = número de artifacts deletados naquela
			operação). Workaround atual (template uniforme + commit
			message como fonte de verdade) é tractable.

			Risco de drift: precedente "SRR para delete" pode ser
			interpretado por agentes futuros como pattern legítimo
			a expandir (SRR para rename, SRR para move, etc).
			Mitigação: deferral rationale + template explicitamente
			diz que SRR é puramente operacional para CI passar.

			Mesmo se 10 SRRs ficarem no repo permanentemente sem
			fix, impacto operacional é zero: cue vet PASS, script
			PASS, artifact-level governance preservada.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			Manual-review apropriado porque "deveríamos corrigir
			check-self-review.sh para distinguir delete de modify?"
			é decisão estratégica que founder revisita quando:
			(a) próximo reset/delete operation acontece e os 10+
			    SRRs novos parecem desproporcionais;
			(b) founder identifica oportunidade de hardening do
			    motor de governance independentemente;
			(c) auditor/colaborador questiona o ruído dos SRRs de
			    deleção atuais.

			Não há pattern textual ou contagem que faça sentido
			automatizar — a decisão é "vale a pena ADR + change?"
			que depende de contexto operacional do momento.
			"""
	}]

	status: "open"
}
