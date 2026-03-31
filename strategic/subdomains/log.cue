package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

log: artifact_schemas.#Subdomain & {
	code: "log"
	name: "Logistics & Operational Evidence"
	type: "supporting-subdomain"

	definition: """
		Captura, verificação e gestão de evidência operacional
		física — rastreamento de carga, entrega, inspeção de
		qualidade, medição de obra e eventos logísticos. Produz
		a cadeia de custódia que DLV consome como pré-condição
		de verificação do compromisso econômico. Não governa o
		lifecycle do compromisso (CMT), não executa pagamentos
		(FCE), não modela risco (REW).
		"""

	purpose: """
		Separar a cadeia de custódia de evidência física do
		lifecycle do compromisso econômico. Evidência operacional
		tem complexidade, vocabulário e cadência de evolução
		próprios — inspeção de qualidade em construção civil é
		radicalmente diferente de rastreamento de carga em
		logística. Sem LOG como unidade separada, DLV governaria
		tanto a verificação do compromisso quanto a integridade
		de evidência física — dois domínios com modelos distintos.
		"""

	negativeBoundaries: [{
		responsibility: "Lifecycle do compromisso econômico — state machine, transições, fases."
		delegatedTo: {
			type: "subdomain"
			ref:  "dlv"
		}
		rationale: "LOG produz evidência; DLV consome como pré-condição para decisão de suficiência. Fusão acoplaria integridade de evidência física à verificação de execução — cadências de evolução distintas por vertical."
	}, {
		responsibility: "Execução financeira — pagamentos, settlement."
		delegatedTo: {
			type: "subdomain"
			ref:  "fce"
		}
		rationale: "LOG comprova que operação aconteceu; FCE move dinheiro quando a comprovação é suficiente. Separação mantém cadeia de evidência independente de fluxo de caixa."
	}, {
		responsibility: "Monitoramento ambiental como atividade fim — sensoriamento, IoT, câmeras."
		delegatedTo: {
			type: "external-system"
			ref:  "ext-monitoring-systems"
		}
		rationale: "LOG consome sinais de sistemas de monitoramento mas não opera infraestrutura de sensoriamento. Internalizar hardware e IoT acoplaria domínio de evidência operacional à gestão de infraestrutura física."
	}]

	rationale: """
		LOG é supporting porque a captura de evidência é
		especializável por vertical (construção, logística, energia)
		mas não é proprietária — o valor proprietário está na
		vinculação evidência→compromisso→pagamento (DLV+CMT+FCE).
		LOG contribui diretamente para mech-evidence ao produzir
		evidência com integridade criptográfica que alimenta
		o flywheel de crédito lastreado.
		"""
}
