# S/MIME Certificate Authority based on OpenSSL CA
## CA, Windows Batch-Scripts for CA & S/MIME Mail-Certificate-Generation

Full-Download: Use the provided [ZIP-File](../../raw/master/SMIME-CA.v2020-07-17.Full-Package-including-OpenSSL.zip), it includes OpenSSL and the Scripts.

This little OpenSSL based CA creates smooth working S/MIME Certificates for signed and encrypted S/MIME Mailing with Mail-Clients like Thunderbird or Outlook. 
You don't need to have Linux installed, it runs on Windows and can be easily configured for your needs, as it uses only small and readable Bat-Scripts.

Creating the CA ist just starting [`create_CA.bat`](create_CA.bat), creating an S/SMIME-Certificate is just another click on [`create_SMIME-Certificate-for-User.bat`](create_SMIME-Certificate-for-User.bat).

You get fully working .p12 Files (.p12 = PKCS#12 = .pfx) to Import your S/MIME-Certificate into Certificate-Store with one click (your self-generated CA already included).

In addition you get a nice [User-Manual / Documentation](Manual%20(German)%20-%20SMIME-CA%20Nutzungsanleitung%20und%20technische%20Infos.pdf) with Screenshots (in German Language).

Folder-Structure
* CA ... Folder contains the generated CA
* CA-openssl.cfg the preconfigured Config-File, usually no modification is needed
* Batch-Files for Creating the CA and S/MIME Certs
* openssl ... contains the OpenSSL Windows Binaries:
** Win64 compiled OpenSSL Binaries (Win64 OpenSSL v1.1.1g, compiled by [Shining Light Productions](https://slproweb.com/products/Win32OpenSSL.html))
** Added vcruntime140.dll (so you don't need to have Visual C++ Redistributable Packages for Visual Studio 2017 installed)

## Solved Pitfalls
* OpenSSL included, VisualStudio-Runtime included, no Installation necessary - just extract zip-File
* CA 20 years valid, Certificates 15 years valid - both configurable in the two Scripts (see argument ´-days´)
* P12 File includes S/MIME User-Certificate with Private-Keys and Root-Certificate, protected by a configurable password, just one click to install
* CA is named "A-Private-Mail Certificate Authority", so CA shows up on top of alphabetic sorted Root-CA List, easy for Checking. Of course the Name is configurable.
* You get the P12-File and in addition you get a cer-File for each user, which can be distributed to your Mailing-Partners.
* Thunderbird seems to expect unique Root-CA Serial Numbers, strange effects happen if you just create a Root-CA with serial 0x01, so Serial is random generated and even the S/MIME-Certificate SerialNumers have an random-start-prefix and then count up on each new cert issued.
* When importing the P12 to Thunderbird be sure you select "This certificate can identify mail users", you find a Sceenshot of this in my Documentation in Chapter 9.
* Certificate Key Usage and Extended Key Usage are exactly tailored for S/MIME, but configuration example to add TLS-Client-Auth Usage is given.
