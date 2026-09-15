
========================================
FAMILY NODE KIT
README FIRST
========================================

Family Node Kit helps individuals and families operate a Bitcoin node 
using official upstream software and clear, verifiable procedures. 
Rather than replacing existing Bitcoin projects, it brings them together 
into a single, consistent workflow focused on simplicity, transparency, and user control.

Welcome!

Thank you for choosing Family Node Kit.

Please read this document before installing or using the system.

This guide explains what Family Node Kit is, what it installs, what 
it does not manage, and how to begin the installation.

Additional topics such as download verification, backups, Tor, and wallet 
configuration are covered in their own documents.

---

1. WHY FAMILY NODE KIT?

---

Family Node Kit began as a personal toolkit created to help my own family 
use Bitcoin safely and independently.

Over time, it evolved into a collection of tools intended to help any family build 
confidence in self-custody by following clear, transparent, and verifiable procedures.

Family Node Kit is not a Bitcoin distribution.

It does not replace Bitcoin Core, Fulcrum, Tor, Sparrow Wallet, or Fedora Silverblue.

Instead, it orchestrates official upstream software into a workflow that 
is easy to install, operate, maintain, and recover.

The project follows a simple principle:

```
Don't Trust. Verify

```

2. WHAT THE KIT MANAGES

---

Family Node Kit manages:

• Bitcoin Core
• Fulcrum
• Tor

Including:

• Installation workflow
• Configuration
• Runtime management
• Health reporting
• Integrity verification
• Interaction between components

Family Node Kit manages the node infrastructure, while Sparrow remains a separate wallet application.

---

3. WHAT REMAINS YOUR RESPONSIBILITY

---

Family Node Kit never manages:

• Wallets
• Seeds
• Recovery phrases
• Passphrases
• Private keys
• Transaction signing
• Spending decisions

These always remain under your direct control.

---

4. THE DASHBOARD — YOUR COCKPIT

---

Think of Family Node Kit as the cockpit of your Bitcoin node.

It provides the instruments, controls, verification tools, and 
health reports needed to operate your Bitcoin node with confidence.

Like the pilot of an aircraft, you remain responsible for the 
decisions you make and for the security of your system.

The Kit provides visibility and control.

You remain responsible for your Bitcoin.

---

5. DESIGN PRINCIPLES

---

Family Node Kit follows five simple principles.

• Use official upstream software.
• Verify before installing or updating.
• Keep user data separate from the Kit.
• Never touch wallets or private keys.
• Keep the user in control.

---

6. SYSTEM REQUIREMENTS

Required

• Fedora Silverblue
• Podman (included with Fedora Silverblue)
• Internet connection

Recommended

• 2 TB SSD
• Broadband Internet connection

Bitcoin Core and Fulcrum require significant disk space.

The initial blockchain and index synchronization may take many hours or 
several days depending on your hardware and Internet connection.
This is normal and only happens during the initial setup.

---

7. BEFORE YOU BEGIN

---

Before running the installer, download the required Bitcoin Core
release files from the official Bitcoin Core website.

Place the downloaded files inside:

    ~/Downloads/bitcoin-verify/

The SHA256 checksum file provided by Bitcoin Core is named:

    SHA256SUMS

Do not modify its contents.

The installer verifies the downloaded Bitcoin Core files against
the official SHA256 checksums before installation.

If you are unfamiliar with SHA256 checksums or GPG signatures,
read:

    GPG-VERIFYING-DOWNLOADS.md

before installing Bitcoin Core.

---

8. INSTALLATION

---

Extract the Family Node Kit package.

Open the extracted folder.

Open **Console** (called **Terminal** in many Linux distributions).

Run the installer:

bash install.sh

The installer guides you through each step and reports its progress 
as it works.

---

9. AFTER INSTALLATION

---

When installation finishes, launch:

```
Family Node Dashboard
```

from your desktop or application menu.

The Dashboard becomes the central control point for operating and 
monitoring your Bitcoin node.

---

10. ADDITIONAL DOCUMENTATION

---

The following documents are included with Family Node Kit.

- START HERE.txt

DOCUMENTATIONS/
├── ARCHITECTURE.md
├── UPDATE-BITCOIN-CORE.md
├── FULCRUM-MANAGEMENT.md
├── USING-SPARROW.md
├── DASHBOARD-USER-GUIDE.md
├── GPG-VERIFYING-DOWNLOADS.md
├── BACKUP-AND-RECOVERY.md
├── FEDORA-SILVERBLUE.md
├── UNINSTALL.md
└── CHANGELOG.md

START HERE.txt provides a short introduction and points to
README-FIRST.txt.

ARCHITECTURE.md explains how the Family Node Kit is structured
and why the different components are separated.

UPDATE-BITCOIN-CORE.md provides the step-by-step procedure to upgrade Bitcoin Core to a new release using Family Node Kit.

FULCRUM-MANAGEMENT.md explains how Fulcrum is installed, managed,
updated, and verified.

USING-SPARROW.md explains how Sparrow Wallet is used with the
node.

DASHBOARD-USER-GUIDE.md explains Dashboard operation and management.

GPG-VERIFYING-DOWNLOADS.md explains how to independently verify
software downloads.

BACKUP-AND-RECOVERY.md explains how to protect and recover
Bitcoin node data.

FEDORA-SILVERBLUE.md explains the operating system environment
used by Family Node Kit.

UNINSTALL.md explains how to safely remove Family Node Kit.

CHANGELOG.md records important changes to the project.

---

========================================
INSTALLATION NEXT STEP
========================================

Inside the extracted "family-node-kit" folder:

1. Double-click an empty area.

2. Choose **Open Console**
   (called **Terminal** on many Linux systems).

3. Run the installer:

    bash install.sh

Then follow the on-screen instructions.

Enjoy your Bitcoin journey.

========================================
END OF README
========================================
