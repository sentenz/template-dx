# SPDX-License-Identifier: Apache-2.0

# Load Dotenv Files

DOTENV_FILES := $(filter-out %.enc,$(wildcard .env .env.*))
ifneq ($(strip $(DOTENV_FILES)),)
	include $(DOTENV_FILES)
	export
endif

# Define Variables

IS_WINDOWS := $(findstring Windows_NT,$(OS))
POWERSHELL := powershell

ifeq ($(IS_WINDOWS),Windows_NT)
	PIP_VENV := .venv/Scripts
else
	PIP_VENV := .venv/bin
endif

SHELL := bash
.SHELLFLAGS := -euo pipefail -c
.ONESHELL:

# ─── General ─────────────────────────────────────────────────────────────────────────────────────

default: help

# NOTE Targets MUST have a leading comment line starting with `##` to be included in the list. See the targets below for examples.
#
## Display help message with a list of available tasks and their descriptions
help:
ifeq ($(IS_WINDOWS),Windows_NT)
	@echo "TODO Implement Windows help script"
else
	@awk 'BEGIN {printf "Tasks\n\tA collection of tasks used in the current project.\n\n"}'
	@awk 'BEGIN {printf "Usage\n\tmake $(shell tput -Txterm setaf 6)<task>$(shell tput -Txterm sgr0)\n\n"}' $(MAKEFILE_LIST)
	@awk '/^##/{c=substr($$0,3);next}c&&/^[[:alpha:]][[:alnum:]_-]+:/{print "$(shell tput -Txterm setaf 6)\t" substr($$1,1,index($$1,":")) "$(shell tput -Txterm sgr0)",c}1{c=0}' $(MAKEFILE_LIST) | column -s: -t
endif
.PHONY: help

# ─── Setup & Teardown ────────────────────────────────────────────────────────────────────────────

# NOTE May require elevated privileges (`sudo`) to install dependencies on the host system.
#
## Initialize a software development workspace with prerequisites
bootstrap:
ifeq ($(IS_WINDOWS),Windows_NT)
	$(POWERSHELL) -File ./scripts/Bootstrap.ps1
else
	@cd ./scripts/ && bash ./bootstrap.sh
endif
.PHONY: bootstrap

# NOTE May require elevated privileges (`sudo`) to install dependencies on the host system.
#
## Install and configure all dependencies essential for development
setup:
ifeq ($(IS_WINDOWS),Windows_NT)
	@echo "TODO Implement Windows setup task"
else
	@cd ./scripts/ && bash ./setup.sh
endif
.PHONY: setup

# NOTE May require elevated privileges (`sudo`) to remove dependencies from the host system.
#
## Remove development artifacts and restore the host to its pre-setup state
teardown:
ifeq ($(IS_WINDOWS),Windows_NT)
	@echo "TODO Implement Windows teardown task"
else
	@cd ./scripts/ && bash ./teardown.sh
endif
.PHONY: teardown

# TODO Migrate to Setup.ps1
## Install the PSScriptAnalyzer PowerShell module on a Windows system
install-pwsh-analyzer:
ifeq ($(IS_WINDOWS),Windows_NT)
	$(POWERSHELL) -Command "Install-Module -Name PSScriptAnalyzer -Scope CurrentUser -Force -AllowClobber"
else
	@echo "TODO Implement Linux install-pwsh-analyzer task"
endif
.PHONY: install-pwsh-analyzer

# TODO Migrate to Setup.ps1
## Use PSScriptAnalyzer to lint PowerShell scripts and modules on Windows
lint-pwsh-analyze:
ifeq ($(IS_WINDOWS),Windows_NT)
	$(POWERSHELL) -Command "Invoke-ScriptAnalyzer -Path $(@D) -Recurse -Severity Warning,Error | Out-String"
else
	@echo "TODO Implement Linux lint-pwsh-analyze task"
endif
.PHONY: lint-pwsh-analyze

# ─── Git Hooks Manager ───────────────────────────────────────────────────────────────────────────

## Initialize Lefthook Git hooks in the local repository
githooks-lefthook-initialize:
	lefthook install --force
.PHONY: githooks-lefthook-initialize

