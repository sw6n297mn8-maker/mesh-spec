package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr140: artifact_schemas.#ADR & {
	id:    "adr-140"
	title: "Estabelecer o contrato de codegen: CUE SoT, derivados duráveis, ContractGate"

	date: "2026-06-04"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		A reconciliação de stack (adr-138 runtime-bootstrap; adr-139 keystone-first)
		estabeleceu que a stack mínima materializa-se em dois ADRs no caminho crítico
		até o golden-example, com o codegen como keystone — codegen primeiro (este
		ADR), kernel depois (adr-141). adr-140 cristaliza o contrato de codegen: como
		os schemas CUE, que já são a source of truth dos contratos de domínio (P1),
		tornam-se tipos, validadores e stubs executáveis sem código escrito à mão. O
		pré-requisito de domínio está cumprido — o CMT, primeiro bounded context
		completo em main (Fatias A+C e B), fornece o domínio real (bd-mutual-acceptance
		e a invariante inv-mutual-bilateral-acceptance) contra o qual o golden-example
		exercitará o codegen end-to-end.

		Esta decisão fixa apenas o lado durável (spec) sob o filtro spec×runtime de
		adr-139: linguagem-alvo, toolchain, contrato de geração, serialização,
		compatibilidade e gate. O lado volátil — versões de biblioteca, configuração
		de build, ambiente de CI, e o runtime HTTP (framework, IdP, ingress) — não
		entra aqui: vive em mesh-runtime ou é deferido (def-040). O propósito é tornar
		P1 concreto sem acoplar a spec a escolhas de implementação substituíveis.

		Downstream: adr-141 (WI-103) decide os Port contracts (P7 concreto) e o
		aggregate skeleton — fora deste ADR por keystone-first. WI-134 define o
		contrato de transformação spec→runtime (governance/build-time/codegen-contract.cue)
		consumindo adr-140 + adr-141; WI-137 autora o golden-example CMT com harness de
		codegen-validation, exercitando o contrato contra domínio real.

		Alternativas avaliadas:
		(a) JSON Schema como SoT — rejeitada: sem compatibility checking built-in,
		    codegen para linguagem-alvo fraco, e duplicação obrigatória com .proto.
		(b) Protobuf como SoT — rejeitada: acopla schema format ao transport (gRPC),
		    arrasta vendor (classes herdando de GeneratedMessageV3) para dentro do
		    domínio violando P2, e elimina a opcionalidade de interop in-process.
		(c) Avro como SoT — rejeitada: ecossistema Confluent-centric, viola zero
		    vendor no domínio (P2).
		(d) Schema-less / convention-based (payloads como mapas não-tipados) —
		    rejeitada: incompatível com contracts-first (P1), impossibilita codegen e
		    fitness functions.
		(e) JSON como serialização — rejeitada em favor de Ion: sem decimal nativo
		    (ambiguidade string-vs-number em monetários), sem canonical form para
		    checksum, sem subsumption para compatibility.
		(f) .proto volátil (regenerado, não committed) — rejeitada: sem âncora estável
		    para buf breaking e sem o artefato promovível que sustenta a exit strategy.
		(g) #Assertion como meta-spec lateral (fora do pipeline de contratos) —
		    rejeitada: perderia participação em FF-04 / compatibility 3-camadas e
		    violaria a disciplina P0/P1 (toda unidade de contrato tem localização
		    canônica e SchemaRef).
		(h) Aggregate skeleton dentro de adr-140 — rejeitada: skeleton é semântica de
		    kernel (adr-141); incluí-lo quebraria keystone-first.
		"""

	decision: """
		(1) ESTABELECER CUE como source of truth único do codegen: todo contrato de
		    domínio (eventos, commands, queries, ledger entries, workflow signals) é
		    definido em CUE; tipos, validadores e stubs são gerados, nunca escritos à
		    mão (P1). Artefatos derivados são committed mas jamais editados à mão —
		    edição manual é drift por construção (P0).

		(2) ESTABELECER o pipeline de codegen multi-target via .proto intermediário
		    durável: CUE gera .proto, Ion Schema e JSON Schema; o .proto gera os tipos
		    na linguagem-alvo. O .proto é committed derived artifact — durável,
		    versionável, auditável — não um passo transiente.

		(3) ADOTAR Amazon Ion como serialização canônica de payload, governada por
		    quatro regras:
		    - Ion-1 (Canonicalization): o checksum de evento é SHA-256 da Ion canonical
		      form do payload; não há serialização custom de canonicalization.
		    - Ion-2 (SchemaRef): SchemaRef é o identificador canônico do payload; o
		      pipeline gera, de CUE, o Ion Schema type (.isl) usado para validação e o
		      $id do JSON Schema usado para documentação. Schema registry de runtime
		      para lookup dinâmico é deferido (decisão futura, conforme canônico —
		      necessário quando BCs forem extraídos).
		    - Ion-3 (Compatibility): validada em três camadas (CUE lattice + Ion Schema
		      subsumption + buf breaking nos .proto); todas MUST pass.
		    - Ion-4 (Decimal Normalization): todo campo monetário serializa como Ion
		      decimal e Currency como Ion symbol (ISO 4217), 1:1 sem perda; nenhum
		      campo monetário usa Ion float ou int.

		(4) ESTABELECER compatibility como gate de CI em três camadas com direção
		    declarada por família (events backward-only; commands none/intra-BC;
		    queries backward-only; ledger versioned; workflows versioned+migrated;
		    routing/authorization additive; projections rebuildable; reconciliation
		    versioned). Schema incompatível com a direção declarada = build failure.

		(5) ESTABELECER o ContractGate como gate determinístico de CI (P10): agentes
		    estocásticos recomendam, gates determinísticos validam. Valida shape (cue
		    vet), compatibility 3-camadas, consistência dos derivados, integridade
		    referencial cross-family e ownership — reprodutível, sem variância.

		(6) ESTABELECER #Assertion como artifact-class de primeira ordem no pipeline de
		    contratos, com SchemaRef próprio e participação em FF-04 / compatibility
		    3-camadas — fonte canônica para geração ou derivação de testes de runtime.
		    O MECANISMO concreto de assertion-to-test é deferido a def-049.

		(7) MANTER o aggregate skeleton FORA deste ADR: geração de skeleton é semântica
		    de kernel e pertence a adr-141, preservando keystone-first.

		(8) ESTABELECER a exit strategy: se o ferramental CUE estagnar, os .proto
		    committed são promovidos a source of truth (custo em semanas; queda para
		    Protobuf). É substituição condicional de um SoT por outro — em todo
		    instante há exatamente uma source of truth, preservando P0.

		(9) ESTABELECER o slice de contrato HTTP durável: Money como string decimal em
		    REST JSON; todo payload referencia via $ref o JSON Schema gerado de CUE,
		    zero schema inline.

		(10) DEFERIR o runtime HTTP (framework, IdP, ingress) a def-040.
		"""

	consequences: """
		Positivas:
		(P1c) P1 deixa de ser aspiracional e vira pipeline verificável: tipos,
		      validadores e stubs são output determinístico de CUE (FF-CG-03 via git
		      diff em generated/), não código hand-written que diverge da spec — a
		      classe de drift spec↔código é eliminada por construção.
		(P2c) P0 honrado: contracts/cue é a única localização canônica de cada
		      contrato; .proto/Ion Schema/JSON Schema são materializações committed mas
		      never-edited — observável, pois qualquer edição manual quebra FF-CG-03.
		(P3c) P2 honrado: CUE desacopla schema format de transport; nenhum vendor
		      (GeneratedMessageV3, Confluent) entra no domínio — fica atrás de adapter.
		(P4c) P10 honrado: o ContractGate é gate determinístico e reproduzível (cue vet
		      + compat 3-camadas + integridade referencial), nunca LLM — breaking
		      change bloqueia merge sem julgamento humano item-a-item.
		(P5c) Exit strategy preservada sem custo presente: o .proto committed é o
		      caminho de saída para Protobuf (semanas), e P0 é mantido em todo instante
		      (um SoT por vez).
		(P6c) O golden-example CMT (WI-137) ganha contrato concreto para exercitar
		      end-to-end contra inv-mutual-bilateral-acceptance — prova executável do
		      path spec→contratos→tipos→testes, não aspiracional.

		Negativas / limitações:
		(N1) Dívida governada explícita: def-040 (runtime HTTP) e def-049 (mecanismo
		     assertion-to-test) entram como deferrals reais — o contrato de codegen não
		     está completo até resolvê-los; cada um carrega trigger de revisita.
		(N2) Curva de aprendizado do ferramental CUE (lattice, cue export, transform
		     CUE→Ion Schema) concentra-se no caminho crítico até o golden-example —
		     risco de schedule.
		(N3) Cobertura CUE→.proto pode ter gaps exigindo overrides hand-maintained;
		     cada override é vetor de shadow-SoT que tensiona P0 — mitigado por
		     ContractGate + FF-CG-03 e monitorado pela falsificationCondition deste ADR.
		(N4) O mecanismo concreto de assertion-to-test fica deferido (def-049): adr-140
		     fixa a PONTE (#Assertion é fonte canônica de teste) mas não o COMO; WI-137
		     depende de def-049 resolver (ou de mecanismo provisório) para derivar
		     testes executáveis.
		(N5) REINTERPRETADO por adr-146: o item 2 declarava o .proto como IR-de-domain-types
		     (CUE→.proto→tipos na linguagem-alvo). adr-146 estabelece P14 (fidelidade de
		     forma) e move a geração de domain-types para o cue.Value direto — proto3 apaga
		     exaustividade-de-estado e presença-de-campo (medido), forma que o cue.Value
		     direto preserva. O .proto PERMANECE no escopo deste ADR para os papéis que não
		     geram tipos: compatibilidade (Ion-3, buf breaking nos .proto) e exit-strategy
		     (item 8). É reinterpretação do escopo do item 2, não supersession: adr-140
		     segue proposed e vigente nos demais itens. Consequência sobre FF-CG-03: o alvo
		     de regeneração-e-diff em generated/ re-aponta para os domain-types gerados do
		     cue.Value; os derivados .proto/Ion/JSON seguem cobertos por FF-CG-03 para
		     compat/wire/exit. Mesmo mecanismo (git diff em generated/), alvo de tipos
		     re-apontado — as menções a FF-CG-03 abaixo (P2c, rationale) permanecem válidas;
		     esta nota é a localização canônica única da re-apontagem (P0).
		(N6) adr-147 resolve o placeholder de linguagem-alvo dos domain-types gerados: Kotlin.
		     Isto NÃO promove adr-140 a accepted — a condição de migração segue amarrada ao
		     golden-example provar a hipótese P1/codegen.
		"""

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	falsificationCondition: {
		condition: """
			Esta decisão estará errada SE a geração a partir de CUE não cobrir o espaço de
			contratos sem manutenção manual significativa — i.e., se artefatos derivados
			hand-maintained (overrides .proto, tipos escritos à mão) proliferarem a ponto
			de CUE deixar de ser efetivamente o SoT único, emergindo um shadow-SoT que
			viola P0/P1.
			"""
		observableSignal: """
			Presença persistente de overrides hand-maintained (ex.: contracts/proto-overrides/)
			com razão override:gerado acima do budget declarado no codegen-contract (WI-134);
			OU o harness de codegen-validation do golden-example (WI-137) exigindo tipos/testes
			de runtime escritos à mão não-deriváveis de CUE/#Assertion. FF-CG-03 (git diff em
			generated/) deixando de bastar como gate.
			"""
	}

	affectedArtifacts: [
		"governance/wave-plan.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-040-http-runtime-stack.cue",
		"architecture/deferred-decisions/def-049-assertion-to-test-mechanism.cue",
	]

	defersTo: ["def-040", "def-049"]

	principlesApplied: ["P0", "P1", "P2", "P10", "P12", "dp-04", "dp-07"]

	supersedes: []

	rationale: """
		P1 (código gerado) é o princípio central: adr-140 É a materialização de P1 —
		decide o path CUE→tipos/validadores/stubs que valida a hipótese de que código é
		materialização da spec, não artefato paralelo. Sem este contrato, P1 permanece
		declaração.

		P0 (localização canônica única) governa a disciplina de derivados e a exit
		strategy: CUE permanece SoT único enquanto viável; .proto derivado é
		materialização sob disciplina FF-CG-03 (never-hand-edit, committed para
		versionamento e auditoria); exit é substituição condicional de um SoT por
		outro, preservando P0 em todo instante. Não há coexistência de dois SoTs — por
		isso não há tensão com P0 (sem tension-entry).

		P2 (zero vendor no domínio) elimina Protobuf-como-SoT e Avro: ambos arrastariam
		vendor (GeneratedMessageV3, Confluent) ou acoplariam schema a transport; CUE
		desacopla, mantendo vendor atrás de adapter. JSON-Schema-como-SoT e schema-less
		violam P1 (sem compat gate / sem codegen). CUE é a única opção que honra P1 e
		P2 simultaneamente.

		P10 (gates determinísticos) + P12 (governança é código): o ContractGate e as
		fitness functions (FF-04, FF-CG-03) são gate determinístico de CI, não revisão
		estocástica — compat é regra executável, não convenção.

		dp-04 (determinismo operacional): Ion canonical form (checksum), codegen
		determinístico (FF-CG-03) e Ion-4 (decimal exato em monetários) sustentam
		operações financeiras determinísticas. dp-07 (evolução sem reescrita): schemas
		versionados + compat 3-camadas por família evoluem contratos sem reescrever
		consumidores.

		Relações: herda o enquadramento real-options de adr-138 (stack como hipótese
		falsificável) e o filtro spec×runtime + keystone-first de adr-139. Downstream:
		adr-141 decide kernel/Ports e o aggregate skeleton (fora daqui); WI-134
		materializa o contrato de transformação spec→runtime (governance/build-time/codegen-contract.cue)
		consumindo adr-140 + adr-141; WI-137 é o consumidor de prova (golden-example CMT).
		"""
}
