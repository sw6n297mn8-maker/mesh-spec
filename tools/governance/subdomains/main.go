package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

func loadCurrentWaveFromEnv() (*uint, error) {
	raw := os.Getenv("MESH_CURRENT_WAVE")
	if raw == "" {
		return nil, nil
	}

	parsed, err := strconv.ParseUint(raw, 10, 64)
	if err != nil {
		return nil, fmt.Errorf("MESH_CURRENT_WAVE inválida: %w", err)
	}

	w := uint(parsed)
	return &w, nil
}

func main() {
	baseRef := "origin/main"
	if len(os.Args) > 1 {
		baseRef = os.Args[1]
	}

	changedFiles, err := ChangedFiles(baseRef)
	if err != nil {
		fmt.Fprintf(os.Stderr, "erro ao obter changed files: %v\n", err)
		os.Exit(1)
	}

	repoRoot := os.Getenv("MESH_REPO_ROOT")
	if repoRoot == "" {
		repoRoot = "."
	}

	suite, err := LoadSuite(repoRoot)
	if err != nil {
		fmt.Fprintf(os.Stderr, "erro ao carregar subdomainSuite: %v\n", err)
		os.Exit(1)
	}

	if err := ValidateFFCoverage(suite); err != nil {
		fmt.Fprintf(os.Stderr, "erro de coverage das fitness functions: %v\n", err)
		os.Exit(1)
	}

	if !ShouldRun(suite.CIPolicy, changedFiles) {
		fmt.Println("OK: nenhum trigger relevante para subdomínios foi detectado.")
		os.Exit(0)
	}

	fmt.Println("Subdomain suite triggered.")

	rawFindings := RunChecks(suite.Catalog.Subdomains)

	findings, err := MaterializeFindings(suite, rawFindings)
	if err != nil {
		fmt.Fprintf(os.Stderr, "erro ao materializar findings: %v\n", err)
		os.Exit(1)
	}

	currentWave, err := loadCurrentWaveFromEnv()
	if err != nil {
		fmt.Fprintf(os.Stderr, "erro ao carregar wave atual: %v\n", err)
		os.Exit(1)
	}

	now := time.Now()

	blocking, warnings := ApplyPolicy(suite.CIPolicy, findings, currentWave, now)
	PrintReport(suite.CIPolicy, blocking, warnings)

	if len(blocking) > 0 {
		os.Exit(1)
	}
}
