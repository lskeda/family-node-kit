# Family Node Kit

**Your Bitcoin node. Your verification. Your control.**

Family Node Kit is a family-friendly toolkit for running and managing your own Bitcoin node. It brings together trusted upstream software, verification procedures, service management, and clear documentation in one organized system.

Its purpose is simple: help people start with a manageable setup, learn as they go, and build confidence in operating their own Bitcoin infrastructure.

**Don't Trust. Verify.**

## Why Family Node Kit?

Running a Bitcoin node should not require you to become a Linux expert before you can get started. Family Node Kit aims to make the process approachable without hiding the underlying technology or sacrificing verification.

- **Start simply:** use the Family Node Dashboard to manage routine operations.
- **Learn progressively:** follow the documentation as you become more familiar with Bitcoin infrastructure.
- **Verify your software:** check downloaded software with SHA-256 and use GPG verification where supported.
- **Protect your data:** keep blockchain and index data separate from the Kit's system files.
- **Manage services safely:** coordinate Bitcoin Core, Fulcrum, and Tor through documented procedures.
- **Stay in control:** use your own node and connect compatible wallets to your own infrastructure.

## Features

- **Bitcoin Core** — run your own Bitcoin node and maintain your own copy of the blockchain.
- **Fulcrum** — provide an Electrum-compatible server for supported wallets.
- **Tor integration** — support privacy-conscious network access.
- **Family Node Dashboard** — manage services and access health and verification reports.
- **Sparrow Wallet** — connect a desktop wallet to your own Bitcoin infrastructure.
- **Wasabi Wallet** — optional wallet support documented separately.
- **Backup and recovery** — guidance for preserving blockchain data, index data, and wallet files.
- **Fedora Silverblue support** — installation and operating guidance for an immutable desktop environment.

## Download

**Latest release: Family Node Kit v1.1.0**

[Download Family Node Kit v1.1.0](https://github.com/lskeda/family-node-kit/releases/tag/v1.1.0)

For installation instructions, begin with `README-FIRST.txt` in the downloaded package. Additional guides are available in the `DOCUMENTATIONS/` directory.

## Verify your download

Family Node Kit follows the principle that software should be verified rather than blindly trusted.

For the v1.1.0 release archive, verify the SHA-256 checksum after downloading:

```text
89e331cf7c0dde71e23e66df4c756f67f8d004250aae67b9406d3df6b21d078b
```

Compare the checksum of your downloaded archive with this value. They must match exactly.

The checksum confirms that the file matches the published release artifact; it does not, by itself, prove the identity of the publisher. Consult the project's verification documentation for guidance on SHA-256 and GPG verification.

## Requirements

- A compatible Linux environment; Fedora Silverblue is a documented and tested platform.
- Sufficient storage for the Bitcoin blockchain and Fulcrum index.
- The installer specifies a **minimum 2 TB SSD**.
- Network connectivity for initial blockchain synchronization and ongoing node operation.
- Compatible wallet software installed separately where required.

Initial synchronization and index creation can take considerable time and storage. Actual requirements depend on the software configuration and the state of the existing data.

## Documentation

Start with these guides in `DOCUMENTATIONS/`:

| Guide | Purpose |
|---|---|
| `ARCHITECTURE.md` | Understand the Kit's organization |
| `DASHBOARD-USER-GUIDE.md` | Operate the Dashboard |
| `FEDORA-SILVERBLUE.md` | Installation and system guidance |
| `GPG-VERIFYING-DOWNLOADS.md` | Verify downloaded software |
| `BACKUP-AND-RECOVERY.md` | Protect and recover your data |
| `FULCRUM-MANAGEMENT.md` | Manage the Fulcrum service |
| `USING-SPARROW.md` | Connect and use Sparrow Wallet |
| `MANAGE-WASABI-WALLET.md` | Manage Wasabi Wallet |
| `UNINSTALL.md` | Understand the uninstall procedure |
| `CHANGELOG.md` | Review release history |

For installation, always follow `README-FIRST.txt` in the release package.

## Privacy and data safety

Running your own Bitcoin node reduces your dependence on third-party node providers and lets compatible wallet software query your own infrastructure. Tor can help conceal your network address from some peers and services.

These measures do **not** guarantee complete anonymity. Wallet behavior, network configuration, application settings, and other identifying information can still affect privacy.

Keep wallet backups secure, protect RPC credentials, verify software before installation, and follow the backup and recovery documentation before performing maintenance.

Family Node Kit is a management toolkit. It does not replace the need to understand the security responsibilities of operating a Bitcoin node and wallet.

## License

Family Node Kit is released under the [MIT License](LICENSE).

## Project philosophy

**Don't Trust. Verify.**

Build your own infrastructure. Learn how it works. Keep control of your data.
