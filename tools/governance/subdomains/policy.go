package main

import (
	"regexp"
	"time"
)

func ShouldRun(policy CIPolicy, changedFiles []string) bool {
	if policy.Execution.Scope == "full-catalog" {
		return true
	}

	if policy.Execution.Scope != "changed-only" {
		return true
	}

	for _, f := range changedFiles {
		for _, trigger := range policy.Triggers {
			re, err := regexp.Compile(trigger.PathRegex)
			if err != nil {
				return true
			}
			if re.MatchString(f) {
				return true
			}
		}
	}
	return false
}

func EnforcementFor(policy CIPolicy, ffID string) string {
	for _, rule := range policy.Rules {
		if rule.FitnessID == ffID {
			return rule.Enforcement
		}
	}
	return policy.DefaultEnforcement
}

func BootstrapApplies(policy CIPolicy, ffID string, currentWave *uint, currentDate time.Time) bool {
	if policy.Bootstrap.Mode != "grace-period" {
		return false
	}

	for _, ex := range policy.Bootstrap.Exceptions {
		if ex.FitnessID != ffID {
			continue
		}

		waveOK := true
		if ex.UntilWave != nil {
			if currentWave == nil {
				waveOK = false
			} else {
				waveOK = *currentWave <= *ex.UntilWave
			}
		}

		dateOK := true
		if ex.UntilDate != "" {
			t, err := time.Parse("2006-01-02", ex.UntilDate)
			if err != nil {
				dateOK = false
			} else {
				dateOK = currentDate.Before(t) || currentDate.Equal(t)
			}
		}

		if waveOK && dateOK {
			return true
		}
	}

	return false
}
