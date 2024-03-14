set OUT="%cd%"
set BIN="%IDE_PATH%"

taskkill /F /IM Application.exe
convertRPK.exe %BIN% %KEY%

echo "gradlew assembleRelease start"

call gradlew assembleRelease

echo "start copy && unzip"
cd /d "%BIN%"
echo "delete other package start"
del resources\\samulator\\Application.bin
del resources\\samulator\\system\\ace\\vendor\\MyApplication.bin
del resources\\samulator\\entry-release-unsigned.bin
del resources\\samulator\\entry-release-liteWearable-unsigned.hap
del resources\\samulator\\package\\src\\entry-release-unsigned.bin
del resources\\samulator\\system\\ace\\vendor\\entry-release-unsigned.bin
del resources\\samulator\\package\\build\\entry-release-unsigned.bin
del resources\\samulator\\package\\src\\entry-debug-unsigned.bin
del resources\\samulator\\system\\ace\\vendor\\entry-debug-unsigned.bin

del resources\\samulator\\package\\build\\entry-debug-unsigned.bin


del /s /q resources\\samulator\\app\\ace\\run\\
rd /s /q resources\\samulator\\app\\ace\\run\\
md resources\\samulator\\app\\ace\\run\\
md resources\\samulator\\app\\ace\run\\com.example.install\\

XCOPY /e /c /y resources\\samulator\\com.example.install resources\\samulator\\app\\ace\\run\\com.example.install
echo "check package manager"
dir resources\\samulator\\app\\ace\\run\\com.example.install

cd /d %OUT%
copy  /y entry\\build\\outputs\\bin\\release\\entry-release-unsigned.bin %BIN%\\resources\\samulator
md  %BIN%\\resources\\samulator\\package\\entry-debug-unsigned.bin
copy  /y entry\\build\\outputs\\bin\\release\\entry-release-unsigned.bin %BIN%\\resources\\samulator\\package\\src
openssl.exe x509 -in "%KEY%\certificate.pem"  -out c2.crt
keytool.exe -file c2.crt -printcert | findstr "SHA" > %BIN%\\resources\\samulator\\package\\src\\key.txt
cd /d %BIN%\\resources\\samulator

cd package

md sign
copy /y %KEY% sign\\release
npm run release & copy /y %KEY% release & aiot resign --sign release --dest out & cd ../& copy /y package\out %OUT%\build & Application.exe entry-release-unsigned.bin & cd /d "%OUT%"

