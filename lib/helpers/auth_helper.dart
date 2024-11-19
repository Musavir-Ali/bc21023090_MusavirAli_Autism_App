import 'package:autism_app/controllers/account_controller.dart';
import 'package:autism_app/controllers/homescreen_controller.dart';
import 'package:autism_app/screens/Basic_profile.dart';
import 'package:autism_app/screens/profile_create.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import '../homescreen.dart';

class AuthHelper {
  static AccountController accountController = AccountController();
  static Future<void> signUp(String email, String password, String role) async {
    print("Email: $email, Password: $password, Role: $role");

    try {
      Get.lazyPut(() => HomeScreenController());
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("User signed up successfully: ${userCredential.user?.email}");
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({'email': email, 'role': role});
      Get.back();
    } on FirebaseAuthException catch (e) {
      log("Error during sign up: ${e.message}");
      Get.snackbar("Sign Up Error", e.message ?? "An unknown error occurred.");
    }
  }

  static Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("User logged in successfully: ${userCredential.user?.email}");
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();

      if (userDoc.exists) {
        HomeScreenController homeScreenController = Get.find();
        String role = userDoc['role'];
        accountController.userRole = role;
        homeScreenController.setListOfScreens(role);

        await redirectBasedOnRole(role, userCredential.user!.uid);
      } else {
        log("Error: No role found for the user.");
        Get.snackbar("Error", "No role found for the user.");
      }
    } on FirebaseAuthException catch (e) {
      log("Error during login: ${e.message}");
      Get.snackbar("Login Error", e.message ?? "An unknown error occurred.");
    }
  }

static Future<void> redirectBasedOnRole(String role, String userId) async {
  try {
    DocumentSnapshot profileSnapshot;

    // Use `basic_profiles` for Admin and Professional, `profiles` for User
    if (role == 'Admin' || role == 'Professional') {
      profileSnapshot = await FirebaseFirestore.instance
          .collection('basic_profiles')
          .doc(userId)
          .get();
    } else if (role == 'User') {
      profileSnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .get();
    } else {
      Get.snackbar("Error", "Invalid role. Cannot redirect.");
      return;
    }

    // Redirect based on profile existence and role
    if (profileSnapshot.exists) {
      Get.offAll(() => HomeScreen());
    } else {
      if (role == 'User') {
        Get.offAll(() => const ProfileCreationScreen());
      } else {
        Get.offAll(() => const BasicProfileScreen());
      }
    }
  } catch (e) {
    log("Error during redirection: $e");
    Get.snackbar("Redirection Error", "An error occurred while redirecting.");
  }
}
}
