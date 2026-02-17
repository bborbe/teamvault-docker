# Changelog

All notable changes to this project will be documented in this file.

Please choose versions by [Semantic Versioning](http://semver.org/).

* MAJOR version when you make incompatible API changes,
* MINOR version when you add functionality in a backwards-compatible manner, and
* PATCH version when you make backwards-compatible bug fixes.

## Unreleased

- Update TeamVault from 0.11.3 to 0.11.6

## v0.2.0

### Added
- Docker Compose setup for easy local development and testing
- Automatic superuser creation on container startup (configurable via environment variables)
- Build metadata support (git version, commit hash, build date) via OCI labels
- Node.js and npm for frontend asset building
- Makefile commands: `run`, `start`, `stop`, `logs`, `superuser`
- Environment variable configuration via `.env` file
- Documentation with quick start guide

### Changed
- Updated base image from Ubuntu 22.04 to Ubuntu 24.04
- Replaced deprecated `MAINTAINER` with OCI labels
- Updated Python package installation for Ubuntu 24.04 (added `--break-system-packages` for PEP 668)
- Upgraded PostgreSQL from 9.6 to 16 in docker-compose
- Improved ENV directive format (`ENV KEY=value`)
- Updated author email to benjamin.borbe@gmail.com

### Fixed
- Removed obsolete packages (`python3-distutils`, `apt-transport-https`)
- Added webpack asset building to generate missing frontend files
- Fixed platform compatibility for arm64 Macs (Apple Silicon)

### Removed
- Port 5432 exposure in docker-compose (uses internal networking only)

## v0.1.0

### Added
- Docker Compose setup for easy local development and testing
- Automatic superuser creation on container startup (configurable via environment variables)
- Build metadata support (git version, commit hash, build date) via OCI labels
- Node.js and npm for frontend asset building
- Makefile commands: `run`, `start`, `stop`, `logs`, `superuser`
- Environment variable configuration via `.env` file
- Documentation with quick start guide

### Changed
- Updated base image from Ubuntu 22.04 to Ubuntu 24.04
- Replaced deprecated `MAINTAINER` with OCI labels
- Updated Python package installation for Ubuntu 24.04 (added `--break-system-packages` for PEP 668)
- Upgraded PostgreSQL from 9.6 to 16 in docker-compose
- Improved ENV directive format (`ENV KEY=value`)

### Fixed
- Removed obsolete packages (`python3-distutils`, `apt-transport-https`)
- Added webpack asset building to generate missing frontend files
- Fixed platform compatibility for arm64 Macs (Apple Silicon)

### Removed
- Port 5432 exposure in docker-compose (uses internal networking only)
