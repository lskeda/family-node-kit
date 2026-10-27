==========================
MANAGE WASABI WALLET
FAMILY NODE KIT
==========================

# PURPOSE

Wasabi Wallet is an optional wallet for users who
want to explore advanced Bitcoin privacy tools.

Family Node Kit launches Wasabi but does not install,
update, configure, or manage the Wasabi application or its wallets.
Sparrow remains the recommended everyday wallet in the Kit's main menu.

Wasabi is optional. You can operate Family Node Kit without installing
or using it.

# REQUIREMENTS

Before connecting Wasabi:

-   Install Wasabi separately from its official distribution source.
-   Verify the downloaded release using the verification instructions
    published by Wasabi.
-   Start Bitcoin Core using Family Node Kit.
-   Confirm Bitcoin Core is running and its local RPC interface is
    reachable.
-   Keep the Bitcoin RPC interface restricted to trusted local use.

The Kit's Dashboard option is:

    COINJ) Open Wasabi Wallet

This option checks that the configured Wasabi AppImage exists and is
executable, and that Bitcoin Core is running, before launching Wasabi.

Wasabi must be installed at the path expected by the current Dashboard:

    ~/Apps/Wasabi/Wasabi-2.8.3.AppImage

If you install a different Wasabi version or use a different path, the
Dashboard launch path must be updated accordingly.

# CONNECT WASABI TO THE LOCAL BITCOIN NODE

In Wasabi's Bitcoin full-node settings, configure the local Bitcoin Core
RPC endpoint:

    http://127.0.0.1:8332/

Use the current RPC username and password managed by Family Node Kit.
The Kit stores its RPC environment settings in:

    ~/.family-node-kit/env/rpc.env

The Kit also writes the RPC username and password to:

    ~/.bitcoin/bitcoin.conf

Do not share, publish, screenshot, or send your RPC credentials to
anyone. Do not put them in public documentation, issue reports, or
command output. Never expose the Bitcoin RPC interface to the public
internet.

Wasabi should report that the Bitcoin RPC connection succeeds. Allow
Wasabi to complete any required filter or data synchronization before
relying on its displayed wallet state.

# RPC PASSWORD ROTATION

Family Node Kit can rotate the Bitcoin RPC password using:

    RPC) Rotate Bitcoin RPC Password

Rotating the password changes the credentials expected by Bitcoin Core.
Wasabi's saved credentials will then be out of date.

After rotating the password:

1.  Wait for the Kit's rotation operation to finish.
2.  Retrieve the current RPC username and password using your normal
    secure local procedure.
3.  Update Wasabi's saved Bitcoin RPC credentials.
4.  Reconnect Wasabi and confirm that its RPC connection succeeds.

Do not copy RPC credentials into this document or store them in a
plain-text note. Keep them private.

The current Kit uses a configured RPC username and password. This guide
does not describe cookie authentication; the Kit has not been migrated
to that authentication method.

# PRIVACY AND SECURITY NOTES

Connecting Wasabi to your own Bitcoin Core node allows Wasabi to use
your local node for supported full-node functions. This can reduce
reliance on third-party Bitcoin infrastructure, but it does not by
itself guarantee complete privacy.

-   Review Wasabi's own network and privacy settings before use.
-   Understand the effect of Tor and other network settings you enable.
-   A local RPC connection is not the same thing as routing all wallet
    network traffic through Tor.
-   Keep RPC credentials private and limit RPC access to trusted local
    applications.
-   Never expose port 8332 to the public internet.
-   Download Wasabi only from its official source and verify releases
    according to its published instructions.
-   Keep wallet recovery information separate from your computer and
    protect it from unauthorized access.

Family Node Kit does not create, import, back up, or manage Wasabi
wallets. Wallet creation, recovery, coin selection, privacy features,
and transactions are handled within Wasabi itself. Make sure you
understand Wasabi's behavior before using funds.

# TROUBLESHOOTING

## Wasabi says it cannot connect to Bitcoin Core

1.  Confirm Bitcoin Core is running.

2.  Confirm the endpoint is exactly:

        http://127.0.0.1:8332/

3.  Check that the RPC username and password saved in Wasabi match the
    current credentials managed by the Kit.

4.  If the RPC password was recently rotated, update Wasabi's saved
    credentials and reconnect.

5.  Run the Family Node Kit Health Report:

        KIT) Family Node Kit Health Report

6.  Review the terminal output for errors.

## Wasabi does not open from the Dashboard

1.  Confirm Wasabi is installed at the path shown in REQUIREMENTS.
2.  Confirm the AppImage is executable.
3.  Confirm Bitcoin Core is running.
4.  Read any Dashboard error message before trying again.

## Wasabi is still synchronizing

Wasabi may need time to synchronize its own filters or other required
data. A successful RPC connection does not necessarily mean all of
Wasabi's data synchronization is complete. Check Wasabi's own status
before relying on it for wallet activity.

# DOCUMENTATION AND UPSTREAM SOURCES

Wasabi documentation:

    https://docs.wasabiwallet.io/

Wasabi full-node connection information:

    https://docs.wasabiwallet.io/using-wasabi/BitcoinFullNode.html

Wasabi FAQ:

    https://docs.wasabiwallet.io/FAQ/FAQ-UseWasabi.html

Use Wasabi's official documentation for current application settings,
download verification, privacy features, and troubleshooting.

=========================
FAMILY NODE KIT
=========================

Don't Trust. Verify.
