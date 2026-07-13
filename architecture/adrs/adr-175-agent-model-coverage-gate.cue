package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr175: artifact_schemas.#ADR & {
	id:    "adr-175"
	title: "Gate de cobertura agente↔modelo: todo building block operável do domain-model coberto pelo agent-spec do BC ou excluído conscientemente (kind instance-scoped-cross-file-coverage + scopeExclusions, born-warn)"
	date:  "2026-07-13"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "high"
	blastRadius:   "repo-wide"

	context: """
		As fatias WI-151 (requisição+portão no p2p), WI-153 (two-phase no bdg) e
		WI-152 (mapa de cotações no ssc) materializaram building blocks nos
		domain-models SEM coevoluir os agent-specs dos BCs — e nenhum gate
		acusou. A medição read-only que abriu esta fatia explicou o porquê: o
		sc-ag-01 (adr-113) valida a direção agente→modelo (toda ref do agente
		existe no modelo — responsabilidade fantasma), mas NÃO a direção
		inversa modelo→agente (todo building block operável está no mapa do
		agente). Como as fatias só ADICIONARAM ao modelo, nada quebrou refs; o
		drift foi silencioso. Baseline medido: 7 dos 12 BCs 100% em par;
		bdg/ssc/p2p com exatamente o delta das 3 fatias; cmt e rew com drift
		pré-existente (rew concentrado numa única família: invariants de
		engine).

		Um agente que 'acha' que tem building blocks que não existem — ou
		IGNORA os que existem — opera com mapa desatualizado do próprio BC.
		Numa infra onde agentes operam sob governança (agent-specs declaram
		responsabilidade, autonomia e escalação), isso é risco operacional da
		mesma classe que o adr-113 fechou na direção oposta. O análogo já
		instituído no repo: 'SRR e derivado viajam com o commit' — agora 'o
		agente viaja com o modelo'.

		Duas classes de erro identificadas: classe-1, incompletude (building
		block sem menção estruturada no agente — curável por gate determinístico
		de cobertura); classe-2, prosa errada (action do agente descrevendo
		comportamento que o modelo alterado desmentiu, ex.: o agente do bdg
		dizendo que a aprovação emite BudgetApproved quando o re-papel do
		WI-153 moveu a emissão para a efetivação — interpretativa, P10 veda
		gate LLM). Alternativa rejeitada: cobrir tudo com gate mecânico —
		classe-2 não é decidível deterministicamente; vive como disciplina de
		processo no PG + advisory. Alternativa rejeitada: exclusão só por id —
		o rew tem dezenas de invariants de engine que virariam carimbo
		repetido; por classe é 1 regra auditável.
		"""

	decision: """
		(1) KIND NOVO instance-scoped-cross-file-coverage no runner estrutural
		— a DIREÇÃO INVERSA do instance-scoped-cross-file-id-exists (adr-113):
		itera o CATÁLOGO do alvo derivado do escopo (targetIdPaths) e exige que
		cada id esteja na união de referencePaths (coberto) OU exclusionPaths
		(excluído conscientemente) das instâncias daquele escopo. União POR
		ESCOPO: múltiplos agentes de um BC cobrem o catálogo em conjunto —
		least-privilege por agente preservado. Custo integral do kind entra no
		mesmo commit (self-asserção do runner: cartaz sem fiscal é finding):
		enum #StructuralCheckKind + branch da união discriminada + rule shape
		#InstanceScopedCrossFileCoverageRule + evaluator
		ev_instance_scoped_cross_file_coverage + entry no registry EVAL +
		fixture na suíte de self-test cobrindo os 5 casos (coberto /
		não-coberto-viola / excluído-por-ref / excluído-por-classe /
		família-fora-ignorada).

		(2) SEIS FAMÍLIAS operáveis exigidas: aggregates, commands, events,
		invariants, projections (as 5 do #OperationalScope) + domainServices
		(svc-, 6ª família adicionada ao #OperationalScope nesta decisão).
		svc- entra porque é categoria-ação — lógica cross-aggregate que o
		agente INVOCA. Doutrina das famílias FORA do gate: vo-/ent- cobertos
		via parent aggregate, qry- coberto via parent projection (a doutrina de
		parent já declarada no #AgentAction), mod- é agrupamento organizacional
		(ninguém 'opera' um module), pol- é automação determinística
		event→command executada pelo runtime (P10 — o agente não opera a
		policy; os commands que ela emite são classe candidata de exclusão).
		O sc-ag-01 ganha operationalScope.domainServices[] em referencePaths —
		a 6ª família vale nas DUAS direções.

		(3) scopeExclusions no #AgentSpec com DUAS FORMAS: por id
		({ref, rationale}) e por classe ({class, rationale, refs}) — a forma
		por classe cobre vários ids com um rationale único auditável; o runner
		resolve refs[], a classe é o fundamento. CRITÉRIO DE EXCLUSÃO LEGÍTIMA:
		uma exclusão só é legítima se (a) a classe é ESTRUTURALMENTE
		identificável (ex.: commands policy-issued — deriváveis mecanicamente
		de policies[].issuesCommand), OU (b) a classe é DOUTRINARIAMENTE
		fechada com rationale citando a marcação em prosa do building block
		(ex.: invariants cujo rule declara enforcement externo ao agente/
		runtime — 'enforcement EXTERNAL TO REW', replayHash mecânico; commands
		cujo ator declarado é externo — cmd-submit-quotation é do fornecedor).
		'Excluí porque dava trabalho cobrir' não satisfaz nenhum dos dois.
		NÃO se estruturam campos de ator/enforcement em #Command/#Invariant
		agora — deferimento consciente governado em def-080 (fatia própria
		ortogonal; trigger manual-review ancorado nas higienes); até lá a
		legitimidade dos padrões prose-keyed é revisada por leitura nas
		higienes, guiada por este critério.

		(4) CHECK sc-ag-02 born-WARN (adr-097; precedente sc-cm-07
		adr-117→123): anuncia o baseline sem bloquear. Baseline anunciado na
		ativação: 61 itens — bdg 3 (delta WI-153), cmt 2 (drift pré-existente),
		p2p 16 (delta WI-151), rew 35 (pré-existente: 31 invariants de engine +
		3 events de ingestão + 1 delta de medição estruturada-vs-textual),
		ssc 5 (3 delta WI-152 + 2 svc- da 6ª família). Promoção a REJECT só
		após as higienes (WI-154/WI-155) zerarem o baseline — catraca em ADR
		próprio, como adr-123 fez para sc-cm-07. Fronteira declarada: BC sem
		agent-spec não é visitado por este check (o check itera instâncias de
		agent-spec); ownership de agente é assunto do canvas (tq-ag-03).

		(5) PG DOMAIN-MODEL — ELO DUPLO para a classe-2: (a) critério
		tq-dmg-12 em _qualityCriteria assegura que o GUIDE contém a disciplina
		de coevolução; (b) passo operativo em finalValidation.steps exige, ao
		alterar building blocks operáveis, verificar coevolução do agent-spec
		(operationalScope/actions/scopeExclusions) E a veracidade da prosa das
		actions — coevoluindo no mesmo ciclo ou justificando a não-edição. Só
		o critério, sem o passo, deixaria a classe-2 descoberta: instâncias
		seguem process/finalValidation do PG (os tq-dmg-* asseguram o guide,
		não a instância); o uq-09 (warn) vigia que a autoria seguiu os section
		gates.

		(6) HIGIENES registradas como task-specs nesta fatia (proposed/
		approved; claim/complete nas fatias próprias): WI-154 (higiene A —
		coevoluir agent-specs de bdg [prioridade: contrato falso na prosa],
		p2p e ssc) e WI-155 (higiene B — cmt + triagem do rew por
		exclusão-de-classe + exclusões formais onde legítimo). O backfill do
		work-event do wi-151 NÃO entra no WI-154 — é higiene de event-sourcing
		de governança (diretório work-events, convenção -backfill), natureza
		distinta de coevolução de artefato de BC; registro em separado.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) scopeExclusions virar válvula de escape — exclusões adicionadas para silenciar o gate sem satisfazer o critério de legitimidade (estrutural OU doutrinária), transformando cobertura declarada em cobertura fictícia; OU (b) o custo de coevolução por fatia (agent-spec a cada mudança de domain-model) se provar maior que o custo do drift que o gate evita, sinalizando granularidade errada de enforcement."
		observableSignal: "(a) observável em review das higienes e de PRs futuros: exclusões novas cujo rationale não cita nem derivação estrutural (ex.: policies[].issuesCommand) nem marcação em prosa do building block — contáveis por inspeção de scopeExclusions em diff. (b) observável na cadência de fatias: proporção de fatias de domain-model que precisam re-tocar agent-spec por razões triviais (id-only, sem mudança de responsabilidade real) — se a maioria das coevoluções for carimbo sem conteúdo, o gate está medindo a coisa errada."
	}

	consequences: """
		Positivas: o drift agente↔modelo morre como classe de erro silencioso —
		o gate acusa no CI o que as 3 fatias fizeram sem ninguém ver; a direção
		inversa fecha o par com o adr-113 (as duas direções do mesmo contrato);
		exclusão consciente vira artefato auditável com critério de
		legitimidade (não omissão nem carimbo); o drift PRÉ-EXISTENTE (cmt,
		rew) foi pego pelo gate já na ativação — o gate pagou o próprio custo
		na primeira execução; a 6ª família (svc-) fecha o vão entre
		#OperationalScope e o catálogo operável do domain-model.

		Negativas/custos: +1 kind no runner (superfície de manutenção — motor
		novo de ~35 linhas, mitigado por fixture própria e self-asserção);
		toda fatia futura de domain-model carrega o custo de coevolução ou
		justificação (vigiado pela falsificação (b)); o baseline de 61 warns
		polui o output do runner até as higienes executarem (janela declarada,
		catraca warn→reject condicionada a baseline zero); a legitimidade das
		exclusões prose-keyed depende de leitura humana até a fatia de
		estruturação de ator/enforcement (deferimento consciente registrado
		em def-080, trigger manual-review — revisita quando as higienes
		medirem o volume real de exclusões).
		"""

	affectedArtifacts: [
		"architecture/artifact-schemas/agent-spec.cue",
		"architecture/artifact-schemas/structural-check.cue",
		"scripts/ci/structural-check-runner.py",
		"architecture/structural-checks/agent-spec.cue",
		"architecture/production-guides/domain-model.cue",
	]

	plannedOutputs: [
		"governance/build-time/task-specs/wi-154.cue",
		"governance/build-time/task-specs/wi-155.cue",
		"architecture/deferred-decisions/def-080-structure-command-actor-and-invariant-enforcement.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	defersTo: ["def-080"]

	principlesApplied: [
		"P10 — a classe-1 (incompletude) é gate determinístico (conjunto-pertinência sobre refs estruturadas); a classe-2 (prosa envelhecida) é interpretativa e vive como disciplina de PG + advisory, nunca gate LLM.",
		"adr-113 — o gate é a direção inversa do mesmo contrato agente↔modelo: sc-ag-01 mata responsabilidade fantasma (ref sem building block), sc-ag-02 mata mapa desatualizado (building block sem ref).",
		"adr-097 — born-warn: gate novo nasce anunciando baseline, promove a reject por catraca em decisão própria quando o baseline zera (precedente adr-117→123).",
		"P0 — exclusão por classe evita duplicação de rationale (uma regra auditável em vez de dezenas de carimbos idênticos); a classe é o fundamento, os refs são a extensão verificável.",
	]

	supersedes: []

	rationale: """
		O gate de cobertura venceu a alternativa de 'disciplina de processo
		apenas' porque as 3 fatias provaram que disciplina sem gate não segura
		drift aditivo — o processo existia (PG, self-review, founder review) e
		o drift passou. A direção inversa venceu 'estender o sc-ag-01' porque
		a pertinência de conjunto é invertida (catálogo→refs, não
		refs→namespace) e exige lógica que o motor existente não tem (união
		por escopo, exclusões, restrição por família) — kind novo com fixture,
		mesmo porte de adr-169. As 6 famílias vencem 5 e 11: 5 deixaria svc-
		(categoria-ação real, 5 ids em 2 BCs) invisível; 11 geraria exclusão
		em massa de famílias que doutrina de parent/runtime já cobre (113 vo-
		no repo). Born-warn vence born-reject porque o baseline é sujo por
		construção (o gate nasce para ACUSAR dívida conhecida, não para
		bloquear o repo no dia 1).
		"""
}
