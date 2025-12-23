# Template DX

[![License](https://img.shields.io/github/license/sentenz/percent)](https://opensource.org/licenses/Apache-2.0)

A comprehensive development experience (DX) template repository that provides a structured framework and essential tools to streamline the software development process.

- [1. Details](#1-details)
  - [1.1. Prerequisites](#11-prerequisites)
- [2. Usage](#2-usage)
  - [2.1. Task Runner](#21-task-runner)
    - [2.1.1. Make](#211-make)
  - [2.2. Bootstrap](#22-bootstrap)
    - [2.2.1. Scripts](#221-scripts)
  - [2.3. Dev Containers](#23-dev-containers)
  - [2.4. Release Manager](#24-release-manager)
    - [2.4.1. Semantic-Release](#241-semantic-release)
  - [2.5. Update Manager](#25-update-manager)
    - [2.5.1. Renovate](#251-renovate)
  - [2.6. Secrets Manager](#26-secrets-manager)
    - [2.6.1. SOPS](#261-sops)
  - [2.7. Container Manager](#27-container-manager)
    - [2.7.1. Docker](#271-docker)
  - [2.8. Policy Manager](#28-policy-manager)
    - [2.8.1. Conftest](#281-conftest)
- [3. Troubleshoot](#3-troubleshoot)
  - [3.1. TODO](#31-todo)
- [4. References](#4-references)

## 1. Details

### 1.1. Prerequisites

- [Make](https://www.gnu.org/software/make/)
  > Task automation tool to manage build processes and workflows.

- [Docker](https://www.docker.com/)
  > Containerization tool to run applications in isolated container environments and execute container-based tasks.

## 2. Usage

### 2.1. Task Runner

#### 2.1.1. Make

- [Makefile](Makefile)
  > Makefile defining tasks for building, testing, and managing the project.

  > [!NOTE]
  > - Run `make help` in the terminal to list the project tasks.
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

### 2.2. Bootstrap

#### 2.2.1. Scripts

[scripts/](scripts/README.md) provides scripts to bootstrap, setup, and teardown a software development workspace with requisites.

1. Insights and Details

    - [bootstrap.sh](scripts/bootstrap.sh)
      > Initializes a software development workspace with requisites.

    - [setup.sh](scripts/setup.sh)
      > Installs and configures all dependencies essential for development.

    - [teardown.sh](scripts/teardown.sh)
      > Removes development artifacts and restores the host to its pre-setup state.

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

### 2.3. Dev Containers

[.devcontainer/](.devcontainer/README.md) provides Dev Containers as a consistent development environment using Docker containers.

1. Insights and Details

    - [go/](.devcontainer/go/)
      > Dev Container configuration for Go development environment.

2. Usage and Instructions

    - Tasks

      ```bash
      # TODO
      # make devcontainer-go
      # make devcontainer-cpp
      # make devcontainer-python
      ```

### 2.4. Release Manager

#### 2.4.1. Semantic-Release

[Semantic-Release](https://github.com/semantic-release/semantic-release) automates the release process by analyzing commit messages to determine the next version number, generating changelog and release notes, and publishing the release.

1. Insights and Details

    - [.releaserc.json](.releaserc.json)
      > Configuration file for Semantic-Release specifying release rules and plugins.

2. Usage and Instructions

    - CI/CD

      ```yaml
      uses: sentenz/actions/semantic-release@latest
      ```

### 2.5. Update Manager

#### 2.5.1. Renovate

[Renovate](https://github.com/renovatebot/renovate) automates dependency updates by creating merge requests for outdated dependencies, ensuring that projects stay up-to-date with the latest versions of libraries and packages.

1. Insights and Details

    - [renovate.json](renovate.json)
      > Configuration file for Renovate specifying update rules and schedules.

2. Usage and Instructions

    - CI/CD

      ```yaml
      uses: sentenz/actions/renovate@latest
      ```

### 2.6. Secrets Manager

#### 2.6.1. SOPS

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

### 2.7. Container Manager

#### 2.7.1. Docker

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

### 2.8. Policy Manager

#### 2.8.1. Conftest

[Conftest](https://www.conftest.dev/) is a **Policy as Code (PaC)** tool to streamline policy management for improved development, security and audit capability.

1. Insights and Details

    - [conftest.toml](conftest.toml)
      > Configuration file for Conftest specifying policy paths and output formats.

    - [tests/policy](tests/policy/)
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
      make policy-lint-regal <filepath>
      ```

      ```bash
      make policy-analysis-conftest <filepath>
      ```

## 3. Troubleshoot

### 3.1. TODO

TODO

## 4. References

- GitHub [Template DX](https://github.com/sentenz/template-dx) repository.
- Sentenz [Manager Tools](https://github.com/sentenz/convention/issues/392) article.
