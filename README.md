# Java Based Game Server Panel + Daemon

A production-grade Java 21 game server control panel inspired by Pterodactyl, with complete original implementation. Designed for Ubuntu VPS (with Proot support) without requiring Docker or root access.

## Architecture Overview

### Components
1. **Panel** - Web interface and REST API (Spring Boot)
2. **Daemon** - Server process management and monitoring (Java)

### Key Features
- User authentication (JWT, 2FA, sessions)
- Multi-node management with heartbeat system
- Server lifecycle management (create, start, stop, restart)
- Real-time console with WebSocket
- File manager with drag-and-drop
- Automated backups and restore
- Scheduler with cron expression support
- Resource monitoring (CPU, RAM, Disk, Network)
- Template system for game servers
- Granular permission system
- Audit and activity logging

## System Requirements

- **Java**: 21+
- **Database**: MySQL 8.0+ / MariaDB 10.5+
- **Cache**: Redis (optional)
- **OS**: Ubuntu 22.04+, Debian, or Proot VPS
- **Architecture**: ARM64, x86_64
- **RAM**: 2GB minimum
- **Disk**: 20GB minimum

## Installation

### Prerequisites
```bash
java -version  # Should be Java 21+
mysql --version
redis-cli --version  # Optional
```

### Build
```bash
mvn clean install
```

### Run
```bash
# Panel
java -jar panel/target/panel.jar

# Daemon
java -jar daemon/target/daemon.jar
```

## Project Structure

```
project/
├── panel/              # Spring Boot Panel Application
├── daemon/             # Daemon Service
├── common/             # Shared utilities and models
├── docs/               # Documentation
└── scripts/            # Installation and utility scripts
```

## Documentation

See [docs/](./docs) for comprehensive documentation.

## License

MIT License
