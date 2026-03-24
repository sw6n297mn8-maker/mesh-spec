package shared_types

// strategic-classification.cue — vocabulário estratégico compartilhado.
//
// Taxonomia canônica para classificação estratégica de subdomínios.
// Deve ser reutilizada por artefatos como subdomain.cue e canvas.cue
// para eliminar drift semântico por construção.

#SubdomainClassification: "core-subdomain" | "supporting-subdomain" | "generic-subdomain"