## Deinitialize Lefthook Git hooks from the local repository
githooks-lefthook-deinitialize:
	lefthook uninstall
.PHONY: githooks-lefthook-deinitialize

# ─── Skills Manager ──────────────────────────────────────────────────────────────────────────────

## Provision new Agent Skills into the project environment
agent-skills-add:
	DISABLE_TELEMETRY=1 \
	npx skills@1.5.15 add sentenz/skills
.PHONY: agent-skills-add

## Synchronize and update existing Agent Skills in the project environment
agent-skills-update:
	DISABLE_TELEMETRY=1 \
	npx skills@1.5.15 update sentenz/skills
.PHONY: agent-skills-update

## Restore Agent Skills in the project environment to a previous state
agent-skills-restore:
	DISABLE_TELEMETRY=1 \
	npx skills@1.5.15 experimental_install
.PHONY: agent-skills-restore

# ─── Dependency Manager ──────────────────────────────────────────────────────────────────────────

DEPENDENCY_RENOVATE_IMAGE ?= docker.io/renovate/renovate:44.103.6@sha256:9c07736ffc4f85e26310db577696cad7dd9ca3d359bea6d0eadbb3d399caa38b
DEPENDENCY_RENOVATE_ALIAS := docker run --rm -v "${PWD}:/workspace" -w /workspace -e LOG_LEVEL=debug -e RENOVATE_REPOSITORIES -e RENOVATE_TOKEN=$(RENOVATE_TOKEN) "$(DEPENDENCY_RENOVATE_IMAGE)"

## Update project dependencies locally using Renovate and generate a report
dependency-renovate-update:
	@mkdir -p logs/dependency

	$(DEPENDENCY_RENOVATE_ALIAS) renovate --platform=local --repository-cache=reset > logs/dependency/renovate.log 2>&1
.PHONY: dependency-renovate-update

# ─── Secrets Manager ─────────────────────────────────────────────────────────────────────────────

SECRETS_SOPS_IMAGE ?= ghcr.io/getsops/sops:v3.13.3@sha256:857f5a151ac0b2bfc55c1e4e5581d66fb8e268e4d106b38e74191f3bac9d58ea
SECRETS_SOPS_ALIAS ?= docker run --rm -v "${PWD}:/workspace" -v "$${HOME}/.gnupg:/root/.gnupg" -w /workspace "$(SECRETS_SOPS_IMAGE)"
SECRETS_SOPS_UID ?= sops-$(notdir $(CURDIR))

# Usage: make secrets-gpg-generate SECRETS_SOPS_UID=<uid>
#
## Generate a new GPG key pair for SOPS with the specified UID
secrets-gpg-generate:
	@gpg --batch --quiet --passphrase '' --quick-generate-key "$(SECRETS_SOPS_UID)" ed25519 cert,sign 0
	@NEW_FPR="$$(gpg --list-keys --with-colons "$(SECRETS_SOPS_UID)" | awk -F: '/^fpr:/ {print $$10; exit}')"
	@gpg --batch --quiet --passphrase '' --quick-add-key "$${NEW_FPR}" cv25519 encrypt 0
.PHONY: secrets-gpg-generate

# Usage: make secrets-gpg-export SECRETS_SOPS_UID=<uid>
#
## Export the GPG key pair for SOPS with the specified UID to ASCII files
secrets-gpg-export:
	@if [ -z "$(SECRETS_SOPS_UID)" ]; then \
		echo "usage: make secrets-gpg-export SECRETS_SOPS_UID=<uid>" >&2; \
		exit 1; \
	fi

	@gpg --armor --export "$(SECRETS_SOPS_UID)" > "$(SECRETS_SOPS_UID)-public.asc"
	@gpg --armor --export-secret-keys "$(SECRETS_SOPS_UID)" > "$(SECRETS_SOPS_UID)-private.asc"
.PHONY: secrets-gpg-export

