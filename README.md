# 👾 Retro Dialog Engine para Flutter

Un sistema de diálogo estilo máquina de escribir optimizado para Flutter, inspirado en los cuadros de texto de los RPG clásicos y juegos como *Animal Crossing* o *Splatoon*. 

Este proyecto es un **Vertical Slice** que demuestra cómo manejar estados reactivos, temporizadores asíncronos y audio de ultra-baja latencia sin comprometer el rendimiento a 60 FPS.

## ✨ Características Principales

* **Efecto Máquina de Escribir:** Aparición secuencial de caracteres controlada por un temporizador asíncrono.
* **Ritmo Orgánico:** Sistema de pausas dinámicas integradas. El motor detecta la puntuación (comas, puntos, signos de interrogación) y añade micro-pausas automáticas para darle "respiración" e intención al texto.
* **Audio de Ultra-Baja Latencia:** Integración con `soundpool` para disparar efectos de sonido ("blips" vocales) por cada letra impresa sin retrasos ni sobrecarga de memoria.
* **Interacción del Jugador:** Permite saltar la animación para mostrar el texto completo de golpe si el usuario toca la pantalla durante la escritura.
* **UI Reactiva y Ligera:** Uso de `ValueNotifier` y `ValueListenableBuilder` para actualizar exclusivamente el widget de texto, evitando reconstruir toda la pantalla.

## 🏗️ Arquitectura y Estructura

El código sigue principios de inyección de dependencias para mantener la interfaz de usuario (UI) completamente separada de la lógica de negocio y los servicios nativos.

* `AudioService`: Encargado de cargar el archivo `.wav` crudo (`ByteData`) directamente en la memoria RAM y gestionar su liberación (`dispose`).
* `DialogueController`: El cerebro del sistema. Maneja el estado del texto, el `Timer.periodic`, el cálculo de pausas y le indica al servicio de audio cuándo disparar.
* `UI (PantallaDialogo)`: Capa de presentación "tonta". Solo se encarga de dibujar el contenedor retro y escuchar los cambios de estado emitidos por el controlador a través de los notificadores.

## 🚀 Instalación y Uso

1.  Clona este repositorio:
    ```bash
    git clone [https://github.com/tu-usuario/tu-repo.git](https://github.com/tu-usuario/tu-repo.git)
    ```
2.  Instala las dependencias:
    ```bash
    flutter pub get
    ```
3.  Asegúrate de tener un archivo de audio corto en `assets/blip.wav` y de haberlo declarado en tu archivo `pubspec.yaml`:
    ```yaml
    assets:
      - assets/blip.wav
    ```
4.  Ejecuta el proyecto:
    ```bash
    flutter run
    ```
    *(Nota: Si deseas probarlo rápidamente sin instalarlo en un dispositivo físico, puedes compilarlo para web usando `flutter run -d chrome`).*

## 🛠️ Dependencias

* [Flutter SDK](https://flutter.dev/)
* [soundpool](https://pub.dev/packages/soundpool) - Para la gestión del motor de audio en C/C++ y la reproducción instantánea en RAM.

---
*Diseñado con enfoque en rendimiento, manejo de memoria seguro y experiencia de usuario fluida.*