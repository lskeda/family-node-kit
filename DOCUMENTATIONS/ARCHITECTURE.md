# Family Node Kit

## Architecture Rules v1.1

The Family Node Kit follows the Bitcoin principle:

    Don't Trust. Verify.

Every component has a defined responsibility.

Every important verification result should be independently
reproducible by the user.

The Dashboard orchestrates the system but does not contain
component-specific business logic.

The architecture is designed to remain simple, transparent,
modular and maintainable as the software managed by the Kit evolves.

---

# Architecture Overview

The Family Node Kit follows a strict separation between:

- User Interface
- Command Execution
- Runtime Libraries
- Official Project Information
- Health Reporting
- Local System and Data

The general flow is:

                         DASHBOARD
                             │
                             ▼
                    system/bin commands
                             │
                             ▼
                       system/lib
                             │
               ┌─────────────┼─────────────┐
               ▼             ▼             ▼
            Bitcoin        Fulcrum         Tor
            runtime        runtime       runtime
               │             │             │
               ▼             ▼             ▼
          Local System   Local System   Local System
               │             │             │
               └─────────────┼─────────────┘
                             │
                             ▼
                     Official Sources
                             │
                             ▼
                      Verification
                             │
                             ▼
                       Health Report

The architecture deliberately separates:

    What the system is doing

from:

    What the system has installed

and from:

    What can currently be verified

These are related, but they are not the same thing.

---

# Project Layout

The principal project structure is:

    ~/family-node-kit

    ├── dashboard/
    │
    ├── system/
    │   ├── bin/
    │   ├── config/
    │   ├── env/
    │   ├── lib/
    │   └── services/
    │
    ├── configs/
    │
    ├── desktop/
    │
    ├── tools/
    │
    ├── updates/
    │
    ├── backups/
    │
    ├── DOCUMENTATIONS/
    │
    ├── family-node
    ├── install.sh
    ├── README-FIRST.txt
    └── VERSION

---

# Documentation

All user and project documentation is kept in:

    DOCUMENTATIONS/

Documentation includes subjects such as:

- Architecture
- Update Bitcoin Core
- Dashboard usage
- Fulcrum management
- Sparrow usage
- Backup and recovery
- Fedora Silverblue
- Software verification
- Uninstallation
- Project changes

The documentation is kept separate from executable system components.

This makes the project easier to navigate and keeps the operational
software separate from explanatory material.

---

# Separation of Responsibilities

The Family Node Kit follows a strict separation of responsibilities.

## system/bin/

Executable commands.

These scripts perform actions and may modify the system.

Examples:

    start-bitcoin-services.sh
    start-fulcrum.sh
    start-tor.sh
    stop-bitcoin-services.sh
    stop-tor.sh
    reset-bitcoin-node.sh
    rotate-bitcoin-rpc.sh
    verify-bitcoin.sh
    verify-fulcrum.sh
    verify-tor.sh
    verify-family-node.sh

These scripts are user-facing operational programs.

They may:

- display information
- ask questions
- perform actions
- start services
- stop services
- install or prepare software
- report results

---

## system/lib/

Shared runtime and information libraries.

These files define:

- functions
- variables
- component-specific knowledge
- runtime detection
- official release information

Libraries should not display banners or user-interface messages.

They should not perform actions simply because they are sourced.

For example:

    version="$(get_bitcoin_version)"

rather than:

    echo "Bitcoin version is..."

The libraries provide knowledge.

The executable commands decide what to do with that knowledge.

---

## dashboard/

User interface.

The Dashboard presents available operations and delegates the actual work
to the appropriate commands.

The Dashboard should not contain component-specific business logic.

For example, the Dashboard should call:

    family-node verify

rather than implementing Bitcoin, Fulcrum or Tor verification itself.

The Dashboard is the conductor.

It is not the instrument.

---

## family-node

Command dispatcher.

The `family-node` command provides a stable interface between the Dashboard
and the operational scripts.

It routes commands to the appropriate `system/bin/` program.

