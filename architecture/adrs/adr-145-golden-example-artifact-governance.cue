package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-145 -- GoldenExample como ArtifactType governado (formaliza o tipo).
// Filho de adr-138 (estrategia de runtime bootstrap): adr-138 decidiu o MECANISMO
// do golden-example; adr-145 formaliza o TIPO (schema + PG + enum + cobertura
// sc-pg-01). Declaracao-pura: a evidencia de run vive em codegen-validation-
// evidence (WI-137). Referencia adr-138, NAO duplica.

adr145: artifact_schemas.#ADR & {
	id:    "adr-145"
	title: "GoldenExample como ArtifactType governado"

	date: "2026-06-08"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		adr-138 (estrategia de runtime bootstrap, em main) decidiu o MECANISMO do golden-example: escopo microscopico CMT (bd-mutual-acceptance), o pipeline businessDecision/invariant -> assertion -> contratos -> codegen -> testes -> execucao local -> evidencia, os gates CONTINUAR/PIVOTAR/ABANDONAR (item 7, real-options), a falsificacao P1-strict (proibido editar semanticamente o output gerado) e o papel de template (P3c). Mas adr-138 NAO formalizou #GoldenExample como artifact-type governado.

		CLAUDE.md (tabela de referencias) e README (contexts/{bc}/golden-examples/; "Pelo menos 1 golden-example") referenciam golden-examples como artefato per-BC, mas o tipo nunca teve schema -- 0 instancias. WI-136 fecha essa lacuna: materializa #GoldenExample como ArtifactType de primeira classe (schema CUE, extensao do enum #ArtifactType, production-guide, cobertura sc-pg-01), para que WI-137 possa autorar a 1a instancia (CMT bd-mutual-acceptance) sob gate.

		TENSAO declaracao vs evidencia, resolvida: o golden-example tem dois ciclos de vida. A DECLARACAO (o que o experimento E: recorte de spec, assertions, alvo de codegen, gates, papel de template) e estavel e copiavel como template (P3c). A EVIDENCIA (o que o experimento PRODUZIU: qual gate foi atingido, divergencias) muda a cada run. adr-145 separa: a declaracao vive em #GoldenExample; a evidencia vive em governance/build-time/codegen-validation-evidence.cue (output de WI-137), que REFERENCIA o golden-example -- direcao evidencia->declaracao, mesmo padrao de agent-probe-record -> targetCanvas.

		Alternativas avaliadas: (a) ArtifactType governado declaracao-pura -- ESCOLHIDA: formaliza o tipo que CLAUDE.md/README ja pressupoem, sob o mesmo regime de adr-144 (schema + enum + PG + cobertura), com a evidencia separada por ciclo de vida; (b) #GoldenExample contendo a evidencia inline -- rejeitada: quebra o template-role (o fan-out copiaria resultado-de-run obsoleto) e inverte a direcao evidencia->declaracao do repo; (c) nao formalizar o tipo (golden-example como arquivo livre) -- rejeitada: 0 gate, 0 disciplina de autoria para agente estocastico, contradiz CLAUDE.md (todo tipo conhecido tem schema); (d) shared-schema leve -- rejeitada: golden-example e instanciado por autoria estocastica (1+ por BC no fan-out), o que justifica PG + quality-criteria proprios como adr-144 decidiu para manifests.
		"""

	decision: """
		(1) #GoldenExample E ARTIFACTTYPE GOVERNADO, DECLARACAO-PURA. Torna-se tipo de primeira classe em architecture/artifact-schemas/, membro do enum #ArtifactType, sob cobertura sc-pg-01 e quality-criteria proprios (tq-ge-01/02/03). A instancia declara SO o experimento; zero campo de evidencia.

		(2) SCHEMA CUE. #GoldenExample = {id (ge-*), boundedContextRef, businessDecisionRef, specSlice (invariantRefs/commandRefs/eventRefs/aggregateRef), assertionRefs (refs a #Assertion, WI-133), codegenTarget (kinds que o codegen-contract de adr-140 gera), gates (continuar/pivotar/abandonar/p1Strict/falsificationSignal como CONDICAO, adr-138 item 7), templateRole (P3c)}. Os campos derivam de adr-138; os refs sao strings (ids) validadas por review + harness, nao cross-ref estatico.

		(3) ENUM #ArtifactType ESTENDIDO. Adiciona-se "golden-example" ao enum em quality-criteria.cue, com abreviacao "ge" no bloco de convencao de ids. Append nao-destrutivo. Sem isso o tipo nao entra no regime de self-review (tq-ge-* inertes).

		(4) PRODUCTION-GUIDE. golden-example.cue com _schema.location, _qualityCriteria (tq-geg-01/02), prerequisites e workOrder/sections bijetivos (sc-pg-02/03). O nome "golden-example" e adicionado a sc-pg-01.coveredSchemas no MESMO commit (cascade ordering). O PG existe porque o golden-example e preenchido por agente estocastico no fan-out.

		(5) SEPARACAO DECLARACAO/EVIDENCIA. A declaracao vive em #GoldenExample (este tipo); a evidencia de run vive em governance/build-time/codegen-validation-evidence.cue (output de WI-137), que referencia o golden-example (direcao evidencia->declaracao). #GoldenExample NAO tem ponteiro para evidencia -- a declaracao e pura e copiavel para o fan-out (template P3c).

		(6) REF-INTEGRITY SEM STRUCTURAL-CHECK ESTATICO (escolha, ver consequences N1). Apenas sc-pg-01 (cobertura de PG) entra neste arco; nao se cria structural-check de ref-integrity de golden-example. cue vet cobre shape; tq-ge-02/tq-geg-01 cobrem refs no self-review; o harness de codegen-validation (WI-137) exercita os refs ao gerar codigo. A isencao deste structural-check fica REGISTRADA em sc-meta-02 exemptTypes (categoria harness) e o reopening em def-055 (defersTo), tornando a escolha rastreavel ao ADR e mantendo a meta-cobertura (adr-099) verde.

		(7) CASCATA. A materializacao segue a ordem sc-pg-01 (cascade ordering, adr-054): schema -> extensao do enum -> production-guide (+ coveredSchemas) -> isencao em sc-meta-02 exemptTypes -> cobertura, atomica num commit. A 1a INSTANCIA (CMT bd-mutual-acceptance) e a evidencia/harness sao downstream: WI-137 (dependsOn WI-133/134/135/136).
		"""

	consequences: """
		Positivas: (P1) Formaliza o tipo que CLAUDE.md/README ja pressupunham -- golden-example deixa de ser arquivo livre e ganha schema + PG + gate de cobertura, habilitando WI-137 sob disciplina. (P2) Declaracao-pura serve o template-role (P3c): a copia do fan-out leva so a declaracao estavel, nunca resultado-de-run. (P3) Separacao por ciclo de vida (declaracao estavel vs evidencia por-run) alinhada ao padrao do repo (agent-probe-protocol/record). (P4) Disciplina de autoria (PG + tq-ge/tq-geg) reduz variancia do agente estocastico que autora golden-examples no fan-out.

		Negativas / limitacoes: (N1) A ref-integrity do specSlice/assertionRefs NAO tem structural-check estatico. Isso e ESCOLHA, nao incapacidade (diferente de adr-144 def-051/052, que eram inexpressiveis pelo kind): um check estatico seria REDUNDANTE com o harness de codegen-validation (WI-137), que EXERCITA os refs ao tentar gerar codigo -- validacao mais forte que ref-exists. POReM essa cobertura e PROMESSA do harness WI-137 (ainda nao materializado); ate la, ref-integrity e REVIEW-TRUSTED. O reopening e governado em def-055 (defersTo): adjacent-need no harness + manual-review para o desfecho ABANDONAR. (N2) O tipo nasce sem instancia (0 golden-examples) -- schema/PG/cobertura existem sem consumidor ate WI-137. (N3) Cascata atomica (schema + enum + PG + coveredSchemas + ADR num commit); estado parcial reprova sc-pg.

		Follow-up (downstream, nao deste commit): WI-137 autora a 1a instancia (contexts/cmt/golden-examples/bd-mutual-acceptance.cue), o harness scripts/ci/validate-codegen.sh e a evidencia governance/build-time/codegen-validation-evidence.cue -- e o consumidor que torna o tipo nao-trivial e que materializa a promessa de ref-integrity da N1.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta decisao estara errada se #GoldenExample como ArtifactType governado provar peso morto -- isto e, se golden-examples acabarem autorados ad-hoc ignorando o schema/PG (porque a declaracao estruturada nao ajuda o codegen nem o fan-out), ou se a separacao declaracao/evidencia forcar duplicacao em vez de clareza. adr-145 NAO congela a hipotese central de adr-138 (que a stack gera codigo da spec sem edicao semantica): essa hipotese e falsificavel pela evidencia de WI-137 e adr-138 admite pivot; adr-145 so formaliza o vaso, nao afirma o resultado.
			"""
		observableSignal: """
			Golden-examples sao criados fora de contexts/{bc}/golden-examples/ ou sem conformar a #GoldenExample (o schema e contornado), OU a declaracao precisa ser duplicada/embutida com a evidencia para ser util (a separacao nao se paga) -- sinal de que o ArtifactType governado foi sobre-engenharia e um shared-schema leve teria bastado.
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"architecture/structural-checks/production-guide.cue",
		"architecture/structural-checks/meta-coverage.cue",
		"governance/wave-plan.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/golden-example.cue",
		"architecture/production-guides/golden-example.cue",
		"architecture/deferred-decisions/def-055-golden-example-refintegrity-coverage.cue",
	]

	defersTo: ["def-055"]

	principlesApplied: ["P0", "P1", "P3", "P10", "P12"]

	supersedes: []

	rationale: """
		A alternativa (a) e a unica que formaliza o tipo sob o mesmo regime que adr-144 ja estabeleceu para manifests (schema + enum + PG + cobertura) -- consistencia de governanca -- enquanto separa a evidencia por ciclo de vida. Evidencia inline (b) quebra o template-role (P3c) e inverte a direcao evidencia->declaracao do repo (agent-probe-record -> targetCanvas). Arquivo livre (c) deixaria o tipo sem gate nem disciplina, contradizendo CLAUDE.md (todo tipo conhecido tem schema). Shared-schema leve (d) nao teria PG nem cobertura sc-pg -- e o golden-example e autorado por agente estocastico no fan-out, o que justifica a disciplina.

		Declaracao-pura e o coracao da decisao: o golden-example tem dois ciclos de vida (declaracao estavel copiavel como template P3c; evidencia por-run). Misturar os dois quebra o fan-out. A direcao evidencia->declaracao (a evidencia referencia o golden-example, nao o inverso) e o padrao agent-probe-record -> targetCanvas ja provado no repo.

		Ref-integrity (decisao item 6): NAO se cria structural-check estatico de golden-example porque seria redundante com o harness WI-137 (que exercita os refs ao gerar codigo, validacao mais forte que ref-exists) -- escolha, nao incapacidade (distinto de def-051/052, inexpressiveis pelo kind). Mas o harness e CONTINGENTE (adr-138 admite WI-137 pivotar/abandonar): por isso o deferimento e governado em def-055 (defersTo), com trigger adjacent-need no harness (entrega -> cobertura realizada) + manual-review (abandono -> reavaliar check estatico ou remocao do enum). Ate WI-137 materializar, ref-integrity e review-trusted.

		P0 (localizacao canonica unica): specSlice aponta por ref, nunca copia spec do domain-model. P1: o tipo declara o experimento que prova spec->codigo. P3 (template): templateRole + declaracao-pura habilitam o fan-out (P3c de adr-138). P10: o gate de cobertura (sc-pg-01) e deterministico; ref-integrity fica no self-review estocastico + harness, nao como gate-LLM. P12: governanca-e-codigo -- "golden-example tem PG e cobertura" vira fitness function no CI.

		reversibility=medium / blastRadius=repo-wide coerente com adr-144: repo-wide porque estende #ArtifactType (consumido por toda a malha de quality-criteria e cobertura sc-pg); medium porque criar tipo novo e append nao-destrutivo (reverter = remover o tipo + cobertura, sem migrar dado), mas a forma do schema, uma vez instanciada, fica mais cara de mudar. Nenhum vendor/runtime e tocado -- adr-145 e puramente spec-side (filtro adr-139).
		"""
}
