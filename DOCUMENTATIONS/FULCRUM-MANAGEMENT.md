# FULCRUM MANAGEMENT

## Official Releases • Verification • Updates • Container Isolation
---

> **Don't Trust. Verify.**

The Family Node Kit manages Fulcrum using a controlled process designed
to separate:

    DETECTION
        ↓
    PERSONAL REVIEW
        ↓
    VERIFICATION
        ↓
    INSTALLATION
        ↓
    FINAL VERIFICATION

The Kit does not blindly install every new version that becomes available.

---

# 1. FULCRUM IN THE FAMILY NODE KIT

Fulcrum is the Electrum server used by the Family Node Kit.

It runs inside a Podman container while its persistent data remains
outside the container.

                 FAMILY NODE KIT
                        │
          ┌─────────────┴─────────────┐
          │                           │
        Bitcoin                     Podman
                                      │
                                      ▼
                                    Fulcrum
                                      │
                                      ▼
                                 ~/.fulcrum

This separates the Fulcrum runtime environment from its persistent data.

Containerization provides an additional runtime isolation layer.

It should not be confused with network anonymity.

Network privacy depends on the network configuration, such as the
Tor configuration used by the node.

---

# 2. FIRST INSTALLATION

When Fulcrum is not installed, the Kit obtains information about the
current official Fulcrum release.

For example:

    Official version : 2.1.2
    Release          : 6c9f074
    Image            : docker.io/cculianu/fulcrum:v2.1.2
    Digest           : sha256:2bd6ba96...

The Kit uses the versioned official container image.

It does not simply choose an arbitrary image.

The image is pulled and its identity is verified before it becomes the
active Fulcrum container.

                    OFFICIAL RELEASE
                           │
                           ▼
              docker.io/cculianu/fulcrum:v2.1.2
                           │
                           ▼
                    VERIFY IMAGE
                           │
                           ▼
                    START FULCRUM

Only after verification does the image become the active Fulcrum
container.

---

# 3. DETECTING A NEW RELEASE

Every time the Kit evaluates Fulcrum, it compares the installed version
with the current official version.

Example:

    Installed Fulcrum : 2.1.1
    Official Fulcrum  : 2.1.2

The Kit reports:

    🟡 A newer official Fulcrum release is available.

IMPORTANT:

The first detection does NOT automatically update Fulcrum.

The Kit records that the release has been detected and allows the
currently installed version to continue running.

                    2.1.1 INSTALLED
                           │
                           ▼
                    2.1.2 DETECTED
                           │
                           ▼
                   🟡 NOTIFICATION
                           │
                           ▼
                    KEEP 2.1.1

This is intentional.

---

# 4. WHY WAIT FOR PERSONAL VERIFICATION?

A new official release is not automatically a reason to replace a
working installation immediately.

The first detection gives the user an opportunity to:

    • Review the new release
    • Understand what changed
    • Decide whether to update
    • Continue using the current version if preferred

On a subsequent detection of the same release, the Kit asks:

    Update Fulcrum now? [Y/N]:

This creates a deliberate separation:

    AUTOMATIC DETECTION
            ↓
    PERSONAL DECISION
            ↓
    TECHNICAL VERIFICATION
            ↓
    INSTALLATION

The computer detects.

The user decides.

The Kit verifies.

---

# 5. SELECTING THE OFFICIAL RELEASE

When an update is selected, the Kit identifies the official target.

Example:

    Version : 2.1.2
    Release : 6c9f074
    Image   : docker.io/cculianu/fulcrum:v2.1.2
    Digest  : sha256:2bd6ba96...

The update target is a specific, versioned official release.

This makes the update target explicit and independently identifiable.

---

# 6. IMAGE VERIFICATION

The official image is pulled before the existing Fulcrum container
is removed.

The Kit then compares the image digest.

Example:

    Pulled digest:
    sha256:2bd6ba96...

    Official digest:
    sha256:2bd6ba96...

    ✔ Image digest matches the official AMD64 image.

If the digest does not match:

    ❌ IMAGE VERIFICATION FAILED

The existing Fulcrum installation is not replaced.

The principle is:

> **Verify first. Replace second.**

---

# 7. STAGED CONTAINER VERIFICATION

The verified image is first started as a temporary container:

    fulcrum-update

The existing Fulcrum container remains in place.

The Kit then verifies:

    1. Container image identity
    2. Fulcrum version
    3. Fulcrum release

Example:

    Expected:
      2.1.2 / 6c9f074

    Detected:
      2.1.2 / 6c9f074

    ✔ Fulcrum version verified

Only after these checks succeed does the Kit proceed with the replacement.

---

# 8. REPLACEMENT

The update sequence is:

             EXISTING FULCRUM
                    │
                    │
                    ▼
             PULL OFFICIAL IMAGE
                    │
                    ▼
              VERIFY DIGEST
                    │
                    ▼
          CREATE TEMPORARY CONTAINER
                    │
                    ▼
          VERIFY VERSION + RELEASE
                    │
                    ▼
             REMOVE OLD CONTAINER
                    │
                    ▼
          PROMOTE VERIFIED CONTAINER
                    │
                    ▼
             NEW FULCRUM RUNNING

The important principle:

> **Verification happens before replacement.**

The Fulcrum data directory is not deleted as part of the update.