This allows the Dashboard to remain simple and provides a stable command
interface even when individual scripts evolve.

---

# Architecture Motto

The architecture can be summarized as:

    Dashboard
        │
        ▼
    Commands
        │
        ▼
    Libraries
        │
        ▼
    Local System + Official Sources
        │
        ▼
    Verification
        │
        ▼
    Health Report

Or, in simpler terms:

    system/bin/
        Do things.

    system/lib/
        Know things.

    dashboard/
        Ask for things.

    family-node
        Connect everything.

    DOCUMENTATIONS/
        Explain things.

---

# Rule 1 — One Responsibility

Every script should have one primary responsibility.

Examples:

    bitcoin-runtime.sh

asks:

    What is installed locally?

    fulcrum-runtime.sh

asks:

    What Fulcrum runtime is present locally?

    fulcrum-official.sh

asks:

    What does the official Fulcrum project currently publish?

    verify-fulcrum.sh

asks:

    What can be verified about the installed Fulcrum?

Keeping responsibilities separate makes the system easier to understand,
test and maintain.

---

# Rule 2 — Libraries Never Talk

Everything inside:

    system/lib/

must avoid user-facing output.

Libraries should primarily:

- return data
- return exit codes
- expose functions

They should not print banners or explanations.

For example:

    get_fulcrum_image

returns information.

The command that uses it decides how that information should be
presented to the user.

---

# Rule 3 — User-Facing Programs Explain

Everything inside:

    system/bin/

may produce clear, human-readable output.

For example:

    =================================
         FULCRUM VERIFICATION
    =================================

Operational scripts are responsible for explaining what is happening.

This is especially important during:

- installation
- updates
- verification
- recovery
- reset operations

The user should be able to understand the operation without needing
to inspect the source code.

---

# Rule 4 — Dashboard Orchestrates

The Dashboard does not contain business logic.

It should not implement:

    curl ...
    grep ...
    awk ...
    podman ...

to determine component-specific facts.

Instead it delegates to the appropriate command.

For example:

    verify-family-node.sh

or:

    family-node verify

The Dashboard becomes the conductor.

---

# Rule 5 — Never Duplicate Code

If multiple scripts require the same information or operation,
the common functionality should be moved into:

    system/lib/

and reused.

This reduces duplication and prevents different parts of the Kit
from developing conflicting definitions of the same fact.

---

# Rule 6 — Every Important Result Must Be Independently Verifiable

This is one of the central principles of the Family Node Kit.

Whenever practical, every reported result should come from something
the user can independently inspect.

Examples include:

    bitcoind --version

    bitcoin-cli

    podman inspect

    podman image inspect

    Podman image information

    Official project release information

    Local configuration files

No magic.

No hidden database used only by the Kit.

No unexplained internal assumption.

The Kit should simplify verification, not replace it.

---

# Rule 7 — VERIFY Never Changes the System

Verification is read-only.

Verification scripts must never:

- install software
- download software
- delete data
- restart services
- stop services
- modify configuration

The Health Report is therefore an observation of the current system,
not an operation performed on the system.

---

# Rule 8 — Installation and Updates Are Explicit

The Family Node Kit does not silently install software merely because
a newer release exists.

If a newer official release is detected:

1. The Kit identifies it.
2. The Kit informs the user.
3. The user decides whether to update.
4. The update is prepared and verified.
5. The verified version is then used.

The user remains in control of the timing of software changes.

This is particularly important for a self-hosted Bitcoin system.

---

# Rule 9 — Human First

Every user-facing report should be understandable by someone who is
not a Linux expert.

Whenever possible, explain:

- what was checked
- what was found
- what the result means
- what the user can do next

The Family Node Kit is designed to educate,
not merely report.

---

# Rule 10 — Common Sense Before Cleverness

Prefer solutions that are:

- simple
- readable
- predictable
- testable
- easy to explain

over solutions that are clever but difficult to maintain.

If a solution is difficult to explain,
it should probably be simplified.

