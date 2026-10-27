# Family Node Kit

## Changelog
---

## 1.1.0 - 2026-10-27

### Dashboard Menu Routing Fix

* Corrected the Dashboard menu selectors for Tor actions so they match
  their displayed options:
  * `3)` starts the Tor proxy for external-wallet access.
  * `4)` stops the Tor proxy.
  * `5)` displays the onion address.
* Verified the Dashboard script with `bash -n` and tested all three
  menu options successfully.


### Graceful Service Shutdown

* Changed the shutdown order so Fulcrum stops before Bitcoin Core.
* Added a Podman availability check before beginning shutdown.
* Fulcrum receives SIGTERM and is given up to 300 seconds to exit.
* The shutdown process checks Fulcrum's container state and aborts
  before stopping Bitcoin Core if Fulcrum cannot be stopped or its
  final state cannot be verified.
* Bitcoin Core is stopped only after Fulcrum has exited.
* Tor is stopped after Bitcoin Core.
* Added explicit error reporting for shutdown failures.
* External SSD testing confirmed clean shutdown while Bitcoin was still
  synchronizing, with Fulcrum active.
* Fulcrum completed its shutdown before Bitcoin Core stopped.
* Both services restarted successfully, existing blockchain and index
  data were preserved, and Sparrow reconnected.

### System Time and UTC

* Added a UTC system-time display to the Family Node Dashboard.
* The Dashboard now displays the current system time as:
  `TIME: HH:MM UTC`.
* Added `UTC) Synchronize System Time` as the first Dashboard action.
* The UTC action checks that `chronyd` is active and uses the configured
  NTP service to synchronize the system clock.
* The UTC action can be used even when the system clock is already
  synchronized.
* Added verification and clear terminal reporting after time
  synchronization.
* Preserved the existing system-time safety check in the Bitcoin startup
  process.
* Clarified the recommended operating sequence:
  `TIME → UTC → KIT → START → SPARROW`.
* Documented UTC as the universal time reference used by the Dashboard,
  independent of the user's local time zone.

### Fulcrum Management

* Improved Fulcrum installation detection so that the locally installed
  versioned container image can be identified independently of whether
  the Fulcrum container is currently running.
* Fulcrum now uses explicit versioned container images rather than relying
  on the mutable `latest` tag.
* Improved Fulcrum startup handling so that an existing stopped container
  is restarted instead of attempting to create a duplicate container.
* Added protection against unnecessary container recreation when Fulcrum
  is already running.
* Improved Fulcrum update handling with explicit user approval.
* The first detection of a newer official Fulcrum release is recorded and
  reported without immediately requesting an update.
* A previously detected update is presented to the user for an explicit
  update decision.
* Fulcrum updates use the official release and versioned OCI image.
* Updated Fulcrum verification to report installed version, release,
  image and image digest.
* Improved verification of the running Fulcrum application against the
  official release information.
* Preserved Fulcrum data during container replacement and RESET operations.

### Fulcrum Runtime and RESET

* Clarified the separation between the Fulcrum runtime container and the
  persistent Fulcrum data directory.
* RESET removes the Fulcrum runtime container while preserving:
  `~/.fulcrum`
* A locally installed Fulcrum image can remain available after RESET even
  though the runtime container has been removed.
* Fulcrum is therefore no longer incorrectly treated as "Not installed"
  simply because its container is absent.
* After RESET, Fulcrum may correctly report:
  `STOPPED / 🟡 Partially verified`
* After Fulcrum is started again and its runtime information becomes
  available, verification can return:
  `RUNNING / 🟢 Verified`

### Health and Status Reporting

* Clarified the separation between runtime state and health/verification
  state.
* Dashboard status now distinguishes:

  * `RUNNING` / `STOPPED`
  * installation state
  * verification state
* Improved Fulcrum health reporting for stopped-but-installed states.
* The Health Runtime continues to translate component-specific facts into
  standardized Family Node Kit health statuses.
* Health reporting remains read-only.

### Fulcrum Update Philosophy

* Documented that an available Fulcrum update does not require immediate
  installation.
* Updates remain explicitly controlled by the user.
* Added guidance to avoid performing a Fulcrum update while an important
  Sparrow transaction is in progress.
