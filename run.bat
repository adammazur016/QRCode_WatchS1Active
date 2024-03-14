set OUT="%cd%"
set BIN="%IDE_PATH%"

taskkill /F /IM Application.exe
convertRPK.exe %BIN% %KEY%
echo "gradlew assembleRelease start"
copy_file.exe %OUT% %BIN%
check_file.exe %BIN% %OUT%
call gradlew assembleRelease && (goto succeed) || goto failed

:succeed
echo "start copy && unzip"
cd /d "%BIN%"
echo "delete other package start"
md resources\\samulator\\app\\ace\\run\\
md resources\\samulator\\app\\ace\run\\com.example.install\\
XCOPY /e /c /y resources\\samulator\\com.example.install resources\\samulator\\app\\ace\\run\\com.example.install
echo "check package manager"
dir resources\\samulator\\app\\ace\\run\\com.example.install
cd /d %OUT%
copy  /y entry\\build\\outputs\\bin\\release\\entry-release-unsigned.bin %BIN%\\resources\\samulator
md  %BIN%\\resources\\samulator\\package\\entry-debug-unsigned.bin
copy  /y entry\\build\\outputs\\bin\\release\\entry-release-unsigned.bin %BIN%\\resources\\samulator\\package\\src
del_file.exe %BIN% %OUT%
openssl.exe x509 -in "%KEY%\certificate.pem"  -out c2.crt
keytool.exe -file c2.crt -printcert | findstr "SHA" > %BIN%\\resources\\samulator\\package\\src\\key.txt
cd /d %BIN%\\resources\\samulator
cd package
md sign
copy /y %KEY% sign\\release
start /b npm run release & copy /y %KEY% release & aiot resign --sign release --dest out & cd ../& copy /y package\out %OUT%\build & Application.exe entry-release-unsigned.bin & cd /d "%OUT%"

:failed
echo failed
echo Verify that the code conforms to the development documentation
del_file.exe %BIN% %OUT%
