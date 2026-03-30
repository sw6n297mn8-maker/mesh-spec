package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ntf: artifact_schemas.#Subdomain & {
	code: "ntf"
	name: "Notifications & Communications"
	type: "generic-subdomain"

	definition: """
		Entrega de notificações e comunicações transacionais —
		e-mail, SMS, push, webhooks e canais futuros. Abstrai
		a heterogeneidade de canais de entrega em interface
		uniforme que subdomínios consomem. Não decide o que
		comunicar nem quando (responsabilidade dos subdomínios
		emissores), apenas entrega.
		"""

	purpose: """
		Separar entrega de comunicações da lógica de domínio
		que as origina. Canais de notificação mudam por
		tecnologia (novos provedores, novos canais), não por
		regras de negócio. Sem NTF como unidade separada,
		cada subdomínio implementaria entrega de notificações
		internamente — duplicação com risco de inconsistência
		de canal e de preferências do destinatário.
		"""

	negativeBoundaries: [{
		responsibility: "Lógica de domínio — decisão sobre o que comunicar e quando."
		delegatedTo: {
			type: "subdomain"
			ref:  "cmt"
		}
		rationale: "NTF entrega; subdomínios emissores (CMT, FCE, NGR, etc.) decidem conteúdo e timing. Fusão acoplaria infraestrutura de entrega a lógica de negócio — cada novo canal exigiria revisão de regras de domínio."
	}, {
		responsibility: "Crescimento da rede — detecção e ativação de contrapartes."
		delegatedTo: {
			type: "subdomain"
			ref:  "ngr"
		}
		rationale: "NTF entrega convites; NGR decide quem convidar e com qual proposta de valor. Separação permite que estratégia de growth evolua sem alterar infraestrutura de entrega."
	}]

	rationale: """
		NTF é generic porque entrega de notificações é
		infraestrutura comoditizada — provedores de e-mail, SMS
		e push são intercambiáveis. Nenhuma diferenciação
		competitiva da Mesh reside em como notificações são
		entregues. NTF é substituível por qualquer serviço de
		comunicação que implemente os mesmos canais.
		"""
}
