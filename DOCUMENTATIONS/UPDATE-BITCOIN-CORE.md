# Update Bitcoin Core

Family Node Kit uses the official Bitcoin Core release and requires the release files to be verified before installation.

**Don't Trust. Verify.**

---

## When should I update?

Update Bitcoin Core when a new official release is available and you decide to upgrade your node.

Family Node Kit does **not** automatically download or install Bitcoin Core updates.

---

## Before you start

Make sure you have:

* The official Bitcoin Core `.tar.gz` release archive
* The matching official `SHA256SUMS` file
* Optional: the matching `SHA256SUMS.asc` file for PGP verification
* Your node data safely backed up if required

Place the downloaded files in:

```text
~/Downloads/bitcoin-verify
```

Do **not** rename the files.

---

## Update Bitcoin Core

### 1. Stop the Bitcoin services

From the Family Node Kit Dashboard:

```text
STOP) Stop Bitcoin Services
```

Wait until Bitcoin and Fulcrum have stopped.

### 2. Run the Bitcoin installer

Open a Terminal and run:

```bash
~/family-node-kit/tools/install-bitcoin.sh
```

### 3. Select the release

The installer will show the Bitcoin Core archives found in:

```text
~/Downloads/bitcoin-verify
```

Select the release you want to install.

### 4. Verify the release

Family Node Kit performs:

* **PGP verification** when the `.asc` file and trusted signing keys are available
* **SHA256 verification** of the selected archive

**Do not continue if SHA256 verification fails.**

PGP verification is optional, but SHA256 verification is mandatory.

For more information about verification:

```text
GPG-VERIFYING-DOWNLOADS.md
```

### 5. Complete the installation

Follow the installer instructions.

Your Bitcoin data directory remains separate:

```text
~/.bitcoin
```

The blockchain does not need to be downloaded again simply because Bitcoin Core was updated.

---

## After the update

Start the node again from the Family Node Kit Dashboard:

```text
1) Start Bitcoin + Fulcrum
```

Then run:

```text
KIT) Family Node Kit Health Report
```

Confirm that the report shows the expected Bitcoin Core version and:

```text
Status:
  ✓ Running
```

and:

```text
RPC:
  ✓ Reachable
```

Fulcrum should also return to:

```text
✓ Running
```

---

## Quick Checklist

```text
☐ Download official Bitcoin Core release
☐ Download matching SHA256SUMS
☐ Optional: download SHA256SUMS.asc
☐ Place files in ~/Downloads/bitcoin-verify
☐ Stop Bitcoin Services
☐ Run ~/family-node-kit/tools/install-bitcoin.sh
☐ Select the correct release
☐ Confirm SHA256 verification succeeds
☐ Complete installation
☐ Start Bitcoin + Fulcrum
☐ Run KIT) Family Node Kit Health Report
☐ Confirm Bitcoin Core version
☐ Confirm Bitcoin: ✓ Running
☐ Confirm RPC: ✓ Reachable
☐ Confirm Fulcrum: ✓ Running
```

---

## Important

**Never replace the Bitcoin installation manually and never skip checksum verification.**

Family Node Kit's update procedure is:

**Download → Verify → Install → Start → Verify again.**

**Don't Trust. Verify.**