# Usage: make secrets-gpg-import [SECRETS_SOPS_UID=<uid>] <key-files>
#
## Import GPG keys from specified files and if provided set ultimate trust for the SOPS UID
secrets-gpg-import:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make secrets-gpg-import <files>" >&2; \
		exit 1; \
	fi

	# Import keys from specified files
	@for file in $(filter-out $@,$(MAKECMDGOALS)); do \
		if [ -f "$$file" ]; then \
			gpg --import "$$file"; \
		fi; \
	done

	# Set ultimate trust for the SECRETS_SOPS_UID
	@if [ "$(origin SECRETS_SOPS_UID)" = "command line" ] && [ -n "$(SECRETS_SOPS_UID)" ]; then \
		FPR="$$( { gpg --list-keys --with-colons "$(SECRETS_SOPS_UID)" 2>/dev/null || true; } | awk -F: '/^fpr:/ {print $$10; exit}')"; \
		if [ -n "$${FPR}" ]; then \
			echo "$${FPR}:6:" | gpg --import-ownertrust; \
		fi; \
	fi
.PHONY: secrets-gpg-import

# Usage: make secrets-gpg-remove SECRETS_SOPS_UID=<uid>
#
## Remove GPG keys for SOPS with the specified UID (interactive)
secrets-gpg-remove:
	@if ! gpg --list-keys "$(SECRETS_SOPS_UID)" >/dev/null 2>&1; then
		echo "warning: no key found for '$(SECRETS_SOPS_UID)'" >&2
		exit 0
	fi

	# Delete private key first, then public key
	@gpg --yes --delete-secret-keys "$(SECRETS_SOPS_UID)"
	@gpg --yes --delete-keys "$(SECRETS_SOPS_UID)"
.PHONY: secrets-gpg-remove

# Usage: make secrets-gpg-show [SECRETS_SOPS_UID=<uid>]
#
## Show GPG public key information for SOPS UID or list all keys if UID is not set
secrets-gpg-show:
	@if [ "$(origin SECRETS_SOPS_UID)" != "command line" ]; then \
		gpg --list-keys --keyid-format long; \
		exit 0; \
	fi

	@FPR="$$( { gpg --list-keys --with-colons "$(SECRETS_SOPS_UID)" 2>/dev/null || true; } | awk -F: '/^fpr:/ {print $$10; exit}')"; \
	if [ -z "$${FPR}" ]; then \
		echo "error: no fingerprint found for UID '$(SECRETS_SOPS_UID)'" >&2; \
		exit 1; \
	fi; \
	echo -e "UID: $(SECRETS_SOPS_UID)\nFingerprint: $${FPR}"
.PHONY: secrets-gpg-show

# Usage: make secrets-sops-encrypt <files>
#
## Encrypt specified files using SOPS with GPG keys, writing output to <file>.enc
secrets-sops-encrypt:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make secrets-sops-encrypt <files>" >&2; \
		exit 1; \
	fi

	@for file in $(filter-out $@,$(MAKECMDGOALS)); do \
		if [ -f "$$file" ]; then \
			$(SECRETS_SOPS_ALIAS) encrypt --output "$$file.enc" "$$file"; \
		else \
			echo "file not found: $$file" >&2; \
		fi; \
	done
.PHONY: secrets-sops-encrypt

# Usage: make secrets-sops-decrypt <files>
#
## Decrypt specified SOPS-encrypted files (expects <file>.enc), writing output to <file>
secrets-sops-decrypt:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make secrets-sops-decrypt <files>" >&2; \
		exit 1; \
	fi

	@for file in $(filter-out $@,$(MAKECMDGOALS)); do \
		case "$$file" in \
			*.enc) \
				$(SECRETS_SOPS_ALIAS) decrypt --filename-override "$${file%.enc}" --output "$${file%.enc}" "$$file"; \
				;;
			*) \
				$(SECRETS_SOPS_ALIAS) decrypt --in-place "$$file"; \
				;;
		esac; \
	done
.PHONY: secrets-sops-decrypt

# Usage: make secrets-sops-view <file>
#
## View decrypted contents of a SOPS-encrypted file using GPG keys
secrets-sops-view:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make secrets-sops-view <file>" >&2; \
		exit 1; \
	fi

	$(SECRETS_SOPS_ALIAS) decrypt "$(filter-out $@,$(MAKECMDGOALS))"
.PHONY: secrets-sops-view

# ─── Policy Manager ──────────────────────────────────────────────────────────────────────────────

