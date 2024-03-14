set OUT="%cd%"
set BIN="%IDE_PATH%"

convertRPK.exe %BIN%
echo "gradlew assembleDebug start"
call gradlew assembleDebug

echo "start copy && unzip"
cd /d "%BIN%"
echo "delete other package start"
del resources\\samulator\\Application.bin
del resources\\samulator\\system\\ace\\vendor\\MyApplication.bin
del resources\\samulator\\entry-debug-unsigned.bin
del resources\\samulator\\entry-debug-liteWearable-unsigned.hap

del /s /q resources\\samulator\\app\\ace\\run\\
rd /s /q resources\\samulator\\app\\ace\\run\\
md resources\\samulator\\app\\ace\\run\\
md resources\\samulator\\app\\ace\run\\com.example.install\\

XCOPY /e /c /y resources\\samulator\\com.example.install resources\\samulator\\app\\ace\\run\\com.example.install
echo "check package manager"
dir resources\\samulator\\app\\ace\\run\\com.example.install

cd /d %OUT%
copy  /y entry\\build\\outputs\\bin\\debug\\entry-debug-unsigned.bin %BIN%\\resources\\samulator
cd /d %BIN%\\resources\\samulator



cd package
npm run build & copy /y %KEY% dist & aiot resign --sign dist --dest out & cd ../& copy /y package\out %OUT%\build & Application.exe entry-debug-unsigned.bin & cd /d "%OUT%"

