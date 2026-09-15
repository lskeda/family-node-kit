========================================
       FAMILY NODE DASHBOARD
       USER GUIDE
========================================

Use this guide together with the Family Node Dashboard.

The Dashboard is the normal way to operate the Kit.

When starting the node, normally follow the menu from top to bottom,
beginning with the system time check.

----------------------------------------
TIME AND SYSTEM CLOCK
----------------------------------------

The Dashboard displays the current system time in UTC.

Example:

TIME: 05:53 UTC

UTC is used because it is a universal time standard
and is independent of your local time zone.

Before starting Bitcoin and Fulcrum, use:

UTC) Synchronize System Time

This checks the system NTP service and synchronizes
the system clock.

You can use this option even when the system clock
is already synchronized.

The terminal will report:

    ✔ System time synchronized

If the system clock cannot be synchronized, do not
start the Bitcoin services. Check the terminal
instructions and correct the time synchronization
problem first.

----------------------------------------
CURRENT STATUS
----------------------------------------

The status shown at the top gives a quick overview of the system 
time, Bitcoin, Fulcrum and Tor.

For detailed information, use:

KIT) Family Node Kit Health Report

----------------------------------------
KIT) FAMILY NODE KIT HEALTH REPORT
----------------------------------------

After checking the system time with UTC, use KIT
to review the Health Report before starting or
using the node.

The report tells you what the system is actually doing.
Do not assume that a service is ready simply because
it is running.

----------------------------------------
1) START BITCOIN + FULCRUM
----------------------------------------

Use this option to start the Bitcoin service.

The Kit also checks and reports the current system
status while starting the services.

If the system detects a Fulcrum update, it will also
install the new official version according to
FULCRUM-MANAGEMENT.md.
Run KIT for detailed information.

FIRST START:

After installation, the first run prepares and starts
Fulcrum in its container.

Bitcoin and Fulcrum then begin their initial
synchronization and data download.

This can take a long time.

Do not press Enter immediately.

Read carefully the Terminal information.

You can open another Terminal window to monitor the download progress, following the Terminal instructions.

----------------------------------------
2) OPEN SPARROW WALLET
----------------------------------------

Use this option to open Sparrow Wallet.

For Sparrow configuration and use, see:

USING-SPARROW.md

Sparrow can open and connect while Bitcoin is still
synchronizing.

Before making a transaction, check the synchronization
indication at the bottom of the Sparrow window.

Only proceed when Sparrow shows that the blockchain
is synchronized with the current chain tip.

Sparrow Wallet can also be opened standalone for
offline operation.

----------------------------------------
3) START TOR PROXY + EXTERNAL WALLET
----------------------------------------

Use this option when you want to use Tor for
Bitcoin communication and transactions.

It also allows an external wallet to connect to
your node through its onion address.

If the system detects a Tor update, it will also install the new version.

Run KIT for detailed information.

FIRST START:

After installation, the first run prepares the Tor
container and starts the Tor service.

Wait for the terminal to report that the operation
has finished.

----------------------------------------
4) STOP TOR PROXY
----------------------------------------

Stops the Tor service.

Use this when Tor is no longer needed.

----------------------------------------
5) SHOW ONION ADDRESS
----------------------------------------

Shows the Bitcoin onion address provided by the node.

Use this address when connecting a compatible
Electrum-type external wallet through Tor.

Tor must be running.

----------------------------------------
RPC) ROTATE BITCOIN RPC PASSWORD
----------------------------------------

Changes the Bitcoin RPC password used by the Kit.

Use this only when required.

The Kit updates the required configuration.

----------------------------------------
RESET) RESET NODE
----------------------------------------

Resets the Bitcoin node environment while preserving
your Bitcoin data.

Use only when required, for example if the node
is not connecting, becomes unusually slow or other unusual behavior.

RESET option will:

- Check and correct the system clock.
- Resolve the Bitcoin installation.
- Stop containers (Fulcrum and Tor).
- Stop the Bitcoin node cleanly, then force-stop it if necessary.
- Perform a final verification.

----------------------------------------
CLEAN) CLEAR SYSTEM LOG ONLY
----------------------------------------

Clears the Family Node system log.

This does not delete Bitcoin or Fulcrum data.

----------------------------------------
STOP) STOP BITCOIN SERVICES
----------------------------------------

Stops the Bitcoin services.

Use this when you want to shut down the node services.

----------------------------------------
0) EXIT
----------------------------------------

Closes the Dashboard.

The current services remain in their current state.

========================================
IMPORTANT: READ THE TERMINAL
========================================

The Kit uses the terminal to:

• explain what it is doing
• report progress
• show warnings
• report errors
• tell you when an operation has finished

Do not immediately select another option or close
the terminal.

Wait for the final result.

IMPORTANT:

        READ THE TERMINAL.
        WAIT FOR THE FINAL RESULT.
        REVIEW BEFORE PRESS ENTER.

========================================
BEFORE USING YOUR WALLET ONLINE
========================================

1. Check the system time with UTC.
2. Run KIT.
3. Check the Bitcoin status.
4. Start Bitcoin + Fulcrum.
5. Open Sparrow and check its synchronization
   indication before making a transaction.

Do not use a connected wallet as proof that the
blockchain is synchronized.

Only proceed when Sparrow shows that the blockchain is 
synchronized with the current chain tip.

========================================
GOOD PRACTICES
========================================

• Use KIT before starting or using the node.
• Read the terminal messages.
• Wait for operations to finish.
• Do not interrupt synchronization unnecessarily.
  If you need to stop synchronization, use STOP
  for a safe interruption.
• Do not delete ~/.bitcoin or ~/.fulcrum to solve
  a problem without first checking the Health Report.
• Keep your backups current.
• Keep your wallet recovery phrase independent
  from the computer.

When something is unclear, stop and check the
appropriate documentation before continuing.

========================================
FAMILY NODE KIT
========================================

Don't Trust. Verify.
========================================