POLICY_CONFTEST_IMAGE ?= docker.io/openpolicyagent/conftest:v0.70.0@sha256:1d5b939a6310fbc18a66165f436f763c57a568822bfe449cb0b9d89a70a0334b
POLICY_CONFTEST_ALIAS := docker run --rm -v "${PWD}:/workspace" -w /workspace "$(POLICY_CONFTEST_IMAGE)"

# Usage: make policy-conftest-test <filepath>
#
## Run Conftest container in REPL (Read-Eval-Print-Loop) to evaluate policies against input data and generate a report
policy-conftest-test:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make policy-conftest-test <filepath>"; \
		exit 1; \
	fi

	@mkdir -p logs/policy

	$(POLICY_CONFTEST_ALIAS) test "$(filter-out $@,$(MAKECMDGOALS))" > logs/policy/conftest-report.json 2>&1
.PHONY: policy-conftest-test

POLICY_REGAL_IMAGE ?= ghcr.io/open-policy-agent/regal:0.42.0@sha256:07984036043f772a1f921bd0ad9045b8bd9dc58460a1d76f476c458dc8a98b16
POLICY_REGAL_ALIAS := docker run --rm -v "${PWD}:/workspace" -w /workspace "$(POLICY_REGAL_IMAGE)"

# Usage: make policy-regal-lint <filepath>
#
## Lint Rego policies using Regal and generate a report
policy-regal-lint:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make policy-regal-lint <filepath>"; \
		exit 1; \
	fi

	@mkdir -p logs/policy

	$(POLICY_REGAL_ALIAS) lint "$(filter-out $@,$(MAKECMDGOALS))" --format json > logs/policy/regal.json 2>&1
.PHONY: policy-regal-lint

# ─── Static Analysis ─────────────────────────────────────────────────────────────────────────────

LINT_MARKDOWNLINT_IMAGE ?= davidanson/markdownlint-cli2:0.22.1@sha256:0ed9a5f4c77ef447da2a2ac6e67caf74b214a7f80288819565e8b7d2ac148fe5
LINT_MARKDOWNLINT_FILES ?= "**/*.md"

## Lint Markdown files using markdownlint and generate a report
lint-markdown:
	@mkdir -p logs/lint

	docker run --rm -v "${PWD}:/workspace" -w /workspace "$(LINT_MARKDOWNLINT_IMAGE)" $(LINT_MARKDOWNLINT_FILES) > logs/lint/markdownlint 2>&1
.PHONY: lint-markdown

# ─── SAST Manager ────────────────────────────────────────────────────────────────────────────────

SAST_SEMGREP_IMAGE ?= semgrep/semgrep:1.177.0@sha256:acaac22ffc7b7cc5926de0751b223bce0b2491c33d18422fa72f632c78d81198
SAST_SEMGREP_ALIAS := docker run --rm -v "${PWD}:/workspace" -w /workspace "$(SAST_SEMGREP_IMAGE)"
SAST_SEMGREP_FILES ?= .
SAST_SEMGREP_FILTER = $(if $(strip $(SAST_SEMGREP_FILES)),$(SAST_SEMGREP_FILES),.)

## Scan source code for security issues using Semgrep and generate a report
sast-semgrep-scan:
	@mkdir -p logs/sast

	$(SAST_SEMGREP_ALIAS) semgrep scan --config auto --error --json --output logs/sast/semgrep.json $(SAST_SEMGREP_FILTER) 2> logs/sast/semgrep.log
.PHONY: sast-semgrep-scan

SAST_TRIVY_IMAGE ?= aquasec/trivy:0.74.0@sha256:62b1e65e8869bc4b4c6aa4fa2b21595256c7c2f6018a9d9ad61caf87187c1969
SAST_TRIVY_ALIAS := docker run --rm -v "${PWD}:/workspace" -w /workspace "$(SAST_TRIVY_IMAGE)"
SAST_TRIVY_FILES ?= .

## Scan Infrastructure-as-Code (IaC) files for misconfigurations using Trivy and generate a report
sast-trivy-misconfig:
	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) config --output logs/sast/trivy-misconfig.json $(SAST_TRIVY_FILES) 2>&1
