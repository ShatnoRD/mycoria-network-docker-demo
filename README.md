# Mycoria Network Experiments

This repository contains a minimal proof of concept demonstrating peer-to-peer networking capability using Mycoria. The implementation establishes a direct connection between two independent nodes in a simplified environment.

[Mycoria](https://mycoria.org/) is a modern encrypted IPv6 network that uses cryptographic identities for addressing and routing. Each node in the Mycoria network is identified by an IPv6 address derived from its public key, enabling secure end-to-end encrypted communications.

## Getting Started

Spin up the docker containers using docker-compose:

```bash
docker-compose up -d
```

## Overview

This proof of concept demonstrates:
- Direct peer-to-peer connectivity between two Mycoria nodes
- Cross-node service access using IPv6 networking
- Port forwarding to access services across nodes
- ~~DNS resolution for .myco domains~~

**DNS Resolution**: This implementation does not fully support DNS resolution for `.myco` domains. While services can be accessed directly via their IPv6 addresses (e.g., `http://[fd1a:8fd0:d01e:8d3b:ce17:dc5b:83f:1d5]:8080`), domain name resolution (e.g., `http://matsutake.myco/`) is not working correctly. 

This issue stems from a discrepancy between the DNS server configuration in our demo and the official Mycoria documentation. While our implementation uses dnsmasq configured to point to `fd00::b909` for `.myco` domains, the official [documentation](https://mycoria.org/install/) recommends using system-level DNS configuration methods like systemd-networkd or NetworkManager instead. For now, please use direct IPv6 addressing to access services.

## Network Structure
```
 ┌──────────────────┐       ┌───────────────────┐       ┌───────────────────┐       ┌─────────────────┐
 │  nginx-matsutake │────── │    mycoria-a      │=======│    mycoria-b      │───────│   nginx-truffle │
 │  (Web Server A)  │node-a │  (Mesh Node A)    │peering│  (Mesh Node B)    │node-b │  (Web Server B) │ 
 └──────────────────┘       └───────────────────┘       └───────────────────┘       └─────────────────┘
```

## Components Explanation

- **nginx-matsutake**: Web server running alongside Node A
- **mycoria-a**: First network node that establishes peer connection
- **mycoria-b**: Second network node that peers with mycoria-a
- **nginx-truffle**: Web server running alongside Node B

## Accessing Services
- **Accessing nginx-truffle through mycoria-node-a**: http://localhost:8081
- **Accessing nginx-matsutake through mycoria-node-b**: http://localhost:8082

## Configuration
The node configuration files [mycoria-node-a.yaml](./config/mycoria/mycoria-node-a.yaml) and [mycoria-node-b.yaml](./config/mycoria/mycoria-node-b.yaml) should be customized according to the [Mycoria documentation](https://mycoria.org/configure/).

**⚠️ Security Warning**: Both configuration files contain private keys that are included for demonstration purposes only. In a real-world scenario, never commit private keys to a repository. Generate new keys for each deployment and store them securely.

## For more information about Mycoria
- [Official Documentation](https://mycoria.org/)
- [GitHub Repository](https://github.com/mycoria/mycoria)