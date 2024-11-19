import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
          .collection('users') // Assuming current user's role is in 'users' collection
          .doc(currentUser.uid)
          .get();

      setState(() {
        currentRole = userDoc['role']; // Fetch role of current user
      });
    } catch (e) {
      print("Error fetching current user role: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchProfiles() async {
    try {
      QuerySnapshot profilesSnapshot = await FirebaseFirestore.instance
          .collection('profiles') // Fetch from profiles collection
          .get();

      return profilesSnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      print("Error fetching profiles: $e");
      return [];
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('profiles').doc(userId).delete();
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      print("User with ID $userId deleted successfully.");
      setState(() {}); 
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchProfiles(),
        builder: (context, profilesSnapshot) {
          if (profilesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (profilesSnapshot.hasError) {
            return Center(child: Text("Error: ${profilesSnapshot.error}"));
          } else if (profilesSnapshot.hasData && profilesSnapshot.data!.isEmpty) {
            return const Center(child: Text("No profiles found."));
          } else if (profilesSnapshot.hasData) {
            List<Map<String, dynamic>> profiles = profilesSnapshot.data!;
            return ListView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> profile = profiles[index];
                String name = profile['name'] ?? 'Unknown'; // Display name from profile
                String userId = profile['id']; // Get user ID from profile

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        name[0].toUpperCase(), // Use first letter of the name
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(name), // Display name
                    trailing: currentRole == 'Admin'
                        ? IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Confirm Deletion"),
                                  content: const Text(
                                      "Are you sure you want to delete this user?"),
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
                                        await deleteUser(userId);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text("User deleted successfully."),
                                          ),
                                        );
                                      },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : null, // Show delete icon only for Admin
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
