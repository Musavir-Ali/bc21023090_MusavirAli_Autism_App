import 'dart:io';
import 'package:autism_app/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BasicProfileScreen extends StatefulWidget {
  const BasicProfileScreen({super.key});

  @override
  State<BasicProfileScreen> createState() => _BasicProfileScreenState();
}

class _BasicProfileScreenState extends State<BasicProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  XFile? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  }

  Future<void> _saveBasicProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final role = userDoc['role'];
        await FirebaseFirestore.instance.collection('basic_profiles').doc(user.uid).set({
          'role': role,
          'uid': user.uid,
          'name': _nameController.text,
          'age': _ageController.text,
          'profileImage': _profileImage != null ? File(_profileImage!.path).path : null,
        });
        Get.snackbar("Success", "Profile saved successfully");
      }
    } catch (e) {
      Get.snackbar("Error", "Could not save profile. Please try again.");
    }
  }

  bool _validateFields() {
    return _nameController.text.isNotEmpty && _ageController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Basic Profile Creation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text('Add Profile Picture'),
              const SizedBox(height: 8),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null ? FileImage(File(_profileImage!.path)) : null,
                    child: _profileImage == null
                      ? Icon(Icons.add_a_photo, color: Colors.grey[700], size: 40)
                      : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Name'),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Enter name',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),
              const Text('Age'),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  hintText: 'Enter age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_validateFields()) {
                    await _saveBasicProfile();
                    Get.to(HomeScreen());
                  } else {
                    Get.snackbar("Error", "Please fill all fields before continuing.",
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
