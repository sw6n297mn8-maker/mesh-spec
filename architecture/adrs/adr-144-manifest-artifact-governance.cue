package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-144 — Governanca de manifests: PortManifest + AggregateManifest como ArtifactTypes.
// Decisao estrutural completa (context/decision/consequences/rationale + falsificationCondition).
// Executa o O1-split do adr-141 item 5. Fecha PARCIALMENTE a janela N3 do adr-141: cria 5
// structural-checks em 2 familias (manifest-conformance well-formedness + manifest-ref-integrity);
// interface-conformance, true-coverage e existencia-de-ids deferidas (def-050/051/052).
// Cascata (proximo arco): schemas + enum #ArtifactType + production-guides + 5 sc-checks (2 familias) + WI-140.

adr144: artifact_schemas.#ADR & {
	id:    "adr-144"
	title: "Governança de manifests: PortManifest e AggregateManifest como ArtifactTypes"

	date: "2026-06-05"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		adr-141 (runtime kernel, em main) decidiu que PortManifest e AggregateManifest existem como contrato e SERAO ArtifactTypes governados, mas deferiu a materializacao formal dos tipos ao adr-144 (decision item 5; O1-split). adr-141 N3 declara a janela aberta: os structural-checks de manifest que o adr-141 previa sao obrigatorios mas so existem apos os ArtifactTypes serem criados -- ate la, conformidade/cobertura de manifest nao tem gate deterministico, so self-review + founder review.

		adr-144 fecha PARCIALMENTE essa janela. Materializa PortManifest e AggregateManifest como ArtifactTypes de primeira classe: schemas CUE, extensao do enum #ArtifactType, production-guides (disciplina de preenchimento, dado que o autor de manifest e agente estocastico), e as familias de structural-checks de manifest que tornam a governanca executavel (P12). A decisao do CONTEUDO dos manifests pertence ao adr-141 (item 5); adr-144 decide a GOVERNANCA -- como esses tipos viram artefatos governados e verificados por gate.

		A criacao de #ArtifactType novo dispara a cascata sc-pg-01 (cascade ordering, adr-054): schema antes do production-guide, PG antes de qualquer instancia, nome adicionado a sc-pg-01.coveredSchemas no mesmo commit, structural-check de cobertura por ultimo. A cascata e atomica -- estado parcial (PG sem cobertura, tipo sem PG) reprova sc-pg.

		Alternativas avaliadas: (a) ArtifactType governado pleno (schema + enum + PG + sc-checks) -- ESCOLHIDA: unica que fecha N3 do adr-141 (o gate deterministico passa a existir) e respeita o O1 que adr-141 ja decidiu; (b) shared-schema leve em shared-schemas/ -- rejeitada: adr-141 ja decidiu O1 (governanca plena, nao config); manifest preenchido repetidamente por agente estocastico justifica production-guide; (c) deferir os sc-checks a um ADR posterior -- rejeitada: N3 do adr-141 ficaria aberta, derrotando o proposito do arco; (d) um unico tipo #Manifest generico para ambos -- rejeitada: PortManifest (Ports/operations/contract-tests/reference-adapter) e AggregateManifest (commands/events/invariants/portsRequired) tem campos disjuntos; unifica-los criaria um tipo com metade dos campos sempre vazia.
		"""

	decision: """
		(1) MANIFESTS SAO ARTIFACTTYPES GOVERNADOS. PortManifest e AggregateManifest tornam-se tipos de artefato de primeira classe em architecture/artifact-schemas/, membros do enum #ArtifactType, sob cobertura sc-pg-01 e quality-criteria proprios -- nao shared-schemas. Executa o que adr-141 item 5 deferiu.

		(2) SCHEMAS CUE. Cria-se #PortManifest e #AggregateManifest cujos campos derivam literalmente do adr-141 item 5: PortManifest = {Ports consumidos, operations, adapters/stubs p/ golden-example, contract-tests obrigatorios, requisito de reference adapter}; AggregateManifest = {name/id, commands aceitos, events emitidos, invariants/assertions, portsRequired (subconjunto dos 5 Ports), generated artifacts esperados}. As regras de conformidade entram conforme a expressibilidade spec-side: portsRequired subset dos 5 Ports = constraint CUE nativa (#PortRef); shape dos ids cmd/evt/inv = #CommandRef/#EventRef/#InvariantRef; coerencia interna operation/test/adapter <-> portsConsumed e ref-integrity = structural-checks (item 5); o que e cross-repo ou exige kind novo e deferido (def-050/051/052).

		(3) ENUM #ArtifactType ESTENDIDO. Adiciona-se "port-manifest" e "aggregate-manifest" ao enum em quality-criteria.cue, com abreviacoes de quality-criteria proprias (tq-pm, tq-am ou conforme convencao do repo). Append nao-destrutivo.

		(4) PRODUCTION-GUIDES. Cada tipo ganha production-guides/{port-manifest,aggregate-manifest}.cue com _schema.location, _qualityCriteria, prerequisites e workOrder/sections bijetivos (sc-pg-02/03). O nome de cada um e adicionado a sc-pg-01.coveredSchemas no MESMO commit. O PG existe porque o manifest e preenchido repetidamente por agente estocastico -- a disciplina de preenchimento reduz variancia na entrada; o sc-check valida a saida.

		(5) DUAS FAMILIAS DE STRUCTURAL-CHECKS SPEC-SIDE. (a) manifest-conformance (well-formedness): 3 checks local-field-reference-integrity garantindo operations[].port, contractTestsRequired[].port e adaptersForGoldenExample[].port subconjunto de portsConsumed. (b) manifest-ref-integrity: 2 checks cross-file-id-exists -- boundedContextRef aponta BC existente (strategic/context-map.cue, contexts[].context) e aggregateRef aponta aggregate existente (contexts/*/domain-model.cue, aggregates[].code). Ambas dormant-safe (0 manifests -> 0 violacoes). Deferidos: interface-Kotlin <-> manifest a def-050 (cross-repo, mesh-runtime); true-coverage entidade -> manifest a def-051 (exige kind novo declared-id-requires-file e nao seria dormante); existencia de cmd/evt/inv no domain-model a def-052 (buildavel spec-side, decisao plain-vs-instance-scoped pendente). O subset-do-canon runtime e cross-repo, distinto, fora deste escopo.

		(6) CASCATA + INSTANCIAS DEFERIDAS. A materializacao segue a ordem sc-pg-01 (cascade ordering): schema -> extensao do enum -> production-guide (+ coveredSchemas) -> structural-check, atomica num commit. As INSTANCIAS de manifest por BC/aggregate sao downstream: WI-140 (dependsOn WI-103) e inserida no wave-plan como o slot onde serao materializadas, sem cravar aqui quais BCs nem quantos manifests -- isso pertence a autoria das instancias.
		"""

	consequences: """
		Positivas: (P1) Janela N3 do adr-141 fecha NO LADO SPEC PARCIALMENTE -- manifest-conformance (well-formedness, 3 checks) + manifest-ref-integrity (2 checks) passam a existir como gate deterministico em mesh-spec agora. Interface-conformance (interface-Kotlin <-> manifest, cross-repo) fica em def-050; true-coverage (entidade -> manifest) em def-051; existencia de cmd/evt/inv no domain-model em def-052. N3 do adr-141 fecha integralmente so quando esses tres materializarem. (P2) Governanca executavel (P12) -- "todo BC tem manifest" (coverage, def-051) e "PortManifest bem-formado" (conformance, agora) viram codigo no CI, nao documentacao; adr-144 NAO afirma interface-conformance como gate spec-side (e def-050). (P3) Manifest como localizacao canonica unica (P0) consumivel por codegen (P1) -- schema CUE governado, nao config solta. (P4) Disciplina de autoria -- o production-guide reduz a variancia do agente estocastico que preenche manifests repetidamente (1+ por BC/aggregate); o sc-check valida a saida.

		Negativas / limitacoes: (N1) Cascata atomica pesada -- 2 schemas + extensao de enum + 2 production-guides + 5 structural-checks (2 familias) + edit de coveredSchemas + 3 deferred-decisions + WI-140, tudo num commit; estado parcial reprova sc-pg. (N2) Os 2 PGs exigem workOrder<->sections bijetivo (sc-pg-02/03) e _qualityCriteria proprios -- autoria nao-trivial, mais pesada que a dos schemas. (N3) manifest-conformance e manifest-ref-integrity ficam dormentes (verde-trivial) ate a primeira instancia de manifest existir -- o GATE passa a existir, mas nao cobre nada ate WI-140 materializar manifests; sem instancias, os tipos existem sem consumidor. (N4) Conformance interface <-> manifest nao e verificavel em mesh-spec (alvo cross-repo); deferida a def-050. Ate mesh-runtime materializar esse gate, a fidelidade da interface hand-authored ao manifest depende de review, nao de gate spec-side. #ServiceContract NAO serve de proxy (e API de dominio do BC, ortogonal a superficie de Port). (N5) True-coverage (entidade -> manifest) nao e expressivel com kinds v1 e nao seria dormante; deferida a def-051 (kind novo declared-id-requires-file + WI-140). Ate la, "toda entidade tem manifest" depende de review, nao de gate. (N6) A existencia de cmd/evt/inv declarados pelo AggregateManifest no domain-model do BC e buildavel spec-side (cross-file-id-exists) mas deferida a def-052 (decisao plain vs instance-scoped pendente); nao entra nos 5 checks deste arco. Distinta do subset-do-canon runtime (canon/command, canon/event), que e cross-repo. (N7) CONDICAO DE MIGRACAO proposed->accepted (registrada 2026-06-10): este ADR permanece proposed-vigente (norma do repo: ADR proposed governa suas instancias) ate a adocao real testar a hipotese. Migra a accepted quando: (a) existir >=1 contexts/<bc>/port-manifest.cue com bc != cmt E >=1 contexts/*/aggregate-manifests/am-*.cue no disco (WI-140 materializou o fan-out alem do seed pm-cmt); E (b) o structural-runner reportar 0 bloqueante em sc-pmc-01..03, sc-mri-01 e sc-mri-02 sobre essas instancias. Ambos verificaveis por contagem de path + output do runner, sem juizo interpretativo. Nota: pm-cmt (WI-135) ja tira sc-pmc-01..03/sc-mri-01 do vacuo; sc-mri-02 segue verde-vacuo ate o primeiro AggregateManifest -- a condicao (a) cobre exatamente essa lacuna.

		Follow-up (downstream, nao deste commit): WI-140 (dependsOn WI-103) materializa as instancias de PortManifest/AggregateManifest por BC/aggregate -- e o consumidor que torna manifest-conformance e manifest-ref-integrity nao-triviais (deixam de ser verde-vacuo); true-coverage (def-051) e existencia-de-ids (def-052) so viram gate nao-trivial quando materializarem + WI-140. Sem WI-140, os ArtifactTypes existem mas os gates fecham so no nivel de existencia.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta decisao estara errada se a governanca de manifest como #ArtifactType pleno provar
			peso morto -- isto e, se o production-guide e os quality-criteria proprios nunca reduzirem
			variancia real de preenchimento (porque manifests acabam gerados deterministicamente de
			outra spec, sem autoria estocastica), ou se manifest-conformance e manifest-ref-integrity
			ficarem verde-trivial indefinidamente porque BCs nao adotam manifests -- caso em que o
			aparato governado era custo sem ganho e um shared-schema leve teria bastado.
			"""
		observableSignal: """
			Os production-guides de manifest ficam sem uso real (nenhum agente os consulta porque o
			preenchimento virou codegen puro), OU manifest-conformance e manifest-ref-integrity
			permanecem verde-trivial indefinidamente porque nenhum BC instancia manifest -- sinal de
			que o ArtifactType governado foi sobre-engenharia e a decisao O1 (vs shared-schema) nao se pagou.
			"""
	}

	affectedArtifacts: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"governance/wave-plan.cue",
		"architecture/tension-log/ten-015-port-interface-handauthored-vs-p1.cue",
		"architecture/structural-checks/production-guide.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/port-manifest.cue",
		"architecture/artifact-schemas/aggregate-manifest.cue",
		"architecture/production-guides/port-manifest.cue",
		"architecture/production-guides/aggregate-manifest.cue",
		"architecture/structural-checks/manifest-conformance.cue",
		"architecture/structural-checks/manifest-ref-integrity.cue",
		"architecture/deferred-decisions/def-050-port-interface-conformance-runtime.cue",
		"architecture/deferred-decisions/def-051-manifest-true-coverage.cue",
		"architecture/deferred-decisions/def-052-manifest-cross-file-scoping.cue",
	]

	defersTo: ["def-050", "def-051", "def-052"]

	principlesApplied: ["P0", "P1", "P10", "P12"]

	supersedes: []

	rationale: """
		A alternativa (a) e a unica que fecha a janela N3 do adr-141: ela so fecha quando o GATE deterministico existe, e gate em mesh-spec e structural-check (P10: agentes recomendam, gates validam). Shared-schema (b) nao tem cobertura sc-pg nem PG -- deixaria o manifest como config nao-governada, contradizendo o O1 que adr-141 ja decidiu. Deferir os checks (c) manteria N3 do adr-141 aberta. Tipo unico (d) criaria um schema com metade dos campos sempre vazia (Port e Aggregate tem campos disjuntos).

		c-puro: o manifest CUE e a localizacao canonica unica (P0) da superficie; a interface Kotlin e projecao (per L3/adr-141), cuja verificacao manifest <-> interface fica deferida a def-050. P12 (governanca-e-codigo) e o principio central: adr-144 transforma "manifests devem conformar" de intencao em fitness function no CI -- toda regra spec-side que importa imposta automaticamente. P1 porque tipos/validadores/tests/verificacao derivam do schema CUE governado. P10 ancora o modelo de enforcement: as 2 familias (manifest-conformance, manifest-ref-integrity) sao deterministicas e complementam o self-review estocastico que ate aqui era a unica defesa (N3 do adr-141).

		def-050/051/052 sao DEFERIMENTOS NEUTROS aqui: adr-144 defere a decisao, nao a resolve. A resolucao preferida de cada um -- p.ex. gerar a interface Kotlin do manifest vs conviver com hand-authoring (def-050); plain vs instance-scoped (def-052) -- mora no texto do respectivo def, nao neste ADR.

		reversibility=medium / blastRadius=repo-wide coerente: repo-wide porque estende #ArtifactType (consumido por toda a malha de quality-criteria e cobertura sc-pg); medium porque criar tipos novos e append nao-destrutivo (reverter = remover os 2 tipos + checks, sem migrar dado), mas a forma dos schemas, uma vez instanciada por BCs, fica mais cara de mudar. Nenhum vendor/runtime e tocado -- adr-144 e puramente spec-side, dentro do filtro adr-139.
		"""
}
