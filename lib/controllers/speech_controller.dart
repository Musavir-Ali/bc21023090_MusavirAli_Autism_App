import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechRecognitionController extends GetxController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  var isListening = false.obs;
  var recognizedText = ''.obs;
  var feedback = ''.obs;

  final String paragraph = "Reading is a window to the world It opens up new ideas and adventures";

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
  }

  void _initSpeech() async {
    bool available = await _speech.initialize();
    if (!available) {
      feedback.value = "Speech recognition is not available on this device.";
    }
  }

  void startListening() async {
    if (!isListening.value) {
      isListening.value = true;
      await _speech.listen(onResult: (result) {
        recognizedText.value = result.recognizedWords;
      });
    }
  }

  void stopListening() {
    if (isListening.value) {
      isListening.value = false;
      _speech.stop();
      evaluateReading();
    }
  }
  

void evaluateReading() {
  // Clean up whitespace and punctuation for both texts
  String cleanRecognized = recognizedText.value.trim().toLowerCase();
  String cleanParagraph = paragraph.trim().toLowerCase();

  // Check for an exact or partial match threshold (e.g., 80% of the text)
  if (cleanRecognized == cleanParagraph) {
    feedback.value = 'Great job! You read the paragraph correctly.';
  } else if (cleanRecognized.contains(cleanParagraph.substring(0, (cleanParagraph.length * 0.8).toInt()))) {
    feedback.value = 'Almost there! You got most of it correct.';
  } else {
    feedback.value = 'Keep practicing! Try to read the paragraph more accurately.';
  }
}
  void readAloud(String text) async {
    await _flutterTts.speak(text);
  }

}
