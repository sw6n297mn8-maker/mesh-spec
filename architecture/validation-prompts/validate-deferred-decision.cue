package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-deferred-decision": artifact_schemas.#ValidationPrompt & {
	id:    "vp-deferred-decision"
	title: "Validação semântica de deferimentos conscientes governados"

	matchPatterns: ["^architecture/deferred-decisions/def-[0-9]{3}-[a-z0-9-]+\\.cue$"]

	appliesTo: ["deferred-decision"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/deferred-decision.cue",
		"architecture/production-guides/deferred-decision.cue",
		"architecture/adrs/adr-062-introduce-deferred-decision-artifact.cue",
	]

	checks: [{
		id:         "vc-def-01"
		question:   "deferralRationale articula trade-off concreto (custo evitado AGORA + custo de continuar deferindo) ou é genérico (\"fazer depois\", \"quando der tempo\", \"em sessão futura\")?"
		lookFor:    "deferralRationale que descreve apenas o que NÃO está sendo feito sem dizer por que ESSE caminho vale mais agora. Ausência de menção concreta a (a) custo evitado por deferir (e.g., 'cerimônia sem enforcement real'), (b) maturidade insuficiente identificada (e.g., 'caso concreto ainda não materializou'), OU (c) trabalho alternativo escolhido na sessão. Padrão a flag: substituir tópico do deferimento por outro tópico no rationale — se ainda faz sentido, está abstrato."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "Deferimento sem trade-off articulado é procrastinação travestida — tornará backlog não-acionável. tq-def-01 do schema fail; este check é a contraparte interpretativa que detecta vagueness mascarada por extensão (MinRunes(100) garante tamanho, não substantividade)."
	}, {
		id:         "vc-def-02"
		question:   "Triggers são calibrados — nenhum threshold ou pattern tão amplo que sempre dispara, nem tão restrito que nunca dispara? triggerCalibrationRationale articula POR QUE estes valores específicos?"
		lookFor:    "recurrence com threshold=2 e pattern muito comum (e.g., 'adr' ou 'cue') — false positive risk alto. file-contains com pattern catch-all (e.g., '.*'). volume-threshold com threshold absurdo para o tipo (e.g., threshold=1000 quando há 50 instâncias). triggerCalibrationRationale tautológico ('threshold=2 porque escolhemos 2'). temporal sem rationale forte de calendário ou regulação."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "Calibração ruim degrada o sistema: trigger que nunca dispara é cosmético; trigger que sempre dispara causa noise (founder ignora). tq-defg-03 do PG warn; este check valida ad-hoc cada def-XXX criado."
	}, {
		id:         "vc-def-03"
		question:   "originatingArtifacts é rastreável — cada origin (.cue path ou session:<slug>) corresponde a artefato/sessão real onde decisão de deferir foi tomada?"
		lookFor:    "Path .cue em originatingArtifacts que não existe no repo. session:<slug> sem âncora identificável (nome de branch, slug de sessão de commit, etc.). Padrão suspeito: lista de origins suspiciously rica (5+ origins) tentando justificar deferimento por agregação — pode indicar deferimento agregando trabalho disparate (split em múltiplos def-XXX)."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "Origin não-rastreável quebra audit trail do deferimento. session:<slug> não-identificável depois é functional equivalent a 'algum lugar'. tq-def-01 não cobre isso (foca no rationale); este check captura origin substantivity."
	}, {
		id:         "vc-def-04"
		question:   "Pelo menos 1 trigger non-manual-review existe, OR deferralRationale articula explicitamente por que manual-only é apropriado neste caso (não default por preguiça)?"
		lookFor:    "Triggers list contém SOMENTE manual-review entries. deferralRationale ou triggerCalibrationRationale NÃO articula por que automação não é viável neste caso (e.g., 'decisão estratégica que só founder pode revisitar', 'condição não machine-evaluable'). Reason de manual-review é vago ('founder decide quando revisitar')."
		outputMode: "finding-only"
		severity:   "warn"
		rationale:  "Manual-only deferral depende de revisão periódica do founder — sem trigger automático, vira esquecimento (failure mode primário do sistema atual). tq-def-03 + tq-defg-04 reiteram; este check captura per-instance compliance."
	}]

	rationale: "Deferimentos conscientes governados (per adr-062) são unidades de cobrança automática de dívida. Validação semântica complementa o shape (cue vet) verificando dimensões interpretativas: trade-off articulado (vc-def-01 fail — anti-procrastinação), calibração de triggers (vc-def-02 warn — anti-noise/silêncio), origins rastreáveis (vc-def-03 warn — audit trail), preferência por automação (vc-def-04 warn — anti-esquecimento). vc-def-01 é o check de máximo valor — captura procrastinação travestida que o schema MinRunes(100) não detecta."
}
