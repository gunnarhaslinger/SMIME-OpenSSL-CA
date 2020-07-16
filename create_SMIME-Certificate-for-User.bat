@echo off

rem # Switch to the directory of this script
pushd "%~dp0\"

rem ### Configuration ####################################
rem # USER = Certificate Common Name, e.g. First-Name Last-Name
rem # EMAIL = the E-Mail address of this user which is used for S/MIME Mailing
rem # PASSWORD = The password for the P12-File, it protects the Users Certificate, User needs this Password for Importing the p12-File
rem #            Avoid special characters, only use alphanumeric passwords
rem #######################################################


rem # Configure
set USER=Richard John Doe
set EMAIL=richard.john.doe@example.com
set PASSWORD=secret-0815

rem # Generate
cmd.exe /c create_SMIME-Certificate.bat