.PHONY: sast-trivy-misconfig

## Scan local filesystem for vulnerabilities and misconfigurations using Trivy
sast-trivy-fs:
	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) filesystem --output logs/sast/trivy-filesystem.json /workspace 2>&1
.PHONY: sast-trivy-fs

# Usage: make sast-trivy-image <image_name>
#
## Scan a container image for vulnerabilities using Trivy
sast-trivy-image:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-image <image_name>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "${PWD}:/workspace" -w /workspace "$(SAST_TRIVY_IMAGE)" image --output logs/sast/trivy-image.json "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-image

# Usage: make sast-trivy-image-license <image_name>
#
## Scan a container image for license compliance using Trivy
sast-trivy-image-license:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-image-license <image_name>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) image --scanners license --format table --output logs/sast/trivy-image-license.txt "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-image-license

# Usage: make sast-trivy-repository <repo_url>
#
## Scan a remote repository for vulnerabilities using Trivy
sast-trivy-repository:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-repository <repo_url>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) repository --output logs/sast/trivy-repository.json "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-repository

# Usage: make sast-trivy-rootfs <path>
#
## Scan a rootfs e.g. `/` for vulnerabilities using Trivy
sast-trivy-rootfs:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-rootfs <path>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) rootfs --output logs/sast/trivy-rootfs.json "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-rootfs

# Usage: make sast-trivy-sbom-scan <sbom_path>
#
## Scan SBOM for vulnerabilities using Trivy
sast-trivy-sbom-scan:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-sbom-scan <sbom_path>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) sbom --output logs/sast/trivy-sbom.json "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-sbom-scan

# Usage: make sast-trivy-sbom-cyclonedx-image <image_name>
#
## Generate SBOM in CycloneDX format for a container image using Trivy
sast-trivy-sbom-cyclonedx-image:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-sbom-cyclonedx-image <image_name>"; \
		exit 1; \
	fi

	@mkdir -p logs/sbom

	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "${PWD}:/workspace" -w /workspace "$(SAST_TRIVY_IMAGE)" image --format cyclonedx --output logs/sbom/sbom-image.cdx.json "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-sbom-cyclonedx-image

# Usage: make sast-trivy-sbom-cyclonedx-fs <path>
#
## Generate SBOM in CycloneDX format for a file system using Trivy
sast-trivy-sbom-cyclonedx-fs:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-sbom-cyclonedx-fs <path>"; \
		exit 1; \
	fi

	@mkdir -p logs/sbom

	$(SAST_TRIVY_ALIAS) filesystem --format cyclonedx --output logs/sbom/sbom-fs.cdx.json "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-sbom-cyclonedx-fs

# Usage: make sast-trivy-sbom-license <sbom_path>
#
## Scan SBOM for license compliance using Trivy
sast-trivy-sbom-license:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-sbom-license <sbom_path>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) sbom --scanners license --format table --output logs/sast/trivy-sbom-license.txt "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-sbom-license

# Usage: make sast-trivy-sbom-attestation <intoto_sbom_path>
#
## Scan the verified SBOM attestation using Trivy
sast-trivy-sbom-attestation:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-sbom-attestation <intoto_sbom_path>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) sbom "$(filter-out $@,$(MAKECMDGOALS))"
.PHONY: sast-trivy-sbom-attestation

# Usage: make sast-trivy-vm <vm_image_path>
#
## [EXPERIMENTAL] Scan a virtual machine image using Trivy
sast-trivy-vm:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-trivy-vm <vm_image_path>"; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_TRIVY_ALIAS) vm --output logs/sast/trivy-vm.json "$(filter-out $@,$(MAKECMDGOALS))" 2>&1
.PHONY: sast-trivy-vm

# Usage: make sast-trivy-kubernetes [target]
#
## [EXPERIMENTAL] Scan kubernetes cluster using Trivy (default `cluster`)
sast-trivy-kubernetes:
	@echo "Note: This requires KUBECONFIG to be mounted or available to the container. Assuming ~/.kube/config is mounted to /root/.kube/config"

	@mkdir -p logs/sast

	docker run --rm -v "${HOME}/.kube/config:/root/.kube/config" -v "${PWD}:/workspace" -w /workspace "$(SAST_TRIVY_IMAGE)" kubernetes --output logs/sast/trivy-kubernetes.json $(if $(filter-out $@,$(MAKECMDGOALS)),$(filter-out $@,$(MAKECMDGOALS)),cluster) 2>&1
