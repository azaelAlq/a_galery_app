# Configuración de Firebase

Este repo NO incluye `lib/firebase_options.dart`, `android/app/google-services.json`
ni `ios/Runner/GoogleService-Info.plist` porque contienen el ID y la configuración
del proyecto de Firebase específico.

## Para correr este proyecto localmente:

1. Creá tu propio proyecto en https://console.firebase.google.com
2. Habilitá Authentication con los proveedores Email/Password y Google.
3. Instalá la CLI de FlutterFire si no la tenés:
   ```bash
   dart pub global activate flutterfire_cli
   ```
4. Corré, desde la raíz del proyecto:
   ```bash
   flutterfire configure
   ```
   Esto va a generar `lib/firebase_options.dart` y bajar los archivos de
   configuración nativos (`google-services.json` / `GoogleService-Info.plist`)
   automáticamente.
5. Para Google Sign-In en Android, agregá tu propio SHA-1 de debug en la
   consola de Firebase (Configuración del proyecto → tu app Android →
   Agregar huella digital). Sacalo con:
   ```bash
   cd android && ./gradlew signingReport && cd ..
   ```
