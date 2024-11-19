import 'package:autism_app/components/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Reports extends StatelessWidget {
  const Reports({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Fetching the current user's UID
        future: Future.value(FirebaseAuth.instance.currentUser?.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user UID.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No user logged in.'));
          }

          // Current user's UID
          final currentUserUid = snapshot.data as String;

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('recommendations')
                .where('assessmentUID', isEqualTo: currentUserUid) // Filter recommendations by UID
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error fetching recommendations.'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No recommendations found.'));
              }

              final recommendations = snapshot.data!.docs;

              return ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index].data() as Map<String, dynamic>;
                  final title = recommendation['title'] ?? 'No Title';
                  final details = recommendation['details'] ?? 'No Details';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: CustomText(text: title),
                      subtitle: CustomText(text:details),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
