import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/utils/constants.dart';

class ProfessionalsScreen extends StatefulWidget {
  const ProfessionalsScreen({super.key});

  @override
  _ProfessionalsScreenState createState() => _ProfessionalsScreenState();
}

class _ProfessionalsScreenState extends State<ProfessionalsScreen> {
  final _formKey = GlobalKey<FormState>();

  String? selectedName;
  String? selectedUid; // To store the UID of the selected person
  String interactionLevel = 'Low';
  String behaviorPatterns = '';
  String sensoryResponse = 'Normal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  FutureBuilder(
                    future: FirebaseFirestore.instance.collection('profiles').get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('Error fetching names');
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        return DropdownButtonFormField<String>(
                          value: selectedName,
                          decoration: const InputDecoration(labelText: 'Select Person'),
                          items: data.map((doc) {
                            return DropdownMenuItem<String>(
                              value: doc['name'],
                              child: Text(doc['name']),
                              onTap: () {
                                // Store the UID of the selected profile
                                selectedUid = doc.id;
                              },
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedName = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a person';
                            }
                            return null;
                          },
                        );
                      }
                      return const Text('No data found');
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: interactionLevel,
                    decoration: const InputDecoration(labelText: 'Interaction Level'),
                    items: ['Low', 'Medium', 'High']
                        .map((level) => DropdownMenuItem(
                              value: level,
                              child: Text(level),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        interactionLevel = value!;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Behavior Patterns'),
                    maxLines: 1,
                    onChanged: (value) {
                      setState(() {
                        behaviorPatterns = value;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: sensoryResponse,
                    decoration: const InputDecoration(labelText: 'Sensory Response'),
                    items: ['Normal', 'Good', 'Bad']
                        .map((response) => DropdownMenuItem(
                              value: response,
                              child: Text(response),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        sensoryResponse = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    title: 'Save Assessment',
                    bgColor: const Color(successColor).value,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (selectedUid != null) {
                          try {
                            await FirebaseFirestore.instance.collection('assessments').add({
                              'uid': selectedUid, // Save the UID from profiles
                              'name': selectedName!,
                              'interactionLevel': interactionLevel,
                              'behaviorPatterns': behaviorPatterns,
                              'sensoryResponse': sensoryResponse,
                              'timestamp': FieldValue.serverTimestamp(),
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Assessment saved successfully!')),
                            );
                            _formKey.currentState!.reset();
                            setState(() {
                              selectedName = null;
                              selectedUid = null;
                            });
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error saving assessment: $e')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error: UID not found for the selected person.')),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