.PHONY: sast-trivy-kubernetes

SAST_TRIVY_KBOM_FILE ?= logs/sbom/kbom.cdx.json

## Generate a CycloneDX KBOM (Kubernetes Bill of Materials) from the selected Kubernetes cluster
sast-trivy-kbom:
	@test -s "$(K8S_KUBECONFIG)" || { \
		echo "error: kubeconfig not found: $(K8S_KUBECONFIG)" >&2; \
		exit 1; \
	}

	@mkdir -p "$(dir $(SAST_TRIVY_KBOM_FILE))"

	docker run --rm --user root --network host --volume /var/run/docker.sock:/var/run/docker.sock --volume "$(CURDIR):/workspace" --workdir /workspace \
		"$(SAST_TRIVY_IMAGE)" k8s --kubeconfig "$(K8S_KUBECONFIG)" --format cyclonedx --output "/workspace/$(SAST_TRIVY_KBOM_FILE)"
.PHONY: sast-trivy-kbom

SAST_IMAGE_GITLEAKS ?= ghcr.io/gitleaks/gitleaks:v8.30.1@sha256:c00b6bd0aeb3071cbcb79009cb16a60dd9e0a7c60e2be9ab65d25e6bc8abbb7f

## Scan git repository history for leaked secrets using Gitleaks and generate a report
sast-gitleaks-detect:
	@mkdir -p logs/sast

	docker run --rm -v "${PWD}:/workspace" -w /workspace "$(SAST_IMAGE_GITLEAKS)" detect --redact --source /workspace --report-format json --report-path logs/sast/gitleaks-detect.json 2>&1
.PHONY: sast-gitleaks-detect

## Scan staged git changes for leaked secrets using Gitleaks and generate a report
sast-gitleaks-staged:
	@mkdir -p logs/sast

	docker run --rm -v "${PWD}:/workspace" -w /workspace "$(SAST_IMAGE_GITLEAKS)" protect --redact --staged --source /workspace --report-format json --report-path logs/sast/gitleaks-protect.json 2>&1
.PHONY: sast-gitleaks-staged

SAST_IMAGE_TRUFFLEHOG ?= trufflesecurity/trufflehog:3.97.5@sha256:1cec88f18ca39e26e04e61fe9d886c9c4e5f2fc0ba4f2ed185cac0722bd8a076

## Scan local filesystem for leaked secrets using TruffleHog and generate a report
sast-trufflehog-fs:
	@mkdir -p logs/sast

	docker run --rm -v "${PWD}:/workspace" -w /workspace "$(SAST_IMAGE_TRUFFLEHOG)" filesystem . --no-update --json > logs/sast/trufflehog-filesystem.json 2> logs/sast/trufflehog-filesystem.log
.PHONY: sast-trufflehog-fs

## Scan git repository history for leaked secrets using TruffleHog and generate a report
sast-trufflehog-git:
	@mkdir -p logs/sast

	docker run --rm -v "${PWD}:/workspace" -w /workspace "$(SAST_IMAGE_TRUFFLEHOG)" git file:///workspace --no-update --json > logs/sast/trufflehog-git.json 2> logs/sast/trufflehog-git.log
.PHONY: sast-trufflehog-git

# ─── Supply Chain Security ───────────────────────────────────────────────────────────────────────

SAST_COSIGN_IMAGE ?= cgr.dev/chainguard/cosign:3.0.0@sha256:b6bc266358e9368be1b3d01fca889b78d5ad5a47832986e14640c34a237ef638
SAST_COSIGN_ALIAS := docker run --rm -v "${PWD}:/workspace" -w /workspace "$(SAST_COSIGN_IMAGE)"

## Generate Cosign key pair
sast-cosign-generate-key-pair:
	$(SAST_COSIGN_ALIAS) generate-key-pair
.PHONY: sast-cosign-generate-key-pair