Future maintainability is more valuable than short-term cleverness.

---

# Rule 11 — Report Facts, Not Conclusions

The Family Node Kit reports what it observes.

It does not guarantee that a system is:

- completely secure
- completely safe
- error-free
- trustworthy

Instead, it reports independently verifiable facts and allows the
user to make the final decision.

Good:

    ✓ Fulcrum version matches the official release.

    ✓ Fulcrum image digest matches the expected image.

    ✓ Fulcrum container is running.

Avoid:

    "This node is completely secure."

    "This system is safe."

    "The software is trusted."

The Family Node Kit informs.

The user decides.

---

# Rule 12 — Runtime State and Health State Are Different

A component can be installed without currently running.

A component can also be running without necessarily being fully verified.

Therefore:

    Runtime State

and:

    Health / Verification State

are separate concepts.

For example:

    Fulcrum : STOPPED   🟡 Partially verified

does not mean that Fulcrum is uninstalled.

It means:

- the Fulcrum runtime container is not currently running
- the local Fulcrum installation can still be identified
- complete runtime verification cannot currently be performed

Similarly:

    Fulcrum : RUNNING   🟢 Verified

means that Fulcrum is running and the available verification checks
match the expected official release.

The Dashboard therefore intentionally displays both pieces of information.

---

# Rule 13 — RESET Removes Runtime, Not Data

The RESET operation is designed to reset the runtime environment
without deleting the important Bitcoin or Fulcrum data.

For Fulcrum, RESET may:

    remove the Fulcrum container

while preserving:

    ~/.fulcrum

and the locally installed versioned image.

After RESET, Fulcrum may therefore appear as:

    Fulcrum : STOPPED   🟡 Partially verified

This is expected.

The next normal start recreates the required runtime container.

Once Fulcrum is running again, full verification can be performed.

This distinction is important:

    STOPPED
        does not mean
    NOT INSTALLED

---

# Rule 14 — Versioned Fulcrum Images

The Family Node Kit uses versioned official Fulcrum container images.

For example:

    docker.io/cculianu/fulcrum:v2.1.2

The Kit does not rely on the mutable `latest` tag for normal
Fulcrum operation.

This provides a clearer relationship between:

- the installed software version
- the container image
- the verification process
- the official release

A versioned image can be identified locally even when the Fulcrum
container itself has been removed by RESET.

This is important because the runtime container and the installed
software image are different things.

---

# Rule 15 — Official Fulcrum Releases Only

When the Kit detects a newer Fulcrum release, it uses information
from the official Fulcrum project.

The update process identifies:

- official version
- official release
- official versioned container image
- expected image digest

The image is pulled and its identity is verified before the existing
Fulcrum container is replaced.

The update process therefore follows the principle:

    Detect
        ↓
    Inform
        ↓
    User decides
        ↓
    Pull official image
        ↓
    Verify image identity
        ↓
    Verify Fulcrum version
        ↓
    Replace runtime container

The existing container is not removed until the new image has passed
the required preparation and verification steps.

---

# Rule 16 — Personal Control of Updates

An available update does not mean that the user must install it
immediately.

The Kit deliberately gives the user the opportunity to review and
accept the update.

This is particularly important when the node is being used for
transactions or other time-sensitive wallet operations.

For example:

    If Sparrow is being used for a transaction,

    and a Fulcrum update is available,

    complete the current wallet operation first.

    The update can be declined and performed later.

This avoids introducing an unexpected indexing or restart operation
during an important wallet session.

A Fulcrum update may require re-indexing after the new version starts.
Depending on the system and database state, this can temporarily
increase CPU, storage and power consumption.

Personal verification and timing are therefore part of the update
decision.

---

# Rule 17 — Health Runtime

The Health Runtime translates component-specific information into
standardized Family Node Kit health statuses.

It does not directly perform the component-specific verification.

It does not install software.

It does not compare software versions itself.

It does not print user-facing reports.

It provides the stable interface between component-specific runtime
knowledge and the Health Report.

