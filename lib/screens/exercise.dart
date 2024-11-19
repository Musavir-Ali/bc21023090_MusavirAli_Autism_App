import 'package:autism_app/controllers/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:autism_app/components/custom_text.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../components/common_button.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildExerciseTile(
              context,
              'Emotion Matching',
              'Match the emotion to the correct emoji.',
              EmotionMatchingExercise(),
            ),
            _buildExerciseTile(
              context,
              'Complete the Sentence',
              'Select the correct word to complete the sentence.',
              SentenceCompletionExercise(),
            ),
            _buildExerciseTile(
              context,
              'Word-Object Matching',
              'Match the word to the correct object or image.',
              WordObjectMatchingExercise(),
            ),
            _buildExerciseTile(
              context,
              'Read Aloud',
              'Read the paragraph aloud and get feedback on your pronunciation.',
              SpeechRecognitionExercise(),
            ),
            _buildExerciseTile(
              context,
              'Listen and Repeat',
              'Listen the paragraph for pronunciation.',
              ListeningExercise(),
            ),
            
            // CommonButton(
            //   title: 'Send Report',
            //   bgColor: Color(successColor).value,
            //   onPressed: () {
               
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTile(BuildContext context, String title, String description, Widget exerciseWidget) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: CustomText(
          text: title,
          fontSize: 2.1,
          weight: FontWeight.bold,
          //color: Color(successColor),
        ),
        subtitle: CustomText(
          text: description,
          fontSize: 1.6,
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Scaffold(
                      appBar: AppBar(
                        title: CustomText(fontSize: 2.1, weight: FontWeight.bold, text: title),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: exerciseWidget,
                      ),
                    )),
          );
        },
      ),
    );
  }
}

// 
class SpeechRecognitionExercise extends StatelessWidget {
  final SpeechRecognitionController controller = Get.put(SpeechRecognitionController());
  final TextEditingController customTextController = TextEditingController();
  final RxBool useCustomText = false.obs;

  SpeechRecognitionExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Read the following paragraph aloud:',
              fontSize: 1.6,
            ),
            const SizedBox(height: 16),
            Obx(() => useCustomText.value
                ? TextField(
                    controller: customTextController,
                    decoration: const InputDecoration(
                      labelText: "Enter your text",
                      border: OutlineInputBorder(),
                    ),
                  )
                : CustomText(
                    text: controller.paragraph,
                    fontSize: 1.8,
                    weight: FontWeight.bold,
                  )),
            const SizedBox(height: 16),
            Obx(() => CheckboxListTile(
                  title: const Text("Use custom text"),
                  value: useCustomText.value,
                  onChanged: (bool? value) {
                    useCustomText.value = value ?? false;
                  },
                )),
            const SizedBox(height: 16),
            Row(
              children: [
                Obx(() => ElevatedButton(
                      onPressed: controller.isListening.value
                          ? controller.stopListening
                          : controller.startListening,
                      child: Text(controller.isListening.value ? 'Stop Listening' : 'Start Listening'),
                    )),
                const SizedBox(width: 16),
                Obx(() => controller.isListening.value
                    ? const Icon(Icons.mic, color: Colors.red)
                    : controller.recognizedText.isNotEmpty
                        ? const Icon(Icons.done, color: Colors.green)
                        : Container()),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    controller.recognizedText.value = '';
                    controller.feedback.value = '';
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const CustomText(
              text: 'Recognized Text:',
              fontSize: 1.6,
            ),
            const SizedBox(height: 8),
            Obx(() => CustomText(text: controller.recognizedText.value, fontSize: 1.6)),
            const SizedBox(height: 16),
            const CustomText(
              text: 'Feedback:',
              fontSize: 1.6,
            ),
            const SizedBox(height: 8),
            Obx(() => Text(controller.feedback.value)),
          ],
        ),
      ),
    );
  }
}



class ListeningExercise extends StatelessWidget {
  final TextEditingController textController = TextEditingController();
  final SpeechRecognitionController controller = Get.put(SpeechRecognitionController());
  final RxBool isCustomText = false.obs;

  ListeningExercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => CheckboxListTile(
              title: const Text("Use custom text"),
              value: isCustomText.value,
              onChanged: (bool? value) {
                isCustomText.value = value ?? false;
              },
            )),
        const SizedBox(height: 16),
        Obx(() => isCustomText.value
            ? TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: "Enter your text",
                  border: OutlineInputBorder(),
                ),
              )
            : Text(
                controller.paragraph,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            String textToRead = isCustomText.value ? textController.text : controller.paragraph;
            controller.readAloud(textToRead);
          },
          child: const Text("Read"),
        ),
      ],
    );
  }
}

class EmotionMatchingExercise extends StatefulWidget {
  const EmotionMatchingExercise({super.key});

  @override
  _EmotionMatchingExerciseState createState() => _EmotionMatchingExerciseState();
}

class _EmotionMatchingExerciseState extends State<EmotionMatchingExercise> {
  String selectedEmoji = '';
  String feedback = '';

  void checkAnswer() {
    setState(() {
      if (selectedEmoji == '😊') {
        feedback = 'Correct! That’s a happy emoji!';
      } else {
        feedback = 'Try again! Select the happy emoji.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Select the emoji that represents happiness:',
          fontSize: 1.6,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildEmojiButton('😊'),
            _buildEmojiButton('😢'),
            _buildEmojiButton('😡'),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: checkAnswer,
          child: const Text('Submit'),
        ),
        const SizedBox(height: 16),
        Text(feedback),
      ],
    );
  }

  Widget _buildEmojiButton(String emoji) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmoji = emoji;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selectedEmoji == emoji ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 32)),
      ),
    );
  }
}

class SentenceCompletionExercise extends StatefulWidget {
  const SentenceCompletionExercise({super.key});

  @override
  _SentenceCompletionExerciseState createState() => _SentenceCompletionExerciseState();
}

class _SentenceCompletionExerciseState extends State<SentenceCompletionExercise> {
  String selectedWord = '';
  String feedback = '';

  void checkAnswer() {
    setState(() {
      if (selectedWord == 'happy') {
        feedback = 'Correct! I feel happy today.';
      } else {
        feedback = 'Try again! Select the correct word.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'Complete the sentence: I feel _____ today.',
          fontSize: 1.6,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildWordButton('happy'),
            _buildWordButton('sad'),
            _buildWordButton('angry'),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: checkAnswer,
          child: const Text('Submit'),
        ),
        const SizedBox(height: 16),
        Text(feedback),
      ],
    );
  }

  Widget _buildWordButton(String word) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWord = word;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selectedWord == word ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(word, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

class WordObjectMatchingExercise extends StatefulWidget {
  const WordObjectMatchingExercise({super.key});

  @override
  _WordObjectMatchingExerciseState createState() => _WordObjectMatchingExerciseState();
}

class _WordObjectMatchingExerciseState extends State<WordObjectMatchingExercise> {
  String selectedObject = '';
  String feedback = '';

  void checkAnswer() {
    setState(() {
      if (selectedObject == 'Apple') {
        feedback = 'Correct! The object is an apple.';
      } else {
        feedback = 'Try again! Select the correct object.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: 'An ______ a day keeps the doctor away.',
          fontSize: 1.6,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildObjectButton('Apple'),
            _buildObjectButton('Banana'),
            _buildObjectButton('Carrot'),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: checkAnswer,
          child: const Text('Submit'),
        ),
        const SizedBox(height: 16),
        Text(feedback),
      ],
    );
  }

  Widget _buildObjectButton(String object) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedObject = object;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: selectedObject == object ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(object, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
