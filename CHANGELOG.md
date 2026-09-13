# Changelog

## [1.6.2](https://github.com/sentenz/template-dx/compare/1.6.1...1.6.2) (2026-09-13)

### Bug Fixes

* update variable names in lefthook.yml for consistency with Makefile ([42bc2ea](https://github.com/sentenz/template-dx/commit/42bc2ea7874441d86e649ce46a998a42fb78db70))

## [1.6.1](https://github.com/sentenz/template-dx/compare/1.6.0...1.6.1) (2026-09-13)

### Bug Fixes

* **ci:** restore policy scans and release workflow permissions ([#86](https://github.com/sentenz/template-dx/issues/86)) ([5ca7743](https://github.com/sentenz/template-dx/commit/5ca7743807e9be5104a0ec76c8a4b56c60c6e914))
* **ci:** update GitHub workflows for improved functionality and consistency ([83e7d7a](https://github.com/sentenz/template-dx/commit/83e7d7aefecaa0aa9f186a302c05d70bbb75e33e))

### Reverts

* undo container registry changes in Makefile ([7745156](https://github.com/sentenz/template-dx/commit/77451560807ec76b0620a55683f2e0b0c898f1b9))

# [1.6.0](https://github.com/sentenz/template-dx/compare/1.5.0...1.6.0) (2026-05-10)


### Features

* add semgrep and trufflehog tasks/hooks ([#37](https://github.com/sentenz/template-dx/issues/37)) ([e61bcfc](https://github.com/sentenz/template-dx/commit/e61bcfc51ce9a78b74e88658125d2295fa52674c))

# [1.5.0](https://github.com/sentenz/template-dx/compare/1.4.0...1.5.0) (2026-05-10)


### Features

* add Gitleaks tasks to Makefile using official container image ([#35](https://github.com/sentenz/template-dx/issues/35)) ([d5ec1d3](https://github.com/sentenz/template-dx/commit/d5ec1d336e6b17f077a5fa2b5a9530f0291dd7bb))

# [1.4.0](https://github.com/sentenz/template-dx/compare/1.3.0...1.4.0) (2026-05-03)


### Features

* add Git Hooks Manager with Lefthook integration ([88771da](https://github.com/sentenz/template-dx/commit/88771da39030a68d929a8554b4f06ee211ebdf57))

# [1.3.0](https://github.com/sentenz/template-dx/compare/1.2.0...1.3.0) (2025-12-30)


### Features

* update semantic-release workflow to publish SBOM to release notes ([72b02d8](https://github.com/sentenz/template-dx/commit/72b02d870f311af18c26846a68cf9d74e613ec53))

# [1.2.0](https://github.com/sentenz/template-dx/compare/1.1.0...1.2.0) (2025-12-30)


### Features

* add Trivy GitHub Actions workflow for security scanning and SBOM generation ([40af1f9](https://github.com/sentenz/template-dx/commit/40af1f99ecf83a68907d1f85de3478a19bff89b2))

# [1.1.0](https://github.com/sentenz/template-dx/compare/1.0.0...1.1.0) (2025-12-28)


### Features

* add Trivy for SAST tasks to Makefile ([4b9e069](https://github.com/sentenz/template-dx/commit/4b9e069892a8d88c19701cea0d0b24a181ff0835))

# 1.0.0 (2025-12-20)


### Bug Fixes

* resolve plugin configuration in .releaserc.json ([a702b4d](https://github.com/sentenz/template-dx/commit/a702b4d76da5819720b89862cbe3aef9bacc1861))


### Features

* add GitHub workflows for Conftest, Regal, Renovate, Semantic Release, and Semgrep ([b71af72](https://github.com/sentenz/template-dx/commit/b71af729cd813374a8ef20b0e483e11b2197d5c5))
