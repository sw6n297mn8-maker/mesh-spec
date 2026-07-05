package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

domainStoryArtifactSchema: build_time.#SelfReviewReport & {
	reportId: "srr-domain-story-artifact-schema"

	artifactPath:       "architecture/artifact-schemas/domain-story.cue"
	artifactSchemaPath: "architecture/artifact-schemas/domain-story.cue"
	artifactType:       "artifact-schema"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "isolated-subagent"
	generatedAt:     "2026-07-05"

	roundsExecuted: 2
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 3
		warnCount: 7
		infoCount: 0
		summary: """
			Round 1 — review ISOLADO PRÉ-ESCRITA do draft do schema (sessão 2026-07-05, antes da
			materialização; executionPolicy: artifact-schema → isolated-subagent). 3 BLOCKERs:
			(1) gates fictícios — o draft referenciava checks sc-ds-* que não existiam e não
			entrariam no mesmo commit; (2) def fantasma — o elo do termo citava um def não
			materializado; (3) divergência não-declarada com _meta.cue/README/WI-113 sobre o papel
			de eventos na story. 7 WARNs, incluindo: duplicação de regexes de ref em vez de reuso
			dos tipos #StakeholderRef/#BoundedContextRef/#SubdomainRef/#GlossaryTermRef (findings
			4/5), campo order paralelo ambíguo vs posição na lista, subdomínio dono ausente
			(WARN 6), rótulo 'Brandolini' incorreto para a gramática ator→ação→work-item.
			TODOS endereçados na materialização: pacote completo no mesmo commit (checks sc-ds-01..08
			+ enum + coveredSchemas + PG), def-075 real, divergência declarada no adr-170 item 5,
			reuso dos tipos de ref, ordem = posição (sem campo order), subdomainRef obrigatório
			(sc-ds-03), rótulo Domain Storytelling (Hofer/Schwentner).
			"""
	}, {
		round:     2
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Round 2 — review ISOLADO PÓS-ESCRITA (working tree; sem histórico da conversa). ZERO
			findings. Verificações: uq-03 — #StakeholderRef/#BoundedContextRef/#SubdomainRef/
			#GlossaryTermRef/#NonEmptyString existem no package; sc-ds-01..08 e def-075 existem;
			regexes por prefixo (cmd-/evt-/pol-/prj-/qry-) casam com os codes REAIS dos
			domain-models do disco. uq-08 — _schema.location presente e completo (exigência
			explícita do uq-08 para artifact schemas); padrão dos vizinhos seguido; cue vet limpo.
			uq-01/02/04..07 OK (rationales de porquê; ancoragem Mesh; P0 refs-como-ponteiros;
			elo frouxo termRefs declarado com ponteiro para def-075; UL consistente; zero
			placeholder). tq-as-01 OK (location completo); tq-as-02/03 vacuamente satisfeitos —
			sem _qualityCriteria intra-schema, legítimo per criteriaResolution.fallback do
			quality-gate ('ausência não é erro'); a razão (elos vivem nos gates sc-ds-*, não em
			tq intra-artifact) documentada no PG e no adr-170. uq-09 N/A (não existe PG para o
			tipo artifact-schema; manualAuthoringProtocol não aplica).
			"""
	}]

	findings: {}

	summary: """
		Schema #DomainStory: dois rounds isolados — o PRÉ-ESCRITA (3 BLOCKERs/7 WARNs sobre o
		draft; todos endereçados: pacote completo no mesmo commit, def-075 real, divergência
		WI-113 declarada, reuso de refs tipadas, ordem-pela-posição, rótulo corrigido para Domain
		Storytelling) e o PÓS-ESCRITA (ZERO findings; refs e regexes verificadas contra os codes
		reais do disco). VEREDITO: stable.
		"""
}
