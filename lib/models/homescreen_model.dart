import 'package:autism_app/screens/Add_Recomendation.dart';
import 'package:autism_app/screens/dashboard.dart';
import 'package:autism_app/screens/donate.dart';
import 'package:autism_app/screens/exercise.dart';
import 'package:autism_app/screens/professionals.dart';
import 'package:autism_app/screens/profile.dart';
import 'package:autism_app/screens/reports.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../screens/Users.dart';
import '../screens/professional.dart';



class HomeScreenModel {
  int index;
  VoidCallback? onPressed;
  String title;
  List<Widget> actions; // List to hold action widgets for each screen
  Widget screenWidget;
  HomeScreenModel(this.index, this.title, this.screenWidget,
      {this.actions =
          const []}); // Include actions parameter in the constructor
}

List<HomeScreenModel> professionalScreensList = [
  HomeScreenModel(0, 'All Users', const UsersScreen()),
  HomeScreenModel(1, 'Add Recommendation', AddRecommendation()),
  HomeScreenModel(
    2,
    'User Analysis',
    ProfessionalsScreen()
  ),
  HomeScreenModel(3, 'Team', ProfileScreen()), 
];
List<HomeScreenModel> adminScreensList = [
  HomeScreenModel(0, 'All Users', const UsersScreen()),
  HomeScreenModel(1, 'All Proffesionals ', const ProfessionalScreen()),
  HomeScreenModel(2, 'Donate Ammount', const Donate()),
  HomeScreenModel(3, 'Profile', ProfileScreen()),
];
List<HomeScreenModel> userScreensList = [
  HomeScreenModel(0, 'Dashboard', const Dashboard()),
  HomeScreenModel(1, 'Recommendations ', const Reports()),
  HomeScreenModel(2, 'Interactive Exercises', const ExercisesScreen()),
  HomeScreenModel(3, 'Profile', ProfileScreen()),
];

