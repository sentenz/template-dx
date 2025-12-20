package tests.policy

import rego.v1

is_dockerfile if {
	input[0].Cmd # Dockerfile input is an array of objects with a "Cmd" key
}

# METADATA
# title: Dockerfile base image pinning
# description: Ensure Dockerfile base image is pinned by digest
# custom:
#   severity: medium
# entrypoint: true
deny_dockerfile contains msg if {
	is_dockerfile

	some cmd in input
	cmd.Cmd == "from"
	image := cmd.Value[0]

	not contains(image, "@sha256:")
	msg := sprintf("Container base image '%s' must be pinned by the image digest '@sha256:94a0...ea1a'.", [image])
}
