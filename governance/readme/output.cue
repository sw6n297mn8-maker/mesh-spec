package readme

import "text/template"

// output.cue — Template markdown local para renderizar #ReadmeConfig
// como README.md derivado.
//
// Implementação LOCAL per adr-050: pode divergir do template de
// tekton-spec quando necessário. Contrato com o schema portfolio-wide
// é só a leitura dos campos — rendering é prerrogativa local.
//
// Convenção editorial: os campos .purpose e .conventions[] do
// #DirectoryNote NÃO podem conter o caractere '|', pois isso quebra
// a sintaxe de tabela markdown. Validação: revisão humana; se
// recorrente, endurecer via regex no schema em ADR futuro.

_tmpl: #"""
	# {{.repo}} — {{.heading}}

	{{.description}}

	## Estrutura do Repositório

	```
	{{.treeAscii}}
	```

	| Pasta | Propósito | Convenções |
	|---|---|---|
	{{- range .tree.entries}}
	| `{{.path}}` | {{.purpose}} | {{range $i, $c := .conventions}}{{if $i}}<br>{{end}}{{$c}}{{end}} |
	{{- end}}

	## Rationale da Estrutura

	{{.tree.rationale}}
	{{- if .sections}}

	## Contexto e Regras
	{{- range .sections}}

	## {{.title}}

	{{.content}}
	{{- end}}
	{{- end}}
	"""#

// _data combina os campos de config (#ReadmeConfig, fechado) com treeAscii
// (irmão, vindo de tree-generated.cue) num struct aberto para o template.
// Alias _treeAsciiTop evita auto-referência do campo treeAscii dentro de _data.
_treeAsciiTop: treeAscii
_data: {
	for k, v in config {(k): v}
	treeAscii: _treeAsciiTop
}

output: template.Execute(_tmpl, _data)
