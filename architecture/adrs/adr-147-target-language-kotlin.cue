package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-147 -- Linguagem-alvo dos domain-types gerados: Kotlin. Resolve o
// placeholder "linguagem-alvo" de adr-140 (3x). Filho de adr-146 (P14:
// geracao do cue.Value preserva forma) + adr-141 (interface de Port ja Kotlin).
// Decisao instrumentada: nasce com 2 criterios estruturais (refutam a
// linguagem) + 3 trataveis (engenharia, nao reabrem) + Rust papel-duplo.
// Prior-art ADR-C4-01 do Mesh-Old citado como convergencia independente,
// NAO-vinculante.

adr147: artifact_schemas.#ADR & {
	id:    "adr-147"
	title: "Linguagem-alvo dos domain-types gerados: Kotlin"

	date: "2026-06-10"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		adr-140 fixou o contrato de codegen mas deixou "linguagem-alvo" como placeholder generico (3x: itens de contexto/alternativa/decisao). adr-146 (P14) estabeleceu as capacidades-minimas que a linguagem-alvo dos domain-types DEVE ter -- (i) tipos-soma fechados com exaustividade verificada, (ii) ausencia-de-nulo no tipo, (iii) tipos-embrulho inescapaveis -- e moveu a geracao para o cue.Value direto. Resta cravar a linguagem.

		P14 ja ELIMINA Go (spike 1: Go vaza exaustividade-de-estado e presenca-de-campo; sem ADTs nem non-null no tipo). Sobram Kotlin e Rust, e os dois SATISFAZEM as 3 capacidades e EMPATAM na correcao-tipada: spikes 1/3/4 mediram 16/16 probes de violacao FORCANDO compile-error em ambos (struct aninhado, sum-type-com-payload, presenca, wrappers de constraint). A vantagem-de-codegen que o Rust exibiu no spike 2 (prost mais enxuto/fiel que protoc-Kotlin) era ARTEFATO DO INTERMEDIARIO .proto, nao da linguagem: com o gerador-do-cue.Value de P14 (que pula o proto3), os dois alvos saem igualmente fieis -- a exaustividade e a presenca chegam intactas em sealed/enum + non-null nos dois.

		Empatada a correcao por demonstracao, o desempate e por dois eixos: (a) COERENCIA -- a interface de Port ja e Kotlin (adr-141 itens 3-4: "INTERFACE KOTLIN E PROJECAO VERIFICADA"; features do sistema de tipos Kotlin na fronteira); cravar Kotlin nos domain-types da um sistema, uma linguagem, sem ponte de tipos entre o tipo gerado e a interface que o consome; (b) AUTOR-AGENTE -- o codigo e escrito por agentes (nao humanos), entao o que pesa e a densidade de corpus Kotlin/fintech no treino dos LLMs e a informatividade dos erros do compilador para autocorrecao no loop agentico, nao ergonomia humana.

		PRIOR-ART (convergencia independente, NAO-vinculante): o ADR-C4-01 do Mesh-Old (aceito) chegou a Kotlin pela MESMA porta, anos antes, sem este pipeline. Matriz de scoring: Kotlin 425 escolhida; F#+C# .NET 427 pontuou MAIS e foi rejeitada por ecossistema ("Empatado com Kotlin; rejeitado por corpus canonico cristalizado, JVM como runtime mais instrumentado"); Go 345 rejeitado ("Sem ADTs. Interfaces implicitas. Domain modeling pobre" -- exatamente o defeito que P14 agora formaliza como inelegibilidade). O raciocinio-raiz do C4-01, verbatim: "Mesh e operada inteiramente por IA. Isso recalibra os criterios de escolha de linguagem: curva de aprendizado humano e irrelevante; o que importa e (1) taxa de acerto do codigo gerado por LLMs (corpus canonico), (2) guardrails do compilador como substituto de code review humano [...]" (o C4-01 lista ainda (3) maturidade de frameworks e (4) observabilidade -- elididos aqui) -- identico ao criterio desta decisao, derivado independentemente. Os papeis complementares do prior-art (Rust para modulos criticos, Python confinado a ML/Agents, TypeScript no frontend, Ktor como framework HTTP) sao citados como DIRECAO, nao re-cravados aqui.

		Alternativas avaliadas: (a) Rust como linguagem-alvo dos domain-types -- empata a correcao-tipada (16/16) e empatou a fidelidade-de-codegen pos-P14; perde nos dois eixos de desempate (coerencia com a interface Kotlin; corpus agentico) -- permanece ALTERNATIVA-VIVA, com papel duplo no item 5. (b) Go -- inelegivel por P14 (spike 1 e o prior-art C4-01 convergem: sem ADTs, sem non-null). (c) F#/.NET -- satisfaz P14 (DUs + non-null), rejeitada por ecossistema (corpus/observabilidade/instrumentacao JVM), exatamente como o prior-art ja havia decidido. (d) Adiar a decisao -- rejeitada: o placeholder de linguagem-alvo bloqueia o gerador-do-cue.Value, o bootstrap do mesh-runtime e a prova viva de P1; adiar e custo sem opcionalidade ganha (a analise ja esta feita).
		"""

	decision: """
		(1) KOTLIN E A LINGUAGEM-ALVO dos domain-types gerados do cue.Value (P14, adr-146). Satisfaz as tres capacidades-minimas de P14, provado por demonstracao nos spikes (16/16 FORCA): (i) sealed interface = tipos-soma fechados com when exaustivo; (ii) non-null por padrao = ausencia-de-nulo no tipo; (iii) @JvmInline value class com construtor privado = tipos-embrulho inescapaveis.

		(2) CRITERIO ESTRUTURAL 1 -- FIDELIDADE AO SPEC. O criterio-chave nao e "Kotlin e boa linguagem"; e "Kotlin sustenta o contrato CUE->codigo sem atrito". Sinais medidos POR FATIA desde o primeiro codegen: (a) falhas de ContractGate distinguindo limitacao expressiva da linguagem de erro de implementacao; (b) proporcao de invariantes CUE que degradam para validacao runtime QUANDO P14 CLASSIFICA A CONSTRUCAO COMO COMPILE-TIME-VERIFICAVEL (proporcao crescente = P14 violado na pratica pela linguagem-alvo); (c) drift #Assertion<->codigo gerado, medido como correcoes manuais pos-codegen por fatia (correcao manual semantica = violacao de P1). A regra deterministica de classificacao (limitacao-expressiva vs erro-de-implementacao) sera definida quando o ContractGate materializar no mesh-runtime CI; ate la, o sinal (c) e advisory e nao participa da falsificacao -- os sinais (a) e (b) a carregam. Datapoint zero: os gates de ge-cmt-mutual-acceptance (continuar/pivotar/abandonar), com o desfecho registrado em codegen-validation-evidence.

		(3) CRITERIO ESTRUTURAL 2 -- QUALIDADE DO CODIGO POR AGENTES. O autor e o agente, nao o humano. Sinais desde a primeira fatia: taxa de compilacao first-try do codigo gerado/autorado; numero de iteracoes ate o golden-example fechar; informatividade dos erros do compilador Kotlin para autocorrecao -- a qualidade da interface agente<->linguagem. Uma linguagem boa para humano nao e necessariamente boa para o loop agentico; este criterio mede o loop, nao a ergonomia.

		(4) TRES CRITERIOS TRATAVEIS -- falha aqui e ENGENHARIA, NAO reabre a linguagem: (a) RUNTIME BANCARIO (observavel so com carga real): p99 de liquidacao sob pausas de GC; throughput de replay/reidratacao de agregados (P3 event-sourcing / P5 workflow); structured concurrency sob carga. Mitigacoes a esgotar ANTES de qualquer reabertura: GraalVM native-image, tuning de GC/JVM, sidecar Rust pontual no hot-path (prior-art C4-01). (b) INTEROP Ion<->Kotlin (observavel em producao): bugs de round-trip de serializacao. Ressalva dura: QUALQUER perda de fidelidade no caminho-de-tipos NAO e friccao toleravel -- e bug do gerador OU falsificacao de P14, tolerancia zero (cai no criterio estrutural 1, nao aqui). (c) CUSTO DE EVOLUCAO (observavel em ~6 meses): tempo de build Gradle com o crescimento do monorepo; lead time por fatia. Degradacao aqui e tooling/build, nao arquitetura de linguagem.

		(5) RUST -- PAPEL DUPLO. (a) FALLBACK GOVERNADO: se os criterios estruturais (itens 2-3) falharem RECORRENTEMENTE por razao-de-linguagem, Rust e o CANDIDATO PREFERENCIAL DE REAVALIACAO para os domain-types -- a analise comparativa ja esta feita (empate tecnico provado nos spikes) e a reabertura e barata. NAO e failover automatico: a troca exige ADR proprio + decisao do founder. (b) CO-ALVO para modulos criticos ("erro = perda irreversivel", per prior-art): o gerador-do-cue.Value ja emite Rust com fidelidade identica a Kotlin (spike 4), entao um modulo critico futuro pode receber os MESMOS domain-types em Rust nativo, sem ponte de tipos. Deferido ate existir um modulo concreto que o exija; nao se antecipa aqui.

		(6) def-049 (mecanismo assertion-to-test) segue open. adr-147 ESTREITA o ecossistema de teste para a JVM (consequencia de Kotlin) mas NAO resolve a tecnologia concreta de teste -- essa escolha permanece em def-049.

		(7) RESOLVE o placeholder de linguagem-alvo de adr-140 via nota aditiva (N6) em consequences (precedente N5/adr-146). Nao promove adr-140 a accepted.
		"""

	consequences: """
		Positivas:
		(P1c) Destrava o gerador-do-cue.Value (alvo concreto), o bootstrap do mesh-runtime e a prova VIVA de P1 -- o placeholder era bloqueante.
		(P2c) Um sistema, uma linguagem: domain-types gerados e interface de Port (adr-141) na mesma linguagem, sem ponte de tipos entre o gerado e o consumidor.
		(P3c) Decisao instrumentada: nasce com protocolo de refutacao (2 criterios estruturais medidos por fatia) e desfechos definidos (Rust como reavaliacao governada), nao como aposta sem gatilho de revisao.
		(P4c) Rust fica utilizavel sem novo projeto: o co-alvo para modulos criticos esta provado (spike 4), nao e trabalho futuro de pipeline.

		Negativas / limitacoes:
		(N1) Aposta no ecossistema JVM para o perfil bancario (latencia/GC/replay) -- as mitigacoes estao nomeadas (GraalVM, tuning, sidecar Rust) mas o risco so e observavel pos-runtime, com carga real; e criterio tratavel (item 4a), nao falsificacao da linguagem.
		(N2) Os criterios estruturais exigem DISCIPLINA DE MEDICAO por fatia desde o primeiro codegen -- sem a serie de sinais (itens 2-3), a falsificationCondition vira condicao morta. A medicao e responsabilidade do fluxo de codegen no mesh-runtime.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			A decisao estara errada se os criterios estruturais falharem RECORRENTEMENTE por razao-de-linguagem: (1) a proporcao de invariantes CUE que degradam para validacao runtime -- QUANDO P14 classifica a construcao como compile-time-verificavel -- crescer ao longo das fatias em vez de convergir a zero (sinal de que Kotlin nao sustenta a forma que P14 exige); OU (2) o loop agentico nao convergir -- iteracoes-ate-compilar/passar causadas por idiossincrasias do Kotlin NAO cairem fatia a fatia. Falhas nos tres criterios trataveis (runtime bancario, interop Ion, custo de build) NAO falsificam esta decisao -- sao engenharia, com mitigacoes nomeadas, e nao reabrem a linguagem.
			"""
		observableSignal: """
			Medido por fatia, desde o primeiro codegen: (a) contagem de invariantes P14-compile-time-verificaveis que foram implementados como validacao runtime no codigo gerado (alvo: zero; crescimento = falsificacao); (b) taxa de compilacao first-try e numero de iteracoes ate o golden-example fechar (alvo: tendencia de queda fatia a fatia); (c) falhas de ContractGate classificadas como limitacao-expressiva-da-linguagem vs erro-de-implementacao (alvo: zero da primeira classe) -- advisory ate a regra de classificacao existir (ver decision item 2); os sinais (a) e (b) carregam a falsificacao. Datapoint zero: os gates de ge-cmt-mutual-acceptance registrados em governance/build-time/codegen-validation-evidence.cue. No fan-out: acumula via templateRole.divergencePolicy do golden-example (adr-138 falsificationCondition -- nº de BCs cuja implementacao diverge do template).
			"""
	}

	affectedArtifacts: [
		"architecture/adrs/adr-140-codegen-contracts.cue",
	]

	plannedOutputs: []

	derivedArtifacts: []

	defersTo: []

	principlesApplied: ["P1", "P7", "P10", "P14"]

	supersedes: []

	rationale: """
		A decisao NAO e "Kotlin e uma boa linguagem" -- e "Kotlin sustenta o contrato CUE->codigo sem atrito", e nasce instrumentada para se provar ou se refutar (itens 2-3 + falsificationCondition). O desempate foi por coerencia (interface de Port ja Kotlin, adr-141) + autor-agente (corpus/erros-de-compilador no loop) PRECISAMENTE porque a correcao-tipada empatou por demonstracao (Kotlin e Rust, 16/16 nos spikes) -- nao havia vencedor tecnico para decidir sozinho, entao os eixos de desempate sao legitimos, nao preferencia.

		P1 (codigo gerado): adr-147 da o alvo concreto que torna o gerado materializavel; sem ele P1 fica sem destino. P7 (5 Ports, value classes na fronteira): Kotlin @JvmInline value class materializa a regra zero-raw-String/Long na fronteira de Port, e a interface de Port ja e Kotlin (adr-141) -- uma linguagem na fronteira. P10 (gates deterministicos): os criterios estruturais sao medidos por sinais observaveis (compila/nao-compila, contagem de degradacoes), nao por julgamento de LLM; o desfecho Rust exige ADR (founder), nao gate-estocastico. P14 (fidelidade de forma): adr-147 escolhe a linguagem cujas tres capacidades P14 exige, provadas por demonstracao -- e o criterio estrutural 1 e exatamente a vigilancia continua de que P14 se sustenta na pratica.

		Rust permanece alternativa-viva com papel duplo (item 5) porque o empate tecnico e real: a reabertura para domain-types e barata (analise feita) mas exige ADR; e o co-alvo para modulos criticos ja esta provado (spike 4: o gerador emite Rust com a mesma fidelidade). Prior-art ADR-C4-01 (Mesh-Old) e convergencia independente -- Kotlin pela mesma porta (corpus + compilador-como-gate em sistema operado por IA), com Go rejeitado pelo defeito que P14 formaliza -- citado para corroborar, nao para vincular.

		reversibility=medium / blastRadius=repo-wide coerente com adr-140/adr-146: repo-wide porque a linguagem-alvo governa o codegen de todo BC; medium porque a troca para Rust (alternativa-viva) e ADR sem migrar dado persistido AGORA (nao ha runtime ainda), mas fica mais cara conforme o mesh-runtime materializa em Kotlin. Nenhum vendor/runtime fisico e escolhido aqui -- spec-side puro (filtro adr-139); a stack de execucao segue atras dos Ports.
		"""
}
