========================================
FEDORA SILVERBLUE
AND FAMILY NODE KIT
========================================

Don't Trust. Verify.

## 1. Why Fedora Silverblue?

Family Node Kit is designed to work with Fedora Silverblue.

Silverblue is different from a traditional Linux desktop.

Instead of treating the operating system as a collection of
individual packages that are continuously modified, Silverblue
uses an image-based operating system model.

This provides several characteristics that are particularly useful
for a self-hosted Bitcoin environment:

• Atomic system updates
• Rollback to a previous system deployment
• Separation between the operating system and user data
• Application isolation through Flatpak and containers
• A predictable base system
• Easy recovery after an operating system problem

These characteristics complement the design philosophy of
Family Node Kit.

The Kit manages the Bitcoin infrastructure.

Silverblue provides a stable and recoverable operating system
underneath it.

## 2. Installation recommendations

Family Node Kit is designed around a dedicated Bitcoin node
computer with sufficient storage for the operating system,
Bitcoin blockchain, Fulcrum database, and future growth.

### The 2 TB SSD is not just for Fedora.

Fedora Silverblue, Bitcoin Core's blockchain, Fulcrum's database, and the other node data all share this storage. Bitcoin Core and Fulcrum will consume most of the available space over time, so the recommended installation uses the entire 2 TB SSD rather than reserving a large unused portion of it.

The Bitcoin data remains separate from the Family Node Kit
software, even though it resides on the same encrypted SSD.

### Enable disk encryption (LUKS)

During Fedora Silverblue installation, enable disk encryption
for the main SSD.

Choose a strong disk-encryption password (passphrase) that you can remember and safely store.

This password is used to unlock the encrypted SSD when the computer starts.

It is important to understand the difference:

• The disk-encryption password protects the computer's stored data.

• Your Bitcoin recovery phrase protects access to your Bitcoin.

• The Family Node Kit does not manage either one.

Never use your Bitcoin recovery phrase as your disk-encryption
password.

Never use the disk-encryption password as your Bitcoin wallet
password.

Keep your passwords and recovery information secure and separate.

### Why encryption matters

A Bitcoin node contains valuable information even when the
wallet itself is not stored on the node.

The computer may contain:

• Bitcoin blockchain data
• Fulcrum databases
• Configuration files
• Wallet application data
• Personal information

Full-disk encryption helps protect this information if the
computer or its SSD is lost or physically accessed by someone
else.

The encryption protects the storage while the computer is
powered off.

It does not replace normal account security, wallet security,
or backups.

## 3. Why this is useful for a Bitcoin node

A Bitcoin node contains important data.

The blockchain can occupy a very large amount of storage,
and Fulcrum maintains its own database and indexes.

We therefore want to avoid tying this data unnecessarily
to the operating system.

Family Node Kit keeps the important Bitcoin data in the
user's home directory:

~/.bitcoin
~/.fulcrum

The operating system can therefore be replaced or rolled back
without treating the blockchain as part of the operating-system
installation.

This is one of the reasons Silverblue is a good match for
Family Node Kit.

## 4. The three layers

It is useful to think of the system as three separate layers.

┌─────────────────────────────────────┐
│       USER / BITCOIN DATA           │
│                                     │
│  ~/.bitcoin                         │
│  ~/.fulcrum                         │
│  ~/.sparrow                         │
└─────────────────────────────────────┘
                  │
                  │
┌─────────────────────────────────────┐
│       FAMILY NODE KIT               │
│                                     │
│  Dashboard                          │
│  Bitcoin Core                       │
│  Fulcrum                            │
│  Tor                                │
│  Verification                       │
└─────────────────────────────────────┘
                  │
                  │
┌─────────────────────────────────────┐
│       FEDORA SILVERBLUE             │
│                                     │
│  Operating system                   │
│  Atomic updates                     │
│  Rollback                           │
│  Containers / Flatpak               │
└─────────────────────────────────────┘

Each layer has a different responsibility.

Silverblue provides the operating system.

Family Node Kit manages the Bitcoin infrastructure.

Your Bitcoin data remains yours.

## 5. Atomic updates

One of the important differences from traditional Fedora
installations is the way Silverblue updates the operating system.

Instead of changing the currently running system piece by piece,
Silverblue prepares a new system deployment.

The new deployment becomes active after reboot.

This means that an operating-system update can be treated as
a complete, identifiable system state.

For the Family Node Kit user, the important idea is simple:

Update → reboot → verify.

The Bitcoin data is not supposed to be part of the operating-system
deployment.

## 6. Rollback

One of Silverblue's most useful features is rollback.

If an operating-system update causes a problem, Silverblue can
boot the previous deployment.
To see the current deployments:

rpm-ostree status

To roll back to the previous deployment:

rpm-ostree rollback

A rollback changes the operating-system deployment.

It does not mean that your Bitcoin blockchain is deleted.

This is another reason to keep the operating system and Bitcoin
data separate.

## 7. What Family Node Kit uses from Silverblue

Family Node Kit relies on several characteristics of Silverblue.

Immutable operating system

The base operating system is managed as an image rather than
being continuously modified by ordinary package installation.

Containers

