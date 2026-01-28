# `scripts/`

- [1. Details](#1-details)
  - [1.1. Shell (Bash)](#11-shell-bash)
  - [1.2. PowerShell](#12-powershell)

## 1. Details

### 1.1. Shell (Bash)

- `shell/`
  > Contains a suite of modular shell scripts intended for system automation and orchestration of complex workflows.

- `bootstrap.sh`
  > Initializes the operating environment by setting up essential prerequisites and configuring dependencies.

- `setup.sh`
  > System configuration and preparation, ensuring that all required services and settings are in place for the successful execution of subsequent tasks or applications.

- `teardown.sh`
  > Facilitates the graceful decommissioning of the environment by reversing configurations and cleaning up temporary artifacts.

### 1.2. PowerShell

- `powershell/`
  > Contains PowerShell modules, reusable units that package cmdlets, functions, providers and resources in order to extend the functionality of PowerShell.

- `Bootstrap.ps1`
  > Initializes the operating environment by setting up essential prerequisites and configuring dependencies.

- `Setup.ps1`
  > System configuration and preparation, ensuring that all required services and settings are in place for the successful execution of subsequent tasks or applications.

- `Teardown.ps1`
  > TODO Facilitates the graceful decommissioning of the environment by reversing configurations and cleaning up temporary artifacts.
