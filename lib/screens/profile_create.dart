import 'dart:io';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:autism_app/components/common_button.dart';
import 'package:autism_app/helpers/homescreen_helper.dart';
import 'package:autism_app/homescreen.dart';
import 'package:autism_app/models/homescreen_model.dart';
import 'package:autism_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileCreationScreen extends StatefulWidget {
  const ProfileCreationScreen({super.key});

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _historyController = TextEditingController();
  final TextEditingController _lifestyleController = TextEditingController();
  String? _selectedGender;
  XFile? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  }


  bool _validateFields() {
    return _nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _selectedGender != null &&
        _heightController.text.isNotEmpty &&
        _weightController.text.isNotEmpty &&
        _historyController.text.isNotEmpty &&
        _lifestyleController.text.isNotEmpty;
  }


  Future<void> _saveProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Save the profile data to Firestore
        await FirebaseFirestore.instance.collection('profiles').doc(user.uid).set({
          'uid': user.uid,
          'name': _nameController.text,
          'age': _ageController.text,
          'gender': _selectedGender,
          'height': _heightController.text,
          'weight': _weightController.text,
          'history': _historyController.text,
          'lifestyle': _lifestyleController.text,
          // If profile image is selected, save its URL to Firestore (you can upload the image to Firebase Storage first)
          'profileImage': _profileImage != null ? File(_profileImage!.path).path : null,
        });
        print(user.displayName);
      }
    } catch (e) {
      print("Error saving profile to Firestore: $e");
      Get.snackbar("Error", "Could not save profile to Firestore. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile Creation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                    child: CircularProfileAvatar(
                      '', 
                      radius: 50,
                      borderWidth: 2,
                      borderColor: Colors.blue, 
                      initialsText: Text(
                         _nameController.text.isNotEmpty
                          ? _nameController.text.length >= 2
                              ? _nameController.text.substring(0, 2).toUpperCase() 
                              : _nameController.text.substring(0, 1).toUpperCase() 
                          : 'AA', 
                        style: const TextStyle(fontSize: 30, color: Colors.white),
                      ),
                      backgroundColor: Colors.grey[300]!,
                      cacheImage: true,
                      showInitialTextAbovePicture: true,
                      child: _profileImage != null
                      ? Image.file(File(_profileImage!.path), fit: BoxFit.cover)
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
                const SizedBox(height: 16),
                const Text('Gender'),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  hint: const Text('Select Gender'),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                  items: ['Male', 'Female', 'Other']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Height (cm)'),
                TextField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    hintText: 'Enter height in cm',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Text('Weight (kg)'),
                TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    hintText: 'Enter weight in kg',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                const Text('Medical History'),
                TextField(
                  controller: _historyController,
                  decoration: const InputDecoration(
                    hintText: 'Enter medical history',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 16),
                const Text('Lifestyle Habits'),
                TextField(
                  controller: _lifestyleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter lifestyle habits',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 32),
                CommonButton(
                  bgColor: const Color(successColor).value,
                  title: 'Continue',
                  onPressed: () async {
                    if (_validateFields()) {
                      await _saveProfile();  
                      
                      Get.offAll(() => HomeScreen());
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please fill all fields before continuing.",
                        backgroundColor: Colors.redAccent,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
