import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/components/view_common.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddRecommendation extends StatelessWidget {
   final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
   AddRecommendation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('assessments').orderBy('timestamp', descending: true).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No assessments found.'));
          }

          final assessments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: assessments.length,
            itemBuilder: (context, index) {
              final assessment = assessments[index].data();
              final assessmentUID = assessment['uid'];  // Assuming 'uid' is stored in the assessment document

              // Convert Firestore timestamp to formatted date
              final timestamp = assessment['timestamp'] as Timestamp?;
              final formattedDate = timestamp != null
                  ? DateFormat('dd/MM/yy').format(timestamp.toDate())
                  : 'Unknown Date';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Name: ${assessment['name']}'),
                  subtitle: Text(
                    'Interaction Level: ${assessment['interactionLevel']}\n'
                    'Behavior Patterns: ${assessment['behaviorPatterns']}\n'
                    'Sensory Response: ${assessment['sensoryResponse']}\n'
                    '\n'
                    'Date: $formattedDate',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.message_outlined),
                    onPressed: () {
                      ViewsCommon.showModalBottom(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                 controller: _titleController,
                                decoration: const InputDecoration(
                                  labelText: 'Title',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                controller: _detailsController,
                                decoration: const InputDecoration(
                                  labelText: 'Details',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CommonButton(
                                title: 'Save Recommendations',
                                bgColor: const Color(successColor).value,
                                onPressed: () {
                                  _saveRecommendation(
                                    context,
                                    _titleController.text.trim(),
                                    _detailsController.text.trim(),
                                    assessmentUID,  
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


  Future<void> _saveRecommendation(
    BuildContext context,
    String title,
    String details,
    String assessmentUID,
  ) async {
    try {

      Map<String, dynamic> recommendationData = {
        'title': title,
        'details': details,
        'assessmentUID': assessmentUID, 
        'timestamp': FieldValue.serverTimestamp(),
      };

  
      await FirebaseFirestore.instance.collection('recommendations').add(recommendationData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Recommendation saved successfully")),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving recommendation: $e")),
      );
    }
  }
}
