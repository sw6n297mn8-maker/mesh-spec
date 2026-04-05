package subdomains

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

log: artifact_schemas.#Subdomain & {
	code: "log"
	name: "Logistics & Operational Evidence"
	type: "supporting-subdomain"

	definition: """
		Captura, registro e gestão de evidência operacional
		— rastreamento de carga, entrega, inspeção de
		qualidade, medição de obra, atividades de prestação
		de serviço e eventos operacionais em campo. Produz
		a cadeia de custódia registrada que DLV consome como
		pré-condição de verificação do compromisso econômico.
		A captura de evidência comprova registro no ponto de
		origem, não veracidade do conteúdo registrado. Não
		governa o lifecycle do compromisso (CMT), não executa
		pagamentos (FCE), não modela risco (REW), não governa
		compliance de comércio exterior (ITC).
		"""

	purpose: """
		Separar a cadeia de custódia registrada de evidência
		operacional do lifecycle do compromisso econômico.
		Evidência operacional tem complexidade, vocabulário e
		cadência de evolução próprios — inspeção de qualidade
		em construção civil é radicalmente diferente de
		rastreamento de carga em logística ou confirmação de
		serviço prestado. Sem LOG como unidade separada, DLV
		governaria tanto a verificação do compromisso quanto
		a integridade de evidência operacional — dois domínios
		com modelos distintos.
		"""

	negativeBoundaries: [{
		responsibility: "Lifecycle do compromisso econômico — state machine, transições, fases."
		delegatedTo: {
			type: "subdomain"
			ref:  "dlv"
		}
		rationale: "LOG produz evidência; DLV consome como pré-condição para decisão de suficiência. Fusão acoplaria integridade de evidência operacional à verificação de execução — cadências de evolução distintas por vertical."
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
	}, {
		responsibility: "Identidade, autenticação, autorização e integridade criptográfica — assinaturas, verificação, cadeia de responsabilidade."
		delegatedTo: {
			type: "subdomain"
			ref:  "idc"
		}
		rationale: "LOG captura evidência operacional no ponto de origem; IDC garante identidade do agente, permissões e integridade criptográfica da evidência. Captura e integridade são preocupações distintas — LOG não garante não adulteração nem autoria verificável."
	}, {
		responsibility: "Compliance de comércio exterior — desembaraço aduaneiro, licenças de importação, habilitação RADAR."
		delegatedTo: {
			type: "subdomain"
			ref:  "itc"
		}
		rationale: "LOG captura evidência operacional de recebimento e inspeção de materiais importados; ITC governa o processo aduaneiro. A hand-off ocorre no desembaraço — ITC libera, LOG registra chegada e condição."
	}]

	rationale: """
		LOG é supporting porque a captura de evidência é
		especializável por vertical (construção, logística,
		energia) mas não é proprietária — o valor proprietário
		está na vinculação evidência→compromisso→pagamento
		(DLV+CMT+FCE). LOG contribui diretamente para
		mech-evidence ao produzir evidência com integridade
		criptográfica que alimenta o flywheel de crédito
		lastreado.
		"""
}
