# Trinity Gym

Aplicacion movil Flutter para Android enfocada en entrenamiento de gimnasio
casero.

## Funciones

- Catalogo local de ejercicios para peso corporal, bandas, mancuernas,
  kettlebell, barra, silla/banco, mochila, cuerda, toalla y sliders.
- Filtros por tipo de ejercicio, musculo/zona corporal, equipo disponible,
  nivel y busqueda de texto.
- Generador de plan por objetivo: fuerza, hipertrofia, resistencia, perdida de
  grasa o movilidad.
- Prescripcion por ejercicio con series, repeticiones o tiempo, descanso, tempo
  y notas tecnicas.
- Imagenes y videos offline incluidos como assets.
- Reproduccion online opcional cuando existe una fuente publica.

## Version

Version actual: `1.0.0+1`

La version se mantiene en:

- `pubspec.yaml`
- `lib/core/constants/app_constants.dart`
- `lib/core/config/update_config.dart`

## Desarrollo

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d <device>
```

Si el emulador no tiene espacio para una build debug, se puede probar con:

```bash
flutter run --profile -d <device>
```

## Release

```bash
flutter build apk --release
```

El APK se genera en:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Para publicar nuevas versiones, seguir `RELEASE_GUIDE.md`.