Standard statuses include:

| Status | Meaning |
| ----------------------- | --------------------------------------------------------------- |
| 🟢 Verified | Component matches the expected official state. |
| 🟡 Update available | Installed component is older than the official release. |
| 🟡 Newer version detected | Installed component is newer than the official release. |
| 🟡 Partially verified | Some information was verified, but complete verification is not currently possible. |
| 🔴 Not installed | Required local component is not present. |
| 🔴 Verification failed | Verification could not be completed because of an error. |

Each component may use different verification logic,
but the result is translated into this common health language.

---

# Rule 18 — Health Is Not the Same as Runtime

The Health Runtime must not treat:

    RUNNING

as automatically meaning:

    VERIFIED

and it must not treat:

    STOPPED

as automatically meaning:

    NOT INSTALLED

For example, after RESET:

    Fulcrum container:
        absent

    Fulcrum image:
        present

    Fulcrum data:
        preserved

    Runtime:
        STOPPED

    Health:
        🟡 Partially verified

After starting:

    Fulcrum container:
        running

    Runtime:
        RUNNING

    Version:
        detected

    Release:
        detected

    Image identity:
        verified

    Health:
        🟢 Verified

This separation prevents the Dashboard from confusing runtime state
with installation or verification state.

---

# Rule 19 — Stable Architecture

The Family Node Kit architecture is designed to outlive the software
it manages.

As Bitcoin, Fulcrum, Tor and future components evolve, changes should
affect component-specific libraries and commands whenever possible.

New components should integrate by adding their own:

- runtime library
- official information library
- verification command
- health translation

rather than changing the overall architecture.

The architecture, user interface and workflow should remain stable.

The best update is the one that preserves both:

    architecture

and:

    user experience

---

# Rule 20 — Independent Component Verification

Each major component should be independently verifiable.

For example:

    verify-bitcoin.sh

    verify-fulcrum.sh

    verify-tor.sh

These component verifiers may be executed individually.

The combined:

    verify-family-node.sh

provides the Family Node Kit Health Report by bringing those
component results together.

This allows a user to investigate a single component without
depending on the entire system.

---

# Health Report

The Family Node Kit Health Report summarizes the current state of
the major components.

Example:

    FAMILY NODE KIT HEALTH REPORT
    =================================

    Bitcoin node: Core v31.1.0

    =================================
    SUMMARY
    Bitcoin Node       🟢 Verified
    Fulcrum            🟢 Verified
    Tor                🟡 Partially verified

    ---------------------------------

    Overall Status

    🟢 No critical issues detected.

The summary is intentionally concise.

Detailed component reports follow when additional information is
required.

The Health Report is read-only.

It does not change the system.

---

# Verification Philosophy

The Family Node Kit does not attempt to create trust by hiding
complexity.

Instead, it attempts to make verification easier.

The user should be able to move from:

    "The Kit says this is verified."

to:

    "I can see why the Kit says this is verified."

and, where appropriate:

    "I can reproduce the important check myself."

This is the meaning of:

    Don't Trust. Verify.

---

# Golden Rule

If a user cannot independently verify a result,
the Family Node Kit should not present that result as an established fact.

Every important reported value should originate from:

- the local system
- an official project source
- or a clearly identified combination of both

The Health Report informs the user.

It never asks the user to blindly trust the software.

---

# Architecture in Brief

The Family Node Kit can be reduced to four simple ideas:

    system/bin/
        Do things.

    system/lib/
        Know things.

    dashboard/
        Ask for things.

    DOCUMENTATIONS/
        Explain things.

And:

    family-node
        Connects everything.

The Dashboard orchestrates.

The libraries know.

The verifiers explain.

The Health Runtime translates.

The Health Report summarizes.

The user decides.

---

# Architecture Motto

    Don't Trust. Verify.

The Family Node Kit exists to simplify the operation of a
self-hosted Bitcoin node while preserving the user's ability
to independently verify the important components.

Trust is never assumed.

Verification is always possible.
