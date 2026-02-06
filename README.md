# Template DX

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A comprehensive Development Experience (DX) template repository that provides a structured framework and essential tools to streamline the software development process.

- [1. Details](#1-details)
  - [1.1. Prerequisites](#11-prerequisites)
- [2. Contribute](#2-contribute)
  - [2.1. AI Agents](#21-ai-agents)
  - [2.2. Skills Manager](#22-skills-manager)
    - [2.2.1. Skills CLI](#221-skills-cli)
  - [2.3. Task Runner](#23-task-runner)
    - [2.3.1. Make](#231-make)
  - [2.4. Bootstrap](#24-bootstrap)
    - [2.4.1. Scripts](#241-scripts)
  - [2.5. Dev Containers](#25-dev-containers)
  - [2.6. Release Manager](#26-release-manager)
    - [2.6.1. Semantic-Release](#261-semantic-release)
  - [2.7. Update Manager](#27-update-manager)
    - [2.7.1. Renovate](#271-renovate)
    - [2.7.2. Dependabot](#272-dependabot)
  - [2.8. Secrets Manager](#28-secrets-manager)
    - [2.8.1. SOPS](#281-sops)
  - [2.9. Container Manager](#29-container-manager)
    - [2.9.1. Docker](#291-docker)
  - [2.10. Policy Manager](#210-policy-manager)
    - [2.10.1. Conftest](#2101-conftest)
  - [2.11. Supply Chain Manager](#211-supply-chain-manager)
    - [2.11.1. Trivy](#2111-trivy)
- [3. Troubleshoot](#3-troubleshoot)
  - [3.1. TODO](#31-todo)
- [4. References](#4-references)

## 1. Details

### 1.1. Prerequisites

- [Git](https://git-scm.com/)
  > Distributed version control system for tracking source code changes.

- [Git LFS](https://git-lfs.com/)
  > Git extension for managing large files (assets, binaries) outside normal Git history.

- [Make](https://www.gnu.org/software/make/)
  > Task automation tool to manage build processes and workflows.

- [Docker](https://www.docker.com/)
  > Containerization tool to run applications in isolated container environments and execute container-based tasks.

## 2. Contribute

Contribution guidelines and project management tools.

### 2.1. AI Agents

AI Agents are automated tools that assist in various development tasks such as code generation, testing, and documentation.

1. Insights and Details

    - [AGENTS.md](AGENTS.md)
      > Instructions for AI coding agents working with the project.

    - [.agents/skills/](.agents/skills/)
      > Directory containing AI agent skill definitions and configurations.

2. Usage and Instructions

    - Implicit Invocation
      > AI Agents can be implicitly invoked based on file paths, programming languages, or specific keywords in user prompts.

      ```plaintext
      .agents/skills/<skill-name>/SKILL.md
      ```

    - Explicit Invocation
      > AI Agents can be explicitly invoked by specifying the skill name in user prompts.

      ```plaintext
      @agent <skill-name> <task-description>
      ```

### 2.2. Skills Manager

#### 2.2.1. Skills CLI

[Skills CLI](https://skills.sh/) is a command-line tool for managing AI agent skills in development projects.

1. Insights and Details

    - [Sentenz Skills](https://github.com/sentenz/skills)
      > Reusable AI agent skills for various development tasks.

2. Usage and Instructions

    - Tasks

      ```bash
      make skills-add
      ```

      ```bash
      make skills-update
      ```

### 2.3. Task Runner

#### 2.3.1. Make

[Make](https://www.gnu.org/software/make/) is a automation tool that defines and manages tasks to streamline development workflows.

1. Insights and Details

    - [Makefile](Makefile)
      > Makefile defining tasks for building, testing, and managing the project.

2. Usage and Instructions

    - Tasks

      ```bash
      make help
      ```

      > [!NOTE]
      > - Each task description must begin with `##` to be included in the task list.

      ```plaintext
      $ make help

      Tasks
              A collection of tasks used in the current project.

      Usage
              make <task>

              bootstrap         Initialize a software development workspace with requisites
              setup             Install and configure all dependencies essential for development
              teardown          Remove development artifacts and restore the host to its pre-setup state
      ```

### 2.4. Bootstrap

#### 2.4.1. Scripts

1. Insights and Details

    - [scripts/](scripts/README.md)
      > Provides scripts to bootstrap, setup, and teardown a software development workspace with requisites.

2. Usage and Instructions

    - Tasks

      ```bash
      make bootstrap
      ```

      ```bash
      make setup
      ```

      ```bash
      make teardown
      ```

### 2.5. Dev Containers

1. Insights and Details

    - [.devcontainer/](.devcontainer/README.md)
      > Provides Dev Containers as a consistent development environment using Docker containers.

2. Usage and Instructions

    - Tasks

      ```bash
      # TODO
      # make devcontainer-go
      # make devcontainer-cpp
      # make devcontainer-python
      ```

### 2.6. Release Manager

#### 2.6.1. Semantic-Release

[Semantic-Release](https://github.com/semantic-release/semantic-release) automates the release process by analyzing commit messages to determine the next version number, generating changelog and release notes, and publishing the release.

1. Insights and Details

    - [.releaserc.json](.releaserc.json)
      > Configuration file for Semantic-Release specifying release rules and plugins.

2. Usage and Instructions

    - CI/CD

      ```yaml
      uses: sentenz/actions/semantic-release@latest
      ```

### 2.7. Update Manager

#### 2.7.1. Renovate

[Renovate](https://github.com/renovatebot/renovate) automates dependency updates by creating merge requests for outdated dependencies, libraries and packages.

1. Insights and Details

    - [renovate.json](renovate.json)
      > Configuration file for Renovate specifying update rules and schedules.

2. Usage and Instructions

    - CI/CD

      ```yaml
      uses: sentenz/actions/renovate@latest
      ```

#### 2.7.2. Dependabot

[Dependabot](https://github.com/dependabot/dependabot-core) automates dependency updates by creating pull requests for outdated dependencies, libraries and packages.

1. Insights and Details

    - [.github/dependabot.yml](.github/dependabot.yml)
      > Configuration file for Dependabot specifying update rules and schedules.

### 2.8. Secrets Manager

#### 2.8.1. SOPS

[SOPS (Secrets OPerationS)](https://github.com/getsops/sops) is a tool for managing and encrypting sensitive data such as passwords, API keys, and other secrets.

1. Insights and Details

    - [.sops.yaml](.sops.yaml)
      > Configuration file for SOPS specifying encryption rules and key management.

2. Usage and Instructions

    - GPG Key Pair Generation

      - Tasks
        > Generate a new key pair to be used with SOPS.

        > [!NOTE]
        > The UID can be customized via the `SECRETS_SOPS_UID` variable (defaults to `sops-dx`).

        ```bash
        make secrets-gpg-generate SECRETS_SOPS_UID=<uid>
        ```

    - GPG Public Key Fingerprint

      - Tasks
        > Print the  GPG Public Key fingerprint associated with a given UID.

        ```bash
        make secrets-gpg-show SECRETS_SOPS_UID=<uid>
        ```

      - [.sops.yaml](.sops.yaml)
        > The GPG UID is required for populating in `.sops.yaml`.

        ```yaml
        creation_rules:
          - pgp: "<fingerprint>" # <uid>
        ```

    - SOPS Encrypt/Decrypt

      - Tasks
        > Encrypt/decrypt one or more files in place using SOPS.

        ```bash
        make secrets-sops-encrypt <files>
        ```

        ```bash
        make secrets-sops-decrypt <files>
        ```

### 2.9. Container Manager

#### 2.9.1. Docker

[Docker](https://github.com/docker) containerization tool to run applications in isolated container environments and execute container-based tasks.

1. Insights and Details

    - [Dockerfile](Dockerfile)
      > Dockerfile defining the container image for the project.

2. Usage and Instructions

    - CI/CD

      ```yaml
      # TODO
      ```

    - Tasks

      ```bash
      # TODO
      ```

### 2.10. Policy Manager

#### 2.10.1. Conftest

[Conftest](https://www.conftest.dev/) is a **Policy as Code (PaC)** tool to streamline policy management for improved development, security and audit capability.

1. Insights and Details

    - [conftest.toml](conftest.toml)
      > Configuration file for Conftest specifying policy paths and output formats.

    - [tests/policy/](tests/policy/)
      > Directory contains Rego policies for Conftest to enforce best practices and compliance standards.

2. Usage and Instructions

    - CI/CD

      ```yaml
      uses: sentenz/actions/regal@latest
      ```

      ```yaml
      uses: sentenz/actions/conftest@latest
      ```

    - Tasks

      ```bash
      make policy-regal-lint <filepath>
      ```

      ```bash
      make policy-conftest-test <filepath>
      ```

### 2.11. Supply Chain Manager

#### 2.11.1. Trivy

[Trivy](https://github.com/aquasecurity/trivy) is a comprehensive security scanner for vulnerabilities, misconfigurations, and compliance issues in container images, filesystems, and source code.

1. Insights and Details

    - [trivy.yaml](trivy.yaml)
      > Configuration file for Trivy specifying scan settings and options.

    - [.trivyignore](.trivyignore)
      > File specifying vulnerabilities to ignore during Trivy scans.

2. Usage and Instructions

    - CI/CD

      ```yaml
      uses: sentenz/actions/trivy@latest
      ```

    - Tasks

      ```bash
      make sast-trivy-fs <path>
      ```

      ```bash
      make sast-trivy-sbom-cyclonedx-fs <path>
      ```

      ```bash
      make sast-trivy-sbom-scan <sbom_path>
      ```

      ```bash
      make sast-trivy-sbom-license <sbom_path>
      ```

## 3. Troubleshoot

### 3.1. TODO

TODO

## 4. References

- Sentenz [Template DX](https://github.com/sentenz/template-dx) repository.
- Sentenz [Template C++](https://github.com/sentenz/template-cpp) repository.
- Sentenz [Actions](https://github.com/sentenz/actions) repository.
- Sentenz [Manager Tools](https://github.com/sentenz/convention/issues/392) article.
- Sentenz [Skills](https://github.com/sentenz/skills) repository.
