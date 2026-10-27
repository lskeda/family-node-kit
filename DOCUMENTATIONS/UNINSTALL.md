==========
UNINSTALL
==========

Don't Trust. Verify.

This document explains how to remove Family Node Kit
from your computer without deleting your Bitcoin data.

Family Node Kit separates the software used to operate
your node from the Bitcoin data stored in your home
directory.

Uninstalling the Kit does not delete your blockchain,
Fulcrum database, or wallet data.

---

## What the uninstall process removes

The Family Node Kit uninstall utility removes:

• Family Node Kit
• Bitcoin Core program
• Fulcrum container
• Tor container
• Fulcrum container image
• Tor container image
• Tor configuration
• Family Node Dashboard launcher

It also removes the Kit's local configuration directories:

~/.family-node-kit

and

~/.family-node


The Bitcoin Core program itself is installed separately in:

~/bitcoin

and is removed during uninstall.

---

## What the uninstall process preserves

The following are deliberately NOT removed:

~/.bitcoin

This contains your Bitcoin blockchain, configuration,
and indexes.

~/.fulcrum

This contains your Fulcrum database, configuration,
and Electrum indexes.

Wallet data is not deliberately removed by the
uninstall process.

Your Bitcoin data therefore remains available for
future recovery or reinstallation.

---

## Before uninstalling

If you may want to use the node again in the future,
make sure you have a current backup.

Read:

`BACKUP-AND-RECOVERY.md`

In particular, verify that you have safely backed up:

**Bitcoin node and indexer data**

- `~/.bitcoin`
- `~/.fulcrum`

**Wallet data, if applicable**

- `~/.sparrow`
- `~/.walletwasabi/client`

**Tor data, if applicable**

- `~/.tor-electrum`

Back up the Tor data if you want to preserve the existing onion-service identity. Protect any private keys contained in this directory.

**Wasabi application (optional)**

- `~/Apps/Wasabi/Wasabi-2.8.3.AppImage`
- `~/Apps/Wasabi/Wasabi-2.8.3.AppImage.asc`

The Wasabi application can be downloaded again from its official source. Always verify the downloaded release before running it.

**Important security notes**

- The `~/.bitcoin` backup includes `bitcoin.conf`, which may contain RPC credentials.
- `~/.family-node-kit/env/rpc.env` also contains RPC credentials. Back it up only if you specifically need to preserve the current credentials, and protect it as a secret. The Kit can generate new credentials when necessary.
- Wasabi wallet files and transaction labels contain sensitive financial and privacy-related information. Store backups securely, preferably on encrypted storage.
- Never include RPC credentials, wallet recovery phrases, or wallet passphrases in public repositories or documentation.

Your wallet recovery phrase and any required wallet passphrase must always be backed up independently of the computer.

**Before removing anything, verify that your backups exist and are readable.**

---

## How to uninstall

Open the Family Node Kit directory:

~/family-node-kit

Run:

bash ~/family-node-kit/tools/uninstall-family-node-kit.sh

The uninstall utility will clearly display what it
will remove and what it will preserve.

You must type:

UNINSTALL

to confirm the operation.

Any other response aborts the uninstall.

---

## What happens during uninstall?

The process performs these operations:

1. Stops the Bitcoin services.

2. Removes the Fulcrum and Tor containers.

3. Removes the Fulcrum and Tor container images.

4. Removes the Bitcoin Core program.

5. Removes Family Node Kit and its local configuration.

6. Removes the Tor Electrum data.

7. Removes the Family Node Dashboard launcher.

The Bitcoin data directories are deliberately left untouched.

---

## After uninstall

The following should still exist:

~/.bitcoin
~/.fulcrum

The Family Node Kit software itself will no longer be installed.

If you later install Family Node Kit again and restore or
reuse these directories, the existing Bitcoin and Fulcrum
data can be used instead of starting from an empty node.

---

## Important distinction

Uninstalling Family Node Kit is not the same as deleting
your Bitcoin data.

The Kit is software.

Your blockchain and Fulcrum database are data.

The uninstall process is designed to remove the software
while preserving the data.

Do not manually delete:

~/.bitcoin
~/.fulcrum

unless you have deliberately decided that the data is no
longer needed and have verified that you have the backups
you require.

---

## If you want to completely remove the node

If your intention is to permanently remove everything,
including the blockchain and Fulcrum database, do not
assume that the uninstall utility does this for you.

The uninstall utility deliberately preserves those
directories.

Only delete them after you have:

• confirmed that you no longer need the data
• verified your backups
• secured your wallet recovery information
• understood that the blockchain and Fulcrum database
  would need to be downloaded/rebuilt if required again

---

## The principle

Family Node Kit follows a simple rule:

Software can be replaced.

Data should be preserved.

The uninstall process therefore removes the Kit and its
supporting software while leaving your Bitcoin data under
your control.

Don't Trust. Verify.

===============
END OF DOCUMENT
===============