The container is replaced; the persistent Fulcrum data remains in:

    ~/.fulcrum

---

# 9. NORMAL STARTING

The Kit distinguishes between three different situations:

    1. Fulcrum is already running
    2. Fulcrum exists but is stopped
    3. Fulcrum does not exist

Therefore, starting the node does not blindly attempt to create a second
container with the same name.

                FULCRUM
                   │
          ┌────────┴────────┐
          │                 │
        RUNNING           STOPPED
          │                 │
          ▼                 ▼
        KEEP RUNNING      START EXISTING
                            │
                            │
                    container does not exist
                            │
                            ▼
                        CREATE NEW

This allows the Kit to safely resume an existing Fulcrum container.

---

# 10. FULCRUM INDEXING AFTER AN UPDATE

A successful update does not necessarily mean that Fulcrum is
immediately ready to serve Electrum requests.

After an update, Fulcrum may need to inspect or re-index its database.

During this period:

    • CPU usage may increase
    • Disk activity may increase
    • Power consumption may increase
    • Port 50001 may not yet be available
    • Fulcrum may take some time before becoming ready

This is not necessarily an error.

The Kit therefore reports:

    ⚠ Fulcrum is still indexing

and allows the process to continue in the background.

Port 50001 becomes available when Fulcrum has completed the necessary
indexing work.

---

# 11. RECOMMENDED PRACTICES

## 11.1 Choose the right time to update

A new official release does not mean that you must install it immediately.

If you are currently using the node for transactions, especially with
Sparrow Wallet, it is recommended to finish your work before installing
a Fulcrum update.

For example:

    Using Sparrow / performing transactions
                    │
                   YES
                    │
                    ▼
             Do NOT update yet
                    │
                    ▼
              Finish your work
                    │
                    ▼
             Finish / close Sparrow
                    │
                    ▼
             Update Fulcrum later

Simply answer:

    Update Fulcrum now? [Y/N]: N

There is no problem with waiting.

The currently installed Fulcrum version remains available.

---

## 11.2 Review before you update

When the Kit detects a new official release, take a moment before
selecting Y.

The purpose of the first detection is to give you time to personally
acknowledge the update.

You may want to:

    • Review the official release
    • Understand what changed
    • Consider whether you need the update now
    • Decide when you have enough time for possible indexing

The Kit does not make that decision for you.

---

## 11.3 Allow time for possible re-indexing

An update may require Fulcrum to perform additional database work.

This can temporarily cause:

    CPU usage        ↑
    Disk activity    ↑
    Power usage      ↑

The duration can vary.

Therefore, do not start a Fulcrum update immediately before you need
the node for an important transaction or other time-sensitive activity.

Choose a moment when the node can remain working without interruption.

---

## 11.4 Remember: VERIFIED ≠ INSTALL NOW

A verified update means:

    The release passed the Kit's verification checks.

It does NOT mean:

    You must install it immediately.

The user still decides when the update is appropriate.

> **Verification tells you that an update is valid.**
>
> **It does not tell you that now is the right time to install it.**

---

# 12. FINAL VERIFICATION

After installation or update, the Family Node Kit can independently
inspect the running Fulcrum container.

Example:

    Image:
      docker.io/cculianu/fulcrum:v2.1.2

    Version:
      2.1.2

    Release:
      6c9f074

    Digest:
      sha256:2bd6ba96...

    Official:
      2.1.2
      6c9f074

    Verification Status:

      🟢 VERIFIED

This verification is read-only.

No changes are made to the system.

---

# 13. THE COMPLETE MODEL

                 OFFICIAL FULCRUM
                       │
                       ▼
               🟡 DETECT UPDATE
                       │
                       ▼
               PERSONAL REVIEW
                       │
                 ┌─────┴─────┐
                 │           │
                 N           Y
                 │           │
                 ▼           ▼
                KEEP      PULL IMAGE
                             │
                             ▼
                       VERIFY DIGEST
                             │
                             ▼
                      STAGED CONTAINER
                             │
                             ▼
                      VERIFY VERSION
                       + RELEASE
                             │
                             ▼
                     REPLACE CONTAINER
                             │
                             ▼
                       🟢 VERIFIED

---

# 14. WHY THIS DESIGN?

The Family Node Kit follows several principles.

### Official source

The update target is derived from the official Fulcrum release.

### Explicit version

The update identifies a specific versioned release.

### Personal decision

The first detection does not force an update.

### Image verification

The container image digest is checked before replacement.

### Staged verification

The new container is tested before becoming the active container.

### Data separation

Fulcrum's persistent data remains outside the container.

### Container isolation

Fulcrum runs inside its own Podman container, adding another layer of
runtime separation.

### Read-only verification

The verification tools inspect the system without modifying it.

### Appropriate timing

The user can choose when an update is convenient and safe for their
current activity.

---

# 15. THE FAMILY NODE KIT PHILOSOPHY

The goal is not to make the computer decide everything automatically.

The goal is to make the important decisions:

    visible
    understandable
    verifiable

The Kit can detect a new release.

The user can review it.

The Kit can verify what was downloaded.

The user can decide when to install it.

Only then is the running installation replaced.

---

        THE COMPUTER DETECTS.
             THE USER DECIDES.
                THE KIT VERIFIES.

---

# DON'T TRUST. VERIFY.
