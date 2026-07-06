import 'package:flutter/material.dart';
import 'services/audio_service.dart';
import 'controllers/dialogue_controller.dart';

void main() {
  runApp(const MiJuegoApp());
}

class MiJuegoApp extends StatelessWidget {
  const MiJuegoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PantallaDialogo(),
    );
  }
}

// === LA PANTALLA PRINCIPAL ===
class PantallaDialogo extends StatefulWidget {
  const PantallaDialogo({super.key});

  @override
  State<PantallaDialogo> createState() => _PantallaDialogoState();
}

class _PantallaDialogoState extends State<PantallaDialogo> {
  // Declaramos nuestras herramientas (usamos late porque las armaremos en initState)
  late AudioService _audioService;
  late DialogueController _dialogueController;
  
  // Una bandera para saber si el audio ya cargó en RAM
  bool _estaListo = false;

  @override
  void initState() {
    super.initState();
    _prepararSistema();
  }

  // 1. LA INICIALIZACIÓN
  Future<void> _prepararSistema() async {
    _audioService = AudioService();
    await _audioService.inicializar(); // Esperamos al mensajero
    
    // Inyectamos el audio al controlador
    _dialogueController = DialogueController(_audioService); 
    
    setState(() {
      _estaListo = true; // Avisamos que ya podemos dibujar la pantalla
    });

    // Arrancamos la primera frase automáticamente
    _dialogueController.startDialogue("¡hOI! Soy bleepy, el alien. Solo hablo en glorp porque soy muy tonto. Pero puedo hacer blip blip blop. Toca la pantalla para escucharme.");
  }

  // 2. LA LIMPIEZA
  @override
  void dispose() {
    _dialogueController.dispose();
    _audioService.desechar(); // Aquí destruimos la "pistola" de audio
    super.dispose();
  }

  // 3. LA INTERFAZ VISUAL
  @override
  Widget build(BuildContext context) {
    // Si aún no carga el audio, mostramos un círculo de carga
    if (!_estaListo) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black, // Fondo oscuro estilo espacio
      
      // GestureDetector nos permite detectar toques en toda la pantalla
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // Lógica de interacción del usuario
          if (_dialogueController.isTyping.value) {
            // Si está escribiendo, saltamos al final
            _dialogueController.skipDialogue();
          } else {
            // Si ya terminó, mostramos la siguiente frase de prueba
            _dialogueController.startDialogue("Mira puedo hablar como sans eee eee ee e e e eee eee eee ee ee e. 67 67 67 67 67 67 67 67 67 67 67");
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end, // Empuja todo hacia abajo
          children: [
            // Aquí podrías poner el dibujo (sprite) de tu alienígena en el futuro
            
            // LA CAJA DE DIÁLOGO
            Container(
              height: 150, // Altura fija para que la caja no salte
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 3), // Borde grueso tipo PS1/Retro
              ),
              
              // EL RECEPTOR DEL MEGÁFONO
              child: ValueListenableBuilder<String>(
                valueListenable: _dialogueController.currentText,
                builder: (context, textoVisible, child) {
                  return Text(
                    textoVisible,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Courier', // Tipografía de máquina de escribir
                      height: 1.5,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20), // Un poco de espacio al fondo
          ],
        ),
      ),
    );
  }
}