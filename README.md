# Template DX

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Development Experience (DX) template providing a structured framework and essential tools to streamline development.

- [1. Details](#1-details)
  - [1.1. Prerequisites](#11-prerequisites)
  - [1.2. Usage](#12-usage)
- [2. Contribute](#2-contribute)
- [3. Troubleshoot](#3-troubleshoot)
  - [3.1. TODO](#31-todo)
- [4. References](#4-references)

## 1. Details

### 1.1. Prerequisites

- [Git](https://git-scm.com/)
  > Distributed version control system for tracking source code changes.

  ```bash
  sudo apt install git
  ```

- [Make](https://www.gnu.org/software/make/)
  > Task automation tool to manage build processes and workflows.

  ```bash
  sudo apt install make
  ```

### 1.2. Usage

1. Insights and Details

    - TODO
      > Brief description of the features.

2. Usage and Instructions

    - CI/CD

      ```yaml
      uses: .github/actions
      ```

    - Tasks

      ```bash
      make <task>
      ```

## 2. Contribute

[CONTRIBUTING.md](CONTRIBUTING.md) provides guidens and instructions for contributing to the project.

- [AI Agents](CONTRIBUTING.md#1-ai-agents)
  > Automated tools that assist in various development tasks such as code generation, testing, and documentation.

- [Skills Manager](CONTRIBUTING.md#2-skills-manager)
  > CLI tool for managing AI agent skills in development projects.

- [Task Runner](CONTRIBUTING.md#3-task-runner)
  > Make automation tool that defines and manages tasks to streamline development workflows.

- [Bootstrap](CONTRIBUTING.md#4-bootstrap)
  > Scripts to bootstrap, setup, and teardown a software development workspace with requisites.

- [Secrets Manager](CONTRIBUTING.md#9-secrets-manager)
  > Manage and secure sensitive information such as API keys, passwords, and certificates.

- [Git Hooks Manager](CONTRIBUTING.md#5-git-hooks-manager)
  > Lefthook configuration for managing Git hooks to automate Git events on commit or push.

- [Dev Containers](CONTRIBUTING.md#6-dev-containers)
  > Consistent development environments using Docker containers.

- [Release Manager](CONTRIBUTING.md#7-release-manager)
  > Semantic-Release automates the release process by analyzing commit messages.

- [Update Manager](CONTRIBUTING.md#8-update-manager)
  > Renovate and Dependabot automate dependency updates by creating pull requests.

- [Policy Manager](CONTRIBUTING.md#11-policy-manager)
  > Conftest for policy-as-code enforcement.

- [SAST Manager](CONTRIBUTING.md#12-sast-manager)
  > Identifying security vulnerabilities and issues in source code, container images, and artifacts.

- [Supply Chain Manager](CONTRIBUTING.md#13-supply-chain-manager)
  > Software Supply Chain Security for identifying vulnerabilities in dependencies by scanning SBOMs, container images, filesystems, and compliance issues.

- [Documentation Generators](CONTRIBUTING.md#14-documentation-generators)
  > MkDocs for building and serving the documentation site.

## 3. Troubleshoot

### 3.1. TODO

TODO

## 4. References

- Sentenz [Template DX](https://github.com/sentenz/template-dx) repository.
- Sentenz [Actions](https://github.com/sentenz/actions) repository.
- Sentenz [Skills](https://github.com/sentenz/skills) repository.
- Sentenz [Manager Tools](https://sentenz.github.io/convention/articles/manager-tools/) article.
