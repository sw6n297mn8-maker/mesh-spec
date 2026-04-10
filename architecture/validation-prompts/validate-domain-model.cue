package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-domain-model": artifact_schemas.#ValidationPrompt & {
	id:    "vp-domain-model"
	title: "Validação semântica de Domain Model"

	matchPatterns: ["^contexts/[a-z][a-z0-9-]*/domain-model\\.cue$"]

	appliesTo: ["domain-model"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/domain-model.cue",
		"architecture/design-principles.cue",
		"domain/domain-definition.cue",
		"strategic/context-map.cue",
	]

	checks: [{
		id:       "vc-dm-01"
		question: "As invariants são regras de negócio genuínas com consequências concretas de violação, ou são reafirmações de commands disfarçadas de regra?"
		lookFor:  "Invariants cuja rule repete a descrição do command que a protege (e.g., invariant 'registro deve ser completo' para command 'registrar participante'). Invariants sem consequência identificável de violação — se violar, o que acontece de ruim? Invariants que são checks de formato (validação técnica) em vez de regras do domínio. Teste: se a invariant fosse removida, algum cenário de negócio perigoso se tornaria possível? Se não, não é invariant."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "tq-dm-03 verifica que invariants estão protegidas por aggregates. Este check avalia se são invariants reais — regras cujo enforcement protege o domínio. Invariant inflada polui o modelo e cria falsa sensação de segurança."
	}, {
		id:       "vc-dm-02"
		question: "O aggregate boundary é a menor unidade que preserva consistência transacional, ou agrega demais/de menos?"
		lookFor:  "Aggregate com muitas entities que poderiam ter consistência eventual entre si — sinal de boundary inflado. Aggregate único cobrindo conceitos que mudam em ritmos diferentes ou por razões diferentes. Inversamente: dois aggregates que sempre mudam juntos na mesma transação — sinal de boundary fragmentado. Teste: qual invariant cross-entity requer transação atômica? Se não há, entities podem ser aggregates separados."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "tq-dm-01 a tq-dm-03 validam wiring (commands, events, invariants pertencem a aggregates). Este check avalia design da boundary — o aggregate é a menor unidade que protege invariantes transacionais? Aggregate inflado cria contenção; fragmentado cria inconsistência."
	}, {
		id:       "vc-dm-03"
		question: "O lifecycle state machine cobre todas as transições relevantes do domínio, ou há caminhos legítimos que não estão modelados?"
		lookFor:  "Estados terminais sem path de chegada realista. Transições que o canvas ou a análise de incentivos sugerem mas não aparecem no lifecycle (e.g., canvas menciona reativação mas lifecycle não tem transição suspended→qualified). Guards ausentes em transições de alto risco — transições que mudam significativamente o que o participante pode fazer sem nenhuma invariant como guard. Transições que pulam estados intermediários sem justificativa."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "tq-dm-07 e tq-dm-08 validam integridade referencial do lifecycle (refs válidas, states existem). Este check avalia completude semântica — a state machine modela o comportamento real do domínio? Transição ausente é cenário não tratado."
	}, {
		id:       "vc-dm-04"
		question: "Os events publicados são fatos de domínio com semântica estável, ou são notificações técnicas que vazam implementação?"
		lookFor:  "Events com nome no presente ou futuro em vez de passado (fato consumado). Events cujo nome descreve ação técnica em vez de fato de domínio (e.g., 'DataUpdated', 'RecordSaved'). Events publicados que carregam estado completo do aggregate em vez de fato específico — sinal de generic event anti-pattern. Events com campos que só fazem sentido para um consumer específico — acoplamento via payload."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "tq-dm-11 valida alinhamento events↔canvas. Este check avalia qualidade semântica dos events — são fatos de domínio estáveis o suficiente para contratos cross-BC? Event publicado é contrato; instabilidade semântica propaga para todos os consumers."
	}, {
		id:       "vc-dm-05"
		question: "As projections e query capabilities cobrem as necessidades de consulta dos BCs consumers declarados no canvas, ou há gaps de informação?"
		lookFor:  "BCs consumers listados no canvas que precisariam de informação não disponível em nenhuma projection. Query capabilities que retornam dados que nenhum consumer declarado consome — possível over-engineering. Projections que consomem events mas não oferecem query capability — projeção sem superfície de consulta. Comparar com communication outbound do canvas: cada query-surface declarada tem projection correspondente?"
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "tq-dm-16 valida que query-surfaces do canvas têm projections. Este check avalia se as projections atendem as necessidades reais dos consumers, não apenas correspondência formal — um consumer pode precisar de dados que a projection não expõe mesmo existindo."
	}]

	rationale: "Domain model é o mapa tático do BC — building blocks, boundaries e comportamento. Validação semântica complementa integridade referencial (quality criteria) com avaliação de design: qualidade de invariants como regras de negócio reais, adequação de aggregate boundaries, completude de lifecycle, estabilidade semântica de events publicados, e cobertura de projections para consumers declarados."
}
