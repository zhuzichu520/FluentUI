
SET PWD_PATH=%2
SET PRESET_PATH=%3
SET BUILDER_BIN_PATH=%4
SET QT_QML_FLUENT_PATH=%5
SET ANDROID=%6
SET LIBFILE_PATH=%7

echo "--------win_install-------"
echo %RUN_TYPE%
echo %PWD_PATH%
echo %PRESET_PATH%
echo %BUILDER_BIN_PATH%
echo %QT_QML_FLUENT_PATH%
echo "--------------------------"

copy /y  %PWD_PATH%\FluentUI.h  %BUILDER_BIN_PATH% & copy /y  %PRESET_PATH%\*  %BUILDER_BIN_PATH%\

if %ANDROID% == YES copy /y %LIBFILE_PATH% %BUILDER_BIN_PATH%

if %1 == SHARED (
    echo running install to qtqml folder
    rmdir /s /q %QT_QML_FLUENT_PATH% & md %QT_QML_FLUENT_PATH%
    copy /y %BUILDER_BIN_PATH% %QT_QML_FLUENT_PATH%
	cd %QT_QML_FLUENT_PATH%
)