package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr173: artifact_schemas.#ADR & {
	id:    "adr-173"
	title: "Identidade legal organizacional qualificada por esquema: raiz (scheme, value) com br-cnpj como primeiro esquema, mandatório para organizações brasileiras"
	date:  "2026-07-12"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		O corpus fundacional (Mesh-Old mesh-domain-model.md, definição do
		subdomínio NPM) registrou a intenção: qualificação de contrapartes 'nas
		jurisdições em que o grupo opera, incluindo IDENTIFICAÇÃO FISCAL LOCAL'.
		A materialização do idc no mesh-spec ESTREITOU essa intenção sem
		registro: vo-cnpj-identifier virou a rootIdentity do
		agg-organizational-identity ('cada CNPJ tem exatamente uma Identidade'),
		e o glossário do npm ecoou 'Identificada por CNPJ' — decisão silenciosa
		pelo caso brasileiro, sem ADR. A arqueologia (2026-07-12, provocada pela
		memória do founder) confirmou: nenhuma decisão registrada sobre esquema
		de identidade em NENHUMA geração de ADRs; a UL do idc manteve a porta
		aberta ('CNPJ ou equivalente' em term-identidade-organizacional), mas o
		modelo operacional hardcodou.

		O custo da correção é assimétrico no tempo: hoje ZERO identidades reais
		existem (nem runtime de cadastro há) — a mudança é edição de spec; após
		o primeiro cadastro vivo, cada identidade registrada é uma chave de
		aggregate a migrar (e, com runtime, event streams a re-keyar). O founder
		decidiu (Opção A) resolver AGORA, na janela do arquivo vazio, antes da
		fatia da requisição.
		"""

	decision: """
		(1) A identidade legal organizacional passa a ser o par (scheme, value):
		vo-legal-entity-identifier substitui vo-cnpj-identifier como identidade
		externa e rootIdentity de agg-organizational-identity (field
		'legalIdentifier'). Unicidade generaliza: cada (esquema, valor) tem
		exatamente uma Identidade Organizacional; espelhado no
		inv-single-active-identity do npm ('mesmo identificador legal
		qualificado' no lugar de 'mesmo CNPJ').

		(2) 'br-cnpj' é o PRIMEIRO e único esquema registrado, e é MANDATÓRIO
		para organizações brasileiras — CNPJ permanece o identifier regulatório
		SCD/Bacen (constraint inviolável preservada por construção; o registro
		de esquemas carrega obrigatoriedade por jurisdição).

		(3) Validação de formato e fonte de verificação são POR ESQUEMA:
		br-cnpj → formato XX.XXX.XXX/XXXX-XX + dígitos verificadores + fontes
		Receita Federal/Junta Comercial (o que vo-cnpj-identifier prescrevia,
		agora como propriedade do esquema); esquemas futuros (ex.: 'lei' →
		GLEIF) trazem validador e fonte próprios. O FLUXO de verificação
		(comandos, eventos, estados, invariantes de trilha) não muda de forma —
		muda a chave e o roteamento. A ação act-validate-cnpj-format do
		idc-primary-agent passa a validar o esquema br-cnpj (única mudança:
		descrição + ref ao VO novo; código da action preservado — churn zero em
		governança de agente).

		(3b) A generalização é COMPLETA nos artefatos afetados — nenhum
		residual da forma antiga sobrevive como regra ou chave (varredura do
		review isolado, corrigida no round 2): rationale do aggregate e chave
		da projeção/query de verificação no idc generalizados para o
		identificador qualificado; campo do agg-participant do npm renomeado
		cnpj → legalIdentifier (a chave de negócio do inv-single-active-
		identity segue o invariante generalizado); inv-registration-
		completeness generalizado; campo de assinatura signerCnpj →
		signerIdentity (alinha ao VO). Referências ao NOME antigo do VO em
		catálogos/rationales atualizadas.

		(4) INTOCADOS: vo-participant-id (chave neutra gerada pelo npm) e toda
		correlação downstream (ctr, rew, nim, ssc consultam por participantId);
		o gate inv-approval-requires-identity-verification; a arquitetura em
		duas camadas (chave neutra ↔ documento legal) é exatamente o que
		contém o blast radius em idc+npm.

		(5) Menções exemplificativas a CNPJ em prosa permanecem (ex.:
		'baixa de CNPJ' como exemplo de perda de elegibilidade no
		evt-identity-revoked) — são exemplos brasileiros legítimos, não
		estrutura. A UL ganha termo canônico novo
		(term-identificador-legal-qualificado, glossário idc).

		(6) FICA DEFERIDO (def-077): agregação de múltiplos identificadores na
		mesma organização (CNPJ + LEI simultâneos). Mínimo definitivo adotado:
		1 identidade por (esquema, valor); vínculo entre identidades da mesma
		organização espera caso real.
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE (a) o par (scheme, value) não expressar algum identificador legal real de jurisdição relevante (formato que não caiba em esquema+valor string); OU (b) a generalização introduzir ambiguidade regulatória no caso BR (br-cnpj mandatório deixar de ser verificável como obrigação); OU (c) o custo previsto como evitado se materializar mesmo assim (migração de chave necessária apesar da mudança pré-dados)."
		observableSignal: "(a) observável na fatia de adoção de cada esquema novo: identificador que exija estrutura além de (scheme, value) para não RE-decidir raiz. (b) observável em review de compliance: a obrigação br-cnpj-para-BR deve permanecer expressa e verificável no modelo. (c) observável no runtime: se o cadastro materializar ANTES desta mudança mergear, a janela fechou e a premissa de custo falhou — reportar imediatamente."
	}

	consequences: """
		Positivas: restaura a intenção fundacional registrada ('identificação
		fiscal local por jurisdição') com proveniência citável; internacionalizar
		identidade vira ADIÇÃO DE ESQUEMA (validador + fonte) sem tocar chave
		neutra, consumidores ou fluxo de verificação; o estreitamento silencioso
		da materialização do idc fica documentado e desfeito na janela em que
		custa só edição de spec.

		Negativas/custos: o modelo carrega generalidade à frente da demanda
		(um esquema só registrado) — aceito conscientemente pelo custo
		assimétrico da migração de chave; a sub-pergunta de múltiplos
		identificadores por organização fica aberta (def-077), com o custo de
		uma eventual organização dual-identificador existir como duas
		identidades desvinculadas até a decisão.
		"""

	affectedArtifacts: [
		"contexts/idc/domain-model.cue",
		"contexts/idc/glossary.cue",
		"contexts/idc/agents/idc-primary-agent.cue",
		"contexts/npm/domain-model.cue",
		"contexts/npm/glossary.cue",
	]

	plannedOutputs: [
		"architecture/deferred-decisions/def-077-multi-identifier-organization.cue",
	]

	defersTo: ["def-077"]

	principlesApplied: [
		"P0 — uma localização canônica para a forma da identidade legal (o VO novo); o esquema br-cnpj absorve o que o VO antigo prescrevia em vez de coexistir com ele (dois VOs de identidade seriam drift por construção).",
		"P10 — validação por esquema permanece determinística (formato + dígitos verificadores + fonte oficial); nenhuma camada estocástica entra no gate de identidade.",
		"adr-172 — a identidade qualificada é da ORGANIZAÇÃO (posição-neutra): nenhum esquema carrega papel; papéis seguem posicionais.",
		"foundingPrinciples/reversibilityThreshold — mudança em estrutura de identidade cruza o threshold (dados persistidos futuros + obrigação regulatória): decidida pelo founder explicitamente (Opção A), não por default de agente.",
	]

	supersedes: []

	rationale: """
		Feita AGORA (e não deferida) porque o único custo que cresce
		monotonicamente na internacionalização é exatamente este — cada cadastro
		real após o runtime é uma chave a migrar — e o despertador originalmente
		proposto (trigger no primeiro caso internacional) tocaria TARDE, com o
		arquivo já cheio; o founder identificou a falha e escolheu a janela do
		arquivo vazio. O desenho (scheme, value) é território batido (ISO 6523,
		LEI) — risco baixo de errar sem segundo esquema real. A alternativa
		'manter CNPJ e migrar quando precisar' foi rejeitada pelo custo
		assimétrico; a alternativa 'modelar também múltiplos identificadores por
		organização' foi rejeitada por especular sem caso (fica em def-077).
		"""
}
