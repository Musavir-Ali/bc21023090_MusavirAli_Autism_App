// import 'package:autism_app/helpers/auth_helper.dart';
// import 'package:autism_app/models/homescreen_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';


// import '../utils/constants.dart';

// class HomeScreenController extends GetxController {
//   List<HomeScreenModel> listOfScreens = [];
//   HomeScreenModel currentScreen =userScreensList.first;

//   void changeIndex(int i) {
//     currentScreen = listOfScreens[i];
//     update(['main']);
//   }

//   @override
//   void onInit() {
//     setListOfScreens();
//     super.onInit();
//   }
//   setListOfScreens(){
//         listOfScreens = userScreensList;
//    }
//   }
import 'package:autism_app/helpers/auth_helper.dart';
import 'package:autism_app/models/homescreen_model.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  List<HomeScreenModel> listOfScreens = [];
  HomeScreenModel currentScreen = userScreensList.first;

  void changeIndex(int i) {
    currentScreen = listOfScreens[i];
    update(['main']);
  }

  @override
  void onInit() {
    setListOfScreens(AuthHelper.accountController.userRole);
    super.onInit();
  }

  void setListOfScreens(String role) {
    if (role == 'Admin') {
      listOfScreens = adminScreensList;
    } else if (role == 'Professional') {
      listOfScreens = professionalScreensList;
    } else {
      listOfScreens = userScreensList;
    }
    currentScreen = listOfScreens.first;
    update(['main']); // Update the UI with the selected screen list
  }
}
