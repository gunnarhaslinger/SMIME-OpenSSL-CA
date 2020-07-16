@echo off
rem # Gunnar Haslinger, 16.07.2020, 
rem # Source at GitHub: https://github.com/gunnarhaslinger/SMIME-OpenSSL-CA
rem # Blog: https://hitco.at/blog
rem # Creates an SMIME-Certificate

rem ### Configuration ####################################

rem Usually this Script and Configuration doesn't need to be modified.
rem Instead: Modify your Attributes like Username, E-Mail-Adress in the 
rem File "create_SMIME-Certificate-for-User.bat" which calls this script

rem # USER = Certificate Common Name, e.g. First-Name Last-Name
if "%USER%"=="" set USER=John Doe

rem # EMAIL = the E-Mail address of this user which is used for S/MIME Mailing
if "%EMAIL%"=="" set EMAIL=john.doe@example.com

rem # The password for the P12-File, it protects the Users Certificate, User needs this Password for Importing the p12-File
rem # Avoid special characters, only use alphanumeric passwords
if "%PASSWORD%"=="" set PASSWORD=email-0815

rem --- End of Configuration, no modification / configuration needed below ---

rem # DIR = Folder of the CA
set DIR=CA

rem # Extensions configured in openssl.cnf Config file
set EXTENSIONS=v3_SMIME

rem # Organisation
set ORG=A-Private-Mail

rem # Organisational Unit
set ORGUNIT=SMIME-Anwender

rem # Other X509 Certificate Attributes
set COUNTRY=AT
set STATE=Austria
set LOCALITY=Europe

rem Form the whole x509 SMIME-Certificate SUBJECT
set SUBJECT=/emailAddress=%EMAIL%/C=%COUNTRY%/O=%ORG%/OU=%ORGUNIT%/CN=%USER%
rem set SUBJECT=/emailAddress=%EMAIL%/C=%COUNTRY%/ST=%STATE%/L=%LOCALITY%/O=%ORG%/OU=%ORGUNIT%/CN=%USER%

set OPENSSL_CONF=..\CA-openssl.cfg
set openssl=..\openssl\openssl.exe
set RANDFILE=%TEMP%\openssl-random.rnd
rem ########################################################

rem CleanUp OpenSSL Random File
if exist "%RANDFILE%" del /f /q "%RANDFILE%"

mode CON COLS=130
color 1f
title Creating Certificate: %USER%

rem # Switch to the directory of this script
pushd "%~dp0\"

if not exist "%DIR%" echo CA-Directory "%DIR%" doesn't exist. Create a CA first! Aborting. && goto ende
if exist "%DIR%\certs\%USER%.p12" echo The User-Certificate "%DIR%\certs\%USER%.p12" already exists, aborting! (Delete or rename it for re-creation!) && goto ende
pushd "%DIR%"

rem # Create a CSR (Certificate Signing Request) and remove the password protection (the choosen P12-Password is applied later)
%openssl% req -new -sha256 -newkey rsa:4096 -passout pass:temp-password-123 -keyout "certs/%USER%.key" -out "certs/%USER%.csr" -config "../CA-openssl.cfg" -batch -subj "%SUBJECT%"
%openssl% rsa -in "certs/%USER%.key" -passin pass:temp-password-123 -out "certs/%USER%.key" -passout pass:

rem # Create Certificate by processing the CSR
%openssl% ca -config "../CA-openssl.cfg" -batch -extensions %EXTENSIONS% -md sha256 -days 5478 -out "certs/%USER%.cer" -infiles "certs/%USER%.csr"

rem # Create a .p12 Container (PKCS#11, PFX), Passwort-Protect the p12-File (Thunderbird needs it to be password-protected for importing it). Also add the CA-Certificate to the p12-File.
%openssl% pkcs12 -export -in "certs/%USER%.cer" -inkey "certs/%USER%.key" -chain -CAfile "ca-cert.cer" -name "%USER%" -passout pass:%PASSWORD% -out "certs/%USER%.p12"

rem # Print the Certificate-details as Informational Output and store it in .infos.txt File (just for your interest)
%openssl% x509 -in "certs/%USER%.cer" -noout -text
echo Password for the P12 (=PFX / PKCS#12) File (%USER%.p12): %PASSWORD% >"certs/%USER%.Certificate-Info.txt"
echo. >>"certs/%USER%.Certificate-Info.txt"
%openssl% x509 -in "certs/%USER%.cer" -noout -text >>"certs/%USER%.Certificate-Info.txt"
popd

rem CleanUp of Files not needed any more
del "%DIR%\certs\%USER%.csr"
del "%DIR%\certs\%USER%.key"

echo.
echo An S/MIME-Certificate in Directory "%DIR%\certs\%USER%.cer" was created.
echo Use the ".p12" File (which contains Certificate + Private Key + Root-Certificate) to
echo import it into your Certificate Store (Windows, Thunderbird, ...)
echo The Password for the created P12-File is: %PASSWORD%
echo.


:ende
rem CleanUp OpenSSL Random File
if exist "%RANDFILE%" del /f /q "%RANDFILE%"

pause
