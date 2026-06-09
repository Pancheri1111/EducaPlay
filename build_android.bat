@echo off
setlocal

REM Script para gerar o APK de release do EducaPlay no Windows
REM Execute este arquivo na raiz do projeto.

cd /d "%~dp0"

if not exist "pubspec.yaml" (
  echo ERRO: Execute este script na raiz do projeto Flutter.
  exit /b 1
)

echo ==========================================
echo Building Android release APK for EducaPlay
echo ==========================================
echo.

set "FLUTTER_CMD="
where flutter >nul 2>&1
if %ERRORLEVEL%==0 (
  set "FLUTTER_CMD=flutter"
) else (
  if defined FLUTTER_HOME if exist "%FLUTTER_HOME%\bin\flutter.bat" set "FLUTTER_CMD=%FLUTTER_HOME%\bin\flutter.bat"
  if not defined FLUTTER_CMD if defined FLUTTER_ROOT if exist "%FLUTTER_ROOT%\bin\flutter.bat" set "FLUTTER_CMD=%FLUTTER_ROOT%\bin\flutter.bat"
  if not defined FLUTTER_CMD if exist "C:\src\flutter\bin\flutter.bat" set "FLUTTER_CMD=C:\src\flutter\bin\flutter.bat"
  if not defined FLUTTER_CMD if exist "C:\flutter\bin\flutter.bat" set "FLUTTER_CMD=C:\flutter\bin\flutter.bat"
  if not defined FLUTTER_CMD if exist "%USERPROFILE%\flutter\bin\flutter.bat" set "FLUTTER_CMD=%USERPROFILE%\flutter\bin\flutter.bat"
)

if not defined FLUTTER_CMD (
  echo ERRO: Flutter não encontrado no PATH.
  echo Instale o Flutter ou adicione "C:\src\flutter\bin" ao PATH.
  echo Exemplo: setx PATH "C:\src\flutter\bin;%%PATH%%"
  exit /b 1
)

echo Usando Flutter em: %FLUTTER_CMD%

echo Running %FLUTTER_CMD% pub get...
%FLUTTER_CMD% pub get
if errorlevel 1 (
  echo ERRO: %FLUTTER_CMD% pub get falhou.
  exit /b 1
)

echo.
echo Building release APK...
%FLUTTER_CMD% build apk --release
if errorlevel 1 (
  echo ERRO: %FLUTTER_CMD% build apk falhou.
  exit /b 1
)

echo.
echo APK de release gerado em:
echo   %cd%\build\app\outputs\flutter-apk\app-release.apk
echo.
echo Concluído.
endlocal
