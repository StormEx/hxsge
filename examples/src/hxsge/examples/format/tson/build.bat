rmdir /s /q %~dp0..\..\..\..\..\build\nodejs\tsonmanager
xcopy /s /Y %~dp0web  %~dp0..\..\..\..\..\build\nodejs
nwbuild -v 0.12.2 -p win64 -o %~dp0..\..\..\..\..\build\nodejs %~dp0..\..\..\..\..\build\nodejs
exit