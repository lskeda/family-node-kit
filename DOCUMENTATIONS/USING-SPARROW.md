======================
INSTALL/UPDATE SPARROW
WITH FAMILY NODE KIT
======================

## Installing Sparrow Wallet

Family Node Kit does not include Sparrow Wallet.

Visit the official Sparrow Wallet website and download 
the latest Linux standalone release.

Choose:

```
Linux (Intel/AMD) Standalone
```

The downloaded file will have a name similar to:

```
sparrowwallet-2.5.3-x86_64.tar.gz
```

(The version number may be different.)

After downloading the package, VERIFY it by following 
the instructions provided on the Sparrow Wallet website.

When the verification is complete:

1. Open your **Downloads** folder.

2. Double-click the downloaded `.tar.gz` file to extract it.

3. A folder named:

```
Sparrow
```

will be created.

4. Move the **Sparrow** folder into your Home folder:

```
~/
```

so the final location becomes:

```
~/Sparrow
```

No further installation is required.

Family Node Kit automatically looks for Sparrow in this location 
when you select **Open Sparrow Wallet** from the Dashboard.

You only need to do this once. Family Node Kit will continue to use 
the same Sparrow folder each time you launch the wallet.

## Update Sparrow wallet

Just follow the same steps as above.

When you obtain the new Sparrow folder, replace the existing 
folder with the new one in:

```
~/Sparrow
```
to maintain the same location as before.

==================
USING SPARROW WITH
FAMILY NODE KIT
==================

Family Node Kit uses Sparrow Wallet as the wallet
interface for your Bitcoin node.

Sparrow does not connect directly to Bitcoin Core.

The connection works through Fulcrum:

    Bitcoin Core
         │
         │
      Fulcrum
         │
         │
      Sparrow

Fulcrum provides Sparrow with access to the blockchain
and transaction information provided by your own
Bitcoin node.

If Fulcrum is not synchronized with Bitcoin Core, 
Sparrow may not be ready for normal wallet operation.

When Sparrow is configured to use the Fulcrum service
provided by Family Node Kit, your wallet does not need
to use a public Bitcoin server.

This keeps your wallet communication connected to
your own node.

----------------------------------------
CONNECTING SPARROW TO FULCRUM
----------------------------------------

When Bitcoin and Fulcrum are running and Fulcrum is synchronized,
Sparrow can connect to the local Fulcrum service.

To connect Sparrow to Fulcrum use these SERVER parameters:

In the Sparrow window, go to:

File → Settings → Server

# Server Type

Select Private Electrum (blue toggle)

# Private Electrum Server

- URL: 127.0.0.1   /   50001
- Use SSL: off
- Certificate: empty
- Use Proxy: active (when Tor is in use)
- Proxy URL: 127.0.0.1   /   9050

Once connected, Sparrow will use your own Bitcoin node
through Fulcrum.

----------------------------------------
SPARROW STATUS
----------------------------------------

Sparrow shows important connection information around
the bottom edge of the wallet window.

Pay attention to:

  • Current synchronized block

  • Online / Offline status
    (blue when active)

  • Tor status, when Proxy URL is active
    (small Tor icon, just before the toggle)

The block height indicates the last block synchronized
by Sparrow (via Fulcrum).

Before making a transaction, VERIFY that the block height
has reached the actual current blockchain tip.
(For example, check mempool.space.)

BE AWARE! A wallet can be connected while synchronization is
still in progress.

----------------------------------------
TRANSACTIONS AND TOR
----------------------------------------

For normal wallet operation, using your own Bitcoin
node through Fulcrum avoids relying on a public
Bitcoin server.

When making transactions, using Tor is RECOMMENDED
for additional network privacy.

Start Tor from the Family Node Dashboard:

    3) Start Tor Proxy + External Wallet

The Dashboard will report when the Tor service is
running.

In Sparrow wallet go:

- File → Settings → Server 
 
- USE Proxy: click on toggle (will turn blue). 

- Close the Server window.

- Verify Tor status 
  (small Tor icon, just before the toggle)
  
----------------------------------------
OFFLINE OPERATION
----------------------------------------

Sparrow Wallet can also be opened standalone for
offline operation.

Offline operation is useful when you want to work with
your wallet without connecting to the Bitcoin node.

The Family Node Kit does not require Sparrow to be
running continuously.

----------------------------------------
IMPORTANT
----------------------------------------

Sparrow is a separate application.

Family Node Kit does not manage:

• Wallets
• Seeds
• Recovery phrases
• Private keys
• Passphrases
• Transaction signing

Your wallet and your Bitcoin remain under your control.

Don't Trust. Verify.
====================
END OF DOCUMENT
====================


