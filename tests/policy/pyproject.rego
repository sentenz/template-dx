package tests.policy

import rego.v1

is_pyproject if {
	input.tool.poetry # Specific to Poetry, adjust for Flit/Hatch if needed
}

# METADATA
# title: Poetry dependency version pinning
# description: Ensure Poetry dependencies are pinned to a specific version
# custom:
#   severity: medium
# entrypoint: true
deny_poetry_deps contains msg if {
	is_pyproject

	dependencies := input.tool.poetry.dependencies
	some name, version in dependencies

	not is_strict_semver(version)
	msg := sprintf(
		"Dependency '%s' uses ranged version specifier '%s'. Pin to the exact semantic versioning tag like 'v1.2.3'.",
		[name, version],
	)
}

# METADATA
# title: Poetry dev dependency version pinning
# description: Ensure Poetry dev dependencies are pinned to a specific version
# custom:
#   severity: medium
# entrypoint: true
deny_poetry_dev_deps contains msg if {
	is_pyproject

	dependencies := input.poetry.group.dev.dependencies
	some name, version in dependencies

	not is_strict_semver(version)
	msg := sprintf(
		"Dev Dependency '%s' uses ranged version specifier '%s'. Pin to the exact semantic versioning tag like 'v1.2.3'.",
		[name, version],
	)
}

is_strict_semver(v) if {
	is_string(v)
	regex.match(`^v?\d+\.\d+\.\d+$`, v)
}
