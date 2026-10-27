
===================
BACKUP AND RECOVERY
===================

Don't Trust. Verify.

Family Node Kit separates the operating system from your Bitcoin data.

This makes backup and recovery simpler.

If your operating system becomes damaged or you replace your computer,
Family Node Kit can be reinstalled without downloading the Bitcoin
blockchain again, provided your backup is complete and usable.

Your Bitcoin data remains yours.

------------------------------------------------------------------------

## What should be backed up?

Family Node Kit itself does not contain your Bitcoin blockchain data.

The most important directories are:

    ~/.bitcoin
    ~/.fulcrum

If you use Sparrow Wallet, you may also wish to back up:

    ~/.sparrow

If you use Wasabi Wallet, back up its wallet data:

    ~/.walletwasabi/client/Wallets

This folder contains Wasabi wallet files and can include address labels
and other sensitive wallet metadata.

If you use the Kit's Tor service and want to preserve its existing
onion-service identity, back up:

    ~/.tor-electrum

Treat this directory as sensitive because it may contain Tor
configuration or onion-service identity data.

The Kit's RPC credentials are stored separately in:

    ~/.family-node-kit/env/rpc.env

This file contains the current RPC username and password. Back it up
only if you specifically need to preserve those credentials, and protect
it as a secret. It is not normally required for recovery because Family
Node Kit can generate new RPC credentials when needed.

------------------------------------------------------------------------

## What do these directories contain?

### \~/.bitcoin

Contains:

-   Bitcoin blockchain data
-   Bitcoin configuration, including `bitcoin.conf`
-   Blockchain indexes
-   Other Bitcoin node data

IMPORTANT: `bitcoin.conf` may contain RPC credentials. Protect this
backup as sensitive information.

### \~/.fulcrum

Contains:

-   Fulcrum database
-   Fulcrum configuration
-   Electrum indexes

### \~/.sparrow

Contains:

-   Sparrow wallet files
-   Labels
-   Application settings

### \~/.walletwasabi/client/Wallets

Contains Wasabi wallet files. These files may include address labels and
other metadata that can reveal links between wallet activity.

Wasabi wallet files are sensitive. Store backups securely, preferably on
encrypted storage. Back up any wallet passphrase separately.

### \~/.tor-electrum

Contains data used by the Kit's Tor service. Depending on the current
setup, it may include information needed to preserve the existing
onion-service identity.

Back up this directory only if you want to preserve that identity and
its related configuration. Keep the backup private because onion-service
keys are sensitive.

### Wallet recovery information

Your wallet recovery phrase and any required passphrase remain critical
recovery information. Keep them backed up independently of the computer
and separate from ordinary data backups.

A recovery phrase may restore wallet access, but it may not restore
labels, wallet metadata, or every application setting.

------------------------------------------------------------------------

## Hidden Folders

The folders used by Family Node Kit begin with a period (`.`).

For example:

    ~/.bitcoin
    ~/.fulcrum
    ~/.sparrow
    ~/.walletwasabi
    ~/.tor-electrum
    ~/.family-node-kit

On Linux, folders that begin with a period are hidden by default.

If you do not see these folders in your Home folder, they are probably
hidden.

In Fedora's file manager, press:

    Ctrl + H

to show or hide hidden files and folders.

You only need to do this while copying or restoring your backup.

------------------------------------------------------------------------

## Backing Up Your Data

The recommended backup method is simple.

1.  Connect an external storage device with sufficient free space.

2.  For the most consistent backup, stop Bitcoin and Fulcrum cleanly
    using the Dashboard's `STOP) Stop Bitcoin Services` option before
    copying their data. Close Sparrow and Wasabi before copying their
    wallet data. Stop Tor before copying its data if you want to
    preserve its current state.

3.  Copy the entire folder:

        ~/.bitcoin

4.  Copy the entire folder:

        ~/.fulcrum

5.  If you use Sparrow Wallet, copy the entire folder:

        ~/.sparrow

6.  If you use Wasabi and want to preserve its wallet files and labels,
    copy:

        ~/.walletwasabi/client/Wallets

7.  If you want to preserve the Kit's Tor data and existing
    onion-service identity, copy:

        ~/.tor-electrum

8.  If you specifically need to preserve the current RPC credentials,
    copy `~/.family-node-kit/env/rpc.env` to secure storage. Treat it as
    a secret. Do not place it in an unencrypted or shared location.

Wait until all copies have completed before disconnecting the drive.

Verify that the copied folders exist and that you can access their
contents. Keep sensitive backups secure. An encrypted external drive is
recommended for wallet files, RPC credentials, and Tor identity data.

No special backup software is required, but make sure the storage device
has enough free space for the data being copied.

------------------------------------------------------------------------

## Recovering Your Node

If you need to rebuild your system:

1.  Install Fedora Silverblue.

2.  Install Family Node Kit.

3.  Connect the backup storage device.

4.  Restore the entire folder:

        ~/.bitcoin

5.  Restore the entire folder:

        ~/.fulcrum

6.  If you use Sparrow Wallet, restore:

        ~/.sparrow

7.  If you use Wasabi and backed up its wallet files, restore the
    `Wallets` folder to:

        ~/.walletwasabi/client/Wallets

8.  If you backed up the Kit's Tor data and want to preserve the
    existing onion-service identity, restore:

        ~/.tor-electrum

9.  Start Family Node Kit and run:

        KIT) Family Node Kit Health Report

10. Confirm the services are healthy before using a connected wallet.

Family Node Kit can use restored Bitcoin and Fulcrum data when the
backups are complete and compatible. This can avoid downloading the
blockchain again and rebuilding Fulcrum indexes from scratch.

However, recovery may still require verification, synchronization, index
updates, or rebuilding if the backup was incomplete, inconsistent, or
made while files were changing.

If you did not back up `~/.family-node-kit/env/rpc.env`, the Kit may
generate new RPC credentials. Applications that store the old
credentials, including Wasabi, may then need to be reconfigured.

If you restored Wasabi wallet files, open Wasabi and confirm that the
wallet appears and can be opened. If you did not back up the wallet
file, recovery may still be possible using the wallet's recovery words
and required passphrase, but labels and other metadata may not be
restored.

If you restored `~/.tor-electrum`, verify the Tor service and onion
address before relying on the previous onion-service identity.

------------------------------------------------------------------------

## What Does Not Need to Be Backed Up?

Family Node Kit itself can be reinstalled from the original release
package or another trusted copy of the release.

Normally there is no need to back up:

-   Family Node Kit program files
-   Dashboard
-   Scripts
-   Libraries
-   Documentation

These can be restored by reinstalling the Kit.

The Wasabi AppImage is also replaceable. If desired, you may keep a copy
of the verified application and its signature file, for example:

    ~/Apps/Wasabi/Wasabi-2.8.3.AppImage
    ~/Apps/Wasabi/Wasabi-2.8.3.AppImage.asc

You can download Wasabi again from its official source, but always
verify the release before running it. The application file is not a
substitute for backing up Wasabi wallet data.

------------------------------------------------------------------------

## Recovery Philosophy

Family Node Kit treats software as replaceable.

Your Bitcoin data and wallet recovery information are not.

The Kit can be reinstalled.

Bitcoin blockchain data, Fulcrum indexes, wallet metadata, and Tor
identity data can be restored only if the relevant data was backed up
correctly and the backup remains usable.

Your recovery phrase and any required wallet passphrase remain critical
recovery information.

Family Node Kit helps protect your Bitcoin infrastructure.

The responsibility for protecting your Bitcoin and sensitive backup data
always remains yours.

Don't Trust. Verify.

===============
END OF DOCUMENT
===============
