rmdir /s /q %~dp0..\..\..\..\..\..\build\nodejs\tsonmanager
xcopy /s /Y %~dp0res  %~dp0..\..\..\..\..\..\build\nodejs
xcopy /s /Y %~dp0res  %~dp0..\..\..\..\..\..\build\js
haxe build.hxml -debug -js %~dp0..\..\..\..\..\..\build\nodejs\test.js -D hxnodejs -D nodejs  -lib hxnodejs
haxe build.hxml -debug -js %~dp0..\..\..\..\..\..\build\js\test.js
nwbuild -v 0.12.2 -p win64 -o %~dp0..\..\..\..\..\..\build\nodejs %~dp0..\..\..\..\..\..\build\nodejs
echo %~dp0
exit