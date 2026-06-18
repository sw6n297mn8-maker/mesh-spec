package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def060: artifact_schemas.#DeferredDecision & {
	id:     "def-060"
	title:  "Stack de vendor de cliente de frontend deferida ao frontend-runtime"
	date:   "2026-06-14"
	status: "triggered"

	triggeredAt: "2026-06-17"
	triggeredCondition: """
		adr-154 (em main, merge 031e6328) formalizou o criterio de runtime
		subordinado virar repo proprio e AUTORIZOU a existencia do
		frontend-runtime. A pre-condicao manual-review deste deferimento esta
		satisfeita no sentido que importa: o repo esta autorizado a nascer — a
		decisao que o def-060 pressupunha ("quando esse repo nascer") agora existe.

		Deferimento MANTIDO — NAO resolvido. adr-154 autoriza a EXISTENCIA do
		repo; NAO escolhe o vendor de cliente (framework web, motor de sync,
		runtime de orquestracao de agente IA, design system). A resolucao — a
		selecao JIT do stack — permanece deferida ate o frontend-runtime
		bootstrar de fato e escolher seu vendor atras da fronteira (P2). Status
		'triggered' registra que a pre-condicao de autorizacao foi atingida;
		resolvedBy fica vazio por construcao (o vendor concreto ainda nao existe).
		"""

	description: """
		A selecao de vendor de cliente de frontend fica deferida ao
		frontend-runtime, materializada JIT quando esse repo nascer: framework
		web, motor de sync mobile offline, runtime de orquestracao de agente IA
		(nao-deterministico, distinto do WorkflowPort de dominio cujo vendor e
		def-043), e design system visual (tokens, tipografia, marca) + specs de
		tela. O adr-150 ratifica os invariantes (premissa AI-first, 3 patterns de
		UX, fronteiras de isolamento, e as obrigacoes FF-FE-01..08 definidas
		nele); QUAL vendor os implementa e decisao de runtime de cliente atras da
		fronteira (P2), nao de spec.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: vendor de cliente e runtime atras da fronteira --
		o filtro spec×runtime do adr-139 fixa que a spec decide o estavel
		(comportamento + fronteira) e nao o stack que o implementa. Stack de
		frontend troca de lider em ciclos de ~18-24 meses; cravar nome de
		framework em lei de spec gravaria em pedra o que envelhece por design.
		Custo evitado: escolher framework + sync + UI-runtime + design-system
		antes de existir o frontend-runtime contra o qual construir e antes de o
		ecossistema girar -- retrabalho garantido quando o repo nascer. Custo de
		continuar deferindo: a spec nao nomeia o cliente -- mitigado porque
		nenhuma tela e construida antes do frontend-runtime, e os invariantes do
		adr-150 (nao o vendor) sao o que a primeira tela obedece. A alternativa de
		nao-deferir (cravar o stack como lei) foi rejeitada no adr-150 (opcao a)
		pelo mesmo motivo.
		"""

	triggerCalibrationRationale: """
		Manual-review-only, waiver consciente do tq-def-03: nenhum sinal de
		revisita e avaliavel pelo runner deterministico do mesh-spec. O
		frontend-runtime e repo futuro invisivel ao grep (mesma licao de def-043
		-- anchor em artefato de outro repo e invisivel ao runner do mesh-spec), e
		os watchpoints sao fatos de ecossistema externo (governing body de
		protocolo, massa critica de framework) que grep no repo nao afere. NAO se
		usa temporal: uma data projetada de release OSS nao e calendario
		operacional nem regulacao datada -- seria um relogio que dispara
		mecanicamente sem relacao com o progresso real do trabalho. Os watchpoints
		datados do arco entram como CRITERIOS de selecao, nao como gatilho de
		maquina: TanStack v1 stable + massa critica (~set/2027, senao reavaliar
		Next.js); AG-UI governing body independente (~fev/2028, senao o bridge
		dedicado migra para protocolo proprio SSE); assistant-ui bus factor;
		PowerSync manutencao ativa; SSE->WebSocket quando o caso de uso
		(co-edicao, voz) chegar. O founder revisita quando o frontend-runtime
		bootstrar OU quando um watchpoint madurar.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-150-frontend-ai-first-invariants.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque nenhuma tela e construida antes de o frontend-runtime
			existir; os invariantes ratificados pelo adr-150 (nao o nome do vendor)
			sao o que a primeira tela obedece, entao deferir o vendor nao bloqueia
			o caminho critico. cross-artifact porque o impacto se concentra na
			camada de cliente/apresentacao e seu contrato com a API, nao no runtime
			inteiro nem em todos os BCs. Reversivel: a escolha de
			framework/sync/UI-runtime/design-system nao muda spec nem contrato de
			Port.
			"""
	}

	triggers: [{
		kind: "manual-review"
		reason: """
			A condicao real de revisita -- o founder selecionar o vendor quando o
			frontend-runtime bootstrar -- e decisao de runtime de cliente nao
			machine-evaluable pelo runner do mesh-spec (repo futuro, invisivel ao
			grep). Os watchpoints de ecossistema (governing body de protocolo,
			massa critica de framework, datas-alvo do arco) tambem so o founder
			afere -- nao ha sinal no repo que o runner determine.
			"""
	}]
}
