package main

import (
	"bytes"
	"fmt"
	"os/exec"
	"strings"
)

func ChangedFiles(baseRef string) ([]string, error) {
	cmd := exec.Command("git", "diff", "--name-only", baseRef+"...HEAD")
	var out bytes.Buffer
	var stderr bytes.Buffer
	cmd.Stdout = &out
	cmd.Stderr = &stderr

	if err := cmd.Run(); err != nil {
		return nil, fmt.Errorf("git diff falhou: %w: %s", err, stderr.String())
	}

	raw := strings.TrimSpace(out.String())
	if raw == "" {
		return []string{}, nil
	}

	lines := strings.Split(raw, "\n")
	files := make([]string, 0, len(lines))
	for _, line := range lines {
		line = strings.TrimSpace(line)
		if line != "" {
			files = append(files, line)
		}
	}
	return files, nil
}
