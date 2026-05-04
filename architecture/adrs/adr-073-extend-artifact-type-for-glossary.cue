package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr073: artifact_schemas.#ADR & {
	id:    "adr-073"
	title: "Extend artifact_type_for_path to cover glossary instances + opportunistic adr-067 PG gap cleanup"
	date:  "2026-05-03"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		State-of-affairs precedente:
		- adr-060 estabeleceu pattern progressivo para
		  artifact_type_for_path em scripts/ci/check-self-review.sh.
		- adr-066/067/068/069/072 cobriram deferred-decision +
		  production-guide + structural-check + validation-prompt +
		  canvas.
		- adr-070 promoveu #BootstrapException a schema first-class;
		  adr-071 adicionou trigger kind file-content-occurrence-count.
		- def-012 monitora crescimento da categoria pre-mapping-
		  transient (threshold=20). Pós-adr-072 baseline=18.
		- Glossary é layer de ubiquitous language por BC (per adr-036
		  glossary schema): cada BC tem exatamente 1 glossary em path
		  canônico contexts/<bc>/glossary.cue.

		Trigger desta ADR: per adr-069/072 known gaps declarados,
		'glossary path mapping é forte candidato seguinte'. Esta ADR
		materializa segundo de 3 BC artifact path-mappings (canvas
		em adr-072 foi primeiro; domain-model próximo).

		Análise per adr-060 critérios:
		- Criticality: HIGH. Glossary é ubiquitous language per BC —
		  drift silencioso quebra termos compartilhados que outros
		  artefatos referenciam (canvas, invariants, commands, events).
		- Volume: 4 instances (1 por BC: cmt, ctr, idc, npm). Volume
		  estável (cresce com novos BCs); maturidade alta (schema
		  desde adr-036).
		- Maturidade: schema #Glossary estável (adr-036); 4 instances
		  conformantes; PG glossary.cue codifica protocolo de autoria.

		Branch (claude/resume-mesh-work-jv2MC) NÃO modificou nenhum
		glossary BC. ZERO instances com modificação in-flight → zero
		retroativos necessários.

		GAP DETECTADO EM ADR-067 (cleanup oportunista): adr-067
		listou 4 transient bootstrap exceptions para PGs em main
		sem SRR matching path (adr.cue, agent-governance.cue,
		agent-spec.cue, structural-check.cue), MAS production-guide
		inventory atual mostra 9 PGs em main: os 4 cobertos +
		deferred-decision (in-flight, has SRR) + tension-entry
		(in-flight, has SRR) + production-guide (META, has own SRR)
		+ domain-model + glossary. Os últimos 2 (domain-model.cue
		e glossary.cue PGs) ficaram fora de adr-067 — gap dormente
		(CI fails se modificados em branch futura).

		Cleanup oportunista neste commit: adicionar 2 transient
		bootstrap exceptions (categoria pre-mapping-transient)
		para domain-model.cue + glossary.cue PGs. Mesmo arquivo,
		mesma categoria, mesmo mecanismo de adr-073 já modifica
		— anti-catch-all preservado (cleanup mecânico de gap
		dormente, não decisão de design nova).

		Alternativas avaliadas:
		(a) Status quo (glossary não enforced + adr-067 gap dormente)
		— rejeitada: criticality HIGH; gap perpetuou-se 5 commits
		(adr-068/069/070/071/072 sem fix); cresce risk de CI
		surprise.
		(b) Pattern narrow ('contexts/<bc>/glossary-*.cue') —
		rejeitada: convenção atual é 1 glossary singleton per BC
		sem prefixo. Pattern broad 'contexts/*/glossary.cue'
		reflete estrutura real, paralelo exato a adr-072 canvas.
		(c) Separar adr-067 gap fix em ADR/commit próprio —
		rejeitada: gap é mecânico (não decisão nova), 2 entries
		adicionais em mesmo edit do bootstrap-policy. Custo
		adicional zero; benefit = gap resolved 5 commits earlier
		do que separate ADR.
		(d) def-XXX para gap de adr-067 — rejeitada: gap é
		mecânico, não trade-off articulado vs custo de continuar.
		Anti-catch-all CLAUDE.md guidance.
		"""

	decision: """
		(1) ADICIONAR pattern para glossary ao artifact_type_for_path
		em scripts/ci/check-self-review.sh:
		    contexts/*/glossary.cue) echo "glossary" ;;
		Pattern broad ('contexts/*/glossary.cue') reflete convenção
		estrutural: cada BC tem exatamente 1 glossary em path
		canônico. Não colide com glossary schema (architecture/
		artifact-schemas/glossary.cue) ou glossary PG (architecture/
		production-guides/glossary.cue) — em diretórios distintos
		já cobertos por outros patterns.

		(2) ESCOPO: instances. Schema #Glossary + PG glossary já
		cobertos por patterns existentes (artifact-schema +
		production-guide).

		(3) ZERO RETROATIVOS IN-FLIGHT: nenhum BC glossary modificado
		nesta branch (verified via git diff origin/main...HEAD).
		Mesmo pattern de adr-072 canvas (zero retros + uso operacional
		schema first-class de bootstrap exception).

		(4) REGULARIZAÇÃO TRANSITÓRIA DE 4 BC GLOSSARIES EM MAIN:
		cmt, ctr, idc, npm — todas pre-path-mapping. Regularizadas
		neste mesmo commit via 4 entries em
		self-review-bootstrap-policy.cue (categoria pre-mapping-
		transient com schema first-class per adr-070).

		(5) CLEANUP OPORTUNISTA DE ADR-067 GAP: adicionar 2 entries
		adicionais em bootstrap-policy para PGs domain-model.cue +
		glossary.cue (categoria pre-mapping-transient). Gap dormente
		que existiu desde adr-067; resolved neste commit por
		coincidência editorial (mesmo arquivo, mesma categoria,
		mesmo mecanismo).

		Total cumulativo da categoria pre-mapping-transient
		pós-adr-073: 24 entries (4 PGs original adr-067 + 1 SC
		adr-068 + 9 VPs adr-069 + 4 canvas adr-072 + 4 BC glossary
		adr-073 + 2 PG gap cleanup adr-073).

		(6) MATERIALIZAÇÃO: single commit consolidado com este ADR +
		script edit + 6 bootstrap exceptions transientes (4 BC
		glossary + 2 PG gap cleanup) + ADR-073 self-review. 5
		arquivos.

		(7) FUTURE EXTENSION (continua pattern): outros types remain
		candidates per adr-060/066/067/068/069/072 framing. Próximos:
		- domain-model (4 BC instances, separate ADR per type)
		- work-governance singleton
		- subdomain (strategic/subdomains/*.cue)
		"""

	consequences: """
		Positivas:

		(P1) glossary instances enforced por CI — ubiquitous language
		per BC protegida contra drift silencioso. Modificações futuras
		a qualquer BC glossary requerem self-review report explícito.

		(P2) Continuidade direta do pattern adr-060/066/067/068/069/
		072: ADR + script edit + bootstrap exceptions transientes +
		uso operacional schema first-class adr-070.

		(P3) Pattern broad ('contexts/*/glossary.cue') é apropriado —
		paralelo exato a adr-072 canvas (convenção estrutural fixa).

		(P4) Coverage agora cobre 16 types via mapping (15 prior +
		glossary).

		(P5) Cleanup oportunista de adr-067 gap (domain-model +
		glossary PGs) resolve dívida dormente sem custo de ADR
		separado. Mesmo arquivo, mesma categoria, mesmo mecanismo.

		(P6) def-012 is expected to fire because transient bootstrap
		exceptions reach 24; this commit intentionally creates the
		revisitation signal for stale-detection structural-check.
		Volume cumulativo cresce de 18 (pós-adr-072) para 24
		(pós-adr-073), atravessando threshold=20. Annotation no
		próximo CI run é signal designed; founder revisita per
		adr-070 lifecycle (decide implementar sc-be-01 OR ajustar
		threshold OR registrar acknowledgment).

		Negativas:

		(N1) 6 bootstrap exceptions adicionadas (4 BC glossary + 2
		PG cleanup) — policy file cresce 6 entries. Surface cresce
		mas categoria + lifecycle são uniformes; sem novidade
		semantica.

		(N2) Surface area de consistency entre mapping, #ArtifactType,
		structural-check.artifactType, e PG cascade-ordering
		coveredSchemas continua crescendo. Manter sync entre os 4
		é responsabilidade editorial até structural-check eventual
		capturar pair-coverage.

		(N3) def-012 fired (count 24 ≥ 20): NÃO é falha — design
		intent. Founder revisita active reconsideration culture
		estabelecida em adr-069 → adr-070 (def-011 → resolved).
		Mesmo padrão se aplica aqui.

		Known gaps declarados:
		- 4 BC glossaries em main sem SRR matching path: regularizadas
		  via bootstrap exception transient.
		- 2 PGs em main sem SRR matching path (domain-model, glossary):
		  cleanup oportunista do gap adr-067.
		- domain-model BC path mapping é forte candidato seguinte
		  (4 BC instances) — separate ADR per progressive pattern.
		- work-governance singleton: separate ADR.
		- def-012 fired neste commit: signal de revisita per adr-062
		  lifecycle. Trate igual a def-011 → adr-070 (active
		  reconsideration).

		Fronteira regulatória: nenhuma. Decisão é meta-estrutural
		sobre CI enforcement scope. BC glossary instances que
		referenciam termos regulatórios mantêm semantics próprias
		— enforcement de self-review NÃO altera ubiquitous language
		semantics.
		"""

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"scripts/ci/check-self-review.sh",
		"governance/build-time/self-review-bootstrap-policy.cue",
	]

	plannedOutputs: []

	defersTo: []

	principlesApplied: [
		"P10",
		"P12",
	]

	supersedes: []

	rationale: """
		Princípios aplicados:

		P12 (governança como código): script edit é veículo
		declarativo para governance scope. Glossary é ubiquitous
		language per BC; coverage incompleta seria violação do
		princípio aplicado a layer linguística cross-BC.

		P10 (gates determinísticos validam): CI self-review-check
		torna-se efetivo para glossary — gate determinístico ao
		invés de discipline voluntária para artefatos críticos
		de BC linguistics.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: pattern broad ('contexts/*/glossary.cue')
		é apropriado porque convenção estrutural fixa cobre todos
		os casos atuais e previsíveis. Pattern narrow seria
		especulativo.

		Relação com outras ADRs:

		- DESCENDS adr-060 (pattern de extensão progressiva).
		- DESCENDS adr-066/067/068/069/072 (continuação direta —
		  glossary era explicit known gap em adr-069/072).
		- COMPLEMENTA adr-036 (glossary artifact schema): glossary
		  instances agora também enforced por CI self-review.
		- USA schema first-class de adr-070 para 6 transient
		  bootstrap exceptions (validação operacional cumulativa).
		- CLEANUP DE adr-067 (PGs domain-model + glossary não
		  cobertas originalmente).
		- TRIGGERS def-012 (count cumulativo passa threshold —
		  designed signal de revisita).
		- PRECEDE potential ADRs para domain-model + outros BC
		  types.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': script edit é puramente aditivo;
		reversão é remover 1 linha. Mesmo pattern de adr-060/066/
		067/068/069/072.

		blastRadius 'cross-cutting': afeta todos glossary instances
		(4 atuais + futures conforme novos BCs). Glossary é
		ubiquitous language — cross-cutting por construção. Não
		atravessa fundamental governance infrastructure.
		"""
}
