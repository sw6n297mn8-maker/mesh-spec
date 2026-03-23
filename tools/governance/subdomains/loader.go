package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"os/exec"
	"path/filepath"
)

func cueFiles(repoRoot string) ([]string, error) {
	base := []string{
		"strategic/subdomain.cue",
		"strategic/subdomain-catalog.cue",
		"strategic/subdomain-fitness-functions.cue",
		"strategic/subdomain-ci-policy.cue",
		"strategic/subdomain-suite.cue",
	}

	pattern := filepath.Join(repoRoot, "strategic", "subdomains", "*.cue")
	matches, err := filepath.Glob(pattern)
	if err != nil {
		return nil, fmt.Errorf("erro ao globar subdomains: %w", err)
	}

	for _, m := range matches {
		rel, err := filepath.Rel(repoRoot, m)
		if err != nil {
			return nil, err
		}
		base = append(base, rel)
	}

	return base, nil
}

func LoadSuite(repoRoot string) (*SubdomainSuite, error) {
	absRoot, err := filepath.Abs(repoRoot)
	if err != nil {
		return nil, fmt.Errorf("erro ao resolver path do repo: %w", err)
	}

	files, err := cueFiles(absRoot)
	if err != nil {
		return nil, err
	}

	args := []string{"export", "--out", "json", "-e", "subdomainSuite"}
	args = append(args, files...)

	cmd := exec.Command("cue", args...)
	cmd.Dir = absRoot

	var stdout, stderr bytes.Buffer
	cmd.Stdout = &stdout
	cmd.Stderr = &stderr

	if err := cmd.Run(); err != nil {
		return nil, fmt.Errorf("cue export falhou: %w: %s", err, stderr.String())
	}

	var suite SubdomainSuite
	if err := json.Unmarshal(stdout.Bytes(), &suite); err != nil {
		return nil, fmt.Errorf("erro ao decodificar subdomainSuite: %w", err)
	}

	if suite.Catalog.Subdomains == nil {
		suite.Catalog.Subdomains = map[string]Subdomain{}
	}

	return &suite, nil
}

func LoadSuiteFromFixture(fixtureDir string) (*SubdomainSuite, error) {
	root, err := filepath.Abs(fixtureDir)
	if err != nil {
		return nil, err
	}
	return LoadSuite(root)
}
