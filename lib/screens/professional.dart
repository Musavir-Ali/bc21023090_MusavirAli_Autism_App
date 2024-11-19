import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfessionalScreen extends StatefulWidget {
  const ProfessionalScreen({super.key});

  @override
  _ProfessionalScreenState createState() => _ProfessionalScreenState();
}

class _ProfessionalScreenState extends State<ProfessionalScreen> {
  String? currentRole;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserRole();
  }

  Future<void> fetchCurrentUserRole() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      setState(() {
        currentRole = userDoc['role'];
      });
    } catch (e) {
      print("Error fetching current user role: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchProfessionals() async {
    try {
      QuerySnapshot profilesSnapshot = await FirebaseFirestore.instance
          .collection('basic_profiles') 
          .where('role', isEqualTo: 'Professional')
          .get();

      return profilesSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print("Error fetching profiles: $e");
      return [];
    }
  }

  Future<void> deleteProfessional(String userId) async {
    try {
      // Delete user from the 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Optionally delete the user's profile from the 'basic_profiles' collection
      await FirebaseFirestore.instance.collection('basic_profiles').doc(userId).delete();

      print("Professional with ID $userId deleted successfully.");
      setState(() {}); // Refresh the UI
    } catch (e) {
      print("Error deleting professional: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProfessionals(),
        builder: (context, professionalsSnapshot) {
          if (professionalsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (professionalsSnapshot.hasError) {
            return Center(child: Text("Error: ${professionalsSnapshot.error}"));
          } else if (professionalsSnapshot.hasData &&
              professionalsSnapshot.data!.isEmpty) {
            return const Center(child: Text("No users with role 'Professional' found."));
          } else if (professionalsSnapshot.hasData) {
            List<Map<String, dynamic>> professionals = professionalsSnapshot.data!;
            return ListView.builder(
              itemCount: professionals.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> professional = professionals[index];
                String email = professional['name'] ?? 'No name';
                String userId = professional['id'];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        'P',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(email),
                    trailing: currentRole == 'Admin'
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: const Text(
                                      "Are you sure you want to delete this professional?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await deleteProfessional(userId);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Professional deleted successfully."),
                                          ),
                                        );
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : null,
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("An unexpected error occurred."));
          }
        },
      ),
    );
  }
}
