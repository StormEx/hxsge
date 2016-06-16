haxe build.hxml -debug -js %~dp0..\..\..\..\..\..\build\tsonmanager\nodejs\test.js -D hxnodejs -D nodejs  -lib hxnodejs
haxe build.hxml -debug -js %~dp0..\..\..\..\..\..\build\tsonmanager\js\test.js
rmdir /s /q %~dp0..\..\..\..\..\..\build\tsonmanager\nodejs\tsonmanager
xcopy /s /Y %~dp0res  %~dp0..\..\..\..\..\..\build\tsonmanager\nodejs
xcopy /s /Y %~dp0res  %~dp0..\..\..\..\..\..\build\tsonmanager\js
nwbuild -v 0.12.2 -p win64 -o %~dp0..\..\..\..\..\..\build\tsonmanager\nodejs %~dp0..\..\..\..\..\..\build\tsonmanager\nodejs
exit