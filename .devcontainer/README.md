# `.devcontainer/`

The `.devcontainer/` directory contains configuration files for setting up a [Development Containers](https://containers.dev/) environment.

- [1. Details](#1-details)
  - [1.1. Dev Containers](#11-dev-containers)
- [2. References](#2-references)

## 1. Details

### 1.1. Dev Containers

- `cpp/`
  > Develop [C++](https://github.com/devcontainers/images/tree/main/src/cpp) applications on Linux. Includes Debian C++ build tools.

- `dotnet/`
  > Develop [C# and .NET](https://github.com/devcontainers/images/tree/main/src/dotnet) based applications. Includes all needed SDKs, extensions, and dependencies.

- `go/`
  > Develop [Go](https://github.com/devcontainers/images/tree/main/src/go) based applications. Includes appropriate runtime args, Go, common tools, extensions, and dependencies.

- `python/`
  > Develop [Python 3](https://github.com/devcontainers/images/tree/main/src/python) applications.

> [!NOTE]
> The `devcontainer.json` runs the `bootstrap` and `setup` tasks to initialize and configure the development environment.
>
> ```json
> // ...
> "postCreateCommand": "sudo make bootstrap && sudo make setup",
> // ...
> ```

## 2. References

- Dev Container [Features](https://containers.dev/features) page.
- Dev Container [Templates](https://containers.dev/templates) page.
- Dev Container [Specification](https://containers.dev/implementors/spec/) page.
- GitHub [Dev Containers Images](https://github.com/devcontainers/images) repository.
