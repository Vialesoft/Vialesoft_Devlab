@echo off
setlocal

set "AVD_NAME=Medium_Phone_API_37.0"
set "EMULATOR_EXE="

if defined ANDROID_SDK_ROOT if exist "%ANDROID_SDK_ROOT%\emulator\emulator.exe" set "EMULATOR_EXE=%ANDROID_SDK_ROOT%\emulator\emulator.exe"
if not defined EMULATOR_EXE if defined ANDROID_HOME if exist "%ANDROID_HOME%\emulator\emulator.exe" set "EMULATOR_EXE=%ANDROID_HOME%\emulator\emulator.exe"
if not defined EMULATOR_EXE set "EMULATOR_EXE=%LOCALAPPDATA%\Android\Sdk\emulator\emulator.exe"

if not exist "%EMULATOR_EXE%" (
    echo No se encontro emulator.exe en:
    echo %EMULATOR_EXE%
    pause
    exit /b 1
)

start "" "%EMULATOR_EXE%" -avd "%AVD_NAME%"