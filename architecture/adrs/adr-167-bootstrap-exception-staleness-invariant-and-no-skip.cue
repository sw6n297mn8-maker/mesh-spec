package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr167: artifact_schemas.#ADR & {
	id:    "adr-167"
	title: "Regras A+B no check-self-review: invariante global de staleness das bootstrap exceptions + isenção perdoa o passado, não o presente (resolução do def-012)"
	date:  "2026-07-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		A revisão de mérito das exceções de bootstrap (fatia def-012,
		pre-flight 2026-07-03 verificado em disco) encontrou:

		(1) 3 exceções transient STALE — SRR matching já existente e a
		entry nunca removida. A primeira (PG structural-check, SRR de
		2026-05-11) ficou INVISÍVEL por ~7 semanas. No caso cmt/glossary
		o ciclo previsto pelo exitCondition COMPLETOU (modificação real
		2026-06-17 + SRR criado junto) e a entry ficou mesmo assim.
		Quitadas no PR #198 (pré-requisito deste ADR: sem essa quitação,
		a Regra A abaixo nasceria vermelha sobre o estado corrente).

		(2) O mecanismo de saída das transient era auto-perpetuante: o
		check dava SKIP TOTAL a artefato isento (is_bootstrap_exempt),
		de modo que a modificação que deveria gerar o SRR quitador
		("after next modification", exitCondition de TODAS as entries
		transient) passava sem exigência — a saída dependia de memória
		humana, que falhou empiricamente (caso idc/glossary em a7126df:
		modificado sob isenção, nenhum SRR nasceu). O SKIP total era
		implementação INFIEL do contrato declarado nas próprias entries.

		(3) Dado decisivo para o escopo: TODAS as 6 exceções permanent
		(inaugural-circularity ×4, predecessor-supersession-only ×2)
		TÊM SRR matching hoje (quality-criteria com 7 SRRs de extensões;
		adr-013..017 com SRRs da migração c3-part3) — remover o SKIP
		delas custa zero: nenhum artefato fica descoberto.

		(4) A associação report↔artefato do check é por EXISTÊNCIA de
		SRR com artifactPath matching (sem exigência de frescor) — o
		custo de exigir SRR de artefato ex-isento é ONE-TIME por
		artefato (a 1ª modificação pós-mudança paga; as seguintes
		reutilizam), idêntico ao regime que todo artefato governado
		não-isento já paga.

		O def-012 deferia um "sc-be-01" de stale detection e especulava
		3 formas: (a) sc com kind existente invertido; (b) kind novo
		cross-file-relationship-presence; (c) runner externo. Todas
		especulavam detecção EXTERNA porque, à época, não havia caso
		empírico de stale. Com 3 casos empíricos e o defeito de SKIP
		identificado, o enforcement no PONTO DE USO (o próprio gate que
		consome a policy) supera as 3: mata a detecção E a causa.

		Alternativas avaliadas:
		(a)/(b)/(c) do def-012 (detecção externa em sc/runner) —
		rejeitadas: detectariam o stale mas manteriam o SKIP que o
		produz; kind novo (b) adicionaria superfície de schema para um
		problema que morre com 2 regras no script que já lê a policy.
		(d) Manter ddp-001 como métrica de decaimento da população —
		rejeitada: predicado sem consumidor automatizado é
		declared-but-unused (o anti-pattern registrado no def-014);
		gate substitui sinal (adr-040); git preserva a série histórica.
		(e) Regra B só para transient (permanent mantém SKIP) —
		rejeitada: o princípio "isenção perdoa o passado, não o
		presente" é geral; o dado (3) prova custo zero; carve-out
		mantém dois regimes onde um basta.
		(f) Exceções por classe de modificação (e.g., mecânica sem SRR)
		— rejeitada: gameable por construção; o custo real é one-time
		por artefato (dado 4), não por modificação.
		"""

	decision: """
		(1) REGRA A — invariante global de staleness (transient-only):
		em TODO run do check-self-review.sh (pull_request + push main),
		nenhuma entry transient da bootstrap policy pode ter SRR
		matching já existente. Violação → falha alto nomeando a entry
		("exceção stale: quitar <path>"). Detecção no primeiro PR
		seguinte ao SRR nascer, independente do que o PR toca — mata a
		invisibilidade. Permanent fora do invariante: não têm contrato
		de saída (exitCondition).

		(2) REGRA B — isenção perdoa o passado, não o presente (TODAS
		as entries, transient + permanent): modificação de artefato
		listado na policy NÃO faz SKIP — o check exige o SRR
		normalmente, como para qualquer artefato governado. A função
		is_bootstrap_exempt morre. Sem carve-outs por classe de
		modificação.

		(3) MUDANÇA DE NATUREZA DA POLICY (declarada): self-review-
		bootstrap-policy.cue deixa de ser mecanismo de ISENÇÃO e passa
		a ser (i) PROVENIÊNCIA HISTÓRICA — as entries permanent
		registram por que commits do bootstrap não têm SRR — e (ii)
		FILA DE QUITAÇÃO ENFORÇADA — as entries transient são dívidas
		com saída cobrada pela Regra A. Efeito conjunto A+B: modificação
		real de artefato transient-isento → SRR exigido (B) → invariante
		A cobra a quitação da entry → ciclo completo num único PR, zero
		memória humana.

		(4) def-012 RESOLVE por este ADR (resolvedBy: adr-167),
		registrando a substituição honesta: as opções (a)/(b)/(c)
		especuladas não são implementadas; a FUNÇÃO (stale nunca
		invisível) é entregue por enforcement no ponto de uso —
		consistente com adr-040 (gate determinístico) e P0 (a regra
		vive onde a policy é consumida). Nenhum "sc-be-01" nasce em
		architecture/structural-checks/.

		(5) ddp-001 APOSENTADO: removido do registry dd-predicates
		(registry passa a 3: ddp-002/003/004); asserts de calibração
		correspondentes removidos conscientemente. Fundamento na
		alternativa (d) rejeitada.

		(6) TESTES: fixtures git em scripts/ci/tests/ cobrindo — Regra A
		dispara nomeando a entry; Regra A limpa; Regra B exige SRR em
		isento modificado (transient sem SRR → falha, sem SKIP); Regra B
		satisfeita por existência (permanent com SRR passa; A não olha
		permanent); ciclo completo num único PR (modificação + SRR +
		entry removida → verde).

		(7) SEQUENCIAMENTO (executado): PR #198 (quitação das 3 stales)
		mergeado ANTES deste ADR — pré-requisito para a Regra A nascer
		verde.

		(8) ESCOPO EXCLUÍDO: frescor de SRR (associação por existência
		permanece o contrato — mudá-la seria decisão separada de custo
		muito maior); mudanças no runner de deferred-triggers (adr-166
		intacto); as 21 entries transient restantes (saem uma a uma
		pelo ciclo A+B conforme seus artefatos forem modificados).
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE a primeira modificação real de artefato transient-isento pós-merge NÃO produzir o ciclo completo num único PR (SRR exigido pela Regra B + quitação da entry cobrada pela Regra A), OU se a Regra B impuser custo recorrente por modificação (e não one-time por artefato) contradizendo a associação por existência, OU se alguma entry permanent ficar descoberta (artefato permanent modificado sem SRR possível)."
		observableSignal: "Prova viva orgânica (sem fabricar, decisão do founder): no primeiro PR pós-merge que modificar um dos 21 artefatos transient-isentos, o CI deve exigir o SRR e, ao SRR nascer, exigir a remoção da entry no MESMO PR — reportar como confirmação. Fixtures em scripts/ci/tests/test_check_self_review.py reproduzem o ciclo deterministicamente em cada run de CI."
	}

	consequences: """
		Positivas:

		(P1) Stale nunca mais invisível: a janela de 7 semanas do caso
		PG structural-check torna-se impossível — detecção no 1º PR
		após o SRR nascer, qualquer que seja o PR.

		(P2) O contrato declarado das entries ("after next
		modification") passa a ser ENFORÇADO em vez de dependente de
		memória: o ciclo modificação→SRR→quitação fecha num único PR.

		(P3) A população transient (21, fechada, só decresce) se
		auto-liquida organicamente sem sensor dedicado — def-012
		resolve e ddp-001 aposenta sem perda de vigilância.

		(P4) Regime único de SRR para todos os artefatos governados —
		fim do dual-regime isento/não-isento (custo one-time por
		artefato, dado (4) do context).

		Negativas:

		(N1) Primeira modificação de cada um dos 21 ex-isentos paga 1
		SRR que antes não pagaria. Aceito: é o regime normal de todo
		artefato governado; a cobertura "indireta via ADRs
		originadores" alegada nos rationales era exatamente o gap que
		deixou idc/glossary passar sem review em a7126df.

		(N2) check-self-review.sh ganha um passo global (21 entries
		transient × ~480 SRRs, uma passada) — custo de CI desprezível
		(<1s), mas superfície de script maior. Mitigação: testes de
		fixture cobrem as 2 regras.

		(N3) A policy mantém nome histórico ("bootstrap-policy") com
		natureza nova (proveniência + fila). Aceito: renomear quebraria
		refs (schema singleton canonicalPathRegex); a natureza está
		declarada aqui e no rationale da policy.

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural sobre
		enforcement de evidência de self-review.
		"""

	affectedArtifacts: [
		"scripts/ci/check-self-review.sh",
		"governance/build-time/self-review-bootstrap-policy.cue",
		"governance/build-time/dd-predicates.cue",
		"architecture/deferred-decisions/def-012-bootstrap-exception-stale-detection-sc.cue",
		"scripts/ci/tests/test_evaluate_deferred_triggers.py",
	]

	plannedOutputs: [
		"scripts/ci/tests/test_check_self_review.py",
		"governance/build-time/task-specs/wi-148.cue",
		"governance/build-time/work-events/wi-148.cue",
		"governance/build-time/self-reviews/adr-167-bootstrap-exception-staleness-invariant-and-no-skip.self-review.cue",
	]

	principlesApplied: [
		"P0",
		"P10",
	]

	supersedes: []

	rationale: """
		P10 (gates determinísticos validam): o exitCondition das
		entries era regra declarada sem gate — dependia de disciplina.
		A Regra A a torna invariante verificado em todo run; a Regra B
		remove o SKIP que impedia o próprio gate de cobrar o SRR
		quitador. Enforcement substitui monitoramento: por isso o
		def-012 resolve SEM nascer o sc-be-01 especulado — a função é
		entregue no ponto de uso, forma superior às 3 opções (a)/(b)/
		(c) que pressupunham detecção externa.

		P0 (localização canônica única): a regra de staleness vive no
		ÚNICO consumidor da policy (check-self-review.sh), não num
		segundo lugar (sc/runner) que precisaria re-ler a mesma policy.
		ddp-001 aposentado pelo mesmo princípio: predicado sem
		consumidor é cópia morta de conhecimento (declared-but-unused,
		anti-pattern do def-014).

		Sem axiomas tensionados. Sem lente: decisão deriva de defeito
		comprovado com 3 casos empíricos e um princípio explícito do
		founder ("isenção perdoa o passado, não o presente").

		Relação com outras ADRs: RESOLVE def-012 (via resolvedBy).
		DESCENDS adr-013/014/015 (sistema de self-review + bootstrap
		exception original), adr-070 (schema first-class das
		exceptions) e adr-071 (kind fcoc criado para o trigger do
		def-012 — o kind PERMANECE no schema; o uso do def-012 já havia
		migrado para ddp-001 em adr-166, agora aposentado). PRESERVA
		adr-166 (runner intacto; apenas registry e asserts recalibram).
		SEM supersession.

		Justificativa de risk metadata: reversibility 'medium' — as 2
		regras são revertíveis no script, mas a reversão re-abre o
		regime dual e re-esconde stales (custo de decisão, não de
		mecânica). blastRadius 'cross-cutting' — afeta o fluxo de
		modificação de TODOS os artefatos governados listados na policy
		(27 entries) e o contrato de evidência de qualquer PR futuro,
		sem tocar schemas de domínio.
		"""
}
