import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class AudioService {
  //variables de estado
  late Soundpool _pool;
  late int _soundId;

  Future<void> inicializar() async {
    _pool = Soundpool.fromOptions(
      options: const SoundpoolOptions(
        streamType: StreamType.notification,
        maxStreams: 4,
      ),
    );


    ByteData audioData = await rootBundle.load('assets/blip.wav');

    _soundId = await _pool.load(audioData);
    }
  
  void reproducirBlip() {
    _pool.play(_soundId);
  }

  void desechar() {
    _pool.release();
    _pool.dispose();
  }
}
