package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr019: artifact_schemas.#ADR & {
	id:    "adr-019"
	title: "Validation prompts with automatic post-commit hook and queue"
	date:  "2026-03-20"

	decisionClass: "structural"
	decider:       "founder"

	context: """
		O protocolo de validação semântica (quality-gate.cue, camada
		'Semântica') depende do agente instruir o usuário a abrir sessão
		separada manualmente após cada commit. Na prática, isso gera
		atrito: o agente precisa lembrar de verificar se existe prompt,
		o usuário precisa lembrar de executar, e não há registro
		persistente de pendências. Alternativas consideradas: (a) validação
		inline no mesmo agente — rejeitada: viola separação de contexto
		que elimina viés de confirmação; (b) CI com API key dedicada —
		rejeitada para esta fase: infraestrutura ainda não disponível,
		path válido para futuro; (c) hook post-commit com queue —
		aceita: detecta automaticamente via matchPatterns, persiste
		pendências em arquivo, mantém separação de contexto.
		"""

	decision: """
		Três artefatos coordenados: (1) schema #ValidationPrompt com
		#ValidationCheck, #ValidationTargetType (#ArtifactType |
		'self-review-report'), #RegexPattern, e #CheckOutputMode
		('pass-fail' | 'finding-only' | 'narrative'); (2) três
		instâncias fundacionais — validate-adr.cue, validate-artifact-
		schema.cue, validate-self-review-report.cue; (3) hook
		post-commit que extrai matchPatterns dos prompts, testa contra
		arquivos commitados, e escreve matches em .validation-queue
		para processamento batch.
		"""

	consequences: """
		Positivas: matching automático elimina dependência de memória
		do agente; queue persiste pendências entre sessões; schema
		garante consistência entre prompts; appliesTo como enum
		controlada (#ValidationTargetType) previne types arbitrários.
		Negativas: extração de matchPatterns via grep é frágil — assume
		formato fixo de patterns no CUE (mitigação: migrar para cue
		export quando performance justificar); .validation-queue requer
		.gitignore; processamento batch ainda é manual (mitigação:
		path para CI com API key); validation prompts para tipos sem
		instâncias (canvas, domain-definition) adiados — criados
		quando instâncias existirem.
		"""

	status: "accepted"

	reversibility: "high"
	blastRadius:   "cross-cutting"

	affectedArtifacts: [
		"architecture/artifact-schemas/validation-prompt.cue",
		"architecture/validation-prompts/validate-adr.cue",
		"architecture/validation-prompts/validate-artifact-schema.cue",
		"architecture/validation-prompts/validate-self-review-report.cue",
		"scripts/hooks/post-commit",
	]

	principlesApplied: [
		"P0",
		"P1",
		"P12",
	]

	rationale: """
		P12 (governança como código) exige que validação seja automatizada
		proporcionalmente à maturidade do sistema. P0 (single source of
		truth) é respeitado: cada prompt declara matchPatterns como fonte
		canônica de matching — o hook resolve em runtime, sem cache ou
		duplicação. P1 (schemas como source of truth) é estendido: o
		schema #ValidationPrompt governa a estrutura de todos os prompts,
		garantindo consistência do regime de validação semântica.
		"""
}