# Usage: make sast-cosign-attest <image_name>
#
## Attest an image with the generated SBOM using Cosign
sast-cosign-attest:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-cosign-attest <image_name>"; \
		exit 1; \
	fi
	@if [ ! -f cosign.key ]; then \
		echo "Error: cosign.key not found. Run 'make sast-cosign-generate-key-pair' first."; \
		exit 1; \
	fi
	@if [ ! -f logs/sbom/sbom.cdx.json ]; then \
		echo "Error: logs/sbom/sbom.cdx.json not found. Run 'make sast-trivy-sbom-cyclonedx <image_name>' first."; \
		exit 1; \
	fi

	$(SAST_COSIGN_ALIAS) attest --key cosign.key --type cyclonedx --predicate logs/sbom/sbom.cdx.json "$(filter-out $@,$(MAKECMDGOALS))"
.PHONY: sast-cosign-attest

# Usage: make sast-cosign-verify <image_name>
#
## Verify SBOM attestation for an image using Cosign
sast-cosign-verify:
	@if [ -z "$(filter-out $@,$(MAKECMDGOALS))" ]; then \
		echo "usage: make sast-cosign-verify <image_name>"; \
		exit 1; \
	fi
	@if [ ! -f cosign.pub ]; then \
		echo "Error: cosign.pub not found. Run 'make sast-cosign-generate-key-pair' first."; \
		exit 1; \
	fi

	@mkdir -p logs/sast

	$(SAST_COSIGN_ALIAS) verify-attestation --key cosign.pub --type cyclonedx "$(filter-out $@,$(MAKECMDGOALS))" > logs/sbom/sbom.cdx.intoto.jsonl 2> logs/sast/cosign-verify.log
.PHONY: sast-cosign-verify

# ─── Static Site Generator (SSG) ─────────────────────────────────────────────────────────────────

### Setup documentation pages with MkDocs
pages-mkdocs-setup:
	@python3 -m venv .venv && . $(PIP_VENV)/activate && cd ./scripts/ && bash ./setup_pages.sh
.PHONY: pages-mkdocs-setup

## Build documentation pages with MkDocs
pages-mkdocs-build:
	@. $(PIP_VENV)/activate; mkdocs build
.PHONY: pages-mkdocs-build

## Serve documentation pages locally with MkDocs
pages-mkdocs-serve:
	@. $(PIP_VENV)/activate; mkdocs serve --dev-addr 127.0.0.1:8000 --livereload
.PHONY: pages-mkdocs-serve

# ─── Documentation Generators ────────────────────────────────────────────────────────────────────

## Build content using Static Site Generator (SSG) for Doxygen documentation
pages-doxygen-build:
	@doxygen Doxyfile
.PHONY: pages-doxygen-build

## Serve the build Static Site Generator (SSG) for Doxygen documentation on a local web server
pages-doxygen-serve:
	@OUT="$$(awk -F'= *' '/^OUTPUT_DIRECTORY/ {gsub(/^[ \t]+|[ \t]+$$/,"",$$2); print $$2; exit}' Doxyfile 2>/dev/null)"; \
	HTML="$$(awk -F'= *' '/^HTML_OUTPUT/ {gsub(/^[ \t]+|[ \t]+$$/,"",$$2); print $$2; exit}' Doxyfile 2>/dev/null)"; \
	OUTDIR="$${OUT:+$${OUT}/}$${HTML:-html}"; \
	if [ ! -d "$$OUTDIR" ]; then echo "error: generated docs not found in $$OUTDIR; run 'make pages-doxygen-build' first" >&2; exit 1; fi; \
	echo "Serving $$OUTDIR at http://localhost:8000"; \
	python3 -m http.server --directory "$$OUTDIR" 8000
.PHONY: pages-doxygen-serve

# ─── Container Manager ───────────────────────────────────────────────────────────────────────────

CONTAINER_DOCKER_IMAGE ?= $(notdir $(shell git rev-parse --show-toplevel 2>/dev/null))
CONTAINER_DOCKER_TAG ?= $(or $(shell git tag --sort=-creatordate | head -n 1),latest)
CONTAINER_DOCKER_CONTEXT ?= .
CONTAINER_DOCKER_FILE ?= ./Dockerfile

