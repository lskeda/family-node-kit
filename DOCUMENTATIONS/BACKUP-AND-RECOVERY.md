========================================
BACKUP AND RECOVERY
===================

Don't Trust. Verify.

Family Node Kit separates the operating system from
your Bitcoin data.

This makes backup and recovery simple.

If your operating system becomes damaged or you
replace your computer, Family Node Kit can be
reinstalled without downloading the Bitcoin
blockchain again.

Your Bitcoin data remains yours.

---

## What should be backed up?

Family Node Kit itself does not contain your Bitcoin
data.

The most important directories are:

```
~/.bitcoin
```

```
~/.fulcrum
```

If you use Sparrow Wallet, you may also wish to back up:

```
~/.sparrow
```

---

## What do these directories contain?

### ~/.bitcoin

Contains:

• Bitcoin blockchain
• Bitcoin configuration
• Blockchain indexes
• Other Bitcoin node data

### ~/.fulcrum

Contains:

• Fulcrum database
• Fulcrum configuration
• Electrum indexes

### ~/.sparrow

Contains:

• Sparrow wallet files
• Labels
• Application settings

Your recovery phrase remains your most important
backup.

Even if your Sparrow files are lost, your Bitcoin
can always be recovered using your recovery phrase.

---

## Hidden Folders

The folders used by Family Node Kit begin with a period (`.`).

For example:

```
~/.bitcoin
~/.fulcrum
~/.sparrow
```

On Linux, folders that begin with a period are **hidden** by default.

If you do not see these folders in your Home folder, they are probably hidden.

In Fedora's file manager, press:

```
Ctrl + H
```

to show or hide hidden files and folders.

You only need to do this once while copying or restoring your backup.

---

## Backing Up Your Data

The recommended backup method is simple.

1. Connect an external storage device with
   sufficient free space.

2. Copy the entire folder:

```
~/.bitcoin
```

to the external storage device.

3. Copy the entire folder:

```
~/.fulcrum
```

to the external storage device.

4. If you use Sparrow Wallet, also copy the entire folder:

```
~/.sparrow
```

Wait until all copies have completed before
disconnecting the drive.

No special backup software is required.

---

## Recovering Your Node

If you need to rebuild your system:

1. Install Fedora Silverblue.

2. Install Family Node Kit.

3. Connect the backup storage device.

4. Restore the entire folder:

```
~/.bitcoin
```

5. Restore the entire folder:

```
~/.fulcrum
```

6. If you use Sparrow Wallet, also restore the entire folder:

```
~/.sparrow
```

7. Start Family Node Kit.

The Dashboard will automatically use the restored
Bitcoin and Fulcrum data.

There is no need to download the blockchain or
rebuild the Fulcrum indexes again.

If the folders were restored correctly, Family Node Kit
can continue using the existing blockchain, Fulcrum data,
and Sparrow Wallet data.

This normally avoids downloading the blockchain again
and avoids rebuilding the Fulcrum indexes from scratch.

---

## What Does Not Need to Be Backed Up?

Family Node Kit can always be reinstalled from the
original release package.

Normally there is no need to back up:

• Family Node Kit
• Dashboard
• Scripts
• Libraries
• Documentation

These can always be restored by reinstalling the Kit.

---

## Recovery Philosophy

Family Node Kit treats software as replaceable.

Your Bitcoin data is not.

The Kit can always be reinstalled.

The blockchain and Fulcrum data can always be restored from backup.

Your recovery phrase remains your ultimate backup.

Family Node Kit helps protect your Bitcoin
infrastructure.

The responsibility for protecting your Bitcoin
always remains yours.

Don't Trust. Verify.

========================================
END OF DOCUMENT
===============
