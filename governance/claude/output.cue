package claude

import "text/template"

_tmpl: #"""
	# {{.repo}} — {{.heading}}
	{{- range .sections}}

	## {{.title}}

	{{.content}}
	{{- end}}
	"""#

output: template.Execute(_tmpl, config)
