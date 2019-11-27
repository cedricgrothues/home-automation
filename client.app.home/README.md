# client.app.home - Fast, Robust & Secure Client

## What is client.app.home?

client.app.home is a cross-platform control center for your home-automation system. It is written in [Dart](https://dart.dev) using [Flutter](https://flutter.dev).

## Building

Android (armeabi-v7a): `flutter build apk`
Android (arm64-v8a): `flutter build apk --target=android-arm64`
iOS: `flutter build ios`

If you have a connected device or emulator you can run and deploy the app with `flutter run`

### Update translations:

```bash
flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localization.dart
flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n \
   --no-use-deferred-loading lib/localization.dart lib/l10n/intl_*.arb
```