# Usage: make container-docker-build [CONTAINER_DOCKER_IMAGE=<name>] [CONTAINER_DOCKER_TAG=<tag>] [CONTAINER_DOCKER_FILE=<file>] [CONTAINER_DOCKER_CONTEXT=<context>]
#
## Build the Docker container image with the specified name, tag, and context
container-docker-build:
	docker build -f "$(CONTAINER_DOCKER_FILE)" -t "$(CONTAINER_DOCKER_IMAGE):$(CONTAINER_DOCKER_TAG)" "$(CONTAINER_DOCKER_CONTEXT)"
.PHONY: container-docker-build

# Usage: make container-docker-run [CONTAINER_DOCKER_IMAGE=<name>] [CONTAINER_DOCKER_TAG=<tag>]
#
## Run the Docker container image with the specified name and tag
container-docker-run:
	docker run --rm "$(CONTAINER_DOCKER_IMAGE):$(CONTAINER_DOCKER_TAG)"
.PHONY: container-docker-run

## Teardown Docker containers and remove all unused images, containers, volumes, and networks
container-docker-teardown:
	# Display Docker disk usage statistics (images, containers, networks, volumes with links and sizes)
	@docker system df -v
	# Remove all unused Docker objects (images, containers, networks)
	@docker system prune -f -a --filter "until=24h"
	# Remove all Docker volumes (unused named `LINKS = 0`, anonymous)
	@docker volume prune -f -a --filter "label!=keep=true"
.PHONY: container-docker-teardown

# ─── Certificate Manager ─────────────────────────────────────────────────────────────────────────

CERT_HOSTNAME ?=
CERT_DIR ?= ./certs
CERT_DAYS ?= 365

# Usage: make cert-certificate-generate CERT_HOSTNAME=<hostname-or-url> [CERT_DIR=<directory>] [CERT_DAYS=<days>]
#
## Generate a self-signed TLS certificate for a local hostname or URL
cert-certificate-generate:
	@raw_hostname="$(strip $(CERT_HOSTNAME))"
	if [[ -z "$$raw_hostname" ]]; then
		echo "usage: make cert-certificate-generate CERT_HOSTNAME=<hostname-or-url> [CERT_DIR=<directory>] [CERT_DAYS=<days>]" >&2
		exit 1
	fi

	hostname="$$raw_hostname"
	hostname="$${hostname#*://}"
	hostname="$${hostname%%/*}"
	hostname="$${hostname%%\?*}"
	hostname="$${hostname%%\#*}"
	hostname="$${hostname%%:*}"

	if (( $${#hostname} > 253 )) || [[ ! "$$hostname" =~ ^[A-Za-z0-9]([A-Za-z0-9.-]*[A-Za-z0-9])?$$ ]] || [[ "$$hostname" == *..* ]]; then
		echo "error: invalid hostname derived from '$(CERT_HOSTNAME)': $$hostname" >&2
		exit 1
	fi
	if [[ ! "$(CERT_DAYS)" =~ ^[1-9][0-9]*$$ ]]; then
		echo "error: CERT_DAYS must be a positive integer" >&2
		exit 1
	fi
	if ! command -v openssl >/dev/null 2>&1; then
		echo "error: openssl is required to generate a self-signed certificate" >&2
		exit 1
	fi

	output_dir="$(CERT_DIR)"
	certificate_path="$$output_dir/$$hostname+1.pem"
	private_key_path="$$output_dir/$$hostname+1-key.pem"
	mkdir -p "$$output_dir"

	umask 077
	openssl req \
		-x509 \
		-nodes \
		-newkey rsa:2048 \
		-sha256 \
		-days "$(CERT_DAYS)" \
		-keyout "$$private_key_path" \
		-out "$$certificate_path" \
		-subj "/CN=$$hostname" \
		-addext "subjectAltName=DNS:$$hostname"
	chmod 0644 "$$certificate_path"

	printf 'Generated self-signed certificate for %s\n  certificate: %s\n  private key: %s\n' \
		"$$hostname" "$$certificate_path" "$$private_key_path"
.PHONY: cert-certificate-generate
