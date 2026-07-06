import '../services/audio_service.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class DialogueController {
  
  final ValueNotifier<String> currentText = ValueNotifier<String>('');
  final ValueNotifier<bool> isTyping = ValueNotifier<bool>(false);

  String _fullText = '';
  int _currentIndex = 0;
  Timer? _timer;
  int _pauseTicks = 0;

  final AudioService _audioService;

  DialogueController(this._audioService);

  void startDialogue(String text) {

    _timer?.cancel();
    _fullText = text;
    currentText.value = '';
    _currentIndex = 0;
    _pauseTicks = 0;
    isTyping.value = true;

    _timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (_pauseTicks > 0) {
        _pauseTicks--;
        return;
      }

      if (_currentIndex < _fullText.length) {
        String char = _fullText[_currentIndex];
        currentText.value += char;
        _currentIndex++;

        if (char == '.' || char == '?' || char == '!') {
          _pauseTicks = 8; // Pause for 8 ticks
        }

        if (char == ' ') {
          _pauseTicks = 2; // Pause for 2 ticks
        }

        if (char == ',') {
          _pauseTicks = 4; // Pause for 4 ticks
        }

        if (char != ' ') {
          _audioService.reproducirBlip();
        }

      } else {
        finishDialogue();
      }
    });
  }

  void skipDialogue() {
    if (!isTyping.value) return;

    _timer?.cancel();
    currentText.value = _fullText;
    finishDialogue();
  }

  void finishDialogue() {
    _timer?.cancel();
    isTyping.value = false;
  }

  void dispose() {
    _timer?.cancel();
    currentText.dispose();
    _audioService.desechar();
    isTyping.dispose();
  }

  

}