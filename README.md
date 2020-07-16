# S/MIME Certificate Authority based on OpenSSL CA
## CA, Windows Batch-Scripts for CA & S/MIME Mail-Certificate-Generation

Full-Download: Use the provided [ZIP-File](SMIME-CA.v2020-07-16.zip), it includes OpenSSL and the Scripts.

This little OpenSSL based CA creates smooth working S/MIME Certificates for signed and encrypted S/MIME Mailing with Mail-Clients like Thunderbird or Outlook. 
You don't need to have Linux installed, it runs on Windows and can be easily configured for your needs, as it uses only small and readable Bat-Scripts.

Creating the CA ist just starting [`create_CA.bat`](create_CA.bat), creating an S/SMIME-Certificate is just another click on [`create_SMIME-Certificate-for-User.bat`](create_SMIME-Certificate-for-User.bat).

You get fully working .p12 Files (.p12 = PKCS#12 = .pfx) to Import your S/MIME-Certificate into Certificate-Store with one click (CA already included).

In addition you get a nice [User-Manual / Documentation](Manual%20(German)%20-%20SMIME-CA%20Nutzungsanleitung%20und%20technische%20Infos.pdf) with Screenshots (in German Language).

Folder-Structure
* CA ... Folder contains the generated CA
* CA-openssl.cfg the preconfigured Config-File, usually no modification is needed
* Batch-Files for Creating the CA and S/MIME Certs
* openssl ... contains the OpenSSL Windows Binaries:
** Win64 compiled OpenSSL Binaries (Win64 OpenSSL v1.1.1g, compiled by [Shining Light Productions](https://slproweb.com/products/Win32OpenSSL.html))
** Added vcruntime140.dll (so you don't need to have Visual C++ Redistributable Packages for Visual Studio 2017 installed)
