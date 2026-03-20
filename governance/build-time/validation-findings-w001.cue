package build_time

// validation-findings-w001.cue — Registro de findings das tarefas
// de validação da W001 (WI-002, WI-003, WI-005, WI-006).
//
// Phase 0: formato minimal sem schema formal. Quando schema
// #ValidationReport existir, migrar para formato tipado.

validationFindings: {
	wave:       "W001"
	executedAt: "2026-03-20"
	rationale: """
		Tarefas type:validate não produzem artefatos novos, mas seus
		resultados precisam ser rastreáveis para desbloquear dependências
		no work-graph e para auditoria de que a baseline de conformidade
		foi verificada antes de avançar para fases que criam instâncias.
		"""

	limitations: [{
		description: "Formato Phase 0 sem artifact schema formal. Estrutura ad-hoc."
		rationale:   "Não existe schema #ValidationReport em artifact-schemas/. Criar schema para um único uso violaria YAGNI. Migrar quando o padrão se repetir."
	}]

	tasks: {
		"WI-002": {
			title:    "Validar architecture/design-principles.cue contra schema"
			artifact: "architecture/design-principles.cue"
			status:   "pass"
			findings: [{
				severity:  "warn"
				message:   "Sem artifact schema em architecture/artifact-schemas/. Tipos definidos inline (#DesignPrinciple, #PrincipleGroup). CI classifica como unmatched-governed-with-schemas."
				rationale: "Dívida técnica registrada. Não bloqueia W001 porque o artefato é auto-consistente e referenciável via designPrinciplesRef."
			}]
		}
		"WI-003": {
			title:    "Validar governance/repo-structure.cue"
			artifact: "governance/repo-structure.cue"
			status:   "pass"
			findings: [{
				severity:  "warn"
				message:   "Sem artifact schema em architecture/artifact-schemas/. Schema e instância definidos no mesmo arquivo."
				rationale: "Dívida técnica registrada. Não bloqueia W001 porque scope.validated cobre todos os paths necessários para W001."
			}]
		}
		"WI-005": {
			title:    "Validar schema #ADR existente"
			artifact: "architecture/artifact-schemas/adr.cue"
			status:   "pass"
			findings: []
		}
		"WI-006": {
			title:    "Validar schema #DomainDefinition existente"
			artifact: "architecture/artifact-schemas/domain-definition.cue"
			status:   "pass"
			findings: [{
				severity:  "info"
				message:   "TODO no código (linha 85-86): extrair tipos comuns para artifact_schemas_common."
				rationale: "Melhoria futura de organização de package. Não afeta completude do schema para WI-001."
			}]
		}
	}
}
