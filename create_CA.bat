@echo off
rem # Gunnar Haslinger, 16.07.2020, 
rem # Source at GitHub: https://github.com/gunnarhaslinger/SMIME-OpenSSL-CA
rem # Blog: https://hitco.at/blog
rem # Creates a new Certificate Authority (CA) for the purpose creating S/MIME-User-Certificates for Mailing

rem ### Configuration ####################################
set USER=A-Private-Mail Certificate Authority
set ORG=A-Private-Mail
set ORGUNIT=SMIME-Certificate-Management

rem # X509-Cert-Attributes for the CA
set COUNTRY=AT
set STATE=Austria
set LOCALITY=Europe

rem Form the whole x509 CA Certificate SUBJECT (the Issuer)
set SUBJECT=/C=%COUNTRY%/O=%ORG%/OU=%ORGUNIT%/CN=%USER%
rem set SUBJECT=/C=%COUNTRY%/ST=%STATE%/L=%LOCALITY%/O=%ORG%/OU=%ORGUNIT%/CN=%USER%

set DIR=CA
set OPENSSL_CONF=..\CA-openssl.cfg
set openssl=..\openssl\openssl.exe
set RANDFILE=%TEMP%\openssl-random.rnd
rem ######################################################

rem CleanUp OpenSSL Random File
if exist "%RANDFILE%" del /f /q "%RANDFILE%"

mode CON COLS=130
color 1f
title Creating CA: %USER%

rem # Switch to the directory of this script
pushd "%~dp0\"

if exist "%DIR%" echo A CA-Folder "%DIR%" already exists, aborting! Delete it to start a new CA. && goto ende

mkdir "%DIR%"
pushd "%DIR%"

mkdir private
mkdir newcerts
mkdir certs
mkdir crl

rem # The OpenSSL CA needs two control Files, one as Index (Journal) which just starts with an empty File, and one for storing the next Serial-Number
rem # To have kind of unique Serial Numbers we don't start at 01 but use a random prefix
rem # But: OpenSSL needs an even amount of digits for the serialnumber, as %RANDOM% can be an even amount of digits we double it
echo. 2>index.txt
set SERIAL=%RANDOM%
set SERIAL=%SERIAL%%SERIAL%000001
echo Initializing the Serial-Config-File for the CA with Start-Value: %SERIAL%
echo %SERIAL%>serial

rem # einen neuen Private-Key generieren und das Kennwort wegwerfen (Schutz der CA durch vertrauliche Behandlung der Files!)
rem # Generate a new Private-Key and remove the password-protection. Store this file in a protected / secure place.
echo Generating new Private-Key for CA:
%openssl% genrsa -aes256 -passout pass:temp-password-123 -out private/ca-key.pem 4096
%openssl% rsa -in private/ca-key.pem -passin pass:temp-password-123 -out private/ca-key.pem -passout pass:

rem # Generating new Root-Certificate, based on the just generated private Key.
echo Creating new Root-Certificate:
%openssl% req -new -x509 -key private/ca-key.pem -sha256 -days 7305 -extensions v3_ca -out ca-cert.cer -config %OPENSSL_CONF% -subj "%SUBJECT%"

rem # Print the CA Details as Informational Output and store it in ca-cert.infos.txt File (just for your interest)
%openssl% x509 -in ca-cert.cer -text -noout
%openssl% x509 -in ca-cert.cer -text -noout >ca-cert.infos.txt

rem Store the Certificate as .cer File, to hand it out to your users
copy ca-cert.cer "../Root-Certificate %USER%.cer" /Y
echo.
echo A new CA in Folder "%DIR%" was created.
echo The Root-Certificate for Importing into your CertStore is: Root-Certificate %USER%.cer
echo.
popd

:ende

rem CleanUp OpenSSL Random File
if exist "%RANDFILE%" del /f /q "%RANDFILE%"

pause