* Documented that a Fulcrum update may require database checking or
  re-indexing.
* Documented the possibility of temporarily increased CPU, storage and
  power consumption during indexing.
* Documented that Fulcrum container startup and Fulcrum readiness are
  different states.
* Port 50001 is used as a readiness indicator after indexing.


### RPC Rotation

* Fixed RPC rotation so that the existing Fulcrum container is removed
  after Bitcoin services are stopped.
* This prevents the existing Fulcrum container from retaining obsolete
  RPC credentials after a password rotation.
* Fulcrum data in `~/.fulcrum` is preserved during RPC rotation.
* The next startup creates a fresh Fulcrum container using the new RPC
  credentials.
* Verified that the corrected workflow eliminates Bitcoin Core RPC
  authentication errors (`401`).
* Verified that Fulcrum reconnects successfully to Bitcoin Core after
  RPC rotation.
* Verified that Sparrow reconnects successfully after the corrected
  RPC rotation workflow.
* Improved Bitcoin startup during RPC rotation by using Bitcoin Core's
  `-daemonwait` startup mode.
* `-daemonwait` allows the Family Node Kit to wait for Bitcoin Core
  initialization to complete before treating daemon startup as
  successful.
* Preserved the existing startup retry logic to handle transient startup
  conditions.
* Preserved the existing Bitcoin RPC readiness verification after
  daemon initialization.
* RPC rotation verification now requires both Bitcoin RPC readiness and
  Fulcrum readiness on port `50001` before reporting:
  `RPC ROTATION COMPLETE`.
* Tested RPC rotation with `-daemonwait` on the external SSD and on the
  primary Fedora Silverblue system.
* Tested immediate RPC rotation after starting the Bitcoin node.
* Verified successful Bitcoin shutdown, restart, RPC authentication and
  Fulcrum recreation after RPC rotation.

### Bitcoin Core Health and Update Guidance

* Added a detailed Bitcoin Core verification section to the Family Node
  Kit Health Report.
* The Bitcoin report now displays:

  * running state
  * Bitcoin Core version
  * runtime type
  * installation source
  * installation directory
  * Bitcoin data directory
  * RPC reachability
* Clarified the distinction between Bitcoin Core installation
  verification and current runtime state.
* The Health Report now provides a direct pointer to:
  `DOCUMENTATIONS/UPDATE-BITCOIN-CORE.md`
* Added the same Bitcoin Core update documentation pointer to the
  successful Bitcoin startup output.
* Added `UPDATE-BITCOIN-CORE.md` with a short, step-by-step procedure
  for verifying and updating Bitcoin Core using Family Node Kit.
* Updated `README-FIRST.txt` to include the new Bitcoin Core update
  documentation.
* Removed duplicate Fulcrum verification output from the Family Node
  Kit Health Report.

### Testing

Additional testing completed during the final release preparation:

* Verified the detailed Bitcoin Core Health Report with Bitcoin stopped.
* Verified the detailed Bitcoin Core Health Report with Bitcoin running.
* Verified Bitcoin RPC reporting as `Not reachable` when Bitcoin is stopped.
* Verified Bitcoin RPC reporting as `Reachable` when Bitcoin is running.
* Verified the Bitcoin Core update documentation pointer in both the
  startup process and Health Report.
* Verified that Fulcrum appears exactly once in the detailed Health
  Report.
* Transferred the tested Bitcoin Health Report changes from the
  external SSD to the primary Fedora Silverblue system.
* Compared the transferred Health Report script with the tested SSD
  version.
* Verified executable permissions and shell syntax after transfer.
* Verified the final package contents before release.
* Verified that administrative tools and development backup files are
  excluded from the release package.

### Documentation

* Added `UPDATE-BITCOIN-CORE.md`.
* Updated `README-FIRST.txt` with the new documentation entry and
  description.
* Documented the Bitcoin Core update workflow:
  `Download → Verify → Install → Start → Verify again`.
* Clarified that SHA256 verification is mandatory and PGP verification
  is optional when trusted signing keys are available.
* Added direct guidance from the Bitcoin Health Report and Bitcoin
  startup process to the Bitcoin Core update procedure.


### Testing

Tested on the primary Fedora Silverblue system and on an external SSD.

Verified on the primary system:

* Family Node Kit installation
* Bitcoin Core startup
* Fulcrum installation
* Fulcrum startup
* Fulcrum version detection
* Fulcrum versioned image detection
* Fulcrum health verification
* Fulcrum update detection
* Fulcrum update workflow
* Fulcrum container replacement
* Fulcrum RESET behavior
* Restart of an existing stopped Fulcrum container
* Dashboard status reporting
* Family Node Kit Health Report
* Bitcoin RPC rotation
* Fulcrum RPC reconnection after rotation
* Sparrow reconnection after RPC rotation
* Preservation of `~/.fulcrum`
* Package creation
* Documentation included in release packages
* Bitcoin startup using `-daemonwait`
* Normal Bitcoin STOP → START operation using `-daemonwait`
* Immediate RPC rotation after Bitcoin startup using `-daemonwait`
* Successful Fulcrum recreation and readiness after immediate RPC rotation

Verified on the external SSD:

* Family Node Kit installation
* UTC system-time synchronization
* Bitcoin Core installation and startup
* Bitcoin Core synchronization
* Fulcrum automatic installation
* Fulcrum startup and indexing
* Fulcrum health verification
* Fulcrum readiness on port 50001
* Sparrow connection
* Tor first-start installation
* Tor service startup
* Sparrow onion connection
* Dashboard status reporting
* Family Node Kit Health Report
* Bitcoin RPC rotation
* Fulcrum recreation and RPC reconnection after rotation
* Sparrow reconnection after RPC rotation
* RESET behavior
* CLEAN system-log cleanup
* Preservation of `~/.bitcoin`
* Preservation of `~/.fulcrum`
* Family Node Kit uninstall
* Removal of versioned Fulcrum container image during uninstall
* Removal of Tor container image during uninstall
* Removal of the Family Node Kit installation during uninstall
* Package creation
* Package extraction
* Documentation included in release packages
* Bitcoin startup using `-daemonwait`
* Normal Bitcoin STOP → START operation using `-daemonwait`
* RPC rotation using `-daemonwait`
* Successful Fulcrum recreation and readiness after RPC rotation
* RPC rotation while the node was still synchronizing
* Successful RPC rotation on the external SSD after approximately
  1 minute of initial node startup


### Documentation

* Added `DOCUMENTATIONS/` as the central documentation directory.
* Added `FULCRUM-MANAGEMENT.md`.
* Added `USING-SPARROW.md`.
* Updated `ARCHITECTURE.md` to document the current architecture and
  separation of responsibilities.
* Updated documentation to describe runtime state separately from
  verification state.
* Expanded documentation of Fulcrum installation, updates, verification,
  RESET behavior and recommended practices.
* Updated `README-FIRST.txt` to reflect the current documentation
  structure and workflow.

### Architecture

* Strengthened the separation between:

  * Dashboard
  * Commands
  * Runtime libraries
  * Official project information
  * Verification
  * Health reporting
  * Persistent user data
* Documented the distinction between runtime state, installation state
  and verification state.
* Documented versioned Fulcrum images as part of the verification model.
* Reinforced the principle that the Dashboard orchestrates but does not
  contain component-specific business logic.
* Reinforced the principle that verification scripts are read-only.

### Testing

Tested on the primary Fedora Silverblue system and on an external SSD.

Verified on the primary system:

* Family Node Kit installation
* Bitcoin Core startup
* Fulcrum installation
* Fulcrum startup
* Fulcrum version detection
* Fulcrum versioned image detection
* Fulcrum health verification
* Fulcrum update detection
* Fulcrum update workflow
* Fulcrum container replacement
* Fulcrum RESET behavior
* Restart of an existing stopped Fulcrum container
* Dashboard status reporting
* Family Node Kit Health Report
* Bitcoin RPC rotation
* Fulcrum RPC reconnection after rotation
* Sparrow reconnection after RPC rotation
* Preservation of `~/.fulcrum`
* Package creation
* Documentation included in release packages

Verified on the external SSD:

* Family Node Kit installation
* UTC system-time synchronization
* Bitcoin Core installation and startup
* Bitcoin Core synchronization
* Fulcrum automatic installation
* Fulcrum startup and indexing
* Fulcrum health verification
* Fulcrum readiness on port 50001
* Sparrow connection
* Tor first-start installation
* Tor service startup
* Sparrow onion connection
* Dashboard status reporting
* Family Node Kit Health Report
* Bitcoin RPC rotation
* Fulcrum recreation and RPC reconnection after rotation
* Sparrow reconnection after RPC rotation
* RESET behavior
* CLEAN system-log cleanup
* Preservation of `~/.bitcoin`
* Preservation of `~/.fulcrum`
* Family Node Kit uninstall
* Removal of versioned Fulcrum container image during uninstall
* Removal of Tor container image during uninstall
* Removal of the Family Node Kit installation during uninstall
* Package creation
* Package extraction
* Documentation included in release packages

### Packaging

* Updated the release package builder to include the new
  `DOCUMENTATIONS/` directory.
* Documentation is now packaged together under the
  `family-node-kit/DOCUMENTATIONS/` directory.
* Administrative and development-only files remain excluded from
  release packages.
* Verified that the generated archive contains the expected documentation
  files.

### Philosophy

The current release continues to follow:

```
Don't Trust. Verify.
```

The Family Node Kit informs the user rather than making decisions on
the user's behalf.

Software updates are explicit.

Verification is read-only.

User data remains separate from the Kit.

The user remains responsible for wallets, private keys, transactions
and spending decisions.

---

## 1.0.0 - 2026-07-22

### First Stable Release

The first stable release of Family Node Kit.

### Features

* Bitcoin Core installation with SHA256 verification and optional GPG verification.
* Fulcrum integration.
* Tor integration.
* Family Node Dashboard.
* Family Health Report.
* Modular verification framework.
* Unified command interface (`family-node`).

### Bitcoin Node

* The project originally used Bitcoin Knots.
* The Bitcoin node was changed to Bitcoin Core following the Bitcoin Knots fork.
* The Family Node Kit runtime architecture was updated so that Bitcoin installation detection, executable paths and version detection are handled centrally.
* The node identity and installed version are reported separately.
* The Health Report identifies the node explicitly, for example:
  `Bitcoin node: Core v31.1.0`.

### Architecture

* Established a modular architecture separating:

  * Dashboard
  * Commands
  * Libraries
  * Runtime verification
  * Health reporting
* Introduced the Health Runtime as a common verification layer.
* Standardized health statuses across all components.
* Simplified command structure and removed legacy startup scripts.
* Centralized Bitcoin runtime detection through `bitcoin-runtime.sh`.
* Removed direct assumptions about Bitcoin installation directory names from runtime-dependent scripts.

### Reset and Runtime Management

* Updated the node reset process to use the centralized Bitcoin runtime functions.
* RESET preserves Bitcoin and Fulcrum data while cleaning the runtime containers.
* RESET was tested successfully on the primary system and on a clean Fedora Silverblue installation on an external SSD.
* Verified that the reset process correctly resolves the Bitcoin Core installation and stops the required runtime components.

### Documentation

* Added `README-FIRST.txt`.
* Added `GPG-VERIFYING-DOWNLOADS.md`.
* Updated `ARCHITECTURE.md`.
* Added installation guide to release packages.
* Improved documentation for installation, verification, backup and recovery.

### Packaging

* Simplified release package layout.
* Removed development-only files from release archives.
* Added reproducible package builder.

### Verification

* Improved Bitcoin verification workflow.
* Added structured GPG verification reporting.
* Clarified missing public-key messages.
* Preserved mandatory SHA256 verification.
* Improved reporting of Bitcoin node identity and installed version.

### Testing

Successfully tested on:

* Fedora Silverblue (primary system)
* Clean Fedora Silverblue installation on external SSD

Verified:

* Installation
* Package creation
* Package extraction
* Bitcoin Core installation
* Bitcoin startup
* Fulcrum startup
* Tor integration
* Dashboard
* Health Report
* RESET
* Family Node Kit uninstall

### Milestone

Version 1.0.0 establishes the stable architecture of the
Family Node Kit. The project now uses Bitcoin Core following
the Bitcoin Knots fork while preserving the project's
verification model, modular architecture and transparent
runtime reporting.

Future releases are expected to extend the project while
preserving its user interface, verification model and
overall workflow whenever possible.

