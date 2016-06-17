haxe build.hxml
rmdir /s /q %~dp0..\..\..\..\..\..\build\bundlemanager\nodejs\bundlemanager
xcopy /s /Y %~dp0res  %~dp0..\..\..\..\..\..\build\bundlemanager\nodejs
xcopy /s /Y %~dp0res  %~dp0..\..\..\..\..\..\build\bundlemanager\js
nwbuild -v 0.12.2 -p win64 -o %~dp0..\..\..\..\..\..\build\bundlemanager\nodejs %~dp0..\..\..\..\..\..\build\bundlemanager\nodejs
exit