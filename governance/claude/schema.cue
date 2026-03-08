package claude

// #Section define uma seção do CLAUDE.md.
//
// canonicalSource indica onde vive a norma canônica:
//   "self" → esta seção É a fonte canônica (regra comportamental do agente).
//   outro valor → arquivo/seção onde a norma vive; content é instrução + ponteiro.
//
// rationale não é renderizado no CLAUDE.md — vive apenas no CUE fonte,
// acessível a humanos que leem a source of truth.
#Section: {
	title:           string & !=""
	canonicalSource: string & !=""
	content:         string & !=""
	rationale:       string & !=""
}

// #AgentConfig é a estrutura raiz do gerador de CLAUDE.md.
// sections exige pelo menos uma seção (fix RT-v3-01).
#AgentConfig: {
	repo:     string & !=""
	heading:  string & !=""
	sections: [#Section, ...#Section]
}
