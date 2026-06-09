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

echo Running flutter pub get...
flutter pub get
if errorlevel 1 (
  echo ERRO: flutter pub get falhou.
  exit /b 1
)

echo.
echo Building release APK...
flutter build apk --release
if errorlevel 1 (
  echo ERRO: flutter build apk falhou.
  exit /b 1
)

echo.
echo APK de release gerado em:
echo   %cd%\build\app\outputs\flutter-apk\app-release.apk
echo.
echo Concluído.
endlocal
