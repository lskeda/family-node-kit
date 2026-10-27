===================
VERIFYING DOWNLOADS
(GPG & SHA256)
===================

Don't Trust. Verify.

Bitcoin software is usually distributed together with
verification files so you can independently
check that the software you downloaded is
the same software published by the developers.

This document explains what those files are,
why they exist, and how to use them.

## Bitcoin Core provides two verification methods:

1. SHA256 checksum
2. GPG (PGP) signatures

They serve different purposes.

# SHA256 answers one question:

"Did this file change?"

If even one single bit changes, the SHA256
checksum changes completely.

This protects against:

• damaged downloads
• incomplete downloads
• accidental corruption

Family Node Kit always performs SHA256
verification.

It is mandatory.

# GPG answers a different question:

"Can I verify who signed this release?"

Instead of checking the file itself,
GPG checks the digital signatures created by 
Bitcoin Core release builders.

If you trust one of those builders and you
have imported their public key, GPG can
prove that the published checksum really
came from them.

# "No public key"

On a new computer you normally have no
Bitcoin builders' public keys installed.

For that reason you may see messages like:

    Can't check signature:
    No public key

This is normal.

It does not mean the download is unsafe.

It simply means your computer does not yet
know the public keys required to verify the
signatures.

# Is GPG required?

No.

Family Node Kit requires successful SHA256 verification 
before installing Bitcoin Core.

GPG verification is optional but recommended because 
it provides additional assurance that the published 
checksums came from the expected release builder.

# If you want full verification

To verify GPG signatures you must first
import one or more trusted public keys.

Those public keys are published by Bitcoin Core release builders.

Once imported, the installer will
automatically verify any signatures matching
those keys.

# Always obtain public keys from trusted sources.

Possible sources include:

• Bitcoin Core official website
• The builder's official website or GitHub profile
• A trusted public OpenPGP key server

Always compare the key fingerprint with the
one published by the builder before trusting
the key.

The following example shows how to import the public key 
of one Bitcoin Core release builder.

## Example: Importing a Bitcoin Core Builder Public Key

The following example imports the public key published by one 
of the Bitcoin Core release builders (Emzy).

1. Open your web browser.

2. Search for:

```
Bitcoin Core builder keys Emzy.gpg
```

3. Open the GitHub page containing **Emzy.gpg**.

4. Download **Emzy.gpg** into your **Downloads** folder.

5. Open your **Downloads** folder.

6. Right-click an empty area and choose **Open Console**
   (called **Terminal** in many Linux distributions).

7. Run:

```
gpg --import Emzy.gpg
```

If the import is successful, GPG will report that the public key 
has been imported into your local keyring.

You only need to import a public key once.

You can confirm that the key is available by running:

```
gpg --list-keys
```

or display its fingerprint with:

```
gpg --fingerprint
```

Always compare the displayed fingerprint with the fingerprint published 
by the key owner before deciding to trust the key.

Once the public key has been imported, Family Node Kit will automatically 
use it whenever it verifies a Bitcoin Core release signed by that builder.

Remember:

Importing a public key does **not** mean you trust it.

Only you can decide which public keys you trust.

Family Node Kit gives you the tools to verify software. 
The decision to trust a public key always remains yours.


## What Family Node Kit does

Family Node Kit never imports public keys
automatically.

Trust decisions belong to you.

The installer simply reports what it can
verify using the keys already installed on
your computer.

This follows the Bitcoin principle:

    Don't Trust. Verify.

## Summary

✓ SHA256 verifies the file.

✓ GPG verifies who signed it.

✓ SHA256 is always performed.

✓ GPG is optional until you choose which
  builders you trust.

Family Node Kit verifies software.

It reports what it can verify.

Only you decide which public keys to trust.
