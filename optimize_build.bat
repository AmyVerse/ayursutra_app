@echo off
echo Optimizing Flutter app for smaller APK size...

REM Remove Poppins font references from all Dart files
echo Removing custom font references to use system fonts...
powershell -Command "Get-ChildItem -Path 'lib' -Filter '*.dart' -Recurse | ForEach-Object { (Get-Content $_.FullName) -replace 'fontFamily: ''Poppins'',', '' | Set-Content $_.FullName }"

echo Font optimization complete!
echo.

REM Clean and rebuild
echo Cleaning previous builds...
flutter clean

echo Getting dependencies...
flutter pub get

echo Building optimized APK...
flutter build apk --release --target-platform android-arm64 --shrink --obfuscate --split-debug-info=build/debug-info

echo.
echo Optimization complete! Check the APK size in build/app/outputs/flutter-apk/
pause