# Steam Base Container

A minimal, production-ready Docker container for running dedicated Steam game servers.

## Overview

This project provides a lightweight Debian-based container image that includes SteamCMD pre-installed, optimized for running game server instances. The container is designed to be easily extended by adding your specific `start-server.sh` script.

## Features

- **Minimal Base Image**: Uses `debian:12.14-slim` for reduced attack surface and size
- **SteamCMD Included**: Pre-installed for easy game server installation and updates
- **Multi-Architecture Support**: Built with Docker BuildKit for cross-platform builds
- **Production Hardening**: Runs as a non-root user (`steam`)
- **Volume Mounting**: Supports `/data` and `/home/steam/.local/share/Steam` volumes
- **BuildCaching**: Optimized APT caching during image builds

## Quick Start

### Build the Image

```bash
docker buildx build --load -t steam-base-container:latest .
```

### Run the Container

```bash
docker run -d \
  --name my-game-server \
  -v /path/to/data:/data \
  -v /path/to/steam:/home/steam/.local/share/Steam \
  -e APP_ID=730 \
  -e APP_NAME="Counter-Strike 2" \
  steam-base-container:latest
```

### Required Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `APP_ID` | Yes | Steam App ID for the game server |
| `APP_NAME` | Yes | Human-readable name of the game |
| `INSTALL_DIR` | No (default: `/data`) | Directory where SteamCMD installs the game files. Must be writable by the `steam` user |
| `DO_VALIDATE` | No (default: 0) | Set to `1` to validate existing files before starting |
| `SKIP_UPDATE` | No (default: 0) | Set to `1` to skip updating existing installation |

### Required Files

The container expects `/start-server.sh` to be present in the container. This script should be provided by extending the base image or mounting it into the container.

## Usage Example

### Extending the Base Image

```dockerfile
FROM thelande/steam-base-container:sha-<GIT_SHA>

# Copy your server startup script
COPY start-server.sh /start-server.sh
RUN chmod +x /start-server.sh

# Add any additional configuration
EXPOSE 27015 27016
```

### Docker Compose Example

```yaml
version: '3.8'

services:
  game-server:
    build: .
    container_name: my-game-server
    volumes:
      - ./data:/data
      - ./steam:/home/steam/.local/share/Steam
    environment:
      - APP_ID=730
      - APP_NAME="Counter-Strike 2"
      - DO_VALIDATE=0
    restart: unless-stopped
    ports:
      - "27015:27015"
      - "27016:27016"
```

## Building Tags

The `docker-bake.hcl` defines multiple build targets:

| Target | Description |
|--------|-------------|
| `image-local` | Local image with date-based tag |
| `image-all` | Pushes to Docker Hub with `rolling` and `sha-<GIT_SHA>` tags |

Run all targets:

```bash
docker buildx bake --set image-all.push=true
```

## License

This project is licensed under the terms specified in [LICENSE](LICENSE).

## Support

For issues and questions, please open an issue on the [GitHub repository](https://github.com/thelande/steam-base-container).
