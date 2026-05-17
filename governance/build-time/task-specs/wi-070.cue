package task_specs

taskSpecs: "WI-070": {
	version:     1
	title:       "Bootstrap Economic Foundation Layers (Layer -1 / Layer 1 / Layer 2 NIM) — emergent from WI-053"
	templateRef: "tmpl-create-schema@v1"
	semanticPrerequisites: [
		"EMERGENT FROM WI-053 — surgiu durante R3 cross-BC adversarial review (commit 956ef14): 5 system-level gaps cross-BC X1-X5 identificados que INV não resolve isoladamente",
		"Layer -1 + Layer 1 já materializados (commits c582ab7..78e8d67) — captura retroativa pelos 6 outputs primeiros",
		"Layer 2 NIM trajectory v0 design completo em chat history; encoding pendente (3 outputs últimos)",
		"Founder canonical R5+: 'valor não é propriedade da transação; é propriedade da trajetória; só existe se sobreviver à composição'",
	]
	outputs: [{
		artifact: "architecture/artifact-schemas/economic-assumption-model.cue"
		type:     "create"
	}, {
		artifact: "strategic/economic-model/mesh-economic-assumptions.cue"
		type:     "create"
	}, {
		artifact: "architecture/adrs/adr-082-economic-assumption-model-layer.cue"
		type:     "create"
	}, {
		artifact: "architecture/artifact-schemas/economic-mechanism-model.cue"
		type:     "create"
	}, {
		artifact: "strategic/economic-model/mesh-economic-mechanisms.cue"
		type:     "create"
	}, {
		artifact: "architecture/adrs/adr-083-economic-mechanism-model-layer.cue"
		type:     "create"
	}, {
		artifact: "architecture/artifact-schemas/value-function-model.cue"
		type:     "create"
	}, {
		artifact: "strategic/nim/mesh-value-function-v0.cue"
		type:     "create"
	}, {
		artifact: "architecture/adrs/adr-084-nim-bootstrap-layer-2.cue"
		type:     "create"
	}]
	affects: [
		"architecture/artifact-schemas/quality-criteria.cue",
		"governance/readme/config.cue",
	]
	rationale: """
		TAREFA EMERGENT-FROM-WI-053 (regra canônica founder estabelecida 2026-05-08):
		'Se trabalho novo surge durante uma WI: NÃO estenda a WI original;
		 NÃO ignore; CRIE nova WI conectada.'

		Surgiu durante WI-053 Phase 4 R3 cross-BC adversarial review (commit
		956ef14 — 'srr-inv-primary-agent R3 founder cross-BC adversarial
		review — 5 system-level declarations'): 5 system-level gaps X1-X5
		identificados — não resolúveis em INV isoladamente; necessitam
		camada arquitetural superior (cross-BC composition + reality layer
		+ mechanism design).

		Resultado da emergência: 3 layers ontológicos canonical:
		- Layer -1 (Economic Reality, ri-* — ADR-082): realidades adversariais
		  do ambiente que sistema sobrevive APESAR de.
		- Layer 1 (Economic Mechanisms, mech-* — ADR-083): mecanismos que
		  REDUZEM exploitability; NÃO eliminate, NÃO solve. R4++ adversarial
		  revealed Layer 1 insufficient by construction (composite attack
		  satisfies all mechanisms simultaneously — Round 2 SRR commit 78e8d67).
		- Layer 2 (NIM bootstrap, vfm-* — ADR-084 PENDENTE): sistema de
		  medição de valor real; trajectory-based v0 designed (3 candidates
		  ingênua/fluxo/rede testados → todos falharam → trajectory v0 com
		  interaction term emerged → ainda insuficiente; revela 3 NIM
		  subproblemas: separação fluxos / identidade econômica / trajetória).

		OUTPUTS STATUS (structured):
		DELIVERED:
		- architecture/artifact-schemas/economic-assumption-model.cue (c582ab7)
		- strategic/economic-model/mesh-economic-assumptions.cue (c582ab7)
		- architecture/adrs/adr-082-economic-assumption-model-layer.cue (c582ab7)
		- architecture/artifact-schemas/economic-mechanism-model.cue (8be13e5)
		- strategic/economic-model/mesh-economic-mechanisms.cue (8be13e5)
		- architecture/adrs/adr-083-economic-mechanism-model-layer.cue (8be13e5)
		PENDING:
		- architecture/artifact-schemas/value-function-model.cue
		- strategic/nim/mesh-value-function-v0.cue
		- architecture/adrs/adr-084-nim-bootstrap-layer-2.cue
		ORIGIN:
		emergent-from WI-053 (R3 cross-BC adversarial review, commit 956ef14)

		Overall progress: 6/9 outputs (~67%) delivered; 3 Layer 2 outputs
		pending (encoding aguarda continuidade).

		TENSÃO ESTRUTURAL CAPTURADA: status (delivered/pending) + origin
		(emergent-from) ainda NÃO são fields canônicos em #TaskOutput /
		#TaskSpec. Founder canonical R5+ 'repetição gera estrutura; 1
		ocorrência ≠ nova estrutura' — schema mod prematura. Gap rastreado
		em def-015 (task-output-temporality-metadata) com trigger
		automático: quando ≥ 2 WIs adicionais usarem este pattern,
		runner sinaliza para promote a schema. Insight founder: status +
		origin são o mesmo fenômeno — 'temporalidade do trabalho' (status =
		estado no tempo; origin = causalidade no tempo).

		FRASE CANONICAL FOUNDER R5++ capturada nesta sessão:
		'Governança não é só organizar trabalho; é preservar a verdade
		sobre o que aconteceu.' Esta WI registra a emergência
		retroativamente — não como dívida invisível, mas como trabalho
		rastreável + auditável + conectado a WI-053 origem.
		"""
}
