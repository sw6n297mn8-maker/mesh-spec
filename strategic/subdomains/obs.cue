package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

obs: artifact_schemas.#Subdomain & {
	code: "obs"
	name: "Observability & Operational Intelligence"
	type: "supporting-subdomain"

	definition: """
		Observabilidade do sistema como capacidade de domínio —
		métricas operacionais, health checks, alertas, tracing
		distribuído e dashboards. Produz a visibilidade necessária
		para que agentes e humanos monitorem, diagnostiquem e
		otimizem operações. Não processa transações (ECL, FCE),
		não computa reputação (NIM), não modela risco (REW).
		"""

	purpose: """
		Separar a capacidade de observar o sistema da lógica de
		negócio que o sistema executa. Observabilidade é
		cross-cutting — consome eventos de todos os subdomínios
		sem pertencer a nenhum. Sem OBS como unidade separada,
		cada subdomínio implementaria instrumentação internamente
		— duplicação com padrões inconsistentes e lacunas de
		visibilidade.
		"""

	negativeBoundaries: [{
		responsibility: "Processamento de transações — lifecycle, pagamentos, risco."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "OBS observa; CMT (e demais) executam. Fusão acoplaria instrumentação à lógica de negócio — cada mudança operacional exigiria revisão de observabilidade e vice-versa."
	}, {
		responsibility: "Inteligência de rede — scoring, matching, reputação."
		delegatedTo: {
			type: "subdomain"
			ref:  "nim"
		}
		rationale: "OBS produz métricas operacionais sobre o sistema; NIM produz sinais de domínio sobre participantes. Métricas de infra e sinais de negócio têm consumidores, modelos e cadências distintos."
	}, {
		responsibility: "Auditoria contínua — compliance, trilha de auditoria regulatória."
		delegatedTo: {
			type: "subdomain"
			ref:  "ato"
		}
		rationale: "OBS fornece visibilidade operacional para diagnóstico; ATO mantém trilha de auditoria para compliance regulatório. Observabilidade é best-effort e efêmera; auditoria é obrigatória e persistente — requisitos incompatíveis num único modelo."
	}]

	rationale: """
		OBS é supporting porque observabilidade é capacidade
		de infraestrutura com padrões bem estabelecidos (OpenTelemetry,
		Prometheus, tracing distribuído) — não proprietária. O valor
		proprietário da Mesh está nos dados de domínio (NIM, REW),
		não na instrumentação. OBS habilita operação agent-first
		(ax-01) ao fornecer a visibilidade que agentes precisam
		para operar autonomamente.
		"""
}
