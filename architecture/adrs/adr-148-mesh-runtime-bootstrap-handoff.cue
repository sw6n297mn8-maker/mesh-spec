package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-148 — Bootstrap/handoff do mesh-runtime: morada, fronteira, sequencia minima.
// Decisao estrutural completa (context/decision/consequences/rationale + falsificationCondition).
// Contrato de NASCIMENTO do mesh-runtime: formaliza morada do repo e da toolchain,
// a sequencia minima da prova P1 viva e o protocolo de handoff da primeira sessao.
// NAO executa bootstrap: a criacao do repo, o gerador real, o build e o run vivo
// sao acoes downstream, fora do escopo deste repo.
// Prior-art 2.0.6 do Mesh-Old citado como convergencia independente, NAO-vinculante
// (regime adr-147).

adr148: artifact_schemas.#ADR & {
	id:    "adr-148"
	title: "Bootstrap/handoff do mesh-runtime: morada do repo e da toolchain, sequencia minima da prova P1"

	date: "2026-06-11"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		A triade de codegen fechou o que o runtime consome: P14 (fidelidade de forma), adr-146 (gerador-do-cue.Value como pipeline canonico de domain-types, com design-rules "normativas para a materializacao em mesh-runtime") e adr-147 (Kotlin como linguagem-alvo; Rust papel-duplo). A spec pressupoe o mesh-runtime em 6 ADRs (adr-138/140/141/144/146/147), no codegen-contract (output.livesIn "mesh-runtime"; committedHere false; contractGate.runsIn "mesh-runtime CI") e no harness validate-codegen.sh (MESH_CODEGEN_TOOLCHAIN; exit-map pre-fixado) — mas nunca formalizou a estrutura de NASCIMENTO do repo nem a morada da toolchain: o codegen-contract localiza outputs e gate, nao a ferramenta de geracao. am-commitment (contexts/cmt/aggregate-manifests/am-commitment.cue, em main) forneceu o input real do stage aggregate-skeleton — a ultima pre-condicao spec-side do slice minimo. Este ADR e o contrato de bootstrap/handoff: o que a primeira sessao do mesh-runtime le para nascer sem re-decidir nem inferir.

		FRONTEIRA (padrao adr-138): Nenhuma decisao aqui modifica o mesh-runtime nem executa bootstrap. A criacao do repositorio, o acesso ao ambiente e toda implementacao sao acoes downstream, fora do escopo deste repo (CLAUDE.md).

		PRIOR-ART (convergencia independente, NAO-vinculante — regime adr-147): a estrutura de modulos 2.0.6 do Mesh-Old (ADR-C4-2.0, aceito): platform/{canon, ports, runtime, adapters} + contracts/ como gate de CI; lema "BC como particao primaria. Platform como infraestrutura compartilhada. Contracts como gate de CI." Citada como desenho-de-referencia que, em particular, resolve o CANON-PENDING do pm-cmt via platform/canon/ (value-class names das operations nascem no canon do runtime). DIRECAO, nao re-cravada aqui: a estrutura concreta de modulos nasce ou e ratificada no proprio mesh-runtime.

		Alternativas avaliadas: (a) gerador no mesh-spec (tools/) — rejeitada: adr-146 item 4 ja aponta a materializacao em mesh-runtime; a invocabilidade dupla (harness do mesh-spec + ContractGate do mesh-runtime CI) resolve-se por DISTRIBUICAO (executavel invocavel), nao por morada do source. (b) monorepo unico spec+runtime — rejeitada: adr-138 decidiu repo separado/subordinado/cadencia-de-agente; P1 estrito depende da fronteira (gerado nunca committado no mesh-spec). (c) cristalizar Gradle/test-runner como decisao canonica da spec — rejeitada: filtro adr-139 (capacidade e canonica; tecnologia e runtime-local). (d) adiar o handoff ate o repo existir — rejeitada: a primeira sessao do mesh-runtime precisa de contrato legivel, nao de arqueologia de 6 ADRs.
		"""

	decision: """
		(1) DECIDIDO vs A-EXECUTAR — governa a leitura deste ADR. DECIDIDO (itens 2-8): morada, fronteira, sequencia, escopo minimo, gates. A-EXECUTAR (downstream, fora deste repo): criacao/acesso ao repo, gerador real, build, reference adapter, run vivo. Nada aqui afirma bootstrap executado — a evidencia segue pending (governance/build-time/codegen-validation-evidence.cue) ate o harness rodar. Este item impede tres leituras erradas: decisao confundida com execucao; paths futuros do runtime tratados como outputs do spec; evidencia pending lida como falha do ADR.

		(2) MORADA DO RUNTIME, ratificada: mesh-runtime — repo separado, subordinado aos contratos do mesh-spec, cadencia de agente, responsavel por codigo gerado, adapters, reference adapters, build e execucao. Formaliza o que adr-138 (context), adr-141 (item 6), adr-144 (filtro spec-side), adr-146 (item 4), adr-147 e o codegen-contract (livesIn/committedHere/runsIn) ja pressupoem.

		(3) MORADA E DISTRIBUICAO DO GERADOR: o gerador cue.Value->domain-types mora no mesh-runtime (adr-146 item 4) e e distribuido como ferramenta invocavel (executavel versionado e reproduzivel). O mesh-spec o invoca via MESH_CODEGEN_TOOLCHAIN; o harness nao depende da localizacao fisica do source. Divisao de autoridade: a SEMANTICA e o contrato do gerador sao governados pelo mesh-spec (P14, design-rules de adr-146, codegen-contract); a IMPLEMENTACAO e a distribuicao pertencem ao mesh-runtime. FF-CG-03 regenera e compara sem confiar em headers.

		(4) ESCOPO MINIMO DA PROVA P1 VIVA — sequencia obrigatoria, 9 itens ancorados: (i) gerador cue.Value->Kotlin: tipos + validadores-wrapper (codegen-contract transform[0]; adr-146; adr-147); (ii) aggregate-skeleton de am-commitment (transform[1] from AggregateManifest; am-commitment em main, generatedArtifacts.kind "aggregate-skeleton"); (iii) port-contracts do pm-cmt — append/readStream (transform[2]; value-class names CANON-PENDING resolvem no canon do runtime); (iv) 1 reference adapter in-memory do EventLogPort — nao 5 (adr-141 item 6: hand-authored e a spec executavel da semantica do Port; pm-cmt portsConsumed=[EventLogPort], referenceAdapterRequired=true); (v) assertion-tests de asrt-mutual-bilateral-acceptance, hand-encoded provisorio, obrigatoriamente encodando ator-distinto + mesmo-commitmentId (rationale INTERINO da assertion; o auto-codegen futuro herda o furo do predicate V1 ate def-053/054 resolverem); (vi) contract-tests Tier-1 gerado + Tier-2 OCC hand-authored (pm-cmt contractTestsRequired); (vii) build multi-module reproduzivel e invocavel por CI; (viii) test-runner provisorio; (ix) pipeline do harness validate-codegen.sh com exit-map pre-fixado 78->{0 CONTINUAR, 75 PIVOTAR, 70 ABANDONAR}. O desfecho registra em codegen-validation-evidence e avalia os gates do adr-138 item 7.

		(5) CAPACIDADE CANONICA vs TECNOLOGIA RUNTIME-LOCAL: o bootstrap REQUER build multi-module reproduzivel e invocavel por CI (capacidade, canonica); a implementacao inicial PREVISTA no mesh-runtime e Gradle (hipotese, runtime-local — nasce ou e ratificada la). Idem test-runner: este ADR AUTORIZA o provisorio hand-encoded (def-049 deferralRationale; codegen-contract testDerivation.provisional); NAO cristaliza a tecnologia de teste — def-049 segue open. Espelha P14 (capacidades exigidas, nao tecnologias) e o filtro adr-139.

		(6) EXCLUSOES EXPLICITAS do bootstrap minimo: def-040 (runtime HTTP — runtime puro, fora da cadeia P1: "nao bloqueia codegen (P1) nem os contratos de Port (P7), e o golden-example nao expoe HTTP"), vendors reais (def-041..045), os outros 4 Ports (Ledger/Workflow/Delivery/Evidence), deploy, frontend, MPS/projections. O bootstrap minimo e gerador + skeleton + adapter + testes + harness — nada mais.

		(7) NOTA ADITIVA NO CODEGEN-CONTRACT registrando morada e distribuicao da toolchain (o contrato localiza outputs e gate; este ADR fecha o silencio sobre a ferramenta). Ver affectedArtifacts.

		(8) HANDOFF: a primeira sessao do mesh-runtime le este ADR e os artefatos citados — codegen-contract, am-commitment, pm-cmt, ge-cmt, validate-codegen.sh, adr-146 design-rules e adr-147 criterios — como o contrato SUFICIENTE PARA O ESCOPO DECIDIDO do bootstrap. Teste de suficiencia: a sessao deve conseguir executar a sequencia do item 4 sem perguntar novamente nada ja decidido e SEM INFERIR SILENCIOSAMENTE DECISOES AUSENTES. Se encontrar lacuna material nao resolvida pelos artefatos canonicos: emitir o mecanismo governado de gap/escalation aplicavel — na ausencia de mecanismo instalado no repo nascente, o mecanismo default E a escalacao ao founder —, interromper APENAS o passo afetado e solicitar decisao do founder; NAO transformar hipotese runtime-local em decisao canonica do mesh-spec.
		"""

	consequences: """
		Positivas: (P1c) A primeira sessao do mesh-runtime tem contrato suficiente para o escopo decidido — handoff legivel, nao arqueologia de 6 ADRs. (P2c) Fronteira spec/runtime formalizada: semantica e contrato aqui; implementacao, distribuicao e execucao la. (P3c) O silencio do codegen-contract sobre a toolchain fecha (nota aditiva, item 7): morada + distribuicao + contrato de invocacao via MESH_CODEGEN_TOOLCHAIN. (P4c) Gradle e test-runner preservados como hipoteses runtime-locais — o filtro adr-139 (capacidade canonica vs tecnologia) fica intacto; def-049 segue open.

		Negativas / limitacoes: (N1) Assume que o escopo minimo derivado (item 4) esta completo para a prova P1 — se a execucao revelar item ausente, a falsificacao (a)/(b) captura e o desfecho e PIVOTAR por insuficiencia de spec/escopo. (N2) A evidencia viva segue pending ate o mesh-runtime existir e o harness rodar — este ADR NAO a substitui; codegen-validation-evidence permanece o unico registro de desfecho.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			O contrato de bootstrap estara errado se a execucao revelar: (a) o gerador nao consegue consumir am-commitment sem inventar informacao ausente do manifest; (b) o slice minimo exige vendor SDK ou Port nao previsto alem do EventLogPort; (c) o harness permanece incapaz de gerar, compilar e testar depois de a toolchain ter sido resolvida como executavel e todas as precondicoes declaradas do bootstrap terem sido satisfeitas; (d) o output gerado exige edicao semantica manual para compilar ou passar, violando P1 e o gate ABANDONAR do adr-138; ou (e) a sequencia minima completa nao produz um desfecho deterministico CONTINUAR, PIVOTAR ou ABANDONAR em codegen-validation-evidence.
			"""
		observableSignal: """
			Os sinais sao observaveis no primeiro run real do harness: exit codes do exit-map predefinido; diff canonico de generated/ por FF-CG-03; e os campos gates de codegen-validation-evidence deixando o estado not-evaluated. Depois de a toolchain ser resolvida como executavel e as precondicoes do bootstrap estarem satisfeitas, exit 78 nao e um desfecho admissivel. Os sinais (a) e (b) normalmente indicam PIVOTAR por insuficiencia da spec ou erro de escopo. O sinal (d) indica ABANDONAR ou reselecionar a toolchain. Para (c) e (e), a causa-raiz determina o resultado: configuracao, implementacao ou protocolo corrigivel implica PIVOTAR; incapacidade estrutural da toolchain de satisfazer o contrato implica ABANDONAR. Nenhum desfecho e atribuido apenas pelo sintoma.
			"""
	}

	affectedArtifacts: [
		"governance/build-time/codegen-contract.cue",
		"scripts/ci/validate-codegen.sh",
		"governance/build-time/codegen-validation-evidence.cue",
	]

	plannedOutputs: []

	derivedArtifacts: []

	defersTo: []

	principlesApplied: ["P0", "P1", "P7", "P10", "P14"]

	supersedes: []

	rationale: """
		Contrato de bootstrap/handoff, nao de execucao: o valor deste ADR e a primeira sessao do mesh-runtime nascer lendo um contrato unico em vez de reconstruir a decisao por arqueologia — e o item 1 impede que a existencia do contrato seja confundida com a execucao do bootstrap (a evidencia segue pending). P0: cada decisao citada permanece na sua localizacao canonica (adr-138 fronteira, adr-141 Ports/adapters, adr-146 design-rules, adr-147 linguagem, codegen-contract transform); este ADR aponta, nao copia. P1: a fronteira repo-separado + P1-estrito (gerado nunca committado no mesh-spec) e a razao da morada; o exit-map do harness e P1 enforcado operacionalmente. P7: o slice minimo sobe atras de 1 Port canonico (EventLogPort) com reference adapter como spec executavel. P10: o desfecho dos gates e por CAUSA-RAIZ avaliada, nunca por sintoma — exit codes e diffs sao sinais deterministicos que INFORMAM a decisao do founder, nao veredito automatizado; e o item 8 fecha a inferencia silenciosa exigindo escalation governada por lacuna. P14: o que se exige do runtime sao CAPACIDADES (build reproduzivel invocavel por CI; teste derivavel de assertion), nunca tecnologias — Gradle e o test-runner sao hipoteses runtime-locais, ratificadas ou substituidas la (filtro adr-139).

		A reversibilidade media com blast-radius repo-wide e coerente: o contrato orienta o nascimento do runtime inteiro e a fronteira spec/runtime que todos os BCs atravessam (repo-wide); e reversivel enquanto a evidencia esta pending — revisar o contrato antes do primeiro run custa pouco —, mas apos o primeiro run real a falsificacao (a)-(e) e que governa a revisao, nao edicao livre (medium).

		Tensao com axiomas: nenhuma.
		"""
}
