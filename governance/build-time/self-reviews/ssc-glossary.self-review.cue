package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

sscGlossary: build_time.#SelfReviewReport & {
	reportId: "srr-ssc-glossary"

	artifactPath:       "contexts/ssc/glossary.cue"
	artifactSchemaPath: "architecture/artifact-schemas/glossary.cue"
	artifactType:       "glossary"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-04"

	roundsExecuted: 1
	maxRounds:      4

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary:   "Glossário SSC materializado via subagent dispatch (disp-008) — segundo non-PG dispatch successful em WI-060 (Phase 2). Founder review pre-write aplicou 9 ajustes para separar UL de protocol/integration policy: (1) Strategic Award definition simplificada (protocolo de janela [StrategicAward, ContractActivation] move para domain-model); (2) Category Manager definição genérica resiliente a evoluções operacionais (Phase 0 caveats em rationale); (3) Fornecedor Qualificado category role→classification (gate de elegibilidade aplicado a role); (4) Fracionamento category rule→classification (workaround para schema #TermCategory sem 'anti-pattern' enum); (5-9) refs a oq-ssc removidas de definitions onde não-essenciais — mantidas em rationale onde context Phase 0 é necessário. Conversão de HTML entities (&amp;/&lt;/&gt;) para caracteres reais aplicada pre-write (não-semântica). Materializado em 2 commits incrementais: 9fcc407 part 1 (8 terms — anchor + process + roles: Decisão de Sourcing + 3 subtipos + RFQ + Categoria de Compra + Category Manager + Fornecedor Qualificado) + c5bdc83 part 2 (11 terms — machinery: FitnessSignals/FitnessRules/DecisionRationale/Equalização TCO; events: 6 events do trio decisão + trio RFQ lifecycle; adversarial: Fracionamento). cue vet ./... EXIT=0 em cada commit intermediário e final. Schema satisfação tq-gl-XX por inspeção: tq-gl-01 (codes únicos: 19 terms com term-* codes distintos) ✓; tq-gl-02 (relatedTerms refs intra-glossário válidos) ✓; tq-gl-03 (domainModelRefs vazios — Phase 0 sem domain-model) ✓; tq-gl-04 (não aplicável Phase 0); tq-gl-05 (definitions distintas de names; sem redundância) ✓; tq-gl-06 (antiTerms não repetem term names — todos antiTerms são conceitos externos: Pedido de Compra, Contrato, Compromisso, Designação Preferred, Strategic Award (em preferred), Contrato-Quadro, Cotação Informal, Leilão, Conta Contábil, Centro de Custo, Comprador, Procurement Officer, Reputation Score, Risk Rating, Scoring Algorithm, Heurística, Justificativa, Fornecedor Cadastrado, Fornecedor Preferido, Compra Pulverizada, Comparação por Preço) ✓; tq-gl-07 (rejectedAlternatives substantivos com reason — Award/Seleção de Fornecedor/Adjudicação Estratégica/Família de Insumos/Threshold Gaming) ✓; tq-gl-08 (sem self-references em relatedTerms) ✓; tq-gl-09 (rationale substantivo em todos terms) ✓; tq-gl-10 (layerMapping presente em 6 events com codeTerm) ✓; tq-gl-11 (termEn semanticamente adequado — translations apropriadas, loanwords explícitos) ✓; tq-gl-12 (termEn únicos — verificado) ✓; tq-gl-13 (names únicos — verificado) ✓. Anti-mini-NIM como invariant transversal articulado em term-fitness-signals (antiTerms ReputationScore + RiskRating), term-fitness-rules (antiTerms Scoring Algorithm + Heurística), term-decision-rationale (moat de inteligência sem virar mini-NIM). Frase canônica preservada via antiTerms recorrentes em term-sourcing-decision (Pedido de Compra → P2P; Contrato → CTR; Compromisso → CMT). Vocabulary híbrido PT-BR + EN loanword seguindo precedente bdg/idc — defensável caso a caso em rationale por termo. Cross-BC vocabulary consistency: term-fracionamento mirrors bdg para vetor adversarial análogo. Founder review aplicou 9 ajustes em batch (não 9 rounds iterativos) — qualidade incorporada no draft pré-commit, single round suficiente."
	}]

	findings: {}

	summary: "Glossário SSC via subagent dispatch (disp-008). 19 terms canônicos: 4 entities (Decisão de Sourcing + 3 subtipos) + 1 process (RFQ) + 1 process (Equalização TCO) + 2 classifications (Categoria de Compra + Fornecedor Qualificado + Fracionamento como classification workaround) + 1 role (Category Manager) + 2 values (FitnessSignals + DecisionRationale) + 1 rule (Fitness Rules) + 6 events (3 decisões + 3 RFQ lifecycle). Materializado em 2 commits incrementais (anchor+process+roles → machinery+events+adversarial). 9 ajustes founder pre-write (definitions limpas, categories ajustadas, oq refs movidas para rationale). Anti-mini-NIM como invariant transversal preservado. tq-gl-01..13 satisfeitos. cue vet ./... EXIT=0."

	singleRoundRationale: "Authoring via subagent dispatch single attempt + founder review rigoroso pre-write aplicando 9 ajustes substantivos em batch (não rounds iterativos). Auto-checks PASSED em cada commit intermediário (cue vet ./... EXIT=0). Round único suficiente — qualidade incorporada via founder review pré-commit substituindo dispatch de review subagent (paralelo à abordagem disp-005/006/007). Issue de transporte HTML entities resolvido pre-write (não-semântico)."
}