Family Node Kit uses Podman for containerized components such
as Fulcrum and Tor.

User data

Bitcoin data is kept outside the Family Node Kit installation:

~/.bitcoin
~/.fulcrum

Recovery

If the operating system must be reinstalled, the Kit can be
installed again and the Bitcoin data restored from backup.

## 8. Podman

Family Node Kit uses Podman rather than requiring Docker.

For the normal user, there is very little to learn.

Family Node Kit starts and manages the required containers.

You normally do not need to manually create containers.

If you want to see the containers currently running:

podman ps

This can be useful when troubleshooting.

The Family Node Dashboard remains the normal interface.

## 9. Flatpak

Silverblue is designed to work well with Flatpak applications.

This is useful for desktop applications because applications can
be installed separately from the base operating system.

For Family Node Kit, this means that desktop applications and
the operating system do not have to be treated as one large
installation.

For example, Sparrow Wallet remains separate from the Bitcoin
node infrastructure.

You normally do not need to manage Flatpak manually for normal
Family Node Kit operation.

## 10. Updating Silverblue

For normal maintenance, check the system status:

rpm-ostree status

Check for available operating-system updates:

rpm-ostree upgrade --check

Install the update:

rpm-ostree upgrade

Then reboot when requested.

After reboot:

Start the Family Node Dashboard.
Select KIT.
Review the Health Report.
Confirm that Bitcoin Core, Fulcrum and Tor report the
expected status.

The Family Node Kit Health Report should be treated as the
final operational check after an operating-system update.

## 11. Do not confuse OS updates with Bitcoin updates

This distinction is important.

A Fedora Silverblue update is an operating-system update.

A Bitcoin Core update is a Bitcoin software update.

They are separate operations.

Updating Silverblue does not automatically mean that Bitcoin Core
has been updated.

Likewise, installing a new Bitcoin Core release does not require
replacing the Silverblue operating system.

Family Node Kit keeps these responsibilities separate.

## 12. What the user should normally do

For everyday use, you do not need to become a Silverblue expert.

The normal workflow is:

Start computer
     ↓
Fedora Silverblue
     ↓
Family Node Dashboard
     ↓
KIT — Health Report
     ↓
Check Bitcoin Core
Check Fulcrum
Check Tor
     ↓
Operate the node

For normal maintenance:

Silverblue update
       ↓
Reboot
       ↓
Family Node Health Report
       ↓
Verify

## 13. If something goes wrong

Do not immediately delete Bitcoin data.

Do not immediately reinstall the blockchain.

First determine which layer has the problem.

Operating system problem

Check:

rpm-ostree status

Consider rolling back the Silverblue deployment if appropriate.

Family Node Kit problem

Run the Family Node Health Report:

KIT

Bitcoin Core problem

Run KIT and review the Bitcoin verification information.

Fulcrum problem

Run KIT and review the Fulcrum status and verification
information.

Data problem

Use:

BACKUP-AND-RECOVERY.md

Do not delete:

~/.bitcoin
~/.fulcrum

unless you have deliberately decided that the data is no longer
needed.

## 14. The Silverblue philosophy and Family Node Kit

Silverblue and Family Node Kit share an important idea:

Keep responsibilities separate.

Silverblue manages the operating system.

Podman manages containers.

Family Node Kit manages the Bitcoin infrastructure.

Your wallet manages your keys.

You manage your Bitcoin.

No single component should silently take responsibility for
everything.

This makes the system easier to understand, verify and recover.

## 15. The important commands

For a Family Node Kit user, these are usually enough:

Check Silverblue status:

rpm-ostree status

Check for updates:

rpm-ostree upgrade --check

Update Silverblue:

rpm-ostree upgrade

Roll back the previous deployment:

rpm-ostree rollback

See running containers:

podman ps

Everything else should normally be handled through the
Family Node Dashboard.

## 16. What you do NOT need to learn

You do not need to learn the entire Silverblue architecture
before using Family Node Kit.

You do not normally need to:

• modify the Silverblue base image
• manually manage OSTree deployments
• manually create Bitcoin containers
• manually modify Bitcoin data
• install random system packages
• change the immutable operating system to make the Kit work

The goal of this document is not to turn you into a Silverblue
administrator.

It is simply to explain why Silverblue is part of the system and
how its most important features affect your Bitcoin node.

## 17. Recovery

If the Silverblue operating system becomes unusable, the recovery
principle is simple:

Reinstall Fedora Silverblue
        ↓
Install Family Node Kit
        ↓
Restore Bitcoin data
        ↓
Start Dashboard
        ↓
Verify

See:

BACKUP-AND-RECOVERY.md

for the complete procedure.

The operating system is replaceable.

The Family Node Kit is replaceable.

Your Bitcoin data and recovery phrase are not.

### Final principle

Fedora Silverblue gives Family Node Kit a stable and recoverable
foundation.

Family Node Kit adds verification, transparency and simple
operation of the Bitcoin infrastructure.

Together they provide a system where:

The OS can be replaced.
The Kit can be reinstalled.
The node data can be restored.
The software can be verified.
The user remains in control.

Don't Trust. Verify.

========================================
END OF DOCUMENT
