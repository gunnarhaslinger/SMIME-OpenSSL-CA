# S/MIME Certificate Authority based on OpenSSL CA
## CA, Windows Batch-Scripts for CA & S/MIME Mail-Certificate-Generation

Full-Download: Use the provided [ZIP-File](../../raw/master/SMIME-CA.v2020-07-17.Full-Package-including-OpenSSL.zip), it includes OpenSSL and the Scripts.

This little OpenSSL based CA creates smooth working S/MIME Certificates for signed and encrypted S/MIME Mailing with Mail-Clients like Thunderbird or Outlook. 
You don't need to have Linux installed, it runs on Windows and can be easily configured for your needs, as it uses only small and readable Bat-Scripts.

Creating the CA ist just starting [`create_CA.bat`](create_CA.bat), creating an S/SMIME-Certificate is just another click on [`create_SMIME-Certificate-for-User.bat`](create_SMIME-Certificate-for-User.bat).

You get fully working .p12 Files (.p12 = PKCS#12 = .pfx) to Import your S/MIME-Certificate into Certificate-Store with one click (your self-generated CA already included).

In addition you get a nice [User-Manual / Documentation](Manual%20(German)%20-%20SMIME-CA%20Nutzungsanleitung%20und%20technische%20Infos.pdf) with Screenshots (in German Language).

Folder-Structure
* `CA` ... Folder contains the generated CA
* `CA-openssl.cfg` the preconfigured Config-File, usually no modification is needed
* `Batch-Files` for Creating the CA and S/MIME Certs
* `openssl` - contains the OpenSSL Windows Binaries:
  * Win64 compiled OpenSSL Binaries: Win64 OpenSSL v1.1.1g, compiled by [Shining Light Productions](https://slproweb.com/products/Win32OpenSSL.html)
  * Added vcruntime140.dll (so you don't need to have Visual C++ Redistributable Packages for Visual Studio 2017 installed)

## Solved Pitfalls
* OpenSSL included, VisualStudio-Runtime included, no Installation necessary - just extract zip-File
* CA is 20 years valid, Certificates 15 years valid - both configurable in the two Scripts (see argument `-days`)
* P12 File includes S/MIME User-Certificate with Private-Keys and Root-Certificate, protected by a configurable password, just one click to install
* CA is named "A-Private-Mail Certificate Authority", so CA shows up on top of alphabetic sorted Root-CA List, makes it easier for checking Client-Configurations. Of course the name is configurable.
* You get the P12-File (Cert+PrivKey+RootCA) and in addition you get a cer-File (only Cert without PrivKey) for each user, which can be distributed to your Mailing-Partners.
* Thunderbird seems to expect unique Root-CA Serial Numbers, strange effects happen if you just create a Root-CA with serial 0x01 and import two of them, so serial is random generated and even the S/MIME-Certificate SerialNumers have an random-start-prefix and then count up on each new cert issued.
* When importing the P12 to Thunderbird: Be sure you select "This certificate can identify mail users", you find a Sceenshot of this mandatory step in my [documentation](Manual%20(German)%20-%20SMIME-CA%20Nutzungsanleitung%20und%20technische%20Infos.pdf) in Chapter 9.
* Certificate Key Usage and Extended Key Usage are exactly tailored for S/MIME, but configuration example to add TLS-Client-Auth Usage is given in `CA-openssl.cfg` .

---

## Start a new CA
* Extract downloaded ZIP-File
* Start `create_CA.bat` do generate a new Root-CA located in new created Directory `CA`
* Edit `create_SMIME-Certificate-for-User.bat` (Username, E-Mail-Address, ...) and Start it to create your first S/MIME-Certificate
* Repeat editing and starting `create_SMIME-Certificate-for-User.bat` as often as you need a new certificate for a user
* Backup and store the whole folder on a secure place

## Updating from previous Versions
* Extract downloaded ZIP-File of new Version
* Copy `CA` Folder from old Version to new Version

---

## Credit & Kudos
* The [OpenSSL Community](https://www.openssl.org/)
* [Shining Light Productions](https://slproweb.com/products/Win32OpenSSL.html) for providing Win64-compiled OpenSSL
* My friend Werner for acting as Alpha/Beta-Test-User and reporting me all Thunderbird-Bugs he stumbled with.
